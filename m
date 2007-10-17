From: "Gerald Nowitzky" <Nowitzky@igne.de>
Subject: Re: multibus / failover and EMC CX600
Date: Wed, 17 Oct 2007 16:48:38 +0200
Message-ID: <066001c810cc$cd9f6f90$0a00a8c0@ALDI2>
References: <061401c810a7$cac685d0$0a00a8c0@ALDI2><4715E6A4.7060308@linpro.no>
	<4715ED28.9020102@suse.de> <471600F7.5090607@linpro.no>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1395529183=="
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

--===============1395529183==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_065D_01C810DD.90DBF450"

This is a multi-part message in MIME format.

------=_NextPart_000_065D_01C810DD.90DBF450
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable

The mpath_prio_emc with group_by_prio did the trick. Thanks!

But I am still loosing the paths to the failed devices. I Increased =
dev_loss_tmo, but the maximum seems to be about 600 - thus, after 10 =
Minutes, the paths fail:

SANfile_m linux # multipath -l
hcfshare (360060160c820080063502869e459dc11) dm-0 ,
[size=3D3.4T][features=3D1 queue_if_no_path][hwhandler=3D1 emc]
\_ round-robin 0 [prio=3D0][enabled]
 \_ #:#:#:# -   #:#   [failed][undef]
 \_ #:#:#:# -   #:#   [failed][undef]
\_ round-robin 0 [prio=3D0][active]
 \_ 2:0:0:0 sdd 8:48  [active][undef]
 \_ 1:0:0:0 sdb 8:16  [active][undef]

If I put them online again, I run into the -EEXIST prob. Async SCSI =
scanning *is* off in my kernel, so the only thing I could do from here =
is to try the patch, is it?

Oct 17 17:26:34 SANfile_m kernel: scsi 1:0:1:0: rejecting I/O to dead =
device
Oct 17 17:26:34 SANfile_m multipathd: sdc: emc_clariion_checker: query =
command indicates error
Oct 17 17:26:35 SANfile_m kernel: scsi 2:0:1:0: rejecting I/O to dead =
device
Oct 17 17:26:35 SANfile_m multipathd: sde: emc_clariion_checker: query =
command indicates error
Oct 17 17:26:36 SANfile_m kernel: scsi 1:0:1:0: Direct-Access     DGC    =
  RAID 5           0219 PQ: 0 ANSI: 4
