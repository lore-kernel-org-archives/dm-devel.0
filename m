From: Nikanth Karthikesan <knikanth@novell.com>
Subject: [PATCH] Remove unused parameters of dm_get_device
Date: Wed, 10 Feb 2010 17:07:02 +0530
Message-ID: <201002101707.02501.knikanth@novell.com>
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
To: device-mapper development <dm-devel@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Remove unused parameters(start and len) of dm_get_device()
and fix the callers.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index a936372..080381b 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1160,8 +1160,8 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	}
 	cc->start = tmpll;
 
-	if (dm_get_device(ti, argv[3], cc->start, ti->len,
-			  dm_table_get_mode(ti->table), &cc->dev)) {
+	if (dm_get_device(ti, argv[3], dm_table_get_mode(ti->table),
+							&cc->dev)) {
 		ti->error = "Device lookup failed";
 		goto bad_device;
 	}
diff --git a/drivers/md/dm-delay.c b/drivers/md/dm-delay.c
index ebe7381..cf28798 100644
--- a/drivers/md/dm-delay.c
+++ b/drivers/md/dm-delay.c
@@ -156,8 +156,8 @@ static int delay_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto bad;
 	}
 
-	if (dm_get_device(ti, argv[0], dc->start_read, ti->len,
-			  dm_table_get_mode(ti->table), &dc->dev_read)) {
+	if (dm_get_device(ti, argv[0], dm_table_get_mode(ti->table),
+							&dc->dev_read)) {
 		ti->error = "Device lookup failed";
 		goto bad;
 	}
@@ -177,8 +177,8 @@ static int delay_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto bad_dev_read;
 	}
 
-	if (dm_get_device(ti, argv[3], dc->start_write, ti->len,
-			  dm_table_get_mode(ti->table), &dc->dev_write)) {
+	if (dm_get_device(ti, argv[3], dm_table_get_mode(ti->table),
+							&dc->dev_write)) {
 		ti->error = "Write device lookup failed";
 		goto bad_dev_read;
 	}
diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 82f7d6e..bfc43e2 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -47,8 +47,8 @@ static int linear_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	}
 	lc->start = tmp;
 
