From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 12/14] blk-cgroup: move rcu locking from blkcg_bio_issue_check to blk_throtl_bio
Date: Sat, 27 Jun 2020 09:31:57 +0200
Message-ID: <20200627073159.2447325-13-hch@lst.de>
References: <20200627073159.2447325-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20200627073159.2447325-1-hch-jcswGhMUV9g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Dennis Zhou <dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
List-Id: dm-devel.ids

The only thing in blkcg_bio_issue_check that needs to be under
rcu_read_lock is blk_throtl_bio, so move the locking there.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 block/blk-throttle.c       | 3 ++-
 include/linux/blk-cgroup.h | 2 --
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 209fdd8939fba6..ac008345050010 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -2168,7 +2168,7 @@ bool blk_throtl_bio(struct request_queue *q, struct blkcg_gq *blkg,
 	bool throttled = false;
 	struct throtl_data *td = tg->td;
 
-	WARN_ON_ONCE(!rcu_read_lock_held());
+	rcu_read_lock();
 
 	/* see throtl_charge_bio() */
 	if (bio_flagged(bio, BIO_THROTTLED))
@@ -2273,6 +2273,7 @@ bool blk_throtl_bio(struct request_queue *q, struct blkcg_gq *blkg,
 	if (throttled || !td->track_bio_latency)
 		bio->bi_issue.value |= BIO_ISSUE_THROTL_SKIP_LATENCY;
 #endif
+	rcu_read_unlock();
 	return throttled;
 }
 
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index 8e86b598316c10..8ab043c911f233 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -546,7 +546,6 @@ static inline bool blkcg_bio_issue_check(struct request_queue *q,
 	struct blkcg_gq *blkg = bio->bi_blkg;
 	bool throtl = false;
 
-	rcu_read_lock();
 	throtl = blk_throtl_bio(q, blkg, bio);
 	if (!throtl) {
 		struct blkg_iostat_set *bis;
@@ -582,7 +581,6 @@ static inline bool blkcg_bio_issue_check(struct request_queue *q,
 
 	blkcg_bio_issue_init(bio);
 
-	rcu_read_unlock();
 	return !throtl;
 }
 
-- 
2.26.2
