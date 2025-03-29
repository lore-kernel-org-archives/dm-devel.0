Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B7F1C36
	for <dm-devel@lists.linux.dev>; Sat, 29 Mar 2025 01:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743210684; cv=none; b=jGoaVO2jZy6nCGudEqPY+bXikpgEmhq2ODivUzTVAVl2TZrU5dUriB6pR8ZebIbRmx5kU8CemvQGGcgcAdp8seaZRpL+jIin8QeDaZdRwmVpkWAnvZkEjh4TE8bVcKy063g4wzeYZxcY98RprkGfdNF61yTD/9Gt63pumQt+iBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743210684; c=relaxed/simple;
	bh=UO+g2BYpGAaukMg/9O98RekdQq371VrJWc/GvFKjUQY=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=LsbIw6eEyZqZhOKpA/dW4NFxn23HKu5nc0AEFt2Bwq+yKG5Rs2BYjuFO+FTJJsA6wfd039caAQlqgvoNvF3qL8pwBH2ZfH9UaANj6B3AUC6PQ57yRvR2yOONjfWKc4DuJ7VYrvjTNrL+QOCIpG2SI7QjhNG1RawGoGpL6e5/hEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4ZPfTs624nz4f3jtF
	for <dm-devel@lists.linux.dev>; Sat, 29 Mar 2025 09:10:57 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 7B7CA1A1388
	for <dm-devel@lists.linux.dev>; Sat, 29 Mar 2025 09:11:15 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgCH61+xSOdn_T56Hw--.31005S3;
	Sat, 29 Mar 2025 09:11:15 +0800 (CST)
Subject: Re: [PATCH RFC v2 00/14] md: introduce a new lockless bitmap
To: Christoph Hellwig <hch@infradead.org>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@lst.de, xni@redhat.com, colyli@kernel.org, axboe@kernel.dk,
 agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, yi.zhang@huawei.com,
 yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250328060853.4124527-1-yukuai1@huaweicloud.com>
 <Z-aCzTWXzFWe4oxU@infradead.org>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <c6c608e2-23e7-486f-100a-d1fb6cfff4f2@huaweicloud.com>
Date: Sat, 29 Mar 2025 09:11:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <Z-aCzTWXzFWe4oxU@infradead.org>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCH61+xSOdn_T56Hw--.31005S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Ar1fKw1UGr4rWw1xKF4xtFb_yoW8Jw1fpF
	ZIqw4UGw4kAr4Y9rn7Cay7GFy0q3ykJrnxWryFqr9IgFn8uFna9F1fKanYka45urn7GF1a
	vas5XryrGa18uFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBF14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x
	0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0pRHUDLUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/03/28 19:06, Christoph Hellwig Ð´µÀ:
> On Fri, Mar 28, 2025 at 02:08:39PM +0800, Yu Kuai wrote:
>> A hidden disk, named mdxxx_bitmap, is created for bitmap, see details in
>> llbitmap_add_disk(). And a file is created as well to manage bitmap IO for
>> this disk, see details in llbitmap_open_disk(). Read/write bitmap is
>> converted to buffer IO to this file.
>>
>> IO fast path will set bits to dirty, and those dirty bits will be cleared
>> by daemon after IO is done. llbitmap_barrier is used to syncronize between
>> IO path and daemon;
> 
> Why do you need a separate gendisk?  I'll try to find some time to read
> the code to understand what it does, but it would also be really useful
> to explain the need for such an unusual concept here.

The purpose here is to hide the low level bitmap IO implementation to
the API disk->submit_bio(), and the bitmap IO can be converted to buffer
IO to the bdev_file. This is the easiest way that I can think of to
resue the pagecache, with natural ability for dirty page writeback. I do
think about creating a new anon file and implement a new
file_operations, this will be much more complicated.

Meanwhile, bitmap file for the old bitmap will be removed sooner or
later, and this bdev_file implementation will compatible with bitmap
file as well.

Thanks,
Kuai

> 
> .
> 

