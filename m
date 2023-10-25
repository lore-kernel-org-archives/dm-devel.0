Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44CFE27729
	for <dm-devel@lists.linux.dev>; Wed, 25 Oct 2023 15:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-66d264e67d8so34462766d6.1
        for <dm-devel@lists.linux.dev>; Wed, 25 Oct 2023 08:04:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698246240; x=1698851040;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SK4/YQIT8albfolpeQx6GIl47Xru+ciS4+6dOM2dMgc=;
        b=wDHi1YBLuv6HqJcYeOnIeuX1yrGsposFLZ4x/gRYgmZwjGbf/YvN8zlvAsQsWSiAXh
         z6dfZP0QkXKw0rDeApCmYIoDarrkmh8smxcL9s60ziTkT+wbMEGFxpxA3CtAdGU3LZtO
         9GbwwbqksjLfUOeEp2mIxBV+uWBP5ZKgizLpYtVHteI5dvtoNhCRECScBhcxd9COfN/G
         NkqK9gdXFngQgkLzanCJ+giETDijDPAqv70oIEloxiJ0BFpdOYlJXK0WCVVtE7DOs/AF
         THGShT02KrtPGnCyYALixSSfBXfusbbLoboQGIYHVv8CtOozHH8RqeVaU/5LXS5dawkU
         u/pg==
X-Gm-Message-State: AOJu0Yw0jXdBM2izz6ZpeTU1Y2v5HmqQKiNM6oho8NpqEDGxI/Hb4SVl
	7EMfbxf25GGVupN+WhdXgpDj
X-Google-Smtp-Source: AGHT+IHtQZTy6r7Jgq3Z20I1/38PK/hsPneCXkR6gy3CuNTWnrrXWEDcbxZI5/0M0H1Sk+crR1kCHw==
X-Received: by 2002:a05:6214:f01:b0:66d:37bc:bb91 with SMTP id gw1-20020a0562140f0100b0066d37bcbb91mr18624963qvb.56.1698246240065;
        Wed, 25 Oct 2023 08:04:00 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id jy12-20020a0562142b4c00b0065823d20381sm4472018qvb.8.2023.10.25.08.03.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Oct 2023 08:03:59 -0700 (PDT)
Date: Wed, 25 Oct 2023 11:03:58 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: dm-devel@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>
Subject: Re: [PATCH v2] dm: error: Add support for zoned block devices
Message-ID: <ZTkuXgLR1skoEOCc@redhat.com>
References: <20231025072332.465595-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231025072332.465595-1-dlemoal@kernel.org>

On Wed, Oct 25 2023 at  3:23P -0400,
Damien Le Moal <dlemoal@kernel.org> wrote:

> dm-error is used in several test cases in the xfstests test suite to
> check the handling of IO errors in file systems. However, with several
> file systems getting native support for zoned block devices (e.g. btrfs
> and f2fs), dm-error lack of zoned block device support creates problems
> as the file system attempt executing zone commands (e.g. a zone append
> operation) against a dm-error non-zoned block device, which causes
> various issues in the block layer (e.g. WARN_ON triggers).
> 
> This patch adds supports for zoned block devices to dm-error, allowing
> an error table to be exposed as a zoned block device. This is done by
> relying on the first argument passed to dmsetup when creating the device
> table: if that first argument is a path to a backing block device, the
> dm-error device is created by copying the limits of the backing device,
> thus also copying its zone model. This is consistent with how xfstests
> creates dm-error devices (always passing the path to the backing device
> as the first argument).
> 
> The zone support for dm-error requires the definition of the
> report_zones target type method, which is done by introducing the
> function io_err_report_zones(). Given that this function fails report
> zones operations (similarly to any other command issued to the dm-error
> device), dm_set_zones_restrictions() is tweaked to do nothing for a
> wildcard target to avoid failing zone revalidation. As the dm-error
> target does not implement the iterate_devices method,
> dm_table_supports_zoned_model() is also changed to return true.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Tested-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
> Changes from v1:
>  - Improved comment in io_err_ctr() about error from dm_get_device()
>    being ignored
>  - Fixed typos in the commit message
>  - Added review and tested-by tags

