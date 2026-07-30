Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F0E44C4EA
	for <dm-devel@lists.linux.dev>; Thu, 30 Jul 2026 16:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428541; cv=none; b=T+RYu1B+3XHkhljlKW+75L5jOqPQ0F0xv+2LEAl/oy4iAD3zBcTpCngOh0lH1+L9vm3gY0cLmnK5+hbVu4m1c6x8zE9V5RwXnreCFGOKbyfp8HUNhNuvyQQtdPNQOPJbI4MNlSj1NxvEdV3vbgFKJKW5CDe/m0vpTm9jhCKKHXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428541; c=relaxed/simple;
	bh=LzrA83SNg0xwZHckZyesHpd9prkk7E8+AsPKLw0gsqQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hD8xttqtWhlDzYmk8V3i+0sJpPU1UvVmcKpAPgihbXpD5Glrbi8GEBOsPz2Qg7UtQYQSLp81OdlAHXmo72aIOKmrv09VIr0GCdTAxN5srTU1YWP/HG+BYrM3iAt5Otyv4Xre8kcmmJHAMDSezSKIoH9K01JwYCRrEFvyfSzRPDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=oeN1Yf36; arc=none smtp.client-ip=209.85.160.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="oeN1Yf36"
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-458de93b53fso31250fac.2
        for <dm-devel@lists.linux.dev>; Thu, 30 Jul 2026 09:22:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1785428538; x=1786033338; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2TO7rhJEb0t2mz700nvgDIByTqbVS2Yz6f37I4sh7O8=;
        b=oeN1Yf36kEhrrWIHGbUjBV2+eIOQVdifYUj49zh2Ju9LChTUicEbY88Cfj2HwtxpgU
         YQKYItF2eK76v0NXHk/Hylg0nxbKpk1dfdqYhwvycgMpXCVJiPbx3X/k9uenIzBsnzwL
         vFh+GT59cZ7KGCfV0dhAUP8kXwyFgVrASUxOyDxK6pk/IKuDWeHFlVXR8IZYd+AGTBJe
         5bzZJouMfta5C4F6VklXn9m8y6lYlTGlE7ppF7DS2BQBtpyPbofzDSnse8qdI+ULFYKO
         c70Zzt1zok7nGDpd4o5tP99b2o8kfyDO88n+u0FUjn5OmQIwUfaM6yfi3JqQmTE2YNpP
         ASwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785428538; x=1786033338;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2TO7rhJEb0t2mz700nvgDIByTqbVS2Yz6f37I4sh7O8=;
        b=RP6LfNV6jRtqpN/gAfT8H7P/cpbWay2VzB8hoT5J/YgvcsOa7IqRRzFlT+PmjAfdf/
         6lud6Njdy6hOomXrV4BA5wTrfpcWTirg33/AdvgX3khhx9B7pKs/+6wnmwv+ks4x88TE
         RYofg9r3hySfJMUFOZDOM13usoUpEHq7eED1juRTe3Gpr7Xl5dH2PMMNK0YKzhHR5Ykz
         zv17swAZanvlesT85FWtiDL+MXXmDMjz/75M3hyT8Pj7pAtBhIoaNgNie7QiNqSk/hDL
         hw/2lXfYXRAGePQ4PQ9scDRC/uS99adZnnMEuJ3+t8vLb5wyem6ZCBJ84gMgHIaFotIZ
         z3Lw==
X-Forwarded-Encrypted: i=1; AHgh+Rqv5SNeJpI2/M0jujDDurNa5kSMaeNG+3a02jHVNpSjFZSQEm+1jWL90EYpLiegD/F6uQ9aEkADkw==@lists.linux.dev
X-Gm-Message-State: AOJu0YxbYZStqdbucXLv9MW79oczZIJ9h2KV0DjUOHtLK+kJk1xVYEtu
	HIeFPNoztvgnCnH3mOHQdEAKi3XmJcWbakQ+6baLn2ZXUYJfmemxdles2iHNPfeHCBo=
