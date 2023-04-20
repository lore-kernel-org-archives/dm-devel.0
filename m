Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9429DC77B73
	for <dm-devel@archiver.kernel.org>; Thu, 20 Apr 2023 16:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1682007647;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=OJp6E03/W8YwOb2ayBPM/6J0v/gBWDSIH6dHxKoCQbk=;
	b=csgo8ShqBAQdgplak9QHTMF+Yt8CmnUhlxHOYAnUAdCmRTpZ37ZYDm2M9OoP/ox99OJG7B
	Rhe9SYmu535w6M8tXu7End3e2Y5L6GRW2nBZJSH702avvP3kvnjRPh0K1u2VTnES6lpXzV
	0fngHV95nTTjidLn/BWnziZv/jNRfoQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-358-dRcoXyp3MDuw0afrlOQ9KQ-1; Thu, 20 Apr 2023 12:20:43 -0400
X-MC-Unique: dRcoXyp3MDuw0afrlOQ9KQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2DC0F1C04335;
	Thu, 20 Apr 2023 16:20:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8FA4A1121315;
	Thu, 20 Apr 2023 16:20:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 421031946A40;
	Thu, 20 Apr 2023 16:20:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C903819466DF
 for <dm-devel@listman.corp.redhat.com>; Thu, 20 Apr 2023 16:20:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BBD70C16026; Thu, 20 Apr 2023 16:20:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B3DE1C16024
 for <dm-devel@redhat.com>; Thu, 20 Apr 2023 16:20:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 96C0F101A553
 for <dm-devel@redhat.com>; Thu, 20 Apr 2023 16:20:33 +0000 (UTC)
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com
 [209.85.222.174]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-502-o2J08QmkOuOieyWHbTf90w-1; Thu, 20 Apr 2023 12:20:30 -0400
X-MC-Unique: o2J08QmkOuOieyWHbTf90w-1
Received: by mail-qk1-f174.google.com with SMTP id
 af79cd13be357-74e2a00d146so61314985a.2
 for <dm-devel@redhat.com>; Thu, 20 Apr 2023 09:20:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1682007629; x=1684599629;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=mi8BRALKHs7eage0Q9/aKDKQbgLFo1rksVSh6HXojUM=;
 b=YddoO/NB/+Tk9ZCQ9+1ze2FQRd1QKwksIZoWguVXJF7i/b2tL3k5ioIoCOk1rq7Xej
 y/ZSIzJmjwKGqzTXO1h9k7GPDSTaiOouB5n2oRhBgppVD3VW4L12IyhvlZBDzDDqxjFR
 Zggg8krZ7tIdTpYqJt456NLRt0Sp0GmIRYJyGcevzeIeTCl5JfnX5apaksJPiWRrgBOM
 JAu6RDKxFWl5V2IJFj9RkPi+TskMUTr55Ffhm3Y0Amt0hBsdE+vSHAsM2b7cdhsguMbn
 RNLR6Trva4Cfb3O8fp6iAw+ToTGyf0NoFnsq4VhBo8n7z2VLAnMb7VnT/t0oxPTR1GnF
 Y9FA==
X-Gm-Message-State: AAQBX9eVIpH9CfNjGXSKrV9IRW54gYVl1PcsAhDNKVqB6uoy0Gz4mN32
 mrtSv4/p+re3K+xf8e6ILQBoQ5xsvJqjcgwWl/d1
X-Google-Smtp-Source: AKy350ZdxFbx3P6KW7oGgzZkOdBts5SMHV3jmQ7iV4w8PdU+G+NU8GyRCb0ZtSnye0JdmMgLiXUHqw==
X-Received: by 2002:a05:6214:1c4e:b0:5f0:23be:a301 with SMTP id
 if14-20020a0562141c4e00b005f023bea301mr2999579qvb.5.1682007629560; 
 Thu, 20 Apr 2023 09:20:29 -0700 (PDT)
Received: from localhost ([37.19.196.135]) by smtp.gmail.com with ESMTPSA id
 b17-20020a05620a271100b0074e034915d4sm539562qkp.73.2023.04.20.09.20.28
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 20 Apr 2023 09:20:28 -0700 (PDT)
Date: Thu, 20 Apr 2023 12:20:27 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Sarthak Kukreti <sarthakkukreti@chromium.org>
Message-ID: <ZEFmS9h81Wwlv9+/@redhat.com>
References: <20230420004850.297045-2-sarthakkukreti@chromium.org>
 <20230420014734.302304-1-sarthakkukreti@chromium.org>
