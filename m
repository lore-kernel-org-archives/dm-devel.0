From: Prakash Rudraraju <prakash@jigsaw.com>
Subject: multipathd segfault and SCSI errors
Date: Thu, 23 Oct 2008 23:11:38 -0700
Message-ID: <0FCB6A1400B4B9469B7661BFE02AFC2E0B289DA4F1@mailx.jigsaw.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0477347362=="
Return-path: <dm-devel-bounces@redhat.com>
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

--===============0477347362==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_0FCB6A1400B4B9469B7661BFE02AFC2E0B289DA4F1mailxjigsawco_"

--_000_0FCB6A1400B4B9469B7661BFE02AFC2E0B289DA4F1mailxjigsawco_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,

We have setup a Compellent SAN with 2 HBA attached to dual fabrics. Under l=
oad when we import a 60GB database, paths fail very often. Following is the=
 failed path behavior from syslog.

Oct 23 02:01:15 db03 kernel: sd 2:0:1:1: SCSI error: return code =3D 0x0800=
0002
Oct 23 02:01:15 db03 kernel: sde: Current: sense key: Aborted Command
Oct 23 02:01:15 db03 kernel:     Add. Sense: Internal target failure
Oct 23 02:01:15 db03 kernel:
Oct 23 02:01:15 db03 kernel: end_request: I/O error, dev sde, sector 911585=
239
Oct 23 02:01:15 db03 kernel: device-mapper: multipath: Failing path 8:64.
Oct 23 02:01:15 db03 multipathd: 8:64: mark as failed
Oct 23 02:01:15 db03 multipathd: mpath1: remaining active paths: 1
Oct 23 02:01:15 db03 kernel: sd 1:0:3:1: SCSI error: return code =3D 0x0800=
0002
Oct 23 02:01:15 db03 kernel: sdc: Current: sense key: Aborted Command
Oct 23 02:01:15 db03 kernel:     Add. Sense: Internal target failure
Oct 23 02:01:15 db03 kernel:
Oct 23 02:01:15 db03 kernel: end_request: I/O error, dev sdc, sector 911585=
239
Oct 23 02:01:15 db03 kernel: device-mapper: multipath: Failing path 8:32.
Oct 23 02:01:16 db03 multipathd: 8:32: mark as failed
Oct 23 02:01:16 db03 multipathd: mpath1: remaining active paths: 0
Oct 23 02:01:19 db03 multipathd: sde: tur checker reports path is up
Oct 23 02:01:19 db03 multipathd: 8:64: reinstated
Oct 23 02:01:19 db03 multipathd: mpath1: remaining active paths: 1
Oct 23 02:01:20 db03 multipathd: sdc: tur checker reports path is up
Oct 23 02:01:20 db03 multipathd: 8:32: reinstated
Oct 23 02:01:20 db03 multipathd: mpath1: remaining active paths: 2
Oct 23 02:01:21 db03 kernel: sd 2:0:1:1: SCSI error: return code =3D 0x0800=
0002
Oct 23 02:01:21 db03 kernel: sde: Current: sense key: Aborted Command
Oct 23 02:01:21 db03 kernel:     Add. Sense: Internal target failure
Oct 23 02:01:21 db03 kernel:


Multipathd segfault during boot and following is from dmesg output:

multipathd[7165]: segfault at 000000000000000a rip 00002aaaaaf51a3d rsp 000=
07fff03b50090 error 4
sd 2:0:1:1: SCSI error: return code =3D 0x08000002
sde: Current: sense key: Aborted Command
    Add. Sense: Internal target failure

end_request: I/O error, dev sde, sector 912637903
device-mapper: multipath: Failing path 8:64.
sd 1:0:3:1: SCSI error: return code =3D 0x08000002
sdc: Current: sense key: Aborted Command
    Add. Sense: Internal target failure

end_request: I/O error, dev sdc, sector 915472343
device-mapper: multipath: Failing path 8:32.
sd 2:0:1:1: SCSI error: return code =3D 0x08000002
sde: Current: sense key: Aborted Command
    Add. Sense: Internal target failure

end_request: I/O error, dev sde, sector 915472343
device-mapper: multipath: Failing path 8:64.
sd 2:0:1:1: SCSI error: return code =3D 0x08000002
sde: Current: sense key: Aborted Command
    Add. Sense: Internal target failure

end_request: I/O error, dev sde, sector 919728103
device-mapper: multipath: Failing path 8:64.
sd 1:0:3:1: SCSI error: return code =3D 0x08000002
sdc: Current: sense key: Aborted Command
    Add. Sense: Internal target failure

We have experienced same failures on both RHEL 5.1 and CentOS. Following is=
 /etc/multipathd.conf

defaults {
        user_friendly_names yes
        path_grouping_policy multibus
}

