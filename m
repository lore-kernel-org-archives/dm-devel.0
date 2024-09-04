Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EBB640C03
	for <dm-devel@lists.linux.dev>; Wed,  4 Sep 2024 20:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725480902; cv=none; b=e+GOHR4a7d0w4uN/ReBOwQ34e3ilX7Juv03iogZ+Yn8s7nQV12Gh8tQrlZ+g8Ey8PKpUF9V/tZJZ9W887/0n6yzmMuRxs7bRamsiXOPkoJQ8xpjVkpSGozj3LyL/052CRr6FIRdpoPsiVPVJXgEbCZ8AOXOwHUKA+Jx+xP98fCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725480902; c=relaxed/simple;
	bh=lDHhI3Hzd/AV/yh6HPmK5QNTR590Yx88MZu/8Dz5Z2A=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Q9HqGJtUOASu/BZpCookHeHkIsUqGaBWaKGuuLzeeq5z8qENagdVdTP2vVBKRqbjy6E4ge/pbpaHo79eryvXFk677+zTW4jrQo0/Z5LY6ThwEiS7++fUfPm/Q18v7G/1IV0AJFJgGKTeFqFBr0F1opBiEeRlBqbGr5DzJrGJ1+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=W2uFp7KO; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="W2uFp7KO"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a8683dc3b17so1770166b.3
        for <dm-devel@lists.linux.dev>; Wed, 04 Sep 2024 13:14:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1725480898; x=1726085698; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=S3MM7U8Fye6qKiHhFDopmw+RSp6hWxvhPTa0MWbdb/A=;
        b=W2uFp7KOLnW4kZY6q577jcOiMDjmH+cX1gfUmn5XROo3FkVCPlLYNkfXk90sRmRy2b
         qzv5xK5/Tp8+kBLurtTbBAnG/Q/rD4U2RJTPEwMK9ZovI7y5qefi3vbtQwkXFI1KhPFt
         qb9mnAogHzlo2TKDgTGJ/Y9z33BClzlwg8qriUpHvFUCNO+rvUMsuKvD7kcMrt+rkoOR
         UAIq0m0i5hmtruACVsoMJsJNbw6g0VxxW4FZSLMfmsm7elAe2RsiYbuBt94vbxRZZUFu
         x56H3vYAE/MAzdWfP2SwppBhCl1lrgjz0tEUuX9TDTexSgP/D6Lfv5c9aGAdqFwBgO2o
         tz2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725480898; x=1726085698;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S3MM7U8Fye6qKiHhFDopmw+RSp6hWxvhPTa0MWbdb/A=;
        b=ieEpIcKf3cZ7FvLgt0x50O19Cw+hOJ2fXMFNjikCHiUYC34RvhjpwMKK2XIOL6Wjpx
         tHnwJenOUSuwSGl+53qgCzOwv95U4zl8QW4fRizOfDOh6wfcjj28OVCEJ08uPNqmUHSk
         lO46rZyNQeSTLl2gWlrEg6NP33Vu6jeBK7Q6Av8oekAYGKt/V91xxpbciwuztWEAOuOl
         iFrwXHX2IyJr+EGtmNQsGmYDFqVLNrNfLSJUyHmbRBor0YPsO34KKYxy1TgwpspbMLyq
         gaGUaEWZlhT4lxHGkCDm0dpUaHN5V7IhHNRY5XIlfBN7foGicyI0R0gzrezmFAKVwPsV
         8P+A==
X-Forwarded-Encrypted: i=1; AJvYcCWe6+gG7HfYcxRZh73moxi1SBeroSwTjAMDFyt3bSuaS3TO5qLFsbjVplsroSLz5wg6TCTm7sFDQQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz0lIuOgyQOok9xZpIImznDx2RxRyNlZoJ8sknocbw++kInlD0m
	TGj7rY8wpfRSresuz0sW8y6Oh7dQAVwAauguKpuoUXfFReDuuWCJE7FIR836szs=
X-Google-Smtp-Source: AGHT+IEaFoXvo+CJEWgcd0bPA3RHqBc3fvzz88nz4+kt3/xhk0Qh77XwWBA1yNpcxi5khTG7MiYpdQ==
X-Received: by 2002:a05:6402:26c7:b0:5c2:5f43:3e8 with SMTP id 4fb4d7f45d1cf-5c3cd77e570mr160931a12.9.1725480897451;
        Wed, 04 Sep 2024 13:14:57 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c3cc56d1ccsm294519a12.55.2024.09.04.13.14.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2024 13:14:57 -0700 (PDT)
Message-ID: <0583991c24d79915b6c87bd89c42558d11246f45.camel@suse.com>
Subject: Re: [PATCH 13/15] multipathd: update priority once after updating
 all paths
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper
 development <dm-devel@lists.linux.dev>
Date: Wed, 04 Sep 2024 22:14:56 +0200
In-Reply-To: <Zti6SP_4UI_z57Ws@redhat.com>
References: <20240828221757.4060548-1-bmarzins@redhat.com>
	 <20240828221757.4060548-14-bmarzins@redhat.com>
	 <053e43b8586abc36dd19f2ffee14cb0b31edb14f.camel@suse.com>
	 <Zti6SP_4UI_z57Ws@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2024-09-04 at 15:51 -0400, Benjamin Marzinski wrote:
