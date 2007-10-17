From: "Gerald Nowitzky" <Nowitzky@igne.de>
Subject: Re: multibus / failover and EMC CX600
Date: Wed, 17 Oct 2007 20:04:12 +0200
Message-ID: <068301c810e8$1f4e6e70$0a00a8c0@ALDI2>
References: <061401c810a7$cac685d0$0a00a8c0@ALDI2><4715E6A4.7060308@linpro.no>	<4715ED28.9020102@suse.de><471600F7.5090607@linpro.no>
	<066001c810cc$cd9f6f90$0a00a8c0@ALDI2> <471631E5.9050603@linpro.no>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0378461437=="
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

--===============0378461437==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0680_01C810F8.E2A04FF0"

This is a multi-part message in MIME format.

------=_NextPart_000_0680_01C810F8.E2A04FF0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable

I'm afraid the patch did not work for me. I'ts still the same.

I am using kernel 2.6.22.2 at the moment. Should I upgrade to 2.6.23 ?

Anybody any Ideas?
The system is not in production at the moment. We could do some testing.

(Gerald)

Oct 17 20:57:09 SANfile_m kernel: kobject_add failed for 1:0:1:0 with =
-EEXIST, don't try to register things with the same name in the same =
directory.
Oct 17 20:57:09 SANfile_m kernel:  [number+85/816] =
kobject_shadow_add+0x115/0x1b0
Oct 17 20:57:09 SANfile_m kernel:  [<c02f95f5>] =
kobject_shadow_add+0x115/0x1b0
Oct 17 20:57:09 SANfile_m kernel:  [lo_ioctl+1125/2528] =
device_add+0xc5/0x570
Oct 17 20:57:09 SANfile_m kernel:  [<c03aefd5>] device_add+0xc5/0x570
Oct 17 20:57:09 SANfile_m kernel:  [fc_remote_port_rolechg+127/320] =
scsi_adjust_queue_depth+0x9f/0xf0
Oct 17 20:57:09 SANfile_m kernel:  [<c03f9d7f>] =
scsi_adjust_queue_depth+0x9f/0xf0
Oct 17 20:57:09 SANfile_m kernel:  [blk_register_region+18/64] =
__blk_queue_init_tags+0x32/0x70
Oct 17 20:57:09 SANfile_m kernel:  [<c02eeb72>] =
__blk_queue_init_tags+0x32/0x70
Oct 17 20:57:09 SANfile_m kernel:  [sr_get_mcn+50/240] =
scsi_sysfs_add_sdev+0x32/0x230
Oct 17 20:57:09 SANfile_m kernel:  [<c04028b2>] =
scsi_sysfs_add_sdev+0x32/0x230
Oct 17 20:57:09 SANfile_m kernel:  [<f99445b7>] =
qla2xxx_slave_configure+0x77/0x110 [qla2xxx]
Oct 17 20:57:09 SANfile_m kernel:  [sd_init_command+313/1088] =
scsi_probe_and_add_lun+0x8c9/0x940
Oct 17 20:57:09 SANfile_m kernel:  [<c0400859>] =
scsi_probe_and_add_lun+0x8c9/0x940
Oct 17 20:57:09 SANfile_m kernel:  [sr_probe+72/1472] =
__scsi_scan_target+0x518/0x5c0
Oct 17 20:57:09 SANfile_m kernel:  [<c04012c8>] =
__scsi_scan_target+0x518/0x5c0
Oct 17 20:57:09 SANfile_m kernel:  [kallsyms_addresses+36323/130252] =
schedule+0x2df/0x940
Oct 17 20:57:09 SANfile_m kernel:  [<c053699f>] schedule+0x2df/0x940
Oct 17 20:57:09 SANfile_m kernel:  [sr_init_command+128/944] =
scsi_scan_target+0xd0/0xe0
Oct 17 20:57:09 SANfile_m kernel:  [<c0401a40>] =
scsi_scan_target+0xd0/0xe0
Oct 17 20:57:09 SANfile_m kernel:  [SendIocInit+272/784] =
fc_scsi_scan_rport+0x0/0x90
Oct 17 20:57:09 SANfile_m kernel:  [<c04084e0>] =
fc_scsi_scan_rport+0x0/0x90
Oct 17 20:57:09 SANfile_m kernel:  [SendIocInit+392/784] =
fc_scsi_scan_rport+0x78/0x90
Oct 17 20:57:09 SANfile_m kernel:  [<c0408558>] =
fc_scsi_scan_rport+0x78/0x90
Oct 17 20:57:09 SANfile_m kernel:  [run_workqueue+131/256] =
run_workqueue+0x73/0x100
Oct 17 20:57:09 SANfile_m kernel:  [<c0131dc3>] run_workqueue+0x73/0x100
Oct 17 20:57:09 SANfile_m kernel:  [autoremove_wake_function+16/80] =
autoremove_wake_function+0x0/0x50
Oct 17 20:57:09 SANfile_m kernel:  [<c01354e0>] =
autoremove_wake_function+0x0/0x50
Oct 17 20:57:09 SANfile_m kernel:  [worker_thread+172/256] =
worker_thread+0x9c/0x100
Oct 17 20:57:09 SANfile_m kernel:  [<c01326dc>] worker_thread+0x9c/0x100
Oct 17 20:57:09 SANfile_m kernel:  [autoremove_wake_function+16/80] =
autoremove_wake_function+0x0/0x50
Oct 17 20:57:09 SANfile_m kernel:  [<c01354e0>] =
autoremove_wake_function+0x0/0x50
Oct 17 20:57:09 SANfile_m kernel:  [worker_thread+16/256] =
worker_thread+0x0/0x100
Oct 17 20:57:09 SANfile_m kernel:  [<c0132640>] worker_thread+0x0/0x100
Oct 17 20:57:09 SANfile_m kernel:  [kthread+82/112] kthread+0x42/0x70
Oct 17 20:57:09 SANfile_m kernel:  [<c0135212>] kthread+0x42/0x70
Oct 17 20:57:09 SANfile_m kernel:  [kthread+16/112] kthread+0x0/0x70
Oct 17 20:57:09 SANfile_m kernel:  [<c01351d0>] kthread+0x0/0x70
Oct 17 20:57:09 SANfile_m kernel:  [print_trace_stack+3/16] =
kernel_thread_helper+0x7/0x14
Oct 17 20:57:09 SANfile_m kernel:  [<c0104763>] =
kernel_thread_helper+0x7/0x14
Oct 17 20:57:09 SANfile_m kernel:  =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Oct 17 20:57:09 SANfile_m kernel: error 1

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
------=_NextPart_000_0680_01C810F8.E2A04FF0
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
<DIV><FONT face=3DArial size=3D2>I'm afraid the patch did not =
work&nbsp;for me. I'ts=20
still the same.</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV>
<DIV><FONT face=3DArial size=3D2>I am using kernel 2.6.22.2 at the =
moment. Should I=20
upgrade to 2.6.23 ?</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV></DIV>
<DIV><FONT face=3DArial size=3D2>Anybody any Ideas?</FONT></DIV>
<DIV><FONT face=3DArial size=3D2>The system is not in production at the =
moment. We=20
could do some testing.</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>(Gerald)</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>Oct 17 20:57:09 SANfile_m kernel: =
kobject_add=20
failed for 1:0:1:0 with -EEXIST, don't try to register things with the =
same name=20
in the same directory.<BR>Oct 17 20:57:09 SANfile_m kernel:&nbsp;=20
[number+85/816] kobject_shadow_add+0x115/0x1b0<BR>Oct 17 20:57:09 =
SANfile_m=20
kernel:&nbsp; [&lt;c02f95f5&gt;] kobject_shadow_add+0x115/0x1b0<BR>Oct =
17=20
20:57:09 SANfile_m kernel:&nbsp; [lo_ioctl+1125/2528]=20
device_add+0xc5/0x570<BR>Oct 17 20:57:09 SANfile_m kernel:&nbsp;=20
[&lt;c03aefd5&gt;] device_add+0xc5/0x570<BR>Oct 17 20:57:09 SANfile_m=20
kernel:&nbsp; [fc_remote_port_rolechg+127/320]=20
scsi_adjust_queue_depth+0x9f/0xf0<BR>Oct 17 20:57:09 SANfile_m =
kernel:&nbsp;=20
[&lt;c03f9d7f&gt;] scsi_adjust_queue_depth+0x9f/0xf0<BR>Oct 17 20:57:09=20
SANfile_m kernel:&nbsp; [blk_register_region+18/64]=20
__blk_queue_init_tags+0x32/0x70<BR>Oct 17 20:57:09 SANfile_m =
kernel:&nbsp;=20
[&lt;c02eeb72&gt;] __blk_queue_init_tags+0x32/0x70<BR>Oct 17 20:57:09 =
SANfile_m=20
kernel:&nbsp; [sr_get_mcn+50/240] scsi_sysfs_add_sdev+0x32/0x230<BR>Oct =
17=20
20:57:09 SANfile_m kernel:&nbsp; [&lt;c04028b2&gt;]=20
scsi_sysfs_add_sdev+0x32/0x230<BR>Oct 17 20:57:09 SANfile_m =
kernel:&nbsp;=20
[&lt;f99445b7&gt;] qla2xxx_slave_configure+0x77/0x110 [qla2xxx]<BR>Oct =
17=20
20:57:09 SANfile_m kernel:&nbsp; [sd_init_command+313/1088]=20
scsi_probe_and_add_lun+0x8c9/0x940<BR>Oct 17 20:57:09 SANfile_m =
kernel:&nbsp;=20
[&lt;c0400859&gt;] scsi_probe_and_add_lun+0x8c9/0x940<BR>Oct 17 20:57:09 =

