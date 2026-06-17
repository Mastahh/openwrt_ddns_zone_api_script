#!/bin/sh

# Use Command for testing
# /usr/lib/ddns/dynamic_dns_updater.sh -S service_name -v 1

local __URL="https://api.zone.eu/v2/dns/[DOMAIN]/a/[PARAMOPT]"
local __TOKEN="[USERNAME]:[PASSWORD]"
local __JSON_DATA='{"destination":"[IP]"}'


# inside url we need domain, username and password
[ -z "$domain" ]   && write_log 14 "Service section not configured correctly! Missing 'domain'"
[ -z "$username" ] && write_log 14 "Service section not configured correctly! Missing 'username'"
[ -z "$password" ] && write_log 14 "Service section not configured correctly! Missing 'password'"
[ -z "$param_opt" ] && write_log 14 "Service section not configured correctly! Missing 'param_opt'"

# do replaces in URL
__URL=$(echo $__URL | sed -e "s#\[PARAMOPT\]#$param_opt#g" -e "s#\[DOMAIN\]#$domain#g")

# do replaces in JSON_DATA
__JSON_DATA=$(echo $__JSON_DATA | sed -e "s#\[IP\]#$__IP#g")

# do replaces in TOKEN
__TOKEN=$(echo -n $__TOKEN | sed -e "s#\[USERNAME\]#$URL_USER#g" -e "s#\[PASSWORD\]#$URL_PASS#g" | base64 -w 0)
	
http_code=$(curl -s -o /dev/null -w "%{http_code}" \
		-X PUT "$__URL" \
		-H "Authorization: Basic $__TOKEN" \
		-H "Content-Type: application/json" \
		-d "$__JSON_DATA")
 
if [ "$http_code" = "200" ]; then
    return 0
else
    return 1
fi