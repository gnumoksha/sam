#
# Functions to manipulate files.
#

#######################################
# Gets the file extension.
# Globals:
#   None
# Arguments:
#   filename
#   result - variable that will hold the returned value
# Returns:
#   None
#######################################
sam::core::file::get_extension() {
    local filename=${1:-}
    local -n __result=${2:-}

    __result="${filename##*.}" # get the extension
    __result="${__result,,}" # to lower case
}
