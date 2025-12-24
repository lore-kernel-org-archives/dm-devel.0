Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD2F34677A
	for <dm-devel@lists.linux.dev>; Wed, 24 Dec 2025 15:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766588932; cv=none; b=NNKsdkrP7FQnD3D6gjnfU3LSpg7TGR+hwsW5SVqhU3jLraLZ5b7Sk420x0bWlkWIJ38syb5hg4g3Q0ltTR7UMSjNOs2mUcLsoUhdlcTaz7Ns2HZjyqPjlctiCnQezPAsUhcA2VyszXDta70Ccb/DVjW7i5eKNpiaow1z70RWhFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766588932; c=relaxed/simple;
	bh=XeF4MXBPEG6XF+svA5vYiKypggo77MWqe3DBcGgzXzs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rUnguDEHCERmz+4DsL4+KeMtJoGEYciV/MwDPa/t7aieq5CdcvnUQjJROZmsayUJ1wXdhx1wD/l1hBJ/LeRr1eJxL3/BfuHz5zU8pzysoT28SJwySg0dKd8xk9uMu8l9vJ0+JmLsclSxqMnjDIIj4oBiFJ234GKP6gBGASCModE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LtJ2EF56; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LtJ2EF56"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-59a10ef758aso4967231e87.2
        for <dm-devel@lists.linux.dev>; Wed, 24 Dec 2025 07:08:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766588929; x=1767193729; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PJdMwhI8v8VMSjFiMG+aItE2tE/YcXwTATiR/3CZVKA=;
        b=LtJ2EF56lOgEc+A6VDe9ddrPWeJTw4awKKk1TVzwT5S4A0DAW0Gdurh23w2blbSM0B
         aE9XSWameThFIZw0VF0mLX69SIaEdQ4BeBB5KEOszYFE/VcDRV0eSWV4AWZO/X2m2bXz
         Cys8vhOci4jt35vPocOldZdgGcrdmLRhJXXXt7pHXCQ0zWOejsQiZ1HzlrdKTvu195iu
         LJJNlez0uMOftNifRGlTGIDnCgNxvQ2zyeT4jTL2izDONEhrNBMe6fEoAMvrjkIR+4ch
         ZjYsu9A4d8ByJ4u3LuDxLMx09kCEu9/EUOy1ZYOBp4+utkxb1YnMXr1nBsnnIB2Redhb
         WKrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766588929; x=1767193729;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PJdMwhI8v8VMSjFiMG+aItE2tE/YcXwTATiR/3CZVKA=;
        b=YvUzqwKG02eVj8YOBzZSv/KPXmP6xd6zHUeSMI/lc9l2Je4QMUscFwh2bs0q7psCuT
         OMirW0oBcIf7eQ67H7zU9O3v+rg/95712+j9wfUpMjjOdE8bUtEooW3GPGPv2F5+o1UU
         jvmpiw6BFR6WfyXdSG9n/CRyiySvIM21DNG4Yv4eZNpzPZoBWrqcUuVkZKj/qatCdulV
         lW6lTWeXO7OAEyypcHVaHDmVDFKeMDMLqDP7drlJt9z8vKByQker6pzjiPSv27Z4G7RL
         ld8/3Y8dQF1RD1lqnrQKUkSzqCbDyOf01f7cRwB1jmDgZ1BdGrwzM3bTHRNSUSiwZayk
         6jzA==
X-Forwarded-Encrypted: i=1; AJvYcCXlJwuwuENeVh3PIwQ4u4sVN/NuP/xOP0F4tZtntJyFOAo/MIUQi//EhFRTPdZIcSU1ZlKz9kP11A==@lists.linux.dev
X-Gm-Message-State: AOJu0YwNHymWuKcPgb/xfve7PbR+YVWRzDvAJGOV8GNu+37woGEnArPo
	5pWkBulyBZlwbAWPnNOYa5kJnjirTp9Ael036V8S7GRUOIuKutZQAsk6Qmf5Pc6tV4wGNkY+2jY
	u48pbMIVY50ubixKoJqm3vi+aFpG/iuKhDWzrZV4UPA==
