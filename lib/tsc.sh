yarn_node_modules() {
    local build_dir=${1:-}

    echo "Installing node modules (yarn.lock)"
    cd "$build_dir"
    yarn install --pure-lockfile --ignore-engines 2>&1
}

npm_node_modules() {
    local build_dir=${1:-}

    if [ -e $build_dir/package.json ]; then
        cd "$build_dir"

        if [ -e $build_dir/npm-shrinkwrap.json ]; then
            echo "Installing development node modules (package.json + shrinkwrap)"
        else
            echo "Installing development node modules (package.json)"
        fi
        npm install --only=dev --unsafe-perm --userconfig $build_dir/.npmrc 2>&1
    else
        echo "Skipping (no package.json)"
    fi
}

list_dependencies() {
    local build_dir="$1"

    cd "$build_dir"
    if $YARN; then
        echo ""
        (yarn list --depth=0 || true) 2>/dev/null
        echo ""
    else
        (npm ls --only=dev --depth=0 | tail -n +2 || true) 2>/dev/null
    fi
}

compile_ts() {
    local build_dir=${1:-}

    cd "$build_dir"
    if $CUSTOM_TSC; then
        ./node_modules/.bin/tsc --pretty --project $TSC_CUSTOM_FILE
    else
        ./node_modules/.bin/tsc --pretty --project $TSC_DEFAULT_FILE
    fi
}
