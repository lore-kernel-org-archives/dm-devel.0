From: Heinz Mauelshagen <hjm@redhat.com>
Subject: [RFC PATCH 1/6] dm headers(2nd): change name of "struct
	io_region" to "struct dm_io_region" in dm-io.h to prepare for
	move of the header to include/linux and adjust callers.
Date: Thu,  6 Mar 2008 14:11:40 +0100
Message-ID: <1204809105-22360-2-git-send-email-hjm@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
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
Cc: Heinz Mauelshagen <hjm@redhat.com>
List-Id: dm-devel.ids

---
 drivers/md/dm-exception-store.c |    4 ++--
 drivers/md/dm-io.c              |   10 +++++-----
 drivers/md/dm-io.h              |    7 +++++--
 drivers/md/dm-log.c             |    2 +-
 drivers/md/dm-raid1.c           |    8 ++++----
 drivers/md/dm-snap.c            |    2 +-
 drivers/md/kcopyd.c             |    8 ++++----
 drivers/md/kcopyd.h             |    4 ++--
 8 files changed, 24 insertions(+), 21 deletions(-)

diff --git linux-2.6.25-rc4.orig/drivers/md/dm-exception-store.c linux-2.6.25-rc4/drivers/md/dm-exception-store.c
index 5bbce29..b8e210e 100644
--- linux-2.6.25-rc4.orig/drivers/md/dm-exception-store.c
+++ linux-2.6.25-rc4/drivers/md/dm-exception-store.c
@@ -159,7 +159,7 @@ static void free_area(struct pstore *ps)
 }
 
 struct mdata_req {
-	struct io_region *where;
+	struct dm_io_region *where;
 	struct dm_io_request *io_req;
 	struct work_struct work;
 	int result;
@@ -177,7 +177,7 @@ static void do_metadata(struct work_struct *work)
  */
 static int chunk_io(struct pstore *ps, uint32_t chunk, int rw, int metadata)
 {
-	struct io_region where = {
+	struct dm_io_region where = {
 		.bdev = ps->snap->cow->bdev,
 		.sector = ps->snap->chunk_size * chunk,
 		.count = ps->snap->chunk_size,
diff --git linux-2.6.25-rc4.orig/drivers/md/dm-io.c linux-2.6.25-rc4/drivers/md/dm-io.c
index b8e342f..fa9f4e6 100644
--- linux-2.6.25-rc4.orig/drivers/md/dm-io.c
+++ linux-2.6.25-rc4/drivers/md/dm-io.c
@@ -271,7 +271,7 @@ static void km_dp_init(struct dpages *dp, void *data)
 /*-----------------------------------------------------------------
  * IO routines that accept a list of pages.
  *---------------------------------------------------------------*/
-static void do_region(int rw, unsigned int region, struct io_region *where,
+static void do_region(int rw, unsigned int region, struct dm_io_region *where,
 		      struct dpages *dp, struct io *io)
 {
 	struct bio *bio;
@@ -320,7 +320,7 @@ static void do_region(int rw, unsigned int region, struct io_region *where,
 }
 
 static void dispatch_io(int rw, unsigned int num_regions,
-			struct io_region *where, struct dpages *dp,
+			struct dm_io_region *where, struct dpages *dp,
 			struct io *io, int sync)
 {
 	int i;
@@ -347,7 +347,7 @@ static void dispatch_io(int rw, unsigned int num_regions,
 }
 
 static int sync_io(struct dm_io_client *client, unsigned int num_regions,
-		   struct io_region *where, int rw, struct dpages *dp,
+		   struct dm_io_region *where, int rw, struct dpages *dp,
 		   unsigned long *error_bits)
 {
 	struct io io;
@@ -384,7 +384,7 @@ static int sync_io(struct dm_io_client *client, unsigned int num_regions,
 }
 
 static int async_io(struct dm_io_client *client, unsigned int num_regions,
-		    struct io_region *where, int rw, struct dpages *dp,
+		    struct dm_io_region *where, int rw, struct dpages *dp,
 		    io_notify_fn fn, void *context)
 {
 	struct io *io;
@@ -438,7 +438,7 @@ static int dp_init(struct dm_io_request *io_req, struct dpages *dp)
  * New collapsed (a)synchronous interface
  */
 int dm_io(struct dm_io_request *io_req, unsigned num_regions,
-	  struct io_region *where, unsigned long *sync_error_bits)
+	  struct dm_io_region *where, unsigned long *sync_error_bits)
 {
 	int r;
 	struct dpages dp;
diff --git linux-2.6.25-rc4.orig/drivers/md/dm-io.h linux-2.6.25-rc4/drivers/md/dm-io.h
index f647e2c..765c85c 100644
--- linux-2.6.25-rc4.orig/drivers/md/dm-io.h
+++ linux-2.6.25-rc4/drivers/md/dm-io.h
@@ -1,5 +1,8 @@
 /*
  * Copyright (C) 2003 Sistina Software
+ * Copyright (C) 2004-2008 Red Hat GmbH
+ *
+ * Device-Mapper low-level I/O.
  *
  * This file is released under the GPL.
  */
@@ -9,7 +12,7 @@
 
 #include "dm.h"
 
-struct io_region {
+struct dm_io_region {
 	struct block_device *bdev;
 	sector_t sector;
 	sector_t count;		/* If this is zero the region is ignored. */
@@ -74,6 +77,6 @@ void dm_io_client_destroy(struct dm_io_client *client);
  * error occurred doing io to the corresponding region.
  */
 int dm_io(struct dm_io_request *io_req, unsigned num_regions,
-	  struct io_region *region, unsigned long *sync_error_bits);
+	  struct dm_io_region *region, unsigned long *sync_error_bits);
 
 #endif
diff --git linux-2.6.25-rc4.orig/drivers/md/dm-log.c linux-2.6.25-rc4/drivers/md/dm-log.c
index 2d3762e..ec73b34 100644
--- linux-2.6.25-rc4.orig/drivers/md/dm-log.c
+++ linux-2.6.25-rc4/drivers/md/dm-log.c
@@ -208,7 +208,7 @@ struct log_c {
 	struct dm_dev *log_dev;
 	struct log_header header;
 
-	struct io_region header_location;
+	struct dm_io_region header_location;
 	struct log_header *disk_header;
 };
 
diff --git linux-2.6.25-rc4.orig/drivers/md/dm-raid1.c linux-2.6.25-rc4/drivers/md/dm-raid1.c
index 37afe35..b594dee 100644
--- linux-2.6.25-rc4.orig/drivers/md/dm-raid1.c
+++ linux-2.6.25-rc4/drivers/md/dm-raid1.c
@@ -790,7 +790,7 @@ static int recover(struct mirror_set *ms, struct region *reg)
 {
 	int r;
 	unsigned int i;
-	struct io_region from, to[KCOPYD_MAX_REGIONS], *dest;
+	struct dm_io_region from, to[KCOPYD_MAX_REGIONS], *dest;
 	struct mirror *m;
 	unsigned long flags = 0;
 
@@ -909,7 +909,7 @@ static void map_bio(struct mirror *m, struct bio *bio)
 	bio->bi_sector = map_sector(m, bio);
 }
 
-static void map_region(struct io_region *io, struct mirror *m,
+static void map_region(struct dm_io_region *io, struct mirror *m,
 		       struct bio *bio)
 {
 	io->bdev = m->dev->bdev;
@@ -951,7 +951,7 @@ static void read_callback(unsigned long error, void *context)
 /* Asynchronous read. */
 static void read_async_bio(struct mirror *m, struct bio *bio)
 {
-	struct io_region io;
+	struct dm_io_region io;
 	struct dm_io_request io_req = {
 		.bi_rw = READ,
 		.mem.type = DM_IO_BVEC,
@@ -1107,7 +1107,7 @@ out:
 static void do_write(struct mirror_set *ms, struct bio *bio)
 {
 	unsigned int i;
-	struct io_region io[ms->nr_mirrors], *dest = io;
+	struct dm_io_region io[ms->nr_mirrors], *dest = io;
 	struct mirror *m;
 	struct dm_io_request io_req = {
 		.bi_rw = WRITE,
diff --git linux-2.6.25-rc4.orig/drivers/md/dm-snap.c linux-2.6.25-rc4/drivers/md/dm-snap.c
index ae24eab..7133ecf 100644
--- linux-2.6.25-rc4.orig/drivers/md/dm-snap.c
+++ linux-2.6.25-rc4/drivers/md/dm-snap.c
@@ -824,7 +824,7 @@ static void copy_callback(int read_err, unsigned int write_err, void *context)
 static void start_copy(struct dm_snap_pending_exception *pe)
 {
 	struct dm_snapshot *s = pe->snap;
-	struct io_region src, dest;
+	struct dm_io_region src, dest;
 	struct block_device *bdev = s->origin->bdev;
 	sector_t dev_size;
 
diff --git linux-2.6.25-rc4.orig/drivers/md/kcopyd.c linux-2.6.25-rc4/drivers/md/kcopyd.c
index f3831f3..bbfd7ce 100644
--- linux-2.6.25-rc4.orig/drivers/md/kcopyd.c
+++ linux-2.6.25-rc4/drivers/md/kcopyd.c
@@ -175,13 +175,13 @@ struct kcopyd_job {
 	 * Either READ or WRITE
 	 */
 	int rw;
-	struct io_region source;
+	struct dm_io_region source;
 
 	/*
 	 * The destinations for the transfer.
 	 */
 	unsigned int num_dests;
-	struct io_region dests[KCOPYD_MAX_REGIONS];
+	struct dm_io_region dests[KCOPYD_MAX_REGIONS];
 
 	sector_t offset;
 	unsigned int nr_pages;
@@ -526,8 +526,8 @@ static void split_job(struct kcopyd_job *job)
 		segment_complete(0, 0u, job);
 }
 
-int kcopyd_copy(struct kcopyd_client *kc, struct io_region *from,
-		unsigned int num_dests, struct io_region *dests,
+int kcopyd_copy(struct kcopyd_client *kc, struct dm_io_region *from,
+		unsigned int num_dests, struct dm_io_region *dests,
 		unsigned int flags, kcopyd_notify_fn fn, void *context)
 {
 	struct kcopyd_job *job;
diff --git linux-2.6.25-rc4.orig/drivers/md/kcopyd.h linux-2.6.25-rc4/drivers/md/kcopyd.h
index 4621ea0..d30a893 100644
--- linux-2.6.25-rc4.orig/drivers/md/kcopyd.h
+++ linux-2.6.25-rc4/drivers/md/kcopyd.h
@@ -35,8 +35,8 @@ void kcopyd_client_destroy(struct kcopyd_client *kc);
 typedef void (*kcopyd_notify_fn)(int read_err,
 				 unsigned int write_err, void *context);
 
-int kcopyd_copy(struct kcopyd_client *kc, struct io_region *from,
-		unsigned int num_dests, struct io_region *dests,
+int kcopyd_copy(struct kcopyd_client *kc, struct dm_io_region *from,
+		unsigned int num_dests, struct dm_io_region *dests,
 		unsigned int flags, kcopyd_notify_fn fn, void *context);
 
 #endif
-- 
1.5.4.1
