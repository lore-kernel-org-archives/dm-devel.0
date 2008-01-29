From: <LittleJ@AE.com>
Subject: RE: Problem using dm-multipath on first of 2 LUNs on system
Date: Tue, 29 Jan 2008 12:17:18 -0500
Message-ID: <08F3F42DB42FBF4E87512A3AB4596D4A03F72CC0@HERSHEY.aeo.ae.com>
References: <08F3F42DB42FBF4E87512A3AB4596D4A03F72CBF@HERSHEY.aeo.ae.com>
	<008b01c86298$3c1a3280$0602a8c0@sams>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0759012591=="
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <008b01c86298$3c1a3280$0602a8c0@sams>
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

--===============0759012591==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C8629A.CD5A27E8"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C8629A.CD5A27E8
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

I am not specifically blacklisting the /dev/dm-X devices.  The 5
/dev/dm-X devices on my system correspond to the 5 device special files
in /dev/mapper on the second LUN that dm-multipath is currently
managing.

=20

[root@svwdcvispay01 ~]# cd /dev/mapper

[root@svwdcvispay01 mapper]# ls -la

total 0

drwxr-xr-x  2 root root     160 Jan 29 11:47 .

drwxr-xr-x  9 root root    4900 Jan 29 11:44 ..

crw-------  1 root root  10, 63 Jan 29 11:44 control

brw-rw----  1 root disk 253,  0 Jan 29 11:44 mpath1

brw-rw----  1 root disk 253,  1 Jan 29 11:44 mpath1p1

brw-rw----  1 root disk 253,  2 Jan 29 11:44 mpath1p2

brw-rw----  1 root disk 253,  3 Jan 29 11:44 mpath1p3

brw-rw----  1 root disk 253,  4 Jan 29 11:44 mpath1p5

[root@svwdcvispay01 mapper]# ls -la /dev/dm*

brw-r-----  1 root root 253, 0 Jan 29 11:44 /dev/dm-0

brw-r-----  1 root root 253, 1 Jan 29 11:44 /dev/dm-1

brw-r-----  1 root root 253, 2 Jan 29 11:44 /dev/dm-2

brw-r-----  1 root root 253, 3 Jan 29 11:44 /dev/dm-3

brw-r-----  1 root root 253, 4 Jan 29 11:44 /dev/dm-4

[root@svwdcvispay01 mapper]#

=20

I believe that dm-multipath is internally blacklisting those devices.
Notice if I execute `dmsetup remove_all` which removes all the
/dev/mapper/mpath1* files and then recreate them that dm-multipath
creates 5 new /dev/dm-* files:

=20

[root@svwdcvispay01 mapper]# dmsetup remove_all

[root@svwdcvispay01 mapper]# ls -la

total 0

drwxr-xr-x  2 root root     60 Jan 29 12:09 .

drwxr-xr-x  9 root root   4900 Jan 29 11:44 ..

crw-------  1 root root 10, 63 Jan 29 11:44 control

=20

[root@svwdcvispay01 mapper]# ls -la /dev/dm*

brw-r-----  1 root root 253, 0 Jan 29 11:44 /dev/dm-0

brw-r-----  1 root root 253, 1 Jan 29 11:44 /dev/dm-1

brw-r-----  1 root root 253, 2 Jan 29 11:44 /dev/dm-2

brw-r-----  1 root root 253, 3 Jan 29 11:44 /dev/dm-3

brw-r-----  1 root root 253, 4 Jan 29 11:44 /dev/dm-4

=20

[root@svwdcvispay01 mapper]# multipath

create: mpath1 (36005076801810085c8000000000001a2)

[size=3D50 GB][features=3D"1 queue_if_no_path"][hwhandler=3D"0"]

\_ round-robin 0 [prio=3D50]

 \_ 1:0:1:1 sdd 8:48 [ready]

\_ round-robin 0 [prio=3D10]

 \_ 1:0:0:1 sdb 8:16 [ready]

=20

[root@svwdcvispay01 mapper]# ls -la

total 0

drwxr-xr-x  2 root root     160 Jan 29 12:09 .

