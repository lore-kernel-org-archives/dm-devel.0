Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F9423D2A3
	for <dm-devel@lists.linux.dev>; Thu, 27 Nov 2025 11:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764243077; cv=none; b=HAdn1XzfM9vDlj74MCIKzZxhvzpm1IeqVxb3fowqZYMnkyNSGn3ENEx++gu8R2so5HFG45cYWERGKk8SJSOov9VvcF4GdVihH2pANEEu9n4Tm9IETHdKoXojjGbN9qFWQj/8XHRue1TZLQJS9JqmP9FPAVcpXuhw9/s7dAbJmlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764243077; c=relaxed/simple;
	bh=Tdi3LZCObny9R6pAPOASaB3thOUED2PWBa9EOKIIQfY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rikMwe/d2Xd5ZUsonPGbIavYoXkV0etgaLe44O73PxDh5ynpiBQTvzhZO8L3DCuiCVqBAkGTrPu1dse7g+ROTLYYEOQ+lYXTO9PplcVSiAKTvth0zhrolGK/Gbc0tMotLaLHggonHVh6sjz6/pL5xzBbN6+iu7Th3K9/bX4xl8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ISPx3hc5; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ISPx3hc5"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b7355f6ef12so152715766b.3
        for <dm-devel@lists.linux.dev>; Thu, 27 Nov 2025 03:31:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1764243073; x=1764847873; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Tdi3LZCObny9R6pAPOASaB3thOUED2PWBa9EOKIIQfY=;
        b=ISPx3hc5VUKa+YZIrvP+ZP0FT7pyGIwq1DgpMCsNDO47x311g9f2yoE5iadAi7DzWf
         M9Pd9CY7Ha3OVPcqtgIMVEibITvGronW60VgT2zqBkKn+FIs32jTqr7s/1I4AHSDtLUv
         Dh98pfscjVUc+/AUMDUfnylRkycEvLl/tPHRnwo/heLcsRzoh+yaTVMzVYHSMT7Ic3mq
         wnG7/dwKi/RR7w7qpNf3rIth/W8glBV/cE4bLrFD8COtXY/L2DsXq/RFv21i0sq2u4hF
         Ru9ios22u3+b3KI9inmabrTSMpb7tAOOOcWaQ4Hdz1yjrTA3qFko6FgHwvXGMLVvaJg9
         ghKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764243073; x=1764847873;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Tdi3LZCObny9R6pAPOASaB3thOUED2PWBa9EOKIIQfY=;
        b=nA30849X9p/GOUknTiNi3IOly+3A3udMMGjWSC6HWXIv8e3mG+TRCT22msIYysIhzu
         ckNxhfbOwCQr+frk15i1KZ0i/FO0AbXZ6+IOHwu1+V3mIl4mt1oTKrh9wnpRdLlRPoSd
         CGpPEPulWpHEeeHEYoUK+L55Otc3nxqqQpzgdl17+mOUr0J4Z0zTmBWmVIeuxwh8Uek4
         e074n57wPS9+tSbGCzhw8tyawRFzQTSmp+FsthxmhDndevV9V9MVEQJae3OwkcBkF6ds
         ZjjFsjsa1ycJ0k0xaGdTShV1Fc6tSOZd+ItXwDOnxhrqznXDwjf5T9JT9NI1KCNZuiZU
         xGWA==
X-Gm-Message-State: AOJu0YzXc2tHlvxhQJbtqd3oiQTVN2blDGploNz3wPBIk03QP7pWT5BC
	fyGyvflgxBTOSd8pjF+st6s13pN88qulsMPn24ua3bGP134ZSWKuyU3EXVTuCqB7SeE=
