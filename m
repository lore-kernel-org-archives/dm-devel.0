Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB2A41E130F
	for <dm-devel@lists.linux.dev>; Thu, 24 Oct 2024 14:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729778740; cv=none; b=EjXnxJUPCmccl0z9C3YoAaSIDMVqiNB0ktW28RGbYYlCuZoiL9sXtXcuPyzXXz7Sr8+IChcj0uCAWIOMQjpkH1wMIOpg3NVN48OQtJlGBQ4+10UbcvKR8mwxpsicT3VZtvVTdxXU4wNcilaJDBQ//kdskKOCfgEbYVpl3yPuM7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729778740; c=relaxed/simple;
	bh=S3lPUHZxZcitD5vGldNcH8q1olxAVdARqDvzLDhUyfU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V9jGLpnAxsEeoLXdXmfJlNpDkjQUopzx7BbBd0U1IbRxR4AeL9bCPLNJpztJugNP9lYsDxpn8TU01UgCQje9G3Ymp/YThqRci/T0dY/0Ss7RgWzQQAEy1jm4zzArF1TRD54cs1+j35RPPdWU2PqnR5djUArrRnBiXGYpwH5CbV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JeJYH9u6; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JeJYH9u6"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-43158625112so9911055e9.3
        for <dm-devel@lists.linux.dev>; Thu, 24 Oct 2024 07:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729778736; x=1730383536; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LSr0bR4jeW/qu6kyO0At8mOuFzxheAiGNDGN+HknWVI=;
        b=JeJYH9u6/Jw8kFwPopXGV/IFzgjNCD/BsdOBCoBLtfEuv19g7XEzg4tLNxV2lDNtdG
         iOe7PcfySfHwqgLW5qU2NxK279qcVzNtCaZY9nXOLQfIU2unS2vq4RiPGkTQtT8c50gU
         Eo1hVcRXpmMQM/Haqjb02UyP/jgThZowfyE/Kt7v7F1FeY4r3t655a7wwQLWGLYCKQX7
         rqthsRh9ictlzyTCmxEoIpRSb+Uzw7Rsos4oG9eh/gJJax6Gfxvc7vaVFphkvmc9Sylu
         AbXDGsVRG++Q3CK50vm6TjR9cSBSnOpnBe+dcYjzXBq2GhJwrWFnwmCiAtEXySD1t5wv
         du7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729778736; x=1730383536;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LSr0bR4jeW/qu6kyO0At8mOuFzxheAiGNDGN+HknWVI=;
        b=eY9XwIcjt0at6HpjkUej+E4irnCDK682DnUNAJr1EGpHk3ZCJ22rTLCxz+BukIgP+G
         6JowkjMHzdNfR/48IspZYAhj53igJlLYTOvltgWijqAX4ykamDImgjhaSv2BtFaV5ovM
         Qzc4S5e5Ew+TCbtfhEX/gXaE5vJsaBphvGoLR4u1NzieNu1tBkUELjvLqzokf1BpSySA
         LDs3F7I0zNs89Q/u/Fi104oVvcYgmQK5H/YKsjqnBcHLCjWMnuwo7xb6KgSBkZGBt5Eq
         ze9WfkX+N/JBQ5EBorL+dkwjP3Y+risZ8z9Cazn/tRLDSevEM1f0jKJzlUEDo1IMzYp3
         irNw==
X-Forwarded-Encrypted: i=1; AJvYcCVdPvWIMXDQhkUy76dB6l+akRajRiEbOrQqR6FuIK0rhAjtFMxE3IW9TrfhRJ79Mi6L8ltRXuCNow==@lists.linux.dev
X-Gm-Message-State: AOJu0YzMwyYMYSoo1C0lcNhQqkagoqGxQFct3WEwVIGyNAitg6f4AaFx
	6k/o6UBrOtHktSYVxPaWt3I3f7fGPxNM2siWr+2Eb6FnpbatSJMcsjn53w==
X-Google-Smtp-Source: AGHT+IGSFO1aZ78o1YBUyhJmGM3h2q+RJq7aOXte960dZQYLamOXgiV21UZq3FsDxN0JL9SBebA+lg==
X-Received: by 2002:a05:600c:5802:b0:431:5f8c:ccbd with SMTP id 5b1f17b1804b1-431841ee182mr47961375e9.4.1729778735662;
        Thu, 24 Oct 2024 07:05:35 -0700 (PDT)
Received: from [192.168.1.248] ([194.120.133.34])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-43186bd693fsm49008385e9.2.2024.10.24.07.05.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2024 07:05:35 -0700 (PDT)
Message-ID: <363880be-dfa3-4cfc-8d7d-613092c36dd0@gmail.com>
Date: Thu, 24 Oct 2024 15:05:34 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH][next] dm ioctl: rate limit a couple of ioctl based error
 messages
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20241024110431.1906858-1-colin.i.king@gmail.com>
 <51915860-4a32-b563-c000-d64e1df6702d@redhat.com>
Content-Language: en-US
From: "Colin King (gmail)" <colin.i.king@gmail.com>
In-Reply-To: <51915860-4a32-b563-c000-d64e1df6702d@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 24/10/2024 15:01, Mikulas Patocka wrote:
> Hi
> 
> I'd like to ask - have you experienced these errors? What was the process
> that triggered them? Was it some robot that tests syscalls with random
> parameters?

I hit this when running stress-ng's dev test, this exercises various 
ioctls for race conditions.  It's not a major issue, just a corner case 
found when I was running some stress tests.

Colin

> 
> Mikulas
> 
> 
> On Thu, 24 Oct 2024, Colin Ian King wrote:
> 
>> It is possible to spam the kernel log with a misbehaving user process that
>> is passing incorrect dm ioctls to /dev/mapper/control. Use a rate limit
>> on these error messages to reduce the noise.
>>
>> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
>> ---
>>   drivers/md/dm-ioctl.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
>> index f299ff393a6a..d42eac944eb5 100644
>> --- a/drivers/md/dm-ioctl.c
>> +++ b/drivers/md/dm-ioctl.c
>> @@ -1912,7 +1912,7 @@ static int check_version(unsigned int cmd, struct dm_ioctl __user *user,
>>   
>>   	if ((kernel_params->version[0] != DM_VERSION_MAJOR) ||
>>   	    (kernel_params->version[1] > DM_VERSION_MINOR)) {
>> -		DMERR("ioctl interface mismatch: kernel(%u.%u.%u), user(%u.%u.%u), cmd(%d)",
>> +		DMERR_LIMIT("ioctl interface mismatch: kernel(%u.%u.%u), user(%u.%u.%u), cmd(%d)",
>>   		      DM_VERSION_MAJOR, DM_VERSION_MINOR,
>>   		      DM_VERSION_PATCHLEVEL,
>>   		      kernel_params->version[0],
>> @@ -1961,7 +1961,7 @@ static int copy_params(struct dm_ioctl __user *user, struct dm_ioctl *param_kern
>>   
>>   	if (unlikely(param_kernel->data_size < minimum_data_size) ||
>>   	    unlikely(param_kernel->data_size > DM_MAX_TARGETS * DM_MAX_TARGET_PARAMS)) {
>> -		DMERR("Invalid data size in the ioctl structure: %u",
>> +		DMERR_LIMIT("Invalid data size in the ioctl structure: %u",
>>   		      param_kernel->data_size);
>>   		return -EINVAL;
>>   	}
>> -- 
>> 2.39.5
>>
> 

