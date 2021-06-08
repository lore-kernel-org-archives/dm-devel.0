Return-Path: <SRS0=BzfN=LC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A2C1C47082
	for <dm-devel@archiver.kernel.org>; Tue,  8 Jun 2021 16:48:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2EE7261246
	for <dm-devel@archiver.kernel.org>; Tue,  8 Jun 2021 16:48:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2EE7261246
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-462-WZD68tkQNRqNttnY7fXUMg-1; Tue, 08 Jun 2021 12:48:30 -0400
X-MC-Unique: WZD68tkQNRqNttnY7fXUMg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 835F9100830F;
	Tue,  8 Jun 2021 16:48:26 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 60ECD5D9DC;
	Tue,  8 Jun 2021 16:48:26 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 09EF21801265;
	Tue,  8 Jun 2021 16:48:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 158GmOdo023806 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 8 Jun 2021 12:48:24 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 184902014F84; Tue,  8 Jun 2021 16:48:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 13C5D200B664
	for <dm-devel@redhat.com>; Tue,  8 Jun 2021 16:48:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C8CE2802E5E
	for <dm-devel@redhat.com>; Tue,  8 Jun 2021 16:48:21 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-352-8yHd6OaVOtq9ymZVs-6h_A-1; Tue, 08 Jun 2021 12:48:19 -0400
X-MC-Unique: 8yHd6OaVOtq9ymZVs-6h_A-1
Received: from [2001:4bb8:192:ff5f:74ed:7c4f:a5ee:8dcb] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1lqeFN-009Rfa-Dj; Tue, 08 Jun 2021 16:06:34 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Tue,  8 Jun 2021 18:05:55 +0200
Message-Id: <20210608160603.1535935-9-hch@lst.de>
In-Reply-To: <20210608160603.1535935-1-hch@lst.de>
References: <20210608160603.1535935-1-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Mike Snitzer <snitzer@redhat.com>, Geoff Levand <geoff@infradead.org>,
	linuxppc-dev@lists.ozlabs.org, linux-mips@vger.kernel.org,
	Dongsheng Yang <dongsheng.yang@easystack.cn>,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Ilya Dryomov <idryomov@gmail.com>,
	Ira Weiny <ira.weiny@intel.com>, ceph-devel@vger.kernel.org
Subject: [dm-devel] [PATCH 08/16] dm-writecache: use bvec_kmap_local instead
	of bvec_kmap_irq
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

There is no need to disable interrupts in bio_copy_block, and the local
only mappings helps to avoid any sort of problems with stray writes
into the bio data.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-writecache.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index aecc246ade26..93ca454eaca9 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -1205,14 +1205,13 @@ static void memcpy_flushcache_optimized(void *dest, void *source, size_t size)
 static void bio_copy_block(struct dm_writecache *wc, struct bio *bio, void *data)
 {
 	void *buf;
-	unsigned long flags;
 	unsigned size;
 	int rw = bio_data_dir(bio);
 	unsigned remaining_size = wc->block_size;
 
 	do {
 		struct bio_vec bv = bio_iter_iovec(bio, bio->bi_iter);
-		buf = bvec_kmap_irq(&bv, &flags);
+		buf = bvec_kmap_local(&bv);
 		size = bv.bv_len;
 		if (unlikely(size > remaining_size))
 			size = remaining_size;
@@ -1230,7 +1229,7 @@ static void bio_copy_block(struct dm_writecache *wc, struct bio *bio, void *data
 			memcpy_flushcache_optimized(data, buf, size);
 		}
 
-		bvec_kunmap_irq(buf, &flags);
+		kunmap_local(buf);
 
 		data = (char *)data + size;
 		remaining_size -= size;
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

