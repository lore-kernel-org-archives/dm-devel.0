Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACDB534D4DE
	for <dm-devel@lists.linux.dev>; Sun, 11 Jan 2026 18:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768155785; cv=none; b=qtiP/XvX5GNvse4+pgpViXfKHKA5BYyTOQ8DWXMHMAgTE49544vtsMHcTWrtsm6y2S1Q+HbGg8pYAtbGo1uaxMtlJd6n222vKMBeIJJlHL9IHDsl0xBvYQVXsrSg383TfsnmTJ6cxPnJ/nS0ZIhN4/34JFAeaP0D+SuoVe6p+SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768155785; c=relaxed/simple;
	bh=SnwaiHCmqUH+ThTYQxcxdzfWtUEfHeHk57UGWE2uAUY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dHBhckBySA+o58nl5PR0aRttkEtQlch+GAIiykOUdFSW8kxUNf3VxAs3OwOW/j5czKFhWZeLyYCQ45g4LEZmeZjR976dyaik6IqJ6ZaTLem4CXvHl9daK9x/IvQRCtbc5ZBj1C2J1xMT37JSz6re+DSBh0+573fCO4P9JuKff2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m+Cb8v/j; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m+Cb8v/j"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-64ba74e6892so9450703a12.2
        for <dm-devel@lists.linux.dev>; Sun, 11 Jan 2026 10:23:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768155780; x=1768760580; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2DqjL9iPU0YPOMHkaYCAM/wqYqoZukVHNqOaH8JVc1M=;
        b=m+Cb8v/j6OPX6ZA7RXjK50C8yikG4DDGrRp40yoKby3QkRU+i2JBQikEANf08M3YLH
         x8ydGghPm4jpn/izaqdBDN0vTItV2J41VRKaVMw3ur9k98pl+0VLcOoiFMGQAr4yJAup
         PxB8Ww6MsvEhgw+L+MuE6oOxAypvOlP4NaDXcsmyDCjVKoz5LBC7wVgFSvAgvfYjCGkY
         uBasdjXqkRT2wtBUMqK3NCY5gAfL9q2Db8s53JFDzziRTuN+FJH80qy5WJnq9UoyPb5r
         V/7BSU9rxeN8u/oolixpExaBGszlJpUlY3tKhtht4d0CxM/Tk6gWETfNHfvlyYa811RR
         1NPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768155780; x=1768760580;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2DqjL9iPU0YPOMHkaYCAM/wqYqoZukVHNqOaH8JVc1M=;
        b=tCF9uQPESIer42UqfsAJmXW53vkJ3P0SFjnbo3E2zq2ShrNApkY602J3d0606rh/jd
         SAu8g0Aw+EAW5yAFt65ixtkrzfuYV9fQNtP9t/Fon/GBJI6Yi5jbclBsHc6T41jYWLuK
         /4c5q9bDbJZqn1f4FDnyXVwjZRsc6M6o0fzX6RBuLVJRMS/QwC/7KYzwPO/EFjqJay4f
         qUkR26/tSgnp0JpNNmBR01WFxzoLOSLdTb66mE9cKeBLdwE1rKWf91z0OcNntsTEOEdS
         HRM/cr5oHKt9QJPd/6+7iAbtb7MPLHEfhiRMLGFLf/323GHVblSFj7xuEZATF5D2t59Z
         9i1g==
X-Gm-Message-State: AOJu0Yx3Ei0HF8eCOY1mwbgLNra4ahL0qjwrDN6r/cGwgt5bNTBagdxU
	Yy3AdZYp62W/fJPaoYv71txNUcKmDgVLjpUmGytyw9BzO3KW6YKoDRSKQ4OASJgX
