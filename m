Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 167B61EB3D
	for <dm-devel@lists.linux.dev>; Mon, 21 Jul 2025 07:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753081977; cv=none; b=X34WJFFFZsYfwUoJZIke2tpbYz8SS2NnLJZwligjAH3cvLpnOjFm5cKFTu/0q9c8zh9k7HE+9R1rHKhpVKtSpIxS1p0c99XV1LQw6cFZO655L2ur8gwkWIeZ6Frsdwqnt/6oXqQytbMRqCXlQECM6k70AkLwYkugztjwrdKmbE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753081977; c=relaxed/simple;
	bh=HHrQXBQ8/2N/DSFHNO9uanVncwDRi38IvAN8uzcrkMw=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=D/FSqQaYHBq9aIKQcKSyqdEdwFdv0mj1y6GkvLRz9dew85DPHq3kQL76jwC3Vw9P6Hc/4us6jpVvLHNKjU3nRbGJlW9GZqLa/Ry5xk876Kjb+PfNlKNCD25n/THnn/YsLh3BAGWuCe7cLZIqqZ1jDLFER/lOvOpoSjwcakxa+y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4bls6r6y2szYQv3t
	for <dm-devel@lists.linux.dev>; Mon, 21 Jul 2025 15:12:52 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id AD7CB1A0D64
	for <dm-devel@lists.linux.dev>; Mon, 21 Jul 2025 15:12:51 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgCnIxRx6H1o1WHtAw--.25659S3;
	Mon, 21 Jul 2025 15:12:51 +0800 (CST)
Subject: Re: [PATCH v3 11/11] md/md-llbitmap: introduce new lockless bitmap
To: Hannes Reinecke <hare@suse.de>, Yu Kuai <yukuai1@huaweicloud.com>,
 corbet@lwn.net, agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
 song@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, yi.zhang@huawei.com,
 yangerkun@huawei.com, johnny.chenyi@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250718092336.3346644-1-yukuai1@huaweicloud.com>
 <20250718092336.3346644-12-yukuai1@huaweicloud.com>
 <04ba77bb-464d-4b98-91e6-4225204ae679@suse.de>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <bc215f88-a652-090f-ae99-8aaba6c591c4@huaweicloud.com>
Date: Mon, 21 Jul 2025 15:12:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <04ba77bb-464d-4b98-91e6-4225204ae679@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnIxRx6H1o1WHtAw--.25659S3
X-Coremail-Antispam: 1UD129KBjvJXoW3WFyUurWUtFy8uFy3Zry5urg_yoWfZF47pF
	1kJrWUGrW3Jrn5Xr1UXryDAFyFyrn7J3ZFqF18XFy5JrnFyrnYgFy8WFyqgw1UZr48GF1j
	yw15WrsruwnrXrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBF14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
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
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUd-B_UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/07/21 14:20, Hannes Reinecke 写道:
> On 7/18/25 11:23, Yu Kuai wrote:
>> From: Yu Kuai <yukuai3@huawei.com>
>>

>> +
>> +#define BITMAP_DATA_OFFSET 1024
>> +
>> +/* 64k is the max IO size of sync IO for raid1/raid10 */
>> +#define MIN_CHUNK_SIZE (64 * 2)
>> +
> 
> Hmm? Which one is it?
> Comment says 'max IO size', but it's called 'MIN_CHUNK_SIZE'...

max IO size here means the internal recovery IO size for raid1/10,
and we're handling at most one llbimtap bit(chunksie) at a time, so
chunksize should be at least 64k, otherwise recovery IO size will be
less.

>> +/*
>> + * Dirtied bits that have not been accessed for more than 5s will be 
>> cleared
>> + * by daemon.
>> + */
>> +#define BARRIER_IDLE 5
>> +
> 
> Should this be changeable, too?

Yes, idealy this should. Perhaps a new sysfs api?

> 

>> +    if (!test_bit(LLPageDirty, &pctl->flags))
>> +        set_bit(LLPageDirty, &pctl->flags);
>> +
>> +    /*
>> +     * The subpage usually contains a total of 512 bits. If any 
>> single bit
>> +     * within the subpage is marked as dirty, the entire sector will be
>> +     * written. To avoid impacting write performance, when multiple bits
>> +     * within the same sector are modified within a short time frame, 
>> all
>> +     * bits in the sector will be collectively marked as dirty at once.
>> +     */
> 
> How short is the 'short timeframe'?
> Is this the BARRIER_IDLE setting?
> Please clarify.

