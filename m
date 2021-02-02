Return-Path: <SRS0=YUkt=HE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7546DC433E0
	for <dm-devel@archiver.kernel.org>; Tue,  2 Feb 2021 03:17:29 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DE24D64EA1
	for <dm-devel@archiver.kernel.org>; Tue,  2 Feb 2021 03:17:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DE24D64EA1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-uWP22laBNCq1M7ANnTXPfg-1; Mon, 01 Feb 2021 22:17:26 -0500
X-MC-Unique: uWP22laBNCq1M7ANnTXPfg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 85979107ACE4;
	Tue,  2 Feb 2021 03:17:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 68BAB6EF49;
	Tue,  2 Feb 2021 03:17:21 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2E085180954D;
	Tue,  2 Feb 2021 03:17:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1123HISJ022759 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 1 Feb 2021 22:17:18 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2E6152166B2A; Tue,  2 Feb 2021 03:17:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 295A72166B27
	for <dm-devel@redhat.com>; Tue,  2 Feb 2021 03:17:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E70B1101A560
	for <dm-devel@redhat.com>; Tue,  2 Feb 2021 03:17:15 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-519-LTTZ4JxrMY-qx422hKJlOw-1;
	Mon, 01 Feb 2021 22:17:13 -0500
X-MC-Unique: LTTZ4JxrMY-qx422hKJlOw-1
Received: by mail.kernel.org (Postfix) with ESMTPSA id E898964E9C;
	Tue,  2 Feb 2021 03:17:11 +0000 (UTC)
Date: Mon, 1 Feb 2021 19:17:11 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
Message-ID: <20210202031711.GJ7193@magnolia>
References: <20210129062757.1594130-1-ruansy.fnst@cn.fujitsu.com>
	<20210129062757.1594130-9-ruansy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
In-Reply-To: <20210129062757.1594130-9-ruansy.fnst@cn.fujitsu.com>
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
Cc: y-goto@fujitsu.com, qi.fuli@fujitsu.com, snitzer@redhat.com,
	linux-nvdimm@lists.01.org, rgoldwyn@suse.de,
	darrick.wong@oracle.com, david@fromorbit.com,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org, dan.j.williams@intel.com,
	hch@lst.de, agk@redhat.com
Subject: Re: [dm-devel] [PATCH RESEND v2 08/10] md: Implement
	->corrupted_range()
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Jan 29, 2021 at 02:27:55PM +0800, Shiyang Ruan wrote:
> With the support of ->rmap(), it is possible to obtain the superblock on
> a mapped device.
> 
> If a pmem device is used as one target of mapped device, we cannot
> obtain its superblock directly.  With the help of SYSFS, the mapped
> device can be found on the target devices.  So, we iterate the
> bdev->bd_holder_disks to obtain its mapped device.
> 
> Signed-off-by: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
> ---
>  drivers/md/dm.c       | 61 +++++++++++++++++++++++++++++++++++++++++++
>  drivers/nvdimm/pmem.c | 11 +++-----
>  fs/block_dev.c        | 42 ++++++++++++++++++++++++++++-

I feel like this ^^^ part that implements the generic ability for a block
device with a bad sector to notify whatever's holding onto it (fs, other
block device) should be in patch 2.  That's generic block layer code,
and it's hard to tell (when you're looking at patch 2) what the bare
function declaration in it is really supposed to do.

Also, this patch is still difficult to review because it mixes device
mapper, nvdimm, and block layer changes!

