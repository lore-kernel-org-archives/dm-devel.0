Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6A4C13D
	for <dm-devel@lists.linux.dev>; Fri, 23 Feb 2024 03:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708657604; cv=none; b=iPwrtHFVby907SoRBJ430Gaok5ewe8L1L2a6ZB7KhJHPsW0jp37Ot9vPl9vXnchB0rE5w++aYYtHYokO4p8NJNTvMswjK3b9RUVH2OqD5oLEoauMMZMzQlNdppP4tBUSvM7KzFIxXxJhenDR9K8S1JEMuW3MXuZqAit/2nHhtJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708657604; c=relaxed/simple;
	bh=Vc7LaMwLyTIvg8luRiddzPfcznuM/ENdlAYFZtIoJh8=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=anO+Caj0NtRRmB07PfECw2mHaaEy+PzBBZ3z2wV8kedx08cNR4TDFNT51+nm23gY0j0JUyoifX+OrQKYK8KwoCbIEMkxKx5Wea2dPX5esL0BSU2USQchXYEgd1lhESCQNqDrGrSPz8fhfGyfgHj9Z0ZkPN14Xia17c3JZ9VIMb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Tgvzs0YQjz4f3jcx
	for <dm-devel@lists.linux.dev>; Fri, 23 Feb 2024 11:06:33 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 24CEF1A0568
	for <dm-devel@lists.linux.dev>; Fri, 23 Feb 2024 11:06:38 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgAX5g68C9hlzgJ2Ew--.29485S3;
	Fri, 23 Feb 2024 11:06:38 +0800 (CST)
Subject: Re: [PATCH RFC 3/4] md: Missing decrease active_io for flush io
To: Xiao Ni <xni@redhat.com>, song@kernel.org
Cc: yukuai1@huaweicloud.com, bmarzins@redhat.com, heinzm@redhat.com,
 snitzer@kernel.org, ncroxon@redhat.com, neilb@suse.de,
 linux-raid@vger.kernel.org, dm-devel@lists.linux.dev,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20240220153059.11233-1-xni@redhat.com>
 <20240220153059.11233-4-xni@redhat.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <773e5948-79a6-1270-4b74-cb1a3a60d243@huaweicloud.com>
Date: Fri, 23 Feb 2024 11:06:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240220153059.11233-4-xni@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgAX5g68C9hlzgJ2Ew--.29485S3
X-Coremail-Antispam: 1UD129KBjvdXoWrtr1DtF4kKFyUur18trykGrg_yoWktrg_ur
	4jvF9Fgw1Uuw1v9ryj9rWfArWFyrs3urnrWFWIqr43Z345A3W0gFWv9w45Z34rJFWUKF13
	Jrs5tw1Y9rn7ujkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb3kFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr1j
	6rxdM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
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
> If all flush bios finish fast, it doesn't decrease active_io. And it will
> stuck when stopping array.
> 
> This can be reproduced by lvm2 test shell/integrity-caching.sh.
> But it can't reproduce 100%.
> 
> Fixes: fa2bbff7b0b4 ("md: synchronize flush io with array reconfiguration")
> Signed-off-by: Xiao Ni <xni@redhat.com>

Same patch is already applied:

855678ed8534 md: Fix missing release of 'active_io' for flush

Thanks,
Kuai

> ---
>   drivers/md/md.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 77e3af7cf6bb..a41bed286fd2 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -579,8 +579,12 @@ static void submit_flushes(struct work_struct *ws)
>   			rcu_read_lock();
>   		}
>   	rcu_read_unlock();
> -	if (atomic_dec_and_test(&mddev->flush_pending))
> +	if (atomic_dec_and_test(&mddev->flush_pending)) {
> +		/* The pair is percpu_ref_get() from md_flush_request() */
> +		percpu_ref_put(&mddev->active_io);
> +
>   		queue_work(md_wq, &mddev->flush_work);
> +	}
>   }
>   
>   static void md_submit_flush_data(struct work_struct *ws)
> 

