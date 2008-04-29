From: "Keith O'Brien" <keith.obrien@rga.com>
Subject: /dev/sdd fails fsck on bootup
Date: Tue, 29 Apr 2008 12:08:52 -0400
Message-ID: <1A2B8A445FA10A43BD44867E45A2DD9547ED16BAFC@AMIDALA.ny.rga.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1985267776=="
Return-path: <dm-devel-bounces@redhat.com>
Content-Class: urn:content-classes:message
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============1985267776==
Content-Class: urn:content-classes:message
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_1A2B8A445FA10A43BD44867E45A2DD9547ED16BAFCAMIDALAnyrgac_"

--_000_1A2B8A445FA10A43BD44867E45A2DD9547ED16BAFCAMIDALAnyrgac_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

After adding a second dm device to a server and rebooting, the server repor=
ts that /dev/sdd has failed fsck check. Once booted after continuing dmsetu=
p reports a linear device for /dev/sdd. It also reports it for multipath. O=
nce I remove the linear device I can mount the partition and everything app=
ears fine.  While researching this problem I found that I was creating the =
partition on dm device incorrectly, by fdisking /dev/dm-x. This is the only=
 one that has this issue. It is also the first multipath device connected t=
o our new IBM san.

I have tried removing multipath -f svnbackup and then running a manual fdis=
k on /dev/sdd. (inactive path)
fdisk /dev/sdd
Unable to read /dev/sdd

Checking /dev/sdb reports everything is fine. This make since to me because=
 this is the active path and sdd failed and is inactive.

When I run multipath after checking everything it recreates the linear path=
 svnbackup1 along with the multipath. I am not sure why this is happening.

Attached below are the output for dmsetup and mutlitpath -v3

Please let me know if you need any additional info.

Thanks,
Keith.


DMSETUP INFO:
------------------------
Name:              svnbackup1
State:             ACTIVE
Tables present:    LIVE
Open count:        0
Event number:      0
Major, minor:      254, 2
Number of targets: 1
UUID: part1-mpath-3600a0b80002938260000042547e783bb

Name:              svnbackup
State:             ACTIVE
Tables present:    LIVE
Open count:        1
Event number:      1
Major, minor:      254, 1
Number of targets: 1
UUID: mpath-3600a0b80002938260000042547e783bb

Name:              svn
State:             ACTIVE
Tables present:    LIVE
Open count:        1
Event number:      1
Major, minor:      254, 0
Number of targets: 1
UUID: mpath-3600a0b800017d0110000060946d56eb5

