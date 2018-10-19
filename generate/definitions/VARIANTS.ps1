# Docker image variants' definitions
$VARIANTS_VERSION = "1.0.0"
$VARIANTS = @(
    @{
        name = 'bare'
        includeEntrypointScript = $true
    }
    @{
        name = 'openssl'
        includeEntrypointScript = $true
    }
    @{
        name = 'mysqlclient'
        includeEntrypointScript = $true
    }
    @{
        name = 'mysqlclient-openssl'
        includeEntrypointScript = $true
    }
)

# Intelligently add properties
$VARIANTS | % {
    $_['version'] = $VARIANTS_VERSION
    $_['extensions'] = $_['name'] -split '-' | ? { $_.Trim() }
}

# Send definitions down the pipeline
$VARIANTS