Return-Path: <SRS0=4wsM=KP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09913C433B4
	for <dm-devel@archiver.kernel.org>; Thu, 20 May 2021 04:23:27 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 740F86108C
	for <dm-devel@archiver.kernel.org>; Thu, 20 May 2021 04:23:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 740F86108C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-581-fBK2faAEOBCzEypWCpG_AA-1; Thu, 20 May 2021 00:23:08 -0400
X-MC-Unique: fBK2faAEOBCzEypWCpG_AA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6F924802B78;
	Thu, 20 May 2021 04:23:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 56BE3614FD;
	Thu, 20 May 2021 04:23:03 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 251F35535A;
	Thu, 20 May 2021 04:23:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14K4McKQ005763 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 20 May 2021 00:22:39 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id C27E410547E2; Thu, 20 May 2021 04:22:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BC39910547E8
	for <dm-devel@redhat.com>; Thu, 20 May 2021 04:22:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A7B088564FD
	for <dm-devel@redhat.com>; Thu, 20 May 2021 04:22:35 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-452-nVHbyEWXMf6aR0zn0LUm8Q-2; Thu, 20 May 2021 00:22:33 -0400
X-MC-Unique: nVHbyEWXMf6aR0zn0LUm8Q-2
IronPort-SDR: C56IoR74Vdf2arJ5b9YzHzMHJpbDUFaaiLsIav705A/ozj9TnIyMk7xSG06bo4yFBY/3tbdUvq
	tAlcZNaphVyPQqX8R6n6Zo9I7VsVM07YuGiJRs61vL7ymj/0Xg4KhZqw2JaZmZPsf9fZIyHZG8
	PeWcueGBc3z4sJu2/nG9gzurh9tmjbljcOPoowlD9M0UigkXT5thzjhXyaQX3S5rTAkJdyvLU/
	gOdchbmYXjCMTR3mG59kT7nxovZRiYbVFFZLBMboSjUofy+XaSnRGCEtNFQUHKSkX1t3q9qsHh
	vM8=
X-IronPort-AV: E=Sophos;i="5.82,313,1613404800"; d="scan'208";a="169343187"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
	([199.255.45.15])
	by ob1.hgst.iphmx.com with ESMTP; 20 May 2021 12:22:32 +0800
IronPort-SDR: Fmyn0SerIrp+AGXOjAx2xkJJUXK7I28Q6Qx8JQGFykM7fsgNZI9gGEN+Ut7uwKDNGHWG2WzUdn
	l6ZAv2ezTLjfatScWDl1grlHGpjON1KT9Pp3xt2WUlvkx57zVXjxV4NYfN/i4khYZKfrNuFcXA
	qcmmibFaKeRpFki0KEcm0VZLOnT6qkqvWnES9wqhky6/yy0tURr/4FHhQyJHK01IwfX9TIq+ec
	rb6t0P6pch0lp5HH97CslxFnhsVyJ4fQjoqdFDDnZfJ+ZIC/z4d88a+8CnMBv1/XhLrSXV21YL
	xnHzvq1X2XtejscnC6k/QxKF
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	19 May 2021 21:00:55 -0700
IronPort-SDR: J/48wiKhHEXS5SbzrB86Ab9A0rGE/5PNyqwr9Kj+Ra6ZBE7KWJmVhqAati3UyEL4cZQYdumb5c
	xO1BgASlgG89rXBU01EAiuIZc4cm4I6vAZ63H5dzpZjU8cpQVIsaNJTQkT0PY7RcEtiJfySMo9
	6UwCfUdDiOMGpgVtJy74bqieMbYN05GgcGptHNQXvpa2pJ8VpJHZMBVlZyJGZNIBMp/E8ui49u
	f0LhLIOqRKRQohOdwylH78Jp1etczoUz+BVjXfQ7/d+viOLe+ETTf2l/mX0IbYWTAjLxeckIq2
	Fxk=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
	by uls-op-cesaip02.wdc.com with ESMTP; 19 May 2021 21:22:31 -0700
From: Damien Le Moal <damien.lemoal@wdc.com>
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
	linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Date: Thu, 20 May 2021 13:22:19 +0900
Message-Id: <20210520042228.974083-3-damien.lemoal@wdc.com>
In-Reply-To: <20210520042228.974083-1-damien.lemoal@wdc.com>
References: <20210520042228.974083-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Subject: [dm-devel] [PATCH v2 02/11] block: introduce bio zone helpers
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Introduce the helper functions bio_zone_no() and bio_zone_is_seq().
Both are the BIO counterparts of the request helpers blk_rq_zone_no()
and blk_rq_zone_is_seq(), respectively returning the number of the
target zone of a bio and true if the BIO target zone is sequential.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 include/linux/blkdev.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f69c75bd6d27..2db0f376f5d9 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1008,6 +1008,18 @@ static inline unsigned int blk_rq_stats_sectors(const struct request *rq)
 /* Helper to convert BLK_ZONE_ZONE_XXX to its string format XXX */
 const char *blk_zone_cond_str(enum blk_zone_cond zone_cond);
 
+static inline unsigned int bio_zone_no(struct bio *bio)
+{
+	return blk_queue_zone_no(bdev_get_queue(bio->bi_bdev),
+				 bio->bi_iter.bi_sector);
+}
+
+static inline unsigned int bio_zone_is_seq(struct bio *bio)
+{
+	return blk_queue_zone_is_seq(bdev_get_queue(bio->bi_bdev),
+				     bio->bi_iter.bi_sector);
+}
+
 static inline unsigned int blk_rq_zone_no(struct request *rq)
 {
 	return blk_queue_zone_no(rq->q, blk_rq_pos(rq));
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

