Return-Path: <SRS0=BzfN=LC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2BE4C47082
	for <dm-devel@archiver.kernel.org>; Tue,  8 Jun 2021 16:49:09 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5524A61246
	for <dm-devel@archiver.kernel.org>; Tue,  8 Jun 2021 16:49:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5524A61246
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-572-OsA1rqlRNg69crJ4uHLHJQ-1; Tue, 08 Jun 2021 12:49:06 -0400
X-MC-Unique: OsA1rqlRNg69crJ4uHLHJQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5329D107ACC7;
	Tue,  8 Jun 2021 16:49:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 363FB60CC6;
	Tue,  8 Jun 2021 16:49:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 067CF1801265;
	Tue,  8 Jun 2021 16:49:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 158Gn059023916 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 8 Jun 2021 12:49:00 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 6C41C2EF94; Tue,  8 Jun 2021 16:49:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 66A412EF89
	for <dm-devel@redhat.com>; Tue,  8 Jun 2021 16:48:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4413A18E0920
	for <dm-devel@redhat.com>; Tue,  8 Jun 2021 16:48:57 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-600-jmLNC6etM36kYt0gAImzxg-1; Tue, 08 Jun 2021 12:48:55 -0400
X-MC-Unique: jmLNC6etM36kYt0gAImzxg-1
Received: from [2001:4bb8:192:ff5f:74ed:7c4f:a5ee:8dcb] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1lqeFH-009RdW-2S; Tue, 08 Jun 2021 16:06:27 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Tue,  8 Jun 2021 18:05:53 +0200
Message-Id: <20210608160603.1535935-7-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Mike Snitzer <snitzer@redhat.com>, Geoff Levand <geoff@infradead.org>,
	linuxppc-dev@lists.ozlabs.org, linux-mips@vger.kernel.org,
	Dongsheng Yang <dongsheng.yang@easystack.cn>,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Ilya Dryomov <idryomov@gmail.com>,
	Ira Weiny <ira.weiny@intel.com>, ceph-devel@vger.kernel.org
Subject: [dm-devel] [PATCH 06/16] block: use memzero_page in zero_fill_bio
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Use memzero_bvec to zero each segment in the bio instead of manually
mapping and zeroing the data.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 44205dfb6b60..1d7abdb83a39 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -495,16 +495,11 @@ EXPORT_SYMBOL(bio_kmalloc);
 
 void zero_fill_bio(struct bio *bio)
 {
-	unsigned long flags;
 	struct bio_vec bv;
 	struct bvec_iter iter;
 
-	bio_for_each_segment(bv, bio, iter) {
-		char *data = bvec_kmap_irq(&bv, &flags);
-		memset(data, 0, bv.bv_len);
-		flush_dcache_page(bv.bv_page);
-		bvec_kunmap_irq(data, &flags);
-	}
+	bio_for_each_segment(bv, bio, iter)
+		memzero_bvec(&bv);
 }
 EXPORT_SYMBOL(zero_fill_bio);
 
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

