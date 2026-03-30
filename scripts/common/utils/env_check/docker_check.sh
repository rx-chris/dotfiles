#!/usr/bin/env bash

is_docker() {
  [ -f /.dockerenv ] && return 0
  grep -qaE 'docker|containerd|kubepods' /proc/1/cgroup 2>/dev/null && return 0
  return 1
}
