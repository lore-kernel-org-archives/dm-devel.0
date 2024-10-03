Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 071F21B85CF
	for <dm-devel@lists.linux.dev>; Thu,  3 Oct 2024 21:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727989226; cv=none; b=as4S7hmr1NHqYrKz660v9b94t3OvT4C2iIhez8ChJEO4HDARiTybMd6z4JrQiHgWQ4YsTmK3oawL6V8Sk+rqBAco8PX3OGAApFS1r7NV8Et9Lj+w/xgLpj2P9N/jBeM3+BKMd5jiPKGjs/Uo7o5u+8ohdVKLWfGeGLe2+fisjIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727989226; c=relaxed/simple;
	bh=B0ycsqOk0JqXcMSkrQe5RW7XixZNjBegHtafk0+rjDI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pr0ADfGl6j9HU7MySubNxifaVzVocaWQ9AyMKILMSs+EzOlzjkIH/oaWDxhq1U8ziwpw5wWkwDBFCrZzetJdd+GpZVuHKrCNqfKHkZKaT3esZd1K3mx9tOJUieWAnpfaa9Rzn6kSlx/RNLjh4DTFmqBaBUjP4e52d8oajrkBWVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=cVyidf88; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="cVyidf88"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-42cb5b3c57eso13265605e9.2
        for <dm-devel@lists.linux.dev>; Thu, 03 Oct 2024 14:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1727989222; x=1728594022; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4wH/KPkrgJ+7djgBu+mX/Tdee/kBoucWpv+LgFAm1SY=;
        b=cVyidf88HoapDA8s26bPyVny/H709fsMCJ2l1jdcd8dPo/rN8Lo1dhBQj4iSLrh2BD
         gmNEC1JTcZZBx0wWEkETXg4hQEYldpSLPrwX1Vr7RDCGC5LZjz+0JJ9w8K9qzQfEiOwl
         3YsMS16nyE1zad/RIqvKgEZvL/EpVu/O4rZosCWh0oxXRm9a9116ZTSi8JR8ixkshrea
         00J04puZMparfYqtV2Kp/Qv8+haXtYEr8XlRkMg2XjMJVq77NrzLnGZoCVDgWbw0Z5tz
         V6+yUHJrbl91NzsoQ00wLbV6nF2PaKUArHS2JJj8W039GKiYJuh5EibDTIGjGmQWfXNC
         dWlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727989222; x=1728594022;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4wH/KPkrgJ+7djgBu+mX/Tdee/kBoucWpv+LgFAm1SY=;
        b=MDO7OvZ9E5yTy8vkH0MAq5gUHzDN4jWjj16aSLlKj8UIl/oMDSksEv2bCMoUyJONT8
         nr0OWHmzIUKbDMcBbgCInzq6egqtJzyaEMVLe1PaIY7coBdj758eULJxmPYLe13EES8V
         01IbiB+Hc/pNy7H3WuAOZNlBgT/4TVaHDL7BbVDh8LTQ9CHIlEQBKW6GtXZN3jdoBliI
         QwP/Ng4aGGs8TCbyDtZKo6Jrp3O2wYjtC37TJSr41XCk8PrP5cPMoDq9QnRnNe2KYZL/
         uqBuEC/1lK5l19/WGy6KNg28hRGwQPdBh49q/fBlC80/t/zEMPVlT8ctK5m7oSV+ODsx
         Nhjw==
X-Gm-Message-State: AOJu0YxTpnDBy8NzoF2kBRQDAuxynv4rprVUJkFNHLFkRhJv9O/a1s/r
	6ZkvoKxF5l3KZBpRpNAQoWJgdUEONfcDrmGWrUFgzUQwhDC9jAHevVLXmXYL+ngvgWpX9parCLY
	Z
X-Google-Smtp-Source: AGHT+IHFOn0uARwcg+azDfj+r7w13dakzwVyuDLxnpiyli/EzNkd3PSDcFFW9ouBy5GPKAQZ8b+s9Q==
X-Received: by 2002:a05:600c:5103:b0:426:5269:1a50 with SMTP id 5b1f17b1804b1-42f85aa90b0mr2436085e9.11.1727989222058;
        Thu, 03 Oct 2024 14:00:22 -0700 (PDT)
