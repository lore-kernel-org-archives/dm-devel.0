From: "Krishnasamy, Somasundaram" <Somasundaram.Krishnasamy@netapp.com>
Subject: [PATCH] dm-cache mq policy fast warmup
Date: Tue, 26 Nov 2013 17:09:30 +0000
Message-ID: <9BDA3ECEC2A5454BB4294114677019E131B825E0@SACEXCMBX02-PRD.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8366370869917187438=="
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
To: "device-mapper development (dm-devel@redhat.com)" <dm-devel@redhat.com>
Cc: "Mears, Morgan" <Morgan.Mears@netapp.com>
List-Id: dm-devel.ids

--===============8366370869917187438==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_9BDA3ECEC2A5454BB4294114677019E131B825E0SACEXCMBX02PRDh_"

--_000_9BDA3ECEC2A5454BB4294114677019E131B825E0SACEXCMBX02PRDh_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

dm-cache mq policy: Fast warm-up

The multiqueue policy promotes a block only after promote_threshold + 4 (RE=
AD_PROMOTE_THRESHOLD) times hit on read I/O. It will be useful if the polic=
y promotes the block during its first reference in the following use cases.

1. Storage array has information about which blocks are heavily used and ca=
n pass it to server for warming up the cache. (A process running in the ser=
ver can simply read those blocks when device is idle).
2. Database Application or workload capture tool knows where the hot data i=
s and can promote them before it's actual use.
3. To replace a cache device

The below patch will allow a block to get promoted during its first referen=
ce only if requested by user via dmsetup message. It can be changed to allo=
w based on particular process or process group also.

