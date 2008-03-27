From: Alasdair G Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [2.6.25-rc8] dm crypt: fix ctx pending
Date: Thu, 27 Mar 2008 18:53:15 +0000
Message-ID: <20080327185315.GA26288@agk.fab.redhat.com>
Reply-To: dm-crypt-4q3lyFh4P1g@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-crypt-return-2687-glkdd-dm-crypt=m.gmane.org-4q3lyFh4P1g@public.gmane.org>
List-Post: <mailto:dm-crypt-4q3lyFh4P1g@public.gmane.org>
List-Help: <mailto:dm-crypt-help-4q3lyFh4P1g@public.gmane.org>
List-Unsubscribe: <mailto:dm-crypt-unsubscribe-4q3lyFh4P1g@public.gmane.org>
List-Subscribe: <mailto:dm-crypt-subscribe-4q3lyFh4P1g@public.gmane.org>
Content-Disposition: inline
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Chr <chunkeey-S0/GAf8tV78@public.gmane.org>, "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>, Milan Broz <mbroz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, dm-crypt-4q3lyFh4P1g@public.gmane.org, Christian Kujau <lists-AanptEQQ3TL9uQeqpI+JUg@public.gmane.org>, Ulrich Lukas <stellplatz-nr.13a-7vBoImwI/YtIVYojq0lqJrNAH6kLmebB@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Adrian Bunk <bunk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Natalie Protasevich <protasnb-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>, David Chinner <dgc-sJ/iWh9BUns@public.gmane.org>, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.orgdm-crypt-4q3lyFh4P1g@public.gmane.org, Ritesh Raj Sarraf <rrs-7WuBAv+fczCJ8c2fQYRYNw@public.gmane.org>
List-Id: dm-devel.ids

From: Milan Broz <mbroz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Fix regression in dm-crypt introduced in commit
3a7f6c990ad04e6f576a159876c602d14d6f7fef
(dm crypt: use async crypto).

If write requests need to be split into pieces, the code must not
process them in parallel because the crypto context cannot be shared.
So there can be parallel crypto operations on one part of the write,
but only one write bio can be processed at a time.

This is not optimal and the workqueue code needs to be optimized for
parallel processing, but for now it solves the problem without affecting
the performance of synchronous crypto operation (most of current
dm-crypt users).

http://bugzilla.kernel.org/show_bug.cgi?id=10242
http://bugzilla.kernel.org/show_bug.cgi?id=10207

Signed-off-by: Milan Broz <mbroz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Alasdair G Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

---
 drivers/md/dm-crypt.c |   58 +++++++++++++++++++++++++-------------------------
 1 files changed, 30 insertions(+), 28 deletions(-)

Index: linux-2.6.25-rc7/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.25-rc7.orig/drivers/md/dm-crypt.c	2008-03-27 17:51:23.000000000 +0000
+++ linux-2.6.25-rc7/drivers/md/dm-crypt.c	2008-03-27 17:51:25.000000000 +0000
@@ -1,7 +1,7 @@
 /*
  * Copyright (C) 2003 Christophe Saout <christophe-4q3lyFh4P1g@public.gmane.org>
  * Copyright (C) 2004 Clemens Fruhwirth <clemens-Yy/aLhJqNSaEi8DpZVb4nw@public.gmane.org>
- * Copyright (C) 2006-2007 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2006-2008 Red Hat, Inc. All rights reserved.
  *
  * This file is released under the GPL.
  */
