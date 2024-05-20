Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8CB1B59A
	for <dm-devel@lists.linux.dev>; Mon, 20 May 2024 07:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716190038; cv=none; b=a/5ZhIEurcR7vVTN6bILvVByjFm6HdJBR+7BHh7J2F1QvY9f+wL61a5iccYiDumDMN+stpCa75gfwFVDsbNTdEhQwq+/B1vtCDHOY0qdKXWMKqQgq35tUjo8sCtUME5HWDJpxAF27lnZU/HcESP62m66c78jMNA6EEKi3GkFG6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716190038; c=relaxed/simple;
	bh=X0lhOwRtW/UV/XAfkDERI5c3Rxox9rP4mq/396aTjYw=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=bgPnpt5FycmApWq6n7eUlcBnwW5I+6Sk7lrawQSDgmqgUc3P7wDH3aXg0GF2n5nEQF1Zf+XSiot7KF8haE0jN/qfEjXOy85a/gDpX42i8B9hJRo7YkyF63aiIlQk6bO7rI4rb628SXpv4wHYLoQkttuQTMjCodRiY646hCj7X34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4VjTfF5Cdcz4f3lVn
	for <dm-devel@lists.linux.dev>; Mon, 20 May 2024 15:27:01 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 1F3591A083E
	for <dm-devel@lists.linux.dev>; Mon, 20 May 2024 15:27:12 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgDHlxBM+0pmCnisNA--.43024S3;
	Mon, 20 May 2024 15:27:10 +0800 (CST)
Subject: Re: [bug report] INFO: task mdX_resync:42168 blocked for more than
 122 seconds
To: Yu Kuai <yukuai1@huaweicloud.com>, Changhui Zhong <czhong@redhat.com>
Cc: Ming Lei <ming.lei@redhat.com>,
 Linux Block Devices <linux-block@vger.kernel.org>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
 Xiao Ni <xni@redhat.com>, "yukuai (C)" <yukuai3@huawei.com>
References: <CAGVVp+Xsmzy2G9YuEatfMT6qv1M--YdOCQ0g7z7OVmcTbBxQAg@mail.gmail.com>
 <ZkXsOKV5d4T0Hyqu@fedora>
 <9b340157-dc0c-6e6a-3d92-f2c65b515461@huaweicloud.com>
 <CAGVVp+XtThX7=bZm441VxyVd-wv_ycdqMU=19a2pa4wUkbkJ3g@mail.gmail.com>
 <1b35a177-670a-4d2f-0b68-6eda769af37d@huaweicloud.com>
 <CAGVVp+WQVeV0PE12RvpojFTRB4rHXh6Lk01vLmdStw1W9zUACg@mail.gmail.com>
 <CAGVVp+WGyPS5nOQYhWtgJyQnXwUb-+Hui14pXqxd+-ZUjWpTrA@mail.gmail.com>
 <f1c98dd1-a62c-6857-3773-e05b80e6a763@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <ca29a4b1-4b4a-3b1c-4981-6e05e0bb24be@huaweicloud.com>
Date: Mon, 20 May 2024 15:27:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <f1c98dd1-a62c-6857-3773-e05b80e6a763@huaweicloud.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgDHlxBM+0pmCnisNA--.43024S3
X-Coremail-Antispam: 1UD129KBjvJXoWxCrWrCr43Zry7Gr4xZFW8JFb_yoWrWr4kpa
	yfXF1ayFWUZrn3Jw1kJa1UuFyFv348ta48JFWrKwn3ZFZ7tFZa9w1Igw1YgryqvrZ3X34x
	XF98Z39xAr17tFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9F14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
	kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
	67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
	CI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E
	3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcS
	sGvfC2KfnxnUUI43ZEXa7VUbXdbUUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/05/20 10:55, Yu Kuai 写道:
