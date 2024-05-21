Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D1923B1
	for <dm-devel@lists.linux.dev>; Tue, 21 May 2024 02:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716258627; cv=none; b=qqVR67xWR4XLpbFIxDGNCOFmv+N8emOEotffw2MnvMWtMHXsX7XXT8AXo9xGpUQebONOTI8bpimZvkyErTLJD7Q2/Schr5JiKk0IOmKN2LSC9fwAKD7qEdTIze8QWqX6Db1mChE/BrMb3st0ZCrzPnJXLmACiZ1pWPG06hBJs7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716258627; c=relaxed/simple;
	bh=SQAXyf6L7XuEdCbgIa3EmActvAdEy2nEqSVCdmhz/Fk=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=QfQFC4E9A+tuEmHJucBsYJqlMtGZw1rySGQ0MjN/6i+rpsq/Gdy+7FNQDLpve21TL0Z4Sm95W9kKzf9fre4mwHl6byT3sk68S7EOWQmeGyzWwOE/gZbERhD4NFVRke8ybD0K8IuXFsq6qmzLVNE1HjIZCpY8OiBT3wN3H7WW+RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Vjz1J3VKQz4f3jdQ
	for <dm-devel@lists.linux.dev>; Tue, 21 May 2024 10:30:12 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 60A871A0D49
	for <dm-devel@lists.linux.dev>; Tue, 21 May 2024 10:30:21 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgBnOBE8B0xmVN31NA--.31652S3;
	Tue, 21 May 2024 10:30:21 +0800 (CST)
Subject: Re: [PATCH md-6.10 3/9] md: add new helpers for sync_action
To: Su Yue <l@damenly.org>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
 xni@redhat.com, dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20240509011900.2694291-1-yukuai1@huaweicloud.com>
 <20240509011900.2694291-4-yukuai1@huaweicloud.com> <v838ekaa.fsf@damenly.org>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <4c69570f-86d6-9b5d-883c-0ab54b2feb33@huaweicloud.com>
Date: Tue, 21 May 2024 10:30:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <v838ekaa.fsf@damenly.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgBnOBE8B0xmVN31NA--.31652S3
X-Coremail-Antispam: 1UD129KBjvJXoW3WFWrXw18XF17XF1Duw1DAwb_yoW7ZFW7pF
	4kAFW5urWUArn3Jr17tFyUJay5Ar1Iq34DAFyxWa48JFnrKrnYg3WUXF1q9F1DJr48Gr1U
	Zr1UXF9xuF43ArJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9214x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
	kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
	67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
	CI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWr
	Zr1UMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYx
	BIdaVFxhVjvjDU0xZFpf9x0JUZa9-UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/05/20 19:51, Su Yue 写道:
