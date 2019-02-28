#
# Database
#

if [[ -z "${SAM_HOME}" ]]; then
    echo SAM_HOME is undefined
    exit 1
fi

SAM_DATABASE=${SAM_HOME}/db.sh
if [[ ! -e "${SAM_DATABASE}" ]]; then
    touch "${SAM_DATABASE}"
fi

declare -A SAN_ARTIFACTS

declare -A SAN_CURRENT_ARTIFACT
SAN_CURRENT_ARTIFACT['NAME']=
SAN_CURRENT_ARTIFACT['TYPE']=
SAN_CURRENT_ARTIFACT['UPSTREAM_VERSION']=
SAN_CURRENT_ARTIFACT['LOCAL_VERSION']=
SAN_CURRENT_ARTIFACT['DIR']=
SAN_CURRENT_ARTIFACT['PATH']=

encode_array() { declare -n __p="$1"; for k in "${!__p[@]}"; do printf "[%s]='%s' " "$k" "${__p[$k]}" ; done ;  }

sam::core::database::set_name() {
    SAN_CURRENT_ARTIFACT['NAME']=${1}
}
sam::core::database::set_type() {
    SAN_CURRENT_ARTIFACT['TYPE']=${1}
}
sam::core::database::set_upstream_version() {
    SAN_CURRENT_ARTIFACT['UPSTREAM_VERSION']=${1}

    source ${SAM_DATABASE} # load the database

    name=${SAN_CURRENT_ARTIFACT['NAME']}
    if [[ ${SAN_ARTIFACTS[$name]+_} ]]; then
        value=$(echo "${SAN_ARTIFACTS[$name]}")
        eval "declare -A STORED=(${value})"

        if [[ ${SAN_CURRENT_ARTIFACT['UPSTREAM_VERSION']} == ${STORED['UPSTREAM_VERSION']} ]]; then
            sam::core::logger::info "${SAN_CURRENT_ARTIFACT['NAME']} is up to date."
            exit 0
        fi
    fi
}
sam::core::database::set_local_version() {
    SAN_CURRENT_ARTIFACT['LOCAL_VERSION']=${1}
}
#sam::core::database::set_dir() {
#    SAN_CURRENT_ARTIFACT['DIR']=${1}
#}
#sam::core::database::set_PATH() {
#    SAN_CURRENT_ARTIFACT['PATH']=${1}
#}

sam::core::database::save() {
    local name

    source ${SAM_DATABASE} # load the database

    unset SAN_CURRENT_ARTIFACT['DIR']
    unset SAN_CURRENT_ARTIFACT['PATH']

    name=${SAN_CURRENT_ARTIFACT['NAME']}
    SAN_ARTIFACTS[$name]=$(encode_array SAN_CURRENT_ARTIFACT)
    typeset -p SAN_ARTIFACTS > ${SAM_DATABASE} # update the database
}
