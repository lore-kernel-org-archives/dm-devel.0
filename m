From: "Chelly Youssef (ISEFC)" <chilonnb@gmail.com>
Subject: Problem Delay construction of multipath device
Date: Mon, 11 Jan 2010 12:16:54 +0100
Message-ID: <a960d84c1001110316r59c2443bx9feee2da793b7946@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1709672922649295396=="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: snitzer@redhat.com
List-Id: dm-devel.ids

--===============1709672922649295396==
Content-Type: multipart/alternative; boundary=00504502d374bfe764047ce1ac34

--00504502d374bfe764047ce1ac34
Content-Type: text/plain; charset=ISO-8859-1

Problem: Delay construction of multipath device (/ dev/dm-3)

 I have a server and all works well at the beginning and I have no problem
with multipath:
- Server SunX4100

- Sun Storage Sun Storage Teck 2540
- Redhat Enterprise 5.2 (2.6.18-128.1.16.el5)
- 1Seul fiber card (Dual Port) optical Qlogic (qla2xxx)
- 2 Qlogic Fiber Switch 5600



# multipath -v2 -ll

mpath2 (3600a0b80004946b80000083b4a4a0137) dm-3 SUN,LCSM100_F

[size=305G][features=1 queue_if_no_path][hwhandler=1 rdac][rw]

\_ round-robin 0 [prio=100][active]

 \_ 3:0:0:1  sdf 8:80  [active][ready]

\_ round-robin 0 [prio=0][enabled]

 \_ 4:0:0:1  sde 8:64  [active][ghost]

mpath1 (3600a0b8000493fb6000008674a4a0130) dm-2 SUN,LCSM100_F

[size=240G][features=1 queue_if_no_path][hwhandler=1 rdac][rw]

\_ round-robin 0 [prio=100][enabled]

 \_ 4:0:0:0  sdd 8:48  [active][ready]

\_ round-robin 0 [prio=0][enabled]

 \_ 3:0:0:0  sdc 8:32  [active][ghost]



My fstab :

/dev/VolGroup00/LogVol00 /                       ext3    defaults        1 1

LABEL=/boot             /boot                   ext3    defaults        1 2

tmpfs                   /dev/shm                tmpfs   defaults        0 0

devpts                  /dev/pts                devpts  gid=5,mode=620  0 0

sysfs                   /sys                    sysfs   defaults        0 0

proc                    /proc                   proc    defaults        0 0

/dev/dm-2           /home                      auto   defaults     0 0

/dev/dm-3           /data                      auto   defaults     0 0

/dev/VolGroup00/LogVol01 swap                    swap    defaults        0 0

# df -h

Filesystem            Size  Used Avail Use% Mounted on

/dev/mapper/VolGroup00-LogVol00

                       64G   20G   42G  33% /

/dev/sda1              99M   24M   71M  25% /boot

tmpfs                 2.0G     0  2.0G   0% /dev/shm

/dev/dm-2             240G  148G   93G  62% /home

/dev/dm-3             305G  115G  191G  38% /data



After a while, the boot I got the message that displays:
Mounting local filesystems: mount: special device / dev/dm-3 does not exist
/ sbin / mount.gfs gfs_controld not running error mounting lock proto
lock_dlm



*After starting the server I do:***

# multipath -v2 -ll

mpath1 (3600a0b8000493fb6000008674a4a0130) dm-2 SUN,LCSM100_F

[size=240G][features=1 queue_if_no_path][hwhandler=1 rdac][rw]

\_ round-robin 0 [prio=100][active]

 \_ 4:0:0:0  sdd 8:48  [active][ready]

* *

*And*

# df -h

Filesystem            Size  Used Avail Use% Mounted on

/dev/mapper/VolGroup00-LogVol00

                       64G   20G   42G  33% /

/dev/sda1              99M   24M   71M  25% /boot

tmpfs                 2.0G     0  2.0G   0% /dev/shm

/dev/dm-2             240G  148G   93G  62% /home



*I tried to solve the problem*

*
When I do:***

# service multipathd restart

*Then*

# multipath -v2 -ll

mpath2 (3600a0b80004946b80000083b4a4a0137) dm-3 SUN,LCSM100_F

[size=305G][features=1 queue_if_no_path][hwhandler=1 rdac][rw]

\_ round-robin 0 [prio=100][active]

 \_ 3:0:0:1  sdf 8:80  [active][ready]

\_ round-robin 0 [prio=0][enabled]

 \_ 4:0:0:1  sde 8:64  [active][ghost]

mpath1 (3600a0b8000493fb6000008674a4a0130) dm-2 SUN,LCSM100_F

[size=240G][features=1 queue_if_no_path][hwhandler=1 rdac][rw]

\_ round-robin 0 [prio=100][enabled]

 \_ 4:0:0:0  sdd 8:48  [active][ready]

