From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4/4] multipath-tools: change default location for
	bindings file
Date: Fri, 17 Apr 2009 18:08:00 -0400
Message-ID: <1240006080-27892-5-git-send-email-snitzer@redhat.com>
References: <1240006080-27892-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1240006080-27892-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Change from /var/lib/multipath/bindings to /etc/multipath/bindings.  On
bootup, if /var is not on the same device as /, multipath may start up
before /var is mounted.  /etc will always be available.  Use of
/etc/multipath/ is to make selinux happy.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 libmultipath/defaults.h |    2 +-
 multipath/Makefile      |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index d7f93cb..4bd0a8b 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -18,6 +18,6 @@
 #define DEFAULT_PIDFILE		"/var/run/multipathd.pid"
 #define DEFAULT_SOCKET		"/var/run/multipathd.sock"
 #define DEFAULT_CONFIGFILE	"/etc/multipath.conf"
-#define DEFAULT_BINDINGS_FILE	"/var/lib/multipath/bindings"
+#define DEFAULT_BINDINGS_FILE	"/etc/multipath/bindings"
 
 char * set_default (char * str);
diff --git a/multipath/Makefile b/multipath/Makefile
index e0031a2..1f48a8f 100644
--- a/multipath/Makefile
+++ b/multipath/Makefile
@@ -27,6 +27,7 @@ install:
 	$(INSTALL_PROGRAM) -m 644 $(EXEC).8.gz $(DESTDIR)$(mandir)
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(man5dir)
 	$(INSTALL_PROGRAM) -m 644 $(EXEC).conf.5.gz $(DESTDIR)$(man5dir)
+	$(INSTALL_PROGRAM) -d $(DESTDIR)/etc/multipath
 
 uninstall:
 	rm $(DESTDIR)/etc/udev/rules.d/multipath.rules
-- 
1.6.0.6
