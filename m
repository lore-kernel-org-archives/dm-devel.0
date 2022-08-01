Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63B21C00144
	for <dm-devel@archiver.kernel.org>; Mon,  1 Aug 2022 11:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659352764;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=KnloJWN8XK+Uc+eDcdOjaSsmZDsGLep3Xq4MgzVo7tU=;
	b=VCrPbtOcgnar7n74r3KQSknZiVzZnWu+xzxG7GjDPBZ5irmz9mu7/2SYe9/jLeG0Iiz8s9
	MlnfyeJKJahUVm2swaqtF/iSqhPhpg1txLaV9/ceESfBd/sNJ9pniNRrx9jHY8Bu5yclM+
	ilOYcrf/JAzQeu8e0/3yzzg3zixyoLc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-608--eG40_ckOGCs8vBLyV0QCA-1; Mon, 01 Aug 2022 07:19:21 -0400
X-MC-Unique: -eG40_ckOGCs8vBLyV0QCA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E855F3804075;
	Mon,  1 Aug 2022 11:19:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9CC111121314;
	Mon,  1 Aug 2022 11:19:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5E25F1946A4B;
	Mon,  1 Aug 2022 11:19:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 126541946A41
 for <dm-devel@listman.corp.redhat.com>; Mon,  1 Aug 2022 11:19:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 05E92C1D3AD; Mon,  1 Aug 2022 11:19:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 025A4C15D67
 for <dm-devel@redhat.com>; Mon,  1 Aug 2022 11:19:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DF3491824602
 for <dm-devel@redhat.com>; Mon,  1 Aug 2022 11:19:17 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592-JdaY6o9qPwKpkt5JFcV4nA-1; Mon, 01 Aug 2022 07:19:13 -0400
X-MC-Unique: JdaY6o9qPwKpkt5JFcV4nA-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 0EB99611F6;
 Mon,  1 Aug 2022 11:19:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17181C433D6;
 Mon,  1 Aug 2022 11:19:11 +0000 (UTC)
Date: Mon, 1 Aug 2022 13:19:09 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <Yue2rU2Y+xzvGU6x@kroah.com>
References: <20220729062356.1663513-1-yukuai1@huaweicloud.com>
 <20220729062356.1663513-2-yukuai1@huaweicloud.com>
