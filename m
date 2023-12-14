Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E743A5E0AC
	for <dm-devel@lists.linux.dev>; Thu, 14 Dec 2023 16:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="UJYxWdTQ"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-33646d24c1bso705679f8f.2
        for <dm-devel@lists.linux.dev>; Thu, 14 Dec 2023 08:15:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1702570522; x=1703175322; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Ar3aWbtI8d0xJBjsaukpvS7rLoNhlORFTccIaoA6WQY=;
        b=UJYxWdTQI5JyEV0virEvf7sAMnBG/VTbAth41BzAxSHnEUs0CRgxzPIH/V16blnf3V
         6qiT+gPYiPhMAVwN151RxwxCbv4Y9f5r1zYjZW1aWPZ0btpYSvwzGVNf6rYCz0+Q4ONR
         0+sA9YPanBMXXddxsuvCe5iVjRa+z6ZsqFzUpUcY9+kDu+Ob+8qccLgW2Lu9w1etHIJ2
         rnvRSAijNfmEPqOV1uNe8xdFah1LYOrXONYsJrTpQi+7FP8SxFwyFTf/tBGs4/tS+Yhm
         UVeQECXZpI+8DqFurlCGLvsoUMJ+/XW6cuTZ6S0l9aNv/htwvoZnHEa4O1wh5E4AF2To
         M2Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702570522; x=1703175322;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ar3aWbtI8d0xJBjsaukpvS7rLoNhlORFTccIaoA6WQY=;
        b=bZVeblIjWZPQw0Kod2wF2t+FXJuE4X+xry7nggL3wR4QCQJIis42bvrgq3V4G94r9S
         K9aGHAggmFjFa8SWFFjOftmcehH4VqJDFEeA2HtcYXcALwnvOpXCNaJmWPeI9I7sZ4B9
         0AnWpAYl4G562OrI6lDu/vEJGK4KNUZ5SAp6hH2JROzqBMJT6GGgEE2r+In4/UO7HJvq
         sEjYKe4jgrrqLrN84w9M2bTynr8IybWrV3SVZlE/QH/kT1skimcY0UCiogvL6hzYSvPn
         KsoXloyojEPePQm5f2mR1IWrFxzKpRnc1Xxdrt8ecWF5RxxCsAmSlN1FItNtM6LXcWJS
         qjNw==
X-Gm-Message-State: AOJu0YykNq6bLjcUccfnMoC3+qweMSN8b3QyZDRYzqu1Gi4K5BmsWoXA
	w78IBRVkYpuQigo8tf6la50uXQ==
X-Google-Smtp-Source: AGHT+IExx7vp5CmMyiui4l4DFkf0Bxkd2nrj4p58ikQQTN0vDbFPrGQ/BE1p9/CswE1h7DHYj/Q7Jg==
X-Received: by 2002:a5d:63cf:0:b0:336:4b93:7b5b with SMTP id c15-20020a5d63cf000000b003364b937b5bmr352191wrw.39.1702570522013;
        Thu, 14 Dec 2023 08:15:22 -0800 (PST)
Received: from apollon.wilcks.net (dslb-090-186-000-097.090.186.pools.vodafone-ip.de. [90.186.0.97])
        by smtp.gmail.com with ESMTPSA id d9-20020adfe889000000b003363e505ef0sm4380180wrm.44.2023.12.14.08.15.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Dec 2023 08:15:21 -0800 (PST)
Message-ID: <0e0dcba49d56b71a7584efb2273be1e9d0606af2.camel@suse.com>
Subject: Re: [PATCH v2 5/5] multipathd: force setting dm state when
 disabling/restoring queueing
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Thu, 14 Dec 2023 17:15:20 +0100
In-Reply-To: <20231205235704.355125-6-bmarzins@redhat.com>
References: <20231205235704.355125-1-bmarzins@redhat.com>
	 <20231205235704.355125-6-bmarzins@redhat.com>
Autocrypt: addr=martin.wilck@suse.com; prefer-encrypt=mutual; keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Tue, 2023-12-05 at 18:57 -0500, Benjamin Marzinski wrote:
> Currently, the interactive commands to disable and restore queueing
> call
> set_no_path_retry() without first re-reading the device table. This
> means that the value of mpp->features might not be current, which
> means
> that set_no_path_retry() might not tell device-mapper to change the
> queue_if_no_path state when it should have.
>=20
> Instead of making these commands do extra work to re-read the device
> table, simply make them always tell dm to update the queue_if_no_path
> state, regardless of the current state. There is no harm in telling
> dm
> to set the state to its current value.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

