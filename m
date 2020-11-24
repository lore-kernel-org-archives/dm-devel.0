Return-Path: <SRS0=MhoS=E6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43737C63798
	for <dm-devel@archiver.kernel.org>; Tue, 24 Nov 2020 13:38:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 976402083E
	for <dm-devel@archiver.kernel.org>; Tue, 24 Nov 2020 13:38:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 976402083E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-119-gfhbGBf2Pc23D4jiQYpJdA-1; Tue, 24 Nov 2020 08:38:50 -0500
X-MC-Unique: gfhbGBf2Pc23D4jiQYpJdA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8535018C43C8;
	Tue, 24 Nov 2020 13:38:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 61A76100164C;
	Tue, 24 Nov 2020 13:38:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2F77C180954D;
	Tue, 24 Nov 2020 13:38:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AODcik7019944 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 24 Nov 2020 08:38:44 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 3C01B1112873; Tue, 24 Nov 2020 13:38:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 37F4C1004159
	for <dm-devel@redhat.com>; Tue, 24 Nov 2020 13:38:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ED924185A7BC
	for <dm-devel@redhat.com>; Tue, 24 Nov 2020 13:38:41 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-399-Ie7VcGoDPjm_Inx0ngms0g-1;
	Tue, 24 Nov 2020 08:38:39 -0500
X-MC-Unique: Ie7VcGoDPjm_Inx0ngms0g-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id E8E43AC2D;
	Tue, 24 Nov 2020 13:38:37 +0000 (UTC)
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
References: <20201124132751.3747337-1-hch@lst.de>
	<20201124132751.3747337-24-hch@lst.de>
From: Coly Li <colyli@suse.de>
Message-ID: <bbb4130b-6848-f2ed-b7e0-c86b68c2663a@suse.de>
Date: Tue, 24 Nov 2020 21:38:27 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
	Gecko/20100101 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201124132751.3747337-24-hch@lst.de>
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
Cc: linux-bcache@vger.kernel.org, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jan Kara <jack@suse.com>, Josef Bacik <josef@toxicpanda.com>,
	linux-block@vger.kernel.org, Richard Weinberger <richard@nod.at>,
	dm-devel@redhat.com, linux-mtd@lists.infradead.org,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Tejun Heo <tj@kernel.org>, xen-devel@lists.xenproject.org,
	linux-mm@kvack.org
Subject: Re: [dm-devel] [PATCH 23/45] block: remove i_bdev
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
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 11/24/20 9:27 PM, Christoph Hellwig wrote:
> Switch the block device lookup interfaces to directly work with a dev_t
> so that struct block_device references are only acquired by the
> blkdev_get variants (and the blk-cgroup special case).  This means that
> we not don't need an extra reference in the inode and can generally
> simplify handling of struct block_device to keep the lookups contained
> in the core block layer code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

For the bcache part, Acked-by: Coly Li <colyli@suse.de>

Thanks.

Coly Li

> ---
>  block/ioctl.c                                |   3 +-
>  drivers/block/loop.c                         |   8 +-
>  drivers/md/bcache/super.c                    |  20 +-
>  drivers/md/dm-table.c                        |   9 +-
>  drivers/mtd/mtdsuper.c                       |  17 +-
>  drivers/target/target_core_file.c            |   6 +-
>  drivers/usb/gadget/function/storage_common.c |   8 +-
>  fs/block_dev.c                               | 195 +++++--------------
>  fs/btrfs/volumes.c                           |  13 +-
>  fs/inode.c                                   |   3 -
>  fs/internal.h                                |   7 +-
>  fs/io_uring.c                                |  10 +-
>  fs/pipe.c                                    |   5 +-
>  fs/quota/quota.c                             |  19 +-
>  fs/statfs.c                                  |   2 +-
>  fs/super.c                                   |  37 ++--
>  include/linux/blkdev.h                       |   2 +-
>  include/linux/fs.h                           |   1 -
>  18 files changed, 114 insertions(+), 251 deletions(-)
> 

[snipped]

> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index a6a5e21e4fd136..c55d3c58a7ef55 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -2380,38 +2380,38 @@ kobj_attribute_write(register,		register_bcache);
>  kobj_attribute_write(register_quiet,	register_bcache);
>  kobj_attribute_write(pendings_cleanup,	bch_pending_bdevs_cleanup);
>  
> -static bool bch_is_open_backing(struct block_device *bdev)
> +static bool bch_is_open_backing(dev_t dev)
>  {
>  	struct cache_set *c, *tc;
>  	struct cached_dev *dc, *t;
>  
>  	list_for_each_entry_safe(c, tc, &bch_cache_sets, list)
>  		list_for_each_entry_safe(dc, t, &c->cached_devs, list)
> -			if (dc->bdev == bdev)
> +			if (dc->bdev->bd_dev == dev)
>  				return true;
>  	list_for_each_entry_safe(dc, t, &uncached_devices, list)
> -		if (dc->bdev == bdev)
> +		if (dc->bdev->bd_dev == dev)
>  			return true;
>  	return false;
>  }
>  
> -static bool bch_is_open_cache(struct block_device *bdev)
> +static bool bch_is_open_cache(dev_t dev)
>  {
>  	struct cache_set *c, *tc;
>  
>  	list_for_each_entry_safe(c, tc, &bch_cache_sets, list) {
>  		struct cache *ca = c->cache;
>  
> -		if (ca->bdev == bdev)
> +		if (ca->bdev->bd_dev == dev)
>  			return true;
>  	}
>  
>  	return false;
>  }
>  
> -static bool bch_is_open(struct block_device *bdev)
> +static bool bch_is_open(dev_t dev)
>  {
> -	return bch_is_open_cache(bdev) || bch_is_open_backing(bdev);
> +	return bch_is_open_cache(dev) || bch_is_open_backing(dev);
>  }
>  
>  struct async_reg_args {
> @@ -2535,9 +2535,11 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
>  				  sb);
>  	if (IS_ERR(bdev)) {
>  		if (bdev == ERR_PTR(-EBUSY)) {
> -			bdev = lookup_bdev(strim(path));
> +			dev_t dev;
> +
>  			mutex_lock(&bch_register_lock);
> -			if (!IS_ERR(bdev) && bch_is_open(bdev))
> +			if (lookup_bdev(strim(path), &dev) == 0 &&
> +			    bch_is_open(dev))
>  				err = "device already registered";
>  			else
>  				err = "device busy";
[snipped]

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

