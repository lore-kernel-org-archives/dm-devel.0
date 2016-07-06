From: zhang.kai16@zte.com.cn
Subject: [PATCH] multipah: fix 'multipath -p' with invalid policy
Date: Wed, 6 Jul 2016 14:21:03 +0800
Message-ID: <OFEF0477A6.E2A8E55E-ON48257FE8.001271D0-48257FE8.0022DD1A@zte.com.cn>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3881452989287310480=="
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

--===============3881452989287310480==
Content-Type: multipart/alternative;
	boundary="=_alternative 0022DD0F48257FE8_="

This is a multipart message in MIME format.

--=_alternative 0022DD0F48257FE8_=
Content-Type: text/plain; charset="US-ASCII"

hi,

When we excute 'multipath -p' with invalid policy, get_pgpolicy_id() 
returns IOPOLICY_UNDEF. 
We should compare conf->pgpolicy_flag with IOPOLICY_UNDEF, otherwise, it 
couldn't get what we want.


 ---
 multipath/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipath/main.c b/multipath/main.c
index c33f689..af7cf5b 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -532,7 +532,7 @@ main (int argc, char *argv[])
                                                 break;
                                 case 'p':
                                                 conf->pgpolicy_flag = 
get_pgpolicy_id(optarg);
-                                                if (conf->pgpolicy_flag 
== -1) {
+                                                if (conf->pgpolicy_flag 
== IOPOLICY_UNDEF) {
 printf("'%s' is not a valid policy\n", optarg);
 usage(argv[0]);
                                                                 exit(1);
-- 
1.9.1


--------------------------------------------------------
ZTE Information Security Notice: The information contained in this mail (and any attachment transmitted herewith) is privileged and confidential and is intended for the exclusive use of the addressee(s).  If you are not an intended recipient, any disclosure, reproduction, distribution or other dissemination or use of the information contained is strictly prohibited.  If you have received this mail in error, please delete it and notify us immediately.

--=_alternative 0022DD0F48257FE8_=
Content-Type: text/html; charset="US-ASCII"

<font size=2 face="sans-serif">hi,</font>
<br>
<br><font size=2 face="sans-serif">When we excute 'multipath -p' with invalid
policy, get_pgpolicy_id() returns IOPOLICY_UNDEF. </font>
<br><font size=2 face="sans-serif">We should compare conf-&gt;pgpolicy_flag
with IOPOLICY_UNDEF, otherwise, it couldn't get what we want.</font>
<br><font size=2 face="sans-serif"><br>
</font>
<br><font size=2>&nbsp;</font><tt><font size=2>---<br>
 multipath/main.c | 2 +-<br>
 1 file changed, 1 insertion(+), 1 deletion(-)<br>
<br>
diff --git a/multipath/main.c b/multipath/main.c<br>
index c33f689..af7cf5b 100644<br>
--- a/multipath/main.c<br>
+++ b/multipath/main.c<br>
@@ -532,7 +532,7 @@ main (int argc, char *argv[])<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;break;<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
case 'p':<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;conf-&gt;pgpolicy_flag
= get_pgpolicy_id(optarg);<br>
- &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
if (conf-&gt;pgpolicy_flag == -1) {<br>
+ &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
if (conf-&gt;pgpolicy_flag == IOPOLICY_UNDEF) {<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
printf(&quot;'%s' is not a valid policy\n&quot;, optarg);<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
usage(argv[0]);<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
exit(1);<br>
-- <br>
1.9.1</font></tt><tt><font size=3><br>
</font></tt>
<br>
<br>

<br><pre><font color="blue">
--------------------------------------------------------
ZTE Information Security Notice: The information contained in this mail (and any attachment transmitted herewith) is privileged and confidential and is intended for the exclusive use of the addressee(s).  If you are not an intended recipient, any disclosure, reproduction, distribution or other dissemination or use of the information contained is strictly prohibited.  If you have received this mail in error, please delete it and notify us immediately.

</font></pre><br>

--=_alternative 0022DD0F48257FE8_=--


--===============3881452989287310480==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3881452989287310480==--
