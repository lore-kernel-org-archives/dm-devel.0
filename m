Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05BDC1369B1
	for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 20:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721076599; cv=none; b=aUAjmOVFr7VcQnC161eJD2LyuTXGPWxkhCBTcN5bZ/fVfLoMGnsBDDItAJ9y+j5j6fcVOsSq2s5maQnqld0GN+hvooTwcjdS7aQMEmMdLuwJbP8HvJpJ129UuFPBCMSE23gmpRWzyS0c7pH4iRJrbk3/IzMhuzjcReiQiJzt72g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721076599; c=relaxed/simple;
	bh=VsLqkkBtUwNN4Qn2jul6PbYzht2jBfS+I1y8CnrrHds=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XTVYTQWKXelzZl5nsTdDlibBnEqKHgRAIhOAtJ0+VRwPlr9kVeGGcWJgZNwX3sip7/PfG5ds+MmDZuwJHu0DKvPIqvfMtEp6N6R55MpKl+IIdv7S4TLvlm6eOjoeCL5cgNMI1SkljOSJQdRO5ZMQiYz2iVh2ZrwG4mDm0eIlAFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fvE11P+E; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fvE11P+E"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4266182a9d7so30100815e9.0
        for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 13:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1721076594; x=1721681394; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pTn2h20Em9TsCSQX6teBrYr7wiRw6a4PqO6a6+TnxZo=;
        b=fvE11P+EpXnIKD9HvNQt9IJUfk2M67FAJ2EYNW311GRATwB7R0T4NPdbDmkanG0A8g
         hhNrdxo7+FiRx/4vPLHTdnlYHtaDRnKWdC3g8iSbhNlyRIdz0B22N5pjlSM/WaFSMaRb
         VkCYDEG+Gc0Lb+Xz6uK4eK+35jl7UTpxfIflLpe8Yt7k7VlUn0aB3S7xT8F/EgKbucEp
         fREWbcCO7MJxCDmoGhG7LAs6VmRn7sjHDAcPt5GUKOlzuqaHf9I6jy79bLnOIqFpuMVp
         B+SEcmHKnMHlL9HEfLW840RxA6vwfkwH0+zre+eBxBzqWhdFSlY5NucWhxWHIjwSzWs4
         roLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721076594; x=1721681394;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pTn2h20Em9TsCSQX6teBrYr7wiRw6a4PqO6a6+TnxZo=;
        b=dUWJ4jo57mORvRac88g5t14v252yDaqc61QIwwjU6hFOyzHNTT7AGL0OqozLjM5AaH
         dyuiX3QxC2v0hgjDzMpykuNUaq8h8qaB8R9j0gpuNsT3syAVbaaUwp+/XYkvJxn+WNVO
         GnaFxWRXMLMdaMHGza/mmBmfrLnPpvOgRd4sYO8NP1LJQeZs8mp7dl1IhrEJaQX0G12W
         ibKT8v2WFcuRJgT5O5vN3A0kRjiqSAAu+kvQLT6+0fL6d+Fh0kpkBVcz/qvMSn0g+LFo
         htcGhhYEv1ndorfy1GlB18uzFqJ0CKkUqkXp0cIvPzMAIGpaqqR3mai/3iEQG8xap3zQ
         fIwA==
X-Gm-Message-State: AOJu0YzsEkvm6sgRi3tETYxWQaox/azN8mdoCYaWfC0iR/GuYNGaJh2m
	T88TcFVs6F70JWruegig8iW1cMOOOQUuxjnGtndF27bwqGGvcY7UVh+nJFBq8Kk=
X-Google-Smtp-Source: AGHT+IGNwtpNWXYs+PYxGMEhIfhfw4nbvjq2QeP2YlLN8oNslLym2hKrQtC62QotlM8pVe2wOduJkQ==
X-Received: by 2002:a05:600c:198c:b0:426:623f:34ae with SMTP id 5b1f17b1804b1-427ba6869bbmr449145e9.16.1721076593928;
        Mon, 15 Jul 2024 13:49:53 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-427a5e983e7sm99437885e9.23.2024.07.15.13.49.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jul 2024 13:49:53 -0700 (PDT)