Multipath -v3 INFO
---------------------------------
cciss!c0d0: blacklisted
dm-0: blacklisted
hda: blacklisted
loop0: blacklisted
loop1: blacklisted
loop2: blacklisted
loop3: blacklisted
loop4: blacklisted
loop5: blacklisted
loop6: blacklisted
loop7: blacklisted
ram0: blacklisted
ram10: blacklisted
ram11: blacklisted
ram12: blacklisted
ram13: blacklisted
ram14: blacklisted
ram15: blacklisted
ram2: blacklisted
ram3: blacklisted
ram4: blacklisted
ram5: blacklisted
ram6: blacklisted
ram7: blacklisted
ram8: blacklisted
ram9: blacklisted
sda: not found in pathvec
sda: mask =3D 0x1f
sda: bus =3D 1
sda: dev_t =3D 8:0
sda: size =3D 734003200
sda: vendor =3D IBM
sda: product =3D 1722-600
sda: rev =3D 0520
sda: h:b:t:l =3D 0:0:0:0
sda: tgt_node_name =3D 0x200600a0b81607da
sda: serial =3D 1T50650559
sda: path checker =3D tur (controller setting)
sda: state =3D 2
sda: getprio =3D NULL (internal default)
sda: prio =3D 1
sda: getuid =3D /sbin/scsi_id -g -u -s /block/%n (controller setting)
sda: uid =3D 3600a0b800017d0110000060946d56eb5 (callout)
sdb: not found in pathvec
sdb: mask =3D 0x1f
sdb: bus =3D 1
sdb: dev_t =3D 8:16
sdb: size =3D 734003200
sdb: vendor =3D IBM
sdb: product =3D 1814      FAStT
sdb: rev =3D 0916
sdb: h:b:t:l =3D 0:0:1:0
sdb: tgt_node_name =3D 0x200400a0b8293b28
sdb: serial =3D SN70600341
sdb: path checker =3D tur (controller setting)
sdb: state =3D 2
sdb: getprio =3D NULL (internal default)
sdb: prio =3D 1
sdb: getuid =3D /sbin/scsi_id -g -u -s /block/%n (controller setting)
sdb: uid =3D 3600a0b80002938260000042547e783bb (callout)
sdc: not found in pathvec
sdc: mask =3D 0x1f
sdc: bus =3D 1
sdc: dev_t =3D 8:32
sdc: size =3D 734003200
sdc: vendor =3D IBM
sdc: product =3D 1722-600
sdc: rev =3D 0520
sdc: h:b:t:l =3D 1:0:0:0
sdc: tgt_node_name =3D 0x200600a0b81607da
sdc: serial =3D 1T50765237
sdc: path checker =3D tur (controller setting)
sdc: state =3D 2
sdc: getprio =3D NULL (internal default)
sdc: prio =3D 1
sdc: getuid =3D /sbin/scsi_id -g -u -s /block/%n (controller setting)
sdc: uid =3D 3600a0b800017d0110000060946d56eb5 (callout)
sdd: not found in pathvec
sdd: mask =3D 0x1f
sdd: bus =3D 1
sdd: dev_t =3D 8:48
sdd: size =3D 734003200
sdd: vendor =3D IBM
sdd: product =3D 1814      FAStT
sdd: rev =3D 0916
sdd: h:b:t:l =3D 1:0:1:0
sdd: tgt_node_name =3D 0x200400a0b8293b28
sdd: serial =3D SN70504350
sdd: path checker =3D tur (controller setting)
sdd: state =3D 2
sdd: getprio =3D NULL (internal default)
sdd: prio =3D 1
sdd: getuid =3D /sbin/scsi_id -g -u -s /block/%n (controller setting)
sdd: uid =3D 3600a0b80002938260000042547e783bb (callout)
=3D=3D=3D=3D=3D paths list =3D=3D=3D=3D=3D
uuid                              hcil    dev dev_t pri dm_st  chk_st  vend=
/pr
3600a0b800017d0110000060946d56eb5 0:0:0:0 sda 8:0   1   [undef][ready] IBM,=
172
3600a0b80002938260000042547e783bb 0:0:1:0 sdb 8:16  1   [undef][ready] IBM,=
181
3600a0b800017d0110000060946d56eb5 1:0:0:0 sdc 8:32  1   [undef][ready] IBM,=
172
3600a0b80002938260000042547e783bb 1:0:1:0 sdd 8:48  1   [undef][ready] IBM,=
181
params =3D 0 0 2 1 round-robin 0 1 1 8:0 1000 round-robin 0 1 1 8:32 1000
status =3D 1 0 0 2 1 A 0 1 0 8:0 A 0 E 0 1 0 8:32 A 0
*word =3D 0, len =3D 1
*word =3D 0, len =3D 1
*word =3D 2, len =3D 1
*word =3D 1, len =3D 1
*word =3D round-robin, len =3D 11
*word =3D 0, len =3D 1
*word =3D 1, len =3D 1
*word =3D 1, len =3D 1
*word =3D 8:0, len =3D 3
*word =3D 1000, len =3D 4
*word =3D 1, len =3D 1
*word =3D 1, len =3D 1
*word =3D 8:32, len =3D 4
*word =3D 1000, len =3D 4
*word =3D 1, len =3D 1
*word =3D 0, len =3D 1
*word =3D 2, len =3D 1
*word =3D A, len =3D 1
*word =3D 1, len =3D 1
*word =3D 0, len =3D 1
*word =3D A, len =3D 1
*word =3D 0, len =3D 1
*word =3D E, len =3D 1
*word =3D 1, len =3D 1
*word =3D 0, len =3D 1
*word =3D A, len =3D 1
*word =3D 0, len =3D 1
sda: ownership set to svn
sda: not found in pathvec
sda: mask =3D 0xc
sda: state =3D 2
sda: prio =3D 1
sdc: ownership set to svn
sdc: not found in pathvec
sdc: mask =3D 0xc
sdc: state =3D 2
sdc: prio =3D 1
svn: pgfailover =3D -1 (internal default)
svn: pgpolicy =3D failover (LUN setting)
svn: selector =3D round-robin 0 (internal default)
svn: features =3D 0 (controller setting)
svn: hwhandler =3D 0 (controller setting)
svn: rr_weight =3D 1 (internal default)
svn: minio =3D 1000 (config file default)
svn: no_path_retry =3D NONE (internal default)
svn: set ACT_NOTHING (map unchanged)
sdb: ownership set to svnbackup
sdb: not found in pathvec
sdb: mask =3D 0xc
sdb: state =3D 2
sdb: prio =3D 1
sdd: ownership set to svnbackup
sdd: not found in pathvec
sdd: mask =3D 0xc
sdd: state =3D 2
sdd: prio =3D 1
svnbackup: pgfailover =3D -1 (internal default)
svnbackup: pgpolicy =3D failover (LUN setting)
svnbackup: selector =3D round-robin 0 (internal default)
svnbackup: features =3D 0 (controller setting)
svnbackup: hwhandler =3D 0 (controller setting)
svnbackup: rr_weight =3D 1 (internal default)
svnbackup: minio =3D 1000 (config file default)
svnbackup: no_path_retry =3D NONE (internal default)
svnbackup: set ACT_CREATE (map does not exist)
create: svnbackup (3600a0b80002938260000042547e783bb)  IBM,1814      FAStT
[size=3D350G][features=3D0][hwhandler=3D0]
\_ round-robin 0 [prio=3D1][undef]
 \_ 0:0:1:0 sdb 8:16  [undef][ready]
