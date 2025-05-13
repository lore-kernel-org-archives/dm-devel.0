Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7A1DF49
	for <dm-devel@lists.linux.dev>; Tue, 13 May 2025 06:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747117935; cv=none; b=G0K2UgqWhNakWjk468yem5UQue2gAYMolmjTH/uOxllQC/66tfHpsqjFUPf24o0BuBEupjrcjFBSOhWGfXxZenb67zSoaNp9Ph8ZssyKUqFlg9KNPu0BzoYnMBiE+68xflNkPmv8s7IBSQ5qtpXkjDnCyK4FvzZQynWNiRj989M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747117935; c=relaxed/simple;
	bh=3yotUE15OjKyTjOt8m0Lp6s6pl4db2xWWDxfsxZI3Vw=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=bhlQeWgw1mmpQ8MlDk8BKJGCbNtLW94L2GbokIdSxh3n6VkdW26IVG3j1LtOu9f3iuLHJ5ymqjfSO8PgQKn4KTJLRO/vMqakKVPfkRJKrnVz8BsY5SeVYdXJ9c+MWohSqjABlDKIRxxNrLeoVOvI68k08kGcxuS4n1fEgo8M9aM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4ZxRTH2CNgz4f3jkJ
	for <dm-devel@lists.linux.dev>; Tue, 13 May 2025 14:31:47 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id CCE0E1A1565
	for <dm-devel@lists.linux.dev>; Tue, 13 May 2025 14:32:06 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgCH619k5yJoKIEPMQ--.1039S3;
	Tue, 13 May 2025 14:32:06 +0800 (CST)
Subject: Re: [PATCH RFC md-6.16 v3 15/19] md/md-llbitmap: implement APIs to
 dirty bits and clear bits
To: Yu Kuai <yukuai1@huaweicloud.com>, Christoph Hellwig <hch@lst.de>
Cc: xni@redhat.com, colyli@kernel.org, agk@redhat.com, snitzer@kernel.org,
 mpatocka@redhat.com, song@kernel.org, linux-kernel@vger.kernel.org,
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, yi.zhang@huawei.com,
 yangerkun@huawei.com, johnny.chenyi@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250512011927.2809400-1-yukuai1@huaweicloud.com>
 <20250512011927.2809400-16-yukuai1@huaweicloud.com>
 <20250512051722.GA1667@lst.de>
 <0de7efeb-6d4a-2fa5-ed14-e2c0bec0257b@huaweicloud.com>
 <20250512132641.GC31781@lst.de> <20250512133048.GA32562@lst.de>
 <69dc5ab6-542d-dcc2-f4ec-0a6a8e49b937@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <03f64fc7-4e57-2f32-bffc-04836a9df790@huaweicloud.com>
Date: Tue, 13 May 2025 14:32:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <69dc5ab6-542d-dcc2-f4ec-0a6a8e49b937@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCH619k5yJoKIEPMQ--.1039S3
X-Coremail-Antispam: 1UD129KBjvJXoWxCFW8XFyDGFyUuw4Dtw43ZFb_yoWrWFWrpF
	Z0q3WYkr45JFWaq340yry7AF1rKa1vgr9rJryrGwna9FyYyrnIqF4vkFyFywn8ursxCF9r
	Zwn5tr98CryfXr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUB014x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26rxl
	6s0DM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY
	04v7Mxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64
	vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
	jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2I
	x0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK
	8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I
	0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUonmRUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/05/12 21:36, Yu Kuai 写道:
> Hi,
> 
> 在 2025/05/12 21:30, Christoph Hellwig 写道:
>> On Mon, May 12, 2025 at 03:26:41PM +0200, Christoph Hellwig wrote:
>>>> 1) bitmap bio must be done before this bio can be issued;
>>>> 2) bitmap bio will be added to current->bio_list, and wait for this bio
>>>> to be issued;
>>>>
>>>> Do you have a better sulution to this problem?
>>>
>>> A bew block layer API that bypasses bio_list maybe?  I.e. export
>>> __submit_bio with a better name and a kerneldoc detailing the narrow
>>> use case.
>>
>> That won't work as we'd miss a lot of checks, cgroup handling, etc.
>>
>> But maybe a flag to skip the recursion avoidance?
> 
> I think this can work, and this can also improve performance. I'll look
> into this.

