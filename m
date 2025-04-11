Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 029882572
	for <dm-devel@lists.linux.dev>; Fri, 11 Apr 2025 01:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744335414; cv=none; b=Jaahj/tbsqPAa4Ps0LSmCT26MCADZ/+118slC8DSFn1vb4YI1ZRUCynfxv9/NNxHkDHE2lIDVD/20QyZD/3fIH/yit4EYYgIyQFBcwUeGIB4Tr3dNyEbCu+V3m9XE0gJnAkWBbe1KpDYh0CeOTg2xGjoJW4uiTAM1SbKG0Zzwgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744335414; c=relaxed/simple;
	bh=ZRR2/INA9CZRa8hce9t/BDmx3eaWvex4MtkXrh/QCws=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=omIp0TeKUAi06/uEkqtteAX7T//cJ7/AMsiiZM1qR3ul557yz+5bV0DDMHVRqasZUT6Vv6B3J9G7hcOwOJbhV4l1akVd5VBXhY+23gB2bZQGX23b803gXbYqOO+2R3fp+CaaJ3X4ZbYSmZXDItZ1dhiA/tma16QLTyXwp7Jm3Mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4ZYfRL2SGHz4f3jt7
	for <dm-devel@lists.linux.dev>; Fri, 11 Apr 2025 09:36:30 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 71A201A058E
	for <dm-devel@lists.linux.dev>; Fri, 11 Apr 2025 09:36:48 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgAni18ucvhnmjx9JA--.57143S3;
	Fri, 11 Apr 2025 09:36:48 +0800 (CST)
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
 <115c3b08-aff1-dd97-fe6a-7901452ce62c@huaweicloud.com>
 <20250409094019.GA3890@lst.de>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <28bb1c35-5f75-4e1c-4b5d-32bcb87050ce@huaweicloud.com>
Date: Fri, 11 Apr 2025 09:36:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250409094019.GA3890@lst.de>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAni18ucvhnmjx9JA--.57143S3
X-Coremail-Antispam: 1UD129KBjvJXoW7tF4fKF1kAF43AF47ZrW5KFg_yoW8tr45pF
	ZrW3Waka1DAr17trs2yws7KF4Ska93JFW7JFySgr98Ar95Xr9agr18KF4Y9Fy3Zr1kt3W2
	v34jqF93Za15AFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

Hi,

ÔÚ 2025/04/09 17:40, Christoph Hellwig Ð´µÀ:
> On Wed, Apr 09, 2025 at 05:27:11PM +0800, Yu Kuai wrote:
>>> For that you'd be much better of just creating your own trivial
>>> file_system_type with an inode fully controlled by your driver
>>> that has a trivial set of address_space ops instead of oddly
>>> mixing with the block layer.
>>
>> Yes, this is exactly what I said implement a new file_operations(and
>> address_space ops), I wanted do this the easy way, just reuse the raw
>> block device ops, this way I just need to implement the submit_bio ops
>> for new hidden disk.
>>
>> I can try with new fs type if we really think this solution is too
>> hacky, however, the code line will be much more. :(
> 
> I don't think it should be much more.  It'll also remove the rather
> unexpected indirection through submit_bio.  Just make sure you use
> iomap for your operations, and implement the submit_io hook.  That
> will also be more efficient than the buffer_head based block ops
> for writes.
> 
>>>
>>> Note that either way I'm not sure using the page cache here is an
>>> all that good idea, as we're at the bottom of the I/O stack and
>>> thus memory allocations can very easily deadlock.
>>
>> Yes, for the page from bitmap, this set do the easy way just read and
>> ping all realted pages while loading the bitmap. For two reasons:
>>
>> 1) We don't need to allocate and read pages from IO path;(In the first
>> RFC version, I'm using a worker to do that).
> 
> You still depend on the worker, which will still deadlock.
> 
>>> What speaks against using your own folios explicitly allocated at
>>> probe time and then just doing manual submit_bio on that?  That's
>>> probably not much more code but a lot more robust.
>>
>> I'm not quite sure if I understand you correctly. Do you means don't use
>> pagecache for bitmap IO, and manually create BIOs like the old bitmap,
>> meanwhile invent a new solution for synchronism instead of the global
>> spin_lock from old bitmap?
> 
> Yes.  Alternatively you need to pre-populate the page cache and keep
> extra page references.

Ok, I'll think about self managed pages and IO path. Meanwhile, please
let me know if you have questions with other parts.

Thanks,
Kuai

> 
> .
> 

