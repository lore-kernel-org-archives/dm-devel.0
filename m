Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71AC3932E0
	for <dm-devel@lists.linux.dev>; Thu, 30 Jul 2026 16:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428603; cv=none; b=K/MQFRthHaCC8iUYCEj6WfOULWTiZHrqbug29WDbqvRHELNe7Oso2gOD+PNAmqmmlnL/tSCNEve7uRlKYXQNTWAy5rjFdN3D22RuQ7FdoB5fTASNoF76hY4EAdEmgeHK+NcC7e69Jy05A7iTp95GqN9TMx5Q/+H5YSkmSa2c6Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428603; c=relaxed/simple;
	bh=JBBl12W5jAO3f1NQO9V6kLXpVGsPmJIXGnmgZPy1WWk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Benepq3SwD/r0h0NWGEBhmCYReUzzFo1P0p4h0ui5kyGJfsGunAokCFvRcw2a+7Ul+ywNAYvUc5fQipnOTxM2zPEPiLp5SGQq1NzSQm78RHeLXDznGc7UPwRouvdvDW1BVIaIv0E48dr03XRE6EuNJt1JabDgzzw6IamNux+iVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=ZDrVixqe; arc=none smtp.client-ip=209.85.210.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="ZDrVixqe"
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-7e6b554044fso40790a34.0
        for <dm-devel@lists.linux.dev>; Thu, 30 Jul 2026 09:23:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1785428600; x=1786033400; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+2vuxkBUmVJ6H+F0FBU1KBLH+mojm8weuh8i8FR4JAI=;
        b=ZDrVixqet6NAOMRWHYoAmF4CrUOQhf2Ilk2GfjJrZXqqnGt0zs+NtgV5Yxhb5HH96j
         0gXo6Ld5CnvvdG2Vb3o0w8Xtet6ohGq2bQM6MiTaeua+UGCD2ieCQ0UfRvfMcQVxStgW
         DGt2mqWLJHytSblwqC+a5U3DqpvByesW9lnS5bl2Uq3/E1ayAoV6AIbh9AXxRUGIYqwZ
         J9f3PH584XQVYAEraGBnVLlX8hs//K/tOxOaXjzXJzR5ZnnJjqD2p7bxAef8g0RHKUeY
         CgPCP7SqHFhyrikWk+nJtUoNMCux76CTcvhSAcoE9kBgxi8Te58yx6to2lh9Ceue9q+J
         qdHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785428600; x=1786033400;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+2vuxkBUmVJ6H+F0FBU1KBLH+mojm8weuh8i8FR4JAI=;
        b=hRKh4WQtkoFVxRUoxyIeLigXs2XORW3W4hX/OR4o5cX6KtAORj9qv80k5LCDNjJu0q
         OHswYB4mxMcKFIMK89EK4lzEDPeIqQdQEIVms+90yN9FPYCT1jtjNrttpzBKPFwrug6o
         e+NxykTaGlOICr9eas69VioheXknJR5vy+6XwSi/p07NrAERdzmIC41zrN1DIdzqBatD
         hpF92TUzdPBdZeY6aENfFvUD3Xv820XgW8wUneLzP9Mr2HmDVgUT6Gn1n3HuVaX6dkDz
         CzJEapyuZGeoSXnWQm2GA/BFQfx+Qj+ICd1rRlDGOCs+0ePzTp7myP8c/6jnZwC5rTxd
         0RBA==
X-Forwarded-Encrypted: i=1; AHgh+RoYo2fxGUDT0ws6Ve1LtbNJMjLyzPpSxG9lEneIaYp90rbfhNgXs17Lsf6Zziurkj5wjftMZgOtNg==@lists.linux.dev
X-Gm-Message-State: AOJu0YwXVGEGqQ1oxfg2N43MMPLoWN0S7Ufto4d7S9MgYYhh1eInVnu/
	UisMiLe8YKlSzcAWVEn5SqX9mbe29FgUNV+TW6eaYN8cMDpYMGf4JkfEbQtKOitH4F0=
