From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 4/5] multipath-tools: don't create /etc/init.d
	from make install
Date: Thu, 30 Jun 2016 15:42:15 +0200
Message-ID: <1467294136-19275-5-git-send-email-xose.vazquez@gmail.com>
References: <1467294136-19275-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1467294136-19275-1-git-send-email-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

sysv scripts were deleted time ago.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 Makefile.inc        | 1 -
 multipathd/Makefile | 2 --
 2 files changed, 3 deletions(-)

diff --git a/Makefile.inc b/Makefile.inc
index c4bea67..7adeb46 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -48,7 +48,6 @@ multipathdir = $(TOPDIR)/libmultipath
 mandir      = $(prefix)/usr/share/man/man8
 man5dir     = $(prefix)/usr/share/man/man5
 man3dir      = $(prefix)/usr/share/man/man3
-rcdir	    = $(prefix)/etc/init.d
 syslibdir   = $(prefix)/$(LIB)
 incdir      = $(prefix)/usr/include
 libdir	    = $(prefix)/$(LIB)/multipath
diff --git a/multipathd/Makefile b/multipathd/Makefile
index 9b0210f..7fb1d3f 100644
--- a/multipathd/Makefile
+++ b/multipathd/Makefile
@@ -46,7 +46,6 @@ $(EXEC): $(OBJS)
 install:
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(bindir)
 	$(INSTALL_PROGRAM) -m 755 $(EXEC) $(DESTDIR)$(bindir)
-	$(INSTALL_PROGRAM) -d $(DESTDIR)$(rcdir)
 ifdef SYSTEMD
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(unitdir)
 	$(INSTALL_PROGRAM) -m 644 $(EXEC).service $(DESTDIR)$(unitdir)
@@ -57,7 +56,6 @@ endif
 
 uninstall:
 	rm -f $(DESTDIR)$(bindir)/$(EXEC)
-	rm -f $(DESTDIR)$(rcdir)/$(EXEC)
 	rm -f $(DESTDIR)$(mandir)/$(EXEC).8.gz
 	rm -f $(DESTDIR)$(unitdir)/$(EXEC).service
 	rm -f $(DESTDIR)$(unitdir)/$(EXEC).socket
-- 
2.7.4