drwxr-xr-x  9 root root    5000 Jan 29 12:09 ..

crw-------  1 root root  10, 63 Jan 29 11:44 control

brw-rw----  1 root disk 253,  5 Jan 29 12:09 mpath1

brw-rw----  1 root disk 253,  6 Jan 29 12:09 mpath1p1

brw-rw----  1 root disk 253,  7 Jan 29 12:09 mpath1p2

brw-rw----  1 root disk 253,  8 Jan 29 12:09 mpath1p3

brw-rw----  1 root disk 253,  9 Jan 29 12:09 mpath1p5

=20

[root@svwdcvispay01 mapper]# ls -la /dev/dm*

brw-r-----  1 root root 253, 0 Jan 29 11:44 /dev/dm-0

brw-r-----  1 root root 253, 1 Jan 29 11:44 /dev/dm-1

brw-r-----  1 root root 253, 2 Jan 29 11:44 /dev/dm-2

brw-r-----  1 root root 253, 3 Jan 29 11:44 /dev/dm-3

brw-r-----  1 root root 253, 4 Jan 29 11:44 /dev/dm-4

brw-r-----  1 root root 253, 5 Jan 29 12:09 /dev/dm-5

brw-r-----  1 root root 253, 6 Jan 29 12:09 /dev/dm-6

brw-r-----  1 root root 253, 7 Jan 29 12:09 /dev/dm-7

brw-r-----  1 root root 253, 8 Jan 29 12:09 /dev/dm-8

brw-r-----  1 root root 253, 9 Jan 29 12:09 /dev/dm-9

[root@svwdcvispay01 mapper]#=20

=20

Notice also that the blacklist has been automatically extended to cover
the 5 new /dev/dm-X devices:

=20

[root@svwdcvispay01 mapper]# multipath -v3 | more

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

dm-5 blacklisted

dm-6 blacklisted

dm-7 blacklisted

dm-8 blacklisted

dm-9 blacklisted

...

=20

When I reboot the server dm-5 through dm-9 are gone and it is again
using dm-0 through dm-4.

=20

Joe Little

littlej@ae.com

=20

=20

=20

=20

________________________________

From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of Gerald Nowitzky
Sent: Tuesday, January 29, 2008 11:59 AM
To: device-mapper development
Subject: Re: [dm-devel] Problem using dm-multipath on first of 2 LUNs on
system

=20

try and remove dm-0 to dm-4 from the blacklist. The devices in
/dev/mapper are links to /dev/dm-x

(Gerald)

	----- Original Message -----=20

	From: LittleJ@AE.com=20

	To: dm-devel@redhat.com=20

	Sent: Tuesday, January 29, 2008 4:42 PM

	Subject: [dm-devel] Problem using dm-multipath on first of 2
LUNs on system

	=20

	I am attempting to implement dm-multipath on a RHEL4U6 server
and I have been successful in enabling it on the second of 2 LUNs on the
server but for whatever reason it will not create the device special
files in /dev/mapper for the fist LUN.  `multipath -d` shows that it
identifies the first LUN and wants to create the mpath0 files:

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

	However `multipath -v3` generates a "set ACT_CREATE: map does
not exists" error in the mpath0 section:

	=20

	[root@svwdcvispay01 etc]# multipath -v3

	load path identifiers cache

	#

	# all paths in cache :

	#

	36005076801810085c800000000000194  1:0:0:0 sda 8:0   IBM
/2145

	36005076801810085c8000000000001a2  1:0:0:1 sdb 8:16 10 [active]
IBM     /2145

	36005076801810085c800000000000194  1:0:1:0 sdc 8:32   IBM
/2145

	36005076801810085c8000000000001a2  1:0:1:1 sdd 8:48 50 [active]
IBM     /2145

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

	36005076801810085c800000000000194  1:0:0:0 sda 8:0 50 [ready]
IBM     /2145

	36005076801810085c8000000000001a2  1:0:0:1 sdb 8:16 10
[active][ready] IBM

	36005076801810085c800000000000194  1:0:1:0 sdc 8:32 10 [ready]
IBM     /2145

	36005076801810085c8000000000001a2  1:0:1:1 sdd 8:48 50
