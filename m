Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C02A28002D
	for <dm-devel@lists.linux.dev>; Mon, 19 May 2025 13:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747662923; cv=none; b=VU4vATDXZWJvQpPdNt3SHTxGLdYpzK9GOr8cJojlvK9Nc1pUbi3dn9a87163nXHn1kNbpHA//wQBtLpZSBPRniDgjufnY/w9lJq4BxOrcIIXlwUBo8+qIEUnJOMJ8e/sKakYVQTEZY6KtpyjjV9uRUZdlt6SuSzURffLhu3nFuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747662923; c=relaxed/simple;
	bh=NMSN0qZx1d/bqkEDlX05gfU639E4dQQt5fRo3TFKakg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UDQctSDyyOczJRg6seMP9nzZUotAEqabd6CsMlP8NIxWPObK5oR3hJ8AmxBBE4yRf0gfcqzZaT0/pqqI32a1gle8DAe9/xR6034Luq5WXRZdvW99aWMKIp7JJrZndmNveptHxZ9zSz50Kca+gCFiRq3rCo+7D0TZJhFmq0Q/d68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U6khCB0f; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U6khCB0f"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-443a787bd14so15447035e9.1
        for <dm-devel@lists.linux.dev>; Mon, 19 May 2025 06:55:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747662920; x=1748267720; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=chGazsrmzVy3Y/+yv9fBy99AyhTdQ1RXrLWAh6np3ZI=;
        b=U6khCB0fAPniGcXe8oZyCNANYleQ2g3qO5EuuJqUA8LqhKFZlhmhDCt2BM2fmQCBtr
         +g3mC7g7u5BQH9F+oAJjB+RdCp8y+shGA7rrz9PxSQcXf59XptxZPR72syPdRhsVBlHb
         fSPJIkMhKcRyXQdcaymNCQo4Yu8SJlRAMxLw5etdUhpt+aWi+T77bY3bsYpFwOkHcGxL
         wwQ5rJY1bmyYv7PXecFXk77g367AQvUmo0Hfzn3k3GXDKQE7UzSqRactCFTHNaV+SwFo
         ULesqJQNAzjwROJQy/txiSsB0Y5c8lVdboze9qrAwtKEt8y+T0/DfwpjNWq0qzA3jPtQ
         b6zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747662920; x=1748267720;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=chGazsrmzVy3Y/+yv9fBy99AyhTdQ1RXrLWAh6np3ZI=;
        b=K2h1PokSSKD13HMlblu4z/zbX7Mx8NBGiugzXEr/TXullkIX/4iLp5lUee7xHcMfbT
         4fIz/D4QYy0croIwc3C6OsReH8oKhNQeStxoUsqHsQ9ONZCwZiEJomhSi82eg55/qvbV
         x+NipatovfgYQ6YMa+dJrphlqgvU+ff4EKmcqKqKue6KxVfJC0rQGr04saSH8lFqncwb
         0ZoJs4vriJsum96vOZQFy41HwHbiTCVpj+7pEFjNoiSfc6IUsJC0Wty3ZacXnbPq7bGl
         i48gx1FIOemXGRsf1tSVSWb8yOOTKSr6aeuMNBjCae32gnkmvjPAu2OP3hi9xm7BjDOq
         QiRA==
X-Forwarded-Encrypted: i=1; AJvYcCW+TJcuS5Q+exM5OHg8K781MzRIc3yWOXrXJuC1ryv2XCjn/Z7OsoOB6y7tvY4e78LsfKhGJzh3Rw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz+BOu3WcfFGvrGDxD41Aw/xYHk2fqtV56BNwK75+XTfsc82vKM
	NS0bU7nSIPZXno2SfJeaE0JT3YWVLZ6UdAciRIg1fdFR78hdrKNOGvqX
X-Gm-Gg: ASbGncslbI30ay3pzA22J1vutjVX3K339/q2xdr6njCBXHKLUUOi5gIqyaWu/CtzQ3z
	zEG8OvGx9Cg7gyErHN2A1BLGXKSkrE1OFoUZ/qEufBWuyR2T/ETVOLyKNoGZLyWP5lyqg/fClhg
	ubbXCw7aHNu0nz+s0ahSXrbxzam+wDTTJcGwBlZTytAGkZZHVa8/RtSGOAJVFXocYzpL0FXHhdF
	IGEiQa5qeg4Pti75PS6paEcX5JQWySz8q8btBVtAtGy5qMbT/tgZqd+ay+H0M+ML1+yj43ot/f6
	hUaItAvTlK1DZcPzLgU+pPKUIGcymoZHDmkKsCct1HcE5e4fEAIpARy4sbO047Efnpfb
