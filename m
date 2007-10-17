From: "Gerald Nowitzky" <Nowitzky@igne.de>
Subject: Re: multibus / failover and EMC CX600
Date: Wed, 17 Oct 2007 21:38:56 +0200
Message-ID: <06b201c810f5$5b7782d0$0a00a8c0@ALDI2>
References: <061401c810a7$cac685d0$0a00a8c0@ALDI2><4715E6A4.7060308@linpro.no>	<4715ED28.9020102@suse.de><471600F7.5090607@linpro.no>
	<066001c810cc$cd9f6f90$0a00a8c0@ALDI2> <471631E5.9050603@linpro.no>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1152962555=="
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.

--===============1152962555==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_06AF_01C81106.1EAF4CA0"

This is a multi-part message in MIME format.

------=_NextPart_000_06AF_01C81106.1EAF4CA0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable

not much difference with 2.6.23.1:

Oct 17 22:33:56 SANfile_m kernel: kobject_add failed for 1:0:1:0 with =
-EEXIST, don't try to register things with
the same name in the same directory.
Oct 17 22:33:56 SANfile_m kernel:  [<c03074d5>] =
kobject_shadow_add+0x115/0x1b0
Oct 17 22:33:56 SANfile_m kernel:  [<c03a8f58>] device_add+0xa8/0x5a0
Oct 17 22:33:56 SANfile_m kernel:  [<c02fc582>] =
__blk_queue_init_tags+0x32/0x70
Oct 17 22:33:56 SANfile_m kernel:  [<c03fb8af>] =
scsi_sysfs_add_sdev+0x4f/0x220
Oct 17 22:33:56 SANfile_m kernel:  [<f99498b7>] =
qla2xxx_slave_configure+0x77/0x110 [qla2xxx]
Oct 17 22:33:56 SANfile_m kernel:  [<c03f986a>] =
scsi_probe_and_add_lun+0x92a/0x950
Oct 17 22:33:56 SANfile_m kernel:  [<c03fa26d>] =
__scsi_scan_target+0x4fd/0x5b0
Oct 17 22:33:56 SANfile_m kernel:  [<c03fa954>] =
scsi_scan_target+0x94/0xc0
Oct 17 22:33:56 SANfile_m kernel:  [<c04014f0>] =
fc_scsi_scan_rport+0x0/0x90
Oct 17 22:33:56 SANfile_m kernel:  [<c0401568>] =
fc_scsi_scan_rport+0x78/0x90
Oct 17 22:33:56 SANfile_m kernel:  [<c013e963>] run_workqueue+0x73/0x100
Oct 17 22:33:56 SANfile_m kernel:  [<c0142350>] =
autoremove_wake_function+0x0/0x50
Oct 17 22:33:56 SANfile_m kernel:  [<c013f3dc>] worker_thread+0x9c/0x100
Oct 17 22:33:56 SANfile_m kernel:  [<c0142350>] =
autoremove_wake_function+0x0/0x50
Oct 17 22:33:56 SANfile_m kernel:  [<c013f340>] worker_thread+0x0/0x100
Oct 17 22:33:56 SANfile_m kernel:  [<c0142082>] kthread+0x42/0x70
Oct 17 22:33:56 SANfile_m kernel:  [<c0142040>] kthread+0x0/0x70
Oct 17 22:33:56 SANfile_m kernel:  [<c0105e6f>] =
kernel_thread_helper+0x7/0x18
Oct 17 22:33:56 SANfile_m kernel:  =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Oct 17 22:33:56 SANfile_m kernel: error 1

  ----- Original Message -----=20
  From: Tore Anderson=20
  To: device-mapper development=20
  Sent: Wednesday, October 17, 2007 6:01 PM
  Subject: Re: [dm-devel] multibus / failover and EMC CX600


  * Gerald Nowitzky

  > The mpath_prio_emc with group_by_prio did the trick. Thanks!
  > =20
  > But I am still loosing the paths to the failed devices. I Increased
  > dev_loss_tmo, but the maximum seems to be about 600 - thus, after 10
  > Minutes, the paths fail:

  The maximum is indeed 600 seconds in 2.6.23.

  > SANfile_m linux # multipath -l
  > hcfshare (360060160c820080063502869e459dc11) dm-0 ,
  > [size=3D3.4T][features=3D1 queue_if_no_path][hwhandler=3D1 emc]
  > \_ round-robin 0 [prio=3D0][enabled]
  >  \_ #:#:#:# -   #:#   [failed][undef]
  >  \_ #:#:#:# -   #:#   [failed][undef]
  > \_ round-robin 0 [prio=3D0][active]
  >  \_ 2:0:0:0 sdd 8:48  [active][undef]
  >  \_ 1:0:0:0 sdb 8:16  [active][undef]
  > If I put them online again, I run into the -EEXIST prob. Async SCSI
  > scanning *is* off in my kernel, so the only thing I could do from
  > here is to try the patch, is it?

  Matthew Wilcox' patch solved this particular problem for me, yes.  I
  still had some problems with -EEXIST when unloading and re-inserting =
