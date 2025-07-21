Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B52C238C1D
	for <dm-devel@lists.linux.dev>; Mon, 21 Jul 2025 20:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753128902; cv=none; b=O7RmgOU8yo1n40vPjt9zIbOsVKZVLAkhm3I/LMzYEf/82G7b3ghUCFjizU2gC4/OBZ6mAodxYEreRWw3OU2tC3ETUtadmT7X0Wu0qvTYpKEifZe8DJxx0v9L2VyhHd3Q49GKGAr+DQK1qjETfECnDuW88NzUyPEKdYw+IgBvXec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753128902; c=relaxed/simple;
	bh=4U+slSboXHsW6+5MWEOA5G518utqY099eMOyOV5YZ84=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=GfxlvwI50/3tiI5q95KH8doK40Cb4o8mO4VFY6/fW6y6r0eXdxWWlqCnt+il+DE1Qt0ihSEBjNJfaHAU5i49ZcKCt24NL475eTUyYPdhI6CZOIAQsBeuhIa0HCI39cLVUD23s84DRfMm2EGm9CmBjuu7rv6lXjsgiEJ1o4YvAA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h5tBenri; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h5tBenri"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753128899;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mYZKEdqgRvFGNOUG7NkuZ69kA4U0wg8LO6PmLUD9IFA=;
	b=h5tBenriG0AHIhVHPvm9oXkXBUR0KwVqgwjsZxZjhLIe4i2enlCqnRcCNSRD3U4KOVOGCI
	1Ylhg+TWmYqYlrDkuOqOO4sPOthmeGePgiw/4Lk4Xr1mrk5zQzWTSUZgQ8mwjbaj7/p48L
	Q0eTu97+qpejwUxP+YNL/+y0b0v2t8c=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-249-6aGBFA_uMmKyyMEYrFXGqg-1; Mon,
 21 Jul 2025 16:14:56 -0400
X-MC-Unique: 6aGBFA_uMmKyyMEYrFXGqg-1
X-Mimecast-MFC-AGG-ID: 6aGBFA_uMmKyyMEYrFXGqg_1753128894
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 91D8D1800283;
	Mon, 21 Jul 2025 20:14:53 +0000 (UTC)
Received: from [10.22.80.24] (unknown [10.22.80.24])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 87BB730001A4;
	Mon, 21 Jul 2025 20:14:49 +0000 (UTC)
Date: Mon, 21 Jul 2025 22:14:44 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Li Lingfeng <lilingfeng3@huawei.com>
cc: dm-devel@lists.linux.dev, agk@redhat.com, snitzer@kernel.org, 
    colin.i.king@gmail.com, linux-kernel@vger.kernel.org, houtao1@huawei.com, 
    yi.zhang@huawei.com, yangerkun@huawei.com, yukuai3@huawei.com, 
    chengzhihao1@huawei.com, lilingfeng@huaweicloud.com
Subject: Re: [PATCH] dm: introduce ima_lock to prevent concurrent calls to
 dm_ima_measure_* functions
In-Reply-To: <20250719164701.3147592-1-lilingfeng3@huawei.com>
Message-ID: <b93b1ce8-5f1b-6a25-092a-fa8573f8be1b@redhat.com>
References: <20250719164701.3147592-1-lilingfeng3@huawei.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Hi

I think that the race condition between dm_ima_measure_on_device_resume 
and dm_ima_measure_on_device_remove is still possible. The patch prevents 
it from triggering the use-after-free bug, but the race may still result 
in these two events being randomly swapped.

I think that a proper fix would be to move dm_ima_measure_on_device* calls 
to a position where device mapper locks are held, so that the calls will 
be serialized by the dm locks.

Would it be possible to move them inside down_write(&_hash_lock)? Or, 
would there be some problems with that?

Mikulas


On Sun, 20 Jul 2025, Li Lingfeng wrote:

