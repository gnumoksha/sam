#
# tar processor
#

#######################################
# Install the specified tar file.
# Globals:
#   None
# Arguments:
#   file path
# Returns:
#   None
#######################################
sam::processor::tar::install() {
    local file=${1:-}
    sam::core::logger::info "Installing $file"
    echo "TODO"
    exit 1
}