the
  HBA driver module, though, but that's a corner case I rarely run into
  (as well as being easily worked around by trying again).

  Come to think of it, you never said which kernel version you're =
running...?

  > Oct 17 17:26:36 SANfile_m kernel: kobject_add failed for 1:0:1:0 =
with
  > -EEXIST, don't try to register things with the same name in the same
  > directory.

  One suggestion...  If the sysfs object is still around, you might be
  able to delete it manually by running =C2=ABecho 1 >
  /sys/class/scsi_device/1:0:1:0/device/delete=C2=BB.  If that works, =
you can
  try to rescan again by doing =C2=ABecho 0 1 0 >
  /sys/class/scsi_host/host1/scan=C2=BB.  With some luck it'll work...

  If it does, most of the time udev will notice and alert multipath to
  check out the new device.  Sometimes it doesn't work, though - simply
  run the =C2=ABmultipath=C2=BB command manually in that case.

  By the way - the =C2=AB1=C2=BB in =C2=ABhost1=C2=BB maps to the first =
digit in =C2=AB1:0:1:0=C2=BB,
  while the =C2=AB0 1 0=C2=BB in the echo command to the last three.

  Regards
  --=20
  Tore Anderson

  --
  dm-devel mailing list
  dm-devel@redhat.com
  https://www.redhat.com/mailman/listinfo/dm-devel
------=_NextPart_000_06AF_01C81106.1EAF4CA0
Content-Type: text/html;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable

