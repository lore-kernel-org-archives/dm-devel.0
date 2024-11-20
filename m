Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72AB51779BB
	for <dm-devel@lists.linux.dev>; Wed, 20 Nov 2024 08:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732092563; cv=none; b=qptKlSqvzH+ulRinbDYsdAoSwqvPQtl8mITtZ4kI5TWzeBFotY+QOLHGvlFFMIgnE2yo412L73ktysGqZ9RVRfS6kt4HT6DXEoo6L9nlkM7xaRSpCxQJdFkgoyQnErYs0A593ly/YaVNE26lfZ8lR6GL4HrGklHaDrMFlC8qoPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732092563; c=relaxed/simple;
	bh=sRCDMxZhmSxeApATVnvfwfAzLHZtkDjQMjr9MwHIxwI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fhe0I2ZDjCLCEBFJMzF4jKWVUDXgPalAG2EOle6KNf92sG8vfMIQFJTDfSIfXdyCps0hT2EAibb+y7qi4dxKziUmitwtSxXIHGdCf3VRZCoS4XcShydJfnBTBGCKC333QJoigniX55lSaJ2i+ayumysWAosGoFRF6wim2ItzKFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=DYB6SLks; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DYB6SLks"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-43152b79d25so44499765e9.1
        for <dm-devel@lists.linux.dev>; Wed, 20 Nov 2024 00:49:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1732092560; x=1732697360; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=sRCDMxZhmSxeApATVnvfwfAzLHZtkDjQMjr9MwHIxwI=;
        b=DYB6SLks2GvvCojvgCAMT3kK/dcZsW25cjhV+CkgE0A5brZn7FGy+dflJyfDMh7VM4
         vMfLSu/adq+2PP2v1zlLp7Z4FX7/M62h4YNeEGvu8n6I7pdSzxu+UJLkdRKiquN0dqdH
         M92iPwemJBdll3GeiZdix2tXY7P7C8XFbUq/3eD6iAJt47xs8JmCCWGm1TOTcH/rypY1
         QC0EEdvF1lTtESjuAAlY/e0OT4pEuIQZAqbLRKJtXrPMxpZO2Jn4tTkaXe5IIT6yOLJL
         jUObwcy+3LtNVjriUyBnbRBSDX41vNs+CiXhBGHY+shrwbgHKsLKxVOu9jH/USG3cRrQ
         cjTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732092560; x=1732697360;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sRCDMxZhmSxeApATVnvfwfAzLHZtkDjQMjr9MwHIxwI=;
        b=bYuTKcRcuRetyJ2QprQtOHWgpH8taa+kDfm5JQRH3sVoVKuLiDzY+Pcf1iH78FPtIB
         8+/h3tlFMNxT1k7V1ya+jo1h4mBta2BTkqVGtPLd+S45b3Ohzdm0Za+Ujtk+HT1M2bri
         mD16DsvsrToVOP8H/deLqqOxTW0wBHuJtTcedJLg3RN+3dzzj8wed8wDQTIw6XJECV6R
         Ns4qvSTXhyVcskBCzDNklPNK1SI5Ho8eN+ZRjS9U815yP6gOlVZTmekPvbmV1RkI9+bj
         j6BI/PR8Bu3SPADlVXvWX4NRuj4hZ5Z34spEQASaYrgHlEtUi/INg7ydi1KdQYrBO7Gf
         NJlw==
X-Forwarded-Encrypted: i=1; AJvYcCW3e2Jj9fKqCXzjtrf/RUIYzy6sSmb8trL6AzNZ1vH0qXhmyzTje6OkwIZjgErNdKENmmqSj3Q/Hg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw1aSelzDOL4ypoTU18Nd8z93QD83+em5qw01N6+I4begTyOyO/
	D4qTHxCihfHgln+UfC5VvmvaaGfT9nZiE0tYOizakmf/qH1YoZ4zuJM4B6aHvAQ=
