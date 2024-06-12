Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14ABE4411
	for <dm-devel@lists.linux.dev>; Wed, 12 Jun 2024 01:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718155540; cv=none; b=Sf6HDkG1shL2LMGOZDTYLo27wsrutXNhjfuFAEkuSJKYrmC39RZmY8YyvEPNKfQxLUNsL4aSNEpHDPWFn7efVK95Sm+OSDvczjhWrqxNFvEhm8AN65O//HI8ldhZ7IYawn1KfiAdaqblt7+g0uIUP5JcuHDAgt6uov7yLwsEivM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718155540; c=relaxed/simple;
	bh=t2p9ntJ5q7Oe3xiO5Qcu5HCngxdCnJYm582piU5nkIA=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=pL5XqcrKcEFcE9oiwErUhkJsRWlX3+nD0eySTMXI9PdrgH8aDkq/hASxLJSxpDKdgh6oVQ+LwKy1XTC3QJRea5t6M4qB1tpsWgUu7fYQ2uQmqL1t1a/7nbe6qpeMG1eCWp4VCeSukyrxriMmrVpezSkiUPfpl0z/MTQvDJoJj30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4VzSXN0sGwz4f3jLy
	for <dm-devel@lists.linux.dev>; Wed, 12 Jun 2024 09:25:24 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 2372F1A058E
	for <dm-devel@lists.linux.dev>; Wed, 12 Jun 2024 09:25:34 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgAX6REM+Whm8WvzPA--.55682S3;
	Wed, 12 Jun 2024 09:25:34 +0800 (CST)
Subject: Re: [PATCH] dm-raid: Fix WARN_ON_ONCE check for sync_thread in
 raid_resume
To: Benjamin Marzinski <bmarzins@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Song Liu <song@kernel.org>
Cc: Heinz Mauelshagen <heinzm@redhat.com>, Xiao Ni <xni@redhat.com>,
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
 Yu Kuai <yukuai1@huaweicloud.com>, "yukuai (C)" <yukuai3@huawei.com>
References: <20240611215528.846776-1-bmarzins@redhat.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <52739be7-f9bb-7674-f5a3-e99e73a86ae4@huaweicloud.com>
Date: Wed, 12 Jun 2024 09:25:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240611215528.846776-1-bmarzins@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgAX6REM+Whm8WvzPA--.55682S3
X-Coremail-Antispam: 1UD129KBjvJXoW7AF4UJryDAw4rJw1DWw17Jrb_yoW8AF13pr
	WDG3W5Ar4UAr47Za9rt3Wqva4j9a1jgrWYkrZxWFykAa1rGFZYkrWUCFyjvFWDtas5Aw1j
	vay3Ja1xZr10kF7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Y14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
	kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
	67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
	CI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E
	3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCT
	nIWIevJa73UjIFyTuYvjfUoOJ5UUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2024/06/12 5:55, Benjamin Marzinski Ð´µÀ:
> rm-raid devices will occasionally trigger the following warning when
> being resumed after a table load because DM_RECOVERY_RUNNING is set:
> 
> WARNING: CPU: 7 PID: 5660 at drivers/md/dm-raid.c:4105 raid_resume+0xee/0x100 [dm_raid]
> 
> The failing check is:
> WARN_ON_ONCE(test_bit(MD_RECOVERY_RUNNING, &mddev->recovery));
> 
> This check is designed to make sure that the sync thread isn't
> registered, but md_check_recovery can set MD_RECOVERY_RUNNING without
> the sync_thread ever getting registered. Instead of checking if
> MD_RECOVERY_RUNNING is set, check if sync_thread is non-NULL.
> 
> Fixes: 16c4770c75b1 ("dm-raid: really frozen sync_thread during suspend")
> Suggested-by: Yu Kuai <yukuai1@huaweicloud.com>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>   drivers/md/dm-raid.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> index abe88d1e6735..74184989fd15 100644
> --- a/drivers/md/dm-raid.c
> +++ b/drivers/md/dm-raid.c
> @@ -4102,7 +4102,7 @@ static void raid_resume(struct dm_target *ti)
>   			rs_set_capacity(rs);
>   
>   		WARN_ON_ONCE(!test_bit(MD_RECOVERY_FROZEN, &mddev->recovery));
> -		WARN_ON_ONCE(test_bit(MD_RECOVERY_RUNNING, &mddev->recovery));
> +		WARN_ON_ONCE(mddev->sync_thread);

sync_thread is protected by rcu, I think this will cause spares warning.
Please use:

rcu_dereferenct_protected(mddev->sync_thread, 
lockdep_is_held(&mddev->reconfig_mutex));

Otherwise, LGTM.
Thanks

>   		clear_bit(RT_FLAG_RS_FROZEN, &rs->runtime_flags);
>   		mddev_lock_nointr(mddev);
>   		mddev->ro = 0;
> 

