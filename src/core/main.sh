#
# Main function.
#
main() {
    sam::core::logger::debug "Starting"

    declare -A SAN_PARSED_ARGUMENTS
    SAN_PARSED_ARGUMENTS[INSTALL]=
    SAN_PARSED_ARGUMENTS[FROM]='github-release'
    SAN_PARSED_ARGUMENTS[FILTER]=
    SAN_PARSED_ARGUMENTS[AS]=

    for arg in "$@"; do
        case ${arg} in
            install=*)
                SAN_PARSED_ARGUMENTS[INSTALL]="${arg#*=}"
                shift
                ;;
            from=*)
                SAN_PARSED_ARGUMENTS[FROM]="${arg#*=}"
                shift
                ;;
            filter=*)
                SAN_PARSED_ARGUMENTS[FILTER]="${arg#*=}"
                shift
                ;;
            as=*)
                SAN_PARSED_ARGUMENTS[AS]="${arg#*=}"
                shift
                ;;
            *)
                echo "The option ${arg} is unknown."
                exit 1
                ;;
        esac
    done

    if [[ "${SAN_PARSED_ARGUMENTS[FROM]}" == 'github-release' ]]; then
        sam::core::database::set_name "${SAN_PARSED_ARGUMENTS[INSTALL]}"
        sam::core::database::set_type 'github_release'

        if [[ -z "${SAN_PARSED_ARGUMENTS[FILTER]}" ]]; then
            build_filter SAN_PARSED_ARGUMENTS[FILTER]
        fi

        sam::provider::github_release::get_latest "${SAN_PARSED_ARGUMENTS[INSTALL]}" "${SAN_PARSED_ARGUMENTS[FILTER]}"
        sam::core::artifact::handle
    else
        sam::core::logger::error "The value \"${SAN_PARSED_ARGUMENTS[FROM]}\" is not accepted in the \"from\" statement."
    fi
}

build_filter() {
    local -n __result=${1:-}

    arch=$(uname --machine)
    uses_dpkg=$(dpkg -l 2>/dev/null && echo "yes" || echo "no")
    uses_rpm=$(rpm -qa 2>/dev/null && echo "yes" || echo "no")

    if [[ "$uses_dpkg" != 'no' ]]; then
        extension="deb"
        if [[ $arch == 'x86_64' ]]; then
            arch='amd64'
        fi
    fi
    if [[ "$uses_rpm" != 'no' ]]; then
        extension="rpm"
    fi

    __result="$arch.$extension$"
}
