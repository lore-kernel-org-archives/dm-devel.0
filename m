From: "Allen, Jack" <Jack.Allen@mckesson.com>
Subject: General and configuration questions
Date: Fri, 28 May 2010 17:16:34 -0400
Message-ID: <230ED15F81AFD3409345FFA4E565F0E50A978AA3@NDHV3000.na.corp.mckesson.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2365635258253547714=="
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.

--===============2365635258253547714==
Content-class: urn:content-classes:message
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01CAFEAB.0D8F319C"

This is a multi-part message in MIME format.

------_=_NextPart_001_01CAFEAB.0D8F319C
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hello:=20
        I have a system with 2 paths to the SAN which is HITACHI HP. =
The
output of multipath -ll is:=20

mpath2 (360060e8005491000000049100000700a) dm-1 HP,OPEN-V=20
[size=3D10G][features=3D1 queue_if_no_path][hwhandler=3D0][rw]=20
\_ round-robin 0 [prio=3D2][active]=20
 \_ 3:0:0:1 sdc 8:32  [active][ready]=20
 \_ 4:0:0:1 sde 8:64  [active][ready]=20
mpath1 (360060e80054910000000491000007003) dm-0 HP,OPEN-V=20
[size=3D10G][features=3D1 queue_if_no_path][hwhandler=3D0][rw]=20
\_ round-robin 0 [prio=3D2][active]=20
 \_ 3:0:0:0 sdb 8:16  [active][ready]=20
 \_ 4:0:0:0 sdd 8:48  [active][ready]=20


        If I run multipathd -k and do show config, there is a lot of =
out
put but I think the key things are:=20

defaults {=20
        verbosity 2=20
        polling_interval 10=20
        path_grouping_policy multibus=20
        failback 5=20
        rr_min_io 10=20
        no_path_retry 5=20
        user_friendly_names yes=20
        bindings_file /etc/multipath.bindings=20
}=20


devices {=20
        LOTS OF DEVICE ENTRIES.=20

        device {=20
                vendor (HITACHI|HP)=20
                product OPEN-.*=20
                path_checker tur=20
                failback immediate=20
                no_path_retry 12=20
                rr_min_io 1000=20
        }=20
}=20

        The device entry for the SAN has rr_min_io set to 1000. I added
rr_min_io 10 in the default, but per the man page for multipath.conf
entries in the defaults will only be used if they do not appear other
places.

Q1) If I want to over ride the rr_min_io value in the devices/device
section can I just add a devices/device section in /etc./multipath.conf
with the things I want to change or do I have to duplicate everything
that is in the built-in devices/device entry?

Q2) How can I determine the best value for rr_min_io?=20
        I assume whom ever added the HITACHI|HP devices/device built-in
entry decide on the value=20
        of 1000 for a reason. Maybe they did benchmarks or maybe they
just copied another entry=20
        that was some what like what they needed and changed the vendor
and product.=20


I am sure I will have more questions depending on the answers I get to
these questions.=20

-----=20
Jack Allen=20



------_=_NextPart_001_01CAFEAB.0D8F319C
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
<HTML>
<HEAD>

<META NAME=3D"Generator" CONTENT=3D"MS Exchange Server version =
6.5.7655.4">
<TITLE>General and configuration questions</TITLE>
</HEAD>
<BODY>
<!-- Converted from text/rtf format -->

<P><FONT SIZE=3D2 FACE=3D"Arial">Hello:</FONT>

<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <FONT SIZE=3D2 =
FACE=3D"Arial">I have a system with 2 paths to the SAN which is HITACHI =
HP. The output of multipath -ll is:</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Arial">mpath2 =
(360060e8005491000000049100000700a) dm-1 HP,OPEN-V</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">[size=3D10G][features=3D1 =
queue_if_no_path][hwhandler=3D0][rw]</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">\_ round-robin 0 =
[prio=3D2][active]</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">&nbsp;\_ 3:0:0:1 sdc 8:32&nbsp; =
[active][ready]</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">&nbsp;\_ 4:0:0:1 sde 8:64&nbsp; =
[active][ready]</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">mpath1 =
(360060e80054910000000491000007003) dm-0 HP,OPEN-V</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">[size=3D10G][features=3D1 =
queue_if_no_path][hwhandler=3D0][rw]</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">\_ round-robin 0 =
[prio=3D2][active]</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">&nbsp;\_ 3:0:0:0 sdb 8:16&nbsp; =
[active][ready]</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">&nbsp;\_ 4:0:0:0 sdd 8:48&nbsp; =
[active][ready]</FONT>
</P>
<BR>

<P>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <FONT SIZE=3D2 =
FACE=3D"Arial">If I run multipathd -k and do show config, there is a =
lot of out put but I think the key things are: </FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Arial">defaults {</FONT>

<BR><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; verbosity =
2</FONT>

<BR><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
polling_interval 10</FONT>

<BR><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
path_grouping_policy multibus</FONT>

<BR><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; failback =
5</FONT>

<BR><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rr_min_io =
10</FONT>

<BR><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; no_path_retry =
5</FONT>

<BR><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
user_friendly_names yes</FONT>

<BR><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bindings_file =
/etc/multipath.bindings</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">}</FONT>
</P>
<BR>

<P><FONT SIZE=3D2 FACE=3D"Arial">devices {</FONT>

<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <FONT SIZE=3D2 =
FACE=3D"Arial">LOTS OF DEVICE ENTRIES.</FONT>
</P>

<P><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; device =
{</FONT>

<BR><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; vendor (HITACHI|HP)</FONT>

<BR><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; product OPEN-.*</FONT>

<BR><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; path_checker tur</FONT>

<BR><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; failback immediate</FONT>

<BR><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; no_path_retry 12</FONT>

<BR><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rr_min_io 1000</FONT>

<BR><FONT SIZE=3D2 =
FACE=3D"Arial">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">}</FONT>
</P>

<P>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <FONT SIZE=3D2 =
FACE=3D"Arial">The device entry for the SAN has rr_min_io set to 1000. =
I added rr_min_io 10 in the default, but per the man page for =
multipath.conf entries in the defaults will only be used if they do not =
appear other places.</FONT></P>

<P><FONT SIZE=3D2 FACE=3D"Arial">Q1) If I want to over ride the =
rr_min_io value in the devices/device section can I just add a =
devices/device section in /etc./multipath.conf with the things I want =
to change or do I have to duplicate everything that is in the built-in =
devices/device entry?</FONT></P>

<P><FONT SIZE=3D2 FACE=3D"Arial">Q2) How can I determine the best value =
for rr_min_io?</FONT>

<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <FONT SIZE=3D2 =
FACE=3D"Arial">I assume whom ever added the HITACHI|HP devices/device =
built-in entry decide on the value</FONT>

<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <FONT SIZE=3D2 =
FACE=3D"Arial">of 1000 for a reason. Maybe they did benchmarks or maybe =
they just copied another entry</FONT>

<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <FONT SIZE=3D2 =
FACE=3D"Arial">that was some what like what they needed and changed the =
vendor and product.</FONT>
</P>
<BR>

<P><FONT SIZE=3D2 FACE=3D"Arial">I am sure I will have more questions =
depending on the answers I get to these questions.</FONT>
</P>

<P><FONT SIZE=3D2 FACE=3D"Arial">-----</FONT>

<BR><FONT SIZE=3D2 FACE=3D"Arial">Jack Allen</FONT>
</P>
<BR>

</BODY>
</HTML>
------_=_NextPart_001_01CAFEAB.0D8F319C--


--===============2365635258253547714==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2365635258253547714==--