Oct 17 17:26:36 SANfile_m kernel: sd 1:0:1:0: [sdf] Very big device. =
Trying to use READ CAPACITY(16).
Oct 17 17:26:36 SANfile_m kernel: sd 1:0:1:0: [sdf] 7263453184 512-byte =
hardware sectors (3718888 MB)
Oct 17 17:26:36 SANfile_m kernel: sd 1:0:1:0: [sdf] Test WP failed, =
assume Write Enabled
Oct 17 17:26:36 SANfile_m kernel: sd 1:0:1:0: [sdf] Asking for cache =
data failed
Oct 17 17:26:36 SANfile_m kernel: sd 1:0:1:0: [sdf] Assuming drive =
cache: write through
Oct 17 17:26:36 SANfile_m kernel: sd 1:0:1:0: [sdf] Very big device. =
Trying to use READ CAPACITY(16).
Oct 17 17:26:36 SANfile_m kernel: sd 1:0:1:0: [sdf] 7263453184 512-byte =
hardware sectors (3718888 MB)
Oct 17 17:26:36 SANfile_m kernel: sd 1:0:1:0: [sdf] Test WP failed, =
assume Write Enabled
Oct 17 17:26:36 SANfile_m kernel: sd 1:0:1:0: [sdf] Asking for cache =
data failed
Oct 17 17:26:36 SANfile_m kernel: sd 1:0:1:0: [sdf] Assuming drive =
cache: write through
Oct 17 17:26:36 SANfile_m kernel:  sdf:<6>sd 1:0:1:0: [sdf] Device not =
ready: <6>: Sense Key : 0x2 [current]
Oct 17 17:26:36 SANfile_m kernel: : ASC=3D0x4 ASCQ=3D0x3
Oct 17 17:26:36 SANfile_m kernel: end_request: I/O error, dev sdf, =
sector 0
Oct 17 17:26:36 SANfile_m kernel: printk: 40 messages suppressed.
Oct 17 17:26:36 SANfile_m kernel: Buffer I/O error on device sdf, =
logical block 0
Oct 17 17:26:36 SANfile_m kernel: sd 1:0:1:0: [sdf] Device not ready: =
<6>: Sense Key : 0x2 [current]
Oct 17 17:26:36 SANfile_m kernel: : ASC=3D0x4 ASCQ=3D0x3
Oct 17 17:26:36 SANfile_m kernel: end_request: I/O error, dev sdf, =
sector 0
Oct 17 17:26:36 SANfile_m kernel: Buffer I/O error on device sdf, =
logical block 0
Oct 17 17:26:36 SANfile_m kernel: sd 1:0:1:0: [sdf] Device not ready: =
<6>: Sense Key : 0x2 [current]
Oct 17 17:26:36 SANfile_m kernel: : ASC=3D0x4 ASCQ=3D0x3
Oct 17 17:26:36 SANfile_m kernel: end_request: I/O error, dev sdf, =
sector 0
Oct 17 17:26:36 SANfile_m kernel: Buffer I/O error on device sdf, =
logical block 0
Oct 17 17:26:36 SANfile_m kernel: ldm_validate_partition_table(): Disk =
read failed.
Oct 17 17:26:36 SANfile_m kernel: sd 1:0:1:0: [sdf] Device not ready: =
<6>: Sense Key : 0x2 [current]
Oct 17 17:26:36 SANfile_m kernel: : ASC=3D0x4 ASCQ=3D0x3
Oct 17 17:26:36 SANfile_m kernel: end_request: I/O error, dev sdf, =
sector 0
Oct 17 17:26:36 SANfile_m kernel: Buffer I/O error on device sdf, =
logical block 0
Oct 17 17:26:36 SANfile_m kernel:  unable to read partition table
Oct 17 17:26:36 SANfile_m kernel: sd 1:0:1:0: [sdf] Attached SCSI disk
Oct 17 17:26:36 SANfile_m kernel: sd 1:0:1:0: Attached scsi generic sg2 =
type 0
Oct 17 17:26:36 SANfile_m kernel: scsi 1:0:1:0: Direct-Access     DGC    =
  RAID 5           0219 PQ: 0 ANSI: 4
