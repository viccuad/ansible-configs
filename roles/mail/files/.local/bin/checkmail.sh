#!/bin/sh

LC_ALL=C

STATE=`nmcli networking connectivity check`

if [ $STATE = 'full' ]
then
    ~/bin/msmtp-queue # send mail
    r2e run # recollect rss feeds to local mail
    mbsync meviccuadme # sync mail # TODO does this sync mail back?
    notmuch new # find and import new messages to notmuch db, with tag `new`
    # TODO notmuch tag the maildir back with `notmuch tags`?
    afew --tag --new # run tag filters, operate on `new` messages
    # afew -v --tag --new
    # afew -v --move-mail # move mails between maildir folders depending on their tags
    exit 0
fi
echo "No internet connection."
exit 0
