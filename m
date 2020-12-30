Return-Path: <SRS0=/4vF=GC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E11BC433DB
	for <dm-devel@archiver.kernel.org>; Wed, 30 Dec 2020 21:46:20 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id ACC412074D
	for <dm-devel@archiver.kernel.org>; Wed, 30 Dec 2020 21:46:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ACC412074D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-401-ootBB2V6OhqO3EKMZtLzeQ-1; Wed, 30 Dec 2020 16:46:16 -0500
X-MC-Unique: ootBB2V6OhqO3EKMZtLzeQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6C167107ACE3;
	Wed, 30 Dec 2020 21:46:11 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 36A1C1F434;
	Wed, 30 Dec 2020 21:46:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BB8C34BB7B;
	Wed, 30 Dec 2020 21:46:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BULk5dP016208 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 30 Dec 2020 16:46:05 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 3EC872166B2A; Wed, 30 Dec 2020 21:46:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 396F92166B28
	for <dm-devel@redhat.com>; Wed, 30 Dec 2020 21:46:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C5484101A53F
	for <dm-devel@redhat.com>; Wed, 30 Dec 2020 21:46:02 +0000 (UTC)
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com
	[209.85.128.45]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-235-rBh9Qjo9MbuwqPaOBAhnMg-1; Wed, 30 Dec 2020 16:46:00 -0500
X-MC-Unique: rBh9Qjo9MbuwqPaOBAhnMg-1
Received: by mail-wm1-f45.google.com with SMTP id a6so6015220wmc.2
	for <dm-devel@redhat.com>; Wed, 30 Dec 2020 13:46:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references:mime-version:content-transfer-encoding;
	bh=FvrJMrsfSrCMqP0SJkTZGmHVlIQbTBHqqh7rDq5gDYo=;
	b=RmjVJ7E2pIYIPUh6F8dCvO4kfpJ2tkQ3Ld8ge5296Y2U+EVsiNRexsNmXzWirgTJ//
	jb44iVOhaq19PDGP9ur4Yx7Z0So5beE4sVM57FiccX2t7VZiwY91HU173KsXDIV+mlT8
	kGWQb45/LDxq/lLpbkV6noAJehgrh8iV716O1imSadzZ3cso65k4QYYt9SV7WnCi08tr
	414t+d2H3PE0jA0PYligh8qYyvuqN2qiAKi8laPNNoeKN8RoHzTpepZCOOmPrBpi+351
	kxzMwxri6t11eJVJ/8ApkMTuwGnku4aWa7e+SRWZbu8z/UInOb7CSPQWiy592Ck1aIE4
	OC5A==
X-Gm-Message-State: AOAM532wZ8OhUjuaCyKzPD1nYutGMXCgkhlvJqnaceuJSk1wBFVs1/5C
	BP913wnyGvCpLkNTsdQA4onEzQ==
X-Google-Smtp-Source: ABdhPJxU8cJvu00sLK1wr0jBS7pIIOAH36x5vYJwhHdW7BlpXFl8w1XXdVQXTjVw08rKEijjoe6EOA==
X-Received: by 2002:a7b:cbda:: with SMTP id n26mr9267136wmi.144.1609364759036; 
	Wed, 30 Dec 2020 13:45:59 -0800 (PST)
Received: from dev.cfops.net (165.176.200.146.dyn.plus.net. [146.200.176.165])
	by smtp.gmail.com with ESMTPSA id
	r7sm8749894wmh.2.2020.12.30.13.45.57
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 30 Dec 2020 13:45:58 -0800 (PST)
From: Ignat Korchagin <ignat@cloudflare.com>
To: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, dm-crypt@saout.de,
	linux-kernel@vger.kernel.org
Date: Wed, 30 Dec 2020 21:45:20 +0000
Message-Id: <20201230214520.154793-3-ignat@cloudflare.com>
In-Reply-To: <20201230214520.154793-1-ignat@cloudflare.com>
References: <20201230214520.154793-1-ignat@cloudflare.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Damien.LeMoal@wdc.com, herbert@gondor.apana.org.au,
	kernel-team@cloudflare.com, nobuto.murata@canonical.com,
	stable@vger.kernel.org, josef@toxicpanda.com,
	ebiggers@kernel.org, clm@fb.com, mpatocka@redhat.com,
	Ignat Korchagin <ignat@cloudflare.com>, dsterba@suse.com,
	mail@maciej.szmigiero.name, linux-btrfs@vger.kernel.org
Subject: [dm-devel] [PATCH v2 2/2] dm crypt: do not wait for backlogged
	crypto request completion in softirq
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Commit 39d42fa96ba1b7d2544db3f8ed5da8fb0d5cb877 made it possible for some code
paths in dm-crypt to be executed in softirq context, when the underlying driver
processes IO requests in interrupt/softirq context.

When Crypto API backlogs a crypto request, dm-crypt uses wait_for_completion to
avoid sending further requests to an already overloaded crypto driver. However,
if the code is executing in softirq context, we might get the following
stacktrace:

[  210.235213][    C0] BUG: scheduling while atomic: fio/2602/0x00000102
[  210.236701][    C0] Modules linked in:
[  210.237566][    C0] CPU: 0 PID: 2602 Comm: fio Tainted: G        W         5.10.0+ #50
[  210.239292][    C0] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 0.0.0 02/06/2015
[  210.241233][    C0] Call Trace:
[  210.241946][    C0]  <IRQ>
[  210.242561][    C0]  dump_stack+0x7d/0xa3
[  210.243466][    C0]  __schedule_bug.cold+0xb3/0xc2
[  210.244539][    C0]  __schedule+0x156f/0x20d0
[  210.245518][    C0]  ? io_schedule_timeout+0x140/0x140
[  210.246660][    C0]  schedule+0xd0/0x270
[  210.247541][    C0]  schedule_timeout+0x1fb/0x280
[  210.248586][    C0]  ? usleep_range+0x150/0x150
[  210.249624][    C0]  ? unpoison_range+0x3a/0x60
[  210.250632][    C0]  ? ____kasan_kmalloc.constprop.0+0x82/0xa0
[  210.251949][    C0]  ? unpoison_range+0x3a/0x60
[  210.252958][    C0]  ? __prepare_to_swait+0xa7/0x190
[  210.254067][    C0]  do_wait_for_common+0x2ab/0x370
[  210.255158][    C0]  ? usleep_range+0x150/0x150
[  210.256192][    C0]  ? bit_wait_io_timeout+0x160/0x160
[  210.257358][    C0]  ? blk_update_request+0x757/0x1150
[  210.258582][    C0]  ? _raw_spin_lock_irq+0x82/0xd0
[  210.259674][    C0]  ? _raw_read_unlock_irqrestore+0x30/0x30
[  210.260917][    C0]  wait_for_completion+0x4c/0x90
[  210.261971][    C0]  crypt_convert+0x19a6/0x4c00
[  210.263033][    C0]  ? _raw_spin_lock_irqsave+0x87/0xe0
[  210.264193][    C0]  ? kasan_set_track+0x1c/0x30
[  210.265191][    C0]  ? crypt_iv_tcw_ctr+0x4a0/0x4a0
[  210.266283][    C0]  ? kmem_cache_free+0x104/0x470
[  210.267363][    C0]  ? crypt_endio+0x91/0x180
[  210.268327][    C0]  kcryptd_crypt_read_convert+0x30e/0x420
[  210.269565][    C0]  blk_update_request+0x757/0x1150
[  210.270563][    C0]  blk_mq_end_request+0x4b/0x480
[  210.271680][    C0]  blk_done_softirq+0x21d/0x340
[  210.272775][    C0]  ? _raw_spin_lock+0x81/0xd0
[  210.273847][    C0]  ? blk_mq_stop_hw_queue+0x30/0x30
[  210.275031][    C0]  ? _raw_read_lock_irq+0x40/0x40
[  210.276182][    C0]  __do_softirq+0x190/0x611
[  210.277203][    C0]  ? handle_edge_irq+0x221/0xb60
[  210.278340][    C0]  asm_call_irq_on_stack+0x12/0x20
[  210.279514][    C0]  </IRQ>
[  210.280164][    C0]  do_softirq_own_stack+0x37/0x40
[  210.281281][    C0]  irq_exit_rcu+0x110/0x1b0
[  210.282286][    C0]  common_interrupt+0x74/0x120
[  210.283376][    C0]  asm_common_interrupt+0x1e/0x40
[  210.284496][    C0] RIP: 0010:_aesni_enc1+0x65/0xb0

Fix this by making crypt_convert function reentrant from the point of a single
bio and make dm-crypt defer further bio processing to a workqueue, if Crypto API
backlogs a request in interrupt context.

