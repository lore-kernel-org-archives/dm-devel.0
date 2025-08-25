Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016152FD1A0
	for <dm-devel@lists.linux.dev>; Mon, 25 Aug 2025 15:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756136184; cv=none; b=byRUriiY+aJz5vPmgJxZwpFftQKqUgo/g1GQidNbNktqDntlAugNzgvM4qJugegVG24gUh71GWRW8t9mmXgzCK7TqUyJVEqu7su0qDIzyZweZrTS1Com1MqUZik7b/Lo3yez3LBpS4qK3HXHnsGGUJCgIr+L2yUp/jbD6cQgsaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756136184; c=relaxed/simple;
	bh=BjQVmCX5n+ArM88QBrgaIqEAwZDVN/jQocWl4Ym9G+o=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=R4H7PYRm1CcoTS0nBFC4JsCpiVvpb5XZAiN24w7XjfPqNMT1jiO+JtIbe7N7dfgm4y52onjAQLutfiXedCi5+9CJ/va9XkeOTrb+JfboDL9Cya6qMYNHBVopee75ZTDkb++ku4qNWNhEb4twpGGbtku5YaVk9DlSMMELbuLiJh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=TjyOiy/F; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="TjyOiy/F"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-61c51f56fc7so1880514a12.1
        for <dm-devel@lists.linux.dev>; Mon, 25 Aug 2025 08:36:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1756136180; x=1756740980; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oW6/H1NTEr7dnU4j6AkzZ+J5uK2zCG5/92g6cJ6hAko=;
        b=TjyOiy/FalBIRt2AMUEjV0oy7jn/xPXH43lvPHYyvkK1wlwhsuGcR58FQfDiiaPICY
         93HXcVSKA3xaCZzyG2Hb1mlV1Q0bgXhmmsPby2xaTI8AOChNlLgZbGL0XY8ICpMQoxSv
         AlnL7XDYFjlpfZFk+epI/QVN90ib4QtX7fbraQCWo0VyM7HSSpByyXEUjChK3sNCv9Zb
         leMU4cuWpW7axNq4/i9TQ7Xpny1DnZgfngaIV/GDo9woUASJHrsfvgNCATFbDddu/V6M
         0nSxsYeZzEdQzvdNKx2kXUyt5i+IcIP1DACW1D647lbntqHfjuip8YcJ/E1fS/MY3sFs
         r54g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756136180; x=1756740980;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oW6/H1NTEr7dnU4j6AkzZ+J5uK2zCG5/92g6cJ6hAko=;
        b=WkKRNjFNW/DsyyuOELs190MhseWcauD8ZUU9TG1uw8nmNJjazXznoq/2uYLbUNN9Q2
         MPkxFOB5OL3gerstjwBsuqjgFCx2ZOei6nRa6wA4673l478aUyj8X+x4pV6T1Ecc1lP5
         ve8WaQGu/4d9L3blVePc2XDWEDcywxmJrVeEAfzLEd3Yy4COGpxwrfzjTlJzy63EZV0u
         2VcSxMp5EtPaePr03xRR5bpauT3e4JfofDWLB+d1j1+z+XNngFfBuGHlQQMXfGEBTwP8
         6oaUfOVGVeF/rMZk69tkkXt3X54k85wB4aYYXc5Nin4N6Dkx4NsY9+7mJlE0+YlA6Ltb
         beeA==
X-Gm-Message-State: AOJu0YyyWl2bGsUQtvlGWF+vU0LHO5LvHXlasYfjzXJHhypayA/hNDY3
	m4tBixcrVuHSLdjixD2WDhGSX4hMvi4WTxLDG8FDi0qTLL6qff+RKzTKL8odOu7JEBlV49g5O4l
	Ua5B8t5g=
X-Gm-Gg: ASbGncuwlpVc4gVy2zMFlhpwCxXqi+PiPRwQ378JAv8JpgT3NrzpawimkFYqf9qNXpA
	LyOWfk5s1Fb9ipsurnjRpTnT/Wreo85Ia+ywG7nmQE9z8pkkTELwfOF7zCVRg5FdI1R+5TO4Exr
	SxegOFjtaxLqWk+5Ri4IZVyjKImRK5pE6Itl+44lYlBI4N9A4zVIKRwtIEb4LSK6fdUvo8idslb
	gvHfEcOa4uk7pMouOdcGhKnZdVmf8rKh35DZ06kRwMFEjHBohMou2ZoAMfga7W6Wa+dlGVoNjt5
	ulaiE+UqjAHKiozib4EuoHxOK3LGeQTWxe2kj8E2FHeBMo3Loe8uZ9cu19klBrNVpENQBnsd/Y4
	T+pdIfaDNqFtshqZTIS+1g8lT0+WTTkelvPGC0AAT2SNhkDxiREADzg27XGdsW8WlLNKdM4kmur
	R3KhmVoOfiwRCtDnR2wXGzMLO9GdMBbCfgPLTZUECu6CohlMh07EtNLa4=
