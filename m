Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC0873451
	for <dm-devel@lists.linux.dev>; Thu, 27 Jun 2024 07:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719474459; cv=none; b=I5X8rjza7t4UVMZ4ZEuF0BcIlMXm1CxD7mKn6NX6WuuylyhMBKxJyDKGJjN5aAGuHuHWPepiiKRjw7FonfOOsZcs2FXZobbLXAABp1tW644VYYiitfsd3A5UBitemhcho+hzPd2XGIR7D1d8ospsnd3XWc+Kfyu/QjEjo9hBLwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719474459; c=relaxed/simple;
	bh=HQi1CzIVSlY/E80ptdWheJK/dsZyepsitzRidAgvsis=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=utP3w8RW1ruVlNu6ABuqqfzUaUPIftn8iip+n3iVbx9krRrtRXHj+IUy1lphB+jvk6tiqUMRfYfQzSWa9MGjLKtUouSQS8J2yRnW6H9/tZ3cV+EHOXmMcJwbZMErb4xr37Z5dxB3YXiRcQDrwW8C3M7OGiEtXxbn4ntxtXVHQQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HpkkaZnq; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HpkkaZnq"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-424720e73e1so61269185e9.1
        for <dm-devel@lists.linux.dev>; Thu, 27 Jun 2024 00:47:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1719474455; x=1720079255; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=JFwQ0JYHoGmz3uRizIk9y5gpvmyPS2OW5/rXBKps8Zk=;
        b=HpkkaZnqgw07NDeI9YuNQELm9zEeMdAuWjXY1BA0NKYZUrcmIL+T5qFEuobTn38dOh
         BctgAJUszRdMxd44zhQDF++pY2E+E1YKwDjefDfEdAP3mbhT0azP+VtuLKt4lmI4MdWb
         vD0+SaHLFqTjRQieLiQYcpS/a1I5HZytkoiyR4Xp9+U5X8r50E95NmPX/uhEMAlbuj9Z
         YYRse5qBPAN9op3TQwjR6XOfHQf/mujChYHHM+eAb+2wACIYW3S2rmvoxcSAtD4TDgbx
         ktdywt/dfX1w7JTpoipvn3H3L6vDfJcoY8SjwTuMBGCPS3/Jf3MkVrmH/ABIvlst1JLg
         3oKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719474455; x=1720079255;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JFwQ0JYHoGmz3uRizIk9y5gpvmyPS2OW5/rXBKps8Zk=;
        b=mJYlXvId/oANyGW8Y4iLJRMoLzSxUO82WLI51y0XZUl5F53zCtRpFKDhwWs7+AyaIS
         iYI7zvko3YN8gGpUG57fpLsF/PrTAsBsBPFZcrj4rT/6oFJw4uIAyRkdql6p6QmGPIUu
         NypSdiYYSLfpGXjO6nfluKJ4LQS9/9hlo9yaMb+PXzrd+K/CFiL2ta/JcrMMfFfYszmI
         2ETg2WtpJpZVYqj79RTza9hCf7khVE1ZE9OExpqgnFuMsmrYNsa1JTFfOYfZJW8OnhaJ
         Ntd61ip/4i6z408LA5FdWo474QzPQnGVoo2pC0H2g6RFX4M3pw/eGeaMQqZ8F5etCaFe
         KTng==
X-Gm-Message-State: AOJu0YwWXN5uReKgCiq3l+w+2s3halCL8yHcvXd+U0mGO3xSWkDN0z4B
	DAiHeaATRgBTFk0mprZNU9mhzTUU7iNhtZZodiue/wOAJwZAQqnXHljy1fzsQhU2ObWYL4qT4Tg
	7
X-Google-Smtp-Source: AGHT+IGatFdtBqxpdhXrFhyO0JBP2Oh7Z80SVDAVPuvFqu+F5yQw1akQty1arIod0FT4TjBuQAa0IQ==
X-Received: by 2002:a05:600c:4d98:b0:424:a2d8:5fe9 with SMTP id 5b1f17b1804b1-424a2d8601cmr43228455e9.38.1719474455270;
        Thu, 27 Jun 2024 00:47:35 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:e6b3:18ff:fe37:a690? (p200300de37360a00e6b318fffe37a690.dip0.t-ipconnect.de. [2003:de:3736:a00:e6b3:18ff:fe37:a690])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3674357ff03sm993858f8f.45.2024.06.27.00.47.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jun 2024 00:47:35 -0700 (PDT)
