From: "Herr, Manuel" <mher@msc-ge.com>
Subject: Avoid Error Messages in /var/log/messages EMC CX300
Date: Wed, 27 Sep 2006 12:26:56 +0200
Message-ID: <C514D40EFDB5C84083DAEB84A1186A8F266AEB@msc-ex02.msc-ge.mscnet>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0711449156=="
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
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

--===============0711449156==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C6E21F.7554D82F"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C6E21F.7554D82F
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi there,
i get Error Messages in my logfiles when I boot the System and then, =
approx. every 10 Minutes, or during an hwinfo.
The Server is connected to an EMC CX 300 through 1 Qlogic HBA.
The Messages only appear for the failover Device. In my Example for =
/dev/sdh.=20

#multipath -ld
sapdata (36006016040321900600487993216db11)
[size=3D133 GB][features=3D"1 queue_if_no_path"][hwhandler=3D"1 emc"]
\_ round-robin 0 [active]
 \_ 3:0:1:6 sdp 8:240 [active][ready]
\_ round-robin 0 [enabled]
 \_ 3:0:0:6 sdh 8:112 [active][ready]
*snip*

#fdisk -l /dev/sdp
Disk /dev/sdp: 143.0 GB, 143034155008 bytes
255 heads, 63 sectors/track, 17389 cylinders
Units =3D cylinders of 16065 * 512 =3D 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sdp1               1       17389   139677111   83  Linux

#fdisk -l /dev/sdh
--> Generates this Error in /var/log/messages
Sep 27 12:17:44 saptf2 kernel: end_request: I/O error, dev sdh, sector 0
Sep 27 12:17:44 saptf2 kernel: Buffer I/O error on device sdh, logical =
block 0


Configuration:
/etc/multipath.conf
defaults {
        default_features "1 queue_if_no_path"
}

multipaths {
        multipath
        {
                #mountpoint /sapdb/PF1/sapdata
                wwid 36006016040321900600487993216db11
                alias sapdata
        }
*snip* (some more aliases for other LUNs) *snip*
}
devices {
        device {
                vendor                  "DGC  "
                product                 "*"
                path_grouping_policy    group_by_prio
                getuid_callout          "/sbin/scsi_id -g -u -s =
/block/%n"
                path_checker            emc_clariion
                features                "1 queue_if_no_path"
                hardware_handler        "1 emc"
                failback                immediate
                prio_callout            "/sbin/mpath_prio_emc /dev/%n"
                no_path_retry           300
        }
}

Loaded Modules:
dm_emc                 23808  1
dm_round_robin         20480  1
dm_multipath           38800  3 dm_emc,dm_round_robin
dm_mod                 77536  23 dm_multipath
qla2300               141696  0
qla2xxx               356192  33 qla2300

#modinfo qla2300
version:        8.01.02-sles DBB4213CE377B7165AFB8AC

#modinfo qla2xxx
version:        8.01.02-sles F6D31250031AEB3A3B9138A

Kernel:=20
2.6.5-7.282-smp X86_64

I searched the mailing Lists for other examples, but i didnt find any =
Suggestions to solve this.
Thanks for help!
Regarding=20
Manuel Herr



------_=_NextPart_001_01C6E21F.7554D82F
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
<HTML>
<HEAD>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3Diso-8859-1">
<META NAME=3D"Generator" CONTENT=3D"MS Exchange Server version =
6.5.7650.28">
<TITLE>Avoid Error Messages in /var/log/messages EMC CX300</TITLE>
</HEAD>
<BODY>
<!-- Converted from text/rtf format -->

<P><FONT FACE=3D"Arial">Hi there,</FONT>

<BR><FONT FACE=3D"Arial">i get Error Messages in my logfiles when I boot =
the System and then, approx. every 10 Minutes, or during an =
hwinfo.</FONT>

<BR><FONT FACE=3D"Arial">The Server is connected to an EMC CX 300 =
through 1 Qlogic HBA.</FONT>

<BR><FONT FACE=3D"Arial">The Messages only appear for the failover =
Device. In my Example for /dev/sdh. </FONT>
</P>

<P><FONT FACE=3D"Arial">#multipath -ld</FONT>

<BR><FONT FACE=3D"Arial">sapdata =
(36006016040321900600487993216db11)</FONT>

<BR><FONT FACE=3D"Arial">[size=3D133 GB][features=3D&quot;1 =
queue_if_no_path&quot;][hwhandler=3D&quot;1 emc&quot;]</FONT>

<BR><FONT FACE=3D"Arial">\_ round-robin 0 [active]</FONT>

<BR><FONT FACE=3D"Arial">&nbsp;\_ 3:0:1:6 sdp 8:240 =
[active][ready]</FONT>

<BR><FONT FACE=3D"Arial">\_ round-robin 0 [enabled]</FONT>

<BR><FONT FACE=3D"Arial">&nbsp;\_ 3:0:0:6 sdh 8:112 =
[active][ready]</FONT>

<BR><FONT FACE=3D"Arial">*snip*</FONT>
</P>

<P><FONT FACE=3D"Arial">#fdisk -l /dev/sdp</FONT>

<BR><FONT FACE=3D"Arial">Disk /dev/sdp: 143.0 GB, 143034155008 =
bytes</FONT>

