Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 238B3322B89
	for <dm-devel@lists.linux.dev>; Sun, 11 Jan 2026 13:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768138468; cv=none; b=XFSrRm6ez3e/xWYOXCH6g44xC4yAj8QfWmlvBZM81x5vvuptAQNBjgSsnoknxoHWT40pSz01VeXoI57TOFAJOOe/fj4sZT9ybnucmO0HEPzpOxELcp/E5/l7p5Vyn2B3Ab3vlG0Kx2yetd3GxjX8esm9991lFaW3Thfd+yRZT4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768138468; c=relaxed/simple;
	bh=+fWdVbBVS+5ZieHGAy8VJ46GImYkPTn95DEhd287x7k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WAc2GYXxjJU37FK5U9SBVkvl/YKd0HqwzOZWtT35MlY8AHXSHlGVdvGpRlY003V+pHMNtlQhZm/0tEawCSLlQCKVgHkfbspmj0z8hEDZj9tuKinbFqeSyGLsymwbrUMF8gAwrNsz6N9QM+uXNS0V/omU/glxLLfSYLhT/c1av1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HO0If3Vd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HO0If3Vd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768138466;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1iIwW7B3/vGlG96EY9fov8v0A5KtPeBu8NxLAHkqFGo=;
	b=HO0If3VdBsdIm9YJ+dI7KNiRsRFVj84KcCRnk/70Nb5rO3kei0oZur5cbQAS+UE1yE+S8w
	KVu3io4oMMpacChFCVPcsZrA2s2Cr1a9FgRLJUlXsSJJ2Vvj4fC9Owztza6eZrm3Ih59hK
	btq0mOvJZPkjc1DE70MGiC9+Asi8wVw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-497-sJ8qnvplOvq0M4pMXKmRnA-1; Sun, 11 Jan 2026 08:34:24 -0500
X-MC-Unique: sJ8qnvplOvq0M4pMXKmRnA-1
X-Mimecast-MFC-AGG-ID: sJ8qnvplOvq0M4pMXKmRnA_1768138464
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-430fcb6b2ebso3507006f8f.2
        for <dm-devel@lists.linux.dev>; Sun, 11 Jan 2026 05:34:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768138463; x=1768743263;
        h=content-transfer-encoding:in-reply-to:organization:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1iIwW7B3/vGlG96EY9fov8v0A5KtPeBu8NxLAHkqFGo=;
        b=feAA1S+EE8LMk7iG8Knl8UBFnD1V2twXNHmyNmZXhjhWEc8S/zmPINn9mtl3p67/kY
         BYra1VsaA+xeMTkBBsTFubR4GtUhfa2XmEeq2uQPDvUdF5KxxuIl+pA/5v2SmTsgnSvZ
         nVlftb+sSx0rVgLF/1/dqoHJdjxcFW+M2R4ratJrRCM2P+29pjyQ6CxIyP7aBJH5HK2q
         W2eWNXFP9gVJ+PgS6R8478DwAxRBp3Fh5ik7ySVFif/Z6b0Br1/zTtQQNc5Ybj/x82uG
         lr+emzFIPrM5dcmb9Ds1MyBtaYfXMrypSNwHE22jxFC+hs5zTWIArU/J8OAyrVXMYVW4
         LtlA==
X-Forwarded-Encrypted: i=1; AJvYcCVw/gk7j8vBYvj/5HKQGnziwGKpUgvMypJU+1lFOrR4xAI0rOl6lchN+EipouaTenPeYw/XktDKlQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YxtbkPRHF3XqC7X2niI+u0OYEH4JE+1dpLRWoBaYrwBOjfbThQV
	BtnZmU1ygwV1ULPWatXOIWt2KAIRFARzNvydL9rKGyeWAlurYZvf1KMkpiuPjmWufP2sjKKTEbo
	CqUT6qQrlve6HDCdSWUBQeW1F2mdEoVyyWK4Y6f20lnWD3mQj86xdP2/H6Xaq
X-Gm-Gg: AY/fxX5Km/cVD96/C8CovdBZjXTMpkol/AX6EktNq7CbOq/X8KH4ncxUwJZqxUDPind
	BeulO8dDrDfVdH7ysadsC5H0odERfL+tUMNudkeA6Q/1BRRK2PEVL+8xAVOSfDvLf+ahV7B23F1
	s3feiiLW6BsHg/YP6BkeWuKOvUxSp7a1Zoprz2K6JALg5UjnBovl68kIhYYnQg9Oy1l13VwSOCt
	La1muH9wjuNg9V7w7HrC3w8KfIhQp33vlDGO5wS5ihzws3yTm0iFPpcqijX4Gq+Mb82vY5LZ7d8
	S0ltopaZ+pXcm/rAZxnEvKNjHkDmikdO9eYUk+5HenemgNtN35ly99eJtweGXahB6CK5S2qNDYo
	M0Hu6HGTKik42
X-Received: by 2002:a05:6000:18a5:b0:431:8f8:7f17 with SMTP id ffacd0b85a97d-432c362830dmr16282388f8f.10.1768138463553;
        Sun, 11 Jan 2026 05:34:23 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEUrdZET3rEay41v44TRADbajgxRdDNJp4A+SRYJqr3oi8KK+Jf1Lh89iqwj9E2Qa02SJMCbA==
X-Received: by 2002:a05:6000:18a5:b0:431:8f8:7f17 with SMTP id ffacd0b85a97d-432c362830dmr16282379f8f.10.1768138463142;
        Sun, 11 Jan 2026 05:34:23 -0800 (PST)
Received: from [192.168.0.99] ([212.20.115.16])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd0dacdcsm32760448f8f.1.2026.01.11.05.34.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Jan 2026 05:34:22 -0800 (PST)
Message-ID: <fc1d7900-3a5f-4b31-8aa3-8c8cd317d646@redhat.com>
Date: Sun, 11 Jan 2026 14:34:22 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Hard system lock-ups when using encrypted swap and RAM is
 exhausted
To: Askar Safin <safinaskar@gmail.com>, Mikulas Patocka <mpatocka@redhat.com>
Cc: adrelanos@whonix.org, arraybolt3@gmail.com, cryptsetup@lists.linux.dev,
 dm-devel@lists.linux.dev, gmazyland@gmail.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <3f3d871a-6a86-354f-f83d-a871793a4a47@redhat.com>
 <20251211182429.3300562-1-safinaskar@gmail.com>
 <eb3a9746-83a0-8271-6bd6-867ecfa49aad@redhat.com>
 <CAPnZJGAvA+SpkMeOdZx+SZG=qZxSXOThO+Or1bgw=3QqCoEDgw@mail.gmail.com>
From: Zdenek Kabelac <zkabelac@redhat.com>
Organization: RedHat
In-Reply-To: <CAPnZJGAvA+SpkMeOdZx+SZG=qZxSXOThO+Or1bgw=3QqCoEDgw@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Pmq0NSfIRpNSt9GElE5t6Agh766jP8MEe8WqSYwLGPw_1768138464
X-Mimecast-Originator: redhat.com
Content-Language: en-US, cs
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dne 10. 01. 26 v 8:09 Askar Safin napsal(a):
> On Fri, Jan 2, 2026 at 4:47 PM Mikulas Patocka <mpatocka@redhat.com> wrote:
>> Hi
>>
>> Dm integrity doesn't need to allocate memory when processing I/O requests
> 
> Thank you for answer!
> 
> Unfortunately, my experience shows the opposite thing.
> 
> [[ TL;DR: my experience shows that dm-integrity journaled mode is buggy, and
> non-journaled mode is not. I. e. journaled mode seems to allocate memory, and
> this causes temporary (for 4 minutes) lockups (on high specced
> machine). Or maybe journaled mode has
> some another bug, which causes such lockups. They are not reproducible in
> non-journaled mode. ]]


I think it's important to decipher what and how it's blocked - I kind of 
suspect your system is not blocked on 'dm-integrity' itself - rather some 
userland app being swapped out of CPU.

You probably do need to configure your systemd-oom killer to prevent getting 
your system to it's knees - if you run your system to the moment whether it 
takes 4 minutes to run a task - there is something seriously wrong with the 
configuration - as OOM is supposed to kill userland RAM hogging task much 
earlier (possibly even your overbloated google chrome APP if it run out of 
bounds).

So I think you should also show whole device tree of your system and some more 
information - so there is even 'remote' chance trying to reproduce your scenario.

Regards

Zdenek

