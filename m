Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8AE1350FD
	for <dm-devel@lists.linux.dev>; Thu, 27 Jun 2024 09:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719480682; cv=none; b=FdKaYWaWlyyzj6914LVBkbJYj0AZoQ9HTkmwk1MVWoql9jXwqG7LnOAlr/89LzNUyTPQwYNCH3sZrOZLZLNwnX2cBPxr9p3u2pGqTxfSA3+b5/sPg/qC9M/ULO/sujV4bEevBVlab7BsAB6sbPbyHhH1xzRrL0jhylql8KNOKrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719480682; c=relaxed/simple;
	bh=ZWboXsifv5Z8VagMgB4yGyZDiqa7VfmDZ+Zc+ziewOo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=m/EcKzfIWW0EPOJdgfDpCIYANAKBIzp/QeHs+KMd095xH1LA1Fmbp3GLMPTx0JsGPkWD6uVIt8nuYEh1nM8A0M/Cik+33y11TbtHERgs+fMGUUjOnmc5q87fY7mjBFDuj3b17IE9jTaiptNK7N0nMdsNWSS7JG2Jd1fP1qd9u3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=JqCOQ76C; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="JqCOQ76C"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-2eaea28868dso102861651fa.3
        for <dm-devel@lists.linux.dev>; Thu, 27 Jun 2024 02:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1719480678; x=1720085478; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DXkZ7I5pXMfk43H6NOuBQ53xs9q86Sm+RL4KsLsr5rU=;
        b=JqCOQ76CNq0Pm6wfff1SbCN/9MguImTE0c2QOfPvpGMnMUSFEmiEYDPw26KXhntkxv
         qEDkxlcBTgXKHHlgeYcGKVRZpFsLNxV4PZJnqzXBGJ3PxD9OSHEF6hYLXx0DGOb7ZbG0
         6cx5J7fWeg/iRFhXVLHUWvH6oHZ7MIhxHmWFMb7NJEe3W2uAKV6jjfO4hYlMtBcWfIXc
         MujBx4pW1rnBVzfWogbAKUgSvzmFB7+/6yN1Yctia7fRNGIgZTBBC8f9o4gq5mYZAe3m
         5qXiZAGY7RkSzv0aMN++BUy0/P7dAzQfgTUq4Zf0I2viRBAhU/UGWsgFf511fzrN0eTY
         LwAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719480678; x=1720085478;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DXkZ7I5pXMfk43H6NOuBQ53xs9q86Sm+RL4KsLsr5rU=;
        b=ZDa3KuEnuhJmJ32seCCiA+Zzst9BiJH04jU6+FNBK0YHrbAZ0W8ja/GuwrIzccvcEO
         mV9f7RveoNXI/aMbln22yL1jnSCZSToQ3y3V1iG/HOdCHVNvdmpkbMnEQtcELzp/+Dge
         d7XyI5MBjlEz5skz16YblTVf4IWS2CN+ln8XetWQ3KT3hm+DSC+FW0B3NPJTfRoVcWy2
         GuzppKax2668C8AKinvcrcufrPdBCA18uK8xX507NGBeF8rqQInnfiUf/s9AXe9Jv15S
         X0PEHjurRAzqF18x3DLPjkh2obd5SfLiiM5HWekl9utvKqMUuRNsX/MC4IO1h7HZ5aS/
         r1nQ==
X-Gm-Message-State: AOJu0Yy9Dx9IyJfhNybIB5MUTCoiX6ED4mrfh49pBhjWKawzR6wg9KJY
	sYD3n9zD26OwdJCsqjM+BIr4mdUpN9BJcCtWHFjMKKc9ykp7V9X1Repk34hfVaQ=
X-Google-Smtp-Source: AGHT+IHTHcUYEUUWp4s3N7i/nqrsv7BFtnZYNE/hf4TqKE4KDU442PcJVTQot4jJq+KcO9+KyuwK4w==
X-Received: by 2002:a05:651c:1055:b0:2ec:efb:8b60 with SMTP id 38308e7fff4ca-2ec5b2d480amr99974171fa.13.1719480677968;
        Thu, 27 Jun 2024 02:31:17 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:e6b3:18ff:fe37:a690? (p200300de37360a00e6b318fffe37a690.dip0.t-ipconnect.de. [2003:de:3736:a00:e6b3:18ff:fe37:a690])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-424c82519b0sm57123365e9.14.2024.06.27.02.31.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jun 2024 02:31:17 -0700 (PDT)
Message-ID: <15bccd3ff56da7142ad64ad9f574ef64950fc5a8.camel@suse.com>
Subject: Re: [PATCH 1/7] multipathd: fix flush check in flush_map()
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Thu, 27 Jun 2024 11:31:16 +0200
In-Reply-To: <20240605232254.623290-2-bmarzins@redhat.com>
References: <20240605232254.623290-1-bmarzins@redhat.com>
	 <20240605232254.623290-2-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2024-06-05 at 19:22 -0400, Benjamin Marzinski wrote:
> Forgot the comparison in the "if" statement.
>=20
> Fixes 8a3898339 ("multipathd: sync features on flush_map failure
> corner case")
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Ups. The reviewer was asleep, it seems.

Reviewed-by: Martin Wilck <mwilck@suse.com>

(Btw, I am sorry for the long delay of this review).

> ---
> =C2=A0multipathd/main.c | 2 +-
> =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 09286dd0..58afe14a 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -813,7 +813,7 @@ flush_map(struct multipath * mpp, struct vectors
> * vecs)
> =C2=A0{
> =C2=A0	int r =3D dm_suspend_and_flush_map(mpp->alias, 0);
> =C2=A0	if (r !=3D DM_FLUSH_OK) {
> -		if (DM_FLUSH_FAIL_CANT_RESTORE)
> +		if (r =3D=3D DM_FLUSH_FAIL_CANT_RESTORE)
> =C2=A0			remove_feature(&mpp->features,
> "queue_if_no_path");
> =C2=A0		condlog(0, "%s: can't flush", mpp->alias);
> =C2=A0		return r;

