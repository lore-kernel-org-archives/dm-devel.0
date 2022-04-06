Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94252C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  6 Apr 2022 05:20:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-265-Cm1XzNdMMiifXqSINJ1quw-1; Wed, 06 Apr 2022 01:20:13 -0400
X-MC-Unique: Cm1XzNdMMiifXqSINJ1quw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A49841C05AF1;
	Wed,  6 Apr 2022 05:20:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 540E942784F;
	Wed,  6 Apr 2022 05:20:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 05DFB1947BBB;
	Wed,  6 Apr 2022 05:20:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7B6BF19451F3
 for <dm-devel@listman.corp.redhat.com>; Wed,  6 Apr 2022 05:20:10 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4760040CF910; Wed,  6 Apr 2022 05:20:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 42BEC40CF905
 for <dm-devel@redhat.com>; Wed,  6 Apr 2022 05:20:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2B56B8038E3
 for <dm-devel@redhat.com>; Wed,  6 Apr 2022 05:20:10 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-340-lTf8npV8NcubxFR5MmQxNA-1; Wed, 06 Apr 2022 01:20:08 -0400
X-MC-Unique: lTf8npV8NcubxFR5MmQxNA-1
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red
 Hat Linux)) id 1nby5G-003oBJ-1m; Wed, 06 Apr 2022 05:19:58 +0000
Date: Tue, 5 Apr 2022 22:19:58 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jane Chu <jane.chu@oracle.com>
Message-ID: <Yk0i/pODntZ7lbDo@infradead.org>
References: <20220405194747.2386619-1-jane.chu@oracle.com>
 <20220405194747.2386619-5-jane.chu@oracle.com>
MIME-Version: 1.0
In-Reply-To: <20220405194747.2386619-5-jane.chu@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH v7 4/6] dax: add DAX_RECOVERY flag and
 .recovery_write dev_pgmap_ops
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: nvdimm@lists.linux.dev, dave.jiang@intel.com, snitzer@redhat.com,
 djwong@kernel.org, x86@kernel.org, david@fromorbit.com,
 linux-kernel@vger.kernel.org, willy@infradead.org, hch@infradead.org,
 dm-devel@redhat.com, vgoyal@redhat.com, vishal.l.verma@intel.com,
 linux-fsdevel@vger.kernel.org, dan.j.williams@intel.com, ira.weiny@intel.com,
 linux-xfs@vger.kernel.org, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="uA3+SxEy8RfCAOX5"
Content-Disposition: inline

--uA3+SxEy8RfCAOX5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 05, 2022 at 01:47:45PM -0600, Jane Chu wrote:
> Introduce DAX_RECOVERY flag to dax_direct_access(). The flag is
> not set by default in dax_direct_access() such that the helper
> does not translate a pmem range to kernel virtual address if the
> range contains uncorrectable errors.  When the flag is set,
> the helper ignores the UEs and return kernel virtual adderss so
> that the caller may get on with data recovery via write.
> 
> Also introduce a new dev_pagemap_ops .recovery_write function.
> The function is applicable to FSDAX device only. The device
> page backend driver provides .recovery_write function if the
> device has underlying mechanism to clear the uncorrectable
> errors on the fly.

I know Dan suggested it, but I still think dev_pagemap_ops is the very
wrong choice here.  It is about VM callbacks to ZONE_DEVICE owners
independent of what pagemap type they are.  .recovery_write on the
other hand is completely specific to the DAX write path and has no
MM interactions at all.

