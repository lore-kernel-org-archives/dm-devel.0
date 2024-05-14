Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54BB1EA74
	for <dm-devel@lists.linux.dev>; Tue, 14 May 2024 07:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715672366; cv=none; b=pTXy/7kUH4CLe2OuQrtSzltBoUaVBytiM1hu+846mu+RnB7BKq4IRfaVkyzFcuUfjRN5RSrI2GIdC38T1u3GIW9PDCaJ+jXRdDJeOv6zmTzaEv+RT1qTNMGqy7mzAez4EdhHO5+Ma8dKrX4CwDDI9DF/6qzDEZVK/HWHkv8Z1wQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715672366; c=relaxed/simple;
	bh=MnSQzHoxtxIl3IOV7lyQzamLUBc4nGorf90eqgyKJ5Q=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=KSVph0NCFY+ffpvUs6nO1LGmkX+0VkVi/q1SV3mTezr+GDBnEAHVXMFVVD6CfWflkorUuoaQsOW0k7msXvy8YxxmOHgaAlct/ObxHm8Avs5oPky6+CQURuTEgjTbHxRu2NrbGq+WLhRcn4pgMU4kVBDmewRTBg2C244f03ZRH4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4VdpBx5fDwz4f3jXJ
	for <dm-devel@lists.linux.dev>; Tue, 14 May 2024 15:39:05 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 651AD1A0842
	for <dm-devel@lists.linux.dev>; Tue, 14 May 2024 15:39:14 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgBnOBEgFUNmecN+Mg--.24478S3;
	Tue, 14 May 2024 15:39:14 +0800 (CST)
Subject: Re: [PATCH md-6.10 3/9] md: add new helpers for sync_action
To: Xiao Ni <xni@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
 dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20240509011900.2694291-1-yukuai1@huaweicloud.com>
 <20240509011900.2694291-4-yukuai1@huaweicloud.com>
 <CALTww2-RPH_eYBumjxhHLkj7J2tfHskTYNif93Hwn5ksCN0+kA@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <06211ae2-9b5f-10c7-7953-9d79d2eacc67@huaweicloud.com>
Date: Tue, 14 May 2024 15:39:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CALTww2-RPH_eYBumjxhHLkj7J2tfHskTYNif93Hwn5ksCN0+kA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgBnOBEgFUNmecN+Mg--.24478S3
X-Coremail-Antispam: 1UD129KBjvJXoWxZFW3Wr13tw4fCFW8tw1rCrg_yoWruF18pF
	W0yas8ZrW7ZFy7Xry2qa4DAayF9r1Iq3y7AFyfGa4fJ3ZIkwnaka4DK3W7Ca4vka43ur1Y
	va4DGFy3uF4FyrJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9F14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
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

