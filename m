From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 2/21] [kpartx] fix install target
Date: Mon, 21 May 2007 11:23:18 +0200
Message-ID: <20070521092318.3FCB8D44CB@pentland.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <cvaroqui@free.fr>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


The install target should refer the executable, otherwise it'll trigger
an entire rebuild.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 devmap_name/Makefile |    4 ++--
 kpartx/Makefile      |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/devmap_name/Makefile b/devmap_name/Makefile
index 380c85b..d8d8b09 100644
--- a/devmap_name/Makefile
+++ b/devmap_name/Makefile
@@ -28,9 +28,9 @@ klibc: prepare $(OBJS)
 	$(CC) -static -o $(EXEC) $(OBJS)
 	$(GZIP) $(EXEC).8 > $(EXEC).8.gz
 
-install:
+install: $(EXEC) $(EXEC).8
 	install -d $(DESTDIR)$(bindir)
-	install -s -m 755 $(EXEC) $(DESTDIR)$(bindir)/
+	install -m 755 $(EXEC) $(DESTDIR)$(bindir)/
 	install -d $(DESTDIR)$(mandir)
 	install -m 644 $(EXEC).8.gz $(DESTDIR)$(mandir)
 
diff --git a/kpartx/Makefile b/kpartx/Makefile
index bf6e6c1..a43f881 100644
--- a/kpartx/Makefile
+++ b/kpartx/Makefile
@@ -36,7 +36,7 @@ klibc: prepare $(OBJS)
 $(MULTIPATHLIB)-$(BUILD).a:
 	make -C $(multipathdir) BUILD=$(BUILD)
 
-install:
+install: $(EXEC) $(EXEC).8
 	install -d $(DESTDIR)$(bindir)
 	install -s -m 755 $(EXEC) $(DESTDIR)$(bindir)
 	install -d $(DESTDIR)$(mandir)
-- 
1.4.3.4
