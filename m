Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8147A19E827
	for <dm-devel@lists.linux.dev>; Thu, 27 Jun 2024 20:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719520944; cv=none; b=jrmvSyLRh9uXN0P+C74pFM7onxQvaWZBTSdjBsrb3D8XwB2JbRR9hIkk7wN88uwvyN9mwhTovyPPWUwAJT+uWrlgDDRY1ZGpk19w6XKfWi2GIsH2J31rup7zF7cZiiz/aWy2lJt9fLzE6AKYinEE1xz+4CMoxYOEsKUxoL7hq3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719520944; c=relaxed/simple;
	bh=L9HcQ0jkgauNPWLYvnBBb9t1QOTRSvMj4ijFY+swBIM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dMLyV9S1qRJaMdEglK0qqgV8ftnjUziFif3qs0zfz9uuZpmDzQuHoGkljNgeKGPK7fUhZJn+TsSgtU0KUK+mHCNR3Mf4rhptrrfYnk8RndxBW1+mmfCE4HAAik5lAf+y1qxKjpLfaxlOCNqQyhgaz5JTGxOntWtS8cfqquetMzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=IutgwNZK; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IutgwNZK"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-42562fde108so14075535e9.0
        for <dm-devel@lists.linux.dev>; Thu, 27 Jun 2024 13:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1719520941; x=1720125741; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=L9HcQ0jkgauNPWLYvnBBb9t1QOTRSvMj4ijFY+swBIM=;
        b=IutgwNZKEbkVLFXm+8GJUWvpGGG6sPEWiyy9t8wfxQ3GtmFnf8iPvIkBuEMGUmMgvo
         zmJXnrF6Gwnv1cEca0CphY6EUQmMyTT39XEo1xWaK14knv9nBxv+ykm2p7GNiICMJXpY
         dZ2Z5UIyHQhnpeZlAksgXfUnBYLj55ewF7ch+AepqkCsCZD9Lyg3A1Q0BknCHooYP2xK
         mIj2aN44DL1iT/g0pqPMeCnD2Bh7FnmuksfkSL4LC+iWwroq8mNW7Sf3Dz9xWDCNWLI9
         w9ArYoJUJun3bHA1CMBP/YrcfhOThhchJpDo4dcIlPRmKCAkr92Bwya9+y658wl+PIFc
         hpow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719520941; x=1720125741;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=L9HcQ0jkgauNPWLYvnBBb9t1QOTRSvMj4ijFY+swBIM=;
        b=eW4f/YNLzWLbg5Hd/QnkuRaEqMVHKwQNpTyS7fktvVlVPmIqWfGqDRI6X/qC3vCHQN
         z1N+BMREeJgPSIyCBLxgLH/I7huhUqCqfezuxkqgVMJ9erYnvvVp0u3fKSmiOlo2jV5q
         iTuXtlcgut20atbuavHrbvtY0kaHcee2dYCmhb6LhsG/YbT1QZEfRAsOk234OyhZ1A6a
         6/lXBRbDvqnMSSZKr/sX0Hy5N6NfzKlRSD2MOqGwAFU9EccHTQDA01VdGaOal5VHyBVU
         F/6P2J27RSy5tfEnmIlvkC7wNwopHvpzxQ8Qe5gkDo2PWLsooADqmaxmRVIBmCSbWyb7
         yQTw==
X-Forwarded-Encrypted: i=1; AJvYcCUrWIWsViA4Jjmti719fzF7jepyy+k7TJu/fcmH7wbGN2K2yTKqf//3GlwwzTDYOX5ULg3M6Eauxqk7fxkiKOWH/TTDcqrdebM=
X-Gm-Message-State: AOJu0YzUf/V9Y4lpZE+0qg29nWkxQ8yZL9W9/UxF/Up0M+yQ2YyDK7bM
	IHDxaTS9oIAQn/gbJJjBn9hWan2QE1gAYs4eKlkGQM/RpIuTvBsasWB2WPodFwE=
X-Google-Smtp-Source: AGHT+IFWK+eO/xuDUrNkmaxlKMShY6hxVe3HIjC/LyqFp0W+uhBzJcXtP34l9KmPKAZVu+59tNz8Eg==
X-Received: by 2002:a5d:6c68:0:b0:366:ead5:f17 with SMTP id ffacd0b85a97d-366ead50f7emr11292873f8f.9.1719520940603;
        Thu, 27 Jun 2024 13:42:20 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3675a0fb9c1sm260988f8f.74.2024.06.27.13.42.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jun 2024 13:42:20 -0700 (PDT)
Message-ID: <61f0beca0f4cb8215a4f24b1cda759ad30faf49e.camel@suse.com>
Subject: Re: [PATCH 4/7] libmultipath: add name and minor outputs for
 dm_map_present_by_uuid()
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper
 development <dm-devel@lists.linux.dev>
Date: Thu, 27 Jun 2024 22:42:18 +0200
In-Reply-To: <Zn20BcBvXJLClyyI@redhat.com>
References: <20240605232254.623290-1-bmarzins@redhat.com>
	 <20240605232254.623290-5-bmarzins@redhat.com>
	 <6204dbb3f98a53b472e52c0356a16260f95ba2af.camel@suse.com>
	 <Zn20BcBvXJLClyyI@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Thu, 2024-06-27 at 14:48 -0400, Benjamin Marzinski wrote:
> On Thu, Jun 27, 2024 at 11:27:41AM +0200, Martin Wilck wrote:
> > On Wed, 2024-06-05 at 19:22 -0400, Benjamin Marzinski wrote:
> > > add arguments to dm_map_present_by_uuid() to allow optionally
> > > fetching
> > > the device name and minor number for the devices found by WWID.
> > > These
> > > will be used by a later patch.
> > >=20
> > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> >=20
> > I have to say I don't like this much. At least the function name
> > should
> > be changed. But actually, our handling of DM_DEVICE_INFO and
> > DM_DEVICE_STATUS dm tasks needs refactoring. As far as the kernel
> > is
> > concerned, all dm ioctls that refer to an existing map will find
> > the
> > map either by uuid, by name, or by major/minor, and the map uuid
> > and
> > name will always be filled in.
> >=20
> > I'll see if I can come up with something to clean this up.
>=20
> Do you want be to resend this patch with a name change, or will that
> just happen as part of your cleanup?

Please give me a day or two. I'm working on the cleanup, which has
grown quite a bit. I hope to be able to send it tomorrow.

Martin


