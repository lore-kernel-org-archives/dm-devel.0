Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8071325776;
	Sun,  3 Aug 2025 10:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754217221; cv=none; b=WfH/Qc5uhBB6okwBTBw7XP+KQaLP/GAVf90xOmPedfwKpm9NQExrQ9Jese8bIOe/FcfiOvq5siS2U/64OEQaB5a6HOsGPZQlkew+w7a9dLO7BSDoOMUQcN9qvdFmElW3rrGEnhpGrojQ5NQLFke+ByppDOdkYGyUSfgnwTc1puo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754217221; c=relaxed/simple;
	bh=DLYWIq8zJEmNHxQe7BMfZVKgcfHGQvb0iHmZYCuuvZY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BrHalm+BVkuWciqCnoR63X5gGPrYdrqT8J+Zb2cOrdRQLFs6RMx3Bznf3IxQC8s1ZUWvg8/Qugon7YlqMDmaP9TShql8ozi4gIf0DZQ/yyLByzLACAmdvaLep+dvYcp8IBzwjmqjZeyKpm16u3ceelQbztmjIo3UyuiMMotwmxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JTQebgqK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JTQebgqK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CB9EC4CEEB;
	Sun,  3 Aug 2025 10:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754217221;
	bh=DLYWIq8zJEmNHxQe7BMfZVKgcfHGQvb0iHmZYCuuvZY=;
	h=Date:Reply-To:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JTQebgqKwvLEZ1EK3VQEJHobkkCxHbnL+rDHnHMTfx3DDu1lwZ/0kSfqVfCLAurja
	 MZbpMkFZt4v6qqRjKkwTy5jXsUGEfvvtdIIaa3AAGMca5sqy5FqlKPiHILmP2DvMyP
	 K5Mf0k+UE8WVzfT8eh7Kc//Mz/XbqlfM1sLabMXL7+nSnOhwEEvJrq91a73AWkeurc
	 U9LX7D9hVh+EzJPY06EGf+4KDSBNiQyc3C7Wu+zHUOVuI32Cdvwev6BUlS8lIM/9IT
	 wTuWcUPFsL85gbLtd1/ambGTSHkehnyaGFADFUpvsvpbW8da7Atnp1jIvjVC/p1lfM
	 wpa43joielH2g==
Message-ID: <2b099a1c-ba85-4397-a5b1-47f74777703a@kernel.org>
Date: Sun, 3 Aug 2025 18:33:32 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@kernel.org
Subject: Re: [PATCH v5 11/11] md/md-llbitmap: introduce new lockless bitmap
To: Li Nan <linan666@huaweicloud.com>, Yu Kuai <yukuai1@huaweicloud.com>,
 hch@lst.de, corbet@lwn.net, song@kernel.org, yukuai3@huawei.com,
 agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, xni@redhat.com,
 hare@suse.de
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, dm-devel@lists.linux.dev, yi.zhang@huawei.com,
 yangerkun@huawei.com, johnny.chenyi@huawei.com
References: <20250801070346.4127558-1-yukuai1@huaweicloud.com>
 <20250801070346.4127558-12-yukuai1@huaweicloud.com>
 <e6065ccf-4c74-52d3-9f06-7b7cb6499f4e@huaweicloud.com>
Content-Language: en-US
From: Yu Kuai <yukuai@kernel.org>
In-Reply-To: <e6065ccf-4c74-52d3-9f06-7b7cb6499f4e@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2025/8/3 17:48, Li Nan 写道:
>
>
> 在 2025/8/1 15:03, Yu Kuai 写道:
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> Redundant data is used to enhance data fault tolerance, and the storage
>> method for redundant data vary depending on the RAID levels. And it's
>> important to maintain the consistency of redundant data.
>>
>> Bitmap is used to record which data blocks have been synchronized and 
>> which
>> ones need to be resynchronized or recovered. Each bit in the bitmap
>> represents a segment of data in the array. When a bit is set, it 
>> indicates
>> that the multiple redundant copies of that data segment may not be
>> consistent. Data synchronization can be performed based on the bitmap 
>> after
>> power failure or readding a disk. If there is no bitmap, a full disk
>> synchronization is required.
>
> This is a large patch, I've found a few minor issues so far.
> And I'm still working through it.
>
> [...]
>
>> +    [BitDirty] = {
>> +        [BitmapActionStartwrite]    = BitNone,
>> +        [BitmapActionStartsync]        = BitNone,
>> +        [BitmapActionEndsync]        = BitNone,
>> +        [BitmapActionAbortsync]        = BitNone,
>> +        [BitmapActionReload]        = BitNeedSync,
>> +        [BitmapActionDaemon]        = BitClean,
>> +        [BitmapActionDiscard]        = BitUnwritten,
>> +        [BitmapActionStale]        = BitNeedSync,
>> +    },
>
> Bits becomes BitDirt during degraded remains BitDirty even after 
> recover and re-write. Should we consider adjusting this state 
> transition, or maybe trigger the daemon after the recovery is complete?
We should keep this behavior, otherwise readd a disk will be broken, 
we'll have
do do a full resync for the disk instead.

>
> [...]
>
>> +
>> +static int llbitmap_create(struct mddev *mddev)
>> +{
>> +    struct llbitmap *llbitmap;
>> +    int ret;
>> +
>> +    ret = llbitmap_check_support(mddev);
>> +    if (ret)
>> +        return ret;
>> +
>> +    llbitmap = kzalloc(sizeof(*llbitmap), GFP_KERNEL);
>> +    if (!llbitmap)
>> +        return -ENOMEM;
>> +
>> +    llbitmap->mddev = mddev;
>> +    llbitmap->io_size = bdev_logical_block_size(mddev->gendisk->part0);
>> +    llbitmap->blocks_per_page = PAGE_SIZE / llbitmap->io_size;
>
> logical_block_size can > PAGE_SIZE, blocks_per_page is set to 0 which can
> cause issues in later computations.
>
I do not expect this can happen, it's right large lbs for raw disk is 
supported
now, however, mdraid still handles metadata by page, and should forbid large
lbz while assembling the array for now. mdraid need to switch page to folio
to support large lbs, and this will be done later.

Thanks,
Kuai

