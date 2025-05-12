Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1516D255227
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 06:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747029964; cv=none; b=pbxnuRgkmgZbIjfeVAsA5QkBEeRU36P6sVv88K2PjfCyrMou9DCt9puM1VUIzsc4LohP4fGC+WSA2OT2Y18wujftG09ZyjD6fh99JT4SyVbji3IbnNIK0nNd30HQZ1y38FBueYKyNPghPOJ22iIyHHRIbrzjKc5qwlP1nplZvRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747029964; c=relaxed/simple;
	bh=bq67q7+bU5SxI5x84gX3+S/6BoUlZWkfuzP9TZlO2c0=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=O5L298gWhXWd/VBXw5egVWdbOKaTDWorJNu+yWPuYGYnARY1KnYG/M82Humps4SCPjdBRGocOGjeIx2s7BImz1ZwACv8/5+Xul2Vr/WCFk7idFVmBv36/DM9ECUCfkhwarKJI4Y3X5HCLkrZ8bznm06qtoY7E4JBbbX3lYYiJmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4ZwpxT3Ys6z4f3jXg
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 14:05:33 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 30FE31A018D
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 14:05:58 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgAHa1_EjyFo8K+pMA--.56895S3;
	Mon, 12 May 2025 14:05:58 +0800 (CST)
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
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <2830c5d0-cc04-51eb-6785-79d0a43f4fc4@huaweicloud.com>
Date: Mon, 12 May 2025 14:05:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250512044125.GB868@lst.de>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHa1_EjyFo8K+pMA--.56895S3
X-Coremail-Antispam: 1UD129KBjvJXoW7uFW7AFy5GFyDKryUur47XFb_yoW8GFW3pa
	9FqFW3KFs8XF9Y9347X34YgF1Fqw1DGr90yFyIgr45Gw1rCr93CF4fua4YvF15uryxZF4j
	va10y3W3Xry8WrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUB214x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x
	0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvjfUonmRUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/05/12 12:41, Christoph Hellwig Ð´µÀ:
> On Mon, May 12, 2025 at 09:19:10AM +0800, Yu Kuai wrote:
>> +++ b/drivers/md/md.c
>> @@ -8849,14 +8849,24 @@ static void md_bitmap_start(struct mddev *mddev,
>>   		mddev->pers->bitmap_sector(mddev, &md_io_clone->offset,
>>   					   &md_io_clone->sectors);
>>   
>> -	mddev->bitmap_ops->startwrite(mddev, md_io_clone->offset,
>> -				      md_io_clone->sectors);
>> +	if (unlikely(md_io_clone->rw == STAT_DISCARD) &&
>> +	    mddev->bitmap_ops->start_discard)
>> +		mddev->bitmap_ops->start_discard(mddev, md_io_clone->offset,
>> +						 md_io_clone->sectors);
>> +	else
>> +		mddev->bitmap_ops->startwrite(mddev, md_io_clone->offset,
>> +					      md_io_clone->sectors);
>>   }
> 
> This interface feels weird, as it would still call into the write
> interfaces when the discard ones are not defined instead of doing
> nothing.  Also shouldn't discard also use a different interface
> than md_bitmap_start in the caller?

This is because the old bitmap handle discard the same as write, I
can't do nothing in this case. Do you prefer also reuse the write
api to new discard api for old bitmap?

For the caller, I think it's fine, since bitmap framwork already
calculate sectors and len for discard as well.
> 
> I'd also expect the final version of this to be merged with the
> previous patch, as adding an interface without the only user is a
> bit odd.

Sure.

Thanks,
Kuai

> .
> 

