Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C768A7E1
	for <dm-devel@lists.linux.dev>; Mon, 19 May 2025 12:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747658065; cv=none; b=oh+M4iec1d86zZLP8Lh13F06G+9UBskL3e3yaR0VqCpkV+otZqSJABK9nNCBnaefPZVmwhnxXAscgp/evl4TBqL0JkODIJcqORO/I5hbsfvxSOYtLftAc4BX4pv52k55oYhzI6O2MiHVBNI7P9JRgbb2r1lsvry38ePduWsTRg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747658065; c=relaxed/simple;
	bh=KQQKp69JHvvXB3hLcTxxKr3F0kDjIO365FK4eLm5ea8=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=r4Iru3qhk+0AkfAvFPaSrEFwj6le1dUVpMyIXzEVmFiKPZRPylwm4ejI4DaNnEpilNEe6qDXg3pquzB5AFf5zfBnWCb8WgCAnW4Hq6Qy82mbBJoKt/tpIoYrZ6hTy+sZXAjtq4khq+i+PoRNj3h5/oHL5MQrACxAX0n3+/jSB6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4b1HDt5jbVzKHLvX
	for <dm-devel@lists.linux.dev>; Mon, 19 May 2025 20:34:22 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 5B0BA1A07BB
	for <dm-devel@lists.linux.dev>; Mon, 19 May 2025 20:34:21 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgD3Wl9LJStooruDMw--.31954S3;
	Mon, 19 May 2025 20:34:21 +0800 (CST)
Subject: Re: [PATCH] md/raid1,raid10: don't pass down the REQ_RAHEAD flag
To: Mikulas Patocka <mpatocka@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>
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
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <3298da41-c82a-b803-f38d-264defded2a2@huaweicloud.com>
Date: Mon, 19 May 2025 20:34:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <617a9d67-9671-f2aa-5188-0755b5b87972@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3Wl9LJStooruDMw--.31954S3
X-Coremail-Antispam: 1UD129KBjvJXoW7KrW7JF17ZrWDGFW5Xw1UWrg_yoW8WF4kpw
	17W3Za9r4kAr92kwnIvw42qa4vk3y5Ga1UAryrCrW0kw1jgFZ3A3yIqa1F9r98Kw1vkw1j
	vr4UW3yDWFn5tFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

在 2025/05/19 20:05, Mikulas Patocka 写道:
> 
> 
> On Mon, 19 May 2025, Yu Kuai wrote:
> 
>> Hi,
>>
>> 在 2025/05/19 19:19, Yu Kuai 写道:
>>>> The commit e879a0d9cb08 ("md/raid1,raid10: don't ignore IO flags") breaks
>>>> the lvm2 test shell/lvcreate-large-raid.sh. The commit changes raid1 and
>>>> raid10 to pass down all the flags from the incoming bio. The problem is
>>>> when we pass down the REQ_RAHEAD flag - bios with this flag may fail
>>>> anytime and md-raid is not prepared to handle this failure.
>>>
>>> Can dm-raid handle this falg? At least from md-raid array, for read
>>> ahead IO, it doesn't make sense to kill that flag.
>>>
>>> If we want to fall back to old behavior, can we kill that flag from
>>> dm-raid?
>>
>> Please ignore the last reply, I misunderstand your commit message, I
>> thought you said dm-raid, actually you said mdraid, and it's correct,
>> if read_bio faild raid1/10 will set badblocks which is not expected.
>>
>> Then for reada head IO, I still think don't kill REQ_RAHEAD for
>> underlying disks is better, what do you think about skip handling IO
>> error for ead ahead IO?
> 
> I presume that md-raid will report an error and kick the disk out of the
> array if a bio with REQ_RAHEAD fails - could this be the explanation of
> this bug?

This is right if the rdev is set FailFast. However, by default if bio
failed, raid1/raid10 will record badblocks first, and retry the read
untill all underlying disks faild, then read_balance() will finally
found there is no avaliable disk to read and return error.

BTW, I still need to figure out how to run this test to see what really
happened.

Thanks,
Kuai

> 
> Mikulas
> 

