From: Ray Stell <stellr@cns.vt.edu>
Subject: blacklisted paths?
Date: Mon, 19 Sep 2005 17:16:49 -0400
Message-ID: <20050919211649.GA24756@locust.cns.vt.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

I'm not able to get all "available" paths, 13 out of the 16 this time.  Sometimes
14 come up.   Why might these get blacklisted?  Thanks.

boot msgs:
----------
Sep 19 16:44:32 pecan kernel: qla2300 0000:01:07.0: scsi(0:0:0:0): Enabled tagged queuing, queue depth 32.
Sep 19 16:44:32 pecan kernel: qla2300 0000:01:07.0: scsi(0:0:0:1): Enabled tagged queuing, queue depth 32.
Sep 19 16:44:32 pecan kernel: qla2300 0000:01:07.0: scsi(0:0:0:2): Enabled tagged queuing, queue depth 32.
Sep 19 16:44:32 pecan kernel: qla2300 0000:01:07.0: scsi(0:0:0:3): Enabled tagged queuing, queue depth 32.
Sep 19 16:44:32 pecan kernel: qla2300 0000:01:07.0: scsi(0:0:1:0): Enabled tagged queuing, queue depth 32.
Sep 19 16:44:32 pecan kernel: qla2300 0000:01:07.0: scsi(0:0:1:1): Enabled tagged queuing, queue depth 32.
Sep 19 16:44:32 pecan kernel: qla2300 0000:01:07.0: scsi(0:0:1:2): Enabled tagged queuing, queue depth 32.
Sep 19 16:44:32 pecan kernel: qla2300 0000:01:07.0: scsi(0:0:1:3): Enabled tagged queuing, queue depth 32.
Sep 19 16:44:32 pecan kernel: qla2300 0000:01:0a.0: scsi(1:0:0:0): Enabled tagged queuing, queue depth 32.
Sep 19 16:44:32 pecan kernel: qla2300 0000:01:0a.0: scsi(1:0:0:1): Enabled tagged queuing, queue depth 32.
Sep 19 16:44:33 pecan kernel: qla2300 0000:01:0a.0: scsi(1:0:0:2): Enabled tagged queuing, queue depth 32.
Sep 19 16:44:34 pecan kernel: qla2300 0000:01:0a.0: scsi(1:0:0:3): Enabled tagged queuing, queue depth 32.
Sep 19 16:44:35 pecan kernel: qla2300 0000:01:0a.0: scsi(1:0:1:0): Enabled tagged queuing, queue depth 32.
Sep 19 16:44:35 pecan kernel: qla2300 0000:01:0a.0: scsi(1:0:1:1): Enabled tagged queuing, queue depth 32.
Sep 19 16:44:35 pecan kernel: qla2300 0000:01:0a.0: scsi(1:0:1:2): Enabled tagged queuing, queue depth 32.
Sep 19 16:44:35 pecan kernel: qla2300 0000:01:0a.0: scsi(1:0:1:3): Enabled tagged queuing, queue depth 32.

devmaps:
--------
[root@pecan ~]# multipath -ll
1IBM_____2105____________30A22206
[size=19 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [active]
  \_ 0:0:0:1 sdb  8:16    [ready ][active]
  \_ 1:0:0:1 sdj  8:144   [ready ][active]
  \_ 1:0:1:1 sdn  8:208   [ready ][active]

1IBM_____2105____________50A22206
[size=19 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [active]
  \_ 0:0:0:0 sda  8:0     [ready ][active]
  \_ 0:0:1:0 sde  8:64    [ready ][active]
  \_ 1:0:0:0 sdi  8:128   [ready ][active]

1IBM_____2105____________72622206
[size=19 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [active]
  \_ 0:0:0:2 sdc  8:32    [ready ][active]
  \_ 0:0:1:2 sdg  8:96    [ready ][active]
  \_ 1:0:0:2 sdk  8:160   [ready ][active]
  \_ 1:0:1:2 sdo  8:224   [ready ][active]

1IBM_____2105____________72722206
[size=19 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [active]
  \_ 0:0:0:3 sdd  8:48    [ready ][active]
  \_ 1:0:0:3 sdl  8:176   [ready ][active]
  \_ 1:0:1:3 sdp  8:240   [ready ][active]

The devs that fall out have been blacklisted:
---------------------------------------------
[root@pecan ~]# multipath  -v3 -d | grep blacklist
dm-0 blacklisted
dm-1 blacklisted
dm-2 blacklisted
dm-3 blacklisted
dm-4 blacklisted
dm-5 blacklisted
fd0 blacklisted
hda blacklisted
hdb blacklisted
hdc blacklisted
md0 blacklisted
ram0 blacklisted
ram10 blacklisted
ram11 blacklisted
ram12 blacklisted
ram13 blacklisted
ram14 blacklisted
ram15 blacklisted
ram1 blacklisted
ram2 blacklisted
ram3 blacklisted
ram4 blacklisted
ram5 blacklisted
ram6 blacklisted
ram7 blacklisted
ram8 blacklisted
ram9 blacklisted
sdf blacklisted
sdh blacklisted
sdm blacklisted

environment:
 - rhas4 U2 Beta - Linux pecan 2.6.9-16.EL #1 Mon Aug 15 19:58:49 EDT 2005 i686 i686 i386 GNU/Linux
 - multipath-tools-0.4.5.49. compiled from ftp://sources.redhat.com/pub/dm/multipath-tools
    one-off patch of mpath_faker.c
 - 2 QLogic PCI to Fibre Channel Host Adapters for QLA2340:
   Firmware version 3.03.15 IPX, Driver version 8.01.00b5-rh2
 - IBM ESS 2105F20 4 paths
============================================================
Ray Stell  stellr@vt.edu  (540) 231-4109  Tempus fugit  28^D
