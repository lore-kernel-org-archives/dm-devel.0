Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADEE0C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 23 Nov 2021 23:07:33 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-440-7T2_2ST4Ot-e7LtRO1AvVQ-1; Tue, 23 Nov 2021 18:07:29 -0500
X-MC-Unique: 7T2_2ST4Ot-e7LtRO1AvVQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0CFC987D542;
	Tue, 23 Nov 2021 23:07:25 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E79695D6CF;
	Tue, 23 Nov 2021 23:07:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BE46D1832E7F;
	Tue, 23 Nov 2021 23:07:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ANN0XY4026334 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 23 Nov 2021 18:00:33 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 09B642026980; Tue, 23 Nov 2021 23:00:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EF7B02026D6A
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 23:00:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 32E4380A0AB
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 23:00:27 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-137-dfG3CHN-Nmya_zGwqEk_5A-1; Tue, 23 Nov 2021 18:00:25 -0500
X-MC-Unique: dfG3CHN-Nmya_zGwqEk_5A-1
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD5E660FBF;
	Tue, 23 Nov 2021 23:00:23 +0000 (UTC)
Date: Tue, 23 Nov 2021 15:00:23 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20211123230023.GQ266024@magnolia>
References: <20211109083309.584081-1-hch@lst.de>
	<20211109083309.584081-23-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20211109083309.584081-23-hch@lst.de>
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
Cc: nvdimm@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	linux-s390@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	virtualization@lists.linux-foundation.org,
	linux-xfs@vger.kernel.org, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
	linux-ext4@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>
Subject: Re: [dm-devel] [PATCH 22/29] iomap: add a IOMAP_DAX flag
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
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Nov 09, 2021 at 09:33:02AM +0100, Christoph Hellwig wrote:
> Add a flag so that the file system can easily detect DAX operations.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/dax.c              | 7 ++++---
>  include/linux/iomap.h | 1 +
>  2 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 5b52b878124ac..0bd6cdcbacfc4 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -1180,7 +1180,7 @@ int dax_zero_range(struct inode *inode, loff_t pos, loff_t len, bool *did_zero,
>  		.inode		= inode,
>  		.pos		= pos,
>  		.len		= len,
> -		.flags		= IOMAP_ZERO,
> +		.flags		= IOMAP_DAX | IOMAP_ZERO,
>  	};
>  	int ret;
>  
> @@ -1308,6 +1308,7 @@ dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
>  		.inode		= iocb->ki_filp->f_mapping->host,
>  		.pos		= iocb->ki_pos,
>  		.len		= iov_iter_count(iter),
> +		.flags		= IOMAP_DAX,
>  	};
>  	loff_t done = 0;
>  	int ret;
> @@ -1461,7 +1462,7 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
>  		.inode		= mapping->host,
>  		.pos		= (loff_t)vmf->pgoff << PAGE_SHIFT,
>  		.len		= PAGE_SIZE,
> -		.flags		= IOMAP_FAULT,
> +		.flags		= IOMAP_DAX | IOMAP_FAULT,
>  	};
>  	vm_fault_t ret = 0;
>  	void *entry;
> @@ -1570,7 +1571,7 @@ static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
>  	struct iomap_iter iter = {
>  		.inode		= mapping->host,
>  		.len		= PMD_SIZE,
> -		.flags		= IOMAP_FAULT,
> +		.flags		= IOMAP_DAX | IOMAP_FAULT,
>  	};
>  	vm_fault_t ret = VM_FAULT_FALLBACK;
>  	pgoff_t max_pgoff;
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index 6d1b08d0ae930..146a7e3e3ea11 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -141,6 +141,7 @@ struct iomap_page_ops {
>  #define IOMAP_NOWAIT		(1 << 5) /* do not block */
>  #define IOMAP_OVERWRITE_ONLY	(1 << 6) /* only pure overwrites allowed */
>  #define IOMAP_UNSHARE		(1 << 7) /* unshare_file_range */
> +#define IOMAP_DAX		(1 << 8) /* DAX mapping */

Should this be #define'd to 0 ifndef CONFIG_FS_DAX so that the compiler
will optimize out all the IOMAP_DAX bits if dax isn't enabled in
Kconfig?  Kind of like what we do for S_DAX?

--D

>  
>  struct iomap_ops {
>  	/*
> -- 
> 2.30.2
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

