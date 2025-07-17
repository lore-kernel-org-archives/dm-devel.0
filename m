Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5ABA33086
	for <dm-devel@lists.linux.dev>; Thu, 17 Jul 2025 09:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752745397; cv=none; b=BNszeuig2mtGbUjOjl/U5ZUE0e6bjkTrGmB7uC4ZHPKSOB64GOCZhaQ6bbt5rc8AZpDkuKtPaTB1yuFfA4atpD/pIeMEXJrViW12nNjkVr/hi1DF9PJdD2tl+YPJVraX25u+Xfhr7+3pWF5gVVPwFlH2hPI9qVAkKmzV31ApFGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752745397; c=relaxed/simple;
	bh=+mA92FjzqTftsGVBO5wZq7CMWFfu4DpJmkiG1pcV3uc=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=f/kFZcwsH7sSTt2P0YVsZwOMbPvXxWuucJQ8lh5+JXbpnGdTMWL1qfen4LQEtM64oX7DXEcoOzil+V29dSNHuKOXuq6UTVps+V3b7Hq8wqILAcCQaRTJ8o4PeedGrH8TmemLkLdWcH34ZZ0aZGanpPc0PQdDzQ20F8UyBZG+J1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4bjSbd6MzHz2FbPx;
	Thu, 17 Jul 2025 17:41:01 +0800 (CST)
Received: from dggpemf100012.china.huawei.com (unknown [7.185.36.196])
	by mail.maildlp.com (Postfix) with ESMTPS id 0CB57140123;
	Thu, 17 Jul 2025 17:43:07 +0800 (CST)
