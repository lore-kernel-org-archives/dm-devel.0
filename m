From: Xieyingtai <xieyingtai@huawei.com>
Subject: libmpathpersist: pthread join counts should be
 consistent with threads created
Date: Tue, 20 Oct 2015 12:07:35 +0000
Message-ID: <AF7C226D2A4F8B4D913D33FF7150AE051D6B21E9@szxeml556-mbs.china.huawei.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8684496177341265221=="
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
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

--===============8684496177341265221==
Content-Language: zh-CN
Content-Type: multipart/alternative;
	boundary="_000_AF7C226D2A4F8B4D913D33FF7150AE051D6B21E9szxeml556mbschi_"

--_000_AF7C226D2A4F8B4D913D33FF7150AE051D6B21E9szxeml556mbschi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

In mpath_prout_reg, it's perhaps more proper to modify active_pathcount to =
count which
is the actual thread counts created, otherwise it may leads to a segmentfau=
lt error.

---
libmpathpersist/mpath_persist.c | 2 +-
1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist
index 7a2249f..8518a2e 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -503,7 +503,7 @@ int mpath_prout_reg(struct multipath *mpp,
        count =3D count +1;
      }
     }
-    for( i=3D0; i < active_pathcount ; i++){
+    for( i=3D0; i < count ; i++){
      rc =3D pthread_join(thread[i].id, NULL);
      if (rc){
        condlog (0, "%s: Thread[%d] failed to join thread %d",
--
1.8.3.4



--_000_AF7C226D2A4F8B4D913D33FF7150AE051D6B21E9szxeml556mbschi_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<meta name=3D"Generator" content=3D"Microsoft Word 12 (filtered medium)">
<style><!--
/* Font Definitions */
@font-face
	{font-family:SimSun;
	panose-1:2 1 6 0 3 1 1 1 1 1;}
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
@font-face
	{font-family:SimSun;
	panose-1:2 1 6 0 3 1 1 1 1 1;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
	margin-bottom:.0001pt;
	text-align:justify;
	text-justify:inter-ideograph;
	font-size:10.5pt;
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
</o:shapelayout></xml><![endif]-->
</head>
<body lang=3D"ZH-CN" link=3D"blue" vlink=3D"purple" style=3D"text-justify-t=
rim:punctuation">
<div class=3D"WordSection1">
<p class=3D"MsoNormal"><span lang=3D"EN-US">In mpath_prout_reg, it&#8217;s =
perhaps more proper to modify active_pathcount to count which<o:p></o:p></s=
pan></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">is the actual thread counts cre=
ated, otherwise it may leads to a segmentfault error.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">---<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">libmpathpersist/mpath_persist.c=
 | 2 &#43;-<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">1 file changed, 1 insertion(&#4=
3;), 1 deletion(-)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">diff --git a/libmpathpersist/mp=
ath_persist.c b/libmpathpersist<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">index 7a2249f..8518a2e 100644<o=
:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">--- a/libmpathpersist/mpath_per=
sist.c<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&#43;&#43;&#43; b/libmpathpersi=
st/mpath_persist.c<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">@@ -503,7 &#43;503,7 @@ int mpa=
th_prout_reg(struct multipath *mpp,<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp; count =3D count &#43;1;<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
}<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp; }<o:p>=
</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">-&nbsp;&nbsp;&nbsp; for( i=3D0;=
 i &lt; active_pathcount ; i&#43;&#43;){<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&#43;&nbsp;&nbsp;&nbsp; for( i=
=3D0; i &lt; count ; i&#43;&#43;){<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
rc =3D pthread_join(thread[i].id, NULL);<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
if (rc){<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp; condlog (0, &quot;%s: Thread[%d] failed to join thread %d&quot;=
,<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">--<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">1.8.3.4<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
</div>
</body>
</html>

--_000_AF7C226D2A4F8B4D913D33FF7150AE051D6B21E9szxeml556mbschi_--


--===============8684496177341265221==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8684496177341265221==--
