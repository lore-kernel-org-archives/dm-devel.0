Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5FE1862A
	for <dm-devel@lists.linux.dev>; Tue, 14 May 2024 06:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715667037; cv=none; b=ad9/gOHcyuppdMisWJVyNZrITKq+zQWfCI0ySI/bLfnI68L0D6Guy5HqB2ANE5QVsk+VNhUEZeeU7SquJyMEb4yhFlNe4MhsXWqX4PIe1h5KrW9vfWLtoLg25pmqWl7rjJsbQI82xNOdjBWEbxSa9IBZC5/IYc0A8o5JYwEmG9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715667037; c=relaxed/simple;
	bh=POgx0G3yJuUrfQT1wjeXgb2RlNIUmIDzVrU35Dl0hBI=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=YxGL1DhC7wsNZdoDx14O03OObzTO4XKRppSAyxBXwQL97nn04gK5+6wlmO7YBuglkIuAEdOfnushrBfMD84un840+/jewl2xfLuG3GUg+kmOSJpd5K16+WKI7yd+KqLnnkw/igUE8WoOZcvVu+8Y+AXqXIHweaP2yRzumv8HHs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4VdmDZ60HHz4f3jdP
	for <dm-devel@lists.linux.dev>; Tue, 14 May 2024 14:10:22 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 6F8F01A017F
	for <dm-devel@lists.linux.dev>; Tue, 14 May 2024 14:10:31 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgAX5g5VAENmchh5Mg--.22041S3;
	Tue, 14 May 2024 14:10:31 +0800 (CST)
Subject: Re: [PATCH md-6.10 1/9] md: rearrange recovery_flage
To: Xiao Ni <xni@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
 dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20240509011900.2694291-1-yukuai1@huaweicloud.com>
 <20240509011900.2694291-2-yukuai1@huaweicloud.com>
 <CALTww2_2UG49wxNZv1Ay7u9X-2SoV31ca-=2K8uWHH9nRT2Apw@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <e71bec08-036b-9dc1-ca12-a187b2aff528@huaweicloud.com>
Date: Tue, 14 May 2024 14:10:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CALTww2_2UG49wxNZv1Ay7u9X-2SoV31ca-=2K8uWHH9nRT2Apw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgAX5g5VAENmchh5Mg--.22041S3
X-Coremail-Antispam: 1UD129KBjvJXoWxJF4fuF4kKFW7WrWkGF4rKrg_yoWrAw4rpF
	W8C3Z5Zr47Ary7ZrW7tas8X39Yy340yry5AF43W3s5JF9Yy3Z3Ar1UXw1DJFWkt3s3t3W7
	XFn8JF13uF4Yk3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

