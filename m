Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 781AAC77B7A
	for <dm-devel@archiver.kernel.org>; Wed, 31 May 2023 11:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685534096;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=d8nGMn5Egjcv+N7l86b2Ae5yqgzt9nFhPA7T1lfEK3U=;
	b=B237nRe/EaZGKrVlStAPDwaYhMLdoW/xYNenVvxdguuiVKlfVLGIMZLo5PYpotR+3b9N6q
	ALt2bWLca/BzsDgtha7qLxJwzGzrGjCsE9QLu0bninjDX64Nrf2li8/ukV8tA1WNjd7CDb
	FDIPrcaoAxSfu0fpFMOCB7csc+RqCZ0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-486-2YYz4zDdMJSsPUMetMif0Q-1; Wed, 31 May 2023 07:54:53 -0400
X-MC-Unique: 2YYz4zDdMJSsPUMetMif0Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 36D5F858F0F;
	Wed, 31 May 2023 11:54:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E355C40CFD46;
	Wed, 31 May 2023 11:54:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8E4C219465BA;
	Wed, 31 May 2023 11:54:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1828E19465A2
 for <dm-devel@listman.corp.redhat.com>; Wed, 31 May 2023 11:51:10 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 08C0040CFD47; Wed, 31 May 2023 11:51:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0077240CFD45
 for <dm-devel@redhat.com>; Wed, 31 May 2023 11:51:09 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D58D6800B35
 for <dm-devel@redhat.com>; Wed, 31 May 2023 11:51:09 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-413-kIMj45ekP7q-oGRq8SarIA-1; Wed, 31 May 2023 07:51:08 -0400
X-MC-Unique: kIMj45ekP7q-oGRq8SarIA-1
X-IronPort-AV: E=Sophos;i="6.00,207,1681142400"; d="scan'208";a="344179892"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 31 May 2023 19:51:05 +0800
IronPort-SDR: 1zvm+x0GDWwigz/cY/GPuRU6d2DUS+Y2hOwLcIoH57XnVQrNnN2xQ3trnlAgkqeI+2jE5k4vVR
 3Aap2ya6buAW+T+iPUJWEI3FnL1+H+0SptMBSPBf367iZiQBu2gpPOQeTZqwMZA/oMO/Gkf+mQ
 5ryQpcgfeIfKV1Ls8xNToz1IEFBHLrRd9ddk/gnl0dJvSDJJ2u5Y7y8amnv9ZNLbU5+x/Xod38
 k1G9vqJ0RISLJwSz9EMMsJ+k65fRUZX9506BzDTBXaJgqD93VEQWaxmQAJ8OmjkKZTrBGp/squ
 Fuk=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 31 May 2023 04:00:16 -0700
IronPort-SDR: DCUoJnFdqTpXehtn1JwgjSv3UPX1uRxp333BvBFifFTfBv7OlO2CSbLrKRyVZ1ZVcgiosXtY0T
 tVsCFtk92PhOFdpXCSWvnqSTCBvF5UVLxocOGAcoZEQFEIu1gOajsi/mvqMWu8cMF5J6hkw4hM
 5eCUuV+nUJWEQNxIZoJ/kpCJ15t9r2ZraltnxO2/iRT8ytXvXYLujM0u5SnxD1uxOurCUrxHMR
 wO24NKfN/B2SA63R841MABC0LQn3WFoG2ot/EyIEOWiHlgSgUeAes2WB25guvYTGVgT3jm/xuQ
 aSE=
WDCIronportException: Internal
Received: from unknown (HELO redsun91.ssa.fujisawa.hgst.com) ([10.149.66.6])
 by uls-op-cesaip02.wdc.com with ESMTP; 31 May 2023 04:51:02 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Jens Axboe <axboe@kernel.dk>
Date: Wed, 31 May 2023 04:50:27 -0700
Message-Id: <84ff2dcbe81b258a73ad900adb5266e208b61a4d.1685532726.git.johannes.thumshirn@wdc.com>
In-Reply-To: <cover.1685532726.git.johannes.thumshirn@wdc.com>
References: <cover.1685532726.git.johannes.thumshirn@wdc.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: [dm-devel] [PATCH v7 04/20] fs: buffer: use __bio_add_page to add
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
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net,
 Song Liu <song@kernel.org>, dm-devel@redhat.com,
 Christoph Hellwig <hch@lst.de>, Andreas Gruenbacher <agruenba@redhat.com>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 Matthew Wilcox <willy@infradead.org>, cluster-devel@redhat.com,
 Chaitanya Kulkarni <kch@nvidia.com>, Mike Snitzer <snitzer@kernel.org>,
 Ming Lei <ming.lei@redhat.com>, linux-raid@vger.kernel.org,
 Bob Peterson <rpeterso@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>,
 gouha7@uniontech.com, linux-block@vger.kernel.org,
 Damien Le Moal <damien.lemoal@wdc.com>, Gou Hao <gouhao@uniontech.com>,
 linux-mm@kvack.org, Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 linux-fsdevel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: wdc.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The buffer_head submission code uses bio_add_page() to add a page to a
newly created bio. bio_add_page() can fail, but the return value is never
checked.

Use __bio_add_page() as adding a single page to a newly created bio is
guaranteed to succeed.

This brings us a step closer to marking bio_add_page() as __must_check.

Reviewed-by: Gou Hao <gouhao@uniontech.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/buffer.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index a7fc561758b1..63da30ce946a 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2760,8 +2760,7 @@ static void submit_bh_wbc(blk_opf_t opf, struct buffer_head *bh,
 
 	bio->bi_iter.bi_sector = bh->b_blocknr * (bh->b_size >> 9);
 
-	bio_add_page(bio, bh->b_page, bh->b_size, bh_offset(bh));
-	BUG_ON(bio->bi_iter.bi_size != bh->b_size);
+	__bio_add_page(bio, bh->b_page, bh->b_size, bh_offset(bh));
 
 	bio->bi_end_io = end_bio_bh_io_sync;
 	bio->bi_private = bh;
-- 
2.40.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

