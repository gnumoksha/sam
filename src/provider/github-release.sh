#
# Provider for getting GitHub releases.
#
# @see https://help.github.com/en/articles/about-releases

#######################################
# Downloads the latest release artifact
# of the project identified by the
# supplied namespace.
# file.
# Globals:
#   None
# Arguments:
#   namespace
#   regex
# Returns:
#   None
#######################################
sam::provider::github_release::get_latest() {
    local namespace=${1:-}
    local regex=${2:-}
    local id link

    id=$(sam::provider::github_release::get_latest_id ${namespace})
    sam::core::database::set_upstream_version "${id}"

    link=$(sam::provider::github_release::asset_url ${namespace} ${id} ${regex})

    sam::core::artifact::download "${link}"
}
export -f sam::provider::github_release::get_latest

#######################################
# Returns the ID for the latest release
# of the project identified by the
# supplied namespace.
# Globals:
#   None
# Arguments:
#   namespace
# Returns:
#   None
#######################################
sam::provider::github_release::get_latest_id() {
    local namespace=${1:-}
    sam::core::http::get "https://api.github.com/repos/${namespace}/releases/latest" \
        | grep --only-matching --perl-regexp '"id": \K(.*)(?=,)' \
        | head -1 # --max-count=1 does not work
}
export -f sam::provider::github_release::get_latest_id

#######################################
# Returns the asset url that matches
# $regex.
# Globals:
#   None
# Arguments:
#   namespace
#   release id
#   regex
# Returns:
#   None
#######################################
sam::provider::github_release::asset_url() {
    local namespace=${1:-}
    local id=${2:-}
    local regex=${3:-}
    sam::core::http::get "https://api.github.com/repos/${namespace}/releases/${id}/assets" \
        | grep --only-matching --perl-regexp '"browser_download_url": "\K(.*)(?=")' \
        | grep --perl-regexp ${regex}
}
export -f sam::provider::github_release::asset_url