=EF=BB=BF<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=3DContent-Type content=3D"text/html; charset=3Dutf-8">
<META content=3D"MSHTML 6.00.2900.2802" name=3DGENERATOR>
<STYLE></STYLE>
</HEAD>
<BODY bgColor=3D#ffffff>
<DIV><FONT face=3DArial size=3D2>not much&nbsp;difference with=20
2.6.23.1:</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>Oct 17 22:33:56 SANfile_m kernel: =
kobject_add=20
failed for 1:0:1:0 with -EEXIST, don't try to register things =
with<BR>the same=20
name in the same directory.<BR>Oct 17 22:33:56 SANfile_m kernel:&nbsp;=20
[&lt;c03074d5&gt;] kobject_shadow_add+0x115/0x1b0<BR>Oct 17 22:33:56 =
SANfile_m=20
kernel:&nbsp; [&lt;c03a8f58&gt;] device_add+0xa8/0x5a0<BR>Oct 17 =
22:33:56=20
SANfile_m kernel:&nbsp; [&lt;c02fc582&gt;]=20
__blk_queue_init_tags+0x32/0x70<BR>Oct 17 22:33:56 SANfile_m =
kernel:&nbsp;=20
[&lt;c03fb8af&gt;] scsi_sysfs_add_sdev+0x4f/0x220<BR>Oct 17 22:33:56 =
SANfile_m=20
kernel:&nbsp; [&lt;f99498b7&gt;] qla2xxx_slave_configure+0x77/0x110=20
[qla2xxx]<BR>Oct 17 22:33:56 SANfile_m kernel:&nbsp; [&lt;c03f986a&gt;]=20
scsi_probe_and_add_lun+0x92a/0x950<BR>Oct 17 22:33:56 SANfile_m =
kernel:&nbsp;=20
[&lt;c03fa26d&gt;] __scsi_scan_target+0x4fd/0x5b0<BR>Oct 17 22:33:56 =
SANfile_m=20
kernel:&nbsp; [&lt;c03fa954&gt;] scsi_scan_target+0x94/0xc0<BR>Oct 17 =
22:33:56=20
SANfile_m kernel:&nbsp; [&lt;c04014f0&gt;] =
fc_scsi_scan_rport+0x0/0x90<BR>Oct 17=20
22:33:56 SANfile_m kernel:&nbsp; [&lt;c0401568&gt;]=20
fc_scsi_scan_rport+0x78/0x90<BR>Oct 17 22:33:56 SANfile_m kernel:&nbsp;=20
[&lt;c013e963&gt;] run_workqueue+0x73/0x100<BR>Oct 17 22:33:56 SANfile_m =

kernel:&nbsp; [&lt;c0142350&gt;] =
autoremove_wake_function+0x0/0x50<BR>Oct 17=20
22:33:56 SANfile_m kernel:&nbsp; [&lt;c013f3dc&gt;]=20
worker_thread+0x9c/0x100<BR>Oct 17 22:33:56 SANfile_m kernel:&nbsp;=20
[&lt;c0142350&gt;] autoremove_wake_function+0x0/0x50<BR>Oct 17 22:33:56=20
SANfile_m kernel:&nbsp; [&lt;c013f340&gt;] =
worker_thread+0x0/0x100<BR>Oct 17=20
22:33:56 SANfile_m kernel:&nbsp; [&lt;c0142082&gt;] =
kthread+0x42/0x70<BR>Oct 17=20
22:33:56 SANfile_m kernel:&nbsp; [&lt;c0142040&gt;] =
kthread+0x0/0x70<BR>Oct 17=20
22:33:56 SANfile_m kernel:&nbsp; [&lt;c0105e6f&gt;]=20
kernel_thread_helper+0x7/0x18<BR>Oct 17 22:33:56 SANfile_m kernel:&nbsp; =

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<BR>=
Oct 17 22:33:56 SANfile_m kernel: error=20
1<BR></FONT></DIV>
<BLOCKQUOTE=20
style=3D"PADDING-RIGHT: 0px; PADDING-LEFT: 5px; MARGIN-LEFT: 5px; =
BORDER-LEFT: #000000 2px solid; MARGIN-RIGHT: 0px">
  <DIV style=3D"FONT: 10pt arial">----- Original Message ----- </DIV>
  <DIV=20
  style=3D"BACKGROUND: #e4e4e4; FONT: 10pt arial; font-color: =
black"><B>From:</B>=20
  <A title=3Dtore@linpro.no href=3D"mailto:tore@linpro.no">Tore =
Anderson</A> </DIV>
  <DIV style=3D"FONT: 10pt arial"><B>To:</B> <A =
title=3Ddm-devel@redhat.com=20
  href=3D"mailto:dm-devel@redhat.com">device-mapper development</A> =
</DIV>
  <DIV style=3D"FONT: 10pt arial"><B>Sent:</B> Wednesday, October 17, =
2007 6:01=20
  PM</DIV>
  <DIV style=3D"FONT: 10pt arial"><B>Subject:</B> Re: [dm-devel] =
multibus /=20
  failover and EMC CX600</DIV>
  <DIV><BR></DIV>* Gerald Nowitzky<BR><BR>&gt; The mpath_prio_emc with=20
  group_by_prio did the trick. Thanks!<BR>&gt;&nbsp; <BR>&gt; But I am =
