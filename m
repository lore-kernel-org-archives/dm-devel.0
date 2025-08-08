Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB802E371F
	for <dm-devel@lists.linux.dev>; Fri,  8 Aug 2025 06:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754633868; cv=none; b=Z7dYd17g+M5kf4Rhlqjrf5uVGZ60H2HfJOmSZihqKtLfuQZniQDk76/tzdtaZYRYHU7RegUxAirQyHTfbAEZ7R/C3GfXzTSTFk+zsoptkUxq4EqyNj2jfqttq2XC6iw6WOqwMNjt97bw9HkuCnFl+c6QHgtf5a7PK70wG1slNpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754633868; c=relaxed/simple;
	bh=cmAsMBvdaiFIRBmsQgKW2WADeetWcA/YHbrfYBriZuU=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=P6DO6d+YEOXGJsbVwfqOGZAYRI4ekYGDBN5SVN6zzbk+gsjQYa7bQkryw4OjjE6vxy8aO6VgrL/0JNmjoyv12/r6GhsRNWxSpizQGb8v52aa1FZWhsUbVdbumFMKk6p/NvD4EvxwmTRW0N2lju9Yl0zMBst/86pG+qxHxxAPJgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4byv2s6fz4zYQtsG
	for <dm-devel@lists.linux.dev>; Fri,  8 Aug 2025 14:17:41 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 8B9471A0DA7
	for <dm-devel@lists.linux.dev>; Fri,  8 Aug 2025 14:17:40 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgAHzw+ClpVox_zaCw--.65529S3;
	Fri, 08 Aug 2025 14:17:40 +0800 (CST)
Subject: Re: [PATCH v5 11/11] md/md-llbitmap: introduce new lockless bitmap
To: Xiao Ni <xni@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@lst.de, corbet@lwn.net, song@kernel.org, agk@redhat.com,
 snitzer@kernel.org, mpatocka@redhat.com, linan122@huawei.com, hare@suse.de,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, dm-devel@lists.linux.dev, yi.zhang@huawei.com,
 yangerkun@huawei.com, johnny.chenyi@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250801070346.4127558-1-yukuai1@huaweicloud.com>
 <20250801070346.4127558-12-yukuai1@huaweicloud.com>
 <CALTww2-FTgDn9pD-Gmh8YKT-fU1ykk_QbB9J2KO8xQzrkAa_Bg@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <e7902d0b-713f-f245-733b-33fd23262496@huaweicloud.com>
Date: Fri, 8 Aug 2025 14:17:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CALTww2-FTgDn9pD-Gmh8YKT-fU1ykk_QbB9J2KO8xQzrkAa_Bg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHzw+ClpVox_zaCw--.65529S3
X-Coremail-Antispam: 1UD129KBjvJXoW3WF1kWFy8Cr43JFWUXryxKrg_yoW7Ary8pF
	WxW3WUGr45JryrXr1UXr97ZF95trs7JwnFqrZ3Aa4rGr1qyrs3Kry8GFyUC34kur97GF1D
	Za15Gry3uw4rWrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

Hi, Xiao

