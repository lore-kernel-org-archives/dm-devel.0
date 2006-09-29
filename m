From: Edward Goggin <egoggin@emc.com>
Subject: RE: Avoid Error Messages in /var/log/messages EMC CX300
Date: Fri, 29 Sep 2006 11:58:15 -0400
Message-ID: <6CCEAEDF4D06984A83F427424F47D6E4013D1402@CORPUSMX40A.corp.emc.com>
References: <C514D40EFDB5C84083DAEB84A1186A8F266AEB@msc-ex02.msc-ge.mscnet>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1828954548=="
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <C514D40EFDB5C84083DAEB84A1186A8F266AEB@msc-ex02.msc-ge.mscnet>
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

--===============1828954548==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C6E3E0.130D0649"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C6E3E0.130D0649
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

These errors are caused by Linux system applications, (e.g., blkid(8),
hwinfo(8)), which issue read/write i/o directly to target device paths
(i.e., /dev/sdh in your example) which are in a passive/standby state.
=20
Although the errors are benign, there can be a lot of them and it makes
it difficult to discern the ones which are not benign.


________________________________

	From: dm-devel-bounces@redhat.com
[mailto:dm-devel-bounces@redhat.com] On Behalf Of Herr, Manuel
	Sent: Wednesday, September 27, 2006 6:27 AM
	To: dm-devel@redhat.com
	Subject: [dm-devel] Avoid Error Messages in /var/log/messages
EMC CX300
=09
=09

	Hi there,=20
	i get Error Messages in my logfiles when I boot the System and
then, approx. every 10 Minutes, or during an hwinfo.=20
	The Server is connected to an EMC CX 300 through 1 Qlogic HBA.=20
	The Messages only appear for the failover Device. In my Example
for /dev/sdh.=20

	#multipath -ld=20
	sapdata (36006016040321900600487993216db11)=20
	[size=3D133 GB][features=3D"1 queue_if_no_path"][hwhandler=3D"1 emc"]=20
	\_ round-robin 0 [active]=20
	 \_ 3:0:1:6 sdp 8:240 [active][ready]=20
	\_ round-robin 0 [enabled]=20
	 \_ 3:0:0:6 sdh 8:112 [active][ready]=20
	*snip*=20

	#fdisk -l /dev/sdp=20
	Disk /dev/sdp: 143.0 GB, 143034155008 bytes=20
	255 heads, 63 sectors/track, 17389 cylinders=20
	Units =3D cylinders of 16065 * 512 =3D 8225280 bytes=20

	   Device Boot      Start         End      Blocks   Id  System=20
	/dev/sdp1               1       17389   139677111   83  Linux=20

	#fdisk -l /dev/sdh=20
	--> Generates this Error in /var/log/messages=20
	Sep 27 12:17:44 saptf2 kernel: end_request: I/O error, dev sdh,
sector 0=20
	Sep 27 12:17:44 saptf2 kernel: Buffer I/O error on device sdh,
logical block 0=20


	Configuration:=20
	/etc/multipath.conf=20
	defaults {=20
	        default_features "1 queue_if_no_path"=20
	}=20

	multipaths {=20
	        multipath=20
	        {=20
	                #mountpoint /sapdb/PF1/sapdata=20
	                wwid 36006016040321900600487993216db11=20
	                alias sapdata=20
	        }=20
	*snip* (some more aliases for other LUNs) *snip*=20
	}=20
	devices {=20
	        device {=20
	                vendor                  "DGC  "=20
	                product                 "*"=20
	                path_grouping_policy    group_by_prio=20
	                getuid_callout          "/sbin/scsi_id -g -u -s
/block/%n"=20
	                path_checker            emc_clariion=20
	                features                "1 queue_if_no_path"=20
	                hardware_handler        "1 emc"=20
	                failback                immediate=20
	                prio_callout            "/sbin/mpath_prio_emc
/dev/%n"=20
	                no_path_retry           300=20
	        }=20
	}=20

	Loaded Modules:=20
	dm_emc                 23808  1=20
	dm_round_robin         20480  1=20
	dm_multipath           38800  3 dm_emc,dm_round_robin=20
	dm_mod                 77536  23 dm_multipath=20
	qla2300               141696  0=20
	qla2xxx               356192  33 qla2300=20

	#modinfo qla2300=20
	version:        8.01.02-sles DBB4213CE377B7165AFB8AC=20

	#modinfo qla2xxx=20
	version:        8.01.02-sles F6D31250031AEB3A3B9138A=20

	Kernel:=20
	2.6.5-7.282-smp X86_64=20

	I searched the mailing Lists for other examples, but i didnt
find any Suggestions to solve this.=20
	Thanks for help!=20
	Regarding=20
	Manuel Herr=20



