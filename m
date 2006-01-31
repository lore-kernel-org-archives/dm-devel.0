From: =?iso-8859-1?Q?Jo=E3o_Daniel?= <jd-apinf@est.ips.pt>
Subject: Problem with Multipath (devices not ready)
Date: Tue, 31 Jan 2006 17:38:48 -0000
Message-ID: <!&!AAAAAAAAAAAYAAAAAAAAANNuC7JXowhAhztxsUsdl9nCgAAAEAAAAFrKzybPoitElCE3HsMmQqIBAAAAAA==@est.ips.pt>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0793449232=="
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

--===============0793449232==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0044_01C6268D.31366350"

This is a multi-part message in MIME format.

------=_NextPart_000_0044_01C6268D.31366350
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi,

=20

=20

=20

I have upgraded from SLES9-SP2 to SLES9-SP3.

The purpose was to fix some problems related to OCFS2.

=20

I have many warnings (as you can see below) in my /var/log/messages =
related
to multipath (i think), indicating that the devices aren't ready.=20

Maybe the multipath.conf needs some extra configuration (please see my
multipath.conf).

The sdc and sdd devices are disks out on the EMC.

=20

=20

Can anyone help me with this problem ?

=20

=20

=20

=20

=20

=20

ERROR MESSAGES:

=20

(...)

Jan 27 16:16:18 siipstestes kernel: Device sdc not ready.

Jan 27 16:16:18 siipstestes kernel: Device sdd not ready.

Jan 27 16:16:29 siipstestes kernel: Device sdc not ready.

Jan 27 16:16:29 siipstestes kernel: Device sdd not ready.

Jan 27 16:16:40 siipstestes kernel: Device sdc not ready.

Jan 27 16:16:40 siipstestes kernel: Device sdd not ready.

Jan 27 16:16:51 siipstestes kernel: Device sdc not ready.

Jan 27 16:16:51 siipstestes kernel: Device sdd not ready.

Jan 27 16:17:02 siipstestes kernel: Device sdc not ready.

Jan 27 16:17:02 siipstestes kernel: Device sdd not ready.

Jan 27 16:17:13 siipstestes kernel: Device sdc not ready.

Jan 27 16:17:13 siipstestes kernel: Device sdd not ready.

Jan 27 16:17:24 siipstestes kernel: Device sdc not ready.

Jan 27 16:17:24 siipstestes kernel: Device sdd not ready.

Jan 27 16:17:35 siipstestes kernel: Device sdc not ready.

Jan 27 16:17:35 siipstestes kernel: Device sdd not ready.

Jan 27 16:17:46 siipstestes kernel: Device sdc not ready.

Jan 27 16:17:46 siipstestes kernel: Device sdd not ready.

(...)

=20

=20

=20

=20

=20

server:~ # multipath -v2 -l

dm names   N =20

dm table LUN_TESTES  N =20

dm table LUN_TESTES  N =20

dm status LUN_TESTES  N =20

dm info LUN_TESTES  O =20

LUN_TESTES (360060160256014006adcbf64a644da11)

[size=3D458 GB][features=3D"0"][hwhandler=3D"0"]

\_ round-robin 0 [active]

 \_ 3:0:0:0 sdc 8:32 [failed][faulty]

 \_ 3:0:1:0 sdd 8:48 [failed][faulty]

 \_ 3:0:2:0 sde 8:64 [active][ready]

 \_ 3:0:3:0 sdf 8:80 [active][ready]

=20

=20

=20

=20

=20

=20

=20

=20

=20

Here is my MULTIPATH.CONF file:

=20

=20

defaults {

            multipath_tool   "/sbin/multipath -v 0 -S"

            udev_dir            /dev

            polling_interval 10

            default_selector "round-robin 0"

    #default_path_grouping_policy           failover

            default_path_grouping_policy     multibus

            default_getuid_callout    "/sbin/scsi_id -g -u -s /block/%n"

            #default_prio_callout      "/bin/false"

    failback        immediate

}

=20

#

# name    : devnode_blacklist

# scope   : multipath & multipathd

# desc    : list of device names to discard as not multipath candidates

# default : cciss, fd, hd, md, dm, sr, scd, st, ram, raw, loop

#

devnode_blacklist {

            devnode cciss

            devnode fd

            devnode hd

            devnode md

            devnode dm-

            devnode sr

            devnode scd

            devnode st

            devnode ram

            devnode raw

            devnode loop

            devnode sda

            devnode sdb

}

=20

#

# name    : multipaths

# scope   : multipath & multipathd

# desc    : list of multipaths finest-grained settings

