#!/bin/bash 

# =====================================
# Database Connection Script for SQLcl
# =====================================

source $HOME/Workspace/toolbox/sqlcl/secrets.sh

info() { echo -e "\033[32m$*\033[0m"; }
warning() { echo -e "\033[33m$*\033[0m"; }
error() { echo -e "\033[31m$*\033[0m"; }

choose_database() {
    echo -e "\n"
    echo "Available Databases:"
    echo "-----------------------"
    for i in "${!DATABASES[@]}"; do
        IFS='|' read -r name link <<< "${DATABASES[$i]}"
        info "$((i+1)) - $name"
    done
    echo "-----------------------"

    # Prompt user for selection and validate input in a loop
    while true; do

        read -p "Choose a database (default is NOLOG): " selection

        if [[ -z "$selection" ]]; then
            selection=1
            break
        fi
        
        # Validate input
        if [[ ! "$selection" =~ ^[0-9]+$ ]]; then
            error "Invalid selection. Please enter a number."
            continue
        fi

        if [[ "$selection" -lt 1 || "$selection" -gt "${#DATABASES[@]}" ]]; then
            error "Database number out of range."
            continue
        fi

        # Valid selection, break the loop
        break

    done

    # Return chosen database
    IFS='|' read -r name link <<< "${DATABASES[$((selection-1))]}"
    echo "Connecting to $name"
    # ... (code to connect to the database)
}

choose_sqlcl_versions() {
    local valid_choices

    echo -e "\n"
    echo "Available SQLcl Versions:"
    echo "-----------------------"
    for i in "${!SQLCL_VERSIONS[@]}"; do
        IFS='|' read -r sqlcl_name sqlcl_version <<< "${SQLCL_VERSIONS[$i]}"
        info "$i - $sqlcl_name"
        valid_choices="$valid_choices $i"
    done
    echo "-----------------------"

    while true; do
        read -p "Select the SQLcl version (default is latest): " version
        if [[ -z "$version" ]]; then
            version=0
            break
        elif [[ "$valid_choices" =~ "$version" ]]; then
            break
        else
            error "Invalid choice. Please enter a valid number."
        fi
    done


    # ... (rest of your code using the chosen version)
}


# Function to connect to the selected database
connect_db() {
    local version=$1
    local selection=$2

    echo -e "\n"

    if [[ $selection -lt 1 || $selection -gt ${#DATABASES[@]} ]]; then
        error "Invalid selection."
        exit 1
    fi

    #Get SQLcl version
    IFS='|' 
    read -r sqlcl_name sqlcl_version <<< "${SQLCL_VERSIONS[$((version))]}"

    # Get the selected database config
    read -r name link <<< "${DATABASES[$((selection-1))]}"

    info "Connecting to $name using $sqlcl_name..."

    # Execute the SQLcl connection
    eval "$sqlcl_version" "$link"
}

# Main script execution
choose_sqlcl_versions
choose_database

# Connect to the selected database
connect_db "$version" "$selection"