Return-Path: <SRS0=hs6z=KU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4982C47086
	for <dm-devel@archiver.kernel.org>; Tue, 25 May 2021 21:25:35 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 392CD6138C
	for <dm-devel@archiver.kernel.org>; Tue, 25 May 2021 21:25:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 392CD6138C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-93-s-UVhSVVMbGkWQesDWdpyg-1; Tue, 25 May 2021 17:25:23 -0400
X-MC-Unique: s-UVhSVVMbGkWQesDWdpyg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 56D90107ACC7;
	Tue, 25 May 2021 21:25:18 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D27EC5C23E;
	Tue, 25 May 2021 21:25:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 396685534D;
	Tue, 25 May 2021 21:25:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14PLPE8O003301 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 25 May 2021 17:25:14 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 878F3208745A; Tue, 25 May 2021 21:25:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 82FDE2087A50
	for <dm-devel@redhat.com>; Tue, 25 May 2021 21:25:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 71753101D223
	for <dm-devel@redhat.com>; Tue, 25 May 2021 21:25:10 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-215-yUKciKyEMJa4ASqfk-j9og-2; Tue, 25 May 2021 17:25:07 -0400
X-MC-Unique: yUKciKyEMJa4ASqfk-j9og-2
IronPort-SDR: HwjwwwvwtuKpqljdqXj0rzpuElaZ2Qr9jkN537BjDGs7KDqbYrFb0P4MHudkGAj5bfUqSDH7Ra
	lkV+bHrAihPKpmfrY5uphueyJ1162nIj5vW3af6+cHW8AzOzZVT+ahs4akQBxqSqUDmaoK3bSe
	6Tqi2UiUP1aZ93xtACKu213UhQNy9nycQkZW8w4aBBFN46AObE21qeMFruNCVKgpg40jqTafni
	Gl0dDQFcUABQ77NNVa9r56FeL3ncC3dEYOjPRFuJaqxeoS7YdXpB68G4QyKz3mCVPjD8nOmOr3
	KJ0=
X-IronPort-AV: E=Sophos;i="5.82,329,1613404800"; d="scan'208";a="168717513"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
	([199.255.45.15])
	by ob1.hgst.iphmx.com with ESMTP; 26 May 2021 05:25:06 +0800
IronPort-SDR: omg5oUU8l7NLgpqzEUNpjRK2xAb6P87DfIqIqbineuzHW1dtp536tN7gJloGdysvftuuE9faO2
	GZ2LABggyCGH/3GxuOCDBcgy5KYr07btD+ql00bdl3pVKvwPXhe3YvCc0fSvJpzCOJH2S8RIew
	bBlkNz61EgW5n331vG2FwKOAvT5Aev24FaBe1zueNV3AcCridwEN5YHP4dGeJ49uFUjzXP8Ora
	69Zbu9fung3Z99SAH9egwY+Jog5jaznNmm5wFINC4qim76yeJu8+iKKCG40TVHg/hxEy5YgSLg
	+3RiDa3NMdBpzwnkN34VEgnf
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
	by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	25 May 2021 14:03:16 -0700
IronPort-SDR: METJ6JkdC2rJw/wpyWsuv8N7jzQudGNSY6gML668bluLFD0tIn3SFp/V7/AIqHqY5r/YKPpWT1
	ffZP6HcvFV9i86+tGzvlNZgDn8pYS/GPJlWGyJrsT8WG9WguRKrNn4/BVLuRzbWQyCYvV35AIf
	U3ViBdYghgNAik5M0yR/oT3KumOT3izeUi/wtl2SsJUVq8U1+8wI1wXG6DGg8sgWiV10y+7J2i
	N3WZbNOukAt11JGUP0Qqd5LK4qwunBjY+JZ7pNkb77xSZJW/o8oC8c1Ke3CH9ArYD+qZFiQjjY
	ciw=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
	by uls-op-cesaip01.wdc.com with ESMTP; 25 May 2021 14:25:06 -0700
From: Damien Le Moal <damien.lemoal@wdc.com>
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
	linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Date: Wed, 26 May 2021 06:24:52 +0900
Message-Id: <20210525212501.226888-3-damien.lemoal@wdc.com>
In-Reply-To: <20210525212501.226888-1-damien.lemoal@wdc.com>
References: <20210525212501.226888-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Subject: [dm-devel] [PATCH v5 02/11] block: introduce bio zone helpers
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
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