Oct 17 17:26:36 SANfile_m kernel: kobject_add failed for 1:0:1:0 with =
-EEXIST, don't try to register things with the same name in the same =
directory.
Oct 17 17:26:36 SANfile_m kernel:  [number+85/816] =
kobject_shadow_add+0x115/0x1b0
Oct 17 17:26:36 SANfile_m kernel:  [<c02f95f5>] =
kobject_shadow_add+0x115/0x1b0
Oct 17 17:26:36 SANfile_m kernel:  [lo_ioctl+1125/2528] =
device_add+0xc5/0x570
Oct 17 17:26:36 SANfile_m kernel:  [<c03aefd5>] device_add+0xc5/0x570
Oct 17 17:26:36 SANfile_m kernel:  [fc_remote_port_rolechg+127/320] =
scsi_adjust_queue_depth+0x9f/0xf0
Oct 17 17:26:36 SANfile_m kernel:  [<c03f9d7f>] =
scsi_adjust_queue_depth+0x9f/0xf0
Oct 17 17:26:36 SANfile_m kernel:  [blk_register_region+18/64] =
__blk_queue_init_tags+0x32/0x70
Oct 17 17:26:36 SANfile_m kernel:  [<c02eeb72>] =
__blk_queue_init_tags+0x32/0x70
Oct 17 17:26:36 SANfile_m kernel:  [sr_get_mcn+2/240] =
scsi_sysfs_add_sdev+0x32/0x230
Oct 17 17:26:36 SANfile_m kernel:  [<c0402882>] =
scsi_sysfs_add_sdev+0x32/0x230
Oct 17 17:26:36 SANfile_m kernel:  [<f99445b7>] =
qla2xxx_slave_configure+0x77/0x110 [qla2xxx]
Oct 17 17:26:36 SANfile_m kernel:  [sd_init_command+313/1088] =
scsi_probe_and_add_lun+0x8c9/0x940
Oct 17 17:26:36 SANfile_m kernel:  [<c0400859>] =
scsi_probe_and_add_lun+0x8c9/0x940
Oct 17 17:26:36 SANfile_m kernel:  [sr_probe+72/1472] =
__scsi_scan_target+0x518/0x5c0
Oct 17 17:26:36 SANfile_m kernel:  [<c04012c8>] =
__scsi_scan_target+0x518/0x5c0
Oct 17 17:26:36 SANfile_m kernel:  [kallsyms_addresses+36259/130252] =
schedule+0x2df/0x940
Oct 17 17:26:36 SANfile_m kernel:  [<c053695f>] schedule+0x2df/0x940
Oct 17 17:26:36 SANfile_m kernel:  [sr_init_command+54/944] =
scsi_scan_target+0xb6/0xe0
Oct 17 17:26:36 SANfile_m kernel:  [<c04019f6>] =
scsi_scan_target+0xb6/0xe0
Oct 17 17:26:36 SANfile_m kernel:  [SendIocInit+224/784] =
fc_scsi_scan_rport+0x0/0x90
Oct 17 17:26:36 SANfile_m kernel:  [<c04084b0>] =
fc_scsi_scan_rport+0x0/0x90
Oct 17 17:26:36 SANfile_m kernel:  [SendIocInit+344/784] =
fc_scsi_scan_rport+0x78/0x90
Oct 17 17:26:36 SANfile_m kernel:  [<c0408528>] =
fc_scsi_scan_rport+0x78/0x90
Oct 17 17:26:36 SANfile_m kernel:  [run_workqueue+131/256] =
run_workqueue+0x73/0x100
Oct 17 17:26:36 SANfile_m kernel:  [<c0131dc3>] run_workqueue+0x73/0x100
Oct 17 17:26:36 SANfile_m kernel:  [autoremove_wake_function+16/80] =
autoremove_wake_function+0x0/0x50
Oct 17 17:26:36 SANfile_m kernel:  [<c01354e0>] =
autoremove_wake_function+0x0/0x50
Oct 17 17:26:36 SANfile_m kernel:  [worker_thread+172/256] =
worker_thread+0x9c/0x100
Oct 17 17:26:36 SANfile_m kernel:  [<c01326dc>] worker_thread+0x9c/0x100
Oct 17 17:26:36 SANfile_m kernel:  [autoremove_wake_function+16/80] =
autoremove_wake_function+0x0/0x50
Oct 17 17:26:36 SANfile_m kernel:  [<c01354e0>] =
autoremove_wake_function+0x0/0x50
Oct 17 17:26:36 SANfile_m kernel:  [worker_thread+16/256] =
worker_thread+0x0/0x100
Oct 17 17:26:36 SANfile_m kernel:  [<c0132640>] worker_thread+0x0/0x100
Oct 17 17:26:36 SANfile_m kernel:  [kthread+82/112] kthread+0x42/0x70
Oct 17 17:26:36 SANfile_m kernel:  [<c0135212>] kthread+0x42/0x70
Oct 17 17:26:36 SANfile_m kernel:  [kthread+16/112] kthread+0x0/0x70
Oct 17 17:26:36 SANfile_m kernel:  [<c01351d0>] kthread+0x0/0x70
Oct 17 17:26:36 SANfile_m kernel:  [print_trace_stack+3/16] =
kernel_thread_helper+0x7/0x14
Oct 17 17:26:36 SANfile_m kernel:  [<c0104763>] =
kernel_thread_helper+0x7/0x14
Oct 17 17:26:36 SANfile_m kernel:  =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Oct 17 17:26:36 SANfile_m kernel: error 1
Oct 17 17:26:36 SANfile_m kernel: scsi 1:0:1:0: Unexpected response from =
lun 0 while scanning, scan aborted
Oct 17 17:26:36 SANfile_m kernel: sd 1:0:1:0: [sdf] Device not ready: =
<6>: Sense Key : 0x2 [current]
Oct 17 17:26:36 SANfile_m kernel: : ASC=3D0x4 ASCQ=3D0x3
Oct 17 17:26:36 SANfile_m kernel: end_request: I/O error, dev sdf, =
sector 7263453056
Oct 17 17:26:36 SANfile_m kernel: Buffer I/O error on device sdf, =
logical block 907931632
Oct 17 17:26:36 SANfile_m kernel: sd 1:0:1:0: [sdf] Device not ready: =
<6>: Sense Key : 0x2 [current]
Oct 17 17:26:36 SANfile_m kernel: : ASC=3D0x4 ASCQ=3D0x3
Oct 17 17:26:36 SANfile_m kernel: end_request: I/O error, dev sdf, =
sector 7263453056
Oct 17 17:26:36 SANfile_m kernel: Buffer I/O error on device sdf, =
logical block 907931632
Oct 17 17:26:36 SANfile_m kernel: sd 1:0:1:0: [sdf] Device not ready: =
<6>: Sense Key : 0x2 [current]
Oct 17 17:26:36 SANfile_m kernel: : ASC=3D0x4 ASCQ=3D0x3




