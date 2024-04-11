Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 087A46217D
	for <dm-devel@lists.linux.dev>; Thu, 11 Apr 2024 02:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712801893; cv=none; b=i9/oQgDt/Zi1Ihva+rn/j0Ju9kxFmutBsm3vhlMJN5NXfaGGdjQQfEJyI5+M8hwHoHrEWx2+rRvcrbRo1CvViyFRy6jxQsVv1DXSxPPKJTKFWsd1NRktxnSFok9xT31vyXyseWiKrfym1aEYZtfXCsbN4cyO88Pjd29CF/rN/Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712801893; c=relaxed/simple;
	bh=n4oWJOJwpnZcX+1yGeKqJ/YTnoROf+ymwqyy+sCtko8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iEEBVuDgu+QYn5JMtb6joej4ERYujTSPuuH2oi8Weyb+WJdVbrOa+h1DQa1NQFrRDDYt7DdpEbxZ0YzNHuDRxFeYnY5KCs4YgouKRC33WiezfG3yi3Ol8u6dL1V5Dco/dj6EGzcmJe8mkcQl4mI9a0hIpYzt7Z+Z9rEz1pNaeU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4VFNdX5Mtgz4f3m79
	for <dm-devel@lists.linux.dev>; Thu, 11 Apr 2024 10:17:52 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 6A1F51A0179
	for <dm-devel@lists.linux.dev>; Thu, 11 Apr 2024 10:18:01 +0800 (CST)
Received: from [10.174.177.210] (unknown [10.174.177.210])
	by APP1 (Coremail) with SMTP id cCh0CgAn9g5WSBdmZmOoJg--.5436S3;
	Thu, 11 Apr 2024 10:18:00 +0800 (CST)
Message-ID: <cfd693de-449e-a505-39e5-0a7931c3a5b2@huaweicloud.com>
Date: Thu, 11 Apr 2024 10:17:58 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v3] dm-crypt: reexport sysfs of kcryptd workqueue
To: Mike Snitzer <snitzer@kernel.org>
Cc: mpatocka@redhat.com, agk@redhat.com, tj@kernel.org,
 dm-devel@lists.linux.dev, yangerkun@huawei.com, yukuai3@huawei.com,
 Milan Broz <gmazyland@gmail.com>
References: <20230711061129.2706759-1-yangerkun@huaweicloud.com>
 <45a09f8d-d167-c78c-7ac8-3ed27db18653@huaweicloud.com>
 <Zhaxz1ZkGzbfW0RQ@redhat.com> <Zha4M0ru46QrKYgq@redhat.com>
From: yangerkun <yangerkun@huaweicloud.com>
In-Reply-To: <Zha4M0ru46QrKYgq@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgAn9g5WSBdmZmOoJg--.5436S3
X-Coremail-Antispam: 1UD129KBjvJXoWxAFWrXF4UAFyDGryrtFyrJFb_yoWrZFWrpF
	W5JF4akw48Jr47KwnIqw1kJF9xtryrGr9xZr4xJ347Cwn09F93XF17Ar45urWkAFn5Ga1U
	ZF4DJa9I9F9Yy3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyEb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
	64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
	8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE
	2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
	xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
	c7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU1zuWJUUUUU==
X-CM-SenderInfo: 51dqwvhunx0q5kxd4v5lfo033gof0z/



