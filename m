From: Joe Perches <joe@perches.com>
Subject: [PATCH 14/49] drivers/md: Use vzalloc
Date: Thu,  4 Nov 2010 20:07:38 -0700
Message-ID: <fb14aa0a6cfe2754ecc9c8e7cd5be07a5431e33f.1288925424.git.joe@perches.com>
References: <alpine.DEB.2.00.1011031108260.11625@router.home>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.DEB.2.00.1011031108260.11625@router.home>
In-Reply-To: <cover.1288925424.git.joe@perches.com>
References: <cover.1288925424.git.joe@perches.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/md/dm-log.c             |    3 +--
 drivers/md/dm-snap-persistent.c |    3 +--
 drivers/md/dm-table.c           |    4 +---
 3 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
index 33420e6..8f00e38 100644
--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -487,7 +487,7 @@ static int create_log_context(struct dm_dirty_log *log, struct dm_target *ti,
 	memset(lc->sync_bits, (sync == NOSYNC) ? -1 : 0, bitset_size);
 	lc->sync_count = (sync == NOSYNC) ? region_count : 0;
 
-	lc->recovering_bits = vmalloc(bitset_size);
+	lc->recovering_bits = vzalloc(bitset_size);
 	if (!lc->recovering_bits) {
 		DMWARN("couldn't allocate sync bitset");
 		vfree(lc->sync_bits);
@@ -499,7 +499,6 @@ static int create_log_context(struct dm_dirty_log *log, struct dm_target *ti,
 		kfree(lc);
 		return -ENOMEM;
 	}
-	memset(lc->recovering_bits, 0, bitset_size);
 	lc->sync_search = 0;
 	log->context = lc;
 
diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
index 2129cdb..8eb943f 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -174,10 +174,9 @@ static int alloc_area(struct pstore *ps)
 	if (!ps->area)
 		goto err_area;
 
-	ps->zero_area = vmalloc(len);
+	ps->zero_area = vzalloc(len);
 	if (!ps->zero_area)
 		goto err_zero_area;
-	memset(ps->zero_area, 0, len);
 
 	ps->header_area = vmalloc(len);
 	if (!ps->header_area)
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 90267f8..d6a91f7 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -151,9 +151,7 @@ void *dm_vcalloc(unsigned long nmemb, unsigned long elem_size)
 		return NULL;
 
 	size = nmemb * elem_size;
-	addr = vmalloc(size);
-	if (addr)
-		memset(addr, 0, size);
+	addr = vzalloc(size);
 
 	return addr;
 }
-- 
1.7.3.1.g432b3.dirty
