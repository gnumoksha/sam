#
# rpm processor
#

#######################################
# Install the specified rpm file.
# Globals:
#   None
# Arguments:
#   file path
# Returns:
#   None
#######################################
sam::processor::rpm::install() {
    local file=${1:-}
    sam::core::logger::info "Installing $file"
    sudo rpm --install "${file}"
}
