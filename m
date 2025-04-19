Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2887A1B6D01
	for <dm-devel@lists.linux.dev>; Sat, 19 Apr 2025 08:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745052376; cv=none; b=gt9dvX8yyCEBVYClYymYEjBth5CN0f9Xr0V5e4JacZr0mOnNb2AzZFHFNbAH7LuOvaemAmrFRh05JCLYYmdJKJbpEfEUKPAEGvD6/FfTsJE7o+uB3UL8/VKmfl8Kl1T5k0L0nNSnYhHiwt1m6mRUlCfNihvN7QhN0EtpmqtAL9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745052376; c=relaxed/simple;
	bh=sKecEVGccN2Gsv7wSldTED5rOsVAxlOK2KmQYKt+9Vo=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=SOBs26CIV5zmWwaALidi3MBKT8bvgNYyhxi7zxAe8E+ABYOOV9rh4dgv3Gn9LUQ8ydNv5XyX+0r0t5SqSIpWa0cMRszUPQP0gCI+s8tDMbuOKwQSifSyvSyA243wue4/vhz6h0Kc6napxt43g9pLaVs+aCUWRqI6KwPwJ7qYitM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4ZflZz1vjqz4f3jtJ
	for <dm-devel@lists.linux.dev>; Sat, 19 Apr 2025 16:45:47 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id B66231A1A43
	for <dm-devel@lists.linux.dev>; Sat, 19 Apr 2025 16:46:05 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgBXu1_LYgNo_N23Jw--.38949S3;
	Sat, 19 Apr 2025 16:46:05 +0800 (CST)
Subject: Re: [PATCH RFC v2 00/14] md: introduce a new lockless bitmap
To: Yu Kuai <yukuai1@huaweicloud.com>, Christoph Hellwig <hch@lst.de>
Cc: xni@redhat.com, colyli@kernel.org, axboe@kernel.dk, agk@redhat.com,
 snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, yi.zhang@huawei.com,
 yangerkun@huawei.com, kbusch@kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20250328060853.4124527-1-yukuai1@huaweicloud.com>
 <Z-aCzTWXzFWe4oxU@infradead.org>
 <c6c608e2-23e7-486f-100a-d1fb6cfff4f2@huaweicloud.com>
 <20250409083208.GA2326@lst.de>
 <115c3b08-aff1-dd97-fe6a-7901452ce62c@huaweicloud.com>
 <20250409094019.GA3890@lst.de>
 <28bb1c35-5f75-4e1c-4b5d-32bcb87050ce@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <54ab4291-9152-44d1-bf6c-675b58cfcea8@huaweicloud.com>
Date: Sat, 19 Apr 2025 16:46:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <28bb1c35-5f75-4e1c-4b5d-32bcb87050ce@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXu1_LYgNo_N23Jw--.38949S3
X-Coremail-Antispam: 1UD129KBjvJXoWxWr43AF43Aw1UKryDXrW5KFg_yoWrKr18pF
	W7Xa4jkrs8Jr13Xr18trZrAF1Syrs7JFsrJrWSk34rC3sFyrnxKF1kKFyYkFy5W3ykWF12
	vrs8Kw43Ar4rZF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBY14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kI
	c2xKxwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r4a6rW5MxAIw28IcxkI7V
	AKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCj
	r7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6x
	IIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAI
	w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x
	0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7sRidbbtUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi, Christoph!

在 2025/04/11 9:36, Yu Kuai 写道:
> Hi,
> 
> 在 2025/04/09 17:40, Christoph Hellwig 写道:
>> On Wed, Apr 09, 2025 at 05:27:11PM +0800, Yu Kuai wrote:
>>>> For that you'd be much better of just creating your own trivial
>>>> file_system_type with an inode fully controlled by your driver
>>>> that has a trivial set of address_space ops instead of oddly
>>>> mixing with the block layer.
>>>
>>> Yes, this is exactly what I said implement a new file_operations(and
>>> address_space ops), I wanted do this the easy way, just reuse the raw
>>> block device ops, this way I just need to implement the submit_bio ops
>>> for new hidden disk.
>>>
>>> I can try with new fs type if we really think this solution is too
>>> hacky, however, the code line will be much more. :(
>>
>> I don't think it should be much more.  It'll also remove the rather
>> unexpected indirection through submit_bio.  Just make sure you use
>> iomap for your operations, and implement the submit_io hook.  That
>> will also be more efficient than the buffer_head based block ops
>> for writes.
>>
>>>>
>>>> Note that either way I'm not sure using the page cache here is an
>>>> all that good idea, as we're at the bottom of the I/O stack and
>>>> thus memory allocations can very easily deadlock.
>>>
>>> Yes, for the page from bitmap, this set do the easy way just read and
>>> ping all realted pages while loading the bitmap. For two reasons:
>>>
>>> 1) We don't need to allocate and read pages from IO path;(In the first
>>> RFC version, I'm using a worker to do that).
>>
>> You still depend on the worker, which will still deadlock.
>>
>>>> What speaks against using your own folios explicitly allocated at
>>>> probe time and then just doing manual submit_bio on that?  That's
>>>> probably not much more code but a lot more robust.
>>>
>>> I'm not quite sure if I understand you correctly. Do you means don't use
>>> pagecache for bitmap IO, and manually create BIOs like the old bitmap,
>>> meanwhile invent a new solution for synchronism instead of the global
>>> spin_lock from old bitmap?
>>
>> Yes.  Alternatively you need to pre-populate the page cache and keep
>> extra page references.
> 
> Ok, I'll think about self managed pages and IO path. Meanwhile, please
> let me know if you have questions with other parts.

