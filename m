From: =?gb2312?B?VG9tIEdlbmcouaK3vNbSKQ==?= <gengfangzhong@inspur.com>
Subject: multipath-tools: add INSPUR/MCS to hardware table
Date: Mon, 22 Jan 2018 10:55:17 +0000
Message-ID: <6FA0216CBF61AE4AA9DA6744243E7853DB5C42F2@jtjnmailbox06.home.langchao.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3666103423045382305=="
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: zh-CN
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

--===============3666103423045382305==
Content-Language: zh-CN
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature";
	micalg=SHA1; boundary="----=_NextPart_000_00B3_01D393B2.8A33AAE0"

------=_NextPart_000_00B3_01D393B2.8A33AAE0
Content-Type: multipart/alternative;
	boundary="----=_NextPart_001_00B4_01D393B2.8A33AAE0"


------=_NextPart_001_00B4_01D393B2.8A33AAE0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit

Hi, everybody,

I added a new device support, the history and code diff is as below, will
the maintainers help to review and submit? 

Thank you a lot.

 

 

$ git log

commit f7bec5ee939ffff079cc01f8a09e7e51e4b26365 (HEAD -> master, develop)

Author: Tom Geng <gengfangzhong@inspur.com>

Date:   Fri Jan 19 10:25:11 2018 +0800

 

        multipath-tools: add new device, product name is INSPUR
AS5300/AS5500 G2.

 

        It's dual-controller, Active-Active mode, and SPC-3 ALUA feature

        support.

 

        Signed-off-by: Tom Geng <gengfangzhong@inspur.com>

 

commit 07e7bd579ea22e3de0f6481643e9b0809cd76210 (origin/master, origin/HEAD)

Author: Benjamin Marzinski <bmarzins@redhat.com>

Date:   Wed Dec 13 12:08:07 2017 -0600

 

    libmultipath: don't update path queueing on reload

 

    With the fix to the features handling code, the multipath device should

    already be reloaded with the correct value for queue_if_no_path, so

    there's no need to go reset it immediately afterwards.

 

    Cc: Martin Wilck <mwilck@suse.com>

    Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

 

commit 7e7441e9f0127e0bcf23771955ab829f489641fe

Author: Benjamin Marzinski <bmarzins@redhat.com>

Date:   Thu Dec 7 12:49:06 2017 -0600

 

    multipathd: marginal path code fixes

 

 

 

$ git diff f7bec5e..07e7bd5

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c

index c8acf3af..448effe3 100644

--- a/libmultipath/hwtable.c

+++ b/libmultipath/hwtable.c

@@ -1181,21 +1181,6 @@ static struct hwentry default_hw[] = {

                .pgpolicy      = MULTIBUS,

                .no_path_retry = 30,

        },

-       /*

-        * INSPUR

-        *

-        * Maintainer: Tom Geng

-        * Mail: gengfangzhong@inspur.com

-        */

-       {

-               /* AS5300/AS5500 G2 */

-               .vendor        = "INSPUR",

-               .product       = "MCS",

-               .pgpolicy      = GROUP_BY_PRIO,

-               .selector      = "round-robin 0",

-               .pgfailback    = -FAILBACK_IMMEDIATE,

-               .prio_name     = PRIO_ALUA,

-       },

        /*

         * EOL

         */

 

 

Tom Geng

2018.01.22

 


------=_NextPart_001_00B4_01D393B2.8A33AAE0
Content-Type: text/html;
	charset="gb2312"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" =
xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" =
xmlns=3D"http://www.w3.org/TR/REC-html40"><head><meta =
http-equiv=3DContent-Type content=3D"text/html; charset=3Dgb2312"><meta =
name=3DGenerator content=3D"Microsoft Word 15 (filtered =
medium)"><style><!--
/* Font Definitions */
@font-face
	{font-family:=CB=CE=CC=E5;
	panose-1:2 1 6 0 3 1 1 1 1 1;}
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
@font-face
	{font-family:"\@=CB=CE=CC=E5";
	panose-1:2 1 6 0 3 1 1 1 1 1;}
