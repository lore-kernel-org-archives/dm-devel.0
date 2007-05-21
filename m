From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 18/21] [libmultipath] Fix pp_alua install target
Date: Mon, 21 May 2007 11:24:23 +0200
Message-ID: <20070521092423.A58ABD44CE@pentland.suse.de>
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


The install target in the pp_alua Makefile should reference the
program, not the build target. Otherwise the program gets recompiled
on each install.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 path_priority/pp_alua/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/path_priority/pp_alua/Makefile b/path_priority/pp_alua/Makefile
index 983ffe3..6f356a1 100644
--- a/path_priority/pp_alua/Makefile
+++ b/path_priority/pp_alua/Makefile
@@ -35,7 +35,7 @@ glibc:	$(OBJS)
 klibc:	$(OBJS)
 	$(CC) -static -o $(EXEC) $(OBJS)
 
-install: $(BUILD) $(EXEC).8.gz
+install: $(EXEC) $(EXEC).8.gz
 	$(INSTALL) -s -m 755 $(EXEC) $(DESTDIR)$(bindir)/$(EXEC)
 	$(INSTALL) -m 644 $(EXEC).8.gz $(DESTDIR)$(mandir)/$(EXEC).8.gz
 
-- 
1.4.3.4