So, today I implement a version, and I do admit this way is much
simpler, turns out total 200 less code lines. And can you check the
following untested code if you agree with the implementation? I'll
start to work a new version if you agree.

Thanks,
Kuai

static int llbitmap_rdev_page_io(struct md_rdev *rdev, struct page *page,
                                 ┊int idx, bool rw)
{
         struct bio bio;
         int ret;

         bio_init(&bio, rdev->bdev, bio.bi_inline_vecs, BIO_INLINE_VECS,
                 ┊REQ_SYNC | REQ_IDLE | REQ_META);
         if (rw)
                 bio.bi_opf |= REQ_OP_WRITE;
         else
                 bio.bi_opf |= REQ_OP_READ;

         __bio_add_page(&bio, page, PAGE_SIZE, 0);
         bio.bi_iter.bi_size = PAGE_SIZE;
         bio.bi_iter.bi_sector = rdev->sb_start +
                                 rdev->mddev->bitmap_info.offset +
                                 (PAGE_SECTORS << PAGE_SECTORS_SHIFT);

         ret = submit_bio_wait(&bio);
         bio_uninit(&bio);

         if (ret)
                 md_error(rdev->mddev, rdev);
         return ret;
}

static struct page *llbitmap_read_page(struct llbitmap *llbitmap, int idx)
{
         struct page *page = llbitmap->pages[idx];
         struct mddev *mddev = llbitmap->mddev;
         struct md_rdev *rdev;
         int err = -EIO;

         if (page)
                 return page;

         page = alloc_page(GFP_KERNEL);
         if (!page)
                 return ERR_PTR(-ENOMEM);

         rdev_for_each(rdev, mddev) {
                 if (rdev->raid_disk < 0 || test_bit(Faulty, &rdev->flags))
                         continue;

                 err = llbitmap_rdev_page_io(rdev, page, idx, READ);
                 if (!err)
                         break;
         }

         if (err) {
                 __free_page(page);
                 return ERR_PTR(err);
         }

         return page;
}

static int llbitmap_write_page(struct llbitmap *llbitmap, int idx)
{
         struct page *page = llbitmap->pages[idx];
         struct mddev *mddev = llbitmap->mddev;
         struct md_rdev *rdev;
         int err = -EIO;

         if (!page)
                 return err;

         rdev_for_each(rdev, mddev) {
                 if (rdev->raid_disk < 0 || test_bit(Faulty, &rdev->flags))
                         continue;

                 if (!llbitmap_rdev_page_io(rdev, page, idx, WRITE))
                         err = 0;
         }

         return err;
}

static bool llbitmap_dirty(struct llbitmap *llbitmap)
{
         int i;

         for (i = 0; i < llbitmap->nr_pages; ++i) {
                 struct llbitmap_barrier *barrier = &llbitmap->barrier[i];

                 if (test_bit(BitmapPageDirty, &barrier->flags))
                         return true;
         }

         return false;
}

static void llbitmap_flush_dirty_page(struct llbitmap *llbitmap)
{
         int i;

         for (i = 0; i < llbitmap->nr_pages; ++i) {
                 struct llbitmap_barrier *barrier = &llbitmap->barrier[i];

                 if (!test_and_clear_bit(BitmapPageDirty, &barrier->flags))
                         continue;
                 llbitmap_write_page(llbitmap, i);
         }
}

> 
> Thanks,
> Kuai
> 
>>
>> .
>>
> 
> .
> 

