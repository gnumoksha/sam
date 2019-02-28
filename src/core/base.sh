#
# The most basic stuff for SAM
#

# Global variables
SAM_HOME=${SAM_HOME:-}
SAM_DEBUG=${SAM_DEBUG:-}
SAM_VERSION='0.0.1-beta'

if [[ -z "${SAM_HOME}" ]]; then
    SAM_HOME=${XDG_DATA_HOME:=${HOME}/.local/share}/sam
fi

if [[ ! -d "$SAM_HOME" ]]; then
    mkdir -p "$SAM_HOME"
fi

#######################################
# Whether or not the debugging is enabled.
# Globals:
#   SAM_DEBUG
# Arguments:
#   some message
# Returns:
#   boolean
#######################################
sam::core::is_debug_enabled() {
    [[ "${SAM_DEBUG:-}" == "true" ]]
}
export -f sam::core::is_debug_enabled

if sam::core::is_debug_enabled; then
    set -x
fi
