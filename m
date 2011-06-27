From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5/9] dm flakey: add corrupt_bio_byte feature
Date: Mon, 27 Jun 2011 15:53:39 -0400
Message-ID: <1309204423-8599-6-git-send-email-snitzer@redhat.com>
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

Add 'corrupt_bio_byte' feature that will write 0 to the specified Nth
byte of each bio (when the device is "down").

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-flakey.c |   35 +++++++++++++++++++++++++++++++++--
 1 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index 618f313..b26f61d 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -27,6 +27,7 @@ struct flakey_c {
 	unsigned up_interval;
 	unsigned down_interval;
 	unsigned long flags;
+	unsigned corrupt_bio_byte;
 };
 
 enum feature_flag_bits {
@@ -41,7 +42,8 @@ static int parse_features(struct dm_arg_set *as, struct flakey_c *fc,
 	const char *arg_name;
 
 	static struct dm_arg _args[] = {
-		{0, 1, "invalid number of feature args"},
+		{0, 3, "invalid number of feature args"},
+		{1, UINT_MAX, "invalid corrupt bio byte value"},
 	};
 
 	r = dm_read_arg(_args, dm_shift_arg(as), &argc, &ti->error);
@@ -55,6 +57,15 @@ static int parse_features(struct dm_arg_set *as, struct flakey_c *fc,
 		arg_name = dm_shift_arg(as);
 		argc--;
 
+		/* corrupt_bio_byte <Nth byte> */
+		if (!strnicmp(arg_name, MESG_STR("corrupt_bio_byte")) &&
+		    (argc >= 1)) {
+			r = dm_read_arg(_args + 1, dm_shift_arg(as),
+					&fc->corrupt_bio_byte, &ti->error);
+			argc--;
+			continue;
+		}
+
 		if (!strnicmp(arg_name, MESG_STR("drop_writes"))) {
 			set_bit(DROP_WRITES, &fc->flags);
 			continue;
@@ -172,6 +183,16 @@ static void flakey_map_bio(struct dm_target *ti, struct bio *bio)
 		bio->bi_sector = flakey_map_sector(ti, bio->bi_sector);
 }
 
+static void corrupt_bio_data(struct bio *bio, struct flakey_c *fc)
+{
+	unsigned bio_bytes = bio_cur_bytes(bio);
+	char *data = bio_data(bio);
+
+	/* write 0 to the specified Nth byte of the bio */
+	if (data && bio_bytes >= fc->corrupt_bio_byte)
+		data[fc->corrupt_bio_byte-1] = 0;
+}
+
 static int flakey_map(struct dm_target *ti, struct bio *bio,
 		      union map_info *map_context)
 {
@@ -182,6 +203,12 @@ static int flakey_map(struct dm_target *ti, struct bio *bio,
 	elapsed = (jiffies - fc->start_time) / HZ;
 	if (elapsed % (fc->up_interval + fc->down_interval) >= fc->up_interval) {
 		unsigned rw = bio_data_dir(bio);
+		if (fc->corrupt_bio_byte) {
+			/* corrupt writes but don't touch reads */
+			if (rw == WRITE)
+				corrupt_bio_data(bio, fc);
+			goto map_bio;
+		}
 		if (test_bit(DROP_WRITES, &fc->flags)) {
 			/* drop writes but don't error reads */
 			if (rw == WRITE) {
@@ -218,7 +245,11 @@ static int flakey_status(struct dm_target *ti, status_type_t type,
 		       fc->down_interval);
 
 		drop_writes = test_bit(DROP_WRITES, &fc->flags);
-		DMEMIT("%u ", drop_writes);
+		DMEMIT("%u ", drop_writes +
+		              (fc->corrupt_bio_byte > 0) * 2);
+
+		if (fc->corrupt_bio_byte)
+			DMEMIT("corrupt_bio_byte %u ", fc->corrupt_bio_byte);
 		if (drop_writes)
 			DMEMIT("drop_writes ");
 		break;
-- 
1.7.1
