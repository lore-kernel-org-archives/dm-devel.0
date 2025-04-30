Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D317D19048A
	for <dm-devel@lists.linux.dev>; Wed, 30 Apr 2025 07:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745999749; cv=none; b=L7H2sz9hK1jDIjF/wYqxUPg9gmeP6D6f53OZwlbETn5zVHCWbu00L21o3EVQPaOQXYIIuAzssvVdF5jAcil/vegzSujXhLEnU70CTvSQpBCU/4v78pOULiqMVt3WtcUvqrlCdVAiO7VbSnM/hfNw60/opV/L7lGTAetP5/xHUvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745999749; c=relaxed/simple;
	bh=PJGywcZ5fDrimmL9MhHQe2EEqXiYtwSWLlycILUNQYk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=p9hkHzUABxhvrFieQcClxMqkkETso+S4DfKrgtJyTeuEkiLqf/IETLOIIt4dTUDYQeWFIW4AnWMTGU7aRgwJicNkQNzg4ytwfVGL3vd32T4LOkWUOHhJIlynharve/O7qeR4trkQYxZ2/FNt67q7HGAOfn82+ACv8klThTIeKCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=CBZKflXX; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="CBZKflXX"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-39141ffa9fcso8091456f8f.0
        for <dm-devel@lists.linux.dev>; Wed, 30 Apr 2025 00:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1745999745; x=1746604545; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=z1NeGrl/nyErBQ4+euL48lJ4ZDgl5xoiE4RN0Aq3qco=;
        b=CBZKflXXo3/nSPSMHPAyurOD0Q08AM9DEjhd6GNE4GGbwZoWcrOD7Jm+99x88NRgd4
         hj+1NaWiWrDjmAty2EFEMCfjl04Nvolq1AQr6rMe5d54LlYI4LqRt90KrKFqiI8JwWHf
         bKAew/E5pMkm/+cYaQaINVmwrN/+Bw5Cq8+w7cDtb3G4yabkrLN4+fCWUsaTwKN3Rekf
         GUywmsvSC257MuvYwffIHefcAVBcQrKpgs1Nb6ALRCSoFsXHZpc+2/Wts9xi/tBxgr5s
         WLHkmWQYlN401WiY/+n+ps/4GTcL/nqzXdPiZygoCL+kevUMxwakPB0w2SdtcwyScIf/
         gp/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745999745; x=1746604545;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=z1NeGrl/nyErBQ4+euL48lJ4ZDgl5xoiE4RN0Aq3qco=;
        b=PqSWVUTWNJBRIuS7osM4Tzlc/QPHjY5kTen5NE9t/PZQH3EKOpO76HTj7b67giMmMv
         7gkEz64JfricGopM8rvHImI7/kXPrjqqgyzeFVRF2K7+XpJyIBjMQrfwQYnbt/kURlnX
         BzF5NnBt8WgFto1c2c+mYAYbe11rTuVytElK2txtesX9Siew3v1/kmvSeF4ZyFNqJFvr
         ioXeY2wyh0hQxbHhpgCNsM+Wl8AkctTUX2HrfS1UJ9D/D50jm1dCa2FM/ivS65Bnyv1S
         nU2RD1fjU5qA9L9O4Ffh1LsUsPUBeG9YjZxGnBb6ZoSF1h9zqUhpd0R9APsSkjCjBiiO
         GSAA==
X-Forwarded-Encrypted: i=1; AJvYcCXUpo2fWlplXbKAxHjmnFnItCRZNo8ITW26/KiQKqvcDX4WEag6Ug5zfXOnAjYZ4d22rNknlHB/mA==@lists.linux.dev
X-Gm-Message-State: AOJu0YxztBJQ0L80cxbxbeRBlH+nwXB5w2g/Z6PMxXIiM4RJI+ONq8bn
	TRAEXMrsjyQedMrRgS8JN21o3q63CeNXYe/DUjeO69Qt4TyA4JMFvTcadM9xO7i3wVmL2fcE7TM
	W
X-Gm-Gg: ASbGncuOaXAPAHYy0HWDNTS/wud75OJUAfaRll/stN+zFdxCuLNsFwg3CtsrGX3gkFF
	yqbHaGkM9TT8nAMvT5WXQSBCf+PwbSyHJO19ZbkPiHA8tFIzzXnkkbVJolrQgUXXiVHSRC3aKag
	8Ux7aMuijln5Os7BEMQ0dq43eY0XqmpkQXI5yXJoogYBfbkx1VKBhsJ0KOuvl8hZrXYywjpBMzT
	MmvmREshQ2DOpmLUkHocKbU1jPoZvED9l2hYL0np3tzFRkANtQ5StlK6yuuYbOE6O4DXOI+m5nV
	hr9tAmaeK21xAaAxnWw1jMhgo/F3xefr8RffJdLnsz3maqcs3r+TJ8ziT2ZGBfDxaZw54FZ8ocK
	x36W2/6f90uFP2hipckRB8jx6v0yhivdVwntsyTRpBXf7WviyIiN87VXUv172w+CyMi44m9qqGH
	OZFVBm6r6dKw==
