From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 14/20] dm-crypt: move error handling to
	crypt_convert.
Date: Tue, 21 Aug 2012 11:09:25 +0200
Message-ID: <08b17304bd93eacf540dd5c2b10e1aa3d38b680d.1345477953.git.mbroz@redhat.com>
References: <cover.1345477953.git.mbroz@redhat.com>
	<520994e0c87d38ca6abb8dd60760aef993842a32.1345477953.git.mbroz@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <520994e0c87d38ca6abb8dd60760aef993842a32.1345477953.git.mbroz@redhat.com>
In-Reply-To: <cover.1345477953.git.mbroz@redhat.com>
References: <cover.1345477953.git.mbroz@redhat.com>
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
Cc: Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

This patch moves error handling to crypt_convert and makes crypt_convert
return void instead of the error number.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-crypt.c |   24 +++++++-----------------
 1 file changed, 7 insertions(+), 17 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index bb11a95..6f18838 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -825,16 +825,16 @@ static void crypt_dec_cc_pending(struct dm_crypt_io *io)
 /*
  * Encrypt / decrypt data from one bio to another one (can be the same one)
  */
-static int crypt_convert(struct crypt_config *cc,
-			 struct dm_crypt_io *io)
+static void crypt_convert(struct crypt_config *cc,
+			  struct dm_crypt_io *io)
 {
-	int r;
 	LIST_HEAD(batch);
 	unsigned batch_count = 0;
 
 	atomic_set(&io->cc_pending, 1);
 
 	while (1) {
+		int r;
 		struct ablkcipher_request *req = crypt_alloc_req(cc, io, GFP_NOWAIT);
 		if (!req) {
 			/*
@@ -849,8 +849,9 @@ static int crypt_convert(struct crypt_config *cc,
 		r = crypt_convert_block(cc, io, req, &batch);
 		if (unlikely(r < 0)) {
 			crypt_flush_batch(cc, &batch);
+			io->error = -EIO;
 			crypt_dec_cc_pending(io);
-			goto ret;
+			return;
 		}
 
 		io->sector++;
@@ -866,12 +867,8 @@ static int crypt_convert(struct crypt_config *cc,
 		}
 		break;
 	}
-	r = 0;
 
 	crypt_flush_batch(cc, &batch);
-ret:
-
-	return r;
 }
 
 static void dm_crypt_bio_destructor(struct bio *bio)
@@ -1134,7 +1131,6 @@ static void kcryptd_crypt_write_convert(struct dm_crypt_io *io)
 	struct bio *clone;
 	unsigned remaining = io->base_bio->bi_size;
 	sector_t sector = io->sector;
-	int r;
 
 	/*
 	 * Prevent io from disappearing until this function completes.
@@ -1155,9 +1151,7 @@ static void kcryptd_crypt_write_convert(struct dm_crypt_io *io)
 	sector += bio_sectors(clone);
 
 	crypt_inc_pending(io);
-	r = crypt_convert(cc, io);
-	if (r)
-		io->error = -EIO;
+	crypt_convert(cc, io);
 dec:
 	crypt_dec_pending(io);
 }
@@ -1165,17 +1159,13 @@ dec:
 static void kcryptd_crypt_read_convert(struct dm_crypt_io *io)
 {
 	struct crypt_config *cc = io->cc;
-	int r = 0;
 
 	crypt_inc_pending(io);
 
 	crypt_convert_init(cc, io, io->base_bio, io->base_bio,
 			   io->sector);
 
-	r = crypt_convert(cc, io);
-	if (r < 0)
-		io->error = -EIO;
-
+	crypt_convert(cc, io);
 	crypt_dec_pending(io);
 }
 
-- 
1.7.10.4
