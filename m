Return-Path: <SRS0=cgFg=FA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B38FC63798
	for <dm-devel@archiver.kernel.org>; Thu, 26 Nov 2020 16:38:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 838A920B80
	for <dm-devel@archiver.kernel.org>; Thu, 26 Nov 2020 16:38:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 838A920B80
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-3-wuCN-QfDMsWhb_vg_syE2w-1; Thu, 26 Nov 2020 11:38:07 -0500
X-MC-Unique: wuCN-QfDMsWhb_vg_syE2w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5A4A5612A0;
	Thu, 26 Nov 2020 16:38:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1BFFD5C1BD;
	Thu, 26 Nov 2020 16:38:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BD7975002C;
	Thu, 26 Nov 2020 16:38:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AQGbx5h024477 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 26 Nov 2020 11:37:59 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7491A2166B27; Thu, 26 Nov 2020 16:37:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6FD7F2166B29
	for <dm-devel@redhat.com>; Thu, 26 Nov 2020 16:37:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CE47D103B805
	for <dm-devel@redhat.com>; Thu, 26 Nov 2020 16:37:54 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-200-FCXCAz8IP_ij9L8ILY5Nug-1;
	Thu, 26 Nov 2020 11:37:52 -0500
X-MC-Unique: FCXCAz8IP_ij9L8ILY5Nug-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 9A353ACC4;
	Thu, 26 Nov 2020 16:37:50 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
	id 730531E10D0; Thu, 26 Nov 2020 17:37:50 +0100 (CET)
Date: Thu, 26 Nov 2020 17:37:50 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20201126163750.GN422@quack2.suse.cz>
References: <20201126130422.92945-1-hch@lst.de>
	<20201126130422.92945-29-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201126130422.92945-29-hch@lst.de>
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
Subject: Re: [dm-devel] [PATCH 28/44] block: initialize struct block_device
	in bdev_alloc
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu 26-11-20 14:04:06, Christoph Hellwig wrote:
> Don't play tricks with slab constructors as bdev structures tends to not
> get reused very much, and this makes the code a lot less error prone.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Tejun Heo <tj@kernel.org>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/block_dev.c | 22 +++++++++-------------
>  1 file changed, 9 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index f180ac0e87844f..58e8532d8580a1 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -784,20 +784,11 @@ static void bdev_free_inode(struct inode *inode)
>  	kmem_cache_free(bdev_cachep, BDEV_I(inode));
>  }
>  
> -static void init_once(void *foo)
> +static void init_once(void *data)
>  {
> -	struct bdev_inode *ei = (struct bdev_inode *) foo;
> -	struct block_device *bdev = &ei->bdev;
> +	struct bdev_inode *ei = data;
>  
> -	memset(bdev, 0, sizeof(*bdev));
> -	mutex_init(&bdev->bd_mutex);
> -#ifdef CONFIG_SYSFS
> -	INIT_LIST_HEAD(&bdev->bd_holder_disks);
> -#endif
> -	bdev->bd_bdi = &noop_backing_dev_info;
>  	inode_init_once(&ei->vfs_inode);
> -	/* Initialize mutex for freeze. */
> -	mutex_init(&bdev->bd_fsfreeze_mutex);
>  }
>  
>  static void bdev_evict_inode(struct inode *inode)
> @@ -873,12 +864,17 @@ struct block_device *bdev_alloc(struct gendisk *disk, u8 partno)
>  	mapping_set_gfp_mask(&inode->i_data, GFP_USER);
>  
>  	bdev = I_BDEV(inode);
> +	memset(bdev, 0, sizeof(*bdev));
> +	mutex_init(&bdev->bd_mutex);
> +	mutex_init(&bdev->bd_fsfreeze_mutex);
>  	spin_lock_init(&bdev->bd_size_lock);
>  	bdev->bd_disk = disk;
>  	bdev->bd_partno = partno;
> -	bdev->bd_super = NULL;
>  	bdev->bd_inode = inode;
> -	bdev->bd_part_count = 0;
> +	bdev->bd_bdi = &noop_backing_dev_info;
> +#ifdef CONFIG_SYSFS
> +	INIT_LIST_HEAD(&bdev->bd_holder_disks);
> +#endif
>  	return bdev;
>  }
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