Received: from ?IPv6:2003:de:3719:4a00:e912:812a:2309:b70? (p200300de37194a00e912812a23090b70.dip0.t-ipconnect.de. [2003:de:3719:4a00:e912:812a:2309:b70])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42f79eadd04sm52638625e9.20.2024.10.03.14.00.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2024 14:00:21 -0700 (PDT)
Message-ID: <be3a772cdd136269ddd0bb3287f522e7eeb1e6ba.camel@suse.com>
Subject: Re: [PATCH v2 14/22] multipathd: update priority once after
 updating all paths
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Thu, 03 Oct 2024 23:00:20 +0200
In-Reply-To: <20240912214947.783819-15-bmarzins@redhat.com>
References: <20240912214947.783819-1-bmarzins@redhat.com>
	 <20240912214947.783819-15-bmarzins@redhat.com>
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
> Instead of updating the path priorities and possibly reloading the
> multipath device when each path is updated, wait till all paths
> have been updated, and then go through the multipath devices updating
> the priorities once, reloading if necessary.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =C2=A0libmultipath/structs.h |=C2=A0=C2=A0 9 +++
> =C2=A0multipathd/main.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 169 +++++++++++++=
+++++++++++++-------------
> --
> =C2=A02 files changed, 118 insertions(+), 60 deletions(-)
>=20
> diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> index af8e31e9..1f531d30 100644
> --- a/libmultipath/structs.h
> +++ b/libmultipath/structs.h
> @@ -318,6 +318,7 @@ enum check_path_states {
> =C2=A0	CHECK_PATH_UNCHECKED,
> =C2=A0	CHECK_PATH_STARTED,
> =C2=A0	CHECK_PATH_CHECKED,
> +	CHECK_PATH_NEW_UP,
> =C2=A0	CHECK_PATH_SKIPPED,
> =C2=A0	CHECK_PATH_REMOVED,
> =C2=A0};
> @@ -421,6 +422,13 @@ enum prflag_value {
> =C2=A0	PRFLAG_SET,
> =C2=A0};
> =C2=A0
> +enum prio_update_type {
> +	PRIO_UPDATE_NONE,
> +	PRIO_UPDATE_NORMAL,
> +	PRIO_UPDATE_NEW_PATH,
> +	PRIO_UPDATE_MARGINAL,
> +};
> +
> =C2=A0struct multipath {
> =C2=A0	char wwid[WWID_SIZE];
> =C2=A0	char alias_old[WWID_SIZE];
> @@ -464,6 +472,7 @@ struct multipath {
> =C2=A0	int queue_mode;
> =C2=A0	unsigned int sync_tick;
> =C2=A0	int synced_count;
> +	enum prio_update_type prio_update;
> =C2=A0	uid_t uid;
> =C2=A0	gid_t gid;
> =C2=A0	mode_t mode;
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 9519b6c5..3cda3c18 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -1996,15 +1996,13 @@ mpvec_garbage_collector (struct vectors *
> vecs)
> =C2=A0 * best pathgroup, and this is the first path in the pathgroup to
> come back
> =C2=A0 * up, then switch to this pathgroup */
> =C2=A0static int
> -followover_should_failback(struct path * pp)
> +do_followover_should_failback(struct path * pp)
> =C2=A0{
> =C2=A0	struct pathgroup * pgp;
> =C2=A0	struct path *pp1;
> =C2=A0	int i;
> =C2=A0
> -	if (pp->mpp->pgfailback !=3D -FAILBACK_FOLLOWOVER ||
> -	=C2=A0=C2=A0=C2=A0 !pp->mpp->pg || !pp->pgindex ||
> -	=C2=A0=C2=A0=C2=A0 pp->pgindex !=3D pp->mpp->bestpg)
> +	if (!pp->pgindex || pp->pgindex !=3D pp->mpp->bestpg)
> =C2=A0		return 0;
> =C2=A0
> =C2=A0	pgp =3D VECTOR_SLOT(pp->mpp->pg, pp->pgindex - 1);
> @@ -2017,6 +2015,26 @@ followover_should_failback(struct path * pp)
> =C2=A0	return 1;
> =C2=A0}
> =C2=A0
> +static int
> +followover_should_failback(struct multipath *mpp)
> +{
> +	struct path *pp;
> +	struct pathgroup * pgp;
> +	int i, j;
> +
> +	if (mpp->pgfailback !=3D -FAILBACK_FOLLOWOVER || !mpp->pg)
> +		return 0;
> +
> +	vector_foreach_slot (mpp->pg, pgp, i) {
> +		vector_foreach_slot (pgp->paths, pp, j) {
> +			if (pp->is_checked =3D=3D CHECK_PATH_NEW_UP &&
> +			=C2=A0=C2=A0=C2=A0 do_followover_should_failback(pp))
> +				return 1;
> +		}
> +	}
> +	return 0;
> +}
> +
> =C2=A0static void
> =C2=A0missing_uev_wait_tick(struct vectors *vecs)
> =C2=A0{
> @@ -2132,41 +2150,53 @@ partial_retrigger_tick(vector pathvec)
> =C2=A0	}
> =C2=A0}
> =C2=A0
> -static int update_prio(struct path *pp, int force_refresh_all)
> +static bool update_prio(struct multipath *mpp, bool refresh_all)
> =C2=A0{
> =C2=A0	int oldpriority;
> -	struct path *pp1;
> +	struct path *pp;
> =C2=A0	struct pathgroup * pgp;
> -	int i, j, changed =3D 0;
> +	int i, j;
> +	bool changed =3D false;
> +	bool skipped_path =3D false;
> =C2=A0	struct config *conf;
> =C2=A0
> -	oldpriority =3D pp->priority;
> -	if (pp->state !=3D PATH_DOWN) {
> -		conf =3D get_multipath_config();
> -		pthread_cleanup_push(put_multipath_config, conf);
> -		pathinfo(pp, conf, DI_PRIO);
> -		pthread_cleanup_pop(1);
> +	vector_foreach_slot (mpp->pg, pgp, i) {
> +		vector_foreach_slot (pgp->paths, pp, j) {
> +			if (pp->state =3D=3D PATH_DOWN)
> +				continue;
> +			if (!refresh_all &&
> +			=C2=A0=C2=A0=C2=A0 pp->is_checked !=3D CHECK_PATH_CHECKED) {
> +				skipped_path =3D true;
> +				continue;
> +			}

Nit: My first thought here was that this would skip paths for which=C2=A0
pp->is_checked =3D=3D CHECK_PATH_NEW_UP. Then I realized that if there was
a new path up, refresh_all would be set, which is not immediately
obvious. Can you add a comment?

Martin

