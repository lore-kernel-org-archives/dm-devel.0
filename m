Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA90A2DFA26
	for <dm-devel@lists.linux.dev>; Thu,  4 Sep 2025 09:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756977591; cv=none; b=XaOATWRaLDP1jhkhKdeX2mFBAUTdA8lC99T6Z41rLN61XcQ/qyy5WDAJytsjEYniUmAzhCtAVyQl8UaJ4Z9qPwJhcKA2a3vDqy+iU3Ec/iHKUvQGJiS0nNlSH0AlObXZouRGIyJx2u719PesO+Exbaqgg15rNCqruK4m7Eb2fEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756977591; c=relaxed/simple;
	bh=gcxK35ct7x68sSLxRnUL8USHJPcYxUnjSbIyvrRLSPU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vi/80M1otoTFOmG0/Z9zhctGY3+ALjb1DCCvi2dyJy6xfv7JSbhpzl45kOMpkYDZ+7tCo5hE20ndcacwoUdZKZLQvY7o66r6sZYmcNSF5BklPWUhzJj05pyp7NjbAIr6qAnDNQuZxWLeZek3aQXAkw96M6nxSyNVyLkaPraYDL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4cHYpW2626zKHN39
	for <dm-devel@lists.linux.dev>; Thu,  4 Sep 2025 17:19:47 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 3888A1A0BDA
	for <dm-devel@lists.linux.dev>; Thu,  4 Sep 2025 17:19:47 +0800 (CST)
Received: from [10.174.179.247] (unknown [10.174.179.247])
	by APP4 (Coremail) with SMTP id gCh0CgB3wY2xWblocc9nBQ--.16239S3;
	Thu, 04 Sep 2025 17:19:47 +0800 (CST)
Message-ID: <e4da9027-abb4-76d1-04df-fff9798baae1@huaweicloud.com>
Date: Thu, 4 Sep 2025 17:19:45 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v7 md-6.18 11/11] md/md-llbitmap: introduce new lockless
 bitmap
To: Yu Kuai <yukuai1@huaweicloud.com>, hch@infradead.org, xni@redhat.com,
 colyli@kernel.org, corbet@lwn.net, agk@redhat.com, snitzer@kernel.org,
 mpatocka@redhat.com, song@kernel.org, yukuai3@huawei.com, hare@suse.de
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, yi.zhang@huawei.com,
 yangerkun@huawei.com, johnny.chenyi@huawei.com, hailan@yukuai.org.cn
References: <20250829080426.1441678-1-yukuai1@huaweicloud.com>
 <20250829080426.1441678-12-yukuai1@huaweicloud.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20250829080426.1441678-12-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB3wY2xWblocc9nBQ--.16239S3
X-Coremail-Antispam: 1UD129KBjvJXoW7KF48ZFyUuF1DuFykCFW7Arb_yoW8JFWkpF
	Z7K398CrZ8Ar4fuw1xJrWxZa4rZrWkZr1fKrWrt347Zr98Grn3WF1xKa1FgFyvyryxWF9I
	vr4UKryrGr90kaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPI14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
	F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r
	4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v
	4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7
	AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02
	F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_Wr
	ylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r
	1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0pRB
	Vb9UUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/8/29 16:04, Yu Kuai 写道:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> Redundant data is used to enhance data fault tolerance, and the storage
> method for redundant data vary depending on the RAID levels. And it's
> important to maintain the consistency of redundant data.
> 
> Bitmap is used to record which data blocks have been synchronized and which
> ones need to be resynchronized or recovered. Each bit in the bitmap
> represents a segment of data in the array. When a bit is set, it indicates
> that the multiple redundant copies of that data segment may not be
> consistent. Data synchronization can be performed based on the bitmap after
> power failure or readding a disk. If there is no bitmap, a full disk
> synchronization is required.
> 
> Due to known performance issues with md-bitmap and the unreasonable
> implementations:
> 
>   - self-managed IO submitting like filemap_write_page();
>   - global spin_lock
> 
> I have decided not to continue optimizing based on the current bitmap
> implementation, this new bitmap is invented without locking from IO fast
> path and can be used with fast disks.
> 
> For designs and details, see the comments in drivers/md-llbitmap.c.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>

LGTM

Reviewed-by: Li Nan <linan122@huawei.com>

-- 
Thanks,
Nan

