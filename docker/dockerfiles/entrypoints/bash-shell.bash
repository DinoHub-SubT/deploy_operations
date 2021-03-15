#!/usr/bin/env bash
# //////////////////////////////////////////////////////////////////////////////
# docker entrypoint script
# //////////////////////////////////////////////////////////////////////////////
set -e

# log message
echo " == Bash Shell == "

# source the bashrc to set the added ros variables
source ~/.bashrc

# Disallow docker exit -- keep container running
echo "Entrypoint ended";
/bin/bash "$@"
