From: Ben Collins <ben.c@servergy.com>
Subject: [PATCH] dm-crypt: Fix deadlock when algo returns -EBUSY
Date: Fri,  3 Apr 2015 16:09:46 +0000
Message-ID: <1428077387-2292-1-git-send-email-ben.c@servergy.com>
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
To: dm-devel@redhat.com
Cc: Ben Collins <ben.c@servergy.com>, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

I suspect this doesn't show up for most anyone because software
algorithms typically don't have a sense of being too busy. However,
when working with the Freescale CAAM driver, it would, under heavy
load, return -EBUSY on occasion, which would leave dm-crypt dead
locked and quite unhappy.

After checking the logic in some other drivers, the scheme for
crypt_convert() and it's callback, kcryptd_async_done() were not
correctly laid out to handle -EBUSY properly (nor -EINPROGRESS for
that matter).

This patch corrects that and makes things pretty happy. Where-as I
could cause a lockup withing 1-2 minutes, I've not been able to run
the reproduction test with CAAM drivers fully installed for over
24 hours now. I've regression tested it against software algorithms
on PPC32 and x86_64, and things seem perfectly happy there as well.

I've tested this all the way back to 3.13, and a few iterations
in-between. Please consider pushing this to various stable trees.

Cc: dm-devel@redhat.com
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Ben Collins <ben.c@servergy.com>
---
 drivers/md/dm-crypt.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 713a962..3891f26 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -925,11 +925,10 @@ static int crypt_convert(struct crypt_config *cc,
 
 		switch (r) {
 		/* async */
+		case -EINPROGRESS:
 		case -EBUSY:
 			wait_for_completion(&ctx->restart);
 			reinit_completion(&ctx->restart);
-			/* fall through*/
-		case -EINPROGRESS:
 			ctx->req = NULL;
 			ctx->cc_sector++;
 			continue;
@@ -1346,10 +1345,8 @@ static void kcryptd_async_done(struct crypto_async_request *async_req,
 	struct dm_crypt_io *io = container_of(ctx, struct dm_crypt_io, ctx);
 	struct crypt_config *cc = io->cc;
 
-	if (error == -EINPROGRESS) {
-		complete(&ctx->restart);
+	if (error == -EINPROGRESS)
 		return;
-	}
 
 	if (!error && cc->iv_gen_ops && cc->iv_gen_ops->post)
 		error = cc->iv_gen_ops->post(cc, iv_of_dmreq(cc, dmreq), dmreq);
@@ -1359,13 +1356,17 @@ static void kcryptd_async_done(struct crypto_async_request *async_req,
 
 	crypt_free_req(cc, req_of_dmreq(cc, dmreq), io->base_bio);
 
-	if (!atomic_dec_and_test(&ctx->cc_pending))
+	if (!atomic_dec_and_test(&ctx->cc_pending)) {
+		complete(&ctx->restart);
 		return;
+	}
 
 	if (bio_data_dir(io->base_bio) == READ)
 		kcryptd_crypt_read_done(io);
 	else
 		kcryptd_crypt_write_io_submit(io, 1);
+
+	complete(&ctx->restart);
 }
 
 static void kcryptd_crypt(struct work_struct *work)
-- 
1.9.1