\_ round-robin 0 [prio=0][enabled]

 \_ 3:0:0:0  sdc 8:32  [active][ghost]



I have a good result and I do mount-a.
I made the upgrade to Redhat 5.4 (2.6.18-164.el5) but I have not solved the
problem. It must be done at boot

How I can do.* *I can give you my "sosreport" if you want.

Thanks

--00504502d374bfe764047ce1ac34
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><meta http-equiv=3D"Content-Type" content=3D"text/html; ch=
arset=3Dutf-8"><meta name=3D"ProgId" content=3D"Word.Document"><meta name=
=3D"Generator" content=3D"Microsoft Word 12"><meta name=3D"Originator" cont=
ent=3D"Microsoft Word 12"><link rel=3D"File-List" href=3D"file:///C:%5CDOCU=
ME%7E1%5CYCHELL%7E1.BD_%5CLOCALS%7E1%5CTemp%5Cmsohtmlclip1%5C01%5Cclip_file=
list.xml"><link rel=3D"themeData" href=3D"file:///C:%5CDOCUME%7E1%5CYCHELL%=
7E1.BD_%5CLOCALS%7E1%5CTemp%5Cmsohtmlclip1%5C01%5Cclip_themedata.thmx"><lin=
k rel=3D"colorSchemeMapping" href=3D"file:///C:%5CDOCUME%7E1%5CYCHELL%7E1.B=
D_%5CLOCALS%7E1%5CTemp%5Cmsohtmlclip1%5C01%5Cclip_colorschememapping.xml"><=
style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;
	mso-font-charset:0;
	mso-generic-font-family:roman;
	mso-font-pitch:variable;
	mso-font-signature:-1610611985 1107304683 0 0 159 0;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;
	mso-font-charset:0;
	mso-generic-font-family:swiss;
	mso-font-pitch:variable;
	mso-font-signature:-1610611985 1073750139 0 0 159 0;}
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{mso-style-unhide:no;
	mso-style-qformat:yes;
	mso-style-parent:"";
	margin-top:0cm;
	margin-right:0cm;
	margin-bottom:10.0pt;
	margin-left:0cm;
	line-height:115%;
	mso-pagination:widow-orphan;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";
	mso-fareast-font-family:Calibri;
	mso-bidi-font-family:Arial;
	mso-fareast-language:EN-US;}
span.longtext
	{mso-style-name:long_text;
	mso-style-unhide:no;}
span.shorttext
	{mso-style-name:short_text;
	mso-style-unhide:no;}
span.mediumtext
	{mso-style-name:medium_text;
	mso-style-unhide:no;}
.MsoChpDefault
	{mso-style-type:export-only;
	mso-default-props:yes;
	font-size:10.0pt;
	mso-ansi-font-size:10.0pt;
	mso-bidi-font-size:10.0pt;
	mso-ascii-font-family:Calibri;
	mso-fareast-font-family:Calibri;
	mso-hansi-font-family:Calibri;
	mso-bidi-font-family:Arial;}
@page Section1
	{size:612.0pt 792.0pt;
	margin:70.85pt 70.85pt 70.85pt 70.85pt;
	mso-header-margin:36.0pt;
	mso-footer-margin:36.0pt;
	mso-paper-source:0;}
div.Section1
	{page:Section1;}
-->
</style>

<p class=3D"MsoNormal" style=3D"margin-bottom: 0.0001pt; line-height: norma=
l;"><span class=3D"longtext"><span style=3D"background: white none repeat s=
croll 0% 0%; -moz-background-clip: border; -moz-background-origin: padding;=
 -moz-background-inline-policy: continuous;" lang=3D"EN-US">Problem: Delay =
construction of multipath device (/
dev/dm-3) </span></span><span style=3D"background: white none repeat scroll=
 0% 0%; -moz-background-clip: border; -moz-background-origin: padding; -moz=
-background-inline-policy: continuous;" lang=3D"EN-US"><br style=3D"">
<br style=3D"">
<span class=3D"longtext"></span></span></p>

<p class=3D"MsoNormal" style=3D"margin-bottom: 0.0001pt; line-height: norma=
l;"><span class=3D"longtext"><span style=3D"background: white none repeat s=
croll 0% 0%; -moz-background-clip: border; -moz-background-origin: padding;=
 -moz-background-inline-policy: continuous;" lang=3D"EN-US">I have a server=
 and all works well at the beginning
and I have no problem with multipath:</span></span><span style=3D"backgroun=
d: white none repeat scroll 0% 0%; -moz-background-clip: border; -moz-backg=
round-origin: padding; -moz-background-inline-policy: continuous;" lang=3D"=
EN-US"><br>

<span class=3D"longtext">- Server SunX4100 </span></span></p>