I am still not convinced, as this goes against the spirit of keeping
the no_path_retry setting consistently in a single place. Why don't we
rather make sure that our "features" string correctly matches the
kernel settings (ignoring possible attempts to bypass multipathd)?

The code snippet I sent in reply to your 1/5 patch should achieve this
for map reloading. Queueing can only changed by (re)loading, or by
sending dm messages. Thus AFAICS it should be sufficient to add calls
to add_feature("queue_if_no_path") and
remove_feature("queue_if_no_path") to dm_queue_if_no_path(). Am I
overlooking something?

Wrt "there is no harm in telling dm to set the state to its current
value", the kernel doesn't seem to check whether the new and current
value are the same. It always takes a spinlock and set some flags in
the dm device. So the ioctl is not a zero-cost operation.

Apart from these general doubts, I have some more remarks below.

Before 6071176 ("libmultipath: drop mpp->nr_active field"), which
introduced the call to set_no_path_retry() from cli_restore_queueing(),
we also reset mpp->retry_tick, which your new code does not. (That was
actually part of the motivation to use set_no_path_retry() rather than
direct calls to dm_queue_if_no_path(), IIRC).

The term "restorequeuing" suggests that it's somehow reset to a
previously saved value, which is not the case. We should mention in the
man page that "restorequeuing" actually just enables queueing (for maps
that are configured to queue). Perhaps we should also add
"enablequeueing" as an alias for "restorequeueing".

> ---
> =C2=A0multipathd/cli_handlers.c | 25 +++++++++----------------
> =C2=A01 file changed, 9 insertions(+), 16 deletions(-)
>=20
> diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> index b1dff202..758b571b 100644
> --- a/multipathd/cli_handlers.c
> +++ b/multipathd/cli_handlers.c
> @@ -934,16 +934,9 @@ cli_restore_queueing(void *v, struct strbuf
> *reply, void *data)
> =C2=A0	select_no_path_retry(conf, mpp);
> =C2=A0	pthread_cleanup_pop(1);
> =C2=A0
> -	/*
> -	 * Don't call set_no_path_retry() for the NO_PATH_RETRY_FAIL
> case.
> -	 * That would disable queueing when "restorequeueing" is
> called,
> -	 * and the code never behaved that way. Users might not
> expect it.
> -	 * In almost all cases, queueing will be disabled anyway
> when we
> -	 * are here.
> -	 */
> -	if (mpp->no_path_retry !=3D NO_PATH_RETRY_UNDEF &&
> -	=C2=A0=C2=A0=C2=A0 mpp->no_path_retry !=3D NO_PATH_RETRY_FAIL)
> -		set_no_path_retry(mpp);
> +	if (mpp->no_path_retry =3D=3D NO_PATH_RETRY_QUEUE ||
> +	=C2=A0=C2=A0=C2=A0 (mpp->no_path_retry > 0 && count_active_paths(mpp) >=
 0))
> +		dm_queue_if_no_path(mpp->alias, 1);
> =C2=A0
> =C2=A0	return 0;
> =C2=A0}
> @@ -962,10 +955,10 @@ cli_restore_all_queueing(void *v, struct strbuf
> *reply, void *data)
> =C2=A0		pthread_cleanup_push(put_multipath_config, conf);
> =C2=A0		select_no_path_retry(conf, mpp);
> =C2=A0		pthread_cleanup_pop(1);
> -		/* See comment in cli_restore_queueing() */
> -		if (mpp->no_path_retry !=3D NO_PATH_RETRY_UNDEF &&
> -		=C2=A0=C2=A0=C2=A0 mpp->no_path_retry !=3D NO_PATH_RETRY_FAIL)
> -			set_no_path_retry(mpp);
> +
> +		if (mpp->no_path_retry =3D=3D NO_PATH_RETRY_QUEUE ||
> +		=C2=A0=C2=A0=C2=A0 (mpp->no_path_retry > 0 &&
> count_active_paths(mpp) > 0))
> +			dm_queue_if_no_path(mpp->alias, 1);

What about the case when there are no active paths, no pending paths,
mpp->in_recovery and mpp->retry_tick > 0?

Regards,
Martin


