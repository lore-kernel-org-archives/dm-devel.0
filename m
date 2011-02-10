From: <Menny_Hamburger@Dell.com>
Subject: [PATCH]: multipath: fail path on zero size devices
Date: Thu, 10 Feb 2011 10:19:27 +0000
Message-ID: <D8C50530D6022F40A817A35C40CC06A7064B4604BB@DUBX7MCDUB01.EMEA.DELL.COM>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1943615670889170193=="
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

--===============1943615670889170193==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_D8C50530D6022F40A817A35C40CC06A7064B4604BBDUBX7MCDUB01E_"

--_000_D8C50530D6022F40A817A35C40CC06A7064B4604BBDUBX7MCDUB01E_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,

I am sending this as a continuum to the  situation described in the followi=
ng patch:
https://patchwork.kernel.org/patch/62094

We are using MD32xxi storage arrays (ISCSI, RDAC) in a clustering environme=
nt where we have two machines logged into both controllers of the storage a=
rray.

This is the output of multipath -ll on one of the machines when all is well=
.
lun1 (36842b2b00063c13d000003594ce9f82b) dm-1 DELL,MD32xxi
[size=3D1.0T][features=3D2 pg_init_retries 50][hwhandler=3D1 rdac][rw]
\_ round-robin 0 [prio=3D200][active]
\_ 6:0:0:1  sdf 8:80  [active][ready]
\_ 5:0:0:1  sdh 8:112 [active][ready]
\_ round-robin 0 [prio=3D0][enabled]
\_ 8:0:0:1  sdj 8:144 [active][ghost]
\_ 7:0:0:1  sdk 8:160 [active][ghost]
lun0 (36842b2b000571923000003933b4c0d04) dm-0 DELL,MD32xxi
[size=3D1.0T][features=3D2 pg_init_retries 50][hwhandler=3D1 rdac][rw]
\_ round-robin 0 [prio=3D200][active]
\_ 8:0:0:0  sdd 8:48  [active][ready]
\_ 7:0:0:0  sdc 8:32  [active][ready]
\_ round-robin 0 [prio=3D0][enabled]
\_ 6:0:0:0  sdb 8:16  [active][ghost]
\_ 5:0:0:0  sde 8:64  [active][ghost]

When I disconnect the switch connecting between the machines and the storag=
e array (while there is I/O to the devices) and rescan the storage during t=
his period, I get READ_CAPACITY failures and as result the devices receive =
a zero size.  It seems that in this case, not only do we have a ping-pong b=
etween path-groups on the same machine, we also have a ping-pong between LU=
Ns on the two machines, which causes havoc to our system.

This was the output of multipath -ll during the failure:
lun1 (36842b2b00063c13d000003594ce9f82b) dm-1 ,
[size=3D1.0T][features=3D2 pg_init_retries 50][hwhandler=3D1 rdac][rw]
\_ round-robin 0 [prio=3D0][active]
\_ #:#:#:# sdf 8:80  [active][undef]
\_ #:#:#:# sdh 8:112 [active][undef]
\_ round-robin 0 [prio=3D0][enabled]
\_ #:#:#:# sdj 8:144 [active][undef]
\_ #:#:#:# sdk 8:160 [active][undef]
lun0 (36842b2b000571923000003933b4c0d04) dm-0 ,
[size=3D1.0T][features=3D2 pg_init_retries 50][hwhandler=3D1 rdac][rw]
\_ round-robin 0 [prio=3D0][enabled]
\_ #:#:#:# sdd 8:48  [failed][undef]
\_ #:#:#:# sdc 8:32  [failed][undef]
\_ round-robin 0 [prio=3D0][enabled]
\_ #:#:#:# sdb 8:16  [failed][undef]
\_ #:#:#:# sde 8:64  [failed][undef]

Instead of not allowing 0 size paths to enter the map, we should allow them=
 to get in but fail them although the path checker tells us that the path i=