<p class=3D"MsoNormal"><span class=3D"longtext"><span style=3D"background: =
white none repeat scroll 0% 0%; -moz-background-clip: border; -moz-backgrou=
nd-origin: padding; -moz-background-inline-policy: continuous;" lang=3D"EN-=
US">- Sun Storage Sun Storage Teck 2540<br>

- Redhat Enterprise 5.2 (2.6.18-128.1.16.el5) </span></span><span class=3D"=
longtext"><span style=3D"" lang=3D"EN-US"><br>
<span style=3D"background: rgb(235, 239, 249) none repeat scroll 0% 0%; -mo=
z-background-clip: border; -moz-background-origin: padding; -moz-background=
-inline-policy: continuous;">- 1Seul fiber card (Dual Port) optical Qlogic
(qla2xxx)</span></span></span><span style=3D"background: rgb(235, 239, 249)=
 none repeat scroll 0% 0%; -moz-background-clip: border; -moz-background-or=
igin: padding; -moz-background-inline-policy: continuous;" lang=3D"EN-US"><=
br>

</span><span class=3D"longtext"><span style=3D"" lang=3D"EN-US">-
2 Qlogic Fiber Switch 5600</span></span></p>

<p class=3D"MsoNormal"><span class=3D"longtext"><span style=3D"" lang=3D"EN=
-US">=A0</span></span></p>

<p class=3D"MsoNormal" style=3D"margin-bottom: 0.0001pt; line-height: norma=
l;"><span style=3D"font-size: 9pt; font-family: &quot;Courier New&quot;;" l=
ang=3D"EN-US">#
multipath -v2 -ll</span></p>

<p class=3D"MsoNormal" style=3D"margin-bottom: 0.0001pt; line-height: norma=
l;"><span style=3D"font-size: 9pt; font-family: &quot;Courier New&quot;;" l=
ang=3D"EN-US">mpath2
(3600a0b80004946b80000083b4a4a0137) dm-3 SUN,LCSM100_F</span></p>

<p class=3D"MsoNormal" style=3D"margin-bottom: 0.0001pt; line-height: norma=
l;"><span style=3D"font-size: 9pt; font-family: &quot;Courier New&quot;;" l=
ang=3D"EN-US">[size=3D305G][features=3D1
queue_if_no_path][hwhandler=3D1 rdac][rw]</span></p>

<p class=3D"MsoNormal" style=3D"margin-bottom: 0.0001pt; line-height: norma=
l;"><span style=3D"font-size: 9pt; font-family: &quot;Courier New&quot;;" l=
ang=3D"EN-US">\_
round-robin 0 [prio=3D100][active]</span></p>

<p class=3D"MsoNormal" style=3D"margin-bottom: 0.0001pt; line-height: norma=
l;"><span style=3D"font-size: 9pt; font-family: &quot;Courier New&quot;;" l=
ang=3D"EN-US"><span style=3D"">=A0</span>\_ 3:0:0:1<span style=3D"">=A0
</span>sdf 8:80<span style=3D"">=A0 </span>[active][ready]</span></p>

<p class=3D"MsoNormal" style=3D"margin-bottom: 0.0001pt; line-height: norma=
l;"><span style=3D"font-size: 9pt; font-family: &quot;Courier New&quot;;" l=
ang=3D"EN-US">\_
round-robin 0 [prio=3D0][enabled]</span></p>

<p class=3D"MsoNormal" style=3D"margin-bottom: 0.0001pt; line-height: norma=
l;"><span style=3D"font-size: 9pt; font-family: &quot;Courier New&quot;;" l=
ang=3D"EN-US"><span style=3D"">=A0</span>\_ 4:0:0:1<span style=3D"">=A0
</span>sde 8:64<span style=3D"">=A0 </span>[active][ghost]</span></p>

<p class=3D"MsoNormal" style=3D"margin-bottom: 0.0001pt; line-height: norma=
l;"><span style=3D"font-size: 9pt; font-family: &quot;Courier New&quot;;" l=
ang=3D"EN-US">mpath1
(3600a0b8000493fb6000008674a4a0130) dm-2 SUN,LCSM100_F</span></p>

<p class=3D"MsoNormal" style=3D"margin-bottom: 0.0001pt; line-height: norma=
l;"><span style=3D"font-size: 9pt; font-family: &quot;Courier New&quot;;" l=
ang=3D"EN-US">[size=3D240G][features=3D1
queue_if_no_path][hwhandler=3D1 rdac][rw]</span></p>

<p class=3D"MsoNormal" style=3D"margin-bottom: 0.0001pt; line-height: norma=
l;"><span style=3D"font-size: 9pt; font-family: &quot;Courier New&quot;;" l=
ang=3D"EN-US">\_
round-robin 0 [prio=3D100][enabled]</span></p>

