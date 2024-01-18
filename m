Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE322560F
	for <dm-devel@lists.linux.dev>; Thu, 18 Jan 2024 13:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705584019; cv=none; b=sspCZQTrD36hvORIa8B4Aci7jVAsd4zDc/TRTNXHexLDXFzIUbcAX623lg/jW+7s1dSEO4RKsdjgxaWXarxGTa8mC5Hy7uZfHVITMDwyHJlkKmaDG6SuoSnb1Wj1HFQGD8PH0Ezr9biugLPKNfDo1G79ThzII+Viw15l4FpcQ7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705584019; c=relaxed/simple;
	bh=j7zaxoLraX+dhX4O0YdY7eYxFpraVHTFYYhOncGYyPw=;
	h=Received:Received:Received:Subject:To:Cc:References:From:
	 Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo; b=lEk3u69mcAos+wtSU/EUX3IFpqDA+6IhLx0X07vP5h+HgdPFFa4FdkauP2cJX6VNMa/AH7SI2p9LvwJd3SK6XlDi1wu20jr4RmZAIC1mVOcrZco4xrNFmsdZtbx3HD0u18RPX3u4xmyva7zahpucxE+AlrubJEHpsejbXC2cl6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4TG3JQ3v2yz4f3lfJ
	for <dm-devel@lists.linux.dev>; Thu, 18 Jan 2024 21:20:06 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id AB8591A016E
	for <dm-devel@lists.linux.dev>; Thu, 18 Jan 2024 21:20:12 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgAX6RGKJallo6TfBA--.46929S3;
	Thu, 18 Jan 2024 21:20:12 +0800 (CST)
Subject: Re: [PATCH 2/7] md: fix a race condition when stopping the sync
 thread
To: Mikulas Patocka <mpatocka@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: Song Liu <song@kernel.org>, David Jeffery <djeffery@redhat.com>,
 Li Nan <linan122@huawei.com>, dm-devel@lists.linux.dev,
 linux-raid@vger.kernel.org, Mike Snitzer <msnitzer@redhat.com>,
 Heinz Mauelshagen <heinzm@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>, "yukuai (C)" <yukuai3@huawei.com>
References: <e5e8afe2-e9a8-49a2-5ab0-958d4065c55e@redhat.com>
 <8fb335e-6d2c-dbb5-d7-ded8db5145a@redhat.com>
 <dcf29bba-4762-84ad-f60e-3607cf6779f9@huaweicloud.com>
 <66fda537-9d25-77e7-754f-2627e35fb8a4@redhat.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <4af9fe2b-7f5a-59d6-0b5e-762ecae1b007@huaweicloud.com>
Date: Thu, 18 Jan 2024 21:20:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <66fda537-9d25-77e7-754f-2627e35fb8a4@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgAX6RGKJallo6TfBA--.46929S3
X-Coremail-Antispam: 1UD129KBjvJXoW7CF1kJr1UZFy5tw1kKF1xZrb_yoW8WFyrp3
	y0ka4UKrWDZrsrurZ2va1jyFy8Ar17Xay7JryUCFy5A34UGa1SvFyayFy5AFWqkFs3Jw1q
	yr45ta95Zw4qkFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9F14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
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

在 2024/01/18 21:07, Mikulas Patocka 写道:
> 
> 
> On Thu, 18 Jan 2024, Yu Kuai wrote:
> 
>> Hi,
>>
>> 在 2024/01/18 2:18, Mikulas Patocka 写道:
>>> Note that md_wakeup_thread_directly is racy - it will do nothing if the
>>> thread is already running or it may cause spurious wake-up if the thread
>>> is blocked in another subsystem.
>>
>> No, as the comment said, md_wakeup_thread_directly() is just to prevent
>> that md_wakeup_thread() can't wake up md_do_sync() if it's waiting for
>> metadata update.
> 
> Yes - but what happens if you wake up the thread just a few instructions
> before it is going to sleep for metadata update? wake_up_process does
> nothing on a running process and the thread proceeds with waiting. This is
> what I thought could happen when I was making the patch.

Please notice that in the orginal code md_wakeup_thread_directly() is
used for sync_thread, and md_wakeup_thread() should be used for
*mddev->thread* (mddev_unlock always do that) to clear
MD_RECOVERY_RUNNING.

By the way, the root cause that MD_RECOVERY_RUNNING is not cleared is
that mddev_suspend() never stop sync_thread at all, while
md_check_recovery() won't do anything when mddev is suspended.

Before:
1. suspend
2. call md_reap_sync_thread() directly to unregister sync_thread
     -> notice that this is not safe.
3. resume

Now:
1. suspend
2. call stop_sync_thread() to unregister sync_thread interrupt
md_do_sync() and wait for md_check_recovery() to clear
MD_RECOVERY_RUNNING.
    -> which will never happen now;
3. resume

I fixed this locally and the test integrity-caching.sh passed in my VM.

Thanks,
Kuai
> 
> Mikulas
> 

