Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB4E6C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 23 Nov 2021 22:40:20 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-571-XRvR2prDP1KYcxJOWeTpMw-1; Tue, 23 Nov 2021 17:40:16 -0500
X-MC-Unique: XRvR2prDP1KYcxJOWeTpMw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C084110151E2;
	Tue, 23 Nov 2021 22:40:11 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7B72460C22;
	Tue, 23 Nov 2021 22:40:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1C1624E9F5;
	Tue, 23 Nov 2021 22:40:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ANMe9d6024906 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 23 Nov 2021 17:40:09 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id F168A4047279; Tue, 23 Nov 2021 22:40:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ED5954047272
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 22:40:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D3D2A811E78
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 22:40:08 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-211-wV87xw2VMNm3c4nvbsKMSw-1; Tue, 23 Nov 2021 17:40:05 -0500
X-MC-Unique: wV87xw2VMNm3c4nvbsKMSw-1
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBEF660C49;
	Tue, 23 Nov 2021 22:40:03 +0000 (UTC)
Date: Tue, 23 Nov 2021 14:40:03 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20211123224003.GK266024@magnolia>
References: <20211109083309.584081-1-hch@lst.de>
	<20211109083309.584081-17-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20211109083309.584081-17-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
Cc: nvdimm@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	linux-s390@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	virtualization@lists.linux-foundation.org,
	linux-xfs@vger.kernel.org, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
	linux-ext4@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>
Subject: Re: [dm-devel] [PATCH 16/29] fsdax: simplify the offset check in
	dax_iomap_zero
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

On Tue, Nov 09, 2021 at 09:32:56AM +0100, Christoph Hellwig wrote:
> The file relative offset must have the same alignment as the storage
> offset, so use that and get rid of the call to iomap_sector.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/dax.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 5364549d67a48..d7a923d152240 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -1123,7 +1123,6 @@ static vm_fault_t dax_pmd_load_hole(struct xa_state *xas, struct vm_fault *vmf,
>  
>  s64 dax_iomap_zero(loff_t pos, u64 length, struct iomap *iomap)
>  {
> -	sector_t sector = iomap_sector(iomap, pos & PAGE_MASK);
>  	pgoff_t pgoff = dax_iomap_pgoff(iomap, pos);
>  	long rc, id;
>  	void *kaddr;
> @@ -1131,8 +1130,7 @@ s64 dax_iomap_zero(loff_t pos, u64 length, struct iomap *iomap)
>  	unsigned offset = offset_in_page(pos);
>  	unsigned size = min_t(u64, PAGE_SIZE - offset, length);
>  
> -	if (IS_ALIGNED(sector << SECTOR_SHIFT, PAGE_SIZE) &&
> -	    (size == PAGE_SIZE))
> +	if (IS_ALIGNED(pos, PAGE_SIZE) && size == PAGE_SIZE)
>  		page_aligned = true;
>  
>  	id = dax_read_lock();
> -- 
> 2.30.2
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

