From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 1/1] device-mapper: Do not override error code
	from dm_get_device()
Date: Fri, 31 Jul 2015 09:20:36 -0400
Message-ID: <1438348836-20525-1-git-send-email-vgoyal@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
Cc: agk@redhat.com, snitzer@redhat.com, Vivek Goyal <vgoyal@redhat.com>
List-Id: dm-devel.ids

Some of the device mapper targets right now override return code returned
by dm_get_device() and return either -EINVAL or -ENXIO. It is not clear
what do we gain by that. It is better to propagate return code as it is
to caller.

I specifically ran into one issue where underlying device was busy but
I kept on getting -EINVAL. After this change we will get -EBUSY instead
and it will be easier to figure out what's the problem.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 drivers/md/dm-crypt.c      |  4 +++-
 drivers/md/dm-delay.c      | 16 +++++++++++-----
 drivers/md/dm-flakey.c     |  6 ++++--
 drivers/md/dm-linear.c     |  7 +++++--
 drivers/md/dm-log-writes.c | 11 ++++++++---
 drivers/md/dm-raid1.c      |  8 +++++---
 drivers/md/dm-stripe.c     |  8 +++++---
 7 files changed, 41 insertions(+), 19 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 0f48fed..7180f9e 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1811,11 +1811,13 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	}
 	cc->iv_offset = tmpll;
 
