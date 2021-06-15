Return-Path: <SRS0=rgwX=LJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8A6EC48BDF
	for <dm-devel@archiver.kernel.org>; Tue, 15 Jun 2021 13:32:51 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 654FE61474
	for <dm-devel@archiver.kernel.org>; Tue, 15 Jun 2021 13:32:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 654FE61474
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-484-3hXJL6SbP3SXqiss4LOqBw-1; Tue, 15 Jun 2021 09:32:49 -0400
X-MC-Unique: 3hXJL6SbP3SXqiss4LOqBw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2B5FC8042D4;
	Tue, 15 Jun 2021 13:32:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0A3141813C;
	Tue, 15 Jun 2021 13:32:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C199C46F59;
	Tue, 15 Jun 2021 13:32:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15FDWgmt005355 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 15 Jun 2021 09:32:42 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 6AD32207ADC2; Tue, 15 Jun 2021 13:32:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 665A2208AB80
	for <dm-devel@redhat.com>; Tue, 15 Jun 2021 13:32:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 98DA290DE26
	for <dm-devel@redhat.com>; Tue, 15 Jun 2021 13:32:39 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-380-SziYQ-1fMRm-btyFgASXIA-1; Tue, 15 Jun 2021 09:32:35 -0400
X-MC-Unique: SziYQ-1fMRm-btyFgASXIA-1
Received: from [2001:4bb8:19b:fdce:9045:1e63:20f0:ca9] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1lt942-006nuT-C1; Tue, 15 Jun 2021 13:25:13 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>, Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 15 Jun 2021 15:24:39 +0200
Message-Id: <20210615132456.753241-2-hch@lst.de>
In-Reply-To: <20210615132456.753241-1-hch@lst.de>
References: <20210615132456.753241-1-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: linux-arch@vger.kernel.org, linux-block@vger.kernel.org,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Mike Snitzer <snitzer@redhat.com>, Geoff Levand <geoff@infradead.org>,
	linuxppc-dev@lists.ozlabs.org, linux-mips@vger.kernel.org,
	Dongsheng Yang <dongsheng.yang@easystack.cn>, linux-kernel@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	dm-devel@redhat.com, Ilya Dryomov <idryomov@gmail.com>,
	Ira Weiny <ira.weiny@intel.com>, ceph-devel@vger.kernel.org
Subject: [dm-devel] [PATCH 01/18] mm: add a kunmap_local_dirty helper
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

Add a helper that calls flush_kernel_dcache_page before unmapping the
local mapping.  flush_kernel_dcache_page is required for all pages
potentially mapped into userspace that were written to using kmap*,
so having a helper that does the right thing can be very convenient.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/highmem-internal.h | 7 +++++++
 include/linux/highmem.h          | 4 ++++
 2 files changed, 11 insertions(+)

diff --git a/include/linux/highmem-internal.h b/include/linux/highmem-internal.h
index 7902c7d8b55f..bd37706db147 100644
--- a/include/linux/highmem-internal.h
+++ b/include/linux/highmem-internal.h
@@ -224,4 +224,11 @@ do {								\
 	__kunmap_local(__addr);					\
 } while (0)
 
+#define kunmap_local_dirty(__page, __addr)			\
+do {								\
+	if (!PageSlab(__page))					\
+		flush_kernel_dcache_page(__page);		\
+	kunmap_local(__addr);					\
+} while (0)
+
 #endif
diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index 832b49b50c7b..65f548db4f2d 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -93,6 +93,10 @@ static inline void kmap_flush_unused(void);
  * On HIGHMEM enabled systems mapping a highmem page has the side effect of
  * disabling migration in order to keep the virtual address stable across
  * preemption. No caller of kmap_local_page() can rely on this side effect.
+ *
+ * If data is written to the returned kernel mapping, the callers needs to
+ * unmap the mapping using kunmap_local_dirty(), else kunmap_local() should
+ * be used.
  */
 static inline void *kmap_local_page(struct page *page);
 
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