#

multipaths {

            #

            # name  : multipath

            # scope : multipath & multipathd

            # desc  : container for settings that apply to one specific
multipath

            #

            multipath {

                        wwid
360060160256014006adcbf64a644da11

                        alias                             LUN_TESTES

            }

}

=20

=20

=20

=20

=20

=20

=20

=20

=20

=20

=20

=20

=20

=20

HARDWARE:

=20

- DELL 2850

- 1x QLogic 2340 (BIOS 1.47) to acess my Storage (EMC Clariion CX300)

=20

=20

=20

=20

SOFTWARE:

=20

- SLES9 (32 bit) + SP3 (with Multipath and OCFS2 configured)

- Oracle Clusterware Release 2 (10.2.0.1.0)

- Oracle Database 10g Release 2 (10.2.0.1.0)

- Qlogic driver: qlafc-linux-8.01.00-4-install.tgz.gz

- Naviagent CLI: naviagentcli-6.16.0.4.63-1.i386.rpm

- SANsurfer: emc_sansurfer2.0.30b52_linux_install.bin

=20

- Multipath 0.4.5-0.11

=20

=20

=20

=20

=20

=20

Best regards,

=20

=20

=20

=20





Jo=E3o Daniel




Apoio Inform=E1tico=20

Sistema de Informa=E7=E3o do Instituto Polit=E9cnico de Set=FAbal=20

 <mailto:jd-apinf@est.ips.pt>=20

Instituto Polit=E9cnico de Set=FAbal=20
Esc. Sup. de Tec. de Set=FAbal=20

Campus do IPS, Estefanilha
2910-761 Set=FAbal=20





tel:  =20


+351 265 790 133
+351 265 790 119

=20

=20


------=_NextPart_000_0044_01C6268D.31366350
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns=3D"http://www.w3.org/TR/REC-html40">

<head>
<meta http-equiv=3DContent-Type content=3D"text/html; =
charset=3Diso-8859-1">
<meta name=3DGenerator content=3D"Microsoft Word 11 (filtered medium)">
<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:Verdana;
	panose-1:2 11 6 4 3 5 4 4 2 4;}
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
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
span.style11
	{color:black;}
@page Section1
	{size:595.3pt 841.9pt;
	margin:70.85pt 3.0cm 70.85pt 3.0cm;}
div.Section1
	{page:Section1;}
-->
</style>

</head>

<body lang=3DPT link=3Dblue vlink=3Dpurple>

