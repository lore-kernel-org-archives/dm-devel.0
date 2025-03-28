Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2632BB15
	for <dm-devel@lists.linux.dev>; Fri, 28 Mar 2025 19:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743189358; cv=none; b=gcwhe1WcVQW754+lfmSTcVm2aCn+56lOxUfKDxIEzp3VSf5SaYIzCWfKOD17S+NHu7j4ytC9rGdvMJIO4oTvaUcDcmRA7bsIa704w6HbTt/wnIRCUYV0LWlae+qCikd6IdJWfadZbJLNaMOCqXPzmZsHkNK6f8iZto/G+E55NOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743189358; c=relaxed/simple;
	bh=2yOM/MB8AJ8oVwTcBrHSgFaelHRRArjC7/VbEIaMJfc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oqA0ECbDj1WOHw44NVUPi2jOpflPESxiYdS9y2dCDDKf/YhCV9ziwdVYao/ZCWCvDf451oqCGOgYiUbWWRhugudyrZokHZEcPVCZEjl/bhA2obnec2S4sCJ8kKgVVajBYAyEyQrKyVo4ZBlVh/wWxU0/gyUCJqldrf81UBB2PEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Di6/R+qq; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Di6/R+qq"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-43cec5cd73bso17234485e9.3
        for <dm-devel@lists.linux.dev>; Fri, 28 Mar 2025 12:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1743189353; x=1743794153; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2yOM/MB8AJ8oVwTcBrHSgFaelHRRArjC7/VbEIaMJfc=;
        b=Di6/R+qqlTQExzO2eNz8D/csu75C2aNnJZWeNCTOFhzNOVJz8O0GtG348e8s8MudPS
         WVyU6xtcDWRFcMELdVL6kbLOMIA7y5DHH4Vim6UPzYbQYQFUm63HxpM8Fg742wptgo97
         YTQlkRH9XIZv3BdTisdHCS/IDdcxEB4UI59BPF00Zm+SZd1SWTDcWmFLGwUEa69k0+Q5
         H0O0aZ4LiKmLHcyMAOBw7Ep6i1UJb5FbZJswnA215gd0DGp/yISJndZGsCrvvnZl9nta
         aUVwy0UKuq3kUGiaQaUNtj44ioUby0JOQlZbKXW4EIMZVVlXnushJWIYnKugqHgAxAB7
         AnEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743189353; x=1743794153;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2yOM/MB8AJ8oVwTcBrHSgFaelHRRArjC7/VbEIaMJfc=;
        b=wwssS2z0BBMMqZ8cnmBFJ0kqgp4VSNSWWktyqqQfVTttmC8U6Lbh7UhwCob6cs0Q9g
         9ijcmbGF/D3fxdN3UOE8fvvmDErDpYL/ElmSELKYw/lWDxuamdiJ7AT9P7JiGEcRhZNb
         p/Y957aHCiYqGEIP1ppgNmLI+4c9Pwuk7J+Gc/gujrS6fFWdYyPHtqB8paJCO3v/nM4c
         MNLGFP4q172CugvhS/0BO/W6der5Q1RaWzxFxr5eHEPSqt9OoLBXpAC0fyu5fBjiGW4a
         LKCYmlrPU1Q8NKPdA4ktORC+ZrbiZgwYoil+zyIZ/0RjgbFBoPaNOaxXYNRQGYnRtZm3
         rBfQ==
X-Forwarded-Encrypted: i=1; AJvYcCWDjTsXI4oCoDSuqf0RQRnz+ggnahQj1Az43S0nSJhUKpNqPBzSaEa5TlwBjz+2YBtQfxO7svXhOg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yzprf/8tv8J92Hc6HKeVZEvh0s35xdcI4eD5LK2z6Il1Wauso/G
	XC2Bhd4Kvb5J9NFXOqbbuLLmlOnnG0w+Hn6XgUnCNI63/8V9ret4ORbsrstD/4Q=
X-Gm-Gg: ASbGncs/97K/U9l2lXok8tPsEhign+VbnxHOsbvZuQO4eGGi3QLAJf/uYIrZHVVshSc
	6jXHJW/TkLLMS1VhaNSgxhvZhz1Yg33kmS6+gQ2Ktb2vmrp8aCedklQ6mkr3FziAnh7bemZ+ks9
	1xZDy8FeqTvihbzk5N8buDwkG4uoqTac3EhsRD8Qt/S9cGtOQi9/VS+XrZwF2IJWkXJvhE90xVD
	XeurEIgkKo9xzoS1Uc5o3Xzr1IVmJs67M+nTrZl5FOpZUB3KfaY7kOGeaUFqIEh/740WF7cdYVT
	1zMaCmzbXQ7UZrF9bULT0YCETKaKe6jaek9tkCDJ6C/uYbTupiuKK+3o/UYvzKVMSZppXZPVpjP
	NfFVwpNf3YGnUoeGNSd9wrxznEQLQO7NsirELUWyunm2Avc8+SgPCD/WdOPOmhjx77Q6AhrmQEM
	AUa8o=
X-Google-Smtp-Source: AGHT+IE2dNCtf9DDeLi2ZkQuS6rF+7wmTrq0+iYtQfZhc/xkLsn5Q2ONEDwh0u1ciBa79us4YPG6Jg==
X-Received: by 2002:a05:600c:3b9d:b0:43d:7588:6687 with SMTP id 5b1f17b1804b1-43db6227ad4mr5797135e9.12.1743189353356;
        Fri, 28 Mar 2025 12:15:53 -0700 (PDT)
