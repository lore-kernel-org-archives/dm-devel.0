Return-Path: <SRS0=/PHZ=GW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23A3DC433E0
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 05:08:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A2E4822CA2
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 05:08:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A2E4822CA2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-JZ9_u_0oOuC_V-cE5XyPuQ-1; Tue, 19 Jan 2021 00:08:15 -0500
X-MC-Unique: JZ9_u_0oOuC_V-cE5XyPuQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6B4B7107ACFA;
	Tue, 19 Jan 2021 05:08:11 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4DF8860C75;
	Tue, 19 Jan 2021 05:08:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 21C6E5002D;
	Tue, 19 Jan 2021 05:08:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10J589sv020458 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 19 Jan 2021 00:08:09 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A02446D9D9; Tue, 19 Jan 2021 05:08:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9AB1F63AFA
	for <dm-devel@redhat.com>; Tue, 19 Jan 2021 05:08:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 87EA5101A560
	for <dm-devel@redhat.com>; Tue, 19 Jan 2021 05:08:09 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-418-hTuwq9IQP6yNFxIAhIzjxw-1; Tue, 19 Jan 2021 00:08:01 -0500
X-MC-Unique: hTuwq9IQP6yNFxIAhIzjxw-1
IronPort-SDR: XxCGySHFaV784YQy+3az/vgy/mVtLb0Kau8EKrzVBbdaFm42sWMF1Hw4ikID7X6cOK7Nq/Qw/p
	hSmZymnhbMchBkwgJYbTotqHGs097hLR0YtQK5LwvGIJ8/eW0IF224GRSEmu7DJL32cuRfr4s+
	9ux5nTh02zh1/+LH9i1sZuSUw9QasNWER/SNg7FOH0N+BBEUxhyeshtgb8ul8Fah8x5cSeBM+a
	GjEfFZhQpqYTUNGa5lAqMWd0UixXyaAvsWjz5KFLU9w2FRifE+GCncP6pUd6EcU9O5BpFAuF0Z
	VxU=
X-IronPort-AV: E=Sophos;i="5.79,357,1602518400"; d="scan'208";a="158940429"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com)
	([199.255.45.14])
	by ob1.hgst.iphmx.com with ESMTP; 19 Jan 2021 13:06:58 +0800
IronPort-SDR: HE8Bo1aPpEFVKFlYNB6vQfH9kiddxOt8xFOq3U7LoejHzl1bJZXAyK5EeQ5U8KcQ78yRJQqcSr
	InqEyB4WlBbzRfRhomq3VZeuddy1K3el5QlrqHoSkf7PTElfJXHmvHQKIXiqpSXj8rCXw9eCgs
	JdRozwxaTVhrOAqT8AkSLxT9kUoulXAZJP0xPbairCfOkmDXILrJhODNFJffKZS9uGNQAUqMSY
	s/AYg/LjSdCTtCELG5QJT0EV+38X+SD90NkdzIywU2CtnfUra6b569bXXVRNdE1iFe1eWtvhgA
	h7Mz5qAKy2dEsz9BYswnHzpF
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	18 Jan 2021 20:51:35 -0800
IronPort-SDR: 2QvgFwKv1l58qACx1LkMFx25aQa2SIK+nja25KW+g1fGCIsFCI2aDBEoSVRt5vd+mstvmW96a+
	737tI66XYa3YGuNZc7mhzaBx90mzE+7INtx21d/7HVJL8Fs4lXsY46xoeP6qPWvnDZ3ihPj4yc
	0PHxNbwk5lPXU8GKWjmU1O8sK8W4HyOAc9WnAAEnbKb4wGAIm+2gNrXPeVygtgzGsA4DXXJ+Yd
	mrqI036gzbWwtshapKuKgeKERGx47y7vTXELUquL2fc2urlWZF3SUiFLdWMNhtGfvEB6B//WSB
	xEk=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
	by uls-op-cesaip02.wdc.com with ESMTP; 18 Jan 2021 21:06:57 -0800
From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	drbd-dev@tron.linbit.com, linux-bcache@vger.kernel.org,
	linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	cluster-devel@redhat.com
Date: Mon, 18 Jan 2021 21:05:57 -0800
Message-Id: <20210119050631.57073-4-chaitanya.kulkarni@wdc.com>
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
Subject: [dm-devel] [RFC PATCH 03/37] btrfs: use bio_init_fields in disk-io
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 fs/btrfs/disk-io.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 765deefda92b..9a65432fc5e9 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3637,10 +3637,8 @@ static int write_dev_supers(struct btrfs_device *device,
 		 * checking.
 		 */
 		bio = bio_alloc(GFP_NOFS, 1);
-		bio_set_dev(bio, device->bdev);
-		bio->bi_iter.bi_sector = bytenr >> SECTOR_SHIFT;
-		bio->bi_private = device;
-		bio->bi_end_io = btrfs_end_super_write;
+		bio_init_fields(bio, device->bdev, bytenr >> SECTOR_SHIFT,
+				device, btrfs_end_super_write, 0, 0);
 		__bio_add_page(bio, page, BTRFS_SUPER_INFO_SIZE,
 			       offset_in_page(bytenr));
 
@@ -3748,11 +3746,10 @@ static void write_dev_flush(struct btrfs_device *device)
 		return;
 
 	bio_reset(bio);
-	bio->bi_end_io = btrfs_end_empty_barrier;
-	bio_set_dev(bio, device->bdev);
 	bio->bi_opf = REQ_OP_WRITE | REQ_SYNC | REQ_PREFLUSH;
 	init_completion(&device->flush_wait);
-	bio->bi_private = &device->flush_wait;
+	bio_init_fields(bio, device->bdev, 0, &device->flush_wait,
+			btrfs_end_empty_barrier, 0, 0);
 
 	btrfsic_submit_bio(bio);
 	set_bit(BTRFS_DEV_STATE_FLUSH_SENT, &device->dev_state);
-- 
2.22.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

