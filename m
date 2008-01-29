From: <LittleJ@AE.com>
Subject: Problem using dm-multipath on first of 2 LUNs on system
Date: Tue, 29 Jan 2008 10:42:50 -0500
Message-ID: <08F3F42DB42FBF4E87512A3AB4596D4A03F72CBF@HERSHEY.aeo.ae.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2078430707=="
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

--===============2078430707==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C8628D.9AB119D0"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C8628D.9AB119D0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

I am attempting to implement dm-multipath on a RHEL4U6 server and I have
been successful in enabling it on the second of 2 LUNs on the server but
for whatever reason it will not create the device special files in
/dev/mapper for the fist LUN.  `multipath -d` shows that it identifies
the first LUN and wants to create the mpath0 files:

=20

[root@svwdcvispay01 etc]# multipath -d

create: mpath0 (36005076801810085c800000000000194)

[size=3D12 GB][features=3D"1 queue_if_no_path"][hwhandler=3D"0"]

\_ round-robin 0 [prio=3D50]

 \_ 1:0:0:0 sda 8:0  [ready]

\_ round-robin 0 [prio=3D10]

 \_ 1:0:1:0 sdc 8:32 [ready]

=20

switchpg: mpath1 (36005076801810085c8000000000001a2)

[size=3D50 GB][features=3D"1 queue_if_no_path"][hwhandler=3D"0"]

\_ round-robin 0 [prio=3D50]

 \_ 1:0:1:1 sdd 8:48 [active][ready]

\_ round-robin 0 [prio=3D10]

 \_ 1:0:0:1 sdb 8:16 [active][ready]

=20

[root@svwdcvispay01 etc]#

=20

=20

However `multipath -v3` generates a "set ACT_CREATE: map does not
exists" error in the mpath0 section:

=20

[root@svwdcvispay01 etc]# multipath -v3

load path identifiers cache

#

# all paths in cache :

#

36005076801810085c800000000000194  1:0:0:0 sda 8:0   IBM     /2145

36005076801810085c8000000000001a2  1:0:0:1 sdb 8:16 10 [active] IBM
/2145

36005076801810085c800000000000194  1:0:1:0 sdc 8:32   IBM     /2145

36005076801810085c8000000000001a2  1:0:1:1 sdd 8:48 50 [active] IBM
/2145

dm-0 blacklisted

dm-1 blacklisted

dm-2 blacklisted

dm-3 blacklisted

dm-4 blacklisted

md0 blacklisted

ram0 blacklisted

ram10 blacklisted

ram11 blacklisted

ram12 blacklisted

ram13 blacklisted

ram14 blacklisted

ram15 blacklisted

ram1 blacklisted

ram2 blacklisted

ram3 blacklisted

ram4 blacklisted

ram5 blacklisted

ram6 blacklisted

ram7 blacklisted

ram8 blacklisted

ram9 blacklisted

=3D=3D=3D=3D=3D path info sda (mask 0x1f) =3D=3D=3D=3D=3D

bus =3D 1

dev_t =3D 8:0

size =3D 25165824

vendor =3D IBM

product =3D 2145

rev =3D 0000

h:b:t:l =3D 1:0:0:0

tgt_node_name =3D 0x50050768010010b9

serial =3D 020060402172XX00

path checker =3D tur (controler setting)

state =3D 2

getprio =3D /sbin/mpath_prio_alua /dev/%n (controler setting)

prio =3D 50

uid =3D 36005076801810085c800000000000194 (cache)

=3D=3D=3D=3D=3D path info sdb (mask 0x1f) =3D=3D=3D=3D=3D

bus =3D 1

dev_t =3D 8:16

size =3D 104857600

vendor =3D IBM

product =3D 2145

rev =3D 0000

h:b:t:l =3D 1:0:0:1

tgt_node_name =3D 0x50050768010010b9

serial =3D 020060402172XX00

path checker =3D tur (controler setting)

state =3D 2

getprio =3D /sbin/mpath_prio_alua /dev/%n (controler setting)

prio =3D 10

uid =3D 36005076801810085c8000000000001a2 (cache)

=3D=3D=3D=3D=3D path info sdc (mask 0x1f) =3D=3D=3D=3D=3D

bus =3D 1

dev_t =3D 8:32

size =3D 25165824

vendor =3D IBM

product =3D 2145

rev =3D 0000

h:b:t:l =3D 1:0:1:0

tgt_node_name =3D 0x5005076801001082

serial =3D 020060402172XX00

path checker =3D tur (controler setting)

state =3D 2

getprio =3D /sbin/mpath_prio_alua /dev/%n (controler setting)

