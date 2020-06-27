From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/14] block: really clone the block cgroup in bio_clone_blkg_association
Date: Sat, 27 Jun 2020 09:31:48 +0200
Message-ID: <20200627073159.2447325-4-hch@lst.de>
References: <20200627073159.2447325-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200627073159.2447325-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>
Cc: Dennis Zhou <dennis@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org
List-Id: dm-devel.ids

bio_clone_blkg_association is supposed to clone the associatation, but
actually ends up doing a search with a tryget.  As we know we have a
reference on the source cgroup just get an unconditional additional
reference to it and call it a day.  That also removes the need for
a RCU critical section.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 8aef4460b32e0e..e1d01acce8070c 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1737,12 +1737,12 @@ EXPORT_SYMBOL_GPL(bio_associate_blkg);
  */
 void bio_clone_blkg_association(struct bio *dst, struct bio *src)
 {
-	rcu_read_lock();
-
-	if (src->bi_blkg)
-		__bio_associate_blkg(dst, src->bi_blkg);
-
-	rcu_read_unlock();
+	if (src->bi_blkg) {
+		if (dst->bi_blkg)
+			blkg_put(dst->bi_blkg);
+		blkg_get(src->bi_blkg);
+		dst->bi_blkg = src->bi_blkg;
+	}
 }
 EXPORT_SYMBOL_GPL(bio_clone_blkg_association);
 #endif /* CONFIG_BLK_CGROUP */
-- 
2.26.2
