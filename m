From: Alasdair G Kergon <agk@redhat.com>
Subject: [PATCH] Snapshot restructuring: Step 1
Date: Fri, 28 Jan 2005 22:06:20 +0000
Message-ID: <20050128220620.GO10195@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

NB This patch may break some snapshot functionality in LVM2 & EVMS.
[e.g. In LVM2 a test I did resizing the snapshot COW area locked up]

Move snapshot metadata loading to happen when table is created instead
of when device is resumed.  Origin writes don't trigger exceptions until
snapshot table becomes active (when resume() is called on snapshot).


The snapshot and origin targets have various unwritten rules about
how they can be used.  LVM2 and EVMS currently obey those rules.
But there are various memory allocation problems with the existing
implementation and so things have to be changed.
The general aim is to move as much work as possible outside the
suspend & resume functions.

The restriction remains that you mustn't load the same snapshot
metadata into more than one table: I can't think of any
case that needs this, and this patch takes advantage of this.

Inactive table created with snapshot target: loads snapshot metadata, 
  registers snapshot against its origin but does *not* start
  capturing changes to the origin yet.
Device is resumed, making the table active: changes to the origin *are*
  captured from now on.
Snapshot may be suspended/resumed or deleted, but you must never
load the same snapshot metadata into another table concurrently - 
so you mustn't reload the same snapshot into the INACTIVE table.

--- diff/drivers/md/dm-snap.c	2005-01-28 20:25:26.000000000 +0000
+++ source/drivers/md/dm-snap.c	2005-01-28 21:18:43.000000000 +0000
@@ -371,6 +371,20 @@
 	return (n + size) & ~size;
 }
 
+static void read_snapshot_metadata(struct dm_snapshot *s)
+{
+	if (s->have_metadata)
+		return;
+
+	if (s->store.read_metadata(&s->store)) {
+		down_write(&s->lock);
+		s->valid = 0;
+		up_write(&s->lock);
+	}
+
+	s->have_metadata = 1;
+}
+
 /*
  * Construct a snapshot mapping: <origin_dev> <COW-dev> <p/n> <chunk-size>
  */
@@ -848,16 +862,7 @@
 {
 	struct dm_snapshot *s = (struct dm_snapshot *) ti->private;
 
-	if (s->have_metadata)
-		return;
-
-	if (s->store.read_metadata(&s->store)) {
-		down_write(&s->lock);
-		s->valid = 0;
-		up_write(&s->lock);
-	}
-
-	s->have_metadata = 1;
+	read_snapshot_metadata(s);
 }
 
 static int snapshot_status(struct dm_target *ti, status_type_t type,
--- diff/drivers/md/dm-snap.c	2005-01-28 21:25:48.000000000 +0000
+++ source/drivers/md/dm-snap.c	2005-01-28 21:26:21.000000000 +0000
@@ -471,7 +471,7 @@
 	s->chunk_shift = ffs(chunk_size) - 1;
 
 	s->valid = 1;
-	s->have_metadata = 0;
+	s->active = 0;
 	s->last_percent = 0;
 	init_rwsem(&s->lock);
 	s->table = ti->table;
@@ -506,7 +506,11 @@
 		goto bad5;
 	}
 
+	/* Metadata must only be loaded into one table at once */
+	read_snapshot_metadata(s);
+
 	/* Add snapshot to the list of snapshots for this origin */
+	/* Exceptions aren't triggered till snapshot_resume() is called */
 	if (register_snapshot(s)) {
 		r = -EINVAL;
 		ti->error = "Cannot register snapshot origin";
@@ -862,7 +866,9 @@
 {
 	struct dm_snapshot *s = (struct dm_snapshot *) ti->private;
 
-	read_snapshot_metadata(s);
+	down_write(&s->lock);
+	s->active = 1;
+	up_write(&s->lock);
 }
 
 static int snapshot_status(struct dm_target *ti, status_type_t type,
@@ -932,8 +938,8 @@
 	/* Do all the snapshots on this origin */
 	list_for_each_entry (snap, snapshots, list) {
 
-		/* Only deal with valid snapshots */
-		if (!snap->valid)
+		/* Only deal with valid and active snapshots */
+		if (!snap->valid || !snap->active)
 			continue;
 
 		/* Nothing to do if writing beyond end of snapshot */
--- diff/drivers/md/dm-snap.h	2005-01-12 15:21:22.000000000 +0000
+++ source/drivers/md/dm-snap.h	2005-01-28 21:25:32.000000000 +0000
@@ -99,7 +99,9 @@
 
 	/* You can't use a snapshot if this is 0 (e.g. if full) */
 	int valid;
-	int have_metadata;
+
+	/* Origin writes don't trigger exceptions until this is set */
+	int active;
 
 	/* Used for display of table */
 	char type;
--- diff/drivers/md/dm-snap.c	2005-01-28 21:37:05.000000000 +0000
+++ source/drivers/md/dm-snap.c	2005-01-28 21:36:58.000000000 +0000
@@ -373,16 +373,11 @@
 
 static void read_snapshot_metadata(struct dm_snapshot *s)
 {
-	if (s->have_metadata)
-		return;
-
 	if (s->store.read_metadata(&s->store)) {
 		down_write(&s->lock);
 		s->valid = 0;
 		up_write(&s->lock);
 	}
-
-	s->have_metadata = 1;
 }
 
 /*

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
