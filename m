From: NeilBrown <neilb@suse.de>
Subject: [PATCH 21/24] dm-dirty-log: allow log size to be different from
	target size.
Date: Tue, 01 Jun 2010 19:56:20 +1000
Message-ID: <20100601095620.565.10070.stgit@notabene.brown>
References: <20100601094414.565.3638.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100601094414.565.3638.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Heinz Mauelshagen <heinzm@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

With RAID1, the dirty log covers the size of the target - the number
of bits is the target size divided by the region size.

For RAID5 and similar the dirty log needs to cover the parity blocks,
so it is best to base the dirty log size on the size of the component
devices rather than the size of the array.

So when creating a dirty log, allow the log_size to be specified
separately from the target, and in raid1, set it to the target length.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/dm-log-userspace-base.c |   11 +++++++----
 drivers/md/dm-log.c                |   18 +++++++++++-------
 drivers/md/dm-raid1.c              |    4 ++--
 include/linux/dm-dirty-log.h       |    3 ++-
 4 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/md/dm-log-userspace-base.c b/drivers/md/dm-log-userspace-base.c
index 1ed0094..935a49b 100644
--- a/drivers/md/dm-log-userspace-base.c
+++ b/drivers/md/dm-log-userspace-base.c
@@ -94,7 +94,7 @@ retry:
 	return -ESRCH;
 }
 
