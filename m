Return-Path: <SRS0=/PHZ=GW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D631C433DB
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 05:11:00 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 17D37206F8
	for <dm-devel@archiver.kernel.org>; Tue, 19 Jan 2021 05:10:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 17D37206F8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-287-7m3iCv6CM5C1cZwN1wZljA-1; Tue, 19 Jan 2021 00:10:56 -0500
X-MC-Unique: 7m3iCv6CM5C1cZwN1wZljA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A75651005504;
	Tue, 19 Jan 2021 05:10:51 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 847F2620D7;
	Tue, 19 Jan 2021 05:10:51 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 58CE85002E;
	Tue, 19 Jan 2021 05:10:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10J5Andk021523 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 19 Jan 2021 00:10:50 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C98C52026D13; Tue, 19 Jan 2021 05:10:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C4D652026D11
	for <dm-devel@redhat.com>; Tue, 19 Jan 2021 05:10:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4063F858280
	for <dm-devel@redhat.com>; Tue, 19 Jan 2021 05:10:47 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-487-ccr6RaBoOV-2Wr5Y4vuyWA-1; Tue, 19 Jan 2021 00:10:42 -0500
X-MC-Unique: ccr6RaBoOV-2Wr5Y4vuyWA-1
IronPort-SDR: me66d1yU4p9hBo/Fag0KoTptBbVdy6mT4dG6nihrqaPCfx+xorYvgNxRsYEo+rOtqsfE2KEW1R
	D1RFGN/Ky0Eyyb8lk4LrW/AZ9FyMG4Hy/rcbggnVaMMyCyfJr+1o/C7JEwAJ0f5VOeXNO63nAS
	CPMyKqWDLibOPRoBGn+X+6jjl23HN8tCinHpED842R46AQnI1Q9dzJDJwIKQe3c8U8GvYOyjfC
	YDTVXoGigfIBGAv653HIYB4Ubiat4NYor/W/0fEI97XlEUhNcQT6GUcUe3tO5oX9OQ8LzpGs74
	5lA=
X-IronPort-AV: E=Sophos;i="5.79,357,1602518400"; d="scan'208";a="158940794"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com)
	([199.255.45.14])
	by ob1.hgst.iphmx.com with ESMTP; 19 Jan 2021 13:10:41 +0800
IronPort-SDR: c/aH/K/VWIsg3Wm8kJumf/+fhG1w1L77D8u27mAGhscbTh+0Ec9JmrY00rc4fgTmZOZ2cIuR5I
	iuWRr/o35kA6EIBl1QhGzrh6PzwQJNe5ZpVBsYljN38ZlGQFfOj96sBrTop5s7Gb4xORo1K2AV
	WuIOreQW2g9k80FNF3Tkkf1sxL7VKR2JIkMSaCA0nA3sGqt72o3tx4ow4OKoMf3ELt0UnDmVUQ
	GhDimj4bpbvYxO8ZwG1bTQ6s4q0OrbsrVpY7ol8cmFiEtrubanZQ8E4WTDw+v6OeS1AoSdE3kb
	g5mzrPm0JN2eBU7bMyjjPiz+
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	18 Jan 2021 20:55:17 -0800
IronPort-SDR: oklSZwC4T98igITkHvUN5/cFLVu1yS+dVuRFw1rj6Sypghilpv1dq004ftoRiIcXr+1cvb1C+g
	e1+GCw894PQkPu1QcGSBSC17BzbJVdUoKLEKnb23R5ToJPinuljlR2aaNZBBxuQfj4BqaudRJa
	XDGeUKlYGqrX0PkiJf+ZiBwJ6Ik8t4zeEDjdqLOFU05xrby1lNOvGG7JThAaPObtceSdxUj1c7
	/m5QwBatTkcZcWmVuIDWjsPnj5ACeHofJxm9d2p07oDQHlNegcWml37RbpxW8gEnNxSajg/OqB
	c4E=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
	by uls-op-cesaip02.wdc.com with ESMTP; 18 Jan 2021 21:10:40 -0800
From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	drbd-dev@tron.linbit.com, linux-bcache@vger.kernel.org,
	linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	cluster-devel@redhat.com
Date: Mon, 18 Jan 2021 21:06:28 -0800
Message-Id: <20210119050631.57073-35-chaitanya.kulkarni@wdc.com>
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
Subject: [dm-devel] [RFC PATCH 34/37] nfs: use bio_init_fields in blocklayout
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
 fs/nfs/blocklayout/blocklayout.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/nfs/blocklayout/blocklayout.c b/fs/nfs/blocklayout/blocklayout.c
index 3be6836074ae..7ac96519c8b7 100644
--- a/fs/nfs/blocklayout/blocklayout.c
+++ b/fs/nfs/blocklayout/blocklayout.c
@@ -128,12 +128,8 @@ bl_alloc_init_bio(int npg, struct block_device *bdev, sector_t disk_sector,
 			bio = bio_alloc(GFP_NOIO, npg);
 	}
 
-	if (bio) {
-		bio->bi_iter.bi_sector = disk_sector;
-		bio_set_dev(bio, bdev);
-		bio->bi_end_io = end_io;
-		bio->bi_private = par;
-	}
+	if (bio)
+		bio_init_fields(bio, bdev, disk_sector, par, end_io, 0, 0);
 	return bio;
 }
 
-- 
2.22.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

