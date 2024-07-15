Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFC2418EA96
	for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 15:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721057687; cv=none; b=pbB+SoPjbJKM61BjzHtHSgBOpoDymYUHeOQk9CbKc9nzAzs78WkgfLNxHQGZ7KcA7RsjeSiTKtdkh8gBOpiralI6l/aGzJyPYx7LAJ6noVf08oaj4UPMbO8r3WTTPG/LhmVU6fxfNr/3TtD+EE7EvlHj56jwzhLDzVSqCHTTlZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721057687; c=relaxed/simple;
	bh=xAilm3quxAeGFLz5Y7IIHI4ocT5hvHXRJ3KEbGgBlow=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LCi+sP9vBQ9oia7I4nZKnADJuCWEQCPlRtILAhS+lEFjoY0090IYXjfhB2XW124nSuV9CifKl+OejmFM4ybwtYankW/TONAq3LxRqsipdC26q6LauO5WYIaL/WzSPQCl2EzV07V4CeaTcleNI8/wiiwFsWGUXtAkUQJXCOI4vwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SwfKCjEI; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SwfKCjEI"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a77baa87743so498769066b.3
        for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 08:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1721057683; x=1721662483; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Xpgsr5fX4NTjSMuFNSUtr00Icge84Ilmv1pARrD8AcA=;
        b=SwfKCjEINcNfw60t5kbhpJ8K8I3A1wf3xMt8GE7An45NI75IKxOLSVN9EEPi2SYRZV
         IPGICffWRcKz0fuK0rgVDJs6I3PWhApMrSdiSpn+5zLUoKACnps3rUARq2EIuDEJp2z4
         IsoHsho879kt7DtUiml5fWtpL6TMw2axpOkXY470h+cLNPXUO8D2T61Rwfv8zQuG6ImM
         7Tk5/X5+5fz80RYKPINrY3bq/C3xGscfUJoWhT5+W5lEDisYrPItxMnJp5rV+0DigRjy
         qon2i5Hi/7xa6ijkLBAGFHqYJBW4Z9aW1ZDerIuiwTqDMmaZSQ/x0jLpjwH86s0lGvBu
         BiYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721057683; x=1721662483;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Xpgsr5fX4NTjSMuFNSUtr00Icge84Ilmv1pARrD8AcA=;
        b=uVF2UnRpxHdPpUfCouEYsR89VZLfvGjKk41Sc0x1kWDYhVdHuSxKoTReSySIc/y0uF
         4Jd1O6XoVg4uhhZKxNM+J38w012sjF6T8XFRICTjKM5qeKXG44Ljf6DJ2Lr/GLg6BciQ
         h5MnEwfGiQSBkzQr4ZLwYUJ7FgaurNVGMB2ZZo5nMcnJywr8N9ZyqMt4onBAyGHqlUJG
         v0kFVvYff8vBwWEGovpdJYqu16qKXeoKWDrhyUjIiGFa1BcefVYaybeinAMKZwhNX6d3
         IgGSOYnA3XBvFkyP8ufoY976raxJt6+RgpyAulRhynjWOpZ7RFVXO4VtcBS4b4aUCTOV
         Ei9w==
X-Gm-Message-State: AOJu0YxVdNkt/MEYKRpyTlXqPaW9KXPgxXrikpOmRQBYkvidvsYtFFEu
	vEH7N1HHbYTSDRzfm7NFIn/+QgkTPrVbXJ66hM4MGjT1dScEJVvN6gDxcxLs0kI=
X-Google-Smtp-Source: AGHT+IFW6euKHzjhjQs3z4R4+vXlR+PTh3UxRpZJVie/Zb8kPD9p57dLBG5ajArt6tL1Q9xuOvqJfw==
X-Received: by 2002:a17:906:c248:b0:a6f:4e1f:e613 with SMTP id a640c23a62f3a-a79e6a5a05bmr8783866b.37.1721057682878;
        Mon, 15 Jul 2024 08:34:42 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a79bc5e9dd6sm220600066b.97.2024.07.15.08.34.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jul 2024 08:34:42 -0700 (PDT)
