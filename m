Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD75225D0
	for <dm-devel@lists.linux.dev>; Tue, 14 May 2024 08:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715676764; cv=none; b=Dt2lRwsYROtBhK46d2Vh8t8L+0bUkwHfqAM4AsOpc7uWGIxXZcDEgv+hoxQf37hWFaj0JDCFCK8fXkrzyPO+S+vytTFJ/KMwT1N795ODYxqPfHZ0zYI7xDAVXmGeVs2hs1xuN4rNr4cktegMm2IwLyEgbfILXED8FF2Arojjw08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715676764; c=relaxed/simple;
	bh=VnwPN1HC0Qg3a/FfvSmXTWKLTyLbOBEkoZkWOJT5MY8=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=ErJ+lM0qcdHU1iE1I7cgjzqXUmr6WZlSKDQGBLQSakAKK+QVfoCGvqONIM549mkMiPpoHOY8edNIqaWfN/ixQTlB16N9AK0i6PZ/oajk54Tj0PyqmTt9tM/wYRAoDRqz8evXaTwRfO3r3Iuwb3+isr80wT7ivR28KhCd18rCEuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4VdqqZ661Wz4f3lW3
	for <dm-devel@lists.linux.dev>; Tue, 14 May 2024 16:52:26 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id F39121A0851
	for <dm-devel@lists.linux.dev>; Tue, 14 May 2024 16:52:36 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgBnOBFTJkNmDmeDMg--.26345S3;
	Tue, 14 May 2024 16:52:36 +0800 (CST)
Subject: Re: [PATCH md-6.10 3/9] md: add new helpers for sync_action
To: Xiao Ni <xni@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
 dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20240509011900.2694291-1-yukuai1@huaweicloud.com>
 <20240509011900.2694291-4-yukuai1@huaweicloud.com>
 <CALTww2-RPH_eYBumjxhHLkj7J2tfHskTYNif93Hwn5ksCN0+kA@mail.gmail.com>
 <06211ae2-9b5f-10c7-7953-9d79d2eacc67@huaweicloud.com>
 <CALTww28LM_b6SMC-vLY3y7R3ZD9z80H+2vZCXMzmAwnoEH-eMA@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <2d457d0f-8bb5-39cb-0b8a-0bfdde1f560f@huaweicloud.com>
Date: Tue, 14 May 2024 16:52:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CALTww28LM_b6SMC-vLY3y7R3ZD9z80H+2vZCXMzmAwnoEH-eMA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgBnOBFTJkNmDmeDMg--.26345S3
X-Coremail-Antispam: 1UD129KBjvJXoW3Xw4fuw4kCrWUGFW3KF17ZFb_yoW7Kw47pF
	W0yFn8Zr4UXry7Jr12q3WDta9ayr1IqryUXry3Ga48J3ZxKFn3G3WUJF17Cryvyr15uryj
	vrWDGFW3uF4YyrJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Y14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kI
	c2xKxwCYjI0SjxkI62AI1cAE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4
	AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE
	17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMI
	IF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq
	3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCT
	nIWIevJa73UjIFyTuYvjfUoOJ5UUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/