X-Gm-Gg: ASbGnct+v3rE8KloQD8bWq2/HqEir3GkZ/MKUap7FgmhqXzOGbtlLR4K3xiS3IjSpFi
	VzzSz1tVI0augw8auDOUjek+EKBYL8lT7nCBbA4pAaR/wKN0ahiKBPMuviaNgmyZnpzG0oSPpPa
	cZstyVoi0yPrr/4okV/oZSDd+L8YixNlYnnpsh90/CLX+t3O7UYANbaqBhFlFovTcCtyy+LA3Dx
	or8BNZRPDjrPE2uWHlkvJi+aE33yNmBOrtn3YsS4nxXHMKzNsIu4fYB+EOJSSWWeEsrzZumL2YJ
	FUwvQXrYWh1UtQc8AFFlxS3c6hx3dpWpikl6QUwG/3KK2itMarBVDZazVgr38yqwBOzpmEm6F6V
	amglUcpKUew0nB9Zeg+jXokbKEzxshD85C1pC4Sb5mOD7LN4Qvf9MbHVawPCBpk85Uo7I+3BNep
	EuLpb/7runy+LaSc4o7SUEJrGgelnHp2UZvhAlEXmQPLw7lYCM0T0THdH57kZZHSq1ofsd5eUBN
	fqkWZrSytFNmjHs6cd1FLAmKi0d5xnnNTQGdZZo5HiEIiw=
X-Google-Smtp-Source: AGHT+IGyZRSrIPriVAkxrwWpjdX2v59WmtRbUtCWRXC6mnH85aQ4zlWQ20qucvSZSJHPNXqlLnv9DA==
X-Received: by 2002:a17:907:b17:b0:b76:7e0e:4888 with SMTP id a640c23a62f3a-b767e0e64d2mr1733846966b.6.1764243073408;
        Thu, 27 Nov 2025 03:31:13 -0800 (PST)
Received: from ?IPv6:2003:de:373a:d100:7c9:709f:eaee:b67f? (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b76f59eb401sm131992766b.54.2025.11.27.03.31.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Nov 2025 03:31:13 -0800 (PST)
Message-ID: <793c255dbd79b17a2a3e9e4f781f6efa5fabc622.camel@suse.com>
Subject: Re: [PATCH] Add purge capability to multipath-tools
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Brian Bunker
	 <brian@purestorage.com>
Cc: dm-devel@lists.linux.dev, Krishna Kant <krishna.kant@purestorage.com>
Date: Thu, 27 Nov 2025 12:31:12 +0100
In-Reply-To: <aSS75Rt0f4fFbUUA@redhat.com>
References: <20251113184317.55038-1-brian@purestorage.com>
	 <aSC4YOZjDiIZadJ4@redhat.com>
	 <CAHZQxyLJMZ6VpFFj1D8TLECBrQ7_digxT1BS1Dk68LNqTzV5EQ@mail.gmail.com>
	 <aSS75Rt0f4fFbUUA@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Mon, 2025-11-24 at 15:11 -0500, Benjamin Marzinski wrote:
> On Fri, Nov 21, 2025 at 02:35:23PM -0800, Brian Bunker wrote:
>=20
> >=20
> > I added the purge thread because I didn't want to starve the
> > checker thread at a large disconnect volume scale. I noticed
> > that the number of devices if I purged inline with the check that
> > it didn't scale linearly after a point and seemed to be
> > significantly
> > starving the checker thread. Doing the purge in another thread
> > seemed to relieve that pressure.
>=20
> That might be because the check thread has safeguards to try to avoid
> starving the other threads. Since a lot of multipathd's work is gated
> by
> the vecs lock, there's only so much parallelism that can happen with
> multiple threads. If deleting the devices is taking a long time, it
> might
> be better for this to get interrupted, so that other threads can run.
>=20
> Since purging the paths is fairly low priority, we could continue to
> run
> it in its own thread, but instead of running through all the devices
> at
> once, purgeloop could lock the vecs->lock, handle one device, and
> then
> unlock and loop. This means it would need to search through the list
> from the start each time it regrabbed the lock, since the list could
> have changed while it wasn't holding it. When purgeloop makes it all
> the
> way through the list without finding any paths that are due for a
> delete
> attempt, it can sleep or block waiting for more paths.
>=20
> This would mean that paths would need to remember if they had already
> been handled in a cycle. That could be done by purgeloop keeping
> track
> of which cycle it was on, and the paths storing the cycle number
> whenever they were checked.

As I wrote in my other post, wish that this thread wouldn't hold the
vecs lock at all. multipathd could simply use a pipe to write dev_t's
of to-be-purged paths to the purge thread (or process :-) ).

Martin
