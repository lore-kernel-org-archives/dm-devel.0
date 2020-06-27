From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 08/14] block: bypass blkg_tryget_closest for the root_blkg
Date: Sat, 27 Jun 2020 09:31:53 +0200
Message-ID: <20200627073159.2447325-9-hch@lst.de>
References: <20200627073159.2447325-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200627073159.2447325-1-hch-jcswGhMUV9g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Dennis Zhou <dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
List-Id: dm-devel.ids

The root_blkg is only torn down at the very end of removing a queue.
So in the I/O submission path is always has a life reference and we
can just grab another one using blkg_get instead of doing a tryget
and parent walk that won't lead anywhere.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 block/blk-cgroup.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 6aedb73ffbf473..0912820d4f8194 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1758,16 +1758,21 @@ void bio_associate_blkg_from_css(struct bio *bio,
 				 struct cgroup_subsys_state *css)
 {
 	struct request_queue *q = bio->bi_disk->queue;
-	struct blkcg_gq *blkg = q->root_blkg;
 
 	if (bio->bi_blkg)
 		blkg_put(bio->bi_blkg);
 
-	rcu_read_lock();
-	if (css && css->parent)
+	if (css && css->parent) {
+		struct blkcg_gq *blkg;
+
+		rcu_read_lock();
 		blkg = blkg_lookup_create(css_to_blkcg(css), q);
-	bio->bi_blkg = blkg_tryget_closest(blkg);
-	rcu_read_unlock();
+		bio->bi_blkg = blkg_tryget_closest(blkg);
+		rcu_read_unlock();
+	} else {
+		blkg_get(q->root_blkg);
+		bio->bi_blkg = q->root_blkg;
+	}
 }
 EXPORT_SYMBOL_GPL(bio_associate_blkg_from_css);
 
-- 
2.26.2
