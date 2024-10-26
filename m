Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7090D217F5E
	for <dm-devel@lists.linux.dev>; Sat, 26 Oct 2024 09:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729933664; cv=none; b=kAABBlpZTQPNht8ERYkx66sKLvb22HCDfrXR64CLDKy7i6Zud/nBhr6fAdQbOcI4+/zuvuJxTohjpL8Y5iAdtb8Te5riBX/iBmryeQpLA18h/GJHi1yHMgFICNzANAlS37eoFblTm2vRArhSVqSA+QQsVuNHFDlczd8JM2haRHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729933664; c=relaxed/simple;
	bh=+VMspjWYzI9QMnADjv8f8MuW9buTruCCjyMoYn8oHpA=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=dpX5twaogulp9nf9LRrViVSeN9MDR3NdVuSyPxVLK4X3Rae1HOSq3brJMu0LNvKXZd/F6/pyW5W+JXhgQd5xKVtI9Z21Vl6QyiTJOHgRgo6xS/ukgBVE24Hb6/dpCFZO+CZ8QJsILYxkSIC46jb9xL6rYSjn0kFq7OggwehUfOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4XbDLZ4fPGz4f3mHl
	for <dm-devel@lists.linux.dev>; Sat, 26 Oct 2024 17:07:18 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 010EB1A0194
	for <dm-devel@lists.linux.dev>; Sat, 26 Oct 2024 17:07:36 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgAXTMhXsRxnlAeoFA--.41950S3;
	Sat, 26 Oct 2024 17:07:36 +0800 (CST)
Subject: Re: PROBLEM: repeatable lockup on RAID-6 with LUKS dm-crypt on NVMe
 devices when rsyncing many files
To: Christian Theune <ct@flyingcircus.io>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: John Stoffel <john@stoffel.org>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 dm-devel@lists.linux.dev, =?UTF-8?Q?Dragan_Milivojevi=c4=87?=
 <galileo@pkm-inc.com>, "yukuai (C)" <yukuai3@huawei.com>
References: <ADF7D720-5764-4AF3-B68E-1845988737AA@flyingcircus.io>
 <4363F3A3-46C2-419E-B43A-4CDA8C293CEB@flyingcircus.io>
 <C832C22B-E720-4457-83C6-CA259AD667B2@flyingcircus.io>
 <e92ccf15-be2a-a1aa-5ea2-a88def82e681@huaweicloud.com>
 <30D680B2-F494-42F5-8498-6ED586E05766@flyingcircus.io>
 <26294.40330.924457.532299@quad.stoffel.home>
 <C9A9855D-B0A2-4B13-947E-01AF5BA6DF04@flyingcircus.io>
 <26298.22106.810744.702395@quad.stoffel.home>
 <EBC67418-E60C-435A-8F63-114C67F07583@flyingcircus.io>
 <CEC90137-09B3-41AA-A115-1C172F9C6C4B@flyingcircus.io>
 <2F5F9789-1827-4105-934F-516582018540@flyingcircus.io>
 <adee77ef-f785-acd6-485a-fe2d0a1b9a92@huaweicloud.com>
 <143E09BF-BD10-43EB-B0F1-7421F8200DB1@flyingcircus.io>
 <1bbc86a8-1abf-11a1-e724-b6868a8d9f88@huaweicloud.com>
 <69D8A311-E619-40C2-985A-FB15D0336ADE@flyingcircus.io>
 <CALtW_agiOj2PJ_vsWym0qR8w1Q9iotHKPGuP5RohktkqeXt2mw@mail.gmail.com>
 <E893A1D9-4042-4515-88AE-C69B078A3E43@flyingcircus.io>
 <A74EC4F5-2FF8-4274-A1EB-28D527F143F1@flyingcircus.io>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <2d85e9ab-1d0f-70a1-fab2-1e469764ef28@huaweicloud.com>
Date: Sat, 26 Oct 2024 17:07:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <A74EC4F5-2FF8-4274-A1EB-28D527F143F1@flyingcircus.io>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXTMhXsRxnlAeoFA--.41950S3
X-Coremail-Antispam: 1UD129KBjvJXoWxuF4kKr1DArWDKry3ur1kuFg_yoWrCF43pr
	43X34fZrZ8tFZaqwnrGrWUuFyFqr48Zr9rtFWrXw4ak3ZFg39akF1xWFyUtF1vyw1rAFy3
	AF9xZr4rGFyqq3JanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
	Y487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r
	1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CE
	b7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0x
	vE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAI
	cVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2Kf
	nxnUUI43ZEXa7VUbSfO7UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/10/26 13:37, Christian Theune 写道:
> 
>> On 25. Oct 2024, at 16:02, Christian Theune <ct@flyingcircus.io> wrote:
>>
>> Yeah, this was more directed towards the question whether Yu needs me to run the patch that he posted earlier.
>>
>> So. The current status is: previously this crashed within 2-3 hours. Both machines are now running with the bitmap turned off as described above and have been syncing data for about 7 hours. This seems to indicate that the bitmap is involved here.
> 
> Update: both machines have been able to finish their multi-TiB rsync job that previously caused reliable lockups. So: the bitmap code seems to be the culprit here …
> 
> Christian
> 

