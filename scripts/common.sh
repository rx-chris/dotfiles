#!/bin/bash

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}🚀 $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

execute_quietly() {
    local task_name=$1
    shift
    echo -n "⏳ $task_name... "
    if "$@" > /dev/null 2>&1; then
        echo -e "${GREEN}Done!${NC}"
    else
        echo -e "${RED}Failed!${NC}"
        return 1
    fi
}
