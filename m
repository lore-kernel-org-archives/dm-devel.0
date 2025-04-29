Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4D01A8407
	for <dm-devel@lists.linux.dev>; Tue, 29 Apr 2025 01:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745890999; cv=none; b=gWMaFsjYiUj0jbLfpGD8UhwY0McS/yEbxxafU0JaCTGnnYcW85OLm9PrFNsV9o2SfKNrax7bLEaz3+EkPNDiXiiUPAagc/gZ91ZPtMYV+jpOZP5kSbhJ+BMcC+Y99g6PXwMVrad0OX6xlu8kXFPGNsZVtiF+msBNHEYwuPv2E9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745890999; c=relaxed/simple;
	bh=ISwLxZ4Qw6y21hGuiO1AavkdbUe4X2k+AhxsgmkDs+w=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=X83tPeh9XIuwPGYJqQMMraNtuF9MWX5xFL+DTviKeGNBVQBqr7t9zniR819+VSQEn6dg9tn4YC/VrO6MxovFX+JerFbPxOAflJEURYclYi/LiCgwbF+vKmnMBcdCx4KEDY1fBGhdmc7qZ1pf503gdP9mVHPlZyrnMCcf0CWjCZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4ZmjkR3Xffz4f3jqb
	for <dm-devel@lists.linux.dev>; Tue, 29 Apr 2025 09:42:55 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 62F2D1A06E2
	for <dm-devel@lists.linux.dev>; Tue, 29 Apr 2025 09:43:14 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgBXu1+wLhBoJzCBKw--.64964S3;
	Tue, 29 Apr 2025 09:43:14 +0800 (CST)
Subject: Re: [PATCH v2 3/9] block: WARN if bdev inflight counter is negative
To: John Garry <john.g.garry@oracle.com>, Yu Kuai <yukuai1@huaweicloud.com>,
 hch@infradead.org, axboe@kernel.dk, xni@redhat.com, agk@redhat.com,
 snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org, cl@linux.com,
 nadav.amit@gmail.com, ubizjak@gmail.com, akpm@linux-foundation.org
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, yi.zhang@huawei.com,
 yangerkun@huawei.com, johnny.chenyi@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250427082928.131295-1-yukuai1@huaweicloud.com>
 <20250427082928.131295-4-yukuai1@huaweicloud.com>
 <4c6ac59f-0589-4cb9-b909-354d02ee1a44@oracle.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <6bb64a49-a8db-3431-537f-913982886ba9@huaweicloud.com>
Date: Tue, 29 Apr 2025 09:43:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <4c6ac59f-0589-4cb9-b909-354d02ee1a44@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXu1+wLhBoJzCBKw--.64964S3
X-Coremail-Antispam: 1UD129KBjvJXoW7ZFW3Kr4fGr15CFWfKw4kWFg_yoW8WrWDpr
	W8KFZ8Gr98urn5Ar1jq34xXFyrKa1DX3WSvr1fAa4avr4xWr90v3y0g3ZYgrnYqrZ7Kw43
	G3W5tF9ruFy8A37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBF14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x
	0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0pRJPE-UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/04/28 22:06, John Garry 写道:
> On 27/04/2025 09:29, Yu Kuai wrote:
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> Which means there is a BUG
> 
> nit: to me, BUG means symbol BUG(), and not a software bug (which I 
> think that you mean)

Actually, I mean the bio-based disk driver or blk-mq messed up the IO
accounting, IO done is more than IO start, and this is a bug.
> 
>> for related bio-based disk driver, or blk-mq
>> for rq-based disk, it's better not to hide the BUG.
> 
> AFICS, this check was not present for mq, so is it really required now? 
> I suppose that the code is simpler to always have the check. I find it 
> an odd check to begin with...

This check do present for mq, for example, diskstats_show() and
update_io_ticks().

Thanks,
Kuai

> 
>>
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>> ---
>>   block/genhd.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/block/genhd.c b/block/genhd.c
>> index f671d9ee00c4..d158c25237b6 100644
>> --- a/block/genhd.c
>> +++ b/block/genhd.c
>> @@ -136,9 +136,9 @@ static void part_in_flight_rw(struct block_device 
>> *part,
>>           inflight[0] += part_stat_local_read_cpu(part, in_flight[0], 
>> cpu);
>>           inflight[1] += part_stat_local_read_cpu(part, in_flight[1], 
>> cpu);
>>       }
>> -    if ((int)inflight[0] < 0)
>> +    if (WARN_ON_ONCE((int)inflight[0] < 0))
>>           inflight[0] = 0;
>> -    if ((int)inflight[1] < 0)
>> +    if (WARN_ON_ONCE((int)inflight[1] < 0))
>>           inflight[1] = 0;
>>   }
> 
> 
> .
> 

