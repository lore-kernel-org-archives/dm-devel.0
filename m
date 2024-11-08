Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E4A61C1F2B
	for <dm-devel@lists.linux.dev>; Fri,  8 Nov 2024 23:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731107020; cv=none; b=a8azIgLwQhvjEHKdz2clw6/Qy+18a6gHTljOMP60WW6yW0EdX7rrNd7dnLVvOYyg/btb9e5qykhFkLZQoH4kow1JA8x9JDuYPLxGZOWA4rjlFCpRaKoiYiYd6lEhSdEDVsSfIDMDQyqBv5Htjj6zBvqXEpt7Zlir7IRGU6VZaDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731107020; c=relaxed/simple;
	bh=3Y5uEfx1m4Ulu4UcwMdx0RTskWSdPUsMeVxrBfYbHqQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=AHz5GfZpwd6NRW0YapQ/oNGK/evjHFYLIRlDf3f43sRbvpk+gm8EduJp7PJoytvIYnHmfqxK/BjDJxA9QwdYg+TisvHU2excaxT52Yv6KKf+I5TNaqO6mz3Z0jNu2NwdZSJ8nzDBrgEcZdMjI1G21E3NUa7ZW0o+pn+Do1gAr1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Ey11tqXD; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Ey11tqXD"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a9a2209bd7fso421052266b.2
        for <dm-devel@lists.linux.dev>; Fri, 08 Nov 2024 15:03:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1731107016; x=1731711816; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3Y5uEfx1m4Ulu4UcwMdx0RTskWSdPUsMeVxrBfYbHqQ=;
        b=Ey11tqXDcKFFYk82O7qp0+j607MwJIFmfZ1hIpWPSHutbX/0DfKYoE7WihEaTQWcqo
         vR881O5AvOiw/PmNBRRsIxu5tMSAr5EhXkjcPbd8nl0Lj/AUlnCTDQprrhpFq5Qrq6/d
         37KNoleCGmKPKXQJLoZSz0i/yhjxwlX5LKWGOlSxEQF5MTQ/IO2GYObs0RQao1AAjkNb
         drB0WviAtDpmM1Di8SlwQzX76T+BfAXsQkq4aeR2GR0S68FOJz8cRTXZM3zgafA78BS0
         mWi8TaFq4irvNzol4FcBry3yFzaDhGeyHYxZDg0FCtsDfnnsg1EOErvAJqw6ntd4yR2d
         QLiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731107016; x=1731711816;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3Y5uEfx1m4Ulu4UcwMdx0RTskWSdPUsMeVxrBfYbHqQ=;
        b=tOvqv3g99XPw0QxwXJ9xYlC4J+VoVduWKh+BjNQMzXv7dBzveK+fhFr9XZLRis+NnS
         QH4vf7X6qdLcEgKYjRv55a+7aYJPaJ7oQS+fDB4p0rLffuF+Szk3cJZ8C7//wyS/6x2g
         SsHQNzpDZNhSt7zvCOqJ/dDj7SZoMemxAr4SLAZDf+9HFOnkMFGCCZYT7nJtVZr69Gsq
         KBOminfIKq/SUkNxvgT315H2Dh/a3PtNhOcwGX34OcILVgdZozYr5dzQX5jii6qeL93z
         T0dqcjyYRLYWSkjdHTVqFzK45tqFbFjd/54NvNYgDGr5NsfvxzIFkWoMikaihSs382nY
         hgIw==
X-Forwarded-Encrypted: i=1; AJvYcCWuwKdbjk0LjYGFmtmWoAvayiNKP2aGJe/lv5Itjz/AS8b2TMPzq4UACWhevvlEnABNEOtT4eCapA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy8dI4smkOpk3ghaZSobhlP5N5QX2WC4noBOWhkY6z5oK555Xuf
	c8hwhZGVKzMqTfpm60dSw5LoeNErIdaxEoJd6yu/no8fbQa/5m9QfmLlZ4sF2VA=
X-Google-Smtp-Source: AGHT+IHTilPRAhrETNjbbiBEQIPKOo7bkak1xSLC3XQWpxyfbilRqUSh6LOBr68Jqlspzcy3EM0QSQ==
X-Received: by 2002:a17:906:eec3:b0:a99:f71a:4305 with SMTP id a640c23a62f3a-a9eeff0da96mr413637166b.18.1731107015236;
        Fri, 08 Nov 2024 15:03:35 -0800 (PST)
Received: from ?IPv6:2003:de:3746:4600:ac00:378:25cc:9f2c? (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9ee0defd9asm290574466b.144.2024.11.08.15.03.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2024 15:03:34 -0800 (PST)
Message-ID: <a7b6076cc759383e407ac9e46ff39be14f5a1b6d.camel@suse.com>
Subject: Re: [PATCH 0/8] multipath fixes to tableless device handling
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper
 development <dm-devel@lists.linux.dev>
Date: Sat, 09 Nov 2024 00:03:33 +0100
In-Reply-To: <Zy6Lz1y0-dVXvodH@redhat.com>
References: <20241031183301.391416-1-bmarzins@redhat.com>
	 <268bc68ab339ff6d6546f836329ee673fe734458.camel@suse.com>
	 <bc44c44523af9f1014c6e96842371bce422f18a7.camel@suse.com>
	 <Zyz8SFDAkIggpuND@redhat.com>
	 <692cb30cad72ed8165b8efd0751c8c5cb1f03993.camel@suse.com>
	 <Zy6Lz1y0-dVXvodH@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Fri, 2024-11-08 at 17:08 -0500, Benjamin Marzinski wrote:
> On Thu, Nov 07, 2024 at 07:02:11PM +0100, Martin Wilck wrote:
> > On Thu, 2024-11-07 at 12:43 -0500, Benjamin Marzinski wrote:
> > > On Thu, Nov 07, 2024 at 01:20:09PM +0100, Martin Wilck wrote:
> > > >=20
> > > > Thinking about it, I believe we should actually accept devices
> > > > that
> > > > have an mpath UUID and an empty table, and add them to our
> > > > mpvec.
> > > > We
> > > > should treat them like devices that have a multipath target but
> > > > no
> > > > path
> > > > devices. If any matching paths become available, the map will
> > > > be
> > > > reloaded and the issue will be fixed. IMO, this is less prone
> > > > to
> > > > race
> > > > conditions than trying to delete and re-add the devices.
> > >=20
> > > I'm not sure off the top of my head how easy it will be to handle
> > > devices with no dm table at all, but I'll take a look into this.
> >=20
> > I tried this on a system with 0.9.9 yesterday. 0.9.9 will not add
> > the
> > map into the mpvec. But in coalesce_paths(), it will just reload
> > the
> > map:
>=20
> Given that the code already does the right thing without needing any
> changes to handle tableless maps makes me feel like just removing the
> final patch is the best idea.

If we do this, do we still need the special case for DMP_BAD_DEV? IMO
we just need to make sure that dm_get_maps() doesn't return an error if
it encounters an empty map.

> The only issue with the current code is that if you have a device
> with
> no table with the UUID of a multipath device but a different name
> than
> that multipath device should have, multipath will try to create a new
> device instead of reload it, and this fails, since the UUID is
> already
> in use.

That should be handled in coalesce_paths(). It's basically the scenario
that occurs if we enable or disable user_friendly names.

> That should probably be handled by making the multipath code pay more
> attention to the device UUID and less to the device name, but that's
> work for a different patchset.=20

Yes, definitely.

Martin

