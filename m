From: "Ariel Gottlieb" <arielg@voltaire.com>
Subject: RE: multipath device name
Date: Tue, 29 Jan 2008 14:46:34 +0200
Message-ID: <39C75744D164D948A170E9792AF8E7CADC229C@exil.voltaire.com>
References: <39C75744D164D948A170E9792AF8E7CA110B96@exil.voltaire.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1055880242=="
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <39C75744D164D948A170E9792AF8E7CA110B96@exil.voltaire.com>
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

--===============1055880242==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C86274.FAF38816"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C86274.FAF38816
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Erez,=20

Add the following to your multipath.conf  file:

=20

defaults {

        udev_dir                /dev

        polling_interval        2

        failback                immediate

        no_path_retry           3

}

=20

Regards,=20

Ariel=20

________________________________

From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of Erez Zilber
Sent: Monday, January 28, 2008 10:23 PM
To: device-mapper development
Subject: RE: [dm-devel] multipath device name

=20

> Yes, I meant the above. Check if you have any problems with your
> multipath.conf file. Make sure you enclose "multipath {}" within
> "multipaths {}" block. Run 'multipath -t' and make sure your changes
are
> listed in its output.
>=20
> What is your multipath.conf file?

Problem solved:

I copied
/usr/share/doc/packages/multipath-tools/multipath.conf.annotated and
uncommented the block with the "red" device. The problem is that I
didn't remove the comments from 'multipaths {' and the '}' at the end of
the block. After uncommenting it, I see /dev/mapper/red.

=20

Any idea about the other question that I had on this thread (about slow
and strange fail over)? Any help will be appreciated.

=20

Thanks,

Erez


------_=_NextPart_001_01C86274.FAF38816
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
<title>Re: [dm-devel] multipath device name</title>
<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:Tahoma;
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
	{mso-style-type:personal-reply;
	font-family:Arial;
	color:navy;}
@page Section1
	{size:595.3pt 841.9pt;
	margin:72.0pt 90.0pt 72.0pt 90.0pt;}
div.Section1
	{page:Section1;}
-->
</style>

</head>

<body lang=3DEN-US link=3Dblue vlink=3Dpurple>

<div class=3DSection1 dir=3DRTL>

<p class=3DMsoNormal dir=3DLTR><font size=3D2 color=3Dnavy =
face=3DArial><span
style=3D'font-size:10.0pt;font-family:Arial;color:navy'>Erez, =
<o:p></o:p></span></font></p>

<p class=3DMsoNormal dir=3DLTR><font size=3D2 color=3Dnavy =
face=3DArial><span
style=3D'font-size:10.0pt;font-family:Arial;color:navy'>Add the =
following to your
multipath.conf&nbsp; file:<o:p></o:p></span></font></p>

<p class=3DMsoNormal dir=3DLTR><font size=3D2 color=3Dnavy =
face=3DArial><span
style=3D'font-size:10.0pt;font-family:Arial;color:navy'><o:p>&nbsp;</o:p>=
</span></font></p>

<p class=3DMsoNormal dir=3DLTR><font size=3D2 color=3Dnavy =
face=3DArial><span
style=3D'font-size:10.0pt;font-family:Arial;color:navy'>defaults =
{</span></font><font
size=3D2 color=3Dnavy face=3DArial><span lang=3DHE dir=3DRTL =
style=3D'font-size:10.0pt;
font-family:Arial;color:navy'><o:p></o:p></span></font></p>

<p class=3DMsoNormal dir=3DLTR><span dir=3DLTR></span><font size=3D2 =
color=3Dnavy
face=3DArial><span =
style=3D'font-size:10.0pt;font-family:Arial;color:navy'><span
dir=3DLTR></span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
udev_dir&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; /dev</span></font><font size=3D2
color=3Dnavy face=3DArial><span lang=3DHE dir=3DRTL =
style=3D'font-size:10.0pt;font-family:
Arial;color:navy'><o:p></o:p></span></font></p>

<p class=3DMsoNormal dir=3DLTR><span dir=3DLTR></span><font size=3D2 =
color=3Dnavy
face=3DArial><span =
style=3D'font-size:10.0pt;font-family:Arial;color:navy'><span
dir=3DLTR></span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
polling_interval&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
2</span></font><font size=3D2
color=3Dnavy face=3DArial><span lang=3DHE dir=3DRTL =
style=3D'font-size:10.0pt;font-family:
Arial;color:navy'><o:p></o:p></span></font></p>

<p class=3DMsoNormal dir=3DLTR><span dir=3DLTR></span><b><font size=3D2 =
color=3Dnavy
face=3DArial><span =
style=3D'font-size:10.0pt;font-family:Arial;color:navy;
font-weight:bold'><span =
dir=3DLTR></span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
failback&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;
immediate</span></font></b><b><font size=3D2 color=3Dnavy =
face=3DArial><span lang=3DHE
dir=3DRTL =
style=3D'font-size:10.0pt;font-family:Arial;color:navy;font-weight:bold'>=
<o:p></o:p></span></font></b></p>

<p class=3DMsoNormal dir=3DLTR><span dir=3DLTR></span><font size=3D2 =
color=3Dnavy
face=3DArial><span =
style=3D'font-size:10.0pt;font-family:Arial;color:navy'><span
dir=3DLTR></span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
no_path_retry&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
 3</span></font><font size=3D2
color=3Dnavy face=3DArial><span lang=3DHE dir=3DRTL =
style=3D'font-size:10.0pt;font-family:
Arial;color:navy'><o:p></o:p></span></font></p>

<p class=3DMsoNormal dir=3DLTR><span dir=3DLTR></span><font size=3D2 =
color=3Dnavy
face=3DArial><span =
style=3D'font-size:10.0pt;font-family:Arial;color:navy'><span
dir=3DLTR></span>}<o:p></o:p></span></font></p>

