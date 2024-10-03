Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 643F41AD41F
	for <dm-devel@lists.linux.dev>; Thu,  3 Oct 2024 20:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727988085; cv=none; b=nXzv444mNSC75/Ha19SFChpyPxh8dx/4yk8deRwsDOwXUPzPNOy96IJYnw0izhNiwGYQUzaAL/vyihrcMxj0iSoJeSa9FQHxpeo/Q+MQXhpZmt1TNc/I60+14N0AbKn42ouEws1wGNF9VKC4QfjC5s44HUXcIyZ6Kyxg4uItgHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727988085; c=relaxed/simple;
	bh=oghqhgwzVy1X8rjECvP5v6MyN5Cu1scuPy29iwChqCo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=c7Ar46ROVAh/4IywYMvNa9inQEliB2LId5x32xSxvdoFLDGCildbKnPs6dROobwIOi0KvRK3/ucT+jKkyXwdSEIvxYzDWDq1Ni3hoWzoMmnGE1JsixFmfX8WvB7lT05Ohef10+HwnA5E6sxJbWXFGqj2XhhEwv0UKzzRQj9SwVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Yp2xePh2; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Yp2xePh2"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-42cbc38a997so8657465e9.1
        for <dm-devel@lists.linux.dev>; Thu, 03 Oct 2024 13:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1727988082; x=1728592882; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=boEYa3HkN7tpzzbSYKk62wIDlMPHZQ0hIQz86LI7hRE=;
        b=Yp2xePh2jlcMjcuMr2NENmGG082EPcvAEm8ZWZHj3MB/DAkA77zuzwI6Knr0oYwJIo
         ZL3ZERYf2rJN9uGln0UkULSDkDqYJcGFCjyESZTHH6A9/pqGSXOTiz9wbuEEp/EhznWy
         PuQxkziP/4op8RPUk4DiSdk+IJwwXZD6WTplsJkqoQr0VlmvsMVN57FU8hU51f/9E+Yg
         AYgdw5mZLOnnz5f5owrnpiLEwJag9JqbbHTT2oi3HdanS8tyiOZxwCtkx9NP0s4CGpRI
         BF+ivIA89iCIhKCt5pichwdL/5hI+vXg47y2tqWZfzEFlwvvtLxkKcIfT+cEH5k/V8Yi
         F3/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727988082; x=1728592882;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=boEYa3HkN7tpzzbSYKk62wIDlMPHZQ0hIQz86LI7hRE=;
        b=X2+1P3FYvbJSVK/0WUydvQ6zTfbrd4z2ez0XOiwvzEuIg8R/WdGknqZYYxZ0K9rP2K
         lun2ELrKTMh9o1h6J2HgPWYs7y84w/TMxlHY8cHCnpRzlGwKQruqMEuO+qK/9NlbIF02
         p2bhQE4SXrUcCVsuaxsP/vguC2PCacRtFnfnwsCEKFx9tqREzY69/QwAfIsGCzcMuQEW
         FTw3XcDURtLfo6dVSkQKvMcdmSWjI4Rry6OLLd+StCezEzup0KRI/MdVvuVsosc1LCMk
         8xAnXUVyVXKiOQGRtEX8Pt8TcFN4unppSVSWofOonva0mLqMZ4VtVRb7iffZ6uesz0qS
         d2Pw==
X-Gm-Message-State: AOJu0YwE5wmjsYLfQ+6/Pd5EImSapbpo1vYeLkjwOqyiWzskvuIzMtjq
	c7YK9E0duuMJlB9S+CGfkMTBRHRjO2VLtJLCLoLzTOfFKKEQpiKZzPbL+k7rDTXpg6TE2k5DV/h
	0
X-Google-Smtp-Source: AGHT+IGzP7Lv5qXDlb6kVZBnn4Y/1JUFD8AxCCUrN71trPm4nCtxxx1l7c7GbWRAwv5H0ty045zZbA==
X-Received: by 2002:a05:600c:190c:b0:42c:b8c9:16c8 with SMTP id 5b1f17b1804b1-42f856ae59emr2174765e9.10.1727988081503;
        Thu, 03 Oct 2024 13:41:21 -0700 (PDT)