> On Wed, Sep 04, 2024 at 08:57:46PM +0200, Martin Wilck wrote:
> > On Wed, 2024-08-28 at 18:17 -0400, Benjamin Marzinski wrote:
> > > Instead of updating the path priorities and possibly reloading
> > > the
> > > multipath device when each path is updated, wait till all paths
> > > have been updated, and then go through the multipath devices
> > > updating
> > > the priorities once, reloading if necessary.
> > >=20
> > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > > ---
> > > =C2=A0libmultipath/structs.h |=C2=A0=C2=A0 9 +++
> > > =C2=A0multipathd/main.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 169 +++++++++=
+++++++++++++++++---------
> > > ----
> > > --
> > > =C2=A02 files changed, 118 insertions(+), 60 deletions(-)
> > >=20
> > > diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> > > index af8e31e9..1f531d30 100644
> > > --- a/libmultipath/structs.h
> > > +++ b/libmultipath/structs.h
> > > @@ -318,6 +318,7 @@ enum check_path_states {
> > > =C2=A0	CHECK_PATH_UNCHECKED,
> > > =C2=A0	CHECK_PATH_STARTED,
> > > =C2=A0	CHECK_PATH_CHECKED,
> > > +	CHECK_PATH_NEW_UP,
> > > =C2=A0	CHECK_PATH_SKIPPED,
> > > =C2=A0	CHECK_PATH_REMOVED,
> > > =C2=A0};
> > > @@ -421,6 +422,13 @@ enum prflag_value {
> > > =C2=A0	PRFLAG_SET,
> > > =C2=A0};
> > > =C2=A0
> > > +enum prio_update_type {
> > > +	PRIO_UPDATE_NONE,
> > > +	PRIO_UPDATE_NORMAL,
> > > +	PRIO_UPDATE_NEW_PATH,
> > > +	PRIO_UPDATE_MARGINAL,
> > > +};
> > > +
> > > =C2=A0struct multipath {
> > > =C2=A0	char wwid[WWID_SIZE];
> > > =C2=A0	char alias_old[WWID_SIZE];
> > > @@ -464,6 +472,7 @@ struct multipath {
> > > =C2=A0	int queue_mode;
> > > =C2=A0	unsigned int sync_tick;
> > > =C2=A0	int synced_count;
> > > +	enum prio_update_type prio_update;
> > > =C2=A0	uid_t uid;
> > > =C2=A0	gid_t gid;
> > > =C2=A0	mode_t mode;
> > > diff --git a/multipathd/main.c b/multipathd/main.c
> > > index 2bcc6066..1511f701 100644
> > > --- a/multipathd/main.c
> > > +++ b/multipathd/main.c
> > > @@ -1996,15 +1996,13 @@ mpvec_garbage_collector (struct vectors *
> > > vecs)
> > > =C2=A0 * best pathgroup, and this is the first path in the pathgroup
> > > to
> > > come back
> > > =C2=A0 * up, then switch to this pathgroup */
> > > =C2=A0static int
> > > -followover_should_failback(struct path * pp)
> > > +do_followover_should_failback(struct path * pp)
> > > =C2=A0{
> > > =C2=A0	struct pathgroup * pgp;
> > > =C2=A0	struct path *pp1;
> > > =C2=A0	int i;
> > > =C2=A0
> > > -	if (pp->mpp->pgfailback !=3D -FAILBACK_FOLLOWOVER ||
> > > -	=C2=A0=C2=A0=C2=A0 !pp->mpp->pg || !pp->pgindex ||
> > > -	=C2=A0=C2=A0=C2=A0 pp->pgindex !=3D pp->mpp->bestpg)
> > > +	if (pp->pgindex !=3D pp->mpp->bestpg)
> > > =C2=A0		return 0;
> >=20
> > What happened to the !pp->pgindex test? Is it not necessary any
> > more?
>=20
> In followover_should_failback(), before calling this function, we
> test
> if mpp->bestpg is 0 and return early if it is (because 0 is not a
> valid
> pathgroup id).=C2=A0 Thus, if pp->pgindex equals mpp->bestpg (and we
> should
> failback), it's obviously not zero. If it's not equal to mpp->bestpg,
> then it doesn't matter what it is, because we aren't doing the
> failback anyway. Right?

Ok, thanks for clarifying it ;-)

> >=20
> > This test used to be pp->state =3D=3D PATH_DOWN (see below).
> >=20
> > Just trying to confirm that you did this on purpose. It might
> > justify a
> > separate patch, with rationale. After all, AFAICS, we will now keep
> > the
> > old priority for all path states except PATH_UP and PATH_GHOST,
> > while
> > previously we attempted to fetch the prio for most of them, and
> > only
> > used the previous value if fetching the prio failed.
>=20
> In my understanding, we don't try getting the priority of failed
> paths
> because some of the prioritizers can hang. On this grounds, if we are
> excluding PATH_DOWN we should definitely also exclude PATH_SHAKY and
> PATH_TIMEOUT and probably also PATH_DELAYED.
>=20
> Also, since only paths that are in PATH_UP or PATH_GHOST are usable
> by
> the kernel and contribute to the pathgroup's priority, not attempting
> to
> update the priority of these other paths avoids the risk of hanging
> whil
> not hurting anything (except that they might end up in the wrong
> pathgroup during the time when they aren't usable, if you have
> group_by_prio set).
>=20
> Lastly, The way do_check_path() worked before this patchset was
> inconsistent. If a path changed state to anything other than PATH_UP
> or
> PATH_GHOST we skipped the prio update. However if the path kept the
> same
> state we did the prio update, even if it wasn't PATH_UP or
> PATH_GHOST,
> as long as it wasn't PATH_DOWN. That seems wrong.
>=20
> But I'm fine with making these changes in a separate patch.

That would be great, and please include the above rationale.

Martin

