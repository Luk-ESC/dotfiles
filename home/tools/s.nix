{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "s" ''
      WIFI_NAME="L Diablo"

      # 1. Check current WiFi
      CURRENT_WIFI=$(nmcli -t -f active,ssid dev wifi | grep '^yes:' | cut -d: -f2)

      if [[ "$CURRENT_WIFI" != "$WIFI_NAME" ]]; then
        echo "Not connected to $WIFI_NAME. Connecting..."
        nmcli dev wifi connect "$WIFI_NAME" || {
          echo "Failed to connect to $WIFI_NAME"
          return 1
        }

        # wait until connection is active
        for i in {1..10}; do
          sleep 1
          CURRENT_WIFI=$(nmcli -t -f active,ssid dev wifi | grep '^yes:' | cut -d: -f2)
          [[ "$CURRENT_WIFI" == "$WIFI_NAME" ]] && break
        done
      else
        echo "Already connected to $WIFI_NAME"
      fi

      # 2. Get IP address (active connection)
      IP=$(nmcli -t -f IP4.ADDRESS dev show | grep -m1 'IP4.ADDRESS' | cut -d: -f2 | cut -d/ -f1)

      if [[ -z "$IP" ]]; then
        echo "Failed to get IP address"
        return 1
      fi

      OCTET2=$(echo "$IP" | cut -d. -f2)
      OCTET3=$(echo "$IP" | cut -d. -f3)

      # 3. SSH
      TARGET="10.$OCTET2.$OCTET3.63"
      echo "Connecting to hannah@$TARGET ..."
      ssh hannah@"$TARGET"
    '')
  ];
}
