Return-Path: <SRS0=hAiq=MV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C13F8C4338F
	for <dm-devel@archiver.kernel.org>; Thu, 29 Jul 2021 16:25:43 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5E4A76023F
	for <dm-devel@archiver.kernel.org>; Thu, 29 Jul 2021 16:25:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5E4A76023F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1627575942;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=J34WxbEyxCCb3VSji9dFPDDoBV5AVaJSKP9zUHIRWVw=;
	b=cw5gaIPKHA7wJO9WzEVbcKtyZ/WfaFmotLJV9MpbpTUA6UEhjkzOZXaTM8DgZwfYfr2gYJ
	oDBZpUT3tMEm7s5XuZjQuovU6GXmAC+tudlcqHOLfgWHG/J+ZHrQlEE8bFDeBSwQiU81IM
	FTJk2mqBMiZ+0s4rZbw90l+uSzAOvP4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-376-0mL8pAoyOGu2PLeJYj7VEQ-1; Thu, 29 Jul 2021 12:25:40 -0400
X-MC-Unique: 0mL8pAoyOGu2PLeJYj7VEQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EA73A1009606;
	Thu, 29 Jul 2021 16:25:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3EFA25D6A1;
	Thu, 29 Jul 2021 16:25:35 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5FE51180B7A2;
	Thu, 29 Jul 2021 16:25:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16TGPVQN011344 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 29 Jul 2021 12:25:32 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id CBC0720B6656; Thu, 29 Jul 2021 16:25:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C13C420B662F
	for <dm-devel@redhat.com>; Thu, 29 Jul 2021 16:25:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9A924106669B
	for <dm-devel@redhat.com>; Thu, 29 Jul 2021 16:25:19 +0000 (UTC)
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
	[209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-242-BQctXCnSPsO68Z7Uoqc-fA-1; Thu, 29 Jul 2021 12:25:15 -0400
X-MC-Unique: BQctXCnSPsO68Z7Uoqc-fA-1
Received: by mail-qk1-f198.google.com with SMTP id
	j12-20020a05620a146cb02903ad9c5e94baso4063213qkl.16
	for <dm-devel@redhat.com>; Thu, 29 Jul 2021 09:25:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=OU8wmfZjDy5xCbXb6TNHwSPDfi69Pkgv1N60bHHAFXQ=;
	b=i+1N/e1nd43qnHwwirAf81oXNHSulVNnvlGklvUDItek1AMaD1rJKovNQq5lURuUC6
	fLS8CanKyy9qdhL8j9plKOl627SYccOLL2P7PZfJb0RBfebxoMAOK1GMbCNTGb9TkJjp
	nWQlHcFitiBHzCktMAJ2Ba99ikC39vC866wB8kD90vdl753jrvgjTxtzdqT3qHQSDDd5
	/NyFksdqa6W7/sgjGlbN99AR43f+8B0FwplNBvGD9xb5sqeuA5f6l0+kIKEoOrkwcgxX
	nRYMPApro7bRwo/m8OTnVUVi7gMmWccdC2QXKK3B5TN8VKXTs6E3PAuSWIA9ipJcoo20
	nzsg==
X-Gm-Message-State: AOAM5331RAyt11zMWNkgqGIubx8lM2lEsSj6LpnLtpGMS9Z1AHPIz1id
	ijwJB8yWGfGcv6cWJZTRIdCcqRb0TrdHP7+rLvEmt3l1vKjAkYvuLKBmbOcTPxiSF9gJU0uwwGK
	yjqboJe4HeDjg9w==
X-Received: by 2002:a05:620a:12b7:: with SMTP id
	x23mr6081820qki.384.1627575915315; 
	Thu, 29 Jul 2021 09:25:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyYh/qN+xSqDx8QlRAo++lofHbtoe3XVJGORy8mLxKUKwYVVC4S4Mkka5zElWilJMgahdfZpg==
X-Received: by 2002:a05:620a:12b7:: with SMTP id
	x23mr6081792qki.384.1627575914986; 
	Thu, 29 Jul 2021 09:25:14 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52])
	by smtp.gmail.com with ESMTPSA id f3sm1431947qti.65.2021.07.29.09.25.14
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 29 Jul 2021 09:25:14 -0700 (PDT)
Date: Thu, 29 Jul 2021 12:25:13 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <YQLWad8My4ZGPu6Q@redhat.com>
References: <20210725055458.29008-1-hch@lst.de>
	<20210725055458.29008-2-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20210725055458.29008-2-hch@lst.de>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 1/8] block: make the block holder code
	optional
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
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

