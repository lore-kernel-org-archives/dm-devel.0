Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C5015E90
	for <dm-devel@lists.linux.dev>; Wed,  4 Sep 2024 15:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725464340; cv=none; b=ddMj6PLz4u+/z4et66Q4ylJkfAPBVdS5nUkKJosOyqIm7878kMyxbKRs/XDJMsnJwHzPd46kyOlSd2BEpGohpMpu+EotZdsJ3oE/hsRZ1tKGDRoxtXnt6dxFEZi1yXJxejfM3NIx4xbkpm21crMLEUTVWtUtYeRFko5fWoV3fOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725464340; c=relaxed/simple;
	bh=hVf0U5EacqQ/ObEsKsC1CsVQLu4gce3Co3zkfurCcyM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HSOvOQrB5Aviu/7wY7SS5IXB2z6M6TPXlithPyflAdYWq0z++J4KsT3g67c0mPprkaHWjMINFpibmqiDM8t0hwHKoNlmNBChPLKu/xLlD4cNbiNO575L0I2bkGNpb+Je7SgLxTFzqEQojL6VZiDZMSxbrJHpO/rJCoEOmeEatyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OeK1l44Z; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OeK1l44Z"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5c218866849so7211658a12.0
        for <dm-devel@lists.linux.dev>; Wed, 04 Sep 2024 08:38:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1725464334; x=1726069134; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wPeamu7/ppMPuXvO+g8JMXkWG/SgbmzupoBTybQCF9s=;
        b=OeK1l44ZJQTCrkcUrWp6ybIwVi7VeQFkfIwT8NRme5t1cP5wPBYWSeYGa7BizuEpY2
         BJtpLWNQ3efxgttFV8OsXAAdphqpJG4X9qHYscrsYAcCKrYMZ1HHNXxtkuQW0l9Ueyor
         FrcFcrgOY/RdKpRlGLa8aYehIzpSnefHhGhGKApxzhYP33WfFV4SB0K6uctUh2VzG3uP
         B6KTA3eihNWJCIj+u+BBYSP7IYoBzHwIHWkK6h0HulE8K6uM2jryOFC3MI29KtWdkHEK
         4gdwZF27MPGMiQKNpxRZt1abO6/WTLvZdSS5lEuin5OUzjkTkQfFtxBOGqbHK2huA7cC
         4Rrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725464334; x=1726069134;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wPeamu7/ppMPuXvO+g8JMXkWG/SgbmzupoBTybQCF9s=;
        b=DiXq2Y5gDmr652XXlLC1XJl/OV9w4LdUNrckcQhpvXbAMJTbtKVpbrs7B+O9IyObf3
         BMOG2ra5CR2auKfrqkAObcU51NZjsrnfoU+ykmDGj9nOPz6Tn/BWuQbHvn4G9IPODwb1
         oG5Nfnl6HYz6euDuxf8bkhGz5xIaJ6Ux7q8gOrni9KaMAy3x1IaR3Hb6Hxj169/5BIri
         iDEnNV8jW6KZSyYR7jpQsYJCDarWIOsWpuUVaHy/Wu2ucl5/uPJdXWkRZnpCEeYRC2ks
         gb4FLGNalvIxtFP2Y4nuStIVHHUsM5yMM0OHm05+vPzm9XJva8Vyu82atNBPLl5NllHj
         6uiQ==
X-Gm-Message-State: AOJu0Yzw+7OaPTYw844Tromm5dAgrVICxf0L2JzTU+x1gGht7+pNKiqz
	Lg6nRoO0gArl+Zgu5EqdL1mkqMquFOATOXA0CYiXqBTI9JvYDy4Vn5Ih2Ys6l7U=
X-Google-Smtp-Source: AGHT+IE3fTXjvKjfZxV19IR5uFRj+KCLp2+JcAF08/ACMQl+o/2/uSo6itTDqY+CLGKhDtFu548S6g==
X-Received: by 2002:a17:907:97c8:b0:a71:ddb8:9394 with SMTP id a640c23a62f3a-a89b95694c8mr1142066966b.40.1725464334089;
        Wed, 04 Sep 2024 08:38:54 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8a623e2879sm5806166b.208.2024.09.04.08.38.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2024 08:38:53 -0700 (PDT)
Message-ID: <131273007ab11d8a866e395c1e3aa80598aa1dbe.camel@suse.com>
Subject: Re: [PATCH 10/15] multipathd: split check_path into two functions
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Wed, 04 Sep 2024 17:38:52 +0200
In-Reply-To: <20240828221757.4060548-11-bmarzins@redhat.com>
References: <20240828221757.4060548-1-bmarzins@redhat.com>
	 <20240828221757.4060548-11-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2024-08-28 at 18:17 -0400, Benjamin Marzinski wrote:
> Split out the code that updates a path's state and sets up the next
> check time into its own function, update_path().
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =C2=A0multipathd/main.c | 31 ++++++++++++++++++++++---------
> =C2=A01 file changed, 22 insertions(+), 9 deletions(-)
>=20
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 94d4e421..300f8247 100644
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

check_path() used to be one of our core functions, and you now re-
introduce it with quite different semantics.=C2=A0

Perhaps choose a new name?

Martin

