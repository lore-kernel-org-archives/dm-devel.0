From: Gen Zhang <blackgod016574@gmail.com>
Subject: [PATCH] dm-region-hash: Fix a missing-check bug in __rh_alloc()
Date: Fri, 24 May 2019 11:12:48 +0800
Message-ID: <20190524031248.GA6295@zhanggen-UX430UQ>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

In function __rh_alloc(), the pointer nreg is allocated a memory space
via kmalloc(). And it is used in the following codes. However, when 
there is a memory allocation error, kmalloc() fails. Thus null pointer
dereference may happen. And it will cause the kernel to crash. Therefore,
we should check the return value and handle the error.
Further, in __rh_find(), we should also check the return value and
handle the error.

Signed-off-by: Gen Zhang <blackgod016574@gmail.com>

---
diff --git a/drivers/md/dm-region-hash.c b/drivers/md/dm-region-hash.c
index 1f76045..2fa1641 100644
--- a/drivers/md/dm-region-hash.c
+++ b/drivers/md/dm-region-hash.c
@@ -290,8 +290,11 @@ static struct dm_region *__rh_alloc(struct dm_region_hash *rh, region_t region)
 	struct dm_region *reg, *nreg;
 
 	nreg = mempool_alloc(&rh->region_pool, GFP_ATOMIC);
-	if (unlikely(!nreg))
+	if (unlikely(!nreg)) {
 		nreg = kmalloc(sizeof(*nreg), GFP_NOIO | __GFP_NOFAIL);
+		if (!nreg)
+			return NULL;
+	}
 
 	nreg->state = rh->log->type->in_sync(rh->log, region, 1) ?
 		      DM_RH_CLEAN : DM_RH_NOSYNC;
@@ -329,6 +332,8 @@ static struct dm_region *__rh_find(struct dm_region_hash *rh, region_t region)
 	if (!reg) {
 		read_unlock(&rh->hash_lock);
 		reg = __rh_alloc(rh, region);
+		if (!reg)
+			return NULL;
 		read_lock(&rh->hash_lock);
 	}
 
---
