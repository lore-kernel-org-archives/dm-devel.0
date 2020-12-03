Return-Path: <SRS0=8v/u=FH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DB49C433FE
	for <dm-devel@archiver.kernel.org>; Thu,  3 Dec 2020 16:18:16 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AD87B20658
	for <dm-devel@archiver.kernel.org>; Thu,  3 Dec 2020 16:18:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AD87B20658
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-521-cWwP1B2APViiq5XvcoPntA-1; Thu, 03 Dec 2020 11:18:11 -0500
X-MC-Unique: cWwP1B2APViiq5XvcoPntA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EA1C9AFA85;
	Thu,  3 Dec 2020 16:18:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CDC4460854;
	Thu,  3 Dec 2020 16:18:06 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A158C4A7C6;
	Thu,  3 Dec 2020 16:18:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B30mhq0027431 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Dec 2020 19:48:43 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 330F12026D47; Thu,  3 Dec 2020 00:48:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2DF302026D25
	for <dm-devel@redhat.com>; Thu,  3 Dec 2020 00:48:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A7ECA185A794
	for <dm-devel@redhat.com>; Thu,  3 Dec 2020 00:48:40 +0000 (UTC)
Received: from mail-pl1-f195.google.com (mail-pl1-f195.google.com
	[209.85.214.195]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-309-B2BXc_zbNlqQD8UULwNNPw-1; Wed, 02 Dec 2020 19:48:36 -0500
X-MC-Unique: B2BXc_zbNlqQD8UULwNNPw-1
Received: by mail-pl1-f195.google.com with SMTP id f1so166299plt.12;
	Wed, 02 Dec 2020 16:48:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=r1vhAw5KYK+A2HTHj95cD8WrBZBiV4qESvc7DBRN6Tk=;
	b=krjzOtAcNjogAab8G1M9fO+f3hR0O19HqHIXdk0E8e38mZIqmtHftbtvsOCmn/KDHi
	3SfUeCn2Y52QBBoP0tmXSdAaOcTJdDo8M4qb8JLVg25BJTqkE0Y/WY8LSBmqQzrsqeN7
	zUyDn5Lf+yJejWysdke4yeKiVyC71uxsLBQY/aN3oaRFZKSmihiSXBk4BJSCl/TYC5fW
	mUpO8Dn0ogjxbQxKEfGMuq29smOE9aizbfuzyqFMJ6YOyzA/nEKo/AW0Y7V5jYS+duiH
	FX2//eRS0Hc7N7xQuPhdBDG84uFcKeweyfFR65jagWZ2hBL0gHxtIthwfHbSKjdgTobp
	Eoew==
X-Gm-Message-State: AOAM53031wLdlLoQDWbmQMxFOrsEQGi5o+OcEsRMRNRHRQkujxiV3b4x
	Jh9fSel9hB4U75HWmLMYUNJlW6AOwjAeq0qm
X-Google-Smtp-Source: ABdhPJyQ8piQnKQ4iYxll6utigDCPUh5mZSGvq4OuRNasqXf4Dn+/FW1ocu523juX23gKb94xR2FiQ==
X-Received: by 2002:a17:902:b7c3:b029:da:74c3:427 with SMTP id
	v3-20020a170902b7c3b02900da74c30427mr775860plz.38.1606956514876;
	Wed, 02 Dec 2020 16:48:34 -0800 (PST)
Received: from localhost.localdomain ([27.122.242.75])
	by smtp.gmail.com with ESMTPSA id d68sm241314pfd.32.2020.12.02.16.48.32
	(version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
	Wed, 02 Dec 2020 16:48:34 -0800 (PST)
From: Hyeongseok Kim <hyeongseok@gmail.com>
To: agk@redhat.com, snitzer@redhat.com
Date: Thu,  3 Dec 2020 09:46:59 +0900
Message-Id: <20201203004659.95708-1-hyeongseok@gmail.com>
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
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 03 Dec 2020 11:17:59 -0500
Cc: Hyeongseok Kim <hyeongseok@gmail.com>, dm-devel@redhat.com,
	samitolvanen@google.com, hyeongseok.kim@lge.com
Subject: [dm-devel] [PATCH] dm verity: skip verity work on I/O errors when
	system is shutting down
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

If emergency system shutdown is called, like by thermal shutdown,
dm device could be alive when the block device couldn't process
I/O requests anymore. In this status, the handling of I/O errors
by new dm I/O requests or by those already in-flight can lead to
a verity corruption state, which is misjudgment.
So, skip verity work for I/O error when system is shutting down.

Signed-off-by: Hyeongseok Kim <hyeongseok@gmail.com>
---
 drivers/md/dm-verity-target.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index f74982dcbea0..ba62c537798b 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -64,6 +64,15 @@ struct buffer_aux {
 	int hash_verified;
 };
 
+/*
+ * While system shutdown, skip verity work for I/O error.
+ */
+static inline bool verity_is_system_shutting_down(void)
+{
+	return system_state == SYSTEM_HALT || system_state == SYSTEM_POWER_OFF
+		|| system_state == SYSTEM_RESTART;
+}
+
 /*
  * Initialize struct buffer_aux for a freshly created buffer.
  */
@@ -564,7 +573,8 @@ static void verity_end_io(struct bio *bio)
 {
 	struct dm_verity_io *io = bio->bi_private;
 
-	if (bio->bi_status && !verity_fec_is_enabled(io->v)) {
+	if (bio->bi_status &&
+		(!verity_fec_is_enabled(io->v) || verity_is_system_shutting_down())) {
 		verity_finish_io(io, bio->bi_status);
 		return;
 	}
-- 
2.27.0.83.g0313f36

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

