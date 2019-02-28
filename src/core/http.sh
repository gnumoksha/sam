#
# Functions related to HTTP connection.
#

#######################################
# Sends a GET request and echo the
# response.
# Globals:
#   None
# Arguments:
#   URL
# Returns:
#   None
#######################################
sam::core::http::get() {
    local url=${1:-}
    local params

    if sam::core::is_debug_enabled; then
        params='-v'
    else
        params='--silent'
    fi

    curl --location --fail --show-error ${params} "${url}"
}
export -f sam::core::http::get

#######################################
# Downloads a file.
# Globals:
#   None
# Arguments:
#   URL
#   Complete destination path
# Returns:
#   None
#######################################
sam::core::http::download() {
    local url=${1:-}
    local destination=${2:-}
    local params

    if sam::core::is_debug_enabled; then
        params='-v'
    else
        params='--silent'
    fi

    curl --location --fail --show-error ${params} --output "${destination}" "${url}"
}
export -f sam::core::http::download
