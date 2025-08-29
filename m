Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8593C465
	for <dm-devel@lists.linux.dev>; Fri, 29 Aug 2025 01:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756429419; cv=none; b=CO50GUTOvDJfgVXMcLcTOiAomSfl9meoSXUFsOC24i1bgNekNUkhJjwcnhe3OpDyHwdFEBrHLWHH9MH9CJboA7ZqWwb57M9/SjzHpLPMdW8xG6M0bm5RSaksX23JvA8wpPn9mvjx4BYIBfA47ap9TtUNMgeec91ZZYXa3uZpMK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756429419; c=relaxed/simple;
	bh=hOAcyQATWAxzYcSnVX7fz/+B6IAAfqiGWAy4ocesAGU=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=s/ZtcI3ZmwMCq54mz/9N2TTtLAeZckyQs0crre/xC3MOMjmLj6Pdzu3u3q0hfCZ2QPdMj/Bo/Ph5SsxIJCzkj+EB5MAZA/QuCeZjHf/89oACFqK+QkPq9AphDEj5y49+BOJGArlbMpYZjdR/nRWOk7rP1bf6hkMYCbsd4oBwhos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cCg4k3yzfzYQvLb
	for <dm-devel@lists.linux.dev>; Fri, 29 Aug 2025 09:03:34 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 15DAC1A0931
	for <dm-devel@lists.linux.dev>; Fri, 29 Aug 2025 09:03:33 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgDXIY5i_LBo_KyTAg--.37435S3;
	Fri, 29 Aug 2025 09:03:32 +0800 (CST)
Subject: Re: [PATCH v6 md-6.18 11/11] md/md-llbitmap: introduce new lockless
 bitmap
To: Li Nan <linan666@huaweicloud.com>, Yu Kuai <yukuai1@huaweicloud.com>,
 hch@infradead.org, corbet@lwn.net, agk@redhat.com, snitzer@kernel.org,
 mpatocka@redhat.com, song@kernel.org, xni@redhat.com, hare@suse.de,
 colyli@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, yi.zhang@huawei.com,
 yangerkun@huawei.com, johnny.chenyi@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250826085205.1061353-1-yukuai1@huaweicloud.com>
 <20250826085205.1061353-12-yukuai1@huaweicloud.com>
 <93e96f14-dfe3-6390-5a91-f28e1cdb1783@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <dcec1dd2-903a-3569-30e4-7af916ecba4b@huaweicloud.com>
Date: Fri, 29 Aug 2025 09:03:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <93e96f14-dfe3-6390-5a91-f28e1cdb1783@huaweicloud.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDXIY5i_LBo_KyTAg--.37435S3
X-Coremail-Antispam: 1UD129KBjvJXoWxWrWDKw13Ary8JrW3ur1xXwb_yoWrAw1Upr
	ZavF13JrWDJr4rt342yryUXFy8trWUJw17Jr15XF18Arn8Zr1Ygr48WFW0g3srurWxJ3Wj
	qF4UXry5ZFyDJFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

在 2025/08/28 19:24, Li Nan 写道:
> 
> 
> 在 2025/8/26 16:52, Yu Kuai 写道:
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
>>
>> Key Features:
>>
>>   - IO fastpath is lockless, if user issues lots of write IO to the same
>>   bitmap bit in a short time, only the first write have additional 
>> overhead
>>   to update bitmap bit, no additional overhead for the following writes;
>>   - support only resync or recover written data, means in the case 
>> creating
>>   new array or replacing with a new disk, there is no need to do a 
>> full disk
>>   resync/recovery;
>>
>> Key Concept:
>>
>>   - State Machine:
>>
>> Each bit is one byte, contain 6 difference state, see llbitmap_state. And
>> there are total 8 differenct actions, see llbitmap_action, can change 
>> state:
>>
>> llbitmap state machine: transitions between states
>>
>> |           | Startwrite | Startsync | Endsync | Abortsync|
>> | --------- | ---------- | --------- | ------- | -------  |
>> | Unwritten | Dirty      | x         | x       | x        |
>> | Clean     | Dirty      | x         | x       | x        |
>> | Dirty     | x          | x         | x       | x        |
>> | NeedSync  | x          | Syncing   | x       | x        |
>> | Syncing   | x          | Syncing   | Dirty   | NeedSync |
>>
>> |           | Reload   | Daemon | Discard   | Stale     |
>> | --------- | -------- | ------ | --------- | --------- |
>> | Unwritten | x        | x      | x         | x         |
>> | Clean     | x        | x      | Unwritten | NeedSync  |
>> | Dirty     | NeedSync | Clean  | Unwritten | NeedSync  |
>> | NeedSync  | x        | x      | Unwritten | x         |
>> | Syncing   | NeedSync | x      | Unwritten | NeedSync  |
>>
>> Typical scenarios:
>>
>> 1) Create new array
>> All bits will be set to Unwritten by default, if --assume-clean is set,
>> all bits will be set to Clean instead.
>>
>> 2) write data, raid1/raid10 have full copy of data, while raid456 
>> doesn't and
>> rely on xor data
>>
>> 2.1) write new data to raid1/raid10:
>> Unwritten --StartWrite--> Dirty
>>
>> 2.2) write new data to raid456:
>> Unwritten --StartWrite--> NeedSync
>>
>> Because the initial recover for raid456 is skipped, the xor data is 
>> not build
>> yet, the bit must set to NeedSync first and after lazy initial recover is
>> finished, the bit will finially set to Dirty(see 5.1 and 5.4);
>>
>> 2.3) cover write
>> Clean --StartWrite--> Dirty
>>
>> 3) daemon, if the array is not degraded:
>> Dirty --Daemon--> Clean
>>
>> For degraded array, the Dirty bit will never be cleared, prevent full 
>> disk
>> recovery while readding a removed disk.
>>
>> 4) discard
>> {Clean, Dirty, NeedSync, Syncing} --Discard--> Unwritten
>>
>> 5) resync and recover
>>
>> 5.1) common process
>> NeedSync --Startsync--> Syncing --Endsync--> Dirty --Daemon--> Clean
> 
> There is some issue whith Dirty state:
> 1. The Dirty bit will not synced when a disk is re-add.
> 2. It remains Dirty even after a full recovery -- it should be Clean.

We're setting new bits to dirty for degraded array, and there is no
futher action to change the state to need sync before recovery by new
disk.

This can be fixed by setting new bits directly to need sync for degraded
array, will do this in the next version.

Thanks,
Kuai
> 

