Return-Path: <SRS0=ouO8=NI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A7FEC4320A
	for <dm-devel@archiver.kernel.org>; Tue, 17 Aug 2021 07:26:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 80F4460F39
	for <dm-devel@archiver.kernel.org>; Tue, 17 Aug 2021 07:26:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 80F4460F39
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-bhHsbh3PNKWZ8lvBc1HmOg-1; Tue, 17 Aug 2021 03:26:12 -0400
X-MC-Unique: bhHsbh3PNKWZ8lvBc1HmOg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 37D9B8799FB;
	Tue, 17 Aug 2021 07:26:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AB8786A8FA;
	Tue, 17 Aug 2021 07:26:06 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5AB87181A100;
	Tue, 17 Aug 2021 07:26:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17E19ZA2003284 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 13 Aug 2021 21:09:35 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 3CAFF1D093; Sat, 14 Aug 2021 01:09:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 37C6AF8A1A
	for <dm-devel@redhat.com>; Sat, 14 Aug 2021 01:09:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8917A80270A
	for <dm-devel@redhat.com>; Sat, 14 Aug 2021 01:09:32 +0000 (UTC)
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com
	[209.85.216.54]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-438-64gbdbO0MLC8xNjjpBP6DA-1; Fri, 13 Aug 2021 21:09:28 -0400
X-MC-Unique: 64gbdbO0MLC8xNjjpBP6DA-1
Received: by mail-pj1-f54.google.com with SMTP id
	om1-20020a17090b3a8100b0017941c44ce4so4919779pjb.3; 
	Fri, 13 Aug 2021 18:09:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=5D/+fbzE5sNokosW3SJuO12q+qyf/as7HJwwSlZSGn0=;
	b=H1xtkEBVbGNee9lWA5JMBM9T48rE6yUqedDAPsisf4jw2d2e78TfgO/QkSo5LUdBwQ
	4Yk9BRUh8j1HzV3kkbv3itWFuhvbyOhxFtdjVL6Fyrhjw/UiDi5kGM4UWeD75L9aWSB8
	Ax3NmElDPB0fQKw5VEAmPE0LmDsx3TRnJF/firNjxht4/ydbv8uYqjqLF/UHWGSJghY4
	QL8SIQql9r6CQ1nBsmXON5LFz2srGx/O/r0eyJFWVWguzgMa72Ulckxd0h8CehjSO9/u
	DCi+FzlCwUTBNxW8Qr/VpmRDCAh5JrPmzquVjvInKRhID1d/Jj3oTuJ5xEzoulLkprk5
	aELA==
X-Gm-Message-State: AOAM532HMxe1npEPopaGKsRtAaiuPCcpDxfg+VUK/EHI2a3LcjzXh0BZ
	US5+jo99PfspNxnMVCXoM7VmFGW7Im0=
X-Google-Smtp-Source: ABdhPJxm/MRTek6CZZ0jeJciQa83JlPsvJsBAAqNZuUhMX56iBF7Lyt7/7Tiovo/vN7zMjNXfXsonA==
X-Received: by 2002:a17:90a:e507:: with SMTP id
	t7mr4518482pjy.208.1628903366573; 
	Fri, 13 Aug 2021 18:09:26 -0700 (PDT)
Received: from WRT-WX9.. ([141.164.41.4])
	by smtp.gmail.com with ESMTPSA id j5sm2971339pjv.56.2021.08.13.18.09.19
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 13 Aug 2021 18:09:26 -0700 (PDT)
From: Changbin Du <changbin.du@gmail.com>
To: Alasdair Kergon <agk@redhat.com>
Date: Sat, 14 Aug 2021 09:09:09 +0800
Message-Id: <20210814010909.4558-1-changbin.du@gmail.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 17 Aug 2021 03:26:00 -0400
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Mike Snitzer <snitzer@redhat.com>, Changbin Du <changbin.du@gmail.com>
Subject: [dm-devel] [PATCH] md: in_irq() cleanup
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Replace the obsolete and ambiguos macro in_irq() with new
macro in_hardirq().

Signed-off-by: Changbin Du <changbin.du@gmail.com>
---
 drivers/md/dm-crypt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 50f4cbd600d5..d1de93873a91 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2223,11 +2223,11 @@ static void kcryptd_queue_crypt(struct dm_crypt_io *io)
 	if ((bio_data_dir(io->base_bio) == READ && test_bit(DM_CRYPT_NO_READ_WORKQUEUE, &cc->flags)) ||
 	    (bio_data_dir(io->base_bio) == WRITE && test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags))) {
 		/*
-		 * in_irq(): Crypto API's skcipher_walk_first() refuses to work in hard IRQ context.
+		 * in_hardirq(): Crypto API's skcipher_walk_first() refuses to work in hard IRQ context.
 		 * irqs_disabled(): the kernel may run some IO completion from the idle thread, but
 		 * it is being executed with irqs disabled.
 		 */
-		if (in_irq() || irqs_disabled()) {
+		if (in_hardirq() || irqs_disabled()) {
 			tasklet_init(&io->tasklet, kcryptd_crypt_tasklet, (unsigned long)&io->work);
 			tasklet_schedule(&io->tasklet);
 			return;
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