Message-ID: <1eb0cdfbfd0f6cef110fa01802fa07c946011bc4.camel@suse.com>
Subject: Re: [PATCH 05/22] multipathd: handle uninitialized paths in new
 function
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Mon, 15 Jul 2024 17:34:41 +0200
In-Reply-To: <20240713060506.2015463-6-bmarzins@redhat.com>
References: <20240713060506.2015463-1-bmarzins@redhat.com>
	 <20240713060506.2015463-6-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Sat, 2024-07-13 at 02:04 -0400, Benjamin Marzinski wrote:
> Pull the code to handle uninitialized paths out of check_path() and
> into
> a new function called handle_uninitialized_paths(). This should cause
> no functional changes.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =C2=A0multipathd/main.c | 171 ++++++++++++++++++++++++++++---------------=
-
> --
> =C2=A01 file changed, 105 insertions(+), 66 deletions(-)
>=20
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 9b1b5226..9e329e89 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -2343,8 +2343,7 @@ check_path_state(struct path *pp)
> =C2=A0}
> =C2=A0
> =C2=A0/*
> - * Returns '1' if the path has been checked, '-1' if it was
> blacklisted
> - * and '0' otherwise
> + * Returns '1' if the path has been checked and '0' otherwise
> =C2=A0 */
> =C2=A0int
> =C2=A0check_path (struct vectors * vecs, struct path * pp, unsigned int
> ticks)
> @@ -2354,16 +2353,13 @@ check_path (struct vectors * vecs, struct
> path * pp, unsigned int ticks)
> =C2=A0	int chkr_new_path_up =3D 0;
> =C2=A0	int disable_reinstate =3D 0;
> =C2=A0	int oldchkrstate =3D pp->chkrstate;
> -	int retrigger_tries;
> =C2=A0	unsigned int checkint, max_checkint;
> =C2=A0	struct config *conf;
> =C2=A0	int marginal_pathgroups, marginal_changed =3D 0;
> =C2=A0	int ret;
> =C2=A0	bool need_reload;
> =C2=A0
> -	if (((pp->initialized =3D=3D INIT_OK || pp->initialized =3D=3D
> INIT_PARTIAL ||
> -	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pp->initialized =3D=3D INIT_REQUESTED_UD=
EV) && !pp->mpp)
> ||
> -	=C2=A0=C2=A0=C2=A0 pp->initialized =3D=3D INIT_REMOVED)
> +	if (pp->initialized =3D=3D INIT_REMOVED)
> =C2=A0		return 0;
> =C2=A0
> =C2=A0	if (pp->tick)
> @@ -2372,7 +2368,6 @@ check_path (struct vectors * vecs, struct path
> * pp, unsigned int ticks)
> =C2=A0		return 0; /* don't check this path yet */
> =C2=A0
> =C2=A0	conf =3D get_multipath_config();
> -	retrigger_tries =3D conf->retrigger_tries;
> =C2=A0	checkint =3D conf->checkint;
> =C2=A0	max_checkint =3D conf->max_checkint;
> =C2=A0	marginal_pathgroups =3D conf->marginal_pathgroups;
> @@ -2383,38 +2378,6 @@ check_path (struct vectors * vecs, struct path
> * pp, unsigned int ticks)
> =C2=A0		pp->checkint =3D checkint;
> =C2=A0	};
> =C2=A0
> -	if (!pp->mpp && pp->initialized =3D=3D INIT_MISSING_UDEV) {
> -		if (pp->retriggers < retrigger_tries) {
> -			static const char change[] =3D "change";
> -			ssize_t ret;
> -
> -			condlog(2, "%s: triggering change event to
> reinitialize",
> -				pp->dev);
> -			pp->initialized =3D INIT_REQUESTED_UDEV;
> -			pp->retriggers++;
> -			ret =3D sysfs_attr_set_value(pp->udev,
> "uevent", change,
> -						=C2=A0=C2=A0 sizeof(change) -
> 1);
> -			if (ret !=3D sizeof(change) - 1)
> -				log_sysfs_attr_set_value(1, ret,
> -							 "%s: failed
> to trigger change event",
> -							 pp->dev);
> -			return 0;
> -		} else {
> -			condlog(1, "%s: not initialized after %d
> udev retriggers",
> -				pp->dev, retrigger_tries);
> -			/*
> -			 * Make sure that the "add missing path"
> code path
> -			 * below may reinstate the path later, if it
> ever
> -			 * comes up again.
> -			 * The WWID needs not be cleared; if it was
> set, the
> -			 * state hadn't been INIT_MISSING_UDEV in
> the first
> -			 * place.
> -			 */
> -			pp->initialized =3D INIT_FAILED;
> -			return 0;
> -		}
> -	}
> -
> =C2=A0	/*
> =C2=A0	 * provision a next check soonest,
> =C2=A0	 * in case we exit abnormally from here
> @@ -2435,32 +2398,6 @@ check_path (struct vectors * vecs, struct path
> * pp, unsigned int ticks)
> =C2=A0		pp->checkint =3D checkint;
> =C2=A0		return 1;
> =C2=A0	}
> -	if (!pp->mpp) {
> -		if (!strlen(pp->wwid) &&
> -		=C2=A0=C2=A0=C2=A0 (pp->initialized =3D=3D INIT_FAILED ||
> -		=C2=A0=C2=A0=C2=A0=C2=A0 pp->initialized =3D=3D INIT_NEW) &&
> -		=C2=A0=C2=A0=C2=A0 (newstate =3D=3D PATH_UP || newstate =3D=3D PATH_GH=
OST))
> {
> -			condlog(2, "%s: add missing path", pp->dev);
> -			conf =3D get_multipath_config();
> -			pthread_cleanup_push(put_multipath_config,
> conf);
> -			ret =3D pathinfo(pp, conf, DI_ALL |
> DI_BLACKLIST);
> -			pthread_cleanup_pop(1);
> -			/* INIT_OK implies ret =3D=3D PATHINFO_OK */
> -			if (pp->initialized =3D=3D INIT_OK) {
> -				ev_add_path(pp, vecs, 1);
> -				pp->tick =3D 1;
> -			} else {
> -				if (ret =3D=3D PATHINFO_SKIPPED)
> -					return -1;
> -				/*
> -				 * We failed multiple times to
> initialize this
> -				 * path properly. Don't re-check too
> often.
> -				 */
> -				pp->checkint =3D max_checkint;
> -			}
> -		}
> -		return 0;
> -	}
> =C2=A0	/*
> =C2=A0	 * Async IO in flight. Keep the previous path state
> =C2=A0	 * and reschedule as soon as possible
> @@ -2679,6 +2616,104 @@ check_path (struct vectors * vecs, struct
> path * pp, unsigned int ticks)
> =C2=A0	return 1;
> =C2=A0}
> =C2=A0
> +/*
> + * Returns -1 if the path was blacklisted, and 0 otherwise
> + */
> +static int
> +handle_uninitialized_path(struct vectors * vecs, struct path * pp,
> +			=C2=A0 unsigned int ticks)
> +{
> +	int newstate;
> +	int retrigger_tries;
> +	unsigned int checkint, max_checkint;
> +	struct config *conf;
> +	int ret;
> +
> +	if (((pp->initialized =3D=3D INIT_OK || pp->initialized =3D=3D
> INIT_PARTIAL ||
> +	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pp->initialized =3D=3D INIT_REQUESTED_UD=
EV) && !pp->mpp)
> ||
> +	=C2=A0=C2=A0=C2=A0 pp->initialized =3D=3D INIT_REMOVED)
> +		return 0;

!pp->mpp always holds if this function is called, so we can skip this
part of the test.

> +
> +	if (pp->tick)
> +		pp->tick -=3D (pp->tick > ticks) ? ticks : pp->tick;
> +	if (pp->tick)
> +		return 0; /* don't check this path yet */

IMO it would make sense to move this code into checkerloop(). Actually
we could make sure that for those paths that are initialized but not
part of an mpp (see above), pp->tick is always zero.

> +
> +	conf =3D get_multipath_config();
> +	retrigger_tries =3D conf->retrigger_tries;
> +	checkint =3D conf->checkint;
> +	max_checkint =3D conf->max_checkint;
> +	put_multipath_config(conf);
> +
> +	if (!pp->mpp && pp->initialized =3D=3D INIT_MISSING_UDEV) {
> +		if (pp->retriggers < retrigger_tries) {
> +			static const char change[] =3D "change";
> +			ssize_t ret;
> +
> +			condlog(2, "%s: triggering change event to
> reinitialize",
> +				pp->dev);
> +			pp->initialized =3D INIT_REQUESTED_UDEV;
> +			pp->retriggers++;
> +			ret =3D sysfs_attr_set_value(pp->udev,
> "uevent", change,
> +						=C2=A0=C2=A0 sizeof(change) -
> 1);
> +			if (ret !=3D sizeof(change) - 1)
> +				log_sysfs_attr_set_value(1, ret,
> +							 "%s: failed
> to trigger change event",
> +							 pp->dev);
> +			return 0;
> +		} else {
> +			condlog(1, "%s: not initialized after %d
> udev retriggers",
> +				pp->dev, retrigger_tries);
> +			/*
> +			 * Make sure that the "add missing path"
> code path
> +			 * below may reinstate the path later, if it
> ever
> +			 * comes up again.
> +			 * The WWID needs not be cleared; if it was
> set, the
> +			 * state hadn't been INIT_MISSING_UDEV in
> the first
> +			 * place.
> +			 */
> +			pp->initialized =3D INIT_FAILED;
> +			return 0;
> +		}
> +	}
> +
> +	/*
> +	 * provision a next check soonest,
> +	 * in case we exit abnormally from here
> +	 */
> +	pp->tick =3D checkint;
> +
> +	newstate =3D check_path_state(pp);
> +
> +	if (!pp->mpp) {

Again, this test can be skipped, or am I overlooking something?

> +		if (!strlen(pp->wwid) &&
> +		=C2=A0=C2=A0=C2=A0 (pp->initialized =3D=3D INIT_FAILED ||
> +		=C2=A0=C2=A0=C2=A0=C2=A0 pp->initialized =3D=3D INIT_NEW) &&
> +		=C2=A0=C2=A0=C2=A0 (newstate =3D=3D PATH_UP || newstate =3D=3D PATH_GH=
OST))
> {
> +			condlog(2, "%s: add missing path", pp->dev);
> +			conf =3D get_multipath_config();
> +			pthread_cleanup_push(put_multipath_config,
> conf);
> +			ret =3D pathinfo(pp, conf, DI_ALL |
> DI_BLACKLIST);
> +			pthread_cleanup_pop(1);
> +			/* INIT_OK implies ret =3D=3D PATHINFO_OK */
> +			if (pp->initialized =3D=3D INIT_OK) {
> +				ev_add_path(pp, vecs, 1);
> +				pp->tick =3D 1;
> +			} else {
> +				if (ret =3D=3D PATHINFO_SKIPPED)
> +					return -1;
> +				/*
> +				 * We failed multiple times to
> initialize this
> +				 * path properly. Don't re-check too
> often.
> +				 */
> +				pp->checkint =3D max_checkint;
> +			}
> +		}
> +		return 0;
> +	}
> +	return 0;
> +}
> +
> =C2=A0enum checker_state {
> =C2=A0	CHECKER_STARTING,
> =C2=A0	CHECKER_RUNNING,
> @@ -2751,7 +2786,11 @@ checkerloop (void *ap)
> =C2=A0				if (pp->is_checked)
> =C2=A0					continue;
> =C2=A0				pp->is_checked =3D true;
> -				rc =3D check_path(vecs, pp, ticks);
> +				if (pp->mpp)
> +					rc =3D check_path(vecs, pp,
> ticks);
> +				else
> +					rc =3D
> handle_uninitialized_path(vecs, pp,
> +								=C2=A0=C2=A0=C2=A0=C2=A0
> =C2=A0=C2=A0 ticks);
> =C2=A0				if (rc < 0) {
> =C2=A0					condlog(1, "%s: check_path()
> failed, removing",
> =C2=A0						pp->dev);

