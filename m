From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4/9] dm flakey: add drop_writes feature
Date: Mon, 27 Jun 2011 15:53:38 -0400
Message-ID: <1309204423-8599-5-git-send-email-snitzer@redhat.com>
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

Add 'drop_writes' feature that will silently drop writes (when the
device is "down").  Reads are not touched.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-flakey.c |   47 +++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 39 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index ae2107f..618f313 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -14,6 +14,7 @@
 #include <linux/slab.h>
 
 #define DM_MSG_PREFIX "flakey"
+#define MESG_STR(x) x, sizeof(x)
 
 /*
  * Flakey: Used for testing only, simulates intermittent,
@@ -25,16 +26,22 @@ struct flakey_c {
 	sector_t start;
 	unsigned up_interval;
 	unsigned down_interval;
+	unsigned long flags;
 };
 
-static int parse_features(struct dm_arg_set *as, struct dm_target *ti)
+enum feature_flag_bits {
+	DROP_WRITES
+};
+
+static int parse_features(struct dm_arg_set *as, struct flakey_c *fc,
+			  struct dm_target *ti)
 {
 	int r;
 	unsigned argc;
 	const char *arg_name;
 
 	static struct dm_arg _args[] = {
-		{0, 0, "invalid number of feature args"},
+		{0, 1, "invalid number of feature args"},
 	};
 
 	r = dm_read_arg(_args, dm_shift_arg(as), &argc, &ti->error);
@@ -48,6 +55,11 @@ static int parse_features(struct dm_arg_set *as, struct dm_target *ti)
 		arg_name = dm_shift_arg(as);
 		argc--;
 
+		if (!strnicmp(arg_name, MESG_STR("drop_writes"))) {
+			set_bit(DROP_WRITES, &fc->flags);
+			continue;
+		}
+
 		ti->error = "Unrecognised flakey feature request";
 		r = -EINVAL;
 	}
@@ -80,7 +92,7 @@ static int flakey_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		return -EINVAL;
 	}
 
-	fc = kmalloc(sizeof(*fc), GFP_KERNEL);
+	fc = kzalloc(sizeof(*fc), GFP_KERNEL);
 	if (!fc) {
 		ti->error = "dm-flakey: Cannot allocate linear context";
 		return -ENOMEM;
@@ -117,7 +129,7 @@ static int flakey_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto bad;
 	}
 
-	r = parse_features(&as, ti);
+	r = parse_features(&as, fc, ti);
 	if (r)
 		goto bad;
 
@@ -168,9 +180,21 @@ static int flakey_map(struct dm_target *ti, struct bio *bio,
 
 	/* Are we alive ? */
 	elapsed = (jiffies - fc->start_time) / HZ;
-	if (elapsed % (fc->up_interval + fc->down_interval) >= fc->up_interval)
+	if (elapsed % (fc->up_interval + fc->down_interval) >= fc->up_interval) {
+		unsigned rw = bio_data_dir(bio);
+		if (test_bit(DROP_WRITES, &fc->flags)) {
+			/* drop writes but don't error reads */
+			if (rw == WRITE) {
+				bio_endio(bio, 0);
+				return DM_MAPIO_SUBMITTED;
+			} else
+				goto map_bio;
+		}
+		/* default, when down without features, is to error all IO */
 		return -EIO;
+	}
 
+map_bio:
 	flakey_map_bio(ti, bio);
 
 	return DM_MAPIO_REMAPPED;
@@ -179,7 +203,9 @@ static int flakey_map(struct dm_target *ti, struct bio *bio,
 static int flakey_status(struct dm_target *ti, status_type_t type,
 			 char *result, unsigned int maxlen)
 {
+	unsigned sz = 0;
 	struct flakey_c *fc = ti->private;
+	unsigned drop_writes;
 
 	switch (type) {
 	case STATUSTYPE_INFO:
@@ -187,9 +213,14 @@ static int flakey_status(struct dm_target *ti, status_type_t type,
 		break;
 
 	case STATUSTYPE_TABLE:
-		snprintf(result, maxlen, "%s %llu %u %u", fc->dev->name,
-			 (unsigned long long)fc->start, fc->up_interval,
-			 fc->down_interval);
+		DMEMIT("%s %llu %u %u ", fc->dev->name,
+		       (unsigned long long)fc->start, fc->up_interval,
+		       fc->down_interval);
+
+		drop_writes = test_bit(DROP_WRITES, &fc->flags);
+		DMEMIT("%u ", drop_writes);
+		if (drop_writes)
+			DMEMIT("drop_writes ");
 		break;
 	}
 	return 0;
-- 
1.7.1