Is that what you refer as=20



  ----- Original Message -----=20
  From: Tore Anderson=20
  To: device-mapper development=20
  Sent: Wednesday, October 17, 2007 2:32 PM
  Subject: Re: [dm-devel] multibus / failover and EMC CX600


  * Hannes Reinecke

  > That's the dev_loss_tmo setting. Just increase it to something to
  > your liking.

  Oh, sweet.  This knob won't affect how long the layer will hold I/O
  before failing it (like lpfc_nodev_tmo), I assume?  (I'm worried about
  it taking longer for dm-multipath to detect failed paths).

  I wish it could've been set to unlimited, though.  Seems like there's
  always some kind of trouble with re-adding the devices, either I run
  into that -EEXIST bug, or udev doesn't do it's job properly and the
  revived device isn't added back into the dm-multipath map.  In =
addition
  it somtimes breaks queue_if_no_path with earlier multipath-tools that
  doesn't use no_flush on suspend.  Those versions are of course =
included
  in most server distributions...  Sigh.

  Regards
  --=20
  Tore Anderson

  --
  dm-devel mailing list
  dm-devel@redhat.com
  https://www.redhat.com/mailman/listinfo/dm-devel
------=_NextPart_000_065D_01C810DD.90DBF450
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
<DIV><FONT face=3DArial size=3D2>The mpath_prio_emc with group_by_prio =
did the=20
trick. Thanks!</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>But I am still loosing the paths to the =
failed=20
devices. </FONT><FONT face=3DArial size=3D2>I Increased dev_loss_tmo, =
but the=20
maximum seems to be about 600 - thus, after 10 Minutes, the paths=20
fail:</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>SANfile_m linux # multipath =
-l<BR>hcfshare=20
(360060160c820080063502869e459dc11) dm-0 ,<BR>[size=3D3.4T][features=3D1 =

queue_if_no_path][hwhandler=3D1 emc]<BR>\_ round-robin 0=20
[prio=3D0][enabled]<BR>&nbsp;\_ #:#:#:# -&nbsp;&nbsp; #:#&nbsp;&nbsp;=20
[failed][undef]<BR>&nbsp;\_ #:#:#:# -&nbsp;&nbsp; #:#&nbsp;&nbsp;=20
[failed][undef]<BR>\_ round-robin 0 [prio=3D0][active]<BR>&nbsp;\_ =
2:0:0:0 sdd=20
8:48&nbsp; [active][undef]<BR>&nbsp;\_ 1:0:0:0 sdb 8:16&nbsp;=20
[active][undef]<BR></FONT></DIV>
<DIV><FONT face=3DArial size=3D2>If I put them online again, I&nbsp;run=20
into&nbsp;the -EEXIST prob. Async SCSI scanning *is* off in my kernel,=20
so&nbsp;the only thing I could do from here&nbsp;is&nbsp;to try the =
patch, is=20
it?</FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>Oct 17 17:26:34 SANfile_m kernel: scsi =
1:0:1:0:=20
rejecting I/O to dead device<BR>Oct 17 17:26:34 SANfile_m multipathd: =
sdc:=20
emc_clariion_checker: query command indicates error<BR>Oct 17 17:26:35 =
SANfile_m=20
kernel: scsi 2:0:1:0: rejecting I/O to dead device<BR>Oct 17 17:26:35 =
SANfile_m=20
multipathd: sde: emc_clariion_checker: query command indicates =
error<BR>Oct 17=20
17:26:36 SANfile_m kernel: scsi 1:0:1:0: =
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;=20
DGC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; RAID=20
5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0219 PQ: 0 =
ANSI:=20
4<BR>Oct 17 17:26:36 SANfile_m kernel: sd 1:0:1:0: [sdf] Very big =
device. Trying=20
to use READ CAPACITY(16).<BR>Oct 17 17:26:36 SANfile_m kernel: sd =
1:0:1:0: [sdf]=20
7263453184 512-byte hardware sectors (3718888 MB)<BR>Oct 17 17:26:36 =
SANfile_m=20
kernel: sd 1:0:1:0: [sdf] Test WP failed, assume Write Enabled<BR>Oct 17 =

