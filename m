From: Alexander Murashkin <AlexanderMurashkin@msn.com>
Subject: Active/backup multipath configuration for iSCSI paths
Date: Wed, 28 Mar 2012 03:52:09 -0500
Message-ID: <BLU0-SMTP3709E65DBDAB82FD7948CE4D54B0@phx.gbl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6093647820168350282=="
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-us
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

--===============6093647820168350282==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0082_01CD0C96.271E0940"
Content-Language: en-us

------=_NextPart_000_0082_01CD0C96.271E0940
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 03/23/2012 02:41 PM, Hart, Brian R. wrote:

(https://www.redhat.com/archives/dm-devel/2012-March/msg00155.html)

 

> We have a couple of Dell MD storage arrays that when installed

> setup multipath.conf to use this line: prio_callout

> "/sbin/mpath_prio_rdac /dev/%n"

 

On 03/23/2012 02:41 PM, Bryn M. Reeves wrote:

(https://www.redhat.com/archives/dm-devel/2012-March/msg00155.html)

 

>Callouts make life difficult when file systems go away so like the

>path checkers before them they were merged into the libmultipath

>shared library. This means that the daemon can lock them into memory

>via mlock(2)/mlockall(2) and not have to worry about being able to

>load a binary from disk when the paths to that storage have failed -

>this is very useful if your root file system is on multipath and you

>need to recover from a failure.

> 

>In RHEL5 this is dealt with using a complex and fragile private

>namespace and RAM-backed file system - the required binaries are

>copied into this ramfs at daemon startup and the daemon unmounts

>unnecessary file systems to avoid blocking when failures occur.

> 

>For this reason the parameter is now just "prio", e.g.:

> 

>device {

.

>    prio                    rdac

>}

 

I can see that using shared libraries to handle priorities makes handling
failed paths easier in many situations. But how to configure active/backup
multipath in the following case, for example

 

-          1st path uses iSCSI over Infiniband

-          2nd path used iSCSI over Gigabit Ethernet

-          iSCSI target does not support ALUA

-          we want Infiniband path to have higher priority

 

Will it be enough to set path_grouping_policy =  multibus and path_selector
= "service-time 0"? Will Gigabit Ethernet path be never used as long as
Infiniband path is working?

 

I appreciate your help,

    Alexander Murashkin

 

Email:  AlexanderMurashkin@msn.com

 

 


------=_NextPart_000_0082_01CD0C96.271E0940
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" =
xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" =
xmlns=3D"http://www.w3.org/TR/REC-html40"><head><meta =
http-equiv=3DContent-Type content=3D"text/html; =
charset=3Dus-ascii"><meta name=3DGenerator content=3D"Microsoft Word 14 =
(filtered medium)"><style><!--
/* Font Definitions */
@font-face
	{font-family:Wingdings;
	panose-1:5 0 0 0 0 0 0 0 0 0;}
@font-face
	{font-family:Wingdings;
	panose-1:5 0 0 0 0 0 0 0 0 0;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
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
p.MsoListParagraph, li.MsoListParagraph, div.MsoListParagraph
	{mso-style-priority:34;
	margin-top:0in;
	margin-right:0in;
	margin-bottom:0in;
	margin-left:.5in;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri","sans-serif";
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-family:"Calibri","sans-serif";}
@page WordSection1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
	{page:WordSection1;}
/* List Definitions */
@list l0
	{mso-list-id:1014185494;
	mso-list-type:hybrid;
	mso-list-template-ids:-635304684 -1716632624 67698691 67698693 67698689 =
67698691 67698693 67698689 67698691 67698693;}
@list l0:level1
	{mso-level-start-at:0;
	mso-level-number-format:bullet;
	mso-level-text:\F0D8;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;
	font-family:Wingdings;
	mso-fareast-font-family:Calibri;
	mso-bidi-font-family:"Times New Roman";}
@list l0:level2
	{mso-level-number-format:bullet;
	mso-level-text:o;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;
	font-family:"Courier New";}
@list l0:level3
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;
	font-family:Wingdings;}
@list l0:level4
	{mso-level-number-format:bullet;
	mso-level-text:\F0B7;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;
	font-family:Symbol;}
@list l0:level5
	{mso-level-number-format:bullet;
	mso-level-text:o;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;
	font-family:"Courier New";}
@list l0:level6
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;
	font-family:Wingdings;}
@list l0:level7
	{mso-level-number-format:bullet;
	mso-level-text:\F0B7;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;
	font-family:Symbol;}
@list l0:level8
	{mso-level-number-format:bullet;
	mso-level-text:o;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;
	font-family:"Courier New";}
@list l0:level9
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;
	font-family:Wingdings;}
