Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F4D47F7A
	for <dm-devel@lists.linux.dev>; Tue, 11 Jun 2024 13:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718112617; cv=none; b=P78nhx8BHmPdiGQt4VX/PztLaS9lUpA7hatmqaG9MomBQzKPr+6NhEKlPJ+MFETi/y1fe5ha3635Z3vpVUI9vqiehRsARNRyZ0qnoOcLl8j9SQi0UBrjr0hLHjCwWFXtty+HLmdLFQtWyqZx8uneYJ9t0w1TmgWfmzanCdJ21dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718112617; c=relaxed/simple;
	bh=H20fbMfgohGyo4yey5vALGzeXJ8MBMbZ1q9Hn9FTCfw=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=iW1+uyskNIdhnz3/AD25R+MOj2pTRIZAhZ/ZcLYow5kuAdPrDOxM7jxA91oidtNFN65RhVnqYHyqfPsLwlnz0oHimB4QsHRvI9SiOROfAlJ2AyiQrRx1KWPr42Wyfz4UMmoVlXhrAPqq+f4Y81aE6WIs3YOuTOUWDwcnBT+0yXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Vz8fw6rncz4f3mJ4
	for <dm-devel@lists.linux.dev>; Tue, 11 Jun 2024 21:30:00 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 5FE731A0568
	for <dm-devel@lists.linux.dev>; Tue, 11 Jun 2024 21:30:12 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgAn9g5iUWhmdMbEPA--.26115S3;
	Tue, 11 Jun 2024 21:30:12 +0800 (CST)
Subject: Re: [PATCH 02/12] md: add a new enum type sync_action
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
 xni@redhat.com, l@damenly.org, dm-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 yukuai1@huaweicloud.com, yi.zhang@huawei.com, yangerkun@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20240603125815.2199072-1-yukuai3@huawei.com>
 <20240603125815.2199072-3-yukuai3@huawei.com>
 <20240611103126.00003ee0@linux.intel.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <4e8fcdc7-3494-df1d-8654-28ce248850df@huaweicloud.com>
Date: Tue, 11 Jun 2024 21:30:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240611103126.00003ee0@linux.intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgAn9g5iUWhmdMbEPA--.26115S3
X-Coremail-Antispam: 1UD129KBjvJXoWxAF43XFWkuFW7Xr48KFWxZwb_yoW5CFWfpF
	W8Ga4rJr4DArn7Aw1Sq34fJ393u340qrWUGry3Kw18Ar9Ik3Z3CFWrC34DCayktrn8Kw1j
	qFWUtFn8uFZ0vrDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9S14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
	kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
	67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5Jw
	CI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Wr1j
	6rW3Jr1lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr
	1UYxBIdaVFxhVjvjDU0xZFpf9x0JUdHUDUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2024/06/11 16:31, Mariusz Tkaczyk Ð´µÀ:
> On Mon, 3 Jun 2024 20:58:05 +0800
> Yu Kuai <yukuai3@huawei.com> wrote:
> 
>> In order to make code related to sync_thread cleaner in following
>> patches, also add detail comment about each sync action. And also
>> prepare to remove the related recovery_flags in the fulture.
>>
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>> ---
>>   drivers/md/md.h | 57 ++++++++++++++++++++++++++++++++++++++++++++++++-
>>   1 file changed, 56 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/md/md.h b/drivers/md/md.h
>> index 170412a65b63..6b9d9246f260 100644
>> --- a/drivers/md/md.h
>> +++ b/drivers/md/md.h
>> @@ -34,6 +34,61 @@
>>    */
>>   #define	MD_FAILFAST	(REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT)
>>   
>> +/* Status of sync thread. */
>> +enum sync_action {
>> +	/*
>> +	 * Represent by MD_RECOVERY_SYNC, start when:
>> +	 * 1) after assemble, sync data from first rdev to other copies, this
>> +	 * must be done first before other sync actions and will only execute
>> +	 * once;
>> +	 * 2) resize the array(notice that this is not reshape), sync data
>> for
>> +	 * the new range;
>> +	 */
>> +	ACTION_RESYNC,
>> +	/*
>> +	 * Represent by MD_RECOVERY_RECOVER, start when:
>> +	 * 1) for new replacement, sync data based on the replace rdev or
>> +	 * available copies from other rdev;
>> +	 * 2) for new member disk while the array is degraded, sync data from
>> +	 * other rdev;
>> +	 * 3) reassemble after power failure or re-add a hot removed rdev,
>> sync
>> +	 * data from first rdev to other copies based on bitmap;
>> +	 */
>> +	ACTION_RECOVER,
>> +	/*
>> +	 * Represent by MD_RECOVERY_SYNC | MD_RECOVERY_REQUESTED |
>> +	 * MD_RECOVERY_CHECK, start when user echo "check" to sysfs api
>> +	 * sync_action, used to check if data copies from differenct rdev are
>> +	 * the same. The number of mismatch sectors will be exported to user
>> +	 * by sysfs api mismatch_cnt;
>> +	 */
>> +	ACTION_CHECK,
>> +	/*
>> +	 * Represent by MD_RECOVERY_SYNC | MD_RECOVERY_REQUESTED, start when
>> +	 * user echo "repair" to sysfs api sync_action, usually paired with
>> +	 * ACTION_CHECK, used to force syncing data once user found that
>> there
>> +	 * are inconsistent data,
>> +	 */
>> +	ACTION_REPAIR,
>> +	/*
>> +	 * Represent by MD_RECOVERY_RESHAPE, start when new member disk is
>> added
>> +	 * to the conf, notice that this is different from spares or
>> +	 * replacement;
>> +	 */
>> +	ACTION_RESHAPE,
>> +	/*
>> +	 * Represent by MD_RECOVERY_FROZEN, can be set by sysfs api
>> sync_action
>> +	 * or internal usage like setting the array read-only, will forbid
>> above
>> +	 * actions.
>> +	 */
>> +	ACTION_FROZEN,
>> +	/*
>> +	 * All above actions don't match.
>> +	 */
>> +	ACTION_IDLE,
>> +	NR_SYNC_ACTIONS,
>> +};
> 
> I like if counter is keep in same style as rest enum values, like ACTION_COUNT.

Thanks for the review, however, I didn't find this style "xxx_COUNT" in
md code, AFAIK, "NR_xxx" style is used more, for example:

enum stat_group {
         STAT_READ,
         STAT_WRITE,
         STAT_DISCARD,
         STAT_FLUSH,

         NR_STAT_GROUPS
};

Just to let you know, I'll keep this style in the next version. :)

Thanks,
Kuai
> 
> Anyway LGTM.
> 
> Mariusz
> .
> 

