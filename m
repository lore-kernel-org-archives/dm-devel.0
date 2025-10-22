Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 814AC2F6183
	for <dm-devel@lists.linux.dev>; Wed, 22 Oct 2025 08:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761121299; cv=none; b=B5V1a1pqwqZUFuBQHFPJsTWAQWwPP8NRABocaYU4ahJc5pZikLwlQX9UZO6woGfqGzTROZneAdPyagoDaVy+cImzj65yz8nKL5awhNJnMHOK+e3gHec+apEOt+G5C4IujCjYyGSMX12jSfRZ8F9TdD5zCNakvr+fRryybLG4EzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761121299; c=relaxed/simple;
	bh=ZkLVJ4CPf+Od02T5p4UpDr1VbFhpdPQXCD2ro3NnE+Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=qyBUOWYJat89mscu+ZfR+R9DoqPs8bEI+Jdjf66oMesAvasisDZce+Z5DxmMWzB61aL5auNbcnC+btp/8nlBN8DnQbP05C5UJVMXbF3KpNTFZKMJ+AC6RZgdJCK0mec5pUoKE2+wI/aV4ZIRziow/VO1btbhfB/+tm3d3IIOQLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=PvJ7asxK; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="PvJ7asxK"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=27ELNbxEYhJODT7dorjM6ja6xnMNYxTKfYD+DwnBsm4=;
	b=PvJ7asxKUk9LiYCYVeCbhan0UIpdlA3kLQTgqcndPvDrIvp6v2L3UzxV66GcZcMrzj7mhRr6S
	DnyQuF1hAeGKzGEA3i+Pb2GqaQVx2SX0UvqYfuZspybbQrnjpyOWIsK5cd6q1m2coFyvCe3fs26
	lvq3cQ3cxp+Lppw9X01p6/Y=
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4cs2DP6YHyz12Ldj;
	Wed, 22 Oct 2025 16:20:53 +0800 (CST)
Received: from kwepemj200013.china.huawei.com (unknown [7.202.194.25])
	by mail.maildlp.com (Postfix) with ESMTPS id 20C2814010D;
	Wed, 22 Oct 2025 16:21:35 +0800 (CST)