-	if (dm_get_device(ti, argv[0], lc->start, ti->len,
-			  dm_table_get_mode(ti->table), &lc->dev)) {
+	if (dm_get_device(ti, argv[0], dm_table_get_mode(ti->table),
+							&lc->dev)) {
 		ti->error = "dm-linear: Device lookup failed";
 		goto bad;
 	}
diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
index 7035582..5a08be0 100644
--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -543,8 +543,7 @@ static int disk_ctr(struct dm_dirty_log *log, struct dm_target *ti,
 		return -EINVAL;
 	}
 
-	r = dm_get_device(ti, argv[0], 0, 0 /* FIXME */,
-			  FMODE_READ | FMODE_WRITE, &dev);
+	r = dm_get_device(ti, argv[0], FMODE_READ | FMODE_WRITE, &dev);
 	if (r)
 		return r;
 
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index e81345a..255a30d 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -597,8 +597,8 @@ static struct pgpath *parse_path(struct arg_set *as, struct path_selector *ps,
 	if (!p)
 		return ERR_PTR(-ENOMEM);
 
-	r = dm_get_device(ti, shift(as), ti->begin, ti->len,
-			  dm_table_get_mode(ti->table), &p->path.dev);
+	r = dm_get_device(ti, shift(as), dm_table_get_mode(ti->table),
+							 &p->path.dev);
 	if (r) {
 		ti->error = "error getting device";
 		goto bad;
@@ -1471,8 +1471,7 @@ static int multipath_message(struct dm_target *ti, unsigned argc, char **argv)
 		goto out;
 	}
 
-	r = dm_get_device(ti, argv[1], ti->begin, ti->len,
-			  dm_table_get_mode(ti->table), &dev);
+	r = dm_get_device(ti, argv[1], dm_table_get_mode(ti->table), &dev);
 	if (r) {
 		DMWARN("message: error getting device %s",
 		       argv[1]);
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index ad779bd..8642f19 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -917,9 +917,8 @@ static int get_mirror(struct mirror_set *ms, struct dm_target *ti,
 		return -EINVAL;
 	}
 
-	if (dm_get_device(ti, argv[0], offset, ti->len,
-			  dm_table_get_mode(ti->table),
-			  &ms->mirror[mirror].dev)) {
+	if (dm_get_device(ti, argv[0], dm_table_get_mode(ti->table),
+					  &ms->mirror[mirror].dev)) {
 		ti->error = "Device lookup failure";
 		return -ENXIO;
 	}
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index ee8eb28..0789c22 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1081,8 +1081,7 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	argv++;
 	argc--;
 
-	r = dm_get_device(ti, cow_path, 0, 0,
-			  FMODE_READ | FMODE_WRITE, &s->cow);
+	r = dm_get_device(ti, cow_path, FMODE_READ | FMODE_WRITE, &s->cow);
 	if (r) {
 		ti->error = "Cannot get COW device";
 		goto bad_cow;
@@ -1098,7 +1097,7 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	argv += args_used;
 	argc -= args_used;
 
-	r = dm_get_device(ti, origin_path, 0, ti->len, origin_mode, &s->origin);
+	r = dm_get_device(ti, origin_path, origin_mode, &s->origin);
 	if (r) {
 		ti->error = "Cannot get origin device";
 		goto bad_origin;
@@ -2100,8 +2099,7 @@ static int origin_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		return -EINVAL;
 	}
 
-	r = dm_get_device(ti, argv[0], 0, ti->len,
-			  dm_table_get_mode(ti->table), &dev);
+	r = dm_get_device(ti, argv[0], dm_table_get_mode(ti->table), &dev);
 	if (r) {
 		ti->error = "Cannot get target device";
 		return r;
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index e0efc1a..c9ed557 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -80,9 +80,8 @@ static int get_stripe(struct dm_target *ti, struct stripe_c *sc,
 	if (sscanf(argv[1], "%llu", &start) != 1)
 		return -EINVAL;
 
-	if (dm_get_device(ti, argv[0], start, sc->stripe_width,
-			  dm_table_get_mode(ti->table),
-			  &sc->stripe[stripe].dev))
+	if (dm_get_device(ti, argv[0], dm_table_get_mode(ti->table),
+				  &sc->stripe[stripe].dev))
 		return -ENXIO;
 
 	sc->stripe[stripe].physical_start = start;
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 4b22feb..dd08441 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -429,8 +429,7 @@ static int upgrade_mode(struct dm_dev_internal *dd, fmode_t new_mode,
  * it's already present.
  */
 static int __table_get_device(struct dm_table *t, struct dm_target *ti,
-			      const char *path, sector_t start, sector_t len,
-			      fmode_t mode, struct dm_dev **result)
+		      const char *path, fmode_t mode, struct dm_dev **result)
 {
 	int r;
 	dev_t uninitialized_var(dev);
@@ -527,11 +526,10 @@ int dm_set_device_limits(struct dm_target *ti, struct dm_dev *dev,
 }
 EXPORT_SYMBOL_GPL(dm_set_device_limits);
 
-int dm_get_device(struct dm_target *ti, const char *path, sector_t start,
-		  sector_t len, fmode_t mode, struct dm_dev **result)
+int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
+						struct dm_dev **result)
 {
-	return __table_get_device(ti->table, ti, path,
-				  start, len, mode, result);
+	return __table_get_device(ti->table, ti, path, mode, result);
 }
 
 
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index d4c9c0b..1381cd9 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -118,10 +118,9 @@ struct dm_dev {
 /*
  * Constructors should call these functions to ensure destination devices
  * are opened/closed correctly.
- * FIXME: too many arguments.
  */
-int dm_get_device(struct dm_target *ti, const char *path, sector_t start,
-		  sector_t len, fmode_t mode, struct dm_dev **result);
+int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
+						 struct dm_dev **result);
 void dm_put_device(struct dm_target *ti, struct dm_dev *d);
 
 /*
