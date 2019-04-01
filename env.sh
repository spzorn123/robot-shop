#!/bin/sh

# set -x

# Read in vars from .env file
for VAR in $(egrep '^.+=' ./.env)
do
    export $VAR
done
