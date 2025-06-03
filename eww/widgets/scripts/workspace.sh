socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock \
| grep --line-buffered "^workspace>>" \
| while read line;
    do
        echo {\"list\":$(hyprctl -j workspaces | jq -c '[.[] | .id]')\,\"active\":$(hyprctl -j activeworkspace | jq -c '.id')} \
        | jq -c '[range(1;11) as $i | {index: $i,in_use: (.list | index($i) != null),active: ($i == .active)}]';
    done