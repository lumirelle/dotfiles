// oxlint-disable no-console
// If you want to learn about clash verge config example, please visit:
// https://github.com/MetaCubeX/mihomo/blob/Meta/docs/config.yaml

// eslint-disable-next-line unused-imports/no-unused-vars
function main(config) {
  const { proxies, proxyGroups } = genProxiesAndGroups(config)
  config.proxies = proxies
  config['proxy-groups'] = proxyGroups

  const { ruleProviders, rules } = genRulesAndProviders()
  // Preserve profile's rule providers:
  //
  // Some profiles use specific rule providers in DNS config, since the new version of Clash Verge Rev,
  // modify DNS config in this script is not allowed, we have to use DNS overwrite in settings instead.
  //
  // Unfortunately, Clash Verge Rev has a configuration validation step before DNS overwrite taking effect:
  // That means if those rule providers are not preserve, Clash Verge Rev will complain they are missing,
  // and will not allow you to switch to those profiles.
  config['rule-providers'] = {
    ...config['rule-providers'],
    ...ruleProviders,
  }
  config.rules = rules

  return config
}

/**
 * Generate proxies and groups.
 *
 * @param {object} config Original config object
 * @returns { { proxies: object, proxyGroups: object[] } } Custom proxies and groups
 */
function genProxiesAndGroups(config) {
  // Proxies
  /** Regex to filter out none standard proxy by name. */
  const NONE_STANDARD_PROXY_NAME = /官\s*网|到期|重置|订阅|说明|提示|剩余|套餐|导航|Traffic|Expire|Reset|.com/
  const proxies = (config.proxies ?? []).filter(proxy => !NONE_STANDARD_PROXY_NAME.test(proxy.name))

  // Proxy groups
  /** Filter to pick available countries of ChatGPT by proxy name. */
  const CHAT_GPT_AVAILABLE_PROXY_NAME_FILTER = 'AF|🇦🇫|AX|🇦🇽|AL|🇦🇱|DZ|🇩🇿|AD|🇦🇩|AO|🇦🇴|AG|🇦🇬|AR|🇦🇷|阿根廷|AM|🇦🇲|AW|🇦🇼|AU|🇦🇺|澳大利亚|澳大利亞|AT|🇦🇹|AZ|🇦🇿|BS|🇧🇸|BH|🇧🇭|BD|🇧🇩|BB|🇧🇧|BE|🇧🇪|BZ|🇧🇿|BM|🇧🇲|BJ|🇧🇯|BT|🇧🇹|BO|🇧🇴|BA|🇧🇦|BW|🇧🇼|BR|🇧🇷|巴西|BN|🇧🇳|文莱|汶萊|BG|🇧🇬|BF|🇧🇫|BI|🇧🇮|CV|🇨🇻|KH|🇰🇭|CM|🇨🇲|CA|🇨🇦|加拿大|KY|🇰🇾|CF|🇨🇫|TD|🇹🇩|CL|🇨🇱|智利|CO|🇨🇴|KM|🇰🇲|CG|🇨🇬|CD|🇨🇩|刚果金|剛果金|刚果（金）|剛果（金）|CR|🇨🇷|CI|🇨🇮|HR|🇭🇷|CY|🇨🇾|CZ|🇨🇿|捷克|DK|🇩🇰|DJ|🇩🇯|DM|🇩🇲|DO|🇩🇴|EC|🇪🇨|EG|🇪🇬|SV|🇸🇻|GQ|🇬🇶|ER|🇪🇷|EE|🇪🇪|SZ|🇸🇿|ET|🇪🇹|FO|🇫🇴|FJ|🇫🇯|FI|🇫🇮|FR|🇫🇷|法国|法國|GF|🇬🇫|PF|🇵🇫|TF|🇹🇫|GA|🇬🇦|GM|🇬🇲|GE|🇬🇪|DE|🇩🇪|德国|德國|GH|🇬🇭|GR|🇬🇷|GL|🇬🇱|GD|🇬🇩|GP|🇬🇵|GT|🇬🇹|GN|🇬🇳|GW|🇬🇼|GY|🇬🇾|HT|🇭🇹|VA|🇻🇦|HN|🇭🇳|HU|🇭🇺|IS|🇮🇸|IN|🇮🇳|印度|ID|🇮🇩|印尼|印度尼西亚|印度尼西亞|IQ|🇮🇶|IE|🇮🇪|IL|🇮🇱|IT|🇮🇹|JM|🇯🇲|JP|🇯🇵|日本|JO|🇯🇴|KZ|🇰🇿|KE|🇰🇪|KI|🇰🇮|KW|🇰🇼|KG|🇰🇬|LA|🇱🇦|LV|🇱🇻|LB|🇱🇧|LS|🇱🇸|LR|🇱🇷|LY|🇱🇾|LI|🇱🇮|LT|🇱🇹|LU|🇱🇺|MG|🇲🇬|MW|🇲🇼|MY|🇲🇾|马来西亚|馬來西亞|MV|🇲🇻|ML|🇲🇱|MT|🇲🇹|MH|🇲🇭|MQ|🇲🇶|MR|🇲🇷|MU|🇲🇺|YT|🇾🇹|MX|🇲🇽|墨西哥|FM|🇫🇲|MD|🇲🇩|摩尔多瓦|摩爾多瓦|MC|🇲🇨|MN|🇲🇳|ME|🇲🇪|MA|🇲🇦|MZ|🇲🇿|MM|🇲🇲|NA|🇳🇦|NR|🇳🇷|NP|🇳🇵|NL|🇳🇱|荷兰|荷蘭|NC|🇳🇨|NZ|🇳🇿|新西兰|紐西蘭|NI|🇳🇮|NE|🇳🇪|NG|🇳🇬|MK|🇲🇰|NO|🇳🇴|OM|🇴🇲|PK|🇵🇰|PW|🇵🇼|PS|🇵🇸|PA|🇵🇦|PG|🇵🇬|PY|🇵🇾|PE|🇵🇪|秘鲁|秘魯|PH|🇵🇭|菲律宾|菲律賓|PL|🇵🇱|PT|🇵🇹|QA|🇶🇦|RE|🇷🇪|RO|🇷🇴|RW|🇷🇼|BL|🇧🇱|SH|🇸🇭|KN|🇰🇳|LC|🇱🇨|MF|🇲🇫|PM|🇵🇲|VC|🇻🇨|WS|🇼🇸|SM|🇸🇲|ST|🇸🇹|SA|🇸🇦|沙特|沙烏地|沙特阿拉伯|沙烏地阿拉伯|SN|🇸🇳|RS|🇷🇸|SC|🇸🇨|SL|🇸🇱|SG|🇸🇬|新加坡|SK|🇸🇰|SI|🇸🇮|SB|🇸🇧|SO|🇸🇴|ZA|🇿🇦|KR|🇰🇷|韩国|韓國|SS|🇸🇸|ES|🇪🇸|LK|🇱🇰|SD|🇸🇩|SR|🇸🇷|SJ|🇸🇯|SE|🇸🇪|瑞典|CH|🇨🇭|瑞士|TW|🇹🇼|台湾|台灣|TJ|🇹🇯|TZ|🇹🇿|TH|🇹🇭|泰国|泰國|TL|🇹🇱|TG|🇹🇬|TO|🇹🇴|TT|🇹🇹|TN|🇹🇳|TR|🇹🇷|土耳其|TM|🇹🇲|TV|🇹🇻|UG|🇺🇬|UA|🇺🇦|乌克兰|烏克蘭|AE|🇦🇪|阿联酋|阿聯酋|GB|🇬🇧|英国|英國|US|🇺🇸|美国|美國|UY|🇺🇾|UZ|🇺🇿|VU|🇻🇺|VN|🇻🇳|越南|WF|🇼🇫|YE|🇾🇪|ZM|🇿🇲|ZW|🇿🇼'
  /** Filter to pick available countries of Claude Code by proxy name. */
  const CLAUDE_CODE_AVAILABLE_PROXY_NAME_FILTER = 'AL|🇦🇱|DZ|🇩🇿|AD|🇦🇩|AO|🇦🇴|AG|🇦🇬|AR|🇦🇷|阿根廷|AM|🇦🇲|AU|🇦🇺|澳大利亚|澳大利亞|AT|🇦🇹|AZ|🇦🇿|BS|🇧🇸|BH|🇧🇭|BD|🇧🇩|BB|🇧🇧|BE|🇧🇪|BZ|🇧🇿|BJ|🇧🇯|BT|🇧🇹|BO|🇧🇴|BA|🇧🇦|BW|🇧🇼|BR|🇧🇷|巴西|BN|🇧🇳|文莱|汶萊|BG|🇧🇬|BF|🇧🇫|BI|🇧🇮|CV|🇨🇻|KH|🇰🇭|CM|🇨🇲|CA|🇨🇦|加拿大|CF|🇨🇫|TD|🇹🇩|CL|🇨🇱|智利|CO|🇨🇴|KM|🇰🇲|CG|🇨🇬|CR|🇨🇷|CI|🇨🇮|HR|🇭🇷|CY|🇨🇾|CZ|🇨🇿|捷克|DK|🇩🇰|DJ|🇩🇯|DM|🇩🇲|DO|🇩🇴|EC|🇪🇨|EG|🇪🇬|SV|🇸🇻|GQ|🇬🇶|ER|🇪🇷|EE|🇪🇪|SZ|🇸🇿|ET|🇪🇹|FJ|🇫🇯|FI|🇫🇮|FR|🇫🇷|法国|法國|GA|🇬🇦|GM|🇬🇲|GE|🇬🇪|DE|🇩🇪|德国|德國|GH|🇬🇭|GR|🇬🇷|GD|🇬🇩|GT|🇬🇹|GN|🇬🇳|GW|🇬🇼|GY|🇬🇾|HT|🇭🇹|HN|🇭🇳|HU|🇭🇺|IS|🇮🇸|IN|🇮🇳|印度|ID|🇮🇩|印尼|印度尼西亚|印度尼西亞|IQ|🇮🇶|IE|🇮🇪|IL|🇮🇱|IT|🇮🇹|JM|🇯🇲|JP|🇯🇵|日本|JO|🇯🇴|KZ|🇰🇿|KE|🇰🇪|KI|🇰🇮|KW|🇰🇼|KG|🇰🇬|LA|🇱🇦|LV|🇱🇻|LB|🇱🇧|LS|🇱🇸|LR|🇱🇷|LY|🇱🇾|LI|🇱🇮|LT|🇱🇹|LU|🇱🇺|MG|🇲🇬|MW|🇲🇼|MY|🇲🇾|马来西亚|馬來西亞|MV|🇲🇻|ML|🇲🇱|MT|🇲🇹|MH|🇲🇭|MR|🇲🇷|MU|🇲🇺|MX|🇲🇽|墨西哥|FM|🇫🇲|MD|🇲🇩|摩尔多瓦|摩爾多瓦|MC|🇲🇨|MN|🇲🇳|ME|🇲🇪|MA|🇲🇦|MZ|🇲🇿|NA|🇳🇦|NR|🇳🇷|NP|🇳🇵|NL|🇳🇱|荷兰|荷蘭|NZ|🇳🇿|新西兰|紐西蘭|NI|🇳🇮|NE|🇳🇪|NG|🇳🇬|MK|🇲🇰|NO|🇳🇴|OM|🇴🇲|PK|🇵🇰|PW|🇵🇼|PS|🇵🇸|PA|🇵🇦|PG|🇵🇬|PY|🇵🇾|PE|🇵🇪|秘鲁|秘魯|PH|🇵🇭|菲律宾|菲律賓|PL|🇵🇱|PT|🇵🇹|QA|🇶🇦|RO|🇷🇴|RW|🇷🇼|KN|🇰🇳|LC|🇱🇨|VC|🇻🇨|WS|🇼🇸|SM|🇸🇲|ST|🇸🇹|SA|🇸🇦|沙特|沙烏地|沙特阿拉伯|沙烏地阿拉伯|SN|🇸🇳|RS|🇷🇸|SC|🇸🇨|SL|🇸🇱|SG|🇸🇬|新加坡|SK|🇸🇰|SI|🇸🇮|SB|🇸🇧|SO|🇸🇴|ZA|🇿🇦|KR|🇰🇷|韩国|韓國|SS|🇸🇸|ES|🇪🇸|LK|🇱🇰|SD|🇸🇩|SR|🇸🇷|SE|🇸🇪|瑞典|CH|🇨🇭|瑞士|TW|🇹🇼|台湾|台灣|TJ|🇹🇯|TZ|🇹🇿|TH|🇹🇭|泰国|泰國|TL|🇹🇱|TG|🇹🇬|TO|🇹🇴|TT|🇹🇹|TN|🇹🇳|TR|🇹🇷|土耳其|TM|🇹🇲|TV|🇹🇻|UG|🇺🇬|UA|🇺🇦|乌克兰|烏克蘭|AE|🇦🇪|阿联酋|阿聯酋|GB|🇬🇧|英国|英國|US|🇺🇸|美国|美國|UY|🇺🇾|UZ|🇺🇿|VU|🇻🇺|VA|🇻🇦|VN|🇻🇳|越南|ZM|🇿🇲|ZW|🇿🇼'
  const BASIC_PROXY_GROUP_OPTIONS = {
    'url': 'https://www.google.com/generate_204',
    'interval': 180,
    'timeout': 3_000,
    'lazy': true,
    'max-failed-times': 3,
    'hidden': false,
  }
  const { groups: geoBasedGroups, groupNames: geoBasedGroupNames } = genGeographyBasedGroups(BASIC_PROXY_GROUP_OPTIONS)
  const proxyGroups = [
    // Proxy
    {
      ...BASIC_PROXY_GROUP_OPTIONS,
      name: 'Just Proxy',
      type: 'select',
      proxies: ['Low Latency', 'Just Fallback', 'Loadbalance (Hashing)', 'Loadbalance (Round)', ...geoBasedGroupNames],
      icon: 'https://cdn.jsdelivr.net/gh/clash-verge-rev/clash-verge-rev.github.io@main/docs/assets/icons/adjust.svg',
    },
    {
      ...BASIC_PROXY_GROUP_OPTIONS,
      'name': 'Low Latency',
      'icon': 'https://cdn.jsdelivr.net/gh/clash-verge-rev/clash-verge-rev.github.io@main/docs/assets/icons/speed.svg',
      'type': 'url-test',
      'include-all-proxies': true,
      'tolerance': 50,
      'hidden': true,
    },
    {
      ...BASIC_PROXY_GROUP_OPTIONS,
      'name': 'Just Fallback',
      'icon': 'https://cdn.jsdelivr.net/gh/clash-verge-rev/clash-verge-rev.github.io@main/docs/assets/icons/ambulance.svg',
      'type': 'fallback',
      'include-all-proxies': true,
    },
    {
      ...BASIC_PROXY_GROUP_OPTIONS,
      'name': 'Loadbalance (Hashing)',
      'icon': 'https://cdn.jsdelivr.net/gh/clash-verge-rev/clash-verge-rev.github.io@main/docs/assets/icons/merry_go.svg',
      'type': 'load-balance',
      'include-all-proxies': true,
      'strategy': 'consistent-hashing',
      'hidden': true,
    },
    {
      ...BASIC_PROXY_GROUP_OPTIONS,
      'name': 'Loadbalance (Round)',
      'icon': 'https://cdn.jsdelivr.net/gh/clash-verge-rev/clash-verge-rev.github.io@main/docs/assets/icons/balance.svg',
      'type': 'load-balance',
      'include-all-proxies': true,
      'strategy': 'round-robin',
      'hidden': true,
    },
    ...geoBasedGroups,

    // Vendor specific proxy
    {
      ...BASIC_PROXY_GROUP_OPTIONS,
      'name': 'Chat GPT',
      'icon': 'https://cdn.jsdelivr.net/gh/clash-verge-rev/clash-verge-rev.github.io@main/docs/assets/icons/chatgpt.svg',
      'type': 'select',
      'url': 'https://chatgpt.com',
      'expected-status': '200',
      'include-all-proxies': true,
      'filter': CHAT_GPT_AVAILABLE_PROXY_NAME_FILTER,
    },
    {
      ...BASIC_PROXY_GROUP_OPTIONS,
      'name': 'Claude Code',
      'icon': 'https://cdn.jsdelivr.net/gh/clash-verge-rev/clash-verge-rev.github.io@main/docs/assets/icons/claude.svg',
      'type': 'select',
      'url': 'https://claude.com',
      'expected-status': '200',
      'include-all-proxies': true,
      'filter': CLAUDE_CODE_AVAILABLE_PROXY_NAME_FILTER,
    },

    // Direct, Reject & Match
    {
      ...BASIC_PROXY_GROUP_OPTIONS,
      name: 'Just Direct',
      type: 'select',
      proxies: ['DIRECT', 'Just Proxy'],
      icon: 'https://fastly.jsdelivr.net/gh/clash-verge-rev/clash-verge-rev.github.io@main/docs/assets/icons/link.svg',
    },
    {
      ...BASIC_PROXY_GROUP_OPTIONS,
      name: 'Just Reject',
      type: 'select',
      proxies: ['REJECT', 'Just Direct'],
      icon: 'https://cdn.jsdelivr.net/gh/clash-verge-rev/clash-verge-rev.github.io@main/docs/assets/icons/block.svg',
    },
    {
      ...BASIC_PROXY_GROUP_OPTIONS,
      name: 'Just Match',
      type: 'select',
      proxies: ['Just Direct', 'Just Proxy', 'Low Latency', 'Just Fallback', 'Loadbalance (Hashing)', 'Loadbalance (Round)', ...geoBasedGroupNames],
      icon: 'https://cdn.jsdelivr.net/gh/clash-verge-rev/clash-verge-rev.github.io@main/docs/assets/icons/fish.svg',
    },
  ]

  return {
    proxies,
    proxyGroups,
  }
}
/**
 * Generate geography based proxy groups.
 *
 * @param {object} BASIC_GROUP_OPTIONS
 * @returns { { groups: object[], groupNames: string[] } } Geography based proxy groups, and their names.
 */
