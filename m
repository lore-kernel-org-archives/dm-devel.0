Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52BAC21D3C0
	for <dm-devel@lists.linux.dev>; Mon, 21 Jul 2025 06:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753078217; cv=none; b=u6Iw1ZdfkKDzW/lo2E4nnD3MGZ5t84ea/Ss4WyGgMHuH2Cozm8jLYnU3b7vSqsUwMW2dhbunf8CXGsnUr/pZI/K2++TVu1l3hC5Cov4IDIGp6X5/rY0beHTtgtsHc9ReqGaUvejbLJQQ/wV4f8HuDyG5KfB2a2Tv7eVtQA8WgIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753078217; c=relaxed/simple;
	bh=YdNi4rqzaJ2/K/d0sYakKz852DuCCfPoMOsKnVDEw7U=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Mx3tKS2IBhKRSuzl3EWZQ/i20ctiR4mga9KCKw8SUtaElldczt8BqVHzKGd1l4o9mWfYAPClH2g+ogNMy2LFrjB9rQumPX0OFbvyBRaoxLfdlhn+a9jSvgkxUcDiiXSWmSZmgv5D8QL5tOOuhgd0Md3c+/c8nsvZwg01zwxDbMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4blqkX3wNHzYQtvg
	for <dm-devel@lists.linux.dev>; Mon, 21 Jul 2025 14:10:12 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 485D61A0D60
	for <dm-devel@lists.linux.dev>; Mon, 21 Jul 2025 14:10:11 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgBXIBHC2X1oUpToAw--.45771S3;
	Mon, 21 Jul 2025 14:10:11 +0800 (CST)
Subject: Re: [PATCH v3 06/11] md/md-bitmap: delay registration of bitmap_ops
 until creating bitmap
To: Hannes Reinecke <hare@suse.de>, Yu Kuai <yukuai1@huaweicloud.com>,
 corbet@lwn.net, agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
 song@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, yi.zhang@huawei.com,
 yangerkun@huawei.com, johnny.chenyi@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250718092336.3346644-1-yukuai1@huaweicloud.com>
 <20250718092336.3346644-7-yukuai1@huaweicloud.com>
 <ef4a53e0-760e-4ec8-9fdf-f4e8f36360c0@suse.de>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <59f357c2-c69a-69cb-9b79-9841f91ab533@huaweicloud.com>
Date: Mon, 21 Jul 2025 14:10:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <ef4a53e0-760e-4ec8-9fdf-f4e8f36360c0@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXIBHC2X1oUpToAw--.45771S3
X-Coremail-Antispam: 1UD129KBjvdXoWruF4xZF4DGFy3Xw4rKr4rZrb_yoWfGFbE9w
	4UWFZ7Za4xJFWrtr15JFn8ZF40kw4Iyayxtws5AF48Jw13Aa9YyFZYkr9Yk34fCw4UCr43
	GryDAr4ftrnIgjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbfAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
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
	w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x
	0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VU13ku3UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/07/21 14:01, Hannes Reinecke 写道:
>> diff --git a/Documentation/admin-guide/md.rst 
>> b/Documentation/admin-guide/md.rst
>> index 356d2a344f08..03a9f5025f99 100644
>> --- a/Documentation/admin-guide/md.rst
>> +++ b/Documentation/admin-guide/md.rst
>> @@ -388,6 +388,9 @@ All md devices contain:
>>        bitmap
>>            The default internal bitmap
>> +If bitmap_type is not none, then additional bitmap attributes will be
>> +created after md device KOBJ_CHANGE event.
>> +
>>   If bitmap_type is bitmap, then the md device will also contain:
>>     bitmap/location
> 
> Please state _which_ attributes are created with the KOBJ_CHANGE
> event.

Just a notice in case you missed that following statements are exactly
the attributes for bitmap, or do I misunderstood somehow?

Thanks,
Kuai

