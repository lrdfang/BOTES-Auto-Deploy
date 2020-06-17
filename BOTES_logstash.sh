#!/bin/bash

############################################
#########BOTES-Auto-Deploy Script###########
############################################
# Made by Julian Hupp
############################################
# This script will auto deploy the BOTES
# Data set assembled and built by Sebastien 
# Lehuede via a Logstash Docker container.
# Used to ease deployment for Training 
# Purposes
############################################
# V 1.0 - First build for ES Cloud Installs
############################################

function dircheck()
{
	[ ! -d $PWD/pipeline ] && mkdir pipeline
	[ ! -d $PWD/upload ] && mkdir upload
	[ ! -d $PWD/upload/firewall ] && mkdir upload/firewall
	[ ! -d $PWD/upload/ids ] && mkdir upload/ids
	[ ! -d $PWD/upload/iis ] && mkdir upload/iis
	[ ! -d $PWD/upload/scanner ] && mkdir upload/scanner
	[ ! -d $PWD/upload/stream ] && mkdir upload/stream
	[ ! -d $PWD/upload/winevent ] && mkdir upload/winevent
}	
function pipelineimport()
{
	[ ! -f $PWD/pipeline/input-fgt_event.conf ] && wget -q --show-progress https://botes.s3-us-west-1.amazonaws.com/botes-logstash-configuration/full-config/input-fgt_event.conf -P "$PWD/pipeline/"
	[ ! -f $PWD/pipeline/input-fgt_traffic.conf ] && wget -q --show-progress https://botes.s3-us-west-1.amazonaws.com/botes-logstash-configuration/full-config/input-fgt_traffic.conf -P "$PWD/pipeline/"
	[ ! -f $PWD/pipeline/input-fgt_utm.conf ] && wget -q --show-progress https://botes.s3-us-west-1.amazonaws.com/botes-logstash-configuration/full-config/input-fgt_utm.conf -P "$PWD/pipeline/"
	[ ! -f $PWD/pipeline/input-iis.conf ] && wget -q --show-progress https://botes.s3-us-west-1.amazonaws.com/botes-logstash-configuration/full-config/input-iis.conf -P "$PWD/pipeline/"
	[ ! -f $PWD/pipeline/input-nessus.conf ] && wget -q --show-progress https://botes.s3-us-west-1.amazonaws.com/botes-logstash-configuration/full-config/input-nessus.conf -P "$PWD/pipeline/"
	[ ! -f $PWD/pipeline/input-stream-dhcp.conf ] && wget -q --show-progress https://botes.s3-us-west-1.amazonaws.com/botes-logstash-configuration/full-config/input-stream-dhcp.conf -P "$PWD/pipeline/"
	[ ! -f $PWD/pipeline/input-stream-dns.conf ] && wget -q --show-progress https://botes.s3-us-west-1.amazonaws.com/botes-logstash-configuration/full-config/input-stream-dns.conf -P "$PWD/pipeline/"
	[ ! -f $PWD/pipeline/input-stream-http.conf ] && wget -q --show-progress https://botes.s3-us-west-1.amazonaws.com/botes-logstash-configuration/full-config/input-stream-http.conf -P "$PWD/pipeline/"
	[ ! -f $PWD/pipeline/input-stream-icmp.conf ] && wget -q --show-progress https://botes.s3-us-west-1.amazonaws.com/botes-logstash-configuration/full-config/input-stream-icmp.conf -P "$PWD/pipeline/"
	[ ! -f $PWD/pipeline/input-stream-ip.conf ] && wget -q --show-progress https://botes.s3-us-west-1.amazonaws.com/botes-logstash-configuration/full-config/input-stream-ip.conf -P "$PWD/pipeline/"
	[ ! -f $PWD/pipeline/input-stream-ldap.conf ] && wget -q --show-progress https://botes.s3-us-west-1.amazonaws.com/botes-logstash-configuration/full-config/input-stream-ldap.conf -P "$PWD/pipeline/"
	[ ! -f $PWD/pipeline/input-stream-mapi.conf ] && wget -q --show-progress https://botes.s3-us-west-1.amazonaws.com/botes-logstash-configuration/full-config/input-stream-mapi.conf -P "$PWD/pipeline/"
	[ ! -f $PWD/pipeline/input-stream-sip.conf ] && wget -q --show-progress https://botes.s3-us-west-1.amazonaws.com/botes-logstash-configuration/full-config/input-stream-sip.conf -P "$PWD/pipeline/"
	[ ! -f $PWD/pipeline/input-stream-smb.conf ] && wget -q --show-progress https://botes.s3-us-west-1.amazonaws.com/botes-logstash-configuration/full-config/input-stream-smb.conf -P "$PWD/pipeline/"
	[ ! -f $PWD/pipeline/input-stream-snmp.conf ] && wget -q --show-progress https://botes.s3-us-west-1.amazonaws.com/botes-logstash-configuration/full-config/input-stream-snmp.conf -P "$PWD/pipeline/"
	[ ! -f $PWD/pipeline/input-stream-tcp.conf ] && wget -q --show-progress https://botes.s3-us-west-1.amazonaws.com/botes-logstash-configuration/full-config/input-stream-tcp.conf -P "$PWD/pipeline/"
	[ ! -f $PWD/pipeline/input-suricata.conf ] && wget -q --show-progress https://botes.s3-us-west-1.amazonaws.com/botes-logstash-configuration/full-config/input-suricata.conf -P "$PWD/pipeline/"
	[ ! -f $PWD/pipeline/input-winevent-application.conf ] && wget -q --show-progress https://botes.s3-us-west-1.amazonaws.com/botes-logstash-configuration/full-config/input-winevent-application.conf -P "$PWD/pipeline/"
	[ ! -f $PWD/pipeline/input-winevent-security.conf ] && wget -q --show-progress https://botes.s3-us-west-1.amazonaws.com/botes-logstash-configuration/full-config/input-winevent-security.conf -P "$PWD/pipeline/"
	[ ! -f $PWD/pipeline/input-winevent-system.conf ] && wget -q --show-progress https://botes.s3-us-west-1.amazonaws.com/botes-logstash-configuration/full-config/input-winevent-system.conf -P "$PWD/pipeline/"
	[ ! -f $PWD/pipeline/input-winregistry.conf ] && wget -q --show-progress https://botes.s3-us-west-1.amazonaws.com/botes-logstash-configuration/full-config/input-winregistry.conf -P "$PWD/pipeline/"
	[ ! -f $PWD/pipeline/input-winevent-sysmon.conf ] && wget -q --show-progress https://botes.s3-us-west-1.amazonaws.com/botes-logstash-configuration/full-config/input-winevent-sysmon.conf -P "$PWD/pipeline/"
}
function datazipped()
{
	[ ! -f $PWD/upload/firewall/botesv1.fgt_event.json.gz ] && wget -q --show-progress https://botes.s3-us-west-1.amazonaws.com/botes-data/botesv1.fgt_event.json.gz -P "$PWD/upload/firewall/"
	[ ! -f $PWD/upload/firewall/botesv1.fgt_traffic.json.gz ] && wget -q --show-progress https://botes.s3-us-west-1.amazonaws.com/botes-data/botesv1.fgt_traffic.json.gz -P "$PWD/upload/firewall/"
	[ ! -f $PWD/upload/firewall/botesv1.fgt_utm.json.gz ] && wget -q --show-progress https://botes.s3-us-west-1.amazonaws.com/botes-data/botesv1.fgt_utm.json.gz -P "$PWD/upload/firewall/"
	[ ! -f $PWD/upload/iis/botesv1.iis.json.gz ] && wget -q --show-progress https://botes.s3-us-west-1.amazonaws.com/botes-data/botesv1.iis.json.gz -P "$PWD/upload/iis/"
	[ ! -f $PWD/upload/stream/botesv1.nessus-scan.json.gz ] && wget -q --show-progress https://botes.s3-us-west-1.amazonaws.com/botes-data/botesv1.nessus-scan.json.gz -P "$PWD/upload/stream/"
	[ ! -f $PWD/upload/stream/botesv1.stream-dhcp.json.gz ] && wget -q --show-progress https://botes.s3-us-west-1.amazonaws.com/botes-data/botesv1.stream-dhcp.json.gz -P "$PWD/upload/stream/"
	[ ! -f $PWD/upload/stream/botesv1.stream-dns.json.gz ] && wget -q --show-progress https://botes.s3-us-west-1.amazonaws.com/botes-data/botesv1.stream-dns.json.gz -P "$PWD/upload/stream/"
	[ ! -f $PWD/upload/stream/botesv1.stream-http.json.gz ] && wget -q --show-progress https://botes.s3-us-west-1.amazonaws.com/botes-data/botesv1.stream-http.json.gz -P "$PWD/upload/stream//"
	[ ! -f $PWD/upload/stream/botesv1.stream-icmp.json.gz ] && wget -q --show-progress https://botes.s3-us-west-1.amazonaws.com/botes-data/botesv1.stream-icmp.json.gz -P "$PWD/upload/stream/"
	[ ! -f $PWD/upload/stream/botesv1.stream-ip.json.gz ] && wget -q --show-progress https://botes.s3-us-west-1.amazonaws.com/botes-data/botesv1.stream-ip.json.gz -P "$PWD/upload/stream/"
	[ ! -f $PWD/upload/stream/botesv1.stream-ldap.json.gz ] && wget -q --show-progress https://botes.s3-us-west-1.amazonaws.com/botes-data/botesv1.stream-ldap.json.gz -P "$PWD/upload/stream/"
	[ ! -f $PWD/upload/stream/botesv1.stream-mapi.json.gz ] && wget -q --show-progress https://botes.s3-us-west-1.amazonaws.com/botes-data/botesv1.stream-mapi.json.gz -P "$PWD/upload/stream/"
	[ ! -f $PWD/upload/stream/botesv1.stream-sip.json.gz ] && wget -q --show-progress https://botes.s3-us-west-1.amazonaws.com/botes-data/botesv1.stream-sip.json.gz -P "$PWD/upload/stream/"
	[ ! -f $PWD/upload/stream/botesv1.stream-smb.json.gz ] && wget -q --show-progress https://botes.s3-us-west-1.amazonaws.com/botes-data/botesv1.stream-smb.json.gz -P "$PWD/upload/stream/"
	[ ! -f $PWD/upload/stream/botesv1.stream-snmp.json.gz ] && wget -q --show-progress https://botes.s3-us-west-1.amazonaws.com/botes-data/botesv1.stream-snmp.json.gz -P "$PWD/upload/stream/"
	[ ! -f $PWD/upload/stream/botesv1.stream-tcp.json.gz ] && wget -q --show-progress https://botes.s3-us-west-1.amazonaws.com/botes-data/botesv1.stream-tcp.json.gz -P "$PWD/upload/stream/"
	[ ! -f $PWD/upload/ids/botesv1.suricata.json.gz ] && wget -q --show-progress https://botes.s3-us-west-1.amazonaws.com/botes-data/botesv1.suricata.json.gz -P "$PWD/upload/ids/"
	[ ! -f $PWD/upload/winevent/botesv1.WinEventLog-Application.json.gz ] && wget -q --show-progress https://botes.s3-us-west-1.amazonaws.com/botes-data/botesv1.WinEventLog-Application.json.gz -P "$PWD/upload/winevent/"
	[ ! -f $PWD/upload/winevent/botesv1.WinEventLog-Security.json.gz ] && wget -q --show-progress https://botes.s3-us-west-1.amazonaws.com/botes-data/botesv1.WinEventLog-Security.json.gz -P "$PWD/upload/winevent/"
	[ ! -f $PWD/upload/winevent/botesv1.WinEventLog-System.json.gz ] && wget -q --show-progress https://botes.s3-us-west-1.amazonaws.com/botes-data/botesv1.WinEventLog-System.json.gz -P "$PWD/upload/winevent/"
	[ ! -f $PWD/upload/winevent/botesv1.winregistry.json.gz ] && wget -q --show-progress https://botes.s3-us-west-1.amazonaws.com/botes-data/botesv1.winregistry.json.gz -P "$PWD/upload/winevent/"
	[ ! -f $PWD/upload/winevent/botesv1.XmlWinEventLog-Microsoft-Windows-Sysmon-Operational.json.gz ] && wget -q --show-progress https://botes.s3-us-west-1.amazonaws.com/botes-data/botesv1.XmlWinEventLog-Microsoft-Windows-Sysmon-Operational.json.gz -P "$PWD/upload/winevent/"
}
function extract()
{
	[ ! -f $PWD/upload/firewall/botesv1.fgt_event.json ] && gunzip -vk $PWD/upload/firewall/botesv1.fgt_event.json.gz
	[ ! -f $PWD/upload/firewall/botesv1.fgt_traffic.json ] && gunzip -vk $PWD/upload/firewall/botesv1.fgt_traffic.json.gz
	[ ! -f $PWD/upload/firewall/botesv1.fgt_utm.json ] && gunzip -vk $PWD/upload/firewall/botesv1.fgt_utm.json.gz
	[ ! -f $PWD/upload/iis/botesv1.iis.json ] && gunzip -vk $PWD/upload/iis/botesv1.iis.json.gz
	[ ! -f $PWD/upload/stream/botesv1.nessus-scan.json ] && gunzip -vk $PWD/upload/stream/botesv1.nessus-scan.json.gz
	[ ! -f $PWD/upload/stream/botesv1.stream-dhcp.json ] && gunzip -vk $PWD/upload/stream/botesv1.stream-dhcp.json.gz
	[ ! -f $PWD/upload/stream/botesv1.stream-dns.json ] && gunzip -vk $PWD/upload/stream/botesv1.stream-dns.json.gz
	[ ! -f $PWD/upload/stream/botesv1.stream-http.json ] && gunzip -vk $PWD/upload/stream/botesv1.stream-http.json.gz
	[ ! -f $PWD/upload/stream/botesv1.stream-icmp.json ] && gunzip -vk $PWD/upload/stream/botesv1.stream-icmp.json.gz
	[ ! -f $PWD/upload/stream/botesv1.stream-ip.json ] && gunzip -vk $PWD/upload/stream/botesv1.stream-ip.json.gz
	[ ! -f $PWD/upload/stream/botesv1.stream-ldap.json ] && gunzip -vk $PWD/upload/stream/botesv1.stream-ldap.json.gz
	[ ! -f $PWD/upload/stream/botesv1.stream-mapi.json ] && gunzip -vk $PWD/upload/stream/botesv1.stream-mapi.json.gz
	[ ! -f $PWD/upload/stream/botesv1.stream-sip.json ] && gunzip -vk $PWD/upload/stream/botesv1.stream-sip.json.gz
	[ ! -f $PWD/upload/stream/botesv1.stream-smb.json ] && gunzip -vk $PWD/upload/stream/botesv1.stream-smb.json.gz
	[ ! -f $PWD/upload/stream/botesv1.stream-snmp.json ] && gunzip -vk $PWD/upload/stream/botesv1.stream-snmp.json.gz
	[ ! -f $PWD/upload/stream/botesv1.stream-tcp.json ] && gunzip -vk $PWD/upload/stream/botesv1.stream-tcp.json.gz
	[ ! -f $PWD/upload/ids/botesv1.suricata.json ] && gunzip -vk $PWD/upload/ids/botesv1.suricata.json.gz
	[ ! -f $PWD/upload/winevent/botesv1.WinEventLog-Application.json ] && gunzip -vk $PWD/upload/winevent/botesv1.WinEventLog-Application.json.gz
	[ ! -f $PWD/upload/winevent/botesv1.WinEventLog-Security.json ] && gunzip -vk $PWD/upload/winevent/botesv1.WinEventLog-Security.json.gz
	[ ! -f $PWD/upload/winevent/botesv1.WinEventLog-System.json ] && gunzip -vk $PWD/upload/winevent/botesv1.WinEventLog-System.json.gz
	[ ! -f $PWD/upload/winevent/botesv1.winregistry.json ] && gunzip -vk $PWD/upload/winevent/botesv1.winregistry.json.gz
	[ ! -f $PWD/upload/winevent/botesv1.XmlWinEventLog-Microsoft-Windows-Sysmon-Operational.json ] && gunzip -vk $PWD/upload/winevent/botesv1.XmlWinEventLog-Microsoft-Windows-Sysmon-Operational.json.gz
}
function elasticgather()
{
	while true; do
		read -p "Is Elastic Cloud being used? (Y/N): " EScloud
		case $EScloud in
			[Yy]* ) 
				read -p "What is your Elastic Cloud ID: " EScloudid
				read -p "What is your Elastic Cloud Auth [(username):(password)]: " EScloudauth
				read -p "What is your Elastic Cloud Host URL: " EScloudhost
				break;;
			[Nn]* )
				Echo "Logstash Input pipeline will be created. This Version can not support automatic configuration of non-cloud elasticsearch. Please ensure that proper logstash.yml and pipeline/output.conf are included."
				break;;
			* ) echo "Please answer yes or no.";;
		esac
	done


}
function logstashyml()
{
    while true; do
		case $EScloud in
			[Yy]* ) echo -e "cloud.id: \"$EScloudid\"\ncloud.auth: \"$EScloudauth\"" > $PWD/logstash.yml; break;;
			[Nn]* ) break;;
		esac
	done
}	
function outputgen()
{
    while true; do
		case $EScloud in
			[Yy]* )	echo -e "output{\n   elasticsearch {\n     cloud_id => \"$EScloudid\"\n     cloud_auth => \"$EScloudauth\"\n     index => \"botes-%{[tags]}\"\n   }\n}" > $PWD/pipeline/output.conf; break;;
			[Nn]* ) break;;
		esac
	done
}	

function templateput()
{
    while true; do
		case $EScloud in
			[Yy]* )	
				-f $PWD/template.json ] && wget -q --show-progress https://botes.s3-us-west-1.amazonaws.com/botes-index-mapping/template.json -P "$PWD/"
				curl -u $EScloudauth -XPUT "$EScloudhost/_template/botes" -H 'Content-Type: application/json' -d @$PWD/template.json
				break;;
			[Nn]* ) break;;
		esac
	done
}	
function


elasticgather
dircheck
pipelineimport
datazipped
extract
logstashyml
outputgen
templateput

docker pull docker.elastic.co/logstash/logstash:7.7.1
docker run --rm -it -v $PWD/upload:/botes/data/ -v $PWD/logstash.yml:/usr/share/logstash/config/logstash.yml -v $PWD/pipeline/:/usr/share/logstash/pipeline/ docker.elastic.co/logstash/logstash:7.7.1