17:26:36 SANfile_m kernel: sd 1:0:1:0: [sdf] Asking for cache data =
failed<BR>Oct=20
17 17:26:36 SANfile_m kernel: sd 1:0:1:0: [sdf] Assuming drive cache: =
write=20
through<BR>Oct 17 17:26:36 SANfile_m kernel: sd 1:0:1:0: [sdf] Very big =
device.=20
Trying to use READ CAPACITY(16).<BR>Oct 17 17:26:36 SANfile_m kernel: sd =

1:0:1:0: [sdf] 7263453184 512-byte hardware sectors (3718888 MB)<BR>Oct =
17=20
17:26:36 SANfile_m kernel: sd 1:0:1:0: [sdf] Test WP failed, assume =
Write=20
Enabled<BR>Oct 17 17:26:36 SANfile_m kernel: sd 1:0:1:0: [sdf] Asking =
for cache=20
data failed<BR>Oct 17 17:26:36 SANfile_m kernel: sd 1:0:1:0: [sdf] =
Assuming=20
drive cache: write through<BR>Oct 17 17:26:36 SANfile_m kernel:&nbsp;=20
sdf:&lt;6&gt;sd 1:0:1:0: [sdf] Device not ready: &lt;6&gt;: Sense Key : =
0x2=20
[current]<BR>Oct 17 17:26:36 SANfile_m kernel: : ASC=3D0x4 =
ASCQ=3D0x3<BR>Oct 17=20
17:26:36 SANfile_m kernel: end_request: I/O error, dev sdf, sector =
0<BR>Oct 17=20
17:26:36 SANfile_m kernel: printk: 40 messages suppressed.<BR>Oct 17 =
17:26:36=20
SANfile_m kernel: Buffer I/O error on device sdf, logical block 0<BR>Oct =
17=20
17:26:36 SANfile_m kernel: sd 1:0:1:0: [sdf] Device not ready: =
&lt;6&gt;: Sense=20
Key : 0x2 [current]<BR>Oct 17 17:26:36 SANfile_m kernel: : ASC=3D0x4=20
ASCQ=3D0x3<BR>Oct 17 17:26:36 SANfile_m kernel: end_request: I/O error, =
dev sdf,=20
sector 0<BR>Oct 17 17:26:36 SANfile_m kernel: Buffer I/O error on device =
sdf,=20
logical block 0<BR>Oct 17 17:26:36 SANfile_m kernel: sd 1:0:1:0: [sdf] =
Device=20
not ready: &lt;6&gt;: Sense Key : 0x2 [current]<BR>Oct 17 17:26:36 =
SANfile_m=20
kernel: : ASC=3D0x4 ASCQ=3D0x3<BR>Oct 17 17:26:36 SANfile_m kernel: =
end_request: I/O=20
error, dev sdf, sector 0<BR>Oct 17 17:26:36 SANfile_m kernel: Buffer I/O =
error=20
on device sdf, logical block 0<BR>Oct 17 17:26:36 SANfile_m kernel:=20
ldm_validate_partition_table(): Disk read failed.<BR>Oct 17 17:26:36 =
SANfile_m=20
kernel: sd 1:0:1:0: [sdf] Device not ready: &lt;6&gt;: Sense Key : 0x2=20
[current]<BR>Oct 17 17:26:36 SANfile_m kernel: : ASC=3D0x4 =
ASCQ=3D0x3<BR>Oct 17=20
17:26:36 SANfile_m kernel: end_request: I/O error, dev sdf, sector =
0<BR>Oct 17=20
17:26:36 SANfile_m kernel: Buffer I/O error on device sdf, logical block =

