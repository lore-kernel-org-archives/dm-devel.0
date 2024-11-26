Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 472BE139D07
	for <dm-devel@lists.linux.dev>; Tue, 26 Nov 2024 11:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732620210; cv=none; b=HHU5Jz8VnknrQqNE1GTTJKkJe0Q5O9vBWihdld82i1y37NfgY9QuzgKbAgKTZ5MGyqUykwhCudERN2Wc7f1tCVTeg/TO+DvfFpKfsoy3dnLJODseuaU1YPn0Dp82kH2PPONNDVJHnQn8gSYAyRQDfGbdsP1WNNbev/0czJYsYWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732620210; c=relaxed/simple;
	bh=WyFIM05pYmS/1+dn3ZOYOh5BkAGPieWidZfqotau9s0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UNI8m+ycLEa7NHB63LSU3cUkwN5tL6uvN2OFN7mKf4JnK+NE7m/I7F8JFqhFnB2Qm0zhJ/Y6ItB1lMaYvbIbSnS3acg0aNZOHG9ojZkZoybsLuWJ216Jl3ErMisn9H+BwHy/qT2TeHDgZwdib4W33L/YpYrAjkUOK98YImyUXro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=XfU9MjLe; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="XfU9MjLe"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-434a8b94fb5so1176195e9.0
        for <dm-devel@lists.linux.dev>; Tue, 26 Nov 2024 03:23:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1732620206; x=1733225006; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=sMfXqCznumpkAswokl+Gfd/KLc4THJ1niY8BniV2Nbo=;
        b=XfU9MjLeJuD/oxh4YLbisnFKi+67VYMJhzZxjgOfstrAU6P/hsas+OaZaB+soS8oJY
         5C7+oRjCHD26eq/P33C5irbzg4WAnz9+WZwHCEj31uj+hbGhpBL80IwcZ9/UH+ClhqjP
         VXDz+UfLP9IC3ldq10cIQqaXV/GIKEgHc9ZlJKOx6gbUohre7Dw0usVWAl8zK5t1GrHA
         VLcMBAe9vxMGKfeeDsF0qHZqEFduybzoteqWqVsm2UVv6WymvgjHf0ga6NsykaKrdF/T
         sixyy1X7KekW1on7WO4ckh7LrZlTaGV9rE3WrZAg2VKdPYWSMmFzd+gxOUJO6bjAisNx
         fVwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732620206; x=1733225006;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sMfXqCznumpkAswokl+Gfd/KLc4THJ1niY8BniV2Nbo=;
        b=NppRXHvtGjfKRkXsRoN5ahASP4DrfwwtUHkRqmT8TPvI6Gkb9503QA1vZuf/nltqSV
         spMDcP+ek7gB3JkNYtI+hLgz7JT80of+f4dczlMTQzQeBRjcFRQFPmdP29TZ1H5ixJbW
         5MtFVnMSk/16X6I11FwWu4JLBR5JGgBDaFKyQ7JoY2lWDsdTTHwG5+vX1hT0qr+h4O/9
         /wS0vn05fosnagUicetMSPQR2qOG5znzV0wXZ2eopIZapDrRO7hdYMfRT7IVwLY7bRuy
         tR2ds2JcAlSIv2wYsWx0EWv9g7K9duyVaVcNVT4681OxrBAMnrl8lIHpiO6XHF7IRfmo
         iRUQ==
X-Forwarded-Encrypted: i=1; AJvYcCVfVAUBhvkf7PiqLbccgmn137iLk/RdzGpmMF9Gd4KqMCuDyf63KI+J5DLNLMhSdHc6zyguXZcqjA==@lists.linux.dev
X-Gm-Message-State: AOJu0YzKdpzrOHUbzK9vSxS+qkTQEqBsb3FiWADOpakRJ3Yw7uh9FDlh
	1LePIk9nhypwRGjdEa8DyaLQJmFI2SNZV0MMPDV9RyIPJA3r5WMPidwb0/Tce1U=
