Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE3A1547C4
	for <dm-devel@lists.linux.dev>; Thu, 31 Oct 2024 07:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730360892; cv=none; b=iKcJS1mZmopn+RGVDgumSPRZk4bHJUoiKmoKL/sp9rmRrkaOZDQm+meMMYvKNjUdQljA1KRcEnBMh67NJ/X8ZHVRt4I6eL/e3UL8f/vTQl1veOszg+Mf+XUv4FaX/8OXZRdipJucbBDJFzVi1idNKSJwpzOH3ezo6fr1LuInrlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730360892; c=relaxed/simple;
	bh=Hh9vku2B5q8/YibJQIda6w9LkAXuNZ//Ql5BPQ4S7b0=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Z1jsTER7NGUVt/Jbnwu3NTg9Jj2f/Oj8jkCvSdUGezBF0f/W1RB6XiCGC5QbQrqD3d6A0KNu/suycpXvEOa0FBh/dlE2uOn2qqlXdMlW7+DzoM271g4+vgB6tQDAeLklk4NPgzBuG4CK04XvfGmlfvDfGGBuVsYVWC0eKv0ZH5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4XfGLV50Kkz4f3jYR
	for <dm-devel@lists.linux.dev>; Thu, 31 Oct 2024 15:47:46 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 6449D1A018C
	for <dm-devel@lists.linux.dev>; Thu, 31 Oct 2024 15:48:04 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgBHI4cyNiNnD+rFAQ--.60858S3;
	Thu, 31 Oct 2024 15:48:04 +0800 (CST)
Subject: Re: PROBLEM: repeatable lockup on RAID-6 with LUKS dm-crypt on NVMe
 devices when rsyncing many files
To: Christian Theune <ct@flyingcircus.io>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: John Stoffel <john@stoffel.org>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 dm-devel@lists.linux.dev, =?UTF-8?Q?Dragan_Milivojevi=c4=87?=
 <galileo@pkm-inc.com>, "yukuai (C)" <yukuai3@huawei.com>
References: <ADF7D720-5764-4AF3-B68E-1845988737AA@flyingcircus.io>
 <26298.22106.810744.702395@quad.stoffel.home>
 <EBC67418-E60C-435A-8F63-114C67F07583@flyingcircus.io>
 <CEC90137-09B3-41AA-A115-1C172F9C6C4B@flyingcircus.io>
 <2F5F9789-1827-4105-934F-516582018540@flyingcircus.io>
 <adee77ef-f785-acd6-485a-fe2d0a1b9a92@huaweicloud.com>
 <143E09BF-BD10-43EB-B0F1-7421F8200DB1@flyingcircus.io>
 <1bbc86a8-1abf-11a1-e724-b6868a8d9f88@huaweicloud.com>
 <69D8A311-E619-40C2-985A-FB15D0336ADE@flyingcircus.io>
 <CALtW_agiOj2PJ_vsWym0qR8w1Q9iotHKPGuP5RohktkqeXt2mw@mail.gmail.com>
 <E893A1D9-4042-4515-88AE-C69B078A3E43@flyingcircus.io>
 <A74EC4F5-2FF8-4274-A1EB-28D527F143F1@flyingcircus.io>
 <2d85e9ab-1d0f-70a1-fab2-1e469764ef28@huaweicloud.com>
 <3CF4B28B-52D7-414E-96A1-FDFA5A5EF172@flyingcircus.io>
 <3DB33849-56C5-4C5C-BF56-F54205BEFCF2@flyingcircus.io>
 <1f2c74f4-8ba9-1a9f-0c11-018a25e785e5@huaweicloud.com>
 <22A202B1-A802-406F-8F38-F4F486A92F81@flyingcircus.io>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <45d44ed5-da7c-6480-9143-f611385b2e92@huaweicloud.com>
Date: Thu, 31 Oct 2024 15:48:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <22A202B1-A802-406F-8F38-F4F486A92F81@flyingcircus.io>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHI4cyNiNnD+rFAQ--.60858S3
X-Coremail-Antispam: 1UD129KBjvJXoW7uF1rAF1xZr1fXF45Xr4Dtwb_yoW8JFyUpr
	ZFqanIqr43Aws7J392vw18XryYyF4qqrZ0qF1rJw1qy3s8WFWFqa1xGr45CFWDG3WfA3WU
	XF43Ka93Xa18A3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

在 2024/10/30 14:29, Christian Theune 写道:
> Hi,
> 
>> On 30. Oct 2024, at 02:25, Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>
>> Hi,
>>
>> 在 2024/10/26 20:11, Christian Theune 写道:
>>>> On 26. Oct 2024, at 14:07, Christian Theune <ct@flyingcircus.io> wrote:
>>>>
>>>> Hi,
>>>>
>>>> I can’t apply this on 6.10.5 and trying to manually reconstruct your patch lets me directly stumble into:
>>> 6.11.5 of course
>>
>> I cooked this based on v6.12-rc5, it's right there will be conflict for
>> 6.11, can you manual adapta it in you version?
> 
> I will try, but I’m not sure. I don’t have a deep enough understanding to resolve some of the conflicts. In my previous mail I wasn’t sure which change would be the right one:
> 
> I guess if 6.12 doesn’t have this line at all:
> 
> -               atomic_set(&sh->count, 1);
> 
> … then setting it to 0 is fine?
> 
> +               atomic_set(&sh→count, 0);

My patch doesn't touch this field at all, why make such change? This is
not OK.
> 
> But again, I have no idea what’s actually going on there … ;)
> 
> If you want I can try to wade through and give you a list of questions where the patch doesn’t obviously apply and you can let me know …

Perhaps can you try v6.12-rc5 directly? If not, I'll give a patch based
on v6.11 later.

Thanks,
Kuai

> 
> Christian
> 

