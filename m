Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83076205ABB
	for <dm-devel@lists.linux.dev>; Mon, 16 Dec 2024 13:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734356212; cv=none; b=VDZXbOjZDokhBFhEhyTpCW0a3YkwxtmJuY2bs1D7HJJ/QOsDG6g8zx5ydhfrVDaftg+ggos3U1tVblO89CxyiOILJFLDFGsD2zmewYbRsLUZT97ZbwavRRMlo98fgHAY6oPJCP9hYW4IYX8+uZ4wTNc9CyZJMoGBI+N7VTaXiAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734356212; c=relaxed/simple;
	bh=3x2YQ5HVZ2OjXccJi3A6P1XlPFZaQIJfUHvRRf66QRo=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=m3QYIhfAHqUbsstAd76Q2PaN18osm9AQfrx1z6/AmUDFYuUuuqUDAGd1Tyx0NTmrwHkJD6RndiKweZ8ZWzMimHSjvDgrFJkSqWSZt8vc25/limHNzNjKJGiLOOj7WYBrOTKu8d1L18SdP/5K2tvEYagvuy4ezcui7flANXs6mcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4YBgvg2qp6z4f3jjx
	for <dm-devel@lists.linux.dev>; Mon, 16 Dec 2024 21:36:31 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id CACA41A0194
	for <dm-devel@lists.linux.dev>; Mon, 16 Dec 2024 21:36:45 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgB3noLpLGBnVPkTEw--.38413S3;
	Mon, 16 Dec 2024 21:36:43 +0800 (CST)
Subject: Re: PROBLEM: repeatable lockup on RAID-6 with LUKS dm-crypt on NVMe
 devices when rsyncing many files
To: Christian Theune <ct@flyingcircus.io>, Xiao Ni <xni@redhat.com>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, John Stoffel <john@stoffel.org>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 dm-devel@lists.linux.dev, =?UTF-8?Q?Dragan_Milivojevi=c4=87?=
 <galileo@pkm-inc.com>, "yangerkun@huawei.com" <yangerkun@huawei.com>,
 David Jeffery <djeffery@redhat.com>, "yukuai (C)" <yukuai3@huawei.com>
References: <ADF7D720-5764-4AF3-B68E-1845988737AA@flyingcircus.io>
 <9A0AE411-B4B8-424A-B9F6-AF933F6544F9@flyingcircus.io>
 <BE85CBCF-1B09-48D0-9931-AA8D298F1D6B@flyingcircus.io>
 <b2a654e7-6c71-a44e-645c-686eed9d5cd8@huaweicloud.com>
 <240E3553-1EDD-49C8-88B8-FB3A7F0CE39C@flyingcircus.io>
 <12295067-fc9a-8847-b370-7d86b2b66426@huaweicloud.com>
 <CALTww28iP_pGU7jmhZrXX9D-xL5Xb6w=9jLxS=fvv_6HgqZ6qw@mail.gmail.com>
 <09338D11-6B73-4C4B-A19A-6BDC6489C91D@flyingcircus.io>
 <C3A9A473-0F0E-4168-BB96-5AB140C6A9FC@flyingcircus.io>
 <0B1D29D1-523C-4E42-95F9-62B32B741930@flyingcircus.io>
 <4DA6F1FE-D465-40C7-A116-F49CF6A2CFF0@flyingcircus.io>
 <CALTww292Dwduh=k1W4=u+N2K6WYK7RXQyPWG3Yn-JpLY9QDbDQ@mail.gmail.com>
 <362DFCF4-14C5-464C-A73F-72C9A3871E2F@flyingcircus.io>
 <CALTww280ztWNUW23-Y+8w_S4ZAR4UYdtAmZU4b_wLHjjpTRPJQ@mail.gmail.com>
 <DD7FDB11-1BC5-4FA9-9398-23434CBDB6F8@flyingcircus.io>
 <F9738805-DB6B-4249-A4B0-EC989AD6C399@flyingcircus.io>
 <FE6CA342-7C31-4280-A62B-EFA222675DAD@flyingcircus.io>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <f34b49b2-6be2-3a5f-d8b2-ea49f5249dd6@huaweicloud.com>
