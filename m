Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B1028AB10
	for <dm-devel@lists.linux.dev>; Tue, 22 Jul 2025 03:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753153432; cv=none; b=Vzhx3w68emI4Ojn4+uf17d3Jc8oVCDduTeNNvbQ0kyb7hRLpWuoQJwRcsPdnsIIuQmuhsIHSRGSsyKo7JtpXpmnW7rD+UfY7MPDy5PxxDicl8y2sKK1EMZ3tfRDlg6D6oWCcb9C8V5Dj23t2l4ft1xtXaDM4VswmIwI4oFarKYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753153432; c=relaxed/simple;
	bh=hMmymEb4BE8mTTTIsRb9rLQYTVMZXbhGvArb0PeX1Gs=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Ikm7DMuIJitLHZiLxFLVGVqVu0FSctMAAU58sOCk7xzOcCDBcM6aEzqRkFejOsiI7bEWXP69sDMZkHDU7f2IxdWfPchEN9ihSq4KRwed7IAM0lfFG894OWrMZ8Tzxlw1B7PO0Dwh3Cg0GCC/QGHFdJcnJbeHKK1a1UAyFQN1HjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4bmMY04NmTzKHMwc
	for <dm-devel@lists.linux.dev>; Tue, 22 Jul 2025 11:03:48 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 5345D1A1598
	for <dm-devel@lists.linux.dev>; Tue, 22 Jul 2025 11:03:47 +0800 (CST)
Received: from [10.174.177.163] (unknown [10.174.177.163])
	by APP3 (Coremail) with SMTP id _Ch0CgCHANt0_35o0fIzBA--.65316S2;
	Tue, 22 Jul 2025 11:03:47 +0800 (CST)
Subject: Re: [PATCH] dm: introduce ima_lock to prevent concurrent calls to
 dm_ima_measure_* functions
To: Mikulas Patocka <mpatocka@redhat.com>,
 Li Lingfeng <lilingfeng3@huawei.com>
Cc: dm-devel@lists.linux.dev, agk@redhat.com, snitzer@kernel.org,
 colin.i.king@gmail.com, linux-kernel@vger.kernel.org, yi.zhang@huawei.com,
 yangerkun@huawei.com, yukuai3@huawei.com, chengzhihao1@huawei.com,
 lilingfeng@huaweicloud.com, tusharsu@linux.microsoft.com
References: <20250719164701.3147592-1-lilingfeng3@huawei.com>
 <b93b1ce8-5f1b-6a25-092a-fa8573f8be1b@redhat.com>
From: Hou Tao <houtao@huaweicloud.com>
Message-ID: <0eb7e641-3e03-efd9-283b-83d64f0b70c9@huaweicloud.com>
Date: Tue, 22 Jul 2025 11:03:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <b93b1ce8-5f1b-6a25-092a-fa8573f8be1b@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-CM-TRANSID:_Ch0CgCHANt0_35o0fIzBA--.65316S2
X-Coremail-Antispam: 1UD129KBjvJXoW3Kw4xtFy8CFWUCr4xKrWfXwb_yoWkXFWxpa
	4DXFy5urWrJr4Iqw4UZ34j9F1Fvw4rKa1fGr4fAa4S9a43CryYvFyfAFWxZr98tFy2qFn7
	XF47trZ8ZF4DtFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU92b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7I2V7IY0VAS
	07AlzVAYIcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4
	IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1r
	MI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJV
	WUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j
	6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYx
	BIdaVFxhVjvjDU0xZFpf9x07UAwIDUUUUU=
X-CM-SenderInfo: xkrx3t3r6k3tpzhluzxrxghudrp/

Hi Mikulas,

On 7/22/2025 4:14 AM, Mikulas Patocka wrote:
> Hi
>
> I think that the race condition between dm_ima_measure_on_device_resume 
> and dm_ima_measure_on_device_remove is still possible. The patch prevents 
> it from triggering the use-after-free bug, but the race may still result 
> in these two events being randomly swapped.

