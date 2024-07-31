Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3224416C87C
	for <dm-devel@lists.linux.dev>; Wed, 31 Jul 2024 21:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722461629; cv=none; b=CaTFWrgJUDORg2ApIAF6zcWskjisBgDU+1BRnLti2hr3k1PIhVBMEYSbIZxU/hLkN2HWsuntbSlsdOvcTdVGlTnS3Ohiyh4ZSpYGmLKa7tcyTAfydzh2JB8O8f1YgmLcLM0+mNH9khxwf8RSKNLmSe/kmQ2CYe7VQJ75LRRihNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722461629; c=relaxed/simple;
	bh=yfEJ2IyPNo+UIkIuSJZXNNRPNIQb6tp9VjSrL5NU0b4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GiX989uQL/78TNWxkttmjqW8Lsq0xibYhibrHtrAABwyckFqWVrLcuITMIFVO3YwrGdIxR8LNQqzW2B5BCwX+ilGsgSrhaPIjhES+qa9UPunN5/Stj31ep5DIABG/yAfKRW7TMQtiTFueoOmhxCJPnvQcuT4MNvfdAUwwXzMFmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VIAhYFGx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VIAhYFGx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722461627;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lMJD3KA2qGNWCxRW43U2dkrvCsCBxrMP59mKFMIzsms=;
	b=VIAhYFGx518140XiO4Gwpn1+vq1NHcnmoR61UUMxQX1jTUm4g+NyKQ1K+taQJeo6TGGm1G
	tWO+Ia5m5f0qtyCDnoETUjoKYqETyGzbxiXgORJAJZg5TzFZLilGseB3vtabTAgJ8sC9SN
	Yhb3abwoVzjj1KmT1l54WajAy2Q201Q=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-178-MY1qvNJONR2fUJ0wzCFl_w-1; Wed, 31 Jul 2024 17:33:44 -0400
X-MC-Unique: MY1qvNJONR2fUJ0wzCFl_w-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-6b79ab201faso62725176d6.1
        for <dm-devel@lists.linux.dev>; Wed, 31 Jul 2024 14:33:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722461624; x=1723066424;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lMJD3KA2qGNWCxRW43U2dkrvCsCBxrMP59mKFMIzsms=;
        b=tnAU8tfMTxV3Mniu7CQvln/jx7CBGskPpjrfJOE6xZao6Xi+cQgWC4gCwbc6wGMoBD
         ju10TCFvQh0AhAsxvW9oNbqvOzXx2EWPujlIpQ+VYYvjhCtdoU6/0gyEI1/VquiApWxy
         sWukmjJvcfjQVAX59zvLIxyGy/3dyhBwLUKbziwJLiZxTC2FoQ0IHwLJaHraDDiGcQwP
         MbxBQUYi9lOWT3PGQQhC2buslxzsRSVI7LiPo3ykcTJiIYIonROTodyr3tmOnqOO9vpb
         JNjP0ZiW7GO6aADa3f7E7rZBZms+CYFh97J0r1pRBvoe65a5on3Tha3vWWysw526+qt9
         IKmw==
X-Gm-Message-State: AOJu0Yz0usU0eSU4m9JnWYebZBCkbyjWWQJfqZ3Vp5eSTHLEFGPlVJTu
	77R8aQGAkMu1s2JBX4ssAHeFT+BqcV/U5aNRJIJamrPD7AkuvXeV6U/i3m+TUxo5XmUc461gqnG
	GtwG5LqtfZqJCovqsAc3Hn5eYVPLUQhH8BlSC8dGNd4Rzdhg8csdXqBA2
X-Received: by 2002:a05:6214:5241:b0:6b4:fe1a:eeee with SMTP id 6a1803df08f44-6bb8d7be0f2mr6531026d6.46.1722461623990;
        Wed, 31 Jul 2024 14:33:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF/YTx441czrHIh+I1/t3wiuD00rLVQQeAR+4PNmWQ7Z+E6AwR9B1FNdAnu3NkwBA7KgkE5Ug==
X-Received: by 2002:a05:6214:5241:b0:6b4:fe1a:eeee with SMTP id 6a1803df08f44-6bb8d7be0f2mr6530786d6.46.1722461623499;
        Wed, 31 Jul 2024 14:33:43 -0700 (PDT)
Received: from [192.168.1.152] ([70.22.187.239])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6bb3fa950a3sm78404816d6.90.2024.07.31.14.33.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Jul 2024 14:33:42 -0700 (PDT)
Message-ID: <9de7c031-58e6-56df-6b9c-b10952551d02@redhat.com>
Date: Wed, 31 Jul 2024 17:33:41 -0400
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: Lockup of (raid5 or raid6) + vdo after taking out a disk under
 load
