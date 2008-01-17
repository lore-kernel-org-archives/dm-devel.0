From: "Nath, Varun" <varun.nath@amd.com>
Subject: RE: Need Help
Date: Thu, 17 Jan 2008 14:24:45 -0600
Message-ID: <EEBC5C82F965344199BFA3E6047FE13302E8F2@SAUSEXMB2.amd.com>
References: <20080117201400.GA7083@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <20080117201400.GA7083@us.ibm.com>
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

Hi,


Is this the script you are talking about?

[root@x rc3.d]# more S13multipathd
#!/bin/bash
#
#       /etc/rc.d/init.d/multipathd
#
# Starts the multipath daemon
#
# chkconfig: - 13 87
# description: Manage device-mapper multipath devices
# processname: multipathd

DAEMON=3D/sbin/multipathd
prog=3D`basename $DAEMON`
initdir=3D/etc/rc.d/init.d
lockdir=3D/var/lock/subsys
sysconfig=3D/etc/sysconfig


system=3Dredhat

if [ $system =3D redhat ]; then
        # Source function library.
        . $initdir/functions
fi

test -r $sysconfig/$prog && . $sysconfig/$prog

RETVAL=3D0

#
# See how we were called.
#

start() {
        test -x $DAEMON || exit 5
        echo -n $"Starting $prog daemon: "
        daemon $DAEMON
        RETVAL=3D$?
        [ $RETVAL -eq 0 ] && touch $lockdir/$prog
        echo
}

stop() {
        echo -n $"Stopping $prog daemon: "
        killproc $DAEMON
        RETVAL=3D$?
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
        RETVAL=3D$?
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
        RETVAL=3D$?
        ;;
*)
        echo $"Usage: $0 {start|stop|status|restart|condrestart|reload}"
        RETVAL=3D3
esac

exit $RETVAL

-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of malahal@us.ibm.com
Sent: Thursday, January 17, 2008 2:14 PM
To: dm-devel@redhat.com
Subject: Re: [dm-devel] Need Help

Chandra Seetharaman [sekharan@us.ibm.com] wrote:
> On Thu, 2008-01-17 at 12:40 -0600, Nath, Varun wrote:
> > I used the /dev/mapper/mpath# also in the fstab but that did not
help.
>=20
> That is odd.
>=20
> When the system boots up completely, do you see the multipath devices,
> or you explicitly run the multipath command to make the multipath
> devices show up ?

RHEL doesn't require anything other than the mere presence of
/etc/mulipath.conf to configure multipath devices. BUT there was a bug
where it was not able to properly use the /etc/multipath.conf file at
boot time when the file system (/var) is mounted read-only. So you get
device names based SCSI WWN. There is an init script that essentially
runs multipathd that renames the 'SCSI WWN' names to user friendly
names (apart from doing the job of path health check).

Make sure you start the multipath[d] rc script.

-Malahal.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
