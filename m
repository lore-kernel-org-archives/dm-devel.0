From: zhang.kai16@zte.com.cn
Subject: [PATCH] multipathd: fix waiter_attr resource leak
Date: Wed, 6 Jul 2016 16:08:04 +0800
Message-ID: <OF23BCA109.0BE2FFED-ON48257FE8.0023BAD2-48257FE8.002CA989@zte.com.cn>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6178219320604636123=="
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
To: christophe varoqui <christophe.varoqui@free.fr>
Cc: dm-devel@redhat.com, tang.junhui@zte.com.cn
List-Id: dm-devel.ids

This is a multipart message in MIME format.

--===============6178219320604636123==
Content-Type: multipart/alternative;
	boundary="=_alternative 002CA98148257FE8_="

This is a multipart message in MIME format.

--=_alternative 002CA98148257FE8_=
Content-Type: text/plain; charset="US-ASCII"

As a global variable waiter_attr of thread attribute was set up in the 
daemon, 
however,it hasn't been destroyed when the daemon exited.
We need deinitialize waiter_attr.
 

---
 multipathd/main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/multipathd/main.c b/multipathd/main.c
index b86374f..09c5485 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2317,6 +2317,9 @@ child (void * param)
                 conf = NULL;
                 udev_unref(udev);
                 udev = NULL;
+
+                pthread_attr_destroy(&waiter_attr);
+
 #ifdef _DEBUG_
                 dbg_free_final(NULL);
 #endif
-- 
1.9.1


--------------------------------------------------------
ZTE Information Security Notice: The information contained in this mail (and any attachment transmitted herewith) is privileged and confidential and is intended for the exclusive use of the addressee(s).  If you are not an intended recipient, any disclosure, reproduction, distribution or other dissemination or use of the information contained is strictly prohibited.  If you have received this mail in error, please delete it and notify us immediately.

--=_alternative 002CA98148257FE8_=
Content-Type: text/html; charset="US-ASCII"

<font size=2 face="sans-serif">As a global variable waiter_attr of thread
attribute was set up in the daemon, </font>
<br><font size=2 face="sans-serif">however,it hasn't been destroyed when
the daemon exited.</font>
<br><font size=2 face="sans-serif">We need deinitialize waiter_attr.</font>
<br><font size=2 face="sans-serif">&nbsp;<br>
</font>
<br><tt><font size=2>---<br>
 multipathd/main.c | 3 +++<br>
 1 file changed, 3 insertions(+)<br>
<br>
diff --git a/multipathd/main.c b/multipathd/main.c<br>
index b86374f..09c5485 100644<br>
--- a/multipathd/main.c<br>
+++ b/multipathd/main.c<br>
@@ -2317,6 +2317,9 @@ child (void * param)<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;conf
= NULL;<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;udev_unref(udev);<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;udev
= NULL;<br>
+<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
pthread_attr_destroy(&amp;waiter_attr);<br>
+<br>
 #ifdef _DEBUG_<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;dbg_free_final(NULL);<br>
 #endif<br>
-- <br>
1.9.1<br>
</font></tt>
<br>
<br>

<br><pre><font color="blue">
--------------------------------------------------------
ZTE Information Security Notice: The information contained in this mail (and any attachment transmitted herewith) is privileged and confidential and is intended for the exclusive use of the addressee(s).  If you are not an intended recipient, any disclosure, reproduction, distribution or other dissemination or use of the information contained is strictly prohibited.  If you have received this mail in error, please delete it and notify us immediately.

</font></pre><br>

--=_alternative 002CA98148257FE8_=--


--===============6178219320604636123==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6178219320604636123==--