prio =3D 10

uid =3D 36005076801810085c800000000000194 (cache)

=3D=3D=3D=3D=3D path info sdd (mask 0x1f) =3D=3D=3D=3D=3D

bus =3D 1

dev_t =3D 8:48

size =3D 104857600

vendor =3D IBM

product =3D 2145

rev =3D 0000

h:b:t:l =3D 1:0:1:1

tgt_node_name =3D 0x5005076801001082

serial =3D 020060402172XX00

path checker =3D tur (controler setting)

state =3D 2

getprio =3D /sbin/mpath_prio_alua /dev/%n (controler setting)

prio =3D 50

uid =3D 36005076801810085c8000000000001a2 (cache)

#

# all paths :

#

36005076801810085c800000000000194  1:0:0:0 sda 8:0 50 [ready] IBM
/2145

36005076801810085c8000000000001a2  1:0:0:1 sdb 8:16 10 [active][ready]
IBM

36005076801810085c800000000000194  1:0:1:0 sdc 8:32 10 [ready] IBM
/2145

36005076801810085c8000000000001a2  1:0:1:1 sdd 8:48 50 [active][ready]
IBM

params =3D 1 queue_if_no_path 0 2 1 round-robin 0 1 1 8:48 1000
round-robin 0 1 1 8:16 1000

status =3D 1 0 0 2 1 A 0 1 0 8:48 A 0 E 0 1 0 8:16 A 0

Found matching wwid [36005076801810085c800000000000194] in bindings
file.

Setting alias to mpath0

pgpolicy =3D group_by_prio (controler setting)

selector =3D round-robin 0 (internal default)

features =3D 1 queue_if_no_path (controler setting)

hwhandler =3D 0 (controler setting)

rr_weight =3D 1 (internal default)

rr_min_io =3D 1000 (config file default)

no_path_retry =3D NONE (internal default)

pg_timeout =3D NONE (internal default)

0 25165824 multipath 1 queue_if_no_path 0 2 1 round-robin 0 1 1 8:0 1000
round-robin 0 1 1 8:32 1000

set ACT_CREATE: map does not exists

Found matching wwid [36005076801810085c8000000000001a2] in bindings
file.

Setting alias to mpath1

pgpolicy =3D group_by_prio (controler setting)

selector =3D round-robin 0 (internal default)

features =3D 1 queue_if_no_path (controler setting)

hwhandler =3D 0 (controler setting)

rr_weight =3D 1 (internal default)

rr_min_io =3D 1000 (config file default)

no_path_retry =3D NONE (internal default)

pg_timeout =3D NONE (internal default)

0 104857600 multipath 1 queue_if_no_path 0 2 1 round-robin 0 1 1 8:48
1000 round-robin 0 1 1 8:16 1000

set ACT_NOTHING: map unchanged

[root@svwdcvispay01 etc]#

=20

=20

And notice that no /dev/mapper/mpath0 device special files were created:

=20

[root@svwdcvispay01 etc]# ls -la /dev/mapper

total 0

drwxr-xr-x  2 root root     160 Jan 29 09:53 .

drwxr-xr-x  9 root root    4900 Jan 29 09:51 ..

crw-------  1 root root  10, 63 Jan 21 16:15 control

brw-rw----  1 root disk 253,  0 Jan 21 16:15 mpath1

brw-rw----  1 root disk 253,  1 Jan 21 16:15 mpath1p1

brw-rw----  1 root disk 253,  2 Jan 21 16:15 mpath1p2

brw-rw----  1 root disk 253,  3 Jan 21 16:15 mpath1p3

brw-rw----  1 root disk 253,  4 Jan 21 16:15 mpath1p5

[root@svwdcvispay01 etc]#

=20

My /etc/multipath.conf file is basic but I have tried creating an alias
entry that looks like "multipaths {multipath {wwid
36005076801810085c800000000000194 alias os}}" for the first LUN but the
results are the same, it still won't create any device special files for
the first LUN.

=20

[root@svwdcvispay01 mapper]# cat /etc/multipath.conf | grep -v "#"

=20

defaults {

        user_friendly_names yes

}

=20

[root@svwdcvispay01 mapper]#

=20

I have been working this issue for over a week with IBM and RedHat tech
support and they have been unhelpful.  I need to get this functional
because the server in question has been unstable using a single path to
the SAN due to stability issues we have had periodically with one of the
SAN Volume Controllers.  If additional information is needed to
troubleshoot this please let me know.

=20

Joe little

littlej@ae.com

=20


