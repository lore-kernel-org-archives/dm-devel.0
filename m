Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA411991D2
	for <dm-devel@lists.linux.dev>; Thu,  7 Nov 2024 07:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730966144; cv=none; b=PVrLiu8z7Hljqfgwj0gmQ7TfUTUVaTVIQip1cZQ7CQHlO7R8O+Pcko6iPy0/3XfIpzq04FgAy02Mm62R+MjeUxGrqrEH+sNkXw4Rl9Zhmxe/YQE8kdM4mjFNW17jPfvU+NsROJ/7vFyFNpQANfi0RCcPRQ60QZIlPBwsxLAjglA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730966144; c=relaxed/simple;
	bh=EzLH7HbUlUqCUPdvXmN3UQ74szSeNkvQ83TjG1gWA5o=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=spw1WgYWoohR8PMFAPbBXp4culzqyrsyq3w4STs/j8lrJiV1UZPQ5NfDFYyDELmKlsXbqnw5Dy3fQ1pP8Zp6erMXNCYlS4yWY7XO3Ep9PmVGefQ6Eh1WrMxXE7WiqADAN/d4yB/VqkybqrGqjf/hDtMI8INW5r+R44W87QpMgbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4XkZB34QkMz4f3kpP
	for <dm-devel@lists.linux.dev>; Thu,  7 Nov 2024 15:55:23 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 84A8A1A0196
	for <dm-devel@lists.linux.dev>; Thu,  7 Nov 2024 15:55:36 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgCXc4d2cixnXGleBA--.64325S3;
	Thu, 07 Nov 2024 15:55:36 +0800 (CST)
Subject: Re: PROBLEM: repeatable lockup on RAID-6 with LUKS dm-crypt on NVMe
 devices when rsyncing many files
To: Christian Theune <ct@flyingcircus.io>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: John Stoffel <john@stoffel.org>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 dm-devel@lists.linux.dev, =?UTF-8?Q?Dragan_Milivojevi=c4=87?=
 <galileo@pkm-inc.com>, "yangerkun@huawei.com" <yangerkun@huawei.com>,
 "yukuai (C)" <yukuai3@huawei.com>
References: <ADF7D720-5764-4AF3-B68E-1845988737AA@flyingcircus.io>
 <45d44ed5-da7c-6480-9143-f611385b2e92@huaweicloud.com>
 <9C03DED0-3A6A-42F8-B935-6EB500F8BCE2@flyingcircus.io>
 <DD99A1F0-56E7-473D-B917-66885810233E@flyingcircus.io>
 <78517565-B1AB-4441-B4F8-EB380E98EB0F@flyingcircus.io>
 <26403.59789.480428.418012@quad.stoffel.home>
 <5fb0a6f0-066d-c490-3010-8a047aae2c29@huaweicloud.com>
 <F8CEEB15-0E3C-4F67-951D-12E165D6CC05@flyingcircus.io>
 <B6D76C57-B940-4BFD-9C40-D6E463D2A09F@flyingcircus.io>
 <5170f0d2-cb0f-2e0f-eb5e-31aa9d6ff65d@huawei.com>
 <2b093abc-cd9a-0b84-bcba-baec689fa153@huaweicloud.com>
 <63DE1813-C719-49B7-9012-641DB3DECA26@flyingcircus.io>
 <F8A5ABD5-0773-414D-BBBC-538481BCD0F4@flyingcircus.io>
 <753611d4-5c54-ee0d-30ab-9321274fd749@huaweicloud.com>
 <9A0AE411-B4B8-424A-B9F6-AF933F6544F9@flyingcircus.io>
 <BE85CBCF-1B09-48D0-9931-AA8D298F1D6B@flyingcircus.io>
 <b2a654e7-6c71-a44e-645c-686eed9d5cd8@huaweicloud.com>
 <240E3553-1EDD-49C8-88B8-FB3A7F0CE39C@flyingcircus.io>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <12295067-fc9a-8847-b370-7d86b2b66426@huaweicloud.com>
Date: Thu, 7 Nov 2024 15:55:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <240E3553-1EDD-49C8-88B8-FB3A7F0CE39C@flyingcircus.io>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCXc4d2cixnXGleBA--.64325S3
X-Coremail-Antispam: 1UD129KBjvJXoWxKr4DCrWktF48Zw1DuF4fuFg_yoWxCFW8pa
	y2va45GrZ8XFZYg3srA3yDuF1Fgw1kKr9rtFy8X34SkF17Kr9a9F4fWa4FyFn8CayfCFy3
	Zrn8try7GryxWrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvE14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWI
	evJa73UjIFyTuYvjfUYCJmUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi!

