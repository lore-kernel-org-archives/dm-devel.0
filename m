Return-Path: <SRS0=ovTT=GH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8397C433E0
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 15:00:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2AE7522211
	for <dm-devel@archiver.kernel.org>; Mon,  4 Jan 2021 15:00:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2AE7522211
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-52-zL1Av00YPeuSGS9KbdrPCw-1; Mon, 04 Jan 2021 10:00:36 -0500
X-MC-Unique: zL1Av00YPeuSGS9KbdrPCw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A688D107ACE6;
	Mon,  4 Jan 2021 15:00:31 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 86C605D9DE;
	Mon,  4 Jan 2021 15:00:31 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3A318180954D;
	Mon,  4 Jan 2021 15:00:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 104F0ERS029953 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 4 Jan 2021 10:00:14 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 67D4A2166B2E; Mon,  4 Jan 2021 15:00:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5C9232166B34
	for <dm-devel@redhat.com>; Mon,  4 Jan 2021 15:00:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BA084858281
	for <dm-devel@redhat.com>; Mon,  4 Jan 2021 15:00:09 +0000 (UTC)
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com
	[209.85.128.41]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-478-D92qoR-mPQeGrNO97IsTsQ-1; Mon, 04 Jan 2021 10:00:07 -0500
X-MC-Unique: D92qoR-mPQeGrNO97IsTsQ-1
Received: by mail-wm1-f41.google.com with SMTP id y23so19616089wmi.1
	for <dm-devel@redhat.com>; Mon, 04 Jan 2021 07:00:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references:mime-version:content-transfer-encoding;
	bh=CkSaZgPxJaN1/gTlwX2RFLNOGUrJzxXD9c7FCL0OvWs=;
	b=i6KyUf2KXUcNnnRcSP7rU/0L4g/5G8vYZobkW5L+TAG01rHagXiIR9l/ZYNA76WQc3
	fxJVF96xRkp/XFgUshEfVMtWBnv2q2uOOVCE7PKF6sbu/SxonwUvVaJt/qGQN5sonp2D
	i0qN14qRO1gKdziFoCo4Hl2hzrrtu5iyI5b2LLCYiZD0IUOmngBgezdTPq43Adb61zyu
	EW+ZR3ns4RAO0NCXGdyeYhEJj+CQGeKKx85e6ziAfl9mbxkWQn1y5shW2B9laXlvcGTf
	HjhLYh+t+1SVGXMQDKOVW3MgSH5VH2AGNYri5H+2RyCTEN7BSYD6K2IO3msT2Y46KczY
	/nrg==
X-Gm-Message-State: AOAM531YkwxeEZMiDNtxEfXFVizCi8+FDFSnFwYIhCJGL0mRah9kQfxo
	BHRqfYcub5kONxU7Oiro0uiCuA==
X-Google-Smtp-Source: ABdhPJykwXDDJNzKLSUmY714yiMnGq/D9M+7673ivecOYRuECp7qQrAI+7IWvJweD1ihVKXaiv4+RQ==
X-Received: by 2002:a1c:6746:: with SMTP id b67mr27003449wmc.8.1609772406139; 
	Mon, 04 Jan 2021 07:00:06 -0800 (PST)
Received: from dev.cfops.net (165.176.200.146.dyn.plus.net. [146.200.176.165])
	by smtp.gmail.com with ESMTPSA id
	r1sm94445954wrl.95.2021.01.04.07.00.04
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Mon, 04 Jan 2021 07:00:05 -0800 (PST)
From: Ignat Korchagin <ignat@cloudflare.com>
To: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, dm-crypt@saout.de,
	linux-kernel@vger.kernel.org
Date: Mon,  4 Jan 2021 14:59:47 +0000
Message-Id: <20210104145948.1857-2-ignat@cloudflare.com>
In-Reply-To: <20210104145948.1857-1-ignat@cloudflare.com>
References: <20210104145948.1857-1-ignat@cloudflare.com>
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
Subject: [dm-devel] [PATCH v3 1/2] dm crypt: do not wait for backlogged
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
 drivers/md/dm-crypt.c | 103 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 98 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 392337f16ecf..a3326dadfd4d 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1529,13 +1529,19 @@ static void crypt_free_req(struct crypt_config *cc, void *req, struct bio *base_
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
 
@@ -1553,7 +1559,25 @@ static blk_status_t crypt_convert(struct crypt_config *cc,
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
+			} else {
+				wait_for_completion(&ctx->restart);
+			}
 			reinit_completion(&ctx->restart);
 			fallthrough;
 		/*
@@ -1945,6 +1969,37 @@ static bool kcryptd_crypt_write_inline(struct crypt_config *cc,
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
@@ -1973,7 +2028,17 @@ static void kcryptd_crypt_write_convert(struct dm_crypt_io *io)
 
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
@@ -1998,6 +2063,25 @@ static void kcryptd_crypt_read_done(struct dm_crypt_io *io)
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
@@ -2009,7 +2093,16 @@ static void kcryptd_crypt_read_convert(struct dm_crypt_io *io)
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

