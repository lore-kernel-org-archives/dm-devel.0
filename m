Return-Path: <SRS0=Cj1z=G5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3597EC433DB
	for <dm-devel@archiver.kernel.org>; Tue, 26 Jan 2021 15:11:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8BFD0230FE
	for <dm-devel@archiver.kernel.org>; Tue, 26 Jan 2021 15:11:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8BFD0230FE
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-531-3-xLPe2KNNO-HYiV-ru9ww-1; Tue, 26 Jan 2021 10:10:59 -0500
X-MC-Unique: 3-xLPe2KNNO-HYiV-ru9ww-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E222415720;
	Tue, 26 Jan 2021 15:10:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C091510016FF;
	Tue, 26 Jan 2021 15:10:53 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8FA9F5002E;
	Tue, 26 Jan 2021 15:10:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10QFAY2l014017 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 26 Jan 2021 10:10:34 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5A0B19465C; Tue, 26 Jan 2021 15:10:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 54DEA94655
	for <dm-devel@redhat.com>; Tue, 26 Jan 2021 15:10:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DFE54100B165
	for <dm-devel@redhat.com>; Tue, 26 Jan 2021 15:10:29 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-303-Px0aHgmHONupDKH_8pDCOA-1; Tue, 26 Jan 2021 10:10:25 -0500
X-MC-Unique: Px0aHgmHONupDKH_8pDCOA-1
Received: from [2001:4bb8:191:e347:5918:ac86:61cb:8801] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
	id 1l4PwO-005nSC-70; Tue, 26 Jan 2021 15:07:53 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>
Date: Tue, 26 Jan 2021 15:52:39 +0100
Message-Id: <20210126145247.1964410-10-hch@lst.de>
In-Reply-To: <20210126145247.1964410-1-hch@lst.de>
References: <20210126145247.1964410-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	casper.infradead.org. See http://www.infradead.org/rpr.html
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
Cc: Mike Snitzer <snitzer@redhat.com>, David Sterba <dsterba@suse.com>,
	dm-devel@redhat.com, Naohiro Aota <naohiro.aota@wdc.com>,
	linux-nilfs@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
	Chao Yu <chao@kernel.org>, linux-nfs@vger.kernel.org,
	Coly Li <colyli@suse.de>, linux-raid@vger.kernel.org,
	linux-bcache@vger.kernel.org, drbd-dev@tron.linbit.com,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>, linux-block@vger.kernel.org,
	Damien Le Moal <damien.lemoal@wdc.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Philipp Reisner <philipp.reisner@linbit.com>,
	linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
	Lars Ellenberg <lars.ellenberg@linbit.com>, linux-btrfs@vger.kernel.org
Subject: [dm-devel] [PATCH 09/17] drbd: remove bio_alloc_drbd
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Given that drbd_md_io_bio_set is initialized during module initialization
and the module fails to load if the initialization fails there is no need
to fall back to plain bio_alloc.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/drbd/drbd_actlog.c |  2 +-
 drivers/block/drbd/drbd_bitmap.c |  2 +-
 drivers/block/drbd/drbd_int.h    |  2 --
 drivers/block/drbd/drbd_main.c   | 13 -------------
 4 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index 7227fc7ab8ed1e..72cf7603d51fc7 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -138,7 +138,7 @@ static int _drbd_md_sync_page_io(struct drbd_device *device,
 		op_flags |= REQ_FUA | REQ_PREFLUSH;
 	op_flags |= REQ_SYNC;
 
-	bio = bio_alloc_drbd(GFP_NOIO);
+	bio = bio_alloc_bioset(GFP_NOIO, 1, &drbd_md_io_bio_set);
 	bio_set_dev(bio, bdev->md_bdev);
 	bio->bi_iter.bi_sector = sector;
 	err = -EIO;
diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
index df53dca5d02c7e..c1f816f896a89a 100644
--- a/drivers/block/drbd/drbd_bitmap.c
+++ b/drivers/block/drbd/drbd_bitmap.c
@@ -976,7 +976,7 @@ static void drbd_bm_endio(struct bio *bio)
 
 static void bm_page_io_async(struct drbd_bm_aio_ctx *ctx, int page_nr) __must_hold(local)
 {
-	struct bio *bio = bio_alloc_drbd(GFP_NOIO);
+	struct bio *bio = bio_alloc_bioset(GFP_NOIO, 1, &drbd_md_io_bio_set);
 	struct drbd_device *device = ctx->device;
 	struct drbd_bitmap *b = device->bitmap;
 	struct page *page;
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index b2c93a29c251fd..02db50d7e4c668 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1422,8 +1422,6 @@ extern mempool_t drbd_md_io_page_pool;
 /* We also need to make sure we get a bio
  * when we need it for housekeeping purposes */
 extern struct bio_set drbd_md_io_bio_set;
-/* to allocate from that set */
-extern struct bio *bio_alloc_drbd(gfp_t gfp_mask);
 
 /* And a bio_set for cloning */
 extern struct bio_set drbd_io_bio_set;
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 1c8c18b2a25f33..788dd97e6026b8 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -138,19 +138,6 @@ static const struct block_device_operations drbd_ops = {
 	.release	= drbd_release,
 };
 
-struct bio *bio_alloc_drbd(gfp_t gfp_mask)
-{
-	struct bio *bio;
-
-	if (!bioset_initialized(&drbd_md_io_bio_set))
-		return bio_alloc(gfp_mask, 1);
-
-	bio = bio_alloc_bioset(gfp_mask, 1, &drbd_md_io_bio_set);
-	if (!bio)
-		return NULL;
-	return bio;
-}
-
 #ifdef __CHECKER__
 /* When checking with sparse, and this is an inline function, sparse will
    give tons of false positives. When this is a real functions sparse works.
-- 
2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

