#!/bin/bash

# Usage:
# 1. create a log file
# sudo touch /var/log/campus_network.log
# sudo chown xwu /var/log/campus_network.log
# 2. install crontab jobs
# crontab -e
# # auto campus network
# */5 * * * * ~/bin/campus_network.sh >/dev/null 2>&1
# # auto clean log
# 0 0 1 * * date > /var/log/campus_network.log >/dev/null 2>&1

LOG_FILE=/var/log/campus_network.log

# see if is connected
function network()
{
    local timeout=1
    local target=www.baidu.com

    # get response
    local content=`curl -v --silent http://www.baidu.com 2>&1 | grep eportal/index.jsp`
    if [ ${#content} -lt 10 ]; then
        return 1 # not found, connection is OK
    else
        return 0
    fi
    return 0
}

network

if [ $? -eq 0 ]; then
    date >> ${LOG_FILE}
    echo "Network down！Now try to reconnect ..." >> ${LOG_FILE}
    ret_value=$(curl 'http://172.30.1.1/eportal/InterFace.do?method=login' --data-raw 'userId=2019019&password=xwu%2540wtu19&service=&queryString=wlanuserip%253D0fc9c6b53c1e921727ecfc3c203c9727%2526wlanacname%253Da84104051caf75803ef5a8b1c2dd3bf2%2526ssid%253D%2526nasip%253D341e4e3fc769ac2b8f6da0f0c0ea7b6c%2526snmpagentip%253D%2526mac%253D147f90c1bb2f0ee2b2193b5943592c72%2526t%253Dwireless-v2%2526url%253Dbb2ad0269a7a04240aa6073d044c8c98b8582db9f00bd452%2526apmac%253D%2526nasid%253Da84104051caf75803ef5a8b1c2dd3bf2%2526vid%253Dbcdd3161809e9e57%2526port%253De54400836a444d79%2526nasportid%253Dfeb3b0be4a86447d8ce9f89330800b36f5d9ee69ac864df9dcb82721cc08e52d043658fa5839e64ee462cb81879ebecd&operatorPwd=&operatorUserId=&validcode=')

    echo "login result: ${ret_value}" >> ${LOG_FILE}
    exit -1
else
    date >> ${LOG_FILE}
    echo "Network good" >> ${LOG_FILE}
fi
exit 0
