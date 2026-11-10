#!/usr/bin/env nushell
# disable-ctrl-space - disable the hotkey `ctrl+space`, which switches the input
# method language.
#
# `HKU\.DEFAULT` needs elevation, `HKCU` does not.

const targets = [
  { key: 'HKU\.DEFAULT\Control Panel\Input Method\Hot Keys\00000010', elevated: true }
  { key: 'HKU\.DEFAULT\Control Panel\Input Method\Hot Keys\00000070', elevated: true }
  { key: 'HKCU\Control Panel\Input Method\Hot Keys\00000010', elevated: false }
  { key: 'HKCU\Control Panel\Input Method\Hot Keys\00000070', elevated: false }
]

const values = [
  { name: 'Key Modifiers', data: '00000000' }
  { name: 'Target IME', data: '00000000' }
  { name: 'Virtual Key', data: 'ff000000' }
]

def main [] {
  for target in $targets {
    for value in $values {
      if $target.elevated {
        ^sudo reg add $target.key /v $value.name /t REG_BINARY /d $value.data /f
      } else {
        ^reg add $target.key /v $value.name /t REG_BINARY /d $value.data /f
      }
    }
  }
}
