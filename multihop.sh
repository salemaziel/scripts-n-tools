#!/bin/bash

#


DNS_LEAK_PROTECTION=on
function usage {
 echo "See https://cryptostorm.is/multihop for instructions."
}
if [[ ${hopid} == "" ]]; then
 hopid=1
fi
if [[ ${prevgw} == "" ]]; then
 if [[ ${hopid} -eq 1 ]]; then
  prevgw=${route_net_gateway}
 else
  echo "You forgot to set the previous gateway IP."
  usage
  exit 1
 fi
fi
if [[ "$script_type" == "up" ]]; then
 ad="add"
elif [[ "$script_type" == "down" ]];then
 ad="delete"
else
 echo "Don't run this script directly"
 usage
 exit 1
fi
IP=`command -v ip`
eval "$IP route $ad $route_network_1 via $prevgw"
for (( i=0; i < $((2 ** $hopid)); i++ )); do
 net="$(( $i << (8 - $hopid) )).0.0.0/$hopid"
 eval "$IP route $ad $net via $route_vpn_gateway"
done
if [[ "$script_type" == "up" ]]; then
 next_hopid=$((hopid+1))
 next_gw=${route_vpn_gateway}
 next_lport=$((local_port_1+1))
 cur_dns=`echo $foreign_option_1|awk '{print $3}'`
 echo ""
 echo "MULTIHOP HINT:"
 echo "For the next hop, start openvpn with:"
 echo ""
 echo "openvpn --config <config.ovpn> --script-security 2 --route remote_host --persist-tun --up $0 --down $0 --route-noexec --setenv prevdns $cur_dns --setenv hopid $next_hopid --setenv prevgw $next_gw --lport $next_lport"
 echo ""
 if [[ "$DNS_LEAK_PROTECTION" == "on" ]]; then
  if [[ "$prevdns" != "" ]]; then
   iptables -t nat -D OUTPUT -p udp --dport 53 -j DNAT --to-destination $prevdns
   iptables -t nat -D OUTPUT -p tcp --dport 53 -j DNAT --to-destination $prevdns
  fi
  iptables -t nat -A OUTPUT -p udp --dport 53 -j DNAT --to-destination $cur_dns
  iptables -t nat -A OUTPUT -p tcp --dport 53 -j DNAT --to-destination $cur_dns
  echo "DNS Leak Protection: Enabled"
 fi
fi
if [[ "${script_type}" == "down" ]]; then
 if [[ "$DNS_LEAK_PROTECTION" == "on" ]]; then
  cur_dns=`echo $foreign_option_1|awk '{print $3}'`
  iptables -t nat -D OUTPUT -p udp --dport 53 -j DNAT --to-destination $cur_dns
  iptables -t nat -D OUTPUT -p tcp --dport 53 -j DNAT --to-destination $cur_dns
  echo "DNS Leak Protection: Removed DNS IP $cur_dns"
  if [[ $hopid != 1 ]]; then
   iptables -t nat -A OUTPUT -p udp --dport 53 -j DNAT --to-destination $prevdns
   iptables -t nat -A OUTPUT -p tcp --dport 53 -j DNAT --to-destination $prevdns
   echo "DNS Leak Protection: Added DNS IP $prevdns"
  else
   iptables -t nat -F
  fi
 fi
fi