0<BR>Oct 17 17:26:36 SANfile_m kernel:&nbsp; unable to read partition=20
table<BR>Oct 17 17:26:36 SANfile_m kernel: sd 1:0:1:0: [sdf] Attached =
SCSI=20
disk<BR>Oct 17 17:26:36 SANfile_m kernel: sd 1:0:1:0: Attached scsi =
generic sg2=20
type 0<BR>Oct 17 17:26:36 SANfile_m kernel: scsi 1:0:1:0:=20
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp; DGC&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
RAID=20
5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0219 PQ: 0 =
ANSI:=20
4<BR>Oct 17 17:26:36 SANfile_m kernel: kobject_add failed for 1:0:1:0 =
with=20
-EEXIST, don't try to register things with the same name in the same=20
directory.<BR>Oct 17 17:26:36 SANfile_m kernel:&nbsp; [number+85/816]=20
kobject_shadow_add+0x115/0x1b0<BR>Oct 17 17:26:36 SANfile_m =
kernel:&nbsp;=20
[&lt;c02f95f5&gt;] kobject_shadow_add+0x115/0x1b0<BR>Oct 17 17:26:36 =
SANfile_m=20
kernel:&nbsp; [lo_ioctl+1125/2528] device_add+0xc5/0x570<BR>Oct 17 =
17:26:36=20
SANfile_m kernel:&nbsp; [&lt;c03aefd5&gt;] device_add+0xc5/0x570<BR>Oct =
17=20
17:26:36 SANfile_m kernel:&nbsp; [fc_remote_port_rolechg+127/320]=20
scsi_adjust_queue_depth+0x9f/0xf0<BR>Oct 17 17:26:36 SANfile_m =
kernel:&nbsp;=20
[&lt;c03f9d7f&gt;] scsi_adjust_queue_depth+0x9f/0xf0<BR>Oct 17 17:26:36=20
SANfile_m kernel:&nbsp; [blk_register_region+18/64]=20
__blk_queue_init_tags+0x32/0x70<BR>Oct 17 17:26:36 SANfile_m =
kernel:&nbsp;=20
[&lt;c02eeb72&gt;] __blk_queue_init_tags+0x32/0x70<BR>Oct 17 17:26:36 =
SANfile_m=20
kernel:&nbsp; [sr_get_mcn+2/240] scsi_sysfs_add_sdev+0x32/0x230<BR>Oct =
17=20
17:26:36 SANfile_m kernel:&nbsp; [&lt;c0402882&gt;]=20
scsi_sysfs_add_sdev+0x32/0x230<BR>Oct 17 17:26:36 SANfile_m =
kernel:&nbsp;=20
[&lt;f99445b7&gt;] qla2xxx_slave_configure+0x77/0x110 [qla2xxx]<BR>Oct =
17=20
17:26:36 SANfile_m kernel:&nbsp; [sd_init_command+313/1088]=20
scsi_probe_and_add_lun+0x8c9/0x940<BR>Oct 17 17:26:36 SANfile_m =
kernel:&nbsp;=20
[&lt;c0400859&gt;] scsi_probe_and_add_lun+0x8c9/0x940<BR>Oct 17 17:26:36 =