>  /* see "strong" declaration in tools/testing/nvdimm/pmem-dax.c */
>  __weak long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
> -		long nr_pages, void **kaddr, pfn_t *pfn)
> +		long nr_pages, int flags, void **kaddr, pfn_t *pfn)
>  {
>  	resource_size_t offset = PFN_PHYS(pgoff) + pmem->data_offset;
> +	sector_t sector = PFN_PHYS(pgoff) >> SECTOR_SHIFT;
> +	unsigned int num = PFN_PHYS(nr_pages) >> SECTOR_SHIFT;
> +	struct badblocks *bb = &pmem->bb;
> +	sector_t first_bad;
> +	int num_bad;
> +	bool bad_in_range;
> +	long actual_nr;
> +
> +	if (!bb->count)
> +		bad_in_range = false;
> +	else
> +		bad_in_range = !!badblocks_check(bb, sector, num, &first_bad, &num_bad);
>  
> -	if (unlikely(is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512,
> -					PFN_PHYS(nr_pages))))
> +	if (bad_in_range && !(flags & DAX_RECOVERY))
>  		return -EIO;

The use of bad_in_range here seems a litle convoluted.  See the attached
patch on how I would structure the function to avoid the variable and
have the reocvery code in a self-contained chunk.

> -		map_len = dax_direct_access(dax_dev, pgoff, PHYS_PFN(size),
> -				&kaddr, NULL);
> +		nrpg = PHYS_PFN(size);
> +		map_len = dax_direct_access(dax_dev, pgoff, nrpg, 0, &kaddr, NULL);

Overly long line here.

--uA3+SxEy8RfCAOX5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=diff

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index b868a88a0d589..377e4d59aa90f 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -272,42 +272,40 @@ __weak long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
 	struct badblocks *bb = &pmem->bb;
 	sector_t first_bad;
 	int num_bad;
-	bool bad_in_range;
-	long actual_nr;
-
-	if (!bb->count)
-		bad_in_range = false;
-	else
-		bad_in_range = !!badblocks_check(bb, sector, num, &first_bad, &num_bad);
-
-	if (bad_in_range && !(flags & DAX_RECOVERY))
-		return -EIO;
 
 	if (kaddr)
 		*kaddr = pmem->virt_addr + offset;
 	if (pfn)
 		*pfn = phys_to_pfn_t(pmem->phys_addr + offset, pmem->pfn_flags);
 
-	if (!bad_in_range) {
+	if (bb->count &&
+	    badblocks_check(bb, sector, num, &first_bad, &num_bad)) {
+		long actual_nr;
+
+		if (!(flags & DAX_RECOVERY))
+			return -EIO;
 		/*
-		 * If badblock is present but not in the range, limit known good range
-		 * to the requested range.
+		 * Set the recovery stride to the kernel page size because the
+		 * underlying driver and firmware clear poison functions don't
+		 * appear to handle large chunk (such as
+		 * 2MiB) reliably.
 		 */
-		if (bb->count)
-			return nr_pages;
-		return PHYS_PFN(pmem->size - pmem->pfn_pad - offset);
+		actual_nr = PHYS_PFN(
+			PAGE_ALIGN((first_bad - sector) << SECTOR_SHIFT));
+		dev_dbg(pmem->bb.dev, "start sector(%llu), nr_pages(%ld), first_bad(%llu), actual_nr(%ld)\n",
+				sector, nr_pages, first_bad, actual_nr);
+		if (actual_nr)
+			return actual_nr;
+		return 1;
 	}
 
 	/*
-	 * In case poison is found in the given range and DAX_RECOVERY flag is set,
-	 * recovery stride is set to kernel page size because the underlying driver and
-	 * firmware clear poison functions don't appear to handle large chunk (such as
-	 * 2MiB) reliably.
+	 * If badblock is present but not in the range, limit known good range
+	 * to the requested range.
 	 */
-	actual_nr = PHYS_PFN(PAGE_ALIGN((first_bad - sector) << SECTOR_SHIFT));
-	dev_dbg(pmem->bb.dev, "start sector(%llu), nr_pages(%ld), first_bad(%llu), actual_nr(%ld)\n",
-			sector, nr_pages, first_bad, actual_nr);
-	return (actual_nr == 0) ? 1 : actual_nr;
+	if (bb->count)
+		return nr_pages;
+	return PHYS_PFN(pmem->size - pmem->pfn_pad - offset);
 }
 
 static const struct block_device_operations pmem_fops = {

--uA3+SxEy8RfCAOX5
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--uA3+SxEy8RfCAOX5--

