Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28CAB1119E
	for <dm-devel@lists.linux.dev>; Fri, 23 Feb 2024 03:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708657945; cv=none; b=pMT0IKOXKTrvoTiJ7jlDfQUf18H65TMoiAfATLzXGuHIBAPbjgt64IP/evpqMrqTQAK3WUCQWnnJ0ueV4sDTudJyEJULuguFZB6Z1krfBeos0nz2H5HIqZSu8WShhD2df6zqoY/MZKqJGMVpCuJYB/9Cp8SsOyziB2Orhstrf9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708657945; c=relaxed/simple;
	bh=qPknKpEtTewRYB45pj1NiqHCyvrMW5Fg6II5S8IqTL0=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=bkprX3SRtpTZYjMykhepmfy3Uysyikl6X/fbBYmbrpOiY8b07ODQgtLuSwF2ruhy6XNn50XdCJwXxRaitvRkOmierVpkda7wSN5kAvsJbwKXDN9XRvTqieSWBla7KrnxD7easJo8hmRRe1A8BVurcexr7BQI5i7LYonNrcJZqtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Tgw6P6dw3z4f3jMS
	for <dm-devel@lists.linux.dev>; Fri, 23 Feb 2024 11:12:13 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 018FF1A0F08
	for <dm-devel@lists.linux.dev>; Fri, 23 Feb 2024 11:12:19 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgAX6REODdhl3G12Ew--.42116S3;
	Fri, 23 Feb 2024 11:12:15 +0800 (CST)
Subject: Re: [PATCH RFC 2/4] md: Set MD_RECOVERY_FROZEN before stop sync
 thread
To: Xiao Ni <xni@redhat.com>, song@kernel.org
Cc: yukuai1@huaweicloud.com, bmarzins@redhat.com, heinzm@redhat.com,
 snitzer@kernel.org, ncroxon@redhat.com, neilb@suse.de,
 linux-raid@vger.kernel.org, dm-devel@lists.linux.dev,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20240220153059.11233-1-xni@redhat.com>
 <20240220153059.11233-3-xni@redhat.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <4370dfd7-61ac-51e4-6ff5-1eb18ac4c1f1@huaweicloud.com>
Date: Fri, 23 Feb 2024 11:12:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240220153059.11233-3-xni@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgAX6REODdhl3G12Ew--.42116S3
X-Coremail-Antispam: 1UD129KBjvJXoW7WF48JF43uFy5Wr1fJF47Jwb_yoW8Ww1UpF
	W0qF1F9w4DAw17Za4DGay8Za4rt3ZavrWjkFy3G34xA3sxKwnI9rWaka45Jr98uFyxGrs8
	Za1UX3y5WrW7KFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9014x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4U
	JVW0owA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kI
	c2xKxwCYjI0SjxkI62AI1cAE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4
	AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE
	17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMI
	IF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Zr0_Wr1U
	MIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIda
	VFxhVjvjDU0xZFpf9x0JUp6wZUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2024/02/20 23:30, Xiao Ni Ð´µÀ:
> After patch commit f52f5c71f3d4b ("md: fix stopping sync thread"), dmraid
> stops sync thread asynchronously. The calling process is:
> dev_remove->dm_destroy->__dm_destroy->raid_postsuspend->raid_dtr
> 
> raid_postsuspend does two jobs. First, it stops sync thread. Then it
> suspend array. Now it can stop sync thread successfully. But it doesn't
> set MD_RECOVERY_FROZEN. It's introduced by patch f52f5c71f3d4b. So after
> raid_postsuspend, the sync thread starts again. raid_dtr can't stop the
> sync thread because the array is already suspended.
> 
> This can be reproduced easily by those commands:
> while [ 1 ]; do
> vgcreate test_vg /dev/loop0 /dev/loop1
> lvcreate --type raid1 -L 400M -m 1 -n test_lv test_vg
> lvchange -an test_vg
> vgremove test_vg -ff
> done
> 
> Fixes: f52f5c71f3d4 ("md: fix stopping sync thread")
> Signed-off-by: Xiao Ni <xni@redhat.com>

I agree with this change, but this patch is part of my patch in the
other thread:

dm-raid: really frozen sync_thread during suspend

I still think that fix found problems completely is better, however,
we'll let Song to make decision.

Thanks,
Kuai

> ---
>   drivers/md/md.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 54790261254d..77e3af7cf6bb 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6337,6 +6337,7 @@ static void __md_stop_writes(struct mddev *mddev)
>   void md_stop_writes(struct mddev *mddev)
>   {
>   	mddev_lock_nointr(mddev);
> +	set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
>   	__md_stop_writes(mddev);
>   	mddev_unlock(mddev);
>   }
> 

