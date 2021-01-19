Return-Path: <SRS0=/PHZ=GW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AFD9C433E0
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 05:10:51 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id ACA3C22573
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 05:10:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ACA3C22573
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-YTutAIzFNKiuyo0WFeW-lg-1; Tue, 19 Jan 2021 00:10:46 -0500
X-MC-Unique: YTutAIzFNKiuyo0WFeW-lg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D4B0A806660;
	Tue, 19 Jan 2021 05:10:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B69476A8E6;
	Tue, 19 Jan 2021 05:10:41 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 883395002C;
	Tue, 19 Jan 2021 05:10:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10J5AdCT021469 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 19 Jan 2021 00:10:39 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 64DE0112D169; Tue, 19 Jan 2021 05:10:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5E4BE112D170
	for <dm-devel@redhat.com>; Tue, 19 Jan 2021 05:10:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BBA22800969
	for <dm-devel@redhat.com>; Tue, 19 Jan 2021 05:10:34 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-503-tf5W4AORMkuxBQxFZrSQPg-1; Tue, 19 Jan 2021 00:10:27 -0500
X-MC-Unique: tf5W4AORMkuxBQxFZrSQPg-1
IronPort-SDR: 6xgRiY/Hyf62OyBh525sxwjAVPOGFyfgCMTOinXDqppbAy9t0JNpNKih7afWy4+zkHPFu87VID
	9j4cd7MpZ7ZCArbbGEflBKbPgSwexFNH4XmBtUuSZ7Fr3TVheV042ulbpmzroq6bSqHCPU2qzL
	zBc7ayBKT1uSoHyQPQTrXR0m5pq6zoZ8+QLrPSTvgPgOGjb6BmLgRVQo0yfuA1x4hYHQkdacU1
	A5C58uOcfSfRcRY3qtYIt8Xmt07veidyqhLtXeaZDJ48aMjRt+0ISYWikNAcc5YMRKMImM2G11
	kOc=
X-IronPort-AV: E=Sophos;i="5.79,357,1602518400"; d="scan'208";a="268081233"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com)
	([199.255.45.14])
	by ob1.hgst.iphmx.com with ESMTP; 19 Jan 2021 13:10:26 +0800
IronPort-SDR: aESnWodH/qWxO6PimHwko+yF6jYzyrfPoEMk5n7wDW/TpuNj6T9fJeWS0CuMn15e3AQuHc8QFu
	KdfUvtvml46U3E+0Ig7Hyg72p4/n/nvsi7ocCIqiEZThoMDc3j4erFLLBvyTApUcTnkhDJ24wE
	4hs7X1RANM92P4mX9Bz+ZZdC7wA9qVEYCHjdZBm1mXaa6bQBOt/zqaAbs/2soOUtHK+UGQMEq4
	XVQFTaz7YR2HRdU0fKN2z0EONtYPTw2Wtk0NNi2wkKgC8w5Cj6TLcy//1FMaT++kNM/bf2yfQ8
	hduvl95NqoFpPWsY3lcZBVdr
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	18 Jan 2021 20:55:02 -0800
IronPort-SDR: g+cwRIOSTQKlHz0TlzGiv0v8k42MLuyBePoSPu+3wmyOXSjTG0meJZ3HNMEsZPrUSxEzx4+lF4
	FYsGsM8Atqm4KFkngm6kvE4QJEllDZ5asdg1mlTg0nU6MTigdf/l2fufhP5Dl7cUEXrLWJHA4M
	i1hr5sj5wFf0lV2dBD1wzV0FFnhC0FI0FF05HNG+z9KgIFkwL1XTF/q4l1wSPXPSYwzrtYoVOq
	9diXh4xtcenoTU75CyxNQYMQeVt6zVGgTEkE1aGBQ3BRhKLM/ozH18RVsbfAAMJYj8MbBfck/x
	vIk=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
	by uls-op-cesaip02.wdc.com with ESMTP; 18 Jan 2021 21:10:26 -0800
From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	drbd-dev@tron.linbit.com, linux-bcache@vger.kernel.org,
	linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	cluster-devel@redhat.com
Date: Mon, 18 Jan 2021 21:06:26 -0800
Message-Id: <20210119050631.57073-33-chaitanya.kulkarni@wdc.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
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
Subject: [dm-devel] [RFC PATCH 32/37] eros: use bio_init_fields in zdata
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 fs/erofs/zdata.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index 6cb356c4217b..f7cdae88982a 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1236,12 +1236,9 @@ static void z_erofs_submit_queue(struct super_block *sb,
 
 			if (!bio) {
 				bio = bio_alloc(GFP_NOIO, BIO_MAX_PAGES);
-
-				bio->bi_end_io = z_erofs_decompressqueue_endio;
-				bio_set_dev(bio, sb->s_bdev);
-				bio->bi_iter.bi_sector = (sector_t)cur <<
-					LOG_SECTORS_PER_BLOCK;
-				bio->bi_private = bi_private;
+				bio_init_fields(bio, sb->s_bdev, (sector_t)cur <<
+					LOG_SECTORS_PER_BLOCK, bi_private,
+					z_erofs_decompressqueue_endio, 0, 0);
 				bio->bi_opf = REQ_OP_READ;
 				if (f->readahead)
 					bio->bi_opf |= REQ_RAHEAD;
-- 
2.22.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

