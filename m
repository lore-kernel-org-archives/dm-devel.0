Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C68E818A6AB
	for <dm-devel@lists.linux.dev>; Sun,  3 Nov 2024 22:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730671341; cv=none; b=QGoBmteXdATdvKviULLqkzc5dZQXGgxWV1y0iPQ0EkiC9UtEUxIVA4sYEoi4qrTFoSyFV9z1dlD5+FN4+Sz+kvFOd+faAdwednpClc2VuUBNZktqXdBosYnFYRnyqiMggxh/UgPt0Q5MIdpwCTDplwBooNZF2HK7zNWF2DHqU/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730671341; c=relaxed/simple;
	bh=P6DSk0oMA644k+c/EWtG5fpfJ557tm13BDwFVwmxRYs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FiyhnH1/FyVdj1KCOGwJl6XMLNPakLPnfST+S324u51bTt5AZuZ70r2qZd8UBaNvZn/ljAtGAmOma++aWW8+n3Ir+krhwVQ+qlijxvx8NxjtLeBopHsh9LMeELVhgHgTPMDOQ1Jno+b8/F1IxseCCzw2FAWBzQGgwTygUfJXR/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ATA6RYHC; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ATA6RYHC"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5ceb03aadb1so3723287a12.0
        for <dm-devel@lists.linux.dev>; Sun, 03 Nov 2024 14:02:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1730671336; x=1731276136; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=P6DSk0oMA644k+c/EWtG5fpfJ557tm13BDwFVwmxRYs=;
        b=ATA6RYHCfr3AnZFkzWVhsnManfHY8Q7RcCr7+Hf6yiVGADtOm8XH5Xd0FYeOZ4zZZT
         CDJX/gKBCcH7t/Xj84m+SAUhmZ/SQ54vbNMJ2EASfLtDHL1fErOrTE3USvGUP4P1i53o
         +wz6w43gu1gegY4srxzuwgGEAfMF0JTjhaZao62bNAUVkl6dHzwWxDmk1qhF6MhDlMAZ
         0WIriqRTCe7We/CV+gCrbQHlmqcHkDB81jrS7xjQxDXzlPe7DYyZuWcQXkvkpMUb7fYf
         FqnnsQqY+neCST70owlRRPFKTs9iQsBW4ezSJRU8WTbv0pZS1UdfC90980YAqOakIVoL
         YzYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730671336; x=1731276136;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=P6DSk0oMA644k+c/EWtG5fpfJ557tm13BDwFVwmxRYs=;
        b=gGJNor8j1UKckiij5a5DVzfctZYf2/h1aA9CmSkIxxfbQOTanF3y7pZmlg1Zn94L66
         9mPl7gUkwrgjZEmCzhfsM9xdRP+27Q1OQmge5UadIe7Tl5+Y/t3eJbX9sEZMjJ2uX0Wr
         124T+bUKjtulLgBF0aUR2iImzRlDIG+2xTOXOZ4X3IjAtkxeaniH63Lw4g0ZLU0jsVvK
         3k/lPA9o0weWBwAQ7MuD8KyiBBa6W+BuouYCxdE2agqhsbb+atMXwunonnYA5zMxDUPB
         RB6YoHHsj5BYjo0wkT7iOqda2cF7Yu3ZXQ3XHGBfLK+ATnfQJJk84qcwnao8CtV4HB/S
         97EA==
X-Gm-Message-State: AOJu0YxHJJnJ6/ghvaRRt0qwN3e7zifRymyeWlMcSd3jDjuaTsvDsHYj
	z4PI9GNqhQdjvP+qIykb365bC7bPpKfMlHffmUC48ff8avMjHbfAtJ+40Qz8YmmRpuv2KajTL2S
	v
X-Google-Smtp-Source: AGHT+IEfWc/3CfKiPUlkS5x+R5BEwI6s1FZtI2JXgBVhVJQFdvhwbvcWrMrVD6Bc9dTqbPL98sKFsg==
X-Received: by 2002:a17:907:72d6:b0:a99:f9e6:1d0 with SMTP id a640c23a62f3a-a9e50939117mr1367694766b.27.1730671335538;
        Sun, 03 Nov 2024 14:02:15 -0800 (PST)
Received: from ?IPv6:2003:de:3746:4600:ac00:378:25cc:9f2c? (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9e5667d1aesm469389766b.196.2024.11.03.14.02.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Nov 2024 14:02:15 -0800 (PST)
Message-ID: <c5f64d81e153804aa1da648be6272a3ed2df2e5d.camel@suse.com>
Subject: Re: [RFC PATCH] 11-dm-mpath.rules: Disable blkid runs when updating
 the device
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>, Peter Rajnoha
	 <prajnoha@redhat.com>
Date: Sun, 03 Nov 2024 23:02:13 +0100
In-Reply-To: <20241022233349.247087-1-bmarzins@redhat.com>
References: <20241022233349.247087-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Tue, 2024-10-22 at 19:33 -0400, Benjamin Marzinski wrote:
> When multipath reloads a device or fails or restores a path, the udev
> rules disable LVM scanning, but since .DM_NOSCAN isn't set, blkid is
> still run on the device. When multipath devices that are set to
> queue_if_no_path lose all their paths at close to the same time, udev
> workers can hang trying to run blkid. The blkid results shouldn't
> change when multipathd is adding, removing, failing or reinstating
> paths, aside from avoiding hanging udev processes, we're skipping
> unnecessary work.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =C2=A0multipath/11-dm-mpath.rules.in | 6 +++---
> =C2=A01 file changed, 3 insertions(+), 3 deletions(-)

This is correct. It conflicts with my own late udev rule patch set.
While your patch was sent first, I believe it makes more sense to apply
this change after mine.

I'll to send a v2 with the .DM_NOSCAN logic improved.

Regards
Martin

