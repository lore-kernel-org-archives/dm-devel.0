Return-Path: <SRS0=/PHZ=GW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41713C433E0
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 05:08:59 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B6DF522BE9
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 05:08:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B6DF522BE9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-131-W90MIiHZNgWHgBuh8eFz9g-1; Tue, 19 Jan 2021 00:08:55 -0500
X-MC-Unique: W90MIiHZNgWHgBuh8eFz9g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0054110054FF;
	Tue, 19 Jan 2021 05:08:49 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D5E4557;
	Tue, 19 Jan 2021 05:08:48 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AD2DF1809CA2;
	Tue, 19 Jan 2021 05:08:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10J58lLT020720 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 19 Jan 2021 00:08:47 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id DE05F112D169; Tue, 19 Jan 2021 05:08:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DA129112D16F
	for <dm-devel@redhat.com>; Tue, 19 Jan 2021 05:08:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D1A3C858EEC
	for <dm-devel@redhat.com>; Tue, 19 Jan 2021 05:08:44 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-462-bgjP5nOVMK-3iqVCi4frhg-2; Tue, 19 Jan 2021 00:08:40 -0500
X-MC-Unique: bgjP5nOVMK-3iqVCi4frhg-2
IronPort-SDR: AWdYhsdnR2BeNutYnsxH9Tb8RvzNNjCOW8i5o606tUggwcF5E1yNZoVzDU+qqZL+BbC6PXTmwd
	A596uLZjOOWgKzC3WzIx5JrijMeIRe1A8qH73q+SmspOYSIsJ92/Pmqnb7KStW2B0Ei393Q6FL
	hF79pwhaV6f8sOxTZsTsEuy002QyXJ7i6LKPfVRUfwbVv2mfxyRha3iTcGku8D80AeSbctXl20
	PLsmPxNuBKjvjXUFV8Sfn0OO1k15WrJlIU8nr0SBGCv1B79qgGa9tOTiwjrmAee+FM/qQ6tPH7
	Q7s=
X-IronPort-AV: E=Sophos;i="5.79,357,1602518400"; d="scan'208";a="162201090"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com)
	([199.255.45.14])
	by ob1.hgst.iphmx.com with ESMTP; 19 Jan 2021 13:08:37 +0800
IronPort-SDR: B++/icjoVfzkgKWv/Qbse3NiYx6tm90UISnW48KsZgWu9WLIihTw7lt03yF8+FdsBqiew/86n4
	z/ctUaJk8AdM07M2vlkGjCRIcYv/t51GMA2/yIK9j92J49yD6cAXQ03rf5qTzIW1+HfXaGbqD6
	yG34JvJiNAMIx7pFaBRPjEvE4zJvD2j/k4N/4zV6RTZ2ChKYPxOHNZ93fo0y5PjTeE2TwokV/Q
	NM8JzFN8SpwMZlAXHScFgtJpWwzAGCQAS0Lr+Czp0k6ykVsJgzvi1saWmN29X+yZTlC6MfVPn3
	EFvO1JqVEQp9MAyl/xza+U75
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	18 Jan 2021 20:53:15 -0800
IronPort-SDR: JlGfCHshT1mK+XacVyirUo0rFyjPWt2f31VZ3z2J1Z+1bAsxbYaQqDfkpztEmemcjkFKSqFtBW
	eEHx4MKVO6uhGP44oLoJjur9xUH9E+nf+FFdLDlrYS2WxbXcD7sJerBxjAL9tpVS6iMx+k6Ygk
	O6RIIA/q4UYqrDznEz4/cneeqCBOoZihS6qjthtpQtFPN4aYc3uvtGPOTbAR+UEONOX62l4CZO
	swheoC8AcejSmyN7MaD5wpht27eshQMMdBz4TnpekpmQcRnvSAFWabxuH6D+W4HdmuEhyRgLHS
	mSA=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
	by uls-op-cesaip02.wdc.com with ESMTP; 18 Jan 2021 21:08:37 -0800
From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	drbd-dev@tron.linbit.com, linux-bcache@vger.kernel.org,
	linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	cluster-devel@redhat.com
Date: Mon, 18 Jan 2021 21:06:11 -0800
Message-Id: <20210119050631.57073-18-chaitanya.kulkarni@wdc.com>
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
Subject: [dm-devel] [RFC PATCH 17/37] pktcdvd: use bio_init_fields
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 drivers/block/pktcdvd.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index b8bb8ec7538d..47eb4e0bd4c3 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -1028,10 +1028,8 @@ static void pkt_gather_data(struct pktcdvd_device *pd, struct packet_data *pkt)
 
 		bio = pkt->r_bios[f];
 		bio_reset(bio);
-		bio->bi_iter.bi_sector = pkt->sector + f * (CD_FRAMESIZE >> 9);
-		bio_set_dev(bio, pd->bdev);
-		bio->bi_end_io = pkt_end_io_read;
-		bio->bi_private = pkt;
+		bio_init_fields(bio, pd->bdev, pkt->sector + f * (CD_FRAMESIZE >> 9), pkt,
+				pkt_end_io_read, 0, 0);
 
 		p = (f * CD_FRAMESIZE) / PAGE_SIZE;
 		offset = (f * CD_FRAMESIZE) % PAGE_SIZE;
@@ -1208,10 +1206,8 @@ static void pkt_start_write(struct pktcdvd_device *pd, struct packet_data *pkt)
 	int f;
 
 	bio_reset(pkt->w_bio);
-	pkt->w_bio->bi_iter.bi_sector = pkt->sector;
-	bio_set_dev(pkt->w_bio, pd->bdev);
-	pkt->w_bio->bi_end_io = pkt_end_io_packet_write;
-	pkt->w_bio->bi_private = pkt;
+	bio_init_fields(pkt->w_bio, pd->bdev, pkt->sector, pkt,
+			pkt_end_io_packet_write, 0, 0);
 
 	/* XXX: locking? */
 	for (f = 0; f < pkt->frames; f++) {
-- 
2.22.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

