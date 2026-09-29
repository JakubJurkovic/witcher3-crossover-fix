#!/bin/zsh
# Witcher 3 Remastered 5.00b black-screen fix for CrossOver (D3DMetal).
# Usage: double-click, or run: ./install.command ["/path/to/The Witcher 3/bin/x64_dx12"]
set -e
here=${0:A:h}
dll="$here/amd_fidelityfx_loader_dx12.dll"
[ -f "$dll" ] || { echo "amd_fidelityfx_loader_dx12.dll must sit next to this script."; exit 1; }

if [ -n "$1" ]; then
  dirs=("$1")
else
  # Search every CrossOver bottle for the DX12 game folder (GOG, Steam, EA, ...).
  dirs=("${(@f)$(find "$HOME/Library/Application Support/CrossOver/Bottles" -path "*/bin/x64_dx12/witcher3.exe" 2>/dev/null | sed 's|/witcher3.exe$||')}")
fi
dirs=(${dirs:#})
[ ${#dirs} -gt 0 ] || { echo "Witcher 3 (bin/x64_dx12/witcher3.exe) not found. Pass the x64_dx12 folder as an argument."; exit 1; }

for d in "${dirs[@]}"; do
  echo "Patching: $d"
  [ -f "$d/amd_fidelityfx_loader_dx12.dll" ] || { echo "  no amd_fidelityfx_loader_dx12.dll here, skipping (not 5.00b?)"; continue; }
  # Keep the real FidelityFX loader under a new name, unless the proxy is already installed.
  if ! grep -q "ffxproxy" "$d/amd_fidelityfx_loader_dx12.dll"; then
    mv -f "$d/amd_fidelityfx_loader_dx12.dll" "$d/amd_fidelityfx_loader_dx12_orig.dll"
  fi
  cp "$dll" "$d/amd_fidelityfx_loader_dx12.dll"
  # CrossOver silently redirects bin\x64_dx12\witcher3.exe to bin\x64\witcher3.exe (the DX11
  # build, which 5.00b no longer ships). Point that path at the DX12 build.
  bin="${d:h}"
  if [ ! -e "$bin/x64" ]; then
    ln -s x64_dx12 "$bin/x64"
    echo "  created bin/x64 -> x64_dx12"
  fi
  echo "  done"
done
echo "Fix installed. Launch the game as usual."
