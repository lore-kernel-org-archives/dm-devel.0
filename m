Return-Path: <SRS0=tECb=HA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7001BC433E0
	for <dm-devel@archiver.kernel.org>; Fri, 29 Jan 2021 09:38:23 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CBD5264DE2
	for <dm-devel@archiver.kernel.org>; Fri, 29 Jan 2021 09:38:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CBD5264DE2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-495-pJ6zu6a7NDKtvkb9H8EpgQ-1; Fri, 29 Jan 2021 04:38:19 -0500
X-MC-Unique: pJ6zu6a7NDKtvkb9H8EpgQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BAF9E1800D41;
	Fri, 29 Jan 2021 09:38:14 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9D3CF5D740;
	Fri, 29 Jan 2021 09:38:14 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 707A34EEF6;
	Fri, 29 Jan 2021 09:38:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10SGINL6005876 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 28 Jan 2021 11:18:23 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2C4842166B2B; Thu, 28 Jan 2021 16:18:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 273BC2166B2A
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 16:18:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 78280800B3A
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 16:18:20 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-453-5mSykEfOOFqeV5NfM4GlZQ-1;
	Thu, 28 Jan 2021 11:18:15 -0500
X-MC-Unique: 5mSykEfOOFqeV5NfM4GlZQ-1
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15C7D64DE5;
	Thu, 28 Jan 2021 16:11:30 +0000 (UTC)
Date: Thu, 28 Jan 2021 08:11:28 -0800
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <YBLiMN7zm44VWaBI@google.com>
References: <20210126145247.1964410-1-hch@lst.de>
	<20210126145247.1964410-9-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20210126145247.1964410-9-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 29 Jan 2021 04:33:26 -0500
Cc: Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>,
	dm-devel@redhat.com, Naohiro Aota <naohiro.aota@wdc.com>,
	linux-nilfs@vger.kernel.org, Chao Yu <chao@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
	linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org,
	David Sterba <dsterba@suse.com>, drbd-dev@tron.linbit.com,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	Damien Le Moal <damien.lemoal@wdc.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Philipp Reisner <philipp.reisner@linbit.com>,
	linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	linux-nfs@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 08/17] f2fs: remove FAULT_ALLOC_BIO
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

On 01/26, Christoph Hellwig wrote:
> Sleeping bio allocations do not fail, which means that injecting an error
> into sleeping bio allocations is a little silly.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Already merged tho.

Acked-by: Jaegeuk Kim <jaegeuk@kernel.org>

> ---
>  Documentation/filesystems/f2fs.rst |  1 -
>  fs/f2fs/data.c                     | 29 ++++-------------------------
>  fs/f2fs/f2fs.h                     |  1 -
>  fs/f2fs/super.c                    |  1 -
>  4 files changed, 4 insertions(+), 28 deletions(-)
> 
> diff --git a/Documentation/filesystems/f2fs.rst b/Documentation/filesystems/f2fs.rst
> index dae15c96e659e2..624f5f3ed93e86 100644
> --- a/Documentation/filesystems/f2fs.rst
> +++ b/Documentation/filesystems/f2fs.rst
> @@ -179,7 +179,6 @@ fault_type=%d		 Support configuring fault injection type, should be
>  			 FAULT_KVMALLOC		  0x000000002
>  			 FAULT_PAGE_ALLOC	  0x000000004
>  			 FAULT_PAGE_GET		  0x000000008
> -			 FAULT_ALLOC_BIO	  0x000000010
>  			 FAULT_ALLOC_NID	  0x000000020
>  			 FAULT_ORPHAN		  0x000000040
>  			 FAULT_BLOCK		  0x000000080
> diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> index 0cf0c605992431..9fb6be65592b1f 100644
> --- a/fs/f2fs/data.c
> +++ b/fs/f2fs/data.c
> @@ -50,28 +50,6 @@ void f2fs_destroy_bioset(void)
>  	bioset_exit(&f2fs_bioset);
>  }
>  
> -static inline struct bio *__f2fs_bio_alloc(gfp_t gfp_mask,
> -						unsigned int nr_iovecs)
> -{
> -	return bio_alloc_bioset(gfp_mask, nr_iovecs, &f2fs_bioset);
> -}
> -
> -static struct bio *f2fs_bio_alloc(struct f2fs_sb_info *sbi, int npages,
> -		bool noio)
> -{
> -	if (noio) {
> -		/* No failure on bio allocation */
> -		return __f2fs_bio_alloc(GFP_NOIO, npages);
> -	}
> -
> -	if (time_to_inject(sbi, FAULT_ALLOC_BIO)) {
> -		f2fs_show_injection_info(sbi, FAULT_ALLOC_BIO);
> -		return NULL;
> -	}
> -
> -	return __f2fs_bio_alloc(GFP_KERNEL, npages);
> -}
> -
>  static bool __is_cp_guaranteed(struct page *page)
>  {
>  	struct address_space *mapping = page->mapping;
> @@ -433,7 +411,7 @@ static struct bio *__bio_alloc(struct f2fs_io_info *fio, int npages)
>  	struct f2fs_sb_info *sbi = fio->sbi;
>  	struct bio *bio;
>  
> -	bio = f2fs_bio_alloc(sbi, npages, true);
> +	bio = bio_alloc_bioset(GFP_NOIO, npages, &f2fs_bioset);
>  
>  	f2fs_target_device(sbi, fio->new_blkaddr, bio);
>  	if (is_read_io(fio->op)) {
> @@ -1029,8 +1007,9 @@ static struct bio *f2fs_grab_read_bio(struct inode *inode, block_t blkaddr,
>  	struct bio_post_read_ctx *ctx;
>  	unsigned int post_read_steps = 0;
>  
> -	bio = f2fs_bio_alloc(sbi, min_t(int, nr_pages, BIO_MAX_PAGES),
> -								for_write);
> +	bio = bio_alloc_bioset(for_write ? GFP_NOIO : GFP_KERNEL,
> +			       min_t(int, nr_pages, BIO_MAX_PAGES),
> +			       &f2fs_bioset);
>  	if (!bio)
>  		return ERR_PTR(-ENOMEM);
>  
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index 902bd3267c03e1..6c78365d80ceb5 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -43,7 +43,6 @@ enum {
>  	FAULT_KVMALLOC,
>  	FAULT_PAGE_ALLOC,
>  	FAULT_PAGE_GET,
> -	FAULT_ALLOC_BIO,
>  	FAULT_ALLOC_NID,
>  	FAULT_ORPHAN,
>  	FAULT_BLOCK,
> diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
> index b4a07fe62d1a58..3a312642907e86 100644
> --- a/fs/f2fs/super.c
> +++ b/fs/f2fs/super.c
> @@ -45,7 +45,6 @@ const char *f2fs_fault_name[FAULT_MAX] = {
>  	[FAULT_KVMALLOC]	= "kvmalloc",
>  	[FAULT_PAGE_ALLOC]	= "page alloc",
>  	[FAULT_PAGE_GET]	= "page get",
> -	[FAULT_ALLOC_BIO]	= "alloc bio",
>  	[FAULT_ALLOC_NID]	= "alloc nid",
>  	[FAULT_ORPHAN]		= "orphan",
>  	[FAULT_BLOCK]		= "no more block",
> -- 
> 2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