Message-ID: <7551690cc28e39dc733c57ae1a9e657c469aafb3.camel@suse.com>
Subject: Re: [PATCH 3/7] multipathd: refresh multipath before calling
 set_no_path_retry()
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Thu, 27 Jun 2024 09:47:33 +0200
In-Reply-To: <20240605232254.623290-4-bmarzins@redhat.com>
References: <20240605232254.623290-1-bmarzins@redhat.com>
	 <20240605232254.623290-4-bmarzins@redhat.com>
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
> Make sure that all callers of set_no_path_retry() update the
> multipath->features string from the kernel before calling it, so that
> they have the current queueing state to check.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

I am not sure about this one.=C2=A0

refresh_multipath() is not a cheap operation, requiring at least 3
device-mapper ioctls, and we hold the multipath lock while we call it,
meaning that multipathd can't take care of other important things while
it's handling this CLI request.

OTOH, the kernel only changes the features string when the map is
reloaded. Nobody should be reloading the map under normal conditions
anyway, and if they do, we would see an uevent shortly afterwards. IOW,
I think it's safe to assume that multipathd has the correct features
string cached, except in pathological situations.

Am I overlooking something? Do you have evidence of errors occuring
because multipathd has a wrong features string cached?

Regards
Martin






> ---
> =C2=A0multipathd/cli_handlers.c | 12 ++++++++++++
> =C2=A01 file changed, 12 insertions(+)
>=20
> diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> index 117570e1..3dc5e690 100644
> --- a/multipathd/cli_handlers.c
> +++ b/multipathd/cli_handlers.c
> @@ -934,6 +934,8 @@ cli_restore_queueing(void *v, struct strbuf
> *reply, void *data)
> =C2=A0		pthread_cleanup_push(put_multipath_config, conf);
> =C2=A0		select_no_path_retry(conf, mpp);
> =C2=A0		pthread_cleanup_pop(1);
> +		if (refresh_multipath(vecs, mpp))
> +			return -ENODEV;
> =C2=A0		set_no_path_retry(mpp);
> =C2=A0	} else
> =C2=A0		condlog(2, "%s: queueing not disabled. Nothing to
> do", mapname);
> @@ -956,6 +958,10 @@ cli_restore_all_queueing(void *v, struct strbuf
> *reply, void *data)
> =C2=A0			pthread_cleanup_push(put_multipath_config,
> conf);
> =C2=A0			select_no_path_retry(conf, mpp);
> =C2=A0			pthread_cleanup_pop(1);
> +			if (refresh_multipath(vecs, mpp)) {
> +				i--;
> +				continue;
> +			}
> =C2=A0			set_no_path_retry(mpp);
> =C2=A0		} else
> =C2=A0			condlog(2, "%s: queueing not disabled.
> Nothing to do",
> @@ -983,6 +989,8 @@ cli_disable_queueing(void *v, struct strbuf
> *reply, void *data)
> =C2=A0	mpp->retry_tick =3D 0;
> =C2=A0	mpp->no_path_retry =3D NO_PATH_RETRY_FAIL;
> =C2=A0	mpp->disable_queueing =3D 1;
> +	if (refresh_multipath(vecs, mpp))
> +		return -ENODEV;
> =C2=A0	set_no_path_retry(mpp);
> =C2=A0	return 0;
> =C2=A0}
> @@ -1001,6 +1009,10 @@ cli_disable_all_queueing(void *v, struct
> strbuf *reply, void *data)
> =C2=A0		mpp->retry_tick =3D 0;
> =C2=A0		mpp->no_path_retry =3D NO_PATH_RETRY_FAIL;
> =C2=A0		mpp->disable_queueing =3D 1;
> +		if (refresh_multipath(vecs, mpp)) {
> +			i--;
> +			continue;
> +		}
> =C2=A0		set_no_path_retry(mpp);
> =C2=A0	}
> =C2=A0	return 0;

