#
# Main function.
#
main() {
    sam::core::logger::debug "Starting"

    declare -A SAN_PARSED_ARGUMENTS
    SAN_PARSED_ARGUMENTS[INSTALL]=
    SAN_PARSED_ARGUMENTS[FROM]=
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

        sam::provider::github_release::get_latest "${SAN_PARSED_ARGUMENTS[INSTALL]}" "${SAN_PARSED_ARGUMENTS[FILTER]}"
        sam::core::artifact::handle
    fi
}
