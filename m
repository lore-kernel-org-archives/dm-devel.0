Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CEEFC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 27 Jan 2022 07:15:21 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665-6gx9XXPNN22HbPkeDX06dQ-1; Thu, 27 Jan 2022 02:15:16 -0500
X-MC-Unique: 6gx9XXPNN22HbPkeDX06dQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 12ED91091DA0;
	Thu, 27 Jan 2022 07:15:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A7CD74EC78;
	Thu, 27 Jan 2022 07:15:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 171E84BB7C;
	Thu, 27 Jan 2022 07:15:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20R7FAaA003622 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 27 Jan 2022 02:15:10 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 012A1740A; Thu, 27 Jan 2022 07:15:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F172B76CF
	for <dm-devel@redhat.com>; Thu, 27 Jan 2022 07:15:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D1ED01C084C9
	for <dm-devel@redhat.com>; Thu, 27 Jan 2022 07:15:06 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-111-YLBW1eMHNra-S0KRf8wufw-1; Thu, 27 Jan 2022 02:15:05 -0500
X-MC-Unique: YLBW1eMHNra-S0KRf8wufw-1
Received: from 213-225-10-69.nat.highway.a1.net ([213.225.10.69]
	helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nCyOP-00EYCd-7E; Thu, 27 Jan 2022 06:36:25 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Thu, 27 Jan 2022 07:35:42 +0100
Message-Id: <20220127063546.1314111-11-hch@lst.de>
In-Reply-To: <20220127063546.1314111-1-hch@lst.de>
References: <20220127063546.1314111-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	bombadil.infradead.org. See http://www.infradead.org/rpr.html
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
Cc: Mike Snitzer <snitzer@redhat.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	Pavel Begunkov <asml.silence@gmail.com>, drbd-dev@lists.linbit.com
Subject: [dm-devel] [PATCH 10/14] dm-cache: remove
	__remap_to_origin_clear_discard
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
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

Fold __remap_to_origin_clear_discard into the two callers to prepare
for bio cloning refactoring.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-cache-target.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 447d030036d18..1c37fe028e531 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -744,21 +744,14 @@ static void check_if_tick_bio_needed(struct cache *cache, struct bio *bio)
 	spin_unlock_irq(&cache->lock);
 }
 
-static void __remap_to_origin_clear_discard(struct cache *cache, struct bio *bio,
-					    dm_oblock_t oblock, bool bio_has_pbd)
-{
-	if (bio_has_pbd)
-		check_if_tick_bio_needed(cache, bio);
-	remap_to_origin(cache, bio);
-	if (bio_data_dir(bio) == WRITE)
-		clear_discard(cache, oblock_to_dblock(cache, oblock));
-}
-
 static void remap_to_origin_clear_discard(struct cache *cache, struct bio *bio,
 					  dm_oblock_t oblock)
 {
 	// FIXME: check_if_tick_bio_needed() is called way too much through this interface
-	__remap_to_origin_clear_discard(cache, bio, oblock, true);
+	check_if_tick_bio_needed(cache, bio);
+	remap_to_origin(cache, bio);
+	if (bio_data_dir(bio) == WRITE)
+		clear_discard(cache, oblock_to_dblock(cache, oblock));
 }
 
 static void remap_to_cache_dirty(struct cache *cache, struct bio *bio,
@@ -831,11 +824,10 @@ static void remap_to_origin_and_cache(struct cache *cache, struct bio *bio,
 	BUG_ON(!origin_bio);
 
 	bio_chain(origin_bio, bio);
-	/*
-	 * Passing false to __remap_to_origin_clear_discard() skips
-	 * all code that might use per_bio_data (since clone doesn't have it)
-	 */
-	__remap_to_origin_clear_discard(cache, origin_bio, oblock, false);
+
+	remap_to_origin(cache, origin_bio);
+	if (bio_data_dir(origin_bio) == WRITE)
+		clear_discard(cache, oblock_to_dblock(cache, oblock));
 	submit_bio(origin_bio);
 
 	remap_to_cache(cache, bio, cblock);
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

