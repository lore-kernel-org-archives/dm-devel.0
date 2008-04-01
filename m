From: Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH 04/10] dm snapshot: Split snapshot constructor
Date: Tue,  1 Apr 2008 09:32:51 +0200
Message-ID: <1207035177-7156-5-git-send-email-markmc@redhat.com>
References: <1207035177-7156-1-git-send-email-markmc@redhat.com>
	<1207035177-7156-2-git-send-email-markmc@redhat.com>
	<1207035177-7156-3-git-send-email-markmc@redhat.com>
	<1207035177-7156-4-git-send-email-markmc@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1207035177-7156-4-git-send-email-markmc@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com
Cc: Mark McLoughlin <markmc@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Split parts of snapshot_ctr() into a separate function, snapshot_init()
and parts of snapshot_dtr() into snapshot_destroy().

This is needed by later patches because the merging target re-uses the
dm_snapshot structure, but the merging target doesn't register itself
as a snapshot (i.e. origin writes shouldn't cause an exception), has a
different set of arguments and in some ways behaves more like a
snapshot-origin target.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 drivers/md/dm-snap.c |  166 +++++++++++++++++++++++++++----------------------
 1 files changed, 91 insertions(+), 75 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 3b71f53..20f12a8 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -435,18 +435,9 @@ static ulong round_up(ulong n, ulong size)
 	return (n + size) & ~size;
 }
 
-static int set_chunk_size(struct dm_snapshot *s, const char *chunk_size_arg,
+static int set_chunk_size(struct dm_snapshot *s, unsigned long chunk_size,
 			  char **error)
 {
-	unsigned long chunk_size;
-	char *value;
-
-	chunk_size = simple_strtoul(chunk_size_arg, &value, 10);
-	if (*chunk_size_arg == '\0' || *value != '\0') {
-		*error = "Invalid chunk size";
-		return -EINVAL;
-	}
-
 	if (!chunk_size) {
 		s->chunk_size = s->chunk_mask = s->chunk_shift = 0;
 		return 0;
@@ -477,61 +468,30 @@ static int set_chunk_size(struct dm_snapshot *s, const char *chunk_size_arg,
 	return 0;
 }
 
-/*
- * Construct a snapshot mapping: <origin_dev> <COW-dev> <p/n> <chunk-size>
- */
-static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
+static int snapshot_init(struct dm_target *ti, struct dm_snapshot *s,
+			 const char *origin_path, int origin_mode,
+			 const char *cow_path, int cow_mode,
+			 char type, unsigned long chunk_size)
 {
-	struct dm_snapshot *s;
-	int r = -EINVAL;
-	char persistent;
-	char *origin_path;
-	char *cow_path;
-
-	if (argc != 4) {
-		ti->error = "requires exactly 4 arguments";
-		r = -EINVAL;
-		goto bad1;
-	}
-
-	origin_path = argv[0];
-	cow_path = argv[1];
-	persistent = toupper(*argv[2]);
-
-	if (persistent != 'P' && persistent != 'N') {
-		ti->error = "Persistent flag is not P or N";
-		r = -EINVAL;
-		goto bad1;
-	}
-
-	s = kmalloc(sizeof(*s), GFP_KERNEL);
-	if (s == NULL) {
-		ti->error = "Cannot allocate snapshot context private "
-		    "structure";
-		r = -ENOMEM;
-		goto bad1;
-	}
+	int r;
 
-	r = dm_get_device(ti, origin_path, 0, ti->len, FMODE_READ, &s->origin);
+	r = dm_get_device(ti, origin_path, 0, ti->len, origin_mode, &s->origin);
 	if (r) {
 		ti->error = "Cannot get origin device";
-		goto bad2;
+		goto bad1;
 	}
 
-	r = dm_get_device(ti, cow_path, 0, 0,
-			  FMODE_READ | FMODE_WRITE, &s->cow);
+	r = dm_get_device(ti, cow_path, 0, 0, cow_mode, &s->cow);
 	if (r) {
-		dm_put_device(ti, s->origin);
 		ti->error = "Cannot get COW device";
 		goto bad2;
 	}
 
-	r = set_chunk_size(s, argv[3], &ti->error);
+	r = set_chunk_size(s, chunk_size, &ti->error);
 	if (r)
 		goto bad3;
 
-	s->type = persistent;
-
+	s->type = type;
 	s->valid = 1;
 	s->active = 0;
 	s->last_percent = 0;
@@ -548,7 +508,7 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	s->store.snap = s;
 
-	if (persistent == 'P')
+	if (s->type == 'P')
 		r = dm_create_persistent(&s->store);
 	else
 		r = dm_create_transient(&s->store);
@@ -578,41 +538,24 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	bio_list_init(&s->queued_bios);
 	INIT_WORK(&s->queued_bios_work, flush_queued_bios);
 
-	/* Add snapshot to the list of snapshots for this origin */
-	/* Exceptions aren't triggered till snapshot_resume() is called */
-	if (register_snapshot(s)) {
-		r = -EINVAL;
-		ti->error = "Cannot register snapshot origin";
-		goto bad6;
-	}
-
-	ti->private = s;
-	ti->split_io = s->chunk_size;
-
 	return 0;
 
  bad6:
 	kcopyd_client_destroy(s->kcopyd_client);
-
  bad5:
 	s->store.destroy(&s->store);
-
  bad4:
 	exit_exception_table(&s->pending, pending_cache);
 	exit_exception_table(&s->complete, exception_cache);
-
  bad3:
 	dm_put_device(ti, s->cow);
-	dm_put_device(ti, s->origin);
-
  bad2:
-	kfree(s);
-
+	dm_put_device(ti, s->origin);
  bad1:
 	return r;
 }
 
-static void __free_exceptions(struct dm_snapshot *s)
+static void snapshot_destroy(struct dm_target *ti, struct dm_snapshot *s)
 {
 	kcopyd_client_destroy(s->kcopyd_client);
 	s->kcopyd_client = NULL;
@@ -621,6 +564,82 @@ static void __free_exceptions(struct dm_snapshot *s)
 	exit_exception_table(&s->complete, exception_cache);
 
 	s->store.destroy(&s->store);
+
+	dm_put_device(ti, s->origin);
+	dm_put_device(ti, s->cow);
+}
+
+/*
+ * Construct a snapshot mapping: <origin_dev> <COW-dev> <p/n> <chunk-size>
+ */
+static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
+{
+	struct dm_snapshot *s;
+	int r = -EINVAL;
+	char persistent;
+	char *origin_path;
+	char *cow_path;
+	char *chunk_size_arg;
+	unsigned long chunk_size;
+	char *value;
+
+	if (argc != 4) {
+		ti->error = "requires exactly 4 arguments";
+		r = -EINVAL;
+		goto bad1;
+	}
+
+	origin_path = argv[0];
+	cow_path = argv[1];
+	persistent = toupper(*argv[2]);
+	chunk_size_arg = argv[3];
+
+	if (persistent != 'P' && persistent != 'N') {
+		ti->error = "Persistent flag is not P or N";
+		r = -EINVAL;
+		goto bad1;
+	}
+
+	chunk_size = simple_strtoul(chunk_size_arg, &value, 10);
+	if (*chunk_size_arg == '\0' || *value != '\0') {
+		ti->error = "Invalid chunk size";
+		goto bad1;
+	}
+
+	s = kmalloc(sizeof(*s), GFP_KERNEL);
+	if (s == NULL) {
+		ti->error = "Cannot allocate snapshot context private "
+		    "structure";
+		r = -ENOMEM;
+		goto bad1;
+	}
+
+	r = snapshot_init(ti, s,
+			  origin_path, FMODE_READ,
+			  cow_path, FMODE_READ | FMODE_WRITE,
+			  persistent, chunk_size);
+	if (r)
+		goto bad2;
+
+	/* Add snapshot to the list of snapshots for this origin */
+	/* Exceptions aren't triggered till snapshot_resume() is called */
+	if (register_snapshot(s)) {
+		r = -EINVAL;
+		ti->error = "Cannot register snapshot origin";
+		goto bad3;
+	}
+
+	ti->private = s;
+	ti->split_io = s->chunk_size;
+
+	return 0;
+
+ bad3:
+	snapshot_destroy(ti, s);
+ bad2:
+	kfree(s);
+ bad1:
+	return r;
 }
 
 static void snapshot_dtr(struct dm_target *ti)
@@ -633,10 +652,7 @@ static void snapshot_dtr(struct dm_target *ti)
 	/* After this returns there can be no new kcopyd jobs. */
 	unregister_snapshot(s);
 
-	__free_exceptions(s);
-
-	dm_put_device(ti, s->origin);
-	dm_put_device(ti, s->cow);
+	snapshot_destroy(ti, s);
 
 	kfree(s);
 }
-- 
1.5.4.1