X-Google-Smtp-Source: AGHT+IGTV2F0Ie3YiH/a41xukybg0Vv7cUWZ9oCKJfnf7qhaDkr5xbFeDgBR1PRBIzwRzXRjj1GeWA==
X-Received: by 2002:a05:600c:3d0d:b0:442:ea3b:9d72 with SMTP id 5b1f17b1804b1-442f84ca3ecmr152079945e9.5.1747662920177;
        Mon, 19 May 2025 06:55:20 -0700 (PDT)
Received: from [10.43.17.62] ([85.93.96.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442fd583efasm135560755e9.29.2025.05.19.06.55.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 May 2025 06:55:19 -0700 (PDT)
Message-ID: <28d561ba-a4d4-4a16-a6f9-5d39a344cd06@gmail.com>
Date: Mon, 19 May 2025 15:55:18 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: LVM2 test breakage
To: Yu Kuai <yukuai1@huaweicloud.com>, Mikulas Patocka <mpatocka@redhat.com>
Cc: Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
 dm-devel@lists.linux.dev, "yukuai (C)" <yukuai3@huawei.com>
References: <34fa755d-62c8-4588-8ee1-33cb1249bdf2@redhat.com>
 <98ac5772-9931-17fd-1fc4-18d2c737b079@huaweicloud.com>
 <73ff7f5f-6f09-66d8-9061-7840bc72d0df@huaweicloud.com>
 <0be9be18-9488-1edc-00bb-5a1b0414fd15@redhat.com>
 <81c5847a-cfd8-4f9f-892c-62cca3d17e63@redhat.com>
 <2ec7a2fd-13bd-08d7-8e8d-71ef83c3aa45@huaweicloud.com>
Content-Language: en-US, cs
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
In-Reply-To: <2ec7a2fd-13bd-08d7-8e8d-71ef83c3aa45@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dne 19. 05. 25 v 13:07 Yu Kuai napsal(a):
> Hi,
> 
> 在 2025/05/19 18:45, Zdenek Kabelac 写道:
>> Dne 19. 05. 25 v 12:10 Mikulas Patocka napsal(a):
>>> On Mon, 19 May 2025, Yu Kuai wrote:
>>>
>>>> Hi,
>>>>
>>>> 在 2025/05/19 9:11, Yu Kuai 写道:
>>>>> Hi,
>>>>>
>>>>> 在 2025/05/17 0:00, Mikulas Patocka 写道:
>>>>>> Hi
>>>>>>
>>>>>> The commit e879a0d9cb086c8e52ce6c04e5bfa63825a6213c breaks the test
>>>>>> shell/lvcreate-large-raid.sh in the lvm2 testsuite.
>>>>>>
>>>>>> The breakage is caused by removing the line "read_bio->bi_opf = op |
>>>>>> do_sync;"
>>>>>>
>>>> Do I need some special setup to run this test? I got following
>>>> result in my VM, and I don't understand why it failed.
>>>>
>>>> Ask Zdenek Kabelac - he is expert in the testsuite.
>>>>
>>>> Mikulas
>>
>>
>> Hi
>>
>>
>> Lvm2 test suite is creating 'virtual' disk setup - it usually tries first 
>> build something with 'brd' - if this device is 'in-use' it fallback to 
>> create some files in LVM_TEST_DIR.
>>
>> This dir however must allow creation of device - by default nowdays /dev/shm 
>> & /tmp are mounted with  'nodev' mount option.
>>
>> So a dir which does allow dev creation must be passed to the test - so 
>> either remount dir without 'nodev' or set LVM_TEST_DIR to the filesystem 
>> which allows creation of devices.
> 
> Yes, I know that, and I set LVM_TEST_DIR to a new mounted nvme, as use
> can see in the attached log:
> 
> [ 0:02.335] ## DF_H:    /dev/nvme0n1     98G   64K   93G   1% /mnt/test

Hi

Please  check the output of 'mount' command whether your mount point /mnt/test
allows creation of devices  (i.e. does not use 'nodev' as setting for this 
mountpoint)


> 
>>
>> In 'lvm2/test'   run  'make help'  to see all possible settings - useful one 
>> could be LVM_TEST_AUX_TRACE  to expose shell traces from test internals - 
>> helps with debugging...
> The log do have shell trace, I think, it stoped here, I just don't know
> why :(
> 
> [ 0:01.709] ## - /root/lvm2/test/shell/lvcreate-large-raid.sh:31
> [ 0:01.710] ## 1 STACKTRACE() called from /root/lvm2/test/shell/lvcreate- 
> large-raid.sh:31
> 


Run:

   'make check_local T=lvcreate-large-raid LVM_TEST_AUX_TRACE=1  VERBOSE=1'

for more closer look why it is failing when preparing devices.
My best guess is the use of 'nodev' flag   (thus mount with '-o dev')


Regards

Zdenek

