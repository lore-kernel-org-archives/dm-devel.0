Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26B58C6FD18
	for <dm-devel@archiver.kernel.org>; Thu, 20 Apr 2023 01:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681953777;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=jiErlLCybmKuU6iwpLwdrtEb8llxYI+OHCtnIh8PWus=;
	b=F1X6I/fnaFhDAKATUYY5pC1LrSMpHkWk6jvZGREWsMReYzuE5NENay8NLl/+TkNdesEZQX
	rfsA3nclwbyFp5InXFD0Cec+wHa2AtVvDcPT8/gfnabU8uSoeFYtohcIAlKqtKbwBdOkMu
	Exg8VFp2mcCzQzjLhrUDwHmIOa2duSU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-653-5dRcaEBpOUqZxHwn7FTtdw-1; Wed, 19 Apr 2023 21:22:54 -0400
X-MC-Unique: 5dRcaEBpOUqZxHwn7FTtdw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DDFD13C0ED66;
	Thu, 20 Apr 2023 01:22:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 45D4E492C3E;
	Thu, 20 Apr 2023 01:22:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0C04719465B9;
	Thu, 20 Apr 2023 01:22:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1A42519465B5
 for <dm-devel@listman.corp.redhat.com>; Thu, 20 Apr 2023 01:22:50 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9D60040C201F; Thu, 20 Apr 2023 01:22:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9505240C2064
 for <dm-devel@redhat.com>; Thu, 20 Apr 2023 01:22:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7900F800B35
 for <dm-devel@redhat.com>; Thu, 20 Apr 2023 01:22:50 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-99-uTX_K8OVP_u7ABImabFAxQ-1; Wed, 19 Apr 2023 21:22:46 -0400
X-MC-Unique: uTX_K8OVP_u7ABImabFAxQ-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 3C0AC63B6E;
 Thu, 20 Apr 2023 01:22:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95740C433EF;
 Thu, 20 Apr 2023 01:22:44 +0000 (UTC)
Date: Wed, 19 Apr 2023 18:22:43 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Sarthak Kukreti <sarthakkukreti@chromium.org>
Message-ID: <20230420012243.GO360895@frogsfrogsfrogs>
References: <20230414000219.92640-1-sarthakkukreti@chromium.org>
 <20230420004850.297045-1-sarthakkukreti@chromium.org>
 <20230420004850.297045-2-sarthakkukreti@chromium.org>
MIME-Version: 1.0
In-Reply-To: <20230420004850.297045-2-sarthakkukreti@chromium.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH v5 1/5] block: Don't invalidate pagecache for
 invalid falloc modes
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
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
 Theodore Ts'o <tytso@mit.edu>, "Michael S. Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowang@redhat.com>, Bart Van Assche <bvanassche@google.com>,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Andreas Dilger <adilger.kernel@dilger.ca>, Daniil Lunev <dlunev@google.com>,
 Stefan Hajnoczi <stefanha@redhat.com>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Apr 19, 2023 at 05:48:46PM -0700, Sarthak Kukreti wrote:
> Only call truncate_bdev_range() if the fallocate mode is
> supported. This fixes a bug where data in the pagecache
> could be invalidated if the fallocate() was called on the
> block device with an invalid mode.
> 
> Fixes: 25f4c41415e5 ("block: implement (some of) fallocate for block devices")
> Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
> ---
>  block/fops.c | 18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/block/fops.c b/block/fops.c
> index d2e6be4e3d1c..2fd7e8b9ab48 100644
> --- a/block/fops.c
> +++ b/block/fops.c
> @@ -648,25 +648,27 @@ static long blkdev_fallocate(struct file *file, int mode, loff_t start,
>  
>  	filemap_invalidate_lock(inode->i_mapping);
>  
> -	/* Invalidate the page cache, including dirty pages. */
> -	error = truncate_bdev_range(bdev, file->f_mode, start, end);
> -	if (error)
> -		goto fail;
> -
> +	/*
> +	 * Invalidate the page cache, including dirty pages, for valid
> +	 * de-allocate mode calls to fallocate().
> +	 */
>  	switch (mode) {
>  	case FALLOC_FL_ZERO_RANGE:
>  	case FALLOC_FL_ZERO_RANGE | FALLOC_FL_KEEP_SIZE:
> -		error = blkdev_issue_zeroout(bdev, start >> SECTOR_SHIFT,
> +		error = truncate_bdev_range(bdev, file->f_mode, start, end) ||
> +			blkdev_issue_zeroout(bdev, start >> SECTOR_SHIFT,

I'm pretty sure we're supposed to preserve the error codes returned by
both functions.

	error = truncate_bdev_range(...);
	if (!error)
		error = blkdev_issue_zeroout(...);

--D

>  					     len >> SECTOR_SHIFT, GFP_KERNEL,
>  					     BLKDEV_ZERO_NOUNMAP);
>  		break;
>  	case FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE:
> -		error = blkdev_issue_zeroout(bdev, start >> SECTOR_SHIFT,
> +		error = truncate_bdev_range(bdev, file->f_mode, start, end) ||
> +			blkdev_issue_zeroout(bdev, start >> SECTOR_SHIFT,
>  					     len >> SECTOR_SHIFT, GFP_KERNEL,
>  					     BLKDEV_ZERO_NOFALLBACK);
>  		break;
>  	case FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE | FALLOC_FL_NO_HIDE_STALE:
> -		error = blkdev_issue_discard(bdev, start >> SECTOR_SHIFT,
> +		error = truncate_bdev_range(bdev, file->f_mode, start, end) ||
> +			blkdev_issue_discard(bdev, start >> SECTOR_SHIFT,
>  					     len >> SECTOR_SHIFT, GFP_KERNEL);
>  		break;
>  	default:
> -- 
> 2.40.0.634.g4ca3ef3211-goog
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

