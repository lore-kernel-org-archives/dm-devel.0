Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37391221F13
	for <dm-devel@lists.linux.dev>; Fri,  8 Aug 2025 07:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754638470; cv=none; b=dMR9uVZv9bu+WgBx241qXyXX+DtwIBTw2AzPznA49NMq3syPXOYx8BIuWBuF1H5ABLFlPIuXmcfcDUff5zezK7ddBPKOtMnF8BFXAXgbMPNJgFAaZTf28idgZQtq+F/UPUlSZ++Z1gMtFEaOmS8Qy/nvopg97gDzSft5DwY3R+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754638470; c=relaxed/simple;
	bh=mHA71hlwwplMD+0gYZPE6uPJrM2UMYmAtMyRfhMKcVg=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=mN4NhlGGf4XruOb5H1QW4VxXdCsm42PZTaqblDd6YGBIy3i0bfEeK/EPWA8/i6GNnfphWHHywlcLAb3iP+U8hJxyp3WIaMhhxE9o8wkrHQiEyc04TnKhfFjaxE2q82kCpqw6cRDfXy43v4+ooVEYmo2bApVIvZ8XPRUlRybYX+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4bywlQ5XfmzYQtps
	for <dm-devel@lists.linux.dev>; Fri,  8 Aug 2025 15:34:26 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 6A96D1A1BDD
	for <dm-devel@lists.linux.dev>; Fri,  8 Aug 2025 15:34:25 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgC3MxR_qJVogQjhCw--.38019S3;
	Fri, 08 Aug 2025 15:34:25 +0800 (CST)
Subject: Re: [PATCH v2] block: fix kobject double initialization in add_disk
To: Zheng Qixing <zhengqixing@huaweicloud.com>, axboe@kernel.dk
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 yi.zhang@huawei.com, yangerkun@huawei.com, houtao1@huawei.com,
 zhengqixing@huawei.com, lilingfeng3@huawei.com, nilay@linux.ibm.com,
 dm-devel@lists.linux.dev, mpatocka@redhat.com, snitzer@kernel.org,
 Alasdair Kergon <agk@redhat.com>, "yukuai (C)" <yukuai3@huawei.com>
References: <20250808053609.3237836-1-zhengqixing@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <03fe1a9c-ad5d-5417-9797-25fff9459e03@huaweicloud.com>
Date: Fri, 8 Aug 2025 15:34:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250808053609.3237836-1-zhengqixing@huaweicloud.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgC3MxR_qJVogQjhCw--.38019S3
X-Coremail-Antispam: 1UD129KBjvJXoWxXr47Wr1Duw15WFW8try7ZFb_yoWrZw1Dpr
	W5Jw47K3y8Kr4xW3y7A3W7ZFyxWws5Wr1xCrs3Kr9avrZIvrnIga1UGFy8ZF48Jr93uF4I
	qF4jqFZ8Kr18GrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBF14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x
	0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUZYFZUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

+CC device mappper, since this is a regerssion in this driver.

ÔÚ 2025/08/08 13:36, Zheng Qixing Ð´µÀ:
> From: Zheng Qixing <zhengqixing@huawei.com>
> 
> Device-mapper can call add_disk() multiple times for the same gendisk
> due to its two-phase creation process (dm create + dm load). This leads
> to kobject double initialization errors when the underlying iSCSI devices
> become temporarily unavailable and then reappear.
> 
> However, if the first add_disk() call fails and is retried, the queue_kobj
> gets initialized twice, causing:
> 
> kobject: kobject (ffff88810c27bb90): tried to init an initialized object,
> something is seriously wrong.
>   Call Trace:
>    <TASK>
>    dump_stack_lvl+0x5b/0x80
>    kobject_init.cold+0x43/0x51
>    blk_register_queue+0x46/0x280
>    add_disk_fwnode+0xb5/0x280
>    dm_setup_md_queue+0x194/0x1c0
>    table_load+0x297/0x2d0
>    ctl_ioctl+0x2a2/0x480
>    dm_ctl_ioctl+0xe/0x20
>    __x64_sys_ioctl+0xc7/0x110
>    do_syscall_64+0x72/0x390
>    entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
> Fix this by separating kobject initialization from sysfs registration:
>   - Initialize queue_kobj early during gendisk allocation
>   - add_disk() only adds the already-initialized kobject to sysfs
>   - del_gendisk() removes from sysfs but doesn't destroy the kobject
>   - Final cleanup happens when the disk is released
> 
> Fixes: 2bd85221a625 ("block: untangle request_queue refcounting from sysfs")
> Reported-by: Li Lingfeng <lilingfeng3@huawei.com>
> Closes: https://lore.kernel.org/all/83591d0b-2467-433c-bce0-5581298eb161@huawei.com/
> Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
> ---
>   block/blk-sysfs.c | 12 +++++-------
>   block/blk.h       |  1 +
>   block/genhd.c     |  2 ++
>   3 files changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> index 396cded255ea..c5cf79a20842 100644
> --- a/block/blk-sysfs.c
> +++ b/block/blk-sysfs.c
> @@ -847,7 +847,7 @@ static void blk_queue_release(struct kobject *kobj)
>   	/* nothing to do here, all data is associated with the parent gendisk */
>   }
>   
> -static const struct kobj_type blk_queue_ktype = {
> +const struct kobj_type blk_queue_ktype = {
>   	.default_groups = blk_queue_attr_groups,
>   	.sysfs_ops	= &queue_sysfs_ops,
>   	.release	= blk_queue_release,
> @@ -875,15 +875,14 @@ int blk_register_queue(struct gendisk *disk)
>   	struct request_queue *q = disk->queue;
>   	int ret;
>   
> -	kobject_init(&disk->queue_kobj, &blk_queue_ktype);
>   	ret = kobject_add(&disk->queue_kobj, &disk_to_dev(disk)->kobj, "queue");
>   	if (ret < 0)
> -		goto out_put_queue_kobj;
> +		return ret;
>   
>   	if (queue_is_mq(q)) {
>   		ret = blk_mq_sysfs_register(disk);
>   		if (ret)
> -			goto out_put_queue_kobj;
> +			goto out_del_queue_kobj;
>   	}
>   	mutex_lock(&q->sysfs_lock);
>   
> @@ -934,8 +933,8 @@ int blk_register_queue(struct gendisk *disk)
>   	mutex_unlock(&q->sysfs_lock);
>   	if (queue_is_mq(q))
>   		blk_mq_sysfs_unregister(disk);
> -out_put_queue_kobj:
> -	kobject_put(&disk->queue_kobj);
> +out_del_queue_kobj:
> +	kobject_del(&disk->queue_kobj);
>   	return ret;
>   }
>   
> @@ -986,5 +985,4 @@ void blk_unregister_queue(struct gendisk *disk)
>   		elevator_set_none(q);
>   
>   	blk_debugfs_remove(disk);
> -	kobject_put(&disk->queue_kobj);
>   }
> diff --git a/block/blk.h b/block/blk.h
> index 0a2eccf28ca4..46f566f9b126 100644
> --- a/block/blk.h
> +++ b/block/blk.h
> @@ -29,6 +29,7 @@ struct elevator_tags;
>   /* Max future timer expiry for timeouts */
>   #define BLK_MAX_TIMEOUT		(5 * HZ)
>   
> +extern const struct kobj_type blk_queue_ktype;
>   extern struct dentry *blk_debugfs_root;
>   
>   struct blk_flush_queue {
> diff --git a/block/genhd.c b/block/genhd.c
> index c26733f6324b..9bbc38d12792 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -1303,6 +1303,7 @@ static void disk_release(struct device *dev)
>   	disk_free_zone_resources(disk);
>   	xa_destroy(&disk->part_tbl);
>   
> +	kobject_put(&disk->queue_kobj);
>   	disk->queue->disk = NULL;
>   	blk_put_queue(disk->queue);
>   
> @@ -1486,6 +1487,7 @@ struct gendisk *__alloc_disk_node(struct request_queue *q, int node_id,
>   	INIT_LIST_HEAD(&disk->slave_bdevs);
>   #endif
>   	mutex_init(&disk->rqos_state_mutex);
> +	kobject_init(&disk->queue_kobj, &blk_queue_ktype);
>   	return disk;
>   
>   out_erase_part0:
> 

LGTM
Reviewed-by: Yu Kuai <yukuai3@huawei.com>

