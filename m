Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8F2254869
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 06:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747030980; cv=none; b=lcbQsGDb5pfa3XvunPGo5IDu9eAnb9250mZA0Jvvl6YNR8tGtVM/u5X6I2Xg+3Nf9yAh0e3T7+bBux/XGumhC9C6tD+Wv0l2gRB/VoVWf/ajD/1OO3VnIojWpa3tVPTDIpsfgN4aPqaFZgSoNuxYiSIGYNpkL4X7Voe/F5f/g2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747030980; c=relaxed/simple;
	bh=BJiAnYwY1jKc9LgLKpMJUqveSH2oaZPWb0YakqZ9Vfs=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=cLs+zY0Vvj8hWsG9ufeHNp0UguOMt/hKDvSTLatiGXNGfBRcZcnlAFTueYiHbfmrkkGq5dqPtP+/fKqGoSwXPpJGfeCCgQie2hA8w3RlUMDbclUJXhZr7rNKOKb4gLjKK4th46RxZQfORxXyUdVkYgqzOS37nf3Llr1ygUptWvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4ZwqKY0575zKHMVj
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 14:22:57 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id ACAFB1A0359
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 14:22:55 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgAHa1+9kyFoatuqMA--.57068S3;
	Mon, 12 May 2025 14:22:55 +0800 (CST)
Subject: Re: [PATCH RFC md-6.16 v3 02/19] md: support discard for bitmap ops
To: Christoph Hellwig <hch@lst.de>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: xni@redhat.com, colyli@kernel.org, agk@redhat.com, snitzer@kernel.org,
 mpatocka@redhat.com, song@kernel.org, linux-kernel@vger.kernel.org,
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, yi.zhang@huawei.com,
 yangerkun@huawei.com, johnny.chenyi@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250512011927.2809400-1-yukuai1@huaweicloud.com>
 <20250512011927.2809400-3-yukuai1@huaweicloud.com>
 <20250512044125.GB868@lst.de>
 <2830c5d0-cc04-51eb-6785-79d0a43f4fc4@huaweicloud.com>
 <20250512061239.GA2893@lst.de>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <7bfc4eb5-8f6f-663c-f1e2-faf6c1690866@huaweicloud.com>
Date: Mon, 12 May 2025 14:22:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250512061239.GA2893@lst.de>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHa1+9kyFoatuqMA--.57068S3
X-Coremail-Antispam: 1UD129KBjvdXoWruw15JryUXFW7trWrCF4rKrg_yoWkZrbE93
	WDu34qkw15J39aqF9Iyr95Aa98G3WrXF9rZrs5GFyUt3yxXay3CFWSvr9xA397XF43Arn0
	krsFvFy5XrWSgjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbS8FF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kI
	c2xKxwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7V
	AKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCj
	r7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6x
	IIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAI
	w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x
	0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUZYFZUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/05/12 14:12, Christoph Hellwig Ð´µÀ:
> On Mon, May 12, 2025 at 02:05:56PM +0800, Yu Kuai wrote:
>>>>    -	mddev->bitmap_ops->startwrite(mddev, md_io_clone->offset,
>>>> -				      md_io_clone->sectors);
>>>> +	if (unlikely(md_io_clone->rw == STAT_DISCARD) &&
>>>> +	    mddev->bitmap_ops->start_discard)
>>>> +		mddev->bitmap_ops->start_discard(mddev, md_io_clone->offset,
>>>> +						 md_io_clone->sectors);
>>>> +	else
>>>> +		mddev->bitmap_ops->startwrite(mddev, md_io_clone->offset,
>>>> +					      md_io_clone->sectors);
>>>>    }
>>>
>>> This interface feels weird, as it would still call into the write
>>> interfaces when the discard ones are not defined instead of doing
>>> nothing.  Also shouldn't discard also use a different interface
>>> than md_bitmap_start in the caller?
>>
>> This is because the old bitmap handle discard the same as write, I
>> can't do nothing in this case. Do you prefer also reuse the write
>> api to new discard api for old bitmap?
> 
> It can just point the discard method to the same function as the
> existing write one.

Yes, this is exactly want I mean, I'll update this in the next version.

Thanks,
Kuai

> 
> .
> 