s up.
The following patch is over multipathd in device-mapper-multipath-0.4.7-42.=
el5 (RHEL56):

--- a/multipathd/main.c                2010-12-07 08:02:23.000000000 +0200
+++ b/multipathd/main.c             2011-02-10 10:51:57.000000000 +0200
@@ -1050,4 +1050,11 @@
                                                                           =
                                    &(pp->checker.timeout));
                                                               newstate =3D=
 checker_check(&pp->checker);
+                                                             if (newstate =
!=3D PATH_DOWN) {
+                                                                          =
   unsigned long long size =3D 0;
+
+                                                                          =
   sysfs_get_size(sysfs_path, pp->dev, &size);
+                                                                          =
   if (size =3D=3D 0)
+                                                                          =
                   newstate =3D PATH_DOWN;
+                                                             }
                               }
Since the path is down, the path groups no longer compete on LUN ownership =
and things remain stable.
In addition, with the ping-pong running wild I need to rescan again after s=
torage comes up - with this fix I do not.

Menny



Menny Hamburger
Engineer
Dell | IDC
office +972 97698789,  fax +972 97698889
Dell IDC. 4 Hacharoshet St, Raanana 43657, Israel


--_000_D8C50530D6022F40A817A35C40CC06A7064B4604BBDUBX7MCDUB01E_
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
	{font-family:"Trebuchet MS";
	panose-1:2 11 6 3 2 2 2 2 2 4;}
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
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri","sans-serif";
	color:windowtext;}
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
nk=3Dpurple><div class=3DWordSection1><p class=3DMsoNormal>Hi,<o:p></o:p></=
p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p class=3DMsoNormal>I am sendi=
ng this as a continuum to the &nbsp;situation described in the following pa=
tch:<o:p></o:p></p><p class=3DMsoNormal><a href=3D"https://patchwork.kernel=
.org/patch/62094">https://patchwork.kernel.org/patch/62094</a><o:p></o:p></=
p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p class=3DMsoNormal>We are usi=
ng MD32xxi storage arrays (ISCSI, RDAC) in a clustering environment where w=
e have two machines logged into both controllers of the storage array.<o:p>=
</o:p></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p class=3DMsoNormal>Th=
is is the output of multipath &#8211;ll on one of the machines when all is =
well.<o:p></o:p></p><p class=3DMsoNormal>lun1 (36842b2b00063c13d000003594ce=
9f82b) dm-1 DELL,MD32xxi<o:p></o:p></p><p class=3DMsoNormal>[size=3D1.0T][f=
eatures=3D2 pg_init_retries 50][hwhandler=3D1 rdac][rw]<o:p></o:p></p><p cl=
ass=3DMsoNormal>\_ round-robin 0 [prio=3D200][active]<o:p></o:p></p><p clas=
s=3DMsoNormal>\_ 6:0:0:1&nbsp; sdf 8:80&nbsp; [active][ready]<o:p></o:p></p=
><p class=3DMsoNormal>\_ 5:0:0:1&nbsp; sdh 8:112 [active][ready]<o:p></o:p>=
</p><p class=3DMsoNormal>\_ round-robin 0 [prio=3D0][enabled]<o:p></o:p></p=
><p class=3DMsoNormal>\_ 8:0:0:1&nbsp; sdj 8:144 [active][ghost]<o:p></o:p>=
</p><p class=3DMsoNormal>\_ 7:0:0:1&nbsp; sdk 8:160 [active][ghost]<o:p></o=
:p></p><p class=3DMsoNormal>lun0 (36842b2b000571923000003933b4c0d04) dm-0 D=
ELL,MD32xxi<o:p></o:p></p><p class=3DMsoNormal>[size=3D1.0T][features=3D2 p=
g_init_retries 50][hwhandler=3D1 rdac][rw]<o:p></o:p></p><p class=3DMsoNorm=
al>\_ round-robin 0 [prio=3D200][active]<o:p></o:p></p><p class=3DMsoNormal=
>\_ 8:0:0:0&nbsp; sdd 8:48&nbsp; [active][ready]<o:p></o:p></p><p class=3DM=
soNormal>\_ 7:0:0:0&nbsp; sdc 8:32&nbsp; [active][ready]<o:p></o:p></p><p c=
lass=3DMsoNormal>\_ round-robin 0 [prio=3D0][enabled]<o:p></o:p></p><p clas=
s=3DMsoNormal>\_ 6:0:0:0&nbsp; sdb 8:16&nbsp; [active][ghost]<o:p></o:p></p=
><p class=3DMsoNormal>\_ 5:0:0:0&nbsp; sde 8:64&nbsp; [active][ghost]<o:p><=
/o:p></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p class=3DMsoNormal>Whe=
n I disconnect the switch connecting between the machines and the storage a=
rray (while there is I/O to the devices) and rescan the storage during this=
 period, I get READ_CAPACITY failures and as result the devices receive a z=