------_=_NextPart_001_01C8628D.9AB119D0
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns=3D"http://www.w3.org/TR/REC-html40">

<head>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3Dus-ascii">
<meta name=3DGenerator content=3D"Microsoft Word 11 (filtered medium)">
<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:Verdana;
	panose-1:2 11 6 4 3 5 4 4 2 4;}
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
pre
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:10.0pt;
	font-family:"Courier New";
	color:black;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:Verdana;
	color:windowtext;
	font-weight:normal;
	font-style:normal;
	text-decoration:none none;}
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

<p class=3DMsoNormal><font size=3D2 face=3DVerdana><span =
style=3D'font-size:10.0pt;
font-family:Verdana'>I am attempting to implement dm-multipath on a =
RHEL4U6
server and I have been successful in enabling it on the second of 2 LUNs =
on the
server but for whatever reason it will not create the device special =
files in
/dev/mapper for the fist LUN.&nbsp; `multipath &#8211;d` shows that it =
identifies
the first LUN and wants to create the mpath0 =
files:<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DVerdana><span =
style=3D'font-size:10.0pt;
font-family:Verdana'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>[root@svwdcvispay01 etc]# multipath =
-d<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>create: mpath0 =
(36005076801810085c800000000000194)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>[size=3D12 GB][features=3D&quot;1
queue_if_no_path&quot;][hwhandler=3D&quot;0&quot;]<o:p></o:p></span></fon=
t></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>\_ round-robin 0 =
[prio=3D50]<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>&nbsp;\_ 1:0:0:0 sda 8:0&nbsp; =
[ready]<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>\_ round-robin 0 =
[prio=3D10]<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>&nbsp;\_ 1:0:1:0 sdc 8:32 =
[ready]<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>switchpg: mpath1 =
(36005076801810085c8000000000001a2)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>[size=3D50 GB][features=3D&quot;1
queue_if_no_path&quot;][hwhandler=3D&quot;0&quot;]<o:p></o:p></span></fon=
t></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>\_ round-robin 0 =
[prio=3D50]<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>&nbsp;\_ 1:0:1:1 sdd 8:48 =
[active][ready]<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>\_ round-robin 0 =
[prio=3D10]<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>&nbsp;\_ 1:0:0:1 sdb 8:16 =
[active][ready]<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>[root@svwdcvispay01 =
etc]#<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DVerdana><span =
style=3D'font-size:10.0pt;
font-family:Verdana'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DVerdana><span =
style=3D'font-size:10.0pt;
font-family:Verdana'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DVerdana><span =
style=3D'font-size:10.0pt;
font-family:Verdana'>However `multipath &#8211;v3` generates a =
&#8220;</span></font><font
size=3D2 face=3DVerdana><span =
style=3D'font-size:10.0pt;font-family:Verdana'>set
ACT_CREATE: map does not exists&#8221; error in the mpath0 =
section:<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DVerdana><span =
style=3D'font-size:10.0pt;
font-family:Verdana'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>[root@svwdcvispay01 etc]# multipath =
-v3<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>load path identifiers =
cache<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>#<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'># all paths in cache =
:<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>#<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>36005076801810085c800000000000194&nbsp; =
1:0:0:0 sda 8:0&nbsp;&nbsp;
IBM&nbsp;&nbsp;&nbsp;&nbsp; /2145<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>36005076801810085c8000000000001a2&nbsp; =
1:0:0:1 sdb 8:16
10 [active] IBM&nbsp;&nbsp;&nbsp;&nbsp; =
/2145<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>36005076801810085c800000000000194&nbsp; =
1:0:1:0 sdc
8:32&nbsp;&nbsp; IBM&nbsp;&nbsp;&nbsp;&nbsp; =
/2145<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>36005076801810085c8000000000001a2&nbsp; =
1:0:1:1 sdd 8:48
50 [active] IBM&nbsp;&nbsp;&nbsp;&nbsp; =
/2145<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>dm-0 blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>dm-1 blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>dm-2 blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>dm-3 blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>dm-4 blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>md0 blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>ram0 blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>ram10 =
blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>ram11 =
blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>ram12 =
blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>ram13 =
blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>ram14 =
blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>ram15 =
blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>ram1 blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>ram2 blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>ram3 blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>ram4 blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>ram5 blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>ram6 blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>ram7 blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>ram8 blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>ram9 blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>=3D=3D=3D=3D=3D path info sda (mask 0x1f) =
=3D=3D=3D=3D=3D<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>bus =3D 1<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>dev_t =3D 8:0<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>size =3D =
25165824<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>vendor =3D IBM<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>product =3D 2145<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>rev =3D 0000<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>h:b:t:l =3D =
1:0:0:0<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>tgt_node_name =3D =
0x50050768010010b9<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>serial =3D =
020060402172XX00<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>path checker =3D tur (controler =
setting)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>state =3D 2<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>getprio =3D /sbin/mpath_prio_alua /dev/%n =
(controler
setting)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>prio =3D 50<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>uid =3D 36005076801810085c800000000000194 =
(cache)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>=3D=3D=3D=3D=3D path info sdb (mask 0x1f) =
=3D=3D=3D=3D=3D<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>bus =3D 1<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>dev_t =3D 8:16<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>size =3D =
104857600<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>vendor =3D IBM<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>product =3D 2145<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>rev =3D 0000<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>h:b:t:l =3D =
1:0:0:1<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>tgt_node_name =3D =
0x50050768010010b9<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>serial =3D =
020060402172XX00<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>path checker =3D tur (controler =
setting)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>state =3D 2<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>getprio =3D /sbin/mpath_prio_alua /dev/%n =
(controler
setting)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>prio =3D 10<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>uid =3D 36005076801810085c8000000000001a2 =
(cache)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>=3D=3D=3D=3D=3D path info sdc (mask 0x1f) =
=3D=3D=3D=3D=3D<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>bus =3D 1<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>dev_t =3D 8:32<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>size =3D =
25165824<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>vendor =3D IBM<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>product =3D 2145<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>rev =3D 0000<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>h:b:t:l =3D =
1:0:1:0<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>tgt_node_name =3D =
0x5005076801001082<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>serial =3D =
020060402172XX00<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>path checker =3D tur (controler =
setting)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>state =3D 2<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>getprio =3D /sbin/mpath_prio_alua /dev/%n =
(controler
setting)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>prio =3D 10<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>uid =3D 36005076801810085c800000000000194 =
(cache)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>=3D=3D=3D=3D=3D path info sdd (mask 0x1f) =
=3D=3D=3D=3D=3D<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>bus =3D 1<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>dev_t =3D 8:48<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>size =3D =
104857600<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>vendor =3D IBM<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>product =3D 2145<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>rev =3D 0000<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>h:b:t:l =3D =
1:0:1:1<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>tgt_node_name =3D =
0x5005076801001082<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>serial =3D =
020060402172XX00<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>path checker =3D tur (controler =
setting)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>state =3D 2<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>getprio =3D /sbin/mpath_prio_alua /dev/%n =
(controler
setting)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>prio =3D 50<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>uid =3D 36005076801810085c8000000000001a2 =
(cache)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>#<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'># all paths :<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>#<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>36005076801810085c800000000000194&nbsp; =
1:0:0:0 sda 8:0
50 [ready] IBM&nbsp;&nbsp;&nbsp;&nbsp; =
/2145<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>36005076801810085c8000000000001a2&nbsp; =
1:0:0:1 sdb 8:16
10 [active][ready] IBM<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>36005076801810085c800000000000194&nbsp; =
1:0:1:0 sdc 8:32
10 [ready] IBM&nbsp;&nbsp;&nbsp;&nbsp; =
/2145<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>36005076801810085c8000000000001a2&nbsp; =
1:0:1:1 sdd 8:48
50 [active][ready] IBM<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>params =3D 1 queue_if_no_path 0 2 1 =
round-robin 0 1 1
8:48 1000 round-robin 0 1 1 8:16 1000<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>status =3D 1 0 0 2 1 A 0 1 0 8:48 A 0 E 0 1 0 =
8:16 A 0<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>Found matching wwid
[36005076801810085c800000000000194] in bindings =
file.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>Setting alias to =
mpath0<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>pgpolicy =3D group_by_prio (controler =
setting)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>selector =3D round-robin 0 (internal =
default)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>features =3D 1 queue_if_no_path (controler =
setting)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>hwhandler =3D 0 (controler =
setting)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>rr_weight =3D 1 (internal =
default)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>rr_min_io =3D 1000 (config file =
default)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>no_path_retry =3D NONE (internal =
default)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>pg_timeout =3D NONE (internal =
default)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>0 25165824 multipath 1 queue_if_no_path 0 2 1
round-robin 0 1 1 8:0 1000 round-robin 0 1 1 8:32 =
1000<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>set ACT_CREATE: map does not =
exists<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>Found matching wwid =
[36005076801810085c8000000000001a2]
in bindings file.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>Setting alias to =
mpath1<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>pgpolicy =3D group_by_prio (controler =
setting)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>selector =3D round-robin 0 (internal =
default)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>features =3D 1 queue_if_no_path (controler =
setting)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>hwhandler =3D 0 (controler =
setting)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>rr_weight =3D 1 (internal =
default)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>rr_min_io =3D 1000 (config file =
default)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>no_path_retry =3D NONE (internal =
default)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>pg_timeout =3D NONE (internal =
default)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>0 104857600 multipath 1 queue_if_no_path 0 2 =
1
round-robin 0 1 1 8:48 1000 round-robin 0 1 1 8:16 =
1000<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>set ACT_NOTHING: map =
unchanged<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>[root@svwdcvispay01 =
etc]#<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DVerdana><span =
style=3D'font-size:10.0pt;
font-family:Verdana'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DVerdana><span =
style=3D'font-size:10.0pt;
font-family:Verdana'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DVerdana><span =
style=3D'font-size:10.0pt;
font-family:Verdana'>And notice that no /dev/mapper/mpath0 device =
special files
were created:<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DVerdana><span =
style=3D'font-size:10.0pt;
font-family:Verdana'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>[root@svwdcvispay01 etc]# ls -la =
/dev/mapper<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>total 0<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>drwxr-xr-x&nbsp; 2 root =
root&nbsp;&nbsp;&nbsp;&nbsp; 160 Jan 29 09:53 =
.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>drwxr-xr-x&nbsp; 9 root =
root&nbsp;&nbsp;&nbsp; 4900 Jan 29 09:51 ..<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>crw-------&nbsp; 1 root root&nbsp; 10, 63 Jan =
21 16:15 control<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>brw-rw----&nbsp; 1 root disk 253,&nbsp; 0 Jan =
21 16:15 mpath1<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>brw-rw----&nbsp; 1 root disk 253,&nbsp; 1 Jan =
21 16:15
mpath1p1<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>brw-rw----&nbsp; 1 root disk 253,&nbsp; 2 Jan =
21 16:15
mpath1p2<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>brw-rw----&nbsp; 1 root disk 253,&nbsp; 3 Jan =
21 16:15
mpath1p3<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>brw-rw----&nbsp; 1 root disk 253,&nbsp; 4 Jan =
21 16:15
mpath1p5<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>[root@svwdcvispay01 =
etc]#<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DVerdana><span =
style=3D'font-size:10.0pt;
font-family:Verdana'><o:p>&nbsp;</o:p></span></font></p>

