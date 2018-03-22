export_env_dir() {
    env_dir=$1
    whitelist_regex=${2:-''}
    blacklist_regex=${3:-'^(PATH|GIT_DIR|CPATH|CPPATH|LD_PRELOAD|LIBRARY_PATH)$'}
    if [ -d "$env_dir" ]; then
        for e in $(ls $env_dir); do
            echo "$e" | grep -E "$whitelist_regex" | grep -qvE "$blacklist_regex" &&
            export "$e=$(cat $env_dir/$e)"
            :
        done
    fi
}

create_build_env() {
    export ORIGINAL_ENV=${NODE_ENV:-production}

    if $TSC_CUSTOM_FILE; then
        echo "Warning: Please use TSC_CONFIG to set a custom tsconfig.json for compilation."
    fi
    export TSC_CUSTOM_FILE=${TSC_CUSTOM_FILE:-"$BUILD_DIR/tsconfig.json"}
    export TSC_CONFIG=${TSC_CONFIG:-$TSC_CUSTOM_FILE}

    export NODE_ENV=${TSC_BUILD_ENV:-$NODE_ENV}
    export NODE_VERBOSE=${NODE_VERBOSE:-false}
}

exit_build_env() {
    export NODE_ENV=${ORIGINAL_ENV}
}
