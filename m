From: "Sampathkumar, Kishore" <Kishore.SampathKumar@lsi.com>
Subject: question on hot plug removal and addition of a USB disk
Date: Thu, 15 Sep 2011 07:10:00 +0530
Message-ID: <E4D7778E36CF944ABD2F7E18D2DB96660CA26D8EF2@inbmail02.lsi.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3093065572245442561=="
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
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============3093065572245442561==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_E4D7778E36CF944ABD2F7E18D2DB96660CA26D8EF2inbmail02lsic_"

--_000_E4D7778E36CF944ABD2F7E18D2DB96660CA26D8EF2inbmail02lsic_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

I sent the below query (appended in this email) to linux-scsi and linux-hot=
plug mailing lists.

I wanted to know how Device Mapper handles backend disks managed by Device =
mapper targets.

Consider the below command:



# dmsetup create linear-map linear-map-table where, linear-map-table contai=
ns:

       0 1028160 linear /dev/sda 0

       1028160 3903762 linear /dev/sdb 0



Now, when the above is executed, does device mapper open /dev/sda and /dev/=
sdb, and continue to maintain reference counts to the underlying SCSI block=
 devices in the kernel corresponding to them?



Assume that on successful completion of the above command, a file system is=
 created on /dev/mapper/linear-map and then mounted on /mnt. Let us say /de=
v/sdb corresponds to a USB disk. Suppose this USB disk is pulled out (hot p=
lug removal), and then added back after some time (hot plug addition). Let =
us assume that the USB disk is untouched between removal and insertion. The=
 USB disk on re-insertion gets a different name (say /dev/sde). Given the b=
elow context, what are the specific steps the user has to follow to ensure =
that the file system access can resume on the USB disk that was hot-plug ad=
ded? So, do we have to redo the dmsetup command with /dev/sde in place of /=
dev/sdb? How do we do that when the file system is still mounted?



Thanks,

- Kishore



-----Original Message-----

From: Sampathkumar, Kishore

Sent: Thursday, September 15, 2011 1:54 AM

To: 'linux-hotplug@vger.kernel.org'

Subject: question on hot plug removal and addition of a USB disk



I sent the below query to linux-scsi. Thought it would be better to check o=
n the linux-hotplug mailing list.

Can you please provide the details of the expected behavior, and where in t=
he code should I look for details?



Thanks and Regards,

- Kishore



-----Original Message-----

From: Sampathkumar, Kishore

Sent: Wednesday, September 14, 2011 7:47 PM

To: 'linux-scsi@vger.kernel.org'

Subject: question on hot plug removal and addition of a USB disk



Scenario: I have a file system on a USB SCSI disk /dev/sdb mounted on /mnt.

I perform Action 1 below, and after some time, perform Action 2 below.



Action 1: removal (unplug) of a USB disk



At the time of removal of the USB disk, since the file system was mounted, =
is the reference to kobject corresponding (now orphaned) sdb still maintain=
ed in the kernel, although /dev/sdb is gone due to disk removal?



Is it that the old scsi_disk (sdb) still persists, but, the underlying scsi=
_dev is removed? Where should I start to trace the hotplug removal of the U=
SB disk? What are the specific processing steps involved in the kernel to h=
andle this (in terms of main routines handling this)?



Action 2: (hot) plug addition of the same USB SCSI disk



On plugging in the same USB SCSI disk, does the sd layer in scsi subsystem =
grab the first available 'free' sdX device (say sdp), given that sdb is sti=
ll being referenced by the mounted file system?



Again, in terms of code, does this correspond to:

-     a new scsi_dev being allocated

-     a corresponding scsi_disk for sdp being allocated by the sd layer in =
scsi subsystem as part of 'probe' for the added SCSI device



Does the hot plugging work the same way for SAS disks attached behind a FC =
switch?



Thanks,

-     Kishore

--_000_E4D7778E36CF944ABD2F7E18D2DB96660CA26D8EF2inbmail02lsic_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40"><head><meta http-equiv=3DContent-Type content=
=3D"text/html; charset=3Dus-ascii"><meta name=3DGenerator content=3D"Micros=
oft Word 12 (filtered medium)"><style><!--
/* Font Definitions */
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
@font-face
	{font-family:Tahoma;
	panose-1:2 11 6 4 3 5 4 4 2 4;}
