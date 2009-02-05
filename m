From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: FW: Multipath setup and rdac questions
Date: Thu, 5 Feb 2009 13:32:18 -0700
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF46653B584@cosmail01.lsi.com>
References: <E463DF2B2E584B4A82673F53D62C2EF4663976BB@cosmail01.lsi.com>
	<1a4a774c0902051223g3a70ee45k946b9338d5d3c2df@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0076008746=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1a4a774c0902051223g3a70ee45k946b9338d5d3c2df@mail.gmail.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: =?iso-8859-1?Q?Christian_R=F8snes?= <christian.rosnes@gmail.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============0076008746==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_E463DF2B2E584B4A82673F53D62C2EF46653B584cosmail01lsicom_"

--_000_E463DF2B2E584B4A82673F53D62C2EF46653B584cosmail01lsicom_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Your Vendor id is DELL   and Product id is MD3000i

Now update the multipath.conf with the above information and reboot the sys=
tem.

vendor                  "DELL"
      product                 "MD3000i"

You should see the devices.  Let me know if you need more information..

Thanks
Babu Moger
________________________________
From: Christian R=F8snes [mailto:christian.rosnes@gmail.com]
Sent: Thursday, February 05, 2009 2:24 PM
To: Moger, Babu
Cc: dm-devel@redhat.com
Subject: Re: FW: [dm-devel] Multipath setup and rdac questions


On Thu, Feb 5, 2009 at 8:34 PM, Moger, Babu <Babu.Moger@lsi.com<mailto:Babu=
.Moger@lsi.com>> wrote:

It is still not correct.  The product id "MD Virtual Disk" is the device cl=
aimed by MPP. That means you still have mpp in your system.



Please follow the steps below..



 1.  Remove the MPP from your system.

Find the directory where MPP sources are located. It should be somewhere in=
 /opt/.  Then run "make uninstall"



      2. Send me output of /proc/scsi/scsi

Ok. Thank you for spotting this.

The Makefile resided in /usr/src/linuxrdac-09.03.0C06.0030
I did the following to stop the mpp modules from loading at boot:

i first did:

 # cd /usr/src/linuxrdac-09.03.0C06.0030
 /usr/src/linuxrdac-09.03.0C06.0030 # make uninstall

This removed some files (amongst others the files in /opt/mpp)

I rebooted, but the the mpp* drivers still were loaded after reboot.

I then changed the /etc/modprobde.conf and commented out the mpp drivers:

#alias scsi_hostadapter0 mppVhba
#alias scsi_hostadapter1 mppUpper

This was not enough, I still had the mpp* drivers after reboot.

So I looked in /boot and found an "old" version of initrd, and I assume
this was the initrd used before the mpp driver was installed.
So I changed /boot/grub/menu.lst to use the "previous" initrd, and then reb=
ooted.
Now, I don't have any mpp drivers loaded anymore.

And here's the output of /proc/scsi/scsi:

# cat /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: SEAGATE  Model: ST973451SS       Rev: SM04
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi0 Channel: 00 Id: 01 Lun: 00
  Vendor: SEAGATE  Model: ST973451SS       Rev: SM04
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi0 Channel: 01 Id: 00 Lun: 00
  Vendor: Dell     Model: VIRTUAL DISK     Rev: 1028
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi5 Channel: 00 Id: 00 Lun: 00
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi6 Channel: 00 Id: 00 Lun: 00
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi7 Channel: 00 Id: 00 Lun: 00
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi8 Channel: 00 Id: 00 Lun: 00
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi3 Channel: 00 Id: 00 Lun: 00
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi4 Channel: 00 Id: 00 Lun: 00
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi5 Channel: 00 Id: 00 Lun: 10
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi6 Channel: 00 Id: 00 Lun: 10
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi3 Channel: 00 Id: 00 Lun: 01
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi4 Channel: 00 Id: 00 Lun: 01
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi5 Channel: 00 Id: 00 Lun: 11
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi6 Channel: 00 Id: 00 Lun: 11
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi5 Channel: 00 Id: 00 Lun: 12
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi6 Channel: 00 Id: 00 Lun: 12
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi7 Channel: 00 Id: 00 Lun: 10
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi8 Channel: 00 Id: 00 Lun: 10
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi7 Channel: 00 Id: 00 Lun: 11
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi8 Channel: 00 Id: 00 Lun: 11
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi3 Channel: 00 Id: 00 Lun: 02
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi4 Channel: 00 Id: 00 Lun: 02
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi3 Channel: 00 Id: 00 Lun: 03
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi4 Channel: 00 Id: 00 Lun: 03
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 01
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi2 Channel: 00 Id: 00 Lun: 01
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 02
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi2 Channel: 00 Id: 00 Lun: 02
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi6 Channel: 00 Id: 00 Lun: 13
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi5 Channel: 00 Id: 00 Lun: 13
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi5 Channel: 00 Id: 00 Lun: 14
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi6 Channel: 00 Id: 00 Lun: 14
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi7 Channel: 00 Id: 00 Lun: 12
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi8 Channel: 00 Id: 00 Lun: 12
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi7 Channel: 00 Id: 00 Lun: 13
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi8 Channel: 00 Id: 00 Lun: 13
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi3 Channel: 00 Id: 00 Lun: 04
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi4 Channel: 00 Id: 00 Lun: 04
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi3 Channel: 00 Id: 00 Lun: 05
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi4 Channel: 00 Id: 00 Lun: 05
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi3 Channel: 00 Id: 00 Lun: 31
  Vendor: DELL     Model: Universal Xport  Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi4 Channel: 00 Id: 00 Lun: 31
  Vendor: DELL     Model: Universal Xport  Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 03
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi2 Channel: 00 Id: 00 Lun: 03
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 04
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi2 Channel: 00 Id: 00 Lun: 04
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi6 Channel: 00 Id: 00 Lun: 15
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi5 Channel: 00 Id: 00 Lun: 15
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi7 Channel: 00 Id: 00 Lun: 14
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi8 Channel: 00 Id: 00 Lun: 14
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi7 Channel: 00 Id: 00 Lun: 15
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi8 Channel: 00 Id: 00 Lun: 15
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi5 Channel: 00 Id: 00 Lun: 31
  Vendor: DELL     Model: Universal Xport  Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi6 Channel: 00 Id: 00 Lun: 31
  Vendor: DELL     Model: Universal Xport  Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi8 Channel: 00 Id: 00 Lun: 31
  Vendor: DELL     Model: Universal Xport  Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi7 Channel: 00 Id: 00 Lun: 31
  Vendor: DELL     Model: Universal Xport  Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 05
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi2 Channel: 00 Id: 00 Lun: 05
  Vendor: DELL     Model: MD3000i          Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 31
  Vendor: DELL     Model: Universal Xport  Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi2 Channel: 00 Id: 00 Lun: 31
  Vendor: DELL     Model: Universal Xport  Rev: 0735
  Type:   Direct-Access                    ANSI SCSI revision: 05


Thank you
Christian




--_000_E463DF2B2E584B4A82673F53D62C2EF46653B584cosmail01lsicom_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns=3D"http://www.w3.org/TR/REC-html40">

<head>
<meta http-equiv=3DContent-Type content=3D"text/html; charset=3Diso-8859-1"=
>
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
	{color:blue;
	text-decoration:underline;}
p
	{mso-margin-top-alt:auto;
	margin-right:0in;
	mso-margin-bottom-alt:auto;
	margin-left:0in;
	font-size:12.0pt;
	font-family:"Times New Roman";}
span.EmailStyle18
	{mso-style-type:personal-reply;
	font-family:Arial;
	color:navy;}
@page Section1
	{size:8.5in 11.0in;
	margin:1.0in 1.25in 1.0in 1.25in;}
div.Section1
	{page:Section1;}
 /* List Definitions */
 @list l0
	{mso-list-id:2086409988;
	mso-list-template-ids:1430404594;}
ol
	{margin-bottom:0in;}
ul
	{margin-bottom:0in;}
-->
</style>

</head>

<body lang=3DEN-US link=3Dblue vlink=3Dblue>

<div class=3DSection1>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Your Vendor id is DELL&nbsp;&nbsp;&nbsp;and Product id is MD3000i&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<o:p></o:p></span></fon=
t></p>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>Now update the multipath.conf with the above information and reboot=
 the
system.<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'><o:p>&nbsp;</o:p></spa=
n></font></p>

<p class=3DMsoNormal style=3D'text-indent:.5in;text-autospace:none'><font s=
ize=3D2
face=3D"Courier New"><span style=3D'font-size:10.0pt;font-family:"Courier N=
ew"'>vendor=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
&quot;DELL&quot;<o:p></o:p></span></font></p>