在 2024/11/06 14:40, Christian Theune 写道:
> Hi,
> 
>> On 6. Nov 2024, at 07:35, Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>
>> Hi,
>>
>> 在 2024/11/05 18:15, Christian Theune 写道:
>>> Hi,
>>> after about 2 hours it stalled again. Here’s the full blocked process dump. (Tell me if this isn’t helpful, otherwise I’ll keep posting that as it’s the only real data I can show)
>>
>> This is bad news :(
> 
> Yeah. But: the good new is that we aren’t eating any data so far … ;)
> 
>> While reviewing related code, I come up with a plan to move bitmap
>> start/end write ops to the upper layer. Make sure each write IO from
>> upper layer only start once and end once, this is easy to make sure
>> they are balanced and can avoid many calls to improve performance as
>> well.
> 
> Sounds like a plan!
> 
>> However, I need a few days to cooke a patch after work.
> 
> Sure thing! I’ll switch off bitmaps for that time - I’m happy we found a workaround so we can take time to resolve it cleanly. :)

I wrote a simple and crude version, please give it a test again.

Thanks,
Kuai

diff --git a/drivers/md/md.c b/drivers/md/md.c
index d3a837506a36..5e1a82b79e41 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8753,6 +8753,30 @@ void md_submit_discard_bio(struct mddev *mddev, 
struct md_rdev *rdev,
  }
  EXPORT_SYMBOL_GPL(md_submit_discard_bio);

+static bool is_raid456(struct mddev *mddev)
+{
+       return mddev->pers->level == 4 || mddev->pers->level == 5 ||
+              mddev->pers->level == 6;
+}
+
+static void bitmap_startwrite(struct mddev *mddev, struct bio *bio)
+{
+       if (!is_raid456(mddev) || !mddev->bitmap)
+               return;
+
+       md_bitmap_startwrite(mddev->bitmap, bio_offset(bio), 
bio_sectors(bio),
+                            0);
+}
+
+static void bitmap_endwrite(struct mddev *mddev, struct bio *bio, 
sector_t sectors)
+{
+       if (!is_raid456(mddev) || !mddev->bitmap)
+               return;
+
+       md_bitmap_endwrite(mddev->bitmap, bio_offset(bio), sectors,o
+                          bio->bi_status == BLK_STS_OK, 0);
+}
+
  static void md_end_clone_io(struct bio *bio)
  {
         struct md_io_clone *md_io_clone = bio->bi_private;
@@ -8765,6 +8789,7 @@ static void md_end_clone_io(struct bio *bio)
         if (md_io_clone->start_time)
                 bio_end_io_acct(orig_bio, md_io_clone->start_time);

+       bitmap_endwrite(mddev, orig_bio, md_io_clone->sectors);
         bio_put(bio);
         bio_endio(orig_bio);
         percpu_ref_put(&mddev->active_io);
@@ -8778,6 +8803,7 @@ static void md_clone_bio(struct mddev *mddev, 
struct bio **bio)
                 bio_alloc_clone(bdev, *bio, GFP_NOIO, 
&mddev->io_clone_set);

         md_io_clone = container_of(clone, struct md_io_clone, bio_clone);
+       md_io_clone->sectors = bio_sectors(*bio);
         md_io_clone->orig_bio = *bio;
         md_io_clone->mddev = mddev;
         if (blk_queue_io_stat(bdev->bd_disk->queue))
@@ -8790,6 +8816,7 @@ static void md_clone_bio(struct mddev *mddev, 
struct bio **bio)

  void md_account_bio(struct mddev *mddev, struct bio **bio)
  {
+       bitmap_startwrite(mddev, *bio);
         percpu_ref_get(&mddev->active_io);
         md_clone_bio(mddev, bio);
  }
@@ -8807,6 +8834,8 @@ void md_free_cloned_bio(struct bio *bio)
         if (md_io_clone->start_time)
                 bio_end_io_acct(orig_bio, md_io_clone->start_time);

+       bitmap_endwrite(mddev, orig_bio, md_io_clone->sectors);
+
         bio_put(bio);
         percpu_ref_put(&mddev->active_io);
  }