Not exactly. After the invocation of dm_ima_measure_on_device_remove(),
the invocation of dm_ima_measure_on_device_resume will fail because both
the inactive and active tables have been cleared, the hash cell of has
been cleared (namely dm_get_mdptr() will return NULL), and
dm_ima_measure_on_device_resume() will fail when trying to invoke
dm_ima_alloc_and_copy_name_uuid(). However I agree that the lock can not
guarantee the order of the measure as shown below.
>
> I think that a proper fix would be to move dm_ima_measure_on_device* calls 
> to a position where device mapper locks are held, so that the calls will 
> be serialized by the dm locks.
>
> Would it be possible to move them inside down_write(&_hash_lock)? Or, 
> would there be some problems with that?
>
> Mikulas

Glad that you mention about the _hash_lock, because I have a pending
patch set (not completed yet) in which it uses _hash_lock to prevent the
potential out-of-order measure. Using _hash_lock() for
dm_ima_measure_on_table_clear() and dm_ima_measure_on_table_load() will
prevent the measure procedure measures an incorrect inactive table (or
other similar out-of-order) when there are concurrent table load and
clear processes as shown below:

1) load table X (set inactive table as V1)
2) clear table X
old_map = X
new_map = NULL
ready to invoke dm_ima_measure_on_table_clear(), but it is interrupted
by a concurrent load table Y
3) load table Y (set inactive table as V2)
4) clear table X (continue)
read inactive table V2 instead of V1

The tricky ones are dm_ima_measure_on_device_resume(). For
dm_ima_measure_on_device_resume(), using _hash_lock to protect the whole
resume procedure is a bad idea. Using _hash_lock to protect
dm_ima_measure_on_device_resume() is not enough as shown below:

1) load inactive_v1 / table X
2) resume table X
preempted before invoke dm_ima_measure_on_device_resume()
3) load inactive_v2 / table Y
4) resume table X (continue)
measure resume of inactive_v2 instead of inactive_v1

To prevent the out-of-order of dm_ima_measure_on_device_resume() and
_load()/_clear(), I think we need to track dm_ima_measurements in
dm_table, so when we load, clear and resume the table, we could know
which one to use. Will send the RFC patch set for further discussion.

