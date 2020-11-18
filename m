Return-Path: <SRS0=/Nun=EY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E9B3C63798
	for <dm-devel@archiver.kernel.org>; Wed, 18 Nov 2020 21:34:52 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C9812246CF
	for <dm-devel@archiver.kernel.org>; Wed, 18 Nov 2020 21:34:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C9812246CF
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-362-wCYfCFwkMr2mDQTRlnBKNA-1; Wed, 18 Nov 2020 16:34:45 -0500
X-MC-Unique: wCYfCFwkMr2mDQTRlnBKNA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E0C9081CBDD;
	Wed, 18 Nov 2020 21:34:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C139B5D6A8;
	Wed, 18 Nov 2020 21:34:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 97D9C86BE9;
	Wed, 18 Nov 2020 21:34:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AILYWko000535 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 18 Nov 2020 16:34:32 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 04397100415D; Wed, 18 Nov 2020 21:34:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F41C51004168
	for <dm-devel@redhat.com>; Wed, 18 Nov 2020 21:34:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7708B801184
	for <dm-devel@redhat.com>; Wed, 18 Nov 2020 21:34:28 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-265-3Uyl-iFCPiKHyJAOi9FtWg-1;
	Wed, 18 Nov 2020 16:34:26 -0500
X-MC-Unique: 3Uyl-iFCPiKHyJAOi9FtWg-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 2D032B009;
	Wed, 18 Nov 2020 21:34:24 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
	id D003A1E1316; Wed, 18 Nov 2020 15:18:00 +0100 (CET)
Date: Wed, 18 Nov 2020 15:18:00 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20201118141800.GH1981@quack2.suse.cz>
References: <20201118084800.2339180-1-hch@lst.de>
	<20201118084800.2339180-4-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201118084800.2339180-4-hch@lst.de>
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
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Richard Weinberger <richard@nod.at>,
	Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dm-devel@redhat.com, linux-mtd@lists.infradead.org,
	Jan Kara <jack@suse.com>, Tejun Heo <tj@kernel.org>,
	xen-devel@lists.xenproject.org, linux-bcache@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [dm-devel] [PATCH 03/20] block: add a bdev_kobj helper
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed 18-11-20 09:47:43, Christoph Hellwig wrote:
> Add a little helper to find the kobject for a struct block_device.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  drivers/md/bcache/super.c |  7 ++-----
>  drivers/md/md.c           |  4 +---
>  fs/btrfs/sysfs.c          | 15 +++------------
>  include/linux/blk_types.h |  3 +++
>  4 files changed, 9 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 46a00134a36ae1..a6a5e21e4fd136 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1447,8 +1447,7 @@ static int register_bdev(struct cache_sb *sb, struct cache_sb_disk *sb_disk,
>  		goto err;
>  
>  	err = "error creating kobject";
> -	if (kobject_add(&dc->disk.kobj, &part_to_dev(bdev->bd_part)->kobj,
> -			"bcache"))
> +	if (kobject_add(&dc->disk.kobj, bdev_kobj(bdev), "bcache"))
>  		goto err;
>  	if (bch_cache_accounting_add_kobjs(&dc->accounting, &dc->disk.kobj))
>  		goto err;
> @@ -2342,9 +2341,7 @@ static int register_cache(struct cache_sb *sb, struct cache_sb_disk *sb_disk,
>  		goto err;
>  	}
>  
> -	if (kobject_add(&ca->kobj,
> -			&part_to_dev(bdev->bd_part)->kobj,
> -			"bcache")) {
> +	if (kobject_add(&ca->kobj, bdev_kobj(bdev), "bcache")) {
>  		err = "error calling kobject_add";
>  		ret = -ENOMEM;
>  		goto out;
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index b2edf5e0f965b5..7ce6047c856ea2 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -2414,7 +2414,6 @@ EXPORT_SYMBOL(md_integrity_add_rdev);
>  static int bind_rdev_to_array(struct md_rdev *rdev, struct mddev *mddev)
>  {
>  	char b[BDEVNAME_SIZE];
> -	struct kobject *ko;
>  	int err;
>  
>  	/* prevent duplicates */
> @@ -2477,9 +2476,8 @@ static int bind_rdev_to_array(struct md_rdev *rdev, struct mddev *mddev)
>  	if ((err = kobject_add(&rdev->kobj, &mddev->kobj, "dev-%s", b)))
>  		goto fail;
>  
> -	ko = &part_to_dev(rdev->bdev->bd_part)->kobj;
>  	/* failure here is OK */
> -	err = sysfs_create_link(&rdev->kobj, ko, "block");
> +	err = sysfs_create_link(&rdev->kobj, bdev_kobj(rdev->bdev), "block");
>  	rdev->sysfs_state = sysfs_get_dirent_safe(rdev->kobj.sd, "state");
>  	rdev->sysfs_unack_badblocks =
>  		sysfs_get_dirent_safe(rdev->kobj.sd, "unacknowledged_bad_blocks");
> diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
> index 279d9262b676d4..24b6c6dc69000a 100644
> --- a/fs/btrfs/sysfs.c
> +++ b/fs/btrfs/sysfs.c
> @@ -1232,8 +1232,6 @@ int btrfs_sysfs_add_space_info_type(struct btrfs_fs_info *fs_info,
>  
>  void btrfs_sysfs_remove_device(struct btrfs_device *device)
>  {
> -	struct hd_struct *disk;
> -	struct kobject *disk_kobj;
>  	struct kobject *devices_kobj;
>  
>  	/*
> @@ -1243,11 +1241,8 @@ void btrfs_sysfs_remove_device(struct btrfs_device *device)
>  	devices_kobj = device->fs_info->fs_devices->devices_kobj;
>  	ASSERT(devices_kobj);
>  
> -	if (device->bdev) {
> -		disk = device->bdev->bd_part;
> -		disk_kobj = &part_to_dev(disk)->kobj;
> -		sysfs_remove_link(devices_kobj, disk_kobj->name);
> -	}
> +	if (device->bdev)
> +		sysfs_remove_link(devices_kobj, bdev_kobj(device->bdev)->name);
>  
>  	if (device->devid_kobj.state_initialized) {
>  		kobject_del(&device->devid_kobj);
> @@ -1353,11 +1348,7 @@ int btrfs_sysfs_add_device(struct btrfs_device *device)
>  	nofs_flag = memalloc_nofs_save();
>  
>  	if (device->bdev) {
> -		struct hd_struct *disk;
> -		struct kobject *disk_kobj;
> -
> -		disk = device->bdev->bd_part;
> -		disk_kobj = &part_to_dev(disk)->kobj;
> +		struct kobject *disk_kobj = bdev_kobj(device->bdev);
>  
>  		ret = sysfs_create_link(devices_kobj, disk_kobj, disk_kobj->name);
>  		if (ret) {
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index d9b69bbde5cc54..0069bee992063e 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -48,6 +48,9 @@ struct block_device {
>  	struct mutex		bd_fsfreeze_mutex;
>  } __randomize_layout;
>  
> +#define bdev_kobj(_bdev) \
> +	(&part_to_dev((_bdev)->bd_part)->kobj)
> +
>  /*
>   * Block error status values.  See block/blk-core:blk_errors for the details.
>   * Alpha cannot write a byte atomically, so we need to use 32-bit value.
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

