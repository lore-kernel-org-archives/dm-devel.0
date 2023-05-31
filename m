Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BDBEC77B73
	for <dm-devel@archiver.kernel.org>; Wed, 31 May 2023 11:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685534260;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Nmn3SuIPCpiWIJ4gntYdWSsD/W8+nZY4rN/NrBJqif0=;
	b=VU0OqwQfdUqcDbK8PveRIfsVlqtSatWw9a4OC6tUltO5G2Chc2Cn0UUUF5zNX0xRK7rQQT
	SuHVbhXNQJcU2lCqmZzpvhgumjlF3s3V/odW/3WsGC+ceyCGMc+WENiFxJ4F/d8ah+hVXb
	B7UWs8TITXZNZU1/otV6VmhNfN35kWE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592-gL2RXsSQMiufQxoaFN4Ozg-1; Wed, 31 May 2023 07:57:37 -0400
X-MC-Unique: gL2RXsSQMiufQxoaFN4Ozg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0889E858EEB;
	Wed, 31 May 2023 11:57:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E2548420A8;
	Wed, 31 May 2023 11:57:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A437319465B2;
	Wed, 31 May 2023 11:57:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A818A1946595
 for <dm-devel@listman.corp.redhat.com>; Wed, 31 May 2023 11:51:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9871A40C1282; Wed, 31 May 2023 11:51:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9178740C6EC4
 for <dm-devel@redhat.com>; Wed, 31 May 2023 11:51:22 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 759FC384CC50
 for <dm-devel@redhat.com>; Wed, 31 May 2023 11:51:22 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-147-Hdq7OucbMNiSicTlahSRNA-4; Wed, 31 May 2023 07:51:17 -0400
X-MC-Unique: Hdq7OucbMNiSicTlahSRNA-4
X-IronPort-AV: E=Sophos;i="6.00,207,1681142400"; d="scan'208";a="232064942"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 31 May 2023 19:51:16 +0800
IronPort-SDR: oF3LepKPNY924Hdf+Xfvz3BBqbmxQ0PLMN0ILMVgWr5NPIFQdJa8orT8Vklr/gmYxALPxJjGir
 Y30vPHyDAnOA/sqUC1w+yXdfy3xxl1bI2DW3/45AsAH08Fo+exx1pVBMCRUttuUQJKWnAULO4N
 dDJYHh7E+Y0QtX4Onk1fpjiF3aXFbwNmJVbktQiXU8XN+nbk9MBFufErItoP4YSOUsk/4ON/wv
 XJzxfacPG1F3ydVW+/jK29ZM5bFuWiqwxgZQrzdxW7QRS2lvWEKRAe390pRFLA+3AIkn48pKeA
 twQ=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 31 May 2023 04:06:09 -0700
IronPort-SDR: N0Mp4y8z2roxzuFvPYeS73dMUyskg4SUdEFYqtiWL7UyYH8QyLK2HbkzyMpGYTT+EF0PQ5R5Nm
 mbPRnmO0CtIMwMBVMTx15s9v5a5Oh2WyHga/ttkbUx7Jl4Bta6scFUZ2meTIIX541t59maxWrh
 lWBndZcPbu30Jx/mVNKgDiRjvYH1saj/OjkpXgu9CIhpiu3Rt/dyHI1Jxml0CwwJUNnrSWSZ1k
 uBy7/6x2V7pUSi3wBQs8HX8G/rHyPZfLVSVpt3mmdn2FdzPjXwB7XpwzdquL7kP57mT3B4RFOz
 TRE=
WDCIronportException: Internal
Received: from unknown (HELO redsun91.ssa.fujisawa.hgst.com) ([10.149.66.6])
 by uls-op-cesaip02.wdc.com with ESMTP; 31 May 2023 04:51:14 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Jens Axboe <axboe@kernel.dk>
Date: Wed, 31 May 2023 04:50:31 -0700
Message-Id: <9fb5ed86d19f6e0b6f64dfc4109a48ff8ff24497.1685532726.git.johannes.thumshirn@wdc.com>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [PATCH v7 08/20] jfs: logmgr: use __bio_add_page to add
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
 Bob Peterson <rpeterso@redhat.com>, Dave Kleikamp <dave.kleikamp@oracle.com>,
 Mikulas Patocka <mpatocka@redhat.com>, gouha7@uniontech.com,
 linux-block@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>,
 linux-mm@kvack.org, Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 linux-fsdevel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: wdc.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The JFS IO code uses bio_add_page() to add a page to a newly created bio.
bio_add_page() can fail, but the return value is never checked.

Use __bio_add_page() as adding a single page to a newly created bio is
guaranteed to succeed.

This brings us a step closer to marking bio_add_page() as __must_check.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Acked-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/jfs/jfs_logmgr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
index 695415cbfe98..15c645827dec 100644
--- a/fs/jfs/jfs_logmgr.c
+++ b/fs/jfs/jfs_logmgr.c
@@ -1974,7 +1974,7 @@ static int lbmRead(struct jfs_log * log, int pn, struct lbuf ** bpp)
 
 	bio = bio_alloc(log->bdev, 1, REQ_OP_READ, GFP_NOFS);
 	bio->bi_iter.bi_sector = bp->l_blkno << (log->l2bsize - 9);
-	bio_add_page(bio, bp->l_page, LOGPSIZE, bp->l_offset);
+	__bio_add_page(bio, bp->l_page, LOGPSIZE, bp->l_offset);
 	BUG_ON(bio->bi_iter.bi_size != LOGPSIZE);
 
 	bio->bi_end_io = lbmIODone;
@@ -2115,7 +2115,7 @@ static void lbmStartIO(struct lbuf * bp)
 
 	bio = bio_alloc(log->bdev, 1, REQ_OP_WRITE | REQ_SYNC, GFP_NOFS);
 	bio->bi_iter.bi_sector = bp->l_blkno << (log->l2bsize - 9);
-	bio_add_page(bio, bp->l_page, LOGPSIZE, bp->l_offset);
+	__bio_add_page(bio, bp->l_page, LOGPSIZE, bp->l_offset);
 	BUG_ON(bio->bi_iter.bi_size != LOGPSIZE);
 
 	bio->bi_end_io = lbmIODone;
-- 
2.40.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

