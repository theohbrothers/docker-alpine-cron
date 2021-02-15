$local:VARIANTS_DISTRO_VERSIONS = @(
    '3.12'
    '3.11'
    '3.10'
    '3.9'
    '3.8'
)
# Docker image variants' definitions
$local:VARIANTS_MATRIX = @(
    foreach ($v in $local:VARIANTS_DISTRO_VERSIONS) {
        @{
            distro = 'alpine'
            distro_version =  $v
            subvariants = @(
                @{ components = @(); tag_as_latest = if ($v -eq $v -eq $local:VARIANTS_DISTRO_VERSIONS[0]) { $true } else { $false } }
                @{ components = @( 'mysqlclient' ) }
                @{ components = @( 'openssl' ) }
                @{ components = @( 'mysqlclient', 'openssl' ) }
            )
        }
    }
)
$VARIANTS = @(
    foreach ($variant in $VARIANTS_MATRIX){
        foreach ($subVariant in $variant['subvariants']) {
            @{
                # Metadata object
                _metadata = @{
                    distro = $variant['distro']
                    distro_version = $variant['distro_version']
                    components = $subVariant['components']
                }
                # Docker image tag. E.g. '3.8-openssl'
                tag = @(
                        $variant['distro_version']
                        $subVariant['components'] | ? { $_ }
                ) -join '-'
                tag_as_latest = if ( $subVariant.Contains('tag_as_latest') ) {
                                    $subVariant['tag_as_latest']
                                } else {
                                    $false
                                }
            }
        }
    }
)

# Docker image variants' definitions (shared)
$VARIANTS_SHARED = @{
    buildContextFiles = @{
        templates = @{
            'Dockerfile' = @{
                common = $true
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
