Received: from mail-ed1-f65.google.com (mail-ed1-f65.google.com [209.85.208.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288AE537FF
	for <dm-devel@lists.linux.dev>; Wed,  9 Oct 2024 15:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728486061; cv=none; b=sZCCQnwx6jMrU/w2hVP+4rwZFVOWLcPKFrLdjEmZHR4wwIPSwgcalJCmWlIPJz/e5pBS3INd6c75vjk72YIggSGHQNgYJ5p5ClcUNZBPdEkXiVwdZq+LSVqoJrsTRSy/NgDwzPl/UeRLW8V494g0gQNNWKWoAjDwtKXAy9rKDZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728486061; c=relaxed/simple;
	bh=B9lOhOovcWoIW3d7YhIBJF01NBAt9Rc+SyabuN18s7E=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kC0HyKa9g94t8kaC8Obz70LVZAszEVnSchaYiAvE4dMRAI2vJPnOHSgfL4y4nxek/2qL/JYbLzo099J6bNE3qSN5O25854weINSJwV2fyqXfWFt5SZboBRmrAkuuA8IjgKpcaJDb+Gy7cQ3Y+rwu18cQpk2nYra5hBsJzm183KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=YWwH462T; arc=none smtp.client-ip=209.85.208.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="YWwH462T"
Received: by mail-ed1-f65.google.com with SMTP id 4fb4d7f45d1cf-5c915308486so2086188a12.0
        for <dm-devel@lists.linux.dev>; Wed, 09 Oct 2024 08:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1728486057; x=1729090857; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hfcBiyqhxD4tiBhtOlwJ29zq/jIt72Me/EKFvuN7z8A=;
        b=YWwH462TvH3N73N5nz+Ce2OiODvQcZoQdm0QPDtb3DWWa8XoIWQ3IpEgJbiVopEU9f
         a0aJM7lBo4fcq4NOQSXfCBW87uaykjPEE+cRPBByLQuvYKVW2OhO/avcW2SRqiqhlzPh
         LVERhu46mD3R8eg7sJME86kteQJTqfZLlVACusuMiDtRo+7aiFLaVV3hic6aIWZYGwWw
         KXmT+ijRlfyRP4UdBQkf02QXoCOkq5DBm5iYvDgsQlodV3hAcGn/7dp5Z0zGXgpqD+xu
         /gfAMFdJ84GVdnvkC2xAHKy6Gwxq9SwQiHeS2PJdy3eXombVIoUoIPZdyHiJOBGG/ROj
         YVow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728486057; x=1729090857;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hfcBiyqhxD4tiBhtOlwJ29zq/jIt72Me/EKFvuN7z8A=;
        b=w3SFgpGwrkT9N0GRPDgPkh5N2Zs7sTA0s2Ou6nIXn6RmwF6AuIPcw2KqsXIZUxJjJj
         G2Reg2ylcEs4aoEXqwoS20khphMQfjLwtk5YzfojH3E2+KGBsOJ7NTqb8RFTe6VYR1er
         b3aXpLdrO9ccHh+MAj/uvwmnBy5wN4+N6PtyZrGt5PqQqgo4G3kChuEAFVOgYho1wlao
         b2LOxFbp/WH8lZiRLbsfkECMBQgKick4/AipdFXXjHDrPToKZGnsrA9yETV/zwzXINiL
         WVgUOLMhlX78yZ7FN46plVN1xc5TzeXuDzDttk4kuchPF4JLY2QIV8Umep5enExZ/Ueq
         TL0A==
X-Gm-Message-State: AOJu0YyKcgxAqeEJHtuphWg7TJuHx9pPabNheCBf/N2hM3z0DEz6RmpK
	2aVH1dkPEqFVFirLG5FDJHhrLhjXUHkiN39Vd51dLDLOpfl7Iu7a1SxBJjR4wViT0vnl+H6bYLS
	i3bmtFg==
X-Google-Smtp-Source: AGHT+IEnQOusSSoojHEqYltEN33SHdzOhYzkEveAAo9AAE3ju2gyj5tQCI7xughZqE5V/BhQXch1oQ==
X-Received: by 2002:a05:6402:27c6:b0:5c8:a01c:e511 with SMTP id 4fb4d7f45d1cf-5c91d57cac6mr2389063a12.10.1728486056788;
        Wed, 09 Oct 2024 08:00:56 -0700 (PDT)
Received: from ?IPv6:2003:de:3707:9400:b9ee:e7ce:aa91:658e? (p200300de37079400b9eee7ceaa91658e.dip0.t-ipconnect.de. [2003:de:3707:9400:b9ee:e7ce:aa91:658e])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c8e05eccf0sm5551282a12.64.2024.10.09.08.00.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2024 08:00:56 -0700 (PDT)
Message-ID: <061a44d1ab78bd95b10bd908ffbfeb2bbd436ca0.camel@suse.com>
Subject: Re: [PATCH v4 04/22] libmultipath: remove pending wait code from
 libcheck_check calls
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Wed, 09 Oct 2024 17:00:55 +0200
In-Reply-To: <20241009011523.2381575-5-bmarzins@redhat.com>
References: <20241009011523.2381575-1-bmarzins@redhat.com>
	 <20241009011523.2381575-5-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Tue, 2024-10-08 at 21:15 -0400, Benjamin Marzinski wrote:
> When the tur and directio checkers start an asynchronous checker,
> they
> now immediately return with the path in PATH_PENDING, instead of
> waiting in checker_check(). Instead the wait now happens in
> checker_get_state().
>=20
> Additionally, the directio checker now waits for 1 ms, like the tur
> checker does. Also like the tur checker it now only waits once. If it
> is still pending after the first call to checker_get_state(). It will
> not wait at all on future calls, and will just process the already
> completed IOs.
>=20
> Reviewed-by: Martin Wilck <mwilck@suse.com>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =C2=A0libmultipath/checkers.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0 7 +++-
> =C2=A0libmultipath/checkers/directio.c | 57 +++++++++++++++++------------=
-
> --
> =C2=A0libmultipath/checkers/tur.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 13 +++-=
----
> =C2=A03 files changed, 41 insertions(+), 36 deletions(-)
>=20
> diff --git a/libmultipath/checkers/directio.c
> b/libmultipath/checkers/directio.c
> index 3f88b40d..904e3071 100644
> --- a/libmultipath/checkers/directio.c
> +++ b/libmultipath/checkers/directio.c
> @@ -60,10 +60,11 @@ const char *libcheck_msgtable[] =3D {
> =C2=A0#define LOG(prio, fmt, args...) condlog(prio, "directio: " fmt,
> ##args)
> =C2=A0
> =C2=A0struct directio_context {
> -	int		running;
> +	unsigned int	running;
> =C2=A0	int		reset_flags;
> =C2=A0	struct aio_group *aio_grp;
> =C2=A0	struct async_req *req;
> +	struct timespec endtime;
> =C2=A0};
> =C2=A0
> =C2=A0static struct aio_group *
> @@ -314,19 +315,16 @@ check_pending(struct directio_context *ct,
> struct timespec endtime)
> =C2=A0static int
> =C2=A0check_state(int fd, struct directio_context *ct, int sync, int
> timeout_secs)
> =C2=A0{
> -	struct timespec	timeout =3D { .tv_nsec =3D 1000 };
> =C2=A0	struct stat	sb;
> =C2=A0	int		rc;
> +	struct io_event event;
> =C2=A0	struct timespec endtime;
> =C2=A0
> =C2=A0	if (fstat(fd, &sb) =3D=3D 0) {
> =C2=A0		LOG(4, "called for %x", (unsigned) sb.st_rdev);
> =C2=A0	}
> -	if (sync > 0) {
> +	if (sync > 0)
> =C2=A0		LOG(4, "called in synchronous mode");
> -		timeout.tv_sec=C2=A0 =3D timeout_secs;
> -		timeout.tv_nsec =3D 0;
> -	}
> =C2=A0
> =C2=A0	if (ct->running) {
> =C2=A0		if (ct->req->state !=3D PATH_PENDING) {
> @@ -345,31 +343,26 @@ check_state(int fd, struct directio_context
> *ct, int sync, int timeout_secs)
> =C2=A0			LOG(3, "io_submit error %i", -rc);
> =C2=A0			return PATH_UNCHECKED;
> =C2=A0		}
> +		get_monotonic_time(&ct->endtime);
> +		ct->endtime.tv_nsec +=3D 1000 * 1000;
> +		normalize_timespec(&ct->endtime);
> =C2=A0	}
> =C2=A0	ct->running++;

Sorry, I have another concern here, despite my reviewed-by. This very
old statement, combined with "if (ct->running > c->timeout)" below,
somehow assumes that "running" counts seconds, which means that this
code must be called once a second. I guess this has been approximately
true in the past, when this code was originally written. It has never
been clean, we should have compared time stamps instead.=C2=A0

But now, it seems to be plain wrong, "running" will never have a higher
value than 1 as it is only called once from libcheck_check(), and the
(ct->running - c->timeout) statement is broken.

Am I misreading this code?

Martin

