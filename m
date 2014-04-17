From: Vasily Tarasov <tarasov@vasily.name>
Subject: [PATCH RFC 07/10] dm-dedup: Makefile changes
Date: Thu, 17 Apr 2014 16:32:45 -0400
Message-ID: <535ed0dc.d171e00a.7699.3b85@mx.google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
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
To: dm-devel@redhat.com
Cc: Christoph Hellwig <hch@infradead.org>, Philip Shilane <philip.shilane@emc.com>, Sonam Mandal <sonam.dp42@gmail.com>, Erez Zadok <ezk@fsl.cs.sunysb.edu>
List-Id: dm-devel.ids

Changes to the Makefile.

Signed-off-by: Vasily Tarasov <tarasov@vasily.name>
---
 drivers/md/Makefile |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index f26d832..1af205d 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -14,6 +14,7 @@ dm-thin-pool-y	+= dm-thin.o dm-thin-metadata.o
 dm-cache-y	+= dm-cache-target.o dm-cache-metadata.o dm-cache-policy.o
 dm-cache-mq-y   += dm-cache-policy-mq.o
 dm-cache-cleaner-y += dm-cache-policy-cleaner.o
+dm-dedup-y	+= dm-dedup-target.o dm-dedup-hash.o dm-dedup-rw.o dm-dedup-cbt.o dm-dedup-ram.o
 md-mod-y	+= md.o bitmap.o
 raid456-y	+= raid5.o
 
@@ -53,6 +54,7 @@ obj-$(CONFIG_DM_VERITY)		+= dm-verity.o
 obj-$(CONFIG_DM_CACHE)		+= dm-cache.o
 obj-$(CONFIG_DM_CACHE_MQ)	+= dm-cache-mq.o
 obj-$(CONFIG_DM_CACHE_CLEANER)	+= dm-cache-cleaner.o
+obj-$(CONFIG_DM_DEDUP)		+= dm-dedup.o
 
 ifeq ($(CONFIG_DM_UEVENT),y)
 dm-mod-objs			+= dm-uevent.o
-- 
1.7.1