-static int build_constructor_string(struct dm_target *ti,
+static int build_constructor_string(sector_t log_size,
 				    unsigned argc, char **argv,
 				    char **ctr_str)
 {
@@ -114,7 +114,7 @@ static int build_constructor_string(struct dm_target *ti,
 		return -ENOMEM;
 	}
 
-	str_size = sprintf(str, "%llu", (unsigned long long)ti->len);
+	str_size = sprintf(str, "%llu", (unsigned long long)log_size);
 	for (i = 0; i < argc; i++)
 		str_size += sprintf(str + str_size, " %s", argv[i]);
 
@@ -136,6 +136,7 @@ static int build_constructor_string(struct dm_target *ti,
  * else.
  */
 static int userspace_ctr(struct dm_dirty_log *log, struct dm_target *ti,
+			 sector_t log_size,
 			 unsigned argc, char **argv)
 {
 	int r = 0;
@@ -171,7 +172,9 @@ static int userspace_ctr(struct dm_dirty_log *log, struct dm_target *ti,
 	spin_lock_init(&lc->flush_lock);
 	INIT_LIST_HEAD(&lc->flush_list);
 
-	str_size = build_constructor_string(ti, argc - 1, argv + 1, &ctr_str);
+	str_size = build_constructor_string(log_size,
+					    argc - 1, argv + 1,
+					    &ctr_str);
 	if (str_size < 0) {
 		kfree(lc);
 		return str_size;
@@ -197,7 +200,7 @@ static int userspace_ctr(struct dm_dirty_log *log, struct dm_target *ti,
 	}
 
 	lc->region_size = (uint32_t)rdata;
-	lc->region_count = dm_sector_div_up(ti->len, lc->region_size);
+	lc->region_count = dm_sector_div_up(log_size, lc->region_size);
 
 out:
 	if (r) {
diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
index 5a08be0..a232c14 100644
--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -146,6 +146,7 @@ EXPORT_SYMBOL(dm_dirty_log_type_unregister);
 
 struct dm_dirty_log *dm_dirty_log_create(const char *type_name,
 			struct dm_target *ti,
+			sector_t log_size,
 			int (*flush_callback_fn)(struct dm_target *ti),
 			unsigned int argc, char **argv)
 {
@@ -164,7 +165,7 @@ struct dm_dirty_log *dm_dirty_log_create(const char *type_name,
 
 	log->flush_callback_fn = flush_callback_fn;
 	log->type = type;
-	if (type->ctr(log, ti, argc, argv)) {
+	if (type->ctr(log, ti, log_size, argc, argv)) {
 		kfree(log);
 		put_type(type);
 		return NULL;
@@ -335,9 +336,9 @@ static int read_header(struct log_c *log)
 	return 0;
 }
 
-static int _check_region_size(struct dm_target *ti, uint32_t region_size)
+static int _check_region_size(sector_t log_size, uint32_t region_size)
 {
-	if (region_size < 2 || region_size > ti->len)
+	if (region_size < 2 || region_size > log_size)
 		return 0;
 
 	if (!is_power_of_2(region_size))
@@ -353,6 +354,7 @@ static int _check_region_size(struct dm_target *ti, uint32_t region_size)
  *--------------------------------------------------------------*/
 #define BYTE_SHIFT 3
 static int create_log_context(struct dm_dirty_log *log, struct dm_target *ti,
+			      sector_t log_size,
 			      unsigned int argc, char **argv,
 			      struct dm_dev *dev)
 {
@@ -382,12 +384,12 @@ static int create_log_context(struct dm_dirty_log *log, struct dm_target *ti,
 	}
 
 	if (sscanf(argv[0], "%u", &region_size) != 1 ||
-	    !_check_region_size(ti, region_size)) {
+	    !_check_region_size(log_size, region_size)) {
 		DMWARN("invalid region size %s", argv[0]);
 		return -EINVAL;
 	}
 
-	region_count = dm_sector_div_up(ti->len, region_size);
+	region_count = dm_sector_div_up(log_size, region_size);
 
 	lc = kmalloc(sizeof(*lc), GFP_KERNEL);
 	if (!lc) {
@@ -507,9 +509,10 @@ static int create_log_context(struct dm_dirty_log *log, struct dm_target *ti,
 }
 
 static int core_ctr(struct dm_dirty_log *log, struct dm_target *ti,
+		    sector_t log_size,
 		    unsigned int argc, char **argv)
 {
-	return create_log_context(log, ti, argc, argv, NULL);
+	return create_log_context(log, ti, log_size, argc, argv, NULL);
 }
 
 static void destroy_log_context(struct log_c *lc)
@@ -533,6 +536,7 @@ static void core_dtr(struct dm_dirty_log *log)
  * argv contains log_device region_size followed optionally by [no]sync
  *--------------------------------------------------------------*/
 static int disk_ctr(struct dm_dirty_log *log, struct dm_target *ti,
+		    sector_t log_size,
 		    unsigned int argc, char **argv)
 {
 	int r;
@@ -547,7 +551,7 @@ static int disk_ctr(struct dm_dirty_log *log, struct dm_target *ti,
 	if (r)
 		return r;
 
-	r = create_log_context(log, ti, argc - 1, argv + 1, dev);
+	r = create_log_context(log, ti, log_size, argc - 1, argv + 1, dev);
 	if (r) {
 		dm_put_device(ti, dev);
 		return r;
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index ddda531..ea732fc 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -968,8 +968,8 @@ static struct dm_dirty_log *create_dirty_log(struct dm_target *ti,
 		return NULL;
 	}
 
-	dl = dm_dirty_log_create(argv[0], ti, mirror_flush, param_count,
-				 argv + 2);
+	dl = dm_dirty_log_create(argv[0], ti, ti->len, mirror_flush,
+				 param_count, argv + 2);
 	if (!dl) {
 		ti->error = "Error creating mirror dirty log";
 		return NULL;
diff --git a/include/linux/dm-dirty-log.h b/include/linux/dm-dirty-log.h
index 7084503..641419f 100644
--- a/include/linux/dm-dirty-log.h
+++ b/include/linux/dm-dirty-log.h
@@ -33,6 +33,7 @@ struct dm_dirty_log_type {
 	struct list_head list;
 
 	int (*ctr)(struct dm_dirty_log *log, struct dm_target *ti,
+		   sector_t log_size,
 		   unsigned argc, char **argv);
 	void (*dtr)(struct dm_dirty_log *log);
 
@@ -137,7 +138,7 @@ int dm_dirty_log_type_unregister(struct dm_dirty_log_type *type);
  * type->constructor/destructor() directly.
  */
 struct dm_dirty_log *dm_dirty_log_create(const char *type_name,
-			struct dm_target *ti,
+			struct dm_target *ti, sector_t log_size,
 			int (*flush_callback_fn)(struct dm_target *ti),
 			unsigned argc, char **argv);
 void dm_dirty_log_destroy(struct dm_dirty_log *log);


