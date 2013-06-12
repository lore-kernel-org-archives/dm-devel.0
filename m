From: "Praveen Dhanasekaran - PTI" <praveend@promise.com>
Subject: kernel crash with multipath-tools v0.4.7
Date: Wed, 12 Jun 2013 04:03:53 -0700
Message-ID: <975E8BE292621F4CA5B67883EB72497A03C2597E@nonamew.ptu.promise.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============9026878079529517602=="
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Mohan Rowlands - PTU <mohanr@promise.com>, Manoj Mathew - PTU <manojm@promise.com>, Nagendra Vadlakunta - PTU <nagendra.vadlakunta@promise.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.

--===============9026878079529517602==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01CE675C.869A29BF"

This is a multi-part message in MIME format.

------_=_NextPart_001_01CE675C.869A29BF
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hello All,
=20
I have a RAID storage box connected to a Linux server through fc cables. =
The server is using=20
kernel 2.6.26, and multipath-tools v0.4.7 (with dm-mpath target version =
1.0.5) is installed on it=20
to handle the disk scsi devices from the storage box. The multipath =
device is mounted and=20
used for a file system.=20
=20
When fc port is down, it is seen that the scsi fc transport layer =
removes the corresponding=20
fc-target and all the scsi device attached to this target. And when the =
fc port come back up,=20
I see the kernel crash. Below are the details on the crash. Is there any =
patch available to fix=20
this crash?
=20
During port down the output of multipath -l=20
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
/ > multipath -l
22230000155f989c9 dm-0 ,
[size=3D70G][features=3D0][hwhandler=3D1 alua][rw]
\_ round-robin 0 [prio=3D0][enabled]
 \_ #:#:#:# -   #:#   [failed][undef]
 \_ #:#:#:# -   #:#   [failed][undef]
 \_ #:#:#:# -   #:#   [failed][undef]
 \_ #:#:#:# -   #:#   [failed][undef]
22207000155f84ba3 dm-1 ,
[size=3D70G][features=3D0][hwhandler=3D1 alua][rw]
\_ round-robin 0 [prio=3D0][enabled]
 \_ #:#:#:# -   #:#   [failed][undef]
 \_ #:#:#:# -   #:#   [failed][undef]
/ >

During port up I am getting below stack dump in Linux server
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
kobject_add_internal failed for 4:0:3:0 with -EEXIST, don't try to =
register things with the same name in the same directory.
Pid: 1384, comm: scsi_wq_4 Tainted: P          =
2.6.26EIGHTSTACK_64_V15_V11_8GB_SANFS_UP #1
Call Trace:
 [<ffffffff80334455>] kobject_add_internal+0x11e/0x15d
 [<ffffffff803348b3>] kobject_add+0x74/0x7c
 [<ffffffff80283df4>] bio_alloc_bioset+0x89/0xd9
 [<ffffffff802846a9>] bio_map_kern+0xae/0x103
 [<ffffffff803280c9>] __freed_request+0x2f/0x7f
 [<ffffffff8032813d>] freed_request+0x24/0x44
 [<ffffffff80334332>] kobject_get+0x12/0x17
 [<ffffffff80393f2f>] get_device+0x17/0x1f
 [<ffffffff8039450a>] device_add+0x82/0x519
 [<ffffffff803c300e>] scsi_sysfs_add_sdev+0x86/0x1d5
 [<ffffffff803c140d>] scsi_probe_and_add_lun+0x77b/0x89f
 [<ffffffff803c1a60>] __scsi_scan_target+0x3d0/0x566
 [<ffffffff80221989>] update_curr+0x54/0x64
 [<ffffffff80221989>] update_curr+0x54/0x64
 [<ffffffff803c208f>] scsi_scan_target+0x96/0xb9
 [<ffffffff803c6064>] fc_scsi_scan_rport+0x70/0x84
 [<ffffffff803c5ff4>] fc_scsi_scan_rport+0x0/0x84
 [<ffffffff80233c95>] run_workqueue+0x74/0xee
 [<ffffffff8023431b>] worker_thread+0xd0/0xdb
 [<ffffffff802367e4>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8023424b>] worker_thread+0x0/0xdb
 [<ffffffff8023669c>] kthread+0x47/0x73
 [<ffffffff802247b3>] schedule_tail+0x18/0x4c
 [<ffffffff8020c5b8>] child_rip+0xa/0x12
 [<ffffffff80236655>] kthread+0x0/0x73
 [<ffffffff8020c5ae>] child_rip+0x0/0x12

