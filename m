From: krishna here <krishnambm@yahoo.com>
Subject: Problem with state updation in Device mapper
Date: Tue, 4 Oct 2005 04:59:11 -0700 (PDT)
Message-ID: <20051004115911.36574.qmail@web32808.mail.mud.yahoo.com>
References: <20051001160056.AE84172DF8@hormel.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20051001160056.AE84172DF8@hormel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: krishnambm@yahoo.com, christophe.varoqui@free.fr
List-Id: dm-devel.ids

Christophe,

I have been following the dm and multipath tools
mailing lists for a while now.

I was trying to setup the MPIO using iSCSI Initiator
and target setup. this is what i was using

a. multipath-tools package0.4.4
b. Linux kernel 2.6.12 and devmapper (recompiled).
c. multipath configuration file is

......
devnode_blacklist {
        wwid 26353900f02796769
	devnode "(ram|raw|loop|fd|sr|scd|st)[0-9]*"
	devnode "hd*]"
	devnode "cciss!c[0-9]d[0-9]*[p[0-9]*]"
}
......


devices {
	device {
		vendor			"COMPAQ  "
		product			"HSV110 (C)COMPAQ"
		path_grouping_policy	failover
		getuid_callout          "/sbin/scsi_id -g -u -s
/block/%n"
		path_checker		readsector0
		path_selector		"round-robin 0"
		features		"1 queue_if_no_path"
		hardware_handler	"0"
	}
	device {
		vendor			"SIMU TGT"
		product			"0000           "
		path_grouping_policy	failover
		getuid_callout          "/sbin/scsi_id -g -u -s
/block/%n"
		path_checker		readsector0
		path_selector		"round-robin 0"
		features		"1 queue_if_no_path"
		hardware_handler	"0"
	}
}

........... bla bla


Basically Vendor is "SIMU TGT" and Product is "0000 =20
" which i get in SCSI INQUIRY information.

If dm is created using the below file, and multipath
daemon is run.

dmcreate.sh script file
START=3D0
END=3D199873
#Two Path groups - One Path each
echo "$START $END multipath 0 0 2 1 round-robin 0 1 1
8:0 1000 round-robin 0 1 1 8:16 1000" | dmsetup create
target

Observations:
Say 8:0 is Path A,
    8:16 is Path B.
1. multipath shows both paths as [ready] [active]
properly
2. Run some I/O on dm-0, I/O flows on Path A
3. Pull out cable A --> Path A is down
4. I/O fails over to Path B
5. multipath shows [faulty] [failed] for Path A
6. Put back the cable A --> Path A is up
7. multipath shows [ready] [failed] ????
8. After some debugging i found that daemon is calling

/sbin/multipath -v 0 8:0 when the path comes up.
9. But this does not cause any change in the path
state to active.
10. If path B is down, I/O fails on dm-0.


The situation is similar to below problem, Can some
one  help me to know,
--- if the multipath.conf is wrong
--- I have also checked the bug mentioned below and
the check is (newstate !=3D pp->state)
--- or some bug in the dm.
--- Pls let me know if I am not mailing in the correct
list.

Thanks
Krishna MBM

------------------------------------------------------
Re: [dm-devel] path priority group and path state

    * From: Christophe Varoqui <christophe varoqui
free fr>
    * To: device-mapper development <dm-devel redhat
com>
    * Subject: Re: [dm-devel] path priority group and
path state
    * Date: Tue, 15 Feb 2005 22:35:55 +0100

Caushik, Ramesh wrote:
    Given that some of the problems I am noticing in
my testing relates to mismatch between the path state
recorded by the driver and the daemon, I thought I
will chime in with my questions / observations.
    My setup consists of a dual port qla2312
controller connected to a JBOD through a FC switch
thus creating 2 paths A & B to the drive. I have all
the paths in one PG using round-robin selector and
"queue if no path"    set. I run a bonnie++ transfer
to the mounted drive, and then pull out the path A
connection. When the transfer switches to path B I
reinsert A and then after a little while pull out B
and repeat this a few times. Sometimes the transfer
just hangs and the log messages indicate the driver is
queueing the i/o (both paths are marked faulty). This
is what seems to happen. When the cable on path A is
pulled out the controller    receives a "LOOP DOWN" on
that port and ALSO a "LIP RESET" on path B. This
causes i/o on both paths to return SCSI error and so
both paths are set faulty (some of the in-flight i/o
on path B fails as a result of the LIP RESET). However
when the daemon checker loop wakes up and tests the
path (via checkfn) path B returns OK, and since the
daemon will reconfigure the paths only if newstate !=3D
oldstate it does not reconfigure the path. As a
result, we end up with a situation where the driver
marks path B as faulty due to i/o error in the path,
and waits for the daemon to reconfigure the path,
while the daemon does not  reconfigure path B because
the checkfn does not detect a state change.

    First of all please tell me if this analyses is
correct. If it is then my suggestion is for the daemon
checker loop to reinstate the path anytime the there
is a mismatch between the path state in the driver and
   that returned by the checkfn, and not just based on
the newstate !=3D oldstate check. I am in the process of
coding this up to see if it will fix the problem.
Meanwhile I would much appreciate any comments or =20
suggestions on this.=20
                                    Thanks,
                                    Ramesh.

Agreed : this is a real hole in the design.
Suggested solution seems sane.


=09
	=09
______________________________________________________=20
Yahoo! for Good=20
Donate to the Hurricane Katrina relief effort.=20
http://store.yahoo.com/redcross-donate3/=20