X-Google-Smtp-Source: AGHT+IH9fZapEdKmvveiyAeTPhsDTmq/4SMdEWhbGv2OCoRiuIv+lqeVyasAnq+cMf3mP0UxM8xPig==
X-Received: by 2002:a05:600c:4713:b0:431:51e5:22fb with SMTP id 5b1f17b1804b1-433489b2d49mr17337635e9.14.1732092559441;
        Wed, 20 Nov 2024 00:49:19 -0800 (PST)
Received: from ?IPv6:2003:de:3746:4600:ac00:378:25cc:9f2c? (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-433b46021e6sm11301055e9.17.2024.11.20.00.49.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2024 00:49:18 -0800 (PST)
Message-ID: <b74031fd331a5825b45d4c44a5567cc7d5d96bbf.camel@suse.com>
Subject: Re: [PATCH 1/6] libmultipath: signal device with no table in
 libmp_mapinfo
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper
 development <dm-devel@lists.linux.dev>
Date: Wed, 20 Nov 2024 09:49:17 +0100
In-Reply-To: <Zzz2E-UC1m8rezOH@redhat.com>
References: <20241115232256.627933-1-bmarzins@redhat.com>
	 <20241115232256.627933-2-bmarzins@redhat.com>
	 <8f74ed950515b775def323b2d04fb5092ad615de.camel@suse.com>
	 <Zzz2E-UC1m8rezOH@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Tue, 2024-11-19 at 15:33 -0500, Benjamin Marzinski wrote:
> On Tue, Nov 19, 2024 at 05:39:26PM +0100, Martin Wilck wrote:
> > On Fri, 2024-11-15 at 18:22 -0500, Benjamin Marzinski wrote:
> > > if libmp_mapinfo() is run on a device that has no active table,
> > > it will now return with a new exit code, DMP_EMPTY, to signal
> > > this.
> > > Currently all code paths treat this identically to DMP_NOT_FOUND.
> > >=20
> > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> >=20
> > I just looked through the code again. I think with this change, we
> > need
> > to modify dm_flush_map__() and do_foreach_partmaps(). They should
> > remove / act on empty maps. What do you think?
>=20
> I'm not sure that we need to add extra code to handle the possiblity
> that an empty device could appear at any time, since like I said,
> this is a corner case that I've never actually seen in the wild. So
> if
> a device was previously a valid multipath device, I don't think we
> need
> to worry about the possibility that it suddenly became empty.=20
>=20
> But I can see the value in running something like
>=20
> # multipath -F
>=20
> and having it clean up any empty multipath devices. As for
> do_foreach_partmaps(), are you thinking about cleaning up empty
> partition devices or non-empty partition devices on top of empty
> multipath devices?
>=20
> Non-empty partition devices on top of empty multipath devices would
> imply that a multipath device was valid at one point, and then became
> empty, which I don't see an easy way of happening.
>=20
> The problem with empty partition devices is that partition devices
> are
> created by kpartx completely asynchronously to us. That empty
> partition
> device could be in the process of being created.

Right, but multipathd is in the process of deleting the map. If there's
actually a race and kpartx finishes creating the partition map,
multipathd will fail to remove the multipath map. The likely outcome
will be a multipath map with just one partition device. If multipathd
comes first, kpartx will fail, but there's a good chance that
multipathd will succeed in flushing the multipath map, so we'll end up
with a consistent state.

If kpartx had run a little earlier and had finished setting up the map,
multipathd would have removed it, and if kpartx had run a little later,
it would have failed because of a missing target.

> So I'm not against checking for DMP_EMPTY in dm_flush_map__() and
> removing the empty device if its opencount is 0. But I'd rather not
> try messing with partmaps. Do you have a specific case you are
> worried
> about?

From the argument above, I'd say that flushing empty partition maps is
the right thing to do, for consistency reasons.

But now I may be overlooking something.

Martin

