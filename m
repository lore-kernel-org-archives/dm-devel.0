Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF7517F7
	for <dm-devel@lists.linux.dev>; Tue, 14 May 2024 01:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715650571; cv=none; b=S+3/HV97txEZBtk94e/Lx+bSqApty46Y5D5CZlnotzR1HEU4t9mZ+/wdSlT58PSzSunYagXoaby+VAfV7p4dzGd3pipwJgFY/v6Gem42UAkiuAwByiz1a051fOQudomZLh1/VmD3Oevso+kJn6uHtp25q2Dpw1+11AZwd2Fjl5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715650571; c=relaxed/simple;
	bh=Upsul9NcofEKR67TbzR1JI6SV64CmPDbuIlZIz0tIg8=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=U5fGhR6cZToQxIcP5ouNjz7U+nqG+dZiQjU9p8HoOjDU6cKumhd+ZUjmjUbz9xQzAFo27M8XJrlZZdm5orkHKBaQ8knDPmZrvXtfN0aRUibiWH8Cidw4Tzesqe4i21Gfsut7ys5JEupodnJ9lD1k3flrVfXcAxhPTIDjyhjwAOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Vdf7w109hz4f3jJ2
	for <dm-devel@lists.linux.dev>; Tue, 14 May 2024 09:35:56 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id B54E81A017F
	for <dm-devel@lists.linux.dev>; Tue, 14 May 2024 09:36:04 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgBnOBECwEJm7mVnMg--.15054S3;
	Tue, 14 May 2024 09:36:04 +0800 (CST)
Subject: Re: [PATCH md-6.10 1/9] md: rearrange recovery_flage
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
 Yu Kuai <yukuai1@huaweicloud.com>
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
 xni@redhat.com, dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20240509011900.2694291-1-yukuai1@huaweicloud.com>
 <20240509011900.2694291-2-yukuai1@huaweicloud.com>
 <20240513170958.00002282@linux.intel.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <46448c77-894a-1ddc-30b3-42ca00b6ecd4@huaweicloud.com>
Date: Tue, 14 May 2024 09:36:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240513170958.00002282@linux.intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgBnOBECwEJm7mVnMg--.15054S3
X-Coremail-Antispam: 1UD129KBjvJXoWxAFykGrWxAr1xJF4DtFykuFg_yoWrXry5pF
	W0kFn5Zr4UZr12yry7ta4rX39Y934FvFy5ArW3WF98JasYk3Zayr18J3WUWFZ7t3sxt3W7
	XF45JF13uFs0y3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9F14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
	kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
	67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
	CI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E
	3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcS
	sGvfC2KfnxnUUI43ZEXa7VUbXdbUUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2024/05/13 23:12, Mariusz Tkaczyk Ð´µÀ:
> On Thu,  9 May 2024 09:18:52 +0800
> Yu Kuai <yukuai1@huaweicloud.com> wrote:
> 
> There is typo in subject.

Yes, :)
> 
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> Currently there are lots of flags and the names are confusing, since
>> there are two main types of flags, sync thread runnng status and sync
>> thread action, rearrange and update comment to improve code readability,
>> there are no functional changes.
>>
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>> ---
>>   drivers/md/md.h | 52 ++++++++++++++++++++++++++++++++++++-------------
>>   1 file changed, 38 insertions(+), 14 deletions(-)
>>
>> diff --git a/drivers/md/md.h b/drivers/md/md.h
>> index 029dd0491a36..2a1cb7b889e5 100644
>> --- a/drivers/md/md.h
>> +++ b/drivers/md/md.h
>> @@ -551,22 +551,46 @@ struct mddev {
>>   };
>>   
>>   enum recovery_flags {
>> +	/* flags for sync thread running status */
>> +
>> +	/*
>> +	 * set when one of sync action is set and new sync thread need to be
>> +	 * registered, or just add/remove spares from conf.
>> +	 */
>> +	MD_RECOVERY_NEEDED,
>> +	/* sync thread is running, or about to be started */
>> +	MD_RECOVERY_RUNNING,
>> +	/* sync thread needs to be aborted for some reason */
>> +	MD_RECOVERY_INTR,
>> +	/* sync thread is done and is waiting to be unregistered */
>> +	MD_RECOVERY_DONE,
>> +	/* running sync thread must abort immediately, and not restart */
>> +	MD_RECOVERY_FROZEN,
>> +	/* waiting for pers->start() to finish */
>> +	MD_RECOVERY_WAIT,
>> +	/* interrupted because io-error */
>> +	MD_RECOVERY_ERROR,
>> +
>> +	/* flags determines sync action */
>> +
>> +	/* if just this flag is set, action is resync. */
>> +	MD_RECOVERY_SYNC,
>> +	/*
>> +	 * paired with MD_RECOVERY_SYNC, if MD_RECOVERY_CHECK is not set,
>> +	 * action is repair, means user requested resync.
>> +	 */
>> +	MD_RECOVERY_REQUESTED,
>>   	/*
>> -	 * If neither SYNC or RESHAPE are set, then it is a recovery.
>> +	 * paired with MD_RECOVERY_SYNC and MD_RECOVERY_REQUESTED, action is
>> +	 * check.
>>   	 */
>> -	MD_RECOVERY_RUNNING,	/* a thread is running, or about to be
>> started */
>> -	MD_RECOVERY_SYNC,	/* actually doing a resync, not a recovery
>> */
>> -	MD_RECOVERY_RECOVER,	/* doing recovery, or need to try it. */
>> -	MD_RECOVERY_INTR,	/* resync needs to be aborted for some
>> reason */
>> -	MD_RECOVERY_DONE,	/* thread is done and is waiting to be
>> reaped */
>> -	MD_RECOVERY_NEEDED,	/* we might need to start a
>> resync/recover */
>> -	MD_RECOVERY_REQUESTED,	/* user-space has requested a sync
>> (used with SYNC) */
>> -	MD_RECOVERY_CHECK,	/* user-space request for check-only, no
>> repair */
>> -	MD_RECOVERY_RESHAPE,	/* A reshape is happening */
>> -	MD_RECOVERY_FROZEN,	/* User request to abort, and not
>> restart, any action */
>> -	MD_RECOVERY_ERROR,	/* sync-action interrupted because
>> io-error */
>> -	MD_RECOVERY_WAIT,	/* waiting for pers->start() to finish */
>> -	MD_RESYNCING_REMOTE,	/* remote node is running resync thread
>> */
>> +	MD_RECOVERY_CHECK,
>> +	/* recovery, or need to try it */
>> +	MD_RECOVERY_RECOVER,
>> +	/* reshape */
>> +	MD_RECOVERY_RESHAPE,
>> +	/* remote node is running resync thread */
>> +	MD_RESYNCING_REMOTE,
>>   };
>>   
>>   enum md_ro_state {
> 
> I don't know if it is better readable but I know that Kernel coding style comes
> with different approach. I used it for enum mddev_flags in md.h please take a
> look.

1) There are two kinds of flags here, for sync thread running status and
for sync action, I think it's better to distinguish them.
2) The names are confusing, for sync thread status I prefer
SYNC_THREAD_xxx and for sync action I prefer SYNC_ACTION_xxx, I plan to
remove the flags to sync action and replace them with enum type in patch
2.

> 
> Also, I get used to comment above, not below enum values but I don't have strong
> justification here.

I do comment above here.

Thanks,
Kuai

> 
> Thanks,
> Mariusz
> 
> 
> .
> 

