Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1498E51C49
	for <dm-devel@lists.linux.dev>; Fri, 12 Apr 2024 08:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712910358; cv=none; b=u7Iab4nzgab6Z/xmfWsVrWd8ujYDVVXK5kH9YKKcRcW/GWySI6IRhViT9B8KGYYUyeG87USJAyDy/sIUkutNf5q/enGzxN+OCkgfCANsKWrA2U/Wb+1WYQOAgcEOU0UFb61jTOio2C2t9QRfthYBxobABlGM4UKWwoKRQ4ES2+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712910358; c=relaxed/simple;
	bh=ys1xNDospWYY8+6SUaFa3qTSrrE35CxPgWj8sVX5GIM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lv+a5P24DMTzl8xa8AKYEMm3BDp//7ZsqsrLOKsfW8EHSurHsXJ1fxePzczhFyLqW8vkByRsaYOcYukdnk3HaiBXAiWoEkMEj3eXYbNZiS3IfXmHBSUSEAcMJzVUdB/J2s0Opa8lrk9XtX/jC64Rm9BD9Xl2Pegz5fOCSX249UI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=NCrJ/0fs; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="NCrJ/0fs"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-417db45fe01so4779775e9.1
        for <dm-devel@lists.linux.dev>; Fri, 12 Apr 2024 01:25:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1712910353; x=1713515153; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=M9yzipjLT7g5zEHzAitKNE/GT2SRvni1/pt8SW9fAd8=;
        b=NCrJ/0fsL5RPhFmRBvgr9NtFle3sbyD0iomrFYAlOxsegWnKANQSb1V610w1Ebscwn
         AjfgpT+B/QieKq0XFvD/ynTeOhyBfM7aEcdSraORltcb1bJQ9SIhtH7HC2N7i2i/mE3V
         EaREm6Hbi+IY6K33/LEZoAYF+sttRYjRE564KZcHY6vpipP9LMoRMK+s4n6NPBBc9wFX
         Oq/Z+Z7sYQP1STADfeb9q3EnZpFrjI89fNOGCeCrv1myUSj4HzJE6v6gfj1FrgsMEPw/
         cIrJfbnManoQpxeyQC+UQSo5pp67XOwPRSyxucMBk2vuOk5OYxTD54odjgORNJmS4hZg
         KVmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712910353; x=1713515153;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M9yzipjLT7g5zEHzAitKNE/GT2SRvni1/pt8SW9fAd8=;
        b=JnfqaZDTtzN1fyPw3Ks9oLeaN1QY8xzHRoJdhqKDavsBqY6c509mufHaNWa6FSdYNK
         dKOK6ImtVr/ECRXSsyEJtqmhFiI7jxDlSuYgKORfNAmkkrjJXpzmZU49aTZkOS631ngz
         fqzGmYfMea1REgiRGpfDYde+fuxx4fnlvdg+2hLnAjIwvNzklCahh9Vtm82nNnhbNjMd
         llGBLJzceUgd6OhyOyw92KvXQPmveigDmtb56J22t8u+90q77J1G1qNpTq3ObRONfySJ
         jSSGqmyPBtPvmWFGS3DeLTonkd9sO9UzXNk9cIUx1/3Y1wVSlY9iotfCHy5UvXj7O2Nu
         tSVg==
X-Forwarded-Encrypted: i=1; AJvYcCXCP/qAT8P1cPz+YZioyMDT5LIj6vP+gGB+UjP0DdAk6kfEOweQe6inDTe2H7rJXi72YLdHUNVnMNTD1IqigwsqZyE69wpMLWI=
X-Gm-Message-State: AOJu0Yy0jL8NJBvGcfwMcopOCOi2u2BMdygYABuxKLMnoVQhkobA10WL
	21RLAHQnQbEl2T9BTBypgcsBmUFHb8soek9gxMGGlA3gMAxHtZT/rWOjEHGQIOc=