After fc port up and down for one or two time I am getting below crash =
in Linux server
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: unable to handle kernel NULL pointer dereference at =
0000000000000028
IP: [<ffffffff802a6ef5>] sysfs_find_dirent+0x9/0x2f
PGD 21101067 PUD 210d0067 PMD 0=20
Oops: 0000 [1]=20
Firmware Version :  01.01.0000.00
Pid: 1385, comm: fc_wq_4 2.6.26EIGHTSTACK_64_V15_V11_8GB_SANFS_UP #1
 [ffffffff802a6ef5] sysfs_find_dirent+0x9/0x2f
RIP: 0010:[ffffffff802a6ef5] RSP: 0018:ffff8100240cdd30  EFLAGS: =
00010286
RAX: ffff810020c14c30 RBX: ffffffff805c1d8e RCX: 0000000000000002
RDX: ffff8100329a8278 RSI: ffffffff805c1d8e RDI: 0000000000000000
RBP: ffffffff805c1d8e R08: 00000000000015c1 R09: ffff81003f818150
R10: 0000000000000000 R11: ffff8100240d3f50 R12: 0000000000000000
R13: ffff810022031c08 R14: ffffffff806ac6a0 R15: 00000000016a5018
Call Trace
--------------------
 [ffffffff802a7914] ? sysfs_get_dirent+0x24/0x58
 [ffffffff802a81c2] ? sysfs_remove_group+0x24/0xc0
 [ffffffff80398a51] ? device_pm_remove+0x18/0x49
 [ffffffff803942e3] ? device_del+0x13/0x15b
 [ffffffff80394434] ? device_unregister+0x9/0x12
 [ffffffff803c2e0a] ? __scsi_remove_device+0x2a/0x7a
 [ffffffff803c2e7b] ? scsi_remove_device+0x21/0x2e
 [ffffffff803c2f62] ? __remove_child+0x0/0x1a
=20
Thanks,
Praveen