> Hi, Changhui
> 
> 在 2024/05/20 8:39, Changhui Zhong 写道:
>> [czhong@vm linux-block]$ git bisect bad
>> 060406c61c7cb4bbd82a02d179decca9c9bb3443 is the first bad commit
>> commit 060406c61c7cb4bbd82a02d179decca9c9bb3443
>> Author: Yu Kuai<yukuai3@huawei.com>
>> Date:   Thu May 9 20:38:25 2024 +0800
>>
>>      block: add plug while submitting IO
>>
>>      So that if caller didn't use plug, for example, 
>> __blkdev_direct_IO_simple()
>>      and __blkdev_direct_IO_async(), block layer can still benefit 
>> from caching
>>      nsec time in the plug.
>>
>>      Signed-off-by: Yu Kuai<yukuai3@huawei.com>
>>      
>> Link:https://lore.kernel.org/r/20240509123825.3225207-1-yukuai1@huaweicloud.com 
>>
>>      Signed-off-by: Jens Axboe<axboe@kernel.dk>
>>
>>   block/blk-core.c | 6 ++++++
>>   1 file changed, 6 insertions(+)
> 
> Thanks for the test!
> 
> I was surprised to see this blamed commit, and after taking a look at
> raid1 barrier code, I found that there are some known problems, fixed in
> raid10, while raid1 still unfixed. So I wonder this patch maybe just
> making the exist problem easier to reporduce.
> 
> I'll start cooking patches to sync raid10 fixes to raid1, meanwhile,
> can you change your script to test raid10 as well, if raid10 is fine,
> I'll give you these patches later to test raid1.

Hi,

Sorry to ask, but since I can't reporduce the problem, and based on
code reiview, there are multiple potential problems, can you also
reporduce the problem with following debug patch(just add some debug
info, no functional changes). So that I can make sure of details of
the problem.

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 113135e7b5f2..b35b847a9e8b 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -936,6 +936,45 @@ static void flush_pending_writes(struct r1conf *conf)
                 spin_unlock_irq(&conf->device_lock);
  }

+static bool waiting_barrier(struct r1conf *conf, int idx)
+{
+       int nr = atomic_read(&conf->nr_waiting[idx]);
+
+       if (nr) {
+               printk("%s: idx %d nr_waiting %d\n", __func__, idx, nr);
+               return true;
+       }
+
+       return false;
+}
+
+static bool waiting_pending(struct r1conf *conf, int idx)
+{
+       int nr;
+
+       if (test_bit(MD_RECOVERY_INTR, &conf->mddev->recovery))
+               return false;
+
+       if (conf->array_frozen) {
+               printk("%s: array is frozen\n", __func__);
+               return true;
+       }
+
+       nr = atomic_read(&conf->nr_pending[idx]);
+       if (nr) {
+               printk("%s: idx %d nr_pending %d\n", __func__, idx, nr);
+               return true;
+       }
+
+       nr = atomic_read(&conf->barrier[idx]);
+       if (nr >= RESYNC_DEPTH) {
+               printk("%s: idx %d barrier %d exceeds %d\n", __func__, 
idx, nr, RESYNC_DEPTH);
+               return true;
+       }
+
+       return false;
+}
+
  /* Barriers....
   * Sometimes we need to suspend IO while we do something else,
   * either some resync/recovery, or reconfigure the array.
@@ -967,8 +1006,7 @@ static int raise_barrier(struct r1conf *conf, 
sector_t sector_nr)
         spin_lock_irq(&conf->resync_lock);

         /* Wait until no block IO is waiting */
-       wait_event_lock_irq(conf->wait_barrier,
-                           !atomic_read(&conf->nr_waiting[idx]),
+       wait_event_lock_irq(conf->wait_barrier, !waiting_barrier(conf, idx),
                             conf->resync_lock);

         /* block any new IO from starting */
@@ -990,11 +1028,7 @@ static int raise_barrier(struct r1conf *conf, 
sector_t sector_nr)
          * C: while conf->barrier[idx] >= RESYNC_DEPTH, meaning reaches
          *    max resync count which allowed on current I/O barrier bucket.
          */
-       wait_event_lock_irq(conf->wait_barrier,
-                           (!conf->array_frozen &&
-                            !atomic_read(&conf->nr_pending[idx]) &&
-                            atomic_read(&conf->barrier[idx]) < 
RESYNC_DEPTH) ||
-                               test_bit(MD_RECOVERY_INTR, 
&conf->mddev->recovery),
+       wait_event_lock_irq(conf->wait_barrier, !waiting_pending(conf, idx),
                             conf->resync_lock);

         if (test_bit(MD_RECOVERY_INTR, &conf->mddev->recovery)) {

Thanks,
Kuai

> 
> Thanks,
> Kuai
> 
> .
> 