Signed-off-by: Somasundaram, Krishnasamy <Somasundaram.Krishnasamy@netapp.c=
om>
Reviewed-by: Yanling, Qi <Yanling.Qi@netapp.com>
---
diff --git a/drivers/md/dm-cache-policy-mq.c b/drivers/md/dm-cache-policy-m=
q.c
index 7f1aaa3..9653a3c 100644
--- a/drivers/md/dm-cache-policy-mq.c
+++ b/drivers/md/dm-cache-policy-mq.c
@@ -390,6 +390,10 @@ struct mq_policy {
     */
    unsigned promote_threshold;
+    /* Allow the blocks to be promoted during first reference itself
+    */
+    unsigned cachefill_enabled;
+
    /*
     * The hash table allows us to quickly find an entry by origin
     * block.  Both pre_cache and cache entries are in here.
@@ -648,6 +652,9 @@ static int demote_cblock(struct mq_policy *mq, dm_obloc=
k_t *oblock)
static unsigned adjusted_promote_threshold(struct mq_policy *mq,
                             bool discarded_oblock, int data_dir)
{
+    if (mq->cachefill_enabled)
+          return 1;
+
    if (data_dir =3D=3D READ)
          return mq->promote_threshold + READ_PROMOTE_THRESHOLD;
@@ -835,7 +842,8 @@ static int map(struct mq_policy *mq, dm_oblock_t oblock=
,
    if (e && in_cache(mq, e))
          r =3D cache_entry_found(mq, e, result);
-    else if (iot_pattern(&mq->tracker) =3D=3D PATTERN_SEQUENTIAL)
+    else if (iot_pattern(&mq->tracker) =3D=3D PATTERN_SEQUENTIAL &&
+          !mq->cachefill_enabled)
          result->op =3D POLICY_MISS;
     else if (e)
@@ -1134,21 +1142,22 @@ static int mq_set_config_value(struct dm_cache_poli=
cy *p,
                      const char *key, const char *value)
{
    struct mq_policy *mq =3D to_mq_policy(p);
-    enum io_pattern pattern;
    unsigned long tmp;
+    if (kstrtoul(value, 10, &tmp))
+          return -EINVAL;
+
    if (!strcasecmp(key, "random_threshold"))
-          pattern =3D PATTERN_RANDOM;
+          mq->tracker.thresholds[PATTERN_RANDOM] =3D tmp;
    else if (!strcasecmp(key, "sequential_threshold"))
-          pattern =3D PATTERN_SEQUENTIAL;
+          mq->tracker.thresholds[PATTERN_SEQUENTIAL] =3D tmp;
+    else if (!strcasecmp(key, "enable_cachefill"))
+          mq->cachefill_enabled =3D true;
+    else if (!strcasecmp(key, "disable_cachefill"))
+          mq->cachefill_enabled =3D false;
    else
          return -EINVAL;
-    if (kstrtoul(value, 10, &tmp))
-          return -EINVAL;
-
-    mq->tracker.thresholds[pattern] =3D tmp;
-
    return 0;
}
@@ -1212,6 +1221,7 @@ static struct dm_cache_policy *mq_create(dm_cblock_t =
cache_size,
    mq->hit_count =3D 0;
    mq->generation =3D 0;
    mq->promote_threshold =3D 0;
+    mq->cachefill_enabled =3D 0;
    mutex_init(&mq->lock);
    spin_lock_init(&mq->tick_lock);



--_000_9BDA3ECEC2A5454BB4294114677019E131B825E0SACEXCMBX02PRDh_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<meta name=3D"Generator" content=3D"Microsoft Word 14 (filtered medium)">
<style><!--
/* Font Definitions */
@font-face
	{font-family:Latha;
	panose-1:2 11 6 4 2 2 2 2 2 4;}
@font-face
	{font-family:Latha;
	panose-1:2 11 6 4 2 2 2 2 2 4;}
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
span.EmailStyle18
	{mso-style-type:personal;
	font-family:"Calibri","sans-serif";
	color:windowtext;}
span.EmailStyle19
	{mso-style-type:personal-reply;
	font-family:"Calibri","sans-serif";
	color:#1F497D;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-size:10.0pt;}
@page WordSection1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
	{page:WordSection1;}
/* List Definitions */
@list l0
	{mso-list-id:1310094623;
	mso-list-type:hybrid;
	mso-list-template-ids:-1533487654 67698703 67698713 67698715 67698703 6769=
8713 67698715 67698703 67698713 67698715;}
@list l0:level1
	{mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;}
@list l0:level2
	{mso-level-number-format:alpha-lower;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;}
@list l0:level3
	{mso-level-number-format:roman-lower;
	mso-level-tab-stop:none;
	mso-level-number-position:right;
	text-indent:-9.0pt;}
@list l0:level4
	{mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;}
@list l0:level5
	{mso-level-number-format:alpha-lower;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;}
@list l0:level6
	{mso-level-number-format:roman-lower;
	mso-level-tab-stop:none;
	mso-level-number-position:right;
	text-indent:-9.0pt;}
@list l0:level7
	{mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;}
@list l0:level8
	{mso-level-number-format:alpha-lower;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;}
@list l0:level9
	{mso-level-number-format:roman-lower;
	mso-level-tab-stop:none;
	mso-level-number-position:right;
	text-indent:-9.0pt;}
ol
	{margin-bottom:0in;}
ul
	{margin-bottom:0in;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]-->
</head>
<body lang=3D"EN-US" link=3D"blue" vlink=3D"purple">
<div class=3D"WordSection1">
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">dm-cache mq policy: Fast warm-up<o:p></o:p></=
span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">The multiqueue policy promotes a block only a=
fter promote_threshold &#43; 4 (READ_PROMOTE_THRESHOLD) times hit on read I=
/O. It will be useful if the policy promotes the block
 during its first reference in the following use cases.<o:p></o:p></span></=
p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">1. Storage array has information about which =
blocks are heavily used and can pass it to server for warming up the cache.=
 (A process running in the server can simply read
 those blocks when device is idle).<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">2. Database Application or workload capture t=
ool knows where the hot data is and can promote them before it&#8217;s actu=
al use.<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">3. To replace a cache device<o:p></o:p></span=
></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">The below patch will allow a block to get pro=
moted during its first reference only if requested by user via dmsetup mess=
age. It can be changed to allow based on particular
 process or process group also.<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">Signed-off-by: Somasundaram, Krishnasamy &lt;=
Somasundaram.Krishnasamy@netapp.com&gt;<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">Reviewed-by: Yanling, Qi &lt;Yanling.Qi@netap=
p.com&gt;<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">---<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">diff --git a/drivers/md/dm-cache-policy-mq.c =
b/drivers/md/dm-cache-policy-mq.c<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">index 7f1aaa3..9653a3c 100644<o:p></o:p></spa=
n></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">--- a/drivers/md/dm-cache-policy-mq.c<o:p></o=
:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">&#43;&#43;&#43; b/drivers/md/dm-cache-policy-=
mq.c<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">@@ -390,6 &#43;390,10 @@ struct mq_policy {<o=
:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">&nbsp;&nbsp;&nbsp; &nbsp;*/<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">&nbsp;&nbsp;&nbsp; unsigned promote_threshold=
;<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;"><o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">&#43;&nbsp;&nbsp;&nbsp; /* Allow the blocks t=
o be promoted during first reference itself<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">&#43;&nbsp;&nbsp;&nbsp; */<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">&#43;&nbsp;&nbsp;&nbsp; unsigned cachefill_en=
abled;<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">&#43;<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">&nbsp;&nbsp;&nbsp; /*<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">&nbsp;&nbsp;&nbsp; &nbsp;* The hash table all=
ows us to quickly find an entry by origin<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">&nbsp;&nbsp;&nbsp; &nbsp;* block.&nbsp; Both =
pre_cache and cache entries are in here.<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">@@ -648,6 &#43;652,9 @@ static int demote_cbl=
ock(struct mq_policy *mq, dm_oblock_t *oblock)<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">static unsigned adjusted_promote_threshold(st=
ruct mq_policy *mq,<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;bool discarded_oblock, int=
 data_dir)<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">{<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">&#43;&nbsp;&nbsp;&nbsp; if (mq-&gt;cachefill_=
enabled)<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp; return 1;<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">&#43;<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">&nbsp;&nbsp;&nbsp; if (data_dir =3D=3D READ)<=
o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp; return mq-&gt;promote_threshold &#43; READ_PROMOTE_THRESHOLD;<o:p=
></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;"><o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">@@ -835,7 &#43;842,8 @@ static int map(struct=
 mq_policy *mq, dm_oblock_t oblock,<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">&nbsp;&nbsp;&nbsp; if (e &amp;&amp; in_cache(=
mq, e))<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp; r =3D cache_entry_found(mq, e, result);<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;"><o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">-&nbsp;&nbsp;&nbsp; else if (iot_pattern(&amp=
;mq-&gt;tracker) =3D=3D PATTERN_SEQUENTIAL)<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">&#43;&nbsp;&nbsp;&nbsp; else if (iot_pattern(=
&amp;mq-&gt;tracker) =3D=3D PATTERN_SEQUENTIAL &amp;&amp;<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp; !mq-&gt;cachefill_enabled)<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp; result-&gt;op =3D POLICY_MISS;<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;"><o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">&nbsp;&nbsp;&nbsp;&nbsp; else if (e)<o:p></o:=
p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">@@ -1134,21 &#43;1142,22 @@ static int mq_set=
_config_value(struct dm_cache_policy *p,<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;const char *key, const char *value)<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">{<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">&nbsp;&nbsp;&nbsp; struct mq_policy *mq =3D t=
o_mq_policy(p);<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">-&nbsp;&nbsp;&nbsp; enum io_pattern pattern;<=
o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">&nbsp;&nbsp;&nbsp; unsigned long tmp;<o:p></o=
:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;"><o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">&#43;&nbsp;&nbsp;&nbsp; if (kstrtoul(value, 1=
0, &amp;tmp))<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp; return -EINVAL;<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">&#43;<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">&nbsp;&nbsp;&nbsp; if (!strcasecmp(key, &quot=
;random_threshold&quot;))<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; pattern =3D PATTERN_RANDOM;<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp; mq-&gt;tracker.thresholds[PATTERN_RANDOM] =3D tmp;<o:p></o:p=
></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">&nbsp;&nbsp;&nbsp; else if (!strcasecmp(key, =
&quot;sequential_threshold&quot;))<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; pattern =3D PATTERN_SEQUENTIAL;<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp; mq-&gt;tracker.thresholds[PATTERN_SEQUENTIAL] =3D tmp;<o:p><=
/o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">&#43;&nbsp;&nbsp;&nbsp; else if (!strcasecmp(=
key, &quot;enable_cachefill&quot;))<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp; mq-&gt;cachefill_enabled =3D true;<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">&#43;&nbsp;&nbsp;&nbsp; else if (!strcasecmp(=
key, &quot;disable_cachefill&quot;))<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">&#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp; mq-&gt;cachefill_enabled =3D false;<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">&nbsp;&nbsp;&nbsp; else<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp; return -EINVAL;<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;"><o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">-&nbsp;&nbsp;&nbsp; if (kstrtoul(value, 10, &=
amp;tmp))<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; return -EINVAL;<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">-<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">-&nbsp;&nbsp;&nbsp; mq-&gt;tracker.thresholds=
[pattern] =3D tmp;<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">-<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">&nbsp;&nbsp;&nbsp; return 0;<o:p></o:p></span=
></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">}<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;"><o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">@@ -1212,6 &#43;1221,7 @@ static struct dm_ca=
che_policy *mq_create(dm_cblock_t cache_size,<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">&nbsp;&nbsp;&nbsp; mq-&gt;hit_count =3D 0;<o:=
p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">&nbsp;&nbsp;&nbsp; mq-&gt;generation =3D 0;<o=
:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">&nbsp;&nbsp;&nbsp; mq-&gt;promote_threshold =
=3D 0;<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">&#43;&nbsp;&nbsp;&nbsp; mq-&gt;cachefill_enab=
led =3D 0;<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">&nbsp;&nbsp;&nbsp; mutex_init(&amp;mq-&gt;loc=
k);<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;">&nbsp;&nbsp;&nbsp; spin_lock_init(&amp;mq-&gt=
;tick_lock);<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;"><o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-autospace:none"><span style=3D"font-fa=
mily:&quot;Courier New&quot;"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D"><o:p>&nbsp;</o:p></spa=
n></p>
</div>
</body>
</html>

--_000_9BDA3ECEC2A5454BB4294114677019E131B825E0SACEXCMBX02PRDh_--


--===============8366370869917187438==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8366370869917187438==--
