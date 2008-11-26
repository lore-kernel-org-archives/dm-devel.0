From: Takahiro Yasui <tyasui@redhat.com>
Subject: [RFC][PATCH 3/4] dm-log: support multiple log devices
Date: Tue, 25 Nov 2008 19:01:41 -0500
Message-ID: <492C91E5.1070801@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
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
Cc: Alasdair G Kergon <agk@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>
List-Id: dm-devel.ids

This patch introduces multiple log devices feature.

 * "log" member is added into log context to keep a device status and
   device info.

 * read_headers function reads log data from each log devices and check
   if they contain the same header values.

 * write_headers issues write I/O to all active log devices at the same
   time and check each result when all I/Os complete.

 * add parse_params to search "region size" in the parameter list.


Signed-off-by: Takahiro Yasui <tyasui@redhat.com>
---
 drivers/md/dm-log.c |  579 +++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 416 insertions(+), 163 deletions(-)

Index: linux-2.6.28-rc4/drivers/md/dm-log.c
===================================================================
--- linux-2.6.28-rc4.orig/drivers/md/dm-log.c
+++ linux-2.6.28-rc4/drivers/md/dm-log.c
@@ -249,6 +249,15 @@ struct log_header {
 	sector_t nr_regions;
 };
 
+struct log {
+	struct log_c *lc;
+	int failed;
+
+	struct dm_dev *dev;
+	struct log_header header;
+	struct dm_io_region header_location;
+};
+
 struct log_c {
 	struct dm_target *ti;
 	int touched;
@@ -270,17 +279,19 @@ struct log_c {
 		FORCESYNC,	/* Force a sync to happen */
 	} sync;
 
-	struct dm_io_request io_req;
-
 	/*
 	 * Disk log fields
 	 */
-	int log_dev_failed;
-	struct dm_dev *log_dev;
-	struct log_header header;
+	unsigned int nr_logs;
 
-	struct dm_io_region header_location;
 	struct log_header *disk_header;
+	struct dm_io_request io_req;
+
+	unsigned int nr_active_logs;
+	struct dm_io_region *io_regions;
+	struct log **io_logs;	/* index log array of io_regions */
+
+	struct log log[0];
 };
 
 /*
@@ -323,72 +334,236 @@ static void header_from_disk(struct log_
 	core->nr_regions = le64_to_cpu(disk->nr_regions);
 }
 
-static int read_header(struct log_c *log)
+static void update_io_regions(struct log_c *lc)
+{
+	struct log *l;
+	int count = 0;
+
+	for (l = lc->log; l < lc->log + lc->nr_logs; l++) {
+		if (l->failed)
+			continue;
+
+		lc->io_regions[count] = l->header_location;
+		lc->io_logs[count] = l;
+		count++;
+	}
+
+	lc->nr_active_logs = count;
+}
+
+static void fail_log_device(struct log *l)
+{
+	if (l->failed)
+		return;
+
+	l->failed = 1;
+	dm_table_event(l->lc->ti->table);
+}
+
+static void fail_all_devices(struct log_c *lc)
 {
+	struct log *l;
+
+	for (l = lc->log; l < lc->log + lc->nr_logs; l++)
+		l->failed = 1;
+
+	lc->nr_active_logs = 0;
+	dm_table_event(lc->ti->table);
+}
+
+static int read_header(struct log *l)
+{
+	struct log_c *lc = l->lc;
 	int r;
 
-	log->io_req.bi_rw = READ;
+	lc->io_req.bi_rw = READ;
 
-	r = dm_io(&log->io_req, 1, &log->header_location, NULL);
-	if (r)
+	r = dm_io(&lc->io_req, 1, &l->header_location, NULL);
+	if (r) {
+		DMWARN("Failed to read header on ditry "
+		       "region log device, %s", l->dev->name);
+		fail_log_device(l);
 		return r;
+	}
 
-	header_from_disk(&log->header, log->disk_header);
+	header_from_disk(&l->header, lc->disk_header);
 
 	/* New log required? */
