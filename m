Return-Path: <SRS0=cgFg=FA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C08B4C63697
	for <dm-devel@archiver.kernel.org>; Thu, 26 Nov 2020 15:08:18 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3183520B80
	for <dm-devel@archiver.kernel.org>; Thu, 26 Nov 2020 15:08:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3183520B80
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-444-MBPJ3pz3NG60poB3y7ximA-1; Thu, 26 Nov 2020 10:08:14 -0500
X-MC-Unique: MBPJ3pz3NG60poB3y7ximA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DC02D1E7E0;
	Thu, 26 Nov 2020 15:08:09 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B95435D9C6;
	Thu, 26 Nov 2020 15:08:09 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8CD275002C;
	Thu, 26 Nov 2020 15:08:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AQF88Ff016186 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 26 Nov 2020 10:08:08 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 486DE100C28A; Thu, 26 Nov 2020 15:08:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4444D100C281
	for <dm-devel@redhat.com>; Thu, 26 Nov 2020 15:08:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3F12B186E121
	for <dm-devel@redhat.com>; Thu, 26 Nov 2020 15:08:01 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-214-rhfolvRVPCSzlS3EXsEZ3w-1;
	Thu, 26 Nov 2020 10:07:56 -0500
X-MC-Unique: rhfolvRVPCSzlS3EXsEZ3w-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 5E206ACE0;
	Thu, 26 Nov 2020 15:07:55 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
	id 2EBF11E10D0; Thu, 26 Nov 2020 16:07:55 +0100 (CET)
Date: Thu, 26 Nov 2020 16:07:55 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20201126150755.GI422@quack2.suse.cz>
References: <20201126130422.92945-1-hch@lst.de>
	<20201126130422.92945-23-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201126130422.92945-23-hch@lst.de>
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
	Mike Snitzer <snitzer@redhat.com>, linux-mm@kvack.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jan Kara <jack@suse.com>, Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
	linux-mtd@lists.infradead.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Tejun Heo <tj@kernel.org>, linux-bcache@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 22/44] block: opencode
	devcgroup_inode_permission
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

On Thu 26-11-20 14:04:00, Christoph Hellwig wrote:
> Just call devcgroup_check_permission to avoid various superflous checks
> and a double conversion of the access flags.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Tejun Heo <tj@kernel.org>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/block_dev.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index d0783c55a0ce65..b12ab68297baf3 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -1516,15 +1516,13 @@ static int blkdev_get(struct block_device *bdev, fmode_t mode, void *holder)
>  	struct block_device *claiming;
>  	bool unblock_events = true;
>  	struct gendisk *disk;
> -	int perm = 0;
>  	int partno;
>  	int ret;
>  
> -	if (mode & FMODE_READ)
> -		perm |= MAY_READ;
> -	if (mode & FMODE_WRITE)
> -		perm |= MAY_WRITE;
> -	ret = devcgroup_inode_permission(bdev->bd_inode, perm);
> +	ret = devcgroup_check_permission(DEVCG_DEV_BLOCK,
> +			imajor(bdev->bd_inode), iminor(bdev->bd_inode),
> +			((mode & FMODE_READ) ? DEVCG_ACC_READ : 0) |
> +			((mode & FMODE_WRITE) ? DEVCG_ACC_WRITE : 0));
>  	if (ret)
>  		goto bdput;
>  
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

