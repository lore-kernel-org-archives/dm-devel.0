From: "Murthy, Narasimha Doraswamy (STSD)" <narasimha.murthy@hp.com>
Subject: Re:IO error on DM device
Date: Mon, 3 Apr 2006 20:35:56 +0530
Message-ID: <3456F611E9329441B12FBB24447B3FA003C42724@bgeexc01.asiapacific.cpqcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1362465196=="
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.

--===============1362465196==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C65730.1C0446C2"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C65730.1C0446C2
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

My comments are below.

=20

-----Original Message-----

From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of Mike Christie

Sent: Thursday, March 30, 2006 2:45 PM

To: device-mapper development

Cc: Ryan O'Hara

Subject: Re: Fwd: [dm-devel] IO error on DM device

=20

Jonathan E Brassow wrote:

>=20

>     Another observation is that we are not seeing any IO errors when
the

>     same test is executed on SLES9 SP3/SP4.=20

>=20

[Murthy] our other team has seen the error on SLES9 too.  The Qlogic
driver is same as RHEL ones, so we have to see similar behaviour.

=20

I think Ryan's post is correct, but I wonder why the SLES9 is not
returning errors. Was the SLES statement referring to the scsi errors
you see in the log like this:

=20

=20

     Feb  1 11:47:45 apwtest52 kernel: SCSI error : <3 0 0 1> return
code

     =3D 0x20000

=20

or the dm-multipath and block layer messages

=20

Feb  1 11:48:40 apwtest52 kernel: device-mapper: dm-multipath:

     Failing path 8:32.

=20

=20

     Feb  1 11:48:40 apwtest52 kernel: Buffer I/O error on device dm-0,

     logical block 116940 u

=20

=20

or both?

=20

Do you have the same dm-multipath settings (queue if no path, etc)?
[Murthy] yes

 Is this is the qlogic qla2xxx driver? [Murthy] yes

 Are there qlogic guys on the list that would know if there are any
differences between the SLES and RHEL drivers or are we going to have to
dig in there? Are there differences between the SLES and RHEL dm
multipath drivers? Does this occur with the upstream kernel?

=20

--

dm-devel mailing list

dm-devel@redhat.com

https://www.redhat.com/mailman/listinfo/dm-devel


------_=_NextPart_001_01C65730.1C0446C2
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
 /* Font Definitions */
 @font-face
	{font-family:"MS Sans Serif";
	panose-1:0 0 0 0 0 0 0 0 0 0;}