Received: from ?IPv6:2003:de:3744:d600:a441:a57b:4aaa:2b39? (p200300de3744d600a441a57b4aaa2b39.dip0.t-ipconnect.de. [2003:de:3744:d600:a441:a57b:4aaa:2b39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d830f5708sm82557595e9.32.2025.03.28.12.15.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Mar 2025 12:15:53 -0700 (PDT)
Message-ID: <0354c843cb5556ae4c303379b6466347788a4d66.camel@suse.com>
Subject: Re: [PATCH 2/3] multipathd: re-add paths skipped because they were
 offline
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper
 development <dm-devel@lists.linux.dev>
Date: Fri, 28 Mar 2025 20:15:51 +0100
In-Reply-To: <Z-bP80uHCVjJs0-g@redhat.com>
References: <20250324205504.2523493-1-bmarzins@redhat.com>
	 <20250324205504.2523493-3-bmarzins@redhat.com>
	 <8f0c3fab83d329c22a2d1921356fe7c91966da73.camel@suse.com>
	 <Z-bP80uHCVjJs0-g@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.0 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Fri, 2025-03-28 at 12:36 -0400, Benjamin Marzinski wrote:
> On Tue, Mar 25, 2025 at 11:33:18PM +0100, Martin Wilck wrote:
> > On Mon, 2025-03-24 at 16:55 -0400, Benjamin Marzinski wrote:
> > > When a new device is added by the multipath command, multipathd
> > > may
> > > know
> > > of other paths that cannot be added to the device because they
> > > are
> > > currently offline. Instead of ignoring these paths, multipathd
> > > will
> > > now
> > > re-add them when they come back online. To do this, it multipathd
> > > needs
> > > a new device initialized state, INIT_OFFLINE, to track devices
> > > that
> > > were
> > > in INIT_OK, but could not be added to an existing multipath
> > > device
> > > because they were offline. These paths are handled along with the
> > > other
> > > uninitialized paths.
> > >=20
> > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> >=20
> > This looks good in general, but I'm not certain about INIT_OFFLINE.
> > The
> > property "path was temporarily offline while we tried to add it to
> > a
> > map" is not logically related to path initialization, IMO. Also, we
> > have plenty of (pp->initialized !=3D INIT_xyz) conditionals in the
> > code,
> > and your patch touches only 2 of them. I find it difficult to rule
> > out
> > that some of them might be broken by the additional init state.
> > Have
> > you double-checked them all?
>=20
> Yeah. I may have overlooked something, but I did look through them. I
> just double-checked pathinfo(), since if that's called with DI_ALL
> and
> succeeds, it will unconditionally set the path to INIT_OK.=C2=A0 There
> isn't
> a case where that could happen to a path in INIT_OFFLINE, but it
> would
> make sense to add a check there, just to make it obvious that this
> shouldn't move the path from INIT_OFFLINE to INIT_OK. Even if
> DI_CHECKER
> is set and pathinfo() discovers that the path has come back up, It's
> easier to just wait for checkerloop to check the path, and handle
> adding
> it the the multipath device there.
>=20
> I should point out what this patch doesn't do, since that might clear
> up
> some cases where you would think I need to handle offline paths. This
> patch is only taking care of the case where a multipath device
> exists,
> but multipathd won't start monitoring it because it can't reload the
> table with the offline paths. It does not handle the case where
> offline
> paths exist, and that keeps multipathd from creating a device in the
> first place.
>=20
> The easiest way for that to happen is if the device WWID is not in
> the
> wwids file and find_multipaths is set to "on" or "smart", where a
> device
> will get multipathed when a second path appears. In this case, you
> could
> add a single path and fully initialize it, then have that path go
> offline, and later add a second path. Multipathd would see that there
> are two paths, and try to create a multipath device. However the
> offline path would keep the device from being created. Since we
> call pathinfo(DI_CHECKER) in adopt_paths(), multipathd should know
> that the path is offline before it tries to create the device, so
> we could create the device without any offline paths, and then set
> those
> paths to INIT_OFFLINE, for later addition.
>=20
> This case seemed less important to me than the one where we end up
> with
> an untracked mlutipath device. This problem has always existed and
> it's
> immediately obvious when it occurs (there's no multipath device), and
> yet I've never gotten a bug report for it. This makes sense because
> it's
> pretty hard to hit. Usually, the path will either not get initialized
> in
> the first place because it's offline (in which case we won't attempt
> to
> use it as part of a multipath device) or multipathd will create a
> multipath device using it as soon as the path gets added, leaving a
> very
> small window between when multipathd initializes the path and when
> it creates the multipath device. The larger window for the path to
> go offline only happens in the case where multipathd doesn't know
> to create a multipath device right away.
>=20
> The case with the untracked device is pretty much as hard to hit, and
> has also always existed, but it's not obvious to the user that their
> multipath device isn't being tracked by multipathd. That seems much
> worse to me. I'm considering fixing the case where the device doesn't
> get created at all, but that can happen in multiple places, so I
> think
> it'll be a little messier. Also, I can't decide if multipathd should
> try
> to create the device with all the paths first, and only ignore the
> offline paths on retries, if the first create attempt fails, or if it
> should always skip the offline paths, at least if if just checked
> their
> state in adopt_paths(). Thoughts?

I agree that this is a corner case, and I have also never seen a bug
report about it. I wouldn't want to spend a lot of work on it.

Arguably the inconsistency is in the kernel, as the kernel doesn't mind
carrying around an offline device in a map after it has been added, but
refuses to add it in the first place while offline.

But I'm not keen on changing anything in that area, either.

Martin