<pre><font size=3D2 color=3Dblack face=3DVerdana><span =
style=3D'font-size:10.0pt;
font-family:Verdana'>My /etc/multipath.conf file is basic but I have =
tried creating an alias entry that looks like</span></font> =
&#8220;multipaths {multipath {wwid&nbsp;&nbsp; =
36005076801810085c800000000000194 alias os}}&#8221;<font
face=3DVerdana><span style=3D'font-family:Verdana'> for the first LUN =
but the results are the same, it still won&#8217;t create any device =
special files for the first LUN.</span></font><o:p></o:p></pre>

<p class=3DMsoNormal><font size=3D2 face=3DVerdana><span =
style=3D'font-size:10.0pt;
font-family:Verdana'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>[root@svwdcvispay01 mapper]# cat =
/etc/multipath.conf
| grep -v &quot;#&quot;<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>defaults {<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
user_friendly_names yes<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>}<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>[root@svwdcvispay01 =
mapper]#<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DVerdana><span =
style=3D'font-size:10.0pt;
font-family:Verdana'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DVerdana><span =
style=3D'font-size:10.0pt;
font-family:Verdana'>I have been working this issue for over a week with =
IBM
and RedHat tech support and they have been unhelpful.&nbsp; I need to =
get this
functional because the server in question has been unstable using a =
single path
to the SAN due to stability issues we have had periodically with one of =
the SAN
Volume Controllers.&nbsp; If additional information is needed to =
troubleshoot this
please let me know.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DVerdana><span =
style=3D'font-size:10.0pt;
font-family:Verdana'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DVerdana><span =
style=3D'font-size:10.0pt;
font-family:Verdana'>Joe little<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DVerdana><span =
style=3D'font-size:10.0pt;
font-family:Verdana'><a =
href=3D"mailto:littlej@ae.com">littlej@ae.com</a><o:p></o:p></span></font=
></p>

<p class=3DMsoNormal><font size=3D2 face=3DVerdana><span =
style=3D'font-size:10.0pt;
font-family:Verdana'><o:p>&nbsp;</o:p></span></font></p>

</div>

</body>

</html>

------_=_NextPart_001_01C8628D.9AB119D0--


--===============2078430707==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2078430707==--