\_ round-robin 0 [prio=3D1][undef]
 \_ 1:0:1:0 sdd 8:48  [undef][ready]




Keith O'Brien Sr. Unix Administrator
Phone 212-946-4225 Fax 212-946-4010
Keith@rga.com<mailto:212-946-4010Keith@rga.com>

R/GA 350 West 39th Street New York, NY 10018 www.rga.com<http://www.rga.com=
/>



















This message is the property of R/GA and contains information which may be =
privileged or confidential. It is meant only for the intended recipients an=
d/or their authorized agents. If you believe you have received this message=
 in error, please notify us immediately by return e-mail or by forwarding t=
his message to postmaster@rga.com<mailto:postmaster@rga.com>, and destroy a=
ny printed or electronic copies of the message. Any unauthorized use, disse=
mination, disclosure, or copying of this message or the information contain=
ed in it, is strictly prohibited and may be unlawful. Thank you.

--_000_1A2B8A445FA10A43BD44867E45A2DD9547ED16BAFCAMIDALAnyrgac_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<HTML xmlns=3D"http://www.w3.org/TR/REC-html40" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word">=
<head><META content=3D"text/html; charset=3Dus-ascii" http-equiv=3D"Content=
-Type">
<STYLE><!-- /* Style Definitions */ p.dabdc15d-4247-4378-918e-5937bf081b41,=
 li.dabdc15d-4247-4378-918e-5937bf081b41, div.dabdc15d-4247-4378-918e-5937b=
f081b41, table.dabdc15d-4247-4378-918e-5937bf081b41Table	{margin:0cm; margi=
n-bottom:.0001pt;}div.Section1 {page:Section1;}--></STYLE>

