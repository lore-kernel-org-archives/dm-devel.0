From: Prakash Rudraraju <prakash@jigsaw.com>
Subject: RE: multipathd segfault and SCSI errors
Date: Thu, 23 Oct 2008 23:37:46 -0700
Message-ID: <0FCB6A1400B4B9469B7661BFE02AFC2E0B289DA4FF@mailx.jigsaw.com>
References: <0FCB6A1400B4B9469B7661BFE02AFC2E0B289DA4F1@mailx.jigsaw.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0647603337=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <0FCB6A1400B4B9469B7661BFE02AFC2E0B289DA4F1@mailx.jigsaw.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============0647603337==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_0FCB6A1400B4B9469B7661BFE02AFC2E0B289DA4FFmailxjigsawco_"

--_000_0FCB6A1400B4B9469B7661BFE02AFC2E0B289DA4FFmailxjigsawco_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

More info about setup from multipath verbose output.

# multipath -v3
dm-0: blacklisted
dm-1: blacklisted
dm-2: blacklisted
dm-3: blacklisted
dm-4: blacklisted
dm-5: blacklisted
dm-6: blacklisted
md0: blacklisted
ram0: blacklisted
ram10: blacklisted
ram11: blacklisted
ram12: blacklisted
ram13: blacklisted
ram14: blacklisted
ram15: blacklisted
ram1: blacklisted
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
sda: size =3D 142082048
sda: vendor =3D DELL
sda: product =3D PERC 6/i Adapter
sda: rev =3D 1.11
sda: h:b:t:l =3D 0:2:0:0
sda: serial =3D 0036a2870ae53c2410003469e390ec01
sda: path checker =3D readsector0 (config file default)
sda: state =3D 2
sda: getprio =3D NULL (internal default)
sda: prio =3D 1
sda: getuid =3D /sbin/scsi_id -g -u -s /block/%n (config file default)
sda: uid =3D 36001ec90e369340010243ce50a87a236 (callout)
sdb: not found in pathvec
sdb: mask =3D 0x1f
sdb: bus =3D 1
sdb: dev_t =3D 8:16
sdb: size =3D 104857600
sdb: vendor =3D COMPELNT
sdb: product =3D Compellent Vol
sdb: rev =3D 0401
sdb: h:b:t:l =3D 1:0:3:0
sdb: tgt_node_name =3D 0x5000d310000e6302
sdb: serial =3D 00000e63-00000007
sdb: path checker =3D tur (controller setting)
sdb: state =3D 2
sdb: getprio =3D NULL (internal default)
sdb: prio =3D 1
sdb: getuid =3D /sbin/scsi_id -g -u -s /block/%n (config file default)
sdb: uid =3D 36000d310000e63000000000000000007 (callout)
sdc: not found in pathvec
sdc: mask =3D 0x1f
sdc: bus =3D 1
sdc: dev_t =3D 8:32
sdc: size =3D 1048576000
sdc: vendor =3D COMPELNT
sdc: product =3D Compellent Vol
sdc: rev =3D 0401
sdc: h:b:t:l =3D 1:0:3:1
sdc: tgt_node_name =3D 0x5000d310000e6302
sdc: serial =3D 00000e63-0000000c
sdc: path checker =3D tur (controller setting)
sdc: state =3D 2
sdc: getprio =3D NULL (internal default)
sdc: prio =3D 1
sdc: getuid =3D /sbin/scsi_id -g -u -s /block/%n (config file default)
sdc: uid =3D 36000d310000e6300000000000000000c (callout)
sdd: not found in pathvec
sdd: mask =3D 0x1f
sdd: bus =3D 1
sdd: dev_t =3D 8:48
sdd: size =3D 104857600
sdd: vendor =3D COMPELNT
sdd: product =3D Compellent Vol
sdd: rev =3D 0401
sdd: h:b:t:l =3D 2:0:1:0
sdd: tgt_node_name =3D 0x5000d310000e6302
sdd: serial =3D 00000e63-00000007
sdd: path checker =3D tur (controller setting)
sdd: state =3D 2
sdd: getprio =3D NULL (internal default)
sdd: prio =3D 1
sdd: getuid =3D /sbin/scsi_id -g -u -s /block/%n (config file default)
sdd: uid =3D 36000d310000e63000000000000000007 (callout)
sde: not found in pathvec
sde: mask =3D 0x1f
sde: bus =3D 1
sde: dev_t =3D 8:64
sde: size =3D 1048576000
sde: vendor =3D COMPELNT
sde: product =3D Compellent Vol
sde: rev =3D 0401
sde: h:b:t:l =3D 2:0:1:1
sde: tgt_node_name =3D 0x5000d310000e6302
sde: serial =3D 00000e63-0000000c
sde: path checker =3D tur (controller setting)
sde: state =3D 2
sde: getprio =3D NULL (internal default)
sde: prio =3D 1
sde: getuid =3D /sbin/scsi_id -g -u -s /block/%n (config file default)
sde: uid =3D 36000d310000e6300000000000000000c (callout)
=3D=3D=3D=3D=3D paths list =3D=3D=3D=3D=3D
uuid                              hcil    dev dev_t pri dm_st  chk_st  vend=
/pr
36001ec90e369340010243ce50a87a236 0:2:0:0 sda 8:0   1   [undef][ready] DELL=
,PE
36000d310000e63000000000000000007 1:0:3:0 sdb 8:16  1   [undef][ready] COMP=
ELN
36000d310000e6300000000000000000c 1:0:3:1 sdc 8:32  1   [undef][ready] COMP=
ELN
36000d310000e63000000000000000007 2:0:1:0 sdd 8:48  1   [undef][ready] COMP=
ELN
36000d310000e6300000000000000000c 2:0:1:1 sde 8:64  1   [undef][ready] COMP=
ELN
params =3D 1 queue_if_no_path 0 1 1 round-robin 0 2 1 8:32 1000 8:64 1000
status =3D 1 0 0 1 1 A 0 2 0 8:32 A 47 8:64 A 49
params =3D 1 queue_if_no_path 0 1 1 round-robin 0 2 1 8:16 1000 8:48 1000
status =3D 1 0 0 1 1 A 0 2 0 8:16 A 0 8:48 A 0
36001ec90e369340010243ce50a87a236: blacklisted
36000d310000e63000000000000000007: exception-listed
Found matching wwid [36000d310000e63000000000000000007] in bindings file.
Setting alias to mpath0
sdb: ownership set to mpath0
sdb: not found in pathvec
sdb: mask =3D 0xc
sdb: state =3D 2
sdb: prio =3D 1
sdd: ownership set to mpath0
sdd: not found in pathvec
sdd: mask =3D 0xc
sdd: state =3D 2
sdd: prio =3D 1
mpath0: pgfailover =3D -1 (internal default)
mpath0: pgpolicy =3D multibus (config file default)
mpath0: selector =3D round-robin 0 (internal default)
mpath0: features =3D 0 (internal default)
mpath0: hwhandler =3D 0 (internal default)
mpath0: rr_weight =3D 1 (internal default)
mpath0: minio =3D 1000 (config file default)
mpath0: no_path_retry =3D -2 (controller setting)
pg_timeout =3D NONE (internal default)
mpath0: set ACT_NOTHING (map unchanged)
36000d310000e6300000000000000000c: exception-listed
Found matching wwid [36000d310000e6300000000000000000c] in bindings file.
Setting alias to mpath1
sdc: ownership set to mpath1
sdc: not found in pathvec
sdc: mask =3D 0xc
sdc: state =3D 2
sdc: prio =3D 1
sde: ownership set to mpath1
sde: not found in pathvec
sde: mask =3D 0xc
sde: state =3D 2
sde: prio =3D 1
mpath1: pgfailover =3D -1 (internal default)
mpath1: pgpolicy =3D multibus (config file default)
mpath1: selector =3D round-robin 0 (internal default)
mpath1: features =3D 0 (internal default)
mpath1: hwhandler =3D 0 (internal default)
mpath1: rr_weight =3D 1 (internal default)
mpath1: minio =3D 1000 (config file default)
mpath1: no_path_retry =3D -2 (controller setting)
pg_timeout =3D NONE (internal default)
mpath1: set ACT_NOTHING (map unchanged)
36000d310000e63000000000000000007: exception-listed
36000d310000e6300000000000000000c: exception-listed

