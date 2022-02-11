Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B70AC433F5
	for <dm-devel@archiver.kernel.org>; Fri, 11 Feb 2022 21:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1644615971;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=vy8Y/QczxPmWGPAdYlKd4RMoLpPMQKPaIITKcmpYjug=;
	b=ZolsnoGj6BZIOfKHthIEqIag/OxG/uljR9tEnHA29t4ZhIt86Vm39ijPKEjHKin1KIPxhF
	Iud4xFXMDwfbZPmKq/A0ekcTxj/Mlpl3YkDHd0eMWD9yTSRhwk2NdPwxetsA1NGPknx4Tf
	pGFOlYAvxhikhqC1N4tvKiuc5VSxL/c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-240-h5AIJ6UiNymOieZwCkSmYQ-1; Fri, 11 Feb 2022 16:46:09 -0500
X-MC-Unique: h5AIJ6UiNymOieZwCkSmYQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9E3548710F1;
	Fri, 11 Feb 2022 21:46:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 707E8E73C;
	Fri, 11 Feb 2022 21:46:05 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 186FD4BB7C;
	Fri, 11 Feb 2022 21:46:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21BLfNdV024735 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 11 Feb 2022 16:41:23 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id BC05840E80E0; Fri, 11 Feb 2022 21:41:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B892C40E80E4
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 21:41:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 42C78803533
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 21:41:20 +0000 (UTC)
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
	[209.85.161.72]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-611-MEMjC3dcMCO9pUODyI6tvQ-1; Fri, 11 Feb 2022 16:41:13 -0500
X-MC-Unique: MEMjC3dcMCO9pUODyI6tvQ-1
Received: by mail-oo1-f72.google.com with SMTP id
	bb33-20020a056820162100b0031619149c44so6360977oob.5
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 13:41:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references;
	bh=8TzXai5XoIS8MdPbsH2K1r9uRN0R+imGzFYy55uIM5k=;
	b=TooP22p6TyxIOg/cU0pVtNWM6ylWem76q7pnRTkWjY2FctS6MFBbuafIjq1MnAKtrT
	F61aOvtMt1xHNmJrTpnAlSc49mymXS7dFFeRoj5Il1YBvyrAG5n3EHGmw8TxXcvG0j6Y
	5+W8QVExTInOy5aPqiyWK3fLusdKyadc6j32EYT3T+p60VAnWSzIcRDA/gJLtBRpjGda
	hPA4imZ6DGV+vjc23uFBWXU5me2SyPvpbMRXY8wXlp834w10mZx6ewtw0Y3mGv1xj4Y1
	y5FupzEuAV1iQKjsZ6vJE/zGvhhKZgzI2HvUP4FUYtpKLVSmd7tgTBg7g4ApwUt9Vb1L
	DEiw==
X-Gm-Message-State: AOAM5331eNu9Sm7UcF10TietY8bAWqE8nJsnzRaYvNFDVizuFr6FELQo
	k2YQ9inQUw14qCscvK4V029kWbaLmBmzfINvflB9RFNQwy/M6C0iXhAEGZiwWI5Qr0jfkM6I+4I
	zIGq9eFt3w+ofTvZA22bYo4XgXdf86Qrk9IrUZ1Z3ErEAUaXiuxE3hD7Js1SbfKzmDg==
X-Received: by 2002:a05:6870:2b0b:: with SMTP id
	ld11mr762370oab.208.1644615672589; 
	Fri, 11 Feb 2022 13:41:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxuvVk1tr6R6mjs2QBFnD7weYNLfWqReEpv/lo9zB9fvtwYyowwbNBaoeAkADickixXuBf1Aw==
X-Received: by 2002:a05:6870:2b0b:: with SMTP id
	ld11mr762363oab.208.1644615672407; 
	Fri, 11 Feb 2022 13:41:12 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	100sm9697215oth.75.2022.02.11.13.41.11
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 11 Feb 2022 13:41:12 -0800 (PST)
From: Mike Snitzer <snitzer@redhat.com>
To: dm-devel@redhat.com
Date: Fri, 11 Feb 2022 16:40:48 -0500
Message-Id: <20220211214057.40612-6-snitzer@redhat.com>
In-Reply-To: <20220211214057.40612-1-snitzer@redhat.com>
References: <20220211214057.40612-1-snitzer@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org
Subject: [dm-devel] [PATCH v2 05/14] dm: remove impossible BUG_ON in
	__send_empty_flush
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
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The flush_bio in question was just initialized to be empty, so there
is no way bio_has_data() will return true.  So remove stale BUG_ON().

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 8f2288a3b35b..bd07ccadbf01 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1255,7 +1255,6 @@ static int __send_empty_flush(struct clone_info *ci)
 	ci->bio = &flush_bio;
 	ci->sector_count = 0;
 
-	BUG_ON(bio_has_data(ci->bio));
 	while ((ti = dm_table_get_target(ci->map, target_nr++)))
 		__send_duplicate_bios(ci, ti, ti->num_flush_bios, NULL);
 
-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

