Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741AD3101B8
	for <dm-devel@lists.linux.dev>; Wed, 22 Oct 2025 09:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761124451; cv=none; b=iX4aTlitHAIV0lPEYv03UgYIloBG+5w4gWdja1UClVtt9K8pQthEU+U42YwwjmjQtMjwz2wzGECQCkyDAPy4GRNr+Z2CvQipjHyg0PD6iJVIAXzoN7qJ2+Aq6qYRDTl7Oh8nH+VlBC6FdIqImEElV3VEW2QW4njVhnFcV/hv/Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761124451; c=relaxed/simple;
	bh=cnDVP3LL4LQdZ+QtTsXIhx4X1v93yq3hPbbrEUiDMa4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vy2vSen5+aNPP2GcIdQ9lDgPWtjGbmJ3llerQf+Po/nAIFEZcwmVetKeboPlVsfMG4rdw8HPO46s4XTdpn459L52/WcnJ9jK+LhAczBi54zCB0ImFUDhPWwvr4VXu+93O3LcS8HJUZZD0yaGMhlsLtrE+vRexoE0xmKgbOWggAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cs3Nl2HLRzYQv7M
	for <dm-devel@lists.linux.dev>; Wed, 22 Oct 2025 17:13:11 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 632F31A1B5B
	for <dm-devel@lists.linux.dev>; Wed, 22 Oct 2025 17:14:05 +0800 (CST)
Received: from [10.174.178.72] (unknown [10.174.178.72])
	by APP2 (Coremail) with SMTP id Syh0CgBXrERboPhoTRHfBA--.16399S3;
	Wed, 22 Oct 2025 17:14:05 +0800 (CST)
Message-ID: <0a3ace4a-3c0b-4672-8d96-dc456d5b06f0@huaweicloud.com>
Date: Wed, 22 Oct 2025 17:14:02 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10.y] dm: fix NULL pointer dereference in __dm_suspend()
To: Li Lingfeng <lilingfeng3@huawei.com>, Greg KH <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
 Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev,
 yangerkun <yangerkun@huawei.com>, "zhangyi (F)" <yi.zhang@huawei.com>,
 Hou Tao <houtao1@huawei.com>
References: <2025101316-favored-pulsate-a811@gregkh>
 <20251014030334.3868139-1-sashal@kernel.org>
 <cdadc001-3c0e-4152-8b05-08eb79fb528b@huawei.com>
 <2025102252-abrasive-glamorous-465b@gregkh>
 <1767bec2-b660-42b2-b828-b221e0896eba@huawei.com>
 <2025102212-pouring-embellish-95fc@gregkh>
 <28a7f62d-ae81-4629-864c-a0c1ecf98ee9@huawei.com>
From: Zheng Qixing <zhengqixing@huaweicloud.com>
In-Reply-To: <28a7f62d-ae81-4629-864c-a0c1ecf98ee9@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBXrERboPhoTRHfBA--.16399S3
X-Coremail-Antispam: 1UD129KBjvJXoWxKr18ZF45ZrWfJF43WrWxWFg_yoWxXw13pr
	4kGF1UKryrJr1kJw1Utr1DtryUtr45tw1UXr18JFy5Jw4qyr1Fqr1UXr1qgr18Cr48Jr1U
	Jr1UJry3Zw1UJw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUylb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAK
	I48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
	xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xII
	jxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x02
	67AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUF1v3UUUUU
X-CM-SenderInfo: x2kh0wptl0x03j6k3tpzhluzxrxghudrp/

Hi,

