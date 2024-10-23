Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D7E28DD0
	for <dm-devel@lists.linux.dev>; Wed, 23 Oct 2024 01:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729645992; cv=none; b=VvkzjnW0znxRoUkS5/vm+jc/9nu/GzTBo8lkc+C9Rr675nWR40VB8aqeowPwaFwr3rS6xuOU18cUlO5hpmisqDRiGhYhvYJ/EVSMMlE8Cj90qFe9xPLxPw/L2847sw43Or5b4lPgFifo3VeT0zlbmogcvP+WoYKVyOmDr9iEvDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729645992; c=relaxed/simple;
	bh=JWwJ6wMBiZV9tuoxkui/2+3h6i7NkgyBb63LrjxMINU=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=qcZoMGc7i6cAaa6mvXqJQCLTMGE7mBAx0n/kQVAeWcRjO/lUlVo2+Yd7NByLWEegS7R+TIhuUc3IddH8ouvjJT6oivSUeUXxmx6zFsPxo3ABwqpShZBiHUOELkASx7rDg5dBYOxpDaY9wplyLbJjL7e/0FXrsVY02H2/nwOJ47I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4XY9yZ1NcWz4f3jkk
	for <dm-devel@lists.linux.dev>; Wed, 23 Oct 2024 09:12:54 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 7E7AF1A058E
	for <dm-devel@lists.linux.dev>; Wed, 23 Oct 2024 09:13:06 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgAXTMifTRhnnkJsEw--.274S3;
	Wed, 23 Oct 2024 09:13:05 +0800 (CST)
Subject: Re: PROBLEM: repeatable lockup on RAID-6 with LUKS dm-crypt on NVMe
 devices when rsyncing many files
To: Christian Theune <ct@flyingcircus.io>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: John Stoffel <john@stoffel.org>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 dm-devel@lists.linux.dev, "yukuai (C)" <yukuai3@huawei.com>
References: <ADF7D720-5764-4AF3-B68E-1845988737AA@flyingcircus.io>
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
 <adee77ef-f785-acd6-485a-fe2d0a1b9a92@huaweicloud.com>
 <143E09BF-BD10-43EB-B0F1-7421F8200DB1@flyingcircus.io>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <1bbc86a8-1abf-11a1-e724-b6868a8d9f88@huaweicloud.com>
Date: Wed, 23 Oct 2024 09:13:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <143E09BF-BD10-43EB-B0F1-7421F8200DB1@flyingcircus.io>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXTMifTRhnnkJsEw--.274S3
X-Coremail-Antispam: 1UD129KBjvJXoWxZw47WrykAF45tr43Cw13XFb_yoWrXF4rpF
	Z3Gas0qrn5Jr1kG3s2v348XayYyrW3tFZ0qF18J3yUA3s8tFyaqF10kFWY9asrZ3y8A3W0
	vrW2q3srXFy0kaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2Kf
	nxnUUI43ZEXa7VUbSfO7UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/10/22 23:02, Christian Theune 写道:
> Hi,
> 
> I had to put this issue aside and as Yu indicated he was busy I didn’t follow up yet.
> 
> @Yu: I don’t have new insights, but I have a basically identical machine that I will start adding new data with a similar structure soon.
> 
> I couldn’t directly reproduce the issue there - likely because the network is a bit slower as it’s connected from a remote side and has only 1G instead of 10G, due to the long distances.
> 
> Let me know if you’re interested in following up here and I’ll try to make room on my side to get you more input as needed.

Yes, sorry that I was totally busy with other things. :(

BTW, what is the result after bypassing bitmap(disable bitmap by
kernel hacking)?

Thanks,
Kuai

> 
> Christian
> 
>> On 15. Aug 2024, at 13:14, Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>
>> Hi,
>>
>> 在 2024/08/15 18:03, Christian Theune 写道:
>>> Hi,
>>> small insight: even given my dataset that can reliably trigger this (after around 1.5 hours of rsyncing) it does not trigger on a specific set of files. I’ve deleted the data and started the rsync on a fresh directory (not a fresh filesystem, I can’t delete that as it carries important data) but it doesn’t always get stuck on the same files, even though rsync processes them in a repeatable order.
>>> I’m wondering how to generate more insights from that. Maybe keeping a blktrace log might help?
>>> It sounds like the specific pattern relies on XFS doing a specific thing there …
>>> Wild idea: maybe running the xfstest suite on an in-memory raid 6 setup could reproduce this?
>>> I’m guessing that the xfs people do not regularly run their test suite on a layered setup like mine with encryption and software raid?
>>
>> That sounds greate.
>>>   Christian
>>>> On 15. Aug 2024, at 08:19, Christian Theune <ct@flyingcircus.io> wrote:
>>>>
>>>> Hi,
>>>>
>>>>> On 14. Aug 2024, at 10:53, Christian Theune <ct@flyingcircus.io> wrote:
>>>>>
>>>>> Hi,
>>>>>
>>>>>> On 12. Aug 2024, at 20:37, John Stoffel <john@stoffel.org> wrote:
>>>>>>
>>>>>> I'd probably just do the RAID6 tests first, get them out of the way.
>>>>>
>>>>> Alright, those are running right now - I’ll let you know what happens.
>>>>
>>>> I’m not making progress here. I can’t reproduce those on in-memory loopback raid 6. However: i can’t fully produce the rsync. For me this only triggered after around 1.5hs of progress on the NVMe which resulted in the hangup. I can only create around 20 GiB worth of raid 6 volume on this machine. I’ve tried running rsync until it exhausts the space, deleting the content and running rsync again, but I feel like this isn’t suffient to trigger the issue. :(
>>>>
>>>> I’m trying to find whether any specific pattern in the files around the time it locks up might be relevant here and try to run the rsync over that
>>>> portion.
>>>>
>>>> On the plus side, I have a script now that can create the various loopback settings quickly, so I can try out things as needed. Not that valuable without a reproducer, yet, though.
>>>>
>>>> @Yu: you mentioned that you might be able to provide me a kernel that produces more error logging to diagnose this? Any chance we could try that route?
>>
>> Yes, however, I still need some time to sort out the internal process of
>> raid5. I'm quite busy with some other work stuff and I'm familiar with
>> raid1/10, but not too much about raid5. :(
>>
>> Main idea is to figure out why IO are not dispatched to underlying
>> disks.
>>
>> Thanks,
>> Kuai
>>
>>>>
>>>> Christian
>>>>
>>>> -- 
>>>> Christian Theune · ct@flyingcircus.io · +49 345 219401 0
>>>> Flying Circus Internet Operations GmbH · https://flyingcircus.io
>>>> Leipziger Str. 70/71 · 06108 Halle (Saale) · Deutschland
>>>> HR Stendal HRB 21169 · Geschäftsführer: Christian Theune, Christian Zagrodnick
>>> Liebe Grüße,
>>> Christian Theune
> 
> 
> Liebe Grüße,
> Christian Theune
> 

