yarn_node_modules() {
    local build_dir=${1:-}

    if [ -e $build_dir/package.json ]; then
        cd "$build_dir"

        if [ -e $build_dir/yarn.lock ]; then
            echo "Installing node modules (yarn.lock)"
        else
            echo "Installing node modules (yarn)"
        fi
        yarn install --pure-lockfile --production=false --ignore-engines 2>&1
    else
       echo "Skipping (no package.json)"
    fi
}

npm_node_modules() {
    local build_dir=${1:-}

    if [ -e $build_dir/package.json ]; then
        cd "$build_dir"

        if [ -e $build_dir/npm-shrinkwrap.json ]; then
            echo "Installing development node modules (package.json + shrinkwrap)"
        else
            echo "Installing development node modules (npm)"
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
    echo "Using configuration at $TSC_CONFIG"

    cd "$build_dir"
    ./node_modules/.bin/tsc --pretty --project $TSC_CONFIG
}