在 2025/08/07 11:57, Xiao Ni 写道:
>> +/* set all the bits in the subpage as dirty */
>> +static void llbitmap_infect_dirty_bits(struct llbitmap *llbitmap,
>> +                                      struct llbitmap_page_ctl *pctl,
>> +                                      unsigned int block, unsigned int offset)
>> +{
>> +       bool level_456 = raid_is_456(llbitmap->mddev);
>> +       unsigned int io_size = llbitmap->io_size;
>> +       int pos;
>> +
>> +       for (pos = block * io_size; pos < (block + 1) * io_size; pos++) {
>> +               if (pos == offset)
>> +                       continue;
> It looks like it doesn't need to pass the argument offset to this
> function. The pctl->state[offset] must be BitDirty or BitNeedSync. So
> the following switch/case can skip it. So it can save hundreds
> comparing pos with offset here.
> 
Ok.
>> +
>> +               switch (pctl->state[pos]) {
>> +               case BitUnwritten:
>> +                       pctl->state[pos] = level_456 ? BitNeedSync : BitDirty;
>> +                       break;
>> +               case BitClean:
>> +                       pctl->state[pos] = BitDirty;
>> +                       break;
>> +               };
>> +       }
>> +
>> +}
>> +static void llbitmap_write(struct llbitmap *llbitmap, enum llbitmap_state state,
>> +                          loff_t pos)
>> +{
>> +       unsigned int idx;
>> +       unsigned int offset;
> How about change offset to bit?

Yes, and the follong name about bit.
>> +static void llbitmap_write_page(struct llbitmap *llbitmap, int idx)
>> +{
>> +       struct page *page = llbitmap->pctl[idx]->page;
>> +       struct mddev *mddev = llbitmap->mddev;
>> +       struct md_rdev *rdev;
>> +       int bit;
> It's better to change name "bit" to "block"
>> +static int llbitmap_init(struct llbitmap *llbitmap)
>> +{
>> +       struct mddev *mddev = llbitmap->mddev;
>> +       sector_t blocks = mddev->resync_max_sectors;
>> +       unsigned long chunksize = MIN_CHUNK_SIZE;
>> +       unsigned long chunks = DIV_ROUND_UP(blocks, chunksize);
>> +       unsigned long space = mddev->bitmap_info.space << SECTOR_SHIFT;
>> +       int ret;
>> +
>> +       while (chunks > space) {
>> +               chunksize = chunksize << 1;
>> +               chunks = DIV_ROUND_UP(blocks, chunksize);
>> +       }
>> +
>> +       llbitmap->barrier_idle = DEFAULT_BARRIER_IDLE;
>> +       llbitmap->chunkshift = ffz(~chunksize);
>> +       llbitmap->chunksize = chunksize;
>> +       llbitmap->chunks = chunks;
>> +       mddev->bitmap_info.daemon_sleep = DEFAULT_DAEMON_SLEEP;
>> +
>> +       ret = llbitmap_cache_pages(llbitmap);
>> +       if (ret)
>> +               return ret;
>> +
>> +       llbitmap_state_machine(llbitmap, 0, llbitmap->chunks - 1, BitmapActionInit);
>> +       return 0;
>> +}
> There is a problem, if array is created with --assume-clean, it
> doesn't need to start sync. And it doesn't have the chance to sync
> llbitmap superblock to member disks. So it can't get the right bitmap
> superblock information which is calculated here after a power off. It
> needs to sync the superblock here.
> 
Yes, you're right. The mdraid bitmap metadata is written by mdadm,
dm-raid  bitmap metadata is write in kernel by md_update_sb(), llbitmap
is missing a call to llbitmap_write_sb() after initializing, if
md_update_sb() is never triggered, the bitmap metadata will be lost.

>> +
>> +static int llbitmap_create(struct mddev *mddev)
>> +{
>> +       struct llbitmap *llbitmap;
>> +       int ret;
>> +
>> +       ret = llbitmap_check_support(mddev);
>> +       if (ret)
>> +               return ret;
>> +
>> +       llbitmap = kzalloc(sizeof(*llbitmap), GFP_KERNEL);
>> +       if (!llbitmap)
>> +               return -ENOMEM;
>> +
>> +       llbitmap->mddev = mddev;
>> +       llbitmap->io_size = bdev_logical_block_size(mddev->gendisk->part0);
>> +       llbitmap->blocks_per_page = PAGE_SIZE / llbitmap->io_size;
>> +
>> +       timer_setup(&llbitmap->pending_timer, llbitmap_pending_timer_fn, 0);
>> +       INIT_WORK(&llbitmap->daemon_work, md_llbitmap_daemon_fn);
>> +       atomic_set(&llbitmap->behind_writes, 0);
>> +       init_waitqueue_head(&llbitmap->behind_wait);
>> +
>> +       mutex_lock(&mddev->bitmap_info.mutex);
>> +       mddev->bitmap = llbitmap;
>> +       ret = llbitmap_read_sb(llbitmap);
>> +       mutex_unlock(&mddev->bitmap_info.mutex);
>> +       if (ret)
>> +               goto err_out;
>> +
>> +       return 0;
>> +
>> +err_out:
>> +       kfree(llbitmap);
> mddev->bitmap = NULL. If not,
> md_run->md_bitmap_destroy->llbitmap_destroy will free it again.
Yes.

> 
>> +static void llbitmap_start_write(struct mddev *mddev, sector_t offset,
>> +                                unsigned long sectors)
>> +{
>> +       struct llbitmap *llbitmap = mddev->bitmap;
>> +       unsigned long start = offset >> llbitmap->chunkshift;
>> +       unsigned long end = (offset + sectors - 1) >> llbitmap->chunkshift;
>> +       int page_start = (start + BITMAP_DATA_OFFSET) >> PAGE_SHIFT;
>> +       int page_end = (end + BITMAP_DATA_OFFSET) >> PAGE_SHIFT;
>> +
>> +       llbitmap_state_machine(llbitmap, start, end, BitmapActionStartwrite);
>> +
>> +
> Two lines here, just need one.
>> +/*
>> + * Force to write all bitmap pages to disk, called when stopping the array, or
>> + * every daemon_sleep seconds when sync_thread is running.
>> + */
>> +static void __llbitmap_flush(struct mddev *mddev)
>> +{
>> +       struct llbitmap *llbitmap = mddev->bitmap;
>> +       struct blk_plug plug;
>> +       int i;
>> +
>> +       blk_start_plug(&plug);
>> +       for (i = 0; i < llbitmap->nr_pages; i++) {
>> +               struct llbitmap_page_ctl *pctl = llbitmap->pctl[i];
>> +
>> +               /* mark all bits as dirty */
> "mark all blocks as dirty" is better?
> 
>> +static void llbitmap_write_sb(struct llbitmap *llbitmap)
>> +{
>> +       int nr_bits = DIV_ROUND_UP(BITMAP_DATA_OFFSET, llbitmap->io_size);
> s/nr_bits/nr_blocks/g
> 
> 
> 
> 

Thanks again for the review!
Kuai

