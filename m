Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F333235360
	for <dm-devel@lists.linux.dev>; Thu,  6 Nov 2025 20:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762460156; cv=none; b=BzS5sw3OEEasvZEcnaINXDxoCgaCWFgEYXrYYlX60XWiUcD0Tia8HSIRnw3eTinw5aDO7j+lWS4wYBs9iy1abtdXEdf48OpIL3MRjUqz6ztbkrbYVjuvyTl+bmr3CjyGJoVS6mgXB3zlSnLRIy4Dut8M1VNhXQdMAe31jWVvYZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762460156; c=relaxed/simple;
	bh=gS8d77LVXRPphfKXrC7lTjfii1dymfX6n5UrGOUj5c0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YXFTgG1BVQus6op7Ktmj2ArQr/bYqZfmsY7LknoZsRRoO9OMFhm/gO5vg57E1/3EzQBJNKBvsX+tbEhQ7bGgxkLDoKyBtZUmO4TKdkZRUkLzVwasavkc48O7W8sYwcnocbf2HtuR7KLZ6p81uxqWIz/wMzejDHiZ9a0Mm+Nts08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ITptK1jk; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ITptK1jk"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b726997b121so5801566b.0
        for <dm-devel@lists.linux.dev>; Thu, 06 Nov 2025 12:15:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762460152; x=1763064952; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VbSCltTwpwNbdrLaOnkmoAoQsHddeQ3zkGH7jd+Dg18=;
        b=ITptK1jk+CzPMfuS0PnNi6N9BQwFtCQcOrjAI81q/et/4BfKZ/R7m3mKCSmqdOOsAh
         PPehj6cQTJdL/71XMXlzNhMaf4kLpbnBivzONpJCtLzTHHBZdHvu2BkL3QAvVO8JbW4S
         aoPR9m3Jxz1UpaJ+fRGBhnuYS6NSd7t8OKVKl8bzjV5oqz1YVADK41eluWKhmnjHhvLX
         ZLiZkWWbsyXpSt1yuZn7H379sZFUzB8cNqgdGZxXlnwANO/vTrqEdmtSUqcMHnCv5lA3
         v2cw22UcXQu+SzFtY2prbq6fNYlDqs0hH+TEY13x2jDPIUaC7qekx3HlFqrraGZAUP3W
         2zrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762460152; x=1763064952;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VbSCltTwpwNbdrLaOnkmoAoQsHddeQ3zkGH7jd+Dg18=;
        b=Tp+8LpbHtKPnHrFlC+hFFHzlxkHP7ZNKUckizmnr6cUmpokKJ8mZTieHBT0Tn0MV4v
         j48SyqA7GiGzO1UCqorQSAcfZtdI49m6N3Q2Asd/kRBL8BaoB/XFeQMuQ466MZiA51Sl
         UIPwSfEwnCW3OGwnYJAQ62fjlyF8P6aM7BoCRDxkVYhw8pdLhHUweLbbmvr1ey5kKtVZ
         6LXyIF8CtYIb5bZ2E12TCSg6cYjdoH9kKFH/ZsEJoLKl5H41FCRIf6gR4Px2RurGgBaK
         dqtp/aVnLS62x5Esevdd2CSldjfcE2Og8vCQYraX06WcUj3F25/+hw0h2Pvdsgo4/qdy
         G6Ng==
X-Gm-Message-State: AOJu0YyLChTZgBz8HfMxOCKSiw8IWyAJO7YHzKXK3u7u4qng3xPkOZFc
	T638mvSqG2EwjLaqxZJEv7mGWbs2+o9kySDrjUsqcOH+7oOv9lMkfIa3IN9QzxZtH94=