X-Google-Smtp-Source: AGHT+IFidzyrxnaVclec55unHbwLcFkJwp2VF+9QhvSAM30jXnLwiNjcMXKD1Rd93WhlZd9dkDuJoQ==
X-Received: by 2002:a05:600c:4e06:b0:416:667d:4691 with SMTP id b6-20020a05600c4e0600b00416667d4691mr1428440wmq.25.1712910353426;
        Fri, 12 Apr 2024 01:25:53 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? (megane.afterburst.com. [2a01:4a0:11::2])
        by smtp.gmail.com with ESMTPSA id a8-20020a05600c348800b00417bc4820acsm5005704wmq.0.2024.04.12.01.25.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Apr 2024 01:25:53 -0700 (PDT)
Message-ID: <30522782-cafa-4901-9635-bb14bd4d810f@suse.com>
Date: Fri, 12 Apr 2024 10:25:52 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Problem with [PATCH] libmultipath: fix max_sectors_kb on adding
 path
To: Martin Wilck <mwilck@suse.com>, "bmarzins@redhat.com"
 <bmarzins@redhat.com>, Etienne Aujames <eaujames@ddn.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 nilesh.javali@marvell.com, DM-DEVEL ML <dm-devel@lists.linux.dev>
References: <ac898b4b79947c22d510bb365e9b507faac1f016.camel@ddn.com>
 <9bb4ca089c3d2dd5b331df88f3f89953916b0b17.camel@suse.com>
 <7742003e19b5a49398067dc0c59dfa8ddeffc3d7.camel@suse.com>
 <13eefee4-02ab-4cdf-b317-6a8585b4afdf@suse.com>
 <20c44a0ebb3aef1c6924aa7ab6006785330bb744.camel@suse.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20c44a0ebb3aef1c6924aa7ab6006785330bb744.camel@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/12/24 09:21, Martin Wilck wrote:
> On Fri, 2024-04-12 at 08:06 +0200, Hannes Reinecke wrote:
>>>
>> We have gone into great pains in the kernel to ensure the queue
>> limits
>> are sane, and updated correctly. Even for stacking devices.
> 
> This is true, but only for the creation of stacked devices (table
> activation, as far as device mapper is concerned). Admins are free to
> change max_sectors_kb any time; there's no propagation of changed
> settings along the device stack, and no sanity checking in the kernel
> prevents them from setting values that will cause I/O errors.
> 
>> I sinserely doubt we need this patch from multipath anymore.
>> Having to adjust max_sectors_kb really should be reserved for
>> corner-cases where the user has a dodgy hardware which doesn't
>> report correct limits.
> 
> Right. We've seen a couple of cases where decreasing max_sectors_kb
> from the default value was the only remedy for weird I/O failures. This
> happened with remote storage reporting wrong limits, misbehaving
> elements in the fabric, and even with virtualized IO stacks.
> 
>> But even that should rather be handled by blacklisting.
>> Can't we just set max_sectors_kb to readonly in the kernel and
>> be done with it?
> 
> Personally, I think this goes a bit too far. I believe the kernel
> should disallow changing (more specifically, decreasing) the
> max_sectors_kb sysfs attribute for block devices that are either in use
> (bd_openers > 0) or held by other block devices (bd_holder != NULL).
> That would eliminate a large portion of bad cases, AFAICS. Admins could
> still increase max_sectors_kb at the top of the device stack, but that
> would arguably count as shooting oneself into the foot.
> 
> Errors in valid configurations are possible, even without changing
> max_sectors_kb in sysfs. Consider a multipath map consisting of devices
> with different max_sectors (for example mixed iSCSI/tcp and
> iSCSI/bnx2i). If only the paths with large max_sectors are initially
> detected, and others are added later, the map's max_sectors will be
> decreased while in use, and the change will not be propagated to
> stacked block layers above multipath: bummer. The only way to avoid
> this in general is implementing limit propagation. I assume that the
> implementation of block limit propagation in the kernel would be a
> major effort with lots of possible race conditions. It's far easier to
> have admins simply impose max_sectors_kb on multipath maps in corner
> case scenarios like this.
> 
Indeed; changing the max_sectors_kb while the queue is live should
be preceeded with a quiesce, to ensure that we're not changing request
limits in flight.

And disabling setting of max_sectors_kb for stacked devices is a good
idea, too.

Cheers,

Hannes