[active][ready] IBM

	params =3D 1 queue_if_no_path 0 2 1 round-robin 0 1 1 8:48 1000
round-robin 0 1 1 8:16 1000

	status =3D 1 0 0 2 1 A 0 1 0 8:48 A 0 E 0 1 0 8:16 A 0

	Found matching wwid [36005076801810085c800000000000194] in
bindings file.

	Setting alias to mpath0

	pgpolicy =3D group_by_prio (controler setting)

	selector =3D round-robin 0 (internal default)

	features =3D 1 queue_if_no_path (controler setting)

	hwhandler =3D 0 (controler setting)

	rr_weight =3D 1 (internal default)

	rr_min_io =3D 1000 (config file default)

	no_path_retry =3D NONE (internal default)

	pg_timeout =3D NONE (internal default)

	0 25165824 multipath 1 queue_if_no_path 0 2 1 round-robin 0 1 1
8:0 1000 round-robin 0 1 1 8:32 1000

	set ACT_CREATE: map does not exists

	Found matching wwid [36005076801810085c8000000000001a2] in
bindings file.

	Setting alias to mpath1

	pgpolicy =3D group_by_prio (controler setting)

	selector =3D round-robin 0 (internal default)

	features =3D 1 queue_if_no_path (controler setting)

	hwhandler =3D 0 (controler setting)

	rr_weight =3D 1 (internal default)

	rr_min_io =3D 1000 (config file default)

	no_path_retry =3D NONE (internal default)

	pg_timeout =3D NONE (internal default)

	0 104857600 multipath 1 queue_if_no_path 0 2 1 round-robin 0 1 1
8:48 1000 round-robin 0 1 1 8:16 1000

	set ACT_NOTHING: map unchanged

	[root@svwdcvispay01 etc]#

	=20

	=20

	And notice that no /dev/mapper/mpath0 device special files were
created:

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

	My /etc/multipath.conf file is basic but I have tried creating
an alias entry that looks like "multipaths {multipath {wwid
36005076801810085c800000000000194 alias os}}" for the first LUN but the
results are the same, it still won't create any device special files for
the first LUN.

	=20

	[root@svwdcvispay01 mapper]# cat /etc/multipath.conf | grep -v
"#"

	=20

	defaults {

	        user_friendly_names yes

	}

	=20

	[root@svwdcvispay01 mapper]#

	=20

	I have been working this issue for over a week with IBM and
RedHat tech support and they have been unhelpful.  I need to get this
functional because the server in question has been unstable using a
single path to the SAN due to stability issues we have had periodically
with one of the SAN Volume Controllers.  If additional information is
needed to troubleshoot this please let me know.

	=20

	Joe little

	littlej@ae.com

	=20

=09
________________________________


	--
	dm-devel mailing list
	dm-devel@redhat.com
	https://www.redhat.com/mailman/listinfo/dm-devel


------_=_NextPart_001_01C8629A.CD5A27E8
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" =
xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns=3D"http://www.w3.org/TR/REC-html40">

