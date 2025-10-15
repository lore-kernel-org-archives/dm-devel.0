Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD3C3310771
	for <dm-devel@lists.linux.dev>; Wed, 15 Oct 2025 06:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760511541; cv=none; b=Kni1tX+DURllVF2621jElfCXR09lSg6NOKhN06SB7ji5NvcMvrWpcLmMtyC8tPlOw3hBPDMv3i3ZND+pzrUigiOcGEaQrqYT3Zb1s30G5rOWtVC78IwJL13EwSexoxo2hcClv+ys2ORSGjr+LqOZMFdFICudGJ54Y69EfRR8Tmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760511541; c=relaxed/simple;
	bh=mB7O1p7vtPwD5hmmxf81P4UzNGnXnoQJkIFjh/Tf+zc=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=KsR2i9ixJAeTAdBbQ8Ynd2WOMgfvG44RChagxlGsX99vkDIeSjK9onD5t3vJ/mFVI0t9HbQbfDAgPbd05ZfEw6gCWy0UnhGA1WoA8qK1bB7khR7aq58u4GR/8K++6sNyhH/zu8nsPZ7npmOQGmBaM+l9czLKT1DhsROonePC9LI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cmhk82lpczYQv24
	for <dm-devel@lists.linux.dev>; Wed, 15 Oct 2025 14:58:08 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id A629B1A0F75
	for <dm-devel@lists.linux.dev>; Wed, 15 Oct 2025 14:58:50 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP2 (Coremail) with SMTP id Syh0CgDnPUYoRu9o3w+4AQ--.58200S3;
	Wed, 15 Oct 2025 14:58:50 +0800 (CST)
Subject: Re: [PATCH] md: fix rcu protection in md_wakeup_thread
To: Paul Menzel <pmenzel@molgen.mpg.de>, Yun Zhou <yun.zhou@windriver.com>
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
 dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20251015055924.899423-1-yun.zhou@windriver.com>
 <86705912-07a3-4a24-bacd-ad5ac2038201@molgen.mpg.de>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <d2574af5-9410-d296-ef74-97f3e43dc1cc@huaweicloud.com>
Date: Wed, 15 Oct 2025 14:58:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <86705912-07a3-4a24-bacd-ad5ac2038201@molgen.mpg.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgDnPUYoRu9o3w+4AQ--.58200S3
X-Coremail-Antispam: 1UD129KBjvJXoWxXFy7try5WryDGFW8AFW8WFg_yoW5Wry5pr
	W8try7Cw4YvrWj9w1DAa4DCa45tw10qFW2krW8C3yfZwnrK3yayFy7KFyUXws0kF15Grnx
	Z3W5KFn3ZF4ktF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Ib4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7Mxk0xIA0c2IE
	e2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4I
	kC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWU
	WwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr
	0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWU
	JVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJb
	IYCTnIWIevJa73UjIFyTuYvjxUF1v3UUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/10/15 14:35, Paul Menzel 写道:
> Dear Yun,
> 
> 
> Thank you for your patch.
> 
> Am 15.10.25 um 07:59 schrieb Yun Zhou:
>> We attempted to use RCU to protect the pointer 'thread', but directly
>> passed the value when calling md_wakeup_thread(). This means that the
>> RCU pointer has been acquired before rcu_read_lock(), which renders
>> rcu_read_lock() ineffective and could lead to a use-after-free.
> 
> Could you elaborate a little more – especially as nobody has noticed 
> this so far since v6.5-rc1?
> 

This looks correct, memory dereference should be protected by rcu, while
in fact this is done before function parameter passing.

However, in most places, a null check should be enough because the md
thread can't be unregistered concurrently, that's probably no one ever
meet the problem.

However, for the modification, I'll prefer a new marcon like following,
so that you don't need to update all the callers:

Thanks,
Kuai

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 1de550108756..d48ee1b50d27 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8384,11 +8384,10 @@ static void md_wakeup_thread_directly(struct 
md_thread __rcu *thread)
         rcu_read_unlock();
  }

-void md_wakeup_thread(struct md_thread __rcu *thread)
+void __md_wakeup_thread(struct md_thread __rcu *thread)
  {
         struct md_thread *t;

-       rcu_read_lock();
         t = rcu_dereference(thread);
         if (t) {
                 pr_debug("md: waking up MD thread %s.\n", t->tsk->comm);
@@ -8396,9 +8395,8 @@ void md_wakeup_thread(struct md_thread __rcu *thread)
                 if (wq_has_sleeper(&t->wqueue))
                         wake_up(&t->wqueue);
         }
-       rcu_read_unlock();
  }
-EXPORT_SYMBOL(md_wakeup_thread);
+EXPORT_SYMBOL(__md_wakeup_thread);

  struct md_thread *md_register_thread(void (*run) (struct md_thread *),
                 struct mddev *mddev, const char *name)
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 1979c2d4fe89..9ec62afc2a7d 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -882,6 +882,12 @@ struct md_io_clone {

  #define THREAD_WAKEUP  0

+#define md_wakeup_thread(thread) do {                          \
+       rcu_read_lock();                                        \
+       __md_wakeup_thread(thread);                             \
+       rcu_read_unlock();                                      \
+} while (0)
+
  static inline void safe_put_page(struct page *p)
  {
         if (p) put_page(p);
@@ -895,7 +901,7 @@ extern struct md_thread *md_register_thread(
         struct mddev *mddev,
         const char *name);
  extern void md_unregister_thread(struct mddev *mddev, struct md_thread 
__rcu **threadp);
-extern void md_wakeup_thread(struct md_thread __rcu *thread);
+extern void __md_wakeup_thread(struct md_thread __rcu *thread);
  extern void md_check_recovery(struct mddev *mddev);
  extern void md_reap_sync_thread(struct mddev *mddev);
  extern enum sync_action md_sync_action(struct mddev *mddev);

