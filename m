Return-Path: <SRS0=/PHZ=GW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D908C433E0
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 05:10:39 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E19BF2311E
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 05:10:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E19BF2311E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-190--JLGxIplPPW4SjllAVBUPw-1; Tue, 19 Jan 2021 00:10:36 -0500
X-MC-Unique: -JLGxIplPPW4SjllAVBUPw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A7222806660;
	Tue, 19 Jan 2021 05:10:31 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 862A67047D;
	Tue, 19 Jan 2021 05:10:31 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5B823180954D;
	Tue, 19 Jan 2021 05:10:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10J5ATr4021430 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 19 Jan 2021 00:10:29 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6B4426D9EA; Tue, 19 Jan 2021 05:10:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 658406D9EC
	for <dm-devel@redhat.com>; Tue, 19 Jan 2021 05:10:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 11B40811E76
	for <dm-devel@redhat.com>; Tue, 19 Jan 2021 05:10:27 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-275-syc4Cy24OOuxXFHGlKk6TQ-1; Tue, 19 Jan 2021 00:10:20 -0500
X-MC-Unique: syc4Cy24OOuxXFHGlKk6TQ-1
IronPort-SDR: pw04DkX/KQQhfPeoth+zECxcRzaI2dh1rxMq83OxYlSjK8ueep5+j6kwIkwGQIIYb6kbAsHoYy
	DC6TNluVXfUofHqryxjZE6W2/MN/BKKfSB00ildALbcN4sA1HlBvyruc3CSnU0gNCSh0NPkPHX
	e6gi0bwP1WztzR77qEfvnB3K0NAmBrSYa7o15oWpf2uPFhCz64XX0QGVkCWhhiO5ROJ0VCRwnf
	4ocUbwOHjhW7w4UK0yYArLYLZuf0cEOEuYL0FZwZ7TTyljN9xyXdh8F45OKsxWLVcUD72pNyvA
	GQ0=
X-IronPort-AV: E=Sophos;i="5.79,357,1602518400"; d="scan'208";a="158940765"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
	([199.255.45.15])
	by ob1.hgst.iphmx.com with ESMTP; 19 Jan 2021 13:10:19 +0800
IronPort-SDR: ybDxS5W7aKYrP2235G5C9fm8awzh1tIhls4cloxqzr8XTw6k67Iu0P24S+2EeLuIvL6H2d/Fw2
	oeZrqtH8T+Kt0kkvn0628/dOJ0k81RbH2s6PWXOHaS+VUFEi4B83+niR9bL95Rwgp8rMryJS77
	f0S7jUeitY34rlY9GlYuvavABzRqu5dyqBPA+0YV/COXDKDASeuq87H5nShQyLZLYx0p28fsJM
	5xeFyikkuGZj9gdz3DfGkjEumX0r0PsHKzykYNkTEHe+UOGoWYXtuiTQARDqyD3mGJwZSQ32sC
	LWQTInxH6MRS2+lhP+6aK2Ia
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	18 Jan 2021 20:52:54 -0800
IronPort-SDR: cPCtUc/IRHJ6v0mRHjS8V8MFIsoN0oL2wMbe6Ozxyn7u6Jlq2FjrgvACBEr/lheyPR/5wD4N+M
	KEDIu5wE7UWz8Cv9qJDWZum4DMbM7mOvzj/7tfqqgYPHbQ1LhSR/PgR8NGyaDkjJQEt2LBkn32
	1OZrCSpTxv+AMTCn8V0WZgKvKOAI/tj1Sffo8uYhn7bxkZYYg0/EqRTNAqMwUOaWkw/9SrZbM5
	n6bVFFI/rd2QJwwAKHXPwXh+bmpzJXrCR4jV/u3YAVKTR0Pw0jMhQst/htFOvMCrlOnknkAxQ9
	MSM=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
	by uls-op-cesaip02.wdc.com with ESMTP; 18 Jan 2021 21:10:18 -0800
From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	drbd-dev@tron.linbit.com, linux-bcache@vger.kernel.org,
	linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	cluster-devel@redhat.com
Date: Mon, 18 Jan 2021 21:06:25 -0800
Message-Id: <20210119050631.57073-32-chaitanya.kulkarni@wdc.com>
In-Reply-To: <20210119050631.57073-1-chaitanya.kulkarni@wdc.com>
References: <20210119050631.57073-1-chaitanya.kulkarni@wdc.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: shaggy@kernel.org, jfs-discussion@lists.sourceforge.net, snitzer@redhat.com,
	gustavo@embeddedor.com, clm@fb.com, dm-devel@redhat.com,
	adilger.kernel@dilger.ca, hch@lst.de, agk@redhat.com,
	naohiro.aota@wdc.com, sagi@grimberg.me, darrick.wong@oracle.com,
	osandov@fb.com, kent.overstreet@gmail.com,
	Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
	josef@toxicpanda.com, efremov@linux.com, colyli@suse.de,
	tj@kernel.org, viro@zeniv.linux.org.uk, dsterba@suse.com,
	bvanassche@acm.org, agruenba@redhat.com, axboe@kernel.dk,
	damien.lemoal@wdc.com, tytso@mit.edu, martin.petersen@oracle.com,
	song@kernel.org, philipp.reisner@linbit.com,
	jefflexu@linux.alibaba.com, rpeterso@redhat.com,
	lars.ellenberg@linbit.com, jth@kernel.org, asml.silence@gmail.com
Subject: [dm-devel] [RFC PATCH 31/37] eros: use bio_init_fields in data
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 fs/erofs/data.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index ea4f693bee22..15f3a3f01fa3 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -220,10 +220,8 @@ static inline struct bio *erofs_read_raw_page(struct bio *bio,
 
 		bio = bio_alloc(GFP_NOIO, nblocks);
 
-		bio->bi_end_io = erofs_readendio;
-		bio_set_dev(bio, sb->s_bdev);
-		bio->bi_iter.bi_sector = (sector_t)blknr <<
-			LOG_SECTORS_PER_BLOCK;
+		bio_init_fields(bio, sb->s_bdev, (sector_t)blknr <<
+			LOG_SECTORS_PER_BLOCK, NULL, erofs_readendio, 0, 0);
 		bio->bi_opf = REQ_OP_READ | (ra ? REQ_RAHEAD : 0);
 	}
 
-- 
2.22.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

