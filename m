From: Eddie Williams <Eddie.Williams@steeleye.com>
Subject: dm-emc: switchover fails when devices is reserved
Date: Thu, 27 Apr 2006 13:00:47 -0400
Message-ID: <1146157247.5021.16.camel@gator.sc.steeleye.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0956212311=="
Return-path: <dm-devel-bounces@redhat.com>
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
Cc: lmb@suse.de
List-Id: dm-devel.ids


--===============0956212311==
Content-Type: multipart/alternative; boundary="=-PVtXTFPKorY/pjTQ7DXS"


--=-PVtXTFPKorY/pjTQ7DXS
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


The dm-emc module does not seem to be able to switchover a path on an
EMC CX array when the device is reserved (I am reserving the device
using SCSI-3 persistent reservations).  I believe the problem is due to
the default behavior of the dm-emc module to not honor reservations:
   /* Whether or not to honor SCSI reservations when initiating a
    * switch-over. Default: Don't. */

With the default setting I get the following errors:
Apr 26 11:08:14 titan kernel: device-mapper: dm-multipath: 67:48
(#715918): IO error - error: -5 - bi_rw: 8 - bi_flags: 10000018 -
bi_error: 02020403
Apr 26 11:08:14 titan kernel: device-mapper: dm-emc: emc_err: 715918: LU
Not Ready, bypassing PG
Apr 26 11:08:14 titan kernel: device-mapper: dm-multipath: bypass_pg: 2
Apr 26 11:08:14 titan kernel: device-mapper: dm-multipath: 67:48
(#715902): Requeued sector as #90
Apr 26 11:08:14 titan kernel: device-mapper: dm-emc: emc_pg_init:
sending switch-over command
Apr 26 11:08:14 titan kernel: scsi2 (0,0,6) : reservation conflict
Apr 26 11:08:14 titan kernel: SCSI error : <2 0 0 6> return code = 0x18
Apr 26 11:08:14 titan kernel: device-mapper: dm-emc: emc_endio: pg_init
error -5

The switchover is not successful.  If I release the reservation the
switch-over works.

I recompiled dm-emc so that the default behavior is to honor
reservations.  When I cause the same scenario as above I now get:
Apr 27 12:15:39 titan kernel: device-mapper: dm-multipath: 68:240 (#8):
IO error - error: -5 - bi_rw: 8 - bi_flags: 18 - bi_error: 01000005
Apr 27 12:15:39 titan kernel: device-mapper: dm-multipath: Failing path
68:240
Apr 27 12:15:39 titan kernel: device-mapper: dm-multipath: 68:240 (#0):
Requeued sector as #1
Apr 27 12:15:39 titan kernel: device-mapper: dm-emc: emc_pg_init:
sending switch-over command

At that point the path is activated and IO's continue.

Is there a reason for the default behavior to be not to honor
reservations?  Is there an easier way to change the default behavior of
the hardware handler other than rebuilding it?

Thanks

Eddie Williams

--=-PVtXTFPKorY/pjTQ7DXS
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 TRANSITIONAL//EN">
<HTML>
<HEAD>
  <META HTTP-EQUIV="Content-Type" CONTENT="text/html; CHARSET=UTF-8">
  <META NAME="GENERATOR" CONTENT="GtkHTML/3.6.2">
</HEAD>
<BODY>
<BR>
The dm-emc module does not seem to be able to switchover a path on an EMC CX array when the device is reserved (I am reserving the device using SCSI-3 persistent reservations).&nbsp; I believe the problem is due to the default behavior of the dm-emc module to not honor reservations:<BR>
&nbsp;&nbsp; /* Whether or not to honor SCSI reservations when initiating a<BR>
&nbsp;&nbsp;&nbsp; * switch-over. Default: Don't. */<BR>
<BR>
With the default setting I get the following errors:<BR>
Apr 26 11:08:14 titan kernel: device-mapper: dm-multipath: 67:48 (#715918): IO error - error: -5 - bi_rw: 8 - bi_flags: 10000018 - bi_error: 02020403<BR>
Apr 26 11:08:14 titan kernel: device-mapper: dm-emc: emc_err: 715918: LU Not Ready, bypassing PG<BR>
Apr 26 11:08:14 titan kernel: device-mapper: dm-multipath: bypass_pg: 2<BR>
Apr 26 11:08:14 titan kernel: device-mapper: dm-multipath: 67:48 (#715902): Requeued sector as #90<BR>
Apr 26 11:08:14 titan kernel: device-mapper: dm-emc: emc_pg_init: sending switch-over command<BR>
Apr 26 11:08:14 titan kernel: scsi2 (0,0,6) : reservation conflict<BR>
Apr 26 11:08:14 titan kernel: SCSI error : &lt;2 0 0 6&gt; return code = 0x18<BR>
Apr 26 11:08:14 titan kernel: device-mapper: dm-emc: emc_endio: pg_init error -5<BR>
<BR>
The switchover is not successful.&nbsp; If I release the reservation the switch-over works.<BR>
<BR>
I recompiled dm-emc so that the default behavior is to honor reservations.&nbsp; When I cause the same scenario as above I now get:<BR>
Apr 27 12:15:39 titan kernel: device-mapper: dm-multipath: 68:240 (#8): IO error - error: -5 - bi_rw: 8 - bi_flags: 18 - bi_error: 01000005<BR>
Apr 27 12:15:39 titan kernel: device-mapper: dm-multipath: Failing path 68:240<BR>
Apr 27 12:15:39 titan kernel: device-mapper: dm-multipath: 68:240 (#0): Requeued sector as #1<BR>
Apr 27 12:15:39 titan kernel: device-mapper: dm-emc: emc_pg_init: sending switch-over command<BR>
<BR>
At that point the path is activated and IO's continue.<BR>
<BR>
Is there a reason for the default behavior to be not to honor reservations?&nbsp; Is there an easier way to change the default behavior of the hardware handler other than rebuilding it?<BR>
<BR>
Thanks<BR>
<BR>
Eddie Williams
</BODY>
</HTML>

--=-PVtXTFPKorY/pjTQ7DXS--


--===============0956212311==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0956212311==--
