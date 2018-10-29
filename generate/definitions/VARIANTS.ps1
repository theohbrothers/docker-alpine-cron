# Docker image variants' definitions
$VARIANTS_VERSION = "1.0.1"
$VARIANTS = @(
    @{
        tag = 'bare'
        distro = 'alpine'
    }
    @{
        tag = 'openssl'
        distro = 'alpine'
    }
    @{
        tag = 'mysqlclient'
        distro = 'alpine'
    }
    @{
        tag = 'mysqlclient-openssl'
        distro = 'alpine'
    }
)

# Docker image variants' definitions (shared)
$VARIANTS_SHARED = @{
    version = $VARIANTS_VERSION
    buildContextFiles = @{
        templates = @{
            'Dockerfile' = @{
                common = $false
                includeHeader = $true
                includeFooter = $true
                passes = @(
                    @{
                        variables = @{}
                    }
                )
            }
            'docker-entrypoint.sh' = @{
                common = $true
                passes = @(
                    @{
                        variables = @{}
                    }
                )
            }
        }
    }
}

# Send definitions down the pipeline
$VARIANTS