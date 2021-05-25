Return-Path: <SRS0=hs6z=KU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08312C47085
	for <dm-devel@archiver.kernel.org>; Tue, 25 May 2021 02:26:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8CF9E6141F
	for <dm-devel@archiver.kernel.org>; Tue, 25 May 2021 02:26:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8CF9E6141F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-PfZqQT-mPnOvZ6yrD6-oBQ-1; Mon, 24 May 2021 22:25:58 -0400
X-MC-Unique: PfZqQT-mPnOvZ6yrD6-oBQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 426A16D4E3;
	Tue, 25 May 2021 02:25:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2322E629DA;
	Tue, 25 May 2021 02:25:53 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1A8B45535A;
	Tue, 25 May 2021 02:25:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14P2PlTu027652 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 24 May 2021 22:25:48 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id C72891009157; Tue, 25 May 2021 02:25:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C29C21111447
	for <dm-devel@redhat.com>; Tue, 25 May 2021 02:25:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AAA508007AC
	for <dm-devel@redhat.com>; Tue, 25 May 2021 02:25:47 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-507-5XI5MsY_NIaEjKFEB8aiZA-2; Mon, 24 May 2021 22:25:43 -0400
X-MC-Unique: 5XI5MsY_NIaEjKFEB8aiZA-2
IronPort-SDR: iZYv5u5pbPnhP3FQQ/E9CXO3zCjr+GmEyWFYLTIz2W0T9qXvPT+JVhpNrLGfgGhKtm4XG9V0pK
	qh3YEmWKkibHQVPNJNVb5a1HNOMJGVDmsxNRC42ab5u76xi318wiLMe92DU6mDrMqaLi1yGsG1
	iSiIlSLiwMNDysHJ1wk5hO9Sy+FNDNV/zCjJ1WLSWzj5jb7W3SB5E85jYKftT5Zsj6Yum7K44Q
	kT3+s2uI/+/qMVOWH8kzZ0MAHamW2EM4X3A/VYA3GeUkK+LdfklxAbJQWinXuXM7qb2QhaDCxt
	fw4=
X-IronPort-AV: E=Sophos;i="5.82,327,1613404800"; d="scan'208";a="273213774"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
	([199.255.45.15])
	by ob1.hgst.iphmx.com with ESMTP; 25 May 2021 10:26:40 +0800
IronPort-SDR: lrdMICs8ta07vqlmRrf0PYUUg69eAhsZQHmZk708p0bD38hkdHh1kOcaRUVao1xKl4Na6o2A8C
	N7jh5AfXZ9kySf/MyyoOBEpva3mA8d9PvUHFW+7VEmFnjIAdA5zhfLrzFE6h5Kdm3uduXuxA9i
	/LCxQ+kR5bgV6PQTOsmphaiJ1L+gjSVN/vnxQPNBrDzFsZjYkoIgEE6njyJNAdIYNpv2rWKQjb
	7DffE+bh6WF8gQuaye8wgNbKZ2olyHM5tnfTaVAc+LrgYwXoxbCHHtqjG9qki9uKTS0vzb/q54
	r+m26VRD8pEJ5dNxT/NGfFse
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	24 May 2021 19:03:57 -0700
IronPort-SDR: NHHM0i1sJS3FHaVrSYdGlgfhUUIKd/cnRyMYpUNwNCcLGZ3UptgvhlRrPKZpAqwNLaSOs6oaOA
	04lB0OgTsfG5zsCdUENSZFXBEIDdUJ+fKHM6y7d2DOJajY3vi161k91tJO33+m3qFEEs1Edx6Y
	Y1bFSHFxmZWPS1EJaELtyRL8dlgm566w04LpoiPCV/GMBsqjm/mvcqXL0kKMyKzqI05LijKAQ2
	Lnv7YpXYjsBLcN/7HmCiV6+/B8ZC043SEP+JmYNxbFa6//RbtGiMHcyK6hZN97VvRGoBOHAXGN
	VVA=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
	by uls-op-cesaip02.wdc.com with ESMTP; 24 May 2021 19:25:42 -0700
From: Damien Le Moal <damien.lemoal@wdc.com>
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
	linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Date: Tue, 25 May 2021 11:25:30 +0900
Message-Id: <20210525022539.119661-3-damien.lemoal@wdc.com>
In-Reply-To: <20210525022539.119661-1-damien.lemoal@wdc.com>
References: <20210525022539.119661-1-damien.lemoal@wdc.com>
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
Subject: [dm-devel] [PATCH v4 02/11] block: introduce bio zone helpers
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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