Fixes: 39d42fa96ba1 ("dm crypt: add flags to optionally bypass kcryptd workq
ueues")
Cc: <stable@vger.kernel.org> # v5.9+

Signed-off-by: Ignat Korchagin <ignat@cloudflare.com>
---
 drivers/md/dm-crypt.c | 102 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 97 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index e4fd690c70e1..0d939fbe51af 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1539,13 +1539,19 @@ static void crypt_free_req(struct crypt_config *cc, void *req, struct bio *base_
  * Encrypt / decrypt data from one bio to another one (can be the same one)
  */
 static blk_status_t crypt_convert(struct crypt_config *cc,
-			 struct convert_context *ctx, bool atomic)
+			 struct convert_context *ctx, bool atomic, bool reset_pending)
 {
 	unsigned int tag_offset = 0;
 	unsigned int sector_step = cc->sector_size >> SECTOR_SHIFT;
 	int r;
 
-	atomic_set(&ctx->cc_pending, 1);
+	/*
+	 * if reset_pending is set we are dealing with the bio for the first time,
+	 * else we're continuing to work on the previous bio, so don't mess with
+	 * the cc_pending counter
+	 */
+	if (reset_pending)
+		atomic_set(&ctx->cc_pending, 1);
 
 	while (ctx->iter_in.bi_size && ctx->iter_out.bi_size) {
 
@@ -1566,7 +1572,24 @@ static blk_status_t crypt_convert(struct crypt_config *cc,
 		 * but the driver request queue is full, let's wait.
 		 */
 		case -EBUSY:
-			wait_for_completion(&ctx->restart);
+			if (in_interrupt()) {
+				if (try_wait_for_completion(&ctx->restart)) {
+					/*
+					 * we don't have to block to wait for completion,
+					 * so proceed
+					 */
+				} else {
+					/*
+					 * we can't wait for completion without blocking
+					 * exit and continue processing in a workqueue
+					 */
+					ctx->r.req = NULL;
+					ctx->cc_sector += sector_step;
+					tag_offset++;
+					return BLK_STS_DEV_RESOURCE;
+				}
+			} else
+				wait_for_completion(&ctx->restart);
 			reinit_completion(&ctx->restart);
 			fallthrough;
 		/*
@@ -1958,6 +1981,37 @@ static bool kcryptd_crypt_write_inline(struct crypt_config *cc,
 	}
 }
 
+static void kcryptd_crypt_write_continue(struct work_struct *work)
+{
+	struct dm_crypt_io *io = container_of(work, struct dm_crypt_io, work);
+	struct crypt_config *cc = io->cc;
+	struct convert_context *ctx = &io->ctx;
+	int crypt_finished;
+	sector_t sector = io->sector;
+	blk_status_t r;
+
+	wait_for_completion(&ctx->restart);
+	reinit_completion(&ctx->restart);
+
+	r = crypt_convert(cc, &io->ctx, true, false);
+	if (r)
+		io->error = r;
+	crypt_finished = atomic_dec_and_test(&ctx->cc_pending);
+	if (!crypt_finished && kcryptd_crypt_write_inline(cc, ctx)) {
+		/* Wait for completion signaled by kcryptd_async_done() */
+		wait_for_completion(&ctx->restart);
+		crypt_finished = 1;
+	}
+
+	/* Encryption was already finished, submit io now */
+	if (crypt_finished) {
+		kcryptd_crypt_write_io_submit(io, 0);
+		io->sector = sector;
+	}
+
+	crypt_dec_pending(io);
+}
+
 static void kcryptd_crypt_write_convert(struct dm_crypt_io *io)
 {
 	struct crypt_config *cc = io->cc;
@@ -1986,7 +2040,17 @@ static void kcryptd_crypt_write_convert(struct dm_crypt_io *io)
 
 	crypt_inc_pending(io);
 	r = crypt_convert(cc, ctx,
-			  test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags));
+			  test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags), true);
+	/*
+	 * Crypto API backlogged the request, because its queue was full
+	 * and we're in softirq context, so continue from a workqueue
+	 * (TODO: is it actually possible to be in softirq in the write path?)
+	 */
+	if (r == BLK_STS_DEV_RESOURCE) {
+		INIT_WORK(&io->work, kcryptd_crypt_write_continue);
+		queue_work(cc->crypt_queue, &io->work);
+		return;
+	}
 	if (r)
 		io->error = r;
 	crypt_finished = atomic_dec_and_test(&ctx->cc_pending);
@@ -2011,6 +2075,25 @@ static void kcryptd_crypt_read_done(struct dm_crypt_io *io)
 	crypt_dec_pending(io);
 }
 
+static void kcryptd_crypt_read_continue(struct work_struct *work)
+{
+	struct dm_crypt_io *io = container_of(work, struct dm_crypt_io, work);
+	struct crypt_config *cc = io->cc;
+	blk_status_t r;
+
+	wait_for_completion(&io->ctx.restart);
+	reinit_completion(&io->ctx.restart);
+
+	r = crypt_convert(cc, &io->ctx, true, false);
+	if (r)
+		io->error = r;
+
+	if (atomic_dec_and_test(&io->ctx.cc_pending))
+		kcryptd_crypt_read_done(io);
+
+	crypt_dec_pending(io);
+}
+
 static void kcryptd_crypt_read_convert(struct dm_crypt_io *io)
 {
 	struct crypt_config *cc = io->cc;
@@ -2022,7 +2105,16 @@ static void kcryptd_crypt_read_convert(struct dm_crypt_io *io)
 			   io->sector);
 
 	r = crypt_convert(cc, &io->ctx,
-			  test_bit(DM_CRYPT_NO_READ_WORKQUEUE, &cc->flags));
+			  test_bit(DM_CRYPT_NO_READ_WORKQUEUE, &cc->flags), true);
+	/*
+	 * Crypto API backlogged the request, because its queue was full
+	 * and we're in softirq context, so continue from a workqueue
+	 */
+	if (r == BLK_STS_DEV_RESOURCE) {
+		INIT_WORK(&io->work, kcryptd_crypt_read_continue);
+		queue_work(cc->crypt_queue, &io->work);
+		return;
+	}
 	if (r)
 		io->error = r;
 
-- 
2.20.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

