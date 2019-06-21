/*
{
    "Metadata": {
        "AWS::CloudFormation::Init": {
            "config": {
                "commands": {
                    "000-disable-1nicautoconfig": {
                        "command": "/usr/bin/setdb provision.1nicautoconfig disable"
                    },
                    "010-install-libs": {
                        "command": {
                            "Fn::Join": [
                                " ",
                                [
                                    "mkdir -p /var/log/cloud/aws;",
                                    "nohup /config/installCloudLibs.sh",
                                    "&>> /var/log/cloud/aws/install.log < /dev/null &"
                                ]
                            ]
                        }
                    },
                    "020-generate-password": {
                        "command": {
                            "Fn::Join": [
                                "",
                                [
                                    "nohup /config/waitThenRun.sh",
                                    " f5-rest-node /config/cloud/aws/node_modules/@f5devcentral/f5-cloud-libs/scripts/runScript.js",
                                    " --signal PASSWORD_CREATED",
                                    " --file f5-rest-node",
                                    " --cl-args '/config/cloud/aws/node_modules/@f5devcentral/f5-cloud-libs/scripts/generatePassword --file /config/cloud/aws/.adminPassword --encrypt'",
                                    " --log-level silly",
                                    " -o /var/log/cloud/aws/generatePassword.log",
                                    " &>> /var/log/cloud/aws/install.log < /dev/null",
                                    " &"
                                ]
                            ]
                        }
                    },
                    "030-create-admin-user": {
                        "command": {
                            "Fn::Join": [
                                "",
                                [
                                    "nohup /config/waitThenRun.sh",
                                    " f5-rest-node /config/cloud/aws/node_modules/@f5devcentral/f5-cloud-libs/scripts/runScript.js",
                                    " --wait-for PASSWORD_CREATED",
                                    " --signal ADMIN_CREATED",
                                    " --file /config/cloud/aws/node_modules/@f5devcentral/f5-cloud-libs/scripts/createUser.sh",
                                    " --cl-args '--user ",
                                    {
                                        "Ref": "adminUsername"
                                    },
                                    " --password-file /config/cloud/aws/.adminPassword",
                                    " --password-encrypted",
                                    "'",
                                    " --log-level silly",
                                    " -o /var/log/cloud/aws/createUser.log",
                                    " &>> /var/log/cloud/aws/install.log < /dev/null",
                                    " &"
                                ]
                            ]
                        }
                    },
                    "040-network-config": {
                        "command": {
                            "Fn::Join": [
                                " ",
                                [
                                    "nohup /config/waitThenRun.sh",
                                    "f5-rest-node /config/cloud/aws/node_modules/@f5devcentral/f5-cloud-libs/scripts/runScript.js",
                                    "--file /config/cloud/aws/node_modules/@f5devcentral/f5-cloud-libs/scripts/aws/1nicSetup.sh",
                                    "--cwd /config/cloud/aws/node_modules/@f5devcentral/f5-cloud-libs/scripts/aws",
                                    "--log-level silly",
                                    "-o /var/log/cloud/aws/1nicSetup.log",
                                    "--wait-for ADMIN_CREATED",
                                    "--signal NETWORK_CONFIG_DONE",
                                    "&>> /var/log/cloud/aws/install.log < /dev/null",
                                    "&"
                                ]
                            ]
                        }
                    },
                    "050-onboard-BIG-IP": {
                        "command": {
                            "Fn::If": [
                                "optin",
                                {
                                    "Fn::Join": [
                                        " ",
                                        [
                                            "DEPLOYMENTID=`echo \"",
                                            {
                                                "Ref": "AWS::StackId"
                                            },
                                            "\"|sha512sum|cut -d \" \" -f 1`;",
                                            "CUSTOMERID=`echo \"",
                                            {
                                                "Ref": "AWS::AccountId"
                                            },
                                            "\"|sha512sum|cut -d \" \" -f 1`;",
                                            "NAME_SERVER=`/config/cloud/aws/getNameServer.sh eth0`;",
                                            "nohup /config/waitThenRun.sh",
                                            "f5-rest-node /config/cloud/aws/node_modules/@f5devcentral/f5-cloud-libs/scripts/onboard.js",
                                            "--log-level silly",
                                            "--wait-for NETWORK_CONFIG_DONE",
                                            "--signal ONBOARD_DONE",
                                            "-o /var/log/cloud/aws/onboard.log",
                                            "--install-ilx-package file:///config/cloud/f5-appsvcs-3.5.1-5.noarch.rpm",
                                            "--host localhost",
                                            "--user",
                                            {
                                                "Ref": "adminUsername"
                                            },
                                            "--password-url file:///config/cloud/aws/.adminPassword",
                                            "--password-encrypted",
                                            "--hostname `curl http://169.254.169.254/latest/meta-data/hostname`",
                                            "--ntp ",
                                            {
                                                "Ref": "ntpServer"
                                            },
                                            "--tz ",
                                            {
                                                "Ref": "timezone"
                                            },
                                            "--dns ${NAME_SERVER}",
                                            "--port 8443",
                                            "--ssl-port ",
                                            {
                                                "Ref": "managementGuiPort"
                                            },
                                            "--module asm:nominal",
                                            "--metrics \"cloudName:aws,region:${REGION},bigipVersion:14.1.0.3-0.0.6,customerId:${CUSTOMERID},deploymentId:${DEPLOYMENTID},templateName:f5-bigiq-autoscale-bigip-waf.template,templateVersion:4.2.0,licenseType:bigiq\"",
                                            "-d tm.tcpudptxchecksum:software-only ",
                                            "--license-pool --cloud aws",
                                            "--big-iq-host",
                                            {
                                                "Ref": "bigIqAddress"
                                            },
                                            "--big-iq-user ",
                                            {
                                                "Ref": "bigIqUsername"
                                            },
                                            "--big-iq-password-uri ",
                                            {
                                                "Ref": "bigIqPasswordS3Arn"
                                            },
                                            "--license-pool-name ",
                                            {
                                                "Ref": "bigIqLicensePoolName"
                                            },
                                            "--unit-of-measure ",
                                            {
                                                "Fn::If": [
                                                    "noUnitOfMeasure",
                                                    {
                                                        "Ref": "AWS::NoValue"
                                                    },
                                                    {
                                                        "Ref": "bigIqLicenseUnitOfMeasure"
                                                    }
                                                ]
                                            },
                                            "--sku-keyword-1 ",
                                            {
                                                "Fn::If": [
                                                    "noSkuKeyword1",
                                                    {
                                                        "Ref": "AWS::NoValue"
                                                    },
                                                    {
                                                        "Ref": "bigIqLicenseSkuKeyword1"
                                                    }
                                                ]
                                            },
                                            "--ping",
                                            "&>> /var/log/cloud/aws/install.log < /dev/null",
                                            "&"
                                        ]
                                    ]
                                },
                                {
                                    "Fn::Join": [
                                        " ",
                                        [
                                            "NAME_SERVER=`/config/cloud/aws/getNameServer.sh eth0`;",
                                            "nohup /config/waitThenRun.sh",
                                            "f5-rest-node /config/cloud/aws/node_modules/@f5devcentral/f5-cloud-libs/scripts/onboard.js",
                                            "--log-level silly",
                                            "--wait-for NETWORK_CONFIG_DONE",
                                            "--signal ONBOARD_DONE",
                                            "-o /var/log/cloud/aws/onboard.log",
                                            "--install-ilx-package file:///config/cloud/f5-appsvcs-3.5.1-5.noarch.rpm",
                                            "--host localhost",
                                            "--port 8443",
                                            "--user",
                                            {
                                                "Ref": "adminUsername"
                                            },
                                            "--password-url file:///config/cloud/aws/.adminPassword",
                                            "--password-encrypted",
                                            "--hostname `curl http://169.254.169.254/latest/meta-data/hostname`",
                                            "--ntp ",
                                            {
                                                "Ref": "ntpServer"
                                            },
                                            "--tz ",
                                            {
                                                "Ref": "timezone"
                                            },
                                            "--dns ${NAME_SERVER}",
                                            "--ssl-port ",
                                            {
                                                "Ref": "managementGuiPort"
                                            },
                                            "--module asm:nominal",
                                            "-d tm.tcpudptxchecksum:software-only ",
                                            "--license-pool --cloud aws",
                                            "--big-iq-host",
                                            {
                                                "Ref": "bigIqAddress"
                                            },
                                            "--big-iq-user ",
                                            {
                                                "Ref": "bigIqUsername"
                                            },
                                            "--big-iq-password-uri ",
                                            {
                                                "Ref": "bigIqPasswordS3Arn"
                                            },
                                            "--license-pool-name ",
                                            {
                                                "Ref": "bigIqLicensePoolName"
                                            },
                                            "--unit-of-measure ",
                                            {
                                                "Fn::If": [
                                                    "noUnitOfMeasure",
                                                    {
                                                        "Ref": "AWS::NoValue"
                                                    },
                                                    {
                                                        "Ref": "bigIqLicenseUnitOfMeasure"
                                                    }
                                                ]
                                            },
                                            "--sku-keyword-1 ",
                                            {
                                                "Fn::If": [
                                                    "noSkuKeyword1",
                                                    {
                                                        "Ref": "AWS::NoValue"
                                                    },
                                                    {
                                                        "Ref": "bigIqLicenseSkuKeyword1"
                                                    }
                                                ]
                                            },
                                            "--ping",
                                            "&>> /var/log/cloud/aws/install.log < /dev/null",
                                            "&"
                                        ]
                                    ]
                                }
                            ]
                        }
                    },
                    "060-custom-config": {
                        "command": {
                            "Fn::Join": [
                                " ",
                                [
                                    "nohup /config/waitThenRun.sh",
                                    "f5-rest-node /config/cloud/aws/node_modules/@f5devcentral/f5-cloud-libs/scripts/runScript.js",
                                    "--log-level silly",
                                    "--file /config/cloud/aws/custom-config.sh",
                                    "--cwd /config/cloud/aws",
                                    "-o /var/log/cloud/aws/custom-config.log",
                                    "--wait-for ONBOARD_DONE",
                                    "&>> /var/log/cloud/aws/install.log < /dev/null",
                                    "&"
                                ]
                            ]
                        }
                    }
                },
                "files": {
                    "/config/cloud/asm-policy-linux.tar.gz": {
                        "group": "root",
                        "mode": "000755",
                        "owner": "root",
                        "source": "http://cdn.f5.com/product/cloudsolutions/solution-scripts/asm-policy-linux.tar.gz"
                    },
                    "/config/cloud/aws/custom-config.sh": {
                        "content": {
                            "Fn::Join": [
                                "",
                                [
                                    "#!/bin/bash\n",
                                    "# Generated from 4.2.0\n",
                                    "date\n",
                                    ". /config/cloud/aws/onboard_config_vars\n",
                                    "tmsh create sys icall script uploadMetrics definition { exec /config/cloud/aws/node_modules/@f5devcentral/f5-cloud-libs-aws/scripts/reportMetrics.sh }\n",
                                    "tmsh create sys icall handler periodic /Common/metricUploadHandler { first-occurrence now interval 60 script /Common/uploadMetrics }\n",
                                    "tmsh save /sys config\n",
                                    "echo 'Attempting to Join or Initiate Autoscale Cluster' \n",
                                    "f5-rest-node /config/cloud/aws/node_modules/@f5devcentral/f5-cloud-libs/scripts/autoscale.js --cloud aws --provider-options s3Bucket:${s3Bucket},sqsUrl:${sqsUrl},mgmtPort:${managementGuiPort} --host localhost --port ${managementGuiPort} --user ${adminUsername} --password-url file:///config/cloud/aws/.adminPassword --password-encrypted --device-group autoscale-group --block-sync -c join --log-level silly --output /var/log/cloud/aws/autoscale.log --license-pool --big-iq-host ${bigIqAddress} --big-iq-user ${bigIqUsername} --big-iq-password-uri ${bigIqPasswordS3Arn} --license-pool-name ${bigIqLicensePoolName} \n",
                                    "if [ -f /config/cloud/master ]; then \n",
                                    "  if `jq '.ucsLoaded' < /config/cloud/master`; then \n",
                                    "    echo \"UCS backup loaded from backup folder in S3 bucket ${s3Bucket}.\"\n",
                                    "  else\n",
                                    "    echo 'SELF-SELECTED as Master ... Initiated Autoscale Cluster ... Loading default config'\n",
                                    "    tmsh modify cm device-group autoscale-group asm-sync enabled\n",
                                    "    tmsh load sys application template /config/cloud/f5.http.v1.2.0rc7.tmpl\n",
                                    "    tmsh load sys application template /config/cloud/aws/f5.cloud_logger.v1.0.0.tmpl\n",
                                    "    tmsh load sys application template /config/cloud/aws/f5.service_discovery.tmpl\n",
                                    "    source /config/cloud/aws/node_modules/@f5devcentral/f5-cloud-libs/scripts/waitForBigip.sh;wait-for-bigip\n",
                                    "    ### START CUSTOM CONFIGURATION\n",
                                    "    deployed=\"no\"\n",
                                    "    url_regex=\"(http:\\/\\/|https:\\/\\/)?[a-z0-9]+([\\-\\.]{1}[a-z0-9]+)*\\.[a-z]{2,5}(:[0-9]{1,5})?(\\/.*)?$\"\n",
                                    "    file_loc=\"/config/cloud/custom_config\"\n",
                                    "    if [[ $declarationUrl =~ $url_regex ]]; then\n",
                                    "       response_code=$(/usr/bin/curl -sk -w \"%{http_code}\" $declarationUrl -o $file_loc)\n",
                                    "       if [[ $response_code == 200 ]]; then\n",
                                    "           echo \"Custom config download complete; checking for valid JSON.\"\n",
                                    "           cat $file_loc | jq .class\n",
                                    "           if [[ $? == 0 ]]; then\n",
                                    "               response_code=$(/usr/bin/curl -skvvu ${adminUsername}:$passwd -w \"%{http_code}\" -X POST -H \"Content-Type: application/json\" https://localhost:${managementGuiPort}/mgmt/shared/appsvcs/declare -d @$file_loc -o /dev/null)\n",
                                    "           if [[ $response_code == 200 || $response_code == 502 ]]; then\n",
                                    "               echo \"Deployment of custom application succeeded.\"\n",
                                    "               deployed=\"yes\"\n",
                                    "           else\n",
                                    "               echo \"Failed to deploy custom application; continuing...\"\n",
                                    "           fi\n",
                                    "       else\n",
                                    "           echo \"Custom config was not valid JSON, continuing...\"\n",
                                    "       fi\n",
                                    "       else\n",
                                    "           echo \"Failed to download custom config; continuing...\"\n",
                                    "       fi\n",
                                    "   else\n",
                                    "      echo \"Custom config was not a URL, continuing...\"\n",
                                    "   fi\n",
                                    "   if [[ $deployed == \"no\" && $declarationUrl == \"default\" ]]; then\n",
                                    "        asm_policy=\"/config/cloud/asm-policy-linux-${policyLevel}.xml\"\n",
                                    "        payload=$(echo $payload | jq -c --arg asm_policy $asm_policy --arg pool_http_port $applicationPort --arg vs_http_port $virtualServicePort '.waf.Shared.policyWAF.file = $asm_policy | .waf.http.pool.members[0].servicePort = ($pool_http_port | tonumber) | .waf.http.serviceMain.virtualPort = ($vs_http_port | tonumber)')\n",
                                    "    payload=$(echo $payload | jq -c 'del(.waf.http.serviceMain.serverTLS)')\n",
                                    "        if [ \"${applicationPoolTagKey}\" != \"default\" ]\n",
                                    "        then\n",
                                    "            payload=$(echo $payload | jq -c 'del(.waf.http.pool.members[0].autoPopulate) | del(.waf.http.pool.members[0].hostname)')\n",
                                    "            payload=$(echo $payload | jq -c --arg tagKey $applicationPoolTagKey --arg tagValue $applicationPoolTagValue --arg region $region '.waf.http.pool.members[0].tagKey = $tagKey | .waf.http.pool.members[0].tagValue = $tagValue | .waf.http.pool.members[0].region = $region')\n",
                                    "        else\n",
                                    "            payload=$(echo $payload | jq -c 'del(.waf.http.pool.members[0].updateInterval) | del(.waf.http.pool.members[0].tagKey) | del(.waf.http.pool.members[0].tagValue) | del(.waf.http.pool.members[0].addressRealm) | del(.waf.http.pool.members[0].region)')\n",
                                    "            payload=$(echo $payload | jq -c --arg pool_member $appInternalDnsName '.waf.http.pool.members[0].hostname = $pool_member | .waf.http.pool.members[0].addressDiscovery = \"fqdn\"')\n",
                                    "        fi\n",
                                    "        response_code=$(/usr/bin/curl -skvvu ${adminUsername}:$passwd -w \"%{http_code}\" -X POST -H \"Content-Type: application/json\" https://localhost:${managementGuiPort}/mgmt/shared/appsvcs/declare -d \"$payload\" -o /dev/null)\n",
                                    "        if [[ $response_code == 200 || $response_code == 502  ]]; then\n",
                                    "            echo 'Deployment of recommended application succeeded.'\n",
                                    "        else\n",
                                    "            echo 'Failed to deploy recommended application'\n",
                                    "            exit 1\n",
                                    "        fi\n",
                                    "    fi\n",
                                    "    ### END CUSTOM CONFIGURATION\n",
                                    "    tmsh save /sys config\n",
                                    "    f5-rest-node /config/cloud/aws/node_modules/@f5devcentral/f5-cloud-libs/scripts/autoscale.js --cloud aws --provider-options s3Bucket:${s3Bucket},sqsUrl:${sqsUrl},mgmtPort:${managementGuiPort}",
                                    "      --host localhost --port ${managementGuiPort} --user ${adminUsername} --password-url file:///config/cloud/aws/.adminPassword --password-encrypted -c unblock-sync --log-level silly --output /var/log/cloud/aws/autoscale.log --license-pool --big-iq-host ${bigIqAddress} --big-iq-user ${bigIqUsername} --big-iq-password-uri ${bigIqPasswordS3Arn} --license-pool-name ${bigIqLicensePoolName} \n",
                                    "  fi\n",
                                    "fi\n",
                                    "(crontab -l 2>/dev/null; echo '\*\/1 * * * * /config/cloud/aws/run_autoscale_update.sh') | crontab -\n",
                                    "(crontab -l 2>/dev/null; echo '59 23 * * * /config/cloud/aws/run_autoscale_backup.sh') | crontab -\n",
                                    "tmsh save /sys config\n",
                                    "date\n",
                                    "echo 'custom-config.sh complete'\n"
                                ]
                            ]
                        },
                        "group": "root",
                        "mode": "000755",
                        "owner": "root"
                    },
                    "/config/cloud/aws/f5.cloud_logger.v1.0.0.tmpl": {
                        "group": "root",
                        "mode": "000755",
                        "owner": "root",
                        "source": "http://cdn.f5.com/product/cloudsolutions/iapps/common/f5-cloud-logger/v1.0.0/f5.cloud_logger.v1.0.0.tmpl"
                    },
                    "/config/cloud/aws/f5.service_discovery.tmpl": {
                        "group": "root",
                        "mode": "000755",
                        "owner": "root",
                        "source": "http://cdn.f5.com/product/cloudsolutions/iapps/common/f5-service-discovery/v2.3.2/f5.service_discovery.tmpl"
                    },
                    "/config/cloud/aws/getNameServer.sh": {
                        "content": {
                            "Fn::Join": [
                                "\n",
                                [
                                    "INTERFACE=$1",
                                    "INTERFACE_MAC=`ifconfig ${INTERFACE} | egrep ether | awk '{print tolower($2)}'`",
                                    "VPC_CIDR_BLOCK=`curl -s -f --retry 20 http://169.254.169.254/latest/meta-data/network/interfaces/macs/${INTERFACE_MAC}/vpc-ipv4-cidr-block`",
                                    "VPC_NET=${VPC_CIDR_BLOCK%/*}",
                                    "NAME_SERVER=`echo ${VPC_NET} | awk -F. '{ printf \"%d.%d.%d.%d\", $1, $2, $3, $4+2 }'`",
                                    "echo $NAME_SERVER"
                                ]
                            ]
                        },
                        "group": "root",
                        "mode": "000755",
                        "owner": "root"
                    },
                    "/config/cloud/aws/onboard_config_vars": {
                        "content": {
                            "Fn::Join": [
                                "",
                                [
                                    "#!/bin/bash\n",
                                    "# Generated from 4.2.0\n",
                                    "hostname=`curl http://169.254.169.254/latest/meta-data/hostname`\n",
                                    "region='",
                                    {
                                        "Ref": "AWS::Region"
                                    },
                                    "'\n",
                                    "deploymentName='",
                                    {
                                        "Ref": "deploymentName"
                                    },
                                    "'\n",
                                    "adminUsername='",
                                    {
                                        "Ref": "adminUsername"
                                    },
                                    "'\n",
                                    "managementGuiPort='",
                                    {
                                        "Ref": "managementGuiPort"
                                    },
                                    "'\n",
                                    "timezone='",
                                    {
                                        "Ref": "timezone"
                                    },
                                    "'\n",
                                    "ntpServer='",
                                    {
                                        "Ref": "ntpServer"
                                    },
                                    "'\n",
                                    "virtualServicePort='",
                                    {
                                        "Ref": "virtualServicePort"
                                    },
                                    "'\n",
                                    "applicationPort='",
                                    {
                                        "Ref": "applicationPort"
                                    },
                                    "'\n",
                                    "appInternalDnsName='",
                                    {
                                        "Ref": "appInternalDnsName"
                                    },
                                    "'\n",
                                    "applicationPoolTagKey='",
                                    {
                                        "Ref": "applicationPoolTagKey"
                                    },
                                    "'\n",
                                    "applicationPoolTagValue='",
                                    {
                                        "Ref": "applicationPoolTagValue"
                                    },
                                    "'\n",
                                    "s3Bucket='",
                                    {
                                        "Ref": "S3Bucket"
                                    },
                                    "'\n",
                                    "sqsUrl='",
                                    {
                                        "Ref": "SQSQueue"
                                    },
                                    "'\n",
                                    "declarationUrl='",
                                    {
                                        "Ref": "declarationUrl"
                                    },
                                    "'\n",
                                    "policyLevel='",
                                    {
                                        "Ref": "policyLevel"
                                    },
                                    "'\n",
                                    "passwd=$(f5-rest-node /config/cloud/aws/node_modules/@f5devcentral/f5-cloud-libs/scripts/decryptDataFromFile.js --data-file /config/cloud/aws/.adminPassword)\n",
                                    "payload='{\"class\":\"ADC\",\"schemaVersion\":\"3.0.0\",\"label\":\"autoscale_waf\",\"id\":\"AUTOSCALE_WAF\",\"remark\":\"Autoscale WAF\",\"waf\":{\"class\":\"Tenant\",\"Shared\":{\"class\":\"Application\",\"template\":\"shared\",\"serviceAddress\":{\"class\":\"Service_Address\",\"virtualAddress\":\"0.0.0.0\"},\"policyWAF\":{\"class\":\"WAF_Policy\",\"file\":\"/tmp/as30-linux-medium.xml\"}},\"http\":{\"class\":\"Application\",\"template\":\"http\",\"serviceMain\":{\"class\":\"Service_HTTP\",\"virtualAddresses\":[{\"use\":\"/waf/Shared/serviceAddress\"}],\"serverTLS\":{\"bigip\":\"/Common/example-clientssl-profile\"},\"snat\":\"auto\",\"securityLogProfiles\":[{\"bigip\":\"/Common/Log illegal requests\"}],\"pool\":\"pool\",\"policyWAF\":{\"use\":\"/waf/Shared/policyWAF\"}},\"pool\":{\"class\":\"Pool\",\"monitors\":[\"http\"],\"members\":[{\"autoPopulate\":true,\"hostname\":\"demo.example.com\",\"servicePort\":80,\"addressDiscovery\":\"aws\",\"updateInterval\":15,\"tagKey\":\"applicationPoolTagKey\",\"tagValue\":\"applicationPoolTagValue\",\"addressRealm\":\"private\",\"region\":\"us-west-2\"}]}}}}'\n",
                                    "bigIqAddress='",
                                    {
                                        "Ref": "bigIqAddress"
                                    },
                                    "'\n",
                                    "bigIqUsername='",
                                    {
                                        "Ref": "bigIqUsername"
                                    },
                                    "'\n",
                                    "bigIqPasswordS3Arn='",
                                    {
                                        "Ref": "bigIqPasswordS3Arn"
                                    },
                                    "'\n",
                                    "bigIqLicensePoolName='",
                                    {
                                        "Ref": "bigIqLicensePoolName"
                                    },
                                    "'\n",
                                    "bigIqLicenseUnitOfMeasure='",
                                    {
                                        "Ref": "bigIqLicenseUnitOfMeasure"
                                    },
                                    "'\n",
                                    "bigIqLicenseSkuKeyword1='",
                                    {
                                        "Ref": "bigIqLicenseSkuKeyword1"
                                    },
                                    "'\n"
                                ]
                            ]
                        },
                        "group": "root",
                        "mode": "000755",
                        "owner": "root"
                    },
                    "/config/cloud/aws/run_autoscale_backup.sh": {
                        "content": {
                            "Fn::Join": [
                                "",
                                [
                                    "#!/bin/bash\n",
                                    "source /config/cloud/aws/onboard_config_vars\n",
                                    "f5-rest-node /config/cloud/aws/node_modules/@f5devcentral/f5-cloud-libs/scripts/autoscale.js",
                                    " --cloud aws --provider-options '",
                                    "s3Bucket:",
                                    {
                                        "Ref": "S3Bucket"
                                    },
                                    ",sqsUrl:",
                                    {
                                        "Ref": "SQSQueue"
                                    },
                                    ",mgmtPort:",
                                    {
                                        "Ref": "managementGuiPort"
                                    },
                                    "'",
                                    " --host localhost",
                                    " --port ",
                                    {
                                        "Ref": "managementGuiPort"
                                    },
                                    " --user ",
                                    {
                                        "Ref": "adminUsername"
                                    },
                                    " --password-url file:///config/cloud/aws/.adminPassword",
                                    " --password-encrypted",
                                    " --device-group autoscale-group",
                                    " --cluster-action backup-ucs",
                                    " --log-level silly --output /var/log/cloud/aws/autoscale.log"
                                ]
                            ]
                        },
                        "group": "root",
                        "mode": "000755",
                        "owner": "root"
                    },
                    "/config/cloud/aws/run_autoscale_update.sh": {
                        "content": {
                            "Fn::Join": [
                                "",
                                [
                                    "#!/bin/bash\n",
                                    "f5-rest-node /config/cloud/aws/node_modules/@f5devcentral/f5-cloud-libs/scripts/autoscale.js",
                                    " --cloud aws --provider-options '",
                                    "s3Bucket:",
                                    {
                                        "Ref": "S3Bucket"
                                    },
                                    ",sqsUrl:",
                                    {
                                        "Ref": "SQSQueue"
                                    },
                                    ",mgmtPort:",
                                    {
                                        "Ref": "managementGuiPort"
                                    },
                                    "'",
                                    " --host localhost",
                                    " --port ",
                                    {
                                        "Ref": "managementGuiPort"
                                    },
                                    " --user ",
                                    {
                                        "Ref": "adminUsername"
                                    },
                                    " --password-url file:///config/cloud/aws/.adminPassword",
                                    " --password-encrypted",
                                    " --device-group autoscale-group",
                                    " --cluster-action update",
                                    " --log-level silly --output /var/log/cloud/aws/autoscale.log ",
                                    " --license-pool --big-iq-host ",
                                    {
                                        "Ref": "bigIqAddress"
                                    },
                                    " --big-iq-user ",
                                    {
                                        "Ref": "bigIqUsername"
                                    },
                                    " --big-iq-password-uri ",
                                    {
                                        "Ref": "bigIqPasswordS3Arn"
                                    },
                                    " --license-pool-name ",
                                    {
                                        "Ref": "bigIqLicensePoolName"
                                    }
                                ]
                            ]
                        },
                        "group": "root",
                        "mode": "000755",
                        "owner": "root"
                    },
                    "/config/cloud/f5-appsvcs-3.5.1-5.noarch.rpm": {
                        "group": "root",
                        "mode": "000755",
                        "owner": "root",
                        "source": "http://cdn.f5.com/product/cloudsolutions/f5-appsvcs-extension/v3.6.0/dist/lts/f5-appsvcs-3.5.1-5.noarch.rpm"
                    },
                    "/config/cloud/f5-cloud-libs-aws.tar.gz": {
                        "group": "root",
                        "mode": "000755",
                        "owner": "root",
                        "source": "http://cdn.f5.com/product/cloudsolutions/f5-cloud-libs-aws/v2.4.0/f5-cloud-libs-aws.tar.gz"
                    },
                    "/config/cloud/f5-cloud-libs.tar.gz": {
                        "group": "root",
                        "mode": "000755",
                        "owner": "root",
                        "source": "http://cdn.f5.com/product/cloudsolutions/f5-cloud-libs/v4.8.3/f5-cloud-libs.tar.gz"
                    },
                    "/config/cloud/f5.http.v1.2.0rc7.tmpl": {
                        "group": "root",
                        "mode": "000755",
                        "owner": "root",
                        "source": "http://cdn.f5.com/product/cloudsolutions/iapps/common/f5-http/f5.http.v1.2.0rc7.tmpl"
                    },
                    "/config/installCloudLibs.sh": {
                        "content": {
                            "Fn::Join": [
                                "\n",
                                [
                                    "#!/bin/bash",
                                    "echo about to execute",
                                    "checks=0",
                                    "while [ $checks -lt 120 ]; do echo checking mcpd",
                                    "    tmsh -a show sys mcp-state field-fmt | grep -q running",
                                    "    if [ $? == 0 ]; then",
                                    "        echo mcpd ready",
                                    "        break",
                                    "    fi",
                                    "    echo mcpd not ready yet",
                                    "    let checks=checks+1",
                                    "    sleep 10",
                                    "done",
                                    "echo loading verifyHash script",
                                    "if ! tmsh load sys config merge file /config/verifyHash; then",
                                    "    echo cannot validate signature of /config/verifyHash",
                                    "    exit",
                                    "fi",
                                    "echo loaded verifyHash",
                                    "declare -a filesToVerify=(\"/config/cloud/f5-cloud-libs.tar.gz\" \"/config/cloud/f5-cloud-libs-aws.tar.gz\" \"/config/cloud/f5-appsvcs-3.5.1-5.noarch.rpm\" \"/config/cloud/aws/f5.service_discovery.tmpl\" \"/config/cloud/aws/f5.cloud_logger.v1.0.0.tmpl\")",
                                    "for fileToVerify in \"${filesToVerify[@]}\"",
                                    "do",
                                    "    echo verifying \"$fileToVerify\"",
                                    "    if ! tmsh run cli script verifyHash \"$fileToVerify\"; then",
                                    "        echo \"$fileToVerify\" is not valid",
                                    "        exit 1",
                                    "    fi",
                                    "    echo verified \"$fileToVerify\"",
                                    "done",
                                    "mkdir -p /config/cloud/aws/node_modules/@f5devcentral",
                                    "echo expanding f5-cloud-libs.tar.gz",
                                    "tar xvfz /config/cloud/f5-cloud-libs.tar.gz -C /config/cloud/aws/node_modules/@f5devcentral",
                                    "echo installing dependencies",
                                    "tar xvfz /config/cloud/f5-cloud-libs-aws.tar.gz -C /config/cloud/aws/node_modules/@f5devcentral",
                                    "tar xvfz /config/cloud/asm-policy-linux.tar.gz -C /config/cloud",
                                    "echo cloud libs install complete",
                                    "touch /config/cloud/cloudLibsReady"
                                ]
                            ]
                        },
                        "group": "root",
                        "mode": "000755",
                        "owner": "root"
                    },
                    "/config/verifyHash": {
                        "content": {
                            "Fn::Join": [
                                "",
                                [
                                    "cli script /Common/verifyHash {\nproc script::run {} {\n        if {[catch {\n            set hashes(f5-cloud-libs.tar.gz) 86d24521063640bfaaafa882f491974e39b46c700554dd8591d681139df25b0bed4dfe934545c2894e0a27a513ae7498a52e6deac00b5399f301badbfb8a91e0\n            set hashes(f5-cloud-libs-aws.tar.gz) 076c969cbfff12efacce0879820262b7787c98645f1105667cc4927d4acfe2466ed64c777b6d35957f6df7ae266937dde42fef4c8b1f870020a366f7f910ffb5\n            set hashes(f5-cloud-libs-azure.tar.gz) 57fae388e8aa028d24a2d3fa2c029776925011a72edb320da47ccd4fb8dc762321c371312f692b7b8f1c84e8261c280f6887ba2e0f841b50547e6e6abc8043ba\n            set hashes(f5-cloud-libs-gce.tar.gz) 1677835e69967fd9882ead03cbdd24b426627133b8db9e41f6de5a26fef99c2d7b695978ac189f00f61c0737e6dbb638d42dea43a867ef4c01d9507d0ee1fb2f\n            set hashes(f5-cloud-libs-openstack.tar.gz) 5c83fe6a93a6fceb5a2e8437b5ed8cc9faf4c1621bfc9e6a0779f6c2137b45eab8ae0e7ed745c8cf821b9371245ca29749ca0b7e5663949d77496b8728f4b0f9\n            set hashes(f5-cloud-libs-consul.tar.gz) a32aab397073df92cbbba5067e5823e9b5fafca862a258b60b6b40aa0975c3989d1e110f706177b2ffbe4dde65305a260a5856594ce7ad4ef0c47b694ae4a513\n            set hashes(asm-policy-linux.tar.gz) 63b5c2a51ca09c43bd89af3773bbab87c71a6e7f6ad9410b229b4e0a1c483d46f1a9fff39d9944041b02ee9260724027414de592e99f4c2475415323e18a72e0\n            set hashes(f5.http.v1.2.0rc4.tmpl) 47c19a83ebfc7bd1e9e9c35f3424945ef8694aa437eedd17b6a387788d4db1396fefe445199b497064d76967b0d50238154190ca0bd73941298fc257df4dc034\n            set hashes(f5.http.v1.2.0rc6.tmpl) 811b14bffaab5ed0365f0106bb5ce5e4ec22385655ea3ac04de2a39bd9944f51e3714619dae7ca43662c956b5212228858f0592672a2579d4a87769186e2cbfe\n            set hashes(f5.http.v1.2.0rc7.tmpl) 21f413342e9a7a281a0f0e1301e745aa86af21a697d2e6fdc21dd279734936631e92f34bf1c2d2504c201f56ccd75c5c13baa2fe7653213689ec3c9e27dff77d\n            set hashes(f5.aws_advanced_ha.v1.3.0rc1.tmpl) 9e55149c010c1d395abdae3c3d2cb83ec13d31ed39424695e88680cf3ed5a013d626b326711d3d40ef2df46b72d414b4cb8e4f445ea0738dcbd25c4c843ac39d\n            set hashes(f5.aws_advanced_ha.v1.4.0rc1.tmpl) de068455257412a949f1eadccaee8506347e04fd69bfb645001b76f200127668e4a06be2bbb94e10fefc215cfc3665b07945e6d733cbe1a4fa1b88e881590396\n            set hashes(f5.aws_advanced_ha.v1.4.0rc2.tmpl) 6ab0bffc426df7d31913f9a474b1a07860435e366b07d77b32064acfb2952c1f207beaed77013a15e44d80d74f3253e7cf9fbbe12a90ec7128de6facd097d68f\n            set hashes(f5.aws_advanced_ha.v1.4.0rc3.tmpl) 2f2339b4bc3a23c9cfd42aae2a6de39ba0658366f25985de2ea53410a745f0f18eedc491b20f4a8dba8db48970096e2efdca7b8efffa1a83a78e5aadf218b134\n            set hashes(f5.aws_advanced_ha.v1.4.0rc4.tmpl) 2418ac8b1f1884c5c096cbac6a94d4059aaaf05927a6a4508fd1f25b8cc6077498839fbdda8176d2cf2d274a27e6a1dae2a1e3a0a9991bc65fc74fc0d02ce963\n            set hashes(f5.aws_advanced_ha.v1.4.0rc5.tmpl) 5e582187ae1a6323e095d41eddd41151d6bd38eb83c634410d4527a3d0e246a8fc62685ab0849de2ade62b0275f51264d2deaccbc16b773417f847a4a1ea9bc4\n            set hashes(asm-policy.tar.gz) 2d39ec60d006d05d8a1567a1d8aae722419e8b062ad77d6d9a31652971e5e67bc4043d81671ba2a8b12dd229ea46d205144f75374ed4cae58cefa8f9ab6533e6\n            set hashes(deploy_waf.sh) 1a3a3c6274ab08a7dc2cb73aedc8d2b2a23cd9e0eb06a2e1534b3632f250f1d897056f219d5b35d3eed1207026e89989f754840fd92969c515ae4d829214fb74\n            set hashes(f5.policy_creator.tmpl) 06539e08d115efafe55aa507ecb4e443e83bdb1f5825a9514954ef6ca56d240ed00c7b5d67bd8f67b815ee9dd46451984701d058c89dae2434c89715d375a620\n            set hashes(f5.service_discovery.tmpl) 4811a95372d1dbdbb4f62f8bcc48d4bc919fa492cda012c81e3a2fe63d7966cc36ba8677ed049a814a930473234f300d3f8bced2b0db63176d52ac99640ce81b\n            set hashes(f5.cloud_logger.v1.0.0.tmpl) 64a0ed3b5e32a037ba4e71d460385fe8b5e1aecc27dc0e8514b511863952e419a89f4a2a43326abb543bba9bc34376afa114ceda950d2c3bd08dab735ff5ad20\n            set hashes(f5-appsvcs-3.5.1-5.noarch.rpm) ba71c6e1c52d0c7077cdb25a58709b8fb7c37b34418a8338bbf67668339676d208c1a4fef4e5470c152aac84020b4ccb8074ce387de24be339711256c0fa78c8\n\n            set file_path [lindex $tmsh::argv 1]\n            set file_name [file tail $file_path]\n\n            if {![info exists hashes($file_name)]} {\n                tmsh::log err \"No hash found for $file_name\"\n                exit 1\n            }\n\n            set expected_hash $hashes($file_name)\n            set computed_hash [lindex [exec /usr/bin/openssl dgst -r -sha512 $file_path] 0]\n            if { $expected_hash eq $computed_hash } {\n                exit 0\n            }\n            tmsh::log err \"Hash does not match for $file_path\"\n            exit 1\n        }]} {\n            tmsh::log err {Unexpected error in verifyHash}\n            exit 1\n        }\n    }\n    script-signature TjGIQtBj6gmevtbkCb9uwhrzm02aFer0KYwVeIvwBPssYRAJ7T/mc91LWODrSs9U12XAAtxQKHsG3XYWvklyB79fe/7C+589WvIhG814/OoXd1dplcH7O+EF5LBMdXEY4VQNw+5HuSl89tvBIkHGMCXSRAj8hHDIx9kqOF4OirExaJBZopb2qTY0P7AmhjpzFCvkJLUcmz7H5LZCfFCDYWWB5g5Bst7ZkLWfP2arMtxLRTFl/m6x4QttOeD9wktPGajn1XhvXThtzJ8vlTJJRuk/OyLJPr+64qkXwi3wngudiiZeFnCiI1Mrggp96B+yKtCqRsABJju6LMdH80T1Zg==\n    signing-key /Common/f5-irule\n}"
                                ]
                            ]
                        },
                        "group": "root",
                        "mode": "000755",
                        "owner": "root"
                    },
                    "/config/waitThenRun.sh": {
                        "content": {
                            "Fn::Join": [
                                "\n",
                                [
                                    "#!/bin/bash",
                                    "while true; do echo \"waiting for cloud libs install to complete\"",
                                    "    if [ -f /config/cloud/cloudLibsReady ]; then",
                                    "        break",
                                    "    else",
                                    "        sleep 10",
                                    "    fi",
                                    "done",
                                    "\"$@\""
                                ]
                            ]
                        },
                        "group": "root",
                        "mode": "000755",
                        "owner": "root"
                    }
                }
            }
        },
        "AWS::CloudFormation::Designer": {
            "id": "339ec6f5-0f7f-4e28-8185-efb78af04c60"
        }
    },
    "Properties": {
        "AssociatePublicIpAddress": "true",
        "BlockDeviceMappings": [
            {
                "DeviceName": "/dev/xvda",
                "Ebs": {
                    "DeleteOnTermination": "true",
                    "VolumeType": "gp2"
                }
            },
            {
                "DeviceName": "/dev/xvdb",
                "NoDevice": "true"
            }
        ],
        "IamInstanceProfile": {
            "Ref": "BigipAutoScalingInstanceProfile"
        },
        "ImageId": {
            "Fn::If": [
                "noCustomImageId",
                {
                    "Fn::FindInMap": [
                        "BigipRegionMap",
                        {
                            "Ref": "AWS::Region"
                        },
                        "AllTwoBootLocations"
                    ]
                },
                {
                    "Ref": "customImageId"
                }
            ]
        },
        "InstanceMonitoring": "false",
        "InstanceType": {
            "Ref": "instanceType"
        },
        "KeyName": {
            "Ref": "sshKey"
        },
        "SecurityGroups": [
            {
                "Ref": "bigipExternalSecurityGroup"
            }
        ],
        "UserData": {
            "Fn::Base64": {
                "Fn::Join": [
                    "",
                    [
                        "#!/bin/bash -x\n",
                        "/opt/aws/apitools/cfn-init/bin/cfn-init -v -s ",
                        {
                            "Ref": "AWS::StackId"
                        },
                        " -r BigipLaunchConfig",
                        " --region ",
                        {
                            "Ref": "AWS::Region"
                        },
                        "\n"
                    ]
                ]
            }
        }
    },
    "Type": "AWS::AutoScaling::LaunchConfiguration"
}
*/
