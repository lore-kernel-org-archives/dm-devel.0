Return-Path: <SRS0=/PHZ=GW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A60CC433DB
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 05:08:30 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 917C922CA2
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 05:08:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 917C922CA2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-TJyNwU02OcGEPUcj4tjfyA-1; Tue, 19 Jan 2021 00:08:26 -0500
X-MC-Unique: TJyNwU02OcGEPUcj4tjfyA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EB4A1806671;
	Tue, 19 Jan 2021 05:08:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CE8FF6A8EC;
	Tue, 19 Jan 2021 05:08:21 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A4C4050032;
	Tue, 19 Jan 2021 05:08:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10J58KFs020548 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 19 Jan 2021 00:08:20 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 91D012026D12; Tue, 19 Jan 2021 05:08:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8CF192026D11
	for <dm-devel@redhat.com>; Tue, 19 Jan 2021 05:08:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9E63B858284
	for <dm-devel@redhat.com>; Tue, 19 Jan 2021 05:08:17 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-189-GkYZtY9WPimPvs2Aw-I8VA-1; Tue, 19 Jan 2021 00:08:11 -0500
X-MC-Unique: GkYZtY9WPimPvs2Aw-I8VA-1
IronPort-SDR: EoeOB5ZdS+M9zT1kIgygPniqn4MKq17yY9itCkb939Ut5G1X7v1fS3cQVtjNmEHTZWxvn1QIPU
	Af0/RkUDUTqZhvkIgOA4e6Vp2MOoVPo4l0gUVezxr3Ljl7tgrJ5qu8hwzW/1rumBlJi6ijokQS
	25JMLkPgYajBZOFJ/7UpVaeFxqBQIHntv7GTy9Ob/UmXhnW2hI2rx7iwDcdnUzKYGQxGdr19A/
	GWmxTMr6QbJ4P7AXu7Xn7Ob2eH61kB4YTy1Rf49c/SMPQModRyfeOQbicbxcCK4x2rCxeUm6GC
	nqU=
X-IronPort-AV: E=Sophos;i="5.79,357,1602518400"; d="scan'208";a="157763777"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com)
	([199.255.45.15])
	by ob1.hgst.iphmx.com with ESMTP; 19 Jan 2021 13:07:04 +0800
IronPort-SDR: RZrX4uWQN67u8p89F77pBevs9w4FBFl1eYE8axdICtS/VH8Wc/HzA04G8DIKRbHIjy18jwGXTp
	V4X4xXBJrIfzCvkK73KIQgAnZTyXr/WeoyrkbxHNUVwuPrf4Y4OFekB8N5/ISQ4W02aDPEozgb
	P57tMR7o8a91EWywqQIBMDT/Xc/CkiYxwnY7n6/14r+SEFIfwOiWPziFrSTh9xApAQbrpFFXvo
	Wf7pceEHFRgL0jvl/TzC28duaCMsLg8udcxn1PAcWso64t+S5j8lot/9HCvYNJV0WcgoBEPMWm
	oAEHyxIWPwyHg8caB47+DKCM
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	18 Jan 2021 20:49:40 -0800
IronPort-SDR: pxAqff3CzY6SNypEdU8pcyRF7Ycp2XDG/dFXp67ii/ClPi77Zq14dTS0/Abfh56tMQEJCZUgEv
	hp/pu5jYnyf4G6Ftz6560hm1xTauIc3+qd7iUoR92HKspQ4jIbCxp/rRkQaHksEACl6G/0Nxwk
	QZZl1HrIzXwoiE65870EG7Al72AiwGtlVjZjJc6GYoY+JOC16HDs1pPQioV4bpbAPsiE8/On0q
	zAsBgNZtal+/XzWJ5D9TE5/A5r3kkpStmQ4w13z8jL1gTn8oG9nSDXfj42gpMTqu+V2gtyTMTx
	oyE=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
	by uls-op-cesaip02.wdc.com with ESMTP; 18 Jan 2021 21:07:04 -0800
From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	drbd-dev@tron.linbit.com, linux-bcache@vger.kernel.org,
	linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	cluster-devel@redhat.com
Date: Mon, 18 Jan 2021 21:05:58 -0800
Message-Id: <20210119050631.57073-5-chaitanya.kulkarni@wdc.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
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
Subject: [dm-devel] [RFC PATCH 04/37] btrfs: use bio_init_fields in volumes
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
 fs/btrfs/volumes.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index ee086fc56c30..836167212252 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6371,14 +6371,12 @@ static void submit_stripe_bio(struct btrfs_bio *bbio, struct bio *bio,
 
 	bio->bi_private = bbio;
 	btrfs_io_bio(bio)->device = dev;
-	bio->bi_end_io = btrfs_end_bio;
-	bio->bi_iter.bi_sector = physical >> 9;
+	bio_init_fields(bio, dev->bdev, physical >> 9, bbio, btrfs_end_bio, 0, 0);
 	btrfs_debug_in_rcu(fs_info,
 	"btrfs_map_bio: rw %d 0x%x, sector=%llu, dev=%lu (%s id %llu), size=%u",
 		bio_op(bio), bio->bi_opf, bio->bi_iter.bi_sector,
 		(unsigned long)dev->bdev->bd_dev, rcu_str_deref(dev->name),
 		dev->devid, bio->bi_iter.bi_size);
-	bio_set_dev(bio, dev->bdev);
 
 	btrfs_bio_counter_inc_noblocked(fs_info);
 
-- 
2.22.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