<head>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3Dus-ascii">
<meta name=3DGenerator content=3D"Microsoft Word 11 (filtered medium)">
<!--[if !mso]>
<style>
v\:* {behavior:url(#default#VML);}
o\:* {behavior:url(#default#VML);}
w\:* {behavior:url(#default#VML);}
.shape {behavior:url(#default#VML);}
</style>
<![endif]-->
<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:Tahoma;
	panose-1:2 11 6 4 3 5 4 4 2 4;}
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
p
	{mso-margin-top-alt:auto;
	margin-right:0in;
	mso-margin-bottom-alt:auto;
	margin-left:0in;
	font-size:12.0pt;
	font-family:"Times New Roman";}
pre
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:10.0pt;
	font-family:"Courier New";
	color:black;}
span.EmailStyle18
	{mso-style-type:personal;
	font-family:Verdana;
	color:windowtext;
	font-weight:normal;
	font-style:normal;
	text-decoration:none none;}
span.EmailStyle20
	{mso-style-type:personal-reply;
	font-family:Verdana;
	color:teal;
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
<!--[if gte mso 9]><xml>
 <o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
 <o:shapelayout v:ext=3D"edit">
  <o:idmap v:ext=3D"edit" data=3D"1" />
 </o:shapelayout></xml><![endif]-->
</head>

<body bgcolor=3Dwhite lang=3DEN-US link=3Dblue vlink=3Dpurple>

<div class=3DSection1>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>I am not specifically =
blacklisting the
/dev/dm-X devices.&nbsp; The 5 /dev/dm-X devices on my system correspond =
to the 5
device special files in /dev/mapper on the second LUN that dm-multipath =
is
currently managing.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'><o:p>&nbsp;</o:p></span></font></p=
>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>[root@svwdcvispay01 ~]# cd =
/dev/mapper<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>[root@svwdcvispay01 mapper]# ls =
-la<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>total =
0<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>drwxr-xr-x&nbsp; 2 root =
root&nbsp;&nbsp;&nbsp;&nbsp; 160 Jan 29
11:47 .<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>drwxr-xr-x&nbsp; 9 root =
root&nbsp;&nbsp;&nbsp; 4900 Jan 29
11:44 ..<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>crw-------&nbsp; 1 root =
root&nbsp; 10, 63 Jan 29
11:44 control<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>brw-rw----&nbsp; 1 root disk =
253,&nbsp; 0 Jan 29
11:44 mpath1<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>brw-rw----&nbsp; 1 root disk =
253,&nbsp; 1 Jan 29
11:44 mpath1p1<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>brw-rw----&nbsp; 1 root disk =
253,&nbsp; 2 Jan 29
11:44 mpath1p2<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>brw-rw----&nbsp; 1 root disk =
253,&nbsp; 3 Jan 29
11:44 mpath1p3<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>brw-rw----&nbsp; 1 root disk =
253,&nbsp; 4 Jan 29
11:44 mpath1p5<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>[root@svwdcvispay01 mapper]# ls =
-la
/dev/dm*<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>brw-r-----&nbsp; 1 root root 253, =
0 Jan 29
11:44 /dev/dm-0<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>brw-r-----&nbsp; 1 root root 253, =
1 Jan 29
11:44 /dev/dm-1<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>brw-r-----&nbsp; 1 root root 253, =
2 Jan 29
11:44 /dev/dm-2<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>brw-r-----&nbsp; 1 root root 253, =
3 Jan 29
11:44 /dev/dm-3<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>brw-r-----&nbsp; 1 root root 253, =
4 Jan 29
11:44 /dev/dm-4<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>[root@svwdcvispay01 =
mapper]#<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'><o:p>&nbsp;</o:p></span></font></p=
>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>I believe that dm-multipath is =
internally
blacklisting those devices.&nbsp; Notice if I execute `dmsetup =
remove_all` which
removes all the /dev/mapper/mpath1* files and then recreate them that
dm-multipath creates 5 new /dev/dm-* files:<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'><o:p>&nbsp;</o:p></span></font></p=
>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>[root@svwdcvispay01 mapper]# =
dmsetup
remove_all<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>[root@svwdcvispay01 mapper]# ls =
-la<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>total =
0<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>drwxr-xr-x&nbsp; 2 root =
root&nbsp;&nbsp;&nbsp;&nbsp; 60 Jan 29
12:09 .<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>drwxr-xr-x&nbsp; 9 root =
root&nbsp;&nbsp; 4900 Jan 29
11:44 ..<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>crw-------&nbsp; 1 root root 10, =
63 Jan 29
11:44 control<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'><o:p>&nbsp;</o:p></span></font></p=
>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>[root@svwdcvispay01 mapper]# ls =
-la
/dev/dm*<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>brw-r-----&nbsp; 1 root root 253, =
0 Jan 29
11:44 /dev/dm-0<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>brw-r-----&nbsp; 1 root root 253, =
1 Jan 29
11:44 /dev/dm-1<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>brw-r-----&nbsp; 1 root root 253, =
2 Jan 29
11:44 /dev/dm-2<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>brw-r-----&nbsp; 1 root root 253, =
3 Jan 29
11:44 /dev/dm-3<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>brw-r-----&nbsp; 1 root root 253, =
4 Jan 29
11:44 /dev/dm-4<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'><o:p>&nbsp;</o:p></span></font></p=
>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>[root@svwdcvispay01 mapper]# =
multipath<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>create: mpath1
(36005076801810085c8000000000001a2)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>[size=3D50 GB][features=3D&quot;1
queue_if_no_path&quot;][hwhandler=3D&quot;0&quot;]<o:p></o:p></span></fon=
t></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>\_ round-robin 0 =
[prio=3D50]<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>&nbsp;\_ 1:0:1:1 sdd 8:48 =
[ready]<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>\_ round-robin 0 =
[prio=3D10]<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>&nbsp;\_ 1:0:0:1 sdb 8:16 =
[ready]<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'><o:p>&nbsp;</o:p></span></font></p=
>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>[root@svwdcvispay01 mapper]# ls =
-la<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>total =
0<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>drwxr-xr-x&nbsp; 2 root =
root&nbsp;&nbsp;&nbsp;&nbsp; 160 Jan 29
12:09 .<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>drwxr-xr-x&nbsp; 9 root =
root&nbsp;&nbsp;&nbsp; 5000 Jan 29
12:09 ..<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>crw-------&nbsp; 1 root =
root&nbsp; 10, 63 Jan 29
11:44 control<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>brw-rw----&nbsp; 1 root disk =
253,&nbsp; 5 Jan 29
12:09 mpath1<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>brw-rw----&nbsp; 1 root disk =
253,&nbsp; 6 Jan 29
12:09 mpath1p1<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>brw-rw----&nbsp; 1 root disk =
253,&nbsp; 7 Jan 29
12:09 mpath1p2<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>brw-rw----&nbsp; 1 root disk =
253,&nbsp; 8 Jan 29
12:09 mpath1p3<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>brw-rw----&nbsp; 1 root disk =
253,&nbsp; 9 Jan 29
12:09 mpath1p5<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'><o:p>&nbsp;</o:p></span></font></p=
>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>[root@svwdcvispay01 mapper]# ls =
-la
/dev/dm*<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>brw-r-----&nbsp; 1 root root 253, =
0 Jan 29
11:44 /dev/dm-0<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>brw-r-----&nbsp; 1 root root 253, =
1 Jan 29
11:44 /dev/dm-1<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>brw-r-----&nbsp; 1 root root 253, =
2 Jan 29
11:44 /dev/dm-2<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>brw-r-----&nbsp; 1 root root 253, =
3 Jan 29
11:44 /dev/dm-3<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>brw-r-----&nbsp; 1 root root 253, =
4 Jan 29
11:44 /dev/dm-4<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>brw-r-----&nbsp; 1 root root 253, =
5 Jan 29
12:09 /dev/dm-5<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>brw-r-----&nbsp; 1 root root 253, =
6 Jan 29
12:09 /dev/dm-6<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>brw-r-----&nbsp; 1 root root 253, =
7 Jan 29
12:09 /dev/dm-7<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>brw-r-----&nbsp; 1 root root 253, =
8 Jan 29
12:09 /dev/dm-8<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>brw-r-----&nbsp; 1 root root 253, =
9 Jan 29
12:09 /dev/dm-9<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>[root@svwdcvispay01 mapper]# =
<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'><o:p>&nbsp;</o:p></span></font></p=
>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>Notice also that the blacklist =
has been automatically
extended to cover the 5 new /dev/dm-X =
devices:<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'><o:p>&nbsp;</o:p></span></font></p=
>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>[root@svwdcvispay01 mapper]# =
multipath
-v3 | more<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>load path identifiers =
cache<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>#<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'># all paths in cache =
:<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>#<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>36005076801810085c800000000000194&=
nbsp;
1:0:0:0 sda 8:0&nbsp;&nbsp; IBM&nbsp;&nbsp;&nbsp;&nbsp; =
/2145<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>36005076801810085c8000000000001a2&=
nbsp;
1:0:0:1 sdb 8:16 10 [active] IBM&nbsp;&nbsp;&nbsp;&nbsp; =
/2145<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>36005076801810085c800000000000194&=
nbsp;
1:0:1:0 sdc 8:32&nbsp;&nbsp; IBM&nbsp;&nbsp;&nbsp;&nbsp; =
/2145<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>36005076801810085c8000000000001a2&=
nbsp;
1:0:1:1 sdd 8:48 50 [active] IBM&nbsp;&nbsp;&nbsp;&nbsp; =
/2145<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>dm-0 =
blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>dm-1 =
blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>dm-2 =
blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>dm-3 =
blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>dm-4 =
blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>dm-5 =
blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>dm-6 =
blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>dm-7 =
blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>dm-8 =
blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>dm-9 =
blacklisted<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>&#8230;<o:p></o:p></span></font></=
p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'><o:p>&nbsp;</o:p></span></font></p=
>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>When I reboot the server dm-5 =
through
dm-9 are gone and it is again using dm-0 through =
dm-4.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'><o:p>&nbsp;</o:p></span></font></p=
>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'>Joe =
Little<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'><a =
href=3D"mailto:littlej@ae.com">littlej@ae.com</a><o:p></o:p></span></font=
></p>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'><o:p>&nbsp;</o:p></span></font></p=
>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'><o:p>&nbsp;</o:p></span></font></p=
>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'><o:p>&nbsp;</o:p></span></font></p=
>

<p class=3DMsoNormal><font size=3D2 color=3Dteal face=3DVerdana><span =
style=3D'font-size:
10.0pt;font-family:Verdana;color:teal'><o:p>&nbsp;</o:p></span></font></p=
>

<div>

<div class=3DMsoNormal align=3Dcenter style=3D'text-align:center'><font =
size=3D3
face=3D"Times New Roman"><span style=3D'font-size:12.0pt'>

<hr size=3D2 width=3D"100%" align=3Dcenter tabindex=3D-1>

</span></font></div>

<p class=3DMsoNormal><b><font size=3D2 face=3DTahoma><span =
style=3D'font-size:10.0pt;
font-family:Tahoma;font-weight:bold'>From:</span></font></b><font =
size=3D2
face=3DTahoma><span style=3D'font-size:10.0pt;font-family:Tahoma'>
dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] =
<b><span
style=3D'font-weight:bold'>On Behalf Of </span></b>Gerald Nowitzky<br>
<b><span style=3D'font-weight:bold'>Sent:</span></b> Tuesday, January =
29, 2008
11:59 AM<br>
<b><span style=3D'font-weight:bold'>To:</span></b> device-mapper =
development<br>
<b><span style=3D'font-weight:bold'>Subject:</span></b> Re: [dm-devel] =
Problem
using dm-multipath on first of 2 LUNs on =
system</span></font><o:p></o:p></p>

</div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt'><o:p>&nbsp;</o:p></span></font></p>

<div>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>try and remove dm-0 to dm-4 from the blacklist. The =
devices
in /dev/mapper are links to /dev/dm-x</span></font><o:p></o:p></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>(Gerald)</span></font><o:p></o:p></p>

</div>

<blockquote style=3D'border:none;border-left:solid black =
1.5pt;padding:0in 0in 0in 4.0pt;
margin-left:3.75pt;margin-top:5.0pt;margin-right:0in;margin-bottom:5.0pt'=
>

<div>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>----- Original Message ----- =
<o:p></o:p></span></font></p>

</div>

<div style=3D'font-color:black'>

<p class=3DMsoNormal style=3D'background:#E4E4E4'><b><font size=3D2 =
face=3DArial><span
style=3D'font-size:10.0pt;font-family:Arial;font-weight:bold'>From:</span=
></font></b><font
size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;font-family:Arial'> <a
href=3D"mailto:LittleJ@AE.com" =
title=3D"LittleJ@AE.com">LittleJ@AE.com</a> =
<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><b><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial;font-weight:bold'>To:</span></font></b><font size=3D2
face=3DArial><span style=3D'font-size:10.0pt;font-family:Arial'> <a
href=3D"mailto:dm-devel@redhat.com" =
title=3D"dm-devel@redhat.com">dm-devel@redhat.com</a>
<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><b><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial;font-weight:bold'>Sent:</span></font></b><font =
size=3D2
face=3DArial><span style=3D'font-size:10.0pt;font-family:Arial'> =
Tuesday, January
29, 2008 4:42 PM<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><b><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial;font-weight:bold'>Subject:</span></font></b><font =
size=3D2
face=3DArial><span style=3D'font-size:10.0pt;font-family:Arial'> =
[dm-devel] Problem
using dm-multipath on first of 2 LUNs on =
system<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt'><o:p>&nbsp;</o:p></span></font></p>

</div>

<p class=3DMsoNormal><font size=3D2 face=3DVerdana><span =
style=3D'font-size:10.0pt;
font-family:Verdana'>I am attempting to implement dm-multipath on a =
RHEL4U6
server and I have been successful in enabling it on the second of 2 LUNs =
on the
server but for whatever reason it will not create the device special =
files in
/dev/mapper for the fist LUN.&nbsp; `multipath &#8211;d` shows that it
identifies the first LUN and wants to create the mpath0 =
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
&#8220;set
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
1:0:0:0 sda
8:0&nbsp;&nbsp; IBM&nbsp;&nbsp;&nbsp;&nbsp; =
/2145<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>36005076801810085c8000000000001a2&nbsp; =
1:0:0:1 sdb
8:16 10 [active] IBM&nbsp;&nbsp;&nbsp;&nbsp; =
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
1:0:1:1 sdd
8:48 50 [active] IBM&nbsp;&nbsp;&nbsp;&nbsp; =
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
1:0:0:0 sda
8:0 50 [ready] IBM&nbsp;&nbsp;&nbsp;&nbsp; =
/2145<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>36005076801810085c8000000000001a2&nbsp; =
1:0:0:1 sdb
8:16 10 [active][ready] IBM<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>36005076801810085c800000000000194&nbsp; =
1:0:1:0 sdc
8:32 10 [ready] IBM&nbsp;&nbsp;&nbsp;&nbsp; =
/2145<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>36005076801810085c8000000000001a2&nbsp; =
1:0:1:1 sdd
8:48 50 [active][ready] IBM<o:p></o:p></span></font></p>

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
font-family:"Courier New"'>Found matching wwid
[36005076801810085c8000000000001a2] in bindings =
file.<o:p></o:p></span></font></p>

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
root&nbsp;&nbsp;&nbsp;&nbsp;
160 Jan 29 09:53 .<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>drwxr-xr-x&nbsp; 9 root =
root&nbsp;&nbsp;&nbsp; 4900
Jan 29 09:51 ..<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>crw-------&nbsp; 1 root root&nbsp; 10, 63 Jan =
21
16:15 control<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>brw-rw----&nbsp; 1 root disk 253,&nbsp; 0 Jan =
21
16:15 mpath1<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>brw-rw----&nbsp; 1 root disk 253,&nbsp; 1 Jan =
21
16:15 mpath1p1<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>brw-rw----&nbsp; 1 root disk 253,&nbsp; 2 Jan =
21
16:15 mpath1p2<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Courier New"><span =
style=3D'font-size:10.0pt;
font-family:"Courier New"'>brw-rw----&nbsp; 1 root disk 253,&nbsp; 3 Jan =
21
16:15 mpath1p3<o:p></o:p></span></font></p>

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
font-family:"Courier New"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
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
troubleshoot
this please let me know.<o:p></o:p></span></font></p>

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

<div class=3DMsoNormal align=3Dcenter style=3D'text-align:center'><font =
size=3D3
face=3D"Times New Roman"><span style=3D'font-size:12.0pt'>

<hr size=3D2 width=3D"100%" align=3Dcenter>

</span></font></div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span =
style=3D'font-size:
12.0pt'>--<br>
dm-devel mailing list<br>
dm-devel@redhat.com<br>
https://www.redhat.com/mailman/listinfo/dm-devel<o:p></o:p></span></font>=
</p>

</blockquote>

</div>

</body>

</html>

------_=_NextPart_001_01C8629A.CD5A27E8--


--===============0759012591==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0759012591==--