@font-face
	{font-family:Consolas;
	panose-1:2 11 6 9 2 2 4 3 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:purple;
	text-decoration:underline;}
p.MsoPlainText, li.MsoPlainText, div.MsoPlainText
	{mso-style-priority:99;
	mso-style-link:"Plain Text Char";
	margin:0in;
	margin-bottom:.0001pt;
	font-size:10.5pt;
	font-family:Consolas;}
p.MsoAcetate, li.MsoAcetate, div.MsoAcetate
	{mso-style-priority:99;
	mso-style-link:"Balloon Text Char";
	margin:0in;
	margin-bottom:.0001pt;
	font-size:8.0pt;
	font-family:"Tahoma","sans-serif";}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri","sans-serif";
	color:windowtext;}
span.PlainTextChar
	{mso-style-name:"Plain Text Char";
	mso-style-priority:99;
	mso-style-link:"Plain Text";
	font-family:Consolas;}
span.BalloonTextChar
	{mso-style-name:"Balloon Text Char";
	mso-style-priority:99;
	mso-style-link:"Balloon Text";
	font-family:"Tahoma","sans-serif";}
.MsoChpDefault
	{mso-style-type:export-only;}
@page WordSection1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
	{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]--></head><body lang=3DEN-US link=3Dblue vli=
nk=3Dpurple><div class=3DWordSection1><p class=3DMsoPlainText>I sent the be=
low query (appended in this email) to linux-scsi and linux-hotplug mailing =
lists.<o:p></o:p></p><p class=3DMsoPlainText>I wanted to know how Device Ma=
pper handles backend disks managed by Device mapper targets.<o:p></o:p></p>=
<p class=3DMsoPlainText>Consider the below command:<o:p></o:p></p><p class=
=3DMsoPlainText><o:p>&nbsp;</o:p></p><p class=3DMsoPlainText># dmsetup crea=
te linear-map linear-map-table where, linear-map-table contains:<o:p></o:p>=
</p><p class=3DMsoPlainText>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0 1028160 =
linear /dev/sda 0<o:p></o:p></p><p class=3DMsoPlainText>&nbsp;&nbsp; &nbsp;=
&nbsp;&nbsp;&nbsp;1028160 3903762 linear /dev/sdb 0<o:p></o:p></p><p class=
=3DMsoPlainText><o:p>&nbsp;</o:p></p><p class=3DMsoPlainText>Now, when the =
above is executed, does device mapper open /dev/sda and /dev/sdb, and conti=
nue to maintain reference counts to the underlying SCSI block devices in th=
e kernel corresponding to them?<o:p></o:p></p><p class=3DMsoPlainText><o:p>=
&nbsp;</o:p></p><p class=3DMsoPlainText>Assume that on successful completio=
n of the above command, a file system is created on /dev/mapper/linear-map =
and then mounted on /mnt. Let us say /dev/sdb corresponds to a USB disk. Su=
ppose this USB disk is pulled out (hot plug removal), and then added back a=
fter some time (hot plug addition). Let us assume that the USB disk is unto=
uched between removal and insertion. The USB disk on re-insertion gets a di=
fferent name (say /dev/sde). Given the below context, what are the specific=
 steps the user has to follow to ensure that the file system access can res=
ume on the USB disk that was hot-plug added? So, do we have to redo the dms=
etup command with /dev/sde in place of /dev/sdb? How do we do that when the=
 file system is still mounted?<o:p></o:p></p><p class=3DMsoPlainText><o:p>&=
nbsp;</o:p></p><p class=3DMsoPlainText>Thanks,<o:p></o:p></p><p class=3DMso=
PlainText>- Kishore<o:p></o:p></p><p class=3DMsoPlainText><o:p>&nbsp;</o:p>=
</p><p class=3DMsoPlainText>-----Original Message-----<o:p></o:p></p><p cla=
ss=3DMsoPlainText>From: Sampathkumar, Kishore<o:p></o:p></p><p class=3DMsoP=
lainText>Sent: Thursday, September 15, 2011 1:54 AM<o:p></o:p></p><p class=
=3DMsoPlainText>To: 'linux-hotplug@vger.kernel.org'<o:p></o:p></p><p class=
=3DMsoPlainText>Subject: question on hot plug removal and addition of a USB=
 disk<o:p></o:p></p><p class=3DMsoPlainText><o:p>&nbsp;</o:p></p><p class=
