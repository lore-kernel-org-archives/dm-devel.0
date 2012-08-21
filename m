From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 03/20] dm-crypt: remove completion restart
Date: Tue, 21 Aug 2012 11:09:14 +0200
Message-ID: <e6e330f98ea5a68bc6889669ba079f4dbc7d8f03.1345477953.git.mbroz@redhat.com>
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

It won't be used in this context anyway.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-crypt.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 4c8b4e0..144c337 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -34,7 +34,6 @@
  * context holding the current state of a multi-part conversion
  */
 struct convert_context {
-	struct completion restart;
 	struct bio *bio_in;
 	struct bio *bio_out;
 	unsigned int offset_in;
@@ -636,7 +635,6 @@ static void crypt_convert_init(struct crypt_config *cc,
 	ctx->idx_in = bio_in ? bio_in->bi_idx : 0;
 	ctx->idx_out = bio_out ? bio_out->bi_idx : 0;
 	ctx->cc_sector = sector + cc->iv_offset;
-	init_completion(&ctx->restart);
 }
 
 static struct dm_crypt_request *dmreq_of_req(struct crypt_config *cc,
@@ -752,8 +750,6 @@ static int crypt_convert(struct crypt_config *cc,
 		switch (r) {
 		/* async */
 		case -EBUSY:
-			wait_for_completion(&ctx->restart);
-			INIT_COMPLETION(ctx->restart);
 			/* fall through*/
 		case -EINPROGRESS:
 			ctx->req = NULL;
@@ -1167,7 +1163,6 @@ static void kcryptd_async_done(struct crypto_async_request *async_req,
 	struct crypt_config *cc = io->cc;
 
 	if (error == -EINPROGRESS) {
-		complete(&ctx->restart);
 		return;
 	}
 
-- 
1.7.10.4
