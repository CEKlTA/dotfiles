wpctl status \
| awk '/Sinks/ {found=1} found && /\*/ {print; exit}' \
| sed -E 's/(^.+\s)(\S+(\s\S+)*)\s+(\[vol:\s(\S+)(\s(MUTED))?\])/{\"name\":\"\2\",\"volume\":\5,\"muted\":false\7}/;s/falseMUTED/true/'