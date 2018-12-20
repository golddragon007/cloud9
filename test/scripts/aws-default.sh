#!/bin/sh -e

source $HOME/.bash_profile

set -x

sudo salt-call --retcode-passthrough state.apply commands.expandFS --local

sudo salt-call --retcode-passthrough state.apply --local

sudo salt-call --retcode-passthrough state.apply config.bashrc --local

sudo salt-call --retcode-passthrough state.apply config.git --local

sudo salt-call --retcode-passthrough state.apply system.cleanup --local

sudo salt-call --retcode-passthrough state.apply tools.nodejs --local

sudo salt-call --retcode-passthrough state.apply frp --local

sudo salt-call --retcode-passthrough state.apply tools.varnish-mock --local

# Check 
git st || if (( "$?" == 1));then exit 1;fi
source ~/.bashrc
cdenv
node --version
command -v varnish-mock || exit 34