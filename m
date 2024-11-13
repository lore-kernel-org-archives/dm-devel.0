Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D0216DEB4
	for <dm-devel@lists.linux.dev>; Wed, 13 Nov 2024 10:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731495548; cv=none; b=fHV05lq9TxncyKdeTsmjN5f+JSna5F64tgLgiWUufO/Jl9mpFdBEpt188GBfTK9g92X1S58DBnh7ZQLFdP2o0nXaKRfsr4sx7C0d2pChlO8L7IYOgOqaa4SNZL3u8tFU1FkkEp7HPKhm5vYcNot/bY9Gh4E6BcwZSZzdh0pGTVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731495548; c=relaxed/simple;
	bh=Lck+cAj4eHDT7/cZStFv9s6pk5MGdeg9MG8q5T0QVF8=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:References:
	 In-Reply-To:Content-Type; b=kRj9M8+AlLsonY5fkVzVJdw6s+3y2VkZ7QorXpgcBfk25dRBLSmY5XTs8MjVWInVJoVQlqya4+M4GMkhrd/EJkG9Yi84TRdYftMhvYhAajevrwTVfiPea4kSAwAxn9JImgyoOZKiBKnXZpI2fBLbheF1ktU5/MqiDmNM4wyqzTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CH9trQJf; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CH9trQJf"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4315baa51d8so59222835e9.0
        for <dm-devel@lists.linux.dev>; Wed, 13 Nov 2024 02:59:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731495545; x=1732100345; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:subject:user-agent:mime-version:date:message-id:from:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BAmilerga4pcTHJ+7bs8yOEZmrgLYV3C6K/NENv1sSE=;
        b=CH9trQJfY10/QK9HiFNtDU2LBn/FVxYi9OXzuhtfFUWUwhzSjLbcwX7TH1UajqZUb3
         Ws2XzoSBBZmY4kHktvO/y9eg5Rica4SYmDL1f3khoJT5PfZdzYeGvu0Zdko60pWgYUcF
         hS3WoTa9tkjZOwowqcfb9nBWJTL9E4x/k5zmscU1oGJFgkOsKoqFFCXjUXwERvofmltf
         Q8khxyO6/fLpSQYy7of+kGhmug/Jtk2qLRFygg5kK3PDRKDDsO+azMLJKKhFYULmFG1p
         I8D+ivbRt6ndH7xfZ7/fn49jjpMChUUCLo6Ia/OcUVQIamcom4HNQULCC6RtfdJtRsSK
         QCEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731495545; x=1732100345;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:subject:user-agent:mime-version:date:message-id:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BAmilerga4pcTHJ+7bs8yOEZmrgLYV3C6K/NENv1sSE=;
        b=u8ABjNlU9Nc2iFXlbArfmMR2UXcStxIk6jVahU/644Shtxf4d5Rt2pA+zN6A14bA5h
         m71keVXJJiSi15ERFzbYqC+DWPJR+qagglLFenG5tAAtyWY5byobC/r1Wx50XFvHnZUL
         K9Cv8fJtIMHLDw9Aip1qul6NeqspaqPG6UErtPty1Wh/SjVfGlWaiZejq2/gtdG8bsro
         AeZj3LsM2wmsYw1YF/2PLgsAodKtHrDEo8DduZaKzGKH4nVo2qE6qwxY7DkyPLwLPqf6
         mvN4n+PPr0UFTc+JyNhFLK2+qv9BLz/ssY60J/v3cgx7A1/nuD6NZWukzO84llopkWj4
         OAzA==
X-Forwarded-Encrypted: i=1; AJvYcCWiiSND7YnCWs5uGKf+HK8uHvb+zXtALmTnNCj8PbzSGnyfHGeAj6rt8zWr2SLzxMxpL4abUTvZMg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy7SzToQeqvmJt0ZNMgNk2xFpaZkRv2z4QAvylv3cabDUP/JxlL
	VHWOBuuM4l+p1sCXm7WT4pQBrVajT4prfAmdSAGrbMP/oER0rd06lTfrKY6O
X-Google-Smtp-Source: AGHT+IEMeykgBVt2BGDLyzXzmISy9QRmGh5fZ1s5ePxuCtRl9/6ZvdH+zRezTrCC2c5fMprYPBUs/A==
X-Received: by 2002:a05:600c:5008:b0:42c:b9c7:f54b with SMTP id 5b1f17b1804b1-432d4ab926bmr26176165e9.16.1731495544441;
        Wed, 13 Nov 2024 02:59:04 -0800 (PST)
Received: from ?IPV6:2a03:a900:1000:7e9:403e:7c8b:351b:f333? ([2a03:a900:1000:7e9:403e:7c8b:351b:f333])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432d48bb442sm17054215e9.1.2024.11.13.02.59.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Nov 2024 02:59:04 -0800 (PST)
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
X-Google-Original-From: Zdenek Kabelac <zkabelac@redhat.com>
Message-ID: <687e5f5d-b763-4255-afed-8adc4e1df0be@redhat.com>
Date: Wed, 13 Nov 2024 11:59:02 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Copy on Read
To: Shao Miller <device.mapper@synthetel.com>, dm-devel@lists.linux.dev
References: <db1f26b55bd68277b0944179dd11b298@synthetel.com>
Content-Language: en-US, cs
In-Reply-To: <db1f26b55bd68277b0944179dd11b298@synthetel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dne 12. 11. 24 v 20:40 Shao Miller napsal(a):
> Good day, Device Mapper Folks.
>
> In the format of an X Y Problem:
>
> [Almost] Real goal (X): I would like to read storage-blocks locally from a 
> far-away (remote, high latency) source and keep costs (for local storage, 
> for network-traffic) to a minimum.  95% of the remote source will never be 
> read and 5% will be read frequently.  If I read a storage-block 1,000,000 
> times over 10 years, ideally it should only traverse the network once during 
> that time.
>
> There is no mention of writes, so far.
>
> Sub-goal (Y): Identify whether or not there is a device-mapper target with 
> copy-on-read, read-only behaviour.  This seems like it could be useful in 
> certain forensic situations in which "accesses" ought to be recorded.  "We" 
> (device-mapper users) have the "write half" of "accesses" covered, already, 
> with snapshots.
>
> dm-cache might work out, except that it appears to've been designed with 
> considerations for writes, which are irrelevant to the goal(s).
>

Hi

dm-cache should be likely your 'favorite'  since it's designed to handle 
different policies - for some reason not too many policies were ever written 
(maybe existing one is good enough for most to bother), but the idea behind 
was to be modular and handle different need of users - if they simply 'know 
more' upfront then the current  'heuristic' smq policy might ever learn from 
observing  IO traffic within cached device.

So I'd highly recommend to read about those policies and eventually write a 
better one for you specific case (like instantly promote any blocks until 
cache is 100% full)

Although you should probably try to use the existing one first -and you might 
be surprised how good it will get over the time in picking your hot spots of 
your disks - although there might be some 'extra' reads from your origin 
device before the cache considers a block to be 'promoted' to cache.

As for your 'write' concerns - they are actually irrelevant itself - since if 
there is no write - there is no need to maintain the place for it....

Regards


Zdenek

