#
# Functions related to logging.
#

#######################################
# Sends a debug message to stdout.
# Globals:
#   None
# Arguments:
#   some message
# Returns:
#   None
#######################################
sam::core::logger::debug() {
    if sam::core::is_debug_enabled; then
        echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')] [debug]: $@"
    fi
}
export -f sam::core::logger::debug

#######################################
# Sends an info message to stdout.
# Globals:
#   None
# Arguments:
#   some message
# Returns:
#   None
#######################################
sam::core::logger::info() {
    echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')] [info]: $@"
}
export -f sam::core::logger::info

#######################################
# Sends an error message to stderr.
# Globals:
#   None
# Arguments:
#   some message
# Returns:
#   None
#######################################
sam::core::logger::error() {
    echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')] [error]: $@" >&2
}
export -f sam::core::logger::error