Thanks for the improvements. But likely a v3 is worthwhile.

Comment inlined below.

> 
>  drivers/md/dm-table.c  |  3 +++
>  drivers/md/dm-target.c | 45 ++++++++++++++++++++++++++++++++++++++++--
>  drivers/md/dm-zone.c   |  9 +++++++++
>  3 files changed, 55 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 37b48f63ae6a..5e4d887063d3 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -1600,6 +1600,9 @@ static bool dm_table_supports_zoned_model(struct dm_table *t,
>  	for (unsigned int i = 0; i < t->num_targets; i++) {
>  		struct dm_target *ti = dm_table_get_target(t, i);
>  
> +		if (dm_target_is_wildcard(ti->type))
> +			continue;
> +
>  		if (dm_target_supports_zoned_hm(ti->type)) {
>  			if (!ti->type->iterate_devices ||
>  			    ti->type->iterate_devices(ti, device_not_zoned_model,
> diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
> index 27e2992ff249..fcb2ba2bffa2 100644
> --- a/drivers/md/dm-target.c
> +++ b/drivers/md/dm-target.c
> @@ -118,6 +118,24 @@ EXPORT_SYMBOL(dm_unregister_target);
>   */
>  static int io_err_ctr(struct dm_target *tt, unsigned int argc, char **args)
>  {
> +	struct dm_dev *ddev;
> +	int ret;
> +
> +	/*
> +	 * If we have an argument, assume it is the path to the backing
> +	 * block device that we are replacing. In this case, get the device
> +	 * so that we can copy its limits in io_err_io_hints(). If getting the
> +	 * device fails (e.g. because the user did not specify a device file
> +	 * path), ignore the error to be compatible with the normal use case
> +	 * without any argument specified.
> +	 */
> +	if (argc) {
> +		ret = dm_get_device(tt, args[0], dm_table_get_mode(tt->table),
> +				    &ddev);
> +		if (ret == 0)
> +			tt->private = ddev;
> +	}
> +
>  	/*
>  	 * Return error for discards instead of -EOPNOTSUPP
>  	 */
>
> @@ -129,7 +147,10 @@ static int io_err_ctr(struct dm_target *tt, unsigned int argc, char **args)
>  
>  static void io_err_dtr(struct dm_target *tt)
>  {
> -	/* empty */
> +	struct dm_dev *ddev = tt->private;
> +
> +	if (ddev)
> +		dm_put_device(tt, ddev);
>  }
>  
>  static int io_err_map(struct dm_target *tt, struct bio *bio)
> @@ -149,8 +170,27 @@ static void io_err_release_clone_rq(struct request *clone,
>  {
>  }
>  
> +#ifdef CONFIG_BLK_DEV_ZONED
> +static int io_err_report_zones(struct dm_target *ti,
> +		struct dm_report_zones_args *args, unsigned int nr_zones)
> +{
> +	return -EIO;
> +}
> +#else
> +#define io_err_report_zones NULL
> +#endif
> +
>  static void io_err_io_hints(struct dm_target *ti, struct queue_limits *limits)
>  {
> +	struct dm_dev *ddev = ti->private;
> +
> +	/* If we have a target device, copy its limits */
> +	if (ddev) {
> +		struct request_queue *q = bdev_get_queue(ddev->bdev);
> +
> +		memcpy(limits, &q->limits, sizeof(*limits));
> +	}
> +
>  	limits->max_discard_sectors = UINT_MAX;
>  	limits->max_hw_discard_sectors = UINT_MAX;
>  	limits->discard_granularity = 512;


You don't need to explicitly copy the queue_limits, DM core
(dm-table.c:dm_calculate_queue_limits) will stack up the underlying
device's queue_limits as long as you implement io_err_iterate_devices
(like dm-linear.c:linear_iterate_devices).

With io_err_iterate_devices you shouldn't need to change
io_err_io_hints -- but actually I could see there being a need to wrap
setting the above no-device defaults only if (!ddev).. or:
	if (ddev)
		return;

Mike
