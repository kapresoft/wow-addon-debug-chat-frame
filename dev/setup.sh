#!/usr/bin/env zsh

BUILD_DIR=./.release
RELEASE_SCRIPT=./dev/release.sh
TOC_FILE="setup.toc"
PKGMETA_FILE="setup.yml"

ts() {
  date '+[%Y-%m-%d %H:%M:%S]'
}

p() {
  printf '%s %5s: %s\n' "$(ts)" "$1" "$2"
}

ensure_dir() {
  local dir="$1"

  if [[ ! -d "$dir" ]]; then
    p "Executing" "mkdir -p $dir"
    mkdir -p "$dir"
  fi
}
ensure_file() {
  local file="$1"
  [[ -f "$file" ]] && return 0
  return "$?"
}

# Options:
# -d  Skip uploading.
# -u  Use Unix line-endings.
# -z  Skip zip file creation.
# -r  releasedir    Set directory containing the package directory. Defaults to "$topdir/.release".
# -m  pkgmeta.yaml  Set the pkgmeta file to use.
_Release() {
    local pkgmeta_path="./dev/${PKGMETA_FILE}"

    ensure_dir "$BUILD_DIR"
    cp "${pkgmeta_path}" "_${PKGMETA_FILE}" || {
      echo "Missing: ${pkgmeta_path}"
      return 1
    }
    ensure_file "./_${PKGMETA_FILE}" || {
      p "Missing: $file"
      return 1
    }
    cp ./dev/${TOC_FILE} _${TOC_FILE}

    local args="-dz -r ${BUILD_DIR} -m _${PKGMETA_FILE}"
    local cmd="${RELEASE_SCRIPT} ${args}"
    p INFO "Executing: ${cmd}"
    (eval "${cmd}" && p INFO "Execution Complete: ${cmd}") || {
      p ERROR "Run failed."
      return 1
    }
    sleep 1 && p INFO "Cleaning up..." && {
      rm _${PKGMETA_FILE}
      rm _${TOC_FILE}
      rm -f "${BUILD_DIR}/_setup/CHANGELOG.md" \
        && sleep 0.5 \
        && rmdir "${BUILD_DIR}/_setup"
    }
}

_Release