>  include/linux/genhd.h |  2 ++
>  4 files changed, 107 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 7bac564f3faa..31b0c340b695 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -507,6 +507,66 @@ static int dm_blk_report_zones(struct gendisk *disk, sector_t sector,
>  #define dm_blk_report_zones		NULL
>  #endif /* CONFIG_BLK_DEV_ZONED */
>  
> +struct corrupted_hit_info {
> +	struct block_device *bdev;
> +	sector_t offset;
> +};
> +
> +static int dm_blk_corrupted_hit(struct dm_target *ti, struct dm_dev *dev,
> +				sector_t start, sector_t count, void *data)
> +{
> +	struct corrupted_hit_info *bc = data;
> +
> +	return bc->bdev == (void *)dev->bdev &&
> +			(start <= bc->offset && bc->offset < start + count);
> +
> +}
> +
> +struct corrupted_do_info {
> +	size_t length;
> +	void *data;
> +};
> +
> +static int dm_blk_corrupted_do(struct dm_target *ti, struct block_device *bdev,
> +			       sector_t disk_sect, void *data)
> +{
> +	struct corrupted_do_info *bc = data;
> +	loff_t disk_off = to_bytes(disk_sect);
> +	loff_t bdev_off = to_bytes(disk_sect - get_start_sect(bdev));
> +
> +	return bd_corrupted_range(bdev, disk_off, bdev_off, bc->length, bc->data);
> +}
> +
> +static int dm_blk_corrupted_range(struct gendisk *disk,
> +				  struct block_device *target_bdev,
> +				  loff_t target_offset, size_t len, void *data)
> +{
> +	struct mapped_device *md = disk->private_data;
> +	struct dm_table *map;
> +	struct dm_target *ti;
> +	sector_t target_sect = to_sector(target_offset);
> +	struct corrupted_hit_info hi = {target_bdev, target_sect};
> +	struct corrupted_do_info di = {len, data};
> +	int srcu_idx, i, rc = -ENODEV;
> +
> +	map = dm_get_live_table(md, &srcu_idx);
> +	if (!map)
> +		return rc;
> +
> +	for (i = 0; i < dm_table_get_num_targets(map); i++) {
> +		ti = dm_table_get_target(map, i);
> +		if (!(ti->type->iterate_devices && ti->type->rmap))
> +			continue;
> +		if (!ti->type->iterate_devices(ti, dm_blk_corrupted_hit, &hi))
> +			continue;
> +
> +		rc = ti->type->rmap(ti, target_sect, dm_blk_corrupted_do, &di);

Why is it necessary to call ->iterate_devices here?

If you pass the target_bdev, offset, and length to the dm-target's
->rmap function, it should be able to work backwards through its mapping
logic to come up with all the LBA ranges of the mapped_device that
are affected, and then it can call bd_corrupted_range on each of those
reverse mappings.

It would be helpful to have the changes to dm-linear.c in this patch
too, since that's the only real implementation at this point.

> +		break;
> +	}
> +
> +	dm_put_live_table(md, srcu_idx);
> +	return rc;
> +}
> +
>  static int dm_prepare_ioctl(struct mapped_device *md, int *srcu_idx,
>  			    struct block_device **bdev)
>  {
> @@ -3062,6 +3122,7 @@ static const struct block_device_operations dm_blk_dops = {
>  	.getgeo = dm_blk_getgeo,
>  	.report_zones = dm_blk_report_zones,
>  	.pr_ops = &dm_pr_ops,
> +	.corrupted_range = dm_blk_corrupted_range,
>  	.owner = THIS_MODULE
>  };
>  
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 501959947d48..3d9f4ccbbd9e 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -256,21 +256,16 @@ static int pmem_rw_page(struct block_device *bdev, sector_t sector,
>  static int pmem_corrupted_range(struct gendisk *disk, struct block_device *bdev,
>  				loff_t disk_offset, size_t len, void *data)
>  {
> -	struct super_block *sb;
>  	loff_t bdev_offset;
>  	sector_t disk_sector = disk_offset >> SECTOR_SHIFT;
> -	int rc = 0;
> +	int rc = -ENODEV;
>  
>  	bdev = bdget_disk_sector(disk, disk_sector);
>  	if (!bdev)
> -		return -ENODEV;
> +		return rc;
>  
>  	bdev_offset = (disk_sector - get_start_sect(bdev)) << SECTOR_SHIFT;
> -	sb = get_super(bdev);
> -	if (sb && sb->s_op->corrupted_range) {
> -		rc = sb->s_op->corrupted_range(sb, bdev, bdev_offset, len, data);
> -		drop_super(sb);
> -	}
> +	rc = bd_corrupted_range(bdev, bdev_offset, bdev_offset, len, data);
>  
>  	bdput(bdev);
>  	return rc;
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index 3b8963e228a1..3cc2b2911e3a 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -1079,6 +1079,27 @@ struct bd_holder_disk {
>  	int			refcnt;
>  };
>  
> +static int bd_disk_holder_corrupted_range(struct block_device *bdev, loff_t off,
> +					  size_t len, void *data)
> +{
> +	struct bd_holder_disk *holder;
> +	struct gendisk *disk;
> +	int rc = 0;
> +
> +	if (list_empty(&(bdev->bd_holder_disks)))
> +		return -ENODEV;
> +
> +	list_for_each_entry(holder, &bdev->bd_holder_disks, list) {
> +		disk = holder->disk;
> +		if (disk->fops->corrupted_range) {
> +			rc = disk->fops->corrupted_range(disk, bdev, off, len, data);
> +			if (rc != -ENODEV)
> +				break;
> +		}
> +	}
> +	return rc;
> +}
> +
>  static struct bd_holder_disk *bd_find_holder_disk(struct block_device *bdev,
>  						  struct gendisk *disk)
>  {
> @@ -1212,7 +1233,26 @@ void bd_unlink_disk_holder(struct block_device *bdev, struct gendisk *disk)
>  	mutex_unlock(&bdev->bd_mutex);
>  }
>  EXPORT_SYMBOL_GPL(bd_unlink_disk_holder);
> -#endif
> +#endif /* CONFIG_SYSFS */
> +
> +int bd_corrupted_range(struct block_device *bdev, loff_t disk_off,
> +		       loff_t bdev_off, size_t len, void *data)
> +{
> +	struct super_block *sb = get_super(bdev);
> +	int rc = -EOPNOTSUPP;
> +
> +	if (!sb) {
> +#ifdef CONFIG_SYSFS
> +		rc = bd_disk_holder_corrupted_range(bdev, disk_off, len, data);
> +#endif /* CONFIG_SYSFS */

Normal kernel convention is that you'd provide a empty shell for the
CONFIG_SYSFS=n case, e.g.

#ifdef CONFIG_SYSFS
int bd_corrupted_range(...) {
	/* real code */
}
#else
static inline bd_corrupted_range(...) { return -EOPNOTSUPP; }
#endif

so that you don't have preprocessor directives making this function
choppy.

--D

> +		return rc;
> +	} else if (sb->s_op->corrupted_range)
> +		rc = sb->s_op->corrupted_range(sb, bdev, bdev_off, len, data);
> +	drop_super(sb);
> +
> +	return rc;
> +}
> +EXPORT_SYMBOL(bd_corrupted_range);
>  
>  static void __blkdev_put(struct block_device *bdev, fmode_t mode, int for_part);
>  
> diff --git a/include/linux/genhd.h b/include/linux/genhd.h
> index 4da480798955..996f91b08d48 100644
> --- a/include/linux/genhd.h
> +++ b/include/linux/genhd.h
> @@ -315,6 +315,8 @@ void unregister_blkdev(unsigned int major, const char *name);
>  bool bdev_check_media_change(struct block_device *bdev);
>  int __invalidate_device(struct block_device *bdev, bool kill_dirty);
>  void set_capacity(struct gendisk *disk, sector_t size);
> +int bd_corrupted_range(struct block_device *bdev, loff_t disk_off,
> +		       loff_t bdev_off, size_t len, void *data);
>  
>  /* for drivers/char/raw.c: */
>  int blkdev_ioctl(struct block_device *, fmode_t, unsigned, unsigned long);
> -- 
> 2.30.0
> 
> 
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

