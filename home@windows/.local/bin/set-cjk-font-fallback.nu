#!/usr/bin/env nushell
# set-cjk-font-fallback - prefer Resource Han Rounded CN over the built-in CJK fonts
# for the Windows UI.
#
# Covers both the legacy "Segoe UI*" values and the "Segoe UI Variable *" values.
# Each value is the pristine Windows default chain with the Resource Han Rounded
# entries prepended, so fallbacks for Japanese, Korean and Traditional Chinese are
# preserved. Counterpart: reset-cjk-font-fallback.nu restores the defaults.
#
# Resource Han Rounded CN ships no Semilight/Semibold faces, so the nearest
# available weights are used:
#   Semilight -> Resource Han Rounded CN Normal (usWeightClass 350)
#   Semibold  -> Resource Han Rounded CN Medium (usWeightClass 500)
#
# Every linked font is listed twice: once with the 128,96 scaling factors (used by
# GDI) and once without them (used by GDI+), same as the Windows defaults.

const system_link = 'HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontLink\SystemLink'

# Each entry keeps one font-link chain; the segments are joined with `|` when
# the registry value is written.
const font_links = [
  {
    name: 'Segoe UI'
    chain: [
      'RESOURCEHANROUNDEDCN-REGULAR.TTF,Resource Han Rounded CN,128,96'
      'RESOURCEHANROUNDEDCN-REGULAR.TTF,Resource Han Rounded CN'
      'TAHOMA.TTF,Tahoma'
      'MEIRYO.TTC,Meiryo UI,128,96'
      'MEIRYO.TTC,Meiryo UI'
      'MSGOTHIC.TTC,MS UI Gothic'
      'MSJH.TTC,Microsoft JhengHei UI,128,96'
      'MSJH.TTC,Microsoft JhengHei UI'
      'MSYH.TTC,Microsoft YaHei UI,128,96'
      'MSYH.TTC,Microsoft YaHei UI'
      'MALGUN.TTF,Malgun Gothic,128,96'
      'MALGUN.TTF,Malgun Gothic'
      'MINGLIU.TTC,PMingLiU'
      'SIMSUN.TTC,SimSun'
      'GULIM.TTC,Gulim'
      'YUGOTHM.TTC,Yu Gothic UI,128,96'
      'YUGOTHM.TTC,Yu Gothic UI'
      'SEGUISYM.TTF,Segoe UI Symbol'
    ]
  }
  {
    name: 'Segoe UI Light'
    chain: [
      'RESOURCEHANROUNDEDCN-LIGHT.TTF,Resource Han Rounded CN Light,128,96'
      'RESOURCEHANROUNDEDCN-LIGHT.TTF,Resource Han Rounded CN Light'
      'MEIRYO.TTC,Meiryo UI,128,96'
      'MEIRYO.TTC,Meiryo UI'
      'MSJHL.TTC,Microsoft JhengHei UI Light,128,96'
      'MSJHL.TTC,Microsoft JhengHei UI Light'
      'MSYHL.TTC,Microsoft YaHei UI Light,128,96'
      'MSYHL.TTC,Microsoft YaHei UI Light'
      'MALGUNSL.TTF,Malgun Gothic Semilight,128,96'
      'MALGUNSL.TTF,Malgun Gothic Semilight'
      'YUGOTHL.TTC,Yu Gothic UI Light,128,96'
      'YUGOTHL.TTC,Yu Gothic UI Light'
      'SEGUISYM.TTF,Segoe UI Symbol'
    ]
  }
  {
    name: 'Segoe UI Bold'
    chain: [
      'RESOURCEHANROUNDEDCN-BOLD.TTF,Resource Han Rounded CN Bold,128,96'
      'RESOURCEHANROUNDEDCN-BOLD.TTF,Resource Han Rounded CN Bold'
      'MEIRYOB.TTC,Meiryo UI Bold,128,96'
      'MEIRYOB.TTC,Meiryo UI Bold'
      'MSJHBD.TTC,Microsoft JhengHei UI Bold,128,96'
      'MSJHBD.TTC,Microsoft JhengHei UI Bold'
      'MSYHBD.TTC,Microsoft YaHei UI Bold,128,96'
      'MSYHBD.TTC,Microsoft YaHei UI Bold'
      'MALGUNBD.TTF,Malgun Gothic Bold,128,96'
      'MALGUNBD.TTF,Malgun Gothic Bold'
      'YUGOTHB.TTC,Yu Gothic UI Bold,128,96'
      'YUGOTHB.TTC,Yu Gothic UI Bold'
      'SEGUISYM.TTF,Segoe UI Symbol'
    ]
  }
  {
    name: 'Segoe UI Semilight'
    chain: [
      'RESOURCEHANROUNDEDCN-NORMAL.TTF,Resource Han Rounded CN Normal,128,96'
      'RESOURCEHANROUNDEDCN-NORMAL.TTF,Resource Han Rounded CN Normal'
      'MEIRYO.TTC,Meiryo UI,128,96'
      'MEIRYO.TTC,Meiryo UI'
      'MSJH.TTC,Microsoft JhengHei UI,128,96'
      'MSJH.TTC,Microsoft JhengHei UI'
      'MSYH.TTC,Microsoft YaHei UI,128,96'
      'MSYH.TTC,Microsoft YaHei UI'
      'MALGUNSL.TTF,Malgun Gothic Semilight,128,96'
      'MALGUNSL.TTF,Malgun Gothic Semilight'
      'YUGOTHR.TTC,Yu Gothic UI Semilight,128,96'
      'YUGOTHR.TTC,Yu Gothic UI Semilight'
      'SEGUISYM.TTF,Segoe UI Symbol'
    ]
  }
  {
    name: 'Segoe UI Semibold'
    chain: [
      'RESOURCEHANROUNDEDCN-MEDIUM.TTF,Resource Han Rounded CN Medium,128,96'
      'RESOURCEHANROUNDEDCN-MEDIUM.TTF,Resource Han Rounded CN Medium'
      'MEIRYO.TTC,Meiryo UI,128,96'
      'MEIRYO.TTC,Meiryo UI'
      'MSJH.TTC,Microsoft Jhenghei UI,128,96'
      'MSJH.TTC,Microsoft Jhenghei UI'
      'MSYH.TTC,Microsoft Yahei UI,128,96'
      'MSYH.TTC,Microsoft Yahei UI'
      'MALGUN.TTF,Malgun Gothic,128,96'
      'MALGUN.TTF,Malgun Gothic'
      'YUGOTHB.TTC,Yu Gothic UI Semibold,128,96'
      'YUGOTHB.TTC,Yu Gothic UI Semibold'
      'SEGUISYM.TTF,Segoe UI Symbol'
    ]
  }
  {
    name: 'Segoe UI Variable Small'
    chain: [
      'RESOURCEHANROUNDEDCN-REGULAR.TTF,Resource Han Rounded CN,128,96'
      'RESOURCEHANROUNDEDCN-REGULAR.TTF,Resource Han Rounded CN'
      'TAHOMA.TTF,Tahoma'
      'MEIRYO.TTC,Meiryo UI,128,96'
      'MEIRYO.TTC,Meiryo UI'
      'MSGOTHIC.TTC,MS UI Gothic'
      'MSJH.TTC,Microsoft JhengHei UI,128,96'
      'MSJH.TTC,Microsoft JhengHei UI'
      'MSYH.TTC,Microsoft YaHei UI,128,96'
      'MSYH.TTC,Microsoft YaHei UI'
      'MALGUN.TTF,Malgun Gothic,128,96'
      'MALGUN.TTF,Malgun Gothic'
      'MINGLIU.TTC,PMingLiU'
      'SIMSUN.TTC,SimSun'
      'GULIM.TTC,Gulim'
      'YUGOTHM.TTC,Yu Gothic UI,128,96'
      'YUGOTHM.TTC,Yu Gothic UI'
      'SEGUISYM.TTF,Segoe UI Symbol'
    ]
  }
  {
    name: 'Segoe UI Variable Small Bold'
    chain: [
      'RESOURCEHANROUNDEDCN-BOLD.TTF,Resource Han Rounded CN Bold,128,96'
      'RESOURCEHANROUNDEDCN-BOLD.TTF,Resource Han Rounded CN Bold'
      'MEIRYOB.TTC,Meiryo UI Bold,128,96'
      'MEIRYOB.TTC,Meiryo UI Bold'
      'MSJHBD.TTC,Microsoft JhengHei UI Bold,128,96'
      'MSJHBD.TTC,Microsoft JhengHei UI Bold'
      'MSYHBD.TTC,Microsoft YaHei UI Bold,128,96'
      'MSYHBD.TTC,Microsoft YaHei UI Bold'
      'MALGUNBD.TTF,Malgun Gothic Bold,128,96'
      'MALGUNBD.TTF,Malgun Gothic Bold'
      'YUGOTHB.TTC,Yu Gothic UI Bold,128,96'
      'YUGOTHB.TTC,Yu Gothic UI Bold'
      'SEGUISYM.TTF,Segoe UI Symbol'
    ]
  }
  {
    name: 'Segoe UI Variable Small Light'
    chain: [
      'RESOURCEHANROUNDEDCN-LIGHT.TTF,Resource Han Rounded CN Light,128,96'
      'RESOURCEHANROUNDEDCN-LIGHT.TTF,Resource Han Rounded CN Light'
      'MEIRYO.TTC,Meiryo UI,128,96'
      'MEIRYO.TTC,Meiryo UI'
      'MSJHL.TTC,Microsoft JhengHei UI Light,128,96'
      'MSJHL.TTC,Microsoft JhengHei UI Light'
      'MSYHL.TTC,Microsoft YaHei UI Light,128,96'
      'MSYHL.TTC,Microsoft YaHei UI Light'
      'MALGUNSL.TTF,Malgun Gothic Semilight,128,96'
      'MALGUNSL.TTF,Malgun Gothic Semilight'
      'YUGOTHL.TTC,Yu Gothic UI Light,128,96'
      'YUGOTHL.TTC,Yu Gothic UI Light'
      'SEGUISYM.TTF,Segoe UI Symbol'
    ]
  }
  {
    name: 'Segoe UI Variable Small Semilig'
    chain: [
      'RESOURCEHANROUNDEDCN-NORMAL.TTF,Resource Han Rounded CN Normal,128,96'
      'RESOURCEHANROUNDEDCN-NORMAL.TTF,Resource Han Rounded CN Normal'
      'MEIRYO.TTC,Meiryo UI,128,96'
      'MEIRYO.TTC,Meiryo UI'
      'MSJH.TTC,Microsoft JhengHei UI,128,96'
      'MSJH.TTC,Microsoft JhengHei UI'
      'MSYH.TTC,Microsoft YaHei UI,128,96'
      'MSYH.TTC,Microsoft YaHei UI'
      'MALGUNSL.TTF,Malgun Gothic Semilight,128,96'
      'MALGUNSL.TTF,Malgun Gothic Semilight'
      'YUGOTHR.TTC,Yu Gothic UI Semilight,128,96'
      'YUGOTHR.TTC,Yu Gothic UI Semilight'
      'SEGUISYM.TTF,Segoe UI Symbol'
    ]
  }
  {
    name: 'Segoe UI Variable Small Semibol'
    chain: [
      'RESOURCEHANROUNDEDCN-MEDIUM.TTF,Resource Han Rounded CN Medium,128,96'
      'RESOURCEHANROUNDEDCN-MEDIUM.TTF,Resource Han Rounded CN Medium'
      'MEIRYO.TTC,Meiryo UI,128,96'
      'MEIRYO.TTC,Meiryo UI'
      'MSJH.TTC,Microsoft Jhenghei UI,128,96'
      'MSJH.TTC,Microsoft Jhenghei UI'
      'MSYH.TTC,Microsoft Yahei UI,128,96'
      'MSYH.TTC,Microsoft Yahei UI'
      'MALGUN.TTF,Malgun Gothic,128,96'
      'MALGUN.TTF,Malgun Gothic'
      'YUGOTHB.TTC,Yu Gothic UI Semibold,128,96'
      'YUGOTHB.TTC,Yu Gothic UI Semibold'
      'SEGUISYM.TTF,Segoe UI Symbol'
    ]
  }
  {
    name: 'Segoe UI Variable Text'
    chain: [
      'RESOURCEHANROUNDEDCN-REGULAR.TTF,Resource Han Rounded CN,128,96'
      'RESOURCEHANROUNDEDCN-REGULAR.TTF,Resource Han Rounded CN'
      'TAHOMA.TTF,Tahoma'
      'MEIRYO.TTC,Meiryo UI,128,96'
      'MEIRYO.TTC,Meiryo UI'
      'MSGOTHIC.TTC,MS UI Gothic'
      'MSJH.TTC,Microsoft JhengHei UI,128,96'
      'MSJH.TTC,Microsoft JhengHei UI'
      'MSYH.TTC,Microsoft YaHei UI,128,96'
      'MSYH.TTC,Microsoft YaHei UI'
      'MALGUN.TTF,Malgun Gothic,128,96'
      'MALGUN.TTF,Malgun Gothic'
      'MINGLIU.TTC,PMingLiU'
      'SIMSUN.TTC,SimSun'
      'GULIM.TTC,Gulim'
      'YUGOTHM.TTC,Yu Gothic UI,128,96'
      'YUGOTHM.TTC,Yu Gothic UI'
      'SEGUISYM.TTF,Segoe UI Symbol'
    ]
  }
  {
    name: 'Segoe UI Variable Text Bold'
    chain: [
      'RESOURCEHANROUNDEDCN-BOLD.TTF,Resource Han Rounded CN Bold,128,96'
      'RESOURCEHANROUNDEDCN-BOLD.TTF,Resource Han Rounded CN Bold'
      'MEIRYOB.TTC,Meiryo UI Bold,128,96'
      'MEIRYOB.TTC,Meiryo UI Bold'
      'MSJHBD.TTC,Microsoft JhengHei UI Bold,128,96'
      'MSJHBD.TTC,Microsoft JhengHei UI Bold'
      'MSYHBD.TTC,Microsoft YaHei UI Bold,128,96'
      'MSYHBD.TTC,Microsoft YaHei UI Bold'
      'MALGUNBD.TTF,Malgun Gothic Bold,128,96'
      'MALGUNBD.TTF,Malgun Gothic Bold'
      'YUGOTHB.TTC,Yu Gothic UI Bold,128,96'
      'YUGOTHB.TTC,Yu Gothic UI Bold'
      'SEGUISYM.TTF,Segoe UI Symbol'
    ]
  }
  {
    name: 'Segoe UI Variable Text Light'
    chain: [
      'RESOURCEHANROUNDEDCN-LIGHT.TTF,Resource Han Rounded CN Light,128,96'
      'RESOURCEHANROUNDEDCN-LIGHT.TTF,Resource Han Rounded CN Light'
      'MEIRYO.TTC,Meiryo UI,128,96'
      'MEIRYO.TTC,Meiryo UI'
      'MSJHL.TTC,Microsoft JhengHei UI Light,128,96'
      'MSJHL.TTC,Microsoft JhengHei UI Light'
      'MSYHL.TTC,Microsoft YaHei UI Light,128,96'
      'MSYHL.TTC,Microsoft YaHei UI Light'
      'MALGUNSL.TTF,Malgun Gothic Semilight,128,96'
      'MALGUNSL.TTF,Malgun Gothic Semilight'
      'YUGOTHL.TTC,Yu Gothic UI Light,128,96'
      'YUGOTHL.TTC,Yu Gothic UI Light'
      'SEGUISYM.TTF,Segoe UI Symbol'
    ]
  }
  {
    name: 'Segoe UI Variable Text Semiligh'
    chain: [
      'RESOURCEHANROUNDEDCN-NORMAL.TTF,Resource Han Rounded CN Normal,128,96'
      'RESOURCEHANROUNDEDCN-NORMAL.TTF,Resource Han Rounded CN Normal'
      'MEIRYO.TTC,Meiryo UI,128,96'
      'MEIRYO.TTC,Meiryo UI'
      'MSJH.TTC,Microsoft JhengHei UI,128,96'
      'MSJH.TTC,Microsoft JhengHei UI'
      'MSYH.TTC,Microsoft YaHei UI,128,96'
      'MSYH.TTC,Microsoft YaHei UI'
      'MALGUNSL.TTF,Malgun Gothic Semilight,128,96'
      'MALGUNSL.TTF,Malgun Gothic Semilight'
      'YUGOTHR.TTC,Yu Gothic UI Semilight,128,96'
      'YUGOTHR.TTC,Yu Gothic UI Semilight'
      'SEGUISYM.TTF,Segoe UI Symbol'
    ]
  }
  {
    name: 'Segoe UI Variable Text Semibold'
    chain: [
      'RESOURCEHANROUNDEDCN-MEDIUM.TTF,Resource Han Rounded CN Medium,128,96'
      'RESOURCEHANROUNDEDCN-MEDIUM.TTF,Resource Han Rounded CN Medium'
      'MEIRYO.TTC,Meiryo UI,128,96'
      'MEIRYO.TTC,Meiryo UI'
      'MSJH.TTC,Microsoft Jhenghei UI,128,96'
      'MSJH.TTC,Microsoft Jhenghei UI'
      'MSYH.TTC,Microsoft Yahei UI,128,96'
      'MSYH.TTC,Microsoft Yahei UI'
      'MALGUN.TTF,Malgun Gothic,128,96'
      'MALGUN.TTF,Malgun Gothic'
      'YUGOTHB.TTC,Yu Gothic UI Semibold,128,96'
      'YUGOTHB.TTC,Yu Gothic UI Semibold'
      'SEGUISYM.TTF,Segoe UI Symbol'
    ]
  }
  {
    name: 'Segoe UI Variable Display'
    chain: [
      'RESOURCEHANROUNDEDCN-REGULAR.TTF,Resource Han Rounded CN,128,96'
      'RESOURCEHANROUNDEDCN-REGULAR.TTF,Resource Han Rounded CN'
      'TAHOMA.TTF,Tahoma'
      'MEIRYO.TTC,Meiryo UI,128,96'
      'MEIRYO.TTC,Meiryo UI'
      'MSGOTHIC.TTC,MS UI Gothic'
      'MSJH.TTC,Microsoft JhengHei UI,128,96'
      'MSJH.TTC,Microsoft JhengHei UI'
      'MSYH.TTC,Microsoft YaHei UI,128,96'
      'MSYH.TTC,Microsoft YaHei UI'
      'MALGUN.TTF,Malgun Gothic,128,96'
      'MALGUN.TTF,Malgun Gothic'
      'MINGLIU.TTC,PMingLiU'
      'SIMSUN.TTC,SimSun'
      'GULIM.TTC,Gulim'
      'YUGOTHM.TTC,Yu Gothic UI,128,96'
      'YUGOTHM.TTC,Yu Gothic UI'
      'SEGUISYM.TTF,Segoe UI Symbol'
    ]
  }
  {
    name: 'Segoe UI Variable Display Bold'
    chain: [
      'RESOURCEHANROUNDEDCN-BOLD.TTF,Resource Han Rounded CN Bold,128,96'
      'RESOURCEHANROUNDEDCN-BOLD.TTF,Resource Han Rounded CN Bold'
      'MEIRYOB.TTC,Meiryo UI Bold,128,96'
      'MEIRYOB.TTC,Meiryo UI Bold'
      'MSJHBD.TTC,Microsoft JhengHei UI Bold,128,96'
      'MSJHBD.TTC,Microsoft JhengHei UI Bold'
      'MSYHBD.TTC,Microsoft YaHei UI Bold,128,96'
      'MSYHBD.TTC,Microsoft YaHei UI Bold'
      'MALGUNBD.TTF,Malgun Gothic Bold,128,96'
      'MALGUNBD.TTF,Malgun Gothic Bold'
      'YUGOTHB.TTC,Yu Gothic UI Bold,128,96'
      'YUGOTHB.TTC,Yu Gothic UI Bold'
      'SEGUISYM.TTF,Segoe UI Symbol'
    ]
  }
  {
    name: 'Segoe UI Variable Display Light'
    chain: [
      'RESOURCEHANROUNDEDCN-LIGHT.TTF,Resource Han Rounded CN Light,128,96'
      'RESOURCEHANROUNDEDCN-LIGHT.TTF,Resource Han Rounded CN Light'
      'MEIRYO.TTC,Meiryo UI,128,96'
      'MEIRYO.TTC,Meiryo UI'
      'MSJHL.TTC,Microsoft JhengHei UI Light,128,96'
      'MSJHL.TTC,Microsoft JhengHei UI Light'
      'MSYHL.TTC,Microsoft YaHei UI Light,128,96'
      'MSYHL.TTC,Microsoft YaHei UI Light'
      'MALGUNSL.TTF,Malgun Gothic Semilight,128,96'
      'MALGUNSL.TTF,Malgun Gothic Semilight'
      'YUGOTHL.TTC,Yu Gothic UI Light,128,96'
      'YUGOTHL.TTC,Yu Gothic UI Light'
      'SEGUISYM.TTF,Segoe UI Symbol'
    ]
  }
  {
    name: 'Segoe UI Variable Display Semil'
    chain: [
      'RESOURCEHANROUNDEDCN-NORMAL.TTF,Resource Han Rounded CN Normal,128,96'
      'RESOURCEHANROUNDEDCN-NORMAL.TTF,Resource Han Rounded CN Normal'
      'MEIRYO.TTC,Meiryo UI,128,96'
      'MEIRYO.TTC,Meiryo UI'
      'MSJH.TTC,Microsoft JhengHei UI,128,96'
      'MSJH.TTC,Microsoft JhengHei UI'
      'MSYH.TTC,Microsoft YaHei UI,128,96'
      'MSYH.TTC,Microsoft YaHei UI'
      'MALGUNSL.TTF,Malgun Gothic Semilight,128,96'
      'MALGUNSL.TTF,Malgun Gothic Semilight'
      'YUGOTHR.TTC,Yu Gothic UI Semilight,128,96'
      'YUGOTHR.TTC,Yu Gothic UI Semilight'
      'SEGUISYM.TTF,Segoe UI Symbol'
    ]
  }
  {
    name: 'Segoe UI Variable Display Semib'
    chain: [
      'RESOURCEHANROUNDEDCN-MEDIUM.TTF,Resource Han Rounded CN Medium,128,96'
      'RESOURCEHANROUNDEDCN-MEDIUM.TTF,Resource Han Rounded CN Medium'
      'MEIRYO.TTC,Meiryo UI,128,96'
      'MEIRYO.TTC,Meiryo UI'
      'MSJH.TTC,Microsoft Jhenghei UI,128,96'
      'MSJH.TTC,Microsoft Jhenghei UI'
      'MSYH.TTC,Microsoft Yahei UI,128,96'
      'MSYH.TTC,Microsoft Yahei UI'
      'MALGUN.TTF,Malgun Gothic,128,96'
      'MALGUN.TTF,Malgun Gothic'
      'YUGOTHB.TTC,Yu Gothic UI Semibold,128,96'
      'YUGOTHB.TTC,Yu Gothic UI Semibold'
      'SEGUISYM.TTF,Segoe UI Symbol'
    ]
  }
]

def main [] {
  for link in $font_links {
    ^sudo reg add $system_link /v $link.name /t REG_MULTI_SZ /s '|' /d ($link.chain | str join '|') /f
  }
}
