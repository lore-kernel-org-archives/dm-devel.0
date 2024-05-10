Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F446127B69
	for <dm-devel@lists.linux.dev>; Fri, 10 May 2024 14:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715350092; cv=none; b=D0lHcbEKfKEKLSY/bDmnJP9xG/7N7JkNNYZ/SCeektbmOwPtI2Aa6T8wSVRQwVv5Y6m6vLxgYMjUMiHi1fHscnbijgFwEmVrH363UU0LUwho+TIHGjSmShAf6IlZNmSW79hasFtyoOxkRi8XXrnwrzlqwJHYClaqmQ5hg1pA3ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715350092; c=relaxed/simple;
	bh=GY8QKF6N/5yxj3g4eHK9Mo7u5V+hozEk12ERqyApuWw=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=I0g71NceGt1lE0D6sFFEJE5xkcvWk15IxM+EODlGfCng0VqQJDapQK2MvVkwYW79X1QlVIAbcTBaMipGzQzoPfd+5p+d70OX3xAfGOV3A90M9jYWtsuXmjKRofKQ8tFZBQVzx8I0ZtvFjq4wGtUu3IWx/qNqNdyQhAusQggfOII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y6WFUWSM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y6WFUWSM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715350088;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=k8FkXX8ag030wY75AQZvmJGfyiDrhLTTaDh51EZd1JY=;
	b=Y6WFUWSMbNVbWOizvmyggdabcO5agkxEDOJXLVR4x+Zr/czvhAmOMNrTD/p+vgxn+xh/Ro
	6sbblsphGnxnDcONx0ke13m9hLTr8ddvVGIjCV+MyWuTxPoTAcyA4NlQsoBffbrROXbYtH
	t0FAnVCW/3QoXK1FxE3BLPgpCW0lI1Q=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-381-cJOXsvMFPxqCMZeoTfqDlg-1; Fri,
 10 May 2024 10:08:05 -0400
X-MC-Unique: cJOXsvMFPxqCMZeoTfqDlg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 35B6C1C02151;
	Fri, 10 May 2024 14:08:05 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2A58F49103D;
	Fri, 10 May 2024 14:08:05 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 03E1C30C1B93; Fri, 10 May 2024 14:08:04 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id F1CE43FB52;
	Fri, 10 May 2024 16:08:04 +0200 (CEST)
Date: Fri, 10 May 2024 16:08:04 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Yang Yang <yang.yang@vivo.com>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] dm: Avoid sending redundant empty flush bios to the
 same block device
In-Reply-To: <20240422100540.2213-1-yang.yang@vivo.com>
Message-ID: <1f741e4d-c33f-a2e3-f4dd-d7f613443534@redhat.com>
References: <20240422100540.2213-1-yang.yang@vivo.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

Hi

Regarding *bitmap = bitmap_zalloc(t->num_devices + 1, GFP_KERNEL); - you 
can't allocate memory in the I/O processing path, because it may deadlock. 
Think of a case when the system is out of memory and it needs to swap out 
some pages and the swap out operation attempts to allocate more memory.

Anyway, the patch is too complicated. I suggest to try this:

* introduce a per-target bit "flush_pass_around" that is set for dm-linear 
  and dm-stripe and that means that the target supports flush optimization

* set a per-table "flush_pass_around" bit if all the targets in the table 
  have "flush_pass_around" set

* in __send_empty_flush, test the table's "flush_pass_around" bit and if 
  it is set, bypass this loop "for (unsigned int i = 0; i < 
  t->num_targets; i++) {" and iterate over dm_table->devices and send the 
  flush to each of them.

Hopefully, these changes will make the patch smaller and more acceptable.

Mikulas



On Mon, 22 Apr 2024, Yang Yang wrote:

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
> 
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
> +
> +		/* dm_dev's index starts from 1, so need plus 1 here */
> +		*bitmap = bitmap_zalloc(t->num_devices + 1, GFP_KERNEL);
> +		if (*bitmap)
> +			return true;
> +	}
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
> +
> +			if (index > 0) {
> +				if (__test_and_set_bit(index, handled_map))
> +					continue;
> +				else
> +					nr_handled++;
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
>  };
>  
>  /*
> -- 
> 2.34.1
> 

