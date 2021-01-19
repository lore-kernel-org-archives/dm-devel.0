Return-Path: <SRS0=/PHZ=GW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3EC8C433E0
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 05:08:51 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2C47722CA2
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 05:08:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2C47722CA2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-491-qEg-xM1mPM6ekLh9E7IXWg-1; Tue, 19 Jan 2021 00:08:47 -0500
X-MC-Unique: qEg-xM1mPM6ekLh9E7IXWg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0FB72800D55;
	Tue, 19 Jan 2021 05:08:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E4F8527C2E;
	Tue, 19 Jan 2021 05:08:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B57E950030;
	Tue, 19 Jan 2021 05:08:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10J58eA0020667 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 19 Jan 2021 00:08:40 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E70EB4411D; Tue, 19 Jan 2021 05:08:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E1C336D9D9
	for <dm-devel@redhat.com>; Tue, 19 Jan 2021 05:08:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8662E101A560
	for <dm-devel@redhat.com>; Tue, 19 Jan 2021 05:08:37 +0000 (UTC)
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-88-PBhiwwIGNwiNwO_eSi0XJw-1; Tue, 19 Jan 2021 00:08:32 -0500
X-MC-Unique: PBhiwwIGNwiNwO_eSi0XJw-1
IronPort-SDR: Bf+2oH2nd+AJvom/Oat6fb1B3mkFDWiazdb+8WDAn9sdf03AKY3GDK0SgDucLjyJbM7ihOLUUy
	/zQ9fC3lKFND7ol39T8K9kRVl+gn3SB8V8KJuOu3MjokWxPIxGHT7IDzKAcF+iDgsOycMDKy+D
	dRJIY3xlaWEb5fIS5LZpCUklXiq2z9MI0ivACVeBKzfQtWbfccf8yFKjl+JmfKjk4oPW5Sptb9
	y/S5F+x+k3hIRyQjcnnHb00V+cRCI2146nltPk6R0d9Z+tKobktwIBHR24O8S5IXz3JOyWZMEx
	rtA=
X-IronPort-AV: E=Sophos;i="5.79,357,1602518400"; d="scan'208";a="157758631"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com)
	([199.255.45.15])
	by ob1.hgst.iphmx.com with ESMTP; 19 Jan 2021 13:08:30 +0800
IronPort-SDR: +srLMjL4LFW2C3esJiuLI1MK2+iV5bS0Kso2RotBtOgjDsVWn8nGNWVXUQzPf/Uxfzq7nivmmw
	zAUDOtpT/QbqRAg/R9EBEY0nzfpAIwk+Pe13S49yX6PjhoHJSns6yy6VKTNa/Hs9Kz2jHe9F0n
	NTCKqRnxDVFg9mVrQuqJ3QUkl5P6SfE5yIp5T6f9I0J3OivUgGdqymQRmZ9FvcumNnbsVHgVW1
	4Cd2D+mXGkni06O6dDvtoPv9z+6DJBBmIFQtDYK3LhRGLTXkfOurPsS1Ohhj7vFfWyuUTNpZ57
	GM7RaO8iD2ch1zC2Qr52VKAX
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	18 Jan 2021 20:51:05 -0800
IronPort-SDR: P5c68+r5a8DOSQsRGC/PLvFBWof3CYBSZ78/AjZxxbqEhqAxt84O9ZWicHnuz+rOOqV7roKTgj
	twniYUPk2fiAD8Xe2xt0+bCng/kmhe4tRAPsXmMChVmLYeVESDqX1Ch12ppq+swuJrohwMf670
	nW4oFOXw5mZvfoBvM6DRJldmElTkBvSEiHsn4Z6Lj6HNC6nwKfOy7ls60P38dBSPu32aUdCyrJ
	9Xni8CwHGVPZR+TCQgcaFbT87hN7DOlLc38PrOokHP4ypmvZX5OCF+2Q9DRTOOHIgCBKFlVNcC
	QQI=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
	by uls-op-cesaip02.wdc.com with ESMTP; 18 Jan 2021 21:08:30 -0800
From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	drbd-dev@tron.linbit.com, linux-bcache@vger.kernel.org,
	linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	cluster-devel@redhat.com
Date: Mon, 18 Jan 2021 21:06:10 -0800
Message-Id: <20210119050631.57073-17-chaitanya.kulkarni@wdc.com>
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
Subject: [dm-devel] [RFC PATCH 16/37] floppy: use bio_init_fields
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
 drivers/block/floppy.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index dfe1dfc901cc..1237b64bb37b 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4219,13 +4219,10 @@ static int __floppy_read_block_0(struct block_device *bdev, int drive)
 	cbdata.drive = drive;
 
 	bio_init(&bio, &bio_vec, 1);
-	bio_set_dev(&bio, bdev);
+	bio_init_fields(&bio, bdev, 0, &cbdata, floppy_rb0_cb, 0, 0);
 	bio_add_page(&bio, page, block_size(bdev), 0);
 
-	bio.bi_iter.bi_sector = 0;
 	bio.bi_flags |= (1 << BIO_QUIET);
-	bio.bi_private = &cbdata;
-	bio.bi_end_io = floppy_rb0_cb;
 	bio_set_op_attrs(&bio, REQ_OP_READ, 0);
 
 	init_completion(&cbdata.complete);
-- 
2.22.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

