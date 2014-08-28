From: Vasily Tarasov <tarasov@vasily.name>
Subject: [PATCH RFCv2 07/10] dm-dedup: Makefile changes
Date: Thu, 28 Aug 2014 18:10:08 -0400
Message-ID: <53ffb657.257e320a.22ef.1686@mx.google.com>
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
Cc: Joe Thornber <thornber@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@infradead.org>, Philip Shilane <philip.shilane@emc.com>, Sonam Mandal <sonam.dp42@gmail.com>, Erez Zadok <ezk@fsl.cs.sunysb.edu>
List-Id: dm-devel.ids

Changes to the Makefile.

Signed-off-by: Vasily Tarasov <tarasov@vasily.name>
---
 drivers/md/Makefile |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index a2da532..c3651e3 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -14,6 +14,7 @@ dm-thin-pool-y	+= dm-thin.o dm-thin-metadata.o
 dm-cache-y	+= dm-cache-target.o dm-cache-metadata.o dm-cache-policy.o
 dm-cache-mq-y   += dm-cache-policy-mq.o
 dm-cache-cleaner-y += dm-cache-policy-cleaner.o
+dm-dedup-y	+= dm-dedup-target.o dm-dedup-hash.o dm-dedup-rw.o dm-dedup-cbt.o dm-dedup-ram.o
 dm-era-y	+= dm-era-target.o
 md-mod-y	+= md.o bitmap.o
 raid456-y	+= raid5.o
@@ -54,6 +55,7 @@ obj-$(CONFIG_DM_VERITY)		+= dm-verity.o
 obj-$(CONFIG_DM_CACHE)		+= dm-cache.o
 obj-$(CONFIG_DM_CACHE_MQ)	+= dm-cache-mq.o
 obj-$(CONFIG_DM_CACHE_CLEANER)	+= dm-cache-cleaner.o
+obj-$(CONFIG_DM_DEDUP)		+= dm-dedup.o
 obj-$(CONFIG_DM_ERA)		+= dm-era.o
 
 ifeq ($(CONFIG_DM_UEVENT),y)
-- 
1.7.1
