Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A20E576
	for <dm-devel@lists.linux.dev>; Wed, 31 Jan 2024 02:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706669557; cv=none; b=tjhO5DQe5bsRnFogW2mf89g6VOlT7hbHTJ5HGdwywibpj8xI/2DdD9lfDBKbW2LO0KjPvIJQCmyGFFRM93bhLnFyswjEEB3JziMcQdo44P2uhDIhRiigrgP9ZUaS4igQWjRynQB4hPeEd9K0hZjLaKoxD/9LlAA2jSxstq4CCPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706669557; c=relaxed/simple;
	bh=G8vf01ryD6a0sFWIZwyaErB6QWgsZf7rD0S21t/VHH8=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=PsdPJo3tGoN8nM6h+/TthGTLbweQtR3iYmLm6Eby8IphaCts7Sqg3QlNUvduhjq27lw0E+HzpgfmrDWOcomy/8Y4w3qO8+qOKmung7cCjAz34/GJUf5ueYY+dN/NOp98xcecT5jCyyB03SRO3iBjLb9/RyJ0o5wNlTKN2shaOAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4TPmmD4V2Sz4f3jXP
	for <dm-devel@lists.linux.dev>; Wed, 31 Jan 2024 10:52:28 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id C30D21A0172
	for <dm-devel@lists.linux.dev>; Wed, 31 Jan 2024 10:52:32 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgAn+RHvtbllc7kHCg--.37975S3;
	Wed, 31 Jan 2024 10:52:32 +0800 (CST)
Subject: Re: [PATCH v4 00/14] dm-raid: fix v6.7 regressions
To: Xiao Ni <xni@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: mpatocka@redhat.com, heinzm@redhat.com, agk@redhat.com,
 snitzer@kernel.org, dm-devel@lists.linux.dev, song@kernel.org,
 jbrassow@f14.redhat.com, neilb@suse.de, shli@fb.com, akpm@osdl.org,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 yi.zhang@huawei.com, yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20240130021843.3608859-1-yukuai1@huaweicloud.com>
 <CALTww29QO5kzmN6Vd+jT=-8W5F52tJjHKSgrfUc1Z1ZAeRKHHA@mail.gmail.com>
 <78016a94-737a-af4d-446b-c9fbef967895@huaweicloud.com>
 <CALTww29UKCJcvJB2BvGTbCcpvD4Y-J+Bg1WgE0nOijLNMv=RGg@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <6f8ca5f8-c958-8769-1433-a19c4067b074@huaweicloud.com>
Date: Wed, 31 Jan 2024 10:52:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CALTww29UKCJcvJB2BvGTbCcpvD4Y-J+Bg1WgE0nOijLNMv=RGg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgAn+RHvtbllc7kHCg--.37975S3
X-Coremail-Antispam: 1UD129KBjvdXoWrZF1Dtw45GFyUAw1kCrW3Jrb_yoW3CFc_ua
	4jvF4Durs2yr1vka1qqr4YvrsrtF4rJr42k3y8JrWUW34jqFWUG3WDGr4SyrnrAw4SkFna
	gryjqry5Jr4FkjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb3xFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kI
	c2xKxwCYjI0SjxkI62AI1cAE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4
	AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE
	17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMI
	IF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Gr0_Zr1l
	IxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvf
	C2KfnxnUUI43ZEXa7VUbCPfPUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/01/31 9:28, Xiao Ni 写道:
> On Wed, Jan 31, 2024 at 9:25 AM Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>
>> Hi, Xiao Ni!
>>
>> 在 2024/01/31 8:29, Xiao Ni 写道:
>>> In my environment, the lvm2 regression test has passed. There are only
>>> three failed cases which also fail in kernel 6.6.
>>>
>>> ###       failed: [ndev-vanilla] shell/lvresize-fs-crypt.sh
>>> ###       failed: [ndev-vanilla] shell/pvck-dump.sh
>>> ###       failed: [ndev-vanilla] shell/select-report.sh
>>> ### 426 tests: 346 passed, 70 skipped, 0 timed out, 7 warned, 3 failed
>>>     in 89:26.073
>>
>> Thanks for the test, this is greate news.
>>
>> Kuai
>>
> 
> Hi Kuai
> 
> Have you run mdadm regression tests based on this patch set?

Of course, I'm runing in my VM with loop devices.

Thanks,
Kuai

> 
> Regards
> Xiao
> 
> .
> 

