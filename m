Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8153E28AAE6
	for <dm-devel@lists.linux.dev>; Thu, 28 Aug 2025 07:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756365059; cv=none; b=IkUMFNPlryto+rYmyfLWTzx8X5k1IaX3PcHVYqm2DjNyOFO/mmur8GQweNYvNPZPvLtvRQC6iZXfjxbVXX+wsi4a9iRrbK7nCTq8mGprrTA1CQrfGU6349yM997xwnFxuOzcOYk9faYeCpr7++zQxFKykuT4QGM08Kz4na3VXnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756365059; c=relaxed/simple;
	bh=cuLrA6c/v3D9fwcoximnAql+jlHCEAydo8gYwte2HAA=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=UoaBeU9dNagakqSsWmuhzrJZHKjHbYAdqkn/G1EbwwuqlmpYjkmCbsX3F7j8bVk74PA4apkgqMBQ9Zw8v3Q8lbxYE/lFubkyRY+GTiygWGZMv1FTgDHfXLLVaL9gXqxlF5ppnRjoynBC76qgzWXeSEiguZL480C4C1PDNX/6csA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cCCH50WnBzYQtw8
	for <dm-devel@lists.linux.dev>; Thu, 28 Aug 2025 15:10:57 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 94F021A0359
	for <dm-devel@lists.linux.dev>; Thu, 28 Aug 2025 15:10:55 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgAXYIz8ALBowOE9Ag--.63876S3;
	Thu, 28 Aug 2025 15:10:55 +0800 (CST)
Subject: Re: [PATCH v6 md-6.18 11/11] md/md-llbitmap: introduce new lockless
 bitmap
To: Paul Menzel <pmenzel@molgen.mpg.de>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@infradead.org, corbet@lwn.net, agk@redhat.com, snitzer@kernel.org,
 mpatocka@redhat.com, song@kernel.org, xni@redhat.com, hare@suse.de,
 linan122@huawei.com, colyli@kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 johnny.chenyi@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250826085205.1061353-1-yukuai1@huaweicloud.com>
 <20250826085205.1061353-12-yukuai1@huaweicloud.com>
 <4d21e669-f989-4bbc-8c38-ac1b311e8d01@molgen.mpg.de>
 <65a2856a-7e2f-111a-c92e-7941206ad006@huaweicloud.com>
 <8eb5acff-4c21-4be8-8d3c-b98bd258ef99@molgen.mpg.de>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <791992fe-3b98-1d00-6276-56fa1b45b2c8@huaweicloud.com>
Date: Thu, 28 Aug 2025 15:10:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <8eb5acff-4c21-4be8-8d3c-b98bd258ef99@molgen.mpg.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXYIz8ALBowOE9Ag--.63876S3
X-Coremail-Antispam: 1UD129KBjvJXoW7KF18uw47AFWDtw45Gw1rJFb_yoW8ZF47pa
	4rKFyrKas8Jr4vvw1Iq3Z3JFyFyr97tFWUGr1rXa4rWr15JrySgFWIgF1Y934DGr1rXry2
	vw4UtryrWanIy3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBa14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x
	0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVW8JVW5JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY
	6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aV
	CY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0pRHUDLUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/08/27 14:07, Paul Menzel 写道:
> Dear Kuai,
> 
> 
> Thank you for your reply.
> 
> Am 27.08.25 um 05:44 schrieb Yu Kuai:
> 
>> 在 2025/08/26 17:52, Paul Menzel 写道:
>>> It’d be great if you could motivate, why a lockless bitmap is needed 
>>> > compared to the current implemention.
>>
>> Se the performance test, old bitmap have global spinlock and is bad with
>> fast disk.
> 
> Yes, but it’s at the end, and not explicitly stated. Should you resend, 
> it’d be great if you could add that.

If there is no suggestions about functionality, I can add following in
the beginning when I apply this:

Due to known performance issues with md-bitmap and the unreasonable
implementations:

  - self-managed IO submitting like filemap_write_page();
  - global spin_lock

I have decided not to continue optimizing based on the current bitmap
implementation.

And the same as fixing those typos.

Thanks,
Kuai

> 
>> [snip the typo part]
>>
>>> How can/should this patch be tested/benchmarked?
>>
>> There is pending mdadm patch, rfc verion can be used. Will work on
>> formal version after this set is applied.
> 
> Understood. Maybe add an URL to the mdadm patch. (Sorry, should I have 
> missed it.)
> 
>>> --- a/drivers/md/md-bitmap.h
>>> +++ b/drivers/md/md-bitmap.h
>>> @@ -9,10 +9,26 @@
>>>    #define BITMAP_MAGIC 0x6d746962
>>> +/*
>>> + * version 3 is host-endian order, this is deprecated and not used 
>>> for new
>>> + * array
>>> + */
>>> +#define BITMAP_MAJOR_LO        3
>>> +#define BITMAP_MAJOR_HOSTENDIAN    3
>>> +/* version 4 is little-endian order, the default value */
>>> +#define BITMAP_MAJOR_HI        4
>>> +/* version 5 is only used for cluster */
>>> +#define BITMAP_MAJOR_CLUSTERED    5
> 
>>> Move this to the header in a separate patch?
>>
>> I prefer not, old bitmap use this as well.
> Hmm, I do not understand the answer, as it’s moved in this patch, why 
> can’t it be moved in another? But it’s not that important.
> 
> 
> Kind regards,
> 
> Paul
> .
> 