Then, can you enable bitmap and test the following debug patch:

Thanks,
Kuai

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 58f71c3e1368..b2a75a904209 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2369,6 +2369,7 @@ static struct stripe_head *alloc_stripe(struct 
kmem_cache *sc, gfp_t gfp,
                 atomic_set(&sh->count, 1);
                 sh->raid_conf = conf;
                 sh->log_start = MaxSector;
+               atomic_set(&sh->bitmap_counts, 0);

                 if (raid5_has_ppl(conf)) {
                         sh->ppl_page = alloc_page(gfp);
@@ -3565,6 +3566,7 @@ static void __add_stripe_bio(struct stripe_head 
*sh, struct bio *bi,
                 spin_unlock_irq(&sh->stripe_lock);
                 conf->mddev->bitmap_ops->startwrite(conf->mddev, 
sh->sector,
                                         RAID5_STRIPE_SECTORS(conf), false);
+               printk("%s: %s: start %px(%llu+%lu) %u\n", __func__, 
mdname(conf->mddev), sh, sh->sector, RAID5_STRIPE_SECTORS(conf), 
atomic_inc_return(&sh->bitmap_counts));
                 spin_lock_irq(&sh->stripe_lock);
                 clear_bit(STRIPE_BITMAP_PENDING, &sh->state);
                 if (!sh->batch_head) {
@@ -3662,10 +3664,12 @@ handle_failed_stripe(struct r5conf *conf, struct 
stripe_head *sh,
                         bio_io_error(bi);
                         bi = nextbi;
                 }
-               if (bitmap_end)
+               if (bitmap_end) {
                         conf->mddev->bitmap_ops->endwrite(conf->mddev,
                                         sh->sector, 
RAID5_STRIPE_SECTORS(conf),
                                         false, false);
+                       printk("%s: %s: end %px(%llu+%lu) %u\n", 
__func__, mdname(conf->mddev), sh, sh->sector, 
RAID5_STRIPE_SECTORS(conf), atomic_dec_return(&sh->bitmap_counts));
+               }
                 bitmap_end = 0;
                 /* and fail all 'written' */
                 bi = sh->dev[i].written;
@@ -3709,10 +3713,12 @@ handle_failed_stripe(struct r5conf *conf, struct 
stripe_head *sh,
                                 bi = nextbi;
                         }
                 }
-               if (bitmap_end)
+               if (bitmap_end) {
                         conf->mddev->bitmap_ops->endwrite(conf->mddev,
                                         sh->sector, 
RAID5_STRIPE_SECTORS(conf),
                                         false, false);
+                       printk("%s: %s: end %px(%llu+%lu) %u\n", 
__func__, mdname(conf->mddev), sh, sh->sector, 
RAID5_STRIPE_SECTORS(conf), atomic_dec_return(&sh->bitmap_counts));
+               }
                 /* If we were in the middle of a write the parity block 
might
                  * still be locked - so just clear all R5_LOCKED flags
                  */
@@ -4065,6 +4071,7 @@ static void handle_stripe_clean_event(struct 
r5conf *conf,
                                         sh->sector, 
RAID5_STRIPE_SECTORS(conf),
                                         !test_bit(STRIPE_DEGRADED, 
&sh->state),
                                         false);
+                               printk("%s: %s: end %px(%llu+%lu) %u\n", 
__func__, mdname(conf->mddev), sh, sh->sector, 
RAID5_STRIPE_SECTORS(conf), atomic_dec_return(&sh->bitmap_counts));
                                 if (head_sh->batch_head) {
                                         sh = 
list_first_entry(&sh->batch_list,
                                                               struct 
stripe_head,
@@ -5785,9 +5792,11 @@ static void make_discard_request(struct mddev 
*mddev, struct bio *bi)
                 spin_unlock_irq(&sh->stripe_lock);
                 if (conf->mddev->bitmap) {
                         for (d = 0; d < conf->raid_disks - 
conf->max_degraded;
-                            d++)
+                            d++) {
                                 mddev->bitmap_ops->startwrite(mddev, 
sh->sector,
                                         RAID5_STRIPE_SECTORS(conf), false);
+                               printk("%s: %s: start %px(%llu+%lu) 
%u\n", __func__, mdname(conf->mddev), sh, sh->sector, 
RAID5_STRIPE_SECTORS(conf), atomic_inc_return(&sh->bitmap_counts));
+                       }
                         sh->bm_seq = conf->seq_flush + 1;
                         set_bit(STRIPE_BIT_DELAY, &sh->state);
                 }
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 896ecfc4afa6..12024249245e 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -255,6 +255,7 @@ struct stripe_head {
         int     nr_pages;       /* page array size */
         int     stripes_per_page;
  #endif
+       atomic_t bitmap_counts;
         struct r5dev {
                 /* rreq and rvec are used for the replacement device when
                  * writing data to both devices.