Message-ID: <d3f37fe2e7f160b54098b2f54539696c0256c86f.camel@suse.com>
Subject: Re: [PATCH 19/22] multipathd: make multipath devices manage their
 path check times
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Mon, 15 Jul 2024 22:49:52 +0200
In-Reply-To: <20240713060506.2015463-20-bmarzins@redhat.com>
References: <20240713060506.2015463-1-bmarzins@redhat.com>
	 <20240713060506.2015463-20-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Sat, 2024-07-13 at 02:05 -0400, Benjamin Marzinski wrote:
> multipathd's path checking can be very bursty, with all the paths
> running their path checkers at the same time, and then all doing
> nothing
> while waiting for the next check time. Alternatively, the paths in a
> multipath device might all run their path checkers at a different
> time,
> which can keep the multipath device from having a coherent view of
> the
> state of all of its paths.
>=20
> This patch makes all the paths of a multipath device converge to
> running
> their checkers at the same time, and spreads out when this time is
> for
> the different multipath devices.
>=20
> To do this, the checking time is divided into adjustment intervals
> (conf->adjust_int), so that the checkers run at some index within
> this
> interval. conf->adjust_int is chosen so that it is at least twice as
> long as conf->max_checkint, and is a multiple of all possible
> pp->checkint values. This means that regardless of pp->checkint, the
> path should always be checked on the same indexes, each adjustement
> interval.
>=20
> Each multipath device has a goal index. These are evenly spread out
> between 0 and conf->max_checkint. Every conf->adjust_int seconds,
> each
> multipath device should try to check all of its paths on its goal
> index.
> If a path isn't checked on the goal index, then pp->tick for the next
> check after the goal_idx will be decremented by one, to align it over
> time.
>=20
> In order for the path checkers to run every pp->checkint seconds,
> multipathd needs to track how long a path check has been pending for,
> and subtract that time from the number of ticks till the checker is
> run
> again. If the checker has been pending for more that pp->checkint,
> the path will be rechecked on the next tick after the checker
> returns.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Nice, thanks a lot. I have a few remarks  below.


