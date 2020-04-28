From: Gabriel Krisman Bertazi <krisman@collabora.com>
Subject: [PATCH v2 2/3] md: multipath: Pass io_start_time to the
	path selector
Date: Mon, 27 Apr 2020 20:51:45 -0400
Message-ID: <20200428005146.242231-3-krisman@collabora.com>
References: <20200428005146.242231-1-krisman@collabora.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200428005146.242231-1-krisman@collabora.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com, snitzer@redhat.com
Cc: dm-devel@redhat.com, kernel@collabora.com, Gabriel Krisman Bertazi <krisman@collabora.com>, khazhy@google.com
List-Id: dm-devel.ids

HST need to know the IO start time in order to predict path
performance. For request-based multipath use the block layer
io_start_time, while for BIO use the dm_io start_time.

The dm_start_time_ns_from_clone function was suggested and implemented
by Mike Snitzer <snitzer@redhat.com>.

Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Khazhismel Kumykov <khazhy@google.com>
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
---
 drivers/md/dm-mpath.c         | 25 +++++++++++++++----------
 drivers/md/dm-path-selector.h |  1 +
 drivers/md/dm.c               | 10 ++++++++++
 include/linux/device-mapper.h |  2 ++
 4 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 1ef4fc2e745b..7af3249948be 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -500,8 +500,9 @@ static int multipath_clone_and_map(struct dm_target *ti, struct request *rq,
 	struct dm_mpath_io *mpio = get_mpio(map_context);
 	struct request_queue *q;
 	struct request *clone;
-	struct path_selector_io_data io_data = {
+	struct path_selector_io_data ps_io_data = {
 		.nr_bytes = nr_bytes,
+		.io_start_time = rq->io_start_time_ns
 	};
 
 	/* Do we need to select a new pgpath? */
@@ -552,7 +553,7 @@ static int multipath_clone_and_map(struct dm_target *ti, struct request *rq,
 	if (pgpath->pg->ps.type->start_io)
 		pgpath->pg->ps.type->start_io(&pgpath->pg->ps,
 					      &pgpath->path,
-					      &io_data);
+					      &ps_io_data);
 	return DM_MAPIO_REMAPPED;
 }
 
@@ -568,6 +569,7 @@ static void multipath_release_clone(struct request *clone,
 		struct pgpath *pgpath = mpio->pgpath;
 		struct path_selector_io_data ps_io_data = {
 			.nr_bytes = mpio->nr_bytes,
+			.io_start_time = clone->io_start_time_ns,
 		};
 
 		if (pgpath && pgpath->pg->ps.type->end_io)
@@ -623,8 +625,9 @@ static int __multipath_map_bio(struct multipath *m, struct bio *bio,
 			       struct dm_mpath_io *mpio)
 {
 	struct pgpath *pgpath = __map_bio(m, bio);
-	struct path_selector_io_data io_data = {
+	struct path_selector_io_data ps_io_data = {
 		.nr_bytes = mpio->nr_bytes,
+		.io_start_time = dm_start_time_ns_from_clone(bio)
 	};
 
 	if (IS_ERR(pgpath))
@@ -646,7 +649,7 @@ static int __multipath_map_bio(struct multipath *m, struct bio *bio,
 	if (pgpath->pg->ps.type->start_io)
 		pgpath->pg->ps.type->start_io(&pgpath->pg->ps,
 					      &pgpath->path,
-					      &io_data);
+					      &ps_io_data);
 	return DM_MAPIO_REMAPPED;
 }
 
@@ -1627,12 +1630,13 @@ static int multipath_end_io(struct dm_target *ti, struct request *clone,
 
 	if (pgpath) {
 		struct path_selector *ps = &pgpath->pg->ps;
-		struct path_selector_io_data io_data = {
-			.nr_bytes = mpio->nr_bytes
+		struct path_selector_io_data ps_io_data = {
+			.nr_bytes = mpio->nr_bytes,
+			.io_start_time = clone->io_start_time_ns
 		};
 
 		if (ps->type->end_io)
-			ps->type->end_io(ps, &pgpath->path, &io_data);
+			ps->type->end_io(ps, &pgpath->path, &ps_io_data);
 	}
 
 	return r;
@@ -1674,12 +1678,13 @@ static int multipath_end_io_bio(struct dm_target *ti, struct bio *clone,
 done:
 	if (pgpath) {
 		struct path_selector *ps = &pgpath->pg->ps;
-		struct path_selector_io_data io_data = {
-			.nr_bytes = mpio->nr_bytes
+		struct path_selector_io_data ps_io_data = {
+			.nr_bytes = mpio->nr_bytes,
+			.io_start_time = dm_start_time_ns_from_clone(clone)
 		};
 
 		if (ps->type->end_io)
-			ps->type->end_io(ps, &pgpath->path, &io_data);
+			ps->type->end_io(ps, &pgpath->path, &ps_io_data);
 	}
 
 	return r;
diff --git a/drivers/md/dm-path-selector.h b/drivers/md/dm-path-selector.h
index fb582a943234..4c5fa6a2efe3 100644
--- a/drivers/md/dm-path-selector.h
+++ b/drivers/md/dm-path-selector.h
@@ -28,6 +28,7 @@ struct path_selector {
 
 struct path_selector_io_data {
 	size_t nr_bytes;
+	u64 io_start_time;
 };
 
 /* Information about a path selector type */
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index df13fdebe21f..2e0637a6de9d 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -674,6 +674,16 @@ static bool md_in_flight(struct mapped_device *md)
 		return md_in_flight_bios(md);
 }
 
+u64 dm_start_time_ns_from_clone(struct bio *bio)
+{
+	struct dm_target_io *tio = container_of(bio, struct dm_target_io, clone);
+	struct dm_io *io = tio->io;
+
+	/* FIXME: convert io->start_time from jiffies to nanoseconds */
+	return (u64)jiffies_to_msecs(io->start_time) * NSEC_PER_MSEC;
+}
+EXPORT_SYMBOL_GPL(dm_start_time_ns_from_clone);
+
 static void start_io_acct(struct dm_io *io)
 {
 	struct mapped_device *md = io->md;
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 475668c69dbc..e2d506dd805e 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -329,6 +329,8 @@ void *dm_per_bio_data(struct bio *bio, size_t data_size);
 struct bio *dm_bio_from_per_bio_data(void *data, size_t data_size);
 unsigned dm_bio_get_target_bio_nr(const struct bio *bio);
 
+u64 dm_start_time_ns_from_clone(struct bio *bio);
+
 int dm_register_target(struct target_type *t);
 void dm_unregister_target(struct target_type *t);
 
-- 
2.26.2
