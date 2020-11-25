Return-Path: <SRS0=8HMs=E7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7208C5519F
	for <dm-devel@archiver.kernel.org>; Wed, 25 Nov 2020 13:39:47 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EE19620637
	for <dm-devel@archiver.kernel.org>; Wed, 25 Nov 2020 13:39:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EE19620637
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-463-B57X3VtXP2qhRqmVPc6FtA-1; Wed, 25 Nov 2020 08:39:43 -0500
X-MC-Unique: B57X3VtXP2qhRqmVPc6FtA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4BF28100746C;
	Wed, 25 Nov 2020 13:39:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0BD6E5D9CA;
	Wed, 25 Nov 2020 13:39:37 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 46F194BB7B;
	Wed, 25 Nov 2020 13:39:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0APCGuKN027979 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 25 Nov 2020 07:16:56 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 76BFF1134CC7; Wed, 25 Nov 2020 12:16:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 71ED01134CC3
	for <dm-devel@redhat.com>; Wed, 25 Nov 2020 12:16:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 70CB0811E85
	for <dm-devel@redhat.com>; Wed, 25 Nov 2020 12:16:48 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-504-TUruClllMsKv0dW5nu-dHA-1;
	Wed, 25 Nov 2020 07:16:45 -0500
X-MC-Unique: TUruClllMsKv0dW5nu-dHA-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 8E6B3AF0B;
	Wed, 25 Nov 2020 12:16:44 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
	id 2138A1E130F; Wed, 25 Nov 2020 13:16:44 +0100 (CET)
Date: Wed, 25 Nov 2020 13:16:44 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20201125121644.GF16944@quack2.suse.cz>
References: <20201124132751.3747337-1-hch@lst.de>
	<20201124132751.3747337-3-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201124132751.3747337-3-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
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
Cc: Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jan Kara <jack@suse.com>, Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
	Richard Weinberger <richard@nod.at>, dm-devel@redhat.com,
	linux-mtd@lists.infradead.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Tejun Heo <tj@kernel.org>, xen-devel@lists.xenproject.org,
	linux-bcache@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [dm-devel] [PATCH 02/45] filemap: consistently use ->f_mapping
 over ->i_mapping
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue 24-11-20 14:27:08, Christoph Hellwig wrote:
> Use file->f_mapping in all remaining places that have a struct file
> available to properly handle the case where inode->i_mapping !=
> file_inode(file)->i_mapping.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  mm/filemap.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index d5e7c2029d16b4..4f583489aa3c2a 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2886,14 +2886,14 @@ EXPORT_SYMBOL(filemap_map_pages);
>  
>  vm_fault_t filemap_page_mkwrite(struct vm_fault *vmf)
>  {
> +	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
>  	struct page *page = vmf->page;
> -	struct inode *inode = file_inode(vmf->vma->vm_file);
>  	vm_fault_t ret = VM_FAULT_LOCKED;
>  
> -	sb_start_pagefault(inode->i_sb);
> +	sb_start_pagefault(mapping->host->i_sb);
>  	file_update_time(vmf->vma->vm_file);
>  	lock_page(page);
> -	if (page->mapping != inode->i_mapping) {
> +	if (page->mapping != mapping) {
>  		unlock_page(page);
>  		ret = VM_FAULT_NOPAGE;
>  		goto out;
> @@ -2906,7 +2906,7 @@ vm_fault_t filemap_page_mkwrite(struct vm_fault *vmf)
>  	set_page_dirty(page);
>  	wait_for_stable_page(page);
>  out:
> -	sb_end_pagefault(inode->i_sb);
> +	sb_end_pagefault(mapping->host->i_sb);
>  	return ret;
>  }
>  
> @@ -3149,10 +3149,9 @@ void dio_warn_stale_pagecache(struct file *filp)
>  {
>  	static DEFINE_RATELIMIT_STATE(_rs, 86400 * HZ, DEFAULT_RATELIMIT_BURST);
>  	char pathname[128];
> -	struct inode *inode = file_inode(filp);
>  	char *path;
>  
> -	errseq_set(&inode->i_mapping->wb_err, -EIO);
> +	errseq_set(&filp->f_mapping->wb_err, -EIO);
>  	if (__ratelimit(&_rs)) {
>  		path = file_path(filp, pathname, sizeof(pathname));
>  		if (IS_ERR(path))
> @@ -3179,7 +3178,7 @@ generic_file_direct_write(struct kiocb *iocb, struct iov_iter *from)
>  
>  	if (iocb->ki_flags & IOCB_NOWAIT) {
>  		/* If there are pages to writeback, return */
> -		if (filemap_range_has_page(inode->i_mapping, pos,
> +		if (filemap_range_has_page(file->f_mapping, pos,
>  					   pos + write_len - 1))
>  			return -EAGAIN;
>  	} else {
> -- 
> 2.29.2
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