SANfile_m kernel:&nbsp; [sr_probe+72/1472] =
__scsi_scan_target+0x518/0x5c0<BR>Oct=20
17 20:57:09 SANfile_m kernel:&nbsp; [&lt;c04012c8&gt;]=20
__scsi_scan_target+0x518/0x5c0<BR>Oct 17 20:57:09 SANfile_m =
kernel:&nbsp;=20
[kallsyms_addresses+36323/130252] schedule+0x2df/0x940<BR>Oct 17 =
20:57:09=20
SANfile_m kernel:&nbsp; [&lt;c053699f&gt;] schedule+0x2df/0x940<BR>Oct =
17=20
20:57:09 SANfile_m kernel:&nbsp; [sr_init_command+128/944]=20
scsi_scan_target+0xd0/0xe0<BR>Oct 17 20:57:09 SANfile_m kernel:&nbsp;=20
[&lt;c0401a40&gt;] scsi_scan_target+0xd0/0xe0<BR>Oct 17 20:57:09 =
SANfile_m=20
kernel:&nbsp; [SendIocInit+272/784] fc_scsi_scan_rport+0x0/0x90<BR>Oct =
17=20
20:57:09 SANfile_m kernel:&nbsp; [&lt;c04084e0&gt;]=20
fc_scsi_scan_rport+0x0/0x90<BR>Oct 17 20:57:09 SANfile_m kernel:&nbsp;=20
[SendIocInit+392/784] fc_scsi_scan_rport+0x78/0x90<BR>Oct 17 20:57:09 =
SANfile_m=20
kernel:&nbsp; [&lt;c0408558&gt;] fc_scsi_scan_rport+0x78/0x90<BR>Oct 17 =
20:57:09=20
SANfile_m kernel:&nbsp; [run_workqueue+131/256] =
run_workqueue+0x73/0x100<BR>Oct=20
17 20:57:09 SANfile_m kernel:&nbsp; [&lt;c0131dc3&gt;]=20
run_workqueue+0x73/0x100<BR>Oct 17 20:57:09 SANfile_m kernel:&nbsp;=20
[autoremove_wake_function+16/80] =
autoremove_wake_function+0x0/0x50<BR>Oct 17=20
20:57:09 SANfile_m kernel:&nbsp; [&lt;c01354e0&gt;]=20
autoremove_wake_function+0x0/0x50<BR>Oct 17 20:57:09 SANfile_m =
kernel:&nbsp;=20
[worker_thread+172/256] worker_thread+0x9c/0x100<BR>Oct 17 20:57:09 =
SANfile_m=20
kernel:&nbsp; [&lt;c01326dc&gt;] worker_thread+0x9c/0x100<BR>Oct 17 =
20:57:09=20
SANfile_m kernel:&nbsp; [autoremove_wake_function+16/80]=20
autoremove_wake_function+0x0/0x50<BR>Oct 17 20:57:09 SANfile_m =
kernel:&nbsp;=20
[&lt;c01354e0&gt;] autoremove_wake_function+0x0/0x50<BR>Oct 17 20:57:09=20
SANfile_m kernel:&nbsp; [worker_thread+16/256] =
worker_thread+0x0/0x100<BR>Oct 17=20
20:57:09 SANfile_m kernel:&nbsp; [&lt;c0132640&gt;]=20
worker_thread+0x0/0x100<BR>Oct 17 20:57:09 SANfile_m kernel:&nbsp;=20
[kthread+82/112] kthread+0x42/0x70<BR>Oct 17 20:57:09 SANfile_m =
kernel:&nbsp;=20
[&lt;c0135212&gt;] kthread+0x42/0x70<BR>Oct 17 20:57:09 SANfile_m =
kernel:&nbsp;=20
[kthread+16/112] kthread+0x0/0x70<BR>Oct 17 20:57:09 SANfile_m =
kernel:&nbsp;=20
[&lt;c01351d0&gt;] kthread+0x0/0x70<BR>Oct 17 20:57:09 SANfile_m =
kernel:&nbsp;=20
[print_trace_stack+3/16] kernel_thread_helper+0x7/0x14<BR>Oct 17 =
20:57:09=20
SANfile_m kernel:&nbsp; [&lt;c0104763&gt;] =
kernel_thread_helper+0x7/0x14<BR>Oct=20
17 20:57:09 SANfile_m kernel:&nbsp; =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<BR>=
Oct 17 20:57:09=20
SANfile_m kernel: error 1<BR></FONT></DIV>
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

------=_NextPart_000_0680_01C810F8.E2A04FF0--


--===============0378461437==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0378461437==--
