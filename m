Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A412EAC8
	for <dm-devel@lists.linux.dev>; Mon,  3 Jun 2024 02:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717383051; cv=none; b=gkkEYrDvxBoTUYYUOwfBqItNGfL1cn49iJpz2fQRo7+i2HW4+CM3M/jY8RtKNIhbJK03d2OA1KrJtDQMAqqk6vKPlhCsFmApFzU1MaoZXQLZZPisB5wNksITyjfFn3L5EmAOk/4ZkH3HK5fSNO0RKuxzR1Ll+dV3jadXnDRkYk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717383051; c=relaxed/simple;
	bh=9Cuj767uAqO5fKjEM1oY17xabYsz8+VeUEz+oc7TZpc=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=AZPbs2ez83JCvgo8RULAR+HgTSkVL2iUXG+f8tw/q+DubFgOMrpGgWZElEubs3ezZMUqfzKiSetnUGVaVuU3tXwl/naSDorqWX/Kls5iKwDtGY7KWGKcinRzlDGe/chOAvT796bYbwAYkBLZ5s9UETAtNunDzMTgb7J0lt6a48k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Vsyrk4THyz4f3jHj
	for <dm-devel@lists.linux.dev>; Mon,  3 Jun 2024 10:50:30 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 2F99C1A0B54
	for <dm-devel@lists.linux.dev>; Mon,  3 Jun 2024 10:50:40 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgBHGBF9L11mxJ2vOQ--.46547S3;
	Mon, 03 Jun 2024 10:50:40 +0800 (CST)
Subject: Re: [PATCH] md/dm-raid: don't clear MD_RECOVERY_FROZEN after setting
 frozen
To: linan666@huaweicloud.com, agk@redhat.com, snitzer@kernel.org,
 mpatocka@redhat.com, song@kernel.org, xni@redhat.com
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20240601090608.2847814-1-linan666@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <d20a99fa-965d-936d-1492-df87bba3da62@huaweicloud.com>
Date: Mon, 3 Jun 2024 10:50:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240601090608.2847814-1-linan666@huaweicloud.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgBHGBF9L11mxJ2vOQ--.46547S3
X-Coremail-Antispam: 1UD129KBjvJXoWrZFy3JFy8uw15uFW3WFyrCrg_yoW8Jr4rpF
	4kCa9xAr48Ar47Za9rXF1q9ayFv3ZFqr90krW7C3s5XryfGF9rW3WFgw42qFWkJFyrGFW7
	JF47JF4rZF15KaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Y14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4U
	JVW0owA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kI
	c2xKxwCYjI0SjxkI62AI1cAE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4
	AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE
	17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMI
	IF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq
	3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCT
	nIWIevJa73UjIFyTuYvjfUoOJ5UUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

ÔÚ 2024/06/01 17:06, linan666@huaweicloud.com Ð´µÀ:
> From: Li Nan <linan122@huawei.com>
> 
> MD_RECOVERY_FROZEN should always remain set after array is frozen. But
> in raid_message(), this flag is cleared soon after frozen. Fix it. This
> flag will be cleared in md_idle_sync_thread(), there is no need to clear
> it again for idle.
> 
> Fixes: cd32b27a66db ("md/dm-raid: don't call md_reap_sync_thread() directly")
> Signed-off-by: Li Nan <linan122@huawei.com>
> ---
>   drivers/md/dm-raid.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> index abe88d1e6735..466740a3a522 100644
> --- a/drivers/md/dm-raid.c
> +++ b/drivers/md/dm-raid.c
> @@ -3744,9 +3744,10 @@ static int raid_message(struct dm_target *ti, unsigned int argc, char **argv,
>   
>   		md_idle_sync_thread(mddev);
>   		mddev_unlock(mddev);
> +	} else {
> +		clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
>   	}
>   
> -	clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);

LGTM
Reviewed-by: Yu Kuai <yukuai3@huawei.com>

>   	if (decipher_sync_action(mddev, mddev->recovery) != st_idle)
>   		return -EBUSY;
>   	else if (!strcasecmp(argv[0], "resync"))
> 

