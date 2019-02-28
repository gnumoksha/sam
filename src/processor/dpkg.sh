#
# Dpkg processor
#

#######################################
# Install the specified deb file.
# Globals:
#   None
# Arguments:
#   file path
# Returns:
#   None
#######################################
sam::processor::dpkg::install() {
    local file=${1:-}
    sam::core::logger::info "Installing $file"
    sudo dpkg --install "${file}"
}
