Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C692AEE1
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 08:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747037739; cv=none; b=LkeF02q4vhX084V3bEu1zDFS2+158EM4BvIaKxMhR/cEjPQV6J/tYR2ptI8fOXEtMIPLwpjtcs9kqA3CXpJN8USWf6jxHcUtHbyzvsg4pftciU9I7l2rlzpxfsc3t4i98n2WuSHMw8vwoRztZhf9pp2foO0avMuU+pqH35xjStM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747037739; c=relaxed/simple;
	bh=huCY6/i1yQNO1K1PIJZjLeUstF8M43oL4i4aa9uBajs=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=lxz97804AHLKUqFRjrK6f9npESg27xjS9Qm67BCquRZlkDjkEHgwKUf8f3p4Pm7G6dhGebBGjYj0wXGNSQ75u4F4NDcR6qjW06k/OEa0g8P3Y7lakut5ZmEpEVKwGlMDfARZSFkXVOclTCumBTeiqx56DjwMhWKQ7KMVRpVyMHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4ZwsqX56ZKzKHMpT
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 16:15:36 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 659531A07BD
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 16:15:35 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgB32l4mriFoBKSyMA--.52941S3;
	Mon, 12 May 2025 16:15:35 +0800 (CST)
Subject: Re: [PATCH RFC md-6.16 v3 11/19] md/md-llbitmap: implement bitmap IO
To: Christoph Hellwig <hch@lst.de>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: xni@redhat.com, colyli@kernel.org, agk@redhat.com, snitzer@kernel.org,
 mpatocka@redhat.com, song@kernel.org, linux-kernel@vger.kernel.org,
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, yi.zhang@huawei.com,
 yangerkun@huawei.com, johnny.chenyi@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250512011927.2809400-1-yukuai1@huaweicloud.com>
 <20250512011927.2809400-12-yukuai1@huaweicloud.com>
 <20250512051519.GA1555@lst.de>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <a2d1a5c4-c041-064f-307e-eaa677e5a81c@huaweicloud.com>
Date: Mon, 12 May 2025 16:15:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250512051519.GA1555@lst.de>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB32l4mriFoBKSyMA--.52941S3
X-Coremail-Antispam: 1UD129KBjvJXoWxGr18GFWrAF4UWw4xJr4rGrg_yoW5WrykpF
	Z7JFy2kF45JFy5Xr47JrZFya4Syrs7Grsxur97Cas3Cr9Ivrsak34xWFyrG34xury8CFs8
	Zw45Gr13uw15WFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBF14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4U
	JVW0owA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kI
	c2xKxwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7V
	AKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCj
	r7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6x
	IIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAI
	w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x
	0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUZYFZUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/05/12 13:15, Christoph Hellwig Ð´µÀ:
> On Mon, May 12, 2025 at 09:19:19AM +0800, Yu Kuai wrote:
>> +static bool is_raid456(struct mddev *mddev)
>> +{
>> +	return (mddev->level == 4 || mddev->level == 5 || mddev->level == 6);
>> +}
> 
> This really should be in a common helper somewhere..

Perhaps md.h?
> 
>> +static int llbitmap_read(struct llbitmap *llbitmap, enum llbitmap_state *state,
>> +			 loff_t pos)
>> +{
>> +	pos += BITMAP_SB_SIZE;
>> +	*state = llbitmap->barrier[pos >> PAGE_SHIFT].data[offset_in_page(pos)];
>> +	return 0;
>> +}
> 
> This always return 0, and could just return void.

Ok
> 
>> +static void llbitmap_set_page_dirty(struct llbitmap *llbitmap, int idx, int offset)
> 
> Overly long line.
> 
> Also should the second and third argument be unsigned?

Ok
> 
>> +	/*
>> +	 * if the bit is already dirty, or other page bytes is the same bit is
>> +	 * already BitDirty, then mark the whole bytes in the bit as dirty
>> +	 */
>> +	if (test_and_set_bit(bit, barrier->dirty)) {
>> +		infectious = true;
>> +	} else {
>> +		for (pos = bit * io_size; pos < (bit + 1) * io_size - 1;
>> +		     pos++) {
>> +			if (pos == offset)
>> +				continue;
>> +			if (barrier->data[pos] == BitDirty ||
>> +			    barrier->data[pos] == BitNeedSync) {
>> +				infectious = true;
>> +				break;
>> +			}
>> +		}
>> +
>> +	}
>> +	if (!infectious)
>> +		return;
> 
> Mabe use a goto and/or a helper function containing the for loop to
> clean up the control flow here a bit?

Ok, I;ll add a helper function.
> 
>> +static int llbitmap_write(struct llbitmap *llbitmap, enum llbitmap_state state,
>> +			  loff_t pos)
>> +{
>> +	int idx;
>> +	int offset;
> 
> Unsigned?
> 
>> +
>> +	pos += BITMAP_SB_SIZE;
>> +	idx = pos >> PAGE_SHIFT;
>> +	offset = offset_in_page(pos);
>> +
>> +	llbitmap->barrier[idx].data[offset] = state;
>> +	if (state == BitDirty || state == BitNeedSync)
>> +		llbitmap_set_page_dirty(llbitmap, idx, offset);
>> +	return 0;
> 
> and this could also be a void return.

Ok.
> 
>> +		sector = mddev->bitmap_info.offset + (idx << PAGE_SECTORS_SHIFT);
> 
> Overly long line.
> 
>> +			if (rdev->raid_disk < 0 || test_bit(Faulty, &rdev->flags))
> 
> Same here.
> 
>> +	int nr_pages = (llbitmap->chunks + BITMAP_SB_SIZE + PAGE_SIZE - 1) / PAGE_SIZE;
> 
> Unsigned for the type, and DIV_ROUND_UP for the calculation.

Ok.
> 
>> +	struct page *page;
>> +	int i = 0;
>> +
>> +	llbitmap->nr_pages = nr_pages;
>> +	while (i < nr_pages) {
>> +		page = llbitmap_read_page(llbitmap, i);
>> +		if (IS_ERR(page)) {
>> +			llbitmap_free_pages(llbitmap);
>> +			return PTR_ERR(page);
>> +		}
>> +
>> +		if (percpu_ref_init(&llbitmap->barrier[i].active, active_release,
>> +				    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
>> +			__free_page(page);
>> +			return -ENOMEM;
> 
> Doesn't this also need a llbitmap_free_pages for the error case?

Of course, my bad that I forgot this.

Thanks again for the review!
Kuai

> 
> .
> 