diff --git a/drivers/md/md.h b/drivers/md/md.h
index a0d6827dced9..0c2794230e0a 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -837,6 +837,7 @@ struct md_io_clone {
         struct mddev    *mddev;
         struct bio      *orig_bio;
         unsigned long   start_time;
+       sector_t        sectors;
         struct bio      bio_clone;
  };
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index c14cf2410365..4f009e32f68a 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3561,12 +3561,6 @@ static void __add_stripe_bio(struct stripe_head 
*sh, struct bio *bi,
                  * is added to a batch, STRIPE_BIT_DELAY cannot be changed
                  * any more.
                  */
-               set_bit(STRIPE_BITMAP_PENDING, &sh->state);
-               spin_unlock_irq(&sh->stripe_lock);
-               md_bitmap_startwrite(conf->mddev->bitmap, sh->sector,
-                                    RAID5_STRIPE_SECTORS(conf), 0);
-               spin_lock_irq(&sh->stripe_lock);
-               clear_bit(STRIPE_BITMAP_PENDING, &sh->state);
                 if (!sh->batch_head) {
                         sh->bm_seq = conf->seq_flush+1;
                         set_bit(STRIPE_BIT_DELAY, &sh->state);
@@ -3621,7 +3615,6 @@ handle_failed_stripe(struct r5conf *conf, struct 
stripe_head *sh,
         BUG_ON(sh->batch_head);
         for (i = disks; i--; ) {
                 struct bio *bi;
-               int bitmap_end = 0;

                 if (test_bit(R5_ReadError, &sh->dev[i].flags)) {
                         struct md_rdev *rdev = conf->disks[i].rdev;
@@ -3646,8 +3639,6 @@ handle_failed_stripe(struct r5conf *conf, struct 
stripe_head *sh,
                 sh->dev[i].towrite = NULL;
                 sh->overwrite_disks = 0;
                 spin_unlock_irq(&sh->stripe_lock);
-               if (bi)
-                       bitmap_end = 1;

                 log_stripe_write_finished(sh);
@@ -3662,10 +3653,6 @@ handle_failed_stripe(struct r5conf *conf, struct 
stripe_head *sh,
                         bio_io_error(bi);
                         bi = nextbi;
                 }
-               if (bitmap_end)
-                       md_bitmap_endwrite(conf->mddev->bitmap, sh->sector,
-                                          RAID5_STRIPE_SECTORS(conf), 
0, 0);
-               bitmap_end = 0;
                 /* and fail all 'written' */
                 bi = sh->dev[i].written;
                 sh->dev[i].written = NULL;
@@ -3674,7 +3661,6 @@ handle_failed_stripe(struct r5conf *conf, struct 
stripe_head *sh,
                         sh->dev[i].page = sh->dev[i].orig_page;
                 }

-               if (bi) bitmap_end = 1;
                 while (bi && bi->bi_iter.bi_sector <
                        sh->dev[i].sector + RAID5_STRIPE_SECTORS(conf)) {
                         struct bio *bi2 = r5_next_bio(conf, bi, 
sh->dev[i].sector);
@@ -3708,9 +3694,6 @@ handle_failed_stripe(struct r5conf *conf, struct 
stripe_head *sh,
                                 bi = nextbi;
                         }
                 }
-               if (bitmap_end)
-                       md_bitmap_endwrite(conf->mddev->bitmap, sh->sector,
-                                          RAID5_STRIPE_SECTORS(conf), 
0, 0);
                 /* If we were in the middle of a write the parity block 
might
                  * still be locked - so just clear all R5_LOCKED flags
                  */
@@ -4059,10 +4042,6 @@ static void handle_stripe_clean_event(struct 
r5conf *conf,
                                         bio_endio(wbi);
                                         wbi = wbi2;
                                 }
-                               md_bitmap_endwrite(conf->mddev->bitmap, 
sh->sector,
- 
RAID5_STRIPE_SECTORS(conf),
- 
!test_bit(STRIPE_DEGRADED, &sh->state),
-                                                  0);
                                 if (head_sh->batch_head) {
                                         sh = 
list_first_entry(&sh->batch_list,
                                                               struct 
stripe_head,
@@ -5788,13 +5767,6 @@ static void make_discard_request(struct mddev 
*mddev, struct bio *bi)
                 }
                 spin_unlock_irq(&sh->stripe_lock);
                 if (conf->mddev->bitmap) {
-                       for (d = 0;
-                            d < conf->raid_disks - conf->max_degraded;
-                            d++)
-                               md_bitmap_startwrite(mddev->bitmap,
-                                                    sh->sector,
- 
RAID5_STRIPE_SECTORS(conf),
-                                                    0);
                         sh->bm_seq = conf->seq_flush + 1;
                         set_bit(STRIPE_BIT_DELAY, &sh->state);
                 }



> 
> Thanks a lot for your help!
> Christian
> 

