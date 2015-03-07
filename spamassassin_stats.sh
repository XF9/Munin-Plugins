#!/bin/sh
#
# This Plugin displays SpamassAssins filter results per day
# Inspired by postfix_stats by David Obando
#
# Michael Moehler (m.moehler@xf9.de) - 14.02.2015

# set -xv

case $1 in
        config)
                cat <<'EOF'
graph_title SpamAssassin Results
graph_vlabel Filtered Messages
graph_category Mail
ham.label Ham
ham.draw AREA
spammy.label Spammy
spammy.draw STACK
spam.label Spam
spam.draw STACK
virus.label Virus
virus.draw STACK
blocked.label Blocked Spam
blocked.draw STACK
EOF
        exit 0;;
esac

TMP=`mktemp /tmp/tmp.XXXXXXXX`
cat /var/log/mail.log | grep "$(date '+%b %e')" > $TMP
cat /var/log/mail.log.1 | grep "$(date '+%b %e')" >> $TMP

cat <<EOF
ham.value `grep 'Passed CLEAN' $TMP | wc -l`
spammy.value `grep 'Passed SPAMMY' $TMP | wc -l`
spam.value `grep 'Passed SPAM' $TMP | wc -l`
virus.value `grep 'Passed INFECTED' $TMP | wc -l`
blocked.value `grep 'Blocked SPAM' $TMP | wc -l`
EOF

rm $TMP