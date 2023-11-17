Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39521DDA7
	for <dm-devel@lists.linux.dev>; Fri, 17 Nov 2023 17:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NqpRofg4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700242655;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3GhsCweMxQ1ZGI/4oVw7Pr3jiO2hRty7FA038V8Jumg=;
	b=NqpRofg4O3KBDfekjHj4oiC/ZEAeyOexD4PIDmTdhLk6Lfwo2mTKHSB8LzssGfvpKUABCJ
	ai6lk7Sb4b497ift0MaJX0DEGCbRhis7FLyYqGGnuGQSYWFBJsV7cDZgIX/Sq2v5GSfjfc
	G/ZRFMLl1oA3JwbFobnozFs0PGZ8u+U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-381-4xW5KPZCMfmhBRxJK4guXg-1; Fri, 17 Nov 2023 12:37:31 -0500
X-MC-Unique: 4xW5KPZCMfmhBRxJK4guXg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E41E181B163;
	Fri, 17 Nov 2023 17:37:25 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D9C982166B27;
	Fri, 17 Nov 2023 17:37:25 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id D17D130C1A8C; Fri, 17 Nov 2023 17:37:25 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id D0BAA3FB76;
	Fri, 17 Nov 2023 18:37:25 +0100 (CET)
Date: Fri, 17 Nov 2023 18:37:25 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Mike Snitzer <msnitzer@redhat.com>
cc: Joe Thornber <thornber@redhat.com>, Milan Broz <gmazyland@gmail.com>, 
    Nathan Huckleberry <nhuck@google.com>, dm-devel@lists.linux.dev
Subject: [PATCH 2/2] dm-verity: don't use blocking calls from tasklets
In-Reply-To: <3bd19ce6-2f60-548f-acd7-cb98aa308661@redhat.com>
Message-ID: <3c78f811-aab4-b67f-cba-a2d6e8acbc71@redhat.com>
References: <3bd19ce6-2f60-548f-acd7-cb98aa308661@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

The commit 5721d4e5a9cd enhanced dm-verity, so that it can verify blocks
from tasklets rather than from workqueues. This reportedly improves
performance significantly.

However, dm-verity was using the flag CRYPTO_TFM_REQ_MAY_SLEEP from
tasklets which resulted in warnings about sleeping function being called
from non-sleeping context.

BUG: sleeping function called from invalid context at crypto/internal.h:206
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 14, name: ksoftirqd/0
preempt_count: 100, expected: 0
RCU nest depth: 0, expected: 0
CPU: 0 PID: 14 Comm: ksoftirqd/0 Tainted: G        W 6.7.0-rc1 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x32/0x50
 __might_resched+0x110/0x160
 crypto_hash_walk_done+0x54/0xb0
 shash_ahash_update+0x51/0x60
 verity_hash_update.isra.0+0x4a/0x130 [dm_verity]
 verity_verify_io+0x165/0x550 [dm_verity]
 ? free_unref_page+0xdf/0x170
 ? psi_group_change+0x113/0x390
 verity_tasklet+0xd/0x70 [dm_verity]
 tasklet_action_common.isra.0+0xb3/0xc0
 __do_softirq+0xaf/0x1ec
 ? smpboot_thread_fn+0x1d/0x200
 ? sort_range+0x20/0x20
 run_ksoftirqd+0x15/0x30
 smpboot_thread_fn+0xed/0x200
 kthread+0xdc/0x110
 ? kthread_complete_and_exit+0x20/0x20
 ret_from_fork+0x28/0x40
 ? kthread_complete_and_exit+0x20/0x20
 ret_from_fork_asm+0x11/0x20
 </TASK>

This patch fixes dm-verity so that it doesn't use the flags
CRYPTO_TFM_REQ_MAY_SLEEP and CRYPTO_TFM_REQ_MAY_BACKLOG from tasklets. The
crypto API would do GFP_ATOMIC allocation instead, it could return -ENOMEM
and we catch -ENOMEM in verity_tasklet and requeue the request to the
workqueue.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org	# v6.0+
Fixes: 5721d4e5a9cd ("dm verity: Add optional "try_verify_in_tasklet" feature")

---
 drivers/md/dm-verity-fec.c    |    4 ++--
 drivers/md/dm-verity-target.c |   23 ++++++++++++-----------
 drivers/md/dm-verity.h        |    2 +-
 3 files changed, 15 insertions(+), 14 deletions(-)

