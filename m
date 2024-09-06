Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC46A14A629
	for <dm-devel@lists.linux.dev>; Fri,  6 Sep 2024 07:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725608718; cv=none; b=IuUQ7FWeRGp7SMA/NVFNu1zxhVoA3lFy65WWCn+m/EfEknQ9hOZsT+zhhASyrkQqyjE/9Pjl6YFkmtUI8z2fone73SiOxmPTSfnOtUWXF9a0AJ0hSkgdAUuvvclmpS80yx6E3Sjhopt04T9jGBQ7+C79OjiQdpaYFzOjuBOxNtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725608718; c=relaxed/simple;
	bh=3NoK7Hnkx0KBue0lw2BppxLFhdg73GFBeXjwtvlCZEo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RQNfMk+lGg9bqQYLJzxPAVAAMmpXgdpmWoi6mPKbgqZhj8RAzrlD2W7fRWNVlKqVOKChq+w9Tzur/diysVPVFplM2lXYl35ROJASO6UCzIuc9e4Ja3sZQxx0D2BjhhXcKbbzLxfHy8/M+J7oGCUp1Y4SVinzOvgEX459XVRu7vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Cqnro2p8; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Cqnro2p8"
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2f75428b9f8so3953371fa.3
        for <dm-devel@lists.linux.dev>; Fri, 06 Sep 2024 00:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1725608714; x=1726213514; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Jtm/jlRhW83bHNI0Rh7I6kI+BhOiw5kjaanQuhImyGw=;
        b=Cqnro2p85MBDMfWs4N3SQ+d5nrdV4CqvM+7iDiQHpFYUU8w4oLVT3DCHkO8Rx8ctCo
         QBsQvdt5Yw/fR/1qGGcQJwHR3nARsVa/fEpIlUP89l670rPPjiEisB8mNQgq2r4+V2hb
         7AiGttPgNUyTHvDssrjBc13tM7UmnKfnTDd5qN5xlPwZR2nKIbkLUnl4W3e8yMfgI3Lo
         8UR+qx0RMYD8vcSmon78QGW12WEZeWQRqWwVPUtWiaPDKzH+Yv4S6CjVy7pbKpFbiVbh
         Qq+AO9LcEMQjbFMNttGT35h1gYD5mt0c7gXF2Op/Oe8RczxutubtdFkXLMKBTsVQZ2pg
         xpjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725608714; x=1726213514;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Jtm/jlRhW83bHNI0Rh7I6kI+BhOiw5kjaanQuhImyGw=;
        b=cjxHM/LEtNSmqdMsImAhyMycX8ojnP2itFGQaw3EmCD1V1x88AGrUWN+LvX9XXuSff
         l9lYYfJSWKnLUtm3sbyPFxA4UHUYwcq5hD7TgPtmDR1y7Re6jfcvM+84wgb9vpaRfyRn
         jWgr19Xx4UI9YxGeNy9GR2PSEXzZbD5QP1MK+9K8ijUnjKjyJVNTra+Ovze+9dFHzcOl
         Gls0r3OaOJOVgM/nl5KSOn7UHs5jnJoBvqlduC1Ie1fOV7fR8C3vRS5KWCxMgarV6WE6
         SZsjOqDnhpt2gFpyL7Jc3U5CSynGnaYn6HPvy0QDEX9tR8QwphNiAjo49aKvNrTfu3oi
         ak2w==
X-Forwarded-Encrypted: i=1; AJvYcCUXLNPdA31El2mDo6h+AvlsQlLXNKr9MPajwWOm4yoRXJI+VGFmyNN5mWmSLe+Z3gDKpzVoDfj3KA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yzird8cazet7uTFhDvLt4mgjoYNexgty7hXM38aNLzjy2h4NNTc
	Jw1zhkn782nDqLnMaVR+ip2wYoG+xGf5tB7XeI6mud/YrGu4SdTnAAPJ/1RfuvY=