在 2024/05/14 14:52, Xiao Ni 写道:
> On Mon, May 13, 2024 at 5:31 PM Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> The new helpers will get current sync_action of the array, will be used
>> in later patches to make code cleaner.
>>
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>> ---
>>   drivers/md/md.c | 64 +++++++++++++++++++++++++++++++++++++++++++++++++
>>   drivers/md/md.h |  3 +++
>>   2 files changed, 67 insertions(+)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 00bbafcd27bb..48ec35342d1b 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -69,6 +69,16 @@
>>   #include "md-bitmap.h"
>>   #include "md-cluster.h"
>>
>> +static char *action_name[NR_SYNC_ACTIONS] = {
>> +       [ACTION_RESYNC]         = "resync",
>> +       [ACTION_RECOVER]        = "recover",
>> +       [ACTION_CHECK]          = "check",
>> +       [ACTION_REPAIR]         = "repair",
>> +       [ACTION_RESHAPE]        = "reshape",
>> +       [ACTION_FROZEN]         = "frozen",
>> +       [ACTION_IDLE]           = "idle",
>> +};
>> +
>>   /* pers_list is a list of registered personalities protected by pers_lock. */
>>   static LIST_HEAD(pers_list);
>>   static DEFINE_SPINLOCK(pers_lock);
>> @@ -4867,6 +4877,60 @@ metadata_store(struct mddev *mddev, const char *buf, size_t len)
>>   static struct md_sysfs_entry md_metadata =
>>   __ATTR_PREALLOC(metadata_version, S_IRUGO|S_IWUSR, metadata_show, metadata_store);
>>
>> +enum sync_action md_sync_action(struct mddev *mddev)
>> +{
>> +       unsigned long recovery = mddev->recovery;
>> +
>> +       /*
>> +        * frozen has the highest priority, means running sync_thread will be
>> +        * stopped immediately, and no new sync_thread can start.
>> +        */
>> +       if (test_bit(MD_RECOVERY_FROZEN, &recovery))
>> +               return ACTION_FROZEN;
>> +
>> +       /*
>> +        * idle means no sync_thread is running, and no new sync_thread is
>> +        * requested.
>> +        */
>> +       if (!test_bit(MD_RECOVERY_RUNNING, &recovery) &&
>> +           (!md_is_rdwr(mddev) || !test_bit(MD_RECOVERY_NEEDED, &recovery)))
>> +               return ACTION_IDLE;
> 
> Hi Kuai
> 
> Can I think the above judgement cover these two situations:
> 1. The array is readonly / readauto and it doesn't have
> MD_RECOVERY_RUNNING. Now maybe it has MD_RECOVERY_NEEDED, it means one
> array may want to do some sync action, but the array state is not
> readwrite and it can't start.
> 2. The array doesn't have MD_RECOVERY_RUNNING and MD_RECOVERY_NEEDED
> 
>> +
>> +       if (test_bit(MD_RECOVERY_RESHAPE, &recovery) ||
>> +           mddev->reshape_position != MaxSector)
>> +               return ACTION_RESHAPE;
>> +
>> +       if (test_bit(MD_RECOVERY_RECOVER, &recovery))
>> +               return ACTION_RECOVER;
>> +
>> +       if (test_bit(MD_RECOVERY_SYNC, &recovery)) {
>> +               if (test_bit(MD_RECOVERY_CHECK, &recovery))
>> +                       return ACTION_CHECK;
>> +               if (test_bit(MD_RECOVERY_REQUESTED, &recovery))
>> +                       return ACTION_REPAIR;
>> +               return ACTION_RESYNC;
>> +       }
>> +
>> +       return ACTION_IDLE;
> 
> Does it need this? I guess it's the reason in case there are other
> situations, right?

Yes, we need this, because they are many places to set
MD_RECOVERY_NEEDED, while there are no sync action actually, this case
is 'idle'.

Thanks,
Kuai

> 
> Regards
> Xiao
> 
>> +}
>> +
>> +enum sync_action md_sync_action_by_name(char *page)
>> +{
>> +       enum sync_action action;
>> +
>> +       for (action = 0; action < NR_SYNC_ACTIONS; ++action) {
>> +               if (cmd_match(page, action_name[action]))
>> +                       return action;
>> +       }
>> +
>> +       return NR_SYNC_ACTIONS;
>> +}
>> +
>> +char *md_sync_action_name(enum sync_action action)
>> +{
>> +       return action_name[action];
>> +}
>> +
>>   static ssize_t
>>   action_show(struct mddev *mddev, char *page)
>>   {
>> diff --git a/drivers/md/md.h b/drivers/md/md.h
>> index 2edad966f90a..72ca7a796df5 100644
>> --- a/drivers/md/md.h
>> +++ b/drivers/md/md.h
>> @@ -864,6 +864,9 @@ extern void md_unregister_thread(struct mddev *mddev, struct md_thread __rcu **t
>>   extern void md_wakeup_thread(struct md_thread __rcu *thread);
>>   extern void md_check_recovery(struct mddev *mddev);
>>   extern void md_reap_sync_thread(struct mddev *mddev);
>> +extern enum sync_action md_sync_action(struct mddev *mddev);
>> +extern enum sync_action md_sync_action_by_name(char *page);
>> +extern char *md_sync_action_name(enum sync_action action);
>>   extern bool md_write_start(struct mddev *mddev, struct bio *bi);
>>   extern void md_write_inc(struct mddev *mddev, struct bio *bi);
>>   extern void md_write_end(struct mddev *mddev);
>> --
>> 2.39.2
>>
> 
> .
> 

