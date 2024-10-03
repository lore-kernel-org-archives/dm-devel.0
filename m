Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115CE1B85D0
	for <dm-devel@lists.linux.dev>; Thu,  3 Oct 2024 20:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727987043; cv=none; b=Ru7yFb08m0qI2N8uN/iOZ0DJHXlHD2hbb9/AbgNJSu7Au5Aij1r/v5JKIXCTGl9+molRtq9RZvEs8fYFZiJz+MLPAfNPgVRnP+RhOTsF8g75MAevoWrhHjORXAM+vkGixZmUtiAyZg9zIFGRXAkFhJR2tIefiI/itU0s03mvHx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727987043; c=relaxed/simple;
	bh=MT34FwzECfScB/t/k8kORuIOUNjfJyLYXOrRJdKawzI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pg9t2/oTsOY+poOdMnEDIxoKMeEuptOGUL25HugxzwAGqyH3qCc9Sb8JdXOB7Wc5YxSKpANyp88w5AZQyZaLsSzfVOTFh8OfhQni0jYcDigOmnffUtary6awe+4eJ1jdOR+X9QmAs2jFYSRhPuMoej6ch7um9qGkaWUEFTJf6cY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fbjmoT08; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fbjmoT08"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2fad8337aa4so18050581fa.0
        for <dm-devel@lists.linux.dev>; Thu, 03 Oct 2024 13:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1727987039; x=1728591839; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=O49wAewv9U4e5yHefEnE4z4J8lkZbYOw2und/DxthUg=;
        b=fbjmoT08Betg97/K7ZcNzOp8ed+j+sjUxXuVV7zEhfWB8dl3q68rvNX0+CnVIo7w3Y
         8deMODiFasurk68cqjwN7m0D4S/w3VPOiJ3yHJuulYt6/iV2mMzyDXeZp7kt4pb6v5po
         bqgy1ysAKZZNFYZ/jQDT8qCRsA/KBtW2BzOq0ZWvlPB2JBmkU92Fus8/Tl8jeNv2CpkB
         C/fuzFHn5h//iU7SdVUeqY/RaxdFW092zRdkgRUOWk0V793kQ4Ta9lh/+vDAILWQBlB8
         ezaYN1Bv1OJtNy2Vl1CXQ9q/bc7awNRkFlI3dxTpryEygJqwr+VgCvY2/mcAm0zElahc
         B2cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727987039; x=1728591839;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=O49wAewv9U4e5yHefEnE4z4J8lkZbYOw2und/DxthUg=;
        b=ab4QYE99YVquQhW3RG7Pi6S42dmJsJYqur0VXWMfj1RlgKdNDbJDqFMXvnJ16Ju6pD
         2qUxGd+fyCzYEvKUltdKVNxb9D0OMzDFXraaUeZJg1OcV7OhwVZmqkql92uMjmh/oiWG
         btrUGjmfHpHa05N3UtidSE2yLyqOUV7hEaN0ihVlvNwLmGMVfFUE9IZ01CYsWo1CNr12
         uoyXcnxunZwZrfTn25DceKTotuArbCN8fv/RaffnozPZr0jmTX6UhnCAsuss3lhWPTFE
         NqfVbu4dAXP/jI/mia9kABHdC9a3jI8X4sU3kPvTNHUixAy94SKDHeZlvWUaSevLSol5
         LLpw==
X-Gm-Message-State: AOJu0Yym+NSAsWMj656i1ni1LlQ2HqKTjnztWKdWKJTm+NabfkPV+sKi
	t5t85MF10s4hXSC+WHlPwFqNbsJdQoNtvA09A+aRgw8ZC13t2OPZhtogWYRjgJQ=
X-Google-Smtp-Source: AGHT+IHHLA43/tc46+w8iDqaujRLlvEBIFVnuZwkoatcbVR/8t5LEti4jDPTYXeBj2KsKquPG9sIXQ==
X-Received: by 2002:a05:651c:316:b0:2fa:dc24:a346 with SMTP id 38308e7fff4ca-2faf3c1c72bmr1143001fa.21.1727987038671;
        Thu, 03 Oct 2024 13:23:58 -0700 (PDT)
Received: from ?IPv6:2003:de:3719:4a00:e912:812a:2309:b70? (p200300de37194a00e912812a23090b70.dip0.t-ipconnect.de. [2003:de:3719:4a00:e912:812a:2309:b70])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c8ca3dde29sm1060885a12.24.2024.10.03.13.23.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2024 13:23:58 -0700 (PDT)
Message-ID: <2c6e8aab3bbd2938b8b88cdccc170b04b6c469f8.camel@suse.com>
Subject: Re: [PATCH v2 10/22] multipathd: split check_path into two functions
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Thu, 03 Oct 2024 22:23:57 +0200
In-Reply-To: <20240912214947.783819-11-bmarzins@redhat.com>
References: <20240912214947.783819-1-bmarzins@redhat.com>
	 <20240912214947.783819-11-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Thu, 2024-09-12 at 17:49 -0400, Benjamin Marzinski wrote:
> Split out the code that updates a path's state and sets up the next
> check time into its own function, update_path().
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =C2=A0multipathd/main.c | 31 ++++++++++++++++++++++---------
> =C2=A01 file changed, 22 insertions(+), 9 deletions(-)
>=20
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 9319751e..8bfb166d 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -2390,6 +2390,7 @@ sync_mpp(struct vectors * vecs, struct
> multipath *mpp, unsigned int ticks)
> =C2=A0}
> =C2=A0
> =C2=A0enum check_path_return {
> +	CHECK_PATH_STARTED,
> =C2=A0	CHECK_PATH_CHECKED,
> =C2=A0	CHECK_PATH_SKIPPED,
> =C2=A0	CHECK_PATH_REMOVED,
> @@ -2629,13 +2630,10 @@ update_path_state (struct vectors * vecs,
> struct path * pp)
> =C2=A0}
> =C2=A0
> =C2=A0static int
> -check_path (struct vectors * vecs, struct path * pp, unsigned int
> ticks,
> -	=C2=A0=C2=A0=C2=A0 time_t start_secs)
> +check_path (struct path * pp, unsigned int ticks)
> =C2=A0{
> -	int r;
> -	unsigned int adjust_int, checkint, max_checkint;
> +	unsigned int checkint;
> =C2=A0	struct config *conf;
> -	time_t next_idx, goal_idx;
> =C2=A0
> =C2=A0	if (pp->initialized =3D=3D INIT_REMOVED)
> =C2=A0		return CHECK_PATH_SKIPPED;
> @@ -2647,8 +2645,6 @@ check_path (struct vectors * vecs, struct path
> * pp, unsigned int ticks,
> =C2=A0
> =C2=A0	conf =3D get_multipath_config();
> =C2=A0	checkint =3D conf->checkint;
> -	max_checkint =3D conf->max_checkint;
> -	adjust_int =3D conf->adjust_int;
> =C2=A0	put_multipath_config(conf);
> =C2=A0

After this change, we set only checking in this RCU critical section,
and checkint is only used in the if clause below. Perhaps move the
critical section into the if block?

Martin


