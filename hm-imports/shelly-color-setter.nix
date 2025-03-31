{ config, pkgs, scheme, ... }:

let
  # Point to your script file location
  setBase00ColorScript = ''
	HEX=${scheme.base00}
	if [[ ! "$HEX" =~ ^[0-9a-fA-F]{6}$ ]]; then
	  echo "Invalid hex color: $HEX"
	  exit 1
	fi
	if [[ ! "$HEX" =~ ^[0-9a-fA-F]{6}$ ]]; then
	  echo "Invalid hex color: $HEX"
	  exit 1
	fi
	RED=$((16#${HEX:0:2}))
	GREEN=$((16#${HEX:2:2}))
	BLUE=$((16#${HEX:4:2}))
	WHITE=0

	# Send the HTTP request
	# you know now I have one Shelly Device in my home.
	# clean on opsec
	URL="http://10.0.0.26/color/0?turn=on&red=$RED&green=$GREEN&blue=$BLUE&white=$WHITE"

	echo "Sending request to $URL"
	${pkgs.curl}/bin/curl -s "$URL"
  '';
in {
  home.packages = [
    (pkgs.writeShellScriptBin "setShellyTheme" setBase00ColorScript)
  ];
}