------_=_NextPart_001_01C6E3E0.130D0649
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE>Avoid Error Messages in /var/log/messages EMC =
CX300</TITLE>
<META http-equiv=3DContent-Type content=3D"text/html; =
charset=3Dus-ascii">
<META content=3D"MSHTML 6.00.2800.1561" name=3DGENERATOR></HEAD>
<BODY>
<DIV dir=3Dltr align=3Dleft><SPAN class=3D688375315-29092006><FONT =
face=3DArial=20
color=3D#0000ff size=3D2>These errors are caused by Linux system =
applications,=20
(e.g., blkid(8), hwinfo(8)), which issue read/write i/o directly to =
target=20
device paths (i.e., /dev/sdh in your example) which are in a =
passive/standby=20
state.</FONT></SPAN></DIV>
<DIV dir=3Dltr align=3Dleft><SPAN class=3D688375315-29092006><FONT =
face=3DArial=20
color=3D#0000ff size=3D2></FONT></SPAN>&nbsp;</DIV>
<DIV dir=3Dltr align=3Dleft><SPAN class=3D688375315-29092006><FONT =
face=3DArial=20
color=3D#0000ff size=3D2>Although the errors are benign, there can be a =
lot of them=20
and it makes it difficult to discern the ones which are not=20
benign.</FONT></SPAN></DIV><BR>
<BLOCKQUOTE=20
style=3D"PADDING-LEFT: 5px; MARGIN-LEFT: 5px; BORDER-LEFT: #0000ff 2px =
solid; MARGIN-RIGHT: 0px">
  <DIV class=3DOutlookMessageHeader lang=3Den-us dir=3Dltr align=3Dleft>
  <HR tabIndex=3D-1>
  <FONT face=3DTahoma size=3D2><B>From:</B> dm-devel-bounces@redhat.com=20
  [mailto:dm-devel-bounces@redhat.com] <B>On Behalf Of </B>Herr,=20
  Manuel<BR><B>Sent:</B> Wednesday, September 27, 2006 6:27 =
AM<BR><B>To:</B>=20
  dm-devel@redhat.com<BR><B>Subject:</B> [dm-devel] Avoid Error Messages =
in=20
  /var/log/messages EMC CX300<BR></FONT><BR></DIV>
  <DIV></DIV><!-- Converted from text/rtf format -->
  <P><FONT face=3DArial>Hi there,</FONT> <BR><FONT face=3DArial>i get =
Error Messages=20
  in my logfiles when I boot the System and then, approx. every 10 =
Minutes, or=20
  during an hwinfo.</FONT> <BR><FONT face=3DArial>The Server is =
connected to an=20
  EMC CX 300 through 1 Qlogic HBA.</FONT> <BR><FONT face=3DArial>The =
Messages only=20
  appear for the failover Device. In my Example for /dev/sdh. =
</FONT></P>
  <P><FONT face=3DArial>#multipath -ld</FONT> <BR><FONT =
face=3DArial>sapdata=20
  (36006016040321900600487993216db11)</FONT> <BR><FONT =
face=3DArial>[size=3D133=20
  GB][features=3D"1 queue_if_no_path"][hwhandler=3D"1 emc"]</FONT> =
<BR><FONT=20
  face=3DArial>\_ round-robin 0 [active]</FONT> <BR><FONT =
face=3DArial>&nbsp;\_=20
  3:0:1:6 sdp 8:240 [active][ready]</FONT> <BR><FONT face=3DArial>\_ =
round-robin 0=20
  [enabled]</FONT> <BR><FONT face=3DArial>&nbsp;\_ 3:0:0:6 sdh 8:112=20
  [active][ready]</FONT> <BR><FONT face=3DArial>*snip*</FONT> </P>
  <P><FONT face=3DArial>#fdisk -l /dev/sdp</FONT> <BR><FONT =
face=3DArial>Disk=20
  /dev/sdp: 143.0 GB, 143034155008 bytes</FONT> <BR><FONT =
face=3DArial>255 heads,=20
  63 sectors/track, 17389 cylinders</FONT> <BR><FONT face=3DArial>Units =
=3D=20
  cylinders of 16065 * 512 =3D 8225280 bytes</FONT> </P>
  <P><FONT face=3DArial>&nbsp;&nbsp; Device =
Boot&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
  Start&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
  End&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Blocks&nbsp;&nbsp; Id&nbsp; =
System</FONT>=20
  <BR><FONT=20
  =
face=3DArial>/dev/sdp1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
  1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 17389&nbsp;&nbsp; =
139677111&nbsp;&nbsp;=20
  83&nbsp; Linux</FONT> </P>
  <P><FONT face=3DArial>#fdisk -l /dev/sdh</FONT> <BR><FONT =
face=3DArial>--&gt;=20
  Generates this Error in /var/log/messages</FONT> <BR><FONT =
face=3DArial>Sep 27=20
  12:17:44 saptf2 kernel: end_request: I/O error, dev sdh, sector =
