Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF7812F378
	for <dm-devel@lists.linux.dev>; Thu,  9 May 2024 14:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715264447; cv=none; b=YjzQpcA3XVbySZCEfFir5goDTYpC5SuJERaJ8mKkIVjdsUrh2dCIKedhu15kpCYYkbmyp4Z5aB27wlp0pjdKmFaLRsJQ+djc6RcClupURBxtSnpLza2jXuw7KvDhEPfZayRtv/b0xJcI5ZuZuDtMHVxE87oPXjg/q8bRzbEAxe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715264447; c=relaxed/simple;
	bh=eWWDGvbsDVngZYCUCH9ox5lJo7YaapwVrqzwIb2h2I8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vh2D8rmPmDkIMrtijGQSHMitU3qkMXGpowwKcpUNlBAtzCZUhGVG85+cUuuTZR5BGjMWFu/ISQNeqQNK/sqc2se2aqmJTtSV1xPAzd9pW8aN07TjT07pF2Xd+MOKuwBJBX4TCM+gsB6vsqkiZiEk0rNurJ/WxbtNkatqJbSVRSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=snitzer.net; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=snitzer.net
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-792bd1f5b28so69120185a.2
        for <dm-devel@lists.linux.dev>; Thu, 09 May 2024 07:20:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715264444; x=1715869244;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LI8zKzgShybSKm84oEfOTFsWuCr52KPccSGiUqMIups=;
        b=mBuvIK3YV6/Z5JJQUPtZthRp52Ts9QoXvR8Ot5QuYBtMZzMHtu36W4cR09BeS/2Sjq
         cBno2Aa+nfAgUcDwuL4bRr3lgctS1qarWW16M2zieJdw1ONsOR88gNjBD5O75lJUzk1M
         64J6ECE/h1Ihb7E2rM9jim4V2UdOpInG5GoC/JoQhLZt16dmLFWTkSrIKl4dsw+tnIhL
         Uw5xs0iX6eYiD44x+w1xEcXtkHnBDFm16SnJMnx3YumCNWx11RgzRKX1OvK7QX834aXs
         O2c/5md847QwVOUo8yL4y+6N8MSJnBSQIX2Nfs4aNbYFs7B6zTFSKHWYBHJNq8R6rSHY
         3KMA==
X-Forwarded-Encrypted: i=1; AJvYcCVpeA5BBHP9KYouVk8dXEbqp5MGsB+yvO2lwCdIJgtHgPvLOvBlGprfBbjOn9BhhcRhLCV4IzjjcF7gmsZuCPOxrTCV2aTDErk=
X-Gm-Message-State: AOJu0YyQW6mCGszhgwTbK4+zApoWPZbg/CUgXOprXEFaOPFOhNhW7Dbp
	3ehB5ch1Ukywmp+2M2WhVZkqlinclGO4WF17DiuZM/ySQjpiAa9tD54ZPmY2nJk=
X-Google-Smtp-Source: AGHT+IGEqgEoqCipeNchj0vk0VdEV8PUYIZbfhchERXbpltagFOdZQ7FxUe/n0jpmEpUCwvUPuHnvg==
X-Received: by 2002:a05:6214:268a:b0:6a0:a55b:9539 with SMTP id 6a1803df08f44-6a1514e4e6bmr65394296d6.60.1715264444246;
        Thu, 09 May 2024 07:20:44 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6a15f1d8368sm7320406d6.109.2024.05.09.07.20.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 May 2024 07:20:43 -0700 (PDT)
Date: Thu, 9 May 2024 10:20:42 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Yang Yang <yang.yang@vivo.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] dm: Avoid sending redundant empty flush bios to the
 same block device
Message-ID: <ZjzbuuGKqEJxScRY@redhat.com>
References: <20240422100540.2213-1-yang.yang@vivo.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240422100540.2213-1-yang.yang@vivo.com>