在 2025/10/22 17:10, Li Lingfeng 写道:
>
> 在 2025/10/22 16:45, Greg KH 写道:
>> On Wed, Oct 22, 2025 at 04:21:33PM +0800, Li Lingfeng wrote:
>>> Hi,
>>>
>>> 在 2025/10/22 16:10, Greg KH 写道:
>>>> On Wed, Oct 22, 2025 at 04:01:04PM +0800, Li Lingfeng wrote:
>>>>> Hi,
>>>>>
>>>>> 在 2025/10/14 11:03, Sasha Levin 写道:
>>>>>> From: Zheng Qixing <zhengqixing@huawei.com>
>>>>>>
>>>>>> [ Upstream commit 8d33a030c566e1f105cd5bf27f37940b6367f3be ]
>>>>>>
>>>>>> There is a race condition between dm device suspend and table 
>>>>>> load that
>>>>>> can lead to null pointer dereference. The issue occurs when 
>>>>>> suspend is
>>>>>> invoked before table load completes:
>>>>>>
>>>>>> BUG: kernel NULL pointer dereference, address: 0000000000000054
>>>>>> Oops: 0000 [#1] PREEMPT SMP PTI
>>>>>> CPU: 6 PID: 6798 Comm: dmsetup Not tainted 6.6.0-g7e52f5f0ca9b #62
>>>>>> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 
>>>>>> 1.16.1-2.fc37 04/01/2014
>>>>>> RIP: 0010:blk_mq_wait_quiesce_done+0x0/0x50
>>>>>> Call Trace:
>>>>>>      <TASK>
>>>>>>      blk_mq_quiesce_queue+0x2c/0x50
>>>>>>      dm_stop_queue+0xd/0x20
>>>>>>      __dm_suspend+0x130/0x330
>>>>>>      dm_suspend+0x11a/0x180
>>>>>>      dev_suspend+0x27e/0x560
>>>>>>      ctl_ioctl+0x4cf/0x850
>>>>>>      dm_ctl_ioctl+0xd/0x20
>>>>>>      vfs_ioctl+0x1d/0x50
>>>>>>      __se_sys_ioctl+0x9b/0xc0
>>>>>>      __x64_sys_ioctl+0x19/0x30
>>>>>>      x64_sys_call+0x2c4a/0x4620
>>>>>>      do_syscall_64+0x9e/0x1b0
>>>>>>
>>>>>> The issue can be triggered as below:
>>>>>>
>>>>>> T1                         T2
>>>>>> dm_suspend                    table_load
>>>>>> __dm_suspend                    dm_setup_md_queue
>>>>>>                         dm_mq_init_request_queue
>>>>>>                         blk_mq_init_allocated_queue
>>>>>>                         => q->mq_ops = set->ops; (1)
>>>>>> dm_stop_queue / dm_wait_for_completion
>>>>>> => q->tag_set NULL pointer!    (2)
>>>>>>                         => q->tag_set = set; (3)
>>>>>>
>>>>>> Fix this by checking if a valid table (map) exists before performing
>>>>>> request-based suspend and waiting for target I/O. When map is NULL,
>>>>>> skip these table-dependent suspend steps.
>>>>>>
>>>>>> Even when map is NULL, no I/O can reach any target because there is
>>>>>> no table loaded; I/O submitted in this state will fail early in the
>>>>>> DM layer. Skipping the table-dependent suspend logic in this case
>>>>>> is safe and avoids NULL pointer dereferences.
>>>>>>
>>>>>> Fixes: c4576aed8d85 ("dm: fix request-based dm's use of 
>>>>>> dm_wait_for_completion")
>>>>>> Cc: stable@vger.kernel.org
>>>>>> Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
>>>>>> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>>>>>> [ omitted DMF_QUEUE_STOPPED flag setting and braces absent in 5.15 ]
>>>>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>>>>>> ---
>>>>>>     drivers/md/dm.c | 7 ++++---
>>>>>>     1 file changed, 4 insertions(+), 3 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
>>>>>> index 0868358a7a8d2..b51281ce15d4c 100644
>>>>>> --- a/drivers/md/dm.c
>>>>>> +++ b/drivers/md/dm.c
>>>>>> @@ -2457,7 +2457,7 @@ static int __dm_suspend(struct 
>>>>>> mapped_device *md, struct dm_table *map,
>>>>>>     {
>>>>>>         bool do_lockfs = suspend_flags & DM_SUSPEND_LOCKFS_FLAG;
>>>>>>         bool noflush = suspend_flags & DM_SUSPEND_NOFLUSH_FLAG;
>>>>>> -    int r;
>>>>>> +    int r = 0;
>>>>>>         lockdep_assert_held(&md->suspend_lock);
>>>>>> @@ -2509,7 +2509,7 @@ static int __dm_suspend(struct 
>>>>>> mapped_device *md, struct dm_table *map,
>>>>>>          * Stop md->queue before flushing md->wq in case 
>>>>>> request-based
>>>>>>          * dm defers requests to md->wq from md->queue.
>>>>>>          */
>>>>>> -    if (dm_request_based(md))
>>>>>> +    if (map && dm_request_based(md))
>>>>>>             dm_stop_queue(md->queue);
>>>>> It seems that before commit 80bd4a7aab4c ("blk-mq: move the 
>>>>> srcu_struct
>>>>> used for quiescing to the tagset") was merged, 
>>>>> blk_mq_wait_quiesce_done()
>>>>> would not attempt to access q->tag_set, so in dm_stop_queue() this 
>>>>> kind
>>>>> of race condition would not cause a null pointer dereference. The 
>>>>> change
>>>>> may not be necessary for 5.10, but adding it doesn’t appear to 
>>>>> cause any
>>>>> issues either.
>>>>>> flush_workqueue(md->wq);
>>>>>> @@ -2519,7 +2519,8 @@ static int __dm_suspend(struct 
>>>>>> mapped_device *md, struct dm_table *map,
>>>>>>          * We call dm_wait_for_completion to wait for all 
>>>>>> existing requests
>>>>>>          * to finish.
>>>>>>          */
>>>>>> -    r = dm_wait_for_completion(md, task_state);
>>>>>> +    if (map)
>>>>>> +        r = dm_wait_for_completion(md, task_state);
>>>>> The fix tag c4576aed8d85 ("dm: fix request-based dm's use of
>>>>> dm_wait_for_completion") seems to correspond to the modification of
>>>>> dm_wait_for_completion().
>>>>>>         if (!r)
>>>>>>             set_bit(dmf_suspended_flag, &md->flags);
>>>>> Perhaps adding another fix tag would be more appropriate?
>>>> Those tags come directly from the original commit.
>>> Thanks for the clarification. Since the patch has already been 
>>> merged into
>>> the mainline tree, we can't update the commit there. I was just 
>>> wondering
>>> if it would be acceptable to add an additional “Fixes” tag when 
>>> applying
>>> it to the stable branch, before merging.
>> I can, if needed, can you please provide that line?
>
> Fixes: 80bd4a7aab4c ("blk-mq: move the srcu_struct used for quiescing 
> to the tagset")
>
> Thanks,
> Lingfeng
>

Thank you for adding a fix tag.

Qixing


>>
>> thanks,
>>
>> greg k-h
>>