On Sun, Jul 25 2021 at  1:54P -0400,
Christoph Hellwig <hch@lst.de> wrote:

> Move the block holder code into a separate file as it is not in any way
> related to the other block_dev.c code, and add a new selectable config
> option for it so that we don't have to build it without any remapped
> drivers selected.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/Kconfig             |   4 ++
>  block/Makefile            |   1 +
>  block/holder.c            | 139 ++++++++++++++++++++++++++++++++++++
>  drivers/md/Kconfig        |   2 +
>  drivers/md/bcache/Kconfig |   1 +
>  fs/block_dev.c            | 144 +-------------------------------------
>  include/linux/blk_types.h |   2 +-
>  include/linux/genhd.h     |   4 +-
>  8 files changed, 151 insertions(+), 146 deletions(-)
>  create mode 100644 block/holder.c
> 
> diff --git a/block/Kconfig b/block/Kconfig
> index fd732aede922..a24d7263d1fc 100644
> --- a/block/Kconfig
> +++ b/block/Kconfig
> @@ -251,4 +251,8 @@ config BLK_MQ_RDMA
>  config BLK_PM
>  	def_bool BLOCK && PM
>  
> +# do not use in new code
> +config BLOCK_HOLDER_DEPRECATED
> +	bool
> +

What is it that new code that does IO remapping and device stacking
_should_ be using!?  Seems the whole "do not use" and "DEPRECATED" is
a misnomer.

But those nits aside, code looks fine mechnically:

Reviewed-by: Mike Snitzer <snitzer@redhat.com>

