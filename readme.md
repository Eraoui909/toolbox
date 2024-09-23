This is how your `sqlcl/secrets.sh` file should look:

```

#!/bin/bash 


DATABASES=(
    "CONN_NAME | CONN_STRING"
) 

declare SQLCL_VERSIONS=(
    "SQLcl Version | Binary Path"
)

```