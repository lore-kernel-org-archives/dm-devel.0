Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7183090E8
	for <dm-devel@lists.linux.dev>; Fri, 13 Mar 2026 00:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773362593; cv=none; b=ngWbWsk2fK+i7Rm3IaMUWut4vMynQsO8m2FS6q5WKEJb+Y9D9YsKNL5lX9QRPCv5VWFDbdGEyLLkMCwKQ1I1xXSXY34tq5BFWAN3BWbz0k9KphvDl+/2GYRl6Grd9dyOU8v5HubIvZuUw+799DxDrBdo6vXw2H+eqkhnxSOYL5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773362593; c=relaxed/simple;
	bh=0U18UQFc+0YJGYqB0R3zbCEyfyWngjOCTP0JEh+d/SA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=WIh3wQhWSFkiM5d5t2V0tvRV4rInhRCf9WD2ZHI/Plgnl5fH6sptwY9N7p2FvalfxwXB5DvGoeTzmTUAFVuAiFGQTzoNchCI5FHXU8xthL0ktZnBUT4tWV8eHTZHORcg95XP0aVZpnWIwBMU2Z5+q8xfE0fQ7IjA0auF/kkxyVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k46metlk; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k46metlk"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4836cd6e0d4so1555845e9.3
        for <dm-devel@lists.linux.dev>; Thu, 12 Mar 2026 17:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773362589; x=1773967389; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0U18UQFc+0YJGYqB0R3zbCEyfyWngjOCTP0JEh+d/SA=;
        b=k46metlk/KLA3la5NYjwqF6fFigVeNoW7Ztz08rrXJgw1zLyuumvS2jk+YIK1xq4fr
         OPyUtFIh8EzG2Z3YN2oTmp4L3nk/6I69mLP8Xc3iIQlLxjtwd9ZkqYEvJzNx73fcYNNd
         0V8jxm6ScGWx/kDIrss9HCQ7HbXfPsGVntfkdPWV2RYIqTSs6F149Z1t8WunT5zuR2iP
         Fr5vITS/r8DC9gv7HfdSzuayT568hUT+bHgjAQvebgjOnkzTQdI1581FbZqM/84OaRCz
         vDrU97hA7yiq/83ydYZzpK30XzCYWl6q2/ZJgCtt3HlbUUGEy8gatMxG/AEYz6f6lRGc
         GJvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773362589; x=1773967389;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0U18UQFc+0YJGYqB0R3zbCEyfyWngjOCTP0JEh+d/SA=;
        b=gTiTi4/90be0jMu09d5akIo+CI6aE9CHlct7nBtTx+lP7ShDEUxc5dKX6eCb0foEwd
         9oZmCQcMFKPDTqjnRvgE60J1tXPpio/lxCghcOKo/8KBI5HlFivLHjPTbBQKsE/tZuIx
         A9hICgDBxSsYbUHmVkCWkKvsPm9h8shYpFcJ/JPtKqoFGYm10FT26BRm/O+3eeK8bp5d
         msUBkx2gk/daZe5KdsQ7iMdNoxvb7XgfeklqE3/ms0+GZkENwHEpk0RhHyo3Hz0hDsRH
         6cutojhX3WeGL4nu0JRV6TPN2vexsalQVDvhy5OozzdApM/v+ppKgTzF77kwNgBGPzVN
         njyA==
X-Forwarded-Encrypted: i=1; AJvYcCWYIOSC3pa8+AOHtv1kcddbKXum230dPfHlyb66MxiA3OuWde5SUaJDS4SXrOcuM6j4U2evQVM42g==@lists.linux.dev
X-Gm-Message-State: AOJu0YwRPpnD0tMkEQAIHHTH4eHy2O0s3OTu/tfcnsSH0k8B1Kh8p8Fj
	S+BJ40hyldXpbPeLtj/7LrbuIA3XerOnLut1T39eZMpcxmBgF6gMCas=
X-Gm-Gg: ATEYQzw0ZIY8rasYGPLXVYN5tBo9IpTV0204xcAhlvqT+hcmDwVKfuzGH48DtkWxGNm
	IWQOhZtAUs9vsIs/Uy2MB3FKS/YRZVg/97lP0TvS1X3Yeyk1st3kWgK25UDWZi9Si6bVb2X3ys7
	dBNyw7JQOR5xEBhf6mIfBVZ/yoDrtjNtMo6s/8TV6+kcyyrH7L3iRcjKAt8qgp8cpCFx53PCz/B
	l5KWURBoEKAFIXSdAKvnVoDdKwVbsFx3ep4QP+Q/4WqLEYfDXI/GKonVI5dN3H00Q/LSmT1PKzd
	yF6gmr3nhEeEOTgftvdQ8KKcLRTgXGhx+p0ht6McApMHUE4qFc4e0SqHdO83odR084LN80Dgw8k
	YTcAV5UVKvv2cVVEbtOhdAWDz/68Im4s2Kn+szHNfVFOrIfMUzAhNa4oQ9TM9M4ubmO1z0x+ElO
	uyC1oxAqaeMaTyqjvrhjiTK5GfpXCJnJO4RfrLQWFr7xReFu97u3KH+auFrSO2KHfVv5o=
X-Received: by 2002:a05:600c:3106:b0:485:385f:674d with SMTP id 5b1f17b1804b1-4855683272bmr11485485e9.8.1773362589063;
        Thu, 12 Mar 2026 17:43:09 -0700 (PDT)
Received: from localhost (219.red-80-39-142.dynamicip.rima-tde.net. [80.39.142.219])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4854b5f6bb4sm163645335e9.4.2026.03.12.17.43.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Mar 2026 17:43:08 -0700 (PDT)
Message-ID: <8491dc36-0e80-4c2a-bb89-4a8cdcaa3a79@gmail.com>
Date: Fri, 13 Mar 2026 01:43:08 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 0/1] pr: add alua path checker
To: Brian Bunker <brian@purestorage.com>, Martin Wilck <mwilck@suse.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 DM-DEVEL ML <dm-devel@lists.linux.dev>
References: <20260312001642.53321-1-brian@purestorage.com>
Content-Language: en-US, en-GB, es-ES
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <20260312001642.53321-1-brian@purestorage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/12/26 1:16 AM, Brian Bunker wrote:

> For ALUA-capable storage arrays, multipath-tools currently uses TUR
> (Test Unit Ready) as the default path checker while a separate
> prioritizer determines ALUA state. When sysfs provides ALUA state
> (the common case), no RTPG command is needed for priority. However,
> if sysfs is unavailable or detect_prio is off, the prioritizer issues
> RTPG, resulting in two SCSI commands per path check cycle: TUR + RTPG.

prio/checker changes should be documented in multipath/multipath.conf.5.in

Thanks.