Received: from ?IPv6:2003:de:3719:4a00:e912:812a:2309:b70? (p200300de37194a00e912812a23090b70.dip0.t-ipconnect.de. [2003:de:3719:4a00:e912:812a:2309:b70])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37d081f702asm1953276f8f.17.2024.10.03.13.41.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2024 13:41:21 -0700 (PDT)
Message-ID: <eb63e364321e7af634dc9aa8296e1820d3355e45.camel@suse.com>
Subject: Re: [PATCH v2 12/22] multipathd: split check_paths into two
 functions
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Thu, 03 Oct 2024 22:41:20 +0200
In-Reply-To: <20240912214947.783819-13-bmarzins@redhat.com>
References: <20240912214947.783819-1-bmarzins@redhat.com>
	 <20240912214947.783819-13-bmarzins@redhat.com>
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
> Instead of checking and updating each path, the checkerloop now
> starts
> the checkers on all the paths in check_paths(), and then goes back
> and
> updates all the paths in update_paths(). Since the async checkers use
> an
> absolute time to wait for before returning PATH_PENDING, only one
> checker actually needs to be waited for in update_paths(). The rest
> will
> already have reached their timeout when update_path() is called for
> them.
>=20
> The check_paths() and update_paths() loop over the pathvec instead of
> looping through the multipath device paths to avoid having to restart
> checking of the device paths when the multipath device needs to be
> resynced while updating the paths.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =C2=A0libmultipath/structs.h |=C2=A0 10 +++-
> =C2=A0multipathd/main.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 105 +++++++++++++=
++++++--------------------
> --
> =C2=A02 files changed, 57 insertions(+), 58 deletions(-)
>=20
> diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> index d8231e95..af8e31e9 100644
> --- a/libmultipath/structs.h
> +++ b/libmultipath/structs.h
> @@ -314,6 +314,14 @@ enum recheck_wwid_states {
> =C2=A0	RECHECK_WWID_ON =3D YNU_YES,
> =C2=A0};
> =C2=A0
> +enum check_path_states {
> +	CHECK_PATH_UNCHECKED,
> +	CHECK_PATH_STARTED,
> +	CHECK_PATH_CHECKED,
> +	CHECK_PATH_SKIPPED,
> +	CHECK_PATH_REMOVED,
> +};
> +
> =C2=A0struct vpd_vendor_page {
> =C2=A0	int pg;
> =C2=A0	const char *name;
> @@ -395,7 +403,7 @@ struct path {
> =C2=A0	int fast_io_fail;
> =C2=A0	unsigned int dev_loss;
> =C2=A0	int eh_deadline;
> -	bool is_checked;
> +	enum check_path_states is_checked;
> =C2=A0	bool can_use_env_uid;
> =C2=A0	unsigned int checker_timeout;
> =C2=A0	/* configlet pointers */
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 45d40559..9519b6c5 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -2389,13 +2389,6 @@ sync_mpp(struct vectors * vecs, struct
> multipath *mpp, unsigned int ticks)
> =C2=A0	do_sync_mpp(vecs, mpp);
> =C2=A0}
> =C2=A0
> -enum check_path_return {
> -	CHECK_PATH_STARTED,
> -	CHECK_PATH_CHECKED,
> -	CHECK_PATH_SKIPPED,
> -	CHECK_PATH_REMOVED,
> -};
> -
> =C2=A0static int
> =C2=A0update_path_state (struct vectors * vecs, struct path * pp)
> =C2=A0{
> @@ -2735,6 +2728,7 @@ check_uninitialized_path(struct path * pp,
> unsigned int ticks)
> =C2=A0	conf =3D get_multipath_config();
> =C2=A0	retrigger_tries =3D conf->retrigger_tries;
> =C2=A0	pp->tick =3D conf->max_checkint;
> +	pp->checkint =3D conf->checkint;
> =C2=A0	put_multipath_config(conf);
> =C2=A0
> =C2=A0	if (pp->initialized =3D=3D INIT_MISSING_UDEV) {
> @@ -2778,6 +2772,10 @@ update_uninitialized_path(struct vectors *
> vecs, struct path * pp)
> =C2=A0	int newstate, ret;
> =C2=A0	struct config *conf;
> =C2=A0
> +	if (pp->initialized !=3D INIT_NEW && pp->initialized !=3D
> INIT_FAILED &&
> +	=C2=A0=C2=A0=C2=A0 pp->initialized !=3D INIT_MISSING_UDEV)
> +		return CHECK_PATH_SKIPPED;
> +
> =C2=A0	newstate =3D get_new_state(pp);
> =C2=A0

It seems to me that this hunk and the previous one belong into 11/22.

Martin
