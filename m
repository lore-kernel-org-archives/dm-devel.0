Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 546B9C77B73
	for <dm-devel@archiver.kernel.org>; Tue, 30 May 2023 15:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685461873;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=qKFZ+7nw2vI6Qt5bhH7VVyQZjYwxrD9pg7s/KewbHb8=;
	b=fp09ek8xDuYRP/FoqUKo5j90AMhZ1ms868+uTf8o5juWLr31i1hylXqwW5Jj5D5UzqAij6
	bTwQqsi2NOGN/ZpztWDG2JAhOYRQLiUnw44tIH9FEMsL8rWkT7SXXt2U/iG75A6pdDOUQS
	4AbKurn61wMqnXRNlZODTLLtzyYenD4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-307-S6eeA4DIPmy3os9unp4aow-1; Tue, 30 May 2023 11:51:09 -0400
X-MC-Unique: S6eeA4DIPmy3os9unp4aow-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CA4F085A5A8;
	Tue, 30 May 2023 15:51:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B917AC154D1;
	Tue, 30 May 2023 15:51:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1CD6F19451C1;
	Tue, 30 May 2023 15:50:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A7A3A19465BA
 for <dm-devel@listman.corp.redhat.com>; Tue, 30 May 2023 15:50:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8BEA42166B28; Tue, 30 May 2023 15:50:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 83ED62166B25
 for <dm-devel@redhat.com>; Tue, 30 May 2023 15:50:03 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 64D74811621
 for <dm-devel@redhat.com>; Tue, 30 May 2023 15:50:03 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-104-2mwfD9uiNKyd3P8LIrumhg-3; Tue, 30 May 2023 11:49:59 -0400
X-MC-Unique: 2mwfD9uiNKyd3P8LIrumhg-3
X-IronPort-AV: E=Sophos;i="6.00,204,1681142400"; d="scan'208";a="231986002"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 30 May 2023 23:49:57 +0800
IronPort-SDR: YaSIultwjf3IkfWNTJg2x4xyE02/7ARFa9Q5xkk7wbkO84x6ZXpp7+FdUWHLJWruiONeP6JuL8
 QTKTDNN+iXG2hHscFEarBcs6+Vssc8Kf4RO67KqXmqu0HGeLyQLW1pejwPyX0s7xMgO1seeD6z
 KnDynGvaKWiI5DlxbaF6MN48kGyJA7QfpI2JXkfMX6mRtbRWYaZS865bZt+JtMTDhG6fOCCFrd
 3BnJifDR32/7w1rRgCCYpHgIeS6joHCIaCqsL3R0TM1wdgRvaUO37qzR+Tthpag9afbZZ17chL
 kT8=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 30 May 2023 08:04:50 -0700
IronPort-SDR: syhtlBwgzrZqo2FxlZ+3+3UNQOSy9KOrXWDC7tRnbhEDdQ7M+iJ8X9kfYPjunQnyzAJ/BUunY7
 TJFCtDpOg2F5DZ15LsnpaT3Bwo2hrn6uLSc+fNqG13pjWmrx9wooa6bynhnNQMlDHsy2Hk38NM
 QrDHnT8XkrjMZUyM4mGcFvGUGlEisF2RVaO8OEk9Qwnu8PpGMQpoWoaS1QquWy7J7yXqddyE5U
 EJEo3uszMCInYfCLIryejOvT01pFM14+/21EyuCsYg0N/wZvR8GfT4QE1m8ln383WoalorxH4j
 QYQ=
WDCIronportException: Internal
Received: from unknown (HELO redsun91.ssa.fujisawa.hgst.com) ([10.149.66.6])
 by uls-op-cesaip02.wdc.com with ESMTP; 30 May 2023 08:49:54 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Jens Axboe <axboe@kernel.dk>
Date: Tue, 30 May 2023 08:49:12 -0700
Message-Id: <15cfecbbac931aa18bfd89cede85bcde1d6edd77.1685461490.git.johannes.thumshirn@wdc.com>
In-Reply-To: <cover.1685461490.git.johannes.thumshirn@wdc.com>
References: <cover.1685461490.git.johannes.thumshirn@wdc.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] [PATCH v6 09/20] gfs2: use __bio_add_page for adding
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
 linux-block@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>,
 gouhao@uniontech.com, linux-mm@kvack.org,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, linux-fsdevel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: wdc.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The GFS2 superblock reading code uses bio_add_page() to add a page to a
newly created bio. bio_add_page() can fail, but the return value is never
checked.

Use __bio_add_page() as adding a single page to a newly created bio is
guaranteed to succeed.

This brings us a step closer to marking bio_add_page() as __must_check.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/gfs2/ops_fstype.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 9af9ddb61ca0..cd962985b058 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -254,7 +254,7 @@ static int gfs2_read_super(struct gfs2_sbd *sdp, sector_t sector, int silent)
 
 	bio = bio_alloc(sb->s_bdev, 1, REQ_OP_READ | REQ_META, GFP_NOFS);
 	bio->bi_iter.bi_sector = sector * (sb->s_blocksize >> 9);
-	bio_add_page(bio, page, PAGE_SIZE, 0);
+	__bio_add_page(bio, page, PAGE_SIZE, 0);
 
 	bio->bi_end_io = end_bio_io_page;
 	bio->bi_private = page;
-- 
2.40.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

