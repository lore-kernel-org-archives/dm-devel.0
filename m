Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D37CE28FD
	for <dm-devel@lists.linux.dev>; Thu, 18 Jan 2024 01:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705541288; cv=none; b=uEJFm2srrXy62M85cY9IFwNNx6UPPLbn5R6sSauNMB1SoyMcfZoTYakTFF7v7YqLtgdB6NDhXtAi8cIpTS3kymZJtV4u9kFum0Q43puiM8UlNlFxuBcR3XjWKLaDZ2sdUcHyDiKstmmn5s1ho28Lqx4d88oyk3Oqy9/QxQjiKPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705541288; c=relaxed/simple;
	bh=D6h6Yv02q2hUR0jHRwf449fkh3gockwm0+c5rBd5Th0=;
	h=Received:Received:Received:Subject:To:Cc:References:From:
	 Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo; b=N8rPpgoFj2Mfn0PF719p8fP2v7/P57ydXO3lk+uuSaCQphFRt4xClrMMdupN3qRsX7HUbOQHQj96K8bCKD+ySrExQyb/ByhXdtbAwmdl2TEBxbvJO7p4d0BBNYksX00xMEsVK7hypZuRXL3qgzFlX0PYKk+W3pQJxoaAMIZQol4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4TFlVc1x9Kz4f3jMX
	for <dm-devel@lists.linux.dev>; Thu, 18 Jan 2024 09:27:52 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 08F951A017A
	for <dm-devel@lists.linux.dev>; Thu, 18 Jan 2024 09:27:56 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgCXaBGafqhlU9qrBA--.5396S3;
	Thu, 18 Jan 2024 09:27:55 +0800 (CST)
Subject: Re: [PATCH 1/7] md: Revert fa2bbff7b0b4 ("md: synchronize flush io
 with array reconfiguration")
To: Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>,
 David Jeffery <djeffery@redhat.com>, Li Nan <linan122@huawei.com>
Cc: dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
 Mike Snitzer <msnitzer@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>, "yukuai (C)" <yukuai3@huawei.com>
References: <e5e8afe2-e9a8-49a2-5ab0-958d4065c55e@redhat.com>
 <2c29cbd4-736d-2f23-2bc-636881c150d6@redhat.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <c6eb9966-8a6f-e749-3d25-b0e606149750@huaweicloud.com>
Date: Thu, 18 Jan 2024 09:27:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <2c29cbd4-736d-2f23-2bc-636881c150d6@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgCXaBGafqhlU9qrBA--.5396S3
X-Coremail-Antispam: 1UD129KBjvJXoWxCFykAFy8AFy3XrW8uw4fuFg_yoW5ZF1Dp3
	93tasayr4UJFWDKw4jya1kGr15WanxKa97trZ3A343AwnxWr98J345CrZ5XryUCryfAr45
	G3Wqqw4DWayjqrUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv2b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7Mxk0xIA0c2IE
	e2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxV
	Aqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q
	6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6x
	kF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE
	14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa
	7IU1zuWJUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2024/01/18 2:17, Mikulas Patocka Ð´µÀ:
> The commit fa2bbff7b0b4 breaks the LVM2 test shell/integrity-caching.sh,
> so let's revert it.
> 
> sysrq: Show Blocked State
> task:lvm             state:D stack:0     pid:8275  tgid:8275  ppid:1373   flags:0x00000002
> Call Trace:
>   <TASK>
>   __schedule+0x228/0x570
>   ? __percpu_ref_switch_mode+0xb7/0x1b0
>   schedule+0x29/0xa0
>   mddev_suspend+0xec/0x1a0 [md_mod]

We really need more information about the root cause here. If
mddev_suspend() is waiting for this flush IO to be done, then why
the flush IO can't finish?

Thanks,
Kuai

>   ? housekeeping_test_cpu+0x30/0x30
>   dm_table_postsuspend_targets+0x34/0x50 [dm_mod]
>   __dm_destroy+0x1c5/0x1e0 [dm_mod]
>   ? table_clear+0xa0/0xa0 [dm_mod]
>   dev_remove+0xd4/0x110 [dm_mod]
>   ctl_ioctl+0x2e1/0x570 [dm_mod]
>   dm_ctl_ioctl+0x5/0x10 [dm_mod]
>   __x64_sys_ioctl+0x85/0xa0
>   do_syscall_64+0x5d/0x1a0
>   entry_SYSCALL_64_after_hwframe+0x46/0x4e
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Fixes: fa2bbff7b0b4 ("md: synchronize flush io with array reconfiguration")
> 
> ---
>   drivers/md/md.c |   21 ++++++---------------
>   1 file changed, 6 insertions(+), 15 deletions(-)
> 
> Index: linux-2.6/drivers/md/md.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/md.c
> +++ linux-2.6/drivers/md/md.c
> @@ -543,9 +543,6 @@ static void md_end_flush(struct bio *bio
>   	rdev_dec_pending(rdev, mddev);
>   
>   	if (atomic_dec_and_test(&mddev->flush_pending)) {
> -		/* The pair is percpu_ref_get() from md_flush_request() */
> -		percpu_ref_put(&mddev->active_io);
> -
>   		/* The pre-request flush has finished */
>   		queue_work(md_wq, &mddev->flush_work);
>   	}
> @@ -565,7 +562,12 @@ static void submit_flushes(struct work_s
>   	rdev_for_each_rcu(rdev, mddev)
>   		if (rdev->raid_disk >= 0 &&
>   		    !test_bit(Faulty, &rdev->flags)) {
> +			/* Take two references, one is dropped
> +			 * when request finishes, one after
> +			 * we reclaim rcu_read_lock
> +			 */
>   			struct bio *bi;
> +			atomic_inc(&rdev->nr_pending);
>   
>   			atomic_inc(&rdev->nr_pending);
>   			rcu_read_unlock();
> @@ -577,6 +579,7 @@ static void submit_flushes(struct work_s
>   			atomic_inc(&mddev->flush_pending);
>   			submit_bio(bi);
>   			rcu_read_lock();
> +			rdev_dec_pending(rdev, mddev);
>   		}
>   	rcu_read_unlock();
>   	if (atomic_dec_and_test(&mddev->flush_pending))
> @@ -629,18 +632,6 @@ bool md_flush_request(struct mddev *mdde
>   	/* new request after previous flush is completed */
>   	if (ktime_after(req_start, mddev->prev_flush_start)) {
>   		WARN_ON(mddev->flush_bio);
> -		/*
> -		 * Grab a reference to make sure mddev_suspend() will wait for
> -		 * this flush to be done.
> -		 *
> -		 * md_flush_reqeust() is called under md_handle_request() and
> -		 * 'active_io' is already grabbed, hence percpu_ref_is_zero()
> -		 * won't pass, percpu_ref_tryget_live() can't be used because
> -		 * percpu_ref_kill() can be called by mddev_suspend()
> -		 * concurrently.
> -		 */
> -		WARN_ON(percpu_ref_is_zero(&mddev->active_io));
> -		percpu_ref_get(&mddev->active_io);
>   		mddev->flush_bio = bio;
>   		bio = NULL;
>   	}
> 
> .
> 