>
>
> On Sun, 20 Jul 2025, Li Lingfeng wrote:
>
>> There is a window between freeing md->ima.active_table.hash and setting
>> md->ima.active_table.hash to NULL in dm_ima_measure_on_device_resume().
>> If dm_ima_measure_on_device_remove() accesses md->ima.active_table.hash
>> concurrently during this window, it could lead to a double free or UAF,
>> as shown below:
>>
>> BUG: KASAN: slab-use-after-free in dm_ima_measure_on_device_remove...
>> Read of size 71 at addr ffff88817bb9e220 by task dmsetup/2303
>>
>> CPU: 2 UID: 0 PID: 2303 Comm: dmsetup Not tainted 6.16.0-rc6-dirty...
>> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3...
>> Call Trace:
>>  <TASK>
>>  dump_stack_lvl+0x5b/0x80
>>  print_address_description.constprop.0+0x88/0x310
>>  print_report+0x12f/0x21d
>>  kasan_report+0xcc/0x190
>>  kasan_check_range+0x104/0x1b0
>>  __asan_memcpy+0x23/0x60
>>  dm_ima_measure_on_device_remove+0x3fc/0x6c0
>>  dev_remove+0x123/0x1e0
>>  ctl_ioctl+0x2a2/0x480
>>  dm_ctl_ioctl+0xe/0x20
>>  __x64_sys_ioctl+0xc7/0x110
>>  do_syscall_64+0x72/0x390
>>  entry_SYSCALL_64_after_hwframe+0x76/0x7e
>>
>> To reproduce this issue, add a delay between freeing
>> md->ima.active_table.hash and setting it to NULL, using the following
>> steps:
>> dmsetup create mydevice --table "0 2097152 linear /dev/sda 0"
>> dmsetup suspend mydevice
>> dmsetup reload mydevice --table "0 2097152 linear /dev/sdb 0"
>> dmsetup resume mydevice &
>> dmsetup remove mydevice
>>
>> Introduce ima_lock to prevent concurrent calls to dm_ima_measure_*
>> functions to fix it.
>>
>> Fixes: 91ccbbac1747 ("dm ima: measure data on table load")
>> Signed-off-by: Li Lingfeng <lilingfeng3@huawei.com>
>> ---
>>  drivers/md/dm-core.h |  1 +
>>  drivers/md/dm-ima.c  | 38 +++++++++++++++++++++++++++++++++-----
>>  drivers/md/dm-ima.h  |  4 ++++
>>  drivers/md/dm.c      |  3 ++-
>>  4 files changed, 40 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
>> index c889332e533b..24f321b2c2c4 100644
>> --- a/drivers/md/dm-core.h
>> +++ b/drivers/md/dm-core.h
>> @@ -145,6 +145,7 @@ struct mapped_device {
>>  #endif
>>  
>>  #ifdef CONFIG_IMA
>> +	struct mutex ima_lock;
>>  	struct dm_ima_measurements ima;
>>  #endif
>>  };
>> diff --git a/drivers/md/dm-ima.c b/drivers/md/dm-ima.c
>> index b90f34259fbb..0fefad6fbb9f 100644
>> --- a/drivers/md/dm-ima.c
>> +++ b/drivers/md/dm-ima.c
>> @@ -164,7 +164,7 @@ static int dm_ima_alloc_and_copy_capacity_str(struct mapped_device *md, char **c
>>  }
>>  
>>  /*
>> - * Initialize/reset the dm ima related data structure variables.
>> + * Reset the dm ima related data structure variables.
>>   */
>>  void dm_ima_reset_data(struct mapped_device *md)
>>  {
>> @@ -172,6 +172,23 @@ void dm_ima_reset_data(struct mapped_device *md)
>>  	md->ima.dm_version_str_len = strlen(DM_IMA_VERSION_STR);
>>  }
>>  
>> +/*
>> + * Initialize the dm ima.
>> + */
>> +void dm_ima_init(struct mapped_device *md)
>> +{
>> +	dm_ima_reset_data(md);
>> +	mutex_init(&md->ima_lock);
>> +}
>> +
>> +/*
>> + * Destroy the dm ima related data structure.
>> + */
>> +void dm_ima_destroy(struct mapped_device *md)
>> +{
>> +	mutex_destroy(&md->ima_lock);
>> +}
>> +
>>  /*
>>   * Build up the IMA data for each target, and finally measure.
>>   */
>> @@ -195,9 +212,10 @@ void dm_ima_measure_on_table_load(struct dm_table *table, unsigned int status_fl
>>  	const size_t hash_alg_prefix_len = strlen(DM_IMA_TABLE_HASH_ALG) + 1;
>>  	char table_load_event_name[] = "dm_table_load";
>>  
>> +	mutex_lock(&table->md->ima_lock);
>>  	ima_buf = dm_ima_alloc(DM_IMA_MEASUREMENT_BUF_LEN, GFP_KERNEL, noio);
>>  	if (!ima_buf)
>> -		return;
>> +		goto error;
>>  
>>  	target_metadata_buf = dm_ima_alloc(DM_IMA_TARGET_METADATA_BUF_LEN, GFP_KERNEL, noio);
>>  	if (!target_metadata_buf)
>> @@ -361,6 +379,7 @@ void dm_ima_measure_on_table_load(struct dm_table *table, unsigned int status_fl
>>  	kfree(ima_buf);
>>  	kfree(target_metadata_buf);
>>  	kfree(target_data_buf);
>> +	mutex_unlock(&table->md->ima_lock);
>>  }
>>  
>>  /*
>> @@ -376,9 +395,10 @@ void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap)
>>  	bool nodata = true;
>>  	int r;
>>  
>> +	mutex_lock(&md->ima_lock);
>>  	device_table_data = dm_ima_alloc(DM_IMA_DEVICE_BUF_LEN, GFP_KERNEL, noio);
>>  	if (!device_table_data)
>> -		return;
>> +		goto error;
>>  
>>  	r = dm_ima_alloc_and_copy_capacity_str(md, &capacity_str, noio);
>>  	if (r)
>> @@ -466,6 +486,7 @@ void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap)
>>  error:
>>  	kfree(capacity_str);
>>  	kfree(device_table_data);
>> +	mutex_unlock(&md->ima_lock);
>>  }
>>  
>>  /*
>> @@ -490,6 +511,7 @@ void dm_ima_measure_on_device_remove(struct mapped_device *md, bool remove_all)
>>  	bool nodata = true;
>>  	int r;
>>  
>> +	mutex_lock(&md->ima_lock);
>>  	device_table_data = dm_ima_alloc(DM_IMA_DEVICE_BUF_LEN*2, GFP_KERNEL, noio);
>>  	if (!device_table_data)
>>  		goto exit;
>> @@ -597,6 +619,7 @@ void dm_ima_measure_on_device_remove(struct mapped_device *md, bool remove_all)
>>  
>>  	kfree(dev_name);
>>  	kfree(dev_uuid);
>> +	mutex_unlock(&md->ima_lock);
>>  }
>>  
>>  /*
>> @@ -612,9 +635,10 @@ void dm_ima_measure_on_table_clear(struct mapped_device *md, bool new_map)
>>  	bool nodata = true;
>>  	int r;
>>  
>> +	mutex_lock(&md->ima_lock);
>>  	device_table_data = dm_ima_alloc(DM_IMA_DEVICE_BUF_LEN, GFP_KERNEL, noio);
>>  	if (!device_table_data)
>> -		return;
>> +		goto error;
>>  
>>  	r = dm_ima_alloc_and_copy_capacity_str(md, &capacity_str, noio);
>>  	if (r)
>> @@ -696,6 +720,8 @@ void dm_ima_measure_on_table_clear(struct mapped_device *md, bool new_map)
>>  	kfree(capacity_str);
>>  error1:
>>  	kfree(device_table_data);
>> +error:
>> +	mutex_unlock(&md->ima_lock);
>>  }
>>  
>>  /*
>> @@ -708,9 +734,10 @@ void dm_ima_measure_on_device_rename(struct mapped_device *md)
>>  	bool noio = true;
>>  	int r;
>>  
>> +	mutex_lock(&md->ima_lock);
>>  	if (dm_ima_alloc_and_copy_device_data(md, &new_device_data,
>>  					      md->ima.active_table.num_targets, noio))
>> -		return;
>> +		goto error;
>>  
>>  	if (dm_ima_alloc_and_copy_name_uuid(md, &new_dev_name, &new_dev_uuid, noio))
>>  		goto error;
>> @@ -745,4 +772,5 @@ void dm_ima_measure_on_device_rename(struct mapped_device *md)
>>  	kfree(old_device_data);
>>  	kfree(new_dev_name);
>>  	kfree(new_dev_uuid);
>> +	mutex_unlock(&md->ima_lock);
>>  }
>> diff --git a/drivers/md/dm-ima.h b/drivers/md/dm-ima.h
>> index 568870a1a145..36bbcf1b25a0 100644
>> --- a/drivers/md/dm-ima.h
>> +++ b/drivers/md/dm-ima.h
>> @@ -57,6 +57,8 @@ struct dm_ima_measurements {
>>  };
>>  
>>  void dm_ima_reset_data(struct mapped_device *md);
>> +void dm_ima_init(struct mapped_device *md);
>> +void dm_ima_destroy(struct mapped_device *md);
>>  void dm_ima_measure_on_table_load(struct dm_table *table, unsigned int status_flags);
>>  void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap);
>>  void dm_ima_measure_on_device_remove(struct mapped_device *md, bool remove_all);
>> @@ -66,6 +68,8 @@ void dm_ima_measure_on_device_rename(struct mapped_device *md);
>>  #else
>>  
>>  static inline void dm_ima_reset_data(struct mapped_device *md) {}
>> +static inline void dm_ima_init(struct mapped_device *md) {}
>> +static inline void dm_ima_destroy(struct mapped_device *md) {}
>>  static inline void dm_ima_measure_on_table_load(struct dm_table *table, unsigned int status_flags) {}
>>  static inline void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap) {}
>>  static inline void dm_ima_measure_on_device_remove(struct mapped_device *md, bool remove_all) {}
>> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
>> index 1726f0f828cc..b7eab324804c 100644
>> --- a/drivers/md/dm.c
>> +++ b/drivers/md/dm.c
>> @@ -2371,6 +2371,7 @@ static void free_dev(struct mapped_device *md)
>>  	unlock_fs(md);
>>  
>>  	cleanup_mapped_device(md);
>> +	dm_ima_destroy(md);
>>  
>>  	WARN_ON_ONCE(!list_empty(&md->table_devices));
>>  	dm_stats_cleanup(&md->stats);
>> @@ -2506,7 +2507,7 @@ int dm_create(int minor, struct mapped_device **result)
>>  	if (!md)
>>  		return -ENXIO;
>>  
>> -	dm_ima_reset_data(md);
>> +	dm_ima_init(md);
>>  
>>  	*result = md;
>>  	return 0;
>> -- 
>> 2.46.1
>
> .

