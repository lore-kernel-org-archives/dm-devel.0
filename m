Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4419125A5
	for <dm-devel@lists.linux.dev>; Mon, 18 Dec 2023 09:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qf0FKAqS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CBACC433C8;
	Mon, 18 Dec 2023 09:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702893210;
	bh=p85SmRdutR4QwP7RU75Y0x90R5b0kMo7bXFXSSnbNF0=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=Qf0FKAqSgy5pAurWVzjZy4M6jwRApaNZR27CFjZzHArBNWibbJeRmZ6N4+EpUyREY
	 YDOjHI3R2bqnrewYiGwgRSzjOEBC9nnIeanfci2AYz40T4HpUbWyMAKUENpj/yXeIg
	 sQQMNITvOIIcPpORPzS4ZqoVFMED4gTtHpf2T2FuxxAFzi2iqB4lJKpSEkLpuUmK09
	 Bx1+u0XRUT4zVSqw8W7KqYxfnqtIYexf78dISddUQYqoYzhklMHCg250dqL3lhHBo0
	 olKyyffuQHGVxJYy1hB0wC0tqrqhSU9Y+o8HyZy3AQvB8mr5+EjkN3FZr9o4VYGbGs
	 c/UeyRlC+bpqA==
Message-ID: <63b307b6-122d-4bb9-b1e7-aab2e5eec93d@kernel.org>
Date: Mon, 18 Dec 2023 18:53:27 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm: Validate zoned model of devices built with zoned
 targets
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
To: dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 Naohiro Aota <naohiro.aota@wdc.com>
References: <20231201020329.273592-1-dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20231201020329.273592-1-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2023/12/01 11:03, Damien Le Moal wrote:
> Using dm-linear or dm-error, a user can craft a DM device using
> host-managed SMR disks by mapping only conventional zones. Currently,
> such DM device will be reported also as being host-managed, despite the
> fact that this zoned model mandated sequential-write-required zone are
> not present. This breaks the host-managed model and may confuse some
> applications, potentially resulting in unexpected behavior or bugs.
> 
> A simple solution for such case is to expose a DM device built only
> using an SMR host managed disk conventional zones as a regular device.
> This is acceptable and possible because read and write accesses to
> conventional zones do not have any restrictions and can cross zone
> boundaries.
> 
> This commit introduces the function dm_validate_zoned_model() to detect
> if a zoned DM device contains only conventional zones. If it does, this
> function calls disk_set_zoned() to change the DM device queue zoned
> model to BLK_ZONED_NONE, clearing in the process also the queue limits
> associated with zoned block devices (e.g. chunk_sectors for the zone
> size, number of zones, etc). dm_validate_zoned_model() is called from
> dm_table_set_restrictions() when the DM device request queue is set up.
> 
> With this change, dm-linear and dm-error devices built using
> conventional zones are now exposed as regular block devices.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Mike,

Ping ? I do not see this queued in DM tree for-next branch.

Thanks !

> ---
>  drivers/md/dm-table.c | 13 +++++++++
>  drivers/md/dm-zone.c  | 63 +++++++++++++++++++++++++++++++++++++++++++
>  drivers/md/dm.h       |  1 +
>  3 files changed, 77 insertions(+)
> 
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 198d38b53322..9c7547da6171 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -2034,6 +2034,19 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
>  	    dm_table_any_dev_attr(t, device_is_not_random, NULL))
>  		blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, q);
>  
> +	/*
> +	 * A zoned target may contain only conventional zones, in which case
> +	 * we must set the device queue zoned model to BLK_ZONED_NONE to
> +	 * expose the target as a regular block device, and thus avoiding
> +	 * breaking the host-managed zoned model as it mandates the presence
> +	 * of sequential write required zones.
> +	 */
> +	if (blk_queue_is_zoned(q)) {
> +		r = dm_validate_zoned_model(t, q);
> +		if (r)
> +			return r;
> +	}
> +
>  	/*
>  	 * For a zoned target, setup the zones related queue attributes
>  	 * and resources necessary for zone append emulation if necessary.
> diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
> index eb9832b22b14..452a59bfdc10 100644
> --- a/drivers/md/dm-zone.c
> +++ b/drivers/md/dm-zone.c
> @@ -174,6 +174,69 @@ static unsigned int dm_get_zone_wp_offset(struct blk_zone *zone)
>  	}
>  }
>  
> +struct dm_zone_count {
> +	unsigned long nr_conv;
> +	unsigned long nr_seq;
> +};
> +
> +static int dm_validate_zoned_model_cb(struct blk_zone *zone, unsigned int idx,
> +				      void *data)
> +{
> +	struct dm_zone_count *zc = data;
> +
> +	switch (zone->type) {
> +	case BLK_ZONE_TYPE_CONVENTIONAL:
> +		zc->nr_conv++;
> +		break;
> +	case BLK_ZONE_TYPE_SEQWRITE_REQ:
> +	case BLK_ZONE_TYPE_SEQWRITE_PREF:
> +		zc->nr_seq++;
> +		break;
> +	default:
> +		DMERR("Invalid zone type 0x%x at sectors %llu",
> +		      (int)zone->type, zone->start);
> +		return -ENODEV;
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * Validate the queue zoned model by counting the conventional and
> + * sequential zones of the target. If no sequential zones are present, modify
> + * the device queue to expose it as a regular block device.
> + */
> +int dm_validate_zoned_model(struct dm_table *t, struct request_queue *q)
> +{
> +	struct mapped_device *md = t->md;
> +	struct gendisk *disk = md->disk;
> +	unsigned int nr_zones = bdev_nr_zones(disk->part0);
> +	struct dm_zone_count zc = { };
> +	unsigned int noio_flag;
> +	int ret;
> +
> +	/* Count conventional and sequential zones */
> +	noio_flag = memalloc_noio_save();
> +	ret = dm_blk_do_report_zones(md, t, 0, nr_zones,
> +				     dm_validate_zoned_model_cb, &zc);
> +	memalloc_noio_restore(noio_flag);
> +	if (ret != nr_zones ||
> +	    zc.nr_conv + zc.nr_seq != nr_zones)
> +		ret = -EIO;
> +	if (ret < 0)
> +		goto err;
> +
> +	if (!zc.nr_seq)
> +		disk_set_zoned(disk, BLK_ZONED_NONE);
> +
> +	return 0;
> +
> +err:
> +	DMERR("Validate zoned model failed %d", ret);
> +	dm_cleanup_zoned_dev(md);
> +	return ret;
> +}
> +
>  static int dm_zone_revalidate_cb(struct blk_zone *zone, unsigned int idx,
>  				 void *data)
>  {
> diff --git a/drivers/md/dm.h b/drivers/md/dm.h
> index 7f1acbf6bd9e..c3e6afed3910 100644
> --- a/drivers/md/dm.h
> +++ b/drivers/md/dm.h
> @@ -101,6 +101,7 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t);
>  /*
>   * Zoned targets related functions.
>   */
> +int dm_validate_zoned_model(struct dm_table *t, struct request_queue *q);
>  int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q);
>  void dm_zone_endio(struct dm_io *io, struct bio *clone);
>  #ifdef CONFIG_BLK_DEV_ZONED

-- 
Damien Le Moal
Western Digital Research

