#!/usr/bin/env bats

setup() {
  if [ -z ${ver+x} ]; then
    echo 'ver environment variable not set'
    exit 1
  fi
  tag="${ver}"
}

@test "alpine version is correct" {
  run docker run --rm --entrypoint=/bin/sh graze/bats:$tag -c 'cat /etc/os-release'
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [[ "${lines[2]}" == "VERSION_ID=3.6."* ]]
}

@test "bats version is correct" {
  run docker run --rm graze/bats:$tag --version
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [[ "$output" == "${ver}"* ]]
  [[ "$output" != *"-dev"* ]]
  [[ "$output" != *"-alpha"* ]]
  [[ "$output" != *"-beta"* ]]
}

@test "entrypoint is bats" {
  run bash -c "docker inspect graze/bats:$tag | jq -r '.[].Config.Entrypoint[]'"
  echo 'status:' $status
  echo 'output:' $output
  [ "$status" -eq 0 ]
  [ "$output" = "/usr/local/bin/bats" ]
}
