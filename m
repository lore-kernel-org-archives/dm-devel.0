Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C03043A1DC
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 02:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709261096; cv=none; b=Y2otmeuF4xj769ZjdWnfMSytZvpBP4NoyiEabP705fhdGyYwUvrH+fnHiWZaDGlcZr1RigR69dFT4RNxjiWq+w8fKEGx5NdhZJiqHpkrSGQfwc5V7FwO7oz6QfbxFHjutCmdKdD/eZZ/DfurvJkRIE4FNidTO4+etpPy1h0NwXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709261096; c=relaxed/simple;
	bh=akqYgwMFGlJoTEghi5C3kc+b8hNM3IqOc0aWBD5SLHc=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=UCP02fcIhzcQ0CbBu4RhxFcEDMmJ6/P/OaZAhqpz/biBiAQQqCRY9quO57LgEO3VezJOxDWYcZsjn+9gWkHpNvQFR4k9oaCSV8AK0vvUyiacqIc0iCIMJomU2Jyb6Ld7ojkr5q64Ph2xOPRz/xxtLivI5XHV8Ghdl/yT7+VHi4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4TmC9T1mL1z4f3jLy
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 10:44:45 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 839A01A07FA
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 10:44:50 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgCXaBEhQeFlxCZPFg--.12146S3;
	Fri, 01 Mar 2024 10:44:50 +0800 (CST)
Subject: Re: [PATCH 4/6] dm-raid/md: Clear MD_RECOVERY_WAIT when stopping
 dmraid
To: Xiao Ni <xni@redhat.com>, song@kernel.org
Cc: yukuai1@huaweicloud.com, bmarzins@redhat.com, heinzm@redhat.com,
 snitzer@kernel.org, ncroxon@redhat.com, linux-raid@vger.kernel.org,
 dm-devel@lists.linux.dev, "yukuai (C)" <yukuai3@huawei.com>
References: <20240229154941.99557-1-xni@redhat.com>
 <20240229154941.99557-5-xni@redhat.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <6fcfeea4-69bc-d6cf-c367-0392d45c2efd@huaweicloud.com>
Date: Fri, 1 Mar 2024 10:44:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240229154941.99557-5-xni@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgCXaBEhQeFlxCZPFg--.12146S3
X-Coremail-Antispam: 1UD129KBjvJXoWxXrWUAry8Xr4rGr4rXr1DWrg_yoW5uryfpa
	yUXFy5Zw4UAr4UZF9rXa1qqa4Fq3WYqFW5Cry3C34rA3Z8K3WfuFWUKFyUXFWDGFyfJF4j
	yan8Ja9xZa9akrJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9214x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
	kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
	67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
	CI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWr
	Zr1UMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYx
	BIdaVFxhVjvjDU0xZFpf9x0JUZa9-UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2024/02/29 23:49, Xiao Ni Ð´µÀ:
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

Like I mentioned in the RFC v2 patch, this really is not safe, or do you
think am I missing something?

Of course we want lvm2 tests behave the same as v6.6, but we can't
introduce new issue that is not covered by lvm2 tests.

Thanks,
Kuai

>   		/* Writes have to be stopped before suspending to avoid deadlocks. */
>   		if (!test_bit(MD_RECOVERY_FROZEN, &rs->md.recovery))
>   			md_stop_writes(&rs->md);
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 79dfc015c322..f264749be28b 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -4908,6 +4908,7 @@ static void stop_sync_thread(struct mddev *mddev, bool locked, bool check_seq)
>   	 * never happen
>   	 */
>   	md_wakeup_thread_directly(mddev->sync_thread);
> +	md_wakeup_thread(mddev->sync_thread);
>   	if (work_pending(&mddev->sync_work))
>   		flush_work(&mddev->sync_work);
>   
> 

