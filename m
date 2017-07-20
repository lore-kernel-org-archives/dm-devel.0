From: Muneendra Kumar M <mmandala@Brocade.com>
Subject: multipath dm_request_fn(in dm.c) is not getting called
Date: Thu, 20 Jul 2017 14:01:20 +0000
Message-ID: <3a25d3543b9f4d42846fb9b0238fca15@BRMWP-EXMB12.corp.brocade.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6024270914117698794=="
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

--===============6024270914117698794==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_3a25d3543b9f4d42846fb9b0238fca15BRMWPEXMB12corpbrocadec_"

--_000_3a25d3543b9f4d42846fb9b0238fca15BRMWPEXMB12corpbrocadec_
Content-Type: text/plain; charset="us-ascii"

Hi,
We are testing the multipath behavior on centos7.3 and linux version Linux EC056108 3.10.
We have two paths connected to dm-1(sda and sdb).
We are using fio tool to read  data from /dev/dm-1 and we are seeing data on both paths(sda and sdb)
Below is the fio  command which we are using
./fio --filename=/dev/dm-2 --direct=1 --rw=randrw --refill_buffers --norandommap --randrepeat=0 --ioengine=libaio --bs=512k --rwmixread=100 --iodepth=16 --numjobs=16 --runtime=60 --group_reporting --name=4ktest --size=500m

Test Case: Dropping all the requests on sdb .

Observation: When we drop frames on sdb we observe  that on both sda and sdb there is no data flow.
HBA is taking around 30 secs to report the io failure then followed by failover.
During this 30 secs time we are not seeing any data on sda and even dm_request_fn(in dm.c) is not getting called which internally pushes the queue request to sda/sdb.
Theoretically data should flow on sda as we are dropping data only on  sdb.

Any inputs here will help me to understand the concept better.

Regards,
Muneendra.





--_000_3a25d3543b9f4d42846fb9b0238fca15BRMWPEXMB12corpbrocadec_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<meta name=3D"Generator" content=3D"Microsoft Word 15 (filtered medium)">
<style><!--
/* Font Definitions */
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri",sans-serif;}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:#0563C1;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:#954F72;
	text-decoration:underline;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri",sans-serif;
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-family:"Calibri",sans-serif;}
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
</o:shapelayout></xml><![endif]-->
</head>
<body lang=3D"EN-US" link=3D"#0563C1" vlink=3D"#954F72">
<div class=3D"WordSection1">
<p class=3D"MsoNormal">Hi,<o:p></o:p></p>
<p class=3D"MsoNormal">We are testing the multipath behavior on centos7.3 a=
nd linux version Linux EC056108 3.10.<o:p></o:p></p>
<p class=3D"MsoNormal">We have two paths connected to dm-1(sda and sdb).<o:=
p></o:p></p>
<p class=3D"MsoNormal">We are using fio tool to read &nbsp;data from /dev/d=
m-1 and we are seeing data on both paths(sda and sdb)<o:p></o:p></p>
<p class=3D"MsoNormal">Below is the fio&nbsp; command which we are using<o:=
p></o:p></p>
<p class=3D"MsoNormal">./fio --filename=3D/dev/dm-2 --direct=3D1 --rw=3Dran=
drw --refill_buffers --norandommap --randrepeat=3D0 --ioengine=3Dlibaio --b=
s=3D512k --rwmixread=3D100 --iodepth=3D16 --numjobs=3D16 --runtime=3D60 --g=
roup_reporting --name=3D4ktest --size=3D500m<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Test Case: Dropping all the requests on sdb .<o:p></=
o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Observation: When we drop frames on sdb we observe &=
nbsp;that on both sda and sdb there is no data flow.<o:p></o:p></p>
<p class=3D"MsoNormal">HBA is taking around 30 secs to report the io failur=
e then followed by failover.<o:p></o:p></p>
<p class=3D"MsoNormal">During this 30 secs time we are not seeing any data =
on sda and even dm_request_fn(in dm.c) is not getting called which internal=
ly pushes the queue request to sda/sdb.<o:p></o:p></p>
<p class=3D"MsoNormal">Theoretically data should flow on sda as we are drop=
ping data only on &nbsp;sdb.<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Any inputs here will help me to understand the conce=
pt better.<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Regards,<o:p></o:p></p>
<p class=3D"MsoNormal">Muneendra.<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
</div>
</body>
</html>

--_000_3a25d3543b9f4d42846fb9b0238fca15BRMWPEXMB12corpbrocadec_--


--===============6024270914117698794==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6024270914117698794==--
