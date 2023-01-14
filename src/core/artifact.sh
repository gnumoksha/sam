#
# Functions related to the artifact
# itself.
#

#######################################
# Download the artifact.
# Globals:
#   SAN_CURRENT_ARTIFACT
# Arguments:
#   URL
# Returns:
#   None
#######################################
sam::core::artifact::download() {
    local url=${1:-}
    local filename

    filename=$(basename ${url})
    SAN_CURRENT_ARTIFACT['DIR']=$(mktemp -d)
	SAN_CURRENT_ARTIFACT['PATH']=${SAN_CURRENT_ARTIFACT['DIR']}/${filename}

    sam::core::logger::debug "Downloading artifact from ${url} to ${SAN_CURRENT_ARTIFACT['PATH']}..."

    sam::core::http::download "${url}" "${SAN_CURRENT_ARTIFACT['PATH']}"
}

#######################################
# Tries to handle the downloaded
# artifact.
# Globals:
#   SAN_CURRENT_ARTIFACT
# Arguments:
#   None
# Returns:
#   None
#######################################
sam::core::artifact::handle() {
    if [[ ! ${SAN_CURRENT_ARTIFACT['PATH']+_} ]]; then
        sam::core::logger::error "Artifact not defined."
        exit 1
    fi

	local extension=
	local tmp_destination=
	local artifact_path=${SAN_CURRENT_ARTIFACT['PATH']}

	tmp_destination=$(mktemp -d)

	sam::core::logger::debug "Handling the artifact ${artifact_path}"

	sam::core::file::get_extension "${artifact_path}" extension

    if sam::core::archive::can_extract "${artifact_path}"; then
        sam::core::archive::extract "${artifact_path}" "${tmp_destination}"
        # TODO move to /usr/local/bin?
        rm "${artifact_path}"
    elif [[ "${extension}" == 'deb' ]]; then
        sam::processor::dpkg::install "${artifact_path}"
        rm "${artifact_path}"
    elif [[ "${extension}" == 'rpm' ]]; then
        sam::processor::rpm::install "${artifact_path}"
        rm "${artifact_path}"
    else
        mv "${artifact_path}" "$tmp_destination"
    fi

    rmdir ${tmp_destination}

    # the artifact was handled and now the local version is equal to upstream version
    sam::core::database::set_local_version ${SAN_CURRENT_ARTIFACT['UPSTREAM_VERSION']}
    sam::core::database::save
}