devices {
        device {
                vendor "COMPELNT"
                product "Compellent Vol"
                path_checker tur
                polling_interval 10
                no_path_retry queue
        }
}

blacklist {
        devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
        devnode "^(hd|xvd)[a-z]*"
        wwid "*"
}

# Make sure our multipath devices are enabled.

blacklist_exceptions {
        wwid "36000d310000e63000000000000000007"
        wwid "36000d310000e6300000000000000000c"
}


# multipath -ll
mpath1 (36000d310000e6300000000000000000c) dm-5 COMPELNT,Compellent Vol
[size=3D500G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D2][active]
 \_ 1:0:3:1 sdc 8:32  [active][ready]
 \_ 2:0:1:1 sde 8:64  [active][ready]
mpath0 (36000d310000e63000000000000000007) dm-0 COMPELNT,Compellent Vol
[size=3D50G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D2][active]
 \_ 1:0:3:0 sdb 8:16  [active][ready]
 \_ 2:0:1:0 sdd 8:48  [active][ready]


Please let me know if you need more information. This is my first experienc=
e with SAN configuration and I feel that I have missed something very obvio=
us, because I was not getting meaningful results for those search results.

Thanks,
Prakash.

--_000_0FCB6A1400B4B9469B7661BFE02AFC2E0B289DA4F1mailxjigsawco_
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

</head>

<body lang=3DEN-US link=3Dblue vlink=3Dpurple>

<div class=3DSection1>

