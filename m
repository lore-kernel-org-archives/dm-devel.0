From: Milan Broz <mbroz@redhat.com>
Subject: [PATCH] Propagate device open error to table constructor.
Date: Tue, 15 Feb 2011 14:52:40 +0100
Message-ID: <1297777960-22662-2-git-send-email-mbroz@redhat.com>
References: <1297777960-22662-1-git-send-email-mbroz@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1297777960-22662-1-git-send-email-mbroz@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Ensure that all errors in dm_get_device() propagates into
table constructor (thus into userspace).

This is required to properly handle EACCES/EROFS codes
when opening read-only device with recent kernel changes.

Userspace can later retry with read-only flag set.

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 drivers/md/dm-crypt.c  |    7 +++++--
 drivers/md/dm-delay.c  |   15 ++++++++++-----
 drivers/md/dm-linear.c |   14 +++++++-------
 drivers/md/dm-raid1.c  |    8 +++++---
 drivers/md/dm-stripe.c |   11 ++++++-----
 5 files changed, 33 insertions(+), 22 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 4e054bd..397e73a 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1628,20 +1628,23 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto bad;
 	}
 
-	ret = -EINVAL;
 	if (sscanf(argv[2], "%llu", &tmpll) != 1) {
 		ti->error = "Invalid iv_offset sector";
+		ret = -EINVAL;
 		goto bad;
 	}
 	cc->iv_offset = tmpll;
 
-	if (dm_get_device(ti, argv[3], dm_table_get_mode(ti->table), &cc->dev)) {
+	ret = dm_get_device(ti, argv[3], dm_table_get_mode(ti->table),
+			    &cc->dev);
+	if (ret) {
 		ti->error = "Device lookup failed";
 		goto bad;
 	}
 
 	if (sscanf(argv[4], "%llu", &tmpll) != 1) {
 		ti->error = "Invalid device sector";
+		ret = -EINVAL;
 		goto bad;
 	}
 	cc->start = tmpll;
diff --git a/drivers/md/dm-delay.c b/drivers/md/dm-delay.c
index f18375d..b07428f 100644
--- a/drivers/md/dm-delay.c
+++ b/drivers/md/dm-delay.c
@@ -131,6 +131,7 @@ static int delay_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
 	struct delay_c *dc;
 	unsigned long long tmpll;
+	int r = -EINVAL;
 
 	if (argc != 3 && argc != 6) {
 		ti->error = "requires exactly 3 or 6 arguments";
@@ -156,12 +157,14 @@ static int delay_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto bad;
 	}
 
-	if (dm_get_device(ti, argv[0], dm_table_get_mode(ti->table),
-			  &dc->dev_read)) {
+	r = dm_get_device(ti, argv[0], dm_table_get_mode(ti->table),
+			  &dc->dev_read);
+	if (r) {
 		ti->error = "Device lookup failed";
 		goto bad;
 	}
 
+	r = -EINVAL;
 	dc->dev_write = NULL;
 	if (argc == 3)
 		goto out;
@@ -177,8 +180,9 @@ static int delay_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto bad_dev_read;
 	}
 
-	if (dm_get_device(ti, argv[3], dm_table_get_mode(ti->table),
-			  &dc->dev_write)) {
+	r = dm_get_device(ti, argv[3], dm_table_get_mode(ti->table),
+			  &dc->dev_write);
+	if (r) {
 		ti->error = "Write device lookup failed";
 		goto bad_dev_read;
 	}
@@ -187,6 +191,7 @@ out:
 	dc->delayed_pool = mempool_create_slab_pool(128, delayed_cache);
 	if (!dc->delayed_pool) {
 		DMERR("Couldn't create delayed bio pool.");
+		r = -ENOMEM;
 		goto bad_dev_write;
 	}
 
@@ -209,7 +214,7 @@ bad_dev_read:
 	dm_put_device(ti, dc->dev_read);
 bad:
 	kfree(dc);
-	return -EINVAL;
+	return r;
 }
 
 static void delay_dtr(struct dm_target *ti)
diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 3921e3b..f3254e5 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -29,6 +29,7 @@ static int linear_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
 	struct linear_c *lc;
 	unsigned long long tmp;
+	int r;
 
 	if (argc != 2) {
 		ti->error = "Invalid argument count";
@@ -43,23 +44,22 @@ static int linear_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	if (sscanf(argv[1], "%llu", &tmp) != 1) {
 		ti->error = "dm-linear: Invalid device sector";
-		goto bad;
+		kfree(lc);
+		return -EINVAL;
 	}
 	lc->start = tmp;
 
-	if (dm_get_device(ti, argv[0], dm_table_get_mode(ti->table), &lc->dev)) {
+	r = dm_get_device(ti, argv[0], dm_table_get_mode(ti->table), &lc->dev);
+	if (r) {
 		ti->error = "dm-linear: Device lookup failed";
-		goto bad;
+		kfree(lc);
+		return r;
 	}
 
 	ti->num_flush_requests = 1;
 	ti->num_discard_requests = 1;
 	ti->private = lc;
 	return 0;
-
-      bad:
-	kfree(lc);
-	return -EINVAL;
 }
 
 static void linear_dtr(struct dm_target *ti)
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index dee3267..be38862 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -928,16 +928,18 @@ static int get_mirror(struct mirror_set *ms, struct dm_target *ti,
 		      unsigned int mirror, char **argv)
 {
 	unsigned long long offset;
+	int r;
 
 	if (sscanf(argv[1], "%llu", &offset) != 1) {
 		ti->error = "Invalid offset";
 		return -EINVAL;
 	}
 
-	if (dm_get_device(ti, argv[0], dm_table_get_mode(ti->table),
-			  &ms->mirror[mirror].dev)) {
+	r = dm_get_device(ti, argv[0], dm_table_get_mode(ti->table),
+			  &ms->mirror[mirror].dev);
+	if (r) {
 		ti->error = "Device lookup failure";
-		return -ENXIO;
+		return r;
 	}
 
 	ms->mirror[mirror].ms = ms;
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index dddfa14..50f88b9 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -74,18 +74,19 @@ static inline struct stripe_c *alloc_context(unsigned int stripes)
 static int get_stripe(struct dm_target *ti, struct stripe_c *sc,
 		      unsigned int stripe, char **argv)
 {
+	int r;
 	unsigned long long start;
 
 	if (sscanf(argv[1], "%llu", &start) != 1)
 		return -EINVAL;
 
-	if (dm_get_device(ti, argv[0], dm_table_get_mode(ti->table),
-			  &sc->stripe[stripe].dev))
-		return -ENXIO;
+	r = dm_get_device(ti, argv[0], dm_table_get_mode(ti->table),
+			  &sc->stripe[stripe].dev);
 
-	sc->stripe[stripe].physical_start = start;
+	if (!r)
+		sc->stripe[stripe].physical_start = start;
 
-	return 0;
+	return r;
 }
 
 /*
-- 
1.7.2.3