still=20
  loosing the paths to the failed devices. I Increased<BR>&gt; =
dev_loss_tmo, but=20
  the maximum seems to be about 600 - thus, after 10<BR>&gt; Minutes, =
the paths=20
  fail:<BR><BR>The maximum is indeed 600 seconds in 2.6.23.<BR><BR>&gt;=20
  SANfile_m linux # multipath -l<BR>&gt; hcfshare=20
  (360060160c820080063502869e459dc11) dm-0 ,<BR>&gt; =
[size=3D3.4T][features=3D1=20
  queue_if_no_path][hwhandler=3D1 emc]<BR>&gt; \_ round-robin 0=20
  [prio=3D0][enabled]<BR>&gt;&nbsp; \_ #:#:#:# -&nbsp;&nbsp; =
#:#&nbsp;&nbsp;=20
  [failed][undef]<BR>&gt;&nbsp; \_ #:#:#:# -&nbsp;&nbsp; #:#&nbsp;&nbsp; =

  [failed][undef]<BR>&gt; \_ round-robin 0 =
[prio=3D0][active]<BR>&gt;&nbsp; \_=20
  2:0:0:0 sdd 8:48&nbsp; [active][undef]<BR>&gt;&nbsp; \_ 1:0:0:0 sdb =
8:16&nbsp;=20
  [active][undef]<BR>&gt; If I put them online again, I run into the =
-EEXIST=20
  prob. Async SCSI<BR>&gt; scanning *is* off in my kernel, so the only =
thing I=20
  could do from<BR>&gt; here is to try the patch, is it?<BR><BR>Matthew =
Wilcox'=20
  patch solved this particular problem for me, yes.&nbsp; I<BR>still had =
some=20
  problems with -EEXIST when unloading and re-inserting the<BR>HBA =
driver=20
  module, though, but that's a corner case I rarely run into<BR>(as well =
as=20
  being easily worked around by trying again).<BR><BR>Come to think of =
it, you=20
  never said which kernel version you're running...?<BR><BR>&gt; Oct 17 =
17:26:36=20
  SANfile_m kernel: kobject_add failed for 1:0:1:0 with<BR>&gt; -EEXIST, =
don't=20
  try to register things with the same name in the same<BR>&gt;=20
  directory.<BR><BR>One suggestion...&nbsp; If the sysfs object is still =
around,=20
  you might be<BR>able to delete it manually by running =C2=ABecho 1=20
  &gt;<BR>/sys/class/scsi_device/1:0:1:0/device/delete=C2=BB.&nbsp; If =
that works,=20
  you can<BR>try to rescan again by doing =C2=ABecho 0 1 0=20
  &gt;<BR>/sys/class/scsi_host/host1/scan=C2=BB.&nbsp; With some luck =
it'll=20
  work...<BR><BR>If it does, most of the time udev will notice and alert =

  multipath to<BR>check out the new device.&nbsp; Sometimes it doesn't =
work,=20
  though - simply<BR>run the =C2=ABmultipath=C2=BB command manually in =
that=20
  case.<BR><BR>By the way - the =C2=AB1=C2=BB in =C2=ABhost1=C2=BB maps =
to the first digit in=20
  =C2=AB1:0:1:0=C2=BB,<BR>while the =C2=AB0 1 0=C2=BB in the echo =
command to the last=20
  three.<BR><BR>Regards<BR>-- <BR>Tore Anderson<BR><BR>--<BR>dm-devel =
mailing=20
  list<BR><A =
href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</A><BR><A=20
  =
href=3D"https://www.redhat.com/mailman/listinfo/dm-devel">https://www.red=
hat.com/mailman/listinfo/dm-devel</A></BLOCKQUOTE></BODY></HTML>

------=_NextPart_000_06AF_01C81106.1EAF4CA0--


--===============1152962555==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1152962555==--