<p class=3D"MsoNormal" style=3D"margin-bottom: 0.0001pt; line-height: norma=
l;"><span style=3D"font-size: 9pt; font-family: &quot;Courier New&quot;;" l=
ang=3D"EN-US"><span style=3D"">=A0</span>\_ 4:0:0:0<span style=3D"">=A0
</span>sdd 8:48<span style=3D"">=A0 </span>[active][ready]</span></p>

<p class=3D"MsoNormal" style=3D"margin-bottom: 0.0001pt; line-height: norma=
l;"><span style=3D"font-size: 9pt; font-family: &quot;Courier New&quot;;" l=
ang=3D"EN-US">\_
round-robin 0 [prio=3D0][enabled]</span></p>

<p class=3D"MsoNormal" style=3D"margin-bottom: 0.0001pt; line-height: norma=
l;"><span style=3D"font-size: 9pt; font-family: &quot;Courier New&quot;;" l=
ang=3D"EN-US"><span style=3D"">=A0</span>\_ 3:0:0:0<span style=3D"">=A0
</span>sdc 8:32<span style=3D"">=A0 </span>[active][ghost]</span></p>

<p class=3D"MsoNormal"><span style=3D"" lang=3D"EN-US">=A0</span></p>

<p class=3D"MsoNormal">My fstab=A0: </p>

<p class=3D"MsoNormal" style=3D"margin-bottom: 0.0001pt; line-height: norma=
l;"><span style=3D"font-size: 9pt; font-family: &quot;Courier New&quot;;">/=
dev/VolGroup00/LogVol00 /<span style=3D"">=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 </span>ext3<span style=3D"">=A0=A0=A0 </s=
pan>defaults<span style=3D"">=A0=A0=A0=A0=A0=A0=A0 </span>1 1</span></p>


<p class=3D"MsoNormal" style=3D"margin-bottom: 0.0001pt; line-height: norma=
l;"><span style=3D"font-size: 9pt; font-family: &quot;Courier New&quot;;" l=
ang=3D"EN-US">LABEL=3D/boot<span style=3D"">=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 </span>/boot<span style=3D"">=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 </span>ext3<span style=3D"">=A0=A0=A0 </span>defaults<span =
style=3D"">=A0=A0=A0=A0=A0=A0=A0 </span>1 2</span></p>


<p class=3D"MsoNormal" style=3D"margin-bottom: 0.0001pt; line-height: norma=
l;"><span style=3D"font-size: 9pt; font-family: &quot;Courier New&quot;;" l=
ang=3D"EN-US">tmpfs<span style=3D"">=A0=A0=A0=A0=A0=A0=A0=A0=A0 </span><spa=
n style=3D"">=A0=A0=A0=A0=A0=A0=A0=A0=A0</span>/dev/shm<span style=3D"">=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 </span>tmpfs<span style=3D"">=A0=
=A0 </span>defaults<span style=3D"">=A0=A0=A0=A0=A0=A0=A0 </span>0 0</span>=
</p>


<p class=3D"MsoNormal" style=3D"margin-bottom: 0.0001pt; line-height: norma=
l;"><span style=3D"font-size: 9pt; font-family: &quot;Courier New&quot;;" l=
ang=3D"EN-US">devpts<span style=3D"">=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 </span>/dev/pts<span style=3D"">=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 </span>devpts<span style=3D"">=A0 </span>gid=3D5,mode=3D=
620<span style=3D"">=A0 </span>0 0</span></p>


<p class=3D"MsoNormal" style=3D"margin-bottom: 0.0001pt; line-height: norma=
l;"><span style=3D"font-size: 9pt; font-family: &quot;Courier New&quot;;">s=
ysfs<span style=3D"">=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 </span>/sys<span style=3D"">=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 </span>sysfs<span style=3D"">=A0=A0 </span>defaults<span style=
=3D"">=A0=A0=A0=A0=A0=A0=A0 </span>0 0</span></p>


<p class=3D"MsoNormal" style=3D"margin-bottom: 0.0001pt; line-height: norma=
l;"><span style=3D"font-size: 9pt; font-family: &quot;Courier New&quot;;">p=
roc<span style=3D"">=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 </span>/proc<span style=3D"">=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 </=
span><span style=3D"">=A0=A0=A0=A0=A0</span>proc<span style=3D"">=A0=A0=A0
</span>defaults<span style=3D"">=A0=A0=A0=A0=A0=A0=A0 </span>0 0</span></p>

<p class=3D"MsoNormal" style=3D"margin-bottom: 0.0001pt; line-height: norma=
l;"><span style=3D"font-size: 9pt; font-family: &quot;Courier New&quot;;" l=
ang=3D"EN-US">/dev/dm-2<span style=3D"">=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 </sp=
an>/home<span style=3D"">=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 </span>auto<span style=3D"">=A0=A0 </span>defaults<span sty=
le=3D"">=A0=A0=A0=A0 </span>0
0</span></p>

