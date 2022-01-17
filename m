Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 958D9C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 17 Jan 2022 07:59:50 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-400-eDtT1pcaNg2YR_19_7I8KA-1; Mon, 17 Jan 2022 02:59:45 -0500
X-MC-Unique: eDtT1pcaNg2YR_19_7I8KA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 348EF80D680;
	Mon, 17 Jan 2022 07:59:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B404E105913E;
	Mon, 17 Jan 2022 07:59:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 04C861809CB8;
	Mon, 17 Jan 2022 07:59:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20H7xbSB029292 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 17 Jan 2022 02:59:37 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6FE61492CA7; Mon, 17 Jan 2022 07:59:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6BBF2492CA4
	for <dm-devel@redhat.com>; Mon, 17 Jan 2022 07:59:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 524B5811E76
	for <dm-devel@redhat.com>; Mon, 17 Jan 2022 07:59:37 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-360-w8I38C7sMHC4MMHcIFyRPw-1; Mon, 17 Jan 2022 02:59:35 -0500
X-MC-Unique: w8I38C7sMHC4MMHcIFyRPw-1
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red
	Hat Linux)) id 1n9MnN-00DzFK-Gs; Mon, 17 Jan 2022 07:51:17 +0000
Date: Sun, 16 Jan 2022 23:51:17 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Benjamin Marzinski <bmarzins@redhat.com>
Message-ID: <YeUf9dRHky81/bs4@infradead.org>
References: <1642183128-17875-1-git-send-email-bmarzins@redhat.com>
MIME-Version: 1.0
In-Reply-To: <1642183128-17875-1-git-send-email-bmarzins@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>, Ming Lei <ming.lei@redhat.com>
Subject: Re: [dm-devel] [PATCH] dm rq: clear cloned bio ->bi_bdev to fix I/O
 accounting
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

So I actually noticed this during code inspection a while ago, but I
think we need to use the actual underlying device instead of NULL here
to keep our block layer gurantees.  See the patch in my queue below.

---
>From 1e330b8e57fc0d6c6fb07c0ec2915dca5d7a585a Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Thu, 13 Jan 2022 10:53:59 +0100
Subject: block: assign bi_bdev for cloned bios in blk_rq_prep_clone

The cloned bios for the cloned request in blk_rq_prep_clone currently
still point to the original bi_bdev.  This is harmless because dm-mpath
doesn't look at bi_bdev but violates the invariants of always having
the correct bi_bdev.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index a6d4780580fcd..b5e35e63adad4 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2976,6 +2976,7 @@ int blk_rq_prep_clone(struct request *rq, struct request *rq_src,
 		bio = bio_clone_fast(bio_src, gfp_mask, bs);
 		if (!bio)
 			goto free_and_out;
+		bio->bi_bdev = rq->q->disk->part0;
 
 		if (bio_ctr && bio_ctr(bio, bio_src, data))
 			goto free_and_out;
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

