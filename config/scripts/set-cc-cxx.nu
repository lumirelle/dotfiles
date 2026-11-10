#!/usr/bin/env nushell
# set-cc-cxx - point CC/CXX at the MinGW gcc/g++ installed by WinLibs.

def main [] {
  ^setx CC gcc
  ^setx CXX g++
}