<p class=3D"MsoNormal" style=3D"margin-bottom: 0.0001pt; line-height: norma=
l;"><span style=3D"font-size: 9pt; font-family: &quot;Courier New&quot;;" l=
ang=3D"EN-US">/dev/dm-3<span style=3D"">=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 </sp=
an>/data<span style=3D"">=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 </span>auto<span style=3D"">=A0=A0 </span>defaults<span sty=
le=3D"">=A0=A0=A0=A0 </span>0
0</span></p>

<p class=3D"MsoNormal"><span style=3D"font-size: 9pt; line-height: 115%; fo=
nt-family: &quot;Courier New&quot;;" lang=3D"EN-US">/dev/VolGroup00/LogVol0=
1
swap<span style=3D"">=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 </span>swap<span style=3D"">=A0=A0=A0 </span>defaults<span style=3D"">=
=A0=A0=A0=A0=A0=A0=A0 </span>0 0</span></p>

<p class=3D"MsoNormal" style=3D"margin-bottom: 0.0001pt; line-height: norma=
l;"><span style=3D"font-size: 9pt; font-family: &quot;Courier New&quot;;" l=
ang=3D"EN-US"># df
-h</span></p>

<p class=3D"MsoNormal" style=3D"margin-bottom: 0.0001pt; line-height: norma=
l;"><span style=3D"font-size: 9pt; font-family: &quot;Courier New&quot;;" l=
ang=3D"EN-US">Filesystem<span style=3D"">=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
</span>Size<span style=3D"">=A0 </span>Used Avail Use% Mounted on</span></p=
>


<p class=3D"MsoNormal" style=3D"margin-bottom: 0.0001pt; line-height: norma=
l;"><span style=3D"font-size: 9pt; font-family: &quot;Courier New&quot;;" l=
ang=3D"EN-US">/dev/mapper/VolGroup00-LogVol00</span></p>

<p class=3D"MsoNormal" style=3D"margin-bottom: 0.0001pt; line-height: norma=
l;"><span style=3D"font-size: 9pt; font-family: &quot;Courier New&quot;;" l=
ang=3D"EN-US"><span style=3D"">=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 </span>64G<span style=3D"">=A0=A0 </span>20G<span =
style=3D"">=A0=A0
</span>42G<span style=3D"">=A0 </span>33% /</span></p>

<p class=3D"MsoNormal" style=3D"margin-bottom: 0.0001pt; line-height: norma=
l;"><span style=3D"font-size: 9pt; font-family: &quot;Courier New&quot;;" l=
ang=3D"EN-US">/dev/sda1<span style=3D"">=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 </span>99M<span style=3D"">=A0=A0 </span>24M<span style=3D"">=A0=A0
</span>71M<span style=3D"">=A0 </span>25% /boot</span></p>

<p class=3D"MsoNormal" style=3D"margin-bottom: 0.0001pt; line-height: norma=
l;"><span style=3D"font-size: 9pt; font-family: &quot;Courier New&quot;;" l=
ang=3D"EN-US">tmpfs<span style=3D"">=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 </span>2.0G<span style=3D"">=A0=A0=A0=A0 </span>0<span style=3D""=
>=A0
</span>2.0G<span style=3D"">=A0=A0 </span>0% /dev/shm</span></p>

<p class=3D"MsoNormal" style=3D"margin-bottom: 0.0001pt; line-height: norma=
l;"><span style=3D"font-size: 9pt; font-family: &quot;Courier New&quot;;" l=
ang=3D"EN-US">/dev/dm-2<span style=3D"">=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 </span>240G<span style=3D"">=A0 </span>148G<span style=3D"">=A0=A0
</span>93G<span style=3D"">=A0 </span>62% /home</span></p>

<p class=3D"MsoNormal" style=3D"margin-bottom: 0.0001pt; line-height: norma=
l;"><span style=3D"font-size: 9pt; font-family: &quot;Courier New&quot;;" l=
ang=3D"EN-US">/dev/dm-3<span style=3D"">=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 </span>305G<span style=3D"">=A0 </span>115G<span style=3D"">=A0
</span>191G<span style=3D"">=A0 </span>38% /data</span></p>

<p class=3D"MsoNormal"><span class=3D"longtext"><span style=3D"" lang=3D"EN=
-US">=A0</span></span></p>

<p class=3D"MsoNormal"><span class=3D"longtext"><span style=3D"background: =
white none repeat scroll 0% 0%; -moz-background-clip: border; -moz-backgrou=
nd-origin: padding; -moz-background-inline-policy: continuous;" lang=3D"EN-=
US">After a while, the boot I got the message that
displays:</span></span><span style=3D"background: white none repeat scroll =
0% 0%; -moz-background-clip: border; -moz-background-origin: padding; -moz-=
background-inline-policy: continuous;" lang=3D"EN-US"><br>
<span class=3D"longtext">Mounting local filesystems: mount: special device =
/
dev/dm-3 does not exist</span><br>
<span class=3D"longtext">/ sbin / mount.gfs gfs_controld not running error =
mounting
lock proto lock_dlm</span></span></p>

