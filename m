Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE5E1AAE3F
	for <dm-devel@lists.linux.dev>; Thu,  3 Oct 2024 20:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727987037; cv=none; b=At5GyQtxupsG/9ozsaFz7c/7kR8tUb5eNEPfTB2sA1dK9u9SoZq77n6Fn8FB2XMYdbBbtd/wzDkntqYUITJmbC+LJd3AdrSlLjDhLuG+/rLg2iPzqcBXdyMD5moG9Hz9RfetDfEDjty9HitII2SSUN39/IUQ6k+/rhMQiDcl96s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727987037; c=relaxed/simple;
	bh=6PnIZbz+pYMQ1E6/4NnZhx4b/ytvuoJk//BGPGuWR1E=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iHeVaygoYsWgS7XH3Uhaw385UaiwC4wLRZtL3dZNClbsrc/N3dikPgkUdYzAcMcEvmPMSBtra6SiUlQ4QxN9OyIlSbIZQ4OiRvvBlHDweU4jjYpPVIpHvOZ8qvGQ8fsAeBsAV9AgMHti8do+kRFOVaYNFnwxU1vEaO0nJFrHpTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=XW94EPRu; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="XW94EPRu"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5c881aa669fso1502806a12.0
        for <dm-devel@lists.linux.dev>; Thu, 03 Oct 2024 13:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1727987033; x=1728591833; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PY5GjvMwC9LaR0TtuvxGJ3wwWoSUESEEJL5vQCbxgVM=;
        b=XW94EPRu1P2AkwKeNN93tVDciznV4t3i24FIDhIaP+sSkSm16HdYt5vPDTxEIDDbY2
         zEpA6aTNc3465/qDhMgFryJru33C25pUPLh7YN2vrGtkJ+QjHafdPi99QA1bVB+2wllW
         IaUsBMF9aeVuTValKXTzfZHOPZcqTOzTpVhQqcb8Gc6djKbk8SRTzp9P7vNt5OU2pA8d
         ynIAqHtDm0eTDeJePq1GBkAHEp5JAU/hp5xlmbf8xt2kz3ki61wf9F5nrt1kmpHoKsvF
         /TU01yXV2PrATAOub5gqvJGvybHYHysiRc40wd5IoSbIIk2axbLank62vwQMJDyQfSZt
         Ahww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727987033; x=1728591833;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PY5GjvMwC9LaR0TtuvxGJ3wwWoSUESEEJL5vQCbxgVM=;
        b=KS3O+9eB/K6zSiJmeRtGsdgh1iqYChfaNhu5V1lCzVAkWpove6FOLh/wuGp0KQGjMv
         S+k8nxzAy6Hx/asY/TR8o8pFpurVJ5FvQj1bmg7j/vB1OYeLW4SM+wXv3Cnz79VSDsfY
         9r7N4DkkMKXoovmtGBX8oycMt1FI6+u6uO2O2/SgP5F0k9RNFyYMMKyENoJbM5Ie4P1o
         imQABALMRk/3gB1lS1naPr5U6T8zM8jXN9C8rOTrFmrufeT0uuiCPZdGVWxpBT+qaVet
         4GoMVaB7KDV5pVjVI8nKcoTRG/x7pdN1kQ1lhhVRCrnahq0GfU4IN5Oy4oH/QsXKTq7s
         pcpA==
X-Gm-Message-State: AOJu0YzhLgbbe/Dc8jwZ9I6MQUF0D5yNgUiUHz09YNJvLc/9+doiQIT+
	JMzA+GqnUr+cdK/UboB/LA/nS6SrxB/khJrw1ZssNm7Dn1M+ULB4rKANW/D4E0E=
X-Google-Smtp-Source: AGHT+IHf9wTyIWsq87c4jnwY+yQDoYpS0IFc3RUQvhTQIoQAjX4z/4XU/6zSQSmJ0XSzSmfe/V/fmA==
X-Received: by 2002:a17:907:e617:b0:a8d:68fd:cae6 with SMTP id a640c23a62f3a-a991bdbb133mr46098966b.49.1727987032810;
        Thu, 03 Oct 2024 13:23:52 -0700 (PDT)