<p class=3DMsoNormal style=3D'text-autospace:none'><font size=3D2 face=3D"C=
ourier New"><span
style=3D'font-size:10.0pt;font-family:"Courier New"'>=A0=A0=A0=A0=A0
product=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 &quot;MD3000i&quot;=
<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>You should see the devices. =A0Let me =
know
if you need more information..<o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'><o:p>&nbsp;</o:p></span></font></p>

<div>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>Thanks</span></font><font color=3Dnavy=
><span
style=3D'color:navy'><o:p></o:p></span></font></p>

<p class=3DMsoNormal><font size=3D2 color=3Dnavy face=3DArial><span style=
=3D'font-size:
10.0pt;font-family:Arial;color:navy'>Babu Moger </span></font><o:p></o:p></=
p>

</div>

<div>

<div class=3DMsoNormal align=3Dcenter style=3D'text-align:center'><font siz=
e=3D3
face=3D"Times New Roman"><span style=3D'font-size:12.0pt'>

<hr size=3D2 width=3D"100%" align=3Dcenter tabindex=3D-1>

</span></font></div>

<p class=3DMsoNormal><b><font size=3D2 face=3DTahoma><span style=3D'font-si=
ze:10.0pt;
font-family:Tahoma;font-weight:bold'>From:</span></font></b><font size=3D2
face=3DTahoma><span style=3D'font-size:10.0pt;font-family:Tahoma'> Christia=
n R=F8snes
[mailto:christian.rosnes@gmail.com] <br>
<b><span style=3D'font-weight:bold'>Sent:</span></b> Thursday, February 05,=
 2009
2:24 PM<br>
<b><span style=3D'font-weight:bold'>To:</span></b> Moger, Babu<br>
<b><span style=3D'font-weight:bold'>Cc:</span></b> dm-devel@redhat.com<br>
<b><span style=3D'font-weight:bold'>Subject:</span></b> Re: FW: [dm-devel]
Multipath setup and rdac questions</span></font><o:p></o:p></p>

</div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'><o:p>&nbsp;</o:p></span></font></p>

<p class=3DMsoNormal style=3D'margin-bottom:12.0pt'><font size=3D3
face=3D"Times New Roman"><span style=3D'font-size:12.0pt'><o:p>&nbsp;</o:p>=
</span></font></p>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'>On Thu, Feb 5, 2009 at 8:34 PM, Moger, Babu &lt;<a
href=3D"mailto:Babu.Moger@lsi.com">Babu.Moger@lsi.com</a>&gt; wrote:<o:p></=
o:p></span></font></p>

<div link=3Dblue vlink=3Dblue>

<div>

<p><font size=3D2 color=3Dnavy face=3DArial><span style=3D'font-size:10.0pt=
;font-family:
Arial;color:navy'>It is still not correct. &nbsp;The product id &quot;</spa=
n></font>MD
Virtual Disk&quot; is the device claimed by MPP. That means you still have =
mpp
in your system.<o:p></o:p></p>

<p><font size=3D3 face=3D"Times New Roman"><span style=3D'font-size:12.0pt'=
>&nbsp;<o:p></o:p></span></font></p>

<p><font size=3D3 face=3D"Times New Roman"><span style=3D'font-size:12.0pt'=
>Please
follow the steps below..<o:p></o:p></span></font></p>

<p><font size=3D3 face=3D"Times New Roman"><span style=3D'font-size:12.0pt'=
>&nbsp;<o:p></o:p></span></font></p>

<ol start=3D1 type=3D1>
 <li class=3DMsoNormal style=3D'mso-margin-top-alt:auto;mso-margin-bottom-a=
lt:auto;
     mso-list:l0 level1 lfo1'><font size=3D3 face=3D"Times New Roman"><span
     style=3D'font-size:12.0pt'>Remove the MPP from your system.<o:p></o:p>=
</span></font></li>
</ol>

<p style=3D'margin-left:.5in'><font size=3D3 face=3D"Times New Roman"><span
style=3D'font-size:12.0pt'>Find the directory where MPP sources are located=
. It
should be somewhere in /opt/. &nbsp;Then run &quot;make uninstall&quot;<o:p=
></o:p></span></font></p>

<p><font size=3D3 face=3D"Times New Roman"><span style=3D'font-size:12.0pt'=
>&nbsp;<o:p></o:p></span></font></p>

<p><font size=3D3 face=3D"Times New Roman"><span style=3D'font-size:12.0pt'=
>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
2. Send me output of /proc/scsi/scsi<o:p></o:p></span></font></p>

