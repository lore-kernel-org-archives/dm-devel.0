From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/4] Refactor chunk_io
Date: Mon, 3 Aug 2009 21:39:35 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0908032138450.6002@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0908032135580.6002@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0908032135580.6002@hs20-bc2-1.build.redhat.com>
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

Refactor chunk_io.

Pass an area pointer to chunk_io and simplify zero_disk_area to use chunk_io.
This patch is needed to simplify the following patch, otherwise excessive
code duplication would happen. This patch shouldn't change any functionality.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-snap-persistent.c |   25 ++++++-------------------
 1 file changed, 6 insertions(+), 19 deletions(-)

Index: linux-2.6.31-rc5-devel/drivers/md/dm-snap-persistent.c
===================================================================
--- linux-2.6.31-rc5-devel.orig/drivers/md/dm-snap-persistent.c	2009-08-03 17:32:06.000000000 +0200
+++ linux-2.6.31-rc5-devel/drivers/md/dm-snap-persistent.c	2009-08-03 17:40:29.000000000 +0200
@@ -188,7 +188,7 @@ static void do_metadata(struct work_stru
 /*
  * Read or write a chunk aligned and sized block of data from a device.
  */
-static int chunk_io(struct pstore *ps, chunk_t chunk, int rw, int metadata)
+static int chunk_io(struct pstore *ps, void *area, chunk_t chunk, int rw, int metadata)
 {
 	struct dm_io_region where = {
 		.bdev = ps->store->cow->bdev,
@@ -198,7 +198,7 @@ static int chunk_io(struct pstore *ps, c
 	struct dm_io_request io_req = {
 		.bi_rw = rw,
 		.mem.type = DM_IO_VMA,
-		.mem.ptr.vma = ps->area,
+		.mem.ptr.vma = area,
 		.client = ps->io_client,
 		.notify.fn = NULL,
 	};
@@ -240,7 +240,7 @@ static int area_io(struct pstore *ps, in
 
 	chunk = area_location(ps, ps->current_area);
 
-	r = chunk_io(ps, chunk, rw, 0);
+	r = chunk_io(ps, ps->area, chunk, rw, 0);
 	if (r)
 		return r;
 
@@ -254,20 +254,7 @@ static void zero_memory_area(struct psto
 
 static int zero_disk_area(struct pstore *ps, chunk_t area)
 {
-	struct dm_io_region where = {
-		.bdev = ps->store->cow->bdev,
-		.sector = ps->store->chunk_size * area_location(ps, area),
-		.count = ps->store->chunk_size,
-	};
-	struct dm_io_request io_req = {
-		.bi_rw = WRITE,
-		.mem.type = DM_IO_VMA,
-		.mem.ptr.vma = ps->zero_area,
-		.client = ps->io_client,
-		.notify.fn = NULL,
-	};
-
-	return dm_io(&io_req, 1, &where, NULL);
+	return chunk_io(ps, ps->zero_area, area_location(ps, area), WRITE, 0);
 }
 
 static int read_header(struct pstore *ps, int *new_snapshot)
@@ -297,7 +284,7 @@ static int read_header(struct pstore *ps
 	if (r)
 		return r;
 
-	r = chunk_io(ps, 0, READ, 1);
+	r = chunk_io(ps, ps->area, 0, READ, 1);
 	if (r)
 		goto bad;
 
@@ -359,7 +346,7 @@ static int write_header(struct pstore *p
 	dh->version = cpu_to_le32(ps->version);
 	dh->chunk_size = cpu_to_le32(ps->store->chunk_size);
 
-	return chunk_io(ps, 0, WRITE, 1);
+	return chunk_io(ps, ps->area, 0, WRITE, 1);
 }
 
 /*
