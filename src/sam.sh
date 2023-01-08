#!/usr/bin/env bash
set -euo pipefail
export IFS=$'\n\t'

BIN_FILE=./../bin/sam

SOURCES=(
./core/base.sh
./core/logger.sh
./core/file.sh
./core/archive.sh
./core/http.sh
./core/database.sh
./processor/dpkg.sh
./processor/rpm.sh
./processor/font.sh
./core/artifact.sh
./provider/github-release.sh
./core/main.sh
)

for file in "${SOURCES[@]}"; do
    source "${file}"
done

if [[ "${1:-}" != '--build' ]]; then
    main "$@"
else
    sam::core::logger::info "Building SAM into a single file..."
    echo '#!/usr/bin/env bash' > ${BIN_FILE}
    echo "set -euo pipefail" >> ${BIN_FILE}
    echo "export IFS=$'\n\t'" >> ${BIN_FILE}

    for file in "${SOURCES[@]}"; do
        echo "# Source: ${file}" >> ${BIN_FILE}
        cat "${file}" >> ${BIN_FILE}
        echo "" >> ${BIN_FILE}
    done

    echo 'main "$@"' >> ${BIN_FILE}
    chmod +x ${BIN_FILE}

    sam::core::logger::info "Done"
    exit 0
fi
