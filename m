Return-Path: <SRS0=sUON=EZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05CE8C2D0E4
	for <dm-devel@archiver.kernel.org>; Thu, 19 Nov 2020 10:33:12 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2E52C221F1
	for <dm-devel@archiver.kernel.org>; Thu, 19 Nov 2020 10:33:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2E52C221F1
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-514-WcOWcCsDOdmdQ38fbUXTcA-1; Thu, 19 Nov 2020 05:33:07 -0500
X-MC-Unique: WcOWcCsDOdmdQ38fbUXTcA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 96B1B801B18;
	Thu, 19 Nov 2020 10:33:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6607310016F5;
	Thu, 19 Nov 2020 10:33:03 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 01B5E180954D;
	Thu, 19 Nov 2020 10:33:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AJAX0ER004230 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 19 Nov 2020 05:33:00 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7151DC77E0; Thu, 19 Nov 2020 10:33:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6BF9AC77DE
	for <dm-devel@redhat.com>; Thu, 19 Nov 2020 10:32:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 51CE5801232
	for <dm-devel@redhat.com>; Thu, 19 Nov 2020 10:32:58 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-299--6MJDipgPd6MA5-wau0O2Q-1;
	Thu, 19 Nov 2020 05:32:55 -0500
X-MC-Unique: -6MJDipgPd6MA5-wau0O2Q-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 3937FACBA;
	Thu, 19 Nov 2020 10:32:54 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
	id D5CBE1E130B; Thu, 19 Nov 2020 11:32:53 +0100 (CET)
Date: Thu, 19 Nov 2020 11:32:53 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20201119103253.GV1981@quack2.suse.cz>
References: <20201118084800.2339180-1-hch@lst.de>
	<20201118084800.2339180-14-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201118084800.2339180-14-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Richard Weinberger <richard@nod.at>,
	Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dm-devel@redhat.com, linux-mtd@lists.infradead.org,
	Jan Kara <jack@suse.com>, Tejun Heo <tj@kernel.org>,
	xen-devel@lists.xenproject.org, linux-bcache@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [dm-devel] [PATCH 13/20] block: remove ->bd_contains
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed 18-11-20 09:47:53, Christoph Hellwig wrote:
> Now that each hd_struct has a reference to the corresponding
> block_device, there is no need for the bd_contains pointer.  Add
> a bdev_whole() helper to look up the whole device block_device
> struture instead.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Just two nits below. Otherwise feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

> @@ -1521,7 +1510,7 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, void *holder,
>  		if (bdev->bd_bdi == &noop_backing_dev_info)
>  			bdev->bd_bdi = bdi_get(disk->queue->backing_dev_info);
>  	} else {
> -		if (bdev->bd_contains == bdev) {
> +		if (!bdev->bd_partno) {

This should be !bdev_is_partition(bdev) for consistency, right?

>  			ret = 0;
>  			if (bdev->bd_disk->fops->open)
>  				ret = bdev->bd_disk->fops->open(bdev, mode);
...
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index 0069bee992063e..453b940b87d8e9 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -32,7 +32,6 @@ struct block_device {
>  #ifdef CONFIG_SYSFS
>  	struct list_head	bd_holder_disks;
>  #endif
> -	struct block_device *	bd_contains;
>  	u8			bd_partno;
>  	struct hd_struct *	bd_part;
>  	/* number of times partitions within this device have been opened. */
> @@ -48,6 +47,9 @@ struct block_device {
>  	struct mutex		bd_fsfreeze_mutex;
>  } __randomize_layout;
>  
> +#define bdev_whole(_bdev) \
> +	((_bdev)->bd_disk->part0.bdev)
> +
>  #define bdev_kobj(_bdev) \
>  	(&part_to_dev((_bdev)->bd_part)->kobj)

I'd somewhat prefer if these helpers could actually be inline functions and
not macros. I guess they are macros because hd_struct isn't in blk_types.h.
But if we moved helpers to blkdev.h, we'd have all definitions we need...
Is that a problem for some users?

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

