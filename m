Return-Path: <SRS0=/PHZ=GW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A906C433E0
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 05:08:53 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0305522DA9
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 05:08:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0305522DA9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-587-9Ov1SkdkOXGzSPKEXksQiA-1; Tue, 19 Jan 2021 00:08:50 -0500
X-MC-Unique: 9Ov1SkdkOXGzSPKEXksQiA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F24C510055B0;
	Tue, 19 Jan 2021 05:08:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CBD62722D9;
	Tue, 19 Jan 2021 05:08:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9D4BF50032;
	Tue, 19 Jan 2021 05:08:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10J58eMU020671 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 19 Jan 2021 00:08:40 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 16A3D2166B2B; Tue, 19 Jan 2021 05:08:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 104562166B29
	for <dm-devel@redhat.com>; Tue, 19 Jan 2021 05:08:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D4C4A800969
	for <dm-devel@redhat.com>; Tue, 19 Jan 2021 05:08:35 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-255-7V_0gJYDPfmFWT7DXpuPKg-1; Tue, 19 Jan 2021 00:08:31 -0500
X-MC-Unique: 7V_0gJYDPfmFWT7DXpuPKg-1
IronPort-SDR: ytermj/v20O8JI+FBI/f9aLvDcTsCO5cAE9aw1QjYWH35RXCHAWbhKeNTIgIgz8dLjEIcaHXha
	s6qENnmma0xcAJczPfosMoTJIX6UdomkDKWWvFFY72EjCA3/80nQKX9IHqs5evhiJFIP31Ru7k
	MTSuIIQj2LKnXB/6BsJI65QdBAj9B58jmTSRSR1eLglHoOAnLGvNImPHqNAh/gQ07cYo+d2CO6
	bwUzHNZHEuaR/oFSeACB6S6AQX6me8h5jfmSzGgGgmBw41ZaUHxX2caTLVNYLjvOFkHyI8+cxF
	O5s=
X-IronPort-AV: E=Sophos;i="5.79,357,1602518400"; d="scan'208";a="157763825"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com)
	([199.255.45.15])
	by ob1.hgst.iphmx.com with ESMTP; 19 Jan 2021 13:07:26 +0800
IronPort-SDR: 9krwsX04IMmGjpY2sgaaNNQXRL4H9md4/zW18OaRj+r+2Lz0PSr5GR6Krd2ZeFL/SuaXCY6P94
	DFspTyfH+CQjplA+iUAucaU2YmyFkv53aTr4US/2bQKgx6Ety7IvhyhclaHCtM78elLYqvca2X
	FevGCIBjqMvbO51u8b+tcgNgDdPt2Vo6K+aja4EClYNFUn+i6cTwWtY9HP5doaNqgRYGTPkwqe
	9NILdxygo4L2CNcRS1U+uqng/5Ubcf9S5VavDR8DYZ10Q3jLR8NsEPe+B/ii8/bspyOUSJyNuJ
	KjQXDnyW5LtC9s8W+D1IOFVT
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	18 Jan 2021 20:50:01 -0800
IronPort-SDR: RfcxC1FWYGpS0fNCrOs8BtNtAvGS3Soo9XuKQebXkTCgbWAqTp1EKLrasZ0evXuMWoITBnHtNY
	2oxDBYpgHVdIOlbC//vNMX0StFZhGCaZIsKA9cFY7fNqh1OY5fcl3ycEabv+HgHkEc/CXDDC1y
	fzmKDnwNyp8ppyfiLjfpBXI3+rhzN33czQz3Cn2qnuTvExV9IqScOwNt057FA/Z+bR+5w8O/JO
	uiXUS8DdnaYj0tdtbLaCu8GXso9K+bCVoTPbDi0BV1XABhEY6VgIhePNhopNBAIoFyoLyU4M28
	AtU=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
	by uls-op-cesaip02.wdc.com with ESMTP; 18 Jan 2021 21:07:26 -0800
From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	drbd-dev@tron.linbit.com, linux-bcache@vger.kernel.org,
	linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	cluster-devel@redhat.com
Date: Mon, 18 Jan 2021 21:06:01 -0800
Message-Id: <20210119050631.57073-8-chaitanya.kulkarni@wdc.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
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
Subject: [dm-devel] [RFC PATCH 07/37] gfs2: use bio_init_fields in meta_io
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
 fs/gfs2/meta_io.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
index 2db573e31f78..822489b10aec 100644
--- a/fs/gfs2/meta_io.c
+++ b/fs/gfs2/meta_io.c
@@ -217,8 +217,8 @@ static void gfs2_submit_bhs(int op, int op_flags, struct buffer_head *bhs[],
 		struct bio *bio;
 
 		bio = bio_alloc(GFP_NOIO, num);
-		bio->bi_iter.bi_sector = bh->b_blocknr * (bh->b_size >> 9);
-		bio_set_dev(bio, bh->b_bdev);
+		bio_init_fields(bio, bh->b_bdev, bh->b_blocknr * (bh->b_size >> 9), NULL,
+				gfs2_meta_read_endio, 0, 0);
 		while (num > 0) {
 			bh = *bhs;
 			if (!bio_add_page(bio, bh->b_page, bh->b_size, bh_offset(bh))) {
@@ -228,7 +228,6 @@ static void gfs2_submit_bhs(int op, int op_flags, struct buffer_head *bhs[],
 			bhs++;
 			num--;
 		}
-		bio->bi_end_io = gfs2_meta_read_endio;
 		bio_set_op_attrs(bio, op, op_flags);
 		submit_bio(bio);
 	}
-- 
2.22.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