X-Gm-Gg: AY/fxX41W6u2616UTv4rgbKcImywDiQCIP5SQ5jxV9FLmWDQUwVTcz7GAmkJH6FMw0u
	0YDuszb+rdxD/q+dZAJRpVRTN/lbZxY14g9+TlC5usvDqMggn2rGY43W8ySVJxOSfhbO1QuiqDW
	CwcA9/qXnbuF0HtERqHw0QespeeH3zbJRXXW9PGE0QG3xcPhqzw5+TXdkAWb56qkPoUPd36RCTs
	MiHWvBLsdBIjF0ZUPMJSCYCYzdm3f4CYiGUajX26yTGNZoixvBHOgNBU/YVOkATpqJFnioIX20j
	DP4BNuMIE/YUP7ftArpNYkYQwSaIiikqE69dLqM0/s6wVMQ/r3tu/PjMrLOIP/fX5qFDDfLDMY5
	d18Ua2LkCtX8pXKd1Msw527yeqYpItaoNeELD8AtWwgYO3Dy0hM3W6T3rlu9Zlr/gYj0HRP0OpQ
	qU5jrLvcsF6lCnZ3IgiPQIsK/GVC7eotZ4CQDi
X-Google-Smtp-Source: AGHT+IErmOLDSUDRok0P28BEFhg8Wmu9WFpeWbTYcfKq/9s4Ip/jwnWXQEjtvzQCwypCHCyq8hEXfw==
X-Received: by 2002:a05:6402:26cc:b0:64d:498b:aeff with SMTP id 4fb4d7f45d1cf-65097e8e49bmr14305139a12.34.1768155779929;
        Sun, 11 Jan 2026 10:22:59 -0800 (PST)
Received: from [10.137.0.14] ([146.70.124.156])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6507bf65ca0sm15183442a12.24.2026.01.11.10.22.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Jan 2026 10:22:59 -0800 (PST)
Message-ID: <ab453cd5-4dca-4592-b037-3c8c21a3de22@gmail.com>
Date: Sun, 11 Jan 2026 20:22:58 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFQ] dm-steg : a deniable encryption module
To: "Bryn M. Reeves" <bmr@redhat.com>
Cc: dm-devel@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 =?UTF-8?Q?Marek_Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>
References: <022d700d-d3d8-4ef9-8d7b-505f7df89354@gmail.com>
 <aVvRLOlL4YF9sN0R@redhat.com>
Content-Language: en-US
From: Leo Samulis <anagon@gmail.com>
In-Reply-To: <aVvRLOlL4YF9sN0R@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/5/26 4:56 PM, Bryn M. Reeves wrote:
> On Tue, Dec 23, 2025 at 01:35:38AM +0800, Leo Samulis wrote:
>> I'm Leo, the author of dm-steg ( https://dmsteg.sourceforge.net/Steg.pdf ),
>> a deniable encryption module for device mapper. It was working nicely in
>> 2011 but I got caught up in life and never updated it.
>>
>> What would need to be done for it to be accepted into mainline device
>> mapper?
> Short answer, it will need updating if there are changes to any of the
> kernel or device-mapper APIs it uses (which is likely after that length
> of time). I've had a look at the code in the git repo and it seems
> fairly reasonable from a quick scan.
>
> Things like DMWARN("u wot m8?") definitely need cleaning up before it
> would be acceptable upstream.
>
> The docs should be reformatted as RST in the style of the existing DM
> docs under Documentation/admin-guide/device-mapper.
>
>> Would I simply need to update the code, get it working reliably, and then
>> submit a patch? Or would the specification and use of crypto primitives also
>> need to pass a separate cryptography exam?
> That should be enough to at least start an RFC thread. There may well be
> questions about the crypto and where it belongs (the module is on the
> larger side for a DM target, but still smaller than crypt/thin, and
> sxts.c will probably raise some questions), userspace interface, docs,
> tooling etc. but if you're willing to put the time in to modernise it
> that should be enough to get a discussion going.
>
> Regards,
> Bryn.
>
Hi Bryn,

Don't worry, I am expecting quite a lot of changes after 14 years :-D

Noted about docs reformatting.

Re: sxtc.c : it's a cryptographically valid optimization, but I agree it 
would be more acceptable to use AES-XTS.

Thanks for skimming the code - yeah, I'll definitely get it polished 
before I submit. At the moment, I'm just feeling out how difficult it's 
going to be to get it accepted into mainstream and whether it's an easy 
thing to do without getting bogged down in politics.

Thanks,

- Leo