0</FONT>=20
  <BR><FONT face=3DArial>Sep 27 12:17:44 saptf2 kernel: Buffer I/O error =
on device=20
  sdh, logical block 0</FONT> </P><BR>
  <P><FONT face=3DArial>Configuration:</FONT> <BR><FONT=20
  face=3DArial>/etc/multipath.conf</FONT> <BR><FONT =
face=3DArial>defaults {</FONT>=20
  <BR><FONT face=3DArial>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
  default_features "1 queue_if_no_path"</FONT> <BR><FONT =
face=3DArial>}</FONT>=20
</P>
  <P><FONT face=3DArial>multipaths {</FONT> <BR><FONT=20
  face=3DArial>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
multipath</FONT>=20
  <BR><FONT face=3DArial>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
{</FONT>=20
  <BR><FONT=20
  =
face=3DArial>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
  #mountpoint /sapdb/PF1/sapdata</FONT> <BR><FONT=20
  =
face=3DArial>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
  wwid 36006016040321900600487993216db11</FONT> <BR><FONT=20
  =
face=3DArial>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
  alias sapdata</FONT> <BR><FONT=20
  face=3DArial>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }</FONT> =
<BR><FONT=20
  face=3DArial>*snip* (some more aliases for other LUNs) *snip*</FONT> =
<BR><FONT=20
  face=3DArial>}</FONT> <BR><FONT face=3DArial>devices {</FONT> =
<BR><FONT=20
  face=3DArial>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; device =
{</FONT>=20
  <BR><FONT=20
  =
face=3DArial>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
  =
vendor&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
  "DGC&nbsp; "</FONT> <BR><FONT=20
  =
face=3DArial>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
  =
product&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
  "*"</FONT> <BR><FONT=20
  =
face=3DArial>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
  path_grouping_policy&nbsp;&nbsp;&nbsp; group_by_prio</FONT> <BR><FONT=20
  =
face=3DArial>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
  getuid_callout&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
  "/sbin/scsi_id -g -u -s /block/%n"</FONT> <BR><FONT=20
  =
face=3DArial>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
  =
path_checker&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;=20
  emc_clariion</FONT> <BR><FONT=20
  =
face=3DArial>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
  =
features&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;=20
  "1 queue_if_no_path"</FONT> <BR><FONT=20
  =
face=3DArial>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
  hardware_handler&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "1 =
emc"</FONT>=20
  <BR><FONT=20
  =
face=3DArial>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
  =
failback&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;=20
  immediate</FONT> <BR><FONT=20
  =
face=3DArial>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
  =
prio_callout&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;=20
  "/sbin/mpath_prio_emc /dev/%n"</FONT> <BR><FONT=20
  =
face=3DArial>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
  =
no_path_retry&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
=20
  300</FONT> <BR><FONT =
face=3DArial>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
  }</FONT> <BR><FONT face=3DArial>}</FONT> </P>
  <P><FONT face=3DArial>Loaded Modules:</FONT> <BR><FONT=20
  =
face=3DArial>dm_emc&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
  23808&nbsp; 1</FONT> <BR><FONT=20
  =
face=3DArial>dm_round_robin&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;=20
  20480&nbsp; 1</FONT> <BR><FONT=20
  =
face=3DArial>dm_multipath&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;=20
  38800&nbsp; 3 dm_emc,dm_round_robin</FONT> <BR><FONT=20
  =
face=3DArial>dm_mod&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
  77536&nbsp; 23 dm_multipath</FONT> <BR><FONT=20
  =
face=3DArial>qla2300&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
  141696&nbsp; 0</FONT> <BR><FONT=20
  =
face=3DArial>qla2xxx&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
  356192&nbsp; 33 qla2300</FONT> </P>
  <P><FONT face=3DArial>#modinfo qla2300</FONT> <BR><FONT=20
  face=3DArial>version:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
8.01.02-sles=20
  DBB4213CE377B7165AFB8AC</FONT> </P>
  <P><FONT face=3DArial>#modinfo qla2xxx</FONT> <BR><FONT=20
  face=3DArial>version:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
8.01.02-sles=20
  F6D31250031AEB3A3B9138A</FONT> </P>
  <P><FONT face=3DArial>Kernel: </FONT><BR><FONT =
face=3DArial>2.6.5-7.282-smp=20
  X86_64</FONT> </P>
  <P><FONT face=3DArial size=3D2>I searched the mailing Lists for other =
examples,=20
  but i didnt find any Suggestions to solve this.</FONT> <BR><FONT =
face=3DArial=20
  size=3D2>Thanks for help!</FONT> <BR><FONT face=3DArial =
size=3D2>Regarding=20
  </FONT><BR><FONT face=3DArial size=3D2>Manuel Herr</FONT>=20
</P><BR></BLOCKQUOTE></BODY></HTML>

------_=_NextPart_001_01C6E3E0.130D0649--


--===============1828954548==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1828954548==--
