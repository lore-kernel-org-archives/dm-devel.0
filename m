Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C54D267386
	for <dm-devel@lists.linux.dev>; Fri, 29 Aug 2025 07:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756452508; cv=none; b=Uk8A/anOzCoUuYlhpx9uCpsSsOwtkaIaPAuluiCUrM6JcvhauCEYdDPSs+UtPCZqNNES/lC82L5JuVIfYpCO1YCDTL8jCwl77a7dfOUV/l0rQ1dT5dROH2O6kr0pn4trPhqKjfyAyKn70RcSP9ErIh1F3O/2Mq9h1O3+IyFvGxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756452508; c=relaxed/simple;
	bh=Z89gcIASs7TAxNPWvDuvD1/fOHjt6Io/CCQGc+5IYCY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Glo17qbh3n35tei/z+HbPPQCXzsYimLHuav/fY4MAFqbLC7oO2N8Jq1s5Z2Nuhy5N1ATOpS4vG0avWUJjYqMBApOsMhETmTskh07ZzxlHHIO18qxxzOlNU5KyvV+0cpjN3lTzPefvBtj2q+DEvlTCDKVzFVapKGlCvtlTMF6m64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SnDU0lQ4; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SnDU0lQ4"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-afcb7ae6ed0so249429766b.3
        for <dm-devel@lists.linux.dev>; Fri, 29 Aug 2025 00:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1756452504; x=1757057304; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Q/WTle2mU6uaA/jKodNilAw/GsdF2MvI32GXQZbraO8=;
        b=SnDU0lQ4ijDDkzAoBYY4eIVJ+gokXQRNO3B/vlDAKNYAexKgIAnGEoNEZdkgTvgY46
         gvNObmjxNFrirnbSrETmENM13DYDNSmGzZljLcIEeFus9HtwzDt/ZQ6P/Ilx0LoJhtrW
         TTJHlfbetnjj0JRL0/9r1sWWUyWbragHBgBYF4rsT99Ps0Ctex2SGQwDZ65d6b7k5iZT
         wG+Q91HvohIpDcuzXH+GgwB+USOs0cTnSU0onBXcC6BQ/BtVD6fgIpf4qQBtyARywkKw
         m1vHoXXgImEzl9g9vWSlYQ8lYd+NAwi1YeNhWqj4Mk007gBGJXXoBuvBZxv7pDTHRHYv
         btZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756452504; x=1757057304;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q/WTle2mU6uaA/jKodNilAw/GsdF2MvI32GXQZbraO8=;
        b=fZA5B98JVs9fZyWShOnMVPnqnz80CH+YbZL5VBvUwZA2w8A0AOnT6B7Ndh8Kcczz2Q
         e8fwYfvefECy/B+Xn1MagqWSHxH1YtG8eztaUKtqbVdf9MTw1Tg4J+CG92uysEkmVkjK
         +sp6XwRfo4kP+nDA1FSsnjzNTA83fJ+huG3YUs6hVTu+yJeMFUOKIa9D1kOGFzP9PnXo
         uTRHFhR0RZcM3BkibfeaL88Qxtjs+Hgs9LsAsws3nahtn0kJ004acrp7vUg3BI+6nlfZ
         rBZqTHQ7K3xs0kucrSy9++icpXtnsODkhcxXyCT4WKFRAUnGMtNH/o+VbtkJVB2ug3qP
         INwA==
X-Forwarded-Encrypted: i=1; AJvYcCX1TzOJKV8Bicyqx/bMnoTK3BQMdZ+/dOKhPiz1BV+5Q14/eX1ddMt453gAFJYR/MBWXjpcvfW0AQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Ywqb12ABY7lV6c/obMuyKkd8XuP1zgCy5Q3ogAWBB5ayY7myhcg
	T1znT/OvbrE21/39PWMgoxDMXkd9J37cd98uYo1s6vu+nxhSDVjGC88pup4GYf3iKxE=
X-Gm-Gg: ASbGnctUr6EODO3QgXq6HpCESGBoxbVpiNW1Na6Flr62cVphyeVzGZGo1Hb6BB/TVUz
	xET9httxmQsmdJUlMajoQXqefsSfuum1e1IJ9kAqb1cwHo1le6aMTu4vvlpHQaF2pYnEmnTtQU4
	OinSJ+64biJPkpoaGVCyndoIPrqLNWxELqOtK3+O3sJA6b64KAOsE/Pxll2xl0WnXCfBfXUUHyA
	Mu9AaTbUJBDN47Cs77Tq3O0ZYC/NZMOvh/KXXx5tg7iFlbNgCZ3SAcqPFiUJI2X5OwxVQbepvsu
	mbmlrB2oLhMLX+/9dyJQyWPBV5q/UfPALn8JuZmHnSjAMWYN7/faBqKEMpiRIEYu+wW+3EWBwK+
	MkXlvtl0opHErb4cTdfeJjHthskb3C4hJbNGQGBjCqlbX3n9Fcf7G+smAohdFRBL6eu0ocDtey4
	mgL9RYucJAvTc+LP4OQwPT6teRY1np5yytst9urDL1ry2i65pNTXR6Vw7vOeyIueRxkw==
