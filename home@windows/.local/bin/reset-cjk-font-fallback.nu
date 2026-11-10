#!/usr/bin/env nushell
# reset-cjk-font-fallback - restore the built-in Windows font links for the legacy
# "Segoe UI*" values and the "Segoe UI Variable *" values.
#
# Undoes set-cjk-font-fallback.nu. Run this by hand when the custom UI font breaks
# the system.

const registry_key = 'HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontLink\SystemLink'

# Each entry is the REG_MULTI_SZ data written to the font-link value of the same name.
const font_links = [
  {
    name: 'Segoe UI'
    data: 'TAHOMA.TTF,Tahoma|MEIRYO.TTC,Meiryo UI,128,96|MEIRYO.TTC,Meiryo UI|MSGOTHIC.TTC,MS UI Gothic|MSJH.TTC,Microsoft JhengHei UI,128,96|MSJH.TTC,Microsoft JhengHei UI|MSYH.TTC,Microsoft YaHei UI,128,96|MSYH.TTC,Microsoft YaHei UI|MALGUN.TTF,Malgun Gothic,128,96|MALGUN.TTF,Malgun Gothic|MINGLIU.TTC,PMingLiU|SIMSUN.TTC,SimSun|GULIM.TTC,Gulim|YUGOTHM.TTC,Yu Gothic UI,128,96|YUGOTHM.TTC,Yu Gothic UI|SEGUISYM.TTF,Segoe UI Symbol'
  }
  {
    name: 'Segoe UI Light'
    data: 'MEIRYO.TTC,Meiryo UI,128,96|MEIRYO.TTC,Meiryo UI|MSJHL.TTC,Microsoft JhengHei UI Light,128,96|MSJHL.TTC,Microsoft JhengHei UI Light|MSYHL.TTC,Microsoft YaHei UI Light,128,96|MSYHL.TTC,Microsoft YaHei UI Light|MALGUNSL.TTF,Malgun Gothic Semilight,128,96|MALGUNSL.TTF,Malgun Gothic Semilight|YUGOTHL.TTC,Yu Gothic UI Light,128,96|YUGOTHL.TTC,Yu Gothic UI Light|SEGUISYM.TTF,Segoe UI Symbol'
  }
  {
    name: 'Segoe UI Bold'
    data: 'MEIRYOB.TTC,Meiryo UI Bold,128,96|MEIRYOB.TTC,Meiryo UI Bold|MSJHBD.TTC,Microsoft JhengHei UI Bold,128,96|MSJHBD.TTC,Microsoft JhengHei UI Bold|MSYHBD.TTC,Microsoft YaHei UI Bold,128,96|MSYHBD.TTC,Microsoft YaHei UI Bold|MALGUNBD.TTF,Malgun Gothic Bold,128,96|MALGUNBD.TTF,Malgun Gothic Bold|YUGOTHB.TTC,Yu Gothic UI Bold,128,96|YUGOTHB.TTC,Yu Gothic UI Bold|SEGUISYM.TTF,Segoe UI Symbol'
  }
  {
    name: 'Segoe UI Semilight'
    data: 'MEIRYO.TTC,Meiryo UI,128,96|MEIRYO.TTC,Meiryo UI|MSJH.TTC,Microsoft JhengHei UI,128,96|MSJH.TTC,Microsoft JhengHei UI|MSYH.TTC,Microsoft YaHei UI,128,96|MSYH.TTC,Microsoft YaHei UI|MALGUNSL.TTF,Malgun Gothic Semilight,128,96|MALGUNSL.TTF,Malgun Gothic Semilight|YUGOTHR.TTC,Yu Gothic UI Semilight,128,96|YUGOTHR.TTC,Yu Gothic UI Semilight|SEGUISYM.TTF,Segoe UI Symbol'
  }
  {
    name: 'Segoe UI Semibold'
    data: 'MEIRYO.TTC,Meiryo UI,128,96|MEIRYO.TTC,Meiryo UI|MSJH.TTC,Microsoft Jhenghei UI,128,96|MSJH.TTC,Microsoft Jhenghei UI|MSYH.TTC,Microsoft Yahei UI,128,96|MSYH.TTC,Microsoft Yahei UI|MALGUN.TTF,Malgun Gothic,128,96|MALGUN.TTF,Malgun Gothic|YUGOTHB.TTC,Yu Gothic UI Semibold,128,96|YUGOTHB.TTC,Yu Gothic UI Semibold|SEGUISYM.TTF,Segoe UI Symbol'
  }
  {
    name: 'Segoe UI Variable Small'
    data: 'TAHOMA.TTF,Tahoma|MEIRYO.TTC,Meiryo UI,128,96|MEIRYO.TTC,Meiryo UI|MSGOTHIC.TTC,MS UI Gothic|MSJH.TTC,Microsoft JhengHei UI,128,96|MSJH.TTC,Microsoft JhengHei UI|MSYH.TTC,Microsoft YaHei UI,128,96|MSYH.TTC,Microsoft YaHei UI|MALGUN.TTF,Malgun Gothic,128,96|MALGUN.TTF,Malgun Gothic|MINGLIU.TTC,PMingLiU|SIMSUN.TTC,SimSun|GULIM.TTC,Gulim|YUGOTHM.TTC,Yu Gothic UI,128,96|YUGOTHM.TTC,Yu Gothic UI|SEGUISYM.TTF,Segoe UI Symbol'
  }
  {
    name: 'Segoe UI Variable Small Bold'
    data: 'MEIRYOB.TTC,Meiryo UI Bold,128,96|MEIRYOB.TTC,Meiryo UI Bold|MSJHBD.TTC,Microsoft JhengHei UI Bold,128,96|MSJHBD.TTC,Microsoft JhengHei UI Bold|MSYHBD.TTC,Microsoft YaHei UI Bold,128,96|MSYHBD.TTC,Microsoft YaHei UI Bold|MALGUNBD.TTF,Malgun Gothic Bold,128,96|MALGUNBD.TTF,Malgun Gothic Bold|YUGOTHB.TTC,Yu Gothic UI Bold,128,96|YUGOTHB.TTC,Yu Gothic UI Bold|SEGUISYM.TTF,Segoe UI Symbol'
  }
  {
    name: 'Segoe UI Variable Small Light'
    data: 'MEIRYO.TTC,Meiryo UI,128,96|MEIRYO.TTC,Meiryo UI|MSJHL.TTC,Microsoft JhengHei UI Light,128,96|MSJHL.TTC,Microsoft JhengHei UI Light|MSYHL.TTC,Microsoft YaHei UI Light,128,96|MSYHL.TTC,Microsoft YaHei UI Light|MALGUNSL.TTF,Malgun Gothic Semilight,128,96|MALGUNSL.TTF,Malgun Gothic Semilight|YUGOTHL.TTC,Yu Gothic UI Light,128,96|YUGOTHL.TTC,Yu Gothic UI Light|SEGUISYM.TTF,Segoe UI Symbol'
  }
  {
    name: 'Segoe UI Variable Small Semilig'
    data: 'MEIRYO.TTC,Meiryo UI,128,96|MEIRYO.TTC,Meiryo UI|MSJH.TTC,Microsoft JhengHei UI,128,96|MSJH.TTC,Microsoft JhengHei UI|MSYH.TTC,Microsoft YaHei UI,128,96|MSYH.TTC,Microsoft YaHei UI|MALGUNSL.TTF,Malgun Gothic Semilight,128,96|MALGUNSL.TTF,Malgun Gothic Semilight|YUGOTHR.TTC,Yu Gothic UI Semilight,128,96|YUGOTHR.TTC,Yu Gothic UI Semilight|SEGUISYM.TTF,Segoe UI Symbol'
  }
  {
    name: 'Segoe UI Variable Small Semibol'
    data: 'MEIRYO.TTC,Meiryo UI,128,96|MEIRYO.TTC,Meiryo UI|MSJH.TTC,Microsoft Jhenghei UI,128,96|MSJH.TTC,Microsoft Jhenghei UI|MSYH.TTC,Microsoft Yahei UI,128,96|MSYH.TTC,Microsoft Yahei UI|MALGUN.TTF,Malgun Gothic,128,96|MALGUN.TTF,Malgun Gothic|YUGOTHB.TTC,Yu Gothic UI Semibold,128,96|YUGOTHB.TTC,Yu Gothic UI Semibold|SEGUISYM.TTF,Segoe UI Symbol'
  }
  {
    name: 'Segoe UI Variable Text'
    data: 'TAHOMA.TTF,Tahoma|MEIRYO.TTC,Meiryo UI,128,96|MEIRYO.TTC,Meiryo UI|MSGOTHIC.TTC,MS UI Gothic|MSJH.TTC,Microsoft JhengHei UI,128,96|MSJH.TTC,Microsoft JhengHei UI|MSYH.TTC,Microsoft YaHei UI,128,96|MSYH.TTC,Microsoft YaHei UI|MALGUN.TTF,Malgun Gothic,128,96|MALGUN.TTF,Malgun Gothic|MINGLIU.TTC,PMingLiU|SIMSUN.TTC,SimSun|GULIM.TTC,Gulim|YUGOTHM.TTC,Yu Gothic UI,128,96|YUGOTHM.TTC,Yu Gothic UI|SEGUISYM.TTF,Segoe UI Symbol'
  }
  {
    name: 'Segoe UI Variable Text Bold'
    data: 'MEIRYOB.TTC,Meiryo UI Bold,128,96|MEIRYOB.TTC,Meiryo UI Bold|MSJHBD.TTC,Microsoft JhengHei UI Bold,128,96|MSJHBD.TTC,Microsoft JhengHei UI Bold|MSYHBD.TTC,Microsoft YaHei UI Bold,128,96|MSYHBD.TTC,Microsoft YaHei UI Bold|MALGUNBD.TTF,Malgun Gothic Bold,128,96|MALGUNBD.TTF,Malgun Gothic Bold|YUGOTHB.TTC,Yu Gothic UI Bold,128,96|YUGOTHB.TTC,Yu Gothic UI Bold|SEGUISYM.TTF,Segoe UI Symbol'
  }
  {
    name: 'Segoe UI Variable Text Light'
    data: 'MEIRYO.TTC,Meiryo UI,128,96|MEIRYO.TTC,Meiryo UI|MSJHL.TTC,Microsoft JhengHei UI Light,128,96|MSJHL.TTC,Microsoft JhengHei UI Light|MSYHL.TTC,Microsoft YaHei UI Light,128,96|MSYHL.TTC,Microsoft YaHei UI Light|MALGUNSL.TTF,Malgun Gothic Semilight,128,96|MALGUNSL.TTF,Malgun Gothic Semilight|YUGOTHL.TTC,Yu Gothic UI Light,128,96|YUGOTHL.TTC,Yu Gothic UI Light|SEGUISYM.TTF,Segoe UI Symbol'
  }
  {
    name: 'Segoe UI Variable Text Semiligh'
    data: 'MEIRYO.TTC,Meiryo UI,128,96|MEIRYO.TTC,Meiryo UI|MSJH.TTC,Microsoft JhengHei UI,128,96|MSJH.TTC,Microsoft JhengHei UI|MSYH.TTC,Microsoft YaHei UI,128,96|MSYH.TTC,Microsoft YaHei UI|MALGUNSL.TTF,Malgun Gothic Semilight,128,96|MALGUNSL.TTF,Malgun Gothic Semilight|YUGOTHR.TTC,Yu Gothic UI Semilight,128,96|YUGOTHR.TTC,Yu Gothic UI Semilight|SEGUISYM.TTF,Segoe UI Symbol'
  }
  {
    name: 'Segoe UI Variable Text Semibold'
    data: 'MEIRYO.TTC,Meiryo UI,128,96|MEIRYO.TTC,Meiryo UI|MSJH.TTC,Microsoft Jhenghei UI,128,96|MSJH.TTC,Microsoft Jhenghei UI|MSYH.TTC,Microsoft Yahei UI,128,96|MSYH.TTC,Microsoft Yahei UI|MALGUN.TTF,Malgun Gothic,128,96|MALGUN.TTF,Malgun Gothic|YUGOTHB.TTC,Yu Gothic UI Semibold,128,96|YUGOTHB.TTC,Yu Gothic UI Semibold|SEGUISYM.TTF,Segoe UI Symbol'
  }
  {
    name: 'Segoe UI Variable Display'
    data: 'TAHOMA.TTF,Tahoma|MEIRYO.TTC,Meiryo UI,128,96|MEIRYO.TTC,Meiryo UI|MSGOTHIC.TTC,MS UI Gothic|MSJH.TTC,Microsoft JhengHei UI,128,96|MSJH.TTC,Microsoft JhengHei UI|MSYH.TTC,Microsoft YaHei UI,128,96|MSYH.TTC,Microsoft YaHei UI|MALGUN.TTF,Malgun Gothic,128,96|MALGUN.TTF,Malgun Gothic|MINGLIU.TTC,PMingLiU|SIMSUN.TTC,SimSun|GULIM.TTC,Gulim|YUGOTHM.TTC,Yu Gothic UI,128,96|YUGOTHM.TTC,Yu Gothic UI|SEGUISYM.TTF,Segoe UI Symbol'
  }
  {
    name: 'Segoe UI Variable Display Bold'
    data: 'MEIRYOB.TTC,Meiryo UI Bold,128,96|MEIRYOB.TTC,Meiryo UI Bold|MSJHBD.TTC,Microsoft JhengHei UI Bold,128,96|MSJHBD.TTC,Microsoft JhengHei UI Bold|MSYHBD.TTC,Microsoft YaHei UI Bold,128,96|MSYHBD.TTC,Microsoft YaHei UI Bold|MALGUNBD.TTF,Malgun Gothic Bold,128,96|MALGUNBD.TTF,Malgun Gothic Bold|YUGOTHB.TTC,Yu Gothic UI Bold,128,96|YUGOTHB.TTC,Yu Gothic UI Bold|SEGUISYM.TTF,Segoe UI Symbol'
  }
  {
    name: 'Segoe UI Variable Display Light'
    data: 'MEIRYO.TTC,Meiryo UI,128,96|MEIRYO.TTC,Meiryo UI|MSJHL.TTC,Microsoft JhengHei UI Light,128,96|MSJHL.TTC,Microsoft JhengHei UI Light|MSYHL.TTC,Microsoft YaHei UI Light,128,96|MSYHL.TTC,Microsoft YaHei UI Light|MALGUNSL.TTF,Malgun Gothic Semilight,128,96|MALGUNSL.TTF,Malgun Gothic Semilight|YUGOTHL.TTC,Yu Gothic UI Light,128,96|YUGOTHL.TTC,Yu Gothic UI Light|SEGUISYM.TTF,Segoe UI Symbol'
  }
  {
    name: 'Segoe UI Variable Display Semil'
    data: 'MEIRYO.TTC,Meiryo UI,128,96|MEIRYO.TTC,Meiryo UI|MSJH.TTC,Microsoft JhengHei UI,128,96|MSJH.TTC,Microsoft JhengHei UI|MSYH.TTC,Microsoft YaHei UI,128,96|MSYH.TTC,Microsoft YaHei UI|MALGUNSL.TTF,Malgun Gothic Semilight,128,96|MALGUNSL.TTF,Malgun Gothic Semilight|YUGOTHR.TTC,Yu Gothic UI Semilight,128,96|YUGOTHR.TTC,Yu Gothic UI Semilight|SEGUISYM.TTF,Segoe UI Symbol'
  }
  {
    name: 'Segoe UI Variable Display Semib'
    data: 'MEIRYO.TTC,Meiryo UI,128,96|MEIRYO.TTC,Meiryo UI|MSJH.TTC,Microsoft Jhenghei UI,128,96|MSJH.TTC,Microsoft Jhenghei UI|MSYH.TTC,Microsoft Yahei UI,128,96|MSYH.TTC,Microsoft Yahei UI|MALGUN.TTF,Malgun Gothic,128,96|MALGUN.TTF,Malgun Gothic|YUGOTHB.TTC,Yu Gothic UI Semibold,128,96|YUGOTHB.TTC,Yu Gothic UI Semibold|SEGUISYM.TTF,Segoe UI Symbol'
  }
]

def main [] {
  for link in $font_links {
    ^sudo reg add $registry_key /v $link.name /t REG_MULTI_SZ /s '|' /d $link.data /f
  }
}