Index: linux-2.6/drivers/md/dm-verity-fec.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-verity-fec.c	2023-11-16 22:28:46.000000000 +0100
+++ linux-2.6/drivers/md/dm-verity-fec.c	2023-11-16 22:28:46.000000000 +0100
@@ -185,7 +185,7 @@ static int fec_is_erasure(struct dm_veri
 {
 	if (unlikely(verity_hash(v, verity_io_hash_req(v, io),
 				 data, 1 << v->data_dev_block_bits,
-				 verity_io_real_digest(v, io))))
+				 verity_io_real_digest(v, io), true)))
 		return 0;
 
 	return memcmp(verity_io_real_digest(v, io), want_digest,
@@ -386,7 +386,7 @@ static int fec_decode_rsb(struct dm_veri
 	/* Always re-validate the corrected block against the expected hash */
 	r = verity_hash(v, verity_io_hash_req(v, io), fio->output,
 			1 << v->data_dev_block_bits,
-			verity_io_real_digest(v, io));
+			verity_io_real_digest(v, io), true);
 	if (unlikely(r < 0))
 		return r;
 
Index: linux-2.6/drivers/md/dm-verity-target.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-verity-target.c	2023-11-16 22:28:46.000000000 +0100
+++ linux-2.6/drivers/md/dm-verity-target.c	2023-11-16 22:29:49.000000000 +0100
@@ -135,20 +135,21 @@ static int verity_hash_update(struct dm_
  * Wrapper for crypto_ahash_init, which handles verity salting.
  */
 static int verity_hash_init(struct dm_verity *v, struct ahash_request *req,
-				struct crypto_wait *wait)
+				struct crypto_wait *wait, bool may_sleep)
 {
 	int r;
 
 	ahash_request_set_tfm(req, v->tfm);
-	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP |
-					CRYPTO_TFM_REQ_MAY_BACKLOG,
-					crypto_req_done, (void *)wait);
+	ahash_request_set_callback(req,
+		may_sleep ? CRYPTO_TFM_REQ_MAY_SLEEP | CRYPTO_TFM_REQ_MAY_BACKLOG : 0,
+		crypto_req_done, (void *)wait);
 	crypto_init_wait(wait);
 
 	r = crypto_wait_req(crypto_ahash_init(req), wait);
 
 	if (unlikely(r < 0)) {
-		DMERR("crypto_ahash_init failed: %d", r);
+		if (r != -ENOMEM)
+			DMERR("crypto_ahash_init failed: %d", r);
 		return r;
 	}
 
@@ -179,12 +180,12 @@ out:
 }
 
 int verity_hash(struct dm_verity *v, struct ahash_request *req,
-		const u8 *data, size_t len, u8 *digest)
+		const u8 *data, size_t len, u8 *digest, bool may_sleep)
 {
 	int r;
 	struct crypto_wait wait;
 
-	r = verity_hash_init(v, req, &wait);
+	r = verity_hash_init(v, req, &wait, may_sleep);
 	if (unlikely(r < 0))
 		goto out;
 
@@ -322,7 +323,7 @@ static int verity_verify_level(struct dm
 
 		r = verity_hash(v, verity_io_hash_req(v, io),
 				data, 1 << v->hash_dev_block_bits,
-				verity_io_real_digest(v, io));
+				verity_io_real_digest(v, io), !io->in_tasklet);
 		if (unlikely(r < 0))
 			goto release_ret_r;
 
@@ -556,7 +557,7 @@ static int verity_verify_io(struct dm_ve
 			continue;
 		}
 
-		r = verity_hash_init(v, req, &wait);
+		r = verity_hash_init(v, req, &wait, !io->in_tasklet);
 		if (unlikely(r < 0))
 			return r;
 
@@ -652,7 +653,7 @@ static void verity_tasklet(unsigned long
 
 	io->in_tasklet = true;
 	err = verity_verify_io(io);
-	if (err == -EAGAIN) {
+	if (err == -EAGAIN || err == -ENOMEM) {
 		/* fallback to retrying with work-queue */
 		INIT_WORK(&io->work, verity_work);
 		queue_work(io->v->verify_wq, &io->work);
@@ -1033,7 +1034,7 @@ static int verity_alloc_zero_digest(stru
 		goto out;
 
 	r = verity_hash(v, req, zero_data, 1 << v->data_dev_block_bits,
-			v->zero_digest);
+			v->zero_digest, true);
 
 out:
 	kfree(req);
Index: linux-2.6/drivers/md/dm-verity.h
===================================================================
--- linux-2.6.orig/drivers/md/dm-verity.h	2023-11-16 22:28:46.000000000 +0100
+++ linux-2.6/drivers/md/dm-verity.h	2023-11-16 22:28:46.000000000 +0100
@@ -128,7 +128,7 @@ extern int verity_for_bv_block(struct dm
 					      u8 *data, size_t len));
 
 extern int verity_hash(struct dm_verity *v, struct ahash_request *req,
-		       const u8 *data, size_t len, u8 *digest);
+		       const u8 *data, size_t len, u8 *digest, bool may_sleep);
 
 extern int verity_hash_for_block(struct dm_verity *v, struct dm_verity_io *io,
 				 sector_t block, u8 *digest, bool *is_zero);

