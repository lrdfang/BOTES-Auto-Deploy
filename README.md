#BOTES-Auto-Deploy

This is an auto-deploy script for the Boss of the Elastic SOC data set for use in training environments. The BOTES data set is assembled and built by Sebastien Lehuede and documented on his BOTES GitBook documentation. This script just expands upon his work and simplifies deployment.

The script is based on the Logstash Docker container and currently supports Elastic Cloud instances. Requiring only a Linux machine running Docker. It then requests the Cloud ID and Cloud Auth for an Elastic instance to be used. The script will then verify if the required data sets and configurations are downloaded. If they are not it will download the prebuilt/cleaned datasets and configs. Before configuring the needed logstash configurations to talk to Elastic. Once all requirements are gathered it will start a logstash docker that deploys everything.
