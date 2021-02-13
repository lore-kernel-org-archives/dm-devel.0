Return-Path: <SRS0=CL6l=HT=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 521C5C433E0
	for <dm-devel@archiver.kernel.org>; Wed, 17 Feb 2021 15:37:55 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D7BD664E0F
	for <dm-devel@archiver.kernel.org>; Wed, 17 Feb 2021 15:37:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D7BD664E0F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linutronix.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-67-U94_WnWAOpqtlIkqtsvvuQ-1; Wed, 17 Feb 2021 10:37:52 -0500
X-MC-Unique: U94_WnWAOpqtlIkqtsvvuQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B587D835E28;
	Wed, 17 Feb 2021 15:37:46 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 864B719C46;
	Wed, 17 Feb 2021 15:37:46 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5277F18095CC;
	Wed, 17 Feb 2021 15:37:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11DBLtYU030527 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 13 Feb 2021 06:21:56 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D79B22026D16; Sat, 13 Feb 2021 11:21:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CFCD02026D3A
	for <dm-devel@redhat.com>; Sat, 13 Feb 2021 11:21:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 564BD802355
	for <dm-devel@redhat.com>; Sat, 13 Feb 2021 11:21:55 +0000 (UTC)
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-315-MgNkfx9hMxOopOgq_17-Vw-1; Sat, 13 Feb 2021 06:21:50 -0500
X-MC-Unique: MgNkfx9hMxOopOgq_17-Vw-1
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: dm-devel@redhat.com
Date: Sat, 13 Feb 2021 12:11:42 +0100
Message-Id: <20210213111146.3080152-3-bigeasy@linutronix.de>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 11DBLtYU030527
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 17 Feb 2021 10:31:26 -0500
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>,
	Ignat Korchagin <ignat@cloudflare.com>
Subject: [dm-devel] [PATCH 2/6] dm crypt: Handle DM_CRYPT_NO_*_WORKQUEUE
	more explicit.
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

By looking at the handling of DM_CRYPT_NO_*_WORKQUEUE in
kcryptd_queue_crypt() it appears that READ and WRITE requests might be
handled in the tasklet context as long as interrupts are disabled or it
is handled in hardirq context.

The WRITE requests should always be fed in preemptible context. There
are other requirements in the write path which sleep or acquire a mutex.

The READ requests should come from the storage driver, likely not in a
preemptible context. The source of the requests depends on the driver
and other factors like multiple queues in the block layer.

To simplify the handling of DM_CRYPT_NO_*_WORKQUEUE, handle READ
requests always in tasklet/softirq context since the requests will be
passed in hard or softirq context.
Handle the WRITE requests directly because they are already in
preemptible context and must not be passed to the taslket/softirq.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/md/dm-crypt.c | 26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 506655e5eecba..a498de3604a67 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2215,30 +2215,22 @@ static void kcryptd_crypt_tasklet(struct tasklet_struct *t)
 {
 	struct dm_crypt_io *io = from_tasklet(io, t, tasklet);
 
-	if (bio_data_dir(io->base_bio) == READ)
-		kcryptd_crypt_read_convert(io);
-	else
-		kcryptd_crypt_write_convert(io);
+	kcryptd_crypt_read_convert(io);
 }
 
 static void kcryptd_queue_crypt(struct dm_crypt_io *io)
 {
 	struct crypt_config *cc = io->cc;
 
-	if ((bio_data_dir(io->base_bio) == READ && test_bit(DM_CRYPT_NO_READ_WORKQUEUE, &cc->flags)) ||
-	    (bio_data_dir(io->base_bio) == WRITE && test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags))) {
-		/*
-		 * in_irq(): Crypto API's skcipher_walk_first() refuses to work in hard IRQ context.
-		 * irqs_disabled(): the kernel may run some IO completion from the idle thread, but
-		 * it is being executed with irqs disabled.
-		 */
-		if (in_irq() || irqs_disabled()) {
-			tasklet_setup(&io->tasklet, kcryptd_crypt_tasklet);
-			tasklet_schedule(&io->tasklet);
-			return;
-		}
+	if (bio_data_dir(io->base_bio) == READ &&
+	    test_bit(DM_CRYPT_NO_READ_WORKQUEUE, &cc->flags)) {
+		tasklet_setup(&io->tasklet, kcryptd_crypt_tasklet);
+		tasklet_schedule(&io->tasklet);
+		return;
 
-		kcryptd_crypt(&io->work);
+	} else if (bio_data_dir(io->base_bio) == WRITE &&
+		   test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags)) {
+		kcryptd_crypt_write_convert(io);
 		return;
 	}
 
-- 
2.30.0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