<p class=3D"MsoNormal"><span class=3D"longtext"><span style=3D"background: =
white none repeat scroll 0% 0%; -moz-background-clip: border; -moz-backgrou=
nd-origin: padding; -moz-background-inline-policy: continuous;" lang=3D"EN-=
US">=A0</span></span></p>


<p class=3D"MsoNormal"><span class=3D"shorttext"><b><span style=3D"backgrou=
nd: white none repeat scroll 0% 0%; -moz-background-clip: border; -moz-back=
ground-origin: padding; -moz-background-inline-policy: continuous;" lang=3D=
"EN-US">After starting the server I do:</span></b></span><span class=3D"lon=
gtext"><b><span style=3D"background: white none repeat scroll 0% 0%; -moz-b=
ackground-clip: border; -moz-background-origin: padding; -moz-background-in=
line-policy: continuous;" lang=3D"EN-US"></span></b></span></p>


<p class=3D"MsoNormal" style=3D"margin-bottom: 0.0001pt; line-height: norma=
l;"><span style=3D"font-size: 9pt; font-family: &quot;Courier New&quot;;" l=
ang=3D"EN-US">#
multipath -v2 -ll</span></p>

<p class=3D"MsoNormal" style=3D"margin-bottom: 0.0001pt; line-height: norma=
l;"><span style=3D"font-size: 9pt; font-family: &quot;Courier New&quot;;" l=
ang=3D"EN-US">mpath1
(3600a0b8000493fb6000008674a4a0130) dm-2 SUN,LCSM100_F</span></p>

<p class=3D"MsoNormal" style=3D"margin-bottom: 0.0001pt; line-height: norma=
l;"><span style=3D"font-size: 9pt; font-family: &quot;Courier New&quot;;" l=
ang=3D"EN-US">[size=3D240G][features=3D1
queue_if_no_path][hwhandler=3D1 rdac][rw]</span></p>

<p class=3D"MsoNormal" style=3D"margin-bottom: 0.0001pt; line-height: norma=
l;"><span style=3D"font-size: 9pt; font-family: &quot;Courier New&quot;;" l=
ang=3D"EN-US">\_
round-robin 0 [prio=3D100][active]</span></p>

<p class=3D"MsoNormal" style=3D"margin-bottom: 0.0001pt; line-height: norma=
l;"><span style=3D"font-size: 9pt; font-family: &quot;Courier New&quot;;" l=
ang=3D"EN-US"><span style=3D"">=A0</span>\_ 4:0:0:0<span style=3D"">=A0
</span>sdd 8:48<span style=3D"">=A0 </span>[active][ready]</span></p>

<p class=3D"MsoNormal"><b><span style=3D"" lang=3D"EN-US">=A0</span></b></p=
>

<p class=3D"MsoNormal"><b><span style=3D"" lang=3D"EN-US">And</span></b></p=
>

<p class=3D"MsoNormal"><span style=3D"font-size: 9pt; line-height: 115%; fo=
nt-family: &quot;Courier New&quot;;" lang=3D"EN-US"># df -h</span></p>

<p class=3D"MsoNormal" style=3D"margin-bottom: 0.0001pt; line-height: norma=
l;"><span style=3D"font-size: 9pt; font-family: &quot;Courier New&quot;;" l=
ang=3D"EN-US">Filesystem<span style=3D"">=A0=A0=A0=A0 </span><span style=3D=
"">=A0=A0=A0=A0=A0=A0=A0</span>Size<span style=3D"">=A0
</span>Used Avail Use% Mounted on</span></p>

<p class=3D"MsoNormal" style=3D"margin-bottom: 0.0001pt; line-height: norma=
l;"><span style=3D"font-size: 9pt; font-family: &quot;Courier New&quot;;" l=
ang=3D"EN-US">/dev/mapper/VolGroup00-LogVol00</span></p>

<p class=3D"MsoNormal" style=3D"margin-bottom: 0.0001pt; line-height: norma=
l;"><span style=3D"font-size: 9pt; font-family: &quot;Courier New&quot;;" l=
ang=3D"EN-US"><span style=3D"">=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 </span>64G<span style=3D"">=A0=A0 </span>20G<span =
style=3D"">=A0=A0
</span>42G<span style=3D"">=A0 </span>33% /</span></p>

<p class=3D"MsoNormal" style=3D"margin-bottom: 0.0001pt; line-height: norma=
l;"><span style=3D"font-size: 9pt; font-family: &quot;Courier New&quot;;" l=
ang=3D"EN-US">/dev/sda1<span style=3D"">=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 </span>99M<span style=3D"">=A0=A0 </span>24M<span style=3D"">=A0=A0
</span>71M<span style=3D"">=A0 </span>25% /boot</span></p>

