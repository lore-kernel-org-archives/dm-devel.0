From: Moshe Lazarov <Moshe.Lazarov@axxana.com>
Subject: Thin-provisioned LVs throughput
Date: Thu, 27 Jul 2017 23:02:05 +0000
Message-ID: <HE1PR0901MB1497DF55B59376C14F754FAF95BE0@HE1PR0901MB1497.eurprd09.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0484686530243860992=="
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
Cc: Moshe Lazarov <Moshe.Lazarov@axxana.com>
List-Id: dm-devel.ids

--===============0484686530243860992==
Content-Language: en-US
Content-Type: multipart/related;
	boundary="_005_HE1PR0901MB1497DF55B59376C14F754FAF95BE0HE1PR0901MB1497_";
	type="multipart/alternative"

--_005_HE1PR0901MB1497DF55B59376C14F754FAF95BE0HE1PR0901MB1497_
Content-Type: multipart/alternative;
	boundary="_000_HE1PR0901MB1497DF55B59376C14F754FAF95BE0HE1PR0901MB1497_"

--_000_HE1PR0901MB1497DF55B59376C14F754FAF95BE0HE1PR0901MB1497_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,
I am Moshe Lazarov. A researcher in Axxana (https://www.axxana.com). We hav=
e developed a Black Box to for Zero Data Loss in asynchronous replications =
systems.
We consider integrating the LVM2 and its thinly-provisioned and snapshots m=
echanisms to our product.
Lately I have been running several experiments with LVs and snapshots, usin=
g LVM2 (LVM2.2.02.98) and Linux Kernel 4.9.11.
The platforms which I run the tests on are VM (on Dell server carrying inte=
l Xeon E5-2620 CPUs with 2 SAS HDDs) and Axxana's Black Box ("BBX"); a uniq=
ue motherboard carrying intel i7-3517UE CPU and 2 SAS SSDs.
Both platforms run the same scripts and tester application for creating the=
 destinations (LVs and snapshots) and writing to them. The VG (that include=
 all the LVs and snapshots) is stripped (64KB) over the 2 drives.
In the graph below one can see the throughput of writing 1GB (each time a d=
ifferent and random 1GB is written) to each of the destinations in the VM o=
r in the BBX:
SlowLV - A linear LV.
T0 1st - 1st write to a thinly-provisioned LV. Since the allocation of a ch=
unk is initiated in this access, the downgraded throughput is clear.
T0 - Consecutive writes to T0 (thinly-provisioned LV).
T0S0 1st - 1st write to a thinly-provisioned snapshot of T0 (the thinly-pro=
visioned LV above). Since the allocation of a chunk is initiated in this ac=
cess, the downgraded throughput is clear.
T0S0 - Consecutive writes to T0S0 (the snapshot of thinly-provisioned LV).

[cid:image004.png@01D306F1.ABEA4B60]

IMHO, the degradation of the throughput between writes to the SlowLV and wr=
ites to T0 or T0S0 is extremely high; while the BBX writes to the LV in ~74=
0MBps, the writes to other destinations is limited to ~400Mbps (almost 50% =
degradation). On the VM there ~17% degradation at least.
Since both platforms run the same code and reach around the same write thro=
ughput, it seems that the SW/Kernel is the bottleneck for achieving higher =
throughput.
What is your opinion about that?
In addition, I added the output of IOSTAT while executing writes to T0 (thi=
n-provisioned LV).
The following legend applies:
vg-slowlv                                             (252:0)
vg-ramlv1                                           (252:1)
vg-ramlv2                                           (252:2)
vg-poolThinDataLV_tmeta           (252:3)
vg-poolThinDataLV_tdata             (252:4)
vg-poolThinDataLV-tpool              (252:5)
vg-poolThinDataLV                          (252:6)
vg-t0                                                      (252:7)
vg-t0s0                                                 (252:8)

1GB of data was written during 3 IOSTAT sampling windows (samples every 1 s=
econd). See in yellow in the 2nd second window; data was written to dm-4 (p=
oolThinDataLV_tdata) and dm-5 (poolThinDataLV-tpool) at 557MBps, while it w=
as written to dm-7 (t0) in 820MBps.
During the 1st second window, the behavior was different; data was written =
to dm-4, dm-5 and dm-7 at the same throughput (average of 204MBps over this=
 1 second window).
In other cases, data is written to the 3 destinations at the same speed dur=
ing all three 1 second windows.
What could be the reason for the behavior in the 2nd window?
Is data really written twice to dm-4 and dm-5 (one time for each), or is it=
 the same write?
Can throughput be improved by increasing the request size (write in larger =
packets, how?)?

avg-cpu:

%user

%nice

%system

%iowait

%steal

%idle


0.26

0

30.08

0

0

69.67


Device:

rrqm/s

wrqm/s

r/s

w/s

rMB/s

wMB/s

avgrq-sz

avgqu-sz

await

r_await

w_await

svctm

%util

sda

0

0

19

0

0.07

0

8

0.04

2.11

2.11

0

0.21

0.4

sdb

0

24785

14

1312

0.05

96.31

148.84

5.69

4.17

0.29

4.21

0.44

58.4

sdc

0

24772

1

1312

0

96.31

150.23

5.52

4.07

0

4.08

0.44

58.4

dm-0

0

0

0

0

0

0

0

0

0

0

0

0

0

dm-1

0

0

0

0

0

0

0

0

0

0

0

0

0

dm-2

0

0

0

0

0

0

0

0

0

0

0

0

0

dm-3

0

0

15

0

0.06

0

8

0

0.27

0.27

0

0.27

0.4

dm-4

0

0

0

52224

0

204

8

1253.31

23.21

0

23.21

0.01

58.4

dm-5

0

0

0

52224

0

204

8

1253.35

23.21

0

23.21

0.01

58.4

dm-7

0

0

0

52225

0

204

8

1255.08

23.25

0

23.25

0.01

58.4

dm-8

0

0

0

0

0

0

0

0

0

0

0

0

0


avg-cpu:

%user

%nice

%system

%iowait

%steal

%idle


0

0

57.37

3.68

0

38.95


Device:

rrqm/s

wrqm/s

r/s

w/s

rMB/s

wMB/s

avgrq-sz

avgqu-sz

await

r_await

w_await

svctm

%util

sda

0

0

1

0

0

0

8

0

0

0

0

0

0

sdb

0

18031

20

53270

0.08

284.15

10.92

52.74

0.99

3.4

0.99

0.02

99.6

sdc

0

18044

27

53264

0.11

284.12

10.92

32.19

0.61

0.59

0.61

0.02

99.2

dm-0

0

0

0

0

0

0

0

0

0

0

0

0

0

dm-1

0

0

0

0

0

0

0

0

0

0

0

0

0

dm-2

0

0

0

0

0

0

0

0

0

0

0

0

0

dm-3

0

0

47

0

0.18

0

8

0.08

1.79

1.79

0

0.6

2.8

dm-4

0

0

0

142612

0

557.08

8

1505.75

10.85

0

10.85

0.01

100

dm-5

0

0

0

142613

0

557.08

8

1545.26

10.85

0

10.85

0.01

100

dm-7

0

0

0

209919

0

820

8

35341.8

87.93

0

87.93

0

100

dm-8

0

0

0

0

0

0

0

0

0

0

0

0

0


avg-cpu:

%user

%nice

%system

%iowait

%steal

%idle


0.51

0

30.61

9.95

0

58.93


Device:

rrqm/s

wrqm/s

r/s

w/s

rMB/s

wMB/s

avgrq-sz

avgqu-sz

await

r_await

w_await

svctm

%util

sda

0

8

1291

4

5.83

0.05

9.3

1.62

1.25

1.25

2

0.12

15.2

sdb

0

0

0

33674

0

131.54

8

9.09

0.27

0

0.27

0.01

43.2

sdc

0

0

0

33680

0

131.56

8

7

0.21

0

0.21

0.01

43.6

dm-0

0

0

0

0

0

0

0

0

0

0

0

0

0

dm-1

0

0

0

0

0

0

0

0

0

0

0

0

0

dm-2

0

0

0

0

0

0

0

0

0

0

0

0

0

dm-3

0

0

0

0

0

0

0

0

0

0

0

0

0

dm-4

0

0

0

67308

0

262.92

8

15.96

0.24

0

0.24

0.01

43.6

dm-5

0

0

0

67307

0

262.92

8

16.2

0.24

0

0.24

0.01

43.6

dm-7

0

0

0

0

0

0

0

14886.74

0

0

0

0

43.6

dm-8

0

0

0

0

0

0

0

0

0

0

0

0

0



I hope the information is clear.
I would appreciate your response to the questions I've raised above.

Thanks a lot,
-Moshe
----------------------------------------
Moshe Lazarov
Axxana

C:    +1-669-213-9752
F:    +972-74-7887878
www.axxana.com<UrlBlockedError.aspx>

[Description: cid:image004.jpg@01CD29D9.D454ED30]


--_000_HE1PR0901MB1497DF55B59376C14F754FAF95BE0HE1PR0901MB1497_
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
<!--[if !mso]><style>v\:* {behavior:url(#default#VML);}
o\:* {behavior:url(#default#VML);}
w\:* {behavior:url(#default#VML);}
.shape {behavior:url(#default#VML);}
</style><![endif]--><style><!--
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
	text-align:right;
	direction:rtl;
	unicode-bidi:embed;
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
	{mso-style-type:export-only;}
@page WordSection1
	{size:8.5in 11.0in;
	margin:1.0in 1.25in 1.0in 1.25in;}
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
<p class=3D"MsoNormal" style=3D"text-align:left;direction:ltr;unicode-bidi:=
embed">Hi,<o:p></o:p></p>
<p class=3D"MsoNormal" style=3D"text-align:left;direction:ltr;unicode-bidi:=
embed">I am Moshe Lazarov. A researcher in Axxana (<a href=3D"https://www.a=
xxana.com">https://www.axxana.com</a>). We have developed a Black Box to fo=
r Zero Data Loss in asynchronous replications
 systems. <o:p></o:p></p>
<p class=3D"MsoNormal" style=3D"text-align:left;direction:ltr;unicode-bidi:=
embed">We consider integrating the LVM2 and its thinly-provisioned and snap=
shots mechanisms to our product.
<o:p></o:p></p>
<p class=3D"MsoNormal" style=3D"text-align:left;direction:ltr;unicode-bidi:=
embed">Lately I have been running several experiments with LVs and snapshot=
s, using LVM2 (LVM2.2.02.98) and Linux Kernel 4.9.11.<o:p></o:p></p>
<p class=3D"MsoNormal" style=3D"text-align:left;direction:ltr;unicode-bidi:=
embed">The platforms which I run the tests on are VM (on Dell server carryi=
ng intel Xeon E5-2620 CPUs with 2 SAS HDDs) and Axxana&#8217;s Black Box (&=
#8220;BBX&#8221;); a unique motherboard carrying intel
 i7-3517UE CPU and 2 SAS SSDs.<o:p></o:p></p>
<p class=3D"MsoNormal" style=3D"text-align:left;direction:ltr;unicode-bidi:=
embed">Both platforms run the same scripts and tester application for creat=
ing the destinations (LVs and snapshots) and writing to them. The VG (that =
include all the LVs and snapshots) is
 stripped (64KB) over the 2 drives.<o:p></o:p></p>
<p class=3D"MsoNormal" style=3D"text-align:left;direction:ltr;unicode-bidi:=
embed">In the graph below one can see the throughput of writing 1GB (each t=
ime a different and random 1GB is written) to each of the destinations in t=
he VM or in the BBX:<o:p></o:p></p>
<p class=3D"MsoNormal" style=3D"text-align:left;direction:ltr;unicode-bidi:=
embed">SlowLV &#8211; A linear LV.<o:p></o:p></p>
<p class=3D"MsoNormal" style=3D"text-align:left;direction:ltr;unicode-bidi:=
embed">T0 1<sup>st</sup> &#8211; 1<sup>st</sup> write to a thinly-provision=
ed LV. Since the allocation of a chunk is initiated in this access, the dow=
ngraded throughput is clear.<o:p></o:p></p>
<p class=3D"MsoNormal" style=3D"text-align:left;direction:ltr;unicode-bidi:=
embed">T0 &#8211; Consecutive writes to T0 (thinly-provisioned LV).<o:p></o=
:p></p>
<p class=3D"MsoNormal" style=3D"text-align:left;direction:ltr;unicode-bidi:=
embed">T0S0 1<sup>st</sup> &#8211; 1<sup>st</sup> write to a thinly-provisi=
oned snapshot of T0 (the thinly-provisioned LV above). Since the allocation=
 of a chunk is initiated in this access, the
 downgraded throughput is clear.<o:p></o:p></p>
<p class=3D"MsoNormal" style=3D"text-align:left;direction:ltr;unicode-bidi:=
embed">T0S0 &#8211; Consecutive writes to T0S0 (the snapshot of thinly-prov=
isioned LV).<o:p></o:p></p>
<p class=3D"MsoNormal" style=3D"text-align:left;direction:ltr;unicode-bidi:=
embed"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal" style=3D"text-align:left;direction:ltr;unicode-bidi:=
embed"><img border=3D"0" width=3D"728" height=3D"275" style=3D"width:7.5833=
in;height:2.8645in" id=3D"_x0000_i1026" src=3D"cid:image004.png@01D306F1.AB=
EA4B60"><o:p></o:p></p>
<p class=3D"MsoNormal" style=3D"text-align:left;direction:ltr;unicode-bidi:=
embed"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal" style=3D"text-align:left;direction:ltr;unicode-bidi:=
embed">IMHO, the degradation of the throughput between writes to the SlowLV=
 and writes to T0 or T0S0 is extremely high; while the BBX writes to the LV=
 in ~740MBps, the writes to other destinations
 is limited to ~400Mbps (almost 50% degradation). On the VM there ~17% degr=
adation at least.<o:p></o:p></p>
<p class=3D"MsoNormal" style=3D"text-align:left;direction:ltr;unicode-bidi:=
embed">Since both platforms run the same code and reach around the same wri=
te throughput, it seems that the SW/Kernel is the bottleneck for achieving =
higher throughput.<o:p></o:p></p>
<p class=3D"MsoNormal" style=3D"text-align:left;direction:ltr;unicode-bidi:=
embed">What is your opinion about that?<o:p></o:p></p>
<p class=3D"MsoNormal" style=3D"text-align:left;direction:ltr;unicode-bidi:=
embed">In addition, I added the output of IOSTAT while executing writes to =
T0 (thin-provisioned LV).<o:p></o:p></p>
<p class=3D"MsoNormal" style=3D"text-align:left;direction:ltr;unicode-bidi:=
embed">The following legend applies:<o:p></o:p></p>
<p class=3D"MsoNormal" style=3D"text-align:left;direction:ltr;unicode-bidi:=
embed">vg-slowlv&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (252:0)<o:p></o:p></p>
<p class=3D"MsoNormal" style=3D"text-align:left;direction:ltr;unicode-bidi:=
embed">vg-ramlv1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (252:1)<o:p></o:p></p>
<p class=3D"MsoNormal" style=3D"text-align:left;direction:ltr;unicode-bidi:=
embed">vg-ramlv2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (252:2)<o:p></o:p></p>
<p class=3D"MsoNormal" style=3D"text-align:left;direction:ltr;unicode-bidi:=
embed">vg-poolThinDataLV_tmeta &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; (252:3)<o:p></o:p></p>
<p class=3D"MsoNormal" style=3D"text-align:left;direction:ltr;unicode-bidi:=
embed">vg-poolThinDataLV_tdata &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp; (252:4)<o:p></o:p></p>
<p class=3D"MsoNormal" style=3D"text-align:left;direction:ltr;unicode-bidi:=
embed">vg-poolThinDataLV-tpool &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp; (252:5)<o:p></o:p></p>
<p class=3D"MsoNormal" style=3D"text-align:left;direction:ltr;unicode-bidi:=
embed">vg-poolThinDataLV&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; (252:6)<o:p></o:p></p>
<p class=3D"MsoNormal" style=3D"text-align:left;direction:ltr;unicode-bidi:=
embed">vg-t0&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; (252:7)<o:p></o:p></p>
<p class=3D"MsoNormal" style=3D"text-align:left;direction:ltr;unicode-bidi:=
embed">vg-t0s0 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (2=
52:8)<o:p></o:p></p>
<p class=3D"MsoNormal" style=3D"text-align:left;direction:ltr;unicode-bidi:=
embed"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal" style=3D"text-align:left;direction:ltr;unicode-bidi:=
embed">1GB of data was written during 3 IOSTAT sampling windows (samples ev=
ery 1 second). See in yellow in the 2<sup>nd</sup> second window; data was =
written to dm-4 (poolThinDataLV_tdata)
 and dm-5 (poolThinDataLV-tpool) at 557MBps, while it was written to dm-7 (=
t0) in 820MBps.<o:p></o:p></p>
<p class=3D"MsoNormal" style=3D"text-align:left;direction:ltr;unicode-bidi:=
embed">During the 1<sup>st</sup> second window, the behavior was different;=
 data was written to dm-4, dm-5 and dm-7 at the same throughput (average of=
 204MBps over this 1 second window).<o:p></o:p></p>
<p class=3D"MsoNormal" style=3D"text-align:left;direction:ltr;unicode-bidi:=
embed">In other cases, data is written to the 3 destinations at the same sp=
eed during all three 1 second windows.<o:p></o:p></p>
<p class=3D"MsoNormal" style=3D"text-align:left;direction:ltr;unicode-bidi:=
embed">What could be the reason for the behavior in the 2<sup>nd</sup> wind=
ow?<o:p></o:p></p>
<p class=3D"MsoNormal" style=3D"text-align:left;direction:ltr;unicode-bidi:=
embed">Is data really written twice to dm-4 and dm-5 (one time for each), o=
r is it the same write?<o:p></o:p></p>
<p class=3D"MsoNormal" style=3D"text-align:left;direction:ltr;unicode-bidi:=
embed">Can throughput be improved by increasing the request size (write in =
larger packets, how?)?<o:p></o:p></p>
<p class=3D"MsoNormal" style=3D"text-align:left;direction:ltr;unicode-bidi:=
embed"><o:p>&nbsp;</o:p></p>
<table class=3D"MsoNormalTable" border=3D"0" cellspacing=3D"0" cellpadding=
=3D"0" width=3D"756" style=3D"margin-left:30.2pt;border-collapse:collapse">
<tbody>
<tr style=3D"height:.1in">
<td width=3D"50" style=3D"width:37.65pt;border:solid windowtext 1.0pt;paddi=
ng:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">avg-cpu:<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border:solid windowtext 1=
.0pt;border-left:none;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">%user<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border:solid windowtext 1=
.0pt;border-left:none;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">%nice<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border:solid windowtext 1=
.0pt;border-left:none;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">%system<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border:solid windowtext 1=
.0pt;border-left:none;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">%iowait<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border:solid windowtext 1=
.0pt;border-left:none;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">%steal<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border:solid windowtext 1=
.0pt;border-left:none;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">%idle<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:42.3pt;border:solid windowtext =
1.0pt;border-left:none;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"66" nowrap=3D"" style=3D"width:49.5pt;border:solid windowtext =
1.0pt;border-left:none;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border:solid windowtext 1=
.0pt;border-left:none;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border:solid windowtext 1=
.0pt;border-left:none;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:41.85pt;border:solid windowtext=
 1.0pt;border-left:none;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border:solid windowtext 1=
.0pt;border-left:none;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border:solid windowtext 1=
.0pt;border-left:none;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
</tr>
<tr style=3D"height:.1in">
<td width=3D"50" style=3D"width:37.65pt;border:solid windowtext 1.0pt;borde=
r-top:none;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0.26<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">30.08<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">69.67<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:42.3pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"66" nowrap=3D"" style=3D"width:49.5pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:41.85pt;border-top:none;border-=
left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtex=
t 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
</tr>
<tr style=3D"height:.1in">
<td width=3D"50" style=3D"width:37.65pt;border:solid windowtext 1.0pt;borde=
r-top:none;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:42.3pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"66" nowrap=3D"" style=3D"width:49.5pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:41.85pt;border-top:none;border-=
left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtex=
t 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
</tr>
<tr style=3D"height:.1in">
<td width=3D"50" style=3D"width:37.65pt;border:solid windowtext 1.0pt;borde=
r-top:none;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">Device:<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">rrqm/s<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">wrqm/s<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">r/s<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">w/s<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">rMB/s<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">wMB/s<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:42.3pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">avgrq-sz<o:p></o:p></span></p>
</td>
<td width=3D"66" nowrap=3D"" style=3D"width:49.5pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">avgqu-sz<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">await<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">r_await<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:41.85pt;border-top:none;border-=
left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtex=
t 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">w_await<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">svctm<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">%util<o:p></o:p></span></p>
</td>
</tr>
<tr style=3D"height:.1in">
<td width=3D"50" style=3D"width:37.65pt;border:solid windowtext 1.0pt;borde=
r-top:none;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">sda<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">19<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0.07<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:42.3pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">8<o:p></o:p></span></p>
</td>
<td width=3D"66" nowrap=3D"" style=3D"width:49.5pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0.04<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">2.11<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">2.11<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:41.85pt;border-top:none;border-=
left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtex=
t 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0.21<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0.4<o:p></o:p></span></p>
</td>
</tr>
<tr style=3D"height:.1in">
<td width=3D"50" style=3D"width:37.65pt;border:solid windowtext 1.0pt;borde=
r-top:none;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">sdb<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">24785<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">14<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">1312<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0.05<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">96.31<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:42.3pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">148.84<o:p></o:p></span></p>
</td>
<td width=3D"66" nowrap=3D"" style=3D"width:49.5pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">5.69<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">4.17<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0.29<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:41.85pt;border-top:none;border-=
left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtex=
t 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">4.21<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0.44<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">58.4<o:p></o:p></span></p>
</td>
</tr>
<tr style=3D"height:.1in">
<td width=3D"50" style=3D"width:37.65pt;border:solid windowtext 1.0pt;borde=
r-top:none;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">sdc<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">24772<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">1<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">1312<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">96.31<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:42.3pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">150.23<o:p></o:p></span></p>
</td>
<td width=3D"66" nowrap=3D"" style=3D"width:49.5pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">5.52<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">4.07<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:41.85pt;border-top:none;border-=
left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtex=
t 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">4.08<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0.44<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">58.4<o:p></o:p></span></p>
</td>
</tr>
<tr style=3D"height:.1in">
<td width=3D"50" style=3D"width:37.65pt;border:solid windowtext 1.0pt;borde=
r-top:none;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">dm-0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:42.3pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"66" nowrap=3D"" style=3D"width:49.5pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:41.85pt;border-top:none;border-=
left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtex=
t 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
</tr>
<tr style=3D"height:.1in">
<td width=3D"50" style=3D"width:37.65pt;border:solid windowtext 1.0pt;borde=
r-top:none;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">dm-1<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:42.3pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"66" nowrap=3D"" style=3D"width:49.5pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:41.85pt;border-top:none;border-=
left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtex=
t 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
</tr>
<tr style=3D"height:.1in">
<td width=3D"50" style=3D"width:37.65pt;border:solid windowtext 1.0pt;borde=
r-top:none;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">dm-2<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:42.3pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"66" nowrap=3D"" style=3D"width:49.5pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:41.85pt;border-top:none;border-=
left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtex=
t 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
</tr>
<tr style=3D"height:.1in">
<td width=3D"50" style=3D"width:37.65pt;border:solid windowtext 1.0pt;borde=
r-top:none;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">dm-3<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">15<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0.06<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:42.3pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">8<o:p></o:p></span></p>
</td>
<td width=3D"66" nowrap=3D"" style=3D"width:49.5pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0.27<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0.27<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:41.85pt;border-top:none;border-=
left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtex=
t 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0.27<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0.4<o:p></o:p></span></p>
</td>
</tr>
<tr style=3D"height:.1in">
<td width=3D"50" style=3D"width:37.65pt;border:solid windowtext 1.0pt;borde=
r-top:none;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black;background:lime;mso-highlight:li=
me">dm-4<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black;background:lime;mso-highlight:li=
me">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black;background:lime;mso-highlight:li=
me">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black;background:lime;mso-highlight:li=
me">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black;background:lime;mso-highlight:li=
me">52224<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black;background:lime;mso-highlight:li=
me">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black;background:lime;mso-highlight:li=
me">204<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:42.3pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">8<o:p></o:p></span></p>
</td>
<td width=3D"66" nowrap=3D"" style=3D"width:49.5pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">1253.31<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">23.21<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:41.85pt;border-top:none;border-=
left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtex=
t 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">23.21<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0.01<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">58.4<o:p></o:p></span></p>
</td>
</tr>
<tr style=3D"height:.1in">
<td width=3D"50" style=3D"width:37.65pt;border:solid windowtext 1.0pt;borde=
r-top:none;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black;background:lime;mso-highlight:li=
me">dm-5<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black;background:lime;mso-highlight:li=
me">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black;background:lime;mso-highlight:li=
me">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black;background:lime;mso-highlight:li=
me">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black;background:lime;mso-highlight:li=
me">52224<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black;background:lime;mso-highlight:li=
me">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black;background:lime;mso-highlight:li=
me">204<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:42.3pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">8<o:p></o:p></span></p>
</td>
<td width=3D"66" nowrap=3D"" style=3D"width:49.5pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">1253.35<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">23.21<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:41.85pt;border-top:none;border-=
left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtex=
t 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">23.21<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0.01<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">58.4<o:p></o:p></span></p>
</td>
</tr>
<tr style=3D"height:.1in">
<td width=3D"50" style=3D"width:37.65pt;border:solid windowtext 1.0pt;borde=
r-top:none;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black;background:lime;mso-highlight:li=
me">dm-7<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black;background:lime;mso-highlight:li=
me">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black;background:lime;mso-highlight:li=
me">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black;background:lime;mso-highlight:li=
me">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black;background:lime;mso-highlight:li=
me">52225<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black;background:lime;mso-highlight:li=
me">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black;background:lime;mso-highlight:li=
me">204<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:42.3pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">8<o:p></o:p></span></p>
</td>
<td width=3D"66" nowrap=3D"" style=3D"width:49.5pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">1255.08<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">23.25<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:41.85pt;border-top:none;border-=
left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtex=
t 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">23.25<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0.01<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">58.4<o:p></o:p></span></p>
</td>
</tr>
<tr style=3D"height:.1in">
<td width=3D"50" style=3D"width:37.65pt;border:solid windowtext 1.0pt;borde=
r-top:none;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">dm-8<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:42.3pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"66" nowrap=3D"" style=3D"width:49.5pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:41.85pt;border-top:none;border-=
left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtex=
t 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
</tr>
<tr style=3D"height:.1in">
<td width=3D"50" style=3D"width:37.65pt;border:none;border-bottom:solid win=
dowtext 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border:none;border-bottom=
:solid windowtext 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border:none;border-bottom=
:solid windowtext 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border:none;border-bottom=
:solid windowtext 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border:none;border-bottom=
:solid windowtext 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border:none;border-bottom=
:solid windowtext 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border:none;border-bottom=
:solid windowtext 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:42.3pt;border:none;border-botto=
m:solid windowtext 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"66" nowrap=3D"" style=3D"width:49.5pt;border:none;border-botto=
m:solid windowtext 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border:none;border-bottom=
:solid windowtext 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border:none;border-bottom=
:solid windowtext 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:41.85pt;border-top:none;border-=
left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtex=
t 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border:none;border-bottom=
:solid windowtext 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border:none;border-bottom=
:solid windowtext 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
</tr>
<tr style=3D"height:.1in">
<td width=3D"50" style=3D"width:37.65pt;border:solid windowtext 1.0pt;borde=
r-top:none;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">avg-cpu:<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">%user<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">%nice<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">%system<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">%iowait<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">%steal<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">%idle<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:42.3pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"66" nowrap=3D"" style=3D"width:49.5pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:41.85pt;border-top:none;border-=
left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtex=
t 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
</tr>
<tr style=3D"height:.1in">
<td width=3D"50" style=3D"width:37.65pt;border:solid windowtext 1.0pt;borde=
r-top:none;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">57.37<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">3.68<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">38.95<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:42.3pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"66" nowrap=3D"" style=3D"width:49.5pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:41.85pt;border-top:none;border-=
left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtex=
t 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
</tr>
<tr style=3D"height:.1in">
<td width=3D"50" style=3D"width:37.65pt;border:solid windowtext 1.0pt;borde=
r-top:none;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:42.3pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"66" nowrap=3D"" style=3D"width:49.5pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:41.85pt;border-top:none;border-=
left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtex=
t 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
</tr>
<tr style=3D"height:.1in">
<td width=3D"50" style=3D"width:37.65pt;border:solid windowtext 1.0pt;borde=
r-top:none;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">Device:<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">rrqm/s<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">wrqm/s<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">r/s<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">w/s<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">rMB/s<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">wMB/s<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:42.3pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">avgrq-sz<o:p></o:p></span></p>
</td>
<td width=3D"66" nowrap=3D"" style=3D"width:49.5pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">avgqu-sz<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">await<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">r_await<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:41.85pt;border-top:none;border-=
left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtex=
t 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">w_await<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">svctm<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">%util<o:p></o:p></span></p>
</td>
</tr>
<tr style=3D"height:.1in">
<td width=3D"50" style=3D"width:37.65pt;border:solid windowtext 1.0pt;borde=
r-top:none;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">sda<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">1<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:42.3pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">8<o:p></o:p></span></p>
</td>
<td width=3D"66" nowrap=3D"" style=3D"width:49.5pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:41.85pt;border-top:none;border-=
left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtex=
t 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
</tr>
<tr style=3D"height:.1in">
<td width=3D"50" style=3D"width:37.65pt;border:solid windowtext 1.0pt;borde=
r-top:none;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">sdb<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">18031<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">20<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">53270<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0.08<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">284.15<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:42.3pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">10.92<o:p></o:p></span></p>
</td>
<td width=3D"66" nowrap=3D"" style=3D"width:49.5pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">52.74<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0.99<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">3.4<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:41.85pt;border-top:none;border-=
left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtex=
t 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0.99<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0.02<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">99.6<o:p></o:p></span></p>
</td>
</tr>
<tr style=3D"height:.1in">
<td width=3D"50" style=3D"width:37.65pt;border:solid windowtext 1.0pt;borde=
r-top:none;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">sdc<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">18044<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">27<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">53264<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0.11<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">284.12<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:42.3pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">10.92<o:p></o:p></span></p>
</td>
<td width=3D"66" nowrap=3D"" style=3D"width:49.5pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">32.19<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0.61<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0.59<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:41.85pt;border-top:none;border-=
left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtex=
t 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0.61<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0.02<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">99.2<o:p></o:p></span></p>
</td>
</tr>
<tr style=3D"height:.1in">
<td width=3D"50" style=3D"width:37.65pt;border:solid windowtext 1.0pt;borde=
r-top:none;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">dm-0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:42.3pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"66" nowrap=3D"" style=3D"width:49.5pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:41.85pt;border-top:none;border-=
left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtex=
t 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
</tr>
<tr style=3D"height:.1in">
<td width=3D"50" style=3D"width:37.65pt;border:solid windowtext 1.0pt;borde=
r-top:none;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">dm-1<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:42.3pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"66" nowrap=3D"" style=3D"width:49.5pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:41.85pt;border-top:none;border-=
left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtex=
t 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
</tr>
<tr style=3D"height:.1in">
<td width=3D"50" style=3D"width:37.65pt;border:solid windowtext 1.0pt;borde=
r-top:none;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">dm-2<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:42.3pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"66" nowrap=3D"" style=3D"width:49.5pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:41.85pt;border-top:none;border-=
left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtex=
t 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
</tr>
<tr style=3D"height:.1in">
<td width=3D"50" style=3D"width:37.65pt;border:solid windowtext 1.0pt;borde=
r-top:none;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">dm-3<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">47<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0.18<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:42.3pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">8<o:p></o:p></span></p>
</td>
<td width=3D"66" nowrap=3D"" style=3D"width:49.5pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0.08<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">1.79<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">1.79<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:41.85pt;border-top:none;border-=
left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtex=
t 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0.6<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">2.8<o:p></o:p></span></p>
</td>
</tr>
<tr style=3D"height:.1in">
<td width=3D"50" style=3D"width:37.65pt;border:solid windowtext 1.0pt;borde=
r-top:none;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black;background:yellow;mso-highlight:=
yellow">dm-4<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black;background:yellow;mso-highlight:=
yellow">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black;background:yellow;mso-highlight:=
yellow">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black;background:yellow;mso-highlight:=
yellow">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black;background:yellow;mso-highlight:=
yellow">142612<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black;background:yellow;mso-highlight:=
yellow">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black;background:yellow;mso-highlight:=
yellow">557.08<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:42.3pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">8<o:p></o:p></span></p>
</td>
<td width=3D"66" nowrap=3D"" style=3D"width:49.5pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">1505.75<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">10.85<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:41.85pt;border-top:none;border-=
left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtex=
t 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">10.85<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0.01<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">100<o:p></o:p></span></p>
</td>
</tr>
<tr style=3D"height:.1in">
<td width=3D"50" style=3D"width:37.65pt;border:solid windowtext 1.0pt;borde=
r-top:none;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black;background:yellow;mso-highlight:=
yellow">dm-5<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black;background:yellow;mso-highlight:=
yellow">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black;background:yellow;mso-highlight:=
yellow">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black;background:yellow;mso-highlight:=
yellow">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black;background:yellow;mso-highlight:=
yellow">142613<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black;background:yellow;mso-highlight:=
yellow">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black;background:yellow;mso-highlight:=
yellow">557.08<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:42.3pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">8<o:p></o:p></span></p>
</td>
<td width=3D"66" nowrap=3D"" style=3D"width:49.5pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">1545.26<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">10.85<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:41.85pt;border-top:none;border-=
left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtex=
t 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">10.85<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0.01<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">100<o:p></o:p></span></p>
</td>
</tr>
<tr style=3D"height:.1in">
<td width=3D"50" style=3D"width:37.65pt;border:solid windowtext 1.0pt;borde=
r-top:none;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black;background:yellow;mso-highlight:=
yellow">dm-7<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black;background:yellow;mso-highlight:=
yellow">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black;background:yellow;mso-highlight:=
yellow">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black;background:yellow;mso-highlight:=
yellow">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black;background:yellow;mso-highlight:=
yellow">209919<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black;background:yellow;mso-highlight:=
yellow">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black;background:yellow;mso-highlight:=
yellow">820<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:42.3pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">8<o:p></o:p></span></p>
</td>
<td width=3D"66" nowrap=3D"" style=3D"width:49.5pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">35341.8<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">87.93<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:41.85pt;border-top:none;border-=
left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtex=
t 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">87.93<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">100<o:p></o:p></span></p>
</td>
</tr>
<tr style=3D"height:.1in">
<td width=3D"50" style=3D"width:37.65pt;border:solid windowtext 1.0pt;borde=
r-top:none;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">dm-8<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:42.3pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"66" nowrap=3D"" style=3D"width:49.5pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:41.85pt;border-top:none;border-=
left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtex=
t 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
</tr>
<tr style=3D"height:.1in">
<td width=3D"50" style=3D"width:37.65pt;border:none;border-bottom:solid win=
dowtext 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border:none;border-bottom=
:solid windowtext 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border:none;border-bottom=
:solid windowtext 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border:none;border-bottom=
:solid windowtext 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border:none;border-bottom=
:solid windowtext 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border:none;border-bottom=
:solid windowtext 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border:none;border-bottom=
:solid windowtext 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:42.3pt;border:none;border-botto=
m:solid windowtext 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"66" nowrap=3D"" style=3D"width:49.5pt;border:none;border-botto=
m:solid windowtext 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border:none;border-bottom=
:solid windowtext 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border:none;border-bottom=
:solid windowtext 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:41.85pt;border:none;border-bott=
om:solid windowtext 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border:none;border-bottom=
:solid windowtext 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border:none;border-bottom=
:solid windowtext 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
</tr>
<tr style=3D"height:.1in">
<td width=3D"50" style=3D"width:37.65pt;border:solid windowtext 1.0pt;borde=
r-top:none;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">avg-cpu:<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">%user<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">%nice<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">%system<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">%iowait<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">%steal<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">%idle<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:42.3pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"66" nowrap=3D"" style=3D"width:49.5pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:41.85pt;border-top:none;border-=
left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtex=
t 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
</tr>
<tr style=3D"height:.1in">
<td width=3D"50" style=3D"width:37.65pt;border:solid windowtext 1.0pt;borde=
r-top:none;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0.51<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">30.61<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">9.95<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">58.93<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:42.3pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"66" nowrap=3D"" style=3D"width:49.5pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:41.85pt;border-top:none;border-=
left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtex=
t 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
</tr>
<tr style=3D"height:.1in">
<td width=3D"50" style=3D"width:37.65pt;border:solid windowtext 1.0pt;borde=
r-top:none;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:42.3pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"66" nowrap=3D"" style=3D"width:49.5pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:41.85pt;border-top:none;border-=
left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtex=
t 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
</td>
</tr>
<tr style=3D"height:.1in">
<td width=3D"50" style=3D"width:37.65pt;border:solid windowtext 1.0pt;borde=
r-top:none;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">Device:<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">rrqm/s<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">wrqm/s<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">r/s<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">w/s<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">rMB/s<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">wMB/s<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:42.3pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">avgrq-sz<o:p></o:p></span></p>
</td>
<td width=3D"66" nowrap=3D"" style=3D"width:49.5pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">avgqu-sz<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">await<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">r_await<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:41.85pt;border-top:none;border-=
left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtex=
t 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">w_await<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">svctm<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">%util<o:p></o:p></span></p>
</td>
</tr>
<tr style=3D"height:.1in">
<td width=3D"50" style=3D"width:37.65pt;border:solid windowtext 1.0pt;borde=
r-top:none;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">sda<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">8<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">1291<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">4<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">5.83<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0.05<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:42.3pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">9.3<o:p></o:p></span></p>
</td>
<td width=3D"66" nowrap=3D"" style=3D"width:49.5pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">1.62<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">1.25<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">1.25<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:41.85pt;border-top:none;border-=
left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtex=
t 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">2<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0.12<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">15.2<o:p></o:p></span></p>
</td>
</tr>
<tr style=3D"height:.1in">
<td width=3D"50" style=3D"width:37.65pt;border:solid windowtext 1.0pt;borde=
r-top:none;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">sdb<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">33674<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">131.54<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:42.3pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">8<o:p></o:p></span></p>
</td>
<td width=3D"66" nowrap=3D"" style=3D"width:49.5pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">9.09<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0.27<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:41.85pt;border-top:none;border-=
left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtex=
t 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0.27<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0.01<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">43.2<o:p></o:p></span></p>
</td>
</tr>
<tr style=3D"height:.1in">
<td width=3D"50" style=3D"width:37.65pt;border:solid windowtext 1.0pt;borde=
r-top:none;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">sdc<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">33680<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">131.56<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:42.3pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">8<o:p></o:p></span></p>
</td>
<td width=3D"66" nowrap=3D"" style=3D"width:49.5pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">7<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0.21<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:41.85pt;border-top:none;border-=
left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtex=
t 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0.21<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0.01<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">43.6<o:p></o:p></span></p>
</td>
</tr>
<tr style=3D"height:.1in">
<td width=3D"50" style=3D"width:37.65pt;border:solid windowtext 1.0pt;borde=
r-top:none;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">dm-0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:42.3pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"66" nowrap=3D"" style=3D"width:49.5pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:41.85pt;border-top:none;border-=
left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtex=
t 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
</tr>
<tr style=3D"height:.1in">
<td width=3D"50" style=3D"width:37.65pt;border:solid windowtext 1.0pt;borde=
r-top:none;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">dm-1<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:42.3pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"66" nowrap=3D"" style=3D"width:49.5pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:41.85pt;border-top:none;border-=
left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtex=
t 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
</tr>
<tr style=3D"height:.1in">
<td width=3D"50" style=3D"width:37.65pt;border:solid windowtext 1.0pt;borde=
r-top:none;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">dm-2<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:42.3pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"66" nowrap=3D"" style=3D"width:49.5pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:41.85pt;border-top:none;border-=
left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtex=
t 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
</tr>
<tr style=3D"height:.1in">
<td width=3D"50" style=3D"width:37.65pt;border:solid windowtext 1.0pt;borde=
r-top:none;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">dm-3<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:42.3pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"66" nowrap=3D"" style=3D"width:49.5pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:41.85pt;border-top:none;border-=
left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtex=
t 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
</tr>
<tr style=3D"height:.1in">
<td width=3D"50" style=3D"width:37.65pt;border:solid windowtext 1.0pt;borde=
r-top:none;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">dm-4<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">67308<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">262.92<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:42.3pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">8<o:p></o:p></span></p>
</td>
<td width=3D"66" nowrap=3D"" style=3D"width:49.5pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">15.96<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0.24<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:41.85pt;border-top:none;border-=
left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtex=
t 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0.24<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0.01<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">43.6<o:p></o:p></span></p>
</td>
</tr>
<tr style=3D"height:.1in">
<td width=3D"50" style=3D"width:37.65pt;border:solid windowtext 1.0pt;borde=
r-top:none;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">dm-5<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">67307<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">262.92<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:42.3pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">8<o:p></o:p></span></p>
</td>
<td width=3D"66" nowrap=3D"" style=3D"width:49.5pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">16.2<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0.24<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:41.85pt;border-top:none;border-=
left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtex=
t 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0.24<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0.01<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">43.6<o:p></o:p></span></p>
</td>
</tr>
<tr style=3D"height:.1in">
<td width=3D"50" style=3D"width:37.65pt;border:solid windowtext 1.0pt;borde=
r-top:none;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">dm-7<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:42.3pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"66" nowrap=3D"" style=3D"width:49.5pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">14886.74<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:41.85pt;border-top:none;border-=
left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtex=
t 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">43.6<o:p></o:p></span></p>
</td>
</tr>
<tr style=3D"height:.1in">
<td width=3D"50" style=3D"width:37.65pt;border:solid windowtext 1.0pt;borde=
r-top:none;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">dm-8<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:42.3pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"66" nowrap=3D"" style=3D"width:49.5pt;border-top:none;border-l=
eft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext=
 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"56" nowrap=3D"" style=3D"width:41.85pt;border-top:none;border-=
left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtex=
t 1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
<td width=3D"53" nowrap=3D"" style=3D"width:.55in;border-top:none;border-le=
ft:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext =
1.0pt;padding:.75pt 5.4pt .75pt 5.4pt;height:.1in">
<p class=3D"MsoNormal" align=3D"center" style=3D"text-align:center;directio=
n:ltr;unicode-bidi:embed">
<span style=3D"font-size:9.0pt;color:black">0<o:p></o:p></span></p>
</td>
</tr>
</tbody>
</table>
<p class=3D"MsoNormal" align=3D"right" style=3D"text-align:right;direction:=
ltr;unicode-bidi:embed">
<o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal" style=3D"text-align:left;direction:ltr;unicode-bidi:=
embed"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal" style=3D"text-align:left;direction:ltr;unicode-bidi:=
embed">I hope the information is clear.<o:p></o:p></p>
<p class=3D"MsoNormal" style=3D"text-align:left;direction:ltr;unicode-bidi:=
embed">I would appreciate your response to the questions I&#8217;ve raised =
above.<o:p></o:p></p>
<p class=3D"MsoNormal" style=3D"text-align:left;direction:ltr;unicode-bidi:=
embed"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal" style=3D"text-align:left;direction:ltr;unicode-bidi:=
embed">Thanks a lot,<o:p></o:p></p>
<p class=3D"MsoNormal" style=3D"text-align:left;direction:ltr;unicode-bidi:=
embed">-Moshe<o:p></o:p></p>
<p class=3D"MsoNormal" style=3D"text-align:left;direction:ltr;unicode-bidi:=
embed"><span style=3D"font-size:10.0pt;font-family:&quot;Arial&quot;,sans-s=
erif;color:#1F497D">----------------------------------------</span><span st=
yle=3D"color:#1F497D"><o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-align:left;direction:ltr;unicode-bidi:=
embed"><span style=3D"font-size:10.0pt;font-family:&quot;Arial&quot;,sans-s=
erif;color:#1F497D">Moshe Lazarov</span><span style=3D"color:#1F497D"><o:p>=
</o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-align:left;direction:ltr;unicode-bidi:=
embed"><span style=3D"color:#1F497D">Axxana<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-align:left;direction:ltr;unicode-bidi:=
embed"><span style=3D"color:#1F497D">&nbsp;<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-align:left;direction:ltr;unicode-bidi:=
embed"><span style=3D"font-size:10.0pt;font-family:&quot;Arial&quot;,sans-s=
erif;color:black">C:&nbsp;&nbsp;&nbsp; &#43;1-669-213-9752<o:p></o:p></span=
></p>
<p class=3D"MsoNormal" style=3D"text-align:left;direction:ltr;unicode-bidi:=
embed"><span style=3D"font-size:10.0pt;font-family:&quot;Arial&quot;,sans-s=
erif;color:black">F:&nbsp;&nbsp;&nbsp; &#43;972-74-7887878<o:p></o:p></span=
></p>
<p class=3D"MsoNormal" style=3D"text-align:left;direction:ltr;unicode-bidi:=
embed"><span style=3D"color:#404040"><a href=3D"UrlBlockedError.aspx" targe=
t=3D"_blank"><span style=3D"color:blue">www.axxana.com</span></a></span><sp=
an style=3D"color:#404040"><o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-align:left;direction:ltr;unicode-bidi:=
embed"><span style=3D"font-size:10.0pt;color:#404040"><o:p>&nbsp;</o:p></sp=
an></p>
<p class=3D"MsoNormal" style=3D"text-align:left;direction:ltr;unicode-bidi:=
embed"><span style=3D"color:#1F497D"><img border=3D"0" width=3D"532" height=
=3D"47" style=3D"width:5.5416in;height:.4895in" id=3D"Picture_x0020_1" src=
=3D"cid:image001.jpg@01D306D6.21CA2420" alt=3D"Description: cid:image004.jp=
g@01CD29D9.D454ED30"></span><o:p></o:p></p>
<p class=3D"MsoNormal" dir=3D"RTL"><span dir=3D"LTR"><o:p>&nbsp;</o:p></spa=
n></p>
</div>
</body>
</html>

--_000_HE1PR0901MB1497DF55B59376C14F754FAF95BE0HE1PR0901MB1497_--

--_005_HE1PR0901MB1497DF55B59376C14F754FAF95BE0HE1PR0901MB1497_
Content-Type: image/jpeg; name="image001.jpg"
Content-Description: image001.jpg
Content-Disposition: inline; filename="image001.jpg"; size=13437;
	creation-date="Thu, 27 Jul 2017 23:02:02 GMT";
	modification-date="Thu, 27 Jul 2017 23:02:02 GMT"
Content-ID: <image001.jpg@01D306D6.21CA2420>
Content-Transfer-Encoding: base64

/9j/4AAQSkZJRgABAQEAYABgAAD/4RDuRXhpZgAATU0AKgAAAAgABAE7AAIAAAAMAAAISodpAAQA
AAABAAAIVpydAAEAAAAYAAAQzuocAAcAAAgMAAAAPgAAAAAc6gAAAAgAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEVsaXphIENyb2VuAAAF
kAMAAgAAABQAABCkkAQAAgAAABQAABC4kpEAAgAAAAM0MQAAkpIAAgAAAAM0MQAA6hwABwAACAwA
AAiYAAAAABzqAAAACAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAMjAxMjowNTowNCAwOTozODo1NAAyMDEyOjA1OjA0IDA5OjM4OjU0AAAA
RQBsAGkAegBhACAAQwByAG8AZQBuAAAA/+ELHmh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8A
PD94cGFja2V0IGJlZ2luPSfvu78nIGlkPSdXNU0wTXBDZWhpSHpyZVN6TlRjemtjOWQnPz4NCjx4
OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iPjxyZGY6UkRGIHhtbG5zOnJkZj0iaHR0
cDovL3d3dy53My5vcmcvMTk5OS8wMi8yMi1yZGYtc3ludGF4LW5zIyI+PHJkZjpEZXNjcmlwdGlv
biByZGY6YWJvdXQ9InV1aWQ6ZmFmNWJkZDUtYmEzZC0xMWRhLWFkMzEtZDMzZDc1MTgyZjFiIiB4
bWxuczpkYz0iaHR0cDovL3B1cmwub3JnL2RjL2VsZW1lbnRzLzEuMS8iLz48cmRmOkRlc2NyaXB0
aW9uIHJkZjphYm91dD0idXVpZDpmYWY1YmRkNS1iYTNkLTExZGEtYWQzMS1kMzNkNzUxODJmMWIi
IHhtbG5zOnhtcD0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wLyI+PHhtcDpDcmVhdGVEYXRl
PjIwMTItMDUtMDRUMDk6Mzg6NTQuNDE0PC94bXA6Q3JlYXRlRGF0ZT48L3JkZjpEZXNjcmlwdGlv
bj48cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0idXVpZDpmYWY1YmRkNS1iYTNkLTExZGEtYWQz
MS1kMzNkNzUxODJmMWIiIHhtbG5zOmRjPSJodHRwOi8vcHVybC5vcmcvZGMvZWxlbWVudHMvMS4x
LyI+PGRjOmNyZWF0b3I+PHJkZjpTZXEgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5
LzAyLzIyLXJkZi1zeW50YXgtbnMjIj48cmRmOmxpPkVsaXphIENyb2VuPC9yZGY6bGk+PC9yZGY6
U2VxPg0KCQkJPC9kYzpjcmVhdG9yPjwvcmRmOkRlc2NyaXB0aW9uPjwvcmRmOlJERj48L3g6eG1w
bWV0YT4NCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAog
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAg
ICAgPD94cGFja2V0IGVuZD0ndyc/Pv/bAEMABwUFBgUEBwYFBggHBwgKEQsKCQkKFQ8QDBEYFRoZ
GBUYFxseJyEbHSUdFxgiLiIlKCkrLCsaIC8zLyoyJyorKv/bAEMBBwgICgkKFAsLFCocGBwqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKv/AABEIAC8CFAMB
IgACEQEDEQH/xAAfAAABBQEBAQEBAQAAAAAAAAAAAQIDBAUGBwgJCgv/xAC1EAACAQMDAgQDBQUE
BAAAAX0BAgMABBEFEiExQQYTUWEHInEUMoGRoQgjQrHBFVLR8CQzYnKCCQoWFxgZGiUmJygpKjQ1
Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoOEhYaHiImKkpOUlZaXmJmaoqOk
paanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4eLj5OXm5+jp6vHy8/T19vf4+fr/xAAf
AQADAQEBAQEBAQEBAAAAAAAAAQIDBAUGBwgJCgv/xAC1EQACAQIEBAMEBwUEBAABAncAAQIDEQQF
ITEGEkFRB2FxEyIygQgUQpGhscEJIzNS8BVictEKFiQ04SXxFxgZGiYnKCkqNTY3ODk6Q0RFRkdI
SUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqCg4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1
tre4ubrCw8TFxsfIycrS09TV1tfY2dri4+Tl5ufo6ery8/T19vf4+fr/2gAMAwEAAhEDEQA/APpG
iimTTRW8DzXEiRRRqWeR2Cqqjkkk9BQ3YDC8Q+OPD/ha9tLTWr9IJ7tsKgG4ov8AffH3Vzxk/wBD
jejkSWNZInV0cBlZTkMD0INfK/xM8Ut4g8YPPZ6u95bQH9wY4TDHEf8AY+Ylugy5AJI4GAK93+GP
ii28ReFYYxqyX95aqElDQ+TKo7b03Ef8CBwfY5FcmHxHtnJfd6HDTxSnXdPp0OzoorLtPFGgX94t
pY65ptzcuSFhhu43dsDJwoOexrqur2O1tLc1KKht7y1vPN+yXMU/kyGKTynDbHHVTjoR6VNTGFFF
FABRRRQAUUUUAFFQ/bLX7d9i+0xfavL83yN437M43beuM8ZoN5bC+FkbmIXRj80QbxvKZxu29cZ4
zRcV0TUUUUDCioftlr9u+xfaYvtXl+b5G8b9mcbtvXGeM1NQAUUUUAFFFQy3lrDdQ201zFHPcbvJ
idwGk2jJ2jqcDrigCaiiigAooooAKKKKACiiobS8tr+2W5sbiK5gfO2WFw6tg4OCOOooAmopGYKp
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

--_005_HE1PR0901MB1497DF55B59376C14F754FAF95BE0HE1PR0901MB1497_
Content-Type: image/png; name="image004.png"
Content-Description: image004.png
Content-Disposition: inline; filename="image004.png"; size=27762;
	creation-date="Thu, 27 Jul 2017 23:02:03 GMT";
	modification-date="Thu, 27 Jul 2017 23:02:03 GMT"
Content-ID: <image004.png@01D306F1.ABEA4B60>
Content-Transfer-Encoding: base64

iVBORw0KGgoAAAANSUhEUgAAAtgAAAETCAYAAAAMFHHvAAAAAXNSR0ICQMB9xQAAAAlwSFlzAAAO
xAAADsQBlSsOGwAAABl0RVh0U29mdHdhcmUATWljcm9zb2Z0IE9mZmljZX/tNXEAAGvySURBVHja
7b13mFVVmu/f88+9c59nZp4789z7m3C7e3ps7TG0qVttFROIgiRFMCCSk4hkkGwAJIMggglBULII
GJCccxAQVLIgsQqqyFl8f3xWzzqzKQrkrCqpvYvv53mWcmKd86691vqsd6199q++//57U1FRUVFR
UVFRUVHJn/Ir/iOEEEIIIYTIOxJsIYQQQggh8hEJthBCCCGEEPmIBFsIIYQQQoh8RIIthBBCCCFE
PiLBFkIIIYQQIh+RYAshhBBCCJGPSLCFEEIIIYTIRyTYQgghhBBC5CMSbCGEEEIIIfIRCbYQIojs
7Gz77rvvbNu2bZf0/J9++sn2799vhw8fztfPcfLkSVu3bp37LDt37jznsTNnztiuXbvs0KFD7vaP
P/7oPveJEydSz9m+fbsdP37c3bd161b3PpQDBw787N/m/fft22ebNm1yr9myZcs5j/P3NmzY4B6L
/s0ofDb/+TMzM8/7bnz+o0ePutunTp1yn//06dOp9+fzc/+RI0dch877rF+/3o4dO3bJMeT9/ffm
78FXX31lnTt3dn8vr2zevNleeeUV91kv5Tjhb/J98oO9e/e6OOWE7+m/8+7du8+JhT8OqJeDBw+q
sQsh0kaCLYRIG/qMxx9/3MqUKWNPPvmkLViwwN2PaF6oP0Fiy5Yta6+++mq+fQ5E7MUXX7TixYu7
z9KrV69zHp8+fbr9z//5P61Lly7u9g8//GBPPfWUzZ07191+99137a677rKNGzfayJEj7ZprrnHv
U6pUKXviiSdSsnkhsrKyXBx4D153991325tvvumEju/bsWNHu+eee6x06dLufoQ5ChOCmjVr2iOP
POJeP2zYsHMef++99+xv//Zvbfjw4e728uXLrWLFii7O0LZtW/c6xLx79+52ww03uNvFihWz+vXr
uwnNz4GMP//88+4z8try5cvb119/7WLEZ8vIyMhzPa1du9aeffZZF+efg4nNww8/fF5dpgti3bhx
Y7v++uvPm3iNHj3a1THf13/nhQsXpo6JP/zhD+7+kiVLWqVKlWzPnj1q9EKItJBgCyHSpnnz5k7g
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
QmCC

--_005_HE1PR0901MB1497DF55B59376C14F754FAF95BE0HE1PR0901MB1497_--


--===============0484686530243860992==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0484686530243860992==--
