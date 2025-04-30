Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD041D5CD7
	for <dm-devel@lists.linux.dev>; Wed, 30 Apr 2025 19:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746040158; cv=none; b=NgQ915u9tNvIQ08UDl8IKw6erwsJTzuqEZolgnU1Qv7fgVlOOGHRAHrl13+LeZlPklSHyklcsPuSwaijPuRjCFKFQL6ROXwOCIKj48PgLXrrdoP1qUvJ9GCC0lW9wKNzJ/tsqcBUUlKfJvfN/dPrt50Yka1y05alqJlSFm/Klq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746040158; c=relaxed/simple;
	bh=KvxZHu46uBpHJbcvSOOjNzLKh/aWZRjUZFG3AH+ox9s=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HYYijH0kn/iSapek49Nd0aNioZWYSLApgRBVLpqP/eDyn4znHjE6BDLecW3BnK5CfVj5X1+4xLlighZtgbGN8WPkQk6dEHdVvnk5+KzW//+aegRdH/6WKvYbaEhClpAs5VcUt2S+8YEnDYF2gRc1R491j9xFg5og28NggUR8phI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=IRmjagjf; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IRmjagjf"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-43edecbfb94so1190705e9.1
        for <dm-devel@lists.linux.dev>; Wed, 30 Apr 2025 12:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1746040154; x=1746644954; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KvxZHu46uBpHJbcvSOOjNzLKh/aWZRjUZFG3AH+ox9s=;
        b=IRmjagjfZqs2c9NDyGIgT1zDTojGOz9ERoCL9D3/YGFYvnIPyO6qYrkjxmwTlfeNJq
         fKQff7A1XtyI12QXZWTUHPBSOULaHjgtFvJjCN+/Tc+H6RkgVu9LgRQdZaWDKvNDS9GA
         YNpYYGjHqgyhk+A5hdluVfpToK8pAg8RG0HxsOWzIE8IeCmGOMvNmIOrBhyQ930wFz3F
         p+DZiJrnS6wPjZ3iEx1DXDuA+6LAU3Gg9nDPxqzGGHfg+7eA/eE1iR1m1GRvfE2qaOZQ
         ciNkN1PtzWuzIU+rtCHZ/VgnJs++tcQhCDzMUVIXnpwoy4VwM+93K0tAePFf0zotdNQf
         bw7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746040154; x=1746644954;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KvxZHu46uBpHJbcvSOOjNzLKh/aWZRjUZFG3AH+ox9s=;
        b=UOgG8alX0hgmYuSjYBxqYAC6Bsnl8FvsFrg1cwzO0L6Ns7mlEukENNNVacQ6OzNGPy
         RXTVgObcdACUejplGdFUQdWXHB1xfOQPH0IvdhwtN9qbPK2vb8XLwq5hJsinIe8lCxBB
         /h2NFxyvJLAv3NnhjBiaqrZUy6ZR6nmEkFdZ/+JMTBUiLPPyNh3dWfOywVv2ZorLloI1
         SkAa3Wzv4NFtzol0loLKQIqEsyrZT7KznZpC/J3OeqTWwZFH1KCeTLZJVid+jmnqQv1Y
         WC/My6uH/nPGpXos40HBiXS82zuGfw/usEK9c4NLORqTf34Ttw3n8+iQ3wm1jV9gnK2m
         X2JA==
X-Forwarded-Encrypted: i=1; AJvYcCUxfY8qZ3B6ooeWCg+QbWRvttftCnT1cL4ZDDl/A9NyIcCsxISm11mZBopO+68Kirj1o9by9uConw==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz7rlPnZG//r8Y0N4VkE5wF9itaNl6tCR+HIHGAktEXRE9uKJIA
	9M4lrG2zKSDrScODmI/NbyJxX9f62AAEueshu5jA4k9WnxNoAqlsJk126gvsHuCQ2P34PnWc3Le
	A
X-Gm-Gg: ASbGncsG5sl+urUp9xB6movQjURHzV2IK/oXuxtuaYnNpOscRq5wb8xCE21SZxZXnt/
	zmevKthiq/rUsiWIPDtDYSMP25BCK5kknhCk93natsvvduggtUxMTU4m15SihYKCzPzyU2btzRQ
	AqlaIe7UaCQQkz4nZl6/YJXh37HlV8h1i6m+iFhUD9w3nWfDEkowAKvo8txaZTw4JEQOA3nfJeq
	CWIYM5MzvV5AzFw/thAMDUZuc4bOvTrdD4wPqojfz4+AjDkApPjJLRp/N6NBTnCfDsK/Dt5feZE
	Wq21uMLQQpj6NQ5TajUKwdpHSngDqJTrj90ox8rBEJS32/UcIn1XV4WAwvF+k8ezVOUPKKtHjEF
	9fuH88MnmqkLEenxjTAO9Sey1txbeHp2QwQD3grKuGSIML2rBiLD83p4HwVQaTEfOJYiO+QWjCF
	U=