@font-face
	{font-family:"Microsoft Sans Serif";
	panose-1:2 11 6 4 2 2 2 2 2 4;}
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
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"MS Sans Serif";
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

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'>My comments are =
below.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"MS Sans Serif"><span =
style=3D'font-size:
10.0pt;font-family:"MS Sans Serif"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2
face=3D"Microsoft Sans Serif"><span =
style=3D'font-size:10.0pt;font-family:"Microsoft Sans =
Serif"'>-----Original
Message-----<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2
face=3D"Microsoft Sans Serif"><span =
style=3D'font-size:10.0pt;font-family:"Microsoft Sans Serif"'>From:
dm-devel-bounces@redhat.com [<a =
href=3D"mailto:dm-devel-bounces@redhat.com">mailto:dm-devel-bounces@redha=
t.com</a>]
On Behalf Of Mike Christie<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2
face=3D"Microsoft Sans Serif"><span =
style=3D'font-size:10.0pt;font-family:"Microsoft Sans Serif"'>Sent:
Thursday, March 30, 2006 2:45 PM<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2
face=3D"Microsoft Sans Serif"><span =
style=3D'font-size:10.0pt;font-family:"Microsoft Sans Serif"'>To:
device-mapper development<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2
face=3D"Microsoft Sans Serif"><span =
style=3D'font-size:10.0pt;font-family:"Microsoft Sans Serif"'>Cc:
Ryan O'Hara<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2
face=3D"Microsoft Sans Serif"><span =
style=3D'font-size:10.0pt;font-family:"Microsoft Sans Serif"'>Subject:
Re: Fwd: [dm-devel] IO error on DM device<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2
face=3D"Microsoft Sans Serif"><span =
style=3D'font-size:10.0pt;font-family:"Microsoft Sans =
Serif"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2
face=3D"Microsoft Sans Serif"><span =
style=3D'font-size:10.0pt;font-family:"Microsoft Sans Serif"'>Jonathan
E Brassow wrote:<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2
face=3D"Microsoft Sans Serif"><span =
style=3D'font-size:10.0pt;font-family:"Microsoft Sans Serif"'>&gt;
<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2
face=3D"Microsoft Sans Serif"><span =
style=3D'font-size:10.0pt;font-family:"Microsoft Sans =
Serif"'>&gt;&nbsp;&nbsp;&nbsp;&nbsp;
Another observation is that we are not seeing any IO errors when =
the<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2
face=3D"Microsoft Sans Serif"><span =
style=3D'font-size:10.0pt;font-family:"Microsoft Sans =
Serif"'>&gt;&nbsp;&nbsp;&nbsp;&nbsp;
same test is executed on SLES9 SP3/SP4. <o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2
face=3D"Microsoft Sans Serif"><span =
style=3D'font-size:10.0pt;font-family:"Microsoft Sans Serif"'>&gt;
<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><b><font size=3D2
face=3D"Microsoft Sans Serif"><span =
style=3D'font-size:10.0pt;font-family:"Microsoft Sans Serif";
font-weight:bold'>[Murthy]</span></font></b><font size=3D2
face=3D"Microsoft Sans Serif"><span =
style=3D'font-size:10.0pt;font-family:"Microsoft Sans Serif"'>
our other team has seen the error on SLES9 too. &nbsp;The Qlogic driver =
is same
as RHEL ones, so we have to see similar =
behaviour.<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2
face=3D"Microsoft Sans Serif"><span =
style=3D'font-size:10.0pt;font-family:"Microsoft Sans =
Serif"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2
face=3D"Microsoft Sans Serif"><span =
style=3D'font-size:10.0pt;font-family:"Microsoft Sans Serif"'>I
think Ryan's post is correct, but I wonder why the SLES9 is not =
returning
errors. Was the SLES statement referring to the scsi errors you see in =
the log
like this:<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2
face=3D"Microsoft Sans Serif"><span =
style=3D'font-size:10.0pt;font-family:"Microsoft Sans =
Serif"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2
face=3D"Microsoft Sans Serif"><span =
style=3D'font-size:10.0pt;font-family:"Microsoft Sans =
Serif"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2
face=3D"Microsoft Sans Serif"><span =
style=3D'font-size:10.0pt;font-family:"Microsoft Sans =
Serif"'>&nbsp;&nbsp;&nbsp;&nbsp;
Feb&nbsp; 1 11:47:45 apwtest52 kernel: SCSI error : &lt;3 0 0 1&gt; =
return code<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2
face=3D"Microsoft Sans Serif"><span =
style=3D'font-size:10.0pt;font-family:"Microsoft Sans =
Serif"'>&nbsp;&nbsp;&nbsp;&nbsp;
=3D 0x20000<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2
face=3D"Microsoft Sans Serif"><span =
style=3D'font-size:10.0pt;font-family:"Microsoft Sans =
Serif"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2
face=3D"Microsoft Sans Serif"><span =
style=3D'font-size:10.0pt;font-family:"Microsoft Sans Serif"'>or
the dm-multipath and block layer messages<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2
face=3D"Microsoft Sans Serif"><span =
style=3D'font-size:10.0pt;font-family:"Microsoft Sans =
Serif"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2
face=3D"Microsoft Sans Serif"><span lang=3DDE =
style=3D'font-size:10.0pt;font-family:
"Microsoft Sans Serif"'>Feb&nbsp; 1 11:48:40 apwtest52 kernel: =
device-mapper:
dm-multipath:<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2
face=3D"Microsoft Sans Serif"><span lang=3DDE =
style=3D'font-size:10.0pt;font-family:
"Microsoft Sans Serif"'>&nbsp;&nbsp;&nbsp;&nbsp; </span></font><font =
size=3D2
face=3D"Microsoft Sans Serif"><span =
style=3D'font-size:10.0pt;font-family:"Microsoft Sans Serif"'>Failing
path 8:32.<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2
face=3D"Microsoft Sans Serif"><span =
style=3D'font-size:10.0pt;font-family:"Microsoft Sans =
Serif"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2
face=3D"Microsoft Sans Serif"><span =
style=3D'font-size:10.0pt;font-family:"Microsoft Sans =
Serif"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2
face=3D"Microsoft Sans Serif"><span =
style=3D'font-size:10.0pt;font-family:"Microsoft Sans =
Serif"'>&nbsp;&nbsp;&nbsp;&nbsp;
Feb&nbsp; 1 11:48:40 apwtest52 kernel: Buffer I/O error on device =
dm-0,<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2
face=3D"Microsoft Sans Serif"><span =
style=3D'font-size:10.0pt;font-family:"Microsoft Sans =
Serif"'>&nbsp;&nbsp;&nbsp;&nbsp;
logical block 116940 u<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2
face=3D"Microsoft Sans Serif"><span =
style=3D'font-size:10.0pt;font-family:"Microsoft Sans =
Serif"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2
face=3D"Microsoft Sans Serif"><span =
style=3D'font-size:10.0pt;font-family:"Microsoft Sans =
Serif"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2
face=3D"Microsoft Sans Serif"><span =
style=3D'font-size:10.0pt;font-family:"Microsoft Sans Serif"'>or
both?<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2
face=3D"Microsoft Sans Serif"><span =
style=3D'font-size:10.0pt;font-family:"Microsoft Sans =
Serif"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2
face=3D"Microsoft Sans Serif"><span =
style=3D'font-size:10.0pt;font-family:"Microsoft Sans Serif"'>Do
you have the same dm-multipath settings (queue if no path, etc)? =
<b><span
style=3D'font-weight:bold'>[Murthy] =
yes</span></b><o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2
face=3D"Microsoft Sans Serif"><span =
style=3D'font-size:10.0pt;font-family:"Microsoft Sans Serif"'>&nbsp;Is
this is the qlogic qla2xxx driver? <b><span =
style=3D'font-weight:bold'>[Murthy] =
yes</span></b><o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2
face=3D"Microsoft Sans Serif"><span =
style=3D'font-size:10.0pt;font-family:"Microsoft Sans Serif"'>&nbsp;Are
there qlogic guys on the list that would know if there are any =
differences
between the SLES and RHEL drivers or are we going to have to dig in =
there? Are
there differences between the SLES and RHEL dm multipath drivers? Does =
this
occur with the upstream kernel?<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2
face=3D"Microsoft Sans Serif"><span =
style=3D'font-size:10.0pt;font-family:"Microsoft Sans =
Serif"'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2
face=3D"Microsoft Sans Serif"><span =
style=3D'font-size:10.0pt;font-family:"Microsoft Sans =
Serif"'>--<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2
face=3D"Microsoft Sans Serif"><span =
style=3D'font-size:10.0pt;font-family:"Microsoft Sans Serif"'>dm-devel
mailing list<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2
face=3D"Microsoft Sans Serif"><span =
style=3D'font-size:10.0pt;font-family:"Microsoft Sans =
Serif"'>dm-devel@redhat.com<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3D"Microsoft Sans Serif"><span
style=3D'font-size:10.0pt;font-family:"Microsoft Sans Serif"'><a
href=3D"https://www.redhat.com/mailman/listinfo/dm-devel">https://www.red=
hat.com/mailman/listinfo/dm-devel</a></span></font><o:p></o:p></p>

</div>

</body>

</html>

------_=_NextPart_001_01C65730.1C0446C2--


--===============1362465196==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1362465196==--
