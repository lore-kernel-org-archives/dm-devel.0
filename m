From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 2/4] multipath-tools: install libmultipath.so in
	$syslibdir
Date: Fri, 17 Apr 2009 18:07:58 -0400
Message-ID: <1240006080-27892-3-git-send-email-snitzer@redhat.com>
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

Allows libmultipath.so to be installed in the proper lib dir
(e.g. /lib64).  $libdir is already used for /lib/multipath

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 Makefile.inc          |    1 +
 libmultipath/Makefile |    6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/Makefile.inc b/Makefile.inc
index 3e5bca0..1fe9782 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -21,6 +21,7 @@ multipathdir = $(TOPDIR)/libmultipath
 mandir      = $(prefix)/usr/share/man/man8
 man5dir     = $(prefix)/usr/share/man/man5
 rcdir	    = $(prefix)/etc/init.d
+syslibdir   = $(prefix)/lib
 libdir	    = $(prefix)/lib/multipath
 
 GZIP        = /bin/gzip -9 -c
diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index 35cb911..503223d 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -26,12 +26,12 @@ $(LIBS): $(OBJS)
 	$(CC) $(SHARED_FLAGS) -Wl,-soname,$@ $(CFLAGS) -o $@ $(OBJS)
 
 install:
-	$(INSTALL_PROGRAM) -d $(DESTDIR)$(prefix)/lib
-	$(INSTALL_PROGRAM) -m 755 $(LIBS) $(DESTDIR)$(prefix)/lib/$(LIBS)
+	$(INSTALL_PROGRAM) -d $(DESTDIR)$(syslibdir)
+	$(INSTALL_PROGRAM) -m 755 $(LIBS) $(DESTDIR)$(syslibdir)/$(LIBS)
 	$(INSTALL_PROGRAM) -m 755 -d $(DESTDIR)$(libdir)
 
 uninstall:
-	rm -f $(DESTDIR)$(prefix)/lib/$(LIBS)
+	rm -f $(DESTDIR)$(syslibdir)/$(LIBS)
 
 clean:
 	rm -f core *.a *.o *.gz *.so
-- 
1.6.0.6