X-Gm-Gg: ASbGncvE8WyHuQ7q5NzgT8tCbQlMYlXC1GbHnJVSj9AYbQc0XYCKzPPoSGT8RioBEVD
	LLl0ukrVuiaCZTlpX1zWnY9vC1Zp+ntMScA7dF17TrkdWV63dMeFcxglpBbyVqDZOvSHSvNyyAP
	JaezRR7N3UpNtK4XuDDfg+6W4zpcD6B3YUQpyc9XxrzTSJfUGCQoozGURcKsPvlaS6dqO8b8oFV
	BF26t38CcCuj34JNN1ag23WtRSiqlvLs0aefNm3cz5eFMTquwASSl2NJaDgymYsMKmMzufT2ZgG
	BqpIiFajTnNzLhgIiyixxguM4qmRV0PfVoYUop7NCmi9ASCesPjvSDFPdjgrdnhXIT5MwZ7gM9Q
	3EcYhus+FCPgOVxIgSjRF41oyZKRlSC5QFOGmXPFrCR0gCmBVVC0jCNdy1RNBNuhzLf5MeK1jQb
	vtB9OT6iGxYqtf9Px8tr370JsxSJ871x9FDaHCdt9o85xjaGEV7kNfgVVbSdZV7bqVd5FHoJ7HA
	S/zTKJLTyMahSBHLkynB1VA98KJjspFKAYfUf6GQgRPZgg=
X-Google-Smtp-Source: AGHT+IG/UhM5gQabzYaUo1AX1GAoCgjOIDrey+RG+Qni4ZiWy7Bz2g3WiwqteQyKwALKFB1b+faFrg==
X-Received: by 2002:a17:907:d0e:b0:b6d:51d4:802 with SMTP id a640c23a62f3a-b72896041b5mr499696666b.25.1762460149906;
        Thu, 06 Nov 2025 12:15:49 -0800 (PST)
Received: from ?IPv6:2003:f9:7f04:900:e894:a50a:fc99:6ee7? (p200300f97f040900e894a50afc996ee7.dip0.t-ipconnect.de. [2003:f9:7f04:900:e894:a50a:fc99:6ee7])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b72bf9be009sm41015566b.60.2025.11.06.12.15.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 12:15:49 -0800 (PST)
Message-ID: <f3932800e329c528e9f28275c656cc5fb7fa8a57.camel@suse.com>
Subject: Re: [PATCH] multipathd: Fix race while registering PR key
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Thu, 06 Nov 2025 21:15:48 +0100
In-Reply-To: <20251031191935.186170-1-bmarzins@redhat.com>
References: <20251031191935.186170-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Fri, 2025-10-31 at 15:19 -0400, Benjamin Marzinski wrote:
> When libmpathpersist registers a key, It first checks which paths are
> active, then registers the key on those paths, and then tells
> multipathd
> that the key has been registered, and it should start tracking it. If
> a path comes up after libmpathpersist checks for active paths, but
> before
> it tells multipathd that the key has been registered, multipathd will
> not
> register a key no that path (since it hasn't been told to that the
> device
> has a registered key yet). This can leave the device with a path that
> is
> missing a key.
>=20
> To solve this, when multipathd is told that a key has been
> registered,
> it checks if there are the same number of registered keys as active
> paths.=C2=A0 If there aren't, it registers keys on all the paths (at leas=
t
> until the number of registered keys and active paths are equal).

You may want to mention here that the nr_key_wanted check in
mpath_pr_event_handle() and the nr_active check in=20
pr_register_active_paths actually allow us to short-circuit a couple of
PR operations.

>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =C2=A0multipathd/cli_handlers.c |=C2=A0 6 ++++-
> =C2=A0multipathd/main.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=
 47 ++++++++++++++++++++++++++++---------