To: Konstantin Kharlamov <Hi-Angel@yandex.ru>,
 Yu Kuai <yukuai1@huaweicloud.com>, Song Liu <song@kernel.org>,
 linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 "yangerkun@huawei.com" <yangerkun@huawei.com>,
 "yukuai (C)" <yukuai3@huawei.com>
Cc: dm-devel@lists.linux.dev
References: <a6d068a26a90057fb3cdaa59f9d57a2af41a6b22.camel@yandex.ru>
 <1f879e67-4d64-4df0-5817-360d84ff8b89@huaweicloud.com>
 <29d69e586e628ef2e5f2fd7b9fe4e7062ff36ccf.camel@yandex.ru>
 <517243f0-77c5-9d67-a399-78c449f6afc6@huaweicloud.com>
 <810a319b846c7e16d85a7f52667d04252a9d0703.camel@yandex.ru>
 <9c60881e-d28f-d8d5-099c-b9678bd69db9@huaweicloud.com>
 <57241c91337e8fc3257b6d4a35c273af59875eff.camel@yandex.ru>
 <37df66ec9cf1a0570a86ec0b9f17ae18ed11b832.camel@yandex.ru>
From: Matthew Sakai <msakai@redhat.com>
In-Reply-To: <37df66ec9cf1a0570a86ec0b9f17ae18ed11b832.camel@yandex.ru>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 7/31/24 10:14, Konstantin Kharlamov wrote:
> CC'ing VDO maintainers, because the problem is only reproducible with
> VDO, so potentially they might have some ideas.

I don't see anything that implicates VDO directly. The blocked VDO 
threads (with the test patch) seem to be stuck in raid5_make_request() 
so it seems like the raid itself is not handling requests in a timely 
manner.

There is one potentially useful detail, however: VDO mostly submits 4K 
bios. The large number of smaller bios may be exacerbating an issue in 
the raid5.

Matt

