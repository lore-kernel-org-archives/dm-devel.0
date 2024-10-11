Received: from mail-lj1-f193.google.com (mail-lj1-f193.google.com [209.85.208.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC22207A30
	for <dm-devel@lists.linux.dev>; Fri, 11 Oct 2024 07:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728632422; cv=none; b=GUToEr+Wu38sqtkik0gxrsf9IVFcg14vNyeUJLtd38VKmatZDJvBhvgRFE4VCmpsMcFqpKMr0sfKWmKskjvINUQrvl/XLJ9/b4KioH6MQOvaxEA9DjtiuWi1mtX5Kg8/1LIZp/guGJ+ESI2FF0ZiNib88xFpDS5ylSG1sTJdK8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728632422; c=relaxed/simple;
	bh=O7KSZ+qDaPq/4x0BCMP1iEiGU6rU9BJxLa3z5Xh+go8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cdklYNJeuBfIEzjHzBtsFm8ns3hZjvbibopzaEjsA4nnD5EdnyiObR7fRab3KOSaKJNpqtlskeHaUuGORaprlyLfN1i/1U+vIaVGWEnS34tY5Tsu6YS7XcxE015ldxFqOQtm3ktgcFnD+mgrcmruggLHWl4+ZxkbOkgvCuVoZaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=KFd03FlL; arc=none smtp.client-ip=209.85.208.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="KFd03FlL"
Received: by mail-lj1-f193.google.com with SMTP id 38308e7fff4ca-2fad5024b8dso19933411fa.1
        for <dm-devel@lists.linux.dev>; Fri, 11 Oct 2024 00:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1728632416; x=1729237216; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/0B9BC1OSag79aK72QLGfEMRJCzn0e0ZZ0Q2b/HVawU=;
        b=KFd03FlLIX67UYCYuxPM3lzUQ3OZRzvgLJWd1EoLdlWj6NxWq1HnDSAKl7/MoLfkX7
         0eT/VacyFI/R7n+JQ5D+38EcDml1aiWpQpezj7nSiOgqCq5ZEhxuP1XjtDjBMUOprFqY
         LXYK7dCU04fejtVj1jOTJ6J+qSFDrh5VCvAxC2LE3+FUwHfQQww2kePpJX8MWyb704Xx
         85f0IWIj55Uuzkdkgr5IcptnkbIfz8jQpeOGIAE44/wYdqO0Ji3952UhGrnmOIv8HoXX
         5+OCt3XUddF2awgYQSeZTOgH2mZcZ+yoGbCQz2UoJ0I6abeMAzB+SlGLLh2yi255giTE
         +r8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728632416; x=1729237216;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/0B9BC1OSag79aK72QLGfEMRJCzn0e0ZZ0Q2b/HVawU=;
        b=EgNjdDXBr4MIJWmq5PHySEJ29wD8VV7FlcwPiaR8bC1gLByG/hG0pBFh4cV0r1lSyb
         9GzrstPpU7k0f/RR+JDS6JJjMlJZrYfYG0L4yltolXHaFR5zkWzx0YsrhwU7RJPb8hts
         hnBz/fVQNd/L3e59iGZMsOzaHVeI21tHkXBwZ62cVDQf1uzwQY1lj/L0V5QD2DZ1oUWM
         to6Imgn3Z5mh1rGXkm3MIZ1hXN7wniAh1EgiS6NyCCtDDYecWg30mHhtgNqe4grZXlWy
         eLonxei63R9522z5/CSvCN7LQif+Z8hP085WXZDBFJt9DjL2n9r4Xd43xivWeRQmAQfl
         XM8g==
X-Forwarded-Encrypted: i=1; AJvYcCXlHfN6sBqjGXAe+JdZwiBelw5vJifqaVXaiXAC1eiYnibfaO7MdKr1iqD5tI1fowQiMwjWiUpnXw==@lists.linux.dev
X-Gm-Message-State: AOJu0YzrokQqpEYp0L7GD7CGBuzZ5otXhY3fiMwLM9RMCjPAcm1S9c5K
	JTAtt4anAJa+oyMCfhlu5YQRJv59WUM/S91bfi8FBDkrMDVT96/kNF21a9XbF00=
X-Google-Smtp-Source: AGHT+IEmedRPtzfoM8kGj1kzcCjJXhVb/nc6OM98tjZN3SEtukYvggcvVHeUCuZDMSTHpbNbcP1+KA==
X-Received: by 2002:a2e:742:0:b0:2f7:7031:dc31 with SMTP id 38308e7fff4ca-2fb32780f04mr6942171fa.27.1728632414905;
        Fri, 11 Oct 2024 00:40:14 -0700 (PDT)
Received: from ?IPv6:2003:de:3707:9400:b9ee:e7ce:aa91:658e? (p200300de37079400b9eee7ceaa91658e.dip0.t-ipconnect.de. [2003:de:3707:9400:b9ee:e7ce:aa91:658e])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c93711ba52sm1626330a12.26.2024.10.11.00.40.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2024 00:40:14 -0700 (PDT)
Message-ID: <178cfe2729c00dda22656fae5f6ff7260976f5a2.camel@suse.com>
Subject: Re: [PATCH v4 04/22] libmultipath: remove pending wait code from
 libcheck_check calls
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper
 development <dm-devel@lists.linux.dev>
Date: Fri, 11 Oct 2024 09:40:13 +0200
In-Reply-To: <Zwgu9KvN1ZTkCkJL@redhat.com>
References: <20241009011523.2381575-1-bmarzins@redhat.com>
	 <20241009011523.2381575-5-bmarzins@redhat.com>
	 <061a44d1ab78bd95b10bd908ffbfeb2bbd436ca0.camel@suse.com>
	 <Zwgu9KvN1ZTkCkJL@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Thu, 2024-10-10 at 15:45 -0400, Benjamin Marzinski wrote:
> On Wed, Oct 09, 2024 at 05:00:55PM +0200, Martin Wilck wrote:
> > On Tue, 2024-10-08 at 21:15 -0400, Benjamin Marzinski wrote:
> > > =C2=A0
> > > =C2=A0	if (ct->running) {
> > > =C2=A0		if (ct->req->state !=3D PATH_PENDING) {
> > > @@ -345,31 +343,26 @@ check_state(int fd, struct directio_context
> > > *ct, int sync, int timeout_secs)
> > > =C2=A0			LOG(3, "io_submit error %i", -rc);
> > > =C2=A0			return PATH_UNCHECKED;
> > > =C2=A0		}
> > > +		get_monotonic_time(&ct->endtime);
> > > +		ct->endtime.tv_nsec +=3D 1000 * 1000;
> > > +		normalize_timespec(&ct->endtime);
> > > =C2=A0	}
> > > =C2=A0	ct->running++;
> >=20
> > Sorry, I have another concern here, despite my reviewed-by. This
> > very
> > old statement, combined with "if (ct->running > c->timeout)" below,
> > somehow assumes that "running" counts seconds, which means that
> > this
> > code must be called once a second. I guess this has been
> > approximately
> > true in the past, when this code was originally written. It has
> > never
> > been clean, we should have compared time stamps instead.=C2=A0
>=20
> Yeah. That makes sense.
>=20
> >=20
> > But now, it seems to be plain wrong, "running" will never have a
> > higher
> > value than 1 as it is only called once from libcheck_check(), and
> > the
> > (ct->running - c->timeout) statement is broken.
> >=20
> > Am I misreading this code?
>=20
> Either you are or I am.=C2=A0

I am :-)

> libcheck_check() is called by start_checker()
> each time a path comes up for checking. libcheck_check() calls
> check_state() with the number of seconds that the checker should wait
> till it times out. If ct->running is non-zero, but the path is still
> pending, check_state() increments ct->running and returns
> PATH_PENDING.

My misconception was that we call libcheck_check() once, and then call
libcheck_pending() repeatedly until the checker either finishes or
times out.=C2=A0The isn't true even with your patch set, both functions are
called in every checkerloop, just that libcheck_check() doesn't restart
the checker instance if it's already running (it just increments
running, as you mentioned).

(Why I had this "misconception"? I think it's kind of a vague idea that
I had in my mind how it should work; it's not in your code, and I'm not
asking your to change the code in this way).

> libcheck_pending() is called by get_state() every time a path gets
> checked and its state is PATH_PENDING. If ct->running is greater than
> c->timeout then the checker has timed out (it assumes that ct-
> >running is
> counting seconds) and gets cancelled.

>=20
> Also, I only see (ct->running > c->timeout), not
> (ct->running - c->timeout) are you talking about something else in
> the
> code that I'm missing?

No, typo.

> At any rate, I can change this to use actual timestamps instead of
> our
> ct->running assumptions.

Yes, please. "counting seconds" this way is wrong and confusing.

Regards,
Martin

PS: I'll be out of office for 2 weeks, so final review of your series
will probably be delayed again. Sorry about that.