X-Gm-Gg: ASbGncvCEdakRE4AsNIGed30Xum2wbFzLnVMJaLUq2LcNLsd1BbQ4jW8qV3mFkHkIOC
	qDOhCK0aVE/yuO7DxcJxLEaUFeNtOuYScl5bwy4tpdwSyHG0iMfUB/MA1NzW4b+DRv1ayMe34bL
	IwGhmCP8CkaaJ94cmHhUPeVDImhycpORLjI2wXxsRyGZ6/qWLXQrY00Y+c0Z+ehpHczHjqH79SJ
	NzfJeFmTVQbOEnnd6C0K+j50+qf4tzbMq324c6wC4PVmLUr1WLCmeNvomNt5vNizWE7Yk7g+n5H
	BA5zXejdBKbrvOwt/sYGKTH1HwEvdrIks7LtDKfgkqNYTE1LTPfJda+FfLZHI2qqg4Wac+44FQJ
	ZdyO6/w==
X-Google-Smtp-Source: AGHT+IG1F7z+tk5V0+BV3iRlphlN1cu6UTYawBnsuBOkLSBarieqdJPhrlRnislwqbWZAQuwyoPiaQ==
X-Received: by 2002:a05:600c:5106:b0:431:5226:1633 with SMTP id 5b1f17b1804b1-434a4e7222fmr23382755e9.6.1732620206208;
        Tue, 26 Nov 2024 03:23:26 -0800 (PST)
Received: from ?IPv6:2003:de:3746:4600:ac00:378:25cc:9f2c? (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43499bdfc0fsm102235485e9.19.2024.11.26.03.23.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2024 03:23:25 -0800 (PST)
Message-ID: <bb6ef52c1ae6a1eeb90a6f69fc7bfdb110f533f2.camel@suse.com>
Subject: Re: [PATCH v2 06/13] libmultipath: handle a create corner case for
 empty devices
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper
 development <dm-devel@lists.linux.dev>
Date: Tue, 26 Nov 2024 12:23:24 +0100
In-Reply-To: <Z0S8ZgQ4sI4gRvcQ@redhat.com>
References: <20241122211133.718861-1-bmarzins@redhat.com>
	 <20241122211133.718861-7-bmarzins@redhat.com>
	 <e1b620534c909d8ea01e193292ec5dd1ad652ab0.camel@suse.com>
	 <Z0S8ZgQ4sI4gRvcQ@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2024-11-25 at 13:05 -0500, Benjamin Marzinski wrote:
> On Fri, Nov 22, 2024 at 10:54:31PM +0100, Martin Wilck wrote:
> > On Fri, 2024-11-22 at 16:11 -0500, Benjamin Marzinski wrote:
> > >=20
> > > +	if (mpp->action =3D=3D ACT_CREATE) {
> > > +		char alias[WWID_SIZE];
> > > +		int rc =3D dm_find_map_by_wwid(mpp->wwid, alias,
> > > NULL);
> > > =C2=A0
> > > +		if (rc =3D=3D DMP_NO_MATCH) {
> > > +			condlog(1, "%s: wwid \"%s\" already in
> > > use
> > > by non-multipath map \"%s\"",
> > > +				mpp->alias, mpp->wwid, alias);
> >=20
> > Nitpick: This is almost the same message that dm_find_map_by_wwid()
> > has
> > printed immediately before. Similar messages are also printed in
> > all
> > other callers of dm_find_map_by_wwid(). I suggest that we either
> > remove
> > the log message in the callers or in dm_find_map_by_wwid() itself.
> > Probably the latter, then we can decide on a case by case basis in
> > the
> > caller whether the situation needs to be logged.
>=20
> I'm confused here. dm_find_map_by_wwid() doesn't print any message
> itself. It calls libmp_mapinfo__(), which could print either:
>=20
> condlog(lvl, "%s: map %s has multiple targets", fname__, map_id);
>=20
> or:
>=20
> condlog(lvl, "%s: target type mismatch: \"%s\" !=3D \"%s\"",
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fname__, tgt_type, target_type=
);
>=20
> in this case, but at level 4 verbosity, and these are used to
> distinguish between the various reasons why DMP_NO_MATCH could be
> returned, which seems like a reasonable thing at that verbosity.=20

You are right. Not sure what I was looking at. Probably I was just
reviewing your patch too late at night :-/

Forget this. So your series LGTM except for the typo in 08 and the
suggestion to squash patch 9 and 10.

Thanks
Martin