-	if (log->sync != DEFAULTSYNC || log->header.magic != MIRROR_MAGIC) {
-		log->header.magic = MIRROR_MAGIC;
-		log->header.version = MIRROR_DISK_VERSION;
-		log->header.nr_regions = 0;
+	if (lc->sync != DEFAULTSYNC || l->header.magic != MIRROR_MAGIC) {
+		l->header.magic = MIRROR_MAGIC;
+		l->header.version = MIRROR_DISK_VERSION;
+		l->header.nr_regions = 0;
 	}
 
 #ifdef __LITTLE_ENDIAN
-	if (log->header.version == 1)
-		log->header.version = 2;
+	if (l->header.version == 1)
+		l->header.version = 2;
 #endif
 
-	if (log->header.version != MIRROR_DISK_VERSION) {
+	if (l->header.version != MIRROR_DISK_VERSION) {
 		DMWARN("incompatible disk log version");
+		fail_log_device(l);
 		return -EINVAL;
 	}
 
 	return 0;
 }
 
-static inline int write_header(struct log_c *log)
+/*
+ * read_headers
+ *
+ *   Issue read I/Os sequentially and check their contents.
+ *
+ *   return value:
+ *     nr_regions ... the number of region stored on log disks
+ *     -EIO       ... all read I/Os failed and no active log exists
+ *     -EINVAL    ... header data are not consistent among logs
+ */
+static int read_headers(struct log_c *lc)
 {
-	log->io_req.bi_rw = WRITE;
-	return dm_io(&log->io_req, 1, &log->header_location, NULL);
+	struct log *l;
+	sector_t nr_regions = 0;
+	int active_logs = 0;
+
+	/*
+	 * read all log headers
+	 *
+	 * Read shoud be done sequentially, since one buffer is
+	 * shared by all logs.
+	 */
+	for (l = lc->log; l < lc->log + lc->nr_logs; l++)
+		if (!l->failed && !read_header(l))
+			active_logs++;
+
+	if (!active_logs) {
+		DMWARN("All read I/Os to log disks failed.\n");
+		fail_all_devices(lc);
+		return -EIO;
+	}
+
+	/*
+	 * check consistency of log headers
+	 */
+	for (l = lc->log; l < lc->log + lc->nr_logs; l++) {
+		if (l->failed || !l->header.nr_regions)
+			continue;
+
+		if (!nr_regions) {
+			nr_regions = l->header.nr_regions;
+			continue;
+		}
+
+		if (l->header.nr_regions != nr_regions) {
+			DMWARN("log %s has inconsistent region counts %ld"
+			       " (expected %ld)", l->dev->name,
+			       l->header.nr_regions, nr_regions);
+			fail_all_devices(lc);
+			return -EINVAL;
+		}
+	}
+
+	/*
+	 * Refresh log contents, since current data might contain
+	 * data on a new log disk which does not have valid log data.
+	 */
+	if (active_logs > 1) {
+		for (l = lc->log; l < lc->log + lc->nr_logs; l++) {
+			if (l->failed || !l->header.nr_regions)
+				continue;
+			if (!read_header(l))
+				break;
+		}
+
+		if (unlikely(l == lc->log + lc->nr_logs))
+			nr_regions = 0;
+
+		/* initialize new log headers */
+		for (l = lc->log; l < lc->log + lc->nr_logs; l++)
+			if (!l->failed)
+				l->header.nr_regions = nr_regions;
+	}
+
+	update_io_regions(lc);
+
+	return nr_regions;
 }
 
-/*----------------------------------------------------------------
- * core log constructor/destructor
+/*
+ * write_headers
  *
- * argv contains region_size followed optionally by [no]sync
- *--------------------------------------------------------------*/
+ *   Issue write I/Os to all active logs and return 0 if at lease
+ *   one log has scceeded its I/O, othersize (no active logs)
+ *   returns a return value of dm_io function.
+ */
+static int write_headers(struct log_c *lc)
+{
+	unsigned long error;
+	int i, r;
+
+	lc->io_req.bi_rw = WRITE;
+
+	r = dm_io(&lc->io_req, lc->nr_active_logs, lc->io_regions,
+		  &error);
+	if (r) {
+		/* check error devices and disable them */
+		for (i = 0; i < lc->nr_active_logs; i++)
+			if (test_bit(i, &error))
+				fail_log_device(lc->io_logs[i]);
+
+		update_io_regions(lc);
+
+		if (!lc->nr_active_logs)
+			return r;
+	}
+
+	return 0;
+}
+
 #define BYTE_SHIFT 3
-static int create_log_context(struct dm_dirty_log *log, struct dm_target *ti,
-			      unsigned int argc, char **argv,
-			      struct dm_dev *dev)
+static inline size_t log_bitset_size(struct log_c *lc)
 {
-	enum sync sync = DEFAULTSYNC;
+	return dm_round_up(lc->region_count,
+			   sizeof(*lc->clean_bits) << BYTE_SHIFT)
+		>> BYTE_SHIFT;
+}
 
-	struct log_c *lc;
-	uint32_t region_size;
-	unsigned int region_count;
-	size_t bitset_size, buf_size;
-	int r;
+static size_t log_buffer_size(struct log_c *lc)
+{
+	/* Buffer holds both header and bitset. */
+	return dm_round_up((LOG_OFFSET << SECTOR_SHIFT) +
+			   log_bitset_size(lc),
+			   lc->ti->limits.hardsect_size);
+}
 
+static int parse_params(unsigned int argc, char **argv,
+			uint32_t *region_size, enum sync *sync)
+{
+	/*
+	 * check number of parameters
+	 */
 	if (argc < 1 || argc > 2) {
 		DMWARN("wrong number of arguments to dirty region log");
 		return -EINVAL;
 	}
 
+	/*
+	 * get region size
+	 */
+	if (sscanf(argv[0], "%u", region_size) != 1) {
+		DMWARN("invalid region size string to dirty region log");
+		return -EINVAL;
+	}
+
+	/*
+	 * get sync option
+	 */
+	*sync = DEFAULTSYNC;
+
 	if (argc > 1) {
 		if (!strcmp(argv[1], "sync"))
-			sync = FORCESYNC;
+			*sync = FORCESYNC;
 		else if (!strcmp(argv[1], "nosync"))
-			sync = NOSYNC;
+			*sync = NOSYNC;
 		else {
 			DMWARN("unrecognised sync argument to "
 			       "dirty region log: %s", argv[1]);
@@ -396,113 +571,180 @@ static int create_log_context(struct dm_
 		}
 	}
 
-	if (sscanf(argv[0], "%u", &region_size) != 1) {
-		DMWARN("invalid region size string");
-		return -EINVAL;
-	}
+	return 0;
+}
 
-	region_count = dm_sector_div_up(ti->len, region_size);
+static struct log_c *create_log_context(struct dm_target *ti,
+					unsigned int nr_logs,
+					uint32_t region_size,
+					enum sync sync)
+{
+	struct log_c *lc;
+	size_t len;
+
+	len = sizeof(*lc) + sizeof(lc->log[0]) * nr_logs;
 
-	lc = kmalloc(sizeof(*lc), GFP_KERNEL);
+	lc = kzalloc(len, GFP_KERNEL);
 	if (!lc) {
-		DMWARN("couldn't allocate core log");
-		return -ENOMEM;
+		DMWARN("couldn't allocate log context");
+		return NULL;
 	}
 
 	lc->ti = ti;
 	lc->touched = 0;
 	lc->region_size = region_size;
-	lc->region_count = region_count;
+	lc->region_count = dm_sector_div_up(ti->len, region_size);
+
 	lc->sync = sync;
+	lc->nr_logs = nr_logs;
+
+	return lc;
+}
+
+static void destroy_log_context(struct log_c *lc)
+{
+	vfree(lc->recovering_bits);
+	vfree(lc->sync_bits);
+	vfree(lc->clean_bits);
+	kfree(lc);
+}
+
+static void destroy_log_devices(struct log_c *lc)
+{
+	struct log *l;
+
+	kfree(lc->io_logs);
+	kfree(lc->io_regions);
+
+	if (lc->io_req.client)
+		dm_io_client_destroy(lc->io_req.client);
+
+	vfree(lc->disk_header);
+	lc->clean_bits = NULL;
+
+	for (l = lc->log; l < lc->log + lc->nr_logs; l++)
+		dm_put_device(l->lc->ti, l->dev);
+}
+
+static int create_log_devices(struct log_c *lc, char **dev)
+{
+	struct log *l;
+	size_t buf_size = 0;
+	int r;
 
 	/*
-	 * Work out how many "unsigned long"s we need to hold the bitset.
+	 * setup each log device
+	 */
+	for (l = lc->log; l < lc->log + lc->nr_logs; l++, dev++) {
+		r = dm_get_device(lc->ti, dev[0], 0, 0 /* FIXME */,
+				  FMODE_READ | FMODE_WRITE, &l->dev);
+		if (r) {
+			lc->ti->error = "Device lookup failure";
+
+			while (--l >= lc->log)
+				dm_put_device(l->lc->ti, l->dev);
+
+			return r;
+		}
+
+		if (!buf_size)
+			buf_size = log_buffer_size(lc);
+
+		l->lc = lc;
+		l->failed = 0;
+
+		l->header.magic = 0;
+		l->header.version = 0;
+		l->header.nr_regions = 0;
+
+		l->header_location.bdev = l->dev->bdev;
+		l->header_location.sector = 0;
+		l->header_location.count = buf_size >> SECTOR_SHIFT;
+	}
+
+	/*
+	 * setup common info
 	 */
-	bitset_size = dm_round_up(region_count,
-				  sizeof(*lc->clean_bits) << BYTE_SHIFT);
-	bitset_size >>= BYTE_SHIFT;
+	lc->nr_active_logs = lc->nr_logs;
+
+	lc->disk_header = vmalloc(buf_size);
+	if (!lc->disk_header) {
+		DMWARN("couldn't allocate disk log buffer");
+		destroy_log_devices(lc);
+		return -ENOMEM;
+	}
+
+	lc->io_req.mem.type = DM_IO_VMA;
+	lc->io_req.mem.ptr.vma = lc->disk_header;
+	lc->io_req.notify.fn = NULL;
+	lc->io_req.client = dm_io_client_create(dm_div_up(buf_size,
+							  PAGE_SIZE));
+	if (IS_ERR(lc->io_req.client)) {
+		r = PTR_ERR(lc->io_req.client);
+		DMWARN("couldn't allocate disk io client");
+		destroy_log_devices(lc);
+		return -ENOMEM;
+	}
+
+	lc->io_regions = kmalloc(sizeof(*lc->io_regions) * lc->nr_logs,
+				 GFP_KERNEL);
+	if (!lc->io_regions) {
+		DMWARN("couldn't allocate I/O regions");
+		destroy_log_devices(lc);
+		return -ENOMEM;
+	}
 
+	lc->io_logs = kmalloc(sizeof(*lc->io_logs) * lc->nr_logs,
+			      GFP_KERNEL);
+	if (!lc->io_logs) {
+		DMWARN("couldn't allocate I/O region index log array");
+		destroy_log_devices(lc);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static int setup_log_bitmaps(struct log_c *lc)
+{
+	size_t bitset_size;
+
+	/*
+	 * Work out how many "unsigned long"s we need to hold the bitset.
+	 */
+	bitset_size = log_bitset_size(lc);
 	lc->bitset_uint32_count = bitset_size / sizeof(*lc->clean_bits);
 
 	/*
 	 * Disk log?
 	 */
-	if (!dev) {
+	if (!lc->nr_logs) {
 		lc->clean_bits = vmalloc(bitset_size);
 		if (!lc->clean_bits) {
 			DMWARN("couldn't allocate clean bitset");
-			kfree(lc);
-			return -ENOMEM;
-		}
-		lc->disk_header = NULL;
-	} else {
-		lc->log_dev = dev;
-		lc->log_dev_failed = 0;
-		lc->header_location.bdev = lc->log_dev->bdev;
-		lc->header_location.sector = 0;
-
-		/*
-		 * Buffer holds both header and bitset.
-		 */
-		buf_size = dm_round_up((LOG_OFFSET << SECTOR_SHIFT) +
-				       bitset_size, ti->limits.hardsect_size);
-		lc->header_location.count = buf_size >> SECTOR_SHIFT;
-
-		lc->io_req.mem.type = DM_IO_VMA;
-		lc->io_req.mem.ptr.vma = lc->disk_header;
-		lc->io_req.notify.fn = NULL;
-		lc->io_req.client = dm_io_client_create(dm_div_up(buf_size,
-								   PAGE_SIZE));
-		if (IS_ERR(lc->io_req.client)) {
-			r = PTR_ERR(lc->io_req.client);
-			DMWARN("couldn't allocate disk io client");
-			kfree(lc);
 			return -ENOMEM;
 		}
-
-		lc->disk_header = vmalloc(buf_size);
-		if (!lc->disk_header) {
-			DMWARN("couldn't allocate disk log buffer");
-			dm_io_client_destroy(lc->io_req.client);
-			kfree(lc);
-			return -ENOMEM;
-		}
-
+	} else
 		lc->clean_bits = (void *)lc->disk_header +
 				 (LOG_OFFSET << SECTOR_SHIFT);
-	}
 
 	memset(lc->clean_bits, -1, bitset_size);
 
 	lc->sync_bits = vmalloc(bitset_size);
 	if (!lc->sync_bits) {
 		DMWARN("couldn't allocate sync bitset");
-		if (!dev)
-			vfree(lc->clean_bits);
-		vfree(lc->disk_header);
-		if (dev)
-			dm_io_client_destroy(lc->io_req.client);
-		kfree(lc);
 		return -ENOMEM;
 	}
-	memset(lc->sync_bits, (sync == NOSYNC) ? -1 : 0, bitset_size);
-	lc->sync_count = (sync == NOSYNC) ? region_count : 0;
+	memset(lc->sync_bits, (lc->sync == NOSYNC) ? -1 : 0, bitset_size);
+	lc->sync_count = (lc->sync == NOSYNC) ? lc->region_count : 0;
 
 	lc->recovering_bits = vmalloc(bitset_size);
 	if (!lc->recovering_bits) {
 		DMWARN("couldn't allocate sync bitset");
-		vfree(lc->sync_bits);
-		if (!dev)
-			vfree(lc->clean_bits);
-		vfree(lc->disk_header);
-		if (dev)
-			dm_io_client_destroy(lc->io_req.client);
-		kfree(lc);
 		return -ENOMEM;
 	}
 	memset(lc->recovering_bits, 0, bitset_size);
 	lc->sync_search = 0;
-	log->context = lc;
 
 	return 0;
 }
@@ -510,51 +752,78 @@ static int create_log_context(struct dm_
 static int core_ctr(struct dm_dirty_log *log, struct dm_target *ti,
 		    unsigned int argc, char **argv)
 {
-	return create_log_context(log, ti, argc, argv, NULL);
-}
+	struct log_c *lc;
+	uint32_t region_size;
+	enum sync sync;
+	int r;
 
-static void destroy_log_context(struct log_c *lc)
-{
-	vfree(lc->sync_bits);
-	vfree(lc->recovering_bits);
-	kfree(lc);
+	r = parse_params(argc, argv, &region_size, &sync);
+	if (r)
+		return r;
+
+	lc = create_log_context(ti, 0, region_size, sync);
+	if (!lc)
+		return -ENOMEM;
+
+	r = setup_log_bitmaps(lc);
+	if (r) {
+		destroy_log_context(lc);
+		return r;
+	}
+
+	log->context = lc;
+
+	return 0;
 }
 
 static void core_dtr(struct dm_dirty_log *log)
 {
 	struct log_c *lc = (struct log_c *) log->context;
 
-	vfree(lc->clean_bits);
 	destroy_log_context(lc);
 }
 
 /*----------------------------------------------------------------
- * disk log constructor/destructor
+ * disks log constructor/destructor
  *
  * argv contains log_device region_size followed optionally by [no]sync
  *--------------------------------------------------------------*/
 static int disk_ctr(struct dm_dirty_log *log, struct dm_target *ti,
 		    unsigned int argc, char **argv)
 {
+	struct log_c *lc;
+	uint32_t region_size;
+	enum sync sync;
 	int r;
-	struct dm_dev *dev;
 
-	if (argc < 2 || argc > 3) {
-		DMWARN("wrong number of arguments to disk dirty region log");
+	if (!argc) {
+		DMWARN("wrong number of arguments to dirty region log");
 		return -EINVAL;
 	}
 
-	r = dm_get_device(ti, argv[0], 0, 0 /* FIXME */,
-			  FMODE_READ | FMODE_WRITE, &dev);
+	r = parse_params(argc-1, argv+1, &region_size, &sync);
 	if (r)
 		return r;
 
-	r = create_log_context(log, ti, argc - 1, argv + 1, dev);
+	lc = create_log_context(ti, 1, region_size, sync);
+	if (!lc)
+		return -ENOMEM;
+
+	r = create_log_devices(lc, argv);
+	if (r) {
+		destroy_log_context(lc);
+		return r;
+	}
+
+	r = setup_log_bitmaps(lc);
 	if (r) {
-		dm_put_device(ti, dev);
+		destroy_log_devices(lc);
+		destroy_log_context(lc);
 		return r;
 	}
 
+	log->context = lc;
+
 	return 0;
 }
 
@@ -562,9 +831,7 @@ static void disk_dtr(struct dm_dirty_log
 {
 	struct log_c *lc = (struct log_c *) log->context;
 
-	dm_put_device(lc->ti, lc->log_dev);
-	vfree(lc->disk_header);
-	dm_io_client_destroy(lc->io_req.client);
+	destroy_log_devices(lc);
 	destroy_log_context(lc);
 }
 
@@ -578,45 +845,31 @@ static int count_bits32(uint32_t *addr, 
 	return count;
 }
 
-static void fail_log_device(struct log_c *lc)
-{
-	if (lc->log_dev_failed)
-		return;
-
-	lc->log_dev_failed = 1;
-	dm_table_event(lc->ti->table);
-}
-
 static int disk_resume(struct dm_dirty_log *log)
 {
-	int r;
+	int r = 0;
 	unsigned i;
 	struct log_c *lc = (struct log_c *) log->context;
+	struct log *l;
 	size_t size = lc->bitset_uint32_count * sizeof(uint32_t);
+	unsigned int nr_regions = 0;
 
-	/* read the disk header */
-	r = read_header(lc);
-	if (r) {
-		DMWARN("%s: Failed to read header on dirty region log device",
-		       lc->log_dev->name);
-		fail_log_device(lc);
-		/*
-		 * If the log device cannot be read, we must assume
-		 * all regions are out-of-sync.  If we simply return
-		 * here, the state will be uninitialized and could
-		 * lead us to return 'in-sync' status for regions
-		 * that are actually 'out-of-sync'.
-		 */
-		lc->header.nr_regions = 0;
+	if (lc->nr_active_logs) {
+		r = read_headers(lc);
+		if (r < 0) {
+			DMWARN("Failed to read dirty region log");
+			nr_regions = 0;
+		} else
+			nr_regions = r;
 	}
 
 	/* set or clear any new bits -- device has grown */
 	if (lc->sync == NOSYNC)
-		for (i = lc->header.nr_regions; i < lc->region_count; i++)
+		for (i = nr_regions; i < lc->region_count; i++)
 			/* FIXME: amazingly inefficient */
 			log_set_bit(lc, lc->clean_bits, i);
 	else
-		for (i = lc->header.nr_regions; i < lc->region_count; i++)
+		for (i = nr_regions; i < lc->region_count; i++)
 			/* FIXME: amazingly inefficient */
 			log_clear_bit(lc, lc->clean_bits, i);
 
@@ -630,17 +883,17 @@ static int disk_resume(struct dm_dirty_l
 	lc->sync_search = 0;
 
 	/* set the correct number of regions in the header */
-	lc->header.nr_regions = lc->region_count;
-
-	/* update disk headers */
-	header_to_disk(&lc->header, lc->disk_header);
+	for (l = lc->log; l < lc->log + lc->nr_logs; l++)
+		l->header.nr_regions = lc->region_count;
 
-	/* write the new header */
-	r = write_header(lc);
-	if (r) {
-		DMWARN("%s: Failed to write header on dirty region log device",
-		       lc->log_dev->name);
-		fail_log_device(lc);
+	if (lc->nr_active_logs) {
+		/* update disk headers */
+		header_to_disk(&lc->io_logs[0]->header, lc->disk_header);
+
+		/* write the new header */
+		r = write_headers(lc);
+		if (r)
+			DMWARN("Failed to write dirty region log");
 	}
 
 	return r;
@@ -683,12 +936,12 @@ static int disk_flush(struct dm_dirty_lo
 	struct log_c *lc = (struct log_c *) log->context;
 
 	/* only write if the log has changed */
-	if (!lc->touched)
+	if (!lc->touched || !lc->nr_active_logs)
 		return 0;
 
-	r = write_header(lc);
+	r = write_headers(lc);
 	if (r)
-		fail_log_device(lc);
+		DMWARN("Failed to write dirty region log");
 	else
 		lc->touched = 0;
 
@@ -784,13 +1037,13 @@ static int disk_status(struct dm_dirty_l
 
 	switch(status) {
 	case STATUSTYPE_INFO:
-		DMEMIT("3 %s %s %c", log->type->name, lc->log_dev->name,
-		       lc->log_dev_failed ? 'D' : 'A');
+		DMEMIT("3 %s %s %c", log->type->name, lc->log[0].dev->name,
+		       lc->log[0].failed ? 'D' : 'A');
 		break;
 
 	case STATUSTYPE_TABLE:
 		DMEMIT("%s %u %s %u ", log->type->name,
-		       lc->sync == DEFAULTSYNC ? 2 : 3, lc->log_dev->name,
+		       lc->sync == DEFAULTSYNC ? 2 : 3, lc->log[0].dev->name,
 		       lc->region_size);
 		DMEMIT_SYNC;
 	}