Received: from [10.174.177.163] (10.174.177.163) by
 dggpemf100012.china.huawei.com (7.185.36.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 17 Jul 2025 17:43:05 +0800
Subject: Re: [PATCH] dm: introduce spinlocks to prevent concurrent usage and
 release of device_metadata and hash
To: Li Lingfeng <lilingfeng3@huawei.com>, <dm-devel@lists.linux.dev>
CC: <agk@redhat.com>, <snitzer@kernel.org>, <mpatocka@redhat.com>,
	<tusharsu@linux.microsoft.com>, <colin.i.king@gmail.com>,
	<linux-kernel@vger.kernel.org>, <yi.zhang@huawei.com>,
	<yangerkun@huawei.com>, <yukuai3@huawei.com>, <chengzhihao1@huawei.com>,
	<lilingfeng@huaweicloud.com>
References: <20250717140728.3221243-1-lilingfeng3@huawei.com>
From: Hou Tao <houtao1@huawei.com>
Message-ID: <5a29db22-13a9-f3ea-dbf2-13ce7f7aa649@huawei.com>
Date: Thu, 17 Jul 2025 17:43:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250717140728.3221243-1-lilingfeng3@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf100012.china.huawei.com (7.185.36.196)

Hi,

On 7/17/2025 10:07 PM, Li Lingfeng wrote:
> There is a window between freeing md->ima.active_table.hash and setting
> md->ima.active_table.hash to NULL in dm_ima_measure_on_device_resume().
> If dm_ima_measure_on_device_remove() accesses md->ima.active_table.hash
> concurrently during this window, it could lead to a double free or UAF,
> as shown below:

The UAF is a problem. However, I think the order of
dm_ima_measure_on_device_remove() and dm_ima_measure_on_device_resume is
bigger problem. Is it possible to order these two invocations properly
by using suspend_lock ?
>
> BUG: KASAN: slab-use-after-free in dm_ima_measure_on_device_remove+0x3fc/0x6c0
> Read of size 71 at addr ffff88817bb9e220 by task dmsetup/2303
>
> CPU: 2 UID: 0 PID: 2303 Comm: dmsetup Not tainted 6.16.0-rc6-dirty #7 PREEMPT(none)
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-2.fc40 04/01/2014
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
> The device_metadata also appears to have a similar issue.
> Add spinlocks for hash and device_metadata to prevent concurrent
> usage and release.

Instead of adding four spin-locks, how about only using one ?
>
> Fixes: 91ccbbac1747 ("dm ima: measure data on table load")
> Signed-off-by: Li Lingfeng <lilingfeng3@huawei.com>
> ---
>  drivers/md/dm-ima.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
>  drivers/md/dm-ima.h |  2 ++
>  2 files changed, 47 insertions(+)
>
> diff --git a/drivers/md/dm-ima.c b/drivers/md/dm-ima.c
> index b90f34259fbb..ff2ac54addb8 100644
> --- a/drivers/md/dm-ima.c
> +++ b/drivers/md/dm-ima.c
> @@ -170,6 +170,10 @@ void dm_ima_reset_data(struct mapped_device *md)
>  {
>  	memset(&(md->ima), 0, sizeof(md->ima));
>  	md->ima.dm_version_str_len = strlen(DM_IMA_VERSION_STR);
> +	spin_lock_init(&md->ima.active_table.device_metadata_lock);
> +	spin_lock_init(&md->ima.inactive_table.device_metadata_lock);
> +	spin_lock_init(&md->ima.active_table.hash_lock);
> +	spin_lock_init(&md->ima.inactive_table.hash_lock);
>  }
>  
>  /*
> @@ -336,19 +340,24 @@ void dm_ima_measure_on_table_load(struct dm_table *table, unsigned int status_fl
>  	for (i = 0; i < digest_size; i++)
>  		snprintf((digest_buf + hash_alg_prefix_len + (i*2)), 3, "%02x", digest[i]);
>  
> +	spin_lock(&table->md->ima.inactive_table.hash_lock);
>  	if (table->md->ima.active_table.hash != table->md->ima.inactive_table.hash)
>  		kfree(table->md->ima.inactive_table.hash);
>  
>  	table->md->ima.inactive_table.hash = digest_buf;
>  	table->md->ima.inactive_table.hash_len = strlen(digest_buf);
> +	spin_unlock(&table->md->ima.inactive_table.hash_lock);
> +
>  	table->md->ima.inactive_table.num_targets = num_targets;
>  
> +	spin_lock(&table->md->ima.inactive_table.device_metadata_lock);
>  	if (table->md->ima.active_table.device_metadata !=
>  	    table->md->ima.inactive_table.device_metadata)
>  		kfree(table->md->ima.inactive_table.device_metadata);
>  
>  	table->md->ima.inactive_table.device_metadata = device_data_buf;
>  	table->md->ima.inactive_table.device_metadata_len = device_data_buf_len;
> +	spin_unlock(&table->md->ima.inactive_table.device_metadata_lock);
>  
>  	goto exit;
>  error:
> @@ -388,18 +397,22 @@ void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap)
>  	l += md->ima.dm_version_str_len;
>  
>  	if (swap) {
> +		spin_lock(&md->ima.active_table.hash_lock);
>  		if (md->ima.active_table.hash != md->ima.inactive_table.hash)
>  			kfree(md->ima.active_table.hash);
>  
>  		md->ima.active_table.hash = NULL;
>  		md->ima.active_table.hash_len = 0;
> +		spin_unlock(&md->ima.active_table.hash_lock);
>  
> +		spin_lock(&md->ima.active_table.device_metadata_lock);
>  		if (md->ima.active_table.device_metadata !=
>  		    md->ima.inactive_table.device_metadata)
>  			kfree(md->ima.active_table.device_metadata);
>  
>  		md->ima.active_table.device_metadata = NULL;
>  		md->ima.active_table.device_metadata_len = 0;
> +		spin_unlock(&md->ima.active_table.device_metadata_lock);
>  		md->ima.active_table.num_targets = 0;
>  
>  		if (md->ima.inactive_table.hash) {
> @@ -429,6 +442,7 @@ void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap)
>  		nodata = false;
>  	}
>  
> +	spin_lock(&md->ima.active_table.hash_lock);
>  	if (md->ima.active_table.hash) {
>  		memcpy(device_table_data + l, active, active_len);
>  		l += active_len;
> @@ -442,6 +456,7 @@ void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap)
>  
>  		nodata = false;
>  	}
> +	spin_unlock(&md->ima.active_table.hash_lock);
>  
>  	if (nodata) {
>  		r = dm_ima_alloc_and_copy_name_uuid(md, &dev_name, &dev_uuid, noio);
> @@ -503,6 +518,7 @@ void dm_ima_measure_on_device_remove(struct mapped_device *md, bool remove_all)
>  	memcpy(device_table_data + l, DM_IMA_VERSION_STR, md->ima.dm_version_str_len);
>  	l += md->ima.dm_version_str_len;
>  
> +	spin_lock(&md->ima.active_table.device_metadata_lock);
>  	if (md->ima.active_table.device_metadata) {
>  		memcpy(device_table_data + l, device_active_str, device_active_len);
>  		l += device_active_len;
> @@ -513,7 +529,9 @@ void dm_ima_measure_on_device_remove(struct mapped_device *md, bool remove_all)
>  
>  		nodata = false;
>  	}
> +	spin_unlock(&md->ima.active_table.device_metadata_lock);
>  
> +	spin_lock(&md->ima.inactive_table.device_metadata_lock);
>  	if (md->ima.inactive_table.device_metadata) {
>  		memcpy(device_table_data + l, device_inactive_str, device_inactive_len);
>  		l += device_inactive_len;
> @@ -524,7 +542,9 @@ void dm_ima_measure_on_device_remove(struct mapped_device *md, bool remove_all)
>  
>  		nodata = false;
>  	}
> +	spin_unlock(&md->ima.inactive_table.device_metadata_lock);
>  
> +	spin_lock(&md->ima.active_table.hash_lock);
>  	if (md->ima.active_table.hash) {
>  		memcpy(device_table_data + l, active_table_str, active_table_len);
>  		l += active_table_len;
> @@ -538,7 +558,9 @@ void dm_ima_measure_on_device_remove(struct mapped_device *md, bool remove_all)
>  
>  		nodata = false;
>  	}
> +	spin_unlock(&md->ima.active_table.hash_lock);
>  
> +	spin_lock(&md->ima.inactive_table.hash_lock);
>  	if (md->ima.inactive_table.hash) {
>  		memcpy(device_table_data + l, inactive_table_str, inactive_table_len);
>  		l += inactive_table_len;
> @@ -552,6 +574,7 @@ void dm_ima_measure_on_device_remove(struct mapped_device *md, bool remove_all)
>  
>  		nodata = false;
>  	}
> +	spin_unlock(&md->ima.inactive_table.hash_lock);
>  	/*
>  	 * In case both active and inactive tables, and corresponding
>  	 * device metadata is cleared/missing - record the name and uuid
> @@ -582,17 +605,31 @@ void dm_ima_measure_on_device_remove(struct mapped_device *md, bool remove_all)
>  	kfree(device_table_data);
>  	kfree(capacity_str);
>  exit:
> +	spin_lock(&md->ima.active_table.device_metadata_lock);
> +	spin_lock(&md->ima.inactive_table.device_metadata_lock);
>  	kfree(md->ima.active_table.device_metadata);
>  
>  	if (md->ima.active_table.device_metadata !=
>  	    md->ima.inactive_table.device_metadata)
>  		kfree(md->ima.inactive_table.device_metadata);
>  
> +	md->ima.active_table.device_metadata = NULL;
> +	md->ima.inactive_table.device_metadata = NULL;
> +	spin_unlock(&md->ima.inactive_table.device_metadata_lock);
> +	spin_unlock(&md->ima.active_table.device_metadata_lock);
> +
> +	spin_lock(&md->ima.active_table.hash_lock);
> +	spin_lock(&md->ima.inactive_table.hash_lock);
>  	kfree(md->ima.active_table.hash);
>  
>  	if (md->ima.active_table.hash != md->ima.inactive_table.hash)
>  		kfree(md->ima.inactive_table.hash);
>  
> +	md->ima.active_table.hash = NULL;
> +	md->ima.inactive_table.hash = NULL;
> +	spin_unlock(&md->ima.inactive_table.hash_lock);
> +	spin_unlock(&md->ima.active_table.hash_lock);
> +
>  	dm_ima_reset_data(md);
>  
>  	kfree(dev_name);
> @@ -623,6 +660,8 @@ void dm_ima_measure_on_table_clear(struct mapped_device *md, bool new_map)
>  	memcpy(device_table_data + l, DM_IMA_VERSION_STR, md->ima.dm_version_str_len);
>  	l += md->ima.dm_version_str_len;
>  
> +	spin_lock(&md->ima.inactive_table.hash_lock);
> +	spin_lock(&md->ima.inactive_table.device_metadata_lock);
>  	if (md->ima.inactive_table.device_metadata_len &&
>  	    md->ima.inactive_table.hash_len) {
>  		memcpy(device_table_data + l, md->ima.inactive_table.device_metadata,
> @@ -642,6 +681,8 @@ void dm_ima_measure_on_table_clear(struct mapped_device *md, bool new_map)
>  
>  		nodata = false;
>  	}
> +	spin_unlock(&md->ima.inactive_table.device_metadata_lock);
> +	spin_unlock(&md->ima.inactive_table.hash_lock);
>  
>  	if (nodata) {
>  		if (dm_ima_alloc_and_copy_name_uuid(md, &dev_name, &dev_uuid, noio))
> @@ -660,19 +701,23 @@ void dm_ima_measure_on_table_clear(struct mapped_device *md, bool new_map)
>  	dm_ima_measure_data("dm_table_clear", device_table_data, l, noio);
>  
>  	if (new_map) {
> +		spin_lock(&md->ima.inactive_table.hash_lock);
>  		if (md->ima.inactive_table.hash &&
>  		    md->ima.inactive_table.hash != md->ima.active_table.hash)
>  			kfree(md->ima.inactive_table.hash);
>  
>  		md->ima.inactive_table.hash = NULL;
>  		md->ima.inactive_table.hash_len = 0;
> +		spin_unlock(&md->ima.inactive_table.hash_lock);
>  
> +		spin_lock(&md->ima.inactive_table.device_metadata_lock);
>  		if (md->ima.inactive_table.device_metadata &&
>  		    md->ima.inactive_table.device_metadata != md->ima.active_table.device_metadata)
>  			kfree(md->ima.inactive_table.device_metadata);
>  
>  		md->ima.inactive_table.device_metadata = NULL;
>  		md->ima.inactive_table.device_metadata_len = 0;
> +		spin_unlock(&md->ima.inactive_table.device_metadata_lock);
>  		md->ima.inactive_table.num_targets = 0;
>  
>  		if (md->ima.active_table.hash) {
> diff --git a/drivers/md/dm-ima.h b/drivers/md/dm-ima.h
> index 568870a1a145..a021056f4ab5 100644
> --- a/drivers/md/dm-ima.h
> +++ b/drivers/md/dm-ima.h
> @@ -35,6 +35,7 @@ struct dm_ima_device_table_metadata {
>  	 * pairs delimited by a semicolon at the end of the list.
>  	 */
>  	char *device_metadata;
> +	spinlock_t device_metadata_lock;
>  	unsigned int device_metadata_len;
>  	unsigned int num_targets;
>  
> @@ -43,6 +44,7 @@ struct dm_ima_device_table_metadata {
>  	 * attributes' key-value pairs from the active/inactive tables.
>  	 */
>  	char *hash;
> +	spinlock_t hash_lock;
>  	unsigned int hash_len;
>  };
>  