Yes, if the page is not accessed for BARRIER_IDLE seconds.

>> +static struct page *llbitmap_read_page(struct llbitmap *llbitmap, int 
>> idx)
>> +{
>> +    struct mddev *mddev = llbitmap->mddev;
>> +    struct page *page = NULL;
>> +    struct md_rdev *rdev;
>> +
>> +    if (llbitmap->pctl && llbitmap->pctl[idx])
>> +        page = llbitmap->pctl[idx]->page;
>> +    if (page)
>> +        return page;
>> +
>> +    page = alloc_page(GFP_KERNEL | __GFP_ZERO);
>> +    if (!page)
>> +        return ERR_PTR(-ENOMEM);
>> +
>> +    rdev_for_each(rdev, mddev) {
>> +        sector_t sector;
>> +
>> +        if (rdev->raid_disk < 0 || test_bit(Faulty, &rdev->flags))
>> +            continue;
>> +
>> +        sector = mddev->bitmap_info.offset +
>> +             (idx << PAGE_SECTORS_SHIFT);
>> +
>> +        if (sync_page_io(rdev, sector, PAGE_SIZE, page, REQ_OP_READ,
>> +                 true))
>> +            return page;
>> +
>> +        md_error(mddev, rdev);
>> +    }
>> +
>> +    __free_page(page);
>> +    return ERR_PTR(-EIO);
>> +}
>> +
> 
> Have you considered moving to folios here?
> 

Of course, however, because the md high level helpers is still using
page, I'm thinking about using page for now, which is simpler, and
moving to folios for all md code later.


>> +static int llbitmap_resize(struct mddev *mddev, sector_t blocks, int 
>> chunksize)
>> +{
>> +    struct llbitmap *llbitmap = mddev->bitmap;
>> +    unsigned long chunks;
>> +
>> +    if (chunksize == 0)
>> +        chunksize = llbitmap->chunksize;
>> +
>> +    /* If there is enough space, leave the chunksize unchanged. */
>> +    chunks = DIV_ROUND_UP(blocks, chunksize);
>> +    while (chunks > mddev->bitmap_info.space << SECTOR_SHIFT) {
>> +        chunksize = chunksize << 1;
>> +        chunks = DIV_ROUND_UP(blocks, chunksize);
>> +    }
>> +
>> +    llbitmap->chunkshift = ffz(~chunksize);
>> +    llbitmap->chunksize = chunksize;
>> +    llbitmap->chunks = chunks;
>> +
>> +    return 0;
>> +}
>> +
> 
> Hmm. I do get confused with the chunksize here.
> Is this the granularity of the bits in the bitmap
> (ie how many data bytes are covered by one bit)?
> Or is it the chunksize of the bitmap itself?

Yes, the llbitmap->chunksize means the data bytes by one llbitmap bit.
> 
> In either case, if it's a 'chunksize' in the sense
> of the block layer (namely a boundary which I/O
> must not cross), shouldn't you set the request
> queue limits accordingly?

I think we don't, it's fine if IO cross the boundary of
llbitmap->chunksize, multiple bits will be recorded. In fact, we support
plug and recored lots of bits at a time, the only restriction is that
dirty bits have to be written beffore issuing IO.

