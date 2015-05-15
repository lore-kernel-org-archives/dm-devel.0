From: Milan Broz <mbroz@redhat.com>
Subject: [PATCH] dm crypt: Add comments to better describe crypto
	processing logic.
Date: Fri, 15 May 2015 17:00:25 +0200
Message-ID: <1431702025-17925-1-git-send-email-mbroz@redhat.com>
References: <20150504213254.GA27445@debian>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150504213254.GA27445@debian>
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
Cc: Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

A crypto driver can process request synchronously or asynchronously
and can use internal driver queue to backlog requests.
Add some comments to clarify internal logic and completion return codes.

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 drivers/md/dm-crypt.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 5503e43..0f48fed 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1,7 +1,7 @@
 /*
  * Copyright (C) 2003 Jana Saout <jana@saout.de>
  * Copyright (C) 2004 Clemens Fruhwirth <clemens@endorphin.org>
- * Copyright (C) 2006-2009 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2006-2015 Red Hat, Inc. All rights reserved.
  * Copyright (C) 2013 Milan Broz <gmazyland@gmail.com>
  *
  * This file is released under the GPL.
@@ -891,6 +891,11 @@ static void crypt_alloc_req(struct crypt_config *cc,
 		ctx->req = mempool_alloc(cc->req_pool, GFP_NOIO);
 
 	ablkcipher_request_set_tfm(ctx->req, cc->tfms[key_index]);
+
+	/*
+	 * Use REQ_MAY_BACKLOG so a cipher driver internally backlogs
+	 * requests if driver request queue is full.
+	 */
 	ablkcipher_request_set_callback(ctx->req,
 	    CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
 	    kcryptd_async_done, dmreq_of_req(cc, ctx->req));
@@ -924,24 +929,32 @@ static int crypt_convert(struct crypt_config *cc,
 		r = crypt_convert_block(cc, ctx, ctx->req);
 
 		switch (r) {
-		/* async */
+		/*
+		 * The request was queued by a crypto driver
+		 * but the driver request queue is full, let's wait.
+		 */
 		case -EBUSY:
 			wait_for_completion(&ctx->restart);
 			reinit_completion(&ctx->restart);
-			/* fall through*/
+			/* fall through */
+		/*
+		 * The request is queued and processed asynchronously,
+		 * completion function kcryptd_async_done() will be called.
+		 */
 		case -EINPROGRESS:
 			ctx->req = NULL;
 			ctx->cc_sector++;
 			continue;
-
-		/* sync */
+		/*
+		 * The request was already processed (synchronously).
+		 */
 		case 0:
 			atomic_dec(&ctx->cc_pending);
 			ctx->cc_sector++;
 			cond_resched();
 			continue;
 
-		/* error */
+		/* There was an error while processing the request. */
 		default:
 			atomic_dec(&ctx->cc_pending);
 			return r;
@@ -1346,6 +1359,11 @@ static void kcryptd_async_done(struct crypto_async_request *async_req,
 	struct dm_crypt_io *io = container_of(ctx, struct dm_crypt_io, ctx);
 	struct crypt_config *cc = io->cc;
 
+	/*
+	 * A request from crypto driver backlog is going to be processed now,
+	 * finish the completion and continue in crypt_convert().
+	 * (Callback will be called for the second time for this request.)
+	 */
 	if (error == -EINPROGRESS) {
 		complete(&ctx->restart);
 		return;
-- 
2.1.4