Thanks,
Prakash.

--_000_0FCB6A1400B4B9469B7661BFE02AFC2E0B289DA4FFmailxjigsawco_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:o=3D"urn:schemas-microsoft-com:office:office" xmlns:w=3D"urn:sc=
hemas-microsoft-com:office:word" xmlns=3D"http://www.w3.org/TR/REC-html40">

<head>
<meta http-equiv=3DContent-Type content=3D"text/html; charset=3Dus-ascii">
<meta name=3DGenerator content=3D"Microsoft Word 11 (filtered medium)">
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
	{mso-style-type:personal;
	font-family:Arial;
	color:windowtext;}
span.EmailStyle18
	{mso-style-type:personal-reply;
	font-family:Arial;
	color:navy;}
@page Section1
	{size:8.5in 11.0in;
	margin:1.0in 1.25in 1.0in 1.25in;}
div.Section1
	{page:Section1;}
-->
</style>

</head>

<body lang=3DEN-US link=3Dblue vlink=3Dpurple>

<div class=3DSection1>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>More info about setup from multipath
verbose output.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'># multipath -v3<o:p></o:p></span></fon=
t></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>dm-0: blacklisted<o:p></o:p></span></f=
ont></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>dm-1: blacklisted<o:p></o:p></span></f=
ont></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>dm-2: blacklisted<o:p></o:p></span></f=
ont></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>dm-3: blacklisted<o:p></o:p></span></f=
ont></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>dm-4: blacklisted<o:p></o:p></span></f=
ont></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>dm-5: blacklisted<o:p></o:p></span></f=
ont></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>dm-6: blacklisted<o:p></o:p></span></f=
ont></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>md0: blacklisted<o:p></o:p></span></fo=
nt></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>ram0: blacklisted<o:p></o:p></span></f=
ont></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>ram10: blacklisted<o:p></o:p></span></=
font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>ram11: blacklisted<o:p></o:p></span></=
font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>ram12: blacklisted<o:p></o:p></span></=
font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>ram13: blacklisted<o:p></o:p></span></=
font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>ram14: blacklisted<o:p></o:p></span></=
font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>ram15: blacklisted<o:p></o:p></span></=
font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>ram1: blacklisted<o:p></o:p></span></f=
ont></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>ram2: blacklisted<o:p></o:p></span></f=
ont></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>ram3: blacklisted<o:p></o:p></span></f=
ont></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>ram4: blacklisted<o:p></o:p></span></f=
ont></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>ram5: blacklisted<o:p></o:p></span></f=
ont></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>ram6: blacklisted<o:p></o:p></span></f=
ont></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>ram7: blacklisted<o:p></o:p></span></f=
ont></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>ram8: blacklisted<o:p></o:p></span></f=
ont></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>ram9: blacklisted<o:p></o:p></span></f=
ont></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sda: not found in pathvec<o:p></o:p></=
span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sda: mask =3D 0x1f<o:p></o:p></span></=
font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sda: bus =3D 1<o:p></o:p></span></font=
></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sda: dev_t =3D 8:0<o:p></o:p></span></=
font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sda: size =3D 142082048<o:p></o:p></sp=
an></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sda: vendor =3D DELL<o:p></o:p></span>=
</font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sda: product =3D PERC 6/i Adapter<o:p>=
</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sda: rev =3D 1.11<o:p></o:p></span></f=
ont></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sda: h:b:t:l =3D 0:2:0:0<o:p></o:p></s=
pan></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sda: serial =3D
0036a2870ae53c2410003469e390ec01<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sda: path checker =3D readsector0 (con=
fig
file default)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sda: state =3D 2<o:p></o:p></span></fo=
nt></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sda: getprio =3D NULL (internal defaul=
t)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sda: prio =3D 1<o:p></o:p></span></fon=
t></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sda: getuid =3D /sbin/scsi_id -g -u -s
/block/%n (config file default)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sda: uid =3D
36001ec90e369340010243ce50a87a236 (callout)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdb: not found in pathvec<o:p></o:p></=
span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdb: mask =3D 0x1f<o:p></o:p></span></=
font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdb: bus =3D 1<o:p></o:p></span></font=
></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdb: dev_t =3D 8:16<o:p></o:p></span><=
/font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdb: size =3D 104857600<o:p></o:p></sp=
an></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdb: vendor =3D COMPELNT<o:p></o:p></s=
pan></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdb: product =3D Compellent Vol<o:p></=
o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdb: rev =3D 0401<o:p></o:p></span></f=
ont></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdb: h:b:t:l =3D 1:0:3:0<o:p></o:p></s=
pan></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdb: tgt_node_name =3D 0x5000d310000e6=
302<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdb: serial =3D 00000e63-00000007<o:p>=
</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdb: path checker =3D tur (controller
setting)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdb: state =3D 2<o:p></o:p></span></fo=
nt></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdb: getprio =3D NULL (internal defaul=
t)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdb: prio =3D 1<o:p></o:p></span></fon=
t></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdb: getuid =3D /sbin/scsi_id -g -u -s
/block/%n (config file default)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdb: uid =3D
36000d310000e63000000000000000007 (callout)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdc: not found in pathvec<o:p></o:p></=
span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdc: mask =3D 0x1f<o:p></o:p></span></=
font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdc: bus =3D 1<o:p></o:p></span></font=
></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdc: dev_t =3D 8:32<o:p></o:p></span><=
/font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdc: size =3D 1048576000<o:p></o:p></s=
pan></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdc: vendor =3D COMPELNT<o:p></o:p></s=
pan></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdc: product =3D Compellent Vol<o:p></=
o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdc: rev =3D 0401<o:p></o:p></span></f=
ont></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdc: h:b:t:l =3D 1:0:3:1<o:p></o:p></s=
pan></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdc: tgt_node_name =3D 0x5000d310000e6=
302<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdc: serial =3D 00000e63-0000000c<o:p>=
</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdc: path checker =3D tur (controller =
setting)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdc: state =3D 2<o:p></o:p></span></fo=
nt></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdc: getprio =3D NULL (internal defaul=
t)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdc: prio =3D 1<o:p></o:p></span></fon=
t></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdc: getuid =3D /sbin/scsi_id -g -u -s
/block/%n (config file default)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdc: uid =3D
36000d310000e6300000000000000000c (callout)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdd: not found in pathvec<o:p></o:p></=
span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdd: mask =3D 0x1f<o:p></o:p></span></=
font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdd: bus =3D 1<o:p></o:p></span></font=
></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdd: dev_t =3D 8:48<o:p></o:p></span><=
/font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdd: size =3D 104857600<o:p></o:p></sp=
an></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdd: vendor =3D COMPELNT<o:p></o:p></s=
pan></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdd: product =3D Compellent Vol<o:p></=
o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdd: rev =3D 0401<o:p></o:p></span></f=
ont></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdd: h:b:t:l =3D 2:0:1:0<o:p></o:p></s=
pan></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdd: tgt_node_name =3D 0x5000d310000e6=
302<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdd: serial =3D 00000e63-00000007<o:p>=
</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdd: path checker =3D tur (controller
setting)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdd: state =3D 2<o:p></o:p></span></fo=
nt></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdd: getprio =3D NULL (internal defaul=
t)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdd: prio =3D 1<o:p></o:p></span></fon=
t></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdd: getuid =3D /sbin/scsi_id -g -u -s
/block/%n (config file default)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdd: uid =3D
36000d310000e63000000000000000007 (callout)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sde: not found in pathvec<o:p></o:p></=
span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sde: mask =3D 0x1f<o:p></o:p></span></=
font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sde: bus =3D 1<o:p></o:p></span></font=
></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sde: dev_t =3D 8:64<o:p></o:p></span><=
/font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sde: size =3D 1048576000<o:p></o:p></s=
pan></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sde: vendor =3D COMPELNT<o:p></o:p></s=
pan></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sde: product =3D Compellent Vol<o:p></=
o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sde: rev =3D 0401<o:p></o:p></span></f=
ont></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sde: h:b:t:l =3D 2:0:1:1<o:p></o:p></s=
pan></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sde: tgt_node_name =3D 0x5000d310000e6=
302<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sde: serial =3D 00000e63-0000000c<o:p>=
</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sde: path checker =3D tur (controller
setting)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sde: state =3D 2<o:p></o:p></span></fo=
nt></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sde: getprio =3D NULL (internal defaul=
t)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sde: prio =3D 1<o:p></o:p></span></fon=
t></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sde: getuid =3D /sbin/scsi_id -g -u -s
/block/%n (config file default)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sde: uid =3D
36000d310000e6300000000000000000c (callout)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>=3D=3D=3D=3D=3D paths list =3D=3D=3D=
=3D=3D<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>uuid&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
hcil&nbsp;&nbsp;&nbsp; dev dev_t pri dm_st&nbsp; chk_st&nbsp; vend/pr<o:p><=
/o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>36001ec90e369340010243ce50a87a236 0:2:=
0:0
sda 8:0&nbsp;&nbsp; 1&nbsp;&nbsp; [undef][ready] DELL,PE<o:p></o:p></span><=
/font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>36000d310000e63000000000000000007 1:0:=
3:0
sdb 8:16&nbsp; 1&nbsp;&nbsp; [undef][ready] COMPELN<o:p></o:p></span></font=
></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>36000d310000e6300000000000000000c 1:0:=
3:1
sdc 8:32&nbsp; 1&nbsp;&nbsp; [undef][ready] COMPELN<o:p></o:p></span></font=
></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>36000d310000e63000000000000000007 2:0:=
1:0
sdd 8:48&nbsp; 1&nbsp;&nbsp; [undef][ready] COMPELN<o:p></o:p></span></font=
></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>36000d310000e6300000000000000000c 2:0:=
1:1
sde 8:64&nbsp; 1&nbsp;&nbsp; [undef][ready] COMPELN<o:p></o:p></span></font=
></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>params =3D 1 queue_if_no_path 0 1 1 ro=
und-robin
0 2 1 8:32 1000 8:64 1000<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>status =3D 1 0 0 1 1 A 0 2 0 8:32 A 47=
 8:64