SANfile_m kernel:&nbsp; [sr_probe+72/1472] =
__scsi_scan_target+0x518/0x5c0<BR>Oct=20
17 17:26:36 SANfile_m kernel:&nbsp; [&lt;c04012c8&gt;]=20
__scsi_scan_target+0x518/0x5c0<BR>Oct 17 17:26:36 SANfile_m =
kernel:&nbsp;=20
[kallsyms_addresses+36259/130252] schedule+0x2df/0x940<BR>Oct 17 =
17:26:36=20
SANfile_m kernel:&nbsp; [&lt;c053695f&gt;] schedule+0x2df/0x940<BR>Oct =
17=20
17:26:36 SANfile_m kernel:&nbsp; [sr_init_command+54/944]=20
scsi_scan_target+0xb6/0xe0<BR>Oct 17 17:26:36 SANfile_m kernel:&nbsp;=20
[&lt;c04019f6&gt;] scsi_scan_target+0xb6/0xe0<BR>Oct 17 17:26:36 =
SANfile_m=20
kernel:&nbsp; [SendIocInit+224/784] fc_scsi_scan_rport+0x0/0x90<BR>Oct =
17=20
17:26:36 SANfile_m kernel:&nbsp; [&lt;c04084b0&gt;]=20
fc_scsi_scan_rport+0x0/0x90<BR>Oct 17 17:26:36 SANfile_m kernel:&nbsp;=20
[SendIocInit+344/784] fc_scsi_scan_rport+0x78/0x90<BR>Oct 17 17:26:36 =
SANfile_m=20
kernel:&nbsp; [&lt;c0408528&gt;] fc_scsi_scan_rport+0x78/0x90<BR>Oct 17 =
17:26:36=20
SANfile_m kernel:&nbsp; [run_workqueue+131/256] =
run_workqueue+0x73/0x100<BR>Oct=20
17 17:26:36 SANfile_m kernel:&nbsp; [&lt;c0131dc3&gt;]=20
run_workqueue+0x73/0x100<BR>Oct 17 17:26:36 SANfile_m kernel:&nbsp;=20
[autoremove_wake_function+16/80] =
autoremove_wake_function+0x0/0x50<BR>Oct 17=20
17:26:36 SANfile_m kernel:&nbsp; [&lt;c01354e0&gt;]=20
autoremove_wake_function+0x0/0x50<BR>Oct 17 17:26:36 SANfile_m =
kernel:&nbsp;=20
[worker_thread+172/256] worker_thread+0x9c/0x100<BR>Oct 17 17:26:36 =
SANfile_m=20
kernel:&nbsp; [&lt;c01326dc&gt;] worker_thread+0x9c/0x100<BR>Oct 17 =
17:26:36=20
SANfile_m kernel:&nbsp; [autoremove_wake_function+16/80]=20
autoremove_wake_function+0x0/0x50<BR>Oct 17 17:26:36 SANfile_m =
kernel:&nbsp;=20
[&lt;c01354e0&gt;] autoremove_wake_function+0x0/0x50<BR>Oct 17 17:26:36=20
SANfile_m kernel:&nbsp; [worker_thread+16/256] =
worker_thread+0x0/0x100<BR>Oct 17=20
17:26:36 SANfile_m kernel:&nbsp; [&lt;c0132640&gt;]=20
worker_thread+0x0/0x100<BR>Oct 17 17:26:36 SANfile_m kernel:&nbsp;=20
[kthread+82/112] kthread+0x42/0x70<BR>Oct 17 17:26:36 SANfile_m =
kernel:&nbsp;=20
[&lt;c0135212&gt;] kthread+0x42/0x70<BR>Oct 17 17:26:36 SANfile_m =
kernel:&nbsp;=20
[kthread+16/112] kthread+0x0/0x70<BR>Oct 17 17:26:36 SANfile_m =
kernel:&nbsp;=20
[&lt;c01351d0&gt;] kthread+0x0/0x70<BR>Oct 17 17:26:36 SANfile_m =
kernel:&nbsp;=20
[print_trace_stack+3/16] kernel_thread_helper+0x7/0x14<BR>Oct 17 =
17:26:36=20
SANfile_m kernel:&nbsp; [&lt;c0104763&gt;] =
kernel_thread_helper+0x7/0x14<BR>Oct=20
17 17:26:36 SANfile_m kernel:&nbsp; =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<BR>=
Oct 17 17:26:36=20
SANfile_m kernel: error 1<BR>Oct 17 17:26:36 SANfile_m kernel: scsi =
1:0:1:0:=20
Unexpected response from lun 0 while scanning, scan aborted<BR>Oct 17 =
17:26:36=20
SANfile_m kernel: sd 1:0:1:0: [sdf] Device not ready: &lt;6&gt;: Sense =
Key : 0x2=20
[current]<BR>Oct 17 17:26:36 SANfile_m kernel: : ASC=3D0x4 =
ASCQ=3D0x3<BR>Oct 17=20
17:26:36 SANfile_m kernel: end_request: I/O error, dev sdf, sector=20
7263453056<BR>Oct 17 17:26:36 SANfile_m kernel: Buffer I/O error on =
device sdf,=20
logical block 907931632<BR>Oct 17 17:26:36 SANfile_m kernel: sd 1:0:1:0: =
[sdf]=20
Device not ready: &lt;6&gt;: Sense Key : 0x2 [current]<BR>Oct 17 =
17:26:36=20
SANfile_m kernel: : ASC=3D0x4 ASCQ=3D0x3<BR>Oct 17 17:26:36 SANfile_m =
kernel:=20
end_request: I/O error, dev sdf, sector 7263453056<BR>Oct 17 17:26:36 =
SANfile_m=20
kernel: Buffer I/O error on device sdf, logical block 907931632<BR>Oct =
17=20
17:26:36 SANfile_m kernel: sd 1:0:1:0: [sdf] Device not ready: =
&lt;6&gt;: Sense=20
Key : 0x2 [current]<BR>Oct 17 17:26:36 SANfile_m kernel: : ASC=3D0x4=20
ASCQ=3D0x3<BR></FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>Is that what you refer as </FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT face=3DArial size=3D2>&nbsp;</DIV></FONT>
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
2007 2:32=20
  PM</DIV>
  <DIV style=3D"FONT: 10pt arial"><B>Subject:</B> Re: [dm-devel] =
