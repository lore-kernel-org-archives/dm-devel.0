Return-Path: <SRS0=cgFg=FA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6588CC56202
	for <dm-devel@archiver.kernel.org>; Thu, 26 Nov 2020 17:02:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E2B702145D
	for <dm-devel@archiver.kernel.org>; Thu, 26 Nov 2020 17:02:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E2B702145D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-yh_ZVbv5NVevhmxhMiIReQ-1; Thu, 26 Nov 2020 12:02:18 -0500
X-MC-Unique: yh_ZVbv5NVevhmxhMiIReQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 886A9800D62;
	Thu, 26 Nov 2020 17:02:13 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6070F5D71D;
	Thu, 26 Nov 2020 17:02:13 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 054FC1809CA0;
	Thu, 26 Nov 2020 17:02:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AQH0pSl027953 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 26 Nov 2020 12:00:51 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5EB472166B2C; Thu, 26 Nov 2020 17:00:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5895A2166B2A
	for <dm-devel@redhat.com>; Thu, 26 Nov 2020 17:00:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D7837103B807
	for <dm-devel@redhat.com>; Thu, 26 Nov 2020 17:00:48 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-310-4PVUSqxxMFqyhzm-HnF4BQ-1;
	Thu, 26 Nov 2020 12:00:44 -0500
X-MC-Unique: 4PVUSqxxMFqyhzm-HnF4BQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 2F0B0ACE0;
	Thu, 26 Nov 2020 17:00:43 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
	id EBEA21E10D0; Thu, 26 Nov 2020 18:00:42 +0100 (CET)
Date: Thu, 26 Nov 2020 18:00:42 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20201126170042.GS422@quack2.suse.cz>
References: <20201126130422.92945-1-hch@lst.de>
	<20201126130422.92945-34-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201126130422.92945-34-hch@lst.de>
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
Subject: Re: [dm-devel] [PATCH 33/44] block: move holder_dir to struct
	block_device
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

