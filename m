From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 7/9] dm flakey: switch corrupt_bio_data_dir to
	corrupt_bio_flags
Date: Mon, 27 Jun 2011 15:53:41 -0400
Message-ID: <1309204423-8599-8-git-send-email-snitzer@redhat.com>
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

User may specify a series of bio->bi_rw flags that must be seen in order
to trigger corruption (e.g. 33 = REQ_WRITE|REQ_META).

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-flakey.c |   35 ++++++++++++++++++++++-------------
 1 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index 54ab455..0205b00 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -28,7 +28,7 @@ struct flakey_c {
 	unsigned down_interval;
 	unsigned long flags;
 	unsigned corrupt_bio_byte;
-	unsigned corrupt_bio_data_dir;
+	unsigned corrupt_bio_flags;
 };
 
 enum feature_flag_bits {
@@ -45,7 +45,7 @@ static int parse_features(struct dm_arg_set *as, struct flakey_c *fc,
 	static struct dm_arg _args[] = {
 		{0, 4, "invalid number of feature args"},
 		{1, UINT_MAX, "invalid corrupt bio byte value"},
-		{0, 1, "invalid corrupt bio data direction"},
+		{0, UINT_MAX, "invalid corrupt bio flags mask"},
 	};
 
 	r = dm_read_arg(_args, dm_shift_arg(as), &argc, &ti->error);
@@ -59,19 +59,19 @@ static int parse_features(struct dm_arg_set *as, struct flakey_c *fc,
 		arg_name = dm_shift_arg(as);
 		argc--;
 
-		/* corrupt_bio_byte <Nth byte> <READ=0|WRITE=1> */
-		/* snitm: could also allow user to only corrupt bios that
-		 * have specific bi_rw flag(s), e.g.: (REQ_WRITE|REQ_META)?
-		 */
+		/* corrupt_bio_byte <Nth byte> <bio_flags> */
 		if (!strnicmp(arg_name, MESG_STR("corrupt_bio_byte")) &&
 		    (argc >= 1)) {
 			r = dm_read_arg(_args + 1, dm_shift_arg(as),
 					&fc->corrupt_bio_byte, &ti->error);
 			argc--;
 
-			/* corrupt reads or writes? */
+			/*
+			 * Only corrupt bios that have specific bi_rw flag(s),
+			 * e.g.: READ=0 or REQ_WRITE=1|REQ_META=32
+			 */
 			r = dm_read_arg(_args + 2, dm_shift_arg(as),
-					&fc->corrupt_bio_data_dir, &ti->error);
+					&fc->corrupt_bio_flags, &ti->error);
 			argc--;
 			continue;
 		}
@@ -193,14 +193,20 @@ static void flakey_map_bio(struct dm_target *ti, struct bio *bio)
 		bio->bi_sector = flakey_map_sector(ti, bio->bi_sector);
 }
 
+#define corrupt_bio_data_dir(fc)	((fc)->corrupt_bio_flags & 1)
+#define all_corrupt_bio_flags_match(fc, bio)	\
+	(((bio)->bi_rw & (fc)->corrupt_bio_flags) == (fc)->corrupt_bio_flags)
+
 static void corrupt_bio_data(struct bio *bio, struct flakey_c *fc)
 {
 	unsigned bio_bytes = bio_cur_bytes(bio);
 	char *data = bio_data(bio);
 
 	/* write 0 to the specified Nth byte of the bio */
-	if (data && bio_bytes >= fc->corrupt_bio_byte)
+	if (data && bio_bytes >= fc->corrupt_bio_byte) {
 		data[fc->corrupt_bio_byte-1] = 0;
+		printk("corrupting data rw=%lu\n", bio_data_dir(bio));
+	}
 }
 
 static int flakey_map(struct dm_target *ti, struct bio *bio,
@@ -214,9 +220,11 @@ static int flakey_map(struct dm_target *ti, struct bio *bio,
 	if (elapsed % (fc->up_interval + fc->down_interval) >= fc->up_interval) {
 		unsigned rw = bio_data_dir(bio);
 		if (fc->corrupt_bio_byte) {
-			/* only corrupt either reads or writes */
-			if (rw == WRITE && rw == fc->corrupt_bio_data_dir)
+			/* corrupt matching writes, defer reads until end_io */
+			if (rw == WRITE && rw == corrupt_bio_data_dir(fc) &&
+			    all_corrupt_bio_flags_match(fc, bio))
 				corrupt_bio_data(bio, fc);
+
 			/* flag this bio as submitted while down */
 			map_context->ll = 1;
 			goto map_bio;
@@ -247,7 +255,8 @@ static int flakey_end_io(struct dm_target *ti, struct bio *bio,
 	unsigned rw = bio_data_dir(bio);
 
 	if (!error && bio_submitted_while_down)
-		if (rw == READ && rw == fc->corrupt_bio_data_dir)
+		if (rw == READ && rw == corrupt_bio_data_dir(fc) &&
+		    all_corrupt_bio_flags_match(fc, bio))
 			corrupt_bio_data(bio, fc);
 
 	return error;
@@ -276,7 +285,7 @@ static int flakey_status(struct dm_target *ti, status_type_t type,
 
 		if (fc->corrupt_bio_byte)
 			DMEMIT("corrupt_bio_byte %u %u ", fc->corrupt_bio_byte,
-			       fc->corrupt_bio_data_dir);
+			       fc->corrupt_bio_flags);
 		if (drop_writes)
 			DMEMIT("drop_writes ");
 		break;
-- 
1.7.1
