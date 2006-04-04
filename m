From: Alasdair G Kergon <agk@redhat.com>
Subject: dm-snapshot: Unify chunk_size
Date: Tue, 4 Apr 2006 20:08:41 +0100
Message-ID: <20060404190841.GR4197@agk.surrey.redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Persistent snapshots currently store a private copy of the chunk size.
Userspace also supplies the chunk size when loading a snapshot.
Ensure consistency by only storing the chunk_size in one place.

[The inconsistency doesn't arise with lvm2 unless you edit the lvm2 
metadata manually and set an incorrect chunk size or overwrite
snapshot metadata with an image containing a different chunk size.]

Alasdair.


Index: linux-2.6.16-rc5/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.16-rc5.orig/drivers/md/dm-snap.c	2006-03-14 18:25:42.000000000 +0000
+++ linux-2.6.16-rc5/drivers/md/dm-snap.c	2006-04-04 20:02:39.000000000 +0100
@@ -530,7 +530,7 @@ static int snapshot_ctr(struct dm_target
 	}
 
 	ti->private = s;
-	ti->split_io = chunk_size;
+	ti->split_io = s->chunk_size;
 
 	return 0;
 
@@ -1203,7 +1203,7 @@ static int origin_status(struct dm_targe
 
 static struct target_type origin_target = {
 	.name    = "snapshot-origin",
-	.version = {1, 1, 0},
+	.version = {1, 1, 1},
 	.module  = THIS_MODULE,
 	.ctr     = origin_ctr,
 	.dtr     = origin_dtr,
@@ -1214,7 +1214,7 @@ static struct target_type origin_target 
 
 static struct target_type snapshot_target = {
 	.name    = "snapshot",
-	.version = {1, 1, 0},
+	.version = {1, 1, 1},
 	.module  = THIS_MODULE,
 	.ctr     = snapshot_ctr,
 	.dtr     = snapshot_dtr,
Index: linux-2.6.16-rc5/drivers/md/dm-exception-store.c
===================================================================
--- linux-2.6.16-rc5.orig/drivers/md/dm-exception-store.c	2006-02-27 05:09:35.000000000 +0000
+++ linux-2.6.16-rc5/drivers/md/dm-exception-store.c	2006-04-04 19:28:18.000000000 +0100
@@ -91,7 +91,6 @@ struct pstore {
 	struct dm_snapshot *snap;	/* up pointer to my snapshot */
 	int version;
 	int valid;
-	uint32_t chunk_size;
 	uint32_t exceptions_per_area;
 
 	/*
@@ -133,7 +132,7 @@ static int alloc_area(struct pstore *ps)
 	int r = -ENOMEM;
 	size_t len;
 
-	len = ps->chunk_size << SECTOR_SHIFT;
+	len = ps->snap->chunk_size << SECTOR_SHIFT;
 
 	/*
 	 * Allocate the chunk_size block of memory that will hold
@@ -160,8 +159,8 @@ static int chunk_io(struct pstore *ps, u
 	unsigned long bits;
 
 	where.bdev = ps->snap->cow->bdev;
-	where.sector = ps->chunk_size * chunk;
-	where.count = ps->chunk_size;
+	where.sector = ps->snap->chunk_size * chunk;
+	where.count = ps->snap->chunk_size;
 
 	return dm_io_sync_vm(1, &where, rw, ps->area, &bits);
 }
@@ -188,7 +187,7 @@ static int area_io(struct pstore *ps, ui
 
 static int zero_area(struct pstore *ps, uint32_t area)
 {
-	memset(ps->area, 0, ps->chunk_size << SECTOR_SHIFT);
+	memset(ps->area, 0, ps->snap->chunk_size << SECTOR_SHIFT);
 	return area_io(ps, area, WRITE);
 }
 
@@ -196,6 +195,7 @@ static int read_header(struct pstore *ps
 {
 	int r;
 	struct disk_header *dh;
+	chunk_t chunk_size;
 
 	r = chunk_io(ps, 0, READ);
 	if (r)
@@ -210,8 +210,22 @@ static int read_header(struct pstore *ps
 		*new_snapshot = 0;
 		ps->valid = le32_to_cpu(dh->valid);
 		ps->version = le32_to_cpu(dh->version);
-		ps->chunk_size = le32_to_cpu(dh->chunk_size);
-
+		chunk_size = le32_to_cpu(dh->chunk_size);
+		if (ps->snap->chunk_size != chunk_size) {
+			DMWARN("chunk size %llu in device metadata overrides "
+			       "table chunk size of %llu.",
+			       (unsigned long long)chunk_size,
+			       (unsigned long long)ps->snap->chunk_size);
+			dm_io_put(sectors_to_pages(ps->snap->chunk_size));
+
+			ps->snap->chunk_size = chunk_size;
+			ps->snap->chunk_mask = chunk_size - 1;
+			ps->snap->chunk_shift = ffs(chunk_size) - 1;
+
+			r = dm_io_get(sectors_to_pages(chunk_size));
+			if (r)
+				return r;
+		}
 	} else {
 		DMWARN("Invalid/corrupt snapshot");
 		r = -ENXIO;
@@ -224,13 +238,13 @@ static int write_header(struct pstore *p
 {
 	struct disk_header *dh;
 
-	memset(ps->area, 0, ps->chunk_size << SECTOR_SHIFT);
+	memset(ps->area, 0, ps->snap->chunk_size << SECTOR_SHIFT);
 
 	dh = (struct disk_header *) ps->area;
 	dh->magic = cpu_to_le32(SNAP_MAGIC);
 	dh->valid = cpu_to_le32(ps->valid);
 	dh->version = cpu_to_le32(ps->version);
-	dh->chunk_size = cpu_to_le32(ps->chunk_size);
+	dh->chunk_size = cpu_to_le32(ps->snap->chunk_size);
 
 	return chunk_io(ps, 0, WRITE);
 }
@@ -365,7 +379,7 @@ static void persistent_destroy(struct ex
 {
 	struct pstore *ps = get_info(store);
 
-	dm_io_put(sectors_to_pages(ps->chunk_size));
+	dm_io_put(sectors_to_pages(ps->snap->chunk_size));
 	vfree(ps->callbacks);
 	free_area(ps);
 	kfree(ps);
@@ -533,7 +547,6 @@ int dm_create_persistent(struct exceptio
 	ps->snap = store->snap;
 	ps->valid = 1;
 	ps->version = SNAPSHOT_DISK_VERSION;
-	ps->chunk_size = chunk_size;
 	ps->exceptions_per_area = (chunk_size << SECTOR_SHIFT) /
 	    sizeof(struct disk_exception);
 	ps->next_free = 2;	/* skipping the header and first area */
