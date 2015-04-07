From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2] dm crypt: fix deadlock when algo returns
	-EBUSY
Date: Tue, 7 Apr 2015 12:28:42 -0400
Message-ID: <20150407162842.GA54137@redhat.com>
References: <1428077387-2292-1-git-send-email-ben.c@servergy.com>
	<20150407155501.GA29040@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20150407155501.GA29040@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ben Collins <ben.c@servergy.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Milan Broz <gmazyland@gmail.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, Apr 07 2015 at 11:55P -0400,
Mike Snitzer <snitzer@redhat.com> wrote:
 
> It looks like you're _always_ using the completion regardless of whether
> crypt_convert() will be waiting (e.g. even if error is 0).
> 
> I can see this "working" but it seems less than ideal.  Would it be
> better to record the need to use the completion in ctx and then
> conditionally call complete()?

Actually, how about using !completion_done() before calling complete()?
If you think this would be OK, any chance you could re-test with this?

From: Ben Collins <ben.c@servergy.com>
Date: Fri, 3 Apr 2015 16:09:46 +0000
Subject: [PATCH] dm crypt: fix deadlock when algo returns -EBUSY

I suspect this doesn't show up for most anyone because software
algorithms typically don't have a sense of being too busy.  However,
when working with the Freescale CAAM driver it will return -EBUSY on
occasion under heavy -- which resulted in dm-crypt deadlock.

After checking the logic in some other drivers, the scheme for
crypt_convert() and it's callback, kcryptd_async_done(), were not
correctly laid out to properly handle -EBUSY or -EINPROGRESS.

Fix this by using the completion for both -EBUSY and -EINPROGRESS.
Before this fix dm-crypt would lockup within 1-2 minutes running with
the CAAM driver.  Fix was regression tested against software algorithms
on PPC32 and x86_64, and things seem perfectly happy there as well.

Signed-off-by: Ben Collins <ben.c@servergy.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: stable@vger.kernel.org
---
 drivers/md/dm-crypt.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index ea09d54..cab96ca 100644
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
@@ -1360,12 +1357,15 @@ static void kcryptd_async_done(struct crypto_async_request *async_req,
 	crypt_free_req(cc, req_of_dmreq(cc, dmreq), io->base_bio);
 
 	if (!atomic_dec_and_test(&ctx->cc_pending))
-		return;
+		goto done;
 
 	if (bio_data_dir(io->base_bio) == READ)
 		kcryptd_crypt_read_done(io);
 	else
 		kcryptd_crypt_write_io_submit(io, 1);
+done:
+	if (!completion_done(&ctx->restart))
+		complete(&ctx->restart);
 }
 
 static void kcryptd_crypt(struct work_struct *work)
-- 
1.9.5 (Apple Git-50.3)
