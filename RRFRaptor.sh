#!/bin/sh

PATH_SCRIPT='/opt/RRFRaptor/RRFRaptor.py'
PATH_LOG='/tmp'
PATH_PID='/tmp'

# Si pas d'argument, on gere tout seul
if [ -z "$1" ]; then
    /usr/bin/pgrep -f 'python /opt/RRFRaptor/RRFRaptor.py'
    pid=$?
    if [ $pid != 1 ]; then
        set -- 'stop'
    else
        set -- 'start'
    fi
fi

case "$1" in
    scan)
        echo "Simple scan RRFRaptor"
        nohup python $PATH_SCRIPT --scan True --debug False &
        ;;
    start)
        echo "Starting RRFRaptor"
        search="python ${PATH_SCRIPT}"
        pkill -f "${search}"
        nohup python $PATH_SCRIPT --sleep 1 --scan False --debug False > $PATH_LOG/RRFRaptor.log 2>&1 &
        echo "201#"> /tmp/dtmf_uhf
        echo "201#"> /tmp/dtmf_vhf
        ;;
    stop) 
        echo "Stopping RRFRaptor"
        search="python ${PATH_SCRIPT}"
        pkill -f "${search}"
        echo "202#"> /tmp/dtmf_uhf
        echo "202#"> /tmp/dtmf_vhf
        ;;
    esac