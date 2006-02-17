From: "Juer(ZH-CN)" <jlee@plasmon.cn>
Subject: Kernel panic issue of kernel 2.6.16-rc1 + latest device
	mapper patches
Date: Fri, 17 Feb 2006 09:26:43 +0800
Message-ID: <200602170135.k1H1ZL6n030476@mx1.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0133936565=="
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
List-Id: dm-devel.ids

This is a multi-part message in MIME format.

--===============0133936565==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_030F_01C633A4.448A5F50"

This is a multi-part message in MIME format.

------=_NextPart_000_030F_01C633A4.448A5F50
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit

Hi, 

 

Thanks for the team working on the device mapper driver.

I have installed Fedora Core 4 and downloaded latest device mapper patches
from the website
http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/ and
applied them to the kernel 2.6.16-rc1, but I still experience problems when
removing snapshots if there are large I/Os and tens of snapshots have been
created. Before applying those patches to the kernel, kernel panic even when
removing the only one snapshot created for a LV if there are large I/Os on
the LV.

 

The steps to produce the issue:

 

1.       Create PV on the disk partition directly 

2.       Create VG on the PV just created

3.       Create a 20G LV on the VG

4.       Create XFS file system on the LV

5.       Mount the LV

6.       Run a script to generate large I/Os on the LV. The job will keep
running till interrupted by me.

7.       2 snapshots have been created for the LV successfully

8.       All snapshots have been removed one by one successfully

9.       21 snapshots have been created for the LV successfully

10.   Try to remove all snapshots by ("lvremove -f /dev/vg/snap*").

I have seen following messages in the system log before kernel panic
information were logged.

Feb 15 15:39:43 sit-fc4 kernel: attempt to access beyond end of device

Feb 15 15:39:43 sit-fc4 kernel: dm-14: rw=17, want=4194320, limit=4194304

 

       Kernel panic

Kernel panic information:

 

Feb 15 15:40:22 sit-fc4 kernel: Unable to handle kernel paging request at
virtual address 8b8a8988

Feb 15 15:40:22 sit-fc4 kernel:  printing eip:

Feb 15 15:40:22 sit-fc4 kernel: f8abe0ab

Feb 15 15:40:22 sit-fc4 kernel: *pde = 9b9a9998