On Mon, Apr 22, 2024 at 06:05:40PM +0800, Yang Yang wrote:
> __send_empty_flush() sends empty flush bios to every target in the
> dm_table. However, if the num_targets exceeds the number of block
> devices in the dm_table's device list, it could lead to multiple
> invocations of __send_duplicate_bios() for the same block device.
> Typically, a single thread sending numerous empty flush bios to one
> block device is redundant, as these bios are likely to be merged by the
> flush state machine. In scenarios where num_targets significantly
> outweighs the number of block devices, such behavior may result in a
> noteworthy decrease in performance.
> 
> This issue can be reproduced using this command line:
>   for i in {0..1023}; do
>     echo $((8000*$i)) 8000 linear /dev/sda2 $((16384*$i))
>   done | dmsetup create example

Only _one_ dm_dev will be created for this example: /dev/sda2
So your bitmap is looking at a single bit.

> With this fix, a random write with fsync workload executed with the
> following fio command:
> 
>   fio --group_reporting --name=benchmark --filename=/dev/mapper/example \
>       --ioengine=sync --invalidate=1 --numjobs=16 --rw=randwrite \
>       --blocksize=4k --size=2G --time_based --runtime=30 --fdatasync=1
> 
> results in an increase from 857 KB/s to 30.8 MB/s of the write
> throughput (3580% increase).
> 
> Signed-off-by: Yang Yang <yang.yang@vivo.com>

I'm including my original fine-grained review comments inlined below
BUT, having wasted time reviewing this patch I'm left with the
conclusions:

1) this patch has serious issues.
2) it fixes an issue with a toy 'example' but ignores that not all
   targets are linear, each disparate target could have their own
   reason(s) for actually _needing_ the redundant flushes.

I'm inclined to never take this type of change.

> ---
>  drivers/md/dm-core.h          |  1 +
>  drivers/md/dm-table.c         |  7 +++++
>  drivers/md/dm.c               | 59 +++++++++++++++++++++++++++++++++++
>  include/linux/device-mapper.h |  6 ++++
>  4 files changed, 73 insertions(+)
> 
> diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
> index e6757a30dcca..7e3f2168289f 100644
> --- a/drivers/md/dm-core.h
> +++ b/drivers/md/dm-core.h
> @@ -217,6 +217,7 @@ struct dm_table {
>  	/* a list of devices used by this table */
>  	struct list_head devices;
>  	struct rw_semaphore devices_lock;
> +	unsigned short num_devices;
>  
>  	/* events get handed up using this callback */
>  	void (*event_fn)(void *data);
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 41f1d731ae5a..ddc60e498afb 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -2133,6 +2133,8 @@ void dm_table_postsuspend_targets(struct dm_table *t)
>  
>  int dm_table_resume_targets(struct dm_table *t)
>  {
> +	struct list_head *devices = dm_table_get_devices(t);
> +	struct dm_dev_internal *dd;
>  	unsigned int i;
>  	int r = 0;
>  
> @@ -2159,6 +2161,11 @@ int dm_table_resume_targets(struct dm_table *t)
>  			ti->type->resume(ti);
>  	}
>  
> +	t->num_devices = 0;
> +
> +	list_for_each_entry(dd, devices, list)
> +		dd->dm_dev->index = ++(t->num_devices);
> +
>  	return 0;
>  }
>  
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 56aa2a8b9d71..7297235291f6 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -48,6 +48,8 @@
>   */
>  #define REQ_DM_POLL_LIST	REQ_DRV
>  
> +#define DM_MAX_TABLE_DEVICES	1024
> +

This name is too general. This limit isn't imposed for anything other
than bounding the size of the bitmap used to avoid redundant flushes.

So maybe rename to: DM_MAX_REDUNDANT_FLUSH_BITMAP_DEVICES

