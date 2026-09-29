#!/bin/zsh
# Removes the Witcher 3 5.00b CrossOver fix and restores the original files.
# Usage: double-click, or run: ./uninstall.command ["/path/to/The Witcher 3/bin/x64_dx12"]
set -e
if [ -n "$1" ]; then
  dirs=("$1")
else
  dirs=("${(@f)$(find "$HOME/Library/Application Support/CrossOver/Bottles" -path "*/bin/x64_dx12/amd_fidelityfx_loader_dx12_orig.dll" 2>/dev/null | sed 's|/amd_fidelityfx_loader_dx12_orig.dll$||')}")
fi
dirs=(${dirs:#})
[ ${#dirs} -gt 0 ] || { echo "No patched Witcher 3 install found."; exit 0; }

for d in "${dirs[@]}"; do
  echo "Restoring: $d"
  if [ -f "$d/amd_fidelityfx_loader_dx12_orig.dll" ]; then
    mv -f "$d/amd_fidelityfx_loader_dx12_orig.dll" "$d/amd_fidelityfx_loader_dx12.dll"
  fi
  bin="${d:h}"
  [ -L "$bin/x64" ] && rm "$bin/x64"
  echo "  done"
done
