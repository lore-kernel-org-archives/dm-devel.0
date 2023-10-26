Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F25758F47
	for <dm-devel@lists.linux.dev>; Thu, 26 Oct 2023 02:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G9idvVih"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 562A9C433C7;
	Thu, 26 Oct 2023 02:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698286458;
	bh=qUC+7dmVjcgO7tA/NP59V8q50Ym3IVs5USDvM5m8Z/U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=G9idvVihiNAwowfl6YaLBp/mlqoHb3aRFoPIYsM7co7HALSIdSstL0lONAAGe+SCM
	 KhVoT/Ssc42/pi7uIvUearbVJS6wc6xim8cnLxknKhaSIZfRSABrZ4Hot3PQVJNZE3
	 68fmARqF52396lHC+/819UkcAlfHAfg2Ek+p1zzwe3MZw1v2859qfzway28KoLr+Ud
	 gSytusUFBwALXjvacbT8CCbOPSYIGTXaHUIP5rg+tmiQpLu1NEOxTVrZxWTsF5F0AM
	 svB6oku+Ks4UraatxgGcB+J+JK1vXa28c/acA5zEm3IHBbWbvuQrsLSw7hu+hPg/vo
	 itsYF2/OUWw+Q==
Message-ID: <bf3b7a61-40b1-477e-ada0-fa680c335057@kernel.org>
Date: Thu, 26 Oct 2023 11:14:17 +0900
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
 <b2aeab69-169b-4ccb-b7b3-39ebe3c6c733@kernel.org>
 <ZTmptAmDe+mMekV/@redhat.com>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <ZTmptAmDe+mMekV/@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/26/23 08:50, Mike Snitzer wrote:
