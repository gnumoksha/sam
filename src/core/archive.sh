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
		sam::core::archive::extract_zip "$filename" "$destination"
		return
	fi

	if [[ ${filename} =~ .*tar\.gz$ ]]; then
		sam::core::archive::extract_tar "$filename" "$destination"
		return
	fi

	if [[ ${extension} == 'tgz' ]]; then
		sam::core::archive::extract_tar "$filename" "$destination"
		return
	fi

	if [[ ${extension} == 'tar' ]]; then
		sam::core::archive::extract_tar "$filename" "$destination"
		return
	fi

	if [[ ${extension} == 'xz' ]]; then
		sam::core::archive::extract_tar "$filename" "$destination"
		return
	fi

	if [[ ${extension} == 'gz' ]]; then
		sam::core::archive::extract_gzip "$filename" "$destination"
		return
	fi

	false
}

sam::core::archive::extract_zip() {
	local filename=${1:-}
	local destination=${2:-}
	unzip -o -q "$filename" -d "$destination"
}

sam::core::archive::extract_tar() {
	local filename=${1:-}
	local destination=${2:-}
	tar --extract --file "$filename" --directory "$destination"
}

sam::core::archive::extract_gzip() {
	local filename=${1:-}
	local destination=${2:-}

	pushd "$destination" 2>/dev/null
	gunzip "$filename"
	popd "$destination" 2>/dev/null
}
