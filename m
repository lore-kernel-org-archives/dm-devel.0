Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90F12E36ED
	for <dm-devel@lists.linux.dev>; Tue,  5 Aug 2025 01:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754356556; cv=none; b=t1OAIQWm3c6MxahMiIIpaZKCKth/sMwI7EgED64MNWVa86rPX71jTH5JjNqWRneh40y5WWf1MyvSInZL4qvQ3lNOX2KvQ0y4qbBcEnvg8MancMOoYf6OgF0290UaSvjjO31ZVeWECTrOWhjXk/lgdKW/qmjj/92JuUU/MU1U7GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754356556; c=relaxed/simple;
	bh=V78xahyJ1ep3lliD6kGEhd9fl1U9Xx618/exFlNyj4I=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=S5Mp6ydgE6fZL7dyUsGrQVAtNR5lIviKM0tSg+pxgI5PNpNmWFI490OwK//aLjpQrrqtlbyOJdMqU3W7EhklFgn2ojDA3vW2RdJ51kjLgQGu1uT6NbquKOSdgThpCS/VoaTw5Zeq57UVvGr8dMIsH2awf1z37DTvrbFyRvRewAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4bwwTt5wGZzKHMsD
	for <dm-devel@lists.linux.dev>; Tue,  5 Aug 2025 09:15:46 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id D51E21A0359
	for <dm-devel@lists.linux.dev>; Tue,  5 Aug 2025 09:15:45 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgBHwhI_W5FolqNpCg--.41295S3;
	Tue, 05 Aug 2025 09:15:45 +0800 (CST)
Subject: Re: [PATCH v5 08/11] md/md-bitmap: add a new method blocks_synced()
 in bitmap_operations
To: Xiao Ni <xni@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@lst.de, corbet@lwn.net, song@kernel.org, agk@redhat.com,
 snitzer@kernel.org, mpatocka@redhat.com, linan122@huawei.com, hare@suse.de,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, dm-devel@lists.linux.dev, yi.zhang@huawei.com,
 yangerkun@huawei.com, johnny.chenyi@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250801070346.4127558-1-yukuai1@huaweicloud.com>
 <20250801070346.4127558-9-yukuai1@huaweicloud.com>
 <CALTww2_jcDJf-55AEvK2fzf2PLnnOfBw5dG4bQG65B9eFw8Xmg@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <65ab0815-daf0-c614-7fa5-cab095d513b1@huaweicloud.com>
Date: Tue, 5 Aug 2025 09:15:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CALTww2_jcDJf-55AEvK2fzf2PLnnOfBw5dG4bQG65B9eFw8Xmg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHwhI_W5FolqNpCg--.41295S3
X-Coremail-Antispam: 1UD129KBjvJXoWxZr43Ar4rJrWxXr1fGF15Arb_yoW5tF4Upa
	9rXasxuayUWr4UX3W7XayDuFyFq39rtry7JFWSg34ruF90grnxWFyftayY9a4jk3WagasI
	v3Z0y345Crn5tFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

在 2025/08/04 17:15, Xiao Ni 写道:
> Hi Kuai
> 
> I found one thing. The interface ->blocks_synced doesn't work in the
> write io path. So there is a risk of data corruption. For example:
> 
> mdadm -CR /dev/md0 -l5 -n5 /dev/loop[0-4] --bitmap=lockless (all bits
> are unwritten because lazy initial recovery)
> 1. D1 D2 D3 D4 P1, a small write hits D2. rmw is 2 (need to read old
> data of D2 and P1), rcw is 3 (need to read D1 D3 and D4).
> 2. D2 disk fails
> 3. read data from disk2. It needs to calculate the data from other
> disks. But the result is not the real data which was written to D2
> 
> So ->blocks_synced needs to be checked in handle_stripe_dirtying.

This is correct, the write path is missing. Will fix it in the next
version.

Thanks,
Kuai

> 
> Best Regards
> Xiao
> 
> On Fri, Aug 1, 2025 at 3:11 PM Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> Currently, raid456 must perform a whole array initial recovery to build
>> initail xor data, then IO to the array won't have to read all the blocks
>> in underlying disks.
>>
>> This behavior will affect IO performance a lot, and nowadays there are
>> huge disks and the initial recovery can take a long time. Hence llbitmap
>> will support lazy initial recovery in following patches. This method is
>> used to check if data blocks is synced or not, if not then IO will still
>> have to read all blocks for raid456.
>>
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> Reviewed-by: Hannes Reinecke <hare@suse.de>
>> Reviewed-by: Xiao Ni <xni@redhat.com>
>> Reviewed-by: Li Nan <linan122@huawei.com>
>> ---
>>   drivers/md/md-bitmap.h | 1 +
>>   drivers/md/raid5.c     | 6 ++++++
>>   2 files changed, 7 insertions(+)
>>
>> diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
>> index 95453696c68e..5f41724cbcd8 100644
>> --- a/drivers/md/md-bitmap.h
>> +++ b/drivers/md/md-bitmap.h
>> @@ -90,6 +90,7 @@ struct bitmap_operations {
>>          md_bitmap_fn *end_discard;
>>
>>          sector_t (*skip_sync_blocks)(struct mddev *mddev, sector_t offset);
>> +       bool (*blocks_synced)(struct mddev *mddev, sector_t offset);
>>          bool (*start_sync)(struct mddev *mddev, sector_t offset,
>>                             sector_t *blocks, bool degraded);
>>          void (*end_sync)(struct mddev *mddev, sector_t offset, sector_t *blocks);
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index 5285e72341a2..2121f0ff5e30 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -3748,6 +3748,7 @@ static int want_replace(struct stripe_head *sh, int disk_idx)
>>   static int need_this_block(struct stripe_head *sh, struct stripe_head_state *s,
>>                             int disk_idx, int disks)
>>   {
>> +       struct mddev *mddev = sh->raid_conf->mddev;
>>          struct r5dev *dev = &sh->dev[disk_idx];
>>          struct r5dev *fdev[2] = { &sh->dev[s->failed_num[0]],
>>                                    &sh->dev[s->failed_num[1]] };
>> @@ -3762,6 +3763,11 @@ static int need_this_block(struct stripe_head *sh, struct stripe_head_state *s,
>>                   */
>>                  return 0;
>>
>> +       /* The initial recover is not done, must read everything */
>> +       if (mddev->bitmap_ops && mddev->bitmap_ops->blocks_synced &&
>> +           !mddev->bitmap_ops->blocks_synced(mddev, sh->sector))
>> +               return 1;
>> +
>>          if (dev->toread ||
>>              (dev->towrite && !test_bit(R5_OVERWRITE, &dev->flags)))
>>                  /* We need this block to directly satisfy a request */
>> --
>> 2.39.2
>>
> 
> 
> .
> 