X-Google-Smtp-Source: AGHT+IFXTkC+owdkoqfJd2lveImPACBCyYlzpwHQNY4jSSqqZvMekvMAmsscLDHqWRzvMzolDSfh9Q==
X-Received: by 2002:a05:6000:2209:b0:39c:1258:7e18 with SMTP id ffacd0b85a97d-3a08f7a5e72mr2090295f8f.57.1745999744981;
        Wed, 30 Apr 2025 00:55:44 -0700 (PDT)
Received: from ?IPv6:2003:de:3740:fd00:677a:2a06:a366:3993? (p200300de3740fd00677a2a06a3663993.dip0.t-ipconnect.de. [2003:de:3740:fd00:677a:2a06:a366:3993])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a073e46a49sm16373089f8f.61.2025.04.30.00.55.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 00:55:44 -0700 (PDT)
Message-ID: <00c8651c4f589c56b034e7bbe5eb9d59688a1c78.camel@suse.com>
Subject: Coding stye (was Re: [PATCH 1/2] libmutipath: handle blacklisted
 paths on map_discovery)
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, device-mapper
 development <dm-devel@lists.linux.dev>, Xose Vazquez Perez
 <xose.vazquez@gmail.com>
Date: Wed, 30 Apr 2025 09:55:43 +0200
In-Reply-To: <aBE2IX4re8qXv-GG@redhat.com>
References: <20250428214514.1905327-1-bmarzins@redhat.com>
	 <20250428214514.1905327-2-bmarzins@redhat.com>
	 <d277b26e716775ef3778aa47c8a96ea24a551de7.camel@suse.com>
	 <aBE2IX4re8qXv-GG@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Tue, 2025-04-29 at 16:27 -0400, Benjamin Marzinski wrote:
> On Tue, Apr 29, 2025 at 09:59:40PM +0200, Martin Wilck wrote:
> > On Mon, 2025-04-28 at 17:45 -0400, Benjamin Marzinski wrote:
> > > If the multipath configuration is changed to blacklist existing
> > > devices,
> > > and multipathd is reloaded but the blacklisted multipaths device
> > > can't
> > > be removed, multipathd was marking the paths as INIT_PARTIAL,
> > > causing
> > > them to stay in the multipath device, at least until the
> > > partial_retrigger_delay timeout elapsed. Instead, mark them as
> > > INIT_REMOVED and set mpp->need_reload, so the device is reloaded
> > > and
> > > the
> > > paths are removed. To make sure the blacklisted paths are deleted
> > > when
> > > the multipath device is removed in coalesce_maps(), set their pp-
> > > >mpp
> > > to point to map before removing it.
> > >=20
> > > Fixes d9c61332 ("multipathd: trigger uevents for blacklisted
> > > paths in
> > > reconfigure")
> >=20
> > The patch looks good to me, but I only vaguely understand why the
> > bug
> > is introduced in d9c61332. Are you positive that before d9c61332,
> > the
> > hang didn't occur?
>=20
> Well, I'm pretty sure these blacklisted paths stopped getting deleted
> during reconfigure by d9c61332. Before d9c61332, blacklisted paths
> were
> immediately deleted in update_pathvec_from_dm().

Right, thanks.

I've taken the liberty to fix the typo ("libmutipath") and make some
minor coding style adjustments in my queue branch. You can inspect the
result there.

The coding style stuff is work in progress, I've added a clang-format
based workflow on my tip branch.

I'd like to avoid major reformatting of past code while enforcing
consistent formatting for present and future submissions which is more-
or-less in line with what we used to do "sub-conciously" during the
last years. clang-format has a lot of options [1]. I'm still struggling
to find style settings that match ours [2].

Let me know if you dislike this, or if you have suggestions for
improving the settings.

Regards
Martin

[1] https://clang.llvm.org/docs/ClangFormatStyleOptions.html
[2] https://github.com/openSUSE/multipath-tools/blob/refs/heads/tip/.clang-=
format

>  After this change
>=20
> @@ -193,7 +196,8 @@ static void update_pathvec_from_dm(vector
> pathvec, struct multipath *mpp,
> =C2=A0		rc =3D pathinfo(pp, conf,
> =C2=A0		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0
> DI_SYSFS|DI_WWID|DI_BLACKLIST|DI_NOFALLBACK|pathinfo_flags);
> =C2=A0		pthread_cleanup_pop(1);
> -		if (rc !=3D PATHINFO_OK) {
> +		if (rc =3D=3D PATHINFO_FAILED ||
> +		=C2=A0=C2=A0=C2=A0 (rc =3D=3D PATHINFO_SKIPPED && !map_discovery)) {
> =C2=A0		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 condlog(1, "%s: error =
%d in pathinfo,
> discarding path",
> =C2=A0		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 pp->dev, rc);
> =C2=A0		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 vector_del_slot(pgp->p=
aths, j--);
>=20
> they started hanging around, so that uevents could be generated for
> them
> by trigger_paths_udev_change(). However, since coalesce_paths() will
> usually clear pp->mpp, they won't get removed when orphan_paths() is
> later called by remove_maps() to remove the old maps. I admit I
> didn't
> test if the paths got removed before that commit, but the commit
> message
> says that they did.
>=20
> -Ben
>=20
> >=20
> > >=20
> > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> >=20
> > Reviewed-by: Martin Wilck <mwilck@suse.com>