MIME-Version: 1.0
In-Reply-To: <20220729062356.1663513-2-yukuai1@huaweicloud.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH stable 5.10 1/3] block: look up holders by
 bdev
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
Cc: axboe@kernel.dk, snitzer@redhat.com, yi.zhang@huawei.com,
 stable@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com,
 yukuai3@huawei.com, hch@lst.de
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Jul 29, 2022 at 02:23:54PM +0800, Yu Kuai wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> commit 0dbcfe247f22a6d73302dfa691c48b3c14d31c4c upstream.
> 
> Invert they way the holder relations are tracked.  This very
> slightly reduces the memory overhead for partitioned devices.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  block/genhd.c             |  3 +++
>  fs/block_dev.c            | 31 +++++++++++++++++++------------
>  include/linux/blk_types.h |  3 ---
>  include/linux/genhd.h     |  4 +++-
>  4 files changed, 25 insertions(+), 16 deletions(-)
> 
> diff --git a/block/genhd.c b/block/genhd.c
> index 796baf761202..2b11a2735285 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -1760,6 +1760,9 @@ struct gendisk *__alloc_disk_node(int minors, int node_id)
>  	disk_to_dev(disk)->class = &block_class;
>  	disk_to_dev(disk)->type = &disk_type;
>  	device_initialize(disk_to_dev(disk));
> +#ifdef CONFIG_SYSFS
> +	INIT_LIST_HEAD(&disk->slave_bdevs);
> +#endif
>  	return disk;
>  
>  out_free_part0:
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index 29f020c4b2d0..a202c76fcf7f 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -823,9 +823,6 @@ static void init_once(void *foo)
>  
>  	memset(bdev, 0, sizeof(*bdev));
>  	mutex_init(&bdev->bd_mutex);
> -#ifdef CONFIG_SYSFS
> -	INIT_LIST_HEAD(&bdev->bd_holder_disks);
> -#endif
>  	bdev->bd_bdi = &noop_backing_dev_info;
>  	inode_init_once(&ei->vfs_inode);
>  	/* Initialize mutex for freeze. */
> @@ -1188,7 +1185,7 @@ EXPORT_SYMBOL(bd_abort_claiming);
>  #ifdef CONFIG_SYSFS
>  struct bd_holder_disk {
>  	struct list_head	list;
> -	struct gendisk		*disk;
> +	struct block_device	*bdev;
>  	int			refcnt;
>  };
>  
> @@ -1197,8 +1194,8 @@ static struct bd_holder_disk *bd_find_holder_disk(struct block_device *bdev,
>  {
>  	struct bd_holder_disk *holder;
>  
> -	list_for_each_entry(holder, &bdev->bd_holder_disks, list)
> -		if (holder->disk == disk)
> +	list_for_each_entry(holder, &disk->slave_bdevs, list)
> +		if (holder->bdev == bdev)
>  			return holder;
>  	return NULL;
>  }
> @@ -1244,9 +1241,13 @@ static void del_symlink(struct kobject *from, struct kobject *to)
>  int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk)
>  {
>  	struct bd_holder_disk *holder;
> +	struct block_device *bdev_holder = bdget_disk(disk, 0);
>  	int ret = 0;
>  
> -	mutex_lock(&bdev->bd_mutex);
> +	if (WARN_ON_ONCE(!bdev_holder))
> +		return -ENOENT;
> +
> +	mutex_lock(&bdev_holder->bd_mutex);
>  
>  	WARN_ON_ONCE(!bdev->bd_holder);
>  
> @@ -1267,7 +1268,7 @@ int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk)
>  	}
>  
>  	INIT_LIST_HEAD(&holder->list);
> -	holder->disk = disk;
> +	holder->bdev = bdev;
>  	holder->refcnt = 1;
>  
>  	ret = add_symlink(disk->slave_dir, &part_to_dev(bdev->bd_part)->kobj);
> @@ -1283,7 +1284,7 @@ int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk)
>  	 */
>  	kobject_get(bdev->bd_part->holder_dir);
>  
> -	list_add(&holder->list, &bdev->bd_holder_disks);
> +	list_add(&holder->list, &disk->slave_bdevs);
>  	goto out_unlock;
>  
>  out_del:
> @@ -1291,7 +1292,8 @@ int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk)
>  out_free:
>  	kfree(holder);
>  out_unlock:
> -	mutex_unlock(&bdev->bd_mutex);
> +	mutex_unlock(&bdev_holder->bd_mutex);
> +	bdput(bdev_holder);
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(bd_link_disk_holder);
> @@ -1309,8 +1311,12 @@ EXPORT_SYMBOL_GPL(bd_link_disk_holder);
>  void bd_unlink_disk_holder(struct block_device *bdev, struct gendisk *disk)
>  {
>  	struct bd_holder_disk *holder;
> +	struct block_device *bdev_holder = bdget_disk(disk, 0);
>  
> -	mutex_lock(&bdev->bd_mutex);
> +	if (WARN_ON_ONCE(!bdev_holder))
> +		return;
> +
> +	mutex_lock(&bdev_holder->bd_mutex);
>  
>  	holder = bd_find_holder_disk(bdev, disk);
>  
> @@ -1323,7 +1329,8 @@ void bd_unlink_disk_holder(struct block_device *bdev, struct gendisk *disk)
>  		kfree(holder);
>  	}
>  
> -	mutex_unlock(&bdev->bd_mutex);
> +	mutex_unlock(&bdev_holder->bd_mutex);
> +	bdput(bdev_holder);
>  }
>  EXPORT_SYMBOL_GPL(bd_unlink_disk_holder);
>  #endif
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index d9b69bbde5cc..1b84ecb34c18 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -29,9 +29,6 @@ struct block_device {
>  	void *			bd_holder;
>  	int			bd_holders;
>  	bool			bd_write_holder;
> -#ifdef CONFIG_SYSFS
> -	struct list_head	bd_holder_disks;
> -#endif
>  	struct block_device *	bd_contains;
>  	u8			bd_partno;
>  	struct hd_struct *	bd_part;
> diff --git a/include/linux/genhd.h b/include/linux/genhd.h
> index 03da3f603d30..3e5049a527e6 100644
> --- a/include/linux/genhd.h
> +++ b/include/linux/genhd.h
> @@ -195,7 +195,9 @@ struct gendisk {
>  #define GD_NEED_PART_SCAN		0
>  	struct rw_semaphore lookup_sem;
>  	struct kobject *slave_dir;
> -
> +#ifdef CONFIG_SYSFS
> +	struct list_head	slave_bdevs;
> +#endif

This is very different from the upstream version, and forces the change
onto everyone, not just those who had CONFIG_BLOCK_HOLDER_DEPRECATED
enabled like was done in the main kernel tree.

Why force this on all and not just use the same option?

I would need a strong ACK from the original developers and maintainers
of these subsystems before being able to take these into the 5.10 tree.

What prevents you from just using 5.15 for those systems that run into
these issues?

thanks,

greg k-h

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

