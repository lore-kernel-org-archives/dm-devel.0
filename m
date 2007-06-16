From: Guido Guenther <agx@sigxcpu.org>
Subject: [multipath 2/3] move kpartx_id to /lib/udev
Date: Sat, 16 Jun 2007 20:07:15 +0200
Message-ID: <11820172372216-git-send-email-agx@sigxcpu.org>
References: <11820172361537-git-send-email-agx@sigxcpu.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <11820172361537-git-send-email-agx@sigxcpu.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@free.fr>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

diff --git a/Makefile.inc b/Makefile.inc
index 7eb3dfb..6a9dcc1 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -22,6 +22,7 @@ endif
 prefix      = 
 exec_prefix = $(prefix)
 bindir      = $(exec_prefix)/sbin
+libudevdir  = ${prefix}/lib/udev
 checkersdir = $(TOPDIR)/libcheckers
 multipathdir = $(TOPDIR)/libmultipath
 mandir      = $(prefix)/usr/share/man/man8
diff --git a/kpartx/Makefile b/kpartx/Makefile
index f829055..082d15f 100644
--- a/kpartx/Makefile
+++ b/kpartx/Makefile
@@ -39,7 +39,8 @@ $(MULTIPATHLIB)-$(BUILD).a:
 install: $(EXEC) $(EXEC).8
 	install -d $(DESTDIR)$(bindir)
 	install -s -m 755 $(EXEC) $(DESTDIR)$(bindir)
-	install -m 755 kpartx_id $(DESTDIR)$(bindir)
+	install -d $(DESTDIR)$(libudevdir)
+	install -m 755 kpartx_id $(DESTDIR)$(libudevdir)
 	install -d $(DESTDIR)/etc/udev/rules.d
 	install -m 644 kpartx.rules $(DESTDIR)/etc/udev/rules.d/
 	install -d $(DESTDIR)$(mandir)
diff --git a/kpartx/kpartx.rules b/kpartx/kpartx.rules
index 9bd7db7..f32c718 100644
--- a/kpartx/kpartx.rules
+++ b/kpartx/kpartx.rules
@@ -9,7 +9,7 @@ ACTION=="remove", GOTO="kpartx_end"
 
 ENV{DM_TABLE_STATE}!="LIVE", GOTO="kpartx_end"
 
-ENV{DM_UUID}=="?*", IMPORT{program}=="/sbin/kpartx_id %M %m $env{DM_UUID}"
+ENV{DM_UUID}=="?*", IMPORT{program}=="/lib/udev/kpartx_id %M %m $env{DM_UUID}"
 
 OPTIONS="link_priority=50"
 
-- 
1.5.2.1
