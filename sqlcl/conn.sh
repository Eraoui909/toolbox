#!/bin/bash 

# =====================================
# Database Connection Script for SQLcl
# =====================================

declare SQLCL_VERSIONS=(
    "latest|/Users/heraoui/Workspace/development/dbtools-commons/sqlcl-distribution/target/sqlcl-*/sqlcl/bin/sql"
    "_23.3|$HOME/Workspace/repo/sqlcl_23.4/bin/sql"
)

# Array to hold database names and their corresponding links
# Each entry: "Name|Link"
DATABASES=(
    "NOLOG | /nolog"
    "DB23c-SE |system/WelcomeOrcl1@dbtools-dev.oraclecorp.com:2323/DB23P"
    "DB21c-EE-(CDB) |system/oracle@dbtools-dev.oraclecorp.com:2216/DB213P.dbtools-dev.oraclecorp.com"
    "DB21c-EE |system/oracle@dbtools-dev.oraclecorp.com:2213/DB213P"
    "DB19.19-EE |system/oracle@dbtools-dev.oraclecorp.com:2193/DB193P"
    "DB19.3-EE |system/oracle@dbtools-dev.oraclecorp.com:2194/DB193P"
    "DB21.3-EE-Dev-Team  |system/oracle@dbtools-dev.oraclecorp.com:2214/DB213P"
    "DB21.3-EE-ORDSCDB |system/oracle@dbtools-dev.oraclecorp.com:2215/DB213P.DBTOOLS-DEV"
    "DB18.3-EE |system/oracle@dbtools-dev.oraclecorp.com:2183/DB183P"
    "DB12.2-EE  |system/oracle@dbtools-dev.oraclecorp.com:2122/DB122P"
    "DB11.2-EE |system/oracle@dbtools-dev.oraclecorp.com:2112/orcl"
)

# Function to display the menu
display_menu() {


    echo "Available Databases:"
    echo "--------------------"
    for i in "${!DATABASES[@]}"; do
        IFS='|' read -r name link <<< "${DATABASES[$i]}"
        echo "$((i+1)). $name"
    done
    echo "--------------------"
}

choose_sqlcl_versions() {

    echo "SQLcl Version:"

    # for version in "${!SQLCL_VERSIONS[@]}"; do
    #     SQLCL_VERSION="${SQLCL_VERSIONS[$version]}"
    #     echo "===> $version: $SQLCL_VERSION"
    # done

    echo "--------------------"
    for i in "${!SQLCL_VERSIONS[@]}"; do
        IFS='|' read -r sqlcl_name sqlcl_version <<< "${SQLCL_VERSIONS[$i]}"
        echo "$i => $sqlcl_name"
    done
    echo "--------------------"

    read -p "Which version : " version
    ## add user entry check

}

# Function to connect to the selected database
connect_db() {
    local version=$1
    local selection=$2
    if [[ $selection -lt 1 || $selection -gt ${#DATABASES[@]} ]]; then
        echo "Invalid selection."
        exit 1
    fi

    #Get SQLcl version
    IFS='|' 
    read -r sqlcl_name sqlcl_version <<< "${SQLCL_VERSIONS[$((version))]}"

    # Get the selected database config
    read -r name link <<< "${DATABASES[$((selection-1))]}"

    echo "Connecting to $name using $sqlcl_name..."

    # Execute the SQLcl connection
    eval "$sqlcl_version" "$link"
}

# Main script execution
choose_sqlcl_versions
display_menu

# Prompt user for selection
read -p "connect to : " selection

# Connect to the selected database
connect_db "$version" "$selection"