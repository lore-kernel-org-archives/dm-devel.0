From: zhang.kai16@zte.com.cn
Subject: [PATCH] readsector0: the length of the buffer wrong
Date: Tue, 5 Jul 2016 19:48:53 +0800
Message-ID: <OF3CB78F61.50E78D53-ON48257FE7.003E97A1-48257FE7.0040E0D4@zte.com.cn>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3239315580493976285=="
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
To: christophe varoqui <christophe.varoqui@free.fr>, Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com, tang.junhui@zte.com.cn
List-Id: dm-devel.ids

This is a multipart message in MIME format.

--===============3239315580493976285==
Content-Type: multipart/alternative;
	boundary="=_alternative 0040E0CF48257FE7_="

This is a multipart message in MIME format.

--=_alternative 0040E0CF48257FE7_=
Content-Type: text/plain; charset="US-ASCII"

hi,

The length of the buffer is 4096, not 4069 in sg_read().
 
---
 libmultipath/checkers/readsector0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/checkers/readsector0.c 
b/libmultipath/checkers/readsector0.c
index 0550fb6..1c2a868 100644
--- a/libmultipath/checkers/readsector0.c
+++ b/libmultipath/checkers/readsector0.c
@@ -29,7 +29,7 @@ int libcheck_check (struct checker * c)
                 unsigned char sbuf[SENSE_BUFF_LEN];
                 int ret;
 
-                ret = sg_read(c->fd, &buf[0], 4069, &sbuf[0],
+                ret = sg_read(c->fd, &buf[0], 4096, &sbuf[0],
                                       SENSE_BUFF_LEN, c->timeout);
 
                 switch (ret)
-- 
1.9.1

--------------------------------------------------------
ZTE Information Security Notice: The information contained in this mail (and any attachment transmitted herewith) is privileged and confidential and is intended for the exclusive use of the addressee(s).  If you are not an intended recipient, any disclosure, reproduction, distribution or other dissemination or use of the information contained is strictly prohibited.  If you have received this mail in error, please delete it and notify us immediately.

--=_alternative 0040E0CF48257FE7_=
Content-Type: text/html; charset="US-ASCII"

<font size=2 face="sans-serif">hi,</font>
<br>
<br><font size=2 face="sans-serif">The length of the buffer is 4096, not
4069 in sg_read().</font>
<br><font size=3>&nbsp;</font>
<br><tt><font size=2>---<br>
 libmultipath/checkers/readsector0.c | 2 +-<br>
 1 file changed, 1 insertion(+), 1 deletion(-)<br>
<br>
diff --git a/libmultipath/checkers/readsector0.c b/libmultipath/checkers/readsector0.c<br>
index 0550fb6..1c2a868 100644<br>
--- a/libmultipath/checkers/readsector0.c<br>
+++ b/libmultipath/checkers/readsector0.c<br>
@@ -29,7 +29,7 @@ int libcheck_check (struct checker * c)<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;unsigned
char sbuf[SENSE_BUFF_LEN];<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;int
ret;<br>
 <br>
- &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
ret = sg_read(c-&gt;fd, &amp;buf[0], 4069, &amp;sbuf[0],<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
ret = sg_read(c-&gt;fd, &amp;buf[0], 4096, &amp;sbuf[0],<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; SENSE_BUFF_LEN, c-&gt;timeout);<br>
 <br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;switch
(ret)<br>
-- <br>
1.9.1</font></tt><tt><font size=3><br>
</font></tt>
<br>

<br><pre><font color="blue">
--------------------------------------------------------
ZTE Information Security Notice: The information contained in this mail (and any attachment transmitted herewith) is privileged and confidential and is intended for the exclusive use of the addressee(s).  If you are not an intended recipient, any disclosure, reproduction, distribution or other dissemination or use of the information contained is strictly prohibited.  If you have received this mail in error, please delete it and notify us immediately.

</font></pre><br>

--=_alternative 0040E0CF48257FE7_=--


--===============3239315580493976285==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3239315580493976285==--