> There is a window between freeing md->ima.active_table.hash and setting
> md->ima.active_table.hash to NULL in dm_ima_measure_on_device_resume().
> If dm_ima_measure_on_device_remove() accesses md->ima.active_table.hash
> concurrently during this window, it could lead to a double free or UAF,
> as shown below:
> 
> BUG: KASAN: slab-use-after-free in dm_ima_measure_on_device_remove...
> Read of size 71 at addr ffff88817bb9e220 by task dmsetup/2303
> 
> CPU: 2 UID: 0 PID: 2303 Comm: dmsetup Not tainted 6.16.0-rc6-dirty...
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3...
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x5b/0x80
>  print_address_description.constprop.0+0x88/0x310
>  print_report+0x12f/0x21d
>  kasan_report+0xcc/0x190
>  kasan_check_range+0x104/0x1b0
>  __asan_memcpy+0x23/0x60
>  dm_ima_measure_on_device_remove+0x3fc/0x6c0
>  dev_remove+0x123/0x1e0
>  ctl_ioctl+0x2a2/0x480
>  dm_ctl_ioctl+0xe/0x20
>  __x64_sys_ioctl+0xc7/0x110
>  do_syscall_64+0x72/0x390
>  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
> To reproduce this issue, add a delay between freeing
> md->ima.active_table.hash and setting it to NULL, using the following
> steps:
> dmsetup create mydevice --table "0 2097152 linear /dev/sda 0"
> dmsetup suspend mydevice
> dmsetup reload mydevice --table "0 2097152 linear /dev/sdb 0"
> dmsetup resume mydevice &
> dmsetup remove mydevice
> 
> Introduce ima_lock to prevent concurrent calls to dm_ima_measure_*
> functions to fix it.
> 
> Fixes: 91ccbbac1747 ("dm ima: measure data on table load")
> Signed-off-by: Li Lingfeng <lilingfeng3@huawei.com>
> ---
>  drivers/md/dm-core.h |  1 +
>  drivers/md/dm-ima.c  | 38 +++++++++++++++++++++++++++++++++-----
>  drivers/md/dm-ima.h  |  4 ++++
>  drivers/md/dm.c      |  3 ++-
>  4 files changed, 40 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
> index c889332e533b..24f321b2c2c4 100644
> --- a/drivers/md/dm-core.h
> +++ b/drivers/md/dm-core.h
> @@ -145,6 +145,7 @@ struct mapped_device {
>  #endif
>  
>  #ifdef CONFIG_IMA
> +	struct mutex ima_lock;
>  	struct dm_ima_measurements ima;
>  #endif
>  };
> diff --git a/drivers/md/dm-ima.c b/drivers/md/dm-ima.c
> index b90f34259fbb..0fefad6fbb9f 100644
> --- a/drivers/md/dm-ima.c
> +++ b/drivers/md/dm-ima.c
> @@ -164,7 +164,7 @@ static int dm_ima_alloc_and_copy_capacity_str(struct mapped_device *md, char **c
>  }
>  
>  /*
> - * Initialize/reset the dm ima related data structure variables.
> + * Reset the dm ima related data structure variables.
>   */
>  void dm_ima_reset_data(struct mapped_device *md)
>  {
> @@ -172,6 +172,23 @@ void dm_ima_reset_data(struct mapped_device *md)
>  	md->ima.dm_version_str_len = strlen(DM_IMA_VERSION_STR);
>  }
>  
> +/*
> + * Initialize the dm ima.
> + */
> +void dm_ima_init(struct mapped_device *md)
> +{
> +	dm_ima_reset_data(md);
> +	mutex_init(&md->ima_lock);
> +}
> +
> +/*
> + * Destroy the dm ima related data structure.
> + */
> +void dm_ima_destroy(struct mapped_device *md)
> +{
> +	mutex_destroy(&md->ima_lock);
> +}
> +
>  /*
>   * Build up the IMA data for each target, and finally measure.
>   */
> @@ -195,9 +212,10 @@ void dm_ima_measure_on_table_load(struct dm_table *table, unsigned int status_fl
>  	const size_t hash_alg_prefix_len = strlen(DM_IMA_TABLE_HASH_ALG) + 1;
>  	char table_load_event_name[] = "dm_table_load";
>  
> +	mutex_lock(&table->md->ima_lock);
>  	ima_buf = dm_ima_alloc(DM_IMA_MEASUREMENT_BUF_LEN, GFP_KERNEL, noio);
>  	if (!ima_buf)
> -		return;
> +		goto error;
>  
>  	target_metadata_buf = dm_ima_alloc(DM_IMA_TARGET_METADATA_BUF_LEN, GFP_KERNEL, noio);
>  	if (!target_metadata_buf)
> @@ -361,6 +379,7 @@ void dm_ima_measure_on_table_load(struct dm_table *table, unsigned int status_fl
>  	kfree(ima_buf);
>  	kfree(target_metadata_buf);
>  	kfree(target_data_buf);
> +	mutex_unlock(&table->md->ima_lock);
>  }
>  
>  /*
> @@ -376,9 +395,10 @@ void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap)
>  	bool nodata = true;
>  	int r;
>  
> +	mutex_lock(&md->ima_lock);
>  	device_table_data = dm_ima_alloc(DM_IMA_DEVICE_BUF_LEN, GFP_KERNEL, noio);
>  	if (!device_table_data)
> -		return;
> +		goto error;
>  
>  	r = dm_ima_alloc_and_copy_capacity_str(md, &capacity_str, noio);
>  	if (r)
> @@ -466,6 +486,7 @@ void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap)
>  error:
>  	kfree(capacity_str);
>  	kfree(device_table_data);
> +	mutex_unlock(&md->ima_lock);
>  }
>  
>  /*
> @@ -490,6 +511,7 @@ void dm_ima_measure_on_device_remove(struct mapped_device *md, bool remove_all)
>  	bool nodata = true;
>  	int r;
>  
> +	mutex_lock(&md->ima_lock);
>  	device_table_data = dm_ima_alloc(DM_IMA_DEVICE_BUF_LEN*2, GFP_KERNEL, noio);
>  	if (!device_table_data)
>  		goto exit;
> @@ -597,6 +619,7 @@ void dm_ima_measure_on_device_remove(struct mapped_device *md, bool remove_all)
>  
>  	kfree(dev_name);
>  	kfree(dev_uuid);
> +	mutex_unlock(&md->ima_lock);
>  }
>  
>  /*
> @@ -612,9 +635,10 @@ void dm_ima_measure_on_table_clear(struct mapped_device *md, bool new_map)
>  	bool nodata = true;
>  	int r;
>  
> +	mutex_lock(&md->ima_lock);
>  	device_table_data = dm_ima_alloc(DM_IMA_DEVICE_BUF_LEN, GFP_KERNEL, noio);
>  	if (!device_table_data)
> -		return;
> +		goto error;
>  
>  	r = dm_ima_alloc_and_copy_capacity_str(md, &capacity_str, noio);
>  	if (r)
> @@ -696,6 +720,8 @@ void dm_ima_measure_on_table_clear(struct mapped_device *md, bool new_map)
>  	kfree(capacity_str);
>  error1:
>  	kfree(device_table_data);
> +error:
> +	mutex_unlock(&md->ima_lock);
>  }
>  
>  /*
> @@ -708,9 +734,10 @@ void dm_ima_measure_on_device_rename(struct mapped_device *md)
>  	bool noio = true;
>  	int r;
>  
> +	mutex_lock(&md->ima_lock);
>  	if (dm_ima_alloc_and_copy_device_data(md, &new_device_data,
>  					      md->ima.active_table.num_targets, noio))
> -		return;
> +		goto error;
>  
>  	if (dm_ima_alloc_and_copy_name_uuid(md, &new_dev_name, &new_dev_uuid, noio))
>  		goto error;
> @@ -745,4 +772,5 @@ void dm_ima_measure_on_device_rename(struct mapped_device *md)
>  	kfree(old_device_data);
>  	kfree(new_dev_name);
>  	kfree(new_dev_uuid);
> +	mutex_unlock(&md->ima_lock);
>  }
> diff --git a/drivers/md/dm-ima.h b/drivers/md/dm-ima.h
> index 568870a1a145..36bbcf1b25a0 100644
> --- a/drivers/md/dm-ima.h
> +++ b/drivers/md/dm-ima.h
> @@ -57,6 +57,8 @@ struct dm_ima_measurements {
>  };
>  
>  void dm_ima_reset_data(struct mapped_device *md);
> +void dm_ima_init(struct mapped_device *md);
> +void dm_ima_destroy(struct mapped_device *md);
>  void dm_ima_measure_on_table_load(struct dm_table *table, unsigned int status_flags);
>  void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap);
>  void dm_ima_measure_on_device_remove(struct mapped_device *md, bool remove_all);
> @@ -66,6 +68,8 @@ void dm_ima_measure_on_device_rename(struct mapped_device *md);
>  #else
>  
>  static inline void dm_ima_reset_data(struct mapped_device *md) {}
> +static inline void dm_ima_init(struct mapped_device *md) {}
> +static inline void dm_ima_destroy(struct mapped_device *md) {}
>  static inline void dm_ima_measure_on_table_load(struct dm_table *table, unsigned int status_flags) {}
>  static inline void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap) {}
>  static inline void dm_ima_measure_on_device_remove(struct mapped_device *md, bool remove_all) {}
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 1726f0f828cc..b7eab324804c 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -2371,6 +2371,7 @@ static void free_dev(struct mapped_device *md)
>  	unlock_fs(md);
>  
>  	cleanup_mapped_device(md);
> +	dm_ima_destroy(md);
>  
>  	WARN_ON_ONCE(!list_empty(&md->table_devices));
>  	dm_stats_cleanup(&md->stats);
> @@ -2506,7 +2507,7 @@ int dm_create(int minor, struct mapped_device **result)
>  	if (!md)
>  		return -ENXIO;
>  
> -	dm_ima_reset_data(md);
> +	dm_ima_init(md);
>  
>  	*result = md;
>  	return 0;
> -- 
> 2.46.1

