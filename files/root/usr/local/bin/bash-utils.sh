#! /bin/bash

import_script() {
  local file_source="$1"
  shift
  source "$file_source"
}
