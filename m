From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 6/9] dm flakey: add corrupt_bio_byte read support
Date: Mon, 27 Jun 2011 15:53:40 -0400
Message-ID: <1309204423-8599-7-git-send-email-snitzer@redhat.com>
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

Use .end_io hook to corrupt_bio_data() after reads complete.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-flakey.c |   40 ++++++++++++++++++++++++++++++++++------
 1 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index b26f61d..54ab455 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -28,6 +28,7 @@ struct flakey_c {
 	unsigned down_interval;
 	unsigned long flags;
 	unsigned corrupt_bio_byte;
+	unsigned corrupt_bio_data_dir;
 };
 
 enum feature_flag_bits {
@@ -42,8 +43,9 @@ static int parse_features(struct dm_arg_set *as, struct flakey_c *fc,
 	const char *arg_name;
 
 	static struct dm_arg _args[] = {
-		{0, 3, "invalid number of feature args"},
+		{0, 4, "invalid number of feature args"},
 		{1, UINT_MAX, "invalid corrupt bio byte value"},
+		{0, 1, "invalid corrupt bio data direction"},
 	};
 
 	r = dm_read_arg(_args, dm_shift_arg(as), &argc, &ti->error);
@@ -57,12 +59,20 @@ static int parse_features(struct dm_arg_set *as, struct flakey_c *fc,
 		arg_name = dm_shift_arg(as);
 		argc--;
 
-		/* corrupt_bio_byte <Nth byte> */
+		/* corrupt_bio_byte <Nth byte> <READ=0|WRITE=1> */
+		/* snitm: could also allow user to only corrupt bios that
+		 * have specific bi_rw flag(s), e.g.: (REQ_WRITE|REQ_META)?
+		 */
 		if (!strnicmp(arg_name, MESG_STR("corrupt_bio_byte")) &&
 		    (argc >= 1)) {
 			r = dm_read_arg(_args + 1, dm_shift_arg(as),
 					&fc->corrupt_bio_byte, &ti->error);
 			argc--;
+
+			/* corrupt reads or writes? */
+			r = dm_read_arg(_args + 2, dm_shift_arg(as),
+					&fc->corrupt_bio_data_dir, &ti->error);
+			argc--;
 			continue;
 		}
 
@@ -204,9 +214,11 @@ static int flakey_map(struct dm_target *ti, struct bio *bio,
 	if (elapsed % (fc->up_interval + fc->down_interval) >= fc->up_interval) {
 		unsigned rw = bio_data_dir(bio);
 		if (fc->corrupt_bio_byte) {
-			/* corrupt writes but don't touch reads */
-			if (rw == WRITE)
+			/* only corrupt either reads or writes */
+			if (rw == WRITE && rw == fc->corrupt_bio_data_dir)
 				corrupt_bio_data(bio, fc);
+			/* flag this bio as submitted while down */
+			map_context->ll = 1;
 			goto map_bio;
 		}
 		if (test_bit(DROP_WRITES, &fc->flags)) {
@@ -227,6 +239,20 @@ map_bio:
 	return DM_MAPIO_REMAPPED;
 }
 
+static int flakey_end_io(struct dm_target *ti, struct bio *bio,
+			 int error, union map_info *map_context)
+{
+	struct flakey_c *fc = ti->private;
+	unsigned bio_submitted_while_down = map_context->ll;
+	unsigned rw = bio_data_dir(bio);
+
+	if (!error && bio_submitted_while_down)
+		if (rw == READ && rw == fc->corrupt_bio_data_dir)
+			corrupt_bio_data(bio, fc);
+
+	return error;
+}
+
 static int flakey_status(struct dm_target *ti, status_type_t type,
 			 char *result, unsigned int maxlen)
 {
@@ -246,10 +272,11 @@ static int flakey_status(struct dm_target *ti, status_type_t type,
 
 		drop_writes = test_bit(DROP_WRITES, &fc->flags);
 		DMEMIT("%u ", drop_writes +
-		              (fc->corrupt_bio_byte > 0) * 2);
+		              (fc->corrupt_bio_byte > 0) * 3);
 
 		if (fc->corrupt_bio_byte)
-			DMEMIT("corrupt_bio_byte %u ", fc->corrupt_bio_byte);
+			DMEMIT("corrupt_bio_byte %u %u ", fc->corrupt_bio_byte,
+			       fc->corrupt_bio_data_dir);
 		if (drop_writes)
 			DMEMIT("drop_writes ");
 		break;
@@ -293,6 +320,7 @@ static struct target_type flakey_target = {
 	.ctr    = flakey_ctr,
 	.dtr    = flakey_dtr,
 	.map    = flakey_map,
+	.end_io = flakey_end_io,
 	.status = flakey_status,
 	.ioctl	= flakey_ioctl,
 	.merge	= flakey_merge,
-- 
1.7.1
