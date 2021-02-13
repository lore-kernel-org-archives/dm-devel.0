Return-Path: <SRS0=CL6l=HT=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 973FBC433DB
	for <dm-devel@archiver.kernel.org>; Wed, 17 Feb 2021 15:38:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0D8BF64D9A
	for <dm-devel@archiver.kernel.org>; Wed, 17 Feb 2021 15:38:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0D8BF64D9A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linutronix.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-TfLKTluBMFOs-HamKEWHeQ-1; Wed, 17 Feb 2021 10:38:12 -0500
X-MC-Unique: TfLKTluBMFOs-HamKEWHeQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E6379192D789;
	Wed, 17 Feb 2021 15:38:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C46095D9D2;
	Wed, 17 Feb 2021 15:38:06 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9582858076;
	Wed, 17 Feb 2021 15:38:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11DBLu7O030531 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 13 Feb 2021 06:21:56 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 3252C10336DE; Sat, 13 Feb 2021 11:21:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2E9D9100B161
	for <dm-devel@redhat.com>; Sat, 13 Feb 2021 11:21:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4D1308032E4
	for <dm-devel@redhat.com>; Sat, 13 Feb 2021 11:21:53 +0000 (UTC)
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-189-51CxZKqGOH6rd1W8CclxiQ-1; Sat, 13 Feb 2021 06:21:47 -0500
X-MC-Unique: 51CxZKqGOH6rd1W8CclxiQ-1
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: dm-devel@redhat.com
Date: Sat, 13 Feb 2021 12:11:44 +0100
Message-Id: <20210213111146.3080152-5-bigeasy@linutronix.de>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 11DBLu7O030531
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 17 Feb 2021 10:31:26 -0500
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>,
	Ignat Korchagin <ignat@cloudflare.com>
Subject: [dm-devel] [PATCH 4/6] dm crypt: Revisit the atomic argument passed
	to crypt_convert().
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The atomic argument of crypto_convert() is used to decide if
cond_resched() may be invoked.

kcryptd_crypt_write_continue() and kcryptd_crypt_read_continue() pass
true here but both are invoked by a worker where scheduling is possible.

kcryptd_crypt_write_convert() is invoked from preemptible context even
if DM_CRYPT_NO_WRITE_WORKQUEUE is set.

Set the atomic argument to false in the three cases because
cond_resched() is not forbidden.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/md/dm-crypt.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index f5eafc32d32c5..1151a0108ae78 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2019,7 +2019,7 @@ static void kcryptd_crypt_write_continue(struct work_struct *work)
 	wait_for_completion(&ctx->restart);
 	reinit_completion(&ctx->restart);
 
-	r = crypt_convert(cc, &io->ctx, true, false);
+	r = crypt_convert(cc, &io->ctx, false, false);
 	if (r)
 		io->error = r;
 	crypt_finished = atomic_dec_and_test(&ctx->cc_pending);
@@ -2065,8 +2065,7 @@ static void kcryptd_crypt_write_convert(struct dm_crypt_io *io)
 	sector += bio_sectors(clone);
 
 	crypt_inc_pending(io);
-	r = crypt_convert(cc, ctx,
-			  test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags), true);
+	r = crypt_convert(cc, ctx, false, true);
 	/*
 	 * Crypto API backlogged the request, because its queue was full
 	 * and we're in softirq context, so continue from a workqueue
@@ -2110,7 +2109,7 @@ static void kcryptd_crypt_read_continue(struct work_struct *work)
 	wait_for_completion(&io->ctx.restart);
 	reinit_completion(&io->ctx.restart);
 
-	r = crypt_convert(cc, &io->ctx, true, false);
+	r = crypt_convert(cc, &io->ctx, false, false);
 	if (r)
 		io->error = r;
 
-- 
2.30.0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