> On Mon, 2024-07-22 at 20:56 +0300, Konstantin Kharlamov wrote:
>> Hi, sorry for the delay, I had to give away the nodes and we had a
>> week
>> of teambuilding and company party, so for the past week I only
>> managed
>> to hack away stripping debug symbols, get another node and set it up.
>>
>> Experiments below are based off of vanilla 6.9.8 kernel *without*
>> your
>> patch.
>>
>> On Mon, 2024-07-15 at 09:56 +0800, Yu Kuai wrote:
>>> Line number will be helpful.
>>
>> So, after tinkering with building scripts I managed to build modules
>> with debug symbols (not the kernel itself but should be good enough),
>> but for some reason kernel doesn't show line numbers in stacktraces.
>> No
>> idea what could be causing it, so I had to decode line numbers
>> manually, below is an output where I inserted line numbers for
>> raid456
>> manually after decoding them with `gdb`.
>>
>>      […]
>>      [ 1677.293366]  <TASK>
>>      [ 1677.293661]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20
>>      [ 1677.293972]  ? _raw_spin_unlock_irq+0x10/0x30
>>      [ 1677.294276]  ? _raw_spin_unlock_irq+0xa/0x30
>>      [ 1677.294586]  raid5d at drivers/md/raid5.c:6572
>>      [ 1677.294910]  md_thread+0xc1/0x170
>>      [ 1677.295228]  ? __pfx_autoremove_wake_function+0x10/0x10
>>      [ 1677.295545]  ? __pfx_md_thread+0x10/0x10
>>      [ 1677.295870]  kthread+0xff/0x130
>>      [ 1677.296189]  ? __pfx_kthread+0x10/0x10
>>      [ 1677.296498]  ret_from_fork+0x30/0x50
>>      [ 1677.296810]  ? __pfx_kthread+0x10/0x10
>>      [ 1677.297112]  ret_from_fork_asm+0x1a/0x30
>>      [ 1677.297424]  </TASK>
>>      […]
>>      [ 1705.296253]  <TASK>
>>      [ 1705.296554]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20
>>      [ 1705.296864]  ? _raw_spin_unlock_irq+0x10/0x30
>>      [ 1705.297172]  ? _raw_spin_unlock_irq+0xa/0x30
>>      [ 1677.294586]  raid5d at drivers/md/raid5.c:6597
>>      [ 1705.297794]  md_thread+0xc1/0x170
>>      [ 1705.298099]  ? __pfx_autoremove_wake_function+0x10/0x10
>>      [ 1705.298409]  ? __pfx_md_thread+0x10/0x10
>>      [ 1705.298714]  kthread+0xff/0x130
>>      [ 1705.299022]  ? __pfx_kthread+0x10/0x10
>>      [ 1705.299333]  ret_from_fork+0x30/0x50
>>      [ 1705.299641]  ? __pfx_kthread+0x10/0x10
>>      [ 1705.299947]  ret_from_fork_asm+0x1a/0x30
>>      [ 1705.300257]  </TASK>
>>      […]
>>      [ 1733.296255]  <TASK>
>>      [ 1733.296556]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20
>>      [ 1733.296862]  ? _raw_spin_unlock_irq+0x10/0x30
>>      [ 1733.297170]  ? _raw_spin_unlock_irq+0xa/0x30
>>      [ 1677.294586]  raid5d at drivers/md/raid5.c:6572
>>      [ 1733.297792]  md_thread+0xc1/0x170
>>      [ 1733.298096]  ? __pfx_autoremove_wake_function+0x10/0x10
>>      [ 1733.298403]  ? __pfx_md_thread+0x10/0x10
>>      [ 1733.298711]  kthread+0xff/0x130
>>      [ 1733.299018]  ? __pfx_kthread+0x10/0x10
>>      [ 1733.299330]  ret_from_fork+0x30/0x50
>>      [ 1733.299637]  ? __pfx_kthread+0x10/0x10
>>      [ 1733.299943]  ret_from_fork_asm+0x1a/0x30
>>      [ 1733.300251]  </TASK>
>>
>>> Meanwhile, can you check if the underlying
>>> disks has IO while raid5 stuck, by /sys/block/[device]/inflight.
>>
>> The two devices that are left after the 3rd one is removed has these
>> numbers that don't change with time:
>>
>>      [Mon Jul 22 20:18:06 @ ~]:> for d in dm-19 dm-17; do echo -n $d;
>> cat
>>      /sys/block/$d/inflight; done
>>      dm-19       9        1
>>      dm-17      11        2
>>      [Mon Jul 22 20:18:11 @ ~]:> for d in dm-19 dm-17; do echo -n $d;
>> cat
>>      /sys/block/$d/inflight; done
>>      dm-19       9        1
>>      dm-17      11        2
>>
>> They also don't change after I return the disk back (which is to be
>> expected I guess, given that the lockup doesn't go away).
>>
>>>>
>>>>> At first, can the problem reporduce with raid1/raid10? If not,
>>>>> this
>>>>> is
>>>>> probably a raid5 bug.
>>>>
>>>> This is not reproducible with raid1 (i.e. no lockups for raid1),
>>>> I
>>>> tested that. I didn't test raid10, if you want I can try (but
>>>> probably
>>>> only after the weekend, because today I was asked to give the
>>>> nodes
>>>> away, for the weekend at least, to someone else).
>>>
>>> Yes, please try raid10 as well. For now I'll say this is a raid5
>>> problem.
>>
>> Tested: raid10 works just fine, i.e. no lockup and fio continues
>> having non-zero IOPS.
>>
>>>>> The best will be that if I can reporduce this problem myself.
>>>>> The problem is that I don't understand the step 4: turning off
>>>>> jbod
>>>>> slot's power, is this only possible for a real machine, or can
>>>>> I
>>>>> do
>>>>> this in my VM?
>>>>
>>>> Well, let's say that if it is possible, I don't know a way to do
>>>> that.
>>>> The `sg_ses` commands that I used
>>>>
>>>> 	sg_ses --dev-slot-num=9 --set=3:4:1   /dev/sg26 #
>>>> turning
>>>> off
>>>> 	sg_ses --dev-slot-num=9 --clear=3:4:1 /dev/sg26 #
>>>> turning
>>>> on
>>>>
>>>> …sets and clears the value of the 3:4:1 bit, where the bit is
>>>> defined
>>>> by the JBOD's manufacturer datasheet. The 3:4:1 specifically is
>>>> defined
>>>> by "AIC" manufacturer. That means the command as is unlikely to
>>>> work on
>>>> a different hardware.
>>>
>>> I never do this before, I'll try.
>>>>
>>>> Well, while on it, do you have any thoughts why just using a
>>>> `echo
>>>> 1 >
>>>> /sys/block/sdX/device/delete` doesn't reproduce it? Does perhaps
>>>> kernel
>>>> not emulate device disappearance too well?
>>>
>>> echo 1 > delete just delete the disk from kernel, and scsi/dm-raid
>>> will
>>> know that this disk is deleted. However, the disk will stay in
>>> kernel
>>> for the other way, dm-raid does not aware that underlying disks are
>>> problematic and IO will still be generated and issued.
>>>
>>> Thanks,
>>> Kuai
> 

