#! /bin/bash
func_procss (){


}

#handle arguments
for arg in "$@"
do
        case $arg in
        -c)
                echo "ping only"
                PINGS=TRUE
                shift
        ;;
        -t)
                echo "timeout only"
                TIMEOUT=TRUE
                shift
        ;;
        -u)
                echo "user only"
                USER=TRUE
                shift
        ;;
        -ct|-tc)
                echo "ping + timeout only"
                PINGS=TRUE
                TIMEOUT=TRUE
                shift
        ;;
        -cu|-uc)
                echo "ping + user only"
                PINGS=TRUE
                USER=TRUE
                shift
        ;;
        -tu|-ut)
                echo "user +timeout only"
                USER=TRUE
                TIMEOUT=TRUE
                shift
        ;;
        -ctu|-cut|-utc|-uct|-tuc|-tcu)
                echo "all"
                PINGS=TRUE
                USER=TRUE
                TIMEOUT=TRUE
                shift
        ;;
        esac
done