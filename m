Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F991D2718
	for <dm-devel@lists.linux.dev>; Mon, 21 Oct 2024 07:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729495922; cv=none; b=YR2PZuUxJctibbI9DwBTDRWDgjkc3PzMme6oj/0YT/pVzhGpOsQoQ9eIwFHoU/bWQgpyQfgQdAO+nbpCQXLjwohUr7jSWwWMErhNmRhsNQc1Xb0FDyPL7VlgmMpu4Ykpd1Tv0FZKmSK/xpiPXo/MYbru7j5Iov68IqY3J4HyxfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729495922; c=relaxed/simple;
	bh=HFg0wBrt60ujLjDwC2GmRw++MSSdJuvXo+qbOrq3RcY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=IOO68TfB68SXTd4doGabD82I+H/GYACXB7lffQLHguYmKaGQo5aVnee9qCbmxhEeYScijGp7YLY3vJUSKNHsNC1Ki6Lug1d0CJskl3AmE2Dl0IJ/FBRC07Bq45r+P2rjqoS6wP8/31uYHlriMLI2/5uF0Z8nVfL6SEZ5MYrqf7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4XX6Mt0ndcz1HL9J;
	Mon, 21 Oct 2024 15:27:38 +0800 (CST)
Received: from kwepemg500017.china.huawei.com (unknown [7.202.181.81])
	by mail.maildlp.com (Postfix) with ESMTPS id B3F96140109;
	Mon, 21 Oct 2024 15:31:56 +0800 (CST)
Received: from [10.174.179.155] (10.174.179.155) by
 kwepemg500017.china.huawei.com (7.202.181.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 21 Oct 2024 15:31:55 +0800
Message-ID: <afacb6b6-71e7-f7a0-2503-fd054336f6bf@huawei.com>
Date: Mon, 21 Oct 2024 15:31:55 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101
 Thunderbird/104.0
Subject: Re: livelock caused by "dm: requeue IO if mapping table not yet
 available"
To: Mikulas Patocka <mpatocka@redhat.com>
CC: <zkabelac@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	<dm-devel@lists.linux.dev>, Hou Tao <houtao1@huawei.com>, yangerkun
	<yangerkun@huawei.com>, "yukuai (C)" <yukuai3@huawei.com>, "zhangyi (F)"
	<yi.zhang@huawei.com>
References: <45c0226e-d28c-974b-17ab-e161dd784306@redhat.com>
From: Li Lingfeng <lilingfeng3@huawei.com>
In-Reply-To: <45c0226e-d28c-974b-17ab-e161dd784306@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemg500017.china.huawei.com (7.202.181.81)

Hi Mikulas
As described by Zhang Yi in [1], we found the following NULL pointer
dereference problem:
multipath -v2                  mount
ioctl(DM_DEV_CREATE_CMD)
ioctl(DM_TABLE_LOAD_CMD)
                                read super block
                                 blk_mq_dispatch_rq_list()
                                  dm_mq_queue_rq()
                                   md->immutable_target is NULL;
                                   map = dm_get_live_table() //NULL Pointer
ioctl(DM_DEV_SUSPEND_CMD)
__bind()
  set new map
  set md->immutable_target

At that time, Mike solved the problem by adding a check for whether the
map was NULL in dm_mq_queue_rq [2].

Commit c8691cd0fc11("Revert "dm: requeue IO if mapping table not yet
available"") only rolled back part of the changes and still retains the
validation for whether the map is NULL, so the above issue can still be
resolved [3].

We also noticed this loop problem, but I would prefer to requeue the IO
instead of error the IO in this case, as Mike suggested in [4].

Here's my modification, any suggestion will be appreciated:

After DM_DEV_CREATE_CMD and DM_TABLE_LOAD_CMD, users can issue IO to dm
device. However, IO can't be done since map is still NULL and it will be
submitted again by kworker.
Leave IO in the deferred list when the map is NULL to prevent IO from
being repeatedly resubmitted until the map is ready.

Signed-off-by: Li Lingfeng <lilingfeng3@huawei.com>
---
  drivers/md/dm.c | 6 ++++++
  1 file changed, 6 insertions(+)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 87bb90303435..6d360c61a3fb 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2779,6 +2779,12 @@ static void dm_wq_work(struct work_struct *work)
  {
      struct mapped_device *md = container_of(work, struct 
mapped_device, work);
      struct bio *bio;
+    struct dm_table *map;
+
+    map = dm_get_live_table_fast(md);
+    dm_put_live_table_fast(md);
+    if (!map)
+        return;

      while (!test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags)) {
          spin_lock_irq(&md->deferred_lock);

[1] 
https://lore.kernel.org/all/20220209093751.2986716-1-yi.zhang@huawei.com/
[2] 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?h=v6.12-rc4&id=fa247089de9936a46e290d4724cb5f0b845600f5
[3] 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?h=v6.12-rc4&id=c8691cd0fc11197515ed148de0780d927bfca38b
[4] https://lore.kernel.org/all/YhUrH7UfBN3Uw5HP@redhat.com/

在 2024/9/11 3:00, Mikulas Patocka 写道:
> Hi
>
> The commit fa247089de9936a46e290d4724cb5f0b845600f5 ("dm: requeue IO if
> mapping table not yet available") causes a regression. It can be
> reproduced with this script (Zdenek hit it in his testing):
>
> # dmsetup create --notable test
> # truncate -s 1MiB testdata
> # losetup /dev/loop0 testdata
> # dmsetup load test --table '0 2048 linear /dev/loop0 0'
> # dd if=/dev/zero of=/dev/dm-0 bs=16k count=1 conv=fdatasync
>
> When you run the script, there will be a workqueue process looping and
> consuming 100% CPU. When you suspend and resume the device "test", the
> loop ends.
>
>
> The reason for the bug is this - dm_submit_bio sees that map is NULL, so
> it offloads the bio using the function queue_io.
>
> queue_io adds the bio to md->deferred and kicks the workqueue with
> "queue_work(md->wq, &md->work);"
>
> dm_wq_work sees that test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags) is
> false, so it pops the bio from md->deferred and submits it with
> submit_bio_noacct.
>
> submit_bio_noacct goes back to dm_submit_bio and we have a loop.
>
>
> The commit fa247089de9936a46e290d4724cb5f0b845600f5 says that it fixes
> some race condition, however I don't quite know what the race condition
> is. Did the race condition really happen in your testing? What
> configuration did you use when you hit this race? Or do you just think
> that this is racy without hitting it?
>
> Note that when you load a dm table for the first time, the nodes /dev/dm-0
> and /sys/block/dm-0 are created. When you suspend and resume the device,
> the node /dev/mapper/test is created. When udev does its work, the nodes
> in /dev/disk/*/ are created.
>
> In order to hit this race condition, you must have some program that opens
> /dev/dm-0 early, without synchronizing with lvm or udev. Do you have a
> program that does it?
>
> Also note, that when /dev/dm-0 is created, it has size 0, so that all
> reads and writes to it are automatically rejected by the upper layers. The
> only accepted bio is flush, which causes this livelock. So (from
> userspace) you can't do anything meaningful with the device at this point.
>
> Mikulas
>
>