Received: from [10.174.179.155] (10.174.179.155) by
 kwepemj200013.china.huawei.com (7.202.194.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 22 Oct 2025 16:21:34 +0800
Message-ID: <1767bec2-b660-42b2-b828-b221e0896eba@huawei.com>
Date: Wed, 22 Oct 2025 16:21:33 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: =?UTF-8?B?TW96aWxsYSBUaHVuZGVyYmlyZCDmtYvor5XniYg=?=
Subject: Re: [PATCH 5.10.y] dm: fix NULL pointer dereference in __dm_suspend()
To: Greg KH <gregkh@linuxfoundation.org>
CC: Sasha Levin <sashal@kernel.org>, <stable@vger.kernel.org>, Zheng Qixing
	<zhengqixing@huawei.com>, Mikulas Patocka <mpatocka@redhat.com>,
	<dm-devel@lists.linux.dev>, yangerkun <yangerkun@huawei.com>, "zhangyi (F)"
	<yi.zhang@huawei.com>, Hou Tao <houtao1@huawei.com>
References: <2025101316-favored-pulsate-a811@gregkh>
 <20251014030334.3868139-1-sashal@kernel.org>
 <cdadc001-3c0e-4152-8b05-08eb79fb528b@huawei.com>
 <2025102252-abrasive-glamorous-465b@gregkh>
From: Li Lingfeng <lilingfeng3@huawei.com>
In-Reply-To: <2025102252-abrasive-glamorous-465b@gregkh>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemj200013.china.huawei.com (7.202.194.25)

Hi,

在 2025/10/22 16:10, Greg KH 写道:
> On Wed, Oct 22, 2025 at 04:01:04PM +0800, Li Lingfeng wrote:
>> Hi,
>>
>> 在 2025/10/14 11:03, Sasha Levin 写道:
>>> From: Zheng Qixing <zhengqixing@huawei.com>
>>>
>>> [ Upstream commit 8d33a030c566e1f105cd5bf27f37940b6367f3be ]
>>>
>>> There is a race condition between dm device suspend and table load that
>>> can lead to null pointer dereference. The issue occurs when suspend is
>>> invoked before table load completes:
>>>
>>> BUG: kernel NULL pointer dereference, address: 0000000000000054
>>> Oops: 0000 [#1] PREEMPT SMP PTI
>>> CPU: 6 PID: 6798 Comm: dmsetup Not tainted 6.6.0-g7e52f5f0ca9b #62
>>> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.1-2.fc37 04/01/2014
>>> RIP: 0010:blk_mq_wait_quiesce_done+0x0/0x50
>>> Call Trace:
>>>     <TASK>
>>>     blk_mq_quiesce_queue+0x2c/0x50
>>>     dm_stop_queue+0xd/0x20
>>>     __dm_suspend+0x130/0x330
>>>     dm_suspend+0x11a/0x180
>>>     dev_suspend+0x27e/0x560
>>>     ctl_ioctl+0x4cf/0x850
>>>     dm_ctl_ioctl+0xd/0x20
>>>     vfs_ioctl+0x1d/0x50
>>>     __se_sys_ioctl+0x9b/0xc0
>>>     __x64_sys_ioctl+0x19/0x30
>>>     x64_sys_call+0x2c4a/0x4620
>>>     do_syscall_64+0x9e/0x1b0
>>>
>>> The issue can be triggered as below:
>>>
>>> T1 						T2
>>> dm_suspend					table_load
>>> __dm_suspend					dm_setup_md_queue
>>> 						dm_mq_init_request_queue
>>> 						blk_mq_init_allocated_queue
>>> 						=> q->mq_ops = set->ops; (1)
>>> dm_stop_queue / dm_wait_for_completion
>>> => q->tag_set NULL pointer!	(2)
>>> 						=> q->tag_set = set; (3)
>>>
>>> Fix this by checking if a valid table (map) exists before performing
>>> request-based suspend and waiting for target I/O. When map is NULL,
>>> skip these table-dependent suspend steps.
>>>
>>> Even when map is NULL, no I/O can reach any target because there is
>>> no table loaded; I/O submitted in this state will fail early in the
>>> DM layer. Skipping the table-dependent suspend logic in this case
>>> is safe and avoids NULL pointer dereferences.
>>>
>>> Fixes: c4576aed8d85 ("dm: fix request-based dm's use of dm_wait_for_completion")
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
>>> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>>> [ omitted DMF_QUEUE_STOPPED flag setting and braces absent in 5.15 ]
>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>>> ---
>>>    drivers/md/dm.c | 7 ++++---
>>>    1 file changed, 4 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
>>> index 0868358a7a8d2..b51281ce15d4c 100644
>>> --- a/drivers/md/dm.c
>>> +++ b/drivers/md/dm.c
>>> @@ -2457,7 +2457,7 @@ static int __dm_suspend(struct mapped_device *md, struct dm_table *map,
>>>    {
>>>    	bool do_lockfs = suspend_flags & DM_SUSPEND_LOCKFS_FLAG;
>>>    	bool noflush = suspend_flags & DM_SUSPEND_NOFLUSH_FLAG;
>>> -	int r;
>>> +	int r = 0;
>>>    	lockdep_assert_held(&md->suspend_lock);
>>> @@ -2509,7 +2509,7 @@ static int __dm_suspend(struct mapped_device *md, struct dm_table *map,
>>>    	 * Stop md->queue before flushing md->wq in case request-based
>>>    	 * dm defers requests to md->wq from md->queue.
>>>    	 */
>>> -	if (dm_request_based(md))
>>> +	if (map && dm_request_based(md))
>>>    		dm_stop_queue(md->queue);
>> It seems that before commit 80bd4a7aab4c ("blk-mq: move the srcu_struct
>> used for quiescing to the tagset") was merged, blk_mq_wait_quiesce_done()
>> would not attempt to access q->tag_set, so in dm_stop_queue() this kind
>> of race condition would not cause a null pointer dereference. The change
>> may not be necessary for 5.10, but adding it doesn’t appear to cause any
>> issues either.
>>>    	flush_workqueue(md->wq);
>>> @@ -2519,7 +2519,8 @@ static int __dm_suspend(struct mapped_device *md, struct dm_table *map,
>>>    	 * We call dm_wait_for_completion to wait for all existing requests
>>>    	 * to finish.
>>>    	 */
>>> -	r = dm_wait_for_completion(md, task_state);
>>> +	if (map)
>>> +		r = dm_wait_for_completion(md, task_state);
>> The fix tag c4576aed8d85 ("dm: fix request-based dm's use of
>> dm_wait_for_completion") seems to correspond to the modification of
>> dm_wait_for_completion().
>>>    	if (!r)
>>>    		set_bit(dmf_suspended_flag, &md->flags);
>> Perhaps adding another fix tag would be more appropriate?
> Those tags come directly from the original commit.
Thanks for the clarification. Since the patch has already been merged into
the mainline tree, we can't update the commit there. I was just wondering
if it would be acceptable to add an additional “Fixes” tag when applying
it to the stable branch, before merging.

Thanks,
Lingfeng.

>
