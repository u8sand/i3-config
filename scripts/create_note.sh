#/bin/bash

export conf=$(cd $(dirname $0)/.. ; pwd -P)
source "$conf/settings/env.sh"

cat >> "${NOTEDIR}/$(date +%Y-%m-%d)".md << EOF
# $(date +"%A, %B %d, %Y")

## Today

EOF

