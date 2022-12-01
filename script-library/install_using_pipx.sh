#!/usr/bin/env bash

install_using_pipx() {
    # This is part of devcontainers-contrib script library
    # source: https://github.com/devcontainers-contrib/features/tree/v1.0.1/script-library

    PACKAGES=("$@")
    arraylength=${#PACKAGES[@]}
    env_name=$(echo ${PACKAGES[0]} | cut -d "=" -f 1 | cut -d "<" -f 1 | cut -d ">" -f 1 )

    if ! dpkg -s python3-minimal python3-pip libffi-dev python3-venv > /dev/null 2>&1; then
        apt_get_update
        apt-get -y install python3-minimal python3-pip libffi-dev python3-venv
    fi
    export PIPX_HOME=/usr/local/pipx
    mkdir -p ${PIPX_HOME}
    export PIPX_BIN_DIR=/usr/local/bin
    export PYTHONUSERBASE=/tmp/pip-tmp
    export PIP_CACHE_DIR=/tmp/pip-tmp/cache
    pipx_bin=pipx
    if ! type pipx > /dev/null 2>&1; then
        pip3 install --disable-pip-version-check --no-cache-dir --user pipx
        pipx_bin=/tmp/pip-tmp/bin/pipx
    fi
    ${pipx_bin} install --pip-args '--no-cache-dir --force-reinstall' -f ${PACKAGES[0]}
    
    for (( i=1; i<${arraylength}; i++ ));
    do
    ${pipx_bin} inject $env_name --pip-args '--no-cache-dir --force-reinstall' -f ${PACKAGES[$i]}
    done
}