MIME-Version: 1.0
In-Reply-To: <20230420014734.302304-1-sarthakkukreti@chromium.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v5-fix 1/5] block: Don't invalidate pagecache
 for invalid falloc modes
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
 "Darrick J. Wong" <djwong@kernel.org>, Jason Wang <jasowang@redhat.com>,
 Bart Van Assche <bvanassche@google.com>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Andreas Dilger <adilger.kernel@dilger.ca>, Daniil Lunev <dlunev@google.com>,
 Stefan Hajnoczi <stefanha@redhat.com>, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Apr 19 2023 at  9:47P -0400,
Sarthak Kukreti <sarthakkukreti@chromium.org> wrote:

> Only call truncate_bdev_range() if the fallocate mode is
> supported. This fixes a bug where data in the pagecache
> could be invalidated if the fallocate() was called on the
> block device with an invalid mode.
> 
> Fixes: 25f4c41415e5 ("block: implement (some of) fallocate for block devices")

You should add:

Cc: stable@vger.kernel.org
Reported-by: Darrick J. Wong <djwong@kernel.org>

> Signed-off-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
> ---
>  block/fops.c | 37 ++++++++++++++++++++++++-------------
>  1 file changed, 24 insertions(+), 13 deletions(-)
> 
> diff --git a/block/fops.c b/block/fops.c
> index d2e6be4e3d1c..d359254c645d 100644
> --- a/block/fops.c
> +++ b/block/fops.c
> @@ -648,26 +648,37 @@ static long blkdev_fallocate(struct file *file, int mode, loff_t start,
>  
>  	filemap_invalidate_lock(inode->i_mapping);
>  
> -	/* Invalidate the page cache, including dirty pages. */
> -	error = truncate_bdev_range(bdev, file->f_mode, start, end);
> -	if (error)
> -		goto fail;
> -

You remove the only user of the 'fail' label.  But I think it'd be
cleaner to keep using it below (reduces indentation churn too).

> +	/*
> +	 * Invalidate the page cache, including dirty pages, for valid
> +	 * de-allocate mode calls to fallocate().
> +	 */
>  	switch (mode) {
>  	case FALLOC_FL_ZERO_RANGE:
>  	case FALLOC_FL_ZERO_RANGE | FALLOC_FL_KEEP_SIZE:
> -		error = blkdev_issue_zeroout(bdev, start >> SECTOR_SHIFT,
> -					     len >> SECTOR_SHIFT, GFP_KERNEL,
> -					     BLKDEV_ZERO_NOUNMAP);
> +		error = truncate_bdev_range(bdev, file->f_mode, start, end);
> +		if (!error)
> +			error = blkdev_issue_zeroout(bdev,
> +						     start >> SECTOR_SHIFT,
> +						     len >> SECTOR_SHIFT,
> +						     GFP_KERNEL,
> +						     BLKDEV_ZERO_NOUNMAP);
>  		break;


So:

		error = truncate_bdev_range(bdev, file->f_mode, start, end);
		if (error)
		        goto fail;
		...


>  	case FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE:
> -		error = blkdev_issue_zeroout(bdev, start >> SECTOR_SHIFT,
> -					     len >> SECTOR_SHIFT, GFP_KERNEL,
> -					     BLKDEV_ZERO_NOFALLBACK);
> +		error = truncate_bdev_range(bdev, file->f_mode, start, end);
> +		if (!error)
> +			error = blkdev_issue_zeroout(bdev,
> +						     start >> SECTOR_SHIFT,
> +						     len >> SECTOR_SHIFT,
> +						     GFP_KERNEL,
> +						     BLKDEV_ZERO_NOFALLBACK);
>  		break;

Same.

>  	case FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE | FALLOC_FL_NO_HIDE_STALE:
> -		error = blkdev_issue_discard(bdev, start >> SECTOR_SHIFT,
> -					     len >> SECTOR_SHIFT, GFP_KERNEL);
> +		error = truncate_bdev_range(bdev, file->f_mode, start, end);
> +		if (!error)
> +			error = blkdev_issue_discard(bdev,
> +						     start >> SECTOR_SHIFT,
> +						     len >> SECTOR_SHIFT,
> +						     GFP_KERNEL);
>  		break;

Same.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