>  static const char *_name = DM_NAME;
>  
>  static unsigned int major;
> @@ -1543,10 +1545,38 @@ static unsigned int __send_duplicate_bios(struct clone_info *ci, struct dm_targe
>  	return ret;
>  }
>  
> +static inline bool has_redundant_flush(struct dm_table *t,
> +		unsigned long **bitmap)
> +{
> +	if (t->num_devices < t->num_targets) {
> +		/* Add a limit here to prevent excessive memory usage for bitmaps */
> +		if (t->num_devices >= DM_MAX_TABLE_DEVICES)
> +			return false;

OK, in practice I'm not aware of tables that require such an excessive
amount of devices.

> +		/* dm_dev's index starts from 1, so need plus 1 here */
> +		*bitmap = bitmap_zalloc(t->num_devices + 1, GFP_KERNEL);
> +		if (*bitmap)
> +			return true;
> +	}

This method is being used in the IO path, so you cannot use
GFP_KERNEL.  Please switch to GFP_NOIO.

> +
> +	return false;
> +}
> +
> +static int dm_get_dev_index(struct dm_target *ti, struct dm_dev *dev,
> +				     sector_t start, sector_t len, void *data)
> +{
> +	unsigned short *index = data;
> +	*index = dev->index;
> +	return 0;
> +}
> +
>  static void __send_empty_flush(struct clone_info *ci)
>  {
>  	struct dm_table *t = ci->map;
>  	struct bio flush_bio;
> +	unsigned long *handled_map;

Please rename, e.g.: handled_devices_bitmap

> +	unsigned int nr_handled = 0;
> +	bool check = has_redundant_flush(t, &handled_map);
>  
>  	/*
>  	 * Use an on-stack bio for this, it's safe since we don't
> @@ -1562,17 +1592,46 @@ static void __send_empty_flush(struct clone_info *ci)
>  
>  	for (unsigned int i = 0; i < t->num_targets; i++) {
>  		unsigned int bios;
> +		unsigned short index = 0;
>  		struct dm_target *ti = dm_table_get_target(t, i);
>  
>  		if (unlikely(ti->num_flush_bios == 0))
>  			continue;
>  
> +		/*
> +		 * If the num_targets is greater than the number of block devices
> +		 * in the dm_table's devices list, __send_empty_flush() might
> +		 * invoke __send_duplicate_bios() multiple times for the same
> +		 * block device. This could lead to a substantial decrease in
> +		 * performance when num_targets significantly exceeds the number
> +		 * of block devices.
> +		 * Ensure that __send_duplicate_bios() is only called once for
> +		 * each block device.
> +		 */
> +		if (check) {
> +			if (nr_handled == t->num_devices)
> +				break;
> +
> +			if (ti->type->iterate_devices)
> +				ti->type->iterate_devices(ti, dm_get_dev_index, &index);

You're looping through all data devices in a target, so you're only
getting the last device in the target's index.  That seems very
broken.

But each target in your test 'example' device (mentioned in the patch
header) only has a single device so you wouldn't have noticed this.

> +
> +			if (index > 0) {
> +				if (__test_and_set_bit(index, handled_map))
> +					continue;
> +				else
> +					nr_handled++;

Think you really mean to set bits in the bitmap within the
iterate_devices callout.  So it should be renamed accordingly.

Why not count the first time a device is handled in nr_handled?
Also, it strikes me as strange that you're break'ing out this loop
early based on nr_handled... not seeing the point (and also it seems
broken, because it implies you aren't issuing flushes to targets at
the end).

> +			}
> +		}
> +
>  		atomic_add(ti->num_flush_bios, &ci->io->io_count);
>  		bios = __send_duplicate_bios(ci, ti, ti->num_flush_bios,
>  					     NULL, GFP_NOWAIT);
>  		atomic_sub(ti->num_flush_bios - bios, &ci->io->io_count);
>  	}
>  
> +	if (check)
> +		bitmap_free(handled_map);
> +
>  	/*
>  	 * alloc_io() takes one extra reference for submission, so the
>  	 * reference won't reach 0 without the following subtraction
> diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
> index 82b2195efaca..4a54b4f0a609 100644
> --- a/include/linux/device-mapper.h
> +++ b/include/linux/device-mapper.h
> @@ -169,6 +169,12 @@ struct dm_dev {
>  	struct dax_device *dax_dev;
>  	blk_mode_t mode;
>  	char name[16];
> +
> +	/*
> +	 * sequential number for each dm_dev in dm_table's devices list,
> +	 * start from 1
> +	 */
> +	unsigned short index;

Please update this comment to indicate that index=0 is (ab)used as a
flag in __send_empty_flush().
