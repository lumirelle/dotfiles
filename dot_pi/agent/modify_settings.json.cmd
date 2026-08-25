@echo off
REM chezmoi modify_ script for ~/.pi/agent/settings.json (Windows).
REM Manages ONLY hideThinkingBlock. Preserves every other key, including
REM auto-managed ones Pi writes itself (lastChangelogVersion, trackingId).
REM Idempotent: when the value is already correct, input is returned unchanged.
REM Uses PowerShell (built into Windows) -- no python, no jq.
powershell -NoProfile -ExecutionPolicy Bypass -Command "$v=$true; $vs='true'; $raw=[Console]::In.ReadToEnd(); if([string]::IsNullOrWhiteSpace($raw)){[Console]::Out.Write('{'+[char]10+'  '+[char]34+'hideThinkingBlock'+[char]34+': '+$vs+[char]10+'}'+[char]10);exit}; $repl='${1}'+$vs; if($raw -match '\x22hideThinkingBlock\x22\s*:'){[Console]::Out.Write(($raw -replace '(\x22hideThinkingBlock\x22\s*:\s*)(true|false)',$repl));exit}; $j=ConvertFrom-Json -InputObject $raw; Add-Member -InputObject $j -NotePropertyName hideThinkingBlock -NotePropertyValue $v -Force; [Console]::Out.Write((ConvertTo-Json -InputObject $j -Depth 100))"
