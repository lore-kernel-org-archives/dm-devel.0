Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B54E612E
	for <dm-devel@lists.linux.dev>; Thu, 18 Jan 2024 02:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705544619; cv=none; b=OjySOQ7LfVcN3ne51f0LV3JIGhYod7wYx+rQfGUPEqqI/TsvNmF6nVJMfyr5xpf1eghzzZuA0Ft9Pi1yPUN+VVz1IqDyQUOcjHyXmU+kQUMTzEeB32KpZngDldgnBm7s9VkN02JF6ql+0qmhhrLW7KiEDVVv6qeB6ZYptumRtyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705544619; c=relaxed/simple;
	bh=5F6HIsjedr0HZn/DS1rVNOHdbnQcau5vNyZZxuVk6ao=;
	h=Received:Received:Received:Subject:To:Cc:References:From:
	 Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo; b=Ccg6A/L8Dlm8stPDAIriRFMMw1+p39+WO6PNBtTQ6Or+mke5zHONDCL8rQc0Je5hGdb0GQF6JUeG+0c9wYzWZ6/2el0gVGZYlPBDwNUhIzQifkcLOO1NOud6IfHD7H+bQOPguTeI09QmEcRHeMgrelxEyAjlxDoNg8kDa5dWrLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4TFmJG6zhjz4f3kpH
	for <dm-devel@lists.linux.dev>; Thu, 18 Jan 2024 10:03:58 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 27A871A0171
	for <dm-devel@lists.linux.dev>; Thu, 18 Jan 2024 10:04:01 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgBHZQ4Ph6hlxn2uBA--.43049S3;
	Thu, 18 Jan 2024 10:04:01 +0800 (CST)
Subject: Re: [PATCH 0/7] MD fixes for the LVM2 testsuite
To: Song Liu <song@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>
Cc: David Jeffery <djeffery@redhat.com>, Li Nan <linan122@huawei.com>,
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
 Mike Snitzer <msnitzer@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>, "yukuai (C)" <yukuai3@huawei.com>
References: <e5e8afe2-e9a8-49a2-5ab0-958d4065c55e@redhat.com>
 <CAPhsuW40f2SQqzcRkCxu-9=or=3HNiDBHirHO4F=BjAn_ufZgg@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <7088e329-b857-7654-294c-3f43930f8f10@huaweicloud.com>
Date: Thu, 18 Jan 2024 10:03:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CAPhsuW40f2SQqzcRkCxu-9=or=3HNiDBHirHO4F=BjAn_ufZgg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgBHZQ4Ph6hlxn2uBA--.43049S3
X-Coremail-Antispam: 1UD129KBjvdXoWrZrW8uFyDur4kXw17uryxuFg_yoWkZFbE9F
	yqvr97GwsrAw4UXan0qw42qr47KFZrZryDWrWUtrn8Ga43XFWDJrZrGrZ3ZrZxGa98KF9I
	gFZ7ArW8Awn8ZjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbIkYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7I2V7IY0VAS
	07AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c
	02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_
	GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7
	CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE
	14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf
	9x07UGYL9UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/01/18 3:27, Song Liu 写道:
> Hi Mikulas,
> 
> On Wed, Jan 17, 2024 at 10:17 AM Mikulas Patocka <mpatocka@redhat.com> wrote:
>>
>> Hi
>>
>> Here I'm sending MD patches that fix the LVM2 testsuite for the kernels
>> 6.7 and 6.8. The testsuite was broken in the 6.6 -> 6.7 window, there are
>> multiple tests that deadlock.
>>
>> I fixed some of the bugs. And I reverted some patches that claim to be
>> fixing bugs but they break the testsuite.
>>
>> I'd like to ask you - please, next time when you are going to commit
>> something into the MD subsystem, download the LVM2 package from
>> git://sourceware.org/git/lvm2.git and run the testsuite ("./configure &&
>> make && make check") to make sure that your bugfix doesn't introduce
>> another bug. You can run a specific test with the "T" parameter - for
>> example "make check T=shell/integrity-caching.sh"
> 
> Thanks for the report and fixes!
> 
> We will look into the fixes and process them ASAP.
> 
> We will also add the lvm2 testsuite to the test framework.

Yes, we absolutely must make sure that dm-raid is not broken...

I'll try to run lvm2 testsuite and figure out the root cause.

Thanks,
Kuai

> 
> Song
> .
> 