<p class=3DMsoNormal><a name=3D"OLE_LINK1"></a><a name=3D"OLE_LINK2"><font =
size=3D2
face=3DArial><span style=3D'font-size:10.0pt;font-family:Arial'>Hi,<o:p></o=
:p></span></font></a></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>We have setup a Compellent SAN with 2 HBA attached to du=
al
fabrics. Under load when we import a 60GB database, paths fail very often.
Following is the failed path behavior from syslog.<o:p></o:p></span></font>=
</p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Oct 23 02:01:15 db03 kernel: sd 2:0:1:1: SCSI error: ret=
urn
code =3D 0x08000002<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Oct 23 02:01:15 db03 kernel: sde: Current: sense key:
Aborted Command<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Oct 23 02:01:15 db03 kernel:&nbsp;&nbsp;&nbsp;&nbsp; Add=
.
Sense: Internal target failure<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Oct 23 02:01:15 db03 kernel:<o:p></o:p></span></font></p=
>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Oct 23 02:01:15 db03 kernel: end_request: I/O error, dev
sde, sector 911585239<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Oct 23 02:01:15 db03 kernel: device-mapper: multipath:
Failing path 8:64.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Oct 23 02:01:15 db03 multipathd: 8:64: mark as failed<o:=
p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Oct 23 02:01:15 db03 multipathd: mpath1: remaining activ=
e paths:
1<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Oct 23 02:01:15 db03 kernel: sd 1:0:3:1: SCSI error: ret=
urn
code =3D 0x08000002<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Oct 23 02:01:15 db03 kernel: sdc: Current: sense key:
Aborted Command<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Oct 23 02:01:15 db03 kernel:&nbsp;&nbsp;&nbsp;&nbsp; Add=
.
Sense: Internal target failure<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Oct 23 02:01:15 db03 kernel:<o:p></o:p></span></font></p=
>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Oct 23 02:01:15 db03 kernel: end_request: I/O error, dev
sdc, sector 911585239<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Oct 23 02:01:15 db03 kernel: device-mapper: multipath:
Failing path 8:32.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Oct 23 02:01:16 db03 multipathd: 8:32: mark as failed<o:=
p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Oct 23 02:01:16 db03 multipathd: mpath1: remaining activ=
e
paths: 0<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Oct 23 02:01:19 db03 multipathd: sde: tur checker report=
s
path is up<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Oct 23 02:01:19 db03 multipathd: 8:64: reinstated<o:p></=
o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Oct 23 02:01:19 db03 multipathd: mpath1: remaining activ=
e
paths: 1<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Oct 23 02:01:20 db03 multipathd: sdc: tur checker report=
s
path is up<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Oct 23 02:01:20 db03 multipathd: 8:32: reinstated<o:p></=
o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Oct 23 02:01:20 db03 multipathd: mpath1: remaining activ=
e
paths: 2<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Oct 23 02:01:21 db03 kernel: sd 2:0:1:1: SCSI error: ret=
urn
code =3D 0x08000002<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Oct 23 02:01:21 db03 kernel: sde: Current: sense key:
Aborted Command<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Oct 23 02:01:21 db03 kernel:&nbsp;&nbsp;&nbsp;&nbsp; Add=
.
Sense: Internal target failure<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Oct 23 02:01:21 db03 kernel:<o:p></o:p></span></font></p=
>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Multipathd segfault during boot and following is from dm=
esg
output:<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>multipathd[7165]: segfault at 000000000000000a rip
00002aaaaaf51a3d rsp 00007fff03b50090 error 4<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>sd 2:0:1:1: SCSI error: return code =3D 0x08000002<o:p><=
/o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>sde: Current: sense key: Aborted Command<o:p></o:p></spa=
n></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>&nbsp;&nbsp;&nbsp; Add. Sense: Internal target failure<o=
:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>end_request: I/O error, dev sde, sector 912637903<o:p></=
o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>device-mapper: multipath: Failing path 8:64.<o:p></o:p><=
/span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>sd 1:0:3:1: SCSI error: return code =3D 0x08000002<o:p><=
/o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>sdc: Current: sense key: Aborted Command<o:p></o:p></spa=
n></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>&nbsp;&nbsp;&nbsp; Add. Sense: Internal target failure<o=
:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>end_request: I/O error, dev sdc, sector 915472343<o:p></=
o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>device-mapper: multipath: Failing path 8:32.<o:p></o:p><=
/span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>sd 2:0:1:1: SCSI error: return code =3D 0x08000002<o:p><=
/o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>sde: Current: sense key: Aborted Command<o:p></o:p></spa=
n></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>&nbsp;&nbsp;&nbsp; Add. Sense: Internal target failure<o=
:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>end_request: I/O error, dev sde, sector 915472343<o:p></=
o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>device-mapper: multipath: Failing path 8:64.<o:p></o:p><=
/span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>sd 2:0:1:1: SCSI error: return code =3D 0x08000002<o:p><=
/o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>sde: Current: sense key: Aborted Command<o:p></o:p></spa=
n></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>&nbsp;&nbsp;&nbsp; Add. Sense: Internal target failure<o=
:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>end_request: I/O error, dev sde, sector 919728103<o:p></=
o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>device-mapper: multipath: Failing path 8:64.<o:p></o:p><=
/span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>sd 1:0:3:1: SCSI error: return code =3D 0x08000002<o:p><=
/o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>sdc: Current: sense key: Aborted Command<o:p></o:p></spa=
n></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>&nbsp;&nbsp;&nbsp; Add. Sense: Internal target failure<o=
:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>We have experienced same failures on both RHEL 5.1 and
CentOS. Following is /etc/multipathd.conf <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>defaults {<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
user_friendly_names yes<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
path_grouping_policy multibus<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>}<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>devices {<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; device {<o:p>=
</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
vendor &quot;COMPELNT&quot;<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
product &quot;Compellent Vol&quot;<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
path_checker tur<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;polling_interval 10<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
no_path_retry queue<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<o:p></o:p><=
/span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>}<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>blacklist {<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; devnode
&quot;^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*&quot;<o:p></o:p></span></fo=
nt></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; devnode
&quot;^(hd|xvd)[a-z]*&quot;<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; wwid
&quot;*&quot;<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>}<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'># Make sure our multipath devices are enabled.<o:p></o:p=
></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>blacklist_exceptions {<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; wwid
&quot;36000d310000e63000000000000000007&quot;<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; wwid
&quot;36000d310000e6300000000000000000c&quot;<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>}<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'># multipath -ll<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>mpath1 (36000d310000e6300000000000000000c) dm-5
COMPELNT,Compellent Vol<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>[size=3D500G][features=3D1 queue_if_no_path][hwhandler=
=3D0]<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>\_ round-robin 0 [prio=3D2][active]<o:p></o:p></span></f=
ont></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>&nbsp;\_ 1:0:3:1 sdc 8:32&nbsp; [active][ready]<o:p></o:=
p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>&nbsp;\_ 2:0:1:1 sde 8:64&nbsp; [active][ready]<o:p></o:=
p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>mpath0 (36000d310000e63000000000000000007) dm-0
COMPELNT,Compellent Vol<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>[size=3D50G][features=3D1 queue_if_no_path][hwhandler=3D=
0]<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>\_ round-robin 0 [prio=3D2][active]<o:p></o:p></span></f=
ont></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>&nbsp;\_ 1:0:3:0 sdb 8:16&nbsp; [active][ready]<o:p></o:=
p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>&nbsp;\_ 2:0:1:0 sdd 8:48&nbsp; [active][ready]<o:p></o:=
p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Please let me know if you need more information. This is=
 my
first experience with SAN configuration and I feel that I have missed somet=
hing
very obvious, because I was not getting meaningful results for those search
results.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Thanks,<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Prakash.<o:p></o:p></span></font></p>

</div>

</body>

</html>

--_000_0FCB6A1400B4B9469B7661BFE02AFC2E0B289DA4F1mailxjigsawco_--


--===============0477347362==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0477347362==--