> On Wed, Oct 25 2023 at  5:34P -0400,
> Damien Le Moal <dlemoal@kernel.org> wrote:
> 
>> On 10/26/23 00:03, Mike Snitzer wrote:
>>> On Wed, Oct 25 2023 at  3:23P -0400,
>>> Damien Le Moal <dlemoal@kernel.org> wrote:
>>>
>>>> dm-error is used in several test cases in the xfstests test suite to
>>>> check the handling of IO errors in file systems. However, with several
>>>> file systems getting native support for zoned block devices (e.g. btrfs
>>>> and f2fs), dm-error lack of zoned block device support creates problems
>>>> as the file system attempt executing zone commands (e.g. a zone append
>>>> operation) against a dm-error non-zoned block device, which causes
>>>> various issues in the block layer (e.g. WARN_ON triggers).
>>>>
>>>> This patch adds supports for zoned block devices to dm-error, allowing
>>>> an error table to be exposed as a zoned block device. This is done by
>>>> relying on the first argument passed to dmsetup when creating the device
>>>> table: if that first argument is a path to a backing block device, the
>>>> dm-error device is created by copying the limits of the backing device,
>>>> thus also copying its zone model. This is consistent with how xfstests
>>>> creates dm-error devices (always passing the path to the backing device
>>>> as the first argument).
>>>>
>>>> The zone support for dm-error requires the definition of the
>>>> report_zones target type method, which is done by introducing the
>>>> function io_err_report_zones(). Given that this function fails report
>>>> zones operations (similarly to any other command issued to the dm-error
>>>> device), dm_set_zones_restrictions() is tweaked to do nothing for a
>>>> wildcard target to avoid failing zone revalidation. As the dm-error
>>>> target does not implement the iterate_devices method,
>>>> dm_table_supports_zoned_model() is also changed to return true.
>>>>
>>>> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
>>>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>>>> Tested-by: Christoph Hellwig <hch@lst.de>
>>>> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
>>>> ---
>>>> Changes from v1:
>>>>  - Improved comment in io_err_ctr() about error from dm_get_device()
>>>>    being ignored
>>>>  - Fixed typos in the commit message
>>>>  - Added review and tested-by tags
>>>
>>> Thanks for the improvements. But likely a v3 is worthwhile.
>>>
>>> Comment inlined below.
>>>
>>>>
>>>>  drivers/md/dm-table.c  |  3 +++
>>>>  drivers/md/dm-target.c | 45 ++++++++++++++++++++++++++++++++++++++++--
>>>>  drivers/md/dm-zone.c   |  9 +++++++++
>>>>  3 files changed, 55 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
>>>> index 37b48f63ae6a..5e4d887063d3 100644
>>>> --- a/drivers/md/dm-table.c
>>>> +++ b/drivers/md/dm-table.c
>>>> @@ -1600,6 +1600,9 @@ static bool dm_table_supports_zoned_model(struct dm_table *t,
>>>>  	for (unsigned int i = 0; i < t->num_targets; i++) {
>>>>  		struct dm_target *ti = dm_table_get_target(t, i);
>>>>  
>>>> +		if (dm_target_is_wildcard(ti->type))
>>>> +			continue;
>>>> +
>>>>  		if (dm_target_supports_zoned_hm(ti->type)) {
>>>>  			if (!ti->type->iterate_devices ||
>>>>  			    ti->type->iterate_devices(ti, device_not_zoned_model,
>>>> diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
>>>> index 27e2992ff249..fcb2ba2bffa2 100644
>>>> --- a/drivers/md/dm-target.c
>>>> +++ b/drivers/md/dm-target.c
>>>> @@ -118,6 +118,24 @@ EXPORT_SYMBOL(dm_unregister_target);
>>>>   */
>>>>  static int io_err_ctr(struct dm_target *tt, unsigned int argc, char **args)
>>>>  {
>>>> +	struct dm_dev *ddev;
>>>> +	int ret;
>>>> +
>>>> +	/*
>>>> +	 * If we have an argument, assume it is the path to the backing
>>>> +	 * block device that we are replacing. In this case, get the device
>>>> +	 * so that we can copy its limits in io_err_io_hints(). If getting the
>>>> +	 * device fails (e.g. because the user did not specify a device file
>>>> +	 * path), ignore the error to be compatible with the normal use case
>>>> +	 * without any argument specified.
>>>> +	 */
>>>> +	if (argc) {
>>>> +		ret = dm_get_device(tt, args[0], dm_table_get_mode(tt->table),
>>>> +				    &ddev);
>>>> +		if (ret == 0)
>>>> +			tt->private = ddev;
>>>> +	}
>>>> +
>>>>  	/*
>>>>  	 * Return error for discards instead of -EOPNOTSUPP
>>>>  	 */
>>>>
>>>> @@ -129,7 +147,10 @@ static int io_err_ctr(struct dm_target *tt, unsigned int argc, char **args)
>>>>  
>>>>  static void io_err_dtr(struct dm_target *tt)
>>>>  {
>>>> -	/* empty */
>>>> +	struct dm_dev *ddev = tt->private;
>>>> +
>>>> +	if (ddev)
>>>> +		dm_put_device(tt, ddev);
>>>>  }
>>>>  
>>>>  static int io_err_map(struct dm_target *tt, struct bio *bio)
>>>> @@ -149,8 +170,27 @@ static void io_err_release_clone_rq(struct request *clone,
>>>>  {
>>>>  }
>>>>  
>>>> +#ifdef CONFIG_BLK_DEV_ZONED
>>>> +static int io_err_report_zones(struct dm_target *ti,
>>>> +		struct dm_report_zones_args *args, unsigned int nr_zones)
>>>> +{
>>>> +	return -EIO;
>>>> +}
>>>> +#else
>>>> +#define io_err_report_zones NULL
>>>> +#endif
>>>> +
>>>>  static void io_err_io_hints(struct dm_target *ti, struct queue_limits *limits)
>>>>  {
>>>> +	struct dm_dev *ddev = ti->private;
>>>> +
>>>> +	/* If we have a target device, copy its limits */
>>>> +	if (ddev) {
>>>> +		struct request_queue *q = bdev_get_queue(ddev->bdev);
>>>> +
>>>> +		memcpy(limits, &q->limits, sizeof(*limits));
>>>> +	}
>>>> +
>>>>  	limits->max_discard_sectors = UINT_MAX;
>>>>  	limits->max_hw_discard_sectors = UINT_MAX;
>>>>  	limits->discard_granularity = 512;
>>>
>>>
>>> You don't need to explicitly copy the queue_limits, DM core
>>> (dm-table.c:dm_calculate_queue_limits) will stack up the underlying
>>> device's queue_limits as long as you implement io_err_iterate_devices
>>> (like dm-linear.c:linear_iterate_devices).
>>>
>>> With io_err_iterate_devices you shouldn't need to change
>>> io_err_io_hints -- but actually I could see there being a need to wrap
>>> setting the above no-device defaults only if (!ddev).. or:
>>> 	if (ddev)
>>> 		return;
>>
>> Works for me, but I do not see how iterate_devices would work if there is no
>> backing device specified (current default). Am I missing something ?
> 
> You don't call 'fn' if the ddev (ti->private) is NULL.
> 
>> Also,
>> doesn't adding the iterate_devices method allow combining dm-error with other dm
>> targets in the same table, something that is not possible currently ? So that
>> would change dm-error usage. OK with me, but I want to make sure.
> 
> No, iterate_devices is purely for iterating within a given target's
> devices to call the provide 'fn'.
> 
> What I suggested doesn't change combining dm-error with other targets
> in the same table.  But we do allow that, think of a table with
> multiple linear targets and a subset that is the error target.

I was confused about that because my test script had a problem and was failing
to setup a dm-linear+dm-error combination. I now have that working and I can
check the combination.

So adding the iterate device now makes sense for the zone stuff. Will do that.

Thanks for the details. Sending a v3.

> 
>> But it may be that I am missing something because of the wildcard flag. Is do
>> not fully understand how that one impacts anything. Is that flag responsible for
>> preventing dm-error to be combined with other targets ?
> 
> /*
>  * Indicates that a target may replace any target; even immutable targets.
>  * .map, .map_rq, .clone_and_map_rq and .release_clone_rq are all defined.
>  */
> #define DM_TARGET_WILDCARD              0x00000008
> 
> Just means that the error target can replace all types of DM targets
> (its the only DM target that sets the DM_TARGET_WILDCARD flag).
> 
> Mike
> 

-- 
Damien Le Moal
Western Digital Research