>  source "block/Kconfig.iosched"
> diff --git a/block/Makefile b/block/Makefile
> index bfbe4e13ca1e..6fc6216634ed 100644
> --- a/block/Makefile
> +++ b/block/Makefile
> @@ -42,3 +42,4 @@ obj-$(CONFIG_BLK_SED_OPAL)	+= sed-opal.o
>  obj-$(CONFIG_BLK_PM)		+= blk-pm.o
>  obj-$(CONFIG_BLK_INLINE_ENCRYPTION)	+= keyslot-manager.o blk-crypto.o
>  obj-$(CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK)	+= blk-crypto-fallback.o
> +obj-$(CONFIG_BLOCK_HOLDER_DEPRECATED)	+= holder.o
> diff --git a/block/holder.c b/block/holder.c
> new file mode 100644
> index 000000000000..904a1dcd5c12
> --- /dev/null
> +++ b/block/holder.c
> @@ -0,0 +1,139 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +#include <linux/genhd.h>
> +
> +struct bd_holder_disk {
> +	struct list_head	list;
> +	struct gendisk		*disk;
> +	int			refcnt;
> +};
> +
> +static struct bd_holder_disk *bd_find_holder_disk(struct block_device *bdev,
> +						  struct gendisk *disk)
> +{
> +	struct bd_holder_disk *holder;
> +
> +	list_for_each_entry(holder, &bdev->bd_holder_disks, list)
> +		if (holder->disk == disk)
> +			return holder;
> +	return NULL;
> +}
> +
> +static int add_symlink(struct kobject *from, struct kobject *to)
> +{
> +	return sysfs_create_link(from, to, kobject_name(to));
> +}
> +
> +static void del_symlink(struct kobject *from, struct kobject *to)
> +{
> +	sysfs_remove_link(from, kobject_name(to));
> +}
> +
> +/**
> + * bd_link_disk_holder - create symlinks between holding disk and slave bdev
> + * @bdev: the claimed slave bdev
> + * @disk: the holding disk
> + *
> + * DON'T USE THIS UNLESS YOU'RE ALREADY USING IT.
> + *
> + * This functions creates the following sysfs symlinks.
> + *
> + * - from "slaves" directory of the holder @disk to the claimed @bdev
> + * - from "holders" directory of the @bdev to the holder @disk
> + *
> + * For example, if /dev/dm-0 maps to /dev/sda and disk for dm-0 is
> + * passed to bd_link_disk_holder(), then:
> + *
> + *   /sys/block/dm-0/slaves/sda --> /sys/block/sda
> + *   /sys/block/sda/holders/dm-0 --> /sys/block/dm-0
> + *
> + * The caller must have claimed @bdev before calling this function and
> + * ensure that both @bdev and @disk are valid during the creation and
> + * lifetime of these symlinks.
> + *
> + * CONTEXT:
> + * Might sleep.
> + *
> + * RETURNS:
> + * 0 on success, -errno on failure.
> + */
> +int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk)
> +{
> +	struct bd_holder_disk *holder;
> +	int ret = 0;
> +
> +	mutex_lock(&bdev->bd_disk->open_mutex);
> +
> +	WARN_ON_ONCE(!bdev->bd_holder);
> +
> +	/* FIXME: remove the following once add_disk() handles errors */
> +	if (WARN_ON(!disk->slave_dir || !bdev->bd_holder_dir))
> +		goto out_unlock;
> +
> +	holder = bd_find_holder_disk(bdev, disk);
> +	if (holder) {
> +		holder->refcnt++;
> +		goto out_unlock;
> +	}
> +
> +	holder = kzalloc(sizeof(*holder), GFP_KERNEL);
> +	if (!holder) {
> +		ret = -ENOMEM;
> +		goto out_unlock;
> +	}
> +
> +	INIT_LIST_HEAD(&holder->list);
> +	holder->disk = disk;
> +	holder->refcnt = 1;
> +
> +	ret = add_symlink(disk->slave_dir, bdev_kobj(bdev));
> +	if (ret)
> +		goto out_free;
> +
> +	ret = add_symlink(bdev->bd_holder_dir, &disk_to_dev(disk)->kobj);
> +	if (ret)
> +		goto out_del;
> +	/*
> +	 * bdev could be deleted beneath us which would implicitly destroy
> +	 * the holder directory.  Hold on to it.
> +	 */
> +	kobject_get(bdev->bd_holder_dir);
> +
> +	list_add(&holder->list, &bdev->bd_holder_disks);
> +	goto out_unlock;
> +
> +out_del:
> +	del_symlink(disk->slave_dir, bdev_kobj(bdev));
> +out_free:
> +	kfree(holder);
> +out_unlock:
> +	mutex_unlock(&bdev->bd_disk->open_mutex);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(bd_link_disk_holder);
> +
> +/**
> + * bd_unlink_disk_holder - destroy symlinks created by bd_link_disk_holder()
> + * @bdev: the calimed slave bdev
> + * @disk: the holding disk
> + *
> + * DON'T USE THIS UNLESS YOU'RE ALREADY USING IT.
> + *
> + * CONTEXT:
> + * Might sleep.
> + */
> +void bd_unlink_disk_holder(struct block_device *bdev, struct gendisk *disk)
> +{
> +	struct bd_holder_disk *holder;
> +
> +	mutex_lock(&bdev->bd_disk->open_mutex);
> +	holder = bd_find_holder_disk(bdev, disk);
> +	if (!WARN_ON_ONCE(holder == NULL) && !--holder->refcnt) {
> +		del_symlink(disk->slave_dir, bdev_kobj(bdev));
> +		del_symlink(bdev->bd_holder_dir, &disk_to_dev(disk)->kobj);
> +		kobject_put(bdev->bd_holder_dir);
> +		list_del_init(&holder->list);
> +		kfree(holder);
> +	}
> +	mutex_unlock(&bdev->bd_disk->open_mutex);
> +}
> +EXPORT_SYMBOL_GPL(bd_unlink_disk_holder);
> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> index 0602e82a9516..f821dae101a9 100644
> --- a/drivers/md/Kconfig
> +++ b/drivers/md/Kconfig
> @@ -15,6 +15,7 @@ if MD
>  
>  config BLK_DEV_MD
>  	tristate "RAID support"
> +	select BLOCK_HOLDER_DEPRECATED if SYSFS
>  	help
>  	  This driver lets you combine several hard disk partitions into one
>  	  logical block device. This can be used to simply append one
> @@ -201,6 +202,7 @@ config BLK_DEV_DM_BUILTIN
>  
>  config BLK_DEV_DM
>  	tristate "Device mapper support"
> +	select BLOCK_HOLDER_DEPRECATED if SYSFS
>  	select BLK_DEV_DM_BUILTIN
>  	depends on DAX || DAX=n
>  	help
> diff --git a/drivers/md/bcache/Kconfig b/drivers/md/bcache/Kconfig
> index d1ca4d059c20..cf3e8096942a 100644
> --- a/drivers/md/bcache/Kconfig
> +++ b/drivers/md/bcache/Kconfig
> @@ -2,6 +2,7 @@
>  
>  config BCACHE
>  	tristate "Block device as cache"
> +	select BLOCK_HOLDER_DEPRECATED if SYSFS
>  	select CRC64
>  	help
>  	Allows a block device to be used as cache for other devices; uses
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index 0c424a0cadaa..7825d152634e 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -900,7 +900,7 @@ struct block_device *bdev_alloc(struct gendisk *disk, u8 partno)
>  	bdev->bd_disk = disk;
>  	bdev->bd_partno = partno;
>  	bdev->bd_inode = inode;
> -#ifdef CONFIG_SYSFS
> +#ifdef CONFIG_BLOCK_HOLDER_DEPRECATED
>  	INIT_LIST_HEAD(&bdev->bd_holder_disks);
>  #endif
>  	bdev->bd_stats = alloc_percpu(struct disk_stats);
> @@ -1092,148 +1092,6 @@ void bd_abort_claiming(struct block_device *bdev, void *holder)
>  }
>  EXPORT_SYMBOL(bd_abort_claiming);
>  
> -#ifdef CONFIG_SYSFS
> -struct bd_holder_disk {
> -	struct list_head	list;
> -	struct gendisk		*disk;
> -	int			refcnt;
> -};
> -
> -static struct bd_holder_disk *bd_find_holder_disk(struct block_device *bdev,
> -						  struct gendisk *disk)
> -{
> -	struct bd_holder_disk *holder;
> -
> -	list_for_each_entry(holder, &bdev->bd_holder_disks, list)
> -		if (holder->disk == disk)
> -			return holder;
> -	return NULL;
> -}
> -
> -static int add_symlink(struct kobject *from, struct kobject *to)
> -{
> -	return sysfs_create_link(from, to, kobject_name(to));
> -}
> -
> -static void del_symlink(struct kobject *from, struct kobject *to)
> -{
> -	sysfs_remove_link(from, kobject_name(to));
> -}
> -
> -/**
> - * bd_link_disk_holder - create symlinks between holding disk and slave bdev
> - * @bdev: the claimed slave bdev
> - * @disk: the holding disk
> - *
> - * DON'T USE THIS UNLESS YOU'RE ALREADY USING IT.
> - *
> - * This functions creates the following sysfs symlinks.
> - *
> - * - from "slaves" directory of the holder @disk to the claimed @bdev
> - * - from "holders" directory of the @bdev to the holder @disk
> - *
> - * For example, if /dev/dm-0 maps to /dev/sda and disk for dm-0 is
> - * passed to bd_link_disk_holder(), then:
> - *
> - *   /sys/block/dm-0/slaves/sda --> /sys/block/sda
> - *   /sys/block/sda/holders/dm-0 --> /sys/block/dm-0
> - *
> - * The caller must have claimed @bdev before calling this function and
> - * ensure that both @bdev and @disk are valid during the creation and
> - * lifetime of these symlinks.
> - *
> - * CONTEXT:
> - * Might sleep.
> - *
> - * RETURNS:
> - * 0 on success, -errno on failure.
> - */
> -int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk)
> -{
> -	struct bd_holder_disk *holder;
> -	int ret = 0;
> -
> -	mutex_lock(&bdev->bd_disk->open_mutex);
> -
> -	WARN_ON_ONCE(!bdev->bd_holder);
> -
> -	/* FIXME: remove the following once add_disk() handles errors */
> -	if (WARN_ON(!disk->slave_dir || !bdev->bd_holder_dir))
> -		goto out_unlock;
> -
> -	holder = bd_find_holder_disk(bdev, disk);
> -	if (holder) {
> -		holder->refcnt++;
> -		goto out_unlock;
> -	}
> -
> -	holder = kzalloc(sizeof(*holder), GFP_KERNEL);
> -	if (!holder) {
> -		ret = -ENOMEM;
> -		goto out_unlock;
> -	}
> -
> -	INIT_LIST_HEAD(&holder->list);
> -	holder->disk = disk;
> -	holder->refcnt = 1;
> -
> -	ret = add_symlink(disk->slave_dir, bdev_kobj(bdev));
> -	if (ret)
> -		goto out_free;
> -
> -	ret = add_symlink(bdev->bd_holder_dir, &disk_to_dev(disk)->kobj);
> -	if (ret)
> -		goto out_del;
> -	/*
> -	 * bdev could be deleted beneath us which would implicitly destroy
> -	 * the holder directory.  Hold on to it.
> -	 */
> -	kobject_get(bdev->bd_holder_dir);
> -
> -	list_add(&holder->list, &bdev->bd_holder_disks);
> -	goto out_unlock;
> -
> -out_del:
> -	del_symlink(disk->slave_dir, bdev_kobj(bdev));
> -out_free:
> -	kfree(holder);
> -out_unlock:
> -	mutex_unlock(&bdev->bd_disk->open_mutex);
> -	return ret;
> -}
> -EXPORT_SYMBOL_GPL(bd_link_disk_holder);
> -
> -/**
> - * bd_unlink_disk_holder - destroy symlinks created by bd_link_disk_holder()
> - * @bdev: the calimed slave bdev
> - * @disk: the holding disk
> - *
> - * DON'T USE THIS UNLESS YOU'RE ALREADY USING IT.
> - *
> - * CONTEXT:
> - * Might sleep.
> - */
> -void bd_unlink_disk_holder(struct block_device *bdev, struct gendisk *disk)
> -{
> -	struct bd_holder_disk *holder;
> -
> -	mutex_lock(&bdev->bd_disk->open_mutex);
> -
> -	holder = bd_find_holder_disk(bdev, disk);
> -
> -	if (!WARN_ON_ONCE(holder == NULL) && !--holder->refcnt) {
> -		del_symlink(disk->slave_dir, bdev_kobj(bdev));
> -		del_symlink(bdev->bd_holder_dir, &disk_to_dev(disk)->kobj);
> -		kobject_put(bdev->bd_holder_dir);
> -		list_del_init(&holder->list);
> -		kfree(holder);
> -	}
> -
> -	mutex_unlock(&bdev->bd_disk->open_mutex);
> -}
> -EXPORT_SYMBOL_GPL(bd_unlink_disk_holder);
> -#endif
> -
>  static void blkdev_flush_mapping(struct block_device *bdev)
>  {
>  	WARN_ON_ONCE(bdev->bd_holders);
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index 290f9061b29a..7a4e139d24ef 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -34,7 +34,7 @@ struct block_device {
>  	void *			bd_holder;
>  	int			bd_holders;
>  	bool			bd_write_holder;
> -#ifdef CONFIG_SYSFS
> +#ifdef CONFIG_BLOCK_HOLDER_DEPRECATED
>  	struct list_head	bd_holder_disks;
>  #endif
>  	struct kobject		*bd_holder_dir;
> diff --git a/include/linux/genhd.h b/include/linux/genhd.h
> index 13b34177cc85..6831d74f2002 100644
> --- a/include/linux/genhd.h
> +++ b/include/linux/genhd.h
> @@ -316,7 +316,7 @@ void set_capacity(struct gendisk *disk, sector_t size);
>  int blkdev_ioctl(struct block_device *, fmode_t, unsigned, unsigned long);
>  long compat_blkdev_ioctl(struct file *, unsigned, unsigned long);
>  
> -#ifdef CONFIG_SYSFS
> +#ifdef CONFIG_BLOCK_HOLDER_DEPRECATED
>  int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk);
>  void bd_unlink_disk_holder(struct block_device *bdev, struct gendisk *disk);
>  #else
> @@ -329,7 +329,7 @@ static inline void bd_unlink_disk_holder(struct block_device *bdev,
>  					 struct gendisk *disk)
>  {
>  }
> -#endif /* CONFIG_SYSFS */
> +#endif /* CONFIG_BLOCK_HOLDER_DEPRECATED */
>  
>  dev_t part_devt(struct gendisk *disk, u8 partno);
>  dev_t blk_lookup_devt(const char *name, int partno);
> -- 
> 2.30.2
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