<meta content=3D"text/html; charset=3Dus-ascii" http-equiv=3DContent-Type>
<meta content=3D"Microsoft Word 11 (filtered medium)" name=3DGenerator>
<style>
<!--
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:12.0pt;
	font-family:"Times New Roman";}
a:link, span.MsoHyperlink
	{color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{color:purple;
	text-decoration:underline;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:Arial;
	color:windowtext;}
@page Section1
	{size:8.5in 11.0in;
	margin:1.0in 1.25in 1.0in 1.25in;}
div.Section1
	{page:Section1;}
-->
</style>

</head><BODY>
<P CLASS=3D"dabdc15d-4247-4378-918e-5937bf081b41">

<div class=3DSection1>

<p class=3DMsoNormal><font face=3DArial size=3D2><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>After adding a second dm device to a server and rebootin=
g,
the server reports that /dev/sdd has failed fsck check. Once booted after
continuing dmsetup reports a linear device for /dev/sdd. It also reports it=
 for
multipath. Once I remove the linear device I can mount the partition and
everything appears fine. &nbsp;While researching this problem I found that =
I
was creating the partition on dm device incorrectly, by fdisking /dev/dm-x.
This is the only one that has this issue. It is also the first multipath de=
vice
connected to our new IBM san. <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font face=3DArial size=3D2><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font face=3DArial size=3D2><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>I have tried removing multipath &#8211;f svnbackup and t=
hen
running a manual fdisk on /dev/sdd. (inactive path)<o:p></o:p></span></font=
></p>

<p class=3DMsoNormal><font face=3DArial size=3D2><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>fdisk /dev/sdd <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font face=3DArial size=3D2><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Unable to read /dev/sdd<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font face=3DArial size=3D2><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font face=3DArial size=3D2><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Checking /dev/sdb reports everything is fine. This make
since to me because this is the active path and sdd failed and is inactive.=
<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font face=3DArial size=3D2><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font face=3DArial size=3D2><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>When I run multipath after checking everything it recrea=
tes
the linear path svnbackup1 along with the multipath. I am not sure why this=
 is
happening. <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font face=3DArial size=3D2><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font face=3DArial size=3D2><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Attached below are the output for dmsetup and mutlitpath=
 &#8211;v3<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font face=3DArial size=3D2><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font face=3DArial size=3D2><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Please let me know if you need any additional info. <o:p=
></o:p></span></font></p>

<p class=3DMsoNormal><font face=3DArial size=3D2><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font face=3DArial size=3D2><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Thanks,<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font face=3DArial size=3D2><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Keith. <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font face=3DArial size=3D2><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font face=3DArial size=3D2><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font face=3DArial size=3D2><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>DMSETUP INFO: <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font face=3DArial size=3D2><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>------------------------<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font face=3DArial size=3D2><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Name:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;
svnbackup1<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font face=3DArial size=3D2><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>State:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;
ACTIVE<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font face=3DArial size=3D2><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Tables present:&nbsp;&nbsp;&nbsp; LIVE<o:p></o:p></span>=
</font></p>

<p class=3DMsoNormal><font face=3DArial size=3D2><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Open count:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<=
o:p></o:p></span></font></p>

<p class=3DMsoNormal><font face=3DArial size=3D2><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Event number:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0<o:p></o:p>=
</span></font></p>

<p class=3DMsoNormal><font face=3DArial size=3D2><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Major, minor:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 254, 2<o:p><=
/o:p></span></font></p>

<p class=3DMsoNormal><font face=3DArial size=3D2><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Number of targets: 1<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font face=3DArial size=3D2><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>UUID: part1-mpath-3600a0b80002938260000042547e783bb<o:p>=
</o:p></span></font></p>

<p class=3DMsoNormal><font face=3DArial size=3D2><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font face=3DArial size=3D2><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Name:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;
svnbackup<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font face=3DArial size=3D2><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>State:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;
ACTIVE<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font face=3DArial size=3D2><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Tables present:&nbsp;&nbsp;&nbsp; LIVE<o:p></o:p></span>=
</font></p>

<p class=3DMsoNormal><font face=3DArial size=3D2><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Open count:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1<=
o:p></o:p></span></font></p>

<p class=3DMsoNormal><font face=3DArial size=3D2><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Event number:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1<o:p></o:p>=
</span></font></p>

<p class=3DMsoNormal><font face=3DArial size=3D2><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Major, minor:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 254, 1<o:p><=
/o:p></span></font></p>

<p class=3DMsoNormal><font face=3DArial size=3D2><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Number of targets: 1<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font face=3DArial size=3D2><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>UUID: mpath-3600a0b80002938260000042547e783bb<o:p></o:p>=
</span></font></p>

<p class=3DMsoNormal><font face=3DArial size=3D2><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font face=3DArial size=3D2><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Name:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;
svn<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font face=3DArial size=3D2><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>State:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;
ACTIVE<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font face=3DArial size=3D2><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Tables present:&nbsp;&nbsp;&nbsp; LIVE<o:p></o:p></span>=
</font></p>

<p class=3DMsoNormal><font face=3DArial size=3D2><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Open count:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1<=
o:p></o:p></span></font></p>

<p class=3DMsoNormal><font face=3DArial size=3D2><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Event number:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1<o:p></o:p>=
</span></font></p>

<p class=3DMsoNormal><font face=3DArial size=3D2><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Major, minor:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 254, 0<o:p><=
/o:p></span></font></p>

<p class=3DMsoNormal><font face=3DArial size=3D2><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Number of targets: 1<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font face=3DArial size=3D2><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>UUID: mpath-3600a0b800017d0110000060946d56eb5<o:p></o:p>=
</span></font></p>

<p class=3DMsoNormal><font face=3DArial size=3D2><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font face=3DArial size=3D2><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Multipath &#8211;v3 INFO<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font face=3DArial size=3D2><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>---------------------------------<o:p></o:p></span></fon=
t></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>ccis=
s!c0d0: blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>dm-0=
: blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>hda:=
 blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>loop=
0: blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>loop=
1: blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>loop=
2: blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>loop=
3: blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>loop=
4: blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>loop=
5: blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>loop=
6: blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>loop=
7: blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>ram0=
: blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>ram1=
0: blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>ram1=
1: blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>ram1=
2: blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>ram1=
3: blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>ram1=
4: blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>ram1=
5: blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>ram2=
: blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>ram3=
: blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>ram4=
: blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>ram5=
: blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>ram6=
: blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>ram7=
: blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>ram8=
: blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>ram9=
: blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sda:=
 not found in pathvec<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sda:=
 mask =3D 0x1f<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sda:=
 bus =3D 1<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sda:=
 dev_t =3D 8:0<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sda:=
 size =3D 734003200<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sda:=
 vendor =3D IBM<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sda:=
 product =3D 1722-600<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sda:=
 rev =3D 0520<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sda:=
 h:b:t:l =3D 0:0:0:0<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sda:=
 tgt_node_name =3D
0x200600a0b81607da<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sda:=
 serial =3D
1T50650559&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sda:=
 path checker =3D tur
(controller setting)<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sda:=
 state =3D 2<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sda:=
 getprio =3D NULL
(internal default)<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sda:=
 prio =3D 1<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sda:=
 getuid =3D /sbin/scsi_id
-g -u -s /block/%n (controller setting)<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sda:=
 uid =3D
3600a0b800017d0110000060946d56eb5 (callout)<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdb:=
 not found in pathvec<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdb:=
 mask =3D 0x1f<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdb:=
 bus =3D 1<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdb:=
 dev_t =3D 8:16<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdb:=
 size =3D 734003200<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdb:=
 vendor =3D IBM<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdb:=
 product =3D
1814&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; FAStT<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdb:=
 rev =3D 0916<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdb:=
 h:b:t:l =3D 0:0:1:0<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdb:=
 tgt_node_name =3D
0x200400a0b8293b28<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdb:=
 serial =3D
SN70600341&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdb:=
 path checker =3D tur
(controller setting)<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdb:=
 state =3D 2<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdb:=
 getprio =3D NULL
(internal default)<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdb:=
 prio =3D 1<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdb:=
 getuid =3D /sbin/scsi_id
-g -u -s /block/%n (controller setting)<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdb:=
 uid =3D
3600a0b80002938260000042547e783bb (callout)<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdc:=
 not found in pathvec<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdc:=
 mask =3D 0x1f<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdc:=
 bus =3D 1<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdc:=
 dev_t =3D 8:32<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdc:=
 size =3D 734003200<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdc:=
 vendor =3D IBM<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdc:=
 product =3D 1722-600<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdc:=
 rev =3D 0520<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdc:=
 h:b:t:l =3D 1:0:0:0<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdc:=
 tgt_node_name =3D
0x200600a0b81607da<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdc:=
 serial =3D
1T50765237&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdc:=
 path checker =3D tur
(controller setting)<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdc:=
 state =3D 2<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdc:=
 getprio =3D NULL
(internal default)<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdc:=
 prio =3D 1<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdc:=
 getuid =3D /sbin/scsi_id
-g -u -s /block/%n (controller setting)<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdc:=
 uid =3D
3600a0b800017d0110000060946d56eb5 (callout)<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdd:=
 not found in pathvec<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdd:=
 mask =3D 0x1f<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdd:=
 bus =3D 1<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdd:=
 dev_t =3D 8:48<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdd:=
 size =3D 734003200<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdd:=
 vendor =3D IBM<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdd:=
 product =3D
1814&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; FAStT<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdd:=
 rev =3D 0916<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdd:=
 h:b:t:l =3D 1:0:1:0<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdd:=
 tgt_node_name =3D
0x200400a0b8293b28<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdd:=
 serial =3D
SN70504350&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdd:=
 path checker =3D tur
(controller setting)<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdd:=
 state =3D 2<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdd:=
 getprio =3D NULL
(internal default)<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdd:=
 prio =3D 1<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdd:=
 getuid =3D /sbin/scsi_id
-g -u -s /block/%n (controller setting)<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdd:=
 uid =3D
3600a0b80002938260000042547e783bb (callout)<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>=3D=
=3D=3D=3D=3D paths list =3D=3D=3D=3D=3D<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>uuid=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;
hcil&nbsp;&nbsp;&nbsp; dev dev_t pri dm_st&nbsp; chk_st&nbsp; vend/pr<o:p><=
/o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>3600=
a0b800017d0110000060946d56eb5
0:0:0:0 sda 8:0&nbsp;&nbsp; 1&nbsp;&nbsp; [undef][ready] IBM,172<o:p></o:p>=
</span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>3600=
a0b80002938260000042547e783bb
0:0:1:0 sdb 8:16&nbsp; 1&nbsp;&nbsp; [undef][ready] IBM,181<o:p></o:p></spa=
n></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>3600=
a0b800017d0110000060946d56eb5
1:0:0:0 sdc 8:32&nbsp; 1&nbsp;&nbsp; [undef][ready] IBM,172<o:p></o:p></spa=
n></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>3600=
a0b80002938260000042547e783bb
1:0:1:0 sdd 8:48&nbsp; 1&nbsp;&nbsp; [undef][ready] IBM,181<o:p></o:p></spa=
n></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>para=
ms =3D 0 0 2 1 round-robin
0 1 1 8:0 1000 round-robin 0 1 1 8:32 1000 <o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>stat=
us =3D 1 0 0 2 1 A 0 1 0
8:0 A 0 E 0 1 0 8:32 A 0 <o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>*wor=
d =3D 0, len =3D 1<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>*wor=
d =3D 0, len =3D 1<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>*wor=
d =3D 2, len =3D 1<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>*wor=
d =3D 1, len =3D 1<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>*wor=
d =3D round-robin, len =3D
11<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>*wor=
d =3D 0, len =3D 1<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>*wor=
d =3D 1, len =3D 1<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>*wor=
d =3D 1, len =3D 1<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>*wor=
d =3D 8:0, len =3D 3<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>*wor=
d =3D 1000, len =3D 4<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>*wor=
d =3D 1, len =3D 1<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>*wor=
d =3D 1, len =3D 1<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>*wor=
d =3D 8:32, len =3D 4<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>*wor=
d =3D 1000, len =3D 4<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>*wor=
d =3D 1, len =3D 1<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>*wor=
d =3D 0, len =3D 1<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>*wor=
d =3D 2, len =3D 1<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>*wor=
d =3D A, len =3D 1<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>*wor=
d =3D 1, len =3D 1<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>*wor=
d =3D 0, len =3D 1<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>*wor=
d =3D A, len =3D 1<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>*wor=
d =3D 0, len =3D 1<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>*wor=
d =3D E, len =3D 1<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>*wor=
d =3D 1, len =3D 1<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>*wor=
d =3D 0, len =3D 1<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>*wor=
d =3D A, len =3D 1<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>*wor=
d =3D 0, len =3D 1<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sda:=
 ownership set to svn<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sda:=
 not found in pathvec<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sda:=
 mask =3D 0xc<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sda:=
 state =3D 2<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sda:=
 prio =3D 1<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdc:=
 ownership set to svn<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdc:=
 not found in pathvec<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdc:=
 mask =3D 0xc<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdc:=
 state =3D 2<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdc:=
 prio =3D 1<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>svn:=
 pgfailover =3D -1 (internal
default)<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>svn:=
 pgpolicy =3D failover
(LUN setting)<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>svn:=
 selector =3D round-robin
0 (internal default)<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>svn:=
 features =3D 0
(controller setting)<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>svn:=
 hwhandler =3D 0
(controller setting)<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>svn:=
 rr_weight =3D 1 (internal
default)<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>svn:=
 minio =3D 1000 (config
file default)<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>svn:=
 no_path_retry =3D NONE
(internal default)<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>svn:=
 set ACT_NOTHING (map
unchanged)<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdb:=
 ownership set to
svnbackup<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdb:=
 not found in pathvec<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdb:=
 mask =3D 0xc<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdb:=
 state =3D 2<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdb:=
 prio =3D 1<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdd:=
 ownership set to
svnbackup<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdd:=
 not found in pathvec<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdd:=
 mask =3D 0xc<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdd:=
 state =3D 2<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>sdd:=
 prio =3D 1<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>svnb=
ackup: pgfailover =3D -1
(internal default)<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>svnb=
ackup: pgpolicy =3D
failover (LUN setting)<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>svnb=
ackup: selector =3D
round-robin 0 (internal default)<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>svnb=
ackup: features =3D 0
(controller setting)<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>svnb=
ackup: hwhandler =3D 0
(controller setting)<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>svnb=
ackup: rr_weight =3D 1
(internal default)<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>svnb=
ackup: minio =3D 1000
(config file default)<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>svnb=
ackup: no_path_retry =3D
NONE (internal default)<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>svnb=
ackup: set ACT_CREATE
(map does not exist)<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>crea=
te: svnbackup
(3600a0b80002938260000042547e783bb)&nbsp;
IBM,1814&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; FAStT<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>[siz=
e=3D350G][features=3D0][hwhandler=3D0]<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>\_ r=
ound-robin 0
[prio=3D1][undef]<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>&nbs=
p;\_ 0:0:1:0 sdb
8:16&nbsp; [undef][ready]<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>\_ r=
ound-robin 0
[prio=3D1][undef]<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'>&nbs=
p;\_ 1:0:1:0 sdd
8:48&nbsp; [undef][ready]<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font face=3D"Courier Ne=
w" size=3D2><span style=3D'font-size:10.0pt;font-family:"Courier New"'><o:p=
>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font face=3DArial size=3D2><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font face=3DArial size=3D2><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font face=3DArial size=3D2><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font color=3D"#f30017" face=3DArial size=3D2><span st=
yle=3D'font-size:10.0pt;font-family:Arial;color:#F30017'>Keith&nbsp;O'Brien=
</span></font><font face=3DArial size=3D2><span style=3D'font-size:10.0pt;f=
ont-family:Arial'> Sr. Unix
Administrator</span></font><o:p></o:p></p>

<p class=3DMsoNormal><font color=3D"#9e9588" face=3DArial size=3D2><span st=
yle=3D'font-size:10.0pt;font-family:Arial;color:#9E9588'>Phone 212-946-4225=
 Fax
212-946-4010</span></font><o:p></o:p></p>

<p class=3DMsoNormal><font color=3Dgray face=3DArial size=3D2><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:gray'><a href=3D"mailto:212-946-4010Keith@rg=
a.com">Keith@rga.com</a></span></font><font face=3DArial><span style=3D'fon=
t-family:Arial'><o:p></o:p></span></font></p>

<p class=3DMsoNormal><font face=3DArial size=3D2><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>&nbsp;<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font color=3Dblack face=3DArial size=3D2><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:black'>R/GA</span></font><font face=3DArial =
size=3D2><span style=3D'font-size:10.0pt;font-family:Arial'> <font color=3D=
"#9e9588"><span style=3D'color:#9E9588'>350 West 39th Street New York, NY
10018 <a href=3D"http://www.rga.com/">www.rga.com</a></span></font></span><=
/font><font face=3DArial><span style=3D'font-family:Arial'><o:p></o:p></spa=
n></font></p>

<p class=3DMsoNormal><font face=3D"Times New Roman" size=3D3><span style=3D=
'font-size:
12.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font face=3D"Times New Roman" size=3D3><span style=3D=
'font-size:
12.0pt'><o:p>&nbsp;</o:p></span></font></p>

</div>

</P>
<P CLASS=3D"dabdc15d-4247-4378-918e-5937bf081b41"><FONT SIZE=3D"1"></FONT>&=
nbsp;</P>
<P CLASS=3D"dabdc15d-4247-4378-918e-5937bf081b41"><FONT SIZE=3D"1"></FONT>&=
nbsp;</P>
<P CLASS=3D"dabdc15d-4247-4378-918e-5937bf081b41"><FONT SIZE=3D"1"></FONT>&=
nbsp;</P>
<P CLASS=3D"dabdc15d-4247-4378-918e-5937bf081b41"><FONT SIZE=3D"1"></FONT>&=
nbsp;</P>
<P CLASS=3D"dabdc15d-4247-4378-918e-5937bf081b41"><FONT SIZE=3D"1"></FONT>&=
nbsp;</P>
<P CLASS=3D"dabdc15d-4247-4378-918e-5937bf081b41"><FONT SIZE=3D"1"></FONT>&=
nbsp;</P>
<P CLASS=3D"dabdc15d-4247-4378-918e-5937bf081b41"><FONT SIZE=3D"1"></FONT>&=
nbsp;</P>
<P CLASS=3D"dabdc15d-4247-4378-918e-5937bf081b41"><FONT SIZE=3D"1"></FONT>&=
nbsp;</P>
<P CLASS=3D"dabdc15d-4247-4378-918e-5937bf081b41">This message is the prope=
rty of R/GA and contains information which may be privileged or confidentia=
l. It is meant only for the intended recipients and/or their authorized age=
nts. If you believe you have received this message in error, please notify =
us immediately by return e-mail or by forwarding this message to <A HREF=3D=
"mailto:postmaster@rga.com">postmaster@rga.com</A>, and destroy any printed=
 or electronic copies of the message. Any unauthorized use, dissemination, =
disclosure, or copying of this message or the information contained in it, =
is strictly prohibited and may be unlawful. Thank you.</P></BODY></HTML>

--_000_1A2B8A445FA10A43BD44867E45A2DD9547ED16BAFCAMIDALAnyrgac_--


--===============1985267776==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1985267776==--