ero size.&nbsp; It seems that in this case, not only do we have a ping-pong=
 between path-groups on the same machine, we also have a ping-pong between =
LUNs on the two machines, which causes havoc to our system.<o:p></o:p></p><=
p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p class=3DMsoNormal>This was the =
output of multipath &#8211;ll during the failure:<o:p></o:p></p><p class=3D=
MsoNormal>lun1 (36842b2b00063c13d000003594ce9f82b) dm-1 ,<o:p></o:p></p><p =
class=3DMsoNormal>[size=3D1.0T][features=3D2 pg_init_retries 50][hwhandler=
=3D1 rdac][rw]<o:p></o:p></p><p class=3DMsoNormal>\_ round-robin 0 [prio=3D=
0][active]<o:p></o:p></p><p class=3DMsoNormal>\_ #:#:#:# sdf 8:80&nbsp; [ac=
tive][undef]<o:p></o:p></p><p class=3DMsoNormal>\_ #:#:#:# sdh 8:112 [activ=
e][undef]<o:p></o:p></p><p class=3DMsoNormal>\_ round-robin 0 [prio=3D0][en=
abled]<o:p></o:p></p><p class=3DMsoNormal>\_ #:#:#:# sdj 8:144 [active][und=
ef]<o:p></o:p></p><p class=3DMsoNormal>\_ #:#:#:# sdk 8:160 [active][undef]=
<o:p></o:p></p><p class=3DMsoNormal>lun0 (36842b2b000571923000003933b4c0d04=
) dm-0 ,<o:p></o:p></p><p class=3DMsoNormal>[size=3D1.0T][features=3D2 pg_i=
nit_retries 50][hwhandler=3D1 rdac][rw]<o:p></o:p></p><p class=3DMsoNormal>=
\_ round-robin 0 [prio=3D0][enabled]<o:p></o:p></p><p class=3DMsoNormal>\_ =
#:#:#:# sdd 8:48&nbsp; [failed][undef]<o:p></o:p></p><p class=3DMsoNormal>\=
_ #:#:#:# sdc 8:32&nbsp; [failed][undef]<o:p></o:p></p><p class=3DMsoNormal=
>\_ round-robin 0 [prio=3D0][enabled]<o:p></o:p></p><p class=3DMsoNormal>\_=
 #:#:#:# sdb 8:16&nbsp; [failed][undef]<o:p></o:p></p><p class=3DMsoNormal>=
\_ #:#:#:# sde 8:64&nbsp; [failed][undef]<o:p></o:p></p><p class=3DMsoNorma=
l><o:p>&nbsp;</o:p></p><p class=3DMsoNormal>Instead of not allowing 0 size =
paths to enter the map, we should allow them to get in but fail them althou=
gh the path checker tells us that the path is up.<o:p></o:p></p><p class=3D=
MsoNormal>The following patch is over multipathd in device-mapper-multipath=
-0.4.7-42.el5 (RHEL56):<o:p></o:p></p><p class=3DMsoNormal><o:p>&nbsp;</o:p=
></p><p class=3DMsoNormal>--- a/multipathd/main.c&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2010-12-07=
 08:02:23.000000000 +0200<o:p></o:p></p><p class=3DMsoNormal>+++ b/multipat=