X-Gm-Gg: AR+sD10iufTZ43F3ms9ftEgDQvRgx6SRZrF3G9CiVGe1vbWDkEfQDJkhwZ/8lUy0GXC
	1mnpAUsrcLYgN/TbYQRWZKSZ71TVed0dHKPJhY7Z7MdfRjute67f7dg+DHUiMIhz1JGGLCgUyMb
	Mp52hB9OBRRLp1vUL/75d8WHNQng43sHMQjEU47xko4PKMII3pn8xjqIpasD+1JbAo7dhvH6/dZ
	g4obbkw1ul5bxMlcBAg9v+BCSWpJUfBDd2Gm4b2hjFBETjjjFw2Amnf/Djy+8mm9RTsxlprodt2
	kZJZ3GsUw1TfTt8tgBMagIsfzVV3fiyPQ3yKC75SvoupgkTIXr3RuFmFWAZhOcaTsultOpSmTwA
	XI3opE5hb/eauRLAU+FWrKnV9KXXjY0slrWmXxPYSk3aiituCiodA++uqQ7Q+Eh8NyJ34lTcI77
	Ng9NuBj9rYY6F49x9dazAI46hhM9jFOxvE0xr0Pyn+IqJU6KklqkaH9Bgi76ZLzHvAIr5sYZjuP
	luJu3s8uKulSU/VJxcybFJ4nJmSFcZ0PlH09B4tK96svw==
X-Received: by 2002:a05:6808:1246:b0:4a4:e11c:7b56 with SMTP id 5614622812f47-4ad87782f6amr2123750b6e.8.1785428599570;
        Thu, 30 Jul 2026 09:23:19 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4ad6ef595cfsm4494333b6e.10.2026.07.30.09.23.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2026 09:23:18 -0700 (PDT)
Message-ID: <bd7249ff-d0a6-4a3b-8aec-3b5325f24b08@kernel.dk>
Date: Thu, 30 Jul 2026 10:23:17 -0600
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND 0/5] block: validate direct I/O memory alignment
To: Thorsten Leemhuis <regressions@leemhuis.info>,
 Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, dm-devel@lists.linux.dev, brauner@kernel.org,
 djwong@kernel.org, viro@zeniv.linux.org.uk, regressions@lists.linux.dev,
 torvalds@linux-foundation.org
References: <20260720201057.1862857-1-kbusch@meta.com>
 <ampRQyXDbGgeg49V@kbusch-mbp>
 <fbe9e74d-c389-46f4-9874-3e9ffd9c91d3@kernel.dk>
 <ampce7mxSmxAwAiu@kbusch-mbp> <20260730112626.GA24827@lst.de>
 <00104e90-48b8-4419-90c4-ac0c4a2e1c44@leemhuis.info>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <00104e90-48b8-4419-90c4-ac0c4a2e1c44@leemhuis.info>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/30/26 7:25 AM, Thorsten Leemhuis wrote:
> On 7/30/26 13:26, Christoph Hellwig wrote:
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
> Thx for this, as I had been thinking along the same lines already and
> was still considering if I wanted to speak up.
> 
> 6.18 still qualifies as recent in my book, but YMMV. And it's not like
> people "took forever to notice"[1], as they reported this for a while
> now -- and there were a few attempts to fix this; it just took us some
> time to see the full problem (@Keith: many thx for that and the fixes
> for them). And some of the linked reports are quite recent, so people
> really hit this.
> 
> Sure, as always there is the risk that this will cause other, bigger
> regressions. Maybe that's why it's one of those situations where the
> right approach is "submit this separately to Linus and let him decide",
> unless of course he speaks up here.

Sorry that's nonsense, because how is Linus going to make that call if
we can't. It's on us/me to make that call. We're not first-timers around
here, we've been around and know how to make the call that we can stand
by.

-- 
Jens Axboe
