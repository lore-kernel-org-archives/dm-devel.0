From: "Paul Cote" <paul.cote@incipient.com>
Subject: multipath tool 4.8 and RH 5.0
Date: Fri, 4 Jan 2008 14:49:32 -0500
Message-ID: <940B4FF1F5958E4F96FC83C055A2F261377CFE@exch-2003.incipient.waltham>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1134333366=="
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

--===============1134333366==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C84F0A.ED4C45B0"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C84F0A.ED4C45B0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

=20

I've successfully compiled / link multipath tools v4.7 using RHEL 4 but
ran into various issues with RHEL V5

=20

Is multipath tools supported with V5?=20

=20

I also had to remove the laio flag form the make file ... and now the
undefined references.

=20

thanks

=20

=20

make -C ../libmultipath DAEMON=3D1 BUILD=3Dglibc glibc

make[2]: Entering directory
`/root/mp48/multipath-tools-0.4.8/libmultipath'

ar rs libmultipath-glibc.a *.o

ar: creating libmultipath-glibc.a

make[2]: Leaving directory
`/root/mp48/multipath-tools-0.4.8/libmultipath'

cc main.o pidfile.o uxlsnr.o uxclnt.o cli.o cli_handlers.o
../libmultipath/libmultipath-glibc.a ../libcheckers/libcheckers-glibc.a
-o multipathd -lpthread -ldevmapper -lreadline -lncurses=20

../libcheckers/libcheckers-glibc.a(directio.o): In function
`directio_init':

/root/mp48/multipath-tools-0.4.8/libcheckers/directio.c:51: undefined
reference to `io_setup'

/root/mp48/multipath-tools-0.4.8/libcheckers/directio.c:93: undefined
reference to `io_destroy'

../libcheckers/libcheckers-glibc.a(directio.o): In function
`directio_free':

/root/mp48/multipath-tools-0.4.8/libcheckers/directio.c:116: undefined
reference to `io_destroy'

../libcheckers/libcheckers-glibc.a(directio.o): In function
`check_state':

/root/mp48/multipath-tools-0.4.8/libcheckers/directio.c:144: undefined
reference to `io_submit'

/root/mp48/multipath-tools-0.4.8/libcheckers/directio.c:151: undefined
reference to `io_getevents'

collect2: ld returned 1 exit status

make[1]: *** [multipathd] Error 1


------_=_NextPart_001_01C84F0A.ED4C45B0
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns=3D"http://www.w3.org/TR/REC-html40">

<head>
<meta http-equiv=3DContent-Type content=3D"text/html; =
charset=3Dus-ascii">
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

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>I&#8217;ve successfully compiled / link multipath =
tools v4.7
using RHEL 4 but ran into various issues with RHEL =
V5<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>Is multipath tools supported with V5? =
<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>I also had to remove the laio flag form the make file =
&#8230;
and now the undefined references.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>thanks<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>make -C ../libmultipath DAEMON=3D1 BUILD=3Dglibc =
glibc<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>make[2]: Entering directory
`/root/mp48/multipath-tools-0.4.8/libmultipath'<o:p></o:p></span></font><=
/p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>ar rs libmultipath-glibc.a =
*.o<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>ar: creating =
libmultipath-glibc.a<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>make[2]: Leaving directory
`/root/mp48/multipath-tools-0.4.8/libmultipath'<o:p></o:p></span></font><=
/p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>cc main.o pidfile.o uxlsnr.o uxclnt.o cli.o =
cli_handlers.o
../libmultipath/libmultipath-glibc.a =
../libcheckers/libcheckers-glibc.a&nbsp;
-o multipathd -lpthread -ldevmapper -lreadline -lncurses =
<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>../libcheckers/libcheckers-glibc.a(directio.o): In =
function
`directio_init':<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>/root/mp48/multipath-tools-0.4.8/libcheckers/directio.=
c:51:
undefined reference to `io_setup'<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>/root/mp48/multipath-tools-0.4.8/libcheckers/directio.=
c:93:
undefined reference to `io_destroy'<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>../libcheckers/libcheckers-glibc.a(directio.o): In =
function
`directio_free':<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>/root/mp48/multipath-tools-0.4.8/libcheckers/directio.=
c:116:
undefined reference to `io_destroy'<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>../libcheckers/libcheckers-glibc.a(directio.o): In =
function
`check_state':<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>/root/mp48/multipath-tools-0.4.8/libcheckers/directio.=
c:144:
undefined reference to `io_submit'<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>/root/mp48/multipath-tools-0.4.8/libcheckers/directio.=
c:151:
undefined reference to `io_getevents'<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>collect2: ld returned 1 exit =
status<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10.0pt;
font-family:Arial'>make[1]: *** [multipathd] Error =
1<o:p></o:p></span></font></p>

</div>

</body>

</html>

------_=_NextPart_001_01C84F0A.ED4C45B0--


--===============1134333366==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1134333366==--
