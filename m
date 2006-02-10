From: "Child, David" <David.Child@ps.net>
Subject: Multipathing with RHEL4 U2 on EMC DMX
Date: Fri, 10 Feb 2006 08:48:07 -0600
Message-ID: <2CF4E90F20CF3C4DBD3A71BD9FA2758D122F66@PSCDALPEXCH03.perotsystems.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0525598229=="
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

--===============0525598229==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C62E51.0189A9BC"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C62E51.0189A9BC
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hello,

I've just recently connected some HP BL20p G3 blades running RHEL4 U2 up
to a DMX2000 (via McData switches). We didn't get PowerPath and intended
to use device-mapper multipathing. I was able to get things up for the
most part and get devices defined, but have to do that manually. I've
run into a few issues/concerns that I was hoping someone had run across;

Kernel: 2.6.9-22.Elsmp
Multipath tools: multipath-tools-0.4.6.1-1
Device Mapper: device-mapper-1.01.05-01

1. When running 'multipath -v3' I get errors from the getuid_callout
string; "error calling out scsi_id -g -ppre-spc3-83 -u -s /block/sdb".
It doesn't like the "-ppre-spc3-83" part. After some research it appears
that for the DMX (Symmetrix) a more appropriate string would be
"/sbin/scsi_id -g -p 0x80 -u -s /block/sdb". I tried adding that into
the 'defaults' section of /etc/multipath.conf, but it doesn't appear to
pick it up. I've tried restarting multipathd, rebooting, etc. Is there
anyway to get it to take this string? I believe that is part of the
problem I'm having with the next item (#2).

2. In order to have multipath working for my EMC devices I have to
manually create them on system reboot. I simply created a new startup
script for this. Basically I just do; 'echo "0 17677440 multipath 0 0 2
1 round-robin 0 1 1 8:112 1000 round-robin 0 1 1 8:240 1000" | dmsetup
create dm0' for each device. Is that normal to have to do that or is
there a way to do this automatically? I would suspect it has to do with
having a hardware_handler. I thought about the dm-emc handler, but that
appears to only work for the CX/AX/FC family (i.e. Clariion) of arrays
which work nothing like the Symmetrix. Perhaps if I could get the
getuid_callout string working that would help.

3. Early this morning there was a problem on one of the multipath
devices used for Oracle ASM;

	SCSI error : <0 0 0 6> return code =3D 0x20000
	end_request: I/O error, dev sdd, sector 64078960
	end_request: I/O error, dev sdd, sector 64078961
	device-mapper: dm-multipath: Failing path 8:48.
	SCSI error : <1 0 0 6> return code =3D 0x20000
	end_request: I/O error, dev sdl, sector 34888112
	end_request: I/O error, dev sdl, sector 34888113
	device-mapper: dm-multipath: Failing path 8:176.

'multipath -l' showed the device as;

	dm2 ()
	[size=3D67 GB][features=3D"0"][hwhandler=3D"0"]
	\_ round-robin 0 [enabled]
	 \_ 0:0:0:6  sdd 8:48  [failed][ready]
	\_ round-robin 0 [enabled]
	 \_ 1:0:0:6  sdl 8:176 [failed][ready]

The LUNs on this server are shared between three servers and the other
two remained on-line so I know the LUN or paths to the array didn't go
out. Since the other LUNs on this server remained active I know I didn't
loose any HBA connectivity either. The DBAs said they were writing a
bunch of data to it when it dropped off line. I ran a few 'multipath'
and 'dmsetup status' commands to see what was up and it came back online
(it had been "failed" from ~3am to 7am).

Should I try using "failover" instead of "multibus" for my
"path_grouping_policy"? I would like to have it load balance, but
failover is more important.

Sorry for the long-winded post.

Any help would be appreciated.

Thanks,
David

David Child
Email  David.Child@ps.net.


------_=_NextPart_001_01C62E51.0189A9BC
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
<HTML>
<HEAD>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3Dus-ascii">
<META NAME=3D"Generator" CONTENT=3D"MS Exchange Server version =
6.5.7226.0">
<TITLE>[dm-devel] Multipathing with RHEL4 U2 on EMC DMX</TITLE>
</HEAD>
<BODY>
<!-- Converted from text/rtf format -->

