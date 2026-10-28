-- Generate `.gitignore` files from the templates in https://github.com/github/gitignore.
--
-- The template list comes from the GitHub trees API and is cached for a day, so the picker opens
-- instantly after the first fetch. Every `.gitignore` in the repo is offered, including the
-- `Global/` and `community/` folders (shown as a dim path hint), and templates are identified by
-- their repo-relative path, e.g. `Lua` or `Global/mise`. Selected templates are appended to the
-- target `.gitignore` under a `# --- <path> ---` header, and templates that are already present are
-- skipped, so existing rules are never destroyed.

local M = {}

local cache_version = 2
local cache_dir = vim.fs.joinpath(vim.fn.stdpath "cache", "gitignore")
local list_cache = vim.fs.joinpath(cache_dir, "templates.json")
local list_ttl = 24 * 60 * 60 -- seconds
local api_url = "https://api.github.com/repos/github/gitignore/git/trees/main?recursive=1"
local raw_url = "https://raw.githubusercontent.com/github/gitignore/main/%s.gitignore"
local header = "# --- %s ---"

local function notify(msg, level) vim.notify("gitignore: " .. msg, level or vim.log.levels.INFO) end

---@param url string
---@return string? body, string? err
local function curl(url)
  if vim.fn.executable "curl" == 0 then return nil, "curl is not installed" end
  local out = vim.system({ "curl", "-fsSL", "--max-time", "20", url }, { text = true }):wait()
  if out.code ~= 0 then
    return nil, out.stderr ~= "" and vim.trim(out.stderr) or ("curl exited with code " .. out.code)
  end
  return out.stdout
end

---@return { v: integer, time: integer, paths: string[] }?
local function read_cache()
  if vim.fn.filereadable(list_cache) == 0 then return nil end
  local ok, data = pcall(vim.json.decode, table.concat(vim.fn.readfile(list_cache), "\n"))
  if not ok or type(data) ~= "table" or data.v ~= cache_version or type(data.paths) ~= "table" then return nil end
  return data
end

---@param paths string[]
local function write_cache(paths)
  vim.fn.mkdir(cache_dir, "p")
  vim.fn.writefile({ vim.json.encode { v = cache_version, time = os.time(), paths = paths } }, list_cache)
end

--- Split a repo-relative template path into its name and folder hint.
---@param path string
---@return string name, string? dir
local function split_path(path)
  local dir, name = path:match "^(.*)/([^/]+)$"
  return name or path, dir
end