multibus /=20
  failover and EMC CX600</DIV>
  <DIV><BR></DIV>* Hannes Reinecke<BR><BR>&gt; That's the dev_loss_tmo =
setting.=20
  Just increase it to something to<BR>&gt; your liking.<BR><BR>Oh, =
sweet.&nbsp;=20
  This knob won't affect how long the layer will hold I/O<BR>before =
failing it=20
  (like lpfc_nodev_tmo), I assume?&nbsp; (I'm worried about<BR>it taking =
longer=20
  for dm-multipath to detect failed paths).<BR><BR>I wish it could've =
been set=20
  to unlimited, though.&nbsp; Seems like there's<BR>always some kind of =
trouble=20
  with re-adding the devices, either I run<BR>into that -EEXIST bug, or =
udev=20
  doesn't do it's job properly and the<BR>revived device isn't added =
back into=20
  the dm-multipath map.&nbsp; In addition<BR>it somtimes breaks =
queue_if_no_path=20
  with earlier multipath-tools that<BR>doesn't use no_flush on =
suspend.&nbsp;=20
  Those versions are of course included<BR>in most server =
distributions...&nbsp;=20
  Sigh.<BR><BR>Regards<BR>-- <BR>Tore Anderson<BR><BR>--<BR>dm-devel =
mailing=20
  list<BR><A =
href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</A><BR><A=20
  =
href=3D"https://www.redhat.com/mailman/listinfo/dm-devel">https://www.red=
hat.com/mailman/listinfo/dm-devel</A></BLOCKQUOTE></BODY></HTML>

------=_NextPart_000_065D_01C810DD.90DBF450--


--===============1395529183==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1395529183==--
