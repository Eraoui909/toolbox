#!/bin/bash

## =============================================================================
## NAME
##   workspace/structure.sh
##
## DESCRIPTION
##   This script used to generate the workspace folder structure
##
## Example:
##            Workspace
##                    ├── development  // Dedicated to store work-related repositories
##                    ├── external     // Dedicated to store personal-related repositories
##                    ├── opensource   // Dedicated to store opensource-related repositories
##                    ├── repo         // Dedicated to store all the third-party tools, libs...
##                    ├── resources    // Dedicated to store all resources (Courses, PDFs, Books...)
##                    ├── toolbox      // Dedicated to the toolbox repository
##                    └── trash        // Dedicated to store tempoprary work that could be deleted anytime
##
## MODIFIED   (MM/DD/YYYY)
##   Hamza Eraoui  09/14/2024 created
##   Hamza Eraoui  12/27/2024 modified
##
## =============================================================================

source $HOME/Workspace/toolbox/utils/colors.sh

workspace_dir="$HOME/Workspace"

function create_workspace_structure() {

    if [[ -d "$workspace_dir" ]]; then
        error "Workspace directory already exists."
    else
        mkdir -p "$workspace_dir"
    fi

    for dir in development external opensource repo resources toolbox trash; do
        dir_path="$workspace_dir/$dir"
        if [[ ! -d "$dir_path" ]]; then
            mkdir -p "$dir_path"
            info "Created directory: $dir_path"
        fi
    done
} 

create_workspace_structure