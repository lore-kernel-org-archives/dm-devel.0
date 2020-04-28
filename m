From: Gabriel Krisman Bertazi <krisman@collabora.com>
Subject: [PATCH v2 1/3] md: multipath: Encapsulate parameters
	passed to selectors
Date: Mon, 27 Apr 2020 20:51:44 -0400
Message-ID: <20200428005146.242231-2-krisman@collabora.com>
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

Different selector will use different parameters, which means .io_start
and .io_end will get their signatures modified to include more and more
parameters.  This encapsulates the data in a structure so we can
simplify the interface for future users.  For now it only passes
nr_bytes, but HST will require start_time already.

Cc: Khazhismel Kumykov <khazhy@google.com>
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
---
 drivers/md/dm-mpath.c         | 25 ++++++++++++++++++++-----
 drivers/md/dm-path-selector.h |  8 ++++++--
 drivers/md/dm-queue-length.c  |  4 ++--
 drivers/md/dm-service-time.c  |  8 ++++----
 4 files changed, 32 insertions(+), 13 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index f5e7f8e88767..1ef4fc2e745b 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -500,6 +500,9 @@ static int multipath_clone_and_map(struct dm_target *ti, struct request *rq,
 	struct dm_mpath_io *mpio = get_mpio(map_context);
 	struct request_queue *q;
 	struct request *clone;
+	struct path_selector_io_data io_data = {
+		.nr_bytes = nr_bytes,
+	};
 
 	/* Do we need to select a new pgpath? */
 	pgpath = READ_ONCE(m->current_pgpath);
@@ -549,7 +552,7 @@ static int multipath_clone_and_map(struct dm_target *ti, struct request *rq,
 	if (pgpath->pg->ps.type->start_io)
 		pgpath->pg->ps.type->start_io(&pgpath->pg->ps,
 					      &pgpath->path,
-					      nr_bytes);
+					      &io_data);
 	return DM_MAPIO_REMAPPED;
 }
 
@@ -563,11 +566,14 @@ static void multipath_release_clone(struct request *clone,
 		 */
 		struct dm_mpath_io *mpio = get_mpio(map_context);
 		struct pgpath *pgpath = mpio->pgpath;
+		struct path_selector_io_data ps_io_data = {
+			.nr_bytes = mpio->nr_bytes,
+		};
 
 		if (pgpath && pgpath->pg->ps.type->end_io)
 			pgpath->pg->ps.type->end_io(&pgpath->pg->ps,
 						    &pgpath->path,
-						    mpio->nr_bytes);
+						    &ps_io_data);
 	}
 
 	blk_put_request(clone);
@@ -617,6 +623,9 @@ static int __multipath_map_bio(struct multipath *m, struct bio *bio,
 			       struct dm_mpath_io *mpio)
 {
 	struct pgpath *pgpath = __map_bio(m, bio);
+	struct path_selector_io_data io_data = {
+		.nr_bytes = mpio->nr_bytes,
+	};
 
 	if (IS_ERR(pgpath))
 		return DM_MAPIO_SUBMITTED;
@@ -637,7 +646,7 @@ static int __multipath_map_bio(struct multipath *m, struct bio *bio,
 	if (pgpath->pg->ps.type->start_io)
 		pgpath->pg->ps.type->start_io(&pgpath->pg->ps,
 					      &pgpath->path,
-					      mpio->nr_bytes);
+					      &io_data);
 	return DM_MAPIO_REMAPPED;
 }
 
@@ -1618,9 +1627,12 @@ static int multipath_end_io(struct dm_target *ti, struct request *clone,
 
 	if (pgpath) {
 		struct path_selector *ps = &pgpath->pg->ps;
+		struct path_selector_io_data io_data = {
+			.nr_bytes = mpio->nr_bytes
+		};
 
 		if (ps->type->end_io)
-			ps->type->end_io(ps, &pgpath->path, mpio->nr_bytes);
+			ps->type->end_io(ps, &pgpath->path, &io_data);
 	}
 
 	return r;
@@ -1662,9 +1674,12 @@ static int multipath_end_io_bio(struct dm_target *ti, struct bio *clone,
 done:
 	if (pgpath) {
 		struct path_selector *ps = &pgpath->pg->ps;
+		struct path_selector_io_data io_data = {
+			.nr_bytes = mpio->nr_bytes
+		};
 
 		if (ps->type->end_io)
-			ps->type->end_io(ps, &pgpath->path, mpio->nr_bytes);
+			ps->type->end_io(ps, &pgpath->path, &io_data);
 	}
 
 	return r;
diff --git a/drivers/md/dm-path-selector.h b/drivers/md/dm-path-selector.h
index b6eb5365b1a4..fb582a943234 100644
--- a/drivers/md/dm-path-selector.h
+++ b/drivers/md/dm-path-selector.h
@@ -26,6 +26,10 @@ struct path_selector {
 	void *context;
 };
 
+struct path_selector_io_data {
+	size_t nr_bytes;
+};
+
 /* Information about a path selector type */
 struct path_selector_type {
 	char *name;
@@ -72,9 +76,9 @@ struct path_selector_type {
 		       status_type_t type, char *result, unsigned int maxlen);
 
 	int (*start_io) (struct path_selector *ps, struct dm_path *path,
-			 size_t nr_bytes);
+			 const struct path_selector_io_data *io_data);
 	int (*end_io) (struct path_selector *ps, struct dm_path *path,
-		       size_t nr_bytes);
+		       const struct path_selector_io_data *io_data);
 };
 
 /* Register a path selector */
diff --git a/drivers/md/dm-queue-length.c b/drivers/md/dm-queue-length.c
index 969c4f1a3633..eeaa038a1dbb 100644
--- a/drivers/md/dm-queue-length.c
+++ b/drivers/md/dm-queue-length.c
@@ -217,7 +217,7 @@ static struct dm_path *ql_select_path(struct path_selector *ps, size_t nr_bytes)
 }
 
 static int ql_start_io(struct path_selector *ps, struct dm_path *path,
-		       size_t nr_bytes)
+		       const struct path_selector_io_data *io_data)
 {
 	struct path_info *pi = path->pscontext;
 
@@ -227,7 +227,7 @@ static int ql_start_io(struct path_selector *ps, struct dm_path *path,
 }
 
 static int ql_end_io(struct path_selector *ps, struct dm_path *path,
-		     size_t nr_bytes)
+		     const struct path_selector_io_data *io_data)
 {
 	struct path_info *pi = path->pscontext;
 
diff --git a/drivers/md/dm-service-time.c b/drivers/md/dm-service-time.c
index f006a9005593..d751f26b61af 100644
--- a/drivers/md/dm-service-time.c
+++ b/drivers/md/dm-service-time.c
@@ -299,21 +299,21 @@ static struct dm_path *st_select_path(struct path_selector *ps, size_t nr_bytes)
 }
 
 static int st_start_io(struct path_selector *ps, struct dm_path *path,
-		       size_t nr_bytes)
+		       const struct path_selector_io_data *io_data)
 {
 	struct path_info *pi = path->pscontext;
 
-	atomic_add(nr_bytes, &pi->in_flight_size);
+	atomic_add(io_data->nr_bytes, &pi->in_flight_size);
 
 	return 0;
 }
 
 static int st_end_io(struct path_selector *ps, struct dm_path *path,
-		     size_t nr_bytes)
+		     const struct path_selector_io_data *io_data)
 {
 	struct path_info *pi = path->pscontext;
 
-	atomic_sub(nr_bytes, &pi->in_flight_size);
+	atomic_sub(io_data->nr_bytes, &pi->in_flight_size);
 
 	return 0;
 }
-- 
2.26.2
