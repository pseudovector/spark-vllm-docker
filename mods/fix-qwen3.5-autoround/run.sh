#!/bin/bash
set -e

# This patch fixes a type error in transformers' rope validation.
# In transformers >= 5.1.0, the bug was fixed upstream, so skip gracefully.
if grep -q 'ignore_keys_at_rope_validation = ignore_keys_at_rope_validation | {"partial_rotary_factor"}' \
    /usr/local/lib/python3.12/dist-packages/transformers/modeling_rope_utils.py 2>/dev/null; then
    patch -p1 -d /usr/local/lib/python3.12/dist-packages < transformers.patch
    echo "Patch applied successfully."
else
    echo "Patch not needed (already fixed upstream). Skipping."
fi