在 2024/05/14 16:40, Xiao Ni 写道:
> On Tue, May 14, 2024 at 3:39 PM Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>
>> Hi,
>>
>> 在 2024/05/14 14:52, Xiao Ni 写道:
>>> On Mon, May 13, 2024 at 5:31 PM Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>>>
>>>> From: Yu Kuai <yukuai3@huawei.com>
>>>>
>>>> The new helpers will get current sync_action of the array, will be used
>>>> in later patches to make code cleaner.
>>>>
>>>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>>>> ---
>>>>    drivers/md/md.c | 64 +++++++++++++++++++++++++++++++++++++++++++++++++
>>>>    drivers/md/md.h |  3 +++
>>>>    2 files changed, 67 insertions(+)
>>>>
>>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>>>> index 00bbafcd27bb..48ec35342d1b 100644
>>>> --- a/drivers/md/md.c
>>>> +++ b/drivers/md/md.c
>>>> @@ -69,6 +69,16 @@
>>>>    #include "md-bitmap.h"
>>>>    #include "md-cluster.h"
>>>>
>>>> +static char *action_name[NR_SYNC_ACTIONS] = {
>>>> +       [ACTION_RESYNC]         = "resync",
>>>> +       [ACTION_RECOVER]        = "recover",
>>>> +       [ACTION_CHECK]          = "check",
>>>> +       [ACTION_REPAIR]         = "repair",
>>>> +       [ACTION_RESHAPE]        = "reshape",
>>>> +       [ACTION_FROZEN]         = "frozen",
>>>> +       [ACTION_IDLE]           = "idle",
>>>> +};
>>>> +
>>>>    /* pers_list is a list of registered personalities protected by pers_lock. */
>>>>    static LIST_HEAD(pers_list);
>>>>    static DEFINE_SPINLOCK(pers_lock);
>>>> @@ -4867,6 +4877,60 @@ metadata_store(struct mddev *mddev, const char *buf, size_t len)
>>>>    static struct md_sysfs_entry md_metadata =
>>>>    __ATTR_PREALLOC(metadata_version, S_IRUGO|S_IWUSR, metadata_show, metadata_store);
>>>>
>>>> +enum sync_action md_sync_action(struct mddev *mddev)
>>>> +{
>>>> +       unsigned long recovery = mddev->recovery;
>>>> +
>>>> +       /*
>>>> +        * frozen has the highest priority, means running sync_thread will be
>>>> +        * stopped immediately, and no new sync_thread can start.
>>>> +        */
>>>> +       if (test_bit(MD_RECOVERY_FROZEN, &recovery))
>>>> +               return ACTION_FROZEN;
>>>> +
>>>> +       /*
>>>> +        * idle means no sync_thread is running, and no new sync_thread is
>>>> +        * requested.
>>>> +        */
>>>> +       if (!test_bit(MD_RECOVERY_RUNNING, &recovery) &&
>>>> +           (!md_is_rdwr(mddev) || !test_bit(MD_RECOVERY_NEEDED, &recovery)))
>>>> +               return ACTION_IDLE;
>>>
>>> Hi Kuai
>>>
>>> Can I think the above judgement cover these two situations:
>>> 1. The array is readonly / readauto and it doesn't have
>>> MD_RECOVERY_RUNNING. Now maybe it has MD_RECOVERY_NEEDED, it means one
>>> array may want to do some sync action, but the array state is not
>>> readwrite and it can't start.
>>> 2. The array doesn't have MD_RECOVERY_RUNNING and MD_RECOVERY_NEEDED
>>>
>>>> +
>>>> +       if (test_bit(MD_RECOVERY_RESHAPE, &recovery) ||
>>>> +           mddev->reshape_position != MaxSector)
>>>> +               return ACTION_RESHAPE;
>>>> +
>>>> +       if (test_bit(MD_RECOVERY_RECOVER, &recovery))
>>>> +               return ACTION_RECOVER;
>>>> +
>>>> +       if (test_bit(MD_RECOVERY_SYNC, &recovery)) {
>>>> +               if (test_bit(MD_RECOVERY_CHECK, &recovery))
>>>> +                       return ACTION_CHECK;
>>>> +               if (test_bit(MD_RECOVERY_REQUESTED, &recovery))
>>>> +                       return ACTION_REPAIR;
>>>> +               return ACTION_RESYNC;
>>>> +       }
>>>> +
>>>> +       return ACTION_IDLE;
>>>
>>> Does it need this? I guess it's the reason in case there are other
>>> situations, right?
>>
>> Yes, we need this, because they are many places to set
>> MD_RECOVERY_NEEDED, while there are no sync action actually, this case
>> is 'idle'.
> 
> To be frank, the logic in action_show is easier to understand than the
> logic above. I have taken more than half an hour to think if the logic
> here is right or not. In action_show, it only needs to think when it's
> not idle and it's easy.
> 
> Now this patch logic needs to think in the opposite direction: when
> it's idle. And it returns ACTION_IDLE at two places which means it
> still needs to think about when it has sync action. So it's better to
> keep the original logic in action_show now. It's just my 2 cents
> point.

Hi,

but the logical is exactlly the same as action_show(), and there are
no functional changes. I just remove the local variable and return
early, because I think code is cleaner this way...

action_show:

char *type = "idle"

if (test_bit() || xxx) {

  if (xxx)
   type ="reshape"
  else if(xxx)
   type ="resync/check/repair"
  else if(xxx)
   type = "recover"
  else if (xxx)
   type = "reshape"
  -> else is idle
}
-> else is idle

The above two place are corresponding to the new code to return
ACTION_IDLE.

Thanks,
Kuai

> 
> Best Regards
> Xiao
> 
>>
>> Thanks,
>> Kuai
>>
>>>
>>> Regards
>>> Xiao
>>>
>>>> +}
>>>> +
>>>> +enum sync_action md_sync_action_by_name(char *page)
>>>> +{
>>>> +       enum sync_action action;
>>>> +
>>>> +       for (action = 0; action < NR_SYNC_ACTIONS; ++action) {
>>>> +               if (cmd_match(page, action_name[action]))
>>>> +                       return action;
>>>> +       }
>>>> +
>>>> +       return NR_SYNC_ACTIONS;
>>>> +}
>>>> +
>>>> +char *md_sync_action_name(enum sync_action action)
>>>> +{
>>>> +       return action_name[action];
>>>> +}
>>>> +
>>>>    static ssize_t
>>>>    action_show(struct mddev *mddev, char *page)
>>>>    {
>>>> diff --git a/drivers/md/md.h b/drivers/md/md.h
>>>> index 2edad966f90a..72ca7a796df5 100644
>>>> --- a/drivers/md/md.h
>>>> +++ b/drivers/md/md.h
>>>> @@ -864,6 +864,9 @@ extern void md_unregister_thread(struct mddev *mddev, struct md_thread __rcu **t
>>>>    extern void md_wakeup_thread(struct md_thread __rcu *thread);
>>>>    extern void md_check_recovery(struct mddev *mddev);
>>>>    extern void md_reap_sync_thread(struct mddev *mddev);
>>>> +extern enum sync_action md_sync_action(struct mddev *mddev);
>>>> +extern enum sync_action md_sync_action_by_name(char *page);
>>>> +extern char *md_sync_action_name(enum sync_action action);
>>>>    extern bool md_write_start(struct mddev *mddev, struct bio *bi);
>>>>    extern void md_write_inc(struct mddev *mddev, struct bio *bi);
>>>>    extern void md_write_end(struct mddev *mddev);
>>>> --
>>>> 2.39.2
>>>>
>>>
>>> .
>>>
>>
>>
> 
> .
> 