------_=_NextPart_001_01CE675C.869A29BF
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<HTML dir=3Dltr><HEAD>=0A=
<META content=3D"text/html; charset=3Dunicode" http-equiv=3DContent-Type>=0A=
<META name=3DGENERATOR content=3D"MSHTML 9.00.8112.16490"></HEAD>=0A=
<BODY>=0A=
<DIV><FONT color=3D#000000 size=3D2 face=3DArial>Hello All,</FONT></DIV>=0A=
<DIV><FONT size=3D2 face=3DArial></FONT>&nbsp;</DIV>=0A=
<DIV><FONT color=3D#000000 size=3D2 face=3DArial>I have a RAID storage =
box connected to a Linux server through fc cables. The server is using =
<BR>kernel 2.6.26, and multipath-tools v0.4.7 (with dm-mpath target =
version 1.0.5) is installed on it <BR>to handle the disk scsi devices =
from the storage box. The multipath device is mounted and <BR>used for a =
file system. </FONT></DIV>=0A=
<DIV>&nbsp;</DIV>=0A=
<DIV><FONT color=3D#000000 size=3D2 face=3DArial>When fc port is down, =
it is seen that the scsi fc transport layer removes the corresponding =
<BR>fc-target and all the scsi device attached to this target. And when =
the fc port come back up, <BR>I see the kernel crash. Below are the =
details on the crash. Is there any patch available to fix <BR>this =
crash?</FONT></DIV>=0A=
<DIV><FONT size=3D2 face=3DArial></FONT>&nbsp;</DIV>=0A=
<DIV><FONT color=3D#000000 size=3D2 face=3DArial>During port down the =
output of multipath -l =
<BR>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<=
/FONT></DIV>=0A=
<DIV><FONT color=3D#000000 size=3D2 face=3DArial>/ &gt; multipath =
-l<BR>22230000155f989c9 dm-0 =
,<BR>[size=3D70G][features=3D0][hwhandler=3D1 alua][rw]<BR>\_ =
round-robin 0 [prio=3D0][enabled]<BR>&nbsp;\_ #:#:#:# -&nbsp;&nbsp; =
#:#&nbsp;&nbsp; [failed][undef]<BR>&nbsp;\_ #:#:#:# -&nbsp;&nbsp; =
#:#&nbsp;&nbsp; [failed][undef]<BR>&nbsp;\_ #:#:#:# -&nbsp;&nbsp; =
#:#&nbsp;&nbsp; [failed][undef]<BR>&nbsp;\_ #:#:#:# -&nbsp;&nbsp; =
#:#&nbsp;&nbsp; [failed][undef]<BR>22207000155f84ba3 dm-1 =
,<BR>[size=3D70G][features=3D0][hwhandler=3D1 alua][rw]<BR>\_ =
round-robin 0 [prio=3D0][enabled]<BR>&nbsp;\_ #:#:#:# -&nbsp;&nbsp; =
#:#&nbsp;&nbsp; [failed][undef]<BR>&nbsp;\_ #:#:#:# -&nbsp;&nbsp; =
#:#&nbsp;&nbsp; [failed][undef]<BR>/ &gt;</FONT></DIV><FONT =
color=3D#000000 size=3D2 face=3DArial>=0A=
<DIV><BR>During port up I am getting below stack dump in Linux =
server<BR>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<=
/DIV>=0A=
<DIV>kobject_add_internal failed for 4:0:3:0 with -EEXIST, don't try to =
register things with the same name in the same directory.<BR>Pid: 1384, =
comm: scsi_wq_4 Tainted: =
P&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
2.6.26EIGHTSTACK_64_V15_V11_8GB_SANFS_UP #1</DIV>=0A=
<DIV>Call Trace:<BR>&nbsp;[&lt;ffffffff80334455&gt;] =
kobject_add_internal+0x11e/0x15d<BR>&nbsp;[&lt;ffffffff803348b3&gt;] =
kobject_add+0x74/0x7c<BR>&nbsp;[&lt;ffffffff80283df4&gt;] =
bio_alloc_bioset+0x89/0xd9<BR>&nbsp;[&lt;ffffffff802846a9&gt;] =
bio_map_kern+0xae/0x103<BR>&nbsp;[&lt;ffffffff803280c9&gt;] =
__freed_request+0x2f/0x7f<BR>&nbsp;[&lt;ffffffff8032813d&gt;] =
freed_request+0x24/0x44<BR>&nbsp;[&lt;ffffffff80334332&gt;] =
kobject_get+0x12/0x17<BR>&nbsp;[&lt;ffffffff80393f2f&gt;] =
get_device+0x17/0x1f<BR>&nbsp;[&lt;ffffffff8039450a&gt;] =
device_add+0x82/0x519<BR>&nbsp;[&lt;ffffffff803c300e&gt;] =
scsi_sysfs_add_sdev+0x86/0x1d5<BR>&nbsp;[&lt;ffffffff803c140d&gt;] =
scsi_probe_and_add_lun+0x77b/0x89f<BR>&nbsp;[&lt;ffffffff803c1a60&gt;] =
__scsi_scan_target+0x3d0/0x566<BR>&nbsp;[&lt;ffffffff80221989&gt;] =
update_curr+0x54/0x64<BR>&nbsp;[&lt;ffffffff80221989&gt;] =
update_curr+0x54/0x64<BR>&nbsp;[&lt;ffffffff803c208f&gt;] =
scsi_scan_target+0x96/0xb9<BR>&nbsp;[&lt;ffffffff803c6064&gt;] =
fc_scsi_scan_rport+0x70/0x84<BR>&nbsp;[&lt;ffffffff803c5ff4&gt;] =
fc_scsi_scan_rport+0x0/0x84<BR>&nbsp;[&lt;ffffffff80233c95&gt;] =
run_workqueue+0x74/0xee<BR>&nbsp;[&lt;ffffffff8023431b&gt;] =
worker_thread+0xd0/0xdb<BR>&nbsp;[&lt;ffffffff802367e4&gt;] =
autoremove_wake_function+0x0/0x2e<BR>&nbsp;[&lt;ffffffff8023424b&gt;] =
worker_thread+0x0/0xdb<BR>&nbsp;[&lt;ffffffff8023669c&gt;] =
kthread+0x47/0x73<BR>&nbsp;[&lt;ffffffff802247b3&gt;] =
schedule_tail+0x18/0x4c<BR>&nbsp;[&lt;ffffffff8020c5b8&gt;] =
child_rip+0xa/0x12<BR>&nbsp;[&lt;ffffffff80236655&gt;] =
kthread+0x0/0x73<BR>&nbsp;[&lt;ffffffff8020c5ae&gt;] =
child_rip+0x0/0x12</DIV>=0A=
<DIV><BR>After fc port up and down for one or two time&nbsp;I am getting =
below crash in Linux =
server<BR>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D</DIV>=0A=
<DIV>BUG: unable to handle kernel NULL pointer dereference at =
0000000000000028<BR>IP: [&lt;ffffffff802a6ef5&gt;] =
sysfs_find_dirent+0x9/0x2f<BR>PGD 21101067 PUD 210d0067 PMD 0 <BR>Oops: =
0000 [1] <BR>Firmware Version :&nbsp; 01.01.0000.00</DIV>=0A=
<DIV>Pid: 1385, comm: fc_wq_4 2.6.26EIGHTSTACK_64_V15_V11_8GB_SANFS_UP =
#1<BR>&nbsp;[ffffffff802a6ef5] sysfs_find_dirent+0x9/0x2f<BR>RIP: =
0010:[ffffffff802a6ef5] RSP: 0018:ffff8100240cdd30&nbsp; EFLAGS: =
00010286<BR>RAX: ffff810020c14c30 RBX: ffffffff805c1d8e RCX: =
0000000000000002<BR>RDX: ffff8100329a8278 RSI: ffffffff805c1d8e RDI: =
0000000000000000<BR>RBP: ffffffff805c1d8e R08: 00000000000015c1 R09: =
ffff81003f818150<BR>R10: 0000000000000000 R11: ffff8100240d3f50 R12: =
0000000000000000<BR>R13: ffff810022031c08 R14: ffffffff806ac6a0 R15: =
00000000016a5018</DIV>=0A=
<DIV>Call Trace<BR>--------------------<BR>&nbsp;[ffffffff802a7914] ? =
sysfs_get_dirent+0x24/0x58<BR>&nbsp;[ffffffff802a81c2] ? =
sysfs_remove_group+0x24/0xc0<BR>&nbsp;[ffffffff80398a51] ? =
device_pm_remove+0x18/0x49<BR>&nbsp;[ffffffff803942e3] ? =
device_del+0x13/0x15b<BR>&nbsp;[ffffffff80394434] ? =
device_unregister+0x9/0x12<BR>&nbsp;[ffffffff803c2e0a] ? =
__scsi_remove_device+0x2a/0x7a<BR>&nbsp;[ffffffff803c2e7b] ? =
scsi_remove_device+0x21/0x2e<BR>&nbsp;[ffffffff803c2f62] ? =
__remove_child+0x0/0x1a</DIV>=0A=
<DIV>&nbsp;</DIV>=0A=
<DIV>Thanks,<BR>Praveen</FONT></DIV></BODY></HTML>
------_=_NextPart_001_01CE675C.869A29BF--


--===============9026878079529517602==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============9026878079529517602==--
