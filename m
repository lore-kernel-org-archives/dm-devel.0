From: Alasdair G Kergon <agk@redhat.com>
Subject: multipathd.init
Date: Fri, 1 Apr 2005 21:40:48 +0100
Message-ID: <20050401204048.GI14307@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="X1bOJ3K7DJ5YkBrT"
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Attached is a cleaned-up version of multipathd init script - at least 
for Red Hat based systems.

While it uses the standard daemon-handling functions, it's still only 
suitable for a few situations though.

If you have / on dm-multipath, the daemon has to be started from
the initrd - so you don't want it stopping/starting from init.d,
but you might want to HUP it.

If you have other system parts of your filesystem (e.g. /usr) you 
want the daemon starting from rc.sysinit.

If you have data filesystems over multipath, you want something
to mount them after multipathd starts.

And you might also have cryptsetup, md, lvm2, kpartx involved
- in various combinations...

So you could have a multi-level startup with multiple instances
of multipathd each configured to manage only a subset of devices.
Then the init.d multipathd script would only kill the daemon
instance started during by the init.d script, and would leave
alone the instances managing / and /usr.

Or you could forget completely about init.d and /var/lock/subsys
and /var/run and just launch the daemon from the initrd or
failing that from rc.sysinit.

Then you would need a new mechanism to manage it.
(ie a dedicated client program that communicates with it e.g. via
shared memory)
I anticipate that something like this is the right way to go.

That client program could even be 'dmsetup' if the daemon functionality
could be incorporated into plug-ins: The various types of mirroring 
have similar requirements, so it's sensible to have a single
daemon infrastructure for them all.

Alasdair
-- 
agk@redhat.com

--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Description: multipathd
Content-Disposition: attachment; filename=multipathd

#!/bin/bash

#
#	/etc/rc.d/init.d/multipathd
#
# Starts the multipath daemon
#
# chkconfig: 2345 13 87
# description: Manage device-mapper multipath devices
# processname: multipathd

DAEMON=/sbin/multipathd
prog=`basename $DAEMON`
initdir=/etc/rc.d/init.d
lockdir=/var/lock/subsys
sysconfig=/etc/sysconfig

 
system=redhat
 
if [ $system = redhat ]; then
	# Source function library.
	. $initdir/functions
fi
 
test -x $DAEMON || exit 0
test -r $sysconfig/$prog && . $sysconfig/$prog

RETVAL=0

#
# See how we were called.
#

start() {
	echo -n $"Starting $prog daemon: "
	daemon $DAEMON
	RETVAL=$?
	[ $RETVAL -eq 0 ] && touch $lockdir/$prog
	echo
}

stop() {
	echo -n $"Stopping $prog daemon: "
	killproc $DAEMON
	RETVAL=$?
	[ $RETVAL -eq 0 ] && rm -f $lockdir/$prog
	echo
}

restart() {
	stop
	start
}	

reload() {
	echo -n "Reloading $prog: "
	trap "" SIGHUP
	killproc $DAEMON -HUP
	RETVAL=$?
	echo
}	

case "$1" in
start)
	start
	;;
stop)
	stop
	;;
reload)
	reload
	;;
restart)
	restart
	;;
condrestart)
	if [ -f $lockdir/$prog ]; then
	    restart
	fi
	;;
status)
	status $prog
	RETVAL=$?
	;;
*)
	echo $"Usage: $0 {start|stop|status|restart|condrestart|reload}"
	RETVAL=1
esac

exit $RETVAL

--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--X1bOJ3K7DJ5YkBrT--
