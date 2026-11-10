#!/usr/bin/env nushell
# set-yazi-file-one - give yazi a `file(1)` implementation; Git for Windows
# ships one.

def main [] {
  ^setx YAZI_FILE_ONE 'C:\Program Files\Git\usr\bin\file.exe'
}
