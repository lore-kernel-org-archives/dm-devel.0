Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A07AEC433F5
	for <dm-devel@archiver.kernel.org>; Tue, 30 Nov 2021 18:50:54 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-341-knK9Rdx0OJOJZFL7i2c9Wg-1; Tue, 30 Nov 2021 13:50:50 -0500
X-MC-Unique: knK9Rdx0OJOJZFL7i2c9Wg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0D51F10A789F;
	Tue, 30 Nov 2021 18:50:17 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9FC0878C24;
	Tue, 30 Nov 2021 18:50:14 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B0D464BB7C;
	Tue, 30 Nov 2021 18:50:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AUIo8Fp016653 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 30 Nov 2021 13:50:08 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1F504C15E73; Tue, 30 Nov 2021 18:50:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1AC1CC15E6F
	for <dm-devel@redhat.com>; Tue, 30 Nov 2021 18:50:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0010585A5AA
	for <dm-devel@redhat.com>; Tue, 30 Nov 2021 18:50:07 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-599-quvvFc5tMsOoKcRSzyfrsQ-1; Tue, 30 Nov 2021 13:50:06 -0500
X-MC-Unique: quvvFc5tMsOoKcRSzyfrsQ-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.source.kernel.org (Postfix) with ESMTPS id C55D8B81B84;
	Tue, 30 Nov 2021 18:50:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 703C5C53FCC;
	Tue, 30 Nov 2021 18:50:03 +0000 (UTC)
Date: Tue, 30 Nov 2021 10:50:02 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20211130185002.GD8467@magnolia>
References: <20211129102203.2243509-1-hch@lst.de>
	<20211129102203.2243509-6-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20211129102203.2243509-6-hch@lst.de>
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
Cc: nvdimm@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	linux-s390@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	virtualization@lists.linux-foundation.org,
	linux-xfs@vger.kernel.org, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
	linux-ext4@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>
Subject: Re: [dm-devel] [PATCH 05/29] dax: remove the pgmap sanity checks in
 generic_fsdax_supported
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
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Nov 29, 2021 at 11:21:39AM +0100, Christoph Hellwig wrote:
> Drivers that register a dax_dev should make sure it works, no need
> to double check from the file system.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  drivers/dax/super.c | 49 +--------------------------------------------
>  1 file changed, 1 insertion(+), 48 deletions(-)
> 
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index bf77c3da5d56d..c8500b7e2d8a2 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -106,13 +106,9 @@ bool generic_fsdax_supported(struct dax_device *dax_dev,
>  		struct block_device *bdev, int blocksize, sector_t start,
>  		sector_t sectors)
>  {
> -	bool dax_enabled = false;
>  	pgoff_t pgoff, pgoff_end;
> -	void *kaddr, *end_kaddr;
> -	pfn_t pfn, end_pfn;
>  	sector_t last_page;
> -	long len, len2;
> -	int err, id;
> +	int err;
>  
>  	if (blocksize != PAGE_SIZE) {
>  		pr_info("%pg: error: unsupported blocksize for dax\n", bdev);
> @@ -137,49 +133,6 @@ bool generic_fsdax_supported(struct dax_device *dax_dev,
>  		return false;
>  	}
>  
> -	id = dax_read_lock();
> -	len = dax_direct_access(dax_dev, pgoff, 1, &kaddr, &pfn);
> -	len2 = dax_direct_access(dax_dev, pgoff_end, 1, &end_kaddr, &end_pfn);
> -
> -	if (len < 1 || len2 < 1) {
> -		pr_info("%pg: error: dax access failed (%ld)\n",
> -				bdev, len < 1 ? len : len2);
> -		dax_read_unlock(id);
> -		return false;
> -	}
> -
> -	if (IS_ENABLED(CONFIG_FS_DAX_LIMITED) && pfn_t_special(pfn)) {
> -		/*
> -		 * An arch that has enabled the pmem api should also
> -		 * have its drivers support pfn_t_devmap()
> -		 *
> -		 * This is a developer warning and should not trigger in
> -		 * production. dax_flush() will crash since it depends
> -		 * on being able to do (page_address(pfn_to_page())).
> -		 */
> -		WARN_ON(IS_ENABLED(CONFIG_ARCH_HAS_PMEM_API));
> -		dax_enabled = true;
> -	} else if (pfn_t_devmap(pfn) && pfn_t_devmap(end_pfn)) {
> -		struct dev_pagemap *pgmap, *end_pgmap;
> -
> -		pgmap = get_dev_pagemap(pfn_t_to_pfn(pfn), NULL);
> -		end_pgmap = get_dev_pagemap(pfn_t_to_pfn(end_pfn), NULL);
> -		if (pgmap && pgmap == end_pgmap && pgmap->type == MEMORY_DEVICE_FS_DAX
> -				&& pfn_t_to_page(pfn)->pgmap == pgmap
> -				&& pfn_t_to_page(end_pfn)->pgmap == pgmap
> -				&& pfn_t_to_pfn(pfn) == PHYS_PFN(__pa(kaddr))
> -				&& pfn_t_to_pfn(end_pfn) == PHYS_PFN(__pa(end_kaddr)))
> -			dax_enabled = true;
> -		put_dev_pagemap(pgmap);
> -		put_dev_pagemap(end_pgmap);
> -
> -	}
> -	dax_read_unlock(id);
> -
> -	if (!dax_enabled) {
> -		pr_info("%pg: error: dax support not enabled\n", bdev);
> -		return false;
> -	}
>  	return true;
>  }
>  EXPORT_SYMBOL_GPL(generic_fsdax_supported);
> -- 
> 2.30.2
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