Received: from ?IPv6:2003:de:3719:4a00:e912:812a:2309:b70? (p200300de37194a00e912812a23090b70.dip0.t-ipconnect.de. [2003:de:3719:4a00:e912:812a:2309:b70])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a99102ae6e0sm128968166b.95.2024.10.03.13.23.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2024 13:23:52 -0700 (PDT)
Message-ID: <d9deb2b87f50016daef904a5c639ee90f2809b1c.camel@suse.com>
Subject: Re: [PATCH v2 09/22] multipathd: split do_checker_path
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Thu, 03 Oct 2024 22:23:51 +0200
In-Reply-To: <20240912214947.783819-10-bmarzins@redhat.com>
References: <20240912214947.783819-1-bmarzins@redhat.com>
	 <20240912214947.783819-10-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

Nit: the subject should refer to "do_check_path".
Also, the word "split" is somewhat confusing as you've been using it=20
for actually splitting one function into two elsewhere in this set.

Perhaps just call the patch "rename do_check_path to
update_path_state".

On Thu, 2024-09-12 at 17:49 -0400, Benjamin Marzinski wrote:
> Move the code that starts the path checker from do_check_path() into
> check_path(), rename the remainder of do_check_path() to
> update_path_state() and call that from check_path().
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =C2=A0multipathd/main.c | 21 +++++++++++----------
> =C2=A01 file changed, 11 insertions(+), 10 deletions(-)
>=20
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 16c0531e..9319751e 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -2396,7 +2396,7 @@ enum check_path_return {
> =C2=A0};
> =C2=A0
> =C2=A0static int
> -do_check_path (struct vectors * vecs, struct path * pp)
> +update_path_state (struct vectors * vecs, struct path * pp)
> =C2=A0{
> =C2=A0	int newstate;
> =C2=A0	int new_path_up =3D 0;
> @@ -2414,12 +2414,6 @@ do_check_path (struct vectors * vecs, struct
> path * pp)
> =C2=A0	marginal_pathgroups =3D conf->marginal_pathgroups;
> =C2=A0	put_multipath_config(conf);
> =C2=A0
> -	if (pp->checkint =3D=3D CHECKINT_UNDEF) {
> -		condlog(0, "%s: BUG: checkint is not set", pp->dev);
> -		pp->checkint =3D checkint;
> -	};
> -
> -	start_path_check(pp);
> =C2=A0	newstate =3D get_new_state(pp);
> =C2=A0	if (newstate =3D=3D PATH_WILD || newstate =3D=3D PATH_UNCHECKED)
> =C2=A0		return CHECK_PATH_SKIPPED;
> @@ -2639,7 +2633,7 @@ check_path (struct vectors * vecs, struct path
> * pp, unsigned int ticks,
> =C2=A0	=C2=A0=C2=A0=C2=A0 time_t start_secs)
> =C2=A0{
> =C2=A0	int r;
> -	unsigned int adjust_int, max_checkint;
> +	unsigned int adjust_int, checkint, max_checkint;
> =C2=A0	struct config *conf;
> =C2=A0	time_t next_idx, goal_idx;
> =C2=A0
> @@ -2652,14 +2646,21 @@ check_path (struct vectors * vecs, struct
> path * pp, unsigned int ticks,
> =C2=A0		return CHECK_PATH_SKIPPED;
> =C2=A0
> =C2=A0	conf =3D get_multipath_config();
> +	checkint =3D conf->checkint;
> =C2=A0	max_checkint =3D conf->max_checkint;
> =C2=A0	adjust_int =3D conf->adjust_int;
> =C2=A0	put_multipath_config(conf);
> =C2=A0
> -	r =3D do_check_path(vecs, pp);
> +	if (pp->checkint =3D=3D CHECKINT_UNDEF) {
> +		condlog(0, "%s: BUG: checkint is not set", pp->dev);
> +		pp->checkint =3D checkint;
> +	}
> +
> +	start_path_check(pp);
> +	r =3D update_path_state(vecs, pp);
> =C2=A0
> =C2=A0	/*
> -	 * do_check_path() removed or orphaned the path.
> +	 * update_path() removed or orphaned the path.

Nit: update_path() is introduced in the follow-up patch.
Should this be update_path_state()?

Martin


> =C2=A0	 */
> =C2=A0	if (r =3D=3D CHECK_PATH_REMOVED || !pp->mpp)
> =C2=A0		return r;

