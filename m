From: "Riches Jr, RobertX M" <robertx.m.riches.jr@intel.com>
Subject: Is there a way to see updated contents of a DM target's
 underlying device while the DM target is in use?
Date: Wed, 30 Jun 2010 15:54:08 -0700
Message-ID: <4BD43A85686FC34D819098DB1C3999D99E4199BA@orsmsx502.amr.corp.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8516890568913563137=="
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

--===============8516890568913563137==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_4BD43A85686FC34D819098DB1C3999D99E4199BAorsmsx502amrcor_"

--_000_4BD43A85686FC34D819098DB1C3999D99E4199BAorsmsx502amrcor_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

(New list member, just subscribed.  Apologies if this is not the right list=
 for this question.)

Is there a way to see the updated contents of a DM target's underlying devi=
ce while the DM target is in use?  I Googled and searched in documentation =
and existing code for an answer but was not able to find it.

Background:

I'm debugging a DM target that does change-tracking.  It's a combination of=
 code from dm-linear, Alberto Bertogli's dm-csum, dm-delay, and some origin=
al code.  (The project architect does intend to properly release it under G=
PL per the license of the incorporated GPL pieces.)  The target reserves an=
 early portion of the underlying device and exposes/creates/supports a devi=
ce that is a linear mapping of the rest of the underlying device.  The idea=
 is each write to the exposed device sets a corresponding bit in the reserv=
ed portion, using the write barrier trick from dm-csum's 'same' mode, to in=
dicate which parts of the exposed device have been modified and which have =
not.  (I had earlier tried to use the userspace dirty-logging facility but =
found it to not meet our needs.)

The target is intended to be used with LVM snapshots to do block-device-lev=
el backups.  (I'm aware of filesystem-level issues with that, but the requi=
rement is the requirement.)  The underlying device for the DM target will b=
e an LVM logical volume.  The backup manager will send a dmsetup message to=
 the DM target to hold all writes (and maybe reads) on indefinite delay, cr=
eate an LVM snapshot of the DM target's underlying device, then flush the h=
eld bios and resume normal operation.

Problem:

The current problem I have is many updates are not visible in the DM target=
's underlying device until I do a 'dmsetup remove'.  When I look at the und=
erlying device (an LVM LV) prior to 'dmsetup remove', it's not reliable whe=
ther I see what has been written by the DM target.  I have verified that th=
e bios go out and the callbacks are called.

Any suggestions toward being able to reliably see (as in copy out) data fro=
m the underlying device or making an LVM snapshot of it while my change-tra=
cking DM target module is still in use?

Thanks,

Robert Riches
Azad Consultant at Intel



--_000_4BD43A85686FC34D819098DB1C3999D99E4199BAorsmsx502amrcor_
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
font-family:Arial'>(New list member, just subscribed.&nbsp; Apologies if th=
is
is not the right list for this question.)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Is there a way to see the updated contents of a DM targe=
t&#8217;s
underlying device while the DM target is in use?&nbsp; I Googled and search=
ed
in documentation and existing code for an answer but was not able to find i=
t.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Background:<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>I&#8217;m debugging a DM target that does
change-tracking.&nbsp; It&#8217;s a combination of code from dm-linear, Alb=
erto
Bertogli&#8217;s dm-csum, dm-delay, and some original code.&nbsp; (The proj=
ect
architect does intend to properly release it under GPL per the license of t=
he incorporated
GPL pieces.)&nbsp; The target reserves an early portion of the underlying
device and exposes/creates/supports a device that is a linear mapping of th=
e
rest of the underlying device.&nbsp; The idea is each write to the exposed
device sets a corresponding bit in the reserved portion, using the write ba=
rrier
trick from dm-csum&#8217;s &#8216;same&#8217; mode, to indicate which parts=
 of
the exposed device have been modified and which have not.&nbsp; (I had earl=
ier
tried to use the userspace dirty-logging facility but found it to not meet =
our
needs.)<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>The target is intended to be used with LVM snapshots to =
do
block-device-level backups.&nbsp; (I&#8217;m aware of filesystem-level issu=
es
with that, but the requirement is the requirement.)&nbsp; The underlying de=
vice
for the DM target will be an LVM logical volume.&nbsp; The backup manager w=
ill
send a dmsetup message to the DM target to hold all writes (and maybe reads=
) on
indefinite delay, create an LVM snapshot of the DM target&#8217;s underlyin=
g
device, then flush the held bios and resume normal operation.<o:p></o:p></s=
pan></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Problem:<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>The current problem I have is many updates are not visib=
le
in the DM target&#8217;s underlying device until I do a &#8216;dmsetup remo=
ve&#8217;.&nbsp;
When I look at the underlying device (an LVM LV) prior to &#8216;dmsetup re=
move&#8217;,
it&#8217;s not reliable whether I see what has been written by the DM
target.&nbsp; I have verified that the bios go out and the callbacks are
called.<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Any suggestions toward being able to reliably see (as in
copy out) data from the underlying device or making an LVM snapshot of it w=
hile
my change-tracking DM target module is still in use?<o:p></o:p></span></fon=
t></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0.0pt;
font-family:Arial'>Thanks,<o:p></o:p></span></font></p>

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

--_000_4BD43A85686FC34D819098DB1C3999D99E4199BAorsmsx502amrcor_--


--===============8516890568913563137==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8516890568913563137==--
