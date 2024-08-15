Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C859413D530
	for <dm-devel@lists.linux.dev>; Thu, 15 Aug 2024 11:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723720506; cv=none; b=iFEMtwkGY0wSbdY2b82bmn7Gk6OYxPnXbjqQywP0FhZKP/ZH/UOF/i17Cvm04FhsKAcOZ1RwTIv5OBNnN1IGll9+s8C54O5RbPvss8W6BHRCyK0X7iTAcW0zHUng0/AsdwXHbka9avkL/fvu7fl/UsVv6kbVTk5Kwi/aj1OTSVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723720506; c=relaxed/simple;
	bh=OkqzzXiHerrOA+A1ye99MqYNxImtWB/1hIYRJkxHjYE=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=rEswRCxNCuKaHGPlnDhAUsb7Yx8QfLHPGk6N9mI1Y1HiswernPxjoXxU/X3dsPx9+UbkmAiho/TynQEawrkKvwOQ2zQne25iey6idU5dzkNGhJJPhf6TyK/1wHIj7MFqE4VWNglQdbVmMsBE4KdlLmdg/y33QDDt5PixGiWzjF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Wl2Zl6qVGz4f3jXr
	for <dm-devel@lists.linux.dev>; Thu, 15 Aug 2024 19:14:39 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id C3DFB1A0359
	for <dm-devel@lists.linux.dev>; Thu, 15 Aug 2024 19:14:53 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgB3n4Ur471mPgEJBw--.27350S3;
	Thu, 15 Aug 2024 19:14:52 +0800 (CST)
Subject: Re: PROBLEM: repeatable lockup on RAID-6 with LUKS dm-crypt on NVMe
 devices when rsyncing many files
To: Christian Theune <ct@flyingcircus.io>, John Stoffel <john@stoffel.org>
Cc: Yu Kuai <yukuai1@huaweicloud.com>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 dm-devel@lists.linux.dev, "yukuai (C)" <yukuai3@huawei.com>
References: <ADF7D720-5764-4AF3-B68E-1845988737AA@flyingcircus.io>
 <316050c6-fac2-b022-6350-eaedcc7d953a@huaweicloud.com>
 <58450ED6-EBC3-4770-9C5C-01ABB29468D6@flyingcircus.io>
 <EACD5B78-93F6-443C-BB5A-19C9174A1C5C@flyingcircus.io>
 <22C5E55F-9C50-4DB7-B656-08BEC238C8A7@flyingcircus.io>
 <26291.57727.410499.243125@quad.stoffel.home>
 <2EE0A3CE-CFF2-460C-97CD-262D686BFA8C@flyingcircus.io>
 <1dfc4792-02b2-5b3c-c3d1-bf1b187a182e@huaweicloud.com>
 <4363F3A3-46C2-419E-B43A-4CDA8C293CEB@flyingcircus.io>
 <C832C22B-E720-4457-83C6-CA259AD667B2@flyingcircus.io>
 <e92ccf15-be2a-a1aa-5ea2-a88def82e681@huaweicloud.com>
 <30D680B2-F494-42F5-8498-6ED586E05766@flyingcircus.io>
 <26294.40330.924457.532299@quad.stoffel.home>
 <C9A9855D-B0A2-4B13-947E-01AF5BA6DF04@flyingcircus.io>
 <26298.22106.810744.702395@quad.stoffel.home>
 <EBC67418-E60C-435A-8F63-114C67F07583@flyingcircus.io>
 <CEC90137-09B3-41AA-A115-1C172F9C6C4B@flyingcircus.io>
 <2F5F9789-1827-4105-934F-516582018540@flyingcircus.io>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <adee77ef-f785-acd6-485a-fe2d0a1b9a92@huaweicloud.com>
Date: Thu, 15 Aug 2024 19:14:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <2F5F9789-1827-4105-934F-516582018540@flyingcircus.io>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB3n4Ur471mPgEJBw--.27350S3
X-Coremail-Antispam: 1UD129KBjvJXoWxGFy5WFy5AF1kJr48Kw43GFg_yoW5Ary8pF
	Z3KasIgrs3Jw1kG3s2v348X34YyrWayFZ0qF18A3yUA3s8Jryav3WIkrWY9F9rZ3y8Aw10
	vF42qr9rXFyvkaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
	Y487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r
	1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CE
	b7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0x
	vE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAI
	cVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2Kf
	nxnUUI43ZEXa7VUbSfO7UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/08/15 18:03, Christian Theune 写道:
> Hi,
> 
> small insight: even given my dataset that can reliably trigger this (after around 1.5 hours of rsyncing) it does not trigger on a specific set of files. I’ve deleted the data and started the rsync on a fresh directory (not a fresh filesystem, I can’t delete that as it carries important data) but it doesn’t always get stuck on the same files, even though rsync processes them in a repeatable order.
> 
> I’m wondering how to generate more insights from that. Maybe keeping a blktrace log might help?
> 
> It sounds like the specific pattern relies on XFS doing a specific thing there …
> 
> Wild idea: maybe running the xfstest suite on an in-memory raid 6 setup could reproduce this?
> 
> I’m guessing that the xfs people do not regularly run their test suite on a layered setup like mine with encryption and software raid?

That sounds greate.
>   
> Christian
> 
>> On 15. Aug 2024, at 08:19, Christian Theune <ct@flyingcircus.io> wrote:
>>
>> Hi,
>>
>>> On 14. Aug 2024, at 10:53, Christian Theune <ct@flyingcircus.io> wrote:
>>>
>>> Hi,
>>>
>>>> On 12. Aug 2024, at 20:37, John Stoffel <john@stoffel.org> wrote:
>>>>
>>>> I'd probably just do the RAID6 tests first, get them out of the way.
>>>
>>> Alright, those are running right now - I’ll let you know what happens.
>>
>> I’m not making progress here. I can’t reproduce those on in-memory loopback raid 6. However: i can’t fully produce the rsync. For me this only triggered after around 1.5hs of progress on the NVMe which resulted in the hangup. I can only create around 20 GiB worth of raid 6 volume on this machine. I’ve tried running rsync until it exhausts the space, deleting the content and running rsync again, but I feel like this isn’t suffient to trigger the issue. :(
>>
>> I’m trying to find whether any specific pattern in the files around the time it locks up might be relevant here and try to run the rsync over that
>> portion.
>>
>> On the plus side, I have a script now that can create the various loopback settings quickly, so I can try out things as needed. Not that valuable without a reproducer, yet, though.
>>
>> @Yu: you mentioned that you might be able to provide me a kernel that produces more error logging to diagnose this? Any chance we could try that route?

Yes, however, I still need some time to sort out the internal process of
raid5. I'm quite busy with some other work stuff and I'm familiar with
raid1/10, but not too much about raid5. :(

Main idea is to figure out why IO are not dispatched to underlying
disks.

Thanks,
Kuai

>>
>> Christian
>>
>> -- 
>> Christian Theune · ct@flyingcircus.io · +49 345 219401 0
>> Flying Circus Internet Operations GmbH · https://flyingcircus.io
>> Leipziger Str. 70/71 · 06108 Halle (Saale) · Deutschland
>> HR Stendal HRB 21169 · Geschäftsführer: Christian Theune, Christian Zagrodnick
> 
> 
> Liebe Grüße,
> Christian Theune
> 

