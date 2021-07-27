Return-Path: <SRS0=tlLk=MT=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7152C4338F
	for <dm-devel@archiver.kernel.org>; Tue, 27 Jul 2021 06:14:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2921A61103
	for <dm-devel@archiver.kernel.org>; Tue, 27 Jul 2021 06:14:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2921A61103
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-75-bVDT9v92NDGsI0pIUExFdQ-1; Tue, 27 Jul 2021 02:14:38 -0400
X-MC-Unique: bVDT9v92NDGsI0pIUExFdQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D2C7C195D565;
	Tue, 27 Jul 2021 06:14:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A99EF9C8C5;
	Tue, 27 Jul 2021 06:14:30 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 070A74BB7C;
	Tue, 27 Jul 2021 06:14:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16R6EQPB011347 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 27 Jul 2021 02:14:26 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 32939CF607; Tue, 27 Jul 2021 06:14:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2B45BCF616
	for <dm-devel@redhat.com>; Tue, 27 Jul 2021 06:14:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BB95396B04C
	for <dm-devel@redhat.com>; Tue, 27 Jul 2021 06:14:23 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-366-8nH9K4RBNGmI8qo-vgHgaA-1; Tue, 27 Jul 2021 02:14:21 -0400
X-MC-Unique: 8nH9K4RBNGmI8qo-vgHgaA-1
Received: from [2001:4bb8:184:87c5:b7fb:1299:a9e5:ff56] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1m8GHj-00Ej6t-Dn; Tue, 27 Jul 2021 06:10:20 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>, Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 27 Jul 2021 07:56:40 +0200
Message-Id: <20210727055646.118787-10-hch@lst.de>
In-Reply-To: <20210727055646.118787-1-hch@lst.de>
References: <20210727055646.118787-1-hch@lst.de>
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
Cc: linux-arch@vger.kernel.org, linux-block@vger.kernel.org,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Mike Snitzer <snitzer@redhat.com>, Geoff Levand <geoff@infradead.org>,
	linuxppc-dev@lists.ozlabs.org, ceph-devel@vger.kernel.org,
	linux-mips@vger.kernel.org, Dongsheng Yang <dongsheng.yang@easystack.cn>,
	linux-kernel@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	dm-devel@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
	Ira Weiny <ira.weiny@intel.com>, Ilya Dryomov <idryomov@gmail.com>
Subject: [dm-devel] [PATCH 09/15] block: remove bvec_kmap_irq and
	bvec_kunmap_irq
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

These two helpers are entirely unused now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 include/linux/bio.h | 42 ------------------------------------------
 1 file changed, 42 deletions(-)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index 2203b686e1f0..7b5f65a81f2b 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -5,7 +5,6 @@
 #ifndef __LINUX_BIO_H
 #define __LINUX_BIO_H
 
-#include <linux/highmem.h>
 #include <linux/mempool.h>
 #include <linux/ioprio.h>
 /* struct bio, bio_vec and BIO_* flags are defined in blk_types.h */
@@ -519,47 +518,6 @@ static inline void bio_clone_blkg_association(struct bio *dst,
 					      struct bio *src) { }
 #endif	/* CONFIG_BLK_CGROUP */
 
-#ifdef CONFIG_HIGHMEM
-/*
- * remember never ever reenable interrupts between a bvec_kmap_irq and
- * bvec_kunmap_irq!
- */
-static inline char *bvec_kmap_irq(struct bio_vec *bvec, unsigned long *flags)
-{
-	unsigned long addr;
-
-	/*
-	 * might not be a highmem page, but the preempt/irq count
-	 * balancing is a lot nicer this way
-	 */
-	local_irq_save(*flags);
-	addr = (unsigned long) kmap_atomic(bvec->bv_page);
-
-	BUG_ON(addr & ~PAGE_MASK);
-
-	return (char *) addr + bvec->bv_offset;
-}
-
-static inline void bvec_kunmap_irq(char *buffer, unsigned long *flags)
-{
-	unsigned long ptr = (unsigned long) buffer & PAGE_MASK;
-
-	kunmap_atomic((void *) ptr);
-	local_irq_restore(*flags);
-}
-
-#else
-static inline char *bvec_kmap_irq(struct bio_vec *bvec, unsigned long *flags)
-{
-	return page_address(bvec->bv_page) + bvec->bv_offset;
-}
-
-static inline void bvec_kunmap_irq(char *buffer, unsigned long *flags)
-{
-	*flags = 0;
-}
-#endif
-
 /*
  * BIO list management for use by remapping drivers (e.g. DM or MD) and loop.
  *
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

