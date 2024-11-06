Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3B01DFDAF
	for <dm-devel@lists.linux.dev>; Wed,  6 Nov 2024 16:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730911984; cv=none; b=Hmnst7tCLJivhsu8zJvB3e/2jwYANA/x/bamjs9wiCws5KA9do6LCC5dkyRBFwDnXFWeJDBQJJFDFi7FSaBvn0BcBSlnbSLKxxTT5oWZX+Y2yv+LK21eo0gO304xByBLoPC45YZ9dFCV6C4hbvIo7t2S+4ufCmJMr5uDarykj1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730911984; c=relaxed/simple;
	bh=3XnVsDVPnHKcFHg9bO7dUfASpLwz+3quZfVI37DhbSE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uoSdUFBkGPcB8CCcETMPv/gAZ79Vi8P4wF0Ka+mo9/NiJcEJAwb68XREI6YLvdl311rftE47ePUMyVpbpmLwaSvwegdS3eyVIzPhsp0AaWTy3VBCkCaJ4krEDQ7nSVw+jhV745Mtk47lGcS+9rRg1qJEQqyzh7KhiU6OO404nGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=TmgmxJWk; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="TmgmxJWk"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a9eb68e0bd1so264967066b.3
        for <dm-devel@lists.linux.dev>; Wed, 06 Nov 2024 08:53:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1730911981; x=1731516781; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3XnVsDVPnHKcFHg9bO7dUfASpLwz+3quZfVI37DhbSE=;
        b=TmgmxJWk3W/VT6y53vrUaqdJmKzRtru0bP84spdkaUVNL6uJqkl7XBBWp/8OCHXnwu
         E54NitlmrCJ1BARmJySZwylowFShwbY9ClNARxChRC65UymKAXPJwG7TH0oe/Ct1LHei
         7WbscJo19txwXY8K1tsBasu9CJ0+gKD9MUCoemE8U/P7LzIn6ZNmpp3CzGnOspB/XyiD
         f+/4DD2SOp+Hu28S2tr7lTNbduXQVxu1KjA+cpVJW7voY9L8Hhf5N60vShJ4gYNj2FnN
         agfyN6/4XpQ9Myn6QNe361eZp/E9u4PBaeCFmm2vLGZ2thjFzRc0zq05G5ts6DWIxtAN
         0ULQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730911981; x=1731516781;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3XnVsDVPnHKcFHg9bO7dUfASpLwz+3quZfVI37DhbSE=;
        b=lxEK81zE2a/Uh5icR/e7dXj/On4R4zKMmDomqUJoRy7IaLuJaywNLf4tzOVUuxLx5H
         Low72yvvlL6sicks0pEs3QDNfz8hWzB+zBuU9z8SobfFkifTkQ69ZoxKJ0FNATUwzKC1
         GxJE2ofACvdpQjrBxOzIRnNI0g/h2zlM4PSUjuslHXGl/3MpVFjnYxF2bl40aFtRG+gv
         esgQJuCVe/w9pE+RYlq2c4rXOjRbQwwIX6C6WKxgVS4cZBCRwHKUefjHcHt5WR4ofqO1
         t7azbz78vf3L+rQB0AjKcMh9zl5fTwsGMnmkSGPkiJbmLAteUHgMPjQ1nbcYZ2yNZy8h
         jz0Q==
X-Gm-Message-State: AOJu0Ywo6HEh+nj1ilEPrOJlqiIRvGmUR2pQI+OqIznvbxTirWkVsXnh
	xPeyldi8X4s0rdK0OhMw7jFc2lotsqJx+u8r35gE9N8yjQcV3j8VQ8pTuSrGEjA=
X-Google-Smtp-Source: AGHT+IEYmDUn9kzRQezDcGhpoyJG1Ghkn1yoPnhkhqxc+wBBQrlnDLT6wdIkNsqBZwRLWsOiEfymGA==
X-Received: by 2002:a17:907:948f:b0:a9e:3af1:eb1b with SMTP id a640c23a62f3a-a9e65506d11mr1822998966b.38.1730911980538;
        Wed, 06 Nov 2024 08:53:00 -0800 (PST)
Received: from ?IPv6:2003:de:3746:4600:ac00:378:25cc:9f2c? (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9eb16d667fsm310202466b.61.2024.11.06.08.53.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2024 08:53:00 -0800 (PST)
Message-ID: <151dbbdc7bfcd4dd0668bf5d9289f725cf92da28.camel@suse.com>
Subject: Re: [PATCH 0/8] multipath fixes to tableless device handling
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>
Date: Wed, 06 Nov 2024 17:52:59 +0100
In-Reply-To: <20241031183301.391416-1-bmarzins@redhat.com>
References: <20241031183301.391416-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Thu, 2024-10-31 at 14:32 -0400, Benjamin Marzinski wrote:
> This patchset include a couple of miscellaneous cleanups, but is
> mostly
> in response to issues brought up in
> https://github.com/opensvc/multipath-tools/issues/100
> It adds auto restarting to the multipathd.service unit file. I'm
> fairly
> conflicted about the correct limits to be placed on these restarts,
> so
> if anyone has strong opinions and a good argument, I'm more than
> willing
> to change them.
>=20
> The bulk of the changes deal with how multipath handles devices
> without
> any table. Multipath was supposed to delete these if they were left
> behind after a failed device creation, but that code was broken.
> However devices aren't typically left behind after failed creates, so
> it
> didn't matter.=C2=A0=20
>=20
> A bigger issue is that multipathd and multipath could fail if
> tableless
> devices were present. With this patchset, they will simply ignore
> tableless devices that don't have a multipath prefixed DM UUID. The
> last
> patch is a RFC patch that changes the behavior for tableless devices
> that do have a multipath prefixed DM UUID. It makes multipath remove
> these devices on the grounds that they are likely failed creates.
> However, looking at the libdevmapper code, I'm not sure that we
> actually
> want to do this.=C2=A0 When a DM_DEVICE_CREATE task is run, it will first
> create a tableless device, and then immediately load the table and
> resume the device. So it's possible any that tableless devices which
> multipath sees are actually in the process of getting created. I left
> the patch as part of the set, but I'm not sure that removing the
> devices
> is the right answer here. I haven't ever seen any tableless multipath
> devices lying around (and I couldn't force any to get created when I
> tried). Unless other people have seen these, then I don't think the
> final patch of this set should go in.
>=20
> Benjamin Marzinski (8):
> =C2=A0 multipathd: print an error when failing to connect to multipathd
> =C2=A0 libmultipath: check DM UUID earlier in libmp_mapinfo__
> =C2=A0 libmultipath: Don't fail dm_get_maps for DMP_NOT_FOUND
> =C2=A0 multipathd.service: restart multipathd on failure
> =C2=A0 libmultipath: use MAPINFO_CHECK_UUID in dm_get_multipath
> =C2=A0 libmultipath: signal multipath UUID device with no table
> =C2=A0 libmultipath: fix removing device after failed creation
> =C2=A0 libmultipath: remove devices with no table and multipath DM UUID
>=20
> =C2=A0libmultipath/devmapper.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 | 56 +++++++++++++++++++++++-------
> --
> =C2=A0libmultipath/devmapper.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 |=C2=A0 6 ++--
> =C2=A0multipathd/multipathd.service.in |=C2=A0 3 ++
> =C2=A0multipathd/uxclnt.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 4 ++-
> =C2=A04 files changed, 51 insertions(+), 18 deletions(-)

For patch 1-6 of this series:=20
Reviewed-by: Martin Wilck <mwilck@suse.com>