<P><FONT SIZE=3D2 FACE=3D"Courier New">Hello,</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">I've just recently connected some =
HP BL20p G3 blades running RHEL4 U2 up to a DMX2000 (via McData =
switches). We didn't get PowerPath and intended to use device-mapper =
multipathing. I was able to get things up for the most part and get =
devices defined, but have to do that manually. I've run into a few =
issues/concerns that I was hoping someone had run across;</FONT></P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">Kernel: 2.6.9-22.Elsmp</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Multipath tools: =
multipath-tools-0.4.6.1-1</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Courier New">Device Mapper: =
device-mapper-1.01.05-01</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">1. When running 'multipath -v3' I =
get errors from the getuid_callout string; &quot;error calling out =
scsi_id -g -ppre-spc3-83 -u -s /block/sdb&quot;. It doesn't like the =
&quot;-ppre-spc3-83&quot; part. After some research it appears that for =
the DMX (Symmetrix) a more appropriate string would be =
&quot;/sbin/scsi_id -g -p 0x80 -u -s /block/sdb&quot;. I tried adding =
that into the 'defaults' section of /etc/multipath.conf, but it doesn't =
appear to pick it up. I've tried restarting multipathd, rebooting, etc. =
Is there anyway to get it to take this string? I believe that is part of =
the problem I'm having with the next item (#2).</FONT></P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">2. In order to have multipath =
working for my EMC devices I have to manually create them on system =
reboot. I simply created a new startup script for this. Basically I just =
do; 'echo &quot;0 17677440 multipath 0 0 2 1 round-robin 0 1 1 8:112 =
1000 round-robin 0 1 1 8:240 1000&quot; | dmsetup create dm0' for each =
device. Is that normal to have to do that or is there a way to do this =
automatically? I would suspect it has to do with having a =
hardware_handler. I thought about the dm-emc handler, but that appears =
to only work for the CX/AX/FC family (i.e. Clariion) of arrays which =
work nothing like the Symmetrix. Perhaps if I could get the =
getuid_callout string working that would help.</FONT></P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">3. Early this morning there was a =
problem on one of the multipath devices used for Oracle ASM;</FONT>
</P>

<P>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <FONT SIZE=3D2 =
FACE=3D"Courier New">SCSI error : &lt;0 0 0 6&gt; return code =3D =
0x20000</FONT>

<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <FONT SIZE=3D2 =
FACE=3D"Courier New">end_request: I/O error, dev sdd, sector =
64078960</FONT>

<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <FONT SIZE=3D2 =
FACE=3D"Courier New">end_request: I/O error, dev sdd, sector =
64078961</FONT>

<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <FONT SIZE=3D2 =
FACE=3D"Courier New">device-mapper: dm-multipath: Failing path =
8:48.</FONT>

<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <FONT SIZE=3D2 =
FACE=3D"Courier New">SCSI error : &lt;1 0 0 6&gt; return code =3D =
0x20000</FONT>

<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <FONT SIZE=3D2 =
FACE=3D"Courier New">end_request: I/O error, dev sdl, sector =
34888112</FONT>

<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <FONT SIZE=3D2 =
FACE=3D"Courier New">end_request: I/O error, dev sdl, sector =
34888113</FONT>

<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <FONT SIZE=3D2 =
FACE=3D"Courier New">device-mapper: dm-multipath: Failing path =
8:176.</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">'multipath -l' showed the device =
as;</FONT>
</P>

<P>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <FONT SIZE=3D2 =
FACE=3D"Courier New">dm2 ()</FONT>

<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <FONT SIZE=3D2 =
FACE=3D"Courier New">[size=3D67 =
GB][features=3D&quot;0&quot;][hwhandler=3D&quot;0&quot;]</FONT>

<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <FONT SIZE=3D2 =
FACE=3D"Courier New">\_ round-robin 0 [enabled]</FONT>

<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<FONT SIZE=3D2 =
FACE=3D"Courier New"> \_ 0:0:0:6&nbsp; sdd 8:48&nbsp; =
[failed][ready]</FONT>

<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <FONT SIZE=3D2 =
FACE=3D"Courier New">\_ round-robin 0 [enabled]</FONT>

<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<FONT SIZE=3D2 =
FACE=3D"Courier New"> \_ 1:0:0:6&nbsp; sdl 8:176 [failed][ready]</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">The LUNs on this server are =
shared between three servers and the other two remained on-line so I =
know the LUN or paths to the array didn't go out. Since the other LUNs =
on this server remained active I know I didn't loose any HBA =
connectivity either. The DBAs said they were writing a bunch of data to =
it when it dropped off line. I ran a few 'multipath' and 'dmsetup =
status' commands to see what was up and it came back online (it had been =
&quot;failed&quot; from ~3am to 7am).</FONT></P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">Should I try using =
&quot;failover&quot; instead of &quot;multibus&quot; for my =
&quot;path_grouping_policy&quot;? I would like to have it load balance, =
but failover is more important.</FONT></P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">Sorry for the long-winded =
post.</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Courier New">Any help would be =
appreciated.<BR>
<BR>
Thanks,<BR>
</FONT><FONT SIZE=3D2 FACE=3D"Courier New">David</FONT>
</P>

<P><B><FONT FACE=3D"Arial">David Child</FONT></B>

<BR><I><FONT COLOR=3D"#000000" SIZE=3D2 =
FACE=3D"Arial">Email&nbsp;</FONT><U> <FONT COLOR=3D"#0000FF" SIZE=3D2 =
FACE=3D"Arial">David.Child</FONT></U></I><U><FONT COLOR=3D"#0000FF" =
SIZE=3D2 FACE=3D"Arial">@ps.net</FONT></U><FONT FACE=3D"Times New =
Roman">.</FONT>
</P>

</BODY>
</HTML>
------_=_NextPart_001_01C62E51.0189A9BC--


--===============0525598229==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0525598229==--
