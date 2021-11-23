Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D99FC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 23 Nov 2021 22:35:49 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-390-o6HbCmG8MlK5vsi9rMd44A-1; Tue, 23 Nov 2021 17:35:44 -0500
X-MC-Unique: o6HbCmG8MlK5vsi9rMd44A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A37E59F92B;
	Tue, 23 Nov 2021 22:35:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 89E1260CC3;
	Tue, 23 Nov 2021 22:35:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 662581832E84;
	Tue, 23 Nov 2021 22:35:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ANMY26b023258 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 23 Nov 2021 17:34:02 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A97EC112131B; Tue, 23 Nov 2021 22:34:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A4CBC1121318
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 22:33:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A8F29801212
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 22:33:57 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-59-Kn1llgAhNVaVaYeKgyH-KA-1; Tue, 23 Nov 2021 17:33:53 -0500
X-MC-Unique: Kn1llgAhNVaVaYeKgyH-KA-1
Received: by mail.kernel.org (Postfix) with ESMTPSA id 932C6604AC;
	Tue, 23 Nov 2021 22:33:52 +0000 (UTC)
Date: Tue, 23 Nov 2021 14:33:52 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20211123223352.GH266024@magnolia>
References: <20211109083309.584081-1-hch@lst.de>
	<20211109083309.584081-14-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20211109083309.584081-14-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: nvdimm@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	linux-s390@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	virtualization@lists.linux-foundation.org,
	linux-xfs@vger.kernel.org, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
	linux-ext4@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>
Subject: Re: [dm-devel] [PATCH 13/29] fsdax: use a saner calling convention
 for copy_cow_page_dax
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

On Tue, Nov 09, 2021 at 09:32:53AM +0100, Christoph Hellwig wrote:
> Just pass the vm_fault and iomap_iter structures, and figure out the rest
> locally.  Note that this requires moving dax_iomap_sector up in the file.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yes, nice cleanup!
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/dax.c | 29 +++++++++++++----------------
>  1 file changed, 13 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 73bd1439d8089..e51b4129d1b65 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -709,26 +709,31 @@ int dax_invalidate_mapping_entry_sync(struct address_space *mapping,
>  	return __dax_invalidate_entry(mapping, index, false);
>  }
>  
> -static int copy_cow_page_dax(struct block_device *bdev, struct dax_device *dax_dev,
> -			     sector_t sector, struct page *to, unsigned long vaddr)
> +static sector_t dax_iomap_sector(const struct iomap *iomap, loff_t pos)
>  {
> +	return (iomap->addr + (pos & PAGE_MASK) - iomap->offset) >> 9;
> +}
> +
> +static int copy_cow_page_dax(struct vm_fault *vmf, const struct iomap_iter *iter)
> +{
> +	sector_t sector = dax_iomap_sector(&iter->iomap, iter->pos);
>  	void *vto, *kaddr;
>  	pgoff_t pgoff;
>  	long rc;
>  	int id;
>  
> -	rc = bdev_dax_pgoff(bdev, sector, PAGE_SIZE, &pgoff);
> +	rc = bdev_dax_pgoff(iter->iomap.bdev, sector, PAGE_SIZE, &pgoff);
>  	if (rc)
>  		return rc;
>  
>  	id = dax_read_lock();
> -	rc = dax_direct_access(dax_dev, pgoff, 1, &kaddr, NULL);
> +	rc = dax_direct_access(iter->iomap.dax_dev, pgoff, 1, &kaddr, NULL);
>  	if (rc < 0) {
>  		dax_read_unlock(id);
>  		return rc;
>  	}
> -	vto = kmap_atomic(to);
> -	copy_user_page(vto, kaddr, vaddr, to);
> +	vto = kmap_atomic(vmf->cow_page);
> +	copy_user_page(vto, kaddr, vmf->address, vmf->cow_page);
>  	kunmap_atomic(vto);
>  	dax_read_unlock(id);
>  	return 0;
> @@ -1005,11 +1010,6 @@ int dax_writeback_mapping_range(struct address_space *mapping,
>  }
>  EXPORT_SYMBOL_GPL(dax_writeback_mapping_range);
>  
> -static sector_t dax_iomap_sector(const struct iomap *iomap, loff_t pos)
> -{
> -	return (iomap->addr + (pos & PAGE_MASK) - iomap->offset) >> 9;
> -}
> -
>  static int dax_iomap_pfn(const struct iomap *iomap, loff_t pos, size_t size,
>  			 pfn_t *pfnp)
>  {
> @@ -1332,19 +1332,16 @@ static vm_fault_t dax_fault_synchronous_pfnp(pfn_t *pfnp, pfn_t pfn)
>  static vm_fault_t dax_fault_cow_page(struct vm_fault *vmf,
>  		const struct iomap_iter *iter)
>  {
> -	sector_t sector = dax_iomap_sector(&iter->iomap, iter->pos);
> -	unsigned long vaddr = vmf->address;
>  	vm_fault_t ret;
>  	int error = 0;
>  
>  	switch (iter->iomap.type) {
>  	case IOMAP_HOLE:
>  	case IOMAP_UNWRITTEN:
> -		clear_user_highpage(vmf->cow_page, vaddr);
> +		clear_user_highpage(vmf->cow_page, vmf->address);
>  		break;
>  	case IOMAP_MAPPED:
> -		error = copy_cow_page_dax(iter->iomap.bdev, iter->iomap.dax_dev,
> -					  sector, vmf->cow_page, vaddr);
> +		error = copy_cow_page_dax(vmf, iter);
>  		break;
>  	default:
>  		WARN_ON_ONCE(1);
> -- 
> 2.30.2
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

