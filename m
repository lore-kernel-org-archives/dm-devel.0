Return-Path: <SRS0=/PHZ=GW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 746FFC433E0
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 05:08:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F343E22CA2
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 05:08:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F343E22CA2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-t94sIWkGPLGvc8UeQozzpg-1; Tue, 19 Jan 2021 00:08:33 -0500
X-MC-Unique: t94sIWkGPLGvc8UeQozzpg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BAE1B806665;
	Tue, 19 Jan 2021 05:08:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9726C1F078;
	Tue, 19 Jan 2021 05:08:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6A97F50031;
	Tue, 19 Jan 2021 05:08:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10J58QDZ020597 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 19 Jan 2021 00:08:26 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C2D8D2026D12; Tue, 19 Jan 2021 05:08:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BDBEB2026D49
	for <dm-devel@redhat.com>; Tue, 19 Jan 2021 05:08:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A7D0682DFE2
	for <dm-devel@redhat.com>; Tue, 19 Jan 2021 05:08:26 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-489-Fk0z_0KHOCOck7UWz9zKdA-1; Tue, 19 Jan 2021 00:08:23 -0500
X-MC-Unique: Fk0z_0KHOCOck7UWz9zKdA-1
IronPort-SDR: IynUi49ob0BnUOvONbjsn1W6alkE7FIqfADGyTAr0njYiboDDcPPQs1JugE4mwLVcsJ40sUMWJ
	7DyUwoqeP5WgOuAMneA0cSB767I3Ik7DgOr9Npw24d6d8uO+HqzuNkjSq3u1QBi2M6Nj7Zgmfv
	i1Ft9GMxrYg4byZxxOcRoWOnxS51pvDM1AaWsQ36FwHiVdA7FVOSXdDkmkwr1inQJnRQaxLc70
	AzY+iZjOm27tbZZk/jNnpkj6VLBypzqNHFUtfMTbvoM92V5reOYnASCIuhj6G59gG+OD7BiAeA
	Wl0=
X-IronPort-AV: E=Sophos;i="5.79,357,1602518400"; d="scan'208";a="261722253"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
	([199.255.45.15])
	by ob1.hgst.iphmx.com with ESMTP; 19 Jan 2021 13:19:00 +0800
IronPort-SDR: 6u++bFpgtanfGLUOIZBSWInNlvTP2vGn+UjkPePm8fztobD/d2mic8RGrsEk5o1aYzkaBWZSBT
	pMZRqoAaZkoLTQ2PV7hGQ00GjmCs+HDB927ebqqNVHV0n7OAqkghVpzSsOif9ypqyDq5HZnsj+
	1tjl7u/e4DtziZ1i0SDOYYQ1Jt89zBiBTI07oVI5x2UJzYeoiXiIgnDfwcJ02G5ta7layRvmZR
	WP2EfKqTPDZmX1ctx+S4NJxpPfQ+BCbyXqSJi5NDkNUX29x0IJyN8BSVgHkQcLImp6rCYh+zjd
	I2cZnymvKCcHBQ0oWrQ5ID92
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	18 Jan 2021 20:50:57 -0800
IronPort-SDR: AukWeQ10GheUQlYR0D5EEj/feVa20cSuWNwottGMwE7opN0/I3RYtMUjQ5GxQSyfBE6/sdBk0k
	z4fxfv6aG+9JDmdOEZ65AwSHkGYtwddoOVkRqi4DvyiiLB8vtd/fOm44eFdRlx5N0V45fVA/G2
	Mrkem+bFgQ/7hMk41j/WbKXfrCn46pyu5FjaWYjPtBRdJOMYXrfOYhaNNWZEy5N5aQ3tw7GglR
	lppVbOb4m+51NXG4xiicKFxmfiLfz3Hlw8sn3kAgisMPSXvCeaKzeiNu728KKk2Lm4HPl2GKbp
	MUo=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
	by uls-op-cesaip02.wdc.com with ESMTP; 18 Jan 2021 21:08:22 -0800
From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	drbd-dev@tron.linbit.com, linux-bcache@vger.kernel.org,
	linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	cluster-devel@redhat.com
Date: Mon, 18 Jan 2021 21:06:09 -0800
Message-Id: <20210119050631.57073-16-chaitanya.kulkarni@wdc.com>
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
Subject: [dm-devel] [RFC PATCH 15/37] drdb: use bio_init_fields in receiver
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 drivers/block/drbd/drbd_receiver.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 09c86ef3f0fd..2715081a4603 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1296,9 +1296,7 @@ static void submit_one_flush(struct drbd_device *device, struct issue_flush_cont
 
 	octx->device = device;
 	octx->ctx = ctx;
-	bio_set_dev(bio, device->ldev->backing_bdev);
-	bio->bi_private = octx;
-	bio->bi_end_io = one_flush_endio;
+	bio_init_fields(bio, device->ldev->backing_bdev, 0, octx, one_flush_endio, 0, 0);
 	bio->bi_opf = REQ_OP_FLUSH | REQ_PREFLUSH;
 
 	device->flush_jif = jiffies;
@@ -1693,12 +1691,9 @@ int drbd_submit_peer_request(struct drbd_device *device,
 		goto fail;
 	}
 	/* > peer_req->i.sector, unless this is the first bio */
-	bio->bi_iter.bi_sector = sector;
-	bio_set_dev(bio, device->ldev->backing_bdev);
+	bio_init_fields(bio, device->ldev->backing_bdev, sector, peer_req,
+			drbd_peer_request_endio, 0, 0);
 	bio_set_op_attrs(bio, op, op_flags);
-	bio->bi_private = peer_req;
-	bio->bi_end_io = drbd_peer_request_endio;
-
 	bio->bi_next = bios;
 	bios = bio;
 	++n_bios;
-- 
2.22.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

