From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3/9] dm flakey: start of adding features
Date: Mon, 27 Jun 2011 15:53:37 -0400
Message-ID: <1309204423-8599-4-git-send-email-snitzer@redhat.com>
References: <1309204423-8599-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1309204423-8599-1-git-send-email-snitzer@redhat.com>
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
Cc: Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Add the ability to specify arbitrary feature flags when creating a
flakey target.  This code uses the same target argument helpers that
the multipath target does.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-flakey.c |   68 ++++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 58 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index 70a69b2..ae2107f 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -27,15 +27,55 @@ struct flakey_c {
 	unsigned down_interval;
 };
 
+static int parse_features(struct dm_arg_set *as, struct dm_target *ti)
+{
+	int r;
+	unsigned argc;
+	const char *arg_name;
+
+	static struct dm_arg _args[] = {
+		{0, 0, "invalid number of feature args"},
+	};
+
+	r = dm_read_arg(_args, dm_shift_arg(as), &argc, &ti->error);
+	if (r)
+		return -EINVAL;
+
+	if (!argc)
+		return 0;
+
+	while (argc && !r) {
+		arg_name = dm_shift_arg(as);
+		argc--;
+
+		ti->error = "Unrecognised flakey feature request";
+		r = -EINVAL;
+	}
+
+	return 0;
+}
+
 /*
- * Construct a flakey mapping: <dev_path> <offset> <up interval> <down interval>
+ * Construct a flakey mapping:
+ * <dev_path> <offset> <up interval> <down interval> <#feature args> [<arg>]*
  */
 static int flakey_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
+	static struct dm_arg _args[] = {
+		{0, UINT_MAX, "dm-flakey: Invalid up interval"},
+		{0, UINT_MAX, "dm-flakey: Invalid down interval"},
+	};
+
+	int r;
 	struct flakey_c *fc;
 	unsigned long long tmp;
+	struct dm_arg_set as;
+	const char *devname;
 
-	if (argc != 4) {
+	as.argc = argc;
+	as.argv = argv;
+
+	if (argc < 5) {
 		ti->error = "dm-flakey: Invalid argument count";
 		return -EINVAL;
 	}
@@ -47,21 +87,25 @@ static int flakey_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	}
 	fc->start_time = jiffies;
 
+	devname = argv[0];
+	as.argc--;
+	as.argv++;
+
 	if (sscanf(argv[1], "%llu", &tmp) != 1) {
 		ti->error = "dm-flakey: Invalid device sector";
 		goto bad;
 	}
 	fc->start = tmp;
+	as.argc--;
+	as.argv++;
 
-	if (sscanf(argv[2], "%u", &fc->up_interval) != 1) {
-		ti->error = "dm-flakey: Invalid up interval";
+	r = dm_read_arg(_args, dm_shift_arg(&as), &fc->up_interval, &ti->error);
+	if (r)
 		goto bad;
-	}
 
-	if (sscanf(argv[3], "%u", &fc->down_interval) != 1) {
-		ti->error = "dm-flakey: Invalid down interval";
+	r = dm_read_arg(_args, dm_shift_arg(&as), &fc->down_interval, &ti->error);
+	if (r)
 		goto bad;
-	}
 
 	if (!(fc->up_interval + fc->down_interval)) {
 		ti->error = "dm-flakey: Total (up + down) interval is zero";
@@ -73,7 +117,11 @@ static int flakey_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto bad;
 	}
 
-	if (dm_get_device(ti, argv[0], dm_table_get_mode(ti->table), &fc->dev)) {
+	r = parse_features(&as, ti);
+	if (r)
+		goto bad;
+
+	if (dm_get_device(ti, devname, dm_table_get_mode(ti->table), &fc->dev)) {
 		ti->error = "dm-flakey: Device lookup failed";
 		goto bad;
 	}
@@ -178,7 +226,7 @@ static int flakey_iterate_devices(struct dm_target *ti, iterate_devices_callout_
 
 static struct target_type flakey_target = {
 	.name   = "flakey",
-	.version = {1, 1, 0},
+	.version = {1, 2, 0},
 	.module = THIS_MODULE,
 	.ctr    = flakey_ctr,
 	.dtr    = flakey_dtr,
-- 
1.7.1
