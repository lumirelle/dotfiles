# Dotfiles

My dotfiles (also application files), out-of-box (for me).

- Network Tools
  - [Clash Verge Rev](https://github.com/clash-verge-rev/clash-verge-rev)
- Input Methods
  - Rime
    <details>
      <summary>Supports:</summary>
      <ul>
        <li><a href="https://github.com/rime/weasel">Weasel (Rime for Windows)</a></li>
        <li><a href="https://github.com/rime/squirrel">Squirrel (Rime for macOS)</a></li>
        <li><a href="https://github.com/rime/ibus-rime">IBus Rime (Rime for Linux/IBus)</a></li>
        <li><a href="https://github.com/fcitx/fcitx5-rime">Fcitx5 Rime (Rime for Linux/Fcitx5)</a></li>
      </ul>
    </details>
    <details>
      <summary><s>Support but upstream is archived:</s></summary>
      <ul>
        <li><a href="https://github.com/fcitx/fcitx-rime">Fcitx Rime (Rime for Linux/Fcitx)</a></li>
      </ul>
    </details>
- Terminals
  - [Windows Terminal (Windows Only)](https://github.com/microsoft/terminal)
  - [Windows Terminal Preview (1.25+, Windows Only)](https://github.com/microsoft/terminal)
- Shells
  - [Nushell](https://github.com/nushell/nushell)
  - [Windows PowerShell (5.1, Windows 11 Built-in)](https://learn.microsoft.com/en-us/powershell/scripting/overview?view=powershell-5.1)
  - [Bash](https://www.gnu.org/software/bash/)
    - On Windows: Provided by Git Bash / WSL, without any configuration
    - On Unix-like System: Configured, login mode will be redirected to Nushell
- Shell Mutiplexers
  - [Herdr](https://herdr.dev/)
- Shell Prompts
  - [Starship](https://starship.rs/)
- System Configuration
  - Windows Only:
    - [dot_config/run_onchange_ui.reg.cmd.tmpl](dot_config/run_onchange_ui.reg.cmd.tmpl): Custom Windows system UI font solution
    - [dot_config/run_onchange_disable_ctrl_space.reg.cmd](dot_config/run_onchange_disable_ctrl_space.reg.cmd): Disable hotkey `ctrl+space` to switch input method language
    - [dot_config/run_once_LongPathEnabled.cmd](dot_config/run_once_LongPathEnabled.cmd): Enable Windows long path support
- System Components
  - [Windows Subsystem for Linux (WSL, Windows Only)](https://github.com/microsoft/WSL)
  - [WinLibs: GCC + MinGW-w64 compiler for Windows (Windows Only)](https://winlibs.com/)
- Version Control Systems
  - [Git](https://git-scm.com/)
  - [Jujutsu](https://github.com/jj-vcs/jj)
- System Managers
  - [Chezmoi](https://www.chezmoi.io/)
  - [Mise](https://mise.jdx.dev/)
- Password Managers
  - [Fnox](https://fnox.jdx.dev/)
- Editors
  - [Neovim](https://neovim.io/)
  - [Zed](https://zed.dev/)
  - [VSCode](https://code.visualstudio.com/)
- Editor Addon: Linters
  - [CSpell](https://cspell.org/)
- Harness (for AI model, Harness + AI model = Agent)
  - [Pi Coding Agent](https://pi.dev/) & it's extensions:
    - [@gotgenes/pi-permission-system](https://pi.dev/packages/@gotgenes/pi-permission-system)
    - [@juicesharp/rpiv-web-tools](https://pi.dev/packages/@juicesharp/rpiv-web-tools)
- Misc CLI Tools
  - [Yazi](https://yazi-rs.github.io/)