X-Gm-Gg: AR+sD13qbndWRAlIBV8pJg5jMjK9fxL4f5xzTZbtgAL7ZRtxIaPr0RX0K7h6cStcRGv
	uyaPSd0wWuMIPBuFJLF1FUY5nsG5b5bc0fMZvIlpU+9FopkdTXOv3ZUECHW40VBKWEp67R7hB9/
	6lWALFZ7MTmyNfSrwZTHlP0PuzbzS+hOtrfP9whGgMixG3opEL8xGd6wqbqWF3TeQEcsLF5w2By
	f3i9cyxUAVepI6CQ3QYvOltr5YKgXoqW8o9lXqvJzTCjXlFZhfUEb/WV5bHT/VFnhX6WM31ZHsI
	yaDTLJ+tWURLl2cKKi9uFEnfYNUioE0JFOsAIgBNdFu6WMHYAJRJfX8xk2lsU6lq6tvBmyK3uGg
	kZrsQVah2sKDUBGGzi/mOD0kCqXP8MSPZ/zZ9xmljSpEP5bVH14hGeDzG8Ndgeei5VR0238ac7d
	30wprchL69JgKh9z4NXiNP4NZ4rfSO603023IWBTsfzgUO+8YkKv2smu1LlHFdtstUCN+jEe2cZ
	NtQnTfxnOpc8RSNE66gaSHQg9B6hflFoFAGHABt+RktApSYF9oqczpt
X-Received: by 2002:a05:6870:d361:b0:456:4c3f:7e03 with SMTP id 586e51a60fabf-458c0e12897mr2206023fac.18.1785428537794;
        Thu, 30 Jul 2026 09:22:17 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-458c257c4d0sm2482546fac.2.2026.07.30.09.22.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2026 09:22:17 -0700 (PDT)
Message-ID: <e85ec957-d648-4d6a-bcfe-09dd2d21d090@kernel.dk>
Date: Thu, 30 Jul 2026 10:22:15 -0600
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND 0/5] block: validate direct I/O memory alignment
To: Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, dm-devel@lists.linux.dev, brauner@kernel.org,
 djwong@kernel.org, viro@zeniv.linux.org.uk, regressions@lists.linux.dev,
 torvalds@linux-foundation.org
References: <20260720201057.1862857-1-kbusch@meta.com>
 <ampRQyXDbGgeg49V@kbusch-mbp>
 <fbe9e74d-c389-46f4-9874-3e9ffd9c91d3@kernel.dk>
 <ampce7mxSmxAwAiu@kbusch-mbp> <20260730112626.GA24827@lst.de>
 <amtJDCtczVyX1baB@kbusch-mbp>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <amtJDCtczVyX1baB@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/30/26 6:52 AM, Keith Busch wrote:
> On Thu, Jul 30, 2026 at 01:26:26PM +0200, Christoph Hellwig wrote:
>> On Wed, Jul 29, 2026 at 02:03:07PM -0600, Keith Busch wrote:
>>>>> Hi Jens, have you had a chance to look at this one yet? This addresses
>>>>> previous issues with certain device mappers under direct io.
>>>>
>>>> I they look fine, but at this point we should toss them into 7.3. Yes
>>>> I know there are regressions around this, but from 6.1x days. And the
>>>> series doesn't apply to the current block-7.2 anyway.
>>>
>>> This series is kind of old at this point, but yes, it's not fixing a new
>>> regression either. I'm okay if this goes to the next window, and I will
>>> handle the stable follow-up.
>>
>> Honestly, I think that'a a reall bad idea.  This is a regression in 6.18,
>> and while it took a while for people to hit this with their a little
>> more complicated lvm/md setups, it has stopped real systems from being
>> used.  We need to fix this ASAP.
> 
> This should have gone in several weeks ago, IMO. You can most readily
> hit a problem running qemu against one of those lvm setups. We're just
> so late in this release cycle that I'm not pushing hard for 7.2, but I
> would support that choice too.

Exactly, it's been floating for a bit, and the last week is surely on
me. But merging at the time it was posted would've been late for fairly
substantial changes.

Hence why I think 7.3 is just the better choice. We're talking weeks in
difference on when it gets to stable anyway, which is what matters.

-- 
Jens Axboe
