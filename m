Return-Path: <SRS0=a9Kz=KO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66E4BC43460
	for <dm-devel@archiver.kernel.org>; Wed, 19 May 2021 02:58:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D6A0161244
	for <dm-devel@archiver.kernel.org>; Wed, 19 May 2021 02:58:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D6A0161244
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-1ZmWmRpTPjaBwPS02losgg-1; Tue, 18 May 2021 22:58:19 -0400
X-MC-Unique: 1ZmWmRpTPjaBwPS02losgg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 49C5F800D55;
	Wed, 19 May 2021 02:58:13 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BD3FC687CC;
	Wed, 19 May 2021 02:58:12 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DFB8A55353;
	Wed, 19 May 2021 02:58:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14J2tcDR029451 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 18 May 2021 22:55:38 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id A0F8A102F15C; Wed, 19 May 2021 02:55:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9BCA71020453
	for <dm-devel@redhat.com>; Wed, 19 May 2021 02:55:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D0C9A185A79C
	for <dm-devel@redhat.com>; Wed, 19 May 2021 02:55:35 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-409-9jgDcC76MxOzULM6of667A-1; Tue, 18 May 2021 22:55:33 -0400
X-MC-Unique: 9jgDcC76MxOzULM6of667A-1
IronPort-SDR: aXhEsTKSqZIum3HOLU4c/ZS6TvKTxsKvxSqGE3/74iit47Bl88zdcFVNqc94MvV/F4gViEch7/
	imDn9I1KGqRwFjEab/AWg7ILgP9AVHrnTRsVZ7+3/7PdQ2xHl8vnfpoXe39h1oiauKbuWa6nDo
	bfjCmDGVvBwKxjzsQX02JZYLgtWAqNXqYfAnIvB9VcH9an/mZ7GekcuiozjLFY72odViPldeNP
	KU23F6ah/ngq6fgHa74R7GWj+YpsNwVHDDdDIunZ6IG79OMMDxQu1/gPlVJ47afyXE7WZeHpAZ
	eJw=
X-IronPort-AV: E=Sophos;i="5.82,311,1613404800"; d="scan'208";a="169197410"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
	([199.255.45.15])
	by ob1.hgst.iphmx.com with ESMTP; 19 May 2021 10:55:33 +0800
IronPort-SDR: AhTq20ehnS6AdQ9Au3VxYpWspGf/Pa06hUdl9lLHW3clg2MHCSnBP4ttMYCRxqb0Wacw69exDp
	JlqmoB7TaEaUH7bkzAwvW09zzR/tXtEdeMME3pjlcIKch57YaUO/e/8YM4kPOLCocNsPm8iMcb
	svP+RVHd7mhs4rBdSenVrNPhFffOv0ff+CHatWV4corsbmPBNoFQNISqo8oyqJrasQsfXS5ttA
	KGd9YKyDQv3pX7NANTq7uXh7cccZ6nBy/JZCI9WIxDHkDIyOcDtfG+iJUfGC/6fuzNAfB3BBJV
	bo2EyW5gp2tFF/OJWyYEBPsK
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	18 May 2021 19:33:58 -0700
IronPort-SDR: samlL5UFxB1RcbGFoHukxr1J1+J64hnoMxpDfysdEf4DYBQAlWb2iVCqRdgktdcxOP4Wj1kro1
	EunAY8LYZpf1jez9tTBI1iyVbgnfmQNhvFBQWabQOGN63UIKOG18xY6TqeMJenkcw/IUPbO6CL
	3oO5agsPu2faI8erRG8clFmNEVdDGjyY0TQoRIfoJd1IOeWHgfYIMsaYNrvxP9aWwjkypdVz0d
	sAbzo1lbUX5Fi1j88DzsazrDZfA9u7DpcrNUoc6Uv63/obKlKjbkcuVt2v2IpfBaG9uXN59wn0
	sbs=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
	by uls-op-cesaip02.wdc.com with ESMTP; 18 May 2021 19:55:32 -0700
From: Damien Le Moal <damien.lemoal@wdc.com>
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
	linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Date: Wed, 19 May 2021 11:55:20 +0900
Message-Id: <20210519025529.707897-3-damien.lemoal@wdc.com>
In-Reply-To: <20210519025529.707897-1-damien.lemoal@wdc.com>
References: <20210519025529.707897-1-damien.lemoal@wdc.com>
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
Subject: [dm-devel] [PATCH 02/11] block: introduce bio zone helpers
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
index f69c75bd6d27..e74ad1252e78 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1008,6 +1008,18 @@ static inline unsigned int blk_rq_stats_sectors(const struct request *rq)
 /* Helper to convert BLK_ZONE_ZONE_XXX to its string format XXX */
 const char *blk_zone_cond_str(enum blk_zone_cond zone_cond);
 
+static inline unsigned int bio_zone_no(struct request_queue *q,
+				       struct bio *bio)
+{
+	return blk_queue_zone_no(q, bio->bi_iter.bi_sector);
+}
+
+static inline unsigned int bio_zone_is_seq(struct request_queue *q,
+					   struct bio *bio)
+{
+	return blk_queue_zone_is_seq(q, bio->bi_iter.bi_sector);
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

