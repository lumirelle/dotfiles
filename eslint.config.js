// @ts-check
import { antfu } from '@antfu/eslint-config'
import oxlint from 'eslint-plugin-oxlint'

export default antfu(
  {
    // Strict lib type
    type: 'lib',
    // Keep some configs style as their are,
    // to reduce the differences while updating.
    ignores: ['**/Microsoft.WindowsTerminal_8wekyb3d8bbwe/**/*', '**/Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe/**/*', 'dot_config/shared/clash-verge-rev/verge.yaml'],
  },
  ...oxlint.buildFromOxlintConfigFile('.oxlintrc.json'),
)
