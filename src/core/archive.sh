#
# Functions related to file archives.
#

sam::core::archive::can_extract() {
    local file=${1:-}
    local extension
    sam::core::file::get_extension "${file}" extension
    [[ "$extension" =~ ^(zip|tar|gz|tgz|xz)$ ]]
}

sam::core::archive::extract() {
	local filename=${1:-}
	local destination=${2:-}
	local extension

    sam::core::file::get_extension "${filename}" extension
	destination=$(dirname ${destination})

	if [[ ${extension} == 'zip' ]]; then
		extract_zip "$filename" "$destination"
		return
	fi

	false
}

sam::core::archive::extract_zip() {
	local filename=${1:-}
	local destination=${2:-}
	unzip -o -q "$filename" -d "$destination"
}