<div class=3DSection1>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>Hi,<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>=A0<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>I have upgraded from SLES9-SP2 to =
SLES9-SP3.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>The purpose was to fix some problems related =
to
OCFS2.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>I have many warnings (as you can see below) in =
my /var/log/messages
related to multipath (i think), indicating that the devices aren't =
ready. <o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>Maybe the multipath.conf needs some extra
configuration (please see my =
multipath.conf).<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>The sdc and sdd devices are disks out on the =
EMC.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>Can anyone help me with this problem =
?<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>=A0<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>ERROR MESSAGES:<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>(...)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>Jan 27 16:16:18 siipstestes kernel: Device sdc =
not
ready.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>Jan 27 16:16:18 siipstestes kernel: Device sdd =
not
ready.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>Jan 27 16:16:29 siipstestes kernel: Device sdc =
not
ready.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>Jan 27 16:16:29 siipstestes kernel: Device sdd =
not
ready.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>Jan 27 16:16:40 siipstestes kernel: Device sdc =
not
ready.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>Jan 27 16:16:40 siipstestes kernel: Device sdd =
not
ready.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>Jan 27 16:16:51 siipstestes kernel: Device sdc =
not
ready.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>Jan 27 16:16:51 siipstestes kernel: Device sdd =
not
ready.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>Jan 27 16:17:02 siipstestes kernel: Device sdc =
not
ready.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>Jan 27 16:17:02 siipstestes kernel: Device sdd =
not
ready.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>Jan 27 16:17:13 siipstestes kernel: Device sdc =
not
ready.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>Jan 27 16:17:13 siipstestes kernel: Device sdd =
not
ready.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>Jan 27 16:17:24 siipstestes kernel: Device sdc =
not
ready.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>Jan 27 16:17:24 siipstestes kernel: Device sdd =
not
ready.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>Jan 27 16:17:35 siipstestes kernel: Device sdc =
not
ready.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>Jan 27 16:17:35 siipstestes kernel: Device sdd =
not
ready.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>Jan 27 16:17:46 siipstestes kernel: Device sdc =
not
ready.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>Jan 27 16:17:46 siipstestes kernel: Device sdd =
not
ready.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>(...)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>=A0<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>server:~ # multipath -v2 =
-l<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>dm names=A0=A0 N=A0 =
<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>dm table LUN_TESTES=A0 N=A0 =
<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>dm table LUN_TESTES=A0 N=A0 =
<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>dm status LUN_TESTES=A0 N=A0 =
<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>dm info LUN_TESTES=A0 O=A0 =
<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>LUN_TESTES =
(360060160256014006adcbf64a644da11)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>[size=3D458
GB][features=3D&quot;0&quot;][hwhandler=3D&quot;0&quot;]<o:p></o:p></span=
></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>\_ round-robin 0 =
[active]<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>=A0\_ 3:0:0:0 sdc 8:32 =
[failed][faulty]<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>=A0\_ 3:0:1:0 sdd 8:48 =
[failed][faulty]<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>=A0\_ 3:0:2:0 sde 8:64 =
[active][ready]<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>=A0\_ 3:0:3:0 sdf 8:80 =
[active][ready]<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>=A0<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>Here is my MULTIPATH.CONF =
file:<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>defaults {<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
multipath_tool=A0=A0 &quot;/sbin/multipath -v
0 -S&quot;<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
udev_dir=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
/dev<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
polling_interval 10<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
default_selector &quot;round-robin
0&quot;<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>=A0=A0=A0 =
#default_path_grouping_policy=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
failover<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
default_path_grouping_policy=A0=A0=A0=A0 =
multibus<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
default_getuid_callout=A0=A0=A0 &quot;/sbin/scsi_id
-g -u -s /block/%n&quot;<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
#default_prio_callout=A0=A0=A0=A0=A0 =
&quot;/bin/false&quot;<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>=A0=A0=A0 failback=A0=A0=A0=A0=A0=A0=A0 =
immediate<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>}<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>#<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'># name=A0=A0=A0 : =
devnode_blacklist<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'># scope=A0=A0 : multipath &amp; =
multipathd<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'># desc=A0=A0=A0 : list of device names to =
discard as not
multipath candidates<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'># default : cciss, fd, hd, md, dm, sr, scd, =
st, ram,
raw, loop<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>#<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>devnode_blacklist =
{<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 devnode =
cciss<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 devnode =
fd<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
</span></font><font size=3D2 face=3DArial><span
style=3D'font-size:10.0pt;font-family:Arial'>devnode =
hd<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 devnode =
md<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 devnode =
dm-<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 devnode =
sr<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 devnode =
scd<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 devnode =
st<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 devnode =
ram<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 devnode =
raw<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 devnode =
loop<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 </span></font><font =
size=3D2 face=3DArial><span
lang=3DEN-GB style=3D'font-size:10.0pt;font-family:Arial'>devnode =
sda<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 devnode =
sdb<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>}<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>#<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'># name=A0=A0=A0 : =
multipaths<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'># scope=A0=A0 : multipath &amp; =
multipathd<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'># desc=A0=A0=A0 : list of multipaths =
finest-grained
settings<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>#<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>multipaths {<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
#<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 # name=A0 : =
multipath<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 # scope : =
multipath &amp; multipathd<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 # desc=A0 : =
container for settings that
apply to one specific multipath<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
</span></font><font size=3D2 face=3DArial><span
style=3D'font-size:10.0pt;font-family:Arial'>#<o:p></o:p></span></font></=
p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 multipath =
{<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 =
wwid=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 =
360060160256014006adcbf64a644da11<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 =
alias=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 LUN_TESTES<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
}<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>}<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>=A0<span =
lang=3DEN-GB><o:p></o:p></span></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>HARDWARE:<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>- DELL 2850<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>- 1x QLogic 2340 (BIOS 1.47) to acess my =
Storage (EMC
Clariion CX300)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>=A0<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>SOFTWARE:<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>- SLES9 (32 bit) + SP3 (with Multipath and =
OCFS2
configured)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>- Oracle Clusterware Release 2 =
(10.2.0.1.0)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>- Oracle Database 10g Release 2 =
(10.2.0.1.0)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>- Qlogic driver: =
qlafc-linux-8.01.00-4-install.tgz.gz<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>- Naviagent CLI: =
naviagentcli-6.16.0.4.63-1.i386.rpm<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>- SANsurfer: =
emc_sansurfer2.0.30b52_linux_install.bin<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>- Multipath =
0.4.5-0.11<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'>Best regards,<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DEN-GB =
style=3D'font-size:
10.0pt;font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span =
style=3D'font-size:
10.0pt;font-family:Arial;color:navy'><o:p>&nbsp;</o:p></span></font></p>