<div>

<p class=3DMsoNormal dir=3DLTR><font size=3D2 color=3Dnavy =
face=3DArial><span
style=3D'font-size:10.0pt;font-family:Arial;color:navy'><o:p>&nbsp;</o:p>=
</span></font></p>

<p class=3DMsoNormal dir=3DLTR><font size=3D2 color=3Dnavy =
face=3DArial><span
style=3D'font-size:10.0pt;font-family:Arial;color:navy'>Regards, =
<o:p></o:p></span></font></p>

<p class=3DMsoNormal dir=3DLTR><font size=3D2 color=3Dnavy =
face=3DArial><span
style=3D'font-size:10.0pt;font-family:Arial;color:navy'>Ariel =
<o:p></o:p></span></font></p>

<div class=3DMsoNormal align=3Dcenter dir=3DLTR =
style=3D'text-align:center'><font
size=3D3 face=3D"Times New Roman"><span style=3D'font-size:12.0pt'>

<hr size=3D2 width=3D"100%" align=3Dcenter tabindex=3D-1>

</span></font></div>

<p class=3DMsoNormal dir=3DLTR><b><font size=3D2 face=3DTahoma><span =
style=3D'font-size:
10.0pt;font-family:Tahoma;font-weight:bold'>From:</span></font></b><font
size=3D2 face=3DTahoma><span =
style=3D'font-size:10.0pt;font-family:Tahoma'>
dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] =
<b><span
style=3D'font-weight:bold'>On Behalf Of </span></b>Erez Zilber<br>
<b><span style=3D'font-weight:bold'>Sent:</span></b> Monday, January 28, =
2008
10:23 PM<br>
<b><span style=3D'font-weight:bold'>To:</span></b> device-mapper =
development<br>
<b><span style=3D'font-weight:bold'>Subject:</span></b> RE: [dm-devel] =
multipath
device name</span></font><o:p></o:p></p>

</div>

<p class=3DMsoNormal dir=3DLTR><font size=3D3 face=3D"Times New =
Roman"><span
style=3D'font-size:12.0pt'><o:p>&nbsp;</o:p></span></font></p>

<div id=3DidOWAReplyText33110>

<div>

<p class=3DMsoNormal dir=3DLTR><font size=3D2 face=3D"Times New =
Roman"><span
style=3D'font-size:10.0pt'>&gt; Yes, I meant the above. Check if you =
have any
problems with your<br>
&gt; multipath.conf file. Make sure you enclose &quot;multipath {}&quot; =
within<br>
&gt; &quot;multipaths {}&quot; block. Run 'multipath -t' and make sure =
your
changes are<br>
&gt; listed in its output.<br>
&gt; <br>
&gt; What is your multipath.conf file?</span></font><o:p></o:p></p>

</div>

<div>

<p class=3DMsoNormal dir=3DLTR><font size=3D2 face=3D"Times New =
Roman"><span
style=3D'font-size:10.0pt'>Problem solved:<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal dir=3DLTR><font size=3D2 face=3D"Times New =
Roman"><span
style=3D'font-size:10.0pt'>I copied
/usr/share/doc/packages/multipath-tools/multipath.conf.annotated and
uncommented the block with the &quot;red&quot; device. The problem is =
that I
didn't remove the comments from 'multipaths {' and the '}' at the end of =
the
block. After uncommenting it, I see =
/dev/mapper/red.</span></font><o:p></o:p></p>

</div>

<div>

<p class=3DMsoNormal dir=3DLTR><font size=3D3 face=3D"Times New =
Roman"><span
style=3D'font-size:12.0pt'>&nbsp;<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal dir=3DLTR><font size=3D2 face=3D"Times New =
Roman"><span
style=3D'font-size:10.0pt'>Any idea about the other question that I had =
on this
thread (about&nbsp;slow and strange&nbsp;fail over)? Any help will be
appreciated.</span></font><o:p></o:p></p>

</div>

<div>

<p class=3DMsoNormal dir=3DLTR><font size=3D3 face=3D"Times New =
Roman"><span
style=3D'font-size:12.0pt'>&nbsp;<o:p></o:p></span></font></p>

</div>

<div>

<p class=3DMsoNormal dir=3DLTR><font size=3D2 face=3D"Times New =
Roman"><span
style=3D'font-size:10.0pt'>Thanks,</span></font><o:p></o:p></p>

</div>

<div>

<p class=3DMsoNormal dir=3DLTR><font size=3D2 face=3D"Times New =
Roman"><span
style=3D'font-size:10.0pt'>Erez<o:p></o:p></span></font></p>

</div>

</div>

</div>

</body>

</html>

------_=_NextPart_001_01C86274.FAF38816--


--===============1055880242==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1055880242==--
