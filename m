Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D8725179D
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 08:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747037166; cv=none; b=HvkMMIt2fDOK8H06Anu+pH9wO7uCrpSWWuqjORxK3JHKA2m6Oj4+lnrGGnlcxBZTdryPtChEeLa9lTuEr3GMfac38ADc86esaKcnEVpVBptZjZ63vI3fKpvvCHyy6kNtQuo/S0zfXfRRbhBGGSyURL0L3umOYY2rQcegSUPyrzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747037166; c=relaxed/simple;
	bh=cBSjNV3TmxjbVyKFzAcA1PScL1hxEmH1Fya7XsMMt6c=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=NWLSlsM8HPjum0mQlwYlcJ8DoqBjouMUOvgfW5PyINJcRYhnfuUdbwqcO9XoJDUZ1WamSpAiyycNye6DAC0/V/AOTYqn7NkhGrdtxJs0umdhN3czeY2mp7TjRoXJejwWxLhReTmQxbJyMYgdqJnEv6a3YGgYh1qwpNNDSG/PBew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4ZwscT4mNzzKHMSk
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 16:06:01 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 221381A17A9
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 16:06:00 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgD3W2DmqyFohP6xMA--.56352S3;
	Mon, 12 May 2025 16:06:00 +0800 (CST)
Subject: Re: [PATCH RFC md-6.16 v3 10/19] md/md-llbitmap: add data structure
 definition and comments
To: Christoph Hellwig <hch@lst.de>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: xni@redhat.com, colyli@kernel.org, agk@redhat.com, snitzer@kernel.org,
 mpatocka@redhat.com, song@kernel.org, linux-kernel@vger.kernel.org,
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, yi.zhang@huawei.com,
 yangerkun@huawei.com, johnny.chenyi@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250512011927.2809400-1-yukuai1@huaweicloud.com>
 <20250512011927.2809400-11-yukuai1@huaweicloud.com>
 <20250512050950.GJ868@lst.de>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <89e306d4-bb30-96bd-0fe0-a5ff4e8012ef@huaweicloud.com>
Date: Mon, 12 May 2025 16:05:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250512050950.GJ868@lst.de>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3W2DmqyFohP6xMA--.56352S3
X-Coremail-Antispam: 1UD129KBjvJXoWxZF17WF17Cr4UZr18Gr1DAwb_yoW5uFW8pF
	W2qF4qkrs5Jrn7Aw1xJ34UuFyIkrs7JF13tryFk34UCFs093sa9Fs7KF4rurW0gr4rZ3W7
	XF4jg345Ja4avFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUB214x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
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

ÔÚ 2025/05/12 13:09, Christoph Hellwig Ð´µÀ:
> On Mon, May 12, 2025 at 09:19:18AM +0800, Yu Kuai wrote:
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> 
> You'll need a commit message here.  Also given how tiny this is
> vs the rest of the file I'm not entirely sure there is much of a
> point in splittng it out.

I'm not sure, this way is simpiler, however do you prefer add structure
and comments by following patches gradually?
> 
>> +#include <linux/buffer_head.h>
> 
> This shouldn't be needed here I think.

Yes, I just copy the headers from old bitmap file.
> 
>> + * llbitmap state machine: transitions between states
> 
> Can you split the table below into two columns so that it's easily
> readabe?

Sure
> 
>> +#define LLBITMAP_MAJOR_HI 6
> 
> I think you'll want to consolidate all the different version in
> md-bitmap.h and document them.

Ok, then I'll also move other values from md-bitmap.c.

> 
>> +#define BITMAP_MAX_SECTOR (128 * 2)
> 
> This appears unused even with the later series.

Yes, this is used in the old version, I'll remove it.
> 
>> +#define BITMAP_MAX_PAGES 32
> 
> Can you comment on how we ended up with this number?

Ok, the bitmap superblock is created by mdadm, and mdadm limit
bitmap size max to 128k, then
> 
>> +#define BITMAP_SB_SIZE 1024
> 
> I'd add this to md-bitmap.h as it's part of the on-disk format, and
> also make md-bitmap.c use it.

Ok
> 
>> +#define DEFAULT_DAEMON_SLEEP 30
>> +
>> +#define BARRIER_IDLE 5
> 
> Can you document these?

Ok, this is used for daemon to clean dirty bits when user doesn't issue
IO to the bit for more than 5 seconds.
> 
>> +enum llbitmap_action {
>> +	/* User write new data, this is the only acton from IO fast path */
> 
> s/acton/action/
> 
>> +/*
>> + * page level barrier to synchronize between dirty bit by write IO and clean bit
>> + * by daemon.
> 
> Overly lon line.  Also please stat full sentences with a capitalized
> word.
> 
>> + */
>> +struct llbitmap_barrier {
>> +	char *data;
> 
> This is really a states array as far as I can tell.  Maybe name it
> more descriptively and throw in a comment.

How about llbitmap_page_ctl ?
> 
>> +	struct percpu_ref active;
>> +	unsigned long expire;
>> +	unsigned long flags;
>> +	/* Per block size dirty state, maximum 64k page / 512 sector = 128 */
>> +	DECLARE_BITMAP(dirty, 128);
>> +	wait_queue_head_t wait;
>> +} ____cacheline_aligned_in_smp;
>> +
>> +struct llbitmap {
>> +	struct mddev *mddev;
>> +	int nr_pages;
>> +	struct page *pages[BITMAP_MAX_PAGES];
>> +	struct llbitmap_barrier barrier[BITMAP_MAX_PAGES];
> 
> Should the bitmap and the page be in the same array to have less
> cache line sharing between the users/  The above
> ____cacheline_aligned_in_smp suggests you are at least somewhat
> woerried about cache line sharing.

Yes, and BTW, I probably should allocate necessary memory based on real
number of pages, instead of embedded max pages. I do this first to
eazy coding.

> 
>> +static char state_machine[nr_llbitmap_state][nr_llbitmap_action] = {
>> +	[BitUnwritten] = {BitDirty, BitNone, BitNone, BitNone, BitNone, BitNone, BitNone, BitNone},
> 
> Maybe used named initializers to make this more readable.  In fact that
> might remove the need for the big table in the comment at the top of the
> file because it would be just as readable.

Sure, this is a good suggestion.

Thanks for the review!
Kuai

> 
> .
> 