---@return string[]? paths, string? err
local function fetch_list()
  local body, err = curl(api_url)
  if not body then return nil, err end
  local ok, data = pcall(vim.json.decode, body)
  if not ok or type(data) ~= "table" or type(data.tree) ~= "table" then
    return nil, "could not parse the GitHub API response"
  end
  local paths = {}
  for _, entry in ipairs(data.tree) do
    local path = entry.path
    if type(path) == "string" and path:sub(-10) == ".gitignore" then paths[#paths + 1] = path:sub(1, -11) end
  end
  table.sort(paths, function(a, b)
    local an, ad = split_path(a)
    local bn, bd = split_path(b)
    if an:lower() ~= bn:lower() then return an:lower() < bn:lower() end
    return (ad or "") < (bd or "")
  end)
  write_cache(paths)
  return paths
end

--- Repo-relative template paths from github/gitignore, from cache when still fresh.
---@param opts? { refresh?: boolean }
---@return string[]? paths
function M.templates(opts)
  opts = opts or {}
  local cached = read_cache()
  local fresh = cached and (os.time() - (cached.time or 0)) < list_ttl
  if fresh and not opts.refresh then return cached.paths end

  local paths, err = fetch_list()
  if paths then return paths end
  if cached then
    notify(("could not refresh the template list, using the cached one (%s)"):format(err), vim.log.levels.WARN)
    return cached.paths
  end
  notify("could not fetch the template list: " .. err, vim.log.levels.ERROR)
end

---@param path string repo-relative path without the `.gitignore` suffix, e.g. `Global/mise`
---@return string? body, string? err
local function fetch_template(path)
  local encoded = path:gsub("[^%w%-%._~/]", function(c) return ("%%%02X"):format(c:byte()) end)
  local body, err = curl(raw_url:format(encoded))
  if not body then return nil, err end
  if body == "" then return nil, "empty template" end
  return body
end

--- Append the requested templates to `path`, skipping templates that are already there.
---@param names string[]
--- Append the requested templates to `path`, skipping templates that are already there.
---@param paths string[] repo-relative template paths, e.g. `{ "Lua", "Global/mise" }`
---@param path string
function M.generate(paths, path)
  path = path or vim.fs.joinpath(M.root(), ".gitignore")
  local lines = vim.fn.filereadable(path) == 1 and vim.fn.readfile(path) or {}

  local seen = {}
  for _, line in ipairs(lines) do
    local name = line:match "^# %-%-%- (.-) %-%-%-$"
    if name then seen[name] = true end
  end

  local added, skipped, failed = {}, {}, {}
  for _, name in ipairs(paths) do
    if seen[name] then
      skipped[#skipped + 1] = name
    else
      local body, err = fetch_template(name)
      if not body then
        failed[#failed + 1] = ("%s (%s)"):format(name, err)
      else
        if #lines > 0 and lines[#lines] ~= "" then lines[#lines + 1] = "" end
        lines[#lines + 1] = header:format(name)
        vim.list_extend(lines, vim.split((body:gsub("\r\n", "\n"):gsub("%s+$", "")), "\n", { plain = true }))
        added[#added + 1] = name
      end
    end
  end

  if #added > 0 then
    vim.fn.writefile(lines, path)
    M.reload(path)
    notify(("added %s to %s"):format(table.concat(added, ", "), vim.fn.fnamemodify(path, ":~:.")))
  end
  if #skipped > 0 then notify(("already present, skipped: %s"):format(table.concat(skipped, ", "))) end
  if #failed > 0 then notify(("failed to fetch: %s"):format(table.concat(failed, ", ")), vim.log.levels.ERROR) end
  if #added == 0 and #skipped == 0 and #failed == 0 then notify "nothing selected" end
end

--- Reload `path` in an already open, unmodified buffer so the append shows up.
---@param path string
function M.reload(path)
  local buf = vim.fn.bufnr(path)
  if buf == -1 or not vim.api.nvim_buf_is_loaded(buf) or vim.bo[buf].modified then return end
  vim.api.nvim_buf_call(buf, function() vim.cmd "silent edit" end)
end

--- Project root (git top level) or the current working directory.
---@return string
function M.root()
  local cwd = vim.fn.getcwd()
  return vim.fs.root(cwd, ".git") or cwd
end

---@param path string
local function on_choice(path)
  return function(picker)
    local selected = picker:selected { fallback = true }
    picker:close()
    if #selected == 0 then return end
    M.generate(vim.tbl_map(function(item) return item.path end, selected), path)
  end
end

---@param opts? { path?: string }
function M.pick(opts)
  opts = opts or {}
  local path = opts.path
  local paths = M.templates()
  if not paths then return end
  if #paths == 0 then return notify("the template list is empty", vim.log.levels.WARN) end

  local items = vim.tbl_map(function(template)
    local name, dir = split_path(template)
    return { text = template, name = name, dir = dir, path = template }
  end, paths)

  local ok, snacks = pcall(require, "snacks")
  if not (ok and snacks.picker) then
    return vim.ui.select(paths, { prompt = ".gitignore template" }, function(choice)
      if choice then M.generate({ choice }, path) end
    end)
  end

  snacks.picker.pick {
    title = ".gitignore templates",
    items = items,
    format = function(item)
      local ret = { { item.name, "Normal" } }
      if item.dir then ret[#ret + 1] = { "  " .. item.dir, "Comment" } end
      return ret
    end,
    confirm = on_choice(path),
    win = { input = { keys = { ["<c-a>"] = "select_all" } } },
  }
end

---@param opts? { path?: string }
function M.setup(opts)
  opts = opts or {}

  vim.api.nvim_create_user_command("Gitignore", function(args)
    local path = args.args ~= "" and vim.fn.fnamemodify(args.args, ":p") or opts.path
    M.pick { path = path }
  end, {
    nargs = "?",
    desc = "Append templates from github/gitignore to a .gitignore file",
    complete = function(arglead)
      local cached = read_cache()
      return vim.tbl_filter(
        function(name) return name:lower():find(arglead:lower(), 1, true) == 1 end,
        cached and cached.paths or {}
      )
    end,
  })

  vim.api.nvim_create_user_command("GitignoreUpdate", function()
    local paths = M.templates { refresh = true }
    if paths then notify(("cached %d templates from github/gitignore"):format(#paths)) end
  end, { desc = "Refresh the cached github/gitignore template list" })
end

return M
