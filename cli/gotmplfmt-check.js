import { execSync } from 'node:child_process'
import process from 'node:process'

const files = process.argv.slice(2).map(file => `"${file}"`)
const out = execSync(`gotmplfmt -l ${files.join(' ')}`, { encoding: 'utf8' }).trim()
console.log(out)
if (out) {
  process.exit(1)
}