So, I did a quick test with old internal bitmap and make sure following
patch can work.

However, for bitmap file case, bio is issued from submit_bh(), I'll have
to change buffer_head code and I'm not sure if we want to do that.

Thanks,
Kuai

diff --git a/block/blk-core.c b/block/blk-core.c
index b862c66018f2..66ced5769694 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -745,7 +745,7 @@ void submit_bio_noacct_nocheck(struct bio *bio)
          * to collect a list of requests submited by a ->submit_bio 
method while
          * it is active, and then process them after it returned.
          */
-       if (current->bio_list)
+       if (current->bio_list && !bio_flagged(bio, BIO_STACKED_META))
                 bio_list_add(&current->bio_list[0], bio);
         else if (!bdev_test_flag(bio->bi_bdev, BD_HAS_SUBMIT_BIO))
                 __submit_bio_noacct_mq(bio);
diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 431a3ab2e449..e0cb210a4ea4 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1257,35 +1257,6 @@ static void __bitmap_unplug(struct bitmap *bitmap)
                 md_bitmap_file_kick(bitmap);
  }

-struct bitmap_unplug_work {
-       struct work_struct work;
-       struct bitmap *bitmap;
-       struct completion *done;
-};
-
-static void md_bitmap_unplug_fn(struct work_struct *work)
-{
-       struct bitmap_unplug_work *unplug_work =
-               container_of(work, struct bitmap_unplug_work, work);
-
-       __bitmap_unplug(unplug_work->bitmap);
-       complete(unplug_work->done);
-}
-
-static void bitmap_unplug_async(struct bitmap *bitmap)
-{
-       DECLARE_COMPLETION_ONSTACK(done);
-       struct bitmap_unplug_work unplug_work;
-
-       INIT_WORK_ONSTACK(&unplug_work.work, md_bitmap_unplug_fn);
-       unplug_work.bitmap = bitmap;
-       unplug_work.done = &done;
-
-       queue_work(md_bitmap_wq, &unplug_work.work);
-       wait_for_completion(&done);
-       destroy_work_on_stack(&unplug_work.work);
-}
-
  static void bitmap_unplug(struct mddev *mddev, bool sync)
  {
         struct bitmap *bitmap = mddev->bitmap;
@@ -1293,10 +1264,7 @@ static void bitmap_unplug(struct mddev *mddev, 
bool sync)
         if (!bitmap)
                 return;

-       if (sync)
-               __bitmap_unplug(bitmap);
-       else
-               bitmap_unplug_async(bitmap);
+       __bitmap_unplug(bitmap);
  }

  static void md_bitmap_set_memory_bits(struct bitmap *bitmap, sector_t 
offset, int needed);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 32b997dfe6f4..179eabd6e038 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1050,6 +1050,7 @@ void md_super_write(struct mddev *mddev, struct 
md_rdev *rdev,
         __bio_add_page(bio, page, size, 0);
         bio->bi_private = rdev;
         bio->bi_end_io = super_written;
+       bio_set_flag(bio, BIO_STACKED_META);

         if (test_bit(MD_FAILFAST_SUPPORTED, &mddev->flags) &&
             test_bit(FailFast, &rdev->flags) &&
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index f38425338c3f..88164cdae6aa 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -300,6 +300,7 @@ enum {
         BIO_REMAPPED,
         BIO_ZONE_WRITE_PLUGGING, /* bio handled through zone write 
plugging */
         BIO_EMULATES_ZONE_APPEND, /* bio emulates a zone append 
operation */
+       BIO_STACKED_META,       /* bio is metadata from stacked device */
         BIO_FLAG_LAST
  };

> 
> Thanks,
> Kuai
> 
>>
>> .
>>
> 
> .
> 

