From: Gerhard Wichert <Gerhard.Wichert@ts.fujitsu.com>
Subject: [PATCH] Update ETERNUS DX entry
Date: Mon, 09 Mar 2015 15:57:37 +0100
Message-ID: <44563972.MCcuCWMjxF@tabasco>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5366929027042260641=="
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
Cc: "Wilck, Martin" <Martin.Wilck@ts.fujitsu.com>, "Montag,
	Rainer" <Rainer.Montag@ts.fujitsu.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.

--===============5366929027042260641==
Content-Type: multipart/alternative; boundary="nextPart1562563.Li4glXt3aQ"
Content-Transfer-Encoding: 7Bit

This is a multi-part message in MIME format.

--nextPart1562563.Li4glXt3aQ
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Add DX8700 S3 and DX8900 S3

Signed-off-by: Gerhard Wichert <gerhard.wichert@ts.fujitsu.com>
---
 libmultipath/hwtable.c  | 2 +-
 multipath.conf.defaults | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)
diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index bf2c2ca..6de915b 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -308,7 +308,7 @@ static struct hwentry default_hw[] = {
        },
        {
                .vendor        = "FUJITSU",
-               .product       = "ETERNUS_DX(L|M|400|8000)",
+               .product       = "ETERNUS_DX(H|L|M|400|8000)",
                .features      = "1 queue_if_no_path",
                .hwhandler     = DEFAULT_HWHANDLER,
                .pgpolicy      = GROUP_BY_PRIO,
diff --git a/multipath.conf.defaults b/multipath.conf.defaults
index cf8cfdb..c5f12e8 100644
--- a/multipath.conf.defaults
+++ b/multipath.conf.defaults
@@ -285,7 +285,7 @@
 #      }
 #      device {
 #              vendor "FUJITSU"
-#              product "ETERNUS_DX(L|M|400|8000)"
+#              product "ETERNUS_DX(H|L|M|400|8000)"
 #              path_grouping_policy "group_by_prio"
 #              path_checker "tur"
 #              features "1 queue_if_no_path"


--nextPart1562563.Li4glXt3aQ
Content-Transfer-Encoding: 7Bit
Content-Type: text/html; charset="us-ascii"

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN" "http://www.w3.org/TR/REC-html40/strict.dtd">
<html><head><meta name="qrichtext" content="1" /><style type="text/css">
p, li { white-space: pre-wrap; }
</style></head><body style=" font-family:'Monospace'; font-size:9pt; font-weight:400; font-style:normal;">
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">Add DX8700 S3 and DX8900 S3</p>
<p style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; ">&nbsp;</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;"><span style=" font-family:'Courier New,courier'; font-size:medium; color:#000000;">Signed-off-by: Gerhard Wichert &lt;gerhard.wichert@ts.fujitsu.com&gt;</span></p>
<pre style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;"><span style=" font-family:'Courier New,courier'; font-size:medium; color:#000000;">---</span></pre>
<pre style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;"><span style=" font-family:'Courier New,courier'; font-size:medium; color:#000000;"> libmultipath/hwtable.c  | 2 +-</span></pre>
<pre style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;"><span style=" font-family:'Courier New,courier'; font-size:medium; color:#000000;"> multipath.conf.defaults | 2 +-</span></pre>
<pre style=" margin-top:0px; margin-bottom:12px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;"><span style=" font-family:'Courier New,courier'; font-size:medium; color:#000000;"> 2 files changed, 2 insertions(+), 2 deletions(-)</span></pre>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;">diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;">index bf2c2ca..6de915b 100644</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;">--- a/libmultipath/hwtable.c</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;">+++ b/libmultipath/hwtable.c</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;">@@ -308,7 +308,7 @@ static struct hwentry default_hw[] = {</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;">        },</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;">        {</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;">                .vendor        = &quot;FUJITSU&quot;,</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;">-               .product       = &quot;ETERNUS_DX(L|M|400|8000)&quot;,</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;">+               .product       = &quot;ETERNUS_DX(H|L|M|400|8000)&quot;,</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;">                .features      = &quot;1 queue_if_no_path&quot;,</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;">                .hwhandler     = DEFAULT_HWHANDLER,</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;">                .pgpolicy      = GROUP_BY_PRIO,</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;">diff --git a/multipath.conf.defaults b/multipath.conf.defaults</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;">index cf8cfdb..c5f12e8 100644</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;">--- a/multipath.conf.defaults</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;">+++ b/multipath.conf.defaults</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;">@@ -285,7 +285,7 @@</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;"> #      }</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;"> #      device {</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;"> #              vendor &quot;FUJITSU&quot;</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;">-#              product &quot;ETERNUS_DX(L|M|400|8000)&quot;</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;">+#              product &quot;ETERNUS_DX(H|L|M|400|8000)&quot;</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;"> #              path_grouping_policy &quot;group_by_prio&quot;</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;"> #              path_checker &quot;tur&quot;</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;"> #              features &quot;1 queue_if_no_path&quot;</p>
<p style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; ">&nbsp;</p></body></html>
--nextPart1562563.Li4glXt3aQ--


--===============5366929027042260641==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5366929027042260641==--