> 
>> +static int llbitmap_load(struct mddev *mddev)
>> +{
>> +    enum llbitmap_action action = BitmapActionReload;
>> +    struct llbitmap *llbitmap = mddev->bitmap;
>> +
>> +    if (test_and_clear_bit(BITMAP_STALE, &llbitmap->flags))
>> +        action = BitmapActionStale;
>> +
>> +    llbitmap_state_machine(llbitmap, 0, llbitmap->chunks - 1, action);
>> +    return 0;
>> +}
>> +
>> +static void llbitmap_destroy(struct mddev *mddev)
>> +{
>> +    struct llbitmap *llbitmap = mddev->bitmap;
>> +
>> +    if (!llbitmap)
>> +        return;
>> +
>> +    mutex_lock(&mddev->bitmap_info.mutex);
>> +
>> +    timer_delete_sync(&llbitmap->pending_timer);
>> +    flush_workqueue(md_llbitmap_io_wq);
>> +    flush_workqueue(md_llbitmap_unplug_wq);
>> +
>> +    mddev->bitmap = NULL;
>> +    llbitmap_free_pages(llbitmap);
>> +    kfree(llbitmap);
>> +    mutex_unlock(&mddev->bitmap_info.mutex);
>> +}
>> +
>> +static void llbitmap_start_write(struct mddev *mddev, sector_t offset,
>> +                 unsigned long sectors)
>> +{
>> +    struct llbitmap *llbitmap = mddev->bitmap;
>> +    unsigned long start = offset >> llbitmap->chunkshift;
>> +    unsigned long end = (offset + sectors - 1) >> llbitmap->chunkshift;
>> +    int page_start = (start + BITMAP_DATA_OFFSET) >> PAGE_SHIFT;
>> +    int page_end = (end + BITMAP_DATA_OFFSET) >> PAGE_SHIFT;
>> +
>> +    llbitmap_state_machine(llbitmap, start, end, 
>> BitmapActionStartwrite);
>> +
>> +
>> +    while (page_start <= page_end) {
>> +        llbitmap_raise_barrier(llbitmap, page_start);
>> +        page_start++;
>> +    }
>> +}
>> +
>> +static void llbitmap_end_write(struct mddev *mddev, sector_t offset,
>> +                   unsigned long sectors)
>> +{
>> +    struct llbitmap *llbitmap = mddev->bitmap;
>> +    unsigned long start = offset >> llbitmap->chunkshift;
>> +    unsigned long end = (offset + sectors - 1) >> llbitmap->chunkshift;
>> +    int page_start = (start + BITMAP_DATA_OFFSET) >> PAGE_SHIFT;
>> +    int page_end = (end + BITMAP_DATA_OFFSET) >> PAGE_SHIFT;
>> +
>> +    while (page_start <= page_end) {
>> +        llbitmap_release_barrier(llbitmap, page_start);
>> +        page_start++;
>> +    }
>> +}
>> +
>> +static void llbitmap_start_discard(struct mddev *mddev, sector_t offset,
>> +                   unsigned long sectors)
>> +{
>> +    struct llbitmap *llbitmap = mddev->bitmap;
>> +    unsigned long start = DIV_ROUND_UP(offset, llbitmap->chunksize);
>> +    unsigned long end = (offset + sectors - 1) >> llbitmap->chunkshift;
>> +    int page_start = (start + BITMAP_DATA_OFFSET) >> PAGE_SHIFT;
>> +    int page_end = (end + BITMAP_DATA_OFFSET) >> PAGE_SHIFT;
>> +
>> +    llbitmap_state_machine(llbitmap, start, end, BitmapActionDiscard);
>> +
>> +    while (page_start <= page_end) {
>> +        llbitmap_raise_barrier(llbitmap, page_start);
>> +        page_start++;
>> +    }
>> +}
>> +
>> +static void llbitmap_end_discard(struct mddev *mddev, sector_t offset,
>> +                 unsigned long sectors)
>> +{
>> +    struct llbitmap *llbitmap = mddev->bitmap;
>> +    unsigned long start = DIV_ROUND_UP(offset, llbitmap->chunksize);
>> +    unsigned long end = (offset + sectors - 1) >> llbitmap->chunkshift;
>> +    int page_start = (start + BITMAP_DATA_OFFSET) >> PAGE_SHIFT;
>> +    int page_end = (end + BITMAP_DATA_OFFSET) >> PAGE_SHIFT;
>> +
>> +    while (page_start <= page_end) {
>> +        llbitmap_release_barrier(llbitmap, page_start);
>> +        page_start++;
>> +    }
>> +}
>> +
>> +static void llbitmap_unplug_fn(struct work_struct *work)
>> +{
>> +    struct llbitmap_unplug_work *unplug_work =
>> +        container_of(work, struct llbitmap_unplug_work, work);
>> +    struct llbitmap *llbitmap = unplug_work->llbitmap;
>> +    struct blk_plug plug;
>> +    int i;
>> +
>> +    blk_start_plug(&plug);
>> +
>> +    for (i = 0; i < llbitmap->nr_pages; i++) {
>> +        if (!test_bit(LLPageDirty, &llbitmap->pctl[i]->flags) ||
>> +            !test_and_clear_bit(LLPageDirty, &llbitmap->pctl[i]->flags))
> 
> Confused. Is this some kind of micro-optimisation?
> Why not simply 'test_and_clear_bit()'?

Yes, because this is called from IO hot path, and in the most cases,
only a few pages will be dirtied by plugged IO.

Thanks for the review!
Kuai

> Cheers,
> 
> Hannes

