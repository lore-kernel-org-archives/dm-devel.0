From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH] md: replace strict_strto*() with kstrto*()
Date: Sat, 01 Jun 2013 16:15:16 +0900
Message-ID: <000601ce5e97$c4870a20$4d951e60$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-language: ko
Sender: linux-raid-owner@vger.kernel.org
To: 'Neil Brown' <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com, 'Alasdair Kergon' <agk@redhat.com>, Jingoo Han <jg1.han@samsung.com>
List-Id: dm-devel.ids

The usage of strict_strtoul() is not preferred, because
strict_strtoul() is obsolete. Thus, kstrtoul() should be
used.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/md/bitmap.c  |    8 ++++----
 drivers/md/dm-raid.c |    8 ++++----
 drivers/md/md.c      |   16 ++++++++--------
 drivers/md/raid5.c   |    4 ++--
 4 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 5a2c754..a7fd821 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -2002,9 +2002,9 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 		} else {
 			int rv;
 			if (buf[0] == '+')
-				rv = strict_strtoll(buf+1, 10, &offset);
+				rv = kstrtoll(buf+1, 10, &offset);
 			else
-				rv = strict_strtoll(buf, 10, &offset);
+				rv = kstrtoll(buf, 10, &offset);
 			if (rv)
 				return rv;
 			if (offset == 0)
@@ -2139,7 +2139,7 @@ static ssize_t
 backlog_store(struct mddev *mddev, const char *buf, size_t len)
 {
 	unsigned long backlog;
-	int rv = strict_strtoul(buf, 10, &backlog);
+	int rv = kstrtoul(buf, 10, &backlog);
 	if (rv)
 		return rv;
 	if (backlog > COUNTER_MAX)
@@ -2165,7 +2165,7 @@ chunksize_store(struct mddev *mddev, const char *buf, size_t len)
 	unsigned long csize;
 	if (mddev->bitmap)
 		return -EBUSY;
-	rv = strict_strtoul(buf, 10, &csize);
+	rv = kstrtoul(buf, 10, &csize);
 	if (rv)
 		return rv;
 	if (csize < 512 ||
diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 0f5a6fb..21e8e46 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -504,7 +504,7 @@ static int parse_raid_params(struct raid_set *rs, char **argv,
 	 * First, parse the in-order required arguments
 	 * "chunk_size" is the only argument of this type.
 	 */
-	if ((strict_strtoul(argv[0], 10, &value) < 0)) {
+	if ((kstrtoul(argv[0], 10, &value) < 0)) {
 		rs->ti->error = "Bad chunk size";
 		return -EINVAL;
 	} else if (rs->raid_type->level == 1) {
@@ -585,7 +585,7 @@ static int parse_raid_params(struct raid_set *rs, char **argv,
 			continue;
 		}
 
-		if (strict_strtoul(argv[i], 10, &value) < 0) {
+		if (kstrtoul(argv[i], 10, &value) < 0) {
 			rs->ti->error = "Bad numerical argument given in raid params";
 			return -EINVAL;
 		}
@@ -1181,7 +1181,7 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	argv++;
 
 	/* number of RAID parameters */
-	if (strict_strtoul(argv[0], 10, &num_raid_params) < 0) {
+	if (kstrtoul(argv[0], 10, &num_raid_params) < 0) {
 		ti->error = "Cannot understand number of RAID parameters";
 		return -EINVAL;
 	}
@@ -1194,7 +1194,7 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		return -EINVAL;
 	}
 
-	if ((strict_strtoul(argv[num_raid_params], 10, &num_raid_devs) < 0) ||
+	if ((kstrtoul(argv[num_raid_params], 10, &num_raid_devs) < 0) ||
 	    (num_raid_devs >= INT_MAX)) {
 		ti->error = "Cannot understand number of raid devices";
 		return -EINVAL;
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0bbe710..76f5a8b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2870,7 +2870,7 @@ static ssize_t
 offset_store(struct md_rdev *rdev, const char *buf, size_t len)
 {
 	unsigned long long offset;
-	if (strict_strtoull(buf, 10, &offset) < 0)
+	if (kstrtoull(buf, 10, &offset) < 0)
 		return -EINVAL;
 	if (rdev->mddev->pers && rdev->raid_disk >= 0)
 		return -EBUSY;
@@ -2898,7 +2898,7 @@ static ssize_t new_offset_store(struct md_rdev *rdev,
 	unsigned long long new_offset;
 	struct mddev *mddev = rdev->mddev;
 
-	if (strict_strtoull(buf, 10, &new_offset) < 0)
+	if (kstrtoull(buf, 10, &new_offset) < 0)
 		return -EINVAL;
 
 	if (mddev->sync_thread)
@@ -2964,7 +2964,7 @@ static int strict_blocks_to_sectors(const char *buf, sector_t *sectors)
 	unsigned long long blocks;
 	sector_t new;
 
-	if (strict_strtoull(buf, 10, &blocks) < 0)
+	if (kstrtoull(buf, 10, &blocks) < 0)
 		return -EINVAL;
 
 	if (blocks & 1ULL << (8 * sizeof(blocks) - 1))
@@ -3072,7 +3072,7 @@ static ssize_t recovery_start_store(struct md_rdev *rdev, const char *buf, size_
 
 	if (cmd_match(buf, "none"))
 		recovery_start = MaxSector;
-	else if (strict_strtoull(buf, 10, &recovery_start))
+	else if (kstrtoull(buf, 10, &recovery_start))
 		return -EINVAL;
 
 	if (rdev->mddev->pers &&
@@ -3500,7 +3500,7 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
 	if (clevel[len-1] == '\n')
 		len--;
 	clevel[len] = 0;
-	if (strict_strtol(clevel, 10, &level))
+	if (kstrtol(clevel, 10, &level))
 		level = LEVEL_NONE;
 
 	if (request_module("md-%s", clevel) != 0)
@@ -4359,7 +4359,7 @@ sync_force_parallel_store(struct mddev *mddev, const char *buf, size_t len)
 {
 	long n;
 
-	if (strict_strtol(buf, 10, &n))
+	if (kstrtol(buf, 10, &n))
 		return -EINVAL;
 
 	if (n != 0 && n != 1)
@@ -4427,7 +4427,7 @@ static ssize_t
 min_sync_store(struct mddev *mddev, const char *buf, size_t len)
 {
 	unsigned long long min;
-	if (strict_strtoull(buf, 10, &min))
+	if (kstrtoull(buf, 10, &min))
 		return -EINVAL;
 	if (min > mddev->resync_max)
 		return -EINVAL;
@@ -4464,7 +4464,7 @@ max_sync_store(struct mddev *mddev, const char *buf, size_t len)
 		mddev->resync_max = MaxSector;
 	else {
 		unsigned long long max;
-		if (strict_strtoull(buf, 10, &max))
+		if (kstrtoull(buf, 10, &max))
 			return -EINVAL;
 		if (max < mddev->resync_min)
 			return -EINVAL;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index e1bcd75..d06eaa0 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4929,7 +4929,7 @@ raid5_store_stripe_cache_size(struct mddev *mddev, const char *page, size_t len)
 	if (!conf)
 		return -ENODEV;
 
-	if (strict_strtoul(page, 10, &new))
+	if (kstrtoul(page, 10, &new))
 		return -EINVAL;
 	err = raid5_set_cache_size(mddev, new);
 	if (err)
@@ -4962,7 +4962,7 @@ raid5_store_preread_threshold(struct mddev *mddev, const char *page, size_t len)
 	if (!conf)
 		return -ENODEV;
 
-	if (strict_strtoul(page, 10, &new))
+	if (kstrtoul(page, 10, &new))
 		return -EINVAL;
 	if (new > conf->max_nr_stripes)
 		return -EINVAL;
-- 
1.7.10.4


