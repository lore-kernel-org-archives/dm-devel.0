Return-Path: <SRS0=cgFg=FA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 485F5C56202
	for <dm-devel@archiver.kernel.org>; Thu, 26 Nov 2020 15:45:49 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9659E21D1A
	for <dm-devel@archiver.kernel.org>; Thu, 26 Nov 2020 15:45:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9659E21D1A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-OhgNW4BsNSmLe1ksAocoDQ-1; Thu, 26 Nov 2020 10:45:45 -0500
X-MC-Unique: OhgNW4BsNSmLe1ksAocoDQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C91A61009446;
	Thu, 26 Nov 2020 15:45:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A4C5C19C71;
	Thu, 26 Nov 2020 15:45:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EA656180954D;
	Thu, 26 Nov 2020 15:45:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AQFjaXU019523 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 26 Nov 2020 10:45:36 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 83F452166B27; Thu, 26 Nov 2020 15:45:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7EF332166B2A
	for <dm-devel@redhat.com>; Thu, 26 Nov 2020 15:45:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 22FF2811E78
	for <dm-devel@redhat.com>; Thu, 26 Nov 2020 15:45:34 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-364-vJI4UH82O3u_Yx7fQwlR6Q-1;
	Thu, 26 Nov 2020 10:45:29 -0500
X-MC-Unique: vJI4UH82O3u_Yx7fQwlR6Q-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 41B9FAD20;
	Thu, 26 Nov 2020 15:45:28 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
	id C71901E10D0; Thu, 26 Nov 2020 16:45:27 +0100 (CET)
Date: Thu, 26 Nov 2020 16:45:27 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20201126154527.GJ422@quack2.suse.cz>
References: <20201126130422.92945-1-hch@lst.de>
	<20201126130422.92945-24-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201126130422.92945-24-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
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
Cc: Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>,
	Mike Snitzer <snitzer@redhat.com>, linux-mm@kvack.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jan Kara <jack@suse.com>, Josef Bacik <josef@toxicpanda.com>,
	Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
	linux-mtd@lists.infradead.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Tejun Heo <tj@kernel.org>, linux-bcache@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 23/44] block: remove i_bdev
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu 26-11-20 14:04:01, Christoph Hellwig wrote:
> Switch the block device lookup interfaces to directly work with a dev_t
> so that struct block_device references are only acquired by the
> blkdev_get variants (and the blk-cgroup special case).  This means that
> we now don't need an extra reference in the inode and can generally
> simplify handling of struct block_device to keep the lookups contained
> in the core block layer code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Tejun Heo <tj@kernel.org>
> Acked-by: Coly Li <colyli@suse.de>		[bcache]

Looks good to me. Just two nits about comments below. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

>  /**
> - * blkdev_get - open a block device
> - * @bdev: block_device to open
> + * blkdev_get_by_dev - open a block device by device number
> + * @dev: device number of block device to open
>   * @mode: FMODE_* mask
>   * @holder: exclusive holder identifier
>   *
> - * Open @bdev with @mode.  If @mode includes %FMODE_EXCL, @bdev is
> - * open with exclusive access.  Specifying %FMODE_EXCL with %NULL
> - * @holder is invalid.  Exclusive opens may nest for the same @holder.
> + * Open the block device described by device number @dev.  If @mode includes
> + * If @mode includes %FMODE_EXCL, the block device is opened with exclusive
      ^^^ twice "If @mode includes" - here and on previous line...

...
> @@ -776,19 +770,6 @@ struct super_block *__get_super(struct block_device *bdev, bool excl)
>  	return NULL;
>  }
>  
> -/**
> - *	get_super - get the superblock of a device
> - *	@bdev: device to get the superblock for
> - *
> - *	Scans the superblock list and finds the superblock of the file system
> - *	mounted on the device given. %NULL is returned if no match is found.
> - */

I think it would be nice to preserve this comment?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

