Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666794A23
	for <dm-devel@lists.linux.dev>; Thu, 28 Aug 2025 11:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756380296; cv=none; b=YAGT0an7R5QiSHHCExcKl4idlnrIBRmBnIKhFMj4OmJiS3aGaWiaQWWhcnmlx/LEG6HZIU2pDeKN6yPyNtO6hYf/HLsC6cIKzUNTcDr4GS8wtiIUmkHEoZTMyRVNyoy3cktj9amAGUiNLF+prEdxMZbWG37/LPXO7JvUg+65a20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756380296; c=relaxed/simple;
	bh=TXeRFLOKaqNXdI3M+wtltoVaeAc4aWofDcyk4oABMPc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rcYpfKZnTnk9mKB6rkBkdJHyZ2vkqRjrL0TA/b37pNPNBLEJP0numINnSw3RhfCsEFfCsBzHwBzejSbe385VPyc0EtHc0DTAIWC2sxmIEIdWlAnxVC0n4PFUyApFLmTL+kweyzRnWsK3S2X3ZGHZdl7QLs1paLia3c337Ysxn3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cCJw35gT1zYQvT6
	for <dm-devel@lists.linux.dev>; Thu, 28 Aug 2025 19:24:51 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 4FDA31A0C78
	for <dm-devel@lists.linux.dev>; Thu, 28 Aug 2025 19:24:50 +0800 (CST)
Received: from [10.174.179.247] (unknown [10.174.179.247])
	by APP4 (Coremail) with SMTP id gCh0CgAncIyAPLBoCCNSAg--.3285S3;
	Thu, 28 Aug 2025 19:24:50 +0800 (CST)
Message-ID: <93e96f14-dfe3-6390-5a91-f28e1cdb1783@huaweicloud.com>
Date: Thu, 28 Aug 2025 19:24:48 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v6 md-6.18 11/11] md/md-llbitmap: introduce new lockless
 bitmap
To: Yu Kuai <yukuai1@huaweicloud.com>, hch@infradead.org, corbet@lwn.net,
 agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
 xni@redhat.com, hare@suse.de, colyli@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, yukuai3@huawei.com,
 yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com
References: <20250826085205.1061353-1-yukuai1@huaweicloud.com>
 <20250826085205.1061353-12-yukuai1@huaweicloud.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20250826085205.1061353-12-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAncIyAPLBoCCNSAg--.3285S3
X-Coremail-Antispam: 1UD129KBjvJXoWxGr4UAw43Jry5Xr47Cry5twb_yoW5ZrWxpw
	sIyrn7Jrs8tr48K3sFqFyxta4SyrW8Jw13Jr15GF1vvw1q9rnIvF48WFW0q3srCry3X3Wj
	qF4qvry8JFWDCFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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



在 2025/8/26 16:52, Yu Kuai 写道:
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
> Key Features:
> 
>   - IO fastpath is lockless, if user issues lots of write IO to the same
>   bitmap bit in a short time, only the first write have additional overhead
>   to update bitmap bit, no additional overhead for the following writes;
>   - support only resync or recover written data, means in the case creating
>   new array or replacing with a new disk, there is no need to do a full disk
>   resync/recovery;
> 
> Key Concept:
> 
>   - State Machine:
> 
> Each bit is one byte, contain 6 difference state, see llbitmap_state. And
> there are total 8 differenct actions, see llbitmap_action, can change state:
> 
> llbitmap state machine: transitions between states
> 
> |           | Startwrite | Startsync | Endsync | Abortsync|
> | --------- | ---------- | --------- | ------- | -------  |
> | Unwritten | Dirty      | x         | x       | x        |
> | Clean     | Dirty      | x         | x       | x        |
> | Dirty     | x          | x         | x       | x        |
> | NeedSync  | x          | Syncing   | x       | x        |
> | Syncing   | x          | Syncing   | Dirty   | NeedSync |
> 
> |           | Reload   | Daemon | Discard   | Stale     |
> | --------- | -------- | ------ | --------- | --------- |
> | Unwritten | x        | x      | x         | x         |
> | Clean     | x        | x      | Unwritten | NeedSync  |
> | Dirty     | NeedSync | Clean  | Unwritten | NeedSync  |
> | NeedSync  | x        | x      | Unwritten | x         |
> | Syncing   | NeedSync | x      | Unwritten | NeedSync  |
> 
> Typical scenarios:
> 
> 1) Create new array
> All bits will be set to Unwritten by default, if --assume-clean is set,
> all bits will be set to Clean instead.
> 
> 2) write data, raid1/raid10 have full copy of data, while raid456 doesn't and
> rely on xor data
> 
> 2.1) write new data to raid1/raid10:
> Unwritten --StartWrite--> Dirty
> 
> 2.2) write new data to raid456:
> Unwritten --StartWrite--> NeedSync
> 
> Because the initial recover for raid456 is skipped, the xor data is not build
> yet, the bit must set to NeedSync first and after lazy initial recover is
> finished, the bit will finially set to Dirty(see 5.1 and 5.4);
> 
> 2.3) cover write
> Clean --StartWrite--> Dirty
> 
> 3) daemon, if the array is not degraded:
> Dirty --Daemon--> Clean
> 
> For degraded array, the Dirty bit will never be cleared, prevent full disk
> recovery while readding a removed disk.
> 
> 4) discard
> {Clean, Dirty, NeedSync, Syncing} --Discard--> Unwritten
> 
> 5) resync and recover
> 
> 5.1) common process
> NeedSync --Startsync--> Syncing --Endsync--> Dirty --Daemon--> Clean

There is some issue whith Dirty state:
1. The Dirty bit will not synced when a disk is re-add.
2. It remains Dirty even after a full recovery -- it should be Clean.

-- 
Thanks,
Nan

