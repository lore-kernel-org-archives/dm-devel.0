Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E13734191
	for <dm-devel@lists.linux.dev>; Wed, 25 Oct 2023 21:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c3++nJQZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28479C433C8;
	Wed, 25 Oct 2023 21:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698269679;
	bh=GrAk39kzBDIKr4nySxBvnGBj/guxxuD/a2vrSB14bpA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=c3++nJQZzCAwtkzBId/qlR/uYaytprNCVbAWlx2XcDEzD5BKwIOh3RrIYbURB3fK7
	 rUj5yLsMVjduYcO5RAOYSkKp9zYW6vgPAfBPvyzjhqvlus6ptMi+I84Ktp2WejcmC6
	 Qf43mAZYbCzK6RmMFTWOWAjRfDHJr6NLP79MqSntwJdewzANm8IygnVAFC8YUXHW9U
	 iOQHqyPHxYzfcex69ClerE6He6njAnd0O99mV2P5B+wCrkpQ9sGaSqK6+ZjoQ0DtWe
	 IYulKhGPnY4kCJhWq9YLuPqoQ/9nzhBKJS1CGQL/bmLpZ13iL7d1+xrohzR9etO/cQ
	 XA3fXbYYaGbww==
Message-ID: <b2aeab69-169b-4ccb-b7b3-39ebe3c6c733@kernel.org>
Date: Thu, 26 Oct 2023 06:34:38 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] dm: error: Add support for zoned block devices
Content-Language: en-US
To: Mike Snitzer <snitzer@kernel.org>
Cc: dm-devel@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 Naohiro Aota <naohiro.aota@wdc.com>
References: <20231025072332.465595-1-dlemoal@kernel.org>
 <ZTkuXgLR1skoEOCc@redhat.com>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <ZTkuXgLR1skoEOCc@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/26/23 00:03, Mike Snitzer wrote:
