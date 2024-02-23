Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C721560B9E
	for <dm-devel@lists.linux.dev>; Fri, 23 Feb 2024 10:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708684314; cv=none; b=n2dRPO/nyEnmJ3I8IQGS52hnxbC6OUz1I8VdYCdyfWnEXz4ghhsr1n1s3P5vTyMAfHCoU5Zuj0K3P7zm8LOUilvYihE7spDL7HXDbajCRSS4HXUadSB1cjLgyEjobkWO1/QFero2EMg8W3qmTZYPDHT9EU34zkjUIP0rC6i1XTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708684314; c=relaxed/simple;
	bh=wwYj+tUb+2grxbm0MOHODkysuIXxCXc9HyduK0/kDtk=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=H3zKwDPLHzA3c7+EYw9o9jYIsUAyv06EwRKPuR9CjU9VwTDSRkSMl79vAYq/JvoggOU3wrE9DIqjkGs26LBasclF2PaZwpzCCqwQrUCQkk1dzzQLMndYMRXRZWUAoOkl2G86B1tyNzcGKPoGxKmepzOG5GkdtVzkoW2cIfJdMlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Th5sL6NBkz4f3nKH
	for <dm-devel@lists.linux.dev>; Fri, 23 Feb 2024 18:31:34 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 167221A0232
	for <dm-devel@lists.linux.dev>; Fri, 23 Feb 2024 18:31:42 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgAX5g4MdNhly_WWEw--.54101S3;
	Fri, 23 Feb 2024 18:31:41 +0800 (CST)
Subject: Re: [PATCH RFC 1/4] dm-raid/md: Clear MD_RECOVERY_WAIT when stopping
 dmraid
To: Xiao Ni <xni@redhat.com>, song@kernel.org
Cc: yukuai1@huaweicloud.com, bmarzins@redhat.com, heinzm@redhat.com,
 snitzer@kernel.org, ncroxon@redhat.com, neilb@suse.de,
 linux-raid@vger.kernel.org, dm-devel@lists.linux.dev,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20240220153059.11233-1-xni@redhat.com>
 <20240220153059.11233-2-xni@redhat.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <6e5a98ae-1e7d-ea1f-521d-893d9207a132@huaweicloud.com>
Date: Fri, 23 Feb 2024 18:31:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240220153059.11233-2-xni@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgAX5g4MdNhly_WWEw--.54101S3
X-Coremail-Antispam: 1UD129KBjvJXoWxXrWUAry8Xr4rGr4rXr1DWrg_yoW5Kr43pa
	yUXFy5Zw4UArWUZF9rt3Wvqa4Fq3WYqFWYkry3C34rA3Z0k3WfWFW7KFy5WFWDAFyfJa1U
	Aa15Ja9xZasYkrJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9014x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY
	04v7Mxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7
	v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF
	1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIx
	AIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0D
	MIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIda
	VFxhVjvjDU0xZFpf9x0JUdHUDUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2024/02/20 23:30, Xiao Ni Ð´µÀ:
> MD_RECOVERY_WAIT is used by dmraid to delay reshape process by patch
> commit 644e2537fdc7 ("dm raid: fix stripe adding reshape deadlock").
> Before patch commit f52f5c71f3d4b ("md: fix stopping sync thread")
> dmraid stopped sync thread directy by calling md_reap_sync_thread.
> After this patch dmraid stops sync thread asynchronously as md does.
> This is right. Now the dmraid stop process is like this:
> 
> 1. raid_postsuspend->md_stop_writes->__md_stop_writes->stop_sync_thread.
> stop_sync_thread sets MD_RECOVERY_INTR and wait until MD_RECOVERY_RUNNING
> is cleared
> 2. md_do_sync finds MD_RECOVERY_WAIT is set and return. (This is the
> root cause for this deadlock. We hope md_do_sync can set MD_RECOVERY_DONE)
> 3. md thread calls md_check_recovery (This is the place to reap sync
> thread. Because MD_RECOVERY_DONE is not set. md thread can't reap sync
> thread)
> 4. raid_dtr stops/free struct mddev and release dmraid related resources
> 
> dmraid only sets MD_RECOVERY_WAIT but doesn't clear it. It needs to clear
> this bit when stopping the dmraid before stopping sync thread.
> 
> But the deadlock still can happen sometimes even MD_RECOVERY_WAIT is
> cleared before stopping sync thread. It's the reason stop_sync_thread only
> wakes up task. If the task isn't running, it still needs to wake up sync
> thread too.
> 
> This deadlock can be reproduced 100% by these commands:
> modprobe brd rd_size=34816 rd_nr=5
> while [ 1 ]; do
> vgcreate test_vg /dev/ram*
> lvcreate --type raid5 -L 16M -n test_lv test_vg
> lvconvert -y --stripes 4 /dev/test_vg/test_lv
> vgremove test_vg -ff
> sleep 1
> done
> 
> Fixes: 644e2537fdc7 ("dm raid: fix stripe adding reshape deadlock")
> Fixes: f52f5c71f3d4 ("md: fix stopping sync thread")
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>   drivers/md/dm-raid.c | 2 ++
>   drivers/md/md.c      | 1 +
>   2 files changed, 3 insertions(+)
> 
> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> index eb009d6bb03a..325767c1140f 100644
> --- a/drivers/md/dm-raid.c
> +++ b/drivers/md/dm-raid.c
> @@ -3796,6 +3796,8 @@ static void raid_postsuspend(struct dm_target *ti)
>   	struct raid_set *rs = ti->private;
>   
>   	if (!test_and_set_bit(RT_FLAG_RS_SUSPENDED, &rs->runtime_flags)) {
> +		if (test_bit(MD_RECOVERY_WAIT, &rs->md.recovery))
> +			clear_bit(MD_RECOVERY_WAIT, &rs->md.recovery);

Notice that 'MD_RECOVERY_WAIT' will never be cleared, hence sync_thread
will never make progress until table reload for dm-raid.

And other than stopping dm-raid, raid_postsuspend() call also be called
by ioctl to suspend dm-raid, hence this change is wrong.

I think we can never clear 'MD_RECOVERY_FROZEN' in this case so that
'MD_RECOVERY_WAIT' can be removed, or use '!MD_RECOVERY_WAIT' as a
condition to register new sync_thread.

Thanks,
Kuai
>   		/* Writes have to be stopped before suspending to avoid deadlocks. */
>   		if (!test_bit(MD_RECOVERY_FROZEN, &rs->md.recovery))
>   			md_stop_writes(&rs->md);
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 2266358d8074..54790261254d 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -4904,6 +4904,7 @@ static void stop_sync_thread(struct mddev *mddev, bool locked, bool check_seq)
>   	 * never happen
>   	 */
>   	md_wakeup_thread_directly(mddev->sync_thread);
> +	md_wakeup_thread(mddev->sync_thread);
>   	if (work_pending(&mddev->sync_work))
>   		flush_work(&mddev->sync_work);
>   
> 

