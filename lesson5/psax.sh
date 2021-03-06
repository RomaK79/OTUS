#!/bin/bash

function pids {
    PID=$*
    for i in $PID
    do
       
        if [[ -e /proc/$i/environ && -e /proc/$i/stat ]]; then

            cd /proc
            
            
            # PID
            FPid=`awk '{ printf "%7d", $1 }' $i/stat`

            # TTY
            Tty_nr=`awk '{printf $7}' $i/stat`

            # STATE
            FState=`awk '{ printf "%1s", $3 }' $i/stat`
            SLead=`awk '{ printf $6 }' $i/stat`
            Nice=`awk '{ printf $19 }' $i/stat` 
            Threads=`awk '{ printf $20 }'  $i/stat`
            VmLPages=`grep VmFlags $i/smaps | grep lo`
            ProcGrForegr=`awk '{ printf $8 }' $i/stat`

            # Command
            FCommand=`cat $i/cmdline`

            # Field STAT
            ## Flag 'l'(threads)
            [[ $Threads -gt 1 ]] && Threads='l' || Threads=''
            ## Flag 'L'(vm lock pages)
            [[ -n $VmLPages ]] && VmLPages='L' || VmLPages=''
            ## Flag '+' foreground process group
            [[ $ProcGrForegr -eq "-1" ]] && ProcGrForegr='' || ProcGrForegr='+'
            ## Flag 's' session leader
            [[ $SLead -eq $i ]] && SLead='s' || SLead=''
            ## Flag '<' or 'N' priority (the lowest pri. is 20 and the highest pri. is -19)
            if [[ $Nice -lt 0 ]]; then Nice='<'; elif [[ $Nice -gt 0 ]]; then Nice='N'; else Nice=''; fi
            
            # TTY
            ## Flag 'pts|tty' or tty_nr - terminal tty which uses process (pseudo terminal slave and teletype)
            [[ Tty_nr -eq 0 ]] && TTY='?' || TTY=`ls -l $i/fd/ | grep -E 'tty|pts' | cut -d\/ -f3,4 | uniq`
            
            # Field COMMAND, second try to find command
            [[ -z $FCommand ]] && FCommand=`cat $i/stat | awk '{ printf "%10s", $2 }' | tr '(' '[' | tr ')' ']'`
        fi

        #Result
        
        Stat="$FState$Nice$SLead$Threads$VmLPages$ProcGrForegr"
        printf "%5d %-6s %-7s %s\n" "$FPid" "$TTY" "$Stat" "$FCommand"
    done
}

# Get numbers to $PID
PID=`ls /proc | grep -E '[[:digit:]]' | sort -n | xargs`
# Header of columns
echo "  PID TTY    STAT    COMMAND"
# Output values(parametrs) of $PIDs
pids $PID
