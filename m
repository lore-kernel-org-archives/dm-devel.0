Return-Path: <SRS0=/PHZ=GW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C7A0C433DB
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 05:11:43 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id AFDC122573
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 05:11:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AFDC122573
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-44-tLZQhObHPI2sbKWEQ4LoLQ-1; Tue, 19 Jan 2021 00:11:39 -0500
X-MC-Unique: tLZQhObHPI2sbKWEQ4LoLQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8DFB759;
	Tue, 19 Jan 2021 05:11:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 730AA620D7;
	Tue, 19 Jan 2021 05:11:35 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 47C6F5002C;
	Tue, 19 Jan 2021 05:11:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10J5BXKc021740 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 19 Jan 2021 00:11:33 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8108F4411D; Tue, 19 Jan 2021 05:11:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 75E2D6D9EB
	for <dm-devel@redhat.com>; Tue, 19 Jan 2021 05:11:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0D352187504C
	for <dm-devel@redhat.com>; Tue, 19 Jan 2021 05:11:31 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-478-IxFPcDphN9qVxld8iHMESQ-1; Tue, 19 Jan 2021 00:09:59 -0500
X-MC-Unique: IxFPcDphN9qVxld8iHMESQ-1
IronPort-SDR: 1lJguv9GB3Yr6GrWIKyvrP0zQcWR3CDMkyNfdIXZl4TYotTaKb18xYS85EIb182lCtXU3TVCfa
	bYrxoutdVpVHeiTh5K4MW0pcrgvSsBogREB22D41SBV2bS1pf1iHWNTynhRMbi2WOrlHqMXM/R
	88P1mI6/UBl3vTtuuK0y95BNd9Vnh+iSF8Qp5lxDaY/44hSjzs/JmDVnN/jT/Uo6RPZpP4HhH/
	pT8GTbUXj90+qiGsaeOo0hTNZ9M8AX/DImX8Krbo70HJZXCz3zqEq9KmfFRt0uLzsHnSPqczfV
	mxo=
X-IronPort-AV: E=Sophos;i="5.79,357,1602518400"; d="scan'208";a="268081176"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com)
	([199.255.45.15])
	by ob1.hgst.iphmx.com with ESMTP; 19 Jan 2021 13:09:57 +0800
IronPort-SDR: qF0qLh8SZmOfzS2c6jxRfN1FhyzbNSS4NtiVD0EreldCCEOVJJrlPszKn0j2u98UFt4QwVD8mM
	azCxlMuwvSUP64VvW1JpxDchlb0ll+V8Jc7gP3A129Zr/ANski6C1CKUYUuGo+ACCm5bfw2SQg
	7MJ9DK1v6MgynJTBmJMNFO3HRddr6aTZL8cgQim2DX25nxp2E8Culu9nuOk/Xd3tWtZ0NuM+3J
	CkXps/yGYFhp3xE9u0DMeYn6VDkCL8xcAxKjLw4AeuZwb3ICvfal4YsEDh18+pbQvJiYTc7LLb
	p10p/6sgBWnwloEY0dnK920l
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	18 Jan 2021 20:52:32 -0800
IronPort-SDR: a+gnNfhBGlfndCUXu2PRYuff1boYNdHfSgVMM4QGOo0gBqok0UAFSw+CakQqID9DiHlkJTF/tk
	tfTEZKWrBtDq0dUvqYcf+WsTdC0Igy/6eIFaVKPX3skORR8vkvebU+R6xmJfb/vQkDxguYmQjy
	ooWIxSrSXOWgrTQsQSnSH8xsuNu9hFytU9enoqFYqBIe5DbNODHACUTbxgGCYD+JsMeKIy4eA6
	k/5Kfh84EPk4WfgFSkdXjOf+OkCHZJ/80U/a+Ke2lW0oT2ODaSYtQOG1ltNBLA3AQquOKSkivD
	2TA=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
	by uls-op-cesaip02.wdc.com with ESMTP; 18 Jan 2021 21:09:57 -0800
From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	drbd-dev@tron.linbit.com, linux-bcache@vger.kernel.org,
	linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	cluster-devel@redhat.com
Date: Mon, 18 Jan 2021 21:06:22 -0800
Message-Id: <20210119050631.57073-29-chaitanya.kulkarni@wdc.com>
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
Subject: [dm-devel] [RFC PATCH 28/37] target: use bio_init_fields in iblock
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
 drivers/target/target_core_iblock.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 8ed93fd205c7..ec65a9494bee 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -324,10 +324,7 @@ iblock_get_bio(struct se_cmd *cmd, sector_t lba, u32 sg_num, int op,
 		return NULL;
 	}
 
-	bio_set_dev(bio, ib_dev->ibd_bd);
-	bio->bi_private = cmd;
-	bio->bi_end_io = &iblock_bio_done;
-	bio->bi_iter.bi_sector = lba;
+	bio_init_fields(bio, ib_dev->ibd_bd, lba, cmd, &iblock_bio_done, 0, 0);
 	bio_set_op_attrs(bio, op, op_flags);
 
 	return bio;
@@ -380,11 +377,9 @@ iblock_execute_sync_cache(struct se_cmd *cmd)
 		target_complete_cmd(cmd, SAM_STAT_GOOD);
 
 	bio = bio_alloc(GFP_KERNEL, 0);
-	bio->bi_end_io = iblock_end_io_flush;
-	bio_set_dev(bio, ib_dev->ibd_bd);
+	bio_init_fields(bio, ib_dev->ibd_bd, 0, immed ? NULL : cmd,
+			iblock_end_io_flush, 0, 0);
 	bio->bi_opf = REQ_OP_WRITE | REQ_PREFLUSH;
-	if (!immed)
-		bio->bi_private = cmd;
 	submit_bio(bio);
 	return 0;
 }
-- 
2.22.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

