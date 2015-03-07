#!/bin/bash
#
# Plugin displays commits for a set of SVN repositories
# Michael Moehler (m.moehler@xf9.de) - 14.02.2015
#

# set -xv

REPOS=/srv/svn/repos/

case $1 in
        config)
                cat <<'EOF'
graph_title SVN Commits
graph_vlabel Changed Files
graph_category svn
add.label Add
add.draw AREA
add.colour 2E93D1
modified.label Modifed
modified.draw STACK
modified.colour 4FD12E
deleted.label Deleted
deleted.draw STACK
deleted.colour CCCCCC
replaced.label Replaced
replaced.draw STACK
replaced.colour AAAAAA
EOF
        exit 0;;
esac

ADD=0
MOD=0
DEL=0
REP=0

for directory in $REPOS*/
do
        DIR=${directory%*/}
        NAME=${DIR##*/}

        TMP=`mktemp /tmp/tmp.XXXXXXXX`
        svn log -vq -r {"$(date +'%Y-%m-%d') 00:01"}:{"$(date +'%Y-%m-%d') 23:59"} file://$DIR > $TMP
        sed -i.bak "1,/----/d" $TMP

        LINECOUNT=$(wc -l < $TMP)
        if [ $LINECOUNT -gt 0 ]
        then
                ADD=$(( $ADD + `grep '   A' $TMP | wc -l` ))
                MOD=$(( $MOD + `grep '   M' $TMP | wc -l` ))
                DEL=$(( $DEL + `grep '   D' $TMP | wc -l` ))
                REP=$(( $REP + `grep '   R' $TMP | wc -l` ))
        fi

        rm $TMP
done

cat <<EOF
add.value $ADD
modified.value $MOD
deleted.value $DEL
replaced.value $REP
EOF