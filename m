From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/4] Use a separate memory area for the header.
Date: Mon, 3 Aug 2009 21:43:15 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0908032139440.6002@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0908032135580.6002@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0908032138450.6002@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0908032138450.6002@hs20-bc2-1.build.redhat.com>
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
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Use a separate memory area for the header.

This patch fixes the racy corruption of on-disk header.
When the snapshot overflows, __invalidate_snapshot is called, which calls
snapshot store method drop_snapshot. It goes to persistent_drop_snapshot that
calls write_header. write_header constructs the new header in the "area"
location.

Concurrently with that, existing kcopyd job may finish, call copy_callback
and commit_exception method, that goes to persistent_commit_exception.
persistent_commit_exception doesn't do locking, relying on the fact that
callbacks are single-threaded, but it can race with snapshot invalidation and
overwrite the header that is just being written while the snapshot is being
invalidated.

The result of this race is a corrupted header being written that can lead to
a crash on further reactivation (if chunk_size is zero in the corrupted header).

See the bug: https://bugzilla.redhat.com/show_bug.cgi?id=461506

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-snap-persistent.c |   42 ++++++++++++++++++++++++++++++----------
 1 file changed, 32 insertions(+), 10 deletions(-)

Index: linux-2.6.31-rc5-devel/drivers/md/dm-snap-persistent.c
===================================================================
--- linux-2.6.31-rc5-devel.orig/drivers/md/dm-snap-persistent.c	2009-08-03 17:40:29.000000000 +0200
+++ linux-2.6.31-rc5-devel/drivers/md/dm-snap-persistent.c	2009-08-03 17:43:28.000000000 +0200
@@ -106,6 +106,13 @@ struct pstore {
 	void *zero_area;
 
 	/*
+	 * An area used for header. The header can be written
+	 * concurrently with metadata (when invalidating the snapshot),
+	 * so it needs a separate buffer.
+	 */
+	void *header_area;
+
+	/*
 	 * Used to keep track of which metadata area the data in
 	 * 'chunk' refers to.
 	 */
@@ -148,16 +155,25 @@ static int alloc_area(struct pstore *ps)
 	 */
 	ps->area = vmalloc(len);
 	if (!ps->area)
-		return r;
+		goto err0;
 
 	ps->zero_area = vmalloc(len);
-	if (!ps->zero_area) {
-		vfree(ps->area);
-		return r;
-	}
+	if (!ps->zero_area)
+		goto err1;
 	memset(ps->zero_area, 0, len);
 
+	ps->header_area = vmalloc(len);
+	if (!ps->header_area)
+		goto err2;
+
 	return 0;
+
+err2:
+	vfree(ps->zero_area);
+err1:
+	vfree(ps->area);
+err0:
+	return r;
 }
 
 static void free_area(struct pstore *ps)
@@ -169,6 +185,10 @@ static void free_area(struct pstore *ps)
 	if (ps->zero_area)
 		vfree(ps->zero_area);
 	ps->zero_area = NULL;
+
+	if (ps->header_area)
+		vfree(ps->header_area);
+	ps->header_area = NULL;
 }
 
 struct mdata_req {
@@ -284,11 +304,11 @@ static int read_header(struct pstore *ps
 	if (r)
 		return r;
 
-	r = chunk_io(ps, ps->area, 0, READ, 1);
+	r = chunk_io(ps, ps->header_area, 0, READ, 1);
 	if (r)
 		goto bad;
 
-	dh = (struct disk_header *) ps->area;
+	dh = (struct disk_header *) ps->header_area;
 
 	if (le32_to_cpu(dh->magic) == 0) {
 		*new_snapshot = 1;
@@ -338,15 +358,15 @@ static int write_header(struct pstore *p
 {
 	struct disk_header *dh;
 
-	memset(ps->area, 0, ps->store->chunk_size << SECTOR_SHIFT);
+	memset(ps->header_area, 0, ps->store->chunk_size << SECTOR_SHIFT);
 
-	dh = (struct disk_header *) ps->area;
+	dh = (struct disk_header *) ps->header_area;
 	dh->magic = cpu_to_le32(SNAP_MAGIC);
 	dh->valid = cpu_to_le32(ps->valid);
 	dh->version = cpu_to_le32(ps->version);
 	dh->chunk_size = cpu_to_le32(ps->store->chunk_size);
 
-	return chunk_io(ps, ps->area, 0, WRITE, 1);
+	return chunk_io(ps, ps->header_area, 0, WRITE, 1);
 }
 
 /*
@@ -666,6 +686,8 @@ static int persistent_ctr(struct dm_exce
 	ps->valid = 1;
 	ps->version = SNAPSHOT_DISK_VERSION;
 	ps->area = NULL;
+	ps->zero_area = NULL;
+	ps->header_area = NULL;
 	ps->next_free = 2;	/* skipping the header and first area */
 	ps->current_committed = 0;
 