<div>

<table class=3DMsoNormalTable border=3D0 cellspacing=3D0 cellpadding=3D0 =
width=3D600
 style=3D'width:450.0pt' height=3D"100%">
 <tr>
  <td style=3D'padding:0cm 0cm 0cm 0cm'>
  <table class=3DMsoNormalTable border=3D0 cellspacing=3D0 =
cellpadding=3D0 align=3Dright
   width=3D600 style=3D'width:450.0pt'>
   <tr>
    <td width=3D600 style=3D'width:450.0pt;padding:0cm 0cm 0cm 0cm'>
    <table class=3DMsoNormalTable border=3D1 cellspacing=3D0 =
cellpadding=3D0 width=3D600
     style=3D'width:450.0pt;border:solid #666666 1.0pt'>
     <tr>
      <td width=3D607 style=3D'width:455.25pt;border:none;padding:.75pt =
.75pt .75pt .75pt'>
      <table class=3DMsoNormalTable border=3D0 cellpadding=3D0 =
align=3Dright
       width=3D"100%" style=3D'width:100.0%'>
       <tr height=3D1 style=3D'height:.75pt'>
        <td rowspan=3D2 valign=3Dtop style=3D'padding:.75pt .75pt 3.0pt =
3.0pt;
        height:.75pt'>
        <p class=3DMsoNormal =
style=3D'mso-margin-top-alt:auto;mso-margin-bottom-alt:
        auto'><ST1:PERSONNAME u2:st=3D"on" ProductID=3D"Manuel =
Machado"><b><font
        size=3D2 color=3Dblack face=3DVerdana><span =
style=3D'font-size:10.0pt;
        font-family:Verdana;color:black;font-weight:bold'>Jo=E3o =
Daniel</span></font></b></ST1:PERSONNAME><font
        size=3D1 color=3D"#006699" face=3DVerdana><span =
style=3D'font-size:8.0pt;
        font-family:Verdana;color:#006699'><br>
        <br>
        <br>
        <br>
        <br>
        Apoio Inform=E1tico <br>
        <br>
        Sistema de Informa=E7=E3o do Instituto Polit=E9cnico de =
Set=FAbal <U4:P></U4:P></span></font><U1:P></U1:P><font
        color=3Dnavy><span =
style=3D'color:navy'><o:p></o:p></span></font></p>
        <p class=3DMsoNormal =
style=3D'mso-margin-top-alt:auto;mso-margin-bottom-alt:
        auto'><font size=3D1 color=3Dblack face=3DVerdana><span =
style=3D'font-size:
        8.0pt;font-family:Verdana;color:black'><a
        href=3D"mailto:jd-apinf@est.ips.pt" =
target=3D"_blank"></a></span></font><font
        color=3Dnavy><span =
style=3D'color:navy'><U4:P></U4:P><o:p></o:p></span></font></p>
        </td>
        <U1:P></U1:P>
        <td height=3D1 valign=3Dtop style=3D'padding:.75pt 3.0pt 3.0pt =
.75pt;
        height:.75pt'>
        <p class=3DMsoNormal align=3Dright =
style=3D'mso-margin-top-alt:auto;
        mso-margin-bottom-alt:auto;text-align:right'><b><font size=3D1
        color=3Dblack face=3DVerdana><span =
style=3D'font-size:8.0pt;font-family:Verdana;
        color:black;font-weight:bold'>Instituto Polit=E9cnico de =
Set=FAbal <br>
        Esc. Sup. de Tec. de Set=FAbal </span></font></b><font size=3D1
        color=3Dblack face=3DVerdana><span =
style=3D'font-size:8.0pt;font-family:Verdana;
        color:black'><br>
        <br>
        Campus do IPS, Estefanilha<br>
        2910-761 Set=FAbal <U4:P></U4:P></span></font><U1:P></U1:P><font
        color=3Dnavy><span =
style=3D'color:navy'><o:p></o:p></span></font></p>
        </td>
       </tr>
       <tr height=3D1 style=3D'height:.75pt'>
        <td height=3D1 valign=3Dbottom style=3D'padding:.75pt 3.0pt =
3.0pt .75pt;
        height:.75pt'>
        <table class=3DMsoNormalTable border=3D0 cellspacing=3D0 =
cellpadding=3D0
         align=3Dright>
         <tr>
          <td nowrap style=3D'padding:.75pt .75pt .75pt .75pt'>
          <p class=3DMsoNormal align=3Dright =
