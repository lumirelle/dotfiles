// @ts-check
import { antfu } from '@antfu/eslint-config'
import oxlint from 'eslint-plugin-oxlint'

export default antfu(
  {
    // Strict lib type
    type: 'lib',
    toml: {
      overrides: {
        'toml/array-element-newline': ['error', 'consistent'],
        'toml/array-bracket-spacing': ['error', 'never'],
        'toml/spaced-comment': ['error', 'always', { markers: [':schema'] }],
      },
    },
    // Keep some configs style as their are,
    // to reduce the differences while updating.
    ignores: [
      '**/io.github.clash-verge-rev.clash-verge-rev/*.yaml',
      'dot_config/shared/clash-verge-rev/*.yaml',
      'dot_pi/agent/settings.json',
    ],
  },
  ...oxlint.buildFromOxlintConfigFile('.oxlintrc.json'),
)