X-Gm-Gg: AY/fxX7xfmxevtfAbkCevUpGiiE/CqB6DHbFWVYYs3zR4+3X2s8iUYLGVS90qbu2top
	Epgv1Ct0IH4Gj/ikGZqgr8yUdQcyr3lznHdTvAgyVizQsN5E1/mcy/NWyIy1AvLp3XHiE8pul7n
	gygt4lN+iX4eEuUxx5e2ci9/nM2lnIxJylcxDS2TnmpGCqsK/i0MaPxRIhWtx08C3b+8/VejOuR
	mEJVyCNk6Kjxb7QleSRiW4hxzyBGz1OSZp3lSHvmBj5fxFONwHMSB8yNfN2JgRUEY6Rr0gwS4st
	nxbG7GWBDKnTBAiplVqNbP7CPJ2rVDbFrRrlJR0=
X-Google-Smtp-Source: AGHT+IEzi8EmWcFmFMpgj4s3+eZDcenRQvQHBNEjyXxew1NN4bq4lB9C/ctjXhDkPWZhlVzMmTpEHglEJpHnAIKuMUg=
X-Received: by 2002:a05:6512:3b29:b0:598:eaaf:a476 with SMTP id
 2adb3069b0e04-59a17d4ca64mr6088183e87.46.1766588928939; Wed, 24 Dec 2025
 07:08:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251107114318.163015-1-marco.crivellari@suse.com>
In-Reply-To: <20251107114318.163015-1-marco.crivellari@suse.com>
From: Marco Crivellari <marco.crivellari@suse.com>
Date: Wed, 24 Dec 2025 16:08:38 +0100
X-Gm-Features: AQt7F2od5JtAZXit-ClQkrXvppzHNTLkaybyXHFmTHFJXg2kpz8MHVHWh5CFaI0
Message-ID: <CAAofZF5XyFKFHtHKRihO5G_MXPbW2zdV3mF60E+KRaoOSEW+Xw@mail.gmail.com>
Subject: Re: [PATCH] drm/bridge: anx7625: add WQ_PERCPU add to alloc_workqueue users
To: linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev
Cc: Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Michal Hocko <mhocko@suse.com>, Andrzej Hajda <andrzej.hajda@intel.com>, 
	Neil Armstrong <neil.armstrong@linaro.org>, Robert Foss <rfoss@kernel.org>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 7, 2025 at 12:43=E2=80=AFPM Marco Crivellari
<marco.crivellari@suse.com> wrote:
> [...]
>  drivers/gpu/drm/bridge/analogix/anx7625.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/bridge/analogix/anx7625.c b/drivers/gpu/drm/=
bridge/analogix/anx7625.c
> index 6f3fdcb6afdb..4bd34b9825a0 100644
> --- a/drivers/gpu/drm/bridge/analogix/anx7625.c
> +++ b/drivers/gpu/drm/bridge/analogix/anx7625.c
> @@ -2668,7 +2668,8 @@ static int anx7625_i2c_probe(struct i2c_client *cli=
ent)
>         if (platform->pdata.intp_irq) {
>                 INIT_WORK(&platform->work, anx7625_work_func);
>                 platform->workqueue =3D alloc_workqueue("anx7625_work",
> -                                                     WQ_FREEZABLE | WQ_M=
EM_RECLAIM, 1);
> +                                                     WQ_FREEZABLE | WQ_M=
EM_RECLAIM | WQ_PERCPU,
> +                                                     1);
>                 if (!platform->workqueue) {
>                         DRM_DEV_ERROR(dev, "fail to create work queue\n")=
;
>                         ret =3D -ENOMEM;
> --
> 2.51.1
>

Gentle ping.

Thanks!

--=20

Marco Crivellari

L3 Support Engineer