> ---
> =C2=A0libmultipath/config.c=C2=A0 | 13 ++++++
> =C2=A0libmultipath/config.h=C2=A0 |=C2=A0 1 +
> =C2=A0libmultipath/structs.c |=C2=A0 1 +
> =C2=A0libmultipath/structs.h |=C2=A0 1 +
> =C2=A0multipathd/main.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 90 ++++++++++++++=
++++++++++++++++++++------
> --
> =C2=A05 files changed, 89 insertions(+), 17 deletions(-)
>=20
> diff --git a/libmultipath/config.c b/libmultipath/config.c
> index 83fa7369..ca584372 100644
> --- a/libmultipath/config.c
> +++ b/libmultipath/config.c
> @@ -982,6 +982,19 @@ int _init_config (const char *file, struct
> config *conf)
> =C2=A0		conf->checkint =3D conf->max_checkint;
> =C2=A0	condlog(3, "polling interval: %d, max: %d",
> =C2=A0		conf->checkint, conf->max_checkint);
> +	/*
> +	 * make sure that that adjust_int is at least twice as large
> +	 * as checkint and is a multiple of all possible values of
> +	 * pp->checkint.
> +	 */
> +	if (conf->max_checkint % conf->checkint =3D=3D 0) {
> +		conf->adjust_int =3D 2 * conf->max_checkint;
> +	} else {
> +		conf->adjust_int =3D conf->checkint;
> +		while (2 * conf->adjust_int < conf->max_checkint)
> +			conf->adjust_int *=3D 2;
> +		conf->adjust_int *=3D conf->max_checkint;
> +	}
> =C2=A0
> =C2=A0	if (conf->blist_devnode =3D=3D NULL) {
> =C2=A0		conf->blist_devnode =3D vector_alloc();
> diff --git a/libmultipath/config.h b/libmultipath/config.h
> index 384193ab..800c0ca9 100644
> --- a/libmultipath/config.h
> +++ b/libmultipath/config.h
> @@ -147,6 +147,7 @@ struct config {
> =C2=A0	int minio_rq;
> =C2=A0	unsigned int checkint;
> =C2=A0	unsigned int max_checkint;
> +	unsigned int adjust_int;
> =C2=A0	bool use_watchdog;
> =C2=A0	int pgfailback;
> =C2=A0	int rr_weight;
> diff --git a/libmultipath/structs.c b/libmultipath/structs.c
> index 1583e001..472e1001 100644
> --- a/libmultipath/structs.c
> +++ b/libmultipath/structs.c
> @@ -148,6 +148,7 @@ uninitialize_path(struct path *pp)
> =C2=A0	pp->dmstate =3D PSTATE_UNDEF;
> =C2=A0	pp->uid_attribute =3D NULL;
> =C2=A0	pp->checker_timeout =3D 0;
> +	pp->pending_ticks =3D 0;
> =C2=A0
> =C2=A0	if (checker_selected(&pp->checker))
> =C2=A0		checker_put(&pp->checker);
> diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> index 002eeae1..457d7836 100644
> --- a/libmultipath/structs.h
> +++ b/libmultipath/structs.h
> @@ -360,6 +360,7 @@ struct path {
> =C2=A0	unsigned long long size;
> =C2=A0	unsigned int checkint;
> =C2=A0	unsigned int tick;
> +	unsigned int pending_ticks;
> =C2=A0	int bus;
> =C2=A0	int offline;
> =C2=A0	int state;
> diff --git a/multipathd/main.c b/multipathd/main.c
> index daf668eb..42ccb92f 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -2386,7 +2386,7 @@ check_mpp(struct vectors * vecs, struct
> multipath *mpp, unsigned int ticks)
> =C2=A0 * and '0' otherwise
> =C2=A0 */
> =C2=A0static int
> -check_path (struct vectors * vecs, struct path * pp, unsigned int
> ticks)
> +do_check_path (struct vectors * vecs, struct path * pp)
> =C2=A0{
> =C2=A0	int newstate;
> =C2=A0	int new_path_up =3D 0;
> @@ -2398,14 +2398,6 @@ check_path (struct vectors * vecs, struct path
> * pp, unsigned int ticks)
> =C2=A0	int marginal_pathgroups, marginal_changed =3D 0;
> =C2=A0	bool need_reload;
> =C2=A0
> -	if (pp->initialized =3D=3D INIT_REMOVED)
> -		return 0;
> -
> -	if (pp->tick)
> -		pp->tick -=3D (pp->tick > ticks) ? ticks : pp->tick;
> -	if (pp->tick)
> -		return 0; /* don't check this path yet */
> -
> =C2=A0	conf =3D get_multipath_config();
> =C2=A0	checkint =3D conf->checkint;
> =C2=A0	max_checkint =3D conf->max_checkint;
> @@ -2417,12 +2409,6 @@ check_path (struct vectors * vecs, struct path
> * pp, unsigned int ticks)
> =C2=A0		pp->checkint =3D checkint;
> =C2=A0	};
> =C2=A0
> -	/*
> -	 * provision a next check soonest,
> -	 * in case we exit abnormally from here
> -	 */
> -	pp->tick =3D checkint;
> -
> =C2=A0	newstate =3D check_path_state(pp);
> =C2=A0	if (newstate =3D=3D PATH_WILD || newstate =3D=3D PATH_UNCHECKED)
> =C2=A0		return 0;
> @@ -2584,7 +2570,6 @@ check_path (struct vectors * vecs, struct path
> * pp, unsigned int ticks)
> =C2=A0				condlog(4, "%s: delay next check
> %is",
> =C2=A0					pp->dev_t, pp->checkint);
> =C2=A0			}
> -			pp->tick =3D pp->checkint;
> =C2=A0		}
> =C2=A0	}
> =C2=A0	else if (newstate !=3D PATH_UP && newstate !=3D PATH_GHOST) {
> @@ -2637,6 +2622,76 @@ check_path (struct vectors * vecs, struct path
> * pp, unsigned int ticks)
> =C2=A0	return 1;
> =C2=A0}
> =C2=A0
> +static int
> +check_path (struct vectors * vecs, struct path * pp, unsigned int
> ticks,
> +	=C2=A0=C2=A0=C2=A0 time_t start_secs)
> +{
> +	int r;
> +	unsigned int adjust_int, max_checkint;
> +	struct config *conf;
> +	time_t next_idx, goal_idx;
> +
> +	if (pp->initialized =3D=3D INIT_REMOVED)
> +		return 0;
> +
> +	if (pp->tick)
> +		pp->tick -=3D (pp->tick > ticks) ? ticks : pp->tick;
> +	if (pp->tick)
> +		return 0; /* don't check this path yet */
> +
> +	conf =3D get_multipath_config();
> +	max_checkint =3D conf->max_checkint;
> +	adjust_int =3D conf->adjust_int;
> +	put_multipath_config(conf);
> +
> +	r =3D do_check_path(vecs, pp);
> +
> +	/*
> +	 * do_check_path() removed or orphaned the path.
> +	 */
> +	if (r < 0 || !pp->mpp)
> +		return r;
> +
> +	/*
> +	 * the path checker is pending
> +	 */
> +	if (pp->tick !=3D 0) {

I'm not getting this logic. Please explain. Why is pp->tick !=3D 0 at
this point equivalent to the checker being pending?

> +		pp->pending_ticks++;
> +		return r;
> +	}
> +
> +	/* schedule the next check */
> +	pp->tick =3D pp->checkint;
> +	if (pp->pending_ticks >=3D pp->tick)
> +		pp->tick =3D 1;
> +	else
> +		pp->tick -=3D pp->pending_ticks;
> +	pp->pending_ticks =3D 0;
> +
> +	if (pp->tick =3D=3D 1)
> +		return r;
> +
> +	/*
> +	 * every mpp has a goal_idx in the range of
> +	 * 0 <=3D goal_idx < conf->max_checkint
> +	 *
> +	 * The next check has an index, next_idx, in the range of
> +	 * 0 <=3D next_idx < conf->adjust_int
> +	 *
> +	 * Every adjust_int seconds, each multipath device should
> try to
> +	 * check all of its paths on its goal_idx. If a path isn't
> checked
> +	 * on the goal_idx, then pp->tick for the next check after
> the
> +	 * goal_idx will be decremented by one, to align it over
> time.
> +	 */
> +	goal_idx =3D (find_slot(vecs->mpvec, pp->mpp)) *
> +		=C2=A0=C2=A0 max_checkint / VECTOR_SIZE(vecs->mpvec);
> +	next_idx =3D (start_secs + pp->tick) % adjust_int;
> +	if (next_idx > goal_idx && next_idx - goal_idx < pp-
> >checkint)
> +		pp->tick--;

Hm. IMHO this calculation should be little simpler, as follows:
       =20
	cur_idx =3D start_secs % adjust_int;
        if ((goal_idx - cur_idx) % pp->checkint !=3D 0)
                pp->tick--;

My reasoning goes like this: If (goal_idx - cur_idx) % pp->checkint is
0, we need no adjustment, because (assuming checkint remains constant)
it will be checked at the next goal_idx. Otherwise, we check one tick
earlier, and will do so at the next check again, etc. This is similar
to your approach, but not exactly the same, AFAICS. In particular, I am
unsure about your "if (next_idx - goal_idx < pp->checkint)" condition.

If checkint grows toward max_checkint, it may take longer until this
algorithm converges, but sooner or later, it should.

Instead of stepping, we could also force the idx immediately, by doing

        pp->tick -=3D (goal_idx - cur_idx) % pp->checkint;

which would be even simpler (the check intervals would be less evenly
spaced, but I don't think that would hurt us much).

Am I misguided here?

Regards
Martin