X-Google-Smtp-Source: AGHT+IG8EIV+eWK4bSQxHtMGhED8AoUTUDJzUZYHsFHGdk4/VxYLDeOfXr+0Ot0SceYHEEj6AnTgDQ==
X-Received: by 2002:a05:6402:34c5:b0:615:905a:3d43 with SMTP id 4fb4d7f45d1cf-61c1b487c6emr10512351a12.16.1756136180063;
        Mon, 25 Aug 2025 08:36:20 -0700 (PDT)
Received: from ?IPv6:2003:f9:7f15:4e00:f2e:2331:5e9d:fe56? (p200300f97f154e000f2e23315e9dfe56.dip0.t-ipconnect.de. [2003:f9:7f15:4e00:f2e:2331:5e9d:fe56])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61c316f4fc9sm5083709a12.34.2025.08.25.08.36.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Aug 2025 08:36:19 -0700 (PDT)
Message-ID: <2f0981cbfc0f8ea6e5a05d7829eb643675048a0f.camel@suse.com>
Subject: Re: [PATCH 03/15] libmpathpersist: reduce log level for persistent
 reservation checking
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Mon, 25 Aug 2025 17:36:18 +0200
In-Reply-To: <d2797732d55fbeb4f474fffbde623c8480da27a0.camel@suse.com>
References: <20250710181100.3997759-1-bmarzins@redhat.com>
		 <20250710181100.3997759-4-bmarzins@redhat.com>
	 <d2797732d55fbeb4f474fffbde623c8480da27a0.camel@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Sun, 2025-08-24 at 14:57 +0200, Martin Wilck wrote:
> On Thu, 2025-07-10 at 14:10 -0400, Benjamin Marzinski wrote:
> > Move logging of minor expected behavior to INFO level. Modify the
> > log
> > level of some messages by whether or not mpp->prflag changed
> > values.
> >=20
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> > =C2=A0libmpathpersist/mpath_persist_int.c | 26 ++++++++++++++----------=
-
> > -
> > =C2=A01 file changed, 14 insertions(+), 12 deletions(-)
> >=20
> > diff --git a/libmpathpersist/mpath_persist_int.c
> > b/libmpathpersist/mpath_persist_int.c
> > index 612bbed9..4172167a 100644
> > --- a/libmpathpersist/mpath_persist_int.c
> > +++ b/libmpathpersist/mpath_persist_int.c
> > =C2=A0	}
> > @@ -761,22 +761,24 @@ int update_map_pr(struct multipath *mpp)
> >=20
> > =C2=A0keys.key_list[i*8], 8 , 1);
> > +		if (libmp_verbosity >=3D 3) {
> > +			condlog(3, "%s: PR IN READKEYS[%d]
> > reservation key:",
> > +				mpp->alias, i);
> > +			dumpHex((char *)&resp-
> > > prin_descriptor.prin_readkeys.key_list[i * 8], 8, 1);
> > +		}
>=20
> I'd suggest to restrict usage of dumpHex() to verbosity 4 and higher.
>=20
> > =C2=A0
> > -		if (!memcmp(&mpp->reservation_key, &resp-
> > > prin_descriptor.prin_readkeys.key_list[i*8], 8))
> > -		{
> > -			condlog(2, "%s: reservation key found in
> > pr
> > in readkeys response", mpp->alias);
> > +		if (!memcmp(&mpp->reservation_key, &resp-
> > > prin_descriptor.prin_readkeys.key_list[i * 8], 8)) {
> > +			condlog(3, "%s: reservation key found in
> > pr
> > in readkeys response", mpp->alias);
>=20
> This one should be logged at verbosity 4 only, too, IMO.

You made these changes in 03/14 of your 2nd set.
So this one is fine.

Reviewed-by: Martin Wilck <mwilck@suse.com>

Martin
