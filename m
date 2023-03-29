Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70054C77B62
	for <dm-devel@archiver.kernel.org>; Wed, 29 Mar 2023 17:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680109739;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=fvLiNFHqbLfUzr6xuIl0EjCK/aahvzY5q0T+5kOPS44=;
	b=iRlo5hflbO3ywuCTsZOu9t92oHDaY6t6+p1hyYOq1nl8eTza5Nw6nH3AV0gNdywQSLXS3R
	w4pIkzf6YpF0lqH7zZ3elpvIh/I7EQgAtH/wJaGnbPcNA0i8Q4OKg32JjLGkv+3i5M/MWL
	lIz//6m+Igzebbm0pcMy3dWYiaDDidI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-515-BpgMRZrpMqiqlUFFuNXjCw-1; Wed, 29 Mar 2023 13:08:56 -0400
X-MC-Unique: BpgMRZrpMqiqlUFFuNXjCw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 119C218E0A66;
	Wed, 29 Mar 2023 17:08:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EF2B51121330;
	Wed, 29 Mar 2023 17:08:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A6EEA19465BB;
	Wed, 29 Mar 2023 17:08:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A91CD1946587
 for <dm-devel@listman.corp.redhat.com>; Wed, 29 Mar 2023 17:07:32 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7F7111121331; Wed, 29 Mar 2023 17:07:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 783061121330
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 17:07:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 58E06381494B
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 17:07:32 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-30-iwWZGwVxMcyw29PEtWG0vg-2; Wed, 29 Mar 2023 13:07:29 -0400
X-MC-Unique: iwWZGwVxMcyw29PEtWG0vg-2
X-IronPort-AV: E=Sophos;i="5.98,301,1673884800"; d="scan'208";a="338882552"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 30 Mar 2023 01:06:23 +0800
IronPort-SDR: 4FSCxl6CsNOnJC0mhea5vJXLPFFjF4MAuqk7no1p382Nf8tkfKgPUTnvHJ1gSkOvIfgdYtgJGv
 kjCVFUT0t8WTINkpiW2wPRG3NfpA3j3DPWKVskSRylvv2gelc1DldxyItcI2GcQSVsua6xPer9
 O4nC6kZpSQOinA/EUvZy6b/tLe0cgMbC8W4ExVLp0fxHDcY3q2BXegDv0MmMGEvnksXpGvdCB3
 QZ4D1hO0IlJRbmFyoqZZ00/aoX9X3hDnhmoXHDhg/wN7PurqbCoDA0qqqkPjTECt9Dffu/bi5c
 8j4=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 29 Mar 2023 09:22:33 -0700
IronPort-SDR: yyFKbwfOEl8vOCdlm8o/aBoXRqrxQAe/juUDniPmOyA6KC3OO/1kAhsEUEEYLVsoCPHg44tswf
 U4/t+Eht43hkaug7Qk7+EHXBNakm9gxNEJ3L7TUTHnO6hgxDZl9fUBGyLmIxwdFu7eEHUBHXpO
 mDw2lAW7wlIEhS9KYrLKfz7UOp4cFL6JpgENGlPck777d5NCTl/Xpkpz9Aa9Jk2kPk7WtKRS1c
 WhXighkZnqtO4Hr42uzllq0JA5rZq58zNcIHYGF/y9POF5WRGYiU4StYBbSKeJu9G4+2PBGJBo
 br4=
WDCIronportException: Internal
Received: from unknown (HELO redsun91.ssa.fujisawa.hgst.com) ([10.149.66.72])
 by uls-op-cesaip01.wdc.com with ESMTP; 29 Mar 2023 10:06:22 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Jens Axboe <axboe@kernel.dk>
Date: Wed, 29 Mar 2023 10:05:47 -0700
Message-Id: <7849b142e073b20f033e5124a39080f59e5f19d2.1680108414.git.johannes.thumshirn@wdc.com>
In-Reply-To: <cover.1680108414.git.johannes.thumshirn@wdc.com>
References: <cover.1680108414.git.johannes.thumshirn@wdc.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: [dm-devel] [PATCH 01/19] swap: use __bio_add_page to add page to bio
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
Cc: linux-raid@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>,
 cluster-devel@redhat.com, Chaitanya Kulkarni <kch@nvidia.com>,
 Andreas Gruenbacher <agruenba@redhat.com>, Song Liu <song@kernel.org>,
 Dave Kleikamp <shaggy@kernel.org>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 Mike Snitzer <snitzer@kernel.org>, jfs-discussion@lists.sourceforge.net,
 Matthew Wilcox <willy@infradead.org>, Ming Lei <ming.lei@redhat.com>,
 linux-block@vger.kernel.org, linux-mm@kvack.org, dm-devel@redhat.com,
 David Sterba <dsterba@suse.com>, linux-fsdevel@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, linux-btrfs@vger.kernel.org,
 Bob Peterson <rpeterso@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: wdc.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The swap code only adds a single page to a newly created bio. So use
__bio_add_page() to add the page which is guaranteed to succeed in this
case.

This brings us closer to marking bio_add_page() as __must_check.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 mm/page_io.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index 87b682d18850..684cd3c7b59b 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -338,7 +338,7 @@ static void swap_writepage_bdev_sync(struct page *page,
 	bio_init(&bio, sis->bdev, &bv, 1,
 		 REQ_OP_WRITE | REQ_SWAP | wbc_to_write_flags(wbc));
 	bio.bi_iter.bi_sector = swap_page_sector(page);
-	bio_add_page(&bio, page, thp_size(page), 0);
+	__bio_add_page(&bio, page, thp_size(page), 0);
 
 	bio_associate_blkg_from_page(&bio, page);
 	count_swpout_vm_event(page);
@@ -360,7 +360,7 @@ static void swap_writepage_bdev_async(struct page *page,
 			GFP_NOIO);
 	bio->bi_iter.bi_sector = swap_page_sector(page);
 	bio->bi_end_io = end_swap_bio_write;
-	bio_add_page(bio, page, thp_size(page), 0);
+	__bio_add_page(bio, page, thp_size(page), 0);
 
 	bio_associate_blkg_from_page(bio, page);
 	count_swpout_vm_event(page);
@@ -468,7 +468,7 @@ static void swap_readpage_bdev_sync(struct page *page,
 
 	bio_init(&bio, sis->bdev, &bv, 1, REQ_OP_READ);
 	bio.bi_iter.bi_sector = swap_page_sector(page);
-	bio_add_page(&bio, page, thp_size(page), 0);
+	__bio_add_page(&bio, page, thp_size(page), 0);
 	/*
 	 * Keep this task valid during swap readpage because the oom killer may
 	 * attempt to access it in the page fault retry time check.
@@ -488,7 +488,7 @@ static void swap_readpage_bdev_async(struct page *page,
 	bio = bio_alloc(sis->bdev, 1, REQ_OP_READ, GFP_KERNEL);
 	bio->bi_iter.bi_sector = swap_page_sector(page);
 	bio->bi_end_io = end_swap_bio_read;
-	bio_add_page(bio, page, thp_size(page), 0);
+	__bio_add_page(bio, page, thp_size(page), 0);
 	count_vm_event(PSWPIN);
 	submit_bio(bio);
 }
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

