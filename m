From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [patch 5/8] dm-integrity: allow external devices
Date: Tue, 01 May 2018 15:55:21 +0200
Message-ID: <20180501135604.242919780@debian.vm>
References: <20180501135516.961417937@debian.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dm-integrity-separate-device.patch
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

This patch adds a possibility to use external device for metadata for
dm-integrity. It is activated with the option "meta_device:/dev/device".

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-integrity.c |  203 +++++++++++++++++++++++++++++++++-------------
 1 file changed, 149 insertions(+), 54 deletions(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2018-05-01 04:35:08.000000000 +0200
+++ linux-2.6/drivers/md/dm-integrity.c	2018-05-01 04:35:26.000000000 +0200
@@ -139,6 +139,7 @@ struct alg_spec {
 
 struct dm_integrity_c {
 	struct dm_dev *dev;
+	struct dm_dev *meta_dev;
 	unsigned tag_size;
 	__s8 log2_tag_size;
 	sector_t start;
@@ -170,7 +171,8 @@ struct dm_integrity_c {
 	unsigned short journal_section_sectors;
 	unsigned journal_sections;
 	unsigned journal_entries;
-	sector_t device_sectors;
+	sector_t data_device_sectors;
+	sector_t meta_device_sectors;
 	unsigned initial_sectors;
 	unsigned metadata_run;
 	__s8 log2_metadata_run;
@@ -337,10 +339,14 @@ static commit_id_t dm_integrity_commit_i
 static void get_area_and_offset(struct dm_integrity_c *ic, sector_t data_sector,
 				sector_t *area, sector_t *offset)
 {
-	__u8 log2_interleave_sectors = ic->sb->log2_interleave_sectors;
-
-	*area = data_sector >> log2_interleave_sectors;
-	*offset = (unsigned)data_sector & ((1U << log2_interleave_sectors) - 1);
+	if (!ic->meta_dev) {
+		__u8 log2_interleave_sectors = ic->sb->log2_interleave_sectors;
+		*area = data_sector >> log2_interleave_sectors;
+		*offset = (unsigned)data_sector & ((1U << log2_interleave_sectors) - 1);
+	} else {
+		*area = 0;
+		*offset = data_sector;
+	}
 }
 
 #define sector_to_block(ic, n)						\
@@ -379,6 +385,9 @@ static sector_t get_data_sector(struct d
 {
 	sector_t result;
 
+	if (ic->meta_dev)
+		return offset;
+
 	result = area << ic->sb->log2_interleave_sectors;
 	if (likely(ic->log2_metadata_run >= 0))
 		result += (area + 1) << ic->log2_metadata_run;
@@ -408,7 +417,7 @@ static int sync_rw_sb(struct dm_integrit
 	io_req.mem.ptr.addr = ic->sb;
 	io_req.notify.fn = NULL;
 	io_req.client = ic->io;
-	io_loc.bdev = ic->dev->bdev;
+	io_loc.bdev = ic->meta_dev ? ic->meta_dev->bdev : ic->dev->bdev;
 	io_loc.sector = ic->start;
 	io_loc.count = SB_SECTORS;
 
@@ -755,7 +764,7 @@ static void rw_journal(struct dm_integri
 		io_req.notify.fn = NULL;
 	}
 	io_req.client = ic->io;
-	io_loc.bdev = ic->dev->bdev;
+	io_loc.bdev = ic->meta_dev ? ic->meta_dev->bdev : ic->dev->bdev;
 	io_loc.sector = ic->start + SB_SECTORS + sector;
 	io_loc.count = n_sectors;
 
@@ -2254,12 +2263,15 @@ static void dm_integrity_status(struct d
 		watermark_percentage += ic->journal_entries / 2;
 		do_div(watermark_percentage, ic->journal_entries);
 		arg_count = 5;
+		arg_count += !!ic->meta_dev;
 		arg_count += ic->sectors_per_block != 1;
 		arg_count += !!ic->internal_hash_alg.alg_string;
 		arg_count += !!ic->journal_crypt_alg.alg_string;
 		arg_count += !!ic->journal_mac_alg.alg_string;
 		DMEMIT("%s %llu %u %c %u", ic->dev->name, (unsigned long long)ic->start,
 		       ic->tag_size, ic->mode, arg_count);
+		if (ic->meta_dev)
+			DMEMIT(" meta_device:%s", ic->meta_dev->name);
 		DMEMIT(" journal_sectors:%u", ic->initial_sectors - SB_SECTORS);
 		DMEMIT(" interleave_sectors:%u", 1U << ic->sb->log2_interleave_sectors);
 		DMEMIT(" buffer_sectors:%u", 1U << ic->log2_buffer_sectors);
@@ -2289,7 +2301,10 @@ static int dm_integrity_iterate_devices(
 {
 	struct dm_integrity_c *ic = ti->private;
 
-	return fn(ti, ic->dev, ic->start + ic->initial_sectors + ic->metadata_run, ti->len, data);
+	if (!ic->meta_dev)
+		return fn(ti, ic->dev, ic->start + ic->initial_sectors + ic->metadata_run, ti->len, data);
+	else
+		return fn(ti, ic->dev, 0, ti->len, data);
 }
 
 static void dm_integrity_io_hints(struct dm_target *ti, struct queue_limits *limits)
@@ -2322,26 +2337,38 @@ static void calculate_journal_section_si
 static int calculate_device_limits(struct dm_integrity_c *ic)
 {
 	__u64 initial_sectors;
-	sector_t last_sector, last_area, last_offset;
 
 	calculate_journal_section_size(ic);
 	initial_sectors = SB_SECTORS + (__u64)ic->journal_section_sectors * ic->journal_sections;
-	if (initial_sectors + METADATA_PADDING_SECTORS >= ic->device_sectors || initial_sectors > UINT_MAX)
+	if (initial_sectors + METADATA_PADDING_SECTORS >= ic->meta_device_sectors || initial_sectors > UINT_MAX)
 		return -EINVAL;
 	ic->initial_sectors = initial_sectors;
 
-	ic->metadata_run = roundup((__u64)ic->tag_size << (ic->sb->log2_interleave_sectors - ic->sb->log2_sectors_per_block),
-				   (__u64)(1 << SECTOR_SHIFT << METADATA_PADDING_SECTORS)) >> SECTOR_SHIFT;
-	if (!(ic->metadata_run & (ic->metadata_run - 1)))
-		ic->log2_metadata_run = __ffs(ic->metadata_run);
-	else
-		ic->log2_metadata_run = -1;
+	if (!ic->meta_dev) {
+		sector_t last_sector, last_area, last_offset;
 
-	get_area_and_offset(ic, ic->provided_data_sectors - 1, &last_area, &last_offset);
-	last_sector = get_data_sector(ic, last_area, last_offset);
+		ic->metadata_run = roundup((__u64)ic->tag_size << (ic->sb->log2_interleave_sectors - ic->sb->log2_sectors_per_block),
+					   (__u64)(1 << SECTOR_SHIFT << METADATA_PADDING_SECTORS)) >> SECTOR_SHIFT;
+		if (!(ic->metadata_run & (ic->metadata_run - 1)))
+			ic->log2_metadata_run = __ffs(ic->metadata_run);
+		else
+			ic->log2_metadata_run = -1;
 
-	if (last_sector < ic->start || last_sector >= ic->device_sectors)
-		return -EINVAL;
+		get_area_and_offset(ic, ic->provided_data_sectors - 1, &last_area, &last_offset);
+		last_sector = get_data_sector(ic, last_area, last_offset);
+		if (last_sector < ic->start || last_sector >= ic->meta_device_sectors)
+			return -EINVAL;
+	} else {
+		__u64 meta_size = ic->provided_data_sectors * ic->tag_size;
+		meta_size = (meta_size + ((1U << (ic->log2_buffer_sectors + SECTOR_SHIFT)) - 1))
+				>> (ic->log2_buffer_sectors + SECTOR_SHIFT);
+		meta_size <<= ic->log2_buffer_sectors;
+		if (ic->initial_sectors + meta_size < ic->initial_sectors ||
+		    ic->initial_sectors + meta_size > ic->meta_device_sectors)
+			return -EINVAL;
+		ic->metadata_run = 1;
+		ic->log2_metadata_run = 0;
+	}
 
 	return 0;
 }
@@ -2363,26 +2390,51 @@ static int initialize_superblock(struct
 	journal_sections = journal_sectors / ic->journal_section_sectors;
 	if (!journal_sections)
 		journal_sections = 1;
-	ic->sb->journal_sections = cpu_to_le32(journal_sections);
-
-	if (!interleave_sectors)
-		interleave_sectors = DEFAULT_INTERLEAVE_SECTORS;
-	ic->sb->log2_interleave_sectors = __fls(interleave_sectors);
-	ic->sb->log2_interleave_sectors = max((__u8)MIN_LOG2_INTERLEAVE_SECTORS, ic->sb->log2_interleave_sectors);
-	ic->sb->log2_interleave_sectors = min((__u8)MAX_LOG2_INTERLEAVE_SECTORS, ic->sb->log2_interleave_sectors);
 
-	ic->provided_data_sectors = 0;
-	for (test_bit = fls64(ic->device_sectors) - 1; test_bit >= 3; test_bit--) {
-		__u64 prev_data_sectors = ic->provided_data_sectors;
+	if (!ic->meta_dev) {
+		ic->sb->journal_sections = cpu_to_le32(journal_sections);
+		if (!interleave_sectors)
+			interleave_sectors = DEFAULT_INTERLEAVE_SECTORS;
+		ic->sb->log2_interleave_sectors = __fls(interleave_sectors);
+		ic->sb->log2_interleave_sectors = max((__u8)MIN_LOG2_INTERLEAVE_SECTORS, ic->sb->log2_interleave_sectors);
+		ic->sb->log2_interleave_sectors = min((__u8)MAX_LOG2_INTERLEAVE_SECTORS, ic->sb->log2_interleave_sectors);
+
+		ic->provided_data_sectors = 0;
+		for (test_bit = fls64(ic->meta_device_sectors) - 1; test_bit >= 3; test_bit--) {
+			__u64 prev_data_sectors = ic->provided_data_sectors;
+
+			ic->provided_data_sectors |= (sector_t)1 << test_bit;
+			if (calculate_device_limits(ic))
+				ic->provided_data_sectors = prev_data_sectors;
+		}
+		if (!ic->provided_data_sectors)
+			return -EINVAL;
+	} else {
+		ic->sb->log2_interleave_sectors = 0;
+		ic->provided_data_sectors = ic->data_device_sectors;
+		ic->provided_data_sectors &= ~(sector_t)(ic->sectors_per_block - 1);
+
+try_smaller_buffer:
+		ic->sb->journal_sections = cpu_to_le32(0);
+		for (test_bit = fls(journal_sections) - 1; test_bit >= 0; test_bit--) {
+			__u32 prev_journal_sections = le32_to_cpu(ic->sb->journal_sections);
+			__u32 test_journal_sections = prev_journal_sections | (1U << test_bit);
+			if (test_journal_sections > journal_sections)
+				continue;
+			ic->sb->journal_sections = cpu_to_le32(test_journal_sections);
+			if (calculate_device_limits(ic))
+				ic->sb->journal_sections = cpu_to_le32(prev_journal_sections);
 
-		ic->provided_data_sectors |= (sector_t)1 << test_bit;
-		if (calculate_device_limits(ic))
-			ic->provided_data_sectors = prev_data_sectors;
+		}
+		if (!le32_to_cpu(ic->sb->journal_sections)) {
+			if (ic->log2_buffer_sectors > 3) {
+				ic->log2_buffer_sectors--;
+				goto try_smaller_buffer;
+			}
+			return -EINVAL;
+		}
 	}
 
-	if (!ic->provided_data_sectors)
-		return -EINVAL;
-
 	ic->sb->provided_data_sectors = cpu_to_le64(ic->provided_data_sectors);
 
 	return 0;
@@ -2878,9 +2930,7 @@ static int dm_integrity_ctr(struct dm_ta
 		goto bad;
 	}
 
-	ic->device_sectors = i_size_read(ic->dev->bdev->bd_inode) >> SECTOR_SHIFT;
-	journal_sectors = min((sector_t)DEFAULT_MAX_JOURNAL_SECTORS,
-			ic->device_sectors >> DEFAULT_JOURNAL_SIZE_FACTOR);
+	journal_sectors = 0;
 	interleave_sectors = DEFAULT_INTERLEAVE_SECTORS;
 	buffer_sectors = DEFAULT_BUFFER_SECTORS;
 	journal_watermark = DEFAULT_JOURNAL_WATERMARK;
@@ -2903,7 +2953,7 @@ static int dm_integrity_ctr(struct dm_ta
 			goto bad;
 		}
 		if (sscanf(opt_string, "journal_sectors:%u%c", &val, &dummy) == 1)
-			journal_sectors = val;
+			journal_sectors = val ? val : 1;
 		else if (sscanf(opt_string, "interleave_sectors:%u%c", &val, &dummy) == 1)
 			interleave_sectors = val;
 		else if (sscanf(opt_string, "buffer_sectors:%u%c", &val, &dummy) == 1)
@@ -2912,7 +2962,17 @@ static int dm_integrity_ctr(struct dm_ta
 			journal_watermark = val;
 		else if (sscanf(opt_string, "commit_time:%u%c", &val, &dummy) == 1)
 			sync_msec = val;
-		else if (sscanf(opt_string, "block_size:%u%c", &val, &dummy) == 1) {
+		else if (!memcmp(opt_string, "meta_device:", strlen("meta_device:"))) {
+			if (ic->meta_dev) {
+				dm_put_device(ti, ic->meta_dev);
+				ic->meta_dev = NULL;
+			}
+			r = dm_get_device(ti, strchr(opt_string, ':') + 1, dm_table_get_mode(ti->table), &ic->meta_dev);
+			if (r) {
+				ti->error = "Device lookup failed";
+				goto bad;
+			}
+		} else if (sscanf(opt_string, "block_size:%u%c", &val, &dummy) == 1) {
 			if (val < 1 << SECTOR_SHIFT ||
 			    val > MAX_SECTORS_PER_BLOCK << SECTOR_SHIFT ||
 			    (val & (val -1))) {
@@ -2943,6 +3003,21 @@ static int dm_integrity_ctr(struct dm_ta
 		}
 	}
 
+	ic->data_device_sectors = i_size_read(ic->dev->bdev->bd_inode) >> SECTOR_SHIFT;
+	if (!ic->meta_dev)
+		ic->meta_device_sectors = ic->data_device_sectors;
+	else
+		ic->meta_device_sectors = i_size_read(ic->meta_dev->bdev->bd_inode) >> SECTOR_SHIFT;
+
+	if (!journal_sectors) {
+		journal_sectors = min((sector_t)DEFAULT_MAX_JOURNAL_SECTORS,
+			ic->data_device_sectors >> DEFAULT_JOURNAL_SIZE_FACTOR);
+	}
+
+	if (!buffer_sectors)
+		buffer_sectors = 1;
+	ic->log2_buffer_sectors = min((int)__fls(buffer_sectors), 31 - SECTOR_SHIFT);
+
 	r = get_mac(&ic->internal_hash, &ic->internal_hash_alg, &ti->error,
 		    "Invalid internal hash", "Error setting internal hash key");
 	if (r)
@@ -3079,11 +3154,19 @@ static int dm_integrity_ctr(struct dm_ta
 		goto bad;
 	}
 	/* make sure that ti->max_io_len doesn't overflow */
-	if (ic->sb->log2_interleave_sectors < MIN_LOG2_INTERLEAVE_SECTORS ||
-	    ic->sb->log2_interleave_sectors > MAX_LOG2_INTERLEAVE_SECTORS) {
-		r = -EINVAL;
-		ti->error = "Invalid interleave_sectors in the superblock";
-		goto bad;
+	if (!ic->meta_dev) {
+		if (ic->sb->log2_interleave_sectors < MIN_LOG2_INTERLEAVE_SECTORS ||
+		    ic->sb->log2_interleave_sectors > MAX_LOG2_INTERLEAVE_SECTORS) {
+			r = -EINVAL;
+			ti->error = "Invalid interleave_sectors in the superblock";
+			goto bad;
+		}
+	} else {
+		if (ic->sb->log2_interleave_sectors) {
+			r = -EINVAL;
+			ti->error = "Invalid interleave_sectors in the superblock";
+			goto bad;
+		}
 	}
 	ic->provided_data_sectors = le64_to_cpu(ic->sb->provided_data_sectors);
 	if (ic->provided_data_sectors != le64_to_cpu(ic->sb->provided_data_sectors)) {
@@ -3097,20 +3180,28 @@ static int dm_integrity_ctr(struct dm_ta
 		ti->error = "Journal mac mismatch";
 		goto bad;
 	}
+
+try_smaller_buffer:
 	r = calculate_device_limits(ic);
 	if (r) {
+		if (ic->meta_dev) {
+			if (ic->log2_buffer_sectors > 3) {
+				ic->log2_buffer_sectors--;
+				goto try_smaller_buffer;
+			}
+		}
 		ti->error = "The device is too small";
 		goto bad;
 	}
+	if (!ic->meta_dev)
+		ic->log2_buffer_sectors = min(ic->log2_buffer_sectors, (__u8)__ffs(ic->metadata_run));
+
 	if (ti->len > ic->provided_data_sectors) {
 		r = -EINVAL;
 		ti->error = "Not enough provided sectors for requested mapping size";
 		goto bad;
 	}
 
-	if (!buffer_sectors)
-		buffer_sectors = 1;
-	ic->log2_buffer_sectors = min3((int)__fls(buffer_sectors), (int)__ffs(ic->metadata_run), 31 - SECTOR_SHIFT);
 
 	threshold = (__u64)ic->journal_entries * (100 - journal_watermark);
 	threshold += 50;
@@ -3134,8 +3225,8 @@ static int dm_integrity_ctr(struct dm_ta
 		    (unsigned long long)ic->provided_data_sectors);
 	DEBUG_print("	log2_buffer_sectors %u\n", ic->log2_buffer_sectors);
 
-	ic->bufio = dm_bufio_client_create(ic->dev->bdev, 1U << (SECTOR_SHIFT + ic->log2_buffer_sectors),
-					   1, 0, NULL, NULL);
+	ic->bufio = dm_bufio_client_create(ic->meta_dev ? ic->meta_dev->bdev : ic->dev->bdev,
+			1U << (SECTOR_SHIFT + ic->log2_buffer_sectors), 1, 0, NULL, NULL);
 	if (IS_ERR(ic->bufio)) {
 		r = PTR_ERR(ic->bufio);
 		ti->error = "Cannot initialize dm-bufio";
@@ -3167,9 +3258,11 @@ static int dm_integrity_ctr(struct dm_ta
 		ic->just_formatted = true;
 	}
 
-	r = dm_set_target_max_io_len(ti, 1U << ic->sb->log2_interleave_sectors);
-	if (r)
-		goto bad;
+	if (!ic->meta_dev) {
+		r = dm_set_target_max_io_len(ti, 1U << ic->sb->log2_interleave_sectors);
+		if (r)
+			goto bad;
+	}
 
 	if (!ic->internal_hash)
 		dm_integrity_set(ti, ic);
@@ -3204,6 +3297,8 @@ static void dm_integrity_dtr(struct dm_t
 		dm_io_client_destroy(ic->io);
 	if (ic->dev)
 		dm_put_device(ti, ic->dev);
+	if (ic->meta_dev)
+		dm_put_device(ti, ic->meta_dev);
 	dm_integrity_free_page_list(ic, ic->journal);
 	dm_integrity_free_page_list(ic, ic->journal_io);
 	dm_integrity_free_page_list(ic, ic->journal_xor);