Date: Mon, 16 Dec 2024 21:36:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <FE6CA342-7C31-4280-A62B-EFA222675DAD@flyingcircus.io>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB3noLpLGBnVPkTEw--.38413S3
X-Coremail-Antispam: 1UD129KBjvJXoWxAF1DtFykCF17tryxXFy5Jwb_yoW5ury8p3
	s8JFsIvF13Jr17Gr1Iy34FqF1YyF43Jrn0gr18GryUZw4qyr90vFyIkr4YgF18ZrW8Xw18
	ZrWSqw1xXFWxCaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUB014x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kI
	c2xKxwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7V
	AKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCj
	r7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6x
	IIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAI
	w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x
	0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUonmRUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/12/16 21:25, Christian Theune 写道:
> Hi,
> 
> both my servers that exhibited this issue have been running fine with 6.6.64 and the proposed patch.
> 
> @yu I’d love to get this backported, is there anything I can/need to do?

Looks like you're testing the wrong patch. We'll not go with this patch
in upstream.

Do you still remember the patch set from following thread?

https://lore.kernel.org/all/5D6DF34A-81EF-47EE-B280-6A243A28011D@flyingcircus.io/

Sorry that I was busy with other things, I'll push this in the next
merge window v6.14-rc1, unless it fails your test. :)

Thanks,
Kuai

> 
> Christian
> 
>> On 10. Dec 2024, at 09:33, Christian Theune <ct@flyingcircus.io> wrote:
>>
>> Just a quick update: i’ve been out sick and only am getting around to start testing the patch on 6.6. it applied cleanly as you suggested and I’m waiting for the compile to finish. I’ll get back to you in the next days how it worked out.
>>
>>> On 15. Nov 2024, at 12:06, Christian Theune <ct@flyingcircus.io> wrote:
>>>
>>> Will do that!
>>>
>>>> On 15. Nov 2024, at 11:11, Xiao Ni <xni@redhat.com> wrote:
>>>>
>>>> On Fri, Nov 15, 2024 at 4:45 PM Christian Theune <ct@flyingcircus.io> wrote:
>>>>>
>>>>> Hi,
>>>>>
>>>>>> On 15. Nov 2024, at 09:07, Xiao Ni <xni@redhat.com> wrote:
>>>>>>
>>>>>> On Thu, Nov 14, 2024 at 11:07 PM Christian Theune <ct@flyingcircus.io> wrote:
>>>>>>>
>>>>>>> Hi,
>>>>>>>
>>>>>>> just a followup: the system ran over 2 days without my workload being able to trigger the issue. I’ve seen there is another thread where this patch wasn’t sufficient and if i understand correctly, Yu and Xiao are working on an amalgamated fix?
>>>>>>>
>>>>>>> Christian
>>>>>>
>>>>>> Hi Christian
>>>>>>
>>>>>> Beside the bitmap stuck problem, the other thread has a new problem.
>>>>>> But it looks like you don't have the new problem because you already
>>>>>> ran without failure for 2 days. I'll send patches against 6.13 and
>>>>>> 6.11.
>>>>>
>>>>> Great, thanks!
>>>>>
>>>>> What do I need to do to get patches towards 6.6?
>>>>
>>>> Hi
>>>>
>>>> This patch can apply to 6.6 cleanly. You can have a try on 6.6 with
>>>> this patch to see if it works.
>>>>
>>>> Regards
>>>> Xiao
>>>>>
>>>>> Christian
>>>>>
>>>>> --
>>>>> Christian Theune · ct@flyingcircus.io · +49 345 219401 0
>>>>> Flying Circus Internet Operations GmbH · https://flyingcircus.io
>>>>> Leipziger Str. 70/71 · 06108 Halle (Saale) · Deutschland
>>>>> HR Stendal HRB 21169 · Geschäftsführer: Christian Theune, Christian Zagrodnick
>>>
>>>
>>> Liebe Grüße,
>>> Christian Theune
>>>
>>> -- 
>>> Christian Theune · ct@flyingcircus.io · +49 345 219401 0
>>> Flying Circus Internet Operations GmbH · https://flyingcircus.io
>>> Leipziger Str. 70/71 · 06108 Halle (Saale) · Deutschland
>>> HR Stendal HRB 21169 · Geschäftsführer: Christian Theune, Christian Zagrodnick
>>>
>>
>> Liebe Grüße,
>> Christian Theune
>>
>> -- 
>> Christian Theune · ct@flyingcircus.io · +49 345 219401 0
>> Flying Circus Internet Operations GmbH · https://flyingcircus.io
>> Leipziger Str. 70/71 · 06108 Halle (Saale) · Deutschland
>> HR Stendal HRB 21169 · Geschäftsführer: Christian Theune, Christian Zagrodnick
>>
> 
> Liebe Grüße,
> Christian Theune
> 