<p class=3D"MsoNormal" style=3D"margin-bottom: 0.0001pt; line-height: norma=
l;"><span style=3D"font-size: 9pt; font-family: &quot;Courier New&quot;;" l=
ang=3D"EN-US">tmpfs<span style=3D"">=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 </span>2.0G<span style=3D"">=A0=A0=A0=A0 </span>0<span style=3D""=
>=A0
</span>2.0G<span style=3D"">=A0=A0 </span>0% /dev/shm</span></p>

<p class=3D"MsoNormal" style=3D"margin-bottom: 0.0001pt; line-height: norma=
l;"><span style=3D"font-size: 9pt; font-family: &quot;Courier New&quot;;" l=
ang=3D"EN-US">/dev/dm-2<span style=3D"">=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 </span>240G<span style=3D"">=A0 </span>148G<span style=3D"">=A0=A0 </sp=
an>93G<span style=3D"">=A0 </span>62% /home</span></p>


<p class=3D"MsoNormal"><span style=3D"" lang=3D"EN-US">=A0</span></p>

<p class=3D"MsoNormal"><span class=3D"shorttext"><b><span style=3D"backgrou=
nd: white none repeat scroll 0% 0%; -moz-background-clip: border; -moz-back=
ground-origin: padding; -moz-background-inline-policy: continuous;" lang=3D=
"EN-US">I tried to solve the problem</span></b></span></p>


<p class=3D"MsoNormal"><b><span style=3D"background: white none repeat scro=
ll 0% 0%; -moz-background-clip: border; -moz-background-origin: padding; -m=
oz-background-inline-policy: continuous;" lang=3D"EN-US"><br>
<span class=3D"shorttext">When I do:</span></span></b><span class=3D"longte=
xt"><b><span style=3D"" lang=3D"EN-US"></span></b></span></p>

<p class=3D"MsoNormal"><span style=3D"" lang=3D"EN-US"># service
multipathd restart</span></p>

<p class=3D"MsoNormal"><b><span style=3D"" lang=3D"EN-US">Then</span></b></=
p>

<p class=3D"MsoNormal" style=3D"margin-bottom: 0.0001pt; line-height: norma=
l;"><span style=3D"font-size: 9pt; font-family: &quot;Courier New&quot;;" l=
ang=3D"EN-US">#
multipath -v2 -ll</span></p>

<p class=3D"MsoNormal" style=3D"margin-bottom: 0.0001pt; line-height: norma=
l;"><span style=3D"font-size: 9pt; font-family: &quot;Courier New&quot;;" l=
ang=3D"EN-US">mpath2
(3600a0b80004946b80000083b4a4a0137) dm-3 SUN,LCSM100_F</span></p>

<p class=3D"MsoNormal" style=3D"margin-bottom: 0.0001pt; line-height: norma=
l;"><span style=3D"font-size: 9pt; font-family: &quot;Courier New&quot;;" l=
ang=3D"EN-US">[size=3D305G][features=3D1
queue_if_no_path][hwhandler=3D1 rdac][rw]</span></p>

<p class=3D"MsoNormal" style=3D"margin-bottom: 0.0001pt; line-height: norma=
l;"><span style=3D"font-size: 9pt; font-family: &quot;Courier New&quot;;" l=
ang=3D"EN-US">\_
round-robin 0 [prio=3D100][active]</span></p>

<p class=3D"MsoNormal" style=3D"margin-bottom: 0.0001pt; line-height: norma=
l;"><span style=3D"font-size: 9pt; font-family: &quot;Courier New&quot;;" l=
ang=3D"EN-US"><span style=3D"">=A0</span>\_ 3:0:0:1<span style=3D"">=A0
</span>sdf 8:80<span style=3D"">=A0 </span>[active][ready]</span></p>

<p class=3D"MsoNormal" style=3D"margin-bottom: 0.0001pt; line-height: norma=
l;"><span style=3D"font-size: 9pt; font-family: &quot;Courier New&quot;;" l=
ang=3D"EN-US">\_
round-robin 0 [prio=3D0][enabled]</span></p>

<p class=3D"MsoNormal" style=3D"margin-bottom: 0.0001pt; line-height: norma=
l;"><span style=3D"font-size: 9pt; font-family: &quot;Courier New&quot;;" l=
ang=3D"EN-US"><span style=3D"">=A0</span>\_ 4:0:0:1<span style=3D"">=A0
</span>sde 8:64<span style=3D"">=A0 </span>[active][ghost]</span></p>