> 
> On Thu 09 May 2024 at 09:18, Yu Kuai <yukuai1@huaweicloud.com> wrote:
> 
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> The new helpers will get current sync_action of the array, will be used
>> in later patches to make code cleaner.
>>
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>> ---
>>  drivers/md/md.c | 64  +++++++++++++++++++++++++++++++++++++++++++++++++
>>  drivers/md/md.h |  3 +++
>>  2 files changed, 67 insertions(+)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 00bbafcd27bb..48ec35342d1b 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -69,6 +69,16 @@
>>  #include "md-bitmap.h"
>>  #include "md-cluster.h"
>>
>> +static char *action_name[NR_SYNC_ACTIONS] = {
>>
> 
> Th array will not be modified, so:
> 
> static const char * const action_names[NR_SYNC_ACTIONS]

Yes, this make sense.
> 
>> +    [ACTION_RESYNC]        = "resync",
>> +    [ACTION_RECOVER]    = "recover",
>> +    [ACTION_CHECK]        = "check",
>> +    [ACTION_REPAIR]        = "repair",
>> +    [ACTION_RESHAPE]    = "reshape",
>> +    [ACTION_FROZEN]        = "frozen",
>> +    [ACTION_IDLE]        = "idle",
>> +};
>> +
>>  /* pers_list is a list of registered personalities protected by 
>>  pers_lock. */
>>  static LIST_HEAD(pers_list);
>>  static DEFINE_SPINLOCK(pers_lock);
>> @@ -4867,6 +4877,60 @@ metadata_store(struct mddev *mddev, const char 
>> *buf, size_t len)
>>  static struct md_sysfs_entry md_metadata =
>>  __ATTR_PREALLOC(metadata_version, S_IRUGO|S_IWUSR,  metadata_show, 
>> metadata_store);
>>
>> +enum sync_action md_sync_action(struct mddev *mddev)
>> +{
>> +    unsigned long recovery = mddev->recovery;
>> +
>> +    /*
>> +     * frozen has the highest priority, means running sync_thread 
>> will be
>> +     * stopped immediately, and no new sync_thread can start.
>> +     */
>> +    if (test_bit(MD_RECOVERY_FROZEN, &recovery))
>> +        return ACTION_FROZEN;
>> +
>> +    /*
>> +     * idle means no sync_thread is running, and no new sync_thread is
>> +     * requested.
>> +     */
>> +    if (!test_bit(MD_RECOVERY_RUNNING, &recovery) &&
>> +        (!md_is_rdwr(mddev) || !test_bit(MD_RECOVERY_NEEDED, 
>> &recovery)))
>> +        return ACTION_IDLE;
> My brain was lost sometimes looking into nested conditions of md code...
> I agree with Xiao Ni's suggestion that more comments about the array
> state should be added.

Okay, perhaps you're refering md_is_rdwr()? which is supposed to be
related to "no new sync_thread is requestd", perhaps following is
better:

/* only read-write array can start sync_thread */
if (!(md_is_rdwr(mddev))
	return ACTION_IDLE;

/* sync_thread is not running, and no new sync_thread is requested */
if (!test_bit(MD_RECOVERY_RUNNING, &recovery) &&
     !test_bit(MD_RECOVERY_NEEDED, &recovery)
	return ACTION_IDLE;

> 
>> +    if (test_bit(MD_RECOVERY_RESHAPE, &recovery) ||
>> +        mddev->reshape_position != MaxSector)
>> +        return ACTION_RESHAPE;
>> +
>> +    if (test_bit(MD_RECOVERY_RECOVER, &recovery))
>> +        return ACTION_RECOVER;
>> +
>>
> In action_show, MD_RECOVERY_SYNC is tested first then MD_RECOVERY_RECOVER.
> After looking through the logic of MD_RECOVERY_RECOVER clear/set_bit, the
> change is fine to me. However, better to follow old pattern unless there
> have resons.

It's just because MD_RECOVERY_SYNC is more complicated, and I move it to
the last, just programming habits. :)
> 
> 
>> +    if (test_bit(MD_RECOVERY_SYNC, &recovery)) {
>> +        if (test_bit(MD_RECOVERY_CHECK, &recovery))
>> +            return ACTION_CHECK;
>> +        if (test_bit(MD_RECOVERY_REQUESTED, &recovery))
>> +            return ACTION_REPAIR;
>> +        return ACTION_RESYNC;
>> +    }
>> +
>> +    return ACTION_IDLE;
>> +}
>> +
>> +enum sync_action md_sync_action_by_name(char *page)
>> +{
>> +    enum sync_action action;
>> +
>> +    for (action = 0; action < NR_SYNC_ACTIONS; ++action) {
>> +        if (cmd_match(page, action_name[action]))
>> +            return action;
>> +    }
>> +
>> +    return NR_SYNC_ACTIONS;
>> +}
>> +
>> +char *md_sync_action_name(enum sync_action action)
>>
> 
> And 'const char *'

Yes

Thanks,
Kuai

> 
> -- 
> Su
> 
>> +{
>> +    return action_name[action];
>> +}
>> +
>>  static ssize_t
>>  action_show(struct mddev *mddev, char *page)
>>  {
>> diff --git a/drivers/md/md.h b/drivers/md/md.h
>> index 2edad966f90a..72ca7a796df5 100644
>> --- a/drivers/md/md.h
>> +++ b/drivers/md/md.h
>> @@ -864,6 +864,9 @@ extern void md_unregister_thread(struct mddev 
>> *mddev, struct md_thread __rcu **t
>>  extern void md_wakeup_thread(struct md_thread __rcu *thread);
>>  extern void md_check_recovery(struct mddev *mddev);
>>  extern void md_reap_sync_thread(struct mddev *mddev);
>> +extern enum sync_action md_sync_action(struct mddev *mddev);
>> +extern enum sync_action md_sync_action_by_name(char *page);
>> +extern char *md_sync_action_name(enum sync_action action);
>>  extern bool md_write_start(struct mddev *mddev, struct bio  *bi);
>>  extern void md_write_inc(struct mddev *mddev, struct bio *bi);
>>  extern void md_write_end(struct mddev *mddev);
> .
> 

