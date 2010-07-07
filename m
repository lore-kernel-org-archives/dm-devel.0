From: "Riches Jr, RobertX M" <robertx.m.riches.jr@intel.com>
Subject: any known problems when doing bio_clone() over an LVM
	snapshot?
Date: Wed, 7 Jul 2010 13:39:21 -0700
Message-ID: <4BD43A85686FC34D819098DB1C3999D99E777071@orsmsx502.amr.corp.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6777304786004263256=="
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Dm-Devel Mailing List Send-To Address (dm-devel@redhat.com)" <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============6777304786004263256==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_4BD43A85686FC34D819098DB1C3999D99E777071orsmsx502amrcor_"

--_000_4BD43A85686FC34D819098DB1C3999D99E777071orsmsx502amrcor_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Are there any known problems with using bio_clone() in a DM target module w=
hen the underlying block device is an LVM logical volume and a snapshot has=
 been created on said logical volume while the DM target module is active?

I'm developing a DM target module to do block-based change tracking.  It in=
cludes code from dm-linear, Alberto Bertogli's dm-csum, dm-delay, and some =
original code, and it appears to be fairly functional.  With the underlying=
 device (the one in the table entry) being an LVM logical volume.  I have c=
reated an ext2/3 filesystem, copied all ~775MB of /usr/lib to it, and diff'=
ed the original /usr/lib with the copy.  My module includes the parts of dm=
-csum that call bio_clone() to clone the original bio into one or more piec=
es to convert 'evil' bios into 'nice' ones and then to convert an original =
'nice' bio into the one that will be used in a bio_submit() call.

However, if I create an LVM snapshot of the underlying LV while my module i=
s active, and then I write to the device created by my module, after my mod=
ule has called bio_submit() for a metadata write to sector 256 and a data w=
rite to a higher-numbered sector, some portions of my write requests do not=
 complete, and I see the following error messages in /var/log/syslog:

            __ratelimit: 33 callbacks suppressed
            Buffer I/O error on device dm-1, logical block 256
            lost page write due to I/O error on dm-1

If I use dm-linear, dm-delay, or dm-crypt instead of my module, there are n=
o errors reported, and the writes appear to go through.  The main differenc=
e appears to be my use (from dm-csum) of bio_clone().  However, my module, =
even with bio_clone(), appears to work fine except when an LVM snapshot is =
created underneath it.

Any ideas on whether bio_clone() and LVM snapshots don't play well together=
?

Thank you,

Robert Riches
Azad Consultant at Intel



--_000_4BD43A85686FC34D819098DB1C3999D99E777071orsmsx502amrcor_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:o=3D"urn:schemas-microsoft-com:office:office" xmlns:w=3D"urn:sc=
hemas-microsoft-com:office:word" xmlns=3D"http://www.w3.org/TR/REC-html40">

<head>
<meta http-equiv=3DContent-Type content=3D"text/html; charset=3Dus-ascii">
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

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Are there any known problems with using bio_clone() in a=
 DM
target module when the underlying block device is an LVM logical volume and=
 a
snapshot has been created on said logical volume while the DM target module=
 is
active?<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>I&#8217;m developing a DM target module to do block-base=
d
change tracking.&nbsp; It includes code from dm-linear, Alberto Bertogli&#8=
217;s
dm-csum, dm-delay, and some original code, and it appears to be fairly
functional.&nbsp; With the underlying device (the one in the table entry) b=
eing
an LVM logical volume.&nbsp; I have created an ext2/3 filesystem, copied al=
l ~775MB
of /usr/lib to it, and diff&#8217;ed the original /usr/lib with the copy.&n=
bsp;
My module includes the parts of dm-csum that call bio_clone() to clone the
original bio into one or more pieces to convert &#8216;evil&#8217; bios int=
o &#8216;nice&#8217;
ones and then to convert an original &#8216;nice&#8217; bio into the one th=
at
will be used in a bio_submit() call.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>However, if I create an LVM snapshot of the underlying L=
V
while my module is active, and then I write to the device created by my mod=
ule,
after my module has called bio_submit() for a metadata write to sector 256 =
and
a data write to a higher-numbered sector, some portions of my write request=
s do
not complete, and I see the following error messages in /var/log/syslog:<o:=
p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; __ratelimit:
33 callbacks suppressed<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; Buffer
I/O error on device dm-1, logical block 256<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; lost
page write due to I/O error on dm-1<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>If I use dm-linear, dm-delay, or dm-crypt instead of my
module, there are no errors reported, and the writes appear to go
through.&nbsp; The main difference appears to be my use (from dm-csum) of
bio_clone().&nbsp; However, my module, even with bio_clone(), appears to wo=
rk
fine except when an LVM snapshot is created underneath it.<o:p></o:p></span=
></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Any ideas on whether bio_clone() and LVM snapshots don&#=
8217;t
play well together?<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Thank you,<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Robert Riches</span></font><o:p></o:p></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Azad Consultant at Intel</span></font><o:p></o:p></p>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>&nbsp;</span><o:p></o:p></font></p>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'><o:p>&nbsp;</o:p></span></font></p>

</div>

</body>

</html>

--_000_4BD43A85686FC34D819098DB1C3999D99E777071orsmsx502amrcor_--


--===============6777304786004263256==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6777304786004263256==--
