Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC6F135A40
	for <dm-devel@lists.linux.dev>; Wed,  6 Mar 2024 15:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709737852; cv=none; b=D4+9fslbK1Zr9GnxC+TgPKE2lF9EdYjG8NQikl2U+SkjF3rZydfI579wjZWZDcJfCXYxDkAbCES9YobxWttJTBZd5feSi43V3SCbs/7fJ4C4FHR2yvajKOFIZjGNMZfvggq9EahyAmf5CuyN6ffnsVWUUU4tzgaALM7uXG9T2dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709737852; c=relaxed/simple;
	bh=JYpMEoOzZQs3yAFQY3yegUBgCw5BXctmdMIzmY4XVNU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mzXfeadWaenrcYxZ1MFx3ZwKhBGF665Rr4Ai+3eHBrv9X2w0ddvLHm5epvVVaik9dgoSgTTKOMya2/PqK1MMg+5kf5ii2ChbIns0qYMo1Px+iPMGpDt4VRfEPYgiCTy16qpgnvUJEVLBiqOliX8XJgsUxORkDftUewx/nJy5uB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [192.168.0.224] (ip5f5aedd4.dynamic.kabel-deutschland.de [95.90.237.212])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 96BB861E5FE01;
	Wed,  6 Mar 2024 16:10:05 +0100 (CET)
Message-ID: <f9d3cad9-6d7d-4aa1-9592-79300812dce4@molgen.mpg.de>
Date: Wed, 6 Mar 2024 16:10:04 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH md-6.8 v2 2/9] md: export helpers to stop sync_thread
Content-Language: en-US
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: xni@redhat.com, zkabelac@redhat.com, agk@redhat.com, snitzer@kernel.org,
 mpatocka@redhat.com, dm-devel@lists.linux.dev, song@kernel.org,
 heinzm@redhat.com, jbrassow@redhat.com, neilb@suse.de,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 yi.zhang@huawei.com, yangerkun@huawei.com, yukuai3@huawei.com
References: <20240305072306.2562024-1-yukuai1@huaweicloud.com>
 <20240305072306.2562024-3-yukuai1@huaweicloud.com>
 <c0e648ea-d73e-4805-a2bb-b02ddd3ca4e2@molgen.mpg.de>
 <9950cb96-ac8b-d7dd-56a0-133709f51b5f@huaweicloud.com>
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <9950cb96-ac8b-d7dd-56a0-133709f51b5f@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Kuai,


Am 05.03.24 um 09:13 schrieb Yu Kuai:

> 在 2024/03/05 16:08, Paul Menzel 写道:

>> Am 05.03.24 um 08:22 schrieb Yu Kuai:
>>> From: Yu Kuai <yukuai3@huawei.com>
>>>
>>> The new heleprs will be used in dm-raid in later patches to fix
>>
>> hel*pe*rs
>>
>>> regressions and prevent calling md_reap_sync_thread() directly.
>>
>> Please list the new functions.
>>
>> 1.  md_idle_sync_thread(struct mddev *mddev);
>> 2.  md_frozen_sync_thread(struct mddev *mddev);
>> 3.  md_unfrozen_sync_thread(struct mddev *mddev);
>>
>> I do not like the naming so much. `md_reap_sync_thread()` has the verb 
>> in imperative mood. At least myself, I would not know what the 
>> functions do exactly without looking at the implementation.
>
> Thanks for the suggestions, I'm not that good at naming :(
> 
> Usually I'll send a new version with updated naming, however, we must
> merge this set ASAP now, perhaps can we live with this for now?

Fine by me. Maybe when applying the typo can be fixed, and the naming 
than later.


Kind regards,

Paul


>>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>>> Signed-off-by: Xiao Ni <xni@redhat.com>
>>> Acked-by: Mike Snitzer <snitzer@kernel.org>
>>> ---
>>>   drivers/md/md.c | 29 +++++++++++++++++++++++++++++
>>>   drivers/md/md.h |  3 +++
>>>   2 files changed, 32 insertions(+)
>>>
>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>>> index 23f31fd1d024..22e7512a5b1e 100644
>>> --- a/drivers/md/md.c
>>> +++ b/drivers/md/md.c
>>> @@ -4919,6 +4919,35 @@ static void stop_sync_thread(struct mddev 
>>> *mddev, bool locked, bool check_seq)
>>>           mddev_lock_nointr(mddev);
>>>   }
>>> +void md_idle_sync_thread(struct mddev *mddev)
>>> +{
>>> +    lockdep_assert_held(&mddev->reconfig_mutex);
>>> +
>>> +    clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
>>> +    stop_sync_thread(mddev, true, true);
>>> +}
>>> +EXPORT_SYMBOL_GPL(md_idle_sync_thread);
>>> +
>>> +void md_frozen_sync_thread(struct mddev *mddev)
>>> +{
>>> +    lockdep_assert_held(&mddev->reconfig_mutex);
>>> +
>>> +    set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
>>> +    stop_sync_thread(mddev, true, false);
>>> +}
>>> +EXPORT_SYMBOL_GPL(md_frozen_sync_thread);
>>> +
>>> +void md_unfrozen_sync_thread(struct mddev *mddev)
>>> +{
>>> +    lockdep_assert_held(&mddev->reconfig_mutex);
>>> +
>>> +    clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
>>> +    set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>>> +    md_wakeup_thread(mddev->thread);
>>> +    sysfs_notify_dirent_safe(mddev->sysfs_action);
>>> +}
>>> +EXPORT_SYMBOL_GPL(md_unfrozen_sync_thread);
>>> +
>>>   static void idle_sync_thread(struct mddev *mddev)
>>>   {
>>>       mutex_lock(&mddev->sync_mutex);
>>> diff --git a/drivers/md/md.h b/drivers/md/md.h
>>> index 8d881cc59799..437ab70ce79b 100644
>>> --- a/drivers/md/md.h
>>> +++ b/drivers/md/md.h
>>> @@ -781,6 +781,9 @@ extern void md_rdev_clear(struct md_rdev *rdev);
>>>   extern void md_handle_request(struct mddev *mddev, struct bio *bio);
>>>   extern int mddev_suspend(struct mddev *mddev, bool interruptible);
>>>   extern void mddev_resume(struct mddev *mddev);
>>> +extern void md_idle_sync_thread(struct mddev *mddev);
>>> +extern void md_frozen_sync_thread(struct mddev *mddev);
>>> +extern void md_unfrozen_sync_thread(struct mddev *mddev);
>>>   extern void md_reload_sb(struct mddev *mddev, int raid_disk);
>>>   extern void md_update_sb(struct mddev *mddev, int force);