A 49<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>params =3D 1 queue_if_no_path 0 1 1
round-robin 0 2 1 8:16 1000 8:48 1000<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>status =3D 1 0 0 1 1 A 0 2 0 8:16 A 0 =
8:48 A
0<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>36001ec90e369340010243ce50a87a236:
blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>36000d310000e63000000000000000007:
exception-listed<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>Found matching wwid
[36000d310000e63000000000000000007] in bindings file.<o:p></o:p></span></fo=
nt></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>Setting alias to mpath0<o:p></o:p></sp=
an></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdb: ownership set to mpath0<o:p></o:p=
></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdb: not found in pathvec<o:p></o:p></=
span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdb: mask =3D 0xc<o:p></o:p></span></f=
ont></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdb: state =3D 2<o:p></o:p></span></fo=
nt></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdb: prio =3D 1<o:p></o:p></span></fon=
t></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdd: ownership set to mpath0<o:p></o:p=
></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdd: not found in pathvec<o:p></o:p></=
span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdd: mask =3D 0xc<o:p></o:p></span></f=
ont></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdd: state =3D 2<o:p></o:p></span></fo=
nt></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdd: prio =3D 1<o:p></o:p></span></fon=
t></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>mpath0: pgfailover =3D -1 (internal de=
fault)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>mpath0: pgpolicy =3D multibus (config =
file
default)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>mpath0: selector =3D round-robin 0 (in=
ternal
default)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>mpath0: features =3D 0 (internal defau=
lt)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>mpath0: hwhandler =3D 0 (internal defa=
ult)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>mpath0: rr_weight =3D 1 (internal defa=
ult)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>mpath0: minio =3D 1000 (config file de=
fault)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>mpath0: no_path_retry =3D -2 (controll=
er
setting)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>pg_timeout =3D NONE (internal default)=
<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>mpath0: set ACT_NOTHING (map unchanged=
)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>36000d310000e6300000000000000000c:
exception-listed<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>Found matching wwid
[36000d310000e6300000000000000000c] in bindings file.<o:p></o:p></span></fo=
nt></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>Setting alias to mpath1<o:p></o:p></sp=
an></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdc: ownership set to mpath1<o:p></o:p=
></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdc: not found in pathvec<o:p></o:p></=
span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdc: mask =3D 0xc<o:p></o:p></span></f=
ont></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdc: state =3D 2<o:p></o:p></span></fo=
nt></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sdc: prio =3D 1<o:p></o:p></span></fon=
t></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sde: ownership set to mpath1<o:p></o:p=
></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sde: not found in pathvec<o:p></o:p></=
span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sde: mask =3D 0xc<o:p></o:p></span></f=
ont></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sde: state =3D 2<o:p></o:p></span></fo=
nt></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>sde: prio =3D 1<o:p></o:p></span></fon=
t></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>mpath1: pgfailover =3D -1 (internal de=
fault)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>mpath1: pgpolicy =3D multibus (config =
file
default)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>mpath1: selector =3D round-robin 0 (in=
ternal
default)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>mpath1: features =3D 0 (internal defau=
lt)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>mpath1: hwhandler =3D 0 (internal defa=
ult)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>mpath1: rr_weight =3D 1 (internal defa=
ult)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>mpath1: minio =3D 1000 (config file de=
fault)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>mpath1: no_path_retry =3D -2 (controll=
er
setting)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>pg_timeout =3D NONE (internal default)=
<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>mpath1: set ACT_NOTHING (map unchanged=
)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>36000d310000e63000000000000000007:
exception-listed<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>36000d310000e6300000000000000000c: exc=
eption-listed<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>Thanks,<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>Prakash.<o:p></o:p></span></font></p>

</div>

</body>

</html>

--_000_0FCB6A1400B4B9469B7661BFE02AFC2E0B289DA4FFmailxjigsawco_--


--===============0647603337==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0647603337==--
