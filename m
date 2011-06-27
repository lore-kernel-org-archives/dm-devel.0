From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 9/9] dm flakey: add debug feature to control
	debug output
Date: Mon, 27 Jun 2011 15:53:43 -0400
Message-ID: <1309204423-8599-10-git-send-email-snitzer@redhat.com>
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

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-flakey.c |   28 ++++++++++++++++++++--------
 1 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index 58cebca..d0b5042 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -33,7 +33,8 @@ struct flakey_c {
 };
 
 enum feature_flag_bits {
-	DROP_WRITES
+	DROP_WRITES,
+	FLAKEY_DEBUG
 };
 
 static int parse_features(struct dm_arg_set *as, struct flakey_c *fc,
@@ -44,7 +45,7 @@ static int parse_features(struct dm_arg_set *as, struct flakey_c *fc,
 	const char *arg_name;
 
 	static struct dm_arg _args[] = {
-		{0, 5, "invalid number of feature args"},
+		{0, 6, "invalid number of feature args"},
 		{1, UINT_MAX, "invalid corrupt bio byte value"},
 		{0, UINT_MAX, "invalid corrupt bio flags mask"},
 		{0, 1, "invalid value to corrupt bio"},
@@ -88,6 +89,11 @@ static int parse_features(struct dm_arg_set *as, struct flakey_c *fc,
 			continue;
 		}
 
+		if (!strnicmp(arg_name, MESG_STR("debug"))) {
+			set_bit(FLAKEY_DEBUG, &fc->flags);
+			continue;
+		}
+
 		ti->error = "Unrecognised flakey feature request";
 		r = -EINVAL;
 	}
@@ -213,10 +219,12 @@ static void corrupt_bio_data(struct bio *bio, struct flakey_c *fc)
 	if (data && bio_bytes >= fc->corrupt_bio_byte) {
 		data[fc->corrupt_bio_byte-1] = fc->corrupt_bio_value;
 
-		printk("corrupting data bio=%p by writing %u to byte %u "
-		       "(rw=%lu flags=%lu bi_sector=%lu cur_bytes=%u)\n",
-		       bio, fc->corrupt_bio_value, fc->corrupt_bio_byte,
-		       bio_data_dir(bio), bio->bi_rw, bio->bi_sector, bio_bytes);
+		if (test_bit(FLAKEY_DEBUG, &fc->flags))
+			printk("corrupting data bio=%p by writing %u to byte %u "
+			       "(rw=%lu flags=%lu bi_sector=%lu cur_bytes=%u)\n",
+			       bio, fc->corrupt_bio_value, fc->corrupt_bio_byte,
+			       bio_data_dir(bio), bio->bi_rw, bio->bi_sector,
+			       bio_bytes);
 	}
 }
 
@@ -278,7 +286,7 @@ static int flakey_status(struct dm_target *ti, status_type_t type,
 {
 	unsigned sz = 0;
 	struct flakey_c *fc = ti->private;
-	unsigned drop_writes;
+	unsigned drop_writes, flakey_debug;
 
 	switch (type) {
 	case STATUSTYPE_INFO:
@@ -291,14 +299,18 @@ static int flakey_status(struct dm_target *ti, status_type_t type,
 		       fc->down_interval);
 
 		drop_writes = test_bit(DROP_WRITES, &fc->flags);
+		flakey_debug = test_bit(FLAKEY_DEBUG, &fc->flags);
 		DMEMIT("%u ", drop_writes +
-		              (fc->corrupt_bio_byte > 0) * 4);
+		              (fc->corrupt_bio_byte > 0) * 4 +
+		              flakey_debug);
 
 		if (fc->corrupt_bio_byte)
 			DMEMIT("corrupt_bio_byte %u %u %u ", fc->corrupt_bio_byte,
 			       fc->corrupt_bio_flags, fc->corrupt_bio_value);
 		if (drop_writes)
 			DMEMIT("drop_writes ");
+		if (flakey_debug)
+			DMEMIT("debug ");
 		break;
 	}
 	return 0;
-- 
1.7.1
