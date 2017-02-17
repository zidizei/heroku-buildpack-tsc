get_os() {
    uname | tr A-Z a-z
}

function join {
    local IFS="$1"
    shift
    echo "$*"
}

os=$(get_os)
export JQ="$BP_DIR/vendor/jq-$os"

read_json() {
    local file=$1
    local key=$2
    if test -f $file; then
        cat $file | $JQ --compact-output --raw-output "$key // \"\""  2>/dev/null || return 1
    else
        echo ""
    fi
}

prepare_tsconfig() {
    if $CUSTOM_TSC; then
        echo "Using custom configuration found at $TSC_CUSTOM_FILE"
        modify_tsconfig "$BUILD_DIR/tsconfig.json" "$TSC_DEFAULT_PATH"
    else
        echo "Using default configuration found at tsconfig.json"
        modify_tsconfig "$BUILD_DIR/tsconfig.json" "$TSC_DEFAULT_PATH"
    fi
}

modify_tsconfig() {
    local jq_filter=""

    read -r comments sourceMap <<< $(read_json $BUILD_DIR/tsconfig.json '.compilerOptions.removeComments, .compilerOptions.sourceMap')
    if [ $sourceMap == "true" ] || [ $sourceMap == "null" ]; then
        echo "Disable source maps for production build"
        jq_filter="$jq_filter | .compilerOptions.sourceMap = false"
    fi

    if [ $comments == "false" ] || [ $comments == "null" ]; then
        echo "Disable comments for production build"
        jq_filter="$jq_filter | .compilerOptions.removeComments = true"
    fi

    cat $1 | $JQ ". $jq_filter" > $2
}