<BR><FONT FACE=3D"Arial">255 heads, 63 sectors/track, 17389 =
cylinders</FONT>

<BR><FONT FACE=3D"Arial">Units =3D cylinders of 16065 * 512 =3D 8225280 =
bytes</FONT>
</P>

<P><FONT FACE=3D"Arial">&nbsp;&nbsp; Device =
Boot&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
Start&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
End&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Blocks&nbsp;&nbsp; Id&nbsp; =
System</FONT>

<BR><FONT =
FACE=3D"Arial">/dev/sdp1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 17389&nbsp;&nbsp; =
139677111&nbsp;&nbsp; 83&nbsp; Linux</FONT>
</P>

<P><FONT FACE=3D"Arial">#fdisk -l /dev/sdh</FONT>

<BR><FONT FACE=3D"Arial">--&gt; Generates this Error in =
/var/log/messages</FONT>

<BR><FONT FACE=3D"Arial">Sep 27 12:17:44 saptf2 kernel: end_request: I/O =
error, dev sdh, sector 0</FONT>

<BR><FONT FACE=3D"Arial">Sep 27 12:17:44 saptf2 kernel: Buffer I/O error =
on device sdh, logical block 0</FONT>
</P>
<BR>

<P><FONT FACE=3D"Arial">Configuration:</FONT>

<BR><FONT FACE=3D"Arial">/etc/multipath.conf</FONT>

<BR><FONT FACE=3D"Arial">defaults {</FONT>

<BR><FONT FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
default_features &quot;1 queue_if_no_path&quot;</FONT>

<BR><FONT FACE=3D"Arial">}</FONT>
</P>

<P><FONT FACE=3D"Arial">multipaths {</FONT>

<BR><FONT FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
multipath</FONT>

<BR><FONT FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
{</FONT>

<BR><FONT =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; #mountpoint /sapdb/PF1/sapdata</FONT>

<BR><FONT =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; wwid =
36006016040321900600487993216db11</FONT>

<BR><FONT =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; alias sapdata</FONT>

<BR><FONT FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
}</FONT>

<BR><FONT FACE=3D"Arial">*snip* (some more aliases for other LUNs) =
*snip*</FONT>

<BR><FONT FACE=3D"Arial">}</FONT>

<BR><FONT FACE=3D"Arial">devices {</FONT>

<BR><FONT FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
device {</FONT>

<BR><FONT =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
vendor&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &quot;DGC&nbsp; &quot;</FONT>

<BR><FONT =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
product&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &quot;*&quot;</FONT>

<BR><FONT =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; path_grouping_policy&nbsp;&nbsp;&nbsp; =
group_by_prio</FONT>

<BR><FONT =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
getuid_callout&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&quot;/sbin/scsi_id -g -u -s /block/%n&quot;</FONT>

<BR><FONT =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
path_checker&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; emc_clariion</FONT>

<BR><FONT =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
features&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; &quot;1 queue_if_no_path&quot;</FONT>

<BR><FONT =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
hardware_handler&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &quot;1 =
emc&quot;</FONT>

<BR><FONT =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
failback&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; immediate</FONT>

<BR><FONT =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
prio_callout&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; &quot;/sbin/mpath_prio_emc /dev/%n&quot;</FONT>

<BR><FONT =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
no_path_retry&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
 300</FONT>

<BR><FONT FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
}</FONT>

<BR><FONT FACE=3D"Arial">}</FONT>
</P>

<P><FONT FACE=3D"Arial">Loaded Modules:</FONT>

<BR><FONT =
FACE=3D"Arial">dm_emc&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 23808&nbsp; 1</FONT>

<BR><FONT =
FACE=3D"Arial">dm_round_robin&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; 20480&nbsp; 1</FONT>

<BR><FONT =
FACE=3D"Arial">dm_multipath&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp; 38800&nbsp; 3 dm_emc,dm_round_robin</FONT>

<BR><FONT =
FACE=3D"Arial">dm_mod&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 77536&nbsp; 23 =
dm_multipath</FONT>

<BR><FONT =
FACE=3D"Arial">qla2300&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 141696&nbsp; 0</FONT>

<BR><FONT =
FACE=3D"Arial">qla2xxx&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 356192&nbsp; 33 qla2300</FONT>
</P>

<P><FONT FACE=3D"Arial">#modinfo qla2300</FONT>

<BR><FONT =
FACE=3D"Arial">version:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
8.01.02-sles DBB4213CE377B7165AFB8AC</FONT>
</P>

<P><FONT FACE=3D"Arial">#modinfo qla2xxx</FONT>

<BR><FONT =
FACE=3D"Arial">version:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
8.01.02-sles F6D31250031AEB3A3B9138A</FONT>
</P>

<P><FONT FACE=3D"Arial">Kernel: </FONT>

<BR><FONT FACE=3D"Arial">2.6.5-7.282-smp X86_64</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Arial">I searched the mailing Lists for other =
examples, but i didnt find any Suggestions to solve this.</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">Thanks for help!</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">Regarding </FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">Manuel Herr</FONT>
</P>
<BR>

</BODY>
</HTML>
------_=_NextPart_001_01C6E21F.7554D82F--


--===============0711449156==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0711449156==--