X-Google-Smtp-Source: AGHT+IHEzLTZ/x8XW1MQUYgpZta+DY6BuXCnV99E3Vt9ZtJbb5phKareI0RIiSpYtnv8D8DBXXhp3A==
X-Received: by 2002:a17:907:7f90:b0:afe:bd37:5d5f with SMTP id a640c23a62f3a-afebd3765bamr804461666b.7.1756452503847;
        Fri, 29 Aug 2025 00:28:23 -0700 (PDT)
Received: from ?IPv6:2003:f9:7f15:4e00:f2e:2331:5e9d:fe56? (p200300f97f154e000f2e23315e9dfe56.dip0.t-ipconnect.de. [2003:f9:7f15:4e00:f2e:2331:5e9d:fe56])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aff0ed6ffebsm23127466b.32.2025.08.29.00.28.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 00:28:23 -0700 (PDT)
Message-ID: <68294402943745929ab5f6b8f8c2568edc9b35c6.camel@suse.com>
Subject: Re: [PATCH 10/14] libmpathpersist: only clear the key if we are
 using the prkeys file
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper
 development <dm-devel@lists.linux.dev>
Date: Fri, 29 Aug 2025 09:28:22 +0200
In-Reply-To: <aLEc0gW0zNvIA274@redhat.com>
References: <20250726035855.363290-1-bmarzins@redhat.com>
	 <20250726035855.363290-11-bmarzins@redhat.com>
	 <7ceefd5d4a7fb72cb0162e3ef4c23286d128be09.camel@suse.com>
	 <aLEc0gW0zNvIA274@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Thu, 2025-08-28 at 23:21 -0400, Benjamin Marzinski wrote:
> On Mon, Aug 25, 2025 at 06:21:59PM +0200, Martin Wilck wrote:
> > On Fri, 2025-07-25 at 23:58 -0400, Benjamin Marzinski wrote:
> > > Otherwise this request will create a useless prkeys file.
> > >=20
> > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > > ---
> > > =C2=A0libmpathpersist/mpath_persist_int.c | 3 ++-
> > > =C2=A01 file changed, 2 insertions(+), 1 deletion(-)
> > >=20
> > > diff --git a/libmpathpersist/mpath_persist_int.c
> > > b/libmpathpersist/mpath_persist_int.c
> > > index dfdadab6..f901b955 100644
> > > --- a/libmpathpersist/mpath_persist_int.c
> > > +++ b/libmpathpersist/mpath_persist_int.c
> > > @@ -831,7 +831,8 @@ int do_mpath_persistent_reserve_out(vector
> > > curmp,
> > > vector pathvec, int fd,
> > > =C2=A0		break;
> > > =C2=A0	case MPATH_PROUT_CLEAR_SA:
> > > =C2=A0		update_prflag(mpp->alias, 0);
> > > -		update_prkey(mpp->alias, 0);
> > > +		if (mpp->prkey_source =3D=3D PRKEY_SOURCE_FILE)
> > > +			update_prkey(mpp->alias, 0);
> >=20
> > Should this condition be checked in update_prkey_flags() directly?
>=20
> We could, but it would just end up being a pointless extra check most
> of
> the time. Aside from the CLEAR command, we only set the prkey when we
> are registering a key or reverting the prkey if that registration
> failed. When we first set it during register, we need to check
> prkey_source early, since there is a bunch of things we can't do if
> we
> aren't using the prkeys file. And we don't want to revert it unless
> we
> updated it and have an old value to revert to.=C2=A0 In both cases we
> already
> had to do the necessary check before calling update_prkey(). The
> CLEAR
> command is the only one where we don't need to check if we are using
> the
> prkeys file earlier. So, I'd prefer to leave the check outside of
> update_prkey_flags() here as well, to avoid the unnecessary extra
> work.

Well, the unnecessary work is just a single instruction in this case.
I think multipathd has more pressing efficiency issues.
Perhaps we could improve our layering.

But it isn't important. I'm fine with leaving it as it currently is.

Reviewed-by: Martin Wilck <mwilck@suse.com>

Martin