hd/main.c&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp; 2011-02-10 10:51:57.000000000 +0200<o:p></o:p></p><p class=3DMsoNorm=
al>@@ -1050,4 +1050,11 @@<o:p></o:p></p><p class=3DMsoNormal> &nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &amp;(pp-&gt;checker.timeou=
t));<o:p></o:p></p><p class=3DMsoNormal> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; newstate =3D checker_check(&amp;pp-&=
gt;checker);<o:p></o:p></p><p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (newstate !=3D PATH_DOWN) {<o:p></o:p=
></p><p class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; unsigned long long size =3D 0;<o:p></o:p>=
</p><p class=3DMsoNormal>+<o:p></o:p></p><p class=3DMsoNormal>+&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; sysfs=
_get_size(sysfs_path, pp-&gt;dev, &amp;size);<o:p></o:p></p><p class=3DMsoN=
ormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; if (size =3D=3D 0)<o:p></o:p></p><p class=3DMsoNormal>+&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp; newstate =3D PATH_DOWN;<o:p></o:p></p><p class=3DMsoN=
ormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<o:p><=
/o:p></p><p class=3DMsoNormal> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<o:p></o:p><=
/p><p class=3DMsoNormal>Since the path is down, the path groups no longer c=
ompete on LUN ownership and things remain stable.<o:p></o:p></p><p class=3D=
MsoNormal>In addition, with the ping-pong running wild I need to rescan aga=
in after storage comes up &#8211; with this fix I do not.<o:p></o:p></p><p =
class=3DMsoNormal><o:p>&nbsp;</o:p></p><p class=3DMsoNormal>Menny<o:p></o:p=
></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p class=3DMsoNormal><o:p>&n=
bsp;</o:p></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p class=3DMsoNorma=
l><b><span style=3D'font-size:10.0pt;font-family:"Trebuchet MS","sans-serif=
";color:#444444'>Menny Hamburger</span></b><span style=3D'font-size:8.0pt;f=
ont-family:"Trebuchet MS","sans-serif";color:#444444'><o:p></o:p></span></p=
><p class=3DMsoNormal><span style=3D'font-size:8.0pt;font-family:"Trebuchet=
 MS","sans-serif";color:#444444'>Engineer<o:p></o:p></span></p><p class=3DM=
soNormal><b><span style=3D'font-size:8.0pt;font-family:"Trebuchet MS","sans=
-serif";color:#0085C3'>Dell</span></b><span style=3D'font-size:8.0pt;font-f=
amily:"Trebuchet MS","sans-serif";color:#444444'> | IDC<b><o:p></o:p></b></=
span></p><p class=3DMsoNormal><b><span style=3D'font-size:8.0pt;font-family=
:"Trebuchet MS","sans-serif";color:#444444'>office </span></b><span style=
=3D'font-size:8.0pt;font-family:"Trebuchet MS","sans-serif";color:#444444'>=
+972 97698789<b>,&nbsp; fax </b>+972 97698889<b><o:p></o:p></b></span></p><=
p class=3DMsoNormal><span style=3D'font-size:8.0pt;font-family:"Trebuchet M=
S","sans-serif";color:#444444'>Dell IDC. 4 Hacharoshet St, Raanana 43657, I=
srael</span><span style=3D'color:#1F497D'><o:p></o:p></span></p><p class=3D=
MsoNormal><o:p>&nbsp;</o:p></p></div></body></html>=

--_000_D8C50530D6022F40A817A35C40CC06A7064B4604BBDUBX7MCDUB01E_--


--===============1943615670889170193==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1943615670889170193==--