style=3D'mso-margin-top-alt:auto;
          mso-margin-bottom-alt:auto;text-align:right'><font size=3D1
          color=3Dblack face=3DVerdana><span =
style=3D'font-size:8.0pt;font-family:
          Verdana;color:black'><br>
          <br>
          tel: &nbsp; <U4:P></U4:P></span></font><U1:P></U1:P><font =
color=3Dnavy><span
          style=3D'color:navy'><o:p></o:p></span></font></p>
          </td>
          <td nowrap style=3D'padding:.75pt .75pt .75pt 3.0pt'>
          <p class=3DMsoNormal align=3Dright =
style=3D'mso-margin-top-alt:auto;
          mso-margin-bottom-alt:auto;text-align:right'><font size=3D1
          color=3Dblack face=3DVerdana><span =
style=3D'font-size:8.0pt;font-family:
          Verdana;color:black'><br>
          +351 <span class=3Dstyle11><font =
color=3Dblack>265</font></span></span></font>
          <span class=3Dstyle11><font size=3D1 color=3Dblack =
face=3DVerdana><span
          =
style=3D'font-size:8.0pt;font-family:Verdana'>790</span></font></span> =
<span
          class=3Dstyle11><font size=3D1 color=3Dblack =
face=3DVerdana><span
          =
style=3D'font-size:8.0pt;font-family:Verdana'>133</span></font></span><fo=
nt
          size=3D1 color=3Dblack face=3DVerdana><span =
style=3D'font-size:8.0pt;
          font-family:Verdana;color:black'><br>
          +351 <span class=3Dstyle11><font color=3Dblack>265 =
790</font></span> 119<U4:P></U4:P></span></font><U1:P></U1:P><font
          color=3Dnavy><span =
style=3D'color:navy'><o:p></o:p></span></font></p>
          </td>
         </tr>
        </table>
        <font size=3D3 color=3Dnavy face=3D"Times New Roman"><span =
style=3D'font-size:
        12.0pt;font-family:"Times New =
Roman";color:navy'><U4:P></U4:P></span></font>
        <p class=3DMsoNormal><font size=3D3 color=3Dnavy face=3D"Times =
New Roman"><span
        =
style=3D'font-size:12.0pt;color:navy'><o:p></o:p></span></font></p>
        </td>
       </tr>
       <U1:P></U1:P>
      </table>
      <font size=3D3 color=3Dnavy face=3D"Times New Roman"><span =
style=3D'font-size:
      12.0pt;font-family:"Times New =
Roman";color:navy'><U1:P></U1:P></span></font>
      <p class=3DMsoNormal><U4:P></U4:P><font size=3D3 color=3Dnavy
      face=3D"Times New Roman"><span =
style=3D'font-size:12.0pt;color:navy'><o:p></o:p></span></font></p>
      </td>
     </tr>
    </table>
    <font size=3D3 color=3Dnavy face=3D"Times New Roman"><span =
style=3D'font-size:12.0pt;
    font-family:"Times New =
Roman";color:navy'><U4:P></U4:P></span></font>
    <p class=3DMsoNormal><font size=3D3 color=3Dnavy face=3D"Times New =
Roman"><span
    style=3D'font-size:12.0pt;color:navy'><o:p></o:p></span></font></p>
    </td>
    <U1:P></U1:P>
    <td width=3D17 style=3D'width:12.75pt;padding:0cm 0cm 0cm 0cm'>
    <p class=3DMsoNormal =
style=3D'mso-margin-top-alt:auto;mso-margin-bottom-alt:
    auto'><U4:P></U4:P><font size=3D2 color=3Dnavy face=3D"Times New =
Roman"><span
    =
style=3D'font-size:10.0pt;color:navy'><U1:P>&nbsp;</U1:P></span></font><f=
ont
    color=3Dnavy><span =
style=3D'color:navy'><o:p></o:p></span></font></p>
    </td>
   </tr>
  </table>
  <font size=3D3 color=3Dnavy face=3D"Times New Roman"><span =
style=3D'font-size:12.0pt;
  font-family:"Times New Roman";color:navy'><U1:P></U1:P></span></font>
  <p class=3DMsoNormal><U4:P></U4:P><font size=3D3 color=3Dnavy =
face=3D"Times New Roman"><span
  style=3D'font-size:12.0pt;color:navy'><o:p></o:p></span></font></p>
  </td>
 </tr>
</table>

</div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt'><o:p>&nbsp;</o:p></span></font></p>

</div>

</body>

</html>

------=_NextPart_000_0044_01C6268D.31366350--



--===============0793449232==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0793449232==--
