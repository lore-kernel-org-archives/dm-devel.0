Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEFB1C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  2 Feb 2022 13:44:08 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-159-wwBPBM2qODOoxWHHBUl9OQ-1; Wed, 02 Feb 2022 08:44:04 -0500
X-MC-Unique: wwBPBM2qODOoxWHHBUl9OQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1B6E892504;
	Wed,  2 Feb 2022 13:44:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B6F9C798B0;
	Wed,  2 Feb 2022 13:43:59 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0D06D1809CB8;
	Wed,  2 Feb 2022 13:43:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 212Dhvia029375 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Feb 2022 08:43:57 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5FE69C33AE5; Wed,  2 Feb 2022 13:43:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5C633C33AE3
	for <dm-devel@redhat.com>; Wed,  2 Feb 2022 13:43:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 41C2E38035A3
	for <dm-devel@redhat.com>; Wed,  2 Feb 2022 13:43:57 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-277-HWw4y2EMMSOMmHCJoN_Gcg-1; Wed, 02 Feb 2022 08:43:52 -0500
X-MC-Unique: HWw4y2EMMSOMmHCJoN_Gcg-1
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red
	Hat Linux)) id 1nFFvE-00FNjc-Ie; Wed, 02 Feb 2022 13:43:44 +0000
Date: Wed, 2 Feb 2022 05:43:44 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jane Chu <jane.chu@oracle.com>
Message-ID: <YfqKkEB3gBsiuMZt@infradead.org>
References: <20220128213150.1333552-1-jane.chu@oracle.com>
	<20220128213150.1333552-6-jane.chu@oracle.com>
MIME-Version: 1.0
In-Reply-To: <20220128213150.1333552-6-jane.chu@oracle.com>
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-loop: dm-devel@redhat.com
Cc: nvdimm@lists.linux.dev, dave.jiang@intel.com, snitzer@redhat.com,
	djwong@kernel.org, david@fromorbit.com,
	linux-kernel@vger.kernel.org, willy@infradead.org,
	hch@infradead.org, dm-devel@redhat.com, vgoyal@redhat.com,
	vishal.l.verma@intel.com, linux-fsdevel@vger.kernel.org,
	dan.j.williams@intel.com, ira.weiny@intel.com,
	linux-xfs@vger.kernel.org, agk@redhat.com
Subject: Re: [dm-devel] [PATCH v5 5/7] pmem: add pmem_recovery_write() dax op
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
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> @@ -257,10 +263,15 @@ static int pmem_rw_page(struct block_device *bdev, sector_t sector,
>  __weak long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
>  		long nr_pages, void **kaddr, pfn_t *pfn)
>  {
> +	bool bad_pmem;
> +	bool do_recovery = false;
>  	resource_size_t offset = PFN_PHYS(pgoff) + pmem->data_offset;
>  
> -	if (unlikely(is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512,
> -					PFN_PHYS(nr_pages))))
> +	bad_pmem = is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512,
> +				PFN_PHYS(nr_pages));
> +	if (bad_pmem && kaddr)
> +		do_recovery = dax_recovery_started(pmem->dax_dev, kaddr);
> +	if (bad_pmem && !do_recovery)
>  		return -EIO;

I find the passing of the recovery flag through the address very
cumbersome.  I remember there was some kind of discussion, but this looks
pretty ugly.

Also no need for the bad_pmem variable:

	if (is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512, PFN_PHYS(nr_pages)) &&
	    (!kaddr | !dax_recovery_started(pmem->dax_dev, kaddr)))
		return -EIO;

Also:  the !kaddr check could go into dax_recovery_started.  That way
even if we stick with the overloading kaddr could also be used just for
the flag if needed.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

