Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0623EBE68
	for <dm-devel@lists.linux.dev>; Fri, 23 Feb 2024 03:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708657742; cv=none; b=sCivimXosi9HBkwt5wiP2hk4cFxXEu5WZc12J9kNjPzLO7xhZ7Gqm4/9dBmWFOoT23e6mBmCGB8R+3EfzrkC5bo2RODiFeblWh/cgNgs5fL0txY4vM6NnWgyHKXH7jmTzaAad+XJJPoLVpQ64abBJzwlOMULiSmuTRC3tRC+K5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708657742; c=relaxed/simple;
	bh=+CXB3isItILD8iBezHPUlIjsS+Or3REV0kzDnAOovFg=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=GuAAyvgDZcb8osYfAcak6rOk23c3dpGelBd8CBLYlYKOgeLsxYOUswA+GkMNz5Z/EANFbfKBtESG5fjkZ1dcOxQGEYmp41b9hgVVwiv5RV/5oV2m6bW4RHF6cy7q8IyGcdAJA3aLk0OvkWgvEBZhKojNtSKkIb0wD/f2YxyBvLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Tgw2W0Jy6z4f3kj5
	for <dm-devel@lists.linux.dev>; Fri, 23 Feb 2024 11:08:51 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 14CA01A016E
	for <dm-devel@lists.linux.dev>; Fri, 23 Feb 2024 11:08:56 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgBHZQ5HDNhl6y52Ew--.141S3;
	Fri, 23 Feb 2024 11:08:55 +0800 (CST)
Subject: Re: [PATCH RFC V2 4/4] md/raid5: Don't check crossing reshape when
 reshape hasn't started
To: Xiao Ni <xni@redhat.com>, song@kernel.org
Cc: yukuai1@huaweicloud.com, bmarzins@redhat.com, heinzm@redhat.com,
 snitzer@kernel.org, ncroxon@redhat.com, neilb@suse.de,
 linux-raid@vger.kernel.org, dm-devel@lists.linux.dev,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20240220153059.11233-1-xni@redhat.com>
 <20240220153059.11233-5-xni@redhat.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <d87923c7-ec76-e8c1-7420-3d89728c96f5@huaweicloud.com>
Date: Fri, 23 Feb 2024 11:08:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240220153059.11233-5-xni@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgBHZQ5HDNhl6y52Ew--.141S3
X-Coremail-Antispam: 1UD129KBjvJXoWxCF1rWF1DZFy5Zr17WFWfZrb_yoW5Kry7pa
	y5tay3XrWkAr98KF4DJa1qga4F9FZ8trZ8twnrX348Crn8Kr97tF1xG3yjyFyUAFy5Jr4Y
	q3WUAryUCrsF9a7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9014x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4U
	JVW0owA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kI
	c2xKxwCYjI0SjxkI62AI1cAE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4
	AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE
	17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMI
	IF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Zr0_Wr1U
	MIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIda
	VFxhVjvjDU0xZFpf9x0JUZa9-UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2024/02/20 23:30, Xiao Ni Ð´µÀ:
> stripe_ahead_of_reshape is used to check if a stripe region cross the
> reshape position. So first, change the function name to
> stripe_across_reshape to describe the usage of this function.
> 
> For reshape backwards, it starts reshape from the end of array and conf->
> reshape_progress is init to raid5_size. During reshape, if previous is true
> (set in make_stripe_request) and max_sector >= conf->reshape_progress, ios
> should wait until reshape window moves forward. But ios don't need to wait
> if max_sector is raid5_size.
> 
> And put the conditions into the function directly to make understand the
> codes easily.
> 
> This can be reproduced easily by lvm2 test shell/lvconvert-raid-reshape.sh
> For dm raid reshape, before starting sync thread, it needs to reload table
> some times. In one time dm raid uses MD_RECOVERY_WAIT to delay reshape and
> it doesn't start sync thread this time. Then one io comes in and it waits
> because stripe_ahead_of_reshape returns true because it's a backward
> reshape and max_sectors > conf->reshape_progress. But the reshape hasn't
> started. So skip this check when reshape_progress is raid5_size

Like I said before, after following merged patch:

ad39c08186f8 md: Don't register sync_thread for reshape directly

You should not see that sync_thread fo reshape is registered while
MD_RECOVERY_WAIT is set, so this patch should not be needed.

Thanks,
Kuai

> 
> Fixes: 486f60558607 ("md/raid5: Check all disks in a stripe_head for reshape progress")
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>   drivers/md/raid5.c | 22 ++++++++++------------
>   1 file changed, 10 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 8497880135ee..4c71df4e2370 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -5832,17 +5832,12 @@ static bool ahead_of_reshape(struct mddev *mddev, sector_t sector,
>   					  sector >= reshape_sector;
>   }
>   
> -static bool range_ahead_of_reshape(struct mddev *mddev, sector_t min,
> -				   sector_t max, sector_t reshape_sector)
> -{
> -	return mddev->reshape_backwards ? max < reshape_sector :
> -					  min >= reshape_sector;
> -}
> -
> -static bool stripe_ahead_of_reshape(struct mddev *mddev, struct r5conf *conf,
> +static sector_t raid5_size(struct mddev *mddev, sector_t sectors, int raid_disks);
> +static bool stripe_across_reshape(struct mddev *mddev, struct r5conf *conf,
>   				    struct stripe_head *sh)
>   {
>   	sector_t max_sector = 0, min_sector = MaxSector;
> +	sector_t reshape_pos = 0;
>   	bool ret = false;
>   	int dd_idx;
>   
> @@ -5856,9 +5851,12 @@ static bool stripe_ahead_of_reshape(struct mddev *mddev, struct r5conf *conf,
>   
>   	spin_lock_irq(&conf->device_lock);
>   
> -	if (!range_ahead_of_reshape(mddev, min_sector, max_sector,
> -				     conf->reshape_progress))
> -		/* mismatch, need to try again */
> +	reshape_pos = conf->reshape_progress;
> +	if (mddev->reshape_backwards) {
> +		if (max_sector >= reshape_pos &&
> +		    reshape_pos != raid5_size(mddev, 0, 0))
> +			ret = true;
> +	} else if (min_sector < reshape_pos)
>   		ret = true;
>   
>   	spin_unlock_irq(&conf->device_lock);
> @@ -5969,7 +5967,7 @@ static enum stripe_result make_stripe_request(struct mddev *mddev,
>   	}
>   
>   	if (unlikely(previous) &&
> -	    stripe_ahead_of_reshape(mddev, conf, sh)) {
> +	    stripe_across_reshape(mddev, conf, sh)) {
>   		/*
>   		 * Expansion moved on while waiting for a stripe.
>   		 * Expansion could still move past after this
> 