> --
> =C2=A0multipathd/main.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=
=C2=A0 1 +
> =C2=A03 files changed, 40 insertions(+), 14 deletions(-)
>=20
> diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> index 7f572fb4..2812d01e 100644
> --- a/multipathd/cli_handlers.c
> +++ b/multipathd/cli_handlers.c
> @@ -1291,7 +1291,11 @@ cli_setprstatus(void * v, struct strbuf
> *reply, void * data)
> =C2=A0
> =C2=A0	if (mpp->prflag !=3D PR_SET) {
> =C2=A0		set_pr(mpp);
> -		condlog(2, "%s: prflag set", param);
> +		pr_register_active_paths(mpp, true);
> +		if (mpp->prflag =3D=3D PR_SET)
> +			condlog(2, "%s: prflag set", param);
> +		else
> +			condlog(0, "%s: Failed to set prflag",
> param);
> =C2=A0	}
> =C2=A0	memset(&mpp->old_pr_key, 0, 8);
> =C2=A0
> diff --git a/multipathd/main.c b/multipathd/main.c
> index d11a8576..70268d98 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -90,7 +90,8 @@
> =C2=A0#define MSG_SIZE 32
> =C2=A0
> =C2=A0static unsigned int
> -mpath_pr_event_handle(struct path *pp, unsigned int nr_keys_needed);
> +mpath_pr_event_handle(struct path *pp, unsigned int nr_keys_needed,
> +		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned int nr_keys_wanted);
> =C2=A0
> =C2=A0#define LOG_MSG(lvl, pp)					\
> =C2=A0do {								\
> @@ -629,19 +630,28 @@ flush_map_nopaths(struct multipath *mpp, struct
> vectors *vecs) {
> =C2=A0	return true;
> =C2=A0}
> =C2=A0
> -static void
> -pr_register_active_paths(struct multipath *mpp)
> +void pr_register_active_paths(struct multipath *mpp, bool
> check_nr_active)
> =C2=A0{
> =C2=A0	unsigned int i, j, nr_keys =3D 0;
> +	unsigned int nr_active =3D 0;
> =C2=A0	struct path *pp;
> =C2=A0	struct pathgroup *pgp;
> =C2=A0
> +	if (check_nr_active) {
> +		nr_active =3D count_active_paths(mpp);
> +		if (!nr_active)
> +			return;
> +	}
> +
> =C2=A0	vector_foreach_slot (mpp->pg, pgp, i) {
> =C2=A0		vector_foreach_slot (pgp->paths, pp, j) {
> =C2=A0			if (mpp->prflag =3D=3D PR_UNSET)
> =C2=A0				return;
> -			if ((pp->state =3D=3D PATH_UP) || (pp->state =3D=3D
> PATH_GHOST))
> -				nr_keys =3D mpath_pr_event_handle(pp,
> nr_keys);
> +			if (pp->state =3D=3D PATH_UP || pp->state =3D=3D
> PATH_GHOST) {
> +				nr_keys =3D mpath_pr_event_handle(pp,
> nr_keys, nr_active);
> +				if (check_nr_active && nr_keys =3D=3D
> nr_active)
> +					return;
> +			}
> =C2=A0		}
> =C2=A0	}
> =C2=A0}
> @@ -729,7 +739,7 @@ fail:
> =C2=A0
> =C2=A0	sync_map_state(mpp, false);
> =C2=A0
> -	pr_register_active_paths(mpp);
> +	pr_register_active_paths(mpp, false);
> =C2=A0
> =C2=A0	if (VECTOR_SIZE(offline_paths) !=3D 0)
> =C2=A0		handle_orphaned_offline_paths(offline_paths);
> @@ -1319,7 +1329,7 @@ rescan:
> =C2=A0		verify_paths(mpp);
> =C2=A0		mpp->action =3D ACT_RELOAD;
> =C2=A0		prflag =3D mpp->prflag;
> -		mpath_pr_event_handle(pp, 0);
> +		mpath_pr_event_handle(pp, 0, 0);
> =C2=A0	} else {
> =C2=A0		if (!should_multipath(pp, vecs->pathvec, vecs-
> >mpvec)) {
> =C2=A0			orphan_path(pp, "only one path");
> @@ -1403,7 +1413,7 @@ rescan:
> =C2=A0
> =C2=A0	if (retries >=3D 0) {
> =C2=A0		if ((mpp->prflag =3D=3D PR_SET && prflag !=3D PR_SET) ||
> start_waiter)
> -			pr_register_active_paths(mpp);
> +			pr_register_active_paths(mpp, false);
> =C2=A0		condlog(2, "%s [%s]: path added to devmap %s",
> =C2=A0			pp->dev, pp->dev_t, mpp->alias);
> =C2=A0		return 0;
> @@ -2646,9 +2656,9 @@ update_path_state (struct vectors * vecs,
> struct path * pp)
> =C2=A0			 */
> =C2=A0			condlog(2, "%s: checking persistent "
> =C2=A0				"reservation registration", pp-
> >dev);
> -			mpath_pr_event_handle(pp, 0);
> +			mpath_pr_event_handle(pp, 0, 0);
> =C2=A0			if (pp->mpp->prflag =3D=3D PR_SET && prflag !=3D
> PR_SET)
> -				pr_register_active_paths(pp->mpp);
> +				pr_register_active_paths(pp->mpp,
> false);
> =C2=A0		}
> =C2=A0
> =C2=A0		/*
> @@ -3309,7 +3319,7 @@ configure (struct vectors * vecs, enum
> force_reload_types reload_type)
> =C2=A0	vector_foreach_slot(mpvec, mpp, i){
> =C2=A0		if (remember_wwid(mpp->wwid) =3D=3D 1)
> =C2=A0			trigger_paths_udev_change(mpp, true);
> -		pr_register_active_paths(mpp);
> +		pr_register_active_paths(mpp, false);
> =C2=A0	}
> =C2=A0
> =C2=A0	/*
> @@ -4341,16 +4351,25 @@ static int update_map_pr(struct multipath
> *mpp, struct path *pp, unsigned int *n
> =C2=A0}
> =C2=A0
> =C2=A0/*
> - * This function is called with the number of registered keys that
> should be
> + * This function is called with two numbers
> + *
> + * nr_keys_needed: the number of registered keys that should be
> =C2=A0 * seen for this device to know that the key has not been preempted
> while the
> =C2=A0 * path was getting registered. If 0 is passed in, update_mpath_pr
> is called
> =C2=A0 * before registering the key to figure out the number, assuming
> that at
> =C2=A0 * least one key must exist.
> =C2=A0 *
> + * nr_keys_wanted: Only used if nr_keys_needed is 0, so we don't
> know how
> + * many keys we currently have. If nr_keys_wanted in non-zero and
> the
> + * number of keys found by the initial call to update_map_pr()
> matches it,
> + * exit early, since we have all the keys we are expecting.
> + *
> =C2=A0 * The function returns the number of keys that are registered or 0
> if
> =C2=A0 * it's unknown.
> =C2=A0 */
> -static unsigned int mpath_pr_event_handle(struct path *pp, unsigned
> int nr_keys_needed)
> +static unsigned int
> +mpath_pr_event_handle(struct path *pp, unsigned int nr_keys_needed,
> +		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned int nr_keys_wanted)
> =C2=A0{
> =C2=A0	struct multipath *mpp =3D pp->mpp;
> =C2=A0	int ret;
> @@ -4366,6 +4385,8 @@ static unsigned int
> mpath_pr_event_handle(struct path *pp, unsigned int nr_keys_
> =C2=A0		nr_keys_needed =3D 1;
> =C2=A0		if (update_map_pr(mpp, pp, &nr_keys_needed) !=3D
> MPATH_PR_SUCCESS)
> =C2=A0			return 0;
> +		if (nr_keys_wanted && nr_keys_wanted =3D=3D
> nr_keys_needed)
> +			return nr_keys_needed;

I am wondering about the case that prflag gets unset by update_map_pr()
while nr_active is 1. In this case we'd return early without clearing
the registration. Is that correct?

I get it that this must mean that update_map_pr() has found 0 paths
with this key registered. But the comment below in the mpp->prflag !=3D
PR_SET suggests that maybe the registration should still be cleared.

Please explain.

Regards
Martin


> =C2=A0	}
> =C2=A0
> =C2=A0	check_prhold(mpp, pp);
> diff --git a/multipathd/main.h b/multipathd/main.h
> index 29b57e3d..6d60ee81 100644
> --- a/multipathd/main.h
> +++ b/multipathd/main.h
> @@ -54,4 +54,5 @@ int resize_map(struct multipath *mpp, unsigned long
> long size,
> =C2=A0	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct vectors *vecs);
> =C2=A0void set_pr(struct multipath *mpp);
> =C2=A0void unset_pr(struct multipath *mpp);
> +void pr_register_active_paths(struct multipath *mpp, bool
> check_active_nr);
> =C2=A0#endif /* MAIN_H_INCLUDED */
