Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DA26C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 10 Feb 2022 22:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1644533001;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=XVZg9rwOSXexfosXsg/Coid8uQC/sI3QOy4g1abHlEk=;
	b=c+h4RAM92fvvG6MG8g/WsvTYRrsi8Er8P6IU4LooelxfRJ0mUtw5KPmb0UFXU43mQSchrt
	kf/ysjBmiehI5ffhODT6ZBWoyKjRrcQEdDTQNImALvvsHd+Izb5MqE4oLOBqj0JQ7yFtdF
	yD3sEuDr4PauKRpItIyI28fDHZSEFJY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-510-7R_jG8oJPIuOWg4KvwrQcQ-1; Thu, 10 Feb 2022 17:43:20 -0500
X-MC-Unique: 7R_jG8oJPIuOWg4KvwrQcQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2523A81424C;
	Thu, 10 Feb 2022 22:43:14 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0B8C94697F;
	Thu, 10 Feb 2022 22:43:14 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DAB5118048A7;
	Thu, 10 Feb 2022 22:43:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21AMcrLh014860 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 10 Feb 2022 17:38:53 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4612540885B9; Thu, 10 Feb 2022 22:38:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4244B40885B5
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 22:38:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2A209811E7A
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 22:38:53 +0000 (UTC)
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
	[209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-372-hR394K_RPgW-Qxrsq5MhFw-1; Thu, 10 Feb 2022 17:38:51 -0500
X-MC-Unique: hR394K_RPgW-Qxrsq5MhFw-1
Received: by mail-qk1-f197.google.com with SMTP id
	q5-20020a05620a0d8500b004738c1b48beso4560080qkl.7
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 14:38:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references;
	bh=CRfDTYNpxGAOLZDzgeFhYGqT+avXL5fj+x7+6gQLvzM=;
	b=cddtT2P8tT7Z3Ma1408e/e8r1R0Nta7EJ+rDAiTgxuPrB2z0xCfCZUN96Vc5VWxoN/
	KhwvriP/8OQokEB1PTOXlejAeWETbuVyjhtm3o6v2JpmDa4omHImwyHBNWr1jakzHJtV
	xE8reju12jGBgo3Lr90TOGZXaaqGxQrLTc9lTKJFWL+FJT3YEHlu9ZAMWx3MHuL3hoWz
	X7g1x2H0q5aWRNGA2JxFfHywIU1JhdUGC483UxRvEXCUOp+MRX4MQ/uHqtgRTaOIOWbe
	AE40KEBZI384mAPxHrbTkuRDKPGFE6jfuWMHH3u48hrFm2D6UiPaF6yDmw8KxWM6ajrp
	k71Q==
X-Gm-Message-State: AOAM532SiSk9fgnb1bHoMt8Ebza076yAc3SkE58xDlJ9Lorn2N9/w252
	PpfVrDpAfTOHp+rb+9bqOQG0HGdEvIdmDRWwdvvktTrsvr/9iOqRhJS27DHCJyi/GJ0Jw0NMqEG
	VpPYfegqmjB4vV0oLGM89INPYhP/VUg2d5ZAGlr8RE2xeUW0LWHc7Ze4hoC7CRn9lVA==
X-Received: by 2002:a37:a607:: with SMTP id p7mr5034689qke.763.1644532730860; 
	Thu, 10 Feb 2022 14:38:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyxEVIGFiZwGx+fh0BLy5zq1Vh8eVtyQH52OipWCoMyOw9uzoENBF0MFCF33ybEO88rYgtWaw==
X-Received: by 2002:a37:a607:: with SMTP id p7mr5034680qke.763.1644532730613; 
	Thu, 10 Feb 2022 14:38:50 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	bj24sm10469903qkb.115.2022.02.10.14.38.49
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 10 Feb 2022 14:38:50 -0800 (PST)
From: Mike Snitzer <snitzer@redhat.com>
To: dm-devel@redhat.com
Date: Thu, 10 Feb 2022 17:38:30 -0500
Message-Id: <20220210223832.99412-13-snitzer@redhat.com>
In-Reply-To: <20220210223832.99412-1-snitzer@redhat.com>
References: <20220210223832.99412-1-snitzer@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org
Subject: [dm-devel] [PATCH 12/14] dm delay: dm_submit_bio_remap
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-delay.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-delay.c b/drivers/md/dm-delay.c
index 59e51d285b0e..8235927a3912 100644
--- a/drivers/md/dm-delay.c
+++ b/drivers/md/dm-delay.c
@@ -72,7 +72,7 @@ static void flush_bios(struct bio *bio)
 	while (bio) {
 		n = bio->bi_next;
 		bio->bi_next = NULL;
-		submit_bio_noacct(bio);
+		dm_submit_bio_remap(bio, NULL);
 		bio = n;
 	}
 }
@@ -232,6 +232,7 @@ static int delay_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	ti->num_flush_bios = 1;
 	ti->num_discard_bios = 1;
+	ti->accounts_remapped_io = true;
 	ti->per_io_data_size = sizeof(struct dm_delay_info);
 	return 0;
 
-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

