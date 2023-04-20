Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FE78C7EE23
	for <dm-devel@archiver.kernel.org>; Fri, 21 Apr 2023 06:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1682059685;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=PpOgZ4xTI7VSwDCO4wiOGH5y3qFE3YqssuJ72Z5Gp8M=;
	b=W+Y+AZ1KbSz5YnuqVWX1opMSWjiOiSnSbx3FIUKfdvVDokjv8XJYCLTLY+t0HzQIR+v89S
	q8/sowDkN5PUrJD3fBuWPABvai91/X/bPmvNkREnc0/Me77pMuDSlsojFIOJg7zNFcbxEF
	nykbFiqiaTnCW9fBiuAMYi9ODEwdnNo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-587-bo9YyOnsPf6xxN2f7npOnw-1; Fri, 21 Apr 2023 02:48:04 -0400
X-MC-Unique: bo9YyOnsPf6xxN2f7npOnw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D55EA381D4E6;
	Fri, 21 Apr 2023 06:47:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BFED82028B5F;
	Fri, 21 Apr 2023 06:47:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 139811946A47;
	Fri, 21 Apr 2023 06:47:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F1B851946A61
 for <dm-devel@listman.corp.redhat.com>; Thu, 20 Apr 2023 10:06:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1EDAA63A5D; Thu, 20 Apr 2023 10:06:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 17A17637A3
 for <dm-devel@redhat.com>; Thu, 20 Apr 2023 10:06:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ED4D6800047
 for <dm-devel@redhat.com>; Thu, 20 Apr 2023 10:06:09 +0000 (UTC)
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com
 [209.85.128.53]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-567-DSuGbJXOMpCkK_ha_oCy3Q-3; Thu, 20 Apr 2023 06:06:08 -0400
X-MC-Unique: DSuGbJXOMpCkK_ha_oCy3Q-3
Received: by mail-wm1-f53.google.com with SMTP id
 5b1f17b1804b1-3f09b9ac51dso15223785e9.0; 
 Thu, 20 Apr 2023 03:06:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1681985167; x=1684577167;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=KLQcibH4QQVSvQQ/bVwiqZIZ4Gz6ywI38VTMDoqxjbc=;
 b=OBIl3vjVylczTBZ5puOQqq/dQX4xCn9y6dFn1/dhveIIj+fz0x9NJIE1Llo10VsnX2
 EdtwMv3hYZesxaZiIhSnMNrueWqRAzGAPtJUKo4+ION8hIOB8lWR44tpTW6t35zR2rVp
 iGFBr3Yg+cuvfWiVw0yUB4lW3B88vu12Lk100hf9VK+1yB05plPKJOx0Sng7SqNzViLs
 CONAMSKK6Fma9k4MEtitzv24VBb/6aKaxNj9LalrM0TdUACk3Dw4tElYdW+EFlumaAGw
 I8LbIGhF6NSzK+9NDNp4Is5v28+TT0b7f7ub3JHJbjjxUM85t2ODkC9K1q8PtG4jfEBG
 T8PQ==
X-Gm-Message-State: AAQBX9eTIiOmo3K+SnwRVGMmsnUb/oulRJO9JkaRHG1uQzmRlS9p820p
 lBreOnZPpohcX6zn4nQvr9s=
X-Google-Smtp-Source: AKy350ZcFFlxF5q3NJunushXVpPXUYuiC4N/We+M7gafEQiS6iroYF7bHjMp40rssazkY5tuAvcmdQ==
X-Received: by 2002:a5d:4603:0:b0:2fa:a8ad:c49b with SMTP id
 t3-20020a5d4603000000b002faa8adc49bmr929488wrq.1.1681985166988; 
 Thu, 20 Apr 2023 03:06:06 -0700 (PDT)
Received: from localhost.localdomain
 (aftr-62-216-205-208.dynamic.mnet-online.de. [62.216.205.208])
 by smtp.googlemail.com with ESMTPSA id
 l11-20020a5d674b000000b0030276f42f08sm201410wrw.88.2023.04.20.03.06.05
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 20 Apr 2023 03:06:06 -0700 (PDT)
From: Johannes Thumshirn <jth@kernel.org>
To: axboe@kernel.dk
Date: Thu, 20 Apr 2023 12:04:53 +0200
Message-Id: <20230420100501.32981-15-jth@kernel.org>
In-Reply-To: <20230420100501.32981-1-jth@kernel.org>
References: <20230420100501.32981-1-jth@kernel.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mailman-Approved-At: Fri, 21 Apr 2023 06:47:49 +0000
Subject: [dm-devel] [PATCH v4 14/22] floppy: use __bio_add_page for adding
 single page to bio
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: shaggy@kernel.org, jfs-discussion@lists.sourceforge.net, linux-mm@kvack.org,
 dm-devel@redhat.com, hch@lst.de, agruenba@redhat.com,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>, willy@infradead.org,
 cluster-devel@redhat.com, kch@nvidia.com, snitzer@kernel.org,
 ming.lei@redhat.com, linux-block@vger.kernel.org, rpeterso@redhat.com,
 dsterba@suse.com, linux-raid@vger.kernel.org, damien.lemoal@wdc.com,
 song@kernel.org, johannes.thumshirn@wdc.com, linux-fsdevel@vger.kernel.org,
 linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

The floppy code uses bio_add_page() to add a page to a newly created bio.
bio_add_page() can fail, but the return value is never checked.

Use __bio_add_page() as adding a single page to a newly created bio is
guaranteed to succeed.

This brings us a step closer to marking bio_add_page() as __must_check.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/block/floppy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 487840e3564d..6f46a30f7c36 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4147,7 +4147,7 @@ static int __floppy_read_block_0(struct block_device *bdev, int drive)
 	cbdata.drive = drive;
 
 	bio_init(&bio, bdev, &bio_vec, 1, REQ_OP_READ);
-	bio_add_page(&bio, page, block_size(bdev), 0);
+	__bio_add_page(&bio, page, block_size(bdev), 0);
 
 	bio.bi_iter.bi_sector = 0;
 	bio.bi_flags |= (1 << BIO_QUIET);
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