在 2024/05/14 13:51, Xiao Ni 写道:
> On Mon, May 13, 2024 at 9:57 AM Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> Currently there are lots of flags and the names are confusing, since
>> there are two main types of flags, sync thread runnng status and sync
>> thread action, rearrange and update comment to improve code readability,
>> there are no functional changes.
>>
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>> ---
>>   drivers/md/md.h | 52 ++++++++++++++++++++++++++++++++++++-------------
>>   1 file changed, 38 insertions(+), 14 deletions(-)
>>
>> diff --git a/drivers/md/md.h b/drivers/md/md.h
>> index 029dd0491a36..2a1cb7b889e5 100644
>> --- a/drivers/md/md.h
>> +++ b/drivers/md/md.h
>> @@ -551,22 +551,46 @@ struct mddev {
>>   };
>>
>>   enum recovery_flags {
>> +       /* flags for sync thread running status */
>> +
>> +       /*
>> +        * set when one of sync action is set and new sync thread need to be
>> +        * registered, or just add/remove spares from conf.
>> +        */
>> +       MD_RECOVERY_NEEDED,
>> +       /* sync thread is running, or about to be started */
>> +       MD_RECOVERY_RUNNING,
>> +       /* sync thread needs to be aborted for some reason */
>> +       MD_RECOVERY_INTR,
>> +       /* sync thread is done and is waiting to be unregistered */
>> +       MD_RECOVERY_DONE,
>> +       /* running sync thread must abort immediately, and not restart */
>> +       MD_RECOVERY_FROZEN,
>> +       /* waiting for pers->start() to finish */
>> +       MD_RECOVERY_WAIT,
>> +       /* interrupted because io-error */
>> +       MD_RECOVERY_ERROR,
>> +
>> +       /* flags determines sync action */
>> +
>> +       /* if just this flag is set, action is resync. */
>> +       MD_RECOVERY_SYNC,
>> +       /*
>> +        * paired with MD_RECOVERY_SYNC, if MD_RECOVERY_CHECK is not set,
>> +        * action is repair, means user requested resync.
>> +        */
>> +       MD_RECOVERY_REQUESTED,
>>          /*
>> -        * If neither SYNC or RESHAPE are set, then it is a recovery.
>> +        * paired with MD_RECOVERY_SYNC and MD_RECOVERY_REQUESTED, action is
>> +        * check.
> 
> Hi Kuai
> 
> I did a test as follows:
> 
> echo check > /sys/block/md0/md/sync_action
> I added some logs in md_do_sync to check these bits. It only prints
> MD_RECOVERY_SYNC and MD_RECOVERY_CHECK without MD_RECOVERY_SYNC. So
> the comment is not right?

There is a typo, I'm not sure what you mean yet. Can you show how you
add your logs? I think comment is right.

 From action_store:

                 if (cmd_match(page, "check"))
                         set_bit(MD_RECOVERY_CHECK, &mddev->recovery);
                 else if (!cmd_match(page, "repair"))
                         return -EINVAL;
                 clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
                 set_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
                 set_bit(MD_RECOVERY_SYNC, &mddev->recovery);

 From md_do_sync:

         if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
                 if (test_bit(MD_RECOVERY_CHECK, &mddev->recovery)) {
                         desc = "data-check";
                         action = "check";
                 } else if (test_bit(MD_RECOVERY_REQUESTED, 
&mddev->recovery)) {
                         desc = "requested-resync";
                         action = "repair";
                 } else
                         desc = "resync";

Thanks,
Kuai

> 
> Best Regards
> Xiao
> 
>>           */
>> -       MD_RECOVERY_RUNNING,    /* a thread is running, or about to be started */
>> -       MD_RECOVERY_SYNC,       /* actually doing a resync, not a recovery */
>> -       MD_RECOVERY_RECOVER,    /* doing recovery, or need to try it. */
>> -       MD_RECOVERY_INTR,       /* resync needs to be aborted for some reason */
>> -       MD_RECOVERY_DONE,       /* thread is done and is waiting to be reaped */
>> -       MD_RECOVERY_NEEDED,     /* we might need to start a resync/recover */
>> -       MD_RECOVERY_REQUESTED,  /* user-space has requested a sync (used with SYNC) */
>> -       MD_RECOVERY_CHECK,      /* user-space request for check-only, no repair */
>> -       MD_RECOVERY_RESHAPE,    /* A reshape is happening */
>> -       MD_RECOVERY_FROZEN,     /* User request to abort, and not restart, any action */
>> -       MD_RECOVERY_ERROR,      /* sync-action interrupted because io-error */
>> -       MD_RECOVERY_WAIT,       /* waiting for pers->start() to finish */
>> -       MD_RESYNCING_REMOTE,    /* remote node is running resync thread */
>> +       MD_RECOVERY_CHECK,
>> +       /* recovery, or need to try it */
>> +       MD_RECOVERY_RECOVER,
>> +       /* reshape */
>> +       MD_RECOVERY_RESHAPE,
>> +       /* remote node is running resync thread */
>> +       MD_RESYNCING_REMOTE,
>>   };
>>
>>   enum md_ro_state {
>> --
>> 2.39.2
>>
> 
> 
> .
> 