function genGeographyBasedGroups(BASIC_GROUP_OPTIONS) {
  const TW_PROXY_NAME_FILTER = 'TW|🇹🇼|WS|🇼🇸|台湾|台灣'
  const HK_PROXY_NAME_FILTER = 'HK|🇭🇰|香港'
  const SG_PROXY_NAME_FILTER = 'SG|🇸🇬|新加坡'
  const JP_PROXY_NAME_FILTER = 'JP|🇯🇵|日本'
  const US_PROXY_NAME_FILTER = 'US|🇺🇸|美国|美國'
  const GEOGRAPHY_CONFIGS = [
    { name: 'Taiwan', icon: 'https://www.svgrepo.com/show/405623/flag-for-flag-taiwan.svg', filter: TW_PROXY_NAME_FILTER },
    { name: 'Hongkong', icon: 'https://www.svgrepo.com/show/405507/flag-for-flag-hong-kong-sar-china.svg', filter: HK_PROXY_NAME_FILTER },
    { name: 'Singapore', icon: 'https://www.svgrepo.com/show/405601/flag-for-flag-singapore.svg', filter: SG_PROXY_NAME_FILTER },
    { name: 'Japan', icon: 'https://www.svgrepo.com/show/405519/flag-for-flag-japan.svg', filter: JP_PROXY_NAME_FILTER },
    { name: 'United States', icon: 'https://www.svgrepo.com/show/405645/flag-for-flag-united-states.svg', filter: US_PROXY_NAME_FILTER },
    { name: 'Other', icon: 'https://www.svgrepo.com/show/187784/earth-globe-global.svg', excludeFilter: [TW_PROXY_NAME_FILTER, HK_PROXY_NAME_FILTER, SG_PROXY_NAME_FILTER, JP_PROXY_NAME_FILTER, US_PROXY_NAME_FILTER].join('|') },
  ]
  const groups = GEOGRAPHY_CONFIGS.flatMap(({ name, icon, filter, excludeFilter }) => [{
    ...BASIC_GROUP_OPTIONS,
    name,
    icon,
    'type': 'select',
    'include-all-proxies': true,
    filter,
    'exclude-filter': excludeFilter,
  }])
  const groupNames = groups.map(g => g.name)
  return {
    groups,
    groupNames,
  }
}