@@ -93,6 +93,8 @@ struct crypt_config {
 
 	struct workqueue_struct *io_queue;
 	struct workqueue_struct *crypt_queue;
+	wait_queue_head_t writeq;
+
 	/*
 	 * crypto related data
 	 */
@@ -331,14 +333,7 @@ static void crypt_convert_init(struct cr
 	ctx->idx_out = bio_out ? bio_out->bi_idx : 0;
 	ctx->sector = sector + cc->iv_offset;
 	init_completion(&ctx->restart);
-	/*
-	 * Crypto operation can be asynchronous,
-	 * ctx->pending is increased after request submission.
-	 * We need to ensure that we don't call the crypt finish
-	 * operation before pending got incremented
-	 * (dependent on crypt submission return code).
-	 */
-	atomic_set(&ctx->pending, 2);
+	atomic_set(&ctx->pending, 1);
 }
 
 static int crypt_convert_block(struct crypt_config *cc,
@@ -411,43 +406,42 @@ static void crypt_alloc_req(struct crypt
 static int crypt_convert(struct crypt_config *cc,
 			 struct convert_context *ctx)
 {
-	int r = 0;
+	int r;
 
 	while(ctx->idx_in < ctx->bio_in->bi_vcnt &&
 	      ctx->idx_out < ctx->bio_out->bi_vcnt) {
 
 		crypt_alloc_req(cc, ctx);
 
+		atomic_inc(&ctx->pending);
+
 		r = crypt_convert_block(cc, ctx, cc->req);
 
 		switch (r) {
+		/* async */
 		case -EBUSY:
 			wait_for_completion(&ctx->restart);
 			INIT_COMPLETION(ctx->restart);
 			/* fall through*/
 		case -EINPROGRESS:
-			atomic_inc(&ctx->pending);
 			cc->req = NULL;
-			r = 0;
-			/* fall through*/
+			ctx->sector++;
+			continue;
+
+		/* sync */
 		case 0:
+			atomic_dec(&ctx->pending);
 			ctx->sector++;
 			continue;
-		}
 
-		break;
+		/* error */
+		default:
+			atomic_dec(&ctx->pending);
+			return r;
+		}
 	}
 
-	/*
-	 * If there are pending crypto operation run async
-	 * code. Otherwise process return code synchronously.
-	 * The step of 2 ensures that async finish doesn't
-	 * call crypto finish too early.
-	 */
-	if (atomic_sub_return(2, &ctx->pending))
-		return -EINPROGRESS;
-
-	return r;
+	return 0;
 }
 
 static void dm_crypt_bio_destructor(struct bio *bio)
@@ -624,8 +618,10 @@ static void kcryptd_io_read(struct dm_cr
 static void kcryptd_io_write(struct dm_crypt_io *io)
 {
 	struct bio *clone = io->ctx.bio_out;
+	struct crypt_config *cc = io->target->private;
 
 	generic_make_request(clone);
+	wake_up(&cc->writeq);
 }
 
 static void kcryptd_io(struct work_struct *work)
@@ -698,7 +694,8 @@ static void kcryptd_crypt_write_convert_
 
 		r = crypt_convert(cc, &io->ctx);
 
-		if (r != -EINPROGRESS) {
+		if (atomic_dec_and_test(&io->ctx.pending)) {
+			/* processed, no running async crypto  */
 			kcryptd_crypt_write_io_submit(io, r, 0);
 			if (unlikely(r < 0))
 				return;
@@ -706,8 +703,12 @@ static void kcryptd_crypt_write_convert_
 			atomic_inc(&io->pending);
 
 		/* out of memory -> run queues */
-		if (unlikely(remaining))
+		if (unlikely(remaining)) {
+			/* wait for async crypto then reinitialize pending */
+			wait_event(cc->writeq, !atomic_read(&io->ctx.pending));
+			atomic_set(&io->ctx.pending, 1);
 			congestion_wait(WRITE, HZ/100);
+		}
 	}
 }
 
@@ -746,7 +747,7 @@ static void kcryptd_crypt_read_convert(s
 
 	r = crypt_convert(cc, &io->ctx);
 
-	if (r != -EINPROGRESS)
+	if (atomic_dec_and_test(&io->ctx.pending))
 		kcryptd_crypt_read_done(io, r);
 
 	crypt_dec_pending(io);
@@ -1047,6 +1048,7 @@ static int crypt_ctr(struct dm_target *t
 		goto bad_crypt_queue;
 	}
 
+	init_waitqueue_head(&cc->writeq);
 	ti->private = cc;
 	return 0;
 
