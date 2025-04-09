Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C3214D70E
	for <dm-devel@lists.linux.dev>; Wed,  9 Apr 2025 09:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744190846; cv=none; b=MQwT7rpkToUYltMfxWvLJxIk9ZHUC7cWP5exEnljI9UCmEogk1mABaC/XKZ3WkY6uK0LWGKjBG5M2hqVVUMSCZ6W0hqY5RWC8D8s3pb8htYqgoowdyCs57z5CG/+ptRnChxc2YQpd2c3N7clCCnaHdDEwLyO7FoDmGcHkfiVFFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744190846; c=relaxed/simple;
	bh=hO0SDwT67pLhlDTtYRqAD+v/GxTRKC3nAKAXae4odSQ=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Q80Q1cK2dGhREZHLHIWdD34ebgDZWx5njhEmH9/ab0ypV2E0h/KRy8kbmIOX4dApUel+EWKn5As8aLXgoiwy4KY6pbWEUPS+TdOjszIxoVri9zqhsVNPC5MMyw3MwZPGM/xLPPIUMhOnjRoVqbj1E9LkhycIgXM88aPj3mbyG1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4ZXcz3668Dz4f3jt8
	for <dm-devel@lists.linux.dev>; Wed,  9 Apr 2025 17:26:55 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id DBC761A058E
	for <dm-devel@lists.linux.dev>; Wed,  9 Apr 2025 17:27:13 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgCnC2BvPfZncubXIw--.15724S3;
	Wed, 09 Apr 2025 17:27:13 +0800 (CST)
Subject: Re: [PATCH RFC v2 00/14] md: introduce a new lockless bitmap
To: Christoph Hellwig <hch@lst.de>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: xni@redhat.com, colyli@kernel.org, axboe@kernel.dk, agk@redhat.com,
 snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, yi.zhang@huawei.com,
 yangerkun@huawei.com, kbusch@kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20250328060853.4124527-1-yukuai1@huaweicloud.com>
 <Z-aCzTWXzFWe4oxU@infradead.org>
 <c6c608e2-23e7-486f-100a-d1fb6cfff4f2@huaweicloud.com>
 <20250409083208.GA2326@lst.de>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <115c3b08-aff1-dd97-fe6a-7901452ce62c@huaweicloud.com>
Date: Wed, 9 Apr 2025 17:27:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250409083208.GA2326@lst.de>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnC2BvPfZncubXIw--.15724S3
X-Coremail-Antispam: 1UD129KBjvJXoWxWry5WFWDtw4fJw4fCFykXwb_yoW5CFW3pF
	ZxKr1Fkr4DJrWxWrn7Zws7XFyFk3ykJFZrJrySq3sYkr98Grna9r18KayYqa4UXr48JF4a
	vFWvq34rXa15AFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBF14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
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

ÔÚ 2025/04/09 16:32, Christoph Hellwig Ð´µÀ:
> On Sat, Mar 29, 2025 at 09:11:13AM +0800, Yu Kuai wrote:
>> The purpose here is to hide the low level bitmap IO implementation to
>> the API disk->submit_bio(), and the bitmap IO can be converted to buffer
>> IO to the bdev_file. This is the easiest way that I can think of to
>> resue the pagecache, with natural ability for dirty page writeback. I do
>> think about creating a new anon file and implement a new
>> file_operations, this will be much more complicated.
> 
> I've started looking at this a bit now, sorry for the delay.
> 
> As far as I can see you use the bitmap file just so that you have your
> own struct address_space and thus page cache instance and then call
> read_mapping_page and filemap_write_and_wait_range on it right?
Yes.

> 
> For that you'd be much better of just creating your own trivial
> file_system_type with an inode fully controlled by your driver
> that has a trivial set of address_space ops instead of oddly
> mixing with the block layer.

Yes, this is exactly what I said implement a new file_operations(and
address_space ops), I wanted do this the easy way, just reuse the raw
block device ops, this way I just need to implement the submit_bio ops
for new hidden disk.

I can try with new fs type if we really think this solution is too
hacky, however, the code line will be much more. :(

> 
> Note that either way I'm not sure using the page cache here is an
> all that good idea, as we're at the bottom of the I/O stack and
> thus memory allocations can very easily deadlock.

Yes, for the page from bitmap, this set do the easy way just read and
ping all realted pages while loading the bitmap. For two reasons:

1) We don't need to allocate and read pages from IO path;(In the first
RFC version, I'm using a worker to do that).
2) In the first RFC version, I find and get page in the IO path, turns
out page reference is an *atomic*, and the overhead is not acceptable;

And the only action from IO path is that if bitmap page is dirty,
filemap_write_and_wait_range() is called from async worker, the same as
old bitmap, to flush bitmap dirty pages.
> 
> What speaks against using your own folios explicitly allocated at
> probe time and then just doing manual submit_bio on that?  That's
> probably not much more code but a lot more robust.

I'm not quite sure if I understand you correctly. Do you means don't use
pagecache for bitmap IO, and manually create BIOs like the old bitmap,
meanwhile invent a new solution for synchronism instead of the global
spin_lock from old bitmap?

Thanks,
Kuai

> 
> Also a high level note: the bitmap_operations aren't a very nice
> interface.  A lot of methods are empty and should just be called
> conditionally.  Or even better you'd do away with the expensive
> indirect calls and just directly call either the old or new
> bitmap code.
> 
>> Meanwhile, bitmap file for the old bitmap will be removed sooner or
>> later, and this bdev_file implementation will compatible with bitmap
>> file as well.
> 
> Which would also mean that at that point the operations vector would
> be pointless, so we might as well not add it to start with.
> 
> .
> 

