Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5481EC74A5B
	for <dm-devel@archiver.kernel.org>; Wed, 29 Mar 2023 17:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680109737;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=3R3Ffy76r0+Paw6vXKPNJ7rxusW67CJiKuJ77M1Ve4U=;
	b=EWNa1fbNJOqpSE2q4/xd561yDX5hfZpT3sZZDWJVgpHF1PYySinjm1ZfoS6Bn35luBlc/+
	6853YW58+0lFOmRmIm4g69ll3eQJBkMUyDcF3Z2vRbKhVSK7zICZy3SJVkojUHKBahALBu
	ypuIQ7h1mhkUPU3FktMdszJIYdlFyHA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-279-plpUTfarNhW_Xe9zLZUo1A-1; Wed, 29 Mar 2023 13:08:53 -0400
X-MC-Unique: plpUTfarNhW_Xe9zLZUo1A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 01D1A38149B7;
	Wed, 29 Mar 2023 17:08:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E3ECF440DD;
	Wed, 29 Mar 2023 17:08:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C26E91946588;
	Wed, 29 Mar 2023 17:08:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 500B71946595
 for <dm-devel@listman.corp.redhat.com>; Wed, 29 Mar 2023 17:07:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 343511121331; Wed, 29 Mar 2023 17:07:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2CADF1121330
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 17:07:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 05F2A3C02B6E
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 17:07:33 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-30-TiDOJLwPMaCezyTst4TA9Q-3; Wed, 29 Mar 2023 13:07:31 -0400
X-MC-Unique: TiDOJLwPMaCezyTst4TA9Q-3
X-IronPort-AV: E=Sophos;i="5.98,301,1673884800"; d="scan'208";a="338882559"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 30 Mar 2023 01:06:26 +0800
IronPort-SDR: Sdq/d0kxYamTymL1wvJ9HKqfN6Ac49ncTWxWnqUoeK5OamnxNWMhBRFu8yONiGq7culjKc6h4Q
 jVymC4OXNf5K8GIARrHmhQoS1uHEZ+EuXKHClBh3/guBgLhNIouKhHqTrqZ0q2jRKyQLe/YnsR
 67hzWWZWYjJZwKFJIVXBHawpqpblPFRyjVL8KR1mvIaOj0UMwjqBJ88A8izZ9+IH5xfrmSpQa1
 DNFheMFJ/1EeYyqNFZOAua7qVfkzjDE2GyD14xnqkht4JVsEV/PZ78dI82JKG99z8QvV0ZNfnt
 uCM=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 29 Mar 2023 09:22:36 -0700
IronPort-SDR: oN2UR0L9Ic/bC5ZlKdub2hL2B3WzSMNwWPaTts8Go9tRNUBzKiBjVMXtPb1MCBqH30XhfX5VFK
 r3o3y5lK4V0syF4FJkhuPmKVn0NSvYTqzCGIASu7aUGIjtgkWZfbeiTvlj5dp1GTJ+SAbWxEQ1
 bH84aK1rLSnMEBKGsMwYaHXGhkfZPfTCuxZYs+HVziD2+k4Bdwtx3+/JcWFce+mApOYNcNV45r
 3t5a5tYLJENitHpxBEddwdCKeyJVZy3OKiWBV7xOctdwFhAm4r3Z/fd+xkk6SD/0qdXQzGwmhy
 sn0=
WDCIronportException: Internal
Received: from unknown (HELO redsun91.ssa.fujisawa.hgst.com) ([10.149.66.72])
 by uls-op-cesaip01.wdc.com with ESMTP; 29 Mar 2023 10:06:25 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Jens Axboe <axboe@kernel.dk>
Date: Wed, 29 Mar 2023 10:05:48 -0700
Message-Id: <87d0bf7d65cb7c64a0010524e5b39466f2b79870.1680108414.git.johannes.thumshirn@wdc.com>
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
Subject: [dm-devel] [PATCH 02/19] drbd: use __bio_add_page to add page to bio
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: wdc.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The drbd code only adds a single page to a newly created bio. So use
__bio_add_page() to add the page which is guaranteed to succeed in this
case.

This brings us closer to marking bio_add_page() as __must_check.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 drivers/block/drbd/drbd_bitmap.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
index 289876ffbc31..c542dcf8c457 100644
--- a/drivers/block/drbd/drbd_bitmap.c
+++ b/drivers/block/drbd/drbd_bitmap.c
@@ -1043,9 +1043,11 @@ static void bm_page_io_async(struct drbd_bm_aio_ctx *ctx, int page_nr) __must_ho
 	bio = bio_alloc_bioset(device->ldev->md_bdev, 1, op, GFP_NOIO,
 			&drbd_md_io_bio_set);
 	bio->bi_iter.bi_sector = on_disk_sector;
-	/* bio_add_page of a single page to an empty bio will always succeed,
-	 * according to api.  Do we want to assert that? */
-	bio_add_page(bio, page, len, 0);
+	/*
+	 * __bio_add_page of a single page to an empty bio will always succeed,
+	 * according to api.  Do we want to assert that?
+	 */
+	__bio_add_page(bio, page, len, 0);
 	bio->bi_private = ctx;
 	bio->bi_end_io = drbd_bm_endio;
 
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