</div>

</div>

<div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'><br>
Ok. Thank you for spotting this.<br>
<br>
The Makefile resided in /usr/src/linuxrdac-09.03.0C06.0030<br>
I did the following to stop the mpp modules from loading at boot:<br>
<br>
i first did:<br>
<br>
&nbsp;# cd /usr/src/linuxrdac-09.03.0C06.0030<br>
&nbsp;/usr/src/linuxrdac-09.03.0C06.0030 # make uninstall<br>
<br>
This removed some files (amongst others the files in /opt/mpp)<br>
<br>
I rebooted, but the the mpp* drivers still were loaded after reboot.<br>
<br>
I then changed the /etc/modprobde.conf and commented out the mpp drivers:<b=
r>
<br>
#alias scsi_hostadapter0 mppVhba<br>
#alias scsi_hostadapter1 mppUpper<br>
<br>
This was not enough, I still had the mpp* drivers after reboot.<br>
<br>
So I looked in /boot and found an &quot;old&quot; version of initrd, and I
assume<br>
this was the initrd used before the mpp driver was installed.<br>
So I changed /boot/grub/menu.lst to use the &quot;previous&quot; initrd, an=
d
then rebooted.<br>
Now, I don't have any mpp drivers loaded anymore.<br>
<br>
And here's the output of /proc/scsi/scsi:<br>
<br>
# cat /proc/scsi/scsi<br>
Attached devices:<br>
Host: scsi0 Channel: 00 Id: 00 Lun: 00<br>
&nbsp; Vendor: SEAGATE&nbsp; Model:
ST973451SS&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: SM04<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
Host: scsi0 Channel: 00 Id: 01 Lun: 00<br>
&nbsp; Vendor: SEAGATE&nbsp; Model:
ST973451SS&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: SM04<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
Host: scsi0 Channel: 01 Id: 00 Lun: 00<br>
&nbsp; Vendor: Dell&nbsp;&nbsp;&nbsp;&nbsp; Model: VIRTUAL
DISK&nbsp;&nbsp;&nbsp;&nbsp; Rev: 1028<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
Host: scsi5 Channel: 00 Id: 00 Lun: 00<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model:
MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
Host: scsi6 Channel: 00 Id: 00 Lun: 00<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model:
MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
Host: scsi7 Channel: 00 Id: 00 Lun: 00<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model:
MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
Host: scsi8 Channel: 00 Id: 00 Lun: 00<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model: MD3000i&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
Host: scsi3 Channel: 00 Id: 00 Lun: 00<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model:
MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
Host: scsi4 Channel: 00 Id: 00 Lun: 00<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model:
MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
Host: scsi5 Channel: 00 Id: 00 Lun: 10<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model:
MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;
ANSI SCSI revision: 05<br>
Host: scsi6 Channel: 00 Id: 00 Lun: 10<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model:
MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
Host: scsi3 Channel: 00 Id: 00 Lun: 01<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model:
MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
Host: scsi4 Channel: 00 Id: 00 Lun: 01<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model:
MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
Host: scsi1 Channel: 00 Id: 00 Lun: 00<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model:
MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
Host: scsi2 Channel: 00 Id: 00 Lun: 00<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model:
MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
Host: scsi5 Channel: 00 Id: 00 Lun: 11<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model:
MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
Host: scsi6 Channel: 00 Id: 00 Lun: 11<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model:
MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
Host: scsi5 Channel: 00 Id: 00 Lun: 12<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model:
MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;
ANSI SCSI revision: 05<br>
Host: scsi6 Channel: 00 Id: 00 Lun: 12<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model:
MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
Host: scsi7 Channel: 00 Id: 00 Lun: 10<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model:
MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
Host: scsi8 Channel: 00 Id: 00 Lun: 10<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model:
MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
Host: scsi7 Channel: 00 Id: 00 Lun: 11<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model:
MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
Host: scsi8 Channel: 00 Id: 00 Lun: 11<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model:
MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
Host: scsi3 Channel: 00 Id: 00 Lun: 02<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model:
MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
Host: scsi4 Channel: 00 Id: 00 Lun: 02<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model:
MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
Host: scsi3 Channel: 00 Id: 00 Lun: 03<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model:
MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
Host: scsi4 Channel: 00 Id: 00 Lun: 03<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model:
MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
Host: scsi1 Channel: 00 Id: 00 Lun: 01<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model:
MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
Host: scsi2 Channel: 00 Id: 00 Lun: 01<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model:
MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
Host: scsi1 Channel: 00 Id: 00 Lun: 02<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model:
MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
Host: scsi2 Channel: 00 Id: 00 Lun: 02<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model:
MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;
ANSI SCSI revision: 05<br>
Host: scsi6 Channel: 00 Id: 00 Lun: 13<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model:
MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
Host: scsi5 Channel: 00 Id: 00 Lun: 13<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model:
MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
Host: scsi5 Channel: 00 Id: 00 Lun: 14<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model:
MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
Host: scsi6 Channel: 00 Id: 00 Lun: 14<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model:
MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
Host: scsi7 Channel: 00 Id: 00 Lun: 12<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model:
MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
Host: scsi8 Channel: 00 Id: 00 Lun: 12<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model:
MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
Host: scsi7 Channel: 00 Id: 00 Lun: 13<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model:
MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
Host: scsi8 Channel: 00 Id: 00 Lun: 13<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model:
MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
Host: scsi3 Channel: 00 Id: 00 Lun: 04<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model:
MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
Host: scsi4 Channel: 00 Id: 00 Lun: 04<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model: MD3000i&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
Host: scsi3 Channel: 00 Id: 00 Lun: 05<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model:
MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
Host: scsi4 Channel: 00 Id: 00 Lun: 05<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model:
MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
Host: scsi3 Channel: 00 Id: 00 Lun: 31<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model: Universal Xport&nbsp; Re=
v:
0735<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;
ANSI SCSI revision: 05<br>
Host: scsi4 Channel: 00 Id: 00 Lun: 31<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model: Universal Xport&nbsp; Re=
v:
0735<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
Host: scsi1 Channel: 00 Id: 00 Lun: 03<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model:
MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
Host: scsi2 Channel: 00 Id: 00 Lun: 03<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model:
MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
Host: scsi1 Channel: 00 Id: 00 Lun: 04<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model:
MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
Host: scsi2 Channel: 00 Id: 00 Lun: 04<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model:
MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
Host: scsi6 Channel: 00 Id: 00 Lun: 15<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model:
MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
Host: scsi5 Channel: 00 Id: 00 Lun: 15<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model:
MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
Host: scsi7 Channel: 00 Id: 00 Lun: 14<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model:
MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
Host: scsi8 Channel: 00 Id: 00 Lun: 14<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model:
MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
Host: scsi7 Channel: 00 Id: 00 Lun: 15<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model: MD3000i&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
Host: scsi8 Channel: 00 Id: 00 Lun: 15<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model:
MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
Host: scsi5 Channel: 00 Id: 00 Lun: 31<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model: Universal Xport&nbsp; Re=
v:
0735<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
Host: scsi6 Channel: 00 Id: 00 Lun: 31<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model: Universal Xport&nbsp; Re=
v:
0735<br>
&nbsp; Type:&nbsp;&nbsp; Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;
ANSI SCSI revision: 05<br>
Host: scsi8 Channel: 00 Id: 00 Lun: 31<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model: Universal Xport&nbsp; Re=
v:
0735<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
Host: scsi7 Channel: 00 Id: 00 Lun: 31<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model: Universal Xport&nbsp; Re=
v:
0735<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
Host: scsi1 Channel: 00 Id: 00 Lun: 05<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model:
MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
Host: scsi2 Channel: 00 Id: 00 Lun: 05<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model:
MD3000i&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Rev: 0735<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
Host: scsi1 Channel: 00 Id: 00 Lun: 31<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model: Universal Xport&nbsp; Re=
v:
0735<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
Host: scsi2 Channel: 00 Id: 00 Lun: 31<br>
&nbsp; Vendor: DELL&nbsp;&nbsp;&nbsp;&nbsp; Model: Universal Xport&nbsp; Re=
v:
0735<br>
&nbsp; Type:&nbsp;&nbsp;
Direct-Access&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
ANSI SCSI revision: 05<br>
<br>
<br>
Thank you<br>
Christian<br>
<br>
&nbsp;<o:p></o:p></span></font></p>

</div>

</div>

<p class=3DMsoNormal><font size=3D3 face=3D"Times New Roman"><span style=3D=
'font-size:
12.0pt'><o:p>&nbsp;</o:p></span></font></p>

</div>

</body>

</html>

--_000_E463DF2B2E584B4A82673F53D62C2EF46653B584cosmail01lsicom_--


--===============0076008746==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0076008746==--