X-Google-Smtp-Source: AGHT+IF53SKOKO7AGx6dmitqenRBee3EnOsmgcANE1Z6umtire/2fnT5GGy3DQeiLZrEc2le/I2x4w==
X-Received: by 2002:a05:600c:c04f:b0:43d:2313:7b54 with SMTP id 5b1f17b1804b1-441b249af77mr31522285e9.3.1746040153812;
        Wed, 30 Apr 2025 12:09:13 -0700 (PDT)
Received: from ?IPv6:2003:de:3740:fd00:677a:2a06:a366:3993? (p200300de3740fd00677a2a06a3663993.dip0.t-ipconnect.de. [2003:de:3740:fd00:677a:2a06:a366:3993])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-441b2b97288sm35050595e9.6.2025.04.30.12.09.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 12:09:13 -0700 (PDT)
Message-ID: <61d7afaac05f4121ba7988459bd80498737c2d4d.camel@suse.com>
Subject: Re: Coding stye (was Re: [PATCH 1/2] libmutipath: handle
 blacklisted paths on map_discovery)
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper
 development <dm-devel@lists.linux.dev>, Xose Vazquez Perez
 <xose.vazquez@gmail.com>
Date: Wed, 30 Apr 2025 21:09:11 +0200
In-Reply-To: <aBJAQwhaIq2Seaob@redhat.com>
References: <20250428214514.1905327-1-bmarzins@redhat.com>
	 <20250428214514.1905327-2-bmarzins@redhat.com>
	 <d277b26e716775ef3778aa47c8a96ea24a551de7.camel@suse.com>
	 <aBE2IX4re8qXv-GG@redhat.com>
	 <00c8651c4f589c56b034e7bbe5eb9d59688a1c78.camel@suse.com>
	 <aBJAQwhaIq2Seaob@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Wed, 2025-04-30 at 11:22 -0400, Benjamin Marzinski wrote:
> On Wed, Apr 30, 2025 at 09:55:43AM +0200, Martin Wilck wrote:
> > On Tue, 2025-04-29 at 16:27 -0400, Benjamin Marzinski wrote:
> > > On Tue, Apr 29, 2025 at 09:59:40PM +0200, Martin Wilck wrote:
> > > > On Mon, 2025-04-28 at 17:45 -0400, Benjamin Marzinski wrote:
> > > > > If the multipath configuration is changed to blacklist
> > > > > existing
> > > > > devices,
> > > > > and multipathd is reloaded but the blacklisted multipaths
> > > > > device
> > > > > can't
> > > > > be removed, multipathd was marking the paths as INIT_PARTIAL,
> > > > > causing
> > > > > them to stay in the multipath device, at least until the
> > > > > partial_retrigger_delay timeout elapsed. Instead, mark them
> > > > > as
> > > > > INIT_REMOVED and set mpp->need_reload, so the device is
> > > > > reloaded
> > > > > and
> > > > > the
> > > > > paths are removed. To make sure the blacklisted paths are
> > > > > deleted
> > > > > when
> > > > > the multipath device is removed in coalesce_maps(), set their
> > > > > pp-
> > > > > > mpp
> > > > > to point to map before removing it.
> > > > >=20
> > > > > Fixes d9c61332 ("multipathd: trigger uevents for blacklisted
> > > > > paths in
> > > > > reconfigure")
> > > >=20
> > > > The patch looks good to me, but I only vaguely understand why
> > > > the
> > > > bug
> > > > is introduced in d9c61332. Are you positive that before
> > > > d9c61332,
> > > > the
> > > > hang didn't occur?
> > >=20
> > > Well, I'm pretty sure these blacklisted paths stopped getting
> > > deleted
> > > during reconfigure by d9c61332. Before d9c61332, blacklisted
> > > paths
> > > were
> > > immediately deleted in update_pathvec_from_dm().
> >=20
> > Right, thanks.
> >=20
> > I've taken the liberty to fix the typo ("libmutipath") and make
> > some
> > minor coding style adjustments in my queue branch. You can inspect
> > the
> > result there.
> >=20
> > The coding style stuff is work in progress, I've added a clang-
> > format
> > based workflow on my tip branch.
> >=20
> > I'd like to avoid major reformatting of past code while enforcing
> > consistent formatting for present and future submissions which is
> > more-
> > or-less in line with what we used to do "sub-conciously" during the
> > last years. clang-format has a lot of options [1]. I'm still
> > struggling
> > to find style settings that match ours [2].
> >=20
> > Let me know if you dislike this, or if you have suggestions for
> > improving the settings.
>=20
> I'm fine with your changes and with using clang-format in general.
> And I
> do prefer just formatting our new changes, like you mentioned in your
> tip commit, but if someone wants to make the case for a mass
> reformat,
> I'm willing to consider it.=20

Ok, let's try it then. If it becomes too annoying we can disable the
workflow any time.

Martin
