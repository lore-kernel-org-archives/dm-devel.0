From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 8/9] dm flakey: add ability to specify the
	corrupting value to be written
Date: Mon, 27 Jun 2011 15:53:42 -0400
Message-ID: <1309204423-8599-9-git-send-email-snitzer@redhat.com>
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

Add additional corrupting value argument to corrupt_bio_byte feature.
A value of either 0 or 1 will be written to the specified byte in the
bio.  Allowing other arbitrary corrupting values didn't seem necessary.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-flakey.c |   27 +++++++++++++++++++--------
 1 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index 0205b00..58cebca 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -29,6 +29,7 @@ struct flakey_c {
 	unsigned long flags;
 	unsigned corrupt_bio_byte;
 	unsigned corrupt_bio_flags;
+	unsigned corrupt_bio_value;
 };
 
 enum feature_flag_bits {
@@ -43,9 +44,10 @@ static int parse_features(struct dm_arg_set *as, struct flakey_c *fc,
 	const char *arg_name;
 
 	static struct dm_arg _args[] = {
-		{0, 4, "invalid number of feature args"},
+		{0, 5, "invalid number of feature args"},
 		{1, UINT_MAX, "invalid corrupt bio byte value"},
 		{0, UINT_MAX, "invalid corrupt bio flags mask"},
+		{0, 1, "invalid value to corrupt bio"},
 	};
 
 	r = dm_read_arg(_args, dm_shift_arg(as), &argc, &ti->error);
@@ -59,7 +61,7 @@ static int parse_features(struct dm_arg_set *as, struct flakey_c *fc,
 		arg_name = dm_shift_arg(as);
 		argc--;
 
-		/* corrupt_bio_byte <Nth byte> <bio_flags> */
+		/* corrupt_bio_byte <Nth byte> <bio_flags> <value> */
 		if (!strnicmp(arg_name, MESG_STR("corrupt_bio_byte")) &&
 		    (argc >= 1)) {
 			r = dm_read_arg(_args + 1, dm_shift_arg(as),
@@ -73,6 +75,11 @@ static int parse_features(struct dm_arg_set *as, struct flakey_c *fc,
 			r = dm_read_arg(_args + 2, dm_shift_arg(as),
 					&fc->corrupt_bio_flags, &ti->error);
 			argc--;
+
+			/* allow user to write a 0 or 1 to the specified byte */
+			r = dm_read_arg(_args + 3, dm_shift_arg(as),
+					&fc->corrupt_bio_value, &ti->error);
+			argc--;
 			continue;
 		}
 
@@ -202,10 +209,14 @@ static void corrupt_bio_data(struct bio *bio, struct flakey_c *fc)
 	unsigned bio_bytes = bio_cur_bytes(bio);
 	char *data = bio_data(bio);
 
-	/* write 0 to the specified Nth byte of the bio */
+	/* write to the specified Nth byte of the bio */
 	if (data && bio_bytes >= fc->corrupt_bio_byte) {
-		data[fc->corrupt_bio_byte-1] = 0;
-		printk("corrupting data rw=%lu\n", bio_data_dir(bio));
+		data[fc->corrupt_bio_byte-1] = fc->corrupt_bio_value;
+
+		printk("corrupting data bio=%p by writing %u to byte %u "
+		       "(rw=%lu flags=%lu bi_sector=%lu cur_bytes=%u)\n",
+		       bio, fc->corrupt_bio_value, fc->corrupt_bio_byte,
+		       bio_data_dir(bio), bio->bi_rw, bio->bi_sector, bio_bytes);
 	}
 }
 
@@ -281,11 +292,11 @@ static int flakey_status(struct dm_target *ti, status_type_t type,
 
 		drop_writes = test_bit(DROP_WRITES, &fc->flags);
 		DMEMIT("%u ", drop_writes +
-		              (fc->corrupt_bio_byte > 0) * 3);
+		              (fc->corrupt_bio_byte > 0) * 4);
 
 		if (fc->corrupt_bio_byte)
-			DMEMIT("corrupt_bio_byte %u %u ", fc->corrupt_bio_byte,
-			       fc->corrupt_bio_flags);
+			DMEMIT("corrupt_bio_byte %u %u %u ", fc->corrupt_bio_byte,
+			       fc->corrupt_bio_flags, fc->corrupt_bio_value);
 		if (drop_writes)
 			DMEMIT("drop_writes ");
 		break;
-- 
1.7.1