<p class=3D"MsoNormal" style=3D"margin-bottom: 0.0001pt; line-height: norma=
l;"><span style=3D"font-size: 9pt; font-family: &quot;Courier New&quot;;" l=
ang=3D"EN-US">mpath1
(3600a0b8000493fb6000008674a4a0130) dm-2 SUN,LCSM100_F</span></p>

<p class=3D"MsoNormal" style=3D"margin-bottom: 0.0001pt; line-height: norma=
l;"><span style=3D"font-size: 9pt; font-family: &quot;Courier New&quot;;" l=
ang=3D"EN-US">[size=3D240G][features=3D1
queue_if_no_path][hwhandler=3D1 rdac][rw]</span></p>

<p class=3D"MsoNormal" style=3D"margin-bottom: 0.0001pt; line-height: norma=
l;"><span style=3D"font-size: 9pt; font-family: &quot;Courier New&quot;;" l=
ang=3D"EN-US">\_
round-robin 0 [prio=3D100][enabled]</span></p>

<p class=3D"MsoNormal" style=3D"margin-bottom: 0.0001pt; line-height: norma=
l;"><span style=3D"font-size: 9pt; font-family: &quot;Courier New&quot;;" l=
ang=3D"EN-US"><span style=3D"">=A0</span>\_ 4:0:0:0<span style=3D"">=A0
</span>sdd 8:48<span style=3D"">=A0 </span>[active][ready]</span></p>

<p class=3D"MsoNormal" style=3D"margin-bottom: 0.0001pt; line-height: norma=
l;"><span style=3D"font-size: 9pt; font-family: &quot;Courier New&quot;;" l=
ang=3D"EN-US">\_
round-robin 0 [prio=3D0][enabled]</span></p>

<p class=3D"MsoNormal" style=3D"margin-bottom: 0.0001pt; line-height: norma=
l;"><span style=3D"font-size: 9pt; font-family: &quot;Courier New&quot;;" l=
ang=3D"EN-US"><span style=3D"">=A0</span>\_ 3:0:0:0<span style=3D"">=A0
</span>sdc 8:32<span style=3D"">=A0 </span>[active][ghost]</span></p>

<p class=3D"MsoNormal"><span style=3D"background: white none repeat scroll =
0% 0%; -moz-background-clip: border; -moz-background-origin: padding; -moz-=
background-inline-policy: continuous;" lang=3D"EN-US">=A0</span></p>

<p class=3D"MsoNormal"><span class=3D"mediumtext"><span style=3D"background=
: white none repeat scroll 0% 0%; -moz-background-clip: border; -moz-backgr=
ound-origin: padding; -moz-background-inline-policy: continuous;" lang=3D"E=
N-US">I have a good result and I do mount-a.</span></span><span style=3D"ba=
ckground: white none repeat scroll 0% 0%; -moz-background-clip: border; -mo=
z-background-origin: padding; -moz-background-inline-policy: continuous;" l=
ang=3D"EN-US"><br>

<span class=3D"mediumtext">I made the upgrade to Redhat 5.4 (2.6.18-164.el5=
) but I
have not solved the problem. </span></span><span id=3D"result_box" class=3D=
"short_text"><span style=3D"background-color: rgb(255, 255, 255);" title=3D=
"=E7a doit =EAtre fait au d=E9marrage du systeme">It must be done at boot</=
span></span></p>


<p class=3D"MsoNormal"><span class=3D"mediumtext"><span style=3D"background=
: white none repeat scroll 0% 0%; -moz-background-clip: border; -moz-backgr=
ound-origin: padding; -moz-background-inline-policy: continuous;" lang=3D"E=
N-US">How I can do.</span></span><em><span style=3D"background: rgb(235, 23=
9, 249) none repeat scroll 0% 0%; font-family: &quot;Calibri&quot;,&quot;sa=
ns-serif&quot;; -moz-background-clip: border; -moz-background-origin: paddi=
ng; -moz-background-inline-policy: continuous;" lang=3D"EN-US"> </span></em=
><span class=3D"shorttext"><span style=3D"background: rgb(235, 239, 249) no=
ne repeat scroll 0% 0%; -moz-background-clip: border; -moz-background-origi=
n: padding; -moz-background-inline-policy: continuous;" lang=3D"EN-US">I ca=
n give you my
&quot;sosreport&quot; if you want.</span></span><span style=3D"background: =
white none repeat scroll 0% 0%; -moz-background-clip: border; -moz-backgrou=
nd-origin: padding; -moz-background-inline-policy: continuous;" lang=3D"EN-=
US"></span></p>


<p class=3D"MsoNormal"><span style=3D"background: white none repeat scroll =
0% 0%; -moz-background-clip: border; -moz-background-origin: padding; -moz-=
background-inline-policy: continuous;" lang=3D"EN-US">Thanks</span></p>

</div>

--00504502d374bfe764047ce1ac34--


--===============1709672922649295396==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1709672922649295396==--