-	if (dm_get_device(ti, argv[3], dm_table_get_mode(ti->table), &cc->dev)) {
+	ret = dm_get_device(ti, argv[3], dm_table_get_mode(ti->table), &cc->dev);
+	if (ret ) {
 		ti->error = "Device lookup failed";
 		goto bad;
 	}
 
+	ret = -EINVAL;
 	if (sscanf(argv[4], "%llu%c", &tmpll, &dummy) != 1) {
 		ti->error = "Invalid device sector";
 		goto bad;
diff --git a/drivers/md/dm-delay.c b/drivers/md/dm-delay.c
index 57b6a19..b34f6e2 100644
--- a/drivers/md/dm-delay.c
+++ b/drivers/md/dm-delay.c
@@ -129,6 +129,7 @@ static int delay_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	struct delay_c *dc;
 	unsigned long long tmpll;
 	char dummy;
+	int ret;
 
 	if (argc != 3 && argc != 6) {
 		ti->error = "requires exactly 3 or 6 arguments";
@@ -143,6 +144,7 @@ static int delay_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	dc->reads = dc->writes = 0;
 
+	ret = -EINVAL;
 	if (sscanf(argv[1], "%llu%c", &tmpll, &dummy) != 1) {
 		ti->error = "Invalid device sector";
 		goto bad;
@@ -154,12 +156,14 @@ static int delay_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto bad;
 	}
 
-	if (dm_get_device(ti, argv[0], dm_table_get_mode(ti->table),
-			  &dc->dev_read)) {
+	ret = dm_get_device(ti, argv[0], dm_table_get_mode(ti->table),
+			    &dc->dev_read);
+	if (ret) {
 		ti->error = "Device lookup failed";
 		goto bad;
 	}
 
+	ret = -EINVAL;
 	dc->dev_write = NULL;
 	if (argc == 3)
 		goto out;
@@ -175,13 +179,15 @@ static int delay_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto bad_dev_read;
 	}
 
-	if (dm_get_device(ti, argv[3], dm_table_get_mode(ti->table),
-			  &dc->dev_write)) {
+	ret = dm_get_device(ti, argv[3], dm_table_get_mode(ti->table),
+			    &dc->dev_write);
+	if (ret) {
 		ti->error = "Write device lookup failed";
 		goto bad_dev_read;
 	}
 
 out:
+	ret = -EINVAL;
 	dc->kdelayd_wq = alloc_workqueue("kdelayd", WQ_MEM_RECLAIM, 0);
 	if (!dc->kdelayd_wq) {
 		DMERR("Couldn't start kdelayd");
@@ -208,7 +214,7 @@ bad_dev_read:
 	dm_put_device(ti, dc->dev_read);
 bad:
 	kfree(dc);
-	return -EINVAL;
+	return ret;
 }
 
 static void delay_dtr(struct dm_target *ti)
diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index b257e46..ffb99452 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -183,6 +183,7 @@ static int flakey_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	devname = dm_shift_arg(&as);
 
+	r = -EINVAL;
 	if (sscanf(dm_shift_arg(&as), "%llu%c", &tmpll, &dummy) != 1) {
 		ti->error = "Invalid device sector";
 		goto bad;
@@ -211,7 +212,8 @@ static int flakey_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	if (r)
 		goto bad;
 
-	if (dm_get_device(ti, devname, dm_table_get_mode(ti->table), &fc->dev)) {
+	r = dm_get_device(ti, devname, dm_table_get_mode(ti->table), &fc->dev);
+	if (r) {
 		ti->error = "Device lookup failed";
 		goto bad;
 	}
@@ -224,7 +226,7 @@ static int flakey_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 bad:
 	kfree(fc);
-	return -EINVAL;
+	return r;
 }
 
 static void flakey_dtr(struct dm_target *ti)
diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 53e848c..62c26e4 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -30,6 +30,7 @@ static int linear_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	struct linear_c *lc;
 	unsigned long long tmp;
 	char dummy;
+	int ret;
 
 	if (argc != 2) {
 		ti->error = "Invalid argument count";
@@ -42,13 +43,15 @@ static int linear_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		return -ENOMEM;
 	}
 
+	ret = -EINVAL;
 	if (sscanf(argv[1], "%llu%c", &tmp, &dummy) != 1) {
 		ti->error = "dm-linear: Invalid device sector";
 		goto bad;
 	}
 	lc->start = tmp;
 
-	if (dm_get_device(ti, argv[0], dm_table_get_mode(ti->table), &lc->dev)) {
+	ret = dm_get_device(ti, argv[0], dm_table_get_mode(ti->table), &lc->dev);
+	if (ret) {
 		ti->error = "dm-linear: Device lookup failed";
 		goto bad;
 	}
@@ -61,7 +64,7 @@ static int linear_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
       bad:
 	kfree(lc);
-	return -EINVAL;
+	return ret;
 }
 
 static void linear_dtr(struct dm_target *ti)
diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index ad1b049..51d29b6 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -420,6 +420,7 @@ static int log_writes_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	struct log_writes_c *lc;
 	struct dm_arg_set as;
 	const char *devname, *logdevname;
+	int ret;
 
 	as.argc = argc;
 	as.argv = argv;
@@ -443,18 +444,22 @@ static int log_writes_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	atomic_set(&lc->pending_blocks, 0);
 
 	devname = dm_shift_arg(&as);
-	if (dm_get_device(ti, devname, dm_table_get_mode(ti->table), &lc->dev)) {
+	ret = dm_get_device(ti, devname, dm_table_get_mode(ti->table), &lc->dev);
+	if (ret) {
 		ti->error = "Device lookup failed";
 		goto bad;
 	}
 
 	logdevname = dm_shift_arg(&as);
-	if (dm_get_device(ti, logdevname, dm_table_get_mode(ti->table), &lc->logdev)) {
+	ret = dm_get_device(ti, logdevname, dm_table_get_mode(ti->table),
+			    &lc->logdev);
+	if (ret) {
 		ti->error = "Log device lookup failed";
 		dm_put_device(ti, lc->dev);
 		goto bad;
 	}
 
+	ret = -EINVAL;
 	lc->log_kthread = kthread_run(log_writes_kthread, lc, "log-write");
 	if (!lc->log_kthread) {
 		ti->error = "Couldn't alloc kthread";
@@ -479,7 +484,7 @@ static int log_writes_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 bad:
 	kfree(lc);
-	return -EINVAL;
+	return ret;
 }
 
 static int log_mark(struct log_writes_c *lc, char *data)
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index d83696b..933a1fd 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -943,16 +943,18 @@ static int get_mirror(struct mirror_set *ms, struct dm_target *ti,
 {
 	unsigned long long offset;
 	char dummy;
+	int ret;
 
 	if (sscanf(argv[1], "%llu%c", &offset, &dummy) != 1) {
 		ti->error = "Invalid offset";
 		return -EINVAL;
 	}
 
-	if (dm_get_device(ti, argv[0], dm_table_get_mode(ti->table),
-			  &ms->mirror[mirror].dev)) {
+	ret = dm_get_device(ti, argv[0], dm_table_get_mode(ti->table),
+			    &ms->mirror[mirror].dev);
+	if (ret) {
 		ti->error = "Device lookup failure";
-		return -ENXIO;
+		return ret;
 	}
 
 	ms->mirror[mirror].ms = ms;
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index a672a15..9a814a5 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -75,13 +75,15 @@ static int get_stripe(struct dm_target *ti, struct stripe_c *sc,
 {
 	unsigned long long start;
 	char dummy;
+	int ret;
 
 	if (sscanf(argv[1], "%llu%c", &start, &dummy) != 1)
 		return -EINVAL;
 
-	if (dm_get_device(ti, argv[0], dm_table_get_mode(ti->table),
-			  &sc->stripe[stripe].dev))
-		return -ENXIO;
+	ret = dm_get_device(ti, argv[0], dm_table_get_mode(ti->table),
+			    &sc->stripe[stripe].dev);
+	if (ret)
+		return ret;
 
 	sc->stripe[stripe].physical_start = start;
 
-- 
2.1.0
