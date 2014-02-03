From: Bgs <bgs@bgs.hu>
Subject: Patch for readline undefined references
Date: Mon, 03 Feb 2014 10:23:42 +0100
Message-ID: <52EF601E.3070508@bgs.hu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070403000202080802040509"
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
To: christophe.varoqui@opensvc.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------070403000202080802040509
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


  Hello Christophe,

On some systems with libtermcap, readline produces undefined references 
for some functions.

For example on my Slackware laptop:

/usr/lib64/gcc/x86_64-slackware-linux/4.8.1/../../../../lib64/libreadline.so: 
undefined reference to `tputs'
/usr/lib64/gcc/x86_64-slackware-linux/4.8.1/../../../../lib64/libreadline.so: 
undefined reference to `tgoto'
/usr/lib64/gcc/x86_64-slackware-linux/4.8.1/../../../../lib64/libreadline.so: 
undefined reference to `tgetflag'
/usr/lib64/gcc/x86_64-slackware-linux/4.8.1/../../../../lib64/libreadline.so: 
undefined reference to `UP'
/usr/lib64/gcc/x86_64-slackware-linux/4.8.1/../../../../lib64/libreadline.so: 
undefined reference to `tgetent'
/usr/lib64/gcc/x86_64-slackware-linux/4.8.1/../../../../lib64/libreadline.so: 
undefined reference to `tgetnum'
/usr/lib64/gcc/x86_64-slackware-linux/4.8.1/../../../../lib64/libreadline.so: 
undefined reference to `PC'
/usr/lib64/gcc/x86_64-slackware-linux/4.8.1/../../../../lib64/libreadline.so: 
undefined reference to `tgetstr'
/usr/lib64/gcc/x86_64-slackware-linux/4.8.1/../../../../lib64/libreadline.so: 
undefined reference to `BC'

This is not a common problem, but it does show up on some systems.

The attached patch is a very simple solution. Addig libtermcap to the ld 
flags solves the issue.

I'm not sure how it should be included (or not), but even if it's not, 
it would be worth putting the info and patch on the web page.

Best regards
Zoltan Posfai


--------------070403000202080802040509
Content-Type: text/x-patch;
 name="multipath-tools-termcap-Bgs.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="multipath-tools-termcap-Bgs.patch"

diff --git a/kpartx/Makefile b/kpartx/Makefile
index 4ba38ba..c95037f 100644
--- a/kpartx/Makefile
+++ b/kpartx/Makefile
@@ -12,7 +12,7 @@ ifneq ($(strip $(LIBDM_API_COOKIE)),0)
 	CFLAGS += -DLIBDM_API_COOKIE
 endif
 
-LDFLAGS = -ldevmapper
+LDFLAGS = -ldevmapper -ltermcap
 OBJS = bsd.o dos.o kpartx.o solaris.o unixware.o dasd.o sun.o \
        gpt.o mac.o ps3.o crc32.o lopart.o xstrncpy.o devmapper.o
 EXEC = kpartx
diff --git a/multipath/Makefile b/multipath/Makefile
index 5e5958d..22d847a 100644
--- a/multipath/Makefile
+++ b/multipath/Makefile
@@ -7,7 +7,7 @@ include ../Makefile.inc
 OBJS = main.o
 
 CFLAGS += -I$(multipathdir)
-LDFLAGS += -lpthread -ldevmapper -ldl -L$(multipathdir) -lmultipath -ludev
+LDFLAGS += -lpthread -ldevmapper -ldl -L$(multipathdir) -lmultipath -ludev -ltermcap
 
 EXEC = multipath
 
diff --git a/multipathd/Makefile b/multipathd/Makefile
index 781122a..ba892da 100644
--- a/multipathd/Makefile
+++ b/multipathd/Makefile
@@ -9,7 +9,7 @@ CFLAGS += -I$(multipathdir) -I$(mpathpersistdir)
 ifdef SYSTEMD
 	CFLAGS += -DUSE_SYSTEMD=$(SYSTEMD)
 endif
-LDFLAGS += -lpthread -ldevmapper -lreadline
+LDFLAGS += -lpthread -ldevmapper -lreadline -ltermcap
 ifdef SYSTEMD
 	LDFLAGS += -lsystemd-daemon
 endif

--------------070403000202080802040509
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------070403000202080802040509--