X-Google-Smtp-Source: AGHT+IEMyi3tgC7u03kg/GYqmqVm+G5oE1Et2vXSNbXP59lPzbxk55tLeW6krZQjcWFUE8GU9hn+tw==
X-Received: by 2002:a2e:be2c:0:b0:2ee:52f4:266 with SMTP id 38308e7fff4ca-2f6105c47e0mr268405051fa.3.1725608712976;
        Fri, 06 Sep 2024 00:45:12 -0700 (PDT)
Received: from ?IPv6:2003:de:3736:a00:d7e5:6139:e909:29dd? (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8a61fbb0dcsm237880266b.2.2024.09.06.00.45.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Sep 2024 00:45:12 -0700 (PDT)
Message-ID: <06b19ce3bb93d5d897b537e25ba6ca139cf28a8c.camel@suse.com>
Subject: Re: [PATCH 10/15] multipathd: split check_path into two functions
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper
 development <dm-devel@lists.linux.dev>
Date: Fri, 06 Sep 2024 09:45:11 +0200
In-Reply-To: <ZtoASjJZHbKltAJd@redhat.com>
References: <20240828221757.4060548-1-bmarzins@redhat.com>
	 <20240828221757.4060548-11-bmarzins@redhat.com>
	 <131273007ab11d8a866e395c1e3aa80598aa1dbe.camel@suse.com>
	 <ZtisJ_9A2-z0Gdly@redhat.com> <ZtoASjJZHbKltAJd@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Thu, 2024-09-05 at 15:02 -0400, Benjamin Marzinski wrote:
> On Wed, Sep 04, 2024 at 02:51:19PM -0400, Benjamin Marzinski wrote:
> > On Wed, Sep 04, 2024 at 05:38:52PM +0200, Martin Wilck wrote:
> > > On Wed, 2024-08-28 at 18:17 -0400, Benjamin Marzinski wrote:
> > > > Split out the code that updates a path's state and sets up the
> > > > next
> > > > check time into its own function, update_path().
> > > >=20
> > > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > > > ---
> > > > =C2=A0multipathd/main.c | 31 ++++++++++++++++++++++---------
> > > > =C2=A01 file changed, 22 insertions(+), 9 deletions(-)
> > > >=20
> > > > diff --git a/multipathd/main.c b/multipathd/main.c
> > > > index 94d4e421..300f8247 100644
> > > > --- a/multipathd/main.c
> > > > +++ b/multipathd/main.c
> > > > @@ -2390,6 +2390,7 @@ sync_mpp(struct vectors * vecs, struct
> > > > multipath *mpp, unsigned int ticks)
> > > > =C2=A0}
> > > > =C2=A0
> > > > =C2=A0enum check_path_return {
> > > > +	CHECK_PATH_STARTED,
> > > > =C2=A0	CHECK_PATH_CHECKED,
> > > > =C2=A0	CHECK_PATH_SKIPPED,
> > > > =C2=A0	CHECK_PATH_REMOVED,
> > > > @@ -2629,13 +2630,10 @@ update_path_state (struct vectors *
> > > > vecs,
> > > > struct path * pp)
> > > > =C2=A0}
> > > > =C2=A0
> > > > =C2=A0static int
> > > > -check_path (struct vectors * vecs, struct path * pp, unsigned
> > > > int
> > > > ticks,
> > > > -	=C2=A0=C2=A0=C2=A0 time_t start_secs)
> > > > +check_path (struct path * pp, unsigned int ticks)
> > >=20
> > > check_path() used to be one of our core functions, and you now
> > > re-
> > > introduce it with quite different semantics.=C2=A0
> > >=20
> > > Perhaps choose a new name?
> >=20
> > Sure. Although the new check_path() is just the beginning part of
> > the
> > old check_path(), where we actually run the checker, so it seems
> > reasonable to me. But your objection is also reasonable. I was just
> > getting sick of coming up with new function names by this point.
> >=20
> > -Ben=20
>=20
> Do you have ideas for the name, because I can't think of anything
> that
> makes more sense then check_path() in the code paths. Here's the code
> paths

Ok then, keep the name. I was hoping we could find something better
because (as you correctly show) there's already quite some confusion
because of multiple functions with very similar names.

But if we can't, so be it.

Martin

