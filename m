Return-Path: <SRS0=XDEt=G7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81109C433E6
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jan 2021 08:51:45 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DE20E64DD1
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jan 2021 08:51:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DE20E64DD1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-516-aGEzj9U8N3mWcK1z0FNuUQ-1; Thu, 28 Jan 2021 03:51:42 -0500
X-MC-Unique: aGEzj9U8N3mWcK1z0FNuUQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9DFE4180A09D;
	Thu, 28 Jan 2021 08:51:37 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7603A19716;
	Thu, 28 Jan 2021 08:51:37 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4C22C4A7C7;
	Thu, 28 Jan 2021 08:51:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10S7DJMW007451 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 28 Jan 2021 02:13:20 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id CA7EE2026D76; Thu, 28 Jan 2021 07:13:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C442C2026D48
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 07:13:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 31DDB82DFE1
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 07:13:17 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-543-qWlgliabMo2-gag9JctsNQ-1; Thu, 28 Jan 2021 02:13:12 -0500
X-MC-Unique: qWlgliabMo2-gag9JctsNQ-1
IronPort-SDR: A030fhameSsfnGln7mKOTIx9OYzz0fTqppwc+LyIs21BXfi7FW5ZEOJvOHU/MbhJr70UOjiTHL
	A94JsNBK0BILXP7wwuEifzE+4U3EIkBeS3VAIbz7asOUpaKJEmS8pSrc7RgAtkfb82KB1OOv4K
	B2+H9xgaQLkTXVFAXDhq2V7B3qK5nZISN+lKaajfbIRGqmFw6JU9rNXvYzO4+wHqAatlFlC3+1
	HW2Vk+rpWTsZwk1Zidqrx+/FKnR1G0uzYsCuj3WE/nLXX91nPxgB2zMBE1zx+wZeaNUHvxaHfH
	s6I=
X-IronPort-AV: E=Sophos;i="5.79,381,1602518400"; d="scan'208";a="159693821"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com)
	([199.255.45.15])
	by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2021 15:13:11 +0800
IronPort-SDR: mf4dg9ypKcWY8RXzR8gOTBy+dvUHUsRP0X/pK5ALjMY3FSp3NC97uBJKCp8eYGcfCCH3Tbvb5Z
	Ch2k5ZzLKSMiYNVTHkY77kQeXlTCyLmNA5noYvy0KEuqoq+zupzRnBEKD4n7tmsN5/hYvOPAJZ
	re/bKFuz9JizX09lpNru6pz5KhCxfg+FSI5kWnuhVkEtLudHGuuIdDtNDBau4WJDJ4A5JcEBBW
	GdRwoYRSmNi3rjvfC1i9eOZ10UOa7+A0tk19QwCnUin0ZOlOmeI4UCb9mqc2IWowpr3GD5Ejxa
	4KwmkO0QimINUOI9gGAHCNgK
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	27 Jan 2021 22:55:29 -0800
IronPort-SDR: B3g2yURiLlkRDJQjiSw5Axb2Dh2vXpaNrKE/QAQl3YC0d9KYF6ZY/2WEGrs8Ad4s6CTMSYijlI
	As81DRh7fxTUcG6XscFZ0dEUGMxghLXCUSNbFTul1lhg8N84M173b0zoMSc59+C6RPGCZyVbXT
	e5q9NGchuukS+6n/XolnPl9CgZkf3lpSTdPe2xwj7IsZkLY+Q3H2m4972b6vr4aHe8P7F7VrjW
	YTjKY9EpCmYYdyolrCzI7bP6MpRPHgjkbRdfoyYEpwC7inxXY41c/i8ke9uNT4EC8+Q8lA/Kgh
	6rI=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
	by uls-op-cesaip02.wdc.com with ESMTP; 27 Jan 2021 23:13:11 -0800
From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dm-devel@redhat.com, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, drbd-dev@tron.linbit.com,
	xen-devel@lists.xenproject.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	linux-fscrypt@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
	linux-nilfs@vger.kernel.org, ocfs2-devel@oss.oracle.com,
	linux-pm@vger.kernel.org, linux-mm@kvack.org
Date: Wed, 27 Jan 2021 23:11:09 -0800
Message-Id: <20210128071133.60335-11-chaitanya.kulkarni@wdc.com>
In-Reply-To: <20210128071133.60335-1-chaitanya.kulkarni@wdc.com>
References: <20210128071133.60335-1-chaitanya.kulkarni@wdc.com>
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
X-Mailman-Approved-At: Thu, 28 Jan 2021 03:38:55 -0500
Cc: shaggy@kernel.org, sergey.senozhatsky.work@gmail.com, snitzer@redhat.com,
	tiwai@suse.de, djwong@kernel.org, gustavoars@kernel.org,
	joseph.qi@linux.alibaba.com, pavel@ucw.cz,
	alex.shi@linux.alibaba.com, hch@lst.de, agk@redhat.com,
	naohiro.aota@wdc.com, sagi@grimberg.me, mark@fasheh.com,
	osandov@fb.com, ebiggers@kernel.org, ngupta@vflare.org,
	len.brown@intel.com, chaitanya.kulkarni@wdc.com,
	konrad.wilk@oracle.com, ming.lei@redhat.com,
	viro@zeniv.linux.org.uk, jefflexu@linux.alibaba.com,
	jaegeuk@kernel.org, konishi.ryusuke@gmail.com,
	bvanassche@acm.org, axboe@kernel.dk, damien.lemoal@wdc.com,
	tytso@mit.edu, akpm@linux-foundation.org,
	martin.petersen@oracle.com, rjw@rjwysocki.net,
	philipp.reisner@linbit.com, minchan@kernel.org, tj@kernel.org,
	lars.ellenberg@linbit.com, jth@kernel.org,
	asml.silence@gmail.com, jlbec@evilplan.org, roger.pau@citrix.com
Subject: [dm-devel] [RFC PATCH 10/34] dm-zoned: use bio_new in dmz_rdwr_block
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
 drivers/md/dm-zoned-metadata.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index fa0ee732c6e9..5b5ed5fce2ed 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -755,13 +755,11 @@ static int dmz_rdwr_block(struct dmz_dev *dev, int op,
 	if (dmz_bdev_is_dying(dev))
 		return -EIO;
 
-	bio = bio_alloc(GFP_NOIO, 1);
+	bio = bio_new(dev->bdev, dmz_blk2sect(block), op,
+		      REQ_SYNC | REQ_META | REQ_PRIO, 1, GFP_NOIO);
 	if (!bio)
 		return -ENOMEM;
 
-	bio->bi_iter.bi_sector = dmz_blk2sect(block);
-	bio_set_dev(bio, dev->bdev);
-	bio_set_op_attrs(bio, op, REQ_SYNC | REQ_META | REQ_PRIO);
 	bio_add_page(bio, page, DMZ_BLOCK_SIZE, 0);
 	ret = submit_bio_wait(bio);
 	bio_put(bio);
-- 
2.22.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