> On Wed, Oct 25 2023 at  3:23P -0400,
> Damien Le Moal <dlemoal@kernel.org> wrote:
> 
>> dm-error is used in several test cases in the xfstests test suite to
>> check the handling of IO errors in file systems. However, with several
>> file systems getting native support for zoned block devices (e.g. btrfs
>> and f2fs), dm-error lack of zoned block device support creates problems
>> as the file system attempt executing zone commands (e.g. a zone append
>> operation) against a dm-error non-zoned block device, which causes
>> various issues in the block layer (e.g. WARN_ON triggers).
>>
>> This patch adds supports for zoned block devices to dm-error, allowing
>> an error table to be exposed as a zoned block device. This is done by
>> relying on the first argument passed to dmsetup when creating the device
>> table: if that first argument is a path to a backing block device, the
>> dm-error device is created by copying the limits of the backing device,
>> thus also copying its zone model. This is consistent with how xfstests
>> creates dm-error devices (always passing the path to the backing device
>> as the first argument).
>>
>> The zone support for dm-error requires the definition of the
>> report_zones target type method, which is done by introducing the
>> function io_err_report_zones(). Given that this function fails report
>> zones operations (similarly to any other command issued to the dm-error
>> device), dm_set_zones_restrictions() is tweaked to do nothing for a
>> wildcard target to avoid failing zone revalidation. As the dm-error
>> target does not implement the iterate_devices method,
>> dm_table_supports_zoned_model() is also changed to return true.
>>
>> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> Tested-by: Christoph Hellwig <hch@lst.de>
>> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
>> ---
>> Changes from v1:
>>  - Improved comment in io_err_ctr() about error from dm_get_device()
>>    being ignored
>>  - Fixed typos in the commit message
>>  - Added review and tested-by tags
> 
> Thanks for the improvements. But likely a v3 is worthwhile.
> 
> Comment inlined below.
> 
>>
>>  drivers/md/dm-table.c  |  3 +++
>>  drivers/md/dm-target.c | 45 ++++++++++++++++++++++++++++++++++++++++--
>>  drivers/md/dm-zone.c   |  9 +++++++++
>>  3 files changed, 55 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
>> index 37b48f63ae6a..5e4d887063d3 100644
>> --- a/drivers/md/dm-table.c
>> +++ b/drivers/md/dm-table.c
>> @@ -1600,6 +1600,9 @@ static bool dm_table_supports_zoned_model(struct dm_table *t,
>>  	for (unsigned int i = 0; i < t->num_targets; i++) {
>>  		struct dm_target *ti = dm_table_get_target(t, i);
>>  
>> +		if (dm_target_is_wildcard(ti->type))
>> +			continue;
>> +
>>  		if (dm_target_supports_zoned_hm(ti->type)) {
>>  			if (!ti->type->iterate_devices ||
>>  			    ti->type->iterate_devices(ti, device_not_zoned_model,
>> diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
>> index 27e2992ff249..fcb2ba2bffa2 100644
>> --- a/drivers/md/dm-target.c
>> +++ b/drivers/md/dm-target.c
>> @@ -118,6 +118,24 @@ EXPORT_SYMBOL(dm_unregister_target);
>>   */
>>  static int io_err_ctr(struct dm_target *tt, unsigned int argc, char **args)
>>  {
>> +	struct dm_dev *ddev;
>> +	int ret;
>> +
>> +	/*
>> +	 * If we have an argument, assume it is the path to the backing
>> +	 * block device that we are replacing. In this case, get the device
>> +	 * so that we can copy its limits in io_err_io_hints(). If getting the
>> +	 * device fails (e.g. because the user did not specify a device file
>> +	 * path), ignore the error to be compatible with the normal use case
>> +	 * without any argument specified.
>> +	 */
>> +	if (argc) {
>> +		ret = dm_get_device(tt, args[0], dm_table_get_mode(tt->table),
>> +				    &ddev);
>> +		if (ret == 0)
>> +			tt->private = ddev;
>> +	}
>> +
>>  	/*
>>  	 * Return error for discards instead of -EOPNOTSUPP
>>  	 */
>>
>> @@ -129,7 +147,10 @@ static int io_err_ctr(struct dm_target *tt, unsigned int argc, char **args)
>>  
>>  static void io_err_dtr(struct dm_target *tt)
>>  {
>> -	/* empty */
>> +	struct dm_dev *ddev = tt->private;
>> +
>> +	if (ddev)
>> +		dm_put_device(tt, ddev);
>>  }
>>  
>>  static int io_err_map(struct dm_target *tt, struct bio *bio)
>> @@ -149,8 +170,27 @@ static void io_err_release_clone_rq(struct request *clone,
>>  {
>>  }
>>  
>> +#ifdef CONFIG_BLK_DEV_ZONED
>> +static int io_err_report_zones(struct dm_target *ti,
>> +		struct dm_report_zones_args *args, unsigned int nr_zones)
>> +{
>> +	return -EIO;
>> +}
>> +#else
>> +#define io_err_report_zones NULL
>> +#endif
>> +
>>  static void io_err_io_hints(struct dm_target *ti, struct queue_limits *limits)
>>  {
>> +	struct dm_dev *ddev = ti->private;
>> +
>> +	/* If we have a target device, copy its limits */
>> +	if (ddev) {
>> +		struct request_queue *q = bdev_get_queue(ddev->bdev);
>> +
>> +		memcpy(limits, &q->limits, sizeof(*limits));
>> +	}
>> +
>>  	limits->max_discard_sectors = UINT_MAX;
>>  	limits->max_hw_discard_sectors = UINT_MAX;
>>  	limits->discard_granularity = 512;
> 
> 
> You don't need to explicitly copy the queue_limits, DM core
> (dm-table.c:dm_calculate_queue_limits) will stack up the underlying
> device's queue_limits as long as you implement io_err_iterate_devices
> (like dm-linear.c:linear_iterate_devices).
> 
> With io_err_iterate_devices you shouldn't need to change
> io_err_io_hints -- but actually I could see there being a need to wrap
> setting the above no-device defaults only if (!ddev).. or:
> 	if (ddev)
> 		return;

Works for me, but I do not see how iterate_devices would work if there is no
backing device specified (current default). Am I missing something ? Also,
doesn't adding the iterate_devices method allow combining dm-error with other dm
targets in the same table, something that is not possible currently ? So that
would change dm-error usage. OK with me, but I want to make sure.
But it may be that I am missing something because of the wildcard flag. Is do
not fully understand how that one impacts anything. Is that flag responsible for
preventing dm-error to be combined with other targets ?

> 
> Mike
> 

-- 
Damien Le Moal
Western Digital Research

