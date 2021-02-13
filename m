Return-Path: <SRS0=CL6l=HT=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC9F3C433E0
	for <dm-devel@archiver.kernel.org>; Wed, 17 Feb 2021 15:40:20 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3D08764DA1
	for <dm-devel@archiver.kernel.org>; Wed, 17 Feb 2021 15:40:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3D08764DA1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linutronix.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-562-OXh6TNVJNlmwUfGnKqpABA-1; Wed, 17 Feb 2021 10:40:15 -0500
X-MC-Unique: OXh6TNVJNlmwUfGnKqpABA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5F23179EC2;
	Wed, 17 Feb 2021 15:40:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3962D19D9B;
	Wed, 17 Feb 2021 15:40:10 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F2EA21809C91;
	Wed, 17 Feb 2021 15:40:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11DBLtK1030526 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 13 Feb 2021 06:21:56 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D9F5E2026D3A; Sat, 13 Feb 2021 11:21:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CFC292026D36
	for <dm-devel@redhat.com>; Sat, 13 Feb 2021 11:21:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 73297858F1B
	for <dm-devel@redhat.com>; Sat, 13 Feb 2021 11:21:53 +0000 (UTC)
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-497-5-fEhY2UN0a-K5InMnihQQ-1; Sat, 13 Feb 2021 06:21:47 -0500
X-MC-Unique: 5-fEhY2UN0a-K5InMnihQQ-1
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: dm-devel@redhat.com
Date: Sat, 13 Feb 2021 12:11:43 +0100
Message-Id: <20210213111146.3080152-4-bigeasy@linutronix.de>
In-Reply-To: <20210213111146.3080152-1-bigeasy@linutronix.de>
References: <20210213111146.3080152-1-bigeasy@linutronix.de>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 11DBLtK1030526
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 17 Feb 2021 10:31:26 -0500
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>,
	Ignat Korchagin <ignat@cloudflare.com>
Subject: [dm-devel] [PATCH 3/6] dm crypt: Add 'atomic' argument to
	kcryptd_crypt_read_convert()
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
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

kcryptd_crypt_read_convert() can be invoked from atomic context
(softirq/tasklet) and preemptible context (the workqueue).

Add an argument `atomic' to kcryptd_crypt_read_convert().
This argument can be passed to crypt_convert() replacing the test for
DM_CRYPT_NO_READ_WORKQUEUE.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/md/dm-crypt.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index a498de3604a67..f5eafc32d32c5 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2120,7 +2120,7 @@ static void kcryptd_crypt_read_continue(struct work_struct *work)
 	crypt_dec_pending(io);
 }
 
-static void kcryptd_crypt_read_convert(struct dm_crypt_io *io)
+static void kcryptd_crypt_read_convert(struct dm_crypt_io *io, bool atomic)
 {
 	struct crypt_config *cc = io->cc;
 	blk_status_t r;
@@ -2130,8 +2130,7 @@ static void kcryptd_crypt_read_convert(struct dm_crypt_io *io)
 	crypt_convert_init(cc, &io->ctx, io->base_bio, io->base_bio,
 			   io->sector);
 
-	r = crypt_convert(cc, &io->ctx,
-			  test_bit(DM_CRYPT_NO_READ_WORKQUEUE, &cc->flags), true);
+	r = crypt_convert(cc, &io->ctx, atomic, true);
 	/*
 	 * Crypto API backlogged the request, because its queue was full
 	 * and we're in softirq context, so continue from a workqueue
@@ -2206,7 +2205,7 @@ static void kcryptd_crypt(struct work_struct *work)
 	struct dm_crypt_io *io = container_of(work, struct dm_crypt_io, work);
 
 	if (bio_data_dir(io->base_bio) == READ)
-		kcryptd_crypt_read_convert(io);
+		kcryptd_crypt_read_convert(io, false);
 	else
 		kcryptd_crypt_write_convert(io);
 }
@@ -2215,7 +2214,7 @@ static void kcryptd_crypt_tasklet(struct tasklet_struct *t)
 {
 	struct dm_crypt_io *io = from_tasklet(io, t, tasklet);
 
-	kcryptd_crypt_read_convert(io);
+	kcryptd_crypt_read_convert(io, true);
 }
 
 static void kcryptd_queue_crypt(struct dm_crypt_io *io)
-- 
2.30.0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