Feb 15 15:40:22 sit-fc4 kernel: Oops: 0000 [#1]

Feb 15 15:40:22 sit-fc4 kernel: SMP

Feb 15 15:40:22 sit-fc4 kernel: Modules linked in: smbfs xfs exportfs
dm_zero dm_snapshot dm_mod ipv6 parport_pc lp parport autofs4

rfcomm l2cap bluetooth sunrpc video button battery ac uhci_hcd i2c_i801
i2c_core shpchp e1000 ext3 jbd sata_mv libata aic79xx scsi_t

ransport_spi sd_mod scsi_mod

Feb 15 15:40:22 sit-fc4 kernel: CPU:    0

Feb 15 15:40:22 sit-fc4 kernel: EIP:    0060:[<f8abe0ab>]    Not tainted VLI

Feb 15 15:40:22 sit-fc4 kernel: EFLAGS: 00010212   (2.6.16rc2)

Feb 15 15:40:22 sit-fc4 kernel: EIP is at exit_exception_table+0x3b/0x70
[dm_snapshot]

Feb 15 15:40:22 sit-fc4 kernel: eax: 00000046   ebx: 8b8a8988   ecx:
f6fa38c0   edx: dde13988

Feb 15 15:40:22 sit-fc4 kernel: esi: f8bf6ec0   edi: f6fa38c0   ebp:
000001d8   esp: dfb28da4

Feb 15 15:40:22 sit-fc4 kernel: ds: 007b   es: 007b   ss: 0068

Feb 15 15:40:22 sit-fc4 kernel: Process lvremove (pid: 4057,
threadinfo=dfb28000 task=c85e4aa0)

Feb 15 15:40:22 sit-fc4 kernel: Stack: <0>e66b84d8 00004000 e66b8480
d8b097c0 f8ac3700 f8a3e080 f8abe619 f8a3e080

Feb 15 15:40:22 sit-fc4 kernel:        e66b8280 00000000 00000000 f8aaff16
00000004 e66b8280 f59e68e0 00000004

Feb 15 15:40:22 sit-fc4 kernel:        f8ab2a00 f8ab1f33 f8abb6ec f8ad8000
f8ab2a44 00000000 00000000 f8ad8000

Feb 15 15:40:22 sit-fc4 kernel: Call Trace:

Feb 15 15:40:22 sit-fc4 kernel:  [<f8abe619>] snapshot_dtr+0x99/0x110
[dm_snapshot]

Feb 15 15:40:22 sit-fc4 kernel:  [<f8aaff16>] dm_table_put+0x56/0xd0
[dm_mod]

Feb 15 15:40:22 sit-fc4 kernel:  [<f8ab2a00>] dev_remove+0x0/0x90 [dm_mod]

Feb 15 15:40:22 sit-fc4 kernel:  [<f8ab1f33>] __hash_remove+0x63/0x80
[dm_mod]

Feb 15 15:40:22 sit-fc4 kernel:  [<f8ab2a44>] dev_remove+0x44/0x90 [dm_mod]

Feb 15 15:40:22 sit-fc4 kernel:  [<f8ab2105>] ctl_ioctl+0x1b5/0x2c0 [dm_mod]

Feb 15 15:40:22 sit-fc4 kernel:  [<c0150607>] __alloc_pages+0x57/0x320

Feb 15 15:40:22 sit-fc4 kernel:  [<c017f6fa>] do_ioctl+0x8a/0xa0

Feb 15 15:40:22 sit-fc4 kernel:  [<c017f76c>] vfs_ioctl+0x5c/0x2f0

Feb 15 15:40:22 sit-fc4 kernel:  [<c0106b2a>] do_syscall_trace+0x21a/0x240

Feb 15 15:40:22 sit-fc4 kernel:  [<c017fa72>] sys_ioctl+0x72/0x90

Feb 15 15:40:22 sit-fc4 kernel:  [<c0104205>] syscall_call+0x7/0xb

Feb 15 15:40:22 sit-fc4 kernel: Code: d2 89 54 24 04 7e 43 8b 40 04 31 ed 8d
74 26 00 8d 34 e8 8b 16 39 d6 8b 1a 75 07 eb 1a 8d 76 0

0 89 c3 89 f8 e8 a7 ab 6a c7 39 de <8b> 03 89 da 75 ef 8b 14 24 8b 42 04 45
39 6c 24 04 75 d2 83 c4

Feb 15 15:40:22 sit-fc4 kernel:  <0>Fatal exception: panic in 5 seconds

11.   Reboot the system, then remove all snapshots

12.   Repeat step 6 - Run a script to generate large I/Os on the LV. The job
will keep running till interrupted by me.

13.   5 snapshots have been created for the LV successfully

14.   All snapshots have been removed by ("lvremove -f /dev/vg/snap*")
successfully.

15.   9 snapshots have been created for the LV successfully

16.   Try to remove all snapshots by ("lvremove -f /dev/vg/snap*").

17.   Kernel panic again

18.   5 snapshots have been created for the LV successfully

19.   All snapshots have been removed by ("lvremove -f /dev/vg/snap*")
successfully.

20.    

 

Juer


------=_NextPart_000_030F_01C633A4.448A5F50
Content-Type: text/html;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" =
xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:x=3D"urn:schemas-microsoft-com:office:excel" =
xmlns:st1=3D"urn:schemas-microsoft-com:office:smarttags" =
xmlns=3D"http://www.w3.org/TR/REC-html40">

<head>
<meta http-equiv=3DContent-Type content=3D"text/html; =
charset=3Dus-ascii">
<meta name=3DGenerator content=3D"Microsoft Word 11 (filtered medium)">
<o:SmartTagType =
namespaceuri=3D"urn:schemas-microsoft-com:office:smarttags"
 name=3D"City" =
downloadurl=3D"http://www.5iamas-microsoft-com:office:smarttags"/>
<o:SmartTagType =
namespaceuri=3D"urn:schemas-microsoft-com:office:smarttags"
 name=3D"place" downloadurl=3D"http://www.5iantlavalamp.com/"/>
<!--[if !mso]>
<style>
st1\:*{behavior:url(#default#ieooui) }
</style>
<![endif]-->
<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:SimSun;
	panose-1:2 1 6 0 3 1 1 1 1 1;}
@font-face
	{font-family:SimSun;
	panose-1:2 1 6 0 3 1 1 1 1 1;}
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
	margin-bottom:.0001pt;
	text-align:justify;
	text-justify:inter-ideograph;
	font-size:10.5pt;
	font-family:"Times New Roman";}
a:link, span.MsoHyperlink
	{color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{color:purple;
	text-decoration:underline;}
p.MsoPlainText, li.MsoPlainText, div.MsoPlainText
	{margin:0cm;
	margin-bottom:.0001pt;
	font-size:9.0pt;
	font-family:SimSun;}
span.EmailStyle18
	{mso-style-type:personal;
	font-family:Arial;
	color:navy;}
span.EmailStyle19
	{mso-style-type:personal;
	font-family:Arial;
	color:navy;}
span.EmailStyle20
	{mso-style-type:personal-reply;
	font-family:Arial;
	color:navy;}
@page Section1
	{size:595.3pt 841.9pt;
	margin:72.0pt 126.65pt 72.0pt 126.65pt;
	layout-grid:15.6pt;}
div.Section1
	{page:Section1;}
 /* List Definitions */
 @list l0
	{mso-list-id:700907788;
	mso-list-type:hybrid;
	mso-list-template-ids:-2051754402 1258327734 67698713 67698715 67698703 =
67698713 67698715 67698703 67698713 67698715;}
@list l0:level1
	{mso-level-tab-stop:18.0pt;
	mso-level-number-position:left;
	margin-left:18.0pt;
	text-indent:-18.0pt;}
@list l0:level2
	{mso-level-number-format:alpha-lower;
	mso-level-text:"%2\)";
	mso-level-tab-stop:42.0pt;
	mso-level-number-position:left;
	margin-left:42.0pt;
	text-indent:-21.0pt;}
@list l0:level3
	{mso-level-tab-stop:108.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;}
@list l0:level4
	{mso-level-tab-stop:144.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;}
@list l0:level5
	{mso-level-tab-stop:180.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;}
@list l0:level6
	{mso-level-tab-stop:216.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;}
@list l0:level7
	{mso-level-tab-stop:252.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;}
@list l0:level8
	{mso-level-tab-stop:288.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;}
@list l0:level9
	{mso-level-tab-stop:324.0pt;
	mso-level-number-position:left;
	text-indent:-18.0pt;}
ol
	{margin-bottom:0cm;}
ul
	{margin-bottom:0cm;}
-->
</style>

</head>

<body lang=3DZH-CN link=3Dblue vlink=3Dpurple =
style=3D'text-justify-trim:punctuation'>

<div class=3DSection1 style=3D'layout-grid:15.6pt'>

<p class=3DMsoPlainText><font size=3D1 face=3D&#23435;&#20307;><span =
lang=3DEN-US
style=3D'font-size:9.0pt'>Hi, <o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D1 face=3D&#23435;&#20307;><span =
lang=3DEN-US
style=3D'font-size:7.5pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D1 face=3D&#23435;&#20307;><span =
lang=3DEN-US
style=3D'font-size:9.0pt'>Thanks for the team working on the device =
mapper
driver.<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D1 face=3D&#23435;&#20307;><span =
lang=3DEN-US
style=3D'font-size:9.0pt'>I have installed Fedora Core 4 and downloaded =
latest
device mapper patches from the website <a
href=3D"http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/edi=
ting/">http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/edit=
ing/</a>
and applied them to the kernel 2.6.16-rc1, but I still experience =
problems when
removing snapshots if there are large I/Os and tens of snapshots have =
been
created. Before applying those patches to the kernel, kernel panic even =
when
removing the only one snapshot created for a <st1:City =
w:st=3D"on">LV</st1:City>
if there are large I/Os on the <st1:place w:st=3D"on"><st1:City =
w:st=3D"on">LV.</st1:City></st1:place><o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D1 color=3Dblack =
face=3D&#23435;&#20307;><span
lang=3DEN-US =
style=3D'font-size:7.5pt;color:black'><o:p>&nbsp;</o:p></span></font></p>=


<p class=3DMsoPlainText><font size=3D1 color=3Dblack =
face=3D&#23435;&#20307;><span
lang=3DEN-US style=3D'font-size:9.0pt;color:black'>The steps to produce =
the issue:<o:p></o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D1 color=3Dblack =
face=3D&#23435;&#20307;><span
lang=3DEN-US =
style=3D'font-size:7.5pt;color:black'><o:p>&nbsp;</o:p></span></font></p>=


<p class=3DMsoNormal =
style=3D'margin-left:18.0pt;text-indent:-18.0pt;mso-list:l0 level1 =
lfo2'><![if !supportLists]><font
size=3D2 face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'><span
style=3D'mso-list:Ignore'>1.<font size=3D1 face=3D"Times New =
Roman"><span
style=3D'font:7.0pt "Times New =
Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
</span></font></span></span></font><![endif]><span
lang=3DEN-US>Create PV on the disk partition directly =
<o:p></o:p></span></p>

<p class=3DMsoNormal =
style=3D'margin-left:18.0pt;text-indent:-18.0pt;mso-list:l0 level1 =
lfo2'><![if !supportLists]><font
size=3D2 face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'><span
style=3D'mso-list:Ignore'>2.<font size=3D1 face=3D"Times New =
Roman"><span
style=3D'font:7.0pt "Times New =
Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
</span></font></span></span></font><![endif]><span
lang=3DEN-US>Create VG on the PV just created<o:p></o:p></span></p>

<p class=3DMsoNormal =
style=3D'margin-left:18.0pt;text-indent:-18.0pt;mso-list:l0 level1 =
lfo2'><![if !supportLists]><font
size=3D2 face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'><span
style=3D'mso-list:Ignore'>3.<font size=3D1 face=3D"Times New =
Roman"><span
style=3D'font:7.0pt "Times New =
Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
</span></font></span></span></font><![endif]><span
lang=3DEN-US>Create a 20G <st1:place w:st=3D"on"><st1:City =
w:st=3D"on">LV</st1:City></st1:place>
on the VG<o:p></o:p></span></p>

<p class=3DMsoNormal =
style=3D'margin-left:18.0pt;text-indent:-18.0pt;mso-list:l0 level1 =
lfo2'><![if !supportLists]><font
size=3D2 face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'><span
style=3D'mso-list:Ignore'>4.<font size=3D1 face=3D"Times New =
Roman"><span
style=3D'font:7.0pt "Times New =
Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
</span></font></span></span></font><![endif]><span
lang=3DEN-US>Create XFS file system on the <st1:place =
w:st=3D"on"><st1:City =
w:st=3D"on">LV</st1:City></st1:place><o:p></o:p></span></p>

<p class=3DMsoNormal =
style=3D'margin-left:18.0pt;text-indent:-18.0pt;mso-list:l0 level1 =
lfo2'><![if !supportLists]><font
size=3D2 face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'><span
style=3D'mso-list:Ignore'>5.<font size=3D1 face=3D"Times New =
Roman"><span
style=3D'font:7.0pt "Times New =
Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
</span></font></span></span></font><![endif]><span
lang=3DEN-US>Mount the <st1:place w:st=3D"on"><st1:City =
w:st=3D"on">LV</st1:City></st1:place><o:p></o:p></span></p>

<p class=3DMsoNormal =
style=3D'margin-left:18.0pt;text-indent:-18.0pt;mso-list:l0 level1 =
lfo2'><![if !supportLists]><font
size=3D2 face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'><span
style=3D'mso-list:Ignore'>6.<font size=3D1 face=3D"Times New =
Roman"><span
style=3D'font:7.0pt "Times New =
Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
</span></font></span></span></font><![endif]><span
lang=3DEN-US>Run a script to generate large I/Os on the <st1:place =
w:st=3D"on"><st1:City
 w:st=3D"on">LV.</st1:City></st1:place> The job will keep running till
interrupted by me.<o:p></o:p></span></p>

<p class=3DMsoNormal =
style=3D'margin-left:18.0pt;text-indent:-18.0pt;mso-list:l0 level1 =
lfo2'><![if !supportLists]><font
size=3D2 face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'><span
style=3D'mso-list:Ignore'>7.<font size=3D1 face=3D"Times New =
Roman"><span
style=3D'font:7.0pt "Times New =
Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
</span></font></span></span></font><![endif]><span
lang=3DEN-US>2 snapshots have been created for the <st1:place =
w:st=3D"on"><st1:City
 w:st=3D"on">LV</st1:City></st1:place> =
successfully<o:p></o:p></span></p>

<p class=3DMsoNormal =
style=3D'margin-left:18.0pt;text-indent:-18.0pt;mso-list:l0 level1 =
lfo2'><![if !supportLists]><font
size=3D2 face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'><span
style=3D'mso-list:Ignore'>8.<font size=3D1 face=3D"Times New =
Roman"><span
style=3D'font:7.0pt "Times New =
Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
</span></font></span></span></font><![endif]><span
lang=3DEN-US>All snapshots have been removed one by one =
successfully<o:p></o:p></span></p>

<p class=3DMsoNormal =
style=3D'margin-left:18.0pt;text-indent:-18.0pt;mso-list:l0 level1 =
lfo2'><![if !supportLists]><font
size=3D2 face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'><span
style=3D'mso-list:Ignore'>9.<font size=3D1 face=3D"Times New =
Roman"><span
style=3D'font:7.0pt "Times New =
Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
</span></font></span></span></font><![endif]><span
lang=3DEN-US>21 snapshots have been created for the <st1:place =
w:st=3D"on"><st1:City
 w:st=3D"on">LV</st1:City></st1:place> =
successfully<o:p></o:p></span></p>

<p class=3DMsoNormal =
style=3D'margin-left:18.0pt;text-indent:-18.0pt;mso-list:l0 level1 =
lfo2'><![if !supportLists]><font
size=3D2 face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'><span
style=3D'mso-list:Ignore'>10.<font size=3D1 face=3D"Times New =
Roman"><span
style=3D'font:7.0pt "Times New Roman"'>&nbsp;&nbsp; =
</span></font></span></span></font><![endif]><span
lang=3DEN-US>Try to remove all snapshots by (&#8220;lvremove &#8211;f
/dev/vg/snap*&#8221;).<o:p></o:p></span></p>

<p class=3DMsoNormal style=3D'margin-left:21.0pt'><font size=3D2 =
color=3Dblue
face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt;color:blue'>I
have seen following messages in the system log before kernel panic =
information
were logged.<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:21.0pt'><font size=3D2
face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'>Feb 15
15:39:43 sit-fc4 kernel: attempt to access beyond end of =
device<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-indent:21.0pt'><font size=3D2
face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'>Feb 15
15:39:43 sit-fc4 kernel: dm-14: rw=3D17, want=3D4194320, =
limit=3D4194304<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-indent:21.0pt'><font size=3D2
face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Times New Roman"><span =
lang=3DEN-US
style=3D'font-size:10.5pt'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
</span></font><font
size=3D2 color=3Dred><span lang=3DEN-US =
style=3D'font-size:10.0pt;color:red'>Kernel
panic</span></font><font size=3D2><span lang=3DEN-US =
style=3D'font-size:10.0pt'><o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:21.0pt'><font size=3D2
face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'>Kernel panic
information:<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:21.0pt'><font size=3D2
face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:21.0pt'><font size=3D2
face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'>Feb 15
15:40:22 sit-fc4 kernel: Unable to handle kernel paging request at =
virtual
address 8b8a8988<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:21.0pt'><font size=3D2
face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'>Feb 15
15:40:22 sit-fc4 kernel:&nbsp; printing =
eip:<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:21.0pt'><font size=3D2
face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'>Feb 15
15:40:22 sit-fc4 kernel: f8abe0ab<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:21.0pt'><font size=3D2
face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'>Feb 15
15:40:22 sit-fc4 kernel: *pde =3D 9b9a9998<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:21.0pt'><font size=3D2
face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'>Feb 15
15:40:22 sit-fc4 kernel: Oops: 0000 [#1]<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:21.0pt'><font size=3D2
face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'>Feb 15
15:40:22 sit-fc4 kernel: SMP<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:21.0pt'><font size=3D2
face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'>Feb 15
15:40:22 sit-fc4 kernel: Modules linked in: smbfs xfs exportfs dm_zero
dm_snapshot dm_mod ipv6 parport_pc lp parport =
autofs4<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:21.0pt'><font size=3D2
face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'>rfcomm l2cap
bluetooth sunrpc video button battery ac uhci_hcd i2c_i801 i2c_core =
shpchp
e1000 ext3 jbd sata_mv libata aic79xx =
scsi_t<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:21.0pt'><font size=3D2
face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'>ransport_spi
sd_mod scsi_mod<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:21.0pt'><font size=3D2
face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'>Feb 15
15:40:22 sit-fc4 kernel: CPU:&nbsp;&nbsp;&nbsp; =
0<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:21.0pt'><font size=3D2
face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'>Feb 15
15:40:22 sit-fc4 kernel: EIP:&nbsp;&nbsp;&nbsp;
0060:[&lt;f8abe0ab&gt;]&nbsp;&nbsp;&nbsp; Not tainted =
VLI<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:21.0pt'><font size=3D2
face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'>Feb 15
15:40:22 sit-fc4 kernel: EFLAGS: 00010212&nbsp;&nbsp; =
(2.6.16rc2)<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:21.0pt'><font size=3D2
face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'>Feb 15
15:40:22 sit-fc4 kernel: EIP is at exit_exception_table+0x3b/0x70 =
[dm_snapshot]<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:21.0pt'><font size=3D2
face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'>Feb 15
15:40:22 sit-fc4 kernel: eax: 00000046&nbsp;&nbsp; ebx: =
8b8a8988&nbsp;&nbsp;
ecx: f6fa38c0&nbsp;&nbsp; edx: dde13988<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:21.0pt'><font size=3D2
face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'>Feb 15
15:40:22 sit-fc4 kernel: esi: f8bf6ec0&nbsp;&nbsp; edi: =
f6fa38c0&nbsp;&nbsp;
ebp: 000001d8&nbsp;&nbsp; esp: dfb28da4<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:21.0pt'><font size=3D2
face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'>Feb 15
15:40:22 sit-fc4 kernel: ds: 007b&nbsp;&nbsp; es: 007b&nbsp;&nbsp; ss: =
0068<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:21.0pt'><font size=3D2
face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'>Feb 15
15:40:22 sit-fc4 kernel: Process lvremove (pid: 4057, =
threadinfo=3Ddfb28000
task=3Dc85e4aa0)<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:21.0pt'><font size=3D2
face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'>Feb 15
15:40:22 sit-fc4 kernel: Stack: &lt;0&gt;e66b84d8 00004000 e66b8480 =
d8b097c0
f8ac3700 f8a3e080 f8abe619 f8a3e080<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:21.0pt'><font size=3D2
face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'>Feb 15
15:40:22 sit-fc4 kernel:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
e66b8280
00000000 00000000 f8aaff16 00000004 e66b8280 f59e68e0 =
00000004<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:21.0pt'><font size=3D2
face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'>Feb 15
15:40:22 sit-fc4 kernel:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
f8ab2a00
f8ab1f33 f8abb6ec f8ad8000 f8ab2a44 00000000 00000000 =
f8ad8000<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:21.0pt'><font size=3D2
face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'>Feb 15
15:40:22 sit-fc4 kernel: Call Trace:<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:21.0pt'><font size=3D2
face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'>Feb 15
15:40:22 sit-fc4 kernel:&nbsp; [&lt;f8abe619&gt;] =
snapshot_dtr+0x99/0x110
[dm_snapshot]<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:21.0pt'><font size=3D2
face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'>Feb 15
15:40:22 sit-fc4 kernel:&nbsp; [&lt;f8aaff16&gt;] dm_table_put+0x56/0xd0
[dm_mod]<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:21.0pt'><font size=3D2
face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'>Feb 15
15:40:22 sit-fc4 kernel:&nbsp; [&lt;f8ab2a00&gt;] dev_remove+0x0/0x90 =
[dm_mod]<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:21.0pt'><font size=3D2
face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'>Feb 15
15:40:22 sit-fc4 kernel:&nbsp; [&lt;f8ab1f33&gt;] =
__hash_remove+0x63/0x80
[dm_mod]<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:21.0pt'><font size=3D2
face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'>Feb 15
15:40:22 sit-fc4 kernel:&nbsp; [&lt;f8ab2a44&gt;] dev_remove+0x44/0x90 =
[dm_mod]<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:21.0pt'><font size=3D2
face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'>Feb 15
15:40:22 sit-fc4 kernel:&nbsp; [&lt;f8ab2105&gt;] ctl_ioctl+0x1b5/0x2c0
[dm_mod]<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:21.0pt'><font size=3D2
face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'>Feb 15
15:40:22 sit-fc4 kernel:&nbsp; [&lt;c0150607&gt;] =
__alloc_pages+0x57/0x320<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:21.0pt'><font size=3D2
face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'>Feb 15
15:40:22 sit-fc4 kernel:&nbsp; [&lt;c017f6fa&gt;] =
do_ioctl+0x8a/0xa0<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:21.0pt'><font size=3D2
face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'>Feb 15
15:40:22 sit-fc4 kernel:&nbsp; [&lt;c017f76c&gt;] =
vfs_ioctl+0x5c/0x2f0<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:21.0pt'><font size=3D2
face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'>Feb 15
15:40:22 sit-fc4 kernel:&nbsp; [&lt;c0106b2a&gt;] =
do_syscall_trace+0x21a/0x240<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:21.0pt'><font size=3D2
face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'>Feb 15
15:40:22 sit-fc4 kernel:&nbsp; [&lt;c017fa72&gt;] =
sys_ioctl+0x72/0x90<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:21.0pt'><font size=3D2
face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'>Feb 15
15:40:22 sit-fc4 kernel:&nbsp; [&lt;c0104205&gt;] =
syscall_call+0x7/0xb<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:21.0pt'><font size=3D2
face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'>Feb 15
15:40:22 sit-fc4 kernel: Code: d2 89 54 24 04 7e 43 8b 40 04 31 ed 8d 74 =
26 00
8d 34 e8 8b 16 39 d6 8b 1a 75 07 eb 1a 8d 76 =
0<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:21.0pt'><font size=3D2
face=3D"Times New Roman"><span lang=3DEN-US style=3D'font-size:10.5pt'>0 =
89 c3 89 f8
e8 a7 ab 6a c7 39 de &lt;8b&gt; 03 89 da 75 ef 8b 14 24 8b 42 04 45 39 =
6c 24 04
75 d2 83 c4<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-left:21.0pt'><font size=3D2
face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'>Feb 15
15:40:22 sit-fc4 kernel:&nbsp; &lt;0&gt;Fatal exception: panic in 5 =
seconds<o:p></o:p></span></font></p>

<p class=3DMsoNormal =
style=3D'margin-left:18.0pt;text-indent:-18.0pt;mso-list:l0 level1 =
lfo2'><![if !supportLists]><font
size=3D2 face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'><span
style=3D'mso-list:Ignore'>11.<font size=3D1 face=3D"Times New =
Roman"><span
style=3D'font:7.0pt "Times New Roman"'>&nbsp;&nbsp; =
</span></font></span></span></font><![endif]><span
lang=3DEN-US>Reboot the system, then remove all =
snapshots<o:p></o:p></span></p>

<p class=3DMsoNormal =
style=3D'margin-left:18.0pt;text-indent:-18.0pt;mso-list:l0 level1 =
lfo2'><![if !supportLists]><font
size=3D2 face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'><span
style=3D'mso-list:Ignore'>12.<font size=3D1 face=3D"Times New =
Roman"><span
style=3D'font:7.0pt "Times New Roman"'>&nbsp;&nbsp; =
</span></font></span></span></font><![endif]><span
lang=3DEN-US>Repeat step 6 - Run a script to generate large I/Os on the =
<st1:place
w:st=3D"on"><st1:City w:st=3D"on">LV.</st1:City></st1:place> The job =
will keep
running till interrupted by me.<o:p></o:p></span></p>

<p class=3DMsoNormal =
style=3D'margin-left:18.0pt;text-indent:-18.0pt;mso-list:l0 level1 =
lfo2'><![if !supportLists]><font
size=3D2 face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'><span
style=3D'mso-list:Ignore'>13.<font size=3D1 face=3D"Times New =
Roman"><span
style=3D'font:7.0pt "Times New Roman"'>&nbsp;&nbsp; =
</span></font></span></span></font><![endif]><span
lang=3DEN-US>5 snapshots have been created for the <st1:place =
w:st=3D"on"><st1:City
 w:st=3D"on">LV</st1:City></st1:place> =
successfully<o:p></o:p></span></p>

<p class=3DMsoNormal =
style=3D'margin-left:18.0pt;text-indent:-18.0pt;mso-list:l0 level1 =
lfo2'><![if !supportLists]><font
size=3D2 face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'><span
style=3D'mso-list:Ignore'>14.<font size=3D1 face=3D"Times New =
Roman"><span
style=3D'font:7.0pt "Times New Roman"'>&nbsp;&nbsp; =
</span></font></span></span></font><![endif]><span
lang=3DEN-US>All snapshots have been removed by (&#8220;lvremove =
&#8211;f
/dev/vg/snap*&#8221;) successfully.<o:p></o:p></span></p>

<p class=3DMsoNormal =
style=3D'margin-left:18.0pt;text-indent:-18.0pt;mso-list:l0 level1 =
lfo2'><![if !supportLists]><font
size=3D2 face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'><span
style=3D'mso-list:Ignore'>15.<font size=3D1 face=3D"Times New =
Roman"><span
style=3D'font:7.0pt "Times New Roman"'>&nbsp;&nbsp; =
</span></font></span></span></font><![endif]><span
lang=3DEN-US>9 snapshots have been created for the <st1:place =
w:st=3D"on"><st1:City
 w:st=3D"on">LV</st1:City></st1:place> =
successfully<o:p></o:p></span></p>

<p class=3DMsoNormal =
style=3D'margin-left:18.0pt;text-indent:-18.0pt;mso-list:l0 level1 =
lfo2'><![if !supportLists]><font
size=3D2 face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'><span
style=3D'mso-list:Ignore'>16.<font size=3D1 face=3D"Times New =
Roman"><span
style=3D'font:7.0pt "Times New Roman"'>&nbsp;&nbsp; =
</span></font></span></span></font><![endif]><span
lang=3DEN-US>Try to remove all snapshots by (&#8220;lvremove &#8211;f
/dev/vg/snap*&#8221;).<o:p></o:p></span></p>

<p class=3DMsoNormal =
style=3D'margin-left:18.0pt;text-indent:-18.0pt;mso-list:l0 level1 =
lfo2'><![if !supportLists]><font
size=3D2 face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'><span
style=3D'mso-list:Ignore'>17.<font size=3D1 face=3D"Times New =
Roman"><span
style=3D'font:7.0pt "Times New Roman"'>&nbsp;&nbsp; =
</span></font></span></span></font><![endif]><font
color=3Dred><span lang=3DEN-US style=3D'color:red'>Kernel panic =
again</span></font><span
lang=3DEN-US><o:p></o:p></span></p>

<p class=3DMsoNormal =
style=3D'margin-left:18.0pt;text-indent:-18.0pt;mso-list:l0 level1 =
lfo2'><![if !supportLists]><font
size=3D2 face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'><span
style=3D'mso-list:Ignore'>18.<font size=3D1 face=3D"Times New =
Roman"><span
style=3D'font:7.0pt "Times New Roman"'>&nbsp;&nbsp; =
</span></font></span></span></font><![endif]><span
lang=3DEN-US>5 snapshots have been created for the <st1:place =
w:st=3D"on"><st1:City
 w:st=3D"on">LV</st1:City></st1:place> =
successfully<o:p></o:p></span></p>

<p class=3DMsoNormal =
style=3D'margin-left:18.0pt;text-indent:-18.0pt;mso-list:l0 level1 =
lfo2'><![if !supportLists]><font
size=3D2 face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'><span
style=3D'mso-list:Ignore'>19.<font size=3D1 face=3D"Times New =
Roman"><span
style=3D'font:7.0pt "Times New Roman"'>&nbsp;&nbsp; =
</span></font></span></span></font><![endif]><span
lang=3DEN-US>All snapshots have been removed by (&#8220;lvremove =
&#8211;f
/dev/vg/snap*&#8221;) successfully.<o:p></o:p></span></p>

<p class=3DMsoNormal =
style=3D'margin-left:18.0pt;text-indent:-18.0pt;mso-list:l0 level1 =
lfo2'><![if !supportLists]><font
size=3D2 face=3D"Times New Roman"><span lang=3DEN-US =
style=3D'font-size:10.5pt'><span
style=3D'mso-list:Ignore'>20.<font size=3D1 face=3D"Times New =
Roman"><span
style=3D'font:7.0pt "Times New Roman"'>&nbsp;&nbsp; =
</span></font></span></span></font><![endif]><span
lang=3DEN-US><o:p>&nbsp;</o:p></span></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Times New Roman"><span =
lang=3DEN-US
style=3D'font-size:10.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoPlainText><font size=3D1 color=3Dblack =
face=3D&#23435;&#20307;><span
lang=3DEN-US =
style=3D'font-size:9.0pt;color:black'>Juer<o:p></o:p></span></font></p>

</div>

</body>

</html>

------=_NextPart_000_030F_01C633A4.448A5F50--


--===============0133936565==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0133936565==--