@list l1
	{mso-list-id:1372805116;
	mso-list-type:hybrid;
	mso-list-template-ids:-264059628 -1659974808 67698691 67698693 67698689 =
67698691 67698693 67698689 67698691 67698693;}
@list l1:level1
	{mso-level-start-at:0;
	mso-level-number-format:bullet;
	mso-level-text:-;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;
	font-family:"Calibri","sans-serif";
	mso-fareast-font-family:Calibri;}
@list l1:level2
	{mso-level-number-format:bullet;
	mso-level-text:o;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;
	font-family:"Courier New";}
@list l1:level3
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;
	font-family:Wingdings;}
@list l1:level4
	{mso-level-number-format:bullet;
	mso-level-text:\F0B7;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;
	font-family:Symbol;}
@list l1:level5
	{mso-level-number-format:bullet;
	mso-level-text:o;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;
	font-family:"Courier New";}
@list l1:level6
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;
	font-family:Wingdings;}
@list l1:level7
	{mso-level-number-format:bullet;
	mso-level-text:\F0B7;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;
	font-family:Symbol;}
@list l1:level8
	{mso-level-number-format:bullet;
	mso-level-text:o;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;
	font-family:"Courier New";}
@list l1:level9
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;
	font-family:Wingdings;}
@list l2
	{mso-list-id:2067214972;
	mso-list-type:hybrid;
	mso-list-template-ids:-1075653594 -853493250 67698691 67698693 67698689 =
67698691 67698693 67698689 67698691 67698693;}
@list l2:level1
	{mso-level-start-at:0;
	mso-level-number-format:bullet;
	mso-level-text:\F0D8;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;
	font-family:Wingdings;
	mso-fareast-font-family:Calibri;
	mso-bidi-font-family:"Times New Roman";}
@list l2:level2
	{mso-level-number-format:bullet;
	mso-level-text:o;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;
	font-family:"Courier New";}
@list l2:level3
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;
	font-family:Wingdings;}
@list l2:level4
	{mso-level-number-format:bullet;
	mso-level-text:\F0B7;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;
	font-family:Symbol;}
@list l2:level5
	{mso-level-number-format:bullet;
	mso-level-text:o;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;
	font-family:"Courier New";}
@list l2:level6
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;
	font-family:Wingdings;}
@list l2:level7
	{mso-level-number-format:bullet;
	mso-level-text:\F0B7;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;
	font-family:Symbol;}
@list l2:level8
	{mso-level-number-format:bullet;
	mso-level-text:o;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;
	font-family:"Courier New";}
@list l2:level9
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;
	font-family:Wingdings;}
ol
	{margin-bottom:0in;}
ul
	{margin-bottom:0in;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]--></head><body lang=3DEN-US link=3Dblue =