/**
 * Generate rule providers & rules.
 *
 * @returns {object} Custom rule providers & rules
 */
function genRulesAndProviders() {
  // Rule providers
  const BASIC_RULE_PROVIDER_OPTIONS = {
    type: 'http',
    format: 'yaml',
    interval: 86_400,
  }
  const ruleProviders = {
    'fake-ip-filter-set': {
      ...BASIC_RULE_PROVIDER_OPTIONS,
      behavior: 'domain',
      url: 'https://cdn.jsdelivr.net/gh/silver716/fake-ip-filter/fake_ip_filter_set.yaml',
      path: './ruleset/silver716/fake-ip-filter-set.yaml',
    },
    'applications': {
      ...BASIC_RULE_PROVIDER_OPTIONS,
      behavior: 'classical',
      url: 'https://cdn.jsdelivr.net/gh/Loyalsoldier/clash-rules@release/applications.txt',
      path: './ruleset/loyalsoldier/applications.yaml',
    },
    'private': {
      ...BASIC_RULE_PROVIDER_OPTIONS,
      behavior: 'domain',
      url: 'https://cdn.jsdelivr.net/gh/Loyalsoldier/clash-rules@release/private.txt',
      path: './ruleset/loyalsoldier/private.yaml',
    },
    'reject': {
      ...BASIC_RULE_PROVIDER_OPTIONS,
      behavior: 'domain',
      url: 'https://cdn.jsdelivr.net/gh/Loyalsoldier/clash-rules@release/reject.txt',
      path: './ruleset/loyalsoldier/reject.yaml',
    },
    'direct': {
      ...BASIC_RULE_PROVIDER_OPTIONS,
      behavior: 'domain',
      url: 'https://cdn.jsdelivr.net/gh/Loyalsoldier/clash-rules@release/direct.txt',
      path: './ruleset/loyalsoldier/direct.yaml',
    },
    'proxy': {
      ...BASIC_RULE_PROVIDER_OPTIONS,
      behavior: 'domain',
      url: 'https://cdn.jsdelivr.net/gh/Loyalsoldier/clash-rules@release/proxy.txt',
      path: './ruleset/loyalsoldier/proxy.yaml',
    },
    'lancidr': {
      ...BASIC_RULE_PROVIDER_OPTIONS,
      behavior: 'ipcidr',
      url: 'https://cdn.jsdelivr.net/gh/Loyalsoldier/clash-rules@release/lancidr.txt',
      path: './ruleset/loyalsoldier/lancidr.yaml',
    },
    'cncidr': {
      ...BASIC_RULE_PROVIDER_OPTIONS,
      behavior: 'ipcidr',
      url: 'https://cdn.jsdelivr.net/gh/Loyalsoldier/clash-rules@release/cncidr.txt',
      path: './ruleset/loyalsoldier/cncidr.yaml',
    },
    'telegramcidr': {
      ...BASIC_RULE_PROVIDER_OPTIONS,
      behavior: 'ipcidr',
      url: 'https://cdn.jsdelivr.net/gh/Loyalsoldier/clash-rules@release/telegramcidr.txt',
      path: './ruleset/loyalsoldier/telegramcidr.yaml',
    },
  }
  // Rules
  const rules = [
    // Applications
    'PROCESS-NAME,ForzaHorizon4.exe,Just Direct', // Forza Horizon 4
    'PROCESS-NAME,hl.exe,Just Direct', // half-life launcher
    'RULE-SET,applications,Just Direct',

    // Domain
    'RULE-SET,reject,Just Reject',

    'GEOSITE,openai,Chat GPT',
    'GEOSITE,anthropic,Claude',

    'GEOSITE,google,Just Proxy',
    'GEOSITE,youtube,Just Proxy',
    'GEOSITE,netflix,Just Proxy',

    'DOMAIN-SUFFIX,rockstargames.com,Just Direct',
    'DOMAIN-SUFFIX,lspdfrcn.net,Just Direct',
    'DOMAIN-SUFFIX,test-ipv6.com,Just Direct',
    'RULE-SET,private,Just Direct',
    'RULE-SET,direct,Just Direct',
    'GEOSITE,category-games@cn,Just Direct',
    'GEOSITE,steam@cn,Just Direct',
    'GEOSITE,microsoft@cn,Just Direct',
    'GEOSITE,onedrive,Just Direct',
    'GEOSITE,apple-cn,Just Direct',

    'RULE-SET,proxy,Just Proxy',

    // CIDR
    'RULE-SET,telegramcidr,Just Proxy',
    'RULE-SET,lancidr,Just Direct',
    'RULE-SET,cncidr,Just Direct',

    // GEO
    'GEOIP,LAN,Just Direct',
    'GEOIP,CN,Just Direct',

    'MATCH,Just Match',
  ]

  return {
    ruleProviders,
    rules,
  }
}