=3DMsoPlainText>I sent the below query to linux-scsi. Thought it would be b=
etter to check on the linux-hotplug mailing list.<o:p></o:p></p><p class=3D=
MsoPlainText>Can you please provide the details of the expected behavior, a=
nd where in the code should I look for details?<o:p></o:p></p><p class=3DMs=
oPlainText><o:p>&nbsp;</o:p></p><p class=3DMsoPlainText>Thanks and Regards,=
<o:p></o:p></p><p class=3DMsoPlainText>- Kishore<o:p></o:p></p><p class=3DM=
soPlainText><o:p>&nbsp;</o:p></p><p class=3DMsoPlainText>-----Original Mess=
age-----<o:p></o:p></p><p class=3DMsoPlainText>From: Sampathkumar, Kishore<=
o:p></o:p></p><p class=3DMsoPlainText>Sent: Wednesday, September 14, 2011 7=
:47 PM<o:p></o:p></p><p class=3DMsoPlainText>To: 'linux-scsi@vger.kernel.or=
g'<o:p></o:p></p><p class=3DMsoPlainText>Subject: question on hot plug remo=
val and addition of a USB disk<o:p></o:p></p><p class=3DMsoPlainText><o:p>&=
nbsp;</o:p></p><p class=3DMsoPlainText>Scenario: I have a file system on a =
USB SCSI disk /dev/sdb mounted on /mnt.<o:p></o:p></p><p class=3DMsoPlainTe=
xt>I perform Action 1 below, and after some time, perform Action 2 below.<o=
:p></o:p></p><p class=3DMsoPlainText><o:p>&nbsp;</o:p></p><p class=3DMsoPla=
inText>Action 1: removal (unplug) of a USB disk<o:p></o:p></p><p class=3DMs=
oPlainText><o:p>&nbsp;</o:p></p><p class=3DMsoPlainText>At the time of remo=
val of the USB disk, since the file system was mounted, is the reference to=
 kobject corresponding (now orphaned) sdb still maintained in the kernel, a=
lthough /dev/sdb is gone due to disk removal?<o:p></o:p></p><p class=3DMsoP=
lainText><o:p>&nbsp;</o:p></p><p class=3DMsoPlainText>Is it that the old sc=
si_disk (sdb) still persists, but, the underlying scsi_dev is removed? Wher=
e should I start to trace the hotplug removal of the USB disk? What are the=
 specific processing steps involved in the kernel to handle this (in terms =
of main routines handling this)?<o:p></o:p></p><p class=3DMsoPlainText><o:p=
>&nbsp;</o:p></p><p class=3DMsoPlainText>Action 2: (hot) plug addition of t=
he same USB SCSI disk<o:p></o:p></p><p class=3DMsoPlainText><o:p>&nbsp;</o:=
p></p><p class=3DMsoPlainText>On plugging in the same USB SCSI disk, does t=
he sd layer in scsi subsystem grab the first available &#8216;free&#8217; s=
dX device (say sdp), given that sdb is still being referenced by the mounte=
d file system?<o:p></o:p></p><p class=3DMsoPlainText><o:p>&nbsp;</o:p></p><=
p class=3DMsoPlainText>Again, in terms of code, does this correspond to:<o:=
p></o:p></p><p class=3DMsoPlainText>-&nbsp;&nbsp;&nbsp;&nbsp; a new scsi_de=
v being allocated<o:p></o:p></p><p class=3DMsoPlainText>-&nbsp;&nbsp;&nbsp;=
&nbsp; a corresponding scsi_disk for sdp being allocated by the sd layer in=
 scsi subsystem as part of &#8216;probe&#8217; for the added SCSI device<o:=
p></o:p></p><p class=3DMsoPlainText><o:p>&nbsp;</o:p></p><p class=3DMsoPlai=
nText>Does the hot plugging work the same way for SAS disks attached behind=
 a FC switch?<o:p></o:p></p><p class=3DMsoPlainText><o:p>&nbsp;</o:p></p><p=
 class=3DMsoPlainText>Thanks,<o:p></o:p></p><p class=3DMsoPlainText>-&nbsp;=
&nbsp;&nbsp;&nbsp; Kishore<o:p></o:p></p></div></body></html>=

--_000_E4D7778E36CF944ABD2F7E18D2DB96660CA26D8EF2inbmail02lsic_--


--===============3093065572245442561==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3093065572245442561==--