On Thu 26-11-20 14:04:11, Christoph Hellwig wrote:
> Move the holder_dir field to struct block_device in preparation for
> kill struct hd_struct.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  block/genhd.c             |  5 +++--
>  block/partitions/core.c   |  8 ++++----
>  fs/block_dev.c            | 11 +++++------
>  include/linux/blk_types.h |  1 +
>  include/linux/genhd.h     |  1 -
>  5 files changed, 13 insertions(+), 13 deletions(-)
> 
> diff --git a/block/genhd.c b/block/genhd.c
> index fe202a12eec096..a964e7532fedd5 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -673,7 +673,8 @@ static void register_disk(struct device *parent, struct gendisk *disk,
>  	 */
>  	pm_runtime_set_memalloc_noio(ddev, true);
>  
> -	disk->part0.holder_dir = kobject_create_and_add("holders", &ddev->kobj);
> +	disk->part0.bdev->bd_holder_dir =
> +			kobject_create_and_add("holders", &ddev->kobj);
>  	disk->slave_dir = kobject_create_and_add("slaves", &ddev->kobj);
>  
>  	if (disk->flags & GENHD_FL_HIDDEN) {
> @@ -879,7 +880,7 @@ void del_gendisk(struct gendisk *disk)
>  
>  	blk_unregister_queue(disk);
>  
> -	kobject_put(disk->part0.holder_dir);
> +	kobject_put(disk->part0.bdev->bd_holder_dir);
>  	kobject_put(disk->slave_dir);
>  
>  	part_stat_set_all(&disk->part0, 0);
> diff --git a/block/partitions/core.c b/block/partitions/core.c
> index 224a22d82fb86f..d1093adf2570e2 100644
> --- a/block/partitions/core.c
> +++ b/block/partitions/core.c
> @@ -344,7 +344,7 @@ void delete_partition(struct hd_struct *part)
>  	 */
>  	get_device(disk_to_dev(disk));
>  	rcu_assign_pointer(ptbl->part[part->partno], NULL);
> -	kobject_put(part->holder_dir);
> +	kobject_put(part->bdev->bd_holder_dir);
>  	device_del(part_to_dev(part));
>  
>  	/*
> @@ -452,8 +452,8 @@ static struct hd_struct *add_partition(struct gendisk *disk, int partno,
>  		goto out_put;
>  
>  	err = -ENOMEM;
> -	p->holder_dir = kobject_create_and_add("holders", &pdev->kobj);
> -	if (!p->holder_dir)
> +	bdev->bd_holder_dir = kobject_create_and_add("holders", &pdev->kobj);
> +	if (!bdev->bd_holder_dir)
>  		goto out_del;
>  
>  	dev_set_uevent_suppress(pdev, 0);
> @@ -487,7 +487,7 @@ static struct hd_struct *add_partition(struct gendisk *disk, int partno,
>  out_remove_file:
>  	device_remove_file(pdev, &dev_attr_whole_disk);
>  out_del:
> -	kobject_put(p->holder_dir);
> +	kobject_put(bdev->bd_holder_dir);
>  	device_del(pdev);
>  out_put:
>  	put_device(pdev);
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index 62fae6a0e8aa56..2c91c35149787a 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -1138,7 +1138,7 @@ int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk)
>  	WARN_ON_ONCE(!bdev->bd_holder);
>  
>  	/* FIXME: remove the following once add_disk() handles errors */
> -	if (WARN_ON(!disk->slave_dir || !bdev->bd_part->holder_dir))
> +	if (WARN_ON(!disk->slave_dir || !bdev->bd_holder_dir))
>  		goto out_unlock;
>  
>  	holder = bd_find_holder_disk(bdev, disk);
> @@ -1161,14 +1161,14 @@ int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk)
>  	if (ret)
>  		goto out_free;
>  
> -	ret = add_symlink(bdev->bd_part->holder_dir, &disk_to_dev(disk)->kobj);
> +	ret = add_symlink(bdev->bd_holder_dir, &disk_to_dev(disk)->kobj);
>  	if (ret)
>  		goto out_del;
>  	/*
>  	 * bdev could be deleted beneath us which would implicitly destroy
>  	 * the holder directory.  Hold on to it.
>  	 */
> -	kobject_get(bdev->bd_part->holder_dir);
> +	kobject_get(bdev->bd_holder_dir);
>  
>  	list_add(&holder->list, &bdev->bd_holder_disks);
>  	goto out_unlock;
> @@ -1203,9 +1203,8 @@ void bd_unlink_disk_holder(struct block_device *bdev, struct gendisk *disk)
>  
>  	if (!WARN_ON_ONCE(holder == NULL) && !--holder->refcnt) {
>  		del_symlink(disk->slave_dir, bdev_kobj(bdev));
> -		del_symlink(bdev->bd_part->holder_dir,
> -			    &disk_to_dev(disk)->kobj);
> -		kobject_put(bdev->bd_part->holder_dir);
> +		del_symlink(bdev->bd_holder_dir, &disk_to_dev(disk)->kobj);
> +		kobject_put(bdev->bd_holder_dir);
>  		list_del_init(&holder->list);
>  		kfree(holder);
>  	}
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index 2f8ede04e5a94c..c0591e52d7d7ce 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -35,6 +35,7 @@ struct block_device {
>  #ifdef CONFIG_SYSFS
>  	struct list_head	bd_holder_disks;
>  #endif
> +	struct kobject		*bd_holder_dir;
>  	u8			bd_partno;
>  	struct hd_struct *	bd_part;
>  	/* number of times partitions within this device have been opened. */
> diff --git a/include/linux/genhd.h b/include/linux/genhd.h
> index 30d7076155b4d2..b4a5c05593b99c 100644
> --- a/include/linux/genhd.h
> +++ b/include/linux/genhd.h
> @@ -55,7 +55,6 @@ struct hd_struct {
>  
>  	struct block_device *bdev;
>  	struct device __dev;
> -	struct kobject *holder_dir;
>  	int policy, partno;
>  #ifdef CONFIG_FAIL_MAKE_REQUEST
>  	int make_it_fail;
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