@font-face
	{font-family:"Lucida Console";
	panose-1:2 11 6 9 4 5 4 2 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
	margin-bottom:.0001pt;
	text-align:justify;
	text-justify:inter-ideograph;
	font-size:10.5pt;
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
/* Page Definitions */
@page WordSection1
	{size:612.0pt 792.0pt;
	margin:72.0pt 90.0pt 72.0pt 90.0pt;}
div.WordSection1
	{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]--></head><body lang=3DZH-CN =
link=3D"#0563C1" vlink=3D"#954F72" =
style=3D'text-justify-trim:punctuation'><div class=3DWordSection1><p =
class=3DMsoNormal><span lang=3DEN-US>Hi, =
everybody,<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>I added a new device support, the history and code diff is =
as below, will the maintainers help to review and submit? =
<o:p></o:p></span></p><p class=3DMsoNormal><span lang=3DEN-US>Thank you =
a lot.<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal =
align=3Dleft style=3D'text-align:left;text-autospace:none'><span =
lang=3DEN-US style=3D'font-size:9.0pt;font-family:"Lucida Console"'>$ =
git log<o:p></o:p></span></p><p class=3DMsoNormal align=3Dleft =
style=3D'text-align:left;text-autospace:none'><span lang=3DEN-US =
style=3D'font-size:9.0pt;font-family:"Lucida =
Console";color:#BFBF00'>commit f7bec5ee939ffff079cc01f8a09e7e51e4b26365 =
(</span><span lang=3DEN-US style=3D'font-size:9.0pt;font-family:"Lucida =
Console";color:#40FFFF'>HEAD -&gt; </span><span lang=3DEN-US =
style=3D'font-size:9.0pt;font-family:"Lucida =
Console";color:#40FF40'>master</span><span lang=3DEN-US =
style=3D'font-size:9.0pt;font-family:"Lucida Console";color:#BFBF00'>, =
</span><span lang=3DEN-US style=3D'font-size:9.0pt;font-family:"Lucida =
Console";color:#40FF40'>develop</span><span lang=3DEN-US =
style=3D'font-size:9.0pt;font-family:"Lucida =
Console";color:#BFBF00'>)<o:p></o:p></span></p><p class=3DMsoNormal =
align=3Dleft style=3D'text-align:left;text-autospace:none'><span =
lang=3DEN-US style=3D'font-size:9.0pt;font-family:"Lucida =
Console"'>Author: Tom Geng =
&lt;gengfangzhong@inspur.com&gt;<o:p></o:p></span></p><p =
class=3DMsoNormal align=3Dleft =
style=3D'text-align:left;text-autospace:none'><span lang=3DEN-US =
style=3D'font-size:9.0pt;font-family:"Lucida Console"'>Date:&nbsp;&nbsp; =
Fri Jan 19 10:25:11 2018 +0800<o:p></o:p></span></p><p class=3DMsoNormal =
align=3Dleft style=3D'text-align:left;text-autospace:none'><span =
lang=3DEN-US style=3D'font-size:9.0pt;font-family:"Lucida =
Console"'><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal align=3Dleft =
style=3D'text-align:left;text-autospace:none'><span lang=3DEN-US =
style=3D'font-size:9.0pt;font-family:"Lucida =
Console"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; multipath-tools: =
add new device, product name is INSPUR AS5300/AS5500 =
G2.<o:p></o:p></span></p><p class=3DMsoNormal align=3Dleft =
style=3D'text-align:left;text-autospace:none'><span lang=3DEN-US =
style=3D'font-size:9.0pt;font-family:"Lucida =
Console"'><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal align=3Dleft =
style=3D'text-align:left;text-autospace:none'><span lang=3DEN-US =
style=3D'font-size:9.0pt;font-family:"Lucida =
Console"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; It's =
dual-controller, Active-Active mode, and SPC-3 ALUA =
feature<o:p></o:p></span></p><p class=3DMsoNormal align=3Dleft =
style=3D'text-align:left;text-autospace:none'><span lang=3DEN-US =
style=3D'font-size:9.0pt;font-family:"Lucida =
Console"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
support.<o:p></o:p></span></p><p class=3DMsoNormal align=3Dleft =
style=3D'text-align:left;text-autospace:none'><span lang=3DEN-US =
style=3D'font-size:9.0pt;font-family:"Lucida =
Console"'><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal align=3Dleft =
style=3D'text-align:left;text-autospace:none'><span lang=3DEN-US =
style=3D'font-size:9.0pt;font-family:"Lucida =
Console"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Signed-off-by: Tom =
Geng &lt;gengfangzhong@inspur.com&gt;<o:p></o:p></span></p><p =
class=3DMsoNormal align=3Dleft =
style=3D'text-align:left;text-autospace:none'><span lang=3DEN-US =
style=3D'font-size:9.0pt;font-family:"Lucida =
Console"'><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal align=3Dleft =
style=3D'text-align:left;text-autospace:none'><span lang=3DEN-US =
style=3D'font-size:9.0pt;font-family:"Lucida =
Console";color:#BFBF00'>commit 07e7bd579ea22e3de0f6481643e9b0809cd76210 =
(</span><span lang=3DEN-US style=3D'font-size:9.0pt;font-family:"Lucida =
Console";color:#FF4040'>origin/master</span><span lang=3DEN-US =
style=3D'font-size:9.0pt;font-family:"Lucida Console";color:#BFBF00'>, =
</span><span lang=3DEN-US style=3D'font-size:9.0pt;font-family:"Lucida =
Console";color:#FF4040'>origin/HEAD</span><span lang=3DEN-US =
style=3D'font-size:9.0pt;font-family:"Lucida =
Console";color:#BFBF00'>)<o:p></o:p></span></p><p class=3DMsoNormal =
align=3Dleft style=3D'text-align:left;text-autospace:none'><span =
lang=3DEN-US style=3D'font-size:9.0pt;font-family:"Lucida =
Console"'>Author: Benjamin Marzinski =
&lt;bmarzins@redhat.com&gt;<o:p></o:p></span></p><p class=3DMsoNormal =
align=3Dleft style=3D'text-align:left;text-autospace:none'><span =
lang=3DEN-US style=3D'font-size:9.0pt;font-family:"Lucida =
Console"'>Date:&nbsp;&nbsp; Wed Dec 13 12:08:07 2017 =
-0600<o:p></o:p></span></p><p class=3DMsoNormal align=3Dleft =
style=3D'text-align:left;text-autospace:none'><span lang=3DEN-US =
style=3D'font-size:9.0pt;font-family:"Lucida =
Console"'><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal align=3Dleft =
style=3D'text-align:left;text-autospace:none'><span lang=3DEN-US =
style=3D'font-size:9.0pt;font-family:"Lucida =
Console"'>&nbsp;&nbsp;&nbsp; libmultipath: don't update path queueing on =
reload<o:p></o:p></span></p><p class=3DMsoNormal align=3Dleft =
style=3D'text-align:left;text-autospace:none'><span lang=3DEN-US =
style=3D'font-size:9.0pt;font-family:"Lucida =
Console"'><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal align=3Dleft =
style=3D'text-align:left;text-autospace:none'><span lang=3DEN-US =
style=3D'font-size:9.0pt;font-family:"Lucida =
Console"'>&nbsp;&nbsp;&nbsp; With the fix to the features handling code, =
the multipath device should<o:p></o:p></span></p><p class=3DMsoNormal =
align=3Dleft style=3D'text-align:left;text-autospace:none'><span =
lang=3DEN-US style=3D'font-size:9.0pt;font-family:"Lucida =
Console"'>&nbsp;&nbsp;&nbsp; already be reloaded with the correct value =
for queue_if_no_path, so<o:p></o:p></span></p><p class=3DMsoNormal =
align=3Dleft style=3D'text-align:left;text-autospace:none'><span =
lang=3DEN-US style=3D'font-size:9.0pt;font-family:"Lucida =
Console"'>&nbsp;&nbsp;&nbsp; there's no need to go reset it immediately =
afterwards.<o:p></o:p></span></p><p class=3DMsoNormal align=3Dleft =
style=3D'text-align:left;text-autospace:none'><span lang=3DEN-US =
style=3D'font-size:9.0pt;font-family:"Lucida =
Console"'><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal align=3Dleft =
style=3D'text-align:left;text-autospace:none'><span lang=3DEN-US =
style=3D'font-size:9.0pt;font-family:"Lucida =
Console"'>&nbsp;&nbsp;&nbsp; Cc: Martin Wilck =
&lt;mwilck@suse.com&gt;<o:p></o:p></span></p><p class=3DMsoNormal =
align=3Dleft style=3D'text-align:left;text-autospace:none'><span =
lang=3DEN-US style=3D'font-size:9.0pt;font-family:"Lucida =
Console"'>&nbsp;&nbsp;&nbsp; Signed-off-by: Benjamin Marzinski =
&lt;bmarzins@redhat.com&gt;<o:p></o:p></span></p><p class=3DMsoNormal =
align=3Dleft style=3D'text-align:left;text-autospace:none'><span =
lang=3DEN-US style=3D'font-size:9.0pt;font-family:"Lucida =
Console"'><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal align=3Dleft =
style=3D'text-align:left;text-autospace:none'><span lang=3DEN-US =
style=3D'font-size:9.0pt;font-family:"Lucida =
Console";color:#BFBF00'>commit =
7e7441e9f0127e0bcf23771955ab829f489641fe<o:p></o:p></span></p><p =
class=3DMsoNormal align=3Dleft =
style=3D'text-align:left;text-autospace:none'><span lang=3DEN-US =
style=3D'font-size:9.0pt;font-family:"Lucida Console"'>Author: Benjamin =
Marzinski &lt;bmarzins@redhat.com&gt;<o:p></o:p></span></p><p =
class=3DMsoNormal align=3Dleft =
style=3D'text-align:left;text-autospace:none'><span lang=3DEN-US =
style=3D'font-size:9.0pt;font-family:"Lucida Console"'>Date:&nbsp;&nbsp; =
Thu Dec 7 12:49:06 2017 -0600<o:p></o:p></span></p><p class=3DMsoNormal =
align=3Dleft style=3D'text-align:left;text-autospace:none'><span =
lang=3DEN-US style=3D'font-size:9.0pt;font-family:"Lucida =
Console"'><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal align=3Dleft =
style=3D'text-align:left;text-autospace:none'><span lang=3DEN-US =
style=3D'font-size:9.0pt;font-family:"Lucida =
Console"'>&nbsp;&nbsp;&nbsp; multipathd: marginal path code =
fixes<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal =
align=3Dleft style=3D'text-align:left;text-autospace:none'><span =
lang=3DEN-US style=3D'font-size:9.0pt;font-family:"Lucida Console"'>$ =
git diff f7bec5e..07e7bd5<o:p></o:p></span></p><p class=3DMsoNormal =
align=3Dleft style=3D'text-align:left;text-autospace:none'><b><span =
lang=3DEN-US style=3D'font-size:9.0pt;font-family:"Lucida Console"'>diff =
--git a/libmultipath/hwtable.c =
b/libmultipath/hwtable.c<o:p></o:p></span></b></p><p class=3DMsoNormal =
align=3Dleft style=3D'text-align:left;text-autospace:none'><b><span =
lang=3DEN-US style=3D'font-size:9.0pt;font-family:"Lucida =
Console"'>index c8acf3af..448effe3 100644<o:p></o:p></span></b></p><p =
class=3DMsoNormal align=3Dleft =
style=3D'text-align:left;text-autospace:none'><b><span lang=3DEN-US =
style=3D'font-size:9.0pt;font-family:"Lucida Console"'>--- =
a/libmultipath/hwtable.c<o:p></o:p></span></b></p><p class=3DMsoNormal =
align=3Dleft style=3D'text-align:left;text-autospace:none'><b><span =
lang=3DEN-US style=3D'font-size:9.0pt;font-family:"Lucida Console"'>+++ =
b/libmultipath/hwtable.c<o:p></o:p></span></b></p><p class=3DMsoNormal =
align=3Dleft style=3D'text-align:left;text-autospace:none'><span =
lang=3DEN-US style=3D'font-size:9.0pt;font-family:"Lucida =
Console";color:#00BFBF'>@@ -1181,21 +1181,6 @@</span><span lang=3DEN-US =
style=3D'font-size:9.0pt;font-family:"Lucida Console"'> static struct =
hwentry default_hw[] =3D {<o:p></o:p></span></p><p class=3DMsoNormal =
align=3Dleft style=3D'text-align:left;text-autospace:none'><span =
lang=3DEN-US style=3D'font-size:9.0pt;font-family:"Lucida =
Console"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp; .pgpolicy&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =3D =
MULTIBUS,<o:p></o:p></span></p><p class=3DMsoNormal align=3Dleft =
style=3D'text-align:left;text-autospace:none'><span lang=3DEN-US =
style=3D'font-size:9.0pt;font-family:"Lucida =
Console"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp; .no_path_retry =3D =
30,<o:p></o:p></span></p><p class=3DMsoNormal align=3Dleft =
style=3D'text-align:left;text-autospace:none'><span lang=3DEN-US =
style=3D'font-size:9.0pt;font-family:"Lucida =
Console"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
},<o:p></o:p></span></p><p class=3DMsoNormal align=3Dleft =
style=3D'text-align:left;text-autospace:none'><span lang=3DEN-US =
style=3D'font-size:9.0pt;font-family:"Lucida =
Console";color:#BF0000'>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
/*<o:p></o:p></span></p><p class=3DMsoNormal align=3Dleft =
style=3D'text-align:left;text-autospace:none'><span lang=3DEN-US =
style=3D'font-size:9.0pt;font-family:"Lucida =
Console";color:#BF0000'>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * =
INSPUR<o:p></o:p></span></p><p class=3DMsoNormal align=3Dleft =
style=3D'text-align:left;text-autospace:none'><span lang=3DEN-US =
style=3D'font-size:9.0pt;font-family:"Lucida =
Console";color:#BF0000'>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
*<o:p></o:p></span></p><p class=3DMsoNormal align=3Dleft =
style=3D'text-align:left;text-autospace:none'><span lang=3DEN-US =
style=3D'font-size:9.0pt;font-family:"Lucida =
Console";color:#BF0000'>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * =
Maintainer: Tom Geng<o:p></o:p></span></p><p class=3DMsoNormal =
align=3Dleft style=3D'text-align:left;text-autospace:none'><span =
lang=3DEN-US style=3D'font-size:9.0pt;font-family:"Lucida =
Console";color:#BF0000'>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * =
Mail: gengfangzhong@inspur.com<o:p></o:p></span></p><p class=3DMsoNormal =
align=3Dleft style=3D'text-align:left;text-autospace:none'><span =
lang=3DEN-US style=3D'font-size:9.0pt;font-family:"Lucida =
Console";color:#BF0000'>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
*/<o:p></o:p></span></p><p class=3DMsoNormal align=3Dleft =
style=3D'text-align:left;text-autospace:none'><span lang=3DEN-US =
style=3D'font-size:9.0pt;font-family:"Lucida =
Console";color:#BF0000'>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
{<o:p></o:p></span></p><p class=3DMsoNormal align=3Dleft =
style=3D'text-align:left;text-autospace:none'><span lang=3DEN-US =
style=3D'font-size:9.0pt;font-family:"Lucida =
Console";color:#BF0000'>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* AS5300/AS5500 G2 =
*/<o:p></o:p></span></p><p class=3DMsoNormal align=3Dleft =
style=3D'text-align:left;text-autospace:none'><span lang=3DEN-US =
style=3D'font-size:9.0pt;font-family:"Lucida =
Console";color:#BF0000'>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
.vendor&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =3D =
&quot;INSPUR&quot;,<o:p></o:p></span></p><p class=3DMsoNormal =
align=3Dleft style=3D'text-align:left;text-autospace:none'><span =
lang=3DEN-US style=3D'font-size:9.0pt;font-family:"Lucida =
Console";color:#BF0000'>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
.product&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =3D =
&quot;MCS&quot;,<o:p></o:p></span></p><p class=3DMsoNormal align=3Dleft =
style=3D'text-align:left;text-autospace:none'><span lang=3DEN-US =
style=3D'font-size:9.0pt;font-family:"Lucida =
Console";color:#BF0000'>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
.pgpolicy&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =3D =
GROUP_BY_PRIO,<o:p></o:p></span></p><p class=3DMsoNormal align=3Dleft =
style=3D'text-align:left;text-autospace:none'><span lang=3DEN-US =
style=3D'font-size:9.0pt;font-family:"Lucida =
Console";color:#BF0000'>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
.selector&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =3D &quot;round-robin =
0&quot;,<o:p></o:p></span></p><p class=3DMsoNormal align=3Dleft =
style=3D'text-align:left;text-autospace:none'><span lang=3DEN-US =
style=3D'font-size:9.0pt;font-family:"Lucida =
Console";color:#BF0000'>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .pgfailback&nbsp;&nbsp;&nbsp; =3D =
-FAILBACK_IMMEDIATE,<o:p></o:p></span></p><p class=3DMsoNormal =
align=3Dleft style=3D'text-align:left;text-autospace:none'><span =
lang=3DEN-US style=3D'font-size:9.0pt;font-family:"Lucida =
Console";color:#BF0000'>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .prio_name&nbsp;&nbsp;&nbsp;&nbsp; =
=3D PRIO_ALUA,<o:p></o:p></span></p><p class=3DMsoNormal align=3Dleft =
style=3D'text-align:left;text-autospace:none'><span lang=3DEN-US =
style=3D'font-size:9.0pt;font-family:"Lucida =
Console";color:#BF0000'>-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
},<o:p></o:p></span></p><p class=3DMsoNormal align=3Dleft =
style=3D'text-align:left;text-autospace:none'><span lang=3DEN-US =
style=3D'font-size:9.0pt;font-family:"Lucida =
Console"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
/*<o:p></o:p></span></p><p class=3DMsoNormal align=3Dleft =
style=3D'text-align:left;text-autospace:none'><span lang=3DEN-US =
style=3D'font-size:9.0pt;font-family:"Lucida =
Console"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * =
EOL<o:p></o:p></span></p><p class=3DMsoNormal align=3Dleft =
style=3D'text-align:left;text-autospace:none'><span lang=3DEN-US =
style=3D'font-size:9.0pt;font-family:"Lucida =
Console"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
*/<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>Tom Geng<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US>2018.01.22<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-US><o:p>&nbsp;</o:p></span></p></div></body></html>
------=_NextPart_001_00B4_01D393B2.8A33AAE0--

------=_NextPart_000_00B3_01D393B2.8A33AAE0
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIMUTCCBOgw
ggPQoAMCAQICEHJZ3dAghQm7TR3WtIciZWowDQYJKoZIhvcNAQEFBQAwWzETMBEGCgmSJomT8ixk
ARkWA2NvbTEYMBYGCgmSJomT8ixkARkWCGxhbmdjaGFvMRQwEgYKCZImiZPyLGQBGRYEaG9tZTEU
MBIGA1UEAxMLTGFuZ0NoYW8tQ0EwHhcNMDUwMTEyMDcyNTIyWhcNMjQxMTA3MTcyNjM4WjBbMRMw
EQYKCZImiZPyLGQBGRYDY29tMRgwFgYKCZImiZPyLGQBGRYIbGFuZ2NoYW8xFDASBgoJkiaJk/Is
ZAEZFgRob21lMRQwEgYDVQQDEwtMYW5nQ2hhby1DQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCC
AQoCggEBAMvRSQUPw6jL6C6jqLQaQW3/yXkiew6X5DFftp11ymCmwpOEKEAHQEsOqiha/Lkj8ORt
6KjfEHc1Z4AYgzXz9YJx0lJGoM27U/o07gu73XKTYTLEbs+MCb9Juq52ptSsRsZHBb0n4AfBjFON
8gzgDmTg9TRyM2yNXDHoA1pSrHYvNT37urklW4XorW5DeMGohxlpOApkhsqlGpS2w7C2ZAR82NCp
+80yCDXraDZ5cCOhQAyZ6qHcWJIloyi8+gwzJi1MqWB91JjE4wicxof9SCyNtdbx2XwKxSL5U0zM
sZQJ+201lvmaqCrPSMcoUdZxWWKM2yYtro7oEiwB/4jpaHsCAwEAAaOCAaYwggGiMBMGCSsGAQQB
gjcUAgQGHgQAQwBBMAsGA1UdDwQEAwIBhjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBTGbsOi
E24avQY6XrcvNNjg05z7IzCCARUGA1UdHwSCAQwwggEIMIIBBKCCAQCggf2GgbxsZGFwOi8vL0NO
PUxhbmdDaGFvLUNBLENOPWp0am5jYTAxLENOPUNEUCxDTj1QdWJsaWMlMjBLZXklMjBTZXJ2aWNl
cyxDTj1TZXJ2aWNlcyxDTj1Db25maWd1cmF0aW9uLERDPWhvbWUsREM9bGFuZ2NoYW8sREM9Y29t
P2NlcnRpZmljYXRlUmV2b2NhdGlvbkxpc3Q/YmFzZT9vYmplY3RDbGFzcz1jUkxEaXN0cmlidXRp
b25Qb2ludIY8aHR0cDovL2p0am5jYTAxLmhvbWUubGFuZ2NoYW8uY29tL0NlcnRFbnJvbGwvTGFu
Z0NoYW8tQ0EuY3JsMBAGCSsGAQQBgjcVAQQDAgEBMCMGCSsGAQQBgjcVAgQWBBRYQgrth4/MB0pS
3hx7TTpz3BidCDANBgkqhkiG9w0BAQUFAAOCAQEAWjsuzhyiArAxdntQqbkoOaDt/caM2xEA3hWn
gjl4yJeKxxuU0U5KLs7wcaVYantJjeL7jb9r29Aeb5lRzcUHodJgk2xvNYAI0s7ZkmahMSbPIMha
w6sKSiq2bI08u7cyPoW5HxVJz3pEM4IkuLaWmMm/I3BUUQE3rxUdXy7iq2CE7KPNKIf+wDuouDgm
bWItUuIev5toOR37MxpPS02Ci1H2KxOGkMDFAWJawNgzseRaRqEJdgMelpS46KnBaT3uFI/wqG+0
1pMVfldgzOBA9Jaj4AC/AWU+v8Ks6+yX8/14Se7bkRltLqmXI6EGHo6KBiIAP2uGHg7lGzCmR/Ja
dTCCB2EwggZJoAMCAQICChBNNNUAAQACdUkwDQYJKoZIhvcNAQEFBQAwWzETMBEGCgmSJomT8ixk
ARkWA2NvbTEYMBYGCgmSJomT8ixkARkWCGxhbmdjaGFvMRQwEgYKCZImiZPyLGQBGRYEaG9tZTEU
MBIGA1UEAxMLTGFuZ0NoYW8tQ0EwHhcNMTcwNjIyMDgzMDMyWhcNMjIwNjIxMDgzMDMyWjCBqjET
MBEGCgmSJomT8ixkARkWA2NvbTEYMBYGCgmSJomT8ixkARkWCGxhbmdjaGFvMRQwEgYKCZImiZPy
LGQBGRYEaG9tZTEVMBMGA1UECwwM5rWq5r2u5L+h5oGvMQ8wDQYDVQQLDAbnlKjmiLcxEjAQBgNV
BAMMCeiAv+iKs+W/oDEnMCUGCSqGSIb3DQEJARYYZ2VuZ2Zhbmd6aG9uZ0BpbnNwdXIuY29tMIIB
IjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA5QJoej3RSHiDlu7XjHI2tF+YlCUeBItIMzw5
RvGVP5kJUV0zhp0sZhSBCUA81BenIzONGwuOUak0J0+hzQNAs8NHDaRhJrRMmGju3sY+nxMskOw2
rZx50ea24h6TJYvbf6AFVc+knvNzPzvua4GClF3kh+zfg/UwEBfgpHbUWDNzHFiGPHbvEdgrDF5y
rxllUtRP6its4Wm+4DGrG+bG6hXIEQ1Y9AvM/+p3rPEvGtoOu+UfLjZihccyACuxKjJwRzY/nwzR
/PuRsXg0iFenrFOBkE+anAJ91ETPTEUN40omAXIp/LnGM/ZYAmCNK+8hqa/XZOJ6h78oaVPK8sF6
QwIDAQABo4ID1TCCA9EwCwYDVR0PBAQDAgWgMD4GCSsGAQQBgjcVBwQxMC8GJysGAQQBgjcVCILy
qR+Egdd6hqmRPYaA9xWD2I9cgUqGoq0dhteULAIBZAIBGTBEBgkqhkiG9w0BCQ8ENzA1MA4GCCqG
SIb3DQMCAgIAgDAOBggqhkiG9w0DBAICAIAwBwYFKw4DAgcwCgYIKoZIhvcNAwcwHQYDVR0OBBYE
FF3jIZwxg36oDTvJUiQNwy75rtbEMB8GA1UdIwQYMBaAFMZuw6ITbhq9Bjpety802ODTnPsjMIIB
FQYDVR0fBIIBDDCCAQgwggEEoIIBAKCB/YaBvGxkYXA6Ly8vQ049TGFuZ0NoYW8tQ0EsQ049anRq
bmNhMDEsQ049Q0RQLENOPVB1YmxpYyUyMEtleSUyMFNlcnZpY2VzLENOPVNlcnZpY2VzLENOPUNv
bmZpZ3VyYXRpb24sREM9aG9tZSxEQz1sYW5nY2hhbyxEQz1jb20/Y2VydGlmaWNhdGVSZXZvY2F0
aW9uTGlzdD9iYXNlP29iamVjdENsYXNzPWNSTERpc3RyaWJ1dGlvblBvaW50hjxodHRwOi8vanRq
bmNhMDEuaG9tZS5sYW5nY2hhby5jb20vQ2VydEVucm9sbC9MYW5nQ2hhby1DQS5jcmwwggEwBggr
BgEFBQcBAQSCASIwggEeMIGzBggrBgEFBQcwAoaBpmxkYXA6Ly8vQ049TGFuZ0NoYW8tQ0EsQ049
QUlBLENOPVB1YmxpYyUyMEtleSUyMFNlcnZpY2VzLENOPVNlcnZpY2VzLENOPUNvbmZpZ3VyYXRp
b24sREM9aG9tZSxEQz1sYW5nY2hhbyxEQz1jb20/Y0FDZXJ0aWZpY2F0ZT9iYXNlP29iamVjdENs
YXNzPWNlcnRpZmljYXRpb25BdXRob3JpdHkwZgYIKwYBBQUHMAKGWmh0dHA6Ly9qdGpuY2EwMS5o
b21lLmxhbmdjaGFvLmNvbS9DZXJ0RW5yb2xsL2p0am5jYTAxLmhvbWUubGFuZ2NoYW8uY29tX0xh
bmdDaGFvLUNBKDEpLmNydDApBgNVHSUEIjAgBggrBgEFBQcDAgYIKwYBBQUHAwQGCisGAQQBgjcK
AwQwNQYJKwYBBAGCNxUKBCgwJjAKBggrBgEFBQcDAjAKBggrBgEFBQcDBDAMBgorBgEEAYI3CgME
ME0GA1UdEQRGMESgKAYKKwYBBAGCNxQCA6AaDBhnZW5nZmFuZ3pob25nQGluc3B1ci5jb22BGGdl
bmdmYW5nemhvbmdAaW5zcHVyLmNvbTANBgkqhkiG9w0BAQUFAAOCAQEAWE4veiN2R5QIPFRiYcVu
uy13sYJERwDO7uFGwYZlWo/H+VnTg4HVbBOW6oVYspPrL9T019Z0+E8mSnPepQrVQcCuy1PT7PZr
RkcdLbOo7U/tx60g+9lamhB8U+phCKSwWuzw3bH2YASugWx92hI2ZJb/d+4MvtpKUPEgCwV+5oM9
V0oRiej2nlRhZKYjfMiOjdEhEaRRa6j4/NzPOssioIn/eu1tC6ee4gHuHw9lV3yMLfBG69ObVYci
UgInzWyUUjh1+rkSRM1Xg0L7y1RE0of2643atPS95LlNO7TDBccoNuzWwURh9ZN/MFQmCKhRsZhg
Di4cLpUtyxyRgxnoeTGCA30wggN5AgEBMGkwWzETMBEGCgmSJomT8ixkARkWA2NvbTEYMBYGCgmS
JomT8ixkARkWCGxhbmdjaGFvMRQwEgYKCZImiZPyLGQBGRYEaG9tZTEUMBIGA1UEAxMLTGFuZ0No
YW8tQ0ECChBNNNUAAQACdUkwCQYFKw4DAhoFAKCCAekwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEH
ATAcBgkqhkiG9w0BCQUxDxcNMTgwMTIyMTA1NTE1WjAjBgkqhkiG9w0BCQQxFgQUlWatIe1HesJm
c8aNCyq9SGc46v4weAYJKwYBBAGCNxAEMWswaTBbMRMwEQYKCZImiZPyLGQBGRYDY29tMRgwFgYK
CZImiZPyLGQBGRYIbGFuZ2NoYW8xFDASBgoJkiaJk/IsZAEZFgRob21lMRQwEgYDVQQDEwtMYW5n
Q2hhby1DQQIKEE001QABAAJ1STB6BgsqhkiG9w0BCRACCzFroGkwWzETMBEGCgmSJomT8ixkARkW
A2NvbTEYMBYGCgmSJomT8ixkARkWCGxhbmdjaGFvMRQwEgYKCZImiZPyLGQBGRYEaG9tZTEUMBIG
A1UEAxMLTGFuZ0NoYW8tQ0ECChBNNNUAAQACdUkwgZMGCSqGSIb3DQEJDzGBhTCBgjALBglghkgB
ZQMEASowCwYJYIZIAWUDBAEWMAoGCCqGSIb3DQMHMAsGCWCGSAFlAwQBAjAOBggqhkiG9w0DAgIC
AIAwDQYIKoZIhvcNAwICAUAwBwYFKw4DAhowCwYJYIZIAWUDBAIDMAsGCWCGSAFlAwQCAjALBglg
hkgBZQMEAgEwDQYJKoZIhvcNAQEBBQAEggEAdJY2VXMrMgQGYdfQbHGVS0YOll01WZtqnocQPf5F
MOzsfoJkkiIgcMi8YYKcI/oPCWCEmts2h9yDcMQgbplgihLLpNpZycyk3qT7lyWMv8zjMGfKkI0t
GyOkZKmdpq5owes+igoB00/V47zRVWRBFpnCB5+KmzhNxWtf4t1rmAwSGddPNr2Odc3CK/7g9VbL
XkIpRdJikKQNt/35BcYQ8/tEAAtJDB40DKGgNly6Io45iWaEwXYKF/oBvPXt0bxSwNirerbVJ2US
LyJuaPi9LASc3gr+xpY6fh0PphS8pzRhkMKsscQ0XxTPMME5x8gZiz+3R25XIOj/AlxhejM+ogAA
AAAAAA==

------=_NextPart_000_00B3_01D393B2.8A33AAE0--


--===============3666103423045382305==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3666103423045382305==--
