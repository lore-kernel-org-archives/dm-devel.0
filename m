Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5733125D21A
	for <dm-devel@lists.linux.dev>; Tue, 20 May 2025 06:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747722516; cv=none; b=fcpRgG3k/50+VhSxb4LJ96aKwqii3ZUNM1SJ9dIb7P8f0eDynA/u+gUYt9Q2+UBOOx717m83RlMRSPOMvY1ZxaE3uVwewBOUosU0zCrZBm/yLf2nWA7yEC1rApZqamJKQYXcIVIJo7zkyKoBAg7LjrarR73Ff6pTyIBiN5lko5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747722516; c=relaxed/simple;
	bh=as5enGz3kkhs/K+h50BACVAt45Ld6yIPa/WVerE4Wfs=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=ahz2+Hml5wi50+usHkqvllJxG2ly3UAymZhvBVsquYifGF4npjJZnPjCe+2RRqddyEE8LITB+XYxwreaVUsrAXpKNJS7uKPGiYr2Aujshz39wyu0X2lVAMJv2NYwd0G7E1l682gzjxFzyObG0mevYf2ezYDnzUrbP2pV/mS5rJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4b1l3m2ML3z4f3lCf
	for <dm-devel@lists.linux.dev>; Tue, 20 May 2025 14:28:04 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id C5E461A018D
	for <dm-devel@lists.linux.dev>; Tue, 20 May 2025 14:28:30 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgD3Wl8NISxoMY3OMw--.43989S3;
	Tue, 20 May 2025 14:28:30 +0800 (CST)
Subject: Re: [PATCH] md/raid1,raid10: don't pass down the REQ_RAHEAD flag
To: Yu Kuai <yukuai1@huaweicloud.com>, Mikulas Patocka <mpatocka@redhat.com>
Cc: Song Liu <song@kernel.org>, zkabelac@redhat.com,
 linux-raid@vger.kernel.org, dm-devel@lists.linux.dev,
 "yukuai (C)" <yukuai3@huawei.com>
References: <34fa755d-62c8-4588-8ee1-33cb1249bdf2@redhat.com>
 <98ac5772-9931-17fd-1fc4-18d2c737b079@huaweicloud.com>
 <04231d91-cf1f-a932-f24f-996f888f0dd7@redhat.com>
 <c561484d-f056-2531-8fd6-27be0dabca05@redhat.com>
 <10db5f49-0662-49da-9535-75aded725950@huaweicloud.com>
 <b560f87d-0072-91be-2a87-43f3510737d1@huaweicloud.com>
 <617a9d67-9671-f2aa-5188-0755b5b87972@redhat.com>
 <3298da41-c82a-b803-f38d-264defded2a2@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <82afea19-a346-a147-ec5c-7ef37fc83756@huaweicloud.com>
Date: Tue, 20 May 2025 14:28:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <3298da41-c82a-b803-f38d-264defded2a2@huaweicloud.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3Wl8NISxoMY3OMw--.43989S3
X-Coremail-Antispam: 1UD129KBjvJXoWxur1DCFy8XF4ruFyDAFyDAwb_yoW5Wr1Dpw
	srJF12gr4UJr9Fkayqyr42qr9Yy398GryrXr95J3y8G34qganxJ3ySqw4F9F1kWr1kKw4j
	vr4UGrW7XFn5tFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
	VjvjDU0xZFpf9x0JUBVbkUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/05/19 20:34, Yu Kuai 写道:
> Hi,
> 
> 在 2025/05/19 20:05, Mikulas Patocka 写道:
>>
>>
>> On Mon, 19 May 2025, Yu Kuai wrote:
>>
>>> Hi,
>>>
>>> 在 2025/05/19 19:19, Yu Kuai 写道:
>>>>> The commit e879a0d9cb08 ("md/raid1,raid10: don't ignore IO flags") 
>>>>> breaks
>>>>> the lvm2 test shell/lvcreate-large-raid.sh. The commit changes 
>>>>> raid1 and
>>>>> raid10 to pass down all the flags from the incoming bio. The 
>>>>> problem is
>>>>> when we pass down the REQ_RAHEAD flag - bios with this flag may fail
>>>>> anytime and md-raid is not prepared to handle this failure.
>>>>
>>>> Can dm-raid handle this falg? At least from md-raid array, for read
>>>> ahead IO, it doesn't make sense to kill that flag.
>>>>
>>>> If we want to fall back to old behavior, can we kill that flag from
>>>> dm-raid?
>>>
>>> Please ignore the last reply, I misunderstand your commit message, I
>>> thought you said dm-raid, actually you said mdraid, and it's correct,
>>> if read_bio faild raid1/10 will set badblocks which is not expected.
>>>
>>> Then for reada head IO, I still think don't kill REQ_RAHEAD for
>>> underlying disks is better, what do you think about skip handling IO
>>> error for ead ahead IO?
>>
>> I presume that md-raid will report an error and kick the disk out of the
>> array if a bio with REQ_RAHEAD fails - could this be the explanation of
>> this bug?
> 
> This is right if the rdev is set FailFast. However, by default if bio
> failed, raid1/raid10 will record badblocks first, and retry the read
> untill all underlying disks faild, then read_balance() will finally
> found there is no avaliable disk to read and return error.
> 
> BTW, I still need to figure out how to run this test to see what really
> happened.

I can run the test now, and I confirmed that the dm-raid is build on the
top of dm-zero, and for dm-zero, all read ahead bio will return -EIO.
And failfast is set, causing test to fail:

[ 0:54.960] [135.521104] <2> 2025-05-20 06:20:23  md/raid1:mdX: Disk 
failure on dm-6, disabling device.\x0amd/raid1:mdX: Operation continuing 
on 1 devices.
[ 0:54.960] #lvcreate-large-raid.sh:77+ check lv_field 
LVMTEST1119vg1/LV1 size 400.00t
[ 0:55.012] File descriptor 6 (/dev/pts/0) leaked on lvm invocation. 
Parent PID 1670: bash
[ 0:55.278] WARNING: RaidLV LVMTEST1119vg1/LV1 needs to be refreshed! 
See character 'r' at position 9 in the RaidLV's attributes and also its 
SubLV(s) with option '-a'.
[ 0:55.307] check raid_leg_status $vg1 $lv1 "AA"
[ 0:55.474] #lvcreate-large-raid.sh:78+ check raid_leg_status 
LVMTEST1119vg1 LV1 AA
[ 0:55.474] LVMTEST1119vg1-LV1 status DA != AA  (0 858993459200 raid 
raid1 2 DA 429496729600/429496729600 idle 0 0 -)
[ 0:55.534] set +vx; STACKTRACE; set -vx

Thanks,
Kuai

> 
> Thanks,
> Kuai
> 
>>
>> Mikulas
>>
> 
> .
> 