在 2024/4/11 0:02, Mike Snitzer 写道:
> [resend after rebase and fixing dm-devel mailing list address]
> 
> On Wed, Apr 10 2024 at 11:35P -0400,
> Mike Snitzer <snitzer@kernel.org> wrote:
> 
>> On Sat, Mar 30 2024 at  4:05P -0400,
>> yangerkun <yangerkun@huaweicloud.com> wrote:
>>
>>> Hi,
>>>
>>> Ping for this patch!
>>>
>>> 在 2023/7/11 14:11, yangerkun 写道:
>>>> From: yangerkun <yangerkun@huawei.com>
>>>>
>>>> Once there is a heavy IO load, so many encrypt/decrypt work will occupy
>>>> all of the cpu, which may lead the poor performance for other service.
>>>> So the idea like 'a2b8b2d97567 ("dm crypt: export sysfs of kcryptd
>>>> workqueue")' said seems necessary. We can export "kcryptd" workqueue
>>>> sysfs, the entry like cpumask/max_active and so on can help us to limit
>>>> the usage for encrypt/decrypt work.
>>>>
>>>> However, that commit does not consider the reload table will call .ctr
>>>> before .dtr, so the reload for dm-crypt will fail since the same sysfs
>>>> problem, and then we revert that commit('48b0777cd93d ("Revert "dm
>>>> crypt: export sysfs of kcryptd workqueue"")').
>>>>
>>>> Actually, what we should do is give a unique name once we try reload
>>>> table, we can use ida to fix the problem.
>>>>
>>>> Signed-off-by: yangerkun <yangerkun@huawei.com>
>>>> ---
>>>>    drivers/md/dm-crypt.c | 28 +++++++++++++++++++++++-----
>>>>    1 file changed, 23 insertions(+), 5 deletions(-)
>>>>
>>>> v1->v2:
>>>> rewrite the commit msg
>>>>
>>>> v2->v3:
>>>> no logical change, just rebase to latest linux kernel
>>>>
>>>> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
>>>> index 1dc6227d353e..f4678eb71322 100644
>>>> --- a/drivers/md/dm-crypt.c
>>>> +++ b/drivers/md/dm-crypt.c
>>>> @@ -47,6 +47,8 @@
>>>>    #define DM_MSG_PREFIX "crypt"
>>>> +static DEFINE_IDA(crypt_queue_ida);
>>>> +
>>>>    /*
>>>>     * context holding the current state of a multi-part conversion
>>>>     */
>>>> @@ -182,6 +184,7 @@ struct crypt_config {
>>>>    		struct crypto_aead **tfms_aead;
>>>>    	} cipher_tfm;
>>>>    	unsigned int tfms_count;
>>>> +	int crypt_queue_id;
>>>>    	unsigned long cipher_flags;
>>>>    	/*
>>>> @@ -2735,6 +2738,9 @@ static void crypt_dtr(struct dm_target *ti)
>>>>    	if (cc->crypt_queue)
>>>>    		destroy_workqueue(cc->crypt_queue);
>>>> +	if (cc->crypt_queue_id)
>>>> +		ida_free(&crypt_queue_ida, cc->crypt_queue_id);
>>>> +
>>>>    	crypt_free_tfms(cc);
>>>>    	bioset_exit(&cc->bs);
>>>> @@ -3371,12 +3377,24 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>>>>    	}
>>>>    	if (test_bit(DM_CRYPT_SAME_CPU, &cc->flags))
>>>> -		cc->crypt_queue = alloc_workqueue("kcryptd/%s", WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM,
>>>> +		cc->crypt_queue = alloc_workqueue("kcryptd-%s", WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM,
>>>>    						  1, devname);
>>>> -	else
>>>> -		cc->crypt_queue = alloc_workqueue("kcryptd/%s",
>>>> -						  WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM | WQ_UNBOUND,
>>>> -						  num_online_cpus(), devname);
>>>> +	else {
>>>> +		int id = ida_alloc_min(&crypt_queue_ida, 1, GFP_KERNEL);
>>>> +
>>>> +		if (id < 0) {
>>>> +			ti->error = "Couldn't get kcryptd queue id";
>>>> +			ret = id;
>>>> +			goto bad;
>>>> +		}
>>>> +
>>>> +		cc->crypt_queue_id = id;
>>>> +		cc->crypt_queue = alloc_workqueue("kcryptd-%s-%d",
>>>> +						  WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM |
>>>> +						  WQ_UNBOUND | WQ_SYSFS,
>>>> +						  num_online_cpus(), devname, id);
>>>> +	}
>>>> +
>>>>    	if (!cc->crypt_queue) {
>>>>    		ti->error = "Couldn't create kcryptd queue";
>>>>    		goto bad;
>>>
>>
>> I'm OK with adding WQ_SYSFS to export workqueue info.  dm-crypt's
>> performance is very tighly coupled with its use of workqueues.  So
>> allowing more visibility into workqueues makes sense.
>>
>> That said, I'm not loving that the sysfs entry will have a dynamic
>> name (made possible with ida) -- but I can live with it.
>>
>> However, I do think it is useful to always use WQ_SYSFS (even if
>> DM_CRYPT_SAME_CPU, and also for the IO wq).
>>
>> So I've made the use of ida common to all dm-crypt wq. I was able to
>> do this more cleanly by rebasing ontop of dm-6.10 (which now includes
>> recent dm-crypt patch to allow WQ_HIGHPRI to be configured), see:
>> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-6.10&id=6bd1e0b331ddd7bb4d6b2abc8472a36602180aa5
>>
>> Thanks,
>> Mike


This version looks good to me. Thanks a lot!

