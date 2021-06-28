Return-Path: <SRS0=s8Rv=LW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B418C2B9F4
	for <dm-devel@archiver.kernel.org>; Mon, 28 Jun 2021 09:53:25 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CCF1C61C6B
	for <dm-devel@archiver.kernel.org>; Mon, 28 Jun 2021 09:53:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CCF1C61C6B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fujitsu.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-12-bgF8lpVwNE2mTwNsLsQLmA-1; Mon, 28 Jun 2021 05:53:07 -0400
X-MC-Unique: bgF8lpVwNE2mTwNsLsQLmA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 731941084F55;
	Mon, 28 Jun 2021 09:53:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 44CAA5D6D1;
	Mon, 28 Jun 2021 09:53:01 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AB9F84EA40;
	Mon, 28 Jun 2021 09:53:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15S03bnP027108 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 27 Jun 2021 20:03:37 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 6952220239E6; Mon, 28 Jun 2021 00:03:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 650C320239E7
	for <dm-devel@redhat.com>; Mon, 28 Jun 2021 00:03:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1EDC5800B28
	for <dm-devel@redhat.com>; Mon, 28 Jun 2021 00:03:35 +0000 (UTC)
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by relay.mimecast.com with ESMTP id us-mta-438-agXrPXgdPAuU0U6N-nA7nA-1;
	Sun, 27 Jun 2021 20:03:30 -0400
X-MC-Unique: agXrPXgdPAuU0U6N-nA7nA-1
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3A9Se1iaFrOT7Xo9FfpLqEDseALOsnbusQ8zAX?=
	=?us-ascii?q?P0AYc31om6uj5rmTdZUgpGfJYVkqKRIdcLy7V5VoBEmskaKdgrNhW4tKPjOW2l?=
	=?us-ascii?q?dARbsKheCJrlHd8m/Fh4lgPMxbE5SWZuefMbEDt7ee3OCnKadd/PC3tLCvmfzF?=
	=?us-ascii?q?z2pgCSVja6Rb5Q9/DQqBe3cGPjVuNN4oEoaG/Mpbq36FcXQTVM6yAX4IRKztvN?=
	=?us-ascii?q?vO/aiWHCIuNlo27hWUlzO05PrfGxic5B0XVDRC2vMD3AH+4nfE2pk=3D?=
X-IronPort-AV: E=Sophos;i="5.83,304,1616428800"; d="scan'208";a="110256401"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
	by heian.cn.fujitsu.com with ESMTP; 28 Jun 2021 08:03:28 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
	by cn.fujitsu.com (Postfix) with ESMTP id 11E524D0BA6A;
	Mon, 28 Jun 2021 08:03:24 +0800 (CST)
Received: from G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) by
	G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP
	Server (TLS) id 15.0.1497.2; Mon, 28 Jun 2021 08:03:25 +0800
Received: from irides.mr.mr.mr (10.167.225.141) by
	G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP
	Server
	id 15.0.1497.2 via Frontend Transport; Mon, 28 Jun 2021 08:03:24 +0800
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>, <dm-devel@redhat.com>
Date: Mon, 28 Jun 2021 08:02:18 +0800
Message-ID: <20210628000218.387833-10-ruansy.fnst@fujitsu.com>
In-Reply-To: <20210628000218.387833-1-ruansy.fnst@fujitsu.com>
References: <20210628000218.387833-1-ruansy.fnst@fujitsu.com>
MIME-Version: 1.0
X-yoursite-MailScanner-ID: 11E524D0BA6A.A3DAF
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@fujitsu.com
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
X-Mailman-Approved-At: Mon, 28 Jun 2021 05:52:34 -0400
Cc: snitzer@redhat.com, darrick.wong@oracle.com, rgoldwyn@suse.de,
	david@fromorbit.com, dan.j.williams@intel.com, hch@lst.de, agk@redhat.com
Subject: [dm-devel] [PATCH v5 9/9] fs/dax: Remove useless functions
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

Since owner tracking is triggerred by pmem device, these functions are
useless.  So remove them.

Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
---
 fs/dax.c | 46 ----------------------------------------------
 1 file changed, 46 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 7c5d8acd6bc5..cee8e61d1025 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -334,48 +334,6 @@ static unsigned long dax_end_pfn(void *entry)
 	for (pfn = dax_to_pfn(entry); \
 			pfn < dax_end_pfn(entry); pfn++)

-/*
- * TODO: for reflink+dax we need a way to associate a single page with
- * multiple address_space instances at different linear_page_index()
- * offsets.
- */
-static void dax_associate_entry(void *entry, struct address_space *mapping,
-		struct vm_area_struct *vma, unsigned long address)
-{
-	unsigned long size = dax_entry_size(entry), pfn, index;
-	int i = 0;
-
-	if (IS_ENABLED(CONFIG_FS_DAX_LIMITED))
-		return;
-
-	index = linear_page_index(vma, address & ~(size - 1));
-	for_each_mapped_pfn(entry, pfn) {
-		struct page *page = pfn_to_page(pfn);
-
-		WARN_ON_ONCE(page->mapping);
-		page->mapping = mapping;
-		page->index = index + i++;
-	}
-}
-
-static void dax_disassociate_entry(void *entry, struct address_space *mapping,
-		bool trunc)
-{
-	unsigned long pfn;
-
-	if (IS_ENABLED(CONFIG_FS_DAX_LIMITED))
-		return;
-
-	for_each_mapped_pfn(entry, pfn) {
-		struct page *page = pfn_to_page(pfn);
-
-		WARN_ON_ONCE(trunc && page_ref_count(page) > 1);
-		WARN_ON_ONCE(page->mapping && page->mapping != mapping);
-		page->mapping = NULL;
-		page->index = 0;
-	}
-}
-
 static struct page *dax_busy_page(void *entry)
 {
 	unsigned long pfn;
@@ -554,7 +512,6 @@ static void *grab_mapping_entry(struct xa_state *xas,
 			xas_lock_irq(xas);
 		}

-		dax_disassociate_entry(entry, mapping, false);
 		xas_store(xas, NULL);	/* undo the PMD join */
 		dax_wake_entry(xas, entry, WAKE_ALL);
 		mapping->nrpages -= PG_PMD_NR;
@@ -691,7 +648,6 @@ static int __dax_invalidate_entry(struct address_space *mapping,
 	    (xas_get_mark(&xas, PAGECACHE_TAG_DIRTY) ||
 	     xas_get_mark(&xas, PAGECACHE_TAG_TOWRITE)))
 		goto out;
-	dax_disassociate_entry(entry, mapping, trunc);
 	xas_store(&xas, NULL);
 	mapping->nrpages -= 1UL << dax_entry_order(entry);
 	ret = 1;
@@ -785,8 +741,6 @@ static void *dax_insert_entry(struct xa_state *xas,
 	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry)) {
 		void *old;

-		dax_disassociate_entry(entry, mapping, false);
-		dax_associate_entry(new_entry, mapping, vmf->vma, vmf->address);
 		/*
 		 * Only swap our new entry into the page cache if the current
 		 * entry is a zero page or an empty entry.  If a normal PTE or
--
2.32.0



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