vlink=3Dpurple><div class=3DWordSection1><p class=3DMsoNormal>On =
03/23/2012 02:41 PM, Hart, Brian R. wrote:<o:p></o:p></p><p =
class=3DMsoNormal>(<a =
href=3D"https://www.redhat.com/archives/dm-devel/2012-March/msg00155.html=
">https://www.redhat.com/archives/dm-devel/2012-March/msg00155.html</a>)<=
o:p></o:p></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p =
class=3DMsoNormal>&gt; We have a couple of Dell MD storage arrays that =
when installed<o:p></o:p></p><p class=3DMsoNormal>&gt; setup =
multipath.conf to use this line: prio_callout<o:p></o:p></p><p =
class=3DMsoNormal>&gt; &quot;/sbin/mpath_prio_rdac =
/dev/%n&quot;<o:p></o:p></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p =
class=3DMsoNormal>On 03/23/2012 02:41 PM, Bryn M. Reeves =
wrote:<o:p></o:p></p><p class=3DMsoNormal>(<a =
href=3D"https://www.redhat.com/archives/dm-devel/2012-March/msg00155.html=
">https://www.redhat.com/archives/dm-devel/2012-March/msg00155.html</a>)<=
o:p></o:p></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p =
class=3DMsoNormal>&gt;Callouts make life difficult when file systems go =
away so like the<o:p></o:p></p><p class=3DMsoNormal>&gt;path checkers =
before them they were merged into the libmultipath<o:p></o:p></p><p =
class=3DMsoNormal>&gt;shared library. This means that the daemon can =
lock them into memory<o:p></o:p></p><p class=3DMsoNormal>&gt;via =
mlock(2)/mlockall(2) and not have to worry about being able =
to<o:p></o:p></p><p class=3DMsoNormal>&gt;load a binary from disk when =
the paths to that storage have failed -<o:p></o:p></p><p =
class=3DMsoNormal>&gt;this is very useful if your root file system is on =
multipath and you<o:p></o:p></p><p class=3DMsoNormal>&gt;need to recover =
from a failure.<o:p></o:p></p><p =
class=3DMsoNormal>&gt;<o:p>&nbsp;</o:p></p><p class=3DMsoNormal>&gt;In =
RHEL5 this is dealt with using a complex and fragile =
private<o:p></o:p></p><p class=3DMsoNormal>&gt;namespace and RAM-backed =
file system - the required binaries are<o:p></o:p></p><p =
class=3DMsoNormal>&gt;copied into this ramfs at daemon startup and the =
daemon unmounts<o:p></o:p></p><p class=3DMsoNormal>&gt;unnecessary file =
systems to avoid blocking when failures occur.<o:p></o:p></p><p =
class=3DMsoNormal>&gt;<o:p>&nbsp;</o:p></p><p class=3DMsoNormal>&gt;For =
this reason the parameter is now just &quot;prio&quot;, =
e.g.:<o:p></o:p></p><p class=3DMsoNormal>&gt;<o:p>&nbsp;</o:p></p><p =
class=3DMsoNormal>&gt;device {<o:p></o:p></p><p =
class=3DMsoNormal>&#8230;<o:p></o:p></p><p =
class=3DMsoNormal>&gt;&nbsp;&nbsp;&nbsp; =
prio&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;rdac<o:p></o:p></p>=
<p class=3DMsoNormal>&gt;}<o:p></o:p></p><p =
class=3DMsoNormal><o:p>&nbsp;</o:p></p><p class=3DMsoNormal>I can see =
that using shared libraries to handle priorities makes handling failed =
paths easier in many situations. But how to configure active/backup =
multipath in the following case, for example<o:p></o:p></p><p =
class=3DMsoNormal><o:p>&nbsp;</o:p></p><p class=3DMsoListParagraph =
style=3D'text-indent:-.25in;mso-list:l1 level1 lfo3'><![if =
!supportLists]><span style=3D'mso-list:Ignore'>-<span =
style=3D'font:7.0pt "Times New =
Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
</span></span><![endif]>1st path uses iSCSI over =
Infiniband<o:p></o:p></p><p class=3DMsoListParagraph =
style=3D'text-indent:-.25in;mso-list:l1 level1 lfo3'><![if =
!supportLists]><span style=3D'mso-list:Ignore'>-<span =
style=3D'font:7.0pt "Times New =
Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
</span></span><![endif]>2nd path used iSCSI over Gigabit =
Ethernet<o:p></o:p></p><p class=3DMsoListParagraph =
style=3D'text-indent:-.25in;mso-list:l1 level1 lfo3'><![if =
!supportLists]><span style=3D'mso-list:Ignore'>-<span =
style=3D'font:7.0pt "Times New =
Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
</span></span><![endif]>iSCSI target does not support =
ALUA<o:p></o:p></p><p class=3DMsoListParagraph =
style=3D'text-indent:-.25in;mso-list:l1 level1 lfo3'><![if =
!supportLists]><span style=3D'mso-list:Ignore'>-<span =
style=3D'font:7.0pt "Times New =
Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
</span></span><![endif]>we want Infiniband path to have higher =
priority<o:p></o:p></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p =
class=3DMsoNormal>Will it be enough to set path_grouping_policy =3D =
&nbsp;multibus and path_selector =3D &#8220;service-time 0&#8221;? Will =
Gigabit Ethernet path be never used as long as Infiniband path is =
working?<o:p></o:p></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p =
class=3DMsoNormal>I appreciate your help,<o:p></o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp; Alexander =
Murashkin<o:p></o:p></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p =
class=3DMsoNormal>Email: =
&nbsp;AlexanderMurashkin@msn.com<o:p></o:p></p><p =
class=3DMsoNormal><o:p>&nbsp;</o:p></p><p =
class=3DMsoNormal><o:p>&nbsp;</o:p></p></div></body></html>
------=_NextPart_000_0082_01CD0C96.271E0940--


--===============6093647820168350282==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6093647820168350282==--
