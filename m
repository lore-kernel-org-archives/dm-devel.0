From: "Craig Simpson" <csimpson@visto.com>
Subject: RE: Deadlock on RHEL4 with kpartx/queue_if_no_path - any
	wayout?
Date: Mon, 19 May 2008 15:18:23 -0700
Message-ID: <ABFD05FF09D13E4883B757E75603624DF9BF7B@ex-sea1.vistocorp.com>
References: <483141BE.2010304@linpro.no>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <483141BE.2010304@linpro.no>
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



multipathd -k
reconfigure

maybe....

--
=20
Craig Simpson


"In the circle the beginning and the end are common"
 ~ Heraclitis (540-480BC)

=20


-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of Tore Anderson
Sent: Monday, May 19, 2008 2:01 AM
To: device-mapper development
Subject: [dm-devel] Deadlock on RHEL4 with kpartx/queue_if_no_path - any
wayout?

Hi.  Due to a PEBCAK and wrong paths being removed I've now ended up
in this situation:

$ multipath -ll multimedia
multimedia (3600a0b80002984ae00001da546c27de1)
[size=3D200 GB][features=3D"1 queue_if_no_path"][hwhandler=3D"0"]
\_ round-robin 0 [enabled]
 \_ #:#:#:#  -    65:16  [failed][faulty]

I readded the paths with 'echo - - - > /sys/class/scsi_host/host*/scan',
but the map does not get healthy - all attempts to reload the map with
the multipath tools ends up in blocking I/O, using dmsetup directly I
only get failures due to the map being busy.

This is how the process list looks:

$ ps axf
  PID TTY      STAT   TIME COMMAND
[...]
11598 ?        SLl    0:01 /sbin/multipathd
12080 ?        S<     0:00 /bin/sh /etc/dev.d/block/multipath.dev block
12087 ?        S<     0:00  \_ /sbin/dmsetup ls -j 253 -m 3 --target
multipath --exec /sbin/kpartx -a
12088 ?        D<     0:00      \_ /sbin/kpartx -a
/dev/mapper/multimedia
12714 ?        S<     0:00 /bin/sh /etc/dev.d/block/multipath.dev block
12720 ?        S<     0:00  \_ /sbin/multipath -v0 /dev/sdb
12794 ?        S<     0:00 /bin/sh /etc/dev.d/block/multipath.dev block
12800 ?        D<     0:00  \_ /sbin/multipath -v0 /dev/sdc
12831 ?        D      0:00 multipath -v 2
14132 ?        S<     0:00 /bin/sh /etc/dev.d/block/multipath.dev block
14139 ?        S<     0:00  \_ /sbin/dmsetup ls -j 253 -m 3 --target
multipath --exec /sbin/kpartx -a
14140 ?        D<     0:00      \_ /sbin/kpartx -a
/dev/mapper/multimedia
14219 ?        S<     0:00 /bin/sh /etc/dev.d/block/multipath.dev block
14225 ?        D<     0:00  \_ /sbin/multipath -v0 /dev/sdd
14255 ?        D      0:00 multipath -v 2
15312 ?        D      0:00 multipath /dev/sdd
17032 ?        D      0:00 multipath
 1008 ?        S<     0:00 /bin/sh /etc/dev.d/block/multipath.dev block
 1014 ?        D<     0:00  \_ /sbin/multipath -v0 /dev/sde

...I assume the kpartx process is locking the map so no changes can be
done, but since there's no alive paths and queue_if_no_path is active,
it will never return, and I'm stuck in a deadlock.

Is there any way out of this save a reboot?

Regards,
--=20
Tore Anderson

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
