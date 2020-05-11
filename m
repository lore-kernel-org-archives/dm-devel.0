From: Gabriel Krisman Bertazi <krisman@collabora.com>
Subject: [PATCH v4 1/2] md: mpath: Pass IO start time to path selector
Date: Mon, 11 May 2020 12:39:09 -0400
Message-ID: <20200511163910.3778467-2-krisman@collabora.com>
References: <20200511163910.3778467-1-krisman@collabora.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200511163910.3778467-1-krisman@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
To: agk@redhat.com, snitzer@redhat.com
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, song@kernel.org, breeves@redhat.com, mpatocka@redhat.com, khazhy@google.com, Gabriel Krisman Bertazi <krisman@collabora.com>, kernel@collabora.com
List-Id: dm-devel.ids

HST is going to need this information to perform path prediction. For
request-based mpath, we use the struct request io_start_time, while for
bio based, use the DM layer start_time.

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
---
 drivers/md/dm-mpath.c         | 12 +++++++++---
 drivers/md/dm-path-selector.h |  2 +-
 drivers/md/dm-queue-length.c  |  2 +-
 drivers/md/dm-service-time.c  |  2 +-
 4 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index f5e7f8e88767..deb6ae5ad35b 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -105,6 +105,7 @@ struct multipath {
 struct dm_mpath_io {
 	struct pgpath *pgpath;
 	size_t nr_bytes;
+	u64 start_time_ns;
 };
 
 typedef int (*action_fn) (struct pgpath *pgpath);
@@ -519,6 +520,7 @@ static int multipath_clone_and_map(struct dm_target *ti, struct request *rq,
 
 	mpio->pgpath = pgpath;
 	mpio->nr_bytes = nr_bytes;
+	mpio->start_time_ns = rq->io_start_time_ns;
 
 	bdev = pgpath->path.dev->bdev;
 	q = bdev_get_queue(bdev);
@@ -567,7 +569,8 @@ static void multipath_release_clone(struct request *clone,
 		if (pgpath && pgpath->pg->ps.type->end_io)
 			pgpath->pg->ps.type->end_io(&pgpath->pg->ps,
 						    &pgpath->path,
-						    mpio->nr_bytes);
+						    mpio->nr_bytes,
+						    mpio->start_time_ns);
 	}
 
 	blk_put_request(clone);
@@ -629,6 +632,7 @@ static int __multipath_map_bio(struct multipath *m, struct bio *bio,
 	}
 
 	mpio->pgpath = pgpath;
+	mpio->start_time_ns = ktime_get_ns();
 
 	bio->bi_status = 0;
 	bio_set_dev(bio, pgpath->path.dev->bdev);
@@ -1620,7 +1624,8 @@ static int multipath_end_io(struct dm_target *ti, struct request *clone,
 		struct path_selector *ps = &pgpath->pg->ps;
 
 		if (ps->type->end_io)
-			ps->type->end_io(ps, &pgpath->path, mpio->nr_bytes);
+			ps->type->end_io(ps, &pgpath->path, mpio->nr_bytes,
+					 mpio->start_time_ns);
 	}
 
 	return r;
@@ -1664,7 +1669,8 @@ static int multipath_end_io_bio(struct dm_target *ti, struct bio *clone,
 		struct path_selector *ps = &pgpath->pg->ps;
 
 		if (ps->type->end_io)
-			ps->type->end_io(ps, &pgpath->path, mpio->nr_bytes);
+			ps->type->end_io(ps, &pgpath->path, mpio->nr_bytes,
+					 mpio->start_time_ns);
 	}
 
 	return r;
diff --git a/drivers/md/dm-path-selector.h b/drivers/md/dm-path-selector.h
index b6eb5365b1a4..c47bc0e20275 100644
--- a/drivers/md/dm-path-selector.h
+++ b/drivers/md/dm-path-selector.h
@@ -74,7 +74,7 @@ struct path_selector_type {
 	int (*start_io) (struct path_selector *ps, struct dm_path *path,
 			 size_t nr_bytes);
 	int (*end_io) (struct path_selector *ps, struct dm_path *path,
-		       size_t nr_bytes);
+		       size_t nr_bytes, u64 start_time);
 };
 
 /* Register a path selector */
diff --git a/drivers/md/dm-queue-length.c b/drivers/md/dm-queue-length.c
index 969c4f1a3633..5fd018d18418 100644
--- a/drivers/md/dm-queue-length.c
+++ b/drivers/md/dm-queue-length.c
@@ -227,7 +227,7 @@ static int ql_start_io(struct path_selector *ps, struct dm_path *path,
 }
 
 static int ql_end_io(struct path_selector *ps, struct dm_path *path,
-		     size_t nr_bytes)
+		     size_t nr_bytes, u64 start_time)
 {
 	struct path_info *pi = path->pscontext;
 
diff --git a/drivers/md/dm-service-time.c b/drivers/md/dm-service-time.c
index f006a9005593..9cfda665e9eb 100644
--- a/drivers/md/dm-service-time.c
+++ b/drivers/md/dm-service-time.c
@@ -309,7 +309,7 @@ static int st_start_io(struct path_selector *ps, struct dm_path *path,
 }
 
 static int st_end_io(struct path_selector *ps, struct dm_path *path,
-		     size_t nr_bytes)
+		     size_t nr_bytes, u64 start_time)
 {
 	struct path_info *pi = path->pscontext;
 
-- 
2.26.2
