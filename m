From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 09/14] block: move the initial blkg lookup into blkg_tryget_closest
Date: Sat, 27 Jun 2020 09:31:54 +0200
Message-ID: <20200627073159.2447325-10-hch@lst.de>
References: <20200627073159.2447325-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200627073159.2447325-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>
Cc: Dennis Zhou <dennis@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org
List-Id: dm-devel.ids

By moving the initial blkg lookup into blkg_tryget_closest we get
a nicely self contained routines that does all the RCU locking.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-cgroup.c | 33 ++++++++++++++-------------------
 1 file changed, 14 insertions(+), 19 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 0912820d4f8194..d21ec2acd716e7 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1716,19 +1716,20 @@ void blkcg_add_delay(struct blkcg_gq *blkg, u64 now, u64 delta)
 
 /**
  * blkg_tryget_closest - try and get a blkg ref on the closet blkg
- * @blkg: blkg to get
+ * @bio: target bio
+ * @css: target css
  *
- * This needs to be called rcu protected.  As the failure mode here is to walk
- * up the blkg tree, this ensure that the blkg->parent pointers are always
- * valid.  This returns the blkg that it ended up taking a reference on or %NULL
- * if no reference was taken.
+ * As the failure mode here is to walk up the blkg tree, this ensure that the
+ * blkg->parent pointers are always valid.  This returns the blkg that it ended
+ * up taking a reference on or %NULL if no reference was taken.
  */
-static inline struct blkcg_gq *blkg_tryget_closest(struct blkcg_gq *blkg)
+static inline struct blkcg_gq *blkg_tryget_closest(struct bio *bio,
+		struct cgroup_subsys_state *css)
 {
-	struct blkcg_gq *ret_blkg = NULL;
-
-	WARN_ON_ONCE(!rcu_read_lock_held());
+	struct blkcg_gq *blkg, *ret_blkg = NULL;
 
+	rcu_read_lock();
+	blkg = blkg_lookup_create(css_to_blkcg(css), bio->bi_disk->queue);
 	while (blkg) {
 		if (blkg_tryget(blkg)) {
 			ret_blkg = blkg;
@@ -1736,6 +1737,7 @@ static inline struct blkcg_gq *blkg_tryget_closest(struct blkcg_gq *blkg)
 		}
 		blkg = blkg->parent;
 	}
+	rcu_read_unlock();
 
 	return ret_blkg;
 }
@@ -1757,21 +1759,14 @@ static inline struct blkcg_gq *blkg_tryget_closest(struct blkcg_gq *blkg)
 void bio_associate_blkg_from_css(struct bio *bio,
 				 struct cgroup_subsys_state *css)
 {
-	struct request_queue *q = bio->bi_disk->queue;
-
 	if (bio->bi_blkg)
 		blkg_put(bio->bi_blkg);
 
 	if (css && css->parent) {
-		struct blkcg_gq *blkg;
-
-		rcu_read_lock();
-		blkg = blkg_lookup_create(css_to_blkcg(css), q);
-		bio->bi_blkg = blkg_tryget_closest(blkg);
-		rcu_read_unlock();
+		bio->bi_blkg = blkg_tryget_closest(bio, css);
 	} else {
-		blkg_get(q->root_blkg);
-		bio->bi_blkg = q->root_blkg;
+		blkg_get(bio->bi_disk->queue->root_blkg);
+		bio->bi_blkg = bio->bi_disk->queue->root_blkg;
 	}
 }
 EXPORT_SYMBOL_GPL(bio_associate_blkg_from_css);
-- 
2.26.2
