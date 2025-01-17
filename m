Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E7A1AA1D9
	for <dm-devel@lists.linux.dev>; Fri, 17 Jan 2025 19:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737140681; cv=none; b=XmvqzfgxKyyYbE0jf3Jj8JjmCy9jh7WHqQgL+rqvdJosHXImticZJx6ThABw1yydvkN0JTRfqBN9J+XQ6M0KFTYibx4wRFoDa3zpjeJzfgWpITYU/hTym3RoydY1RnjG0siBMWS5fVMMopzUBqnOc0FF89XbvskJKZ6Ze94ZGac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737140681; c=relaxed/simple;
	bh=k+M8eSPCkFCA9mi5ZNapUr6nueNKv7mP4c7PTVQu0yA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Cdby3M9Ik2oxPEsjLtUJ02QBqiRAyPdOJ4oftzWV76B9MwTTzDmU3k+r11RIklicmoslKBdH0QCrmbECLc0glc3wwxR9Bhx4BsFLL8H1ZeeWmX/tRAuTilDaHG8luc6akxhCaWfEsCihyGJ1WcN7hHvcdX+j3JJrJoQd+3hVY1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZPgqEctW; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZPgqEctW"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-436281c8a38so17042655e9.3
        for <dm-devel@lists.linux.dev>; Fri, 17 Jan 2025 11:04:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1737140677; x=1737745477; darn=lists.linux.dev;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=k+M8eSPCkFCA9mi5ZNapUr6nueNKv7mP4c7PTVQu0yA=;
        b=ZPgqEctWZC5tc7fFYg4E2e2HW5XBd1N38GWtKL91MvejBiO5p9t+JbjER7HpoClhss
         V6iY595bBDNgGMMoIuRGzUFZQ5naec1JLyCacPIhfIRlpk3Vz6faPI1N0yLEWF7+/krk
         6rXDR2MWGKZW9cwIDF7ST8PcPB0CDyXGFnOxT82WM36oMgb+OAbWIjh1IPK0SRw3BSdL
         VViS63hz/g5cd5nGaDNjj0Xqqgq5gWaT8bJWrJVU5odpz09FBfApKKhbB+ZbeQ+M0sU2
         UB8lFxtgsfAvgnPcP7lsmj2mW3wqXdHEUO4vIYQKv5aVZk4YRSx+1EhuceXWppNy0r0M
         NGfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737140677; x=1737745477;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=k+M8eSPCkFCA9mi5ZNapUr6nueNKv7mP4c7PTVQu0yA=;
        b=K4FTX2yTrrZo14Yf2dnRJpJoifNot9wcIdsce5kBHnjehPsduvtYjiYsu47XdrotiM
         5c1q45Ud2JDros2LbJyz0heu3h9EUWmOeAzvZxpGWiXz/ObB4X2S0ljHM55rjRACKDFv
         q2b8/HYvNCFWJ0QIRP3hLXlSvnNm9KZFTL3UVJ0bWkOdYtabo88rape0Bz8IhieX6Zyq
         M7EP+gB6y5LeFFuHO3iKoOqtbKhrbyzaInlZC0n5xsx4e9D5fiB0Zr7QPkISFEzzSVrq
         0Jjyd+4T9V/GTyE+RLhe9tIjH8XX/mcIV1WpEHEL7wH8uoWNfC2MVVwkGVzpHaDnvYIm
         r0EA==
X-Forwarded-Encrypted: i=1; AJvYcCWC5mLS+t77ryGE/XNg3G2L+2BWspm8ITN471+8LA3CQE8tUbDZ2fvq8QU9eeAvV43x7AQoAZS3Eg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw5ZvhNTWOvoOqh5Oy1iPXDp2OdXMR6onKJvckdf57BTWLUMR58
	5k4/uUXcO+fCCR20riZH+FPOlBEJVX6+CvmKumEef7WmQELQx3vnblXA4yI8GHg=
X-Gm-Gg: ASbGncu/xtaiAipD8KvsNXx5pCAJ9LES/EoC1JK2hCQVcBqYOXz6leykTGGXITUNTWJ
	RHvoBt9qCIC7e9aSbUZdhk5AHCBVy4lyrZkOZFS7BRdMfIwGatUdrfDh+Q86N6D7MsZ3TOJ8p0w
	tPUiSgUT2UVISu2LAOOpZN2UOwYsv2cD7HoFSYlEhAd+/pNtE2PV/sNmCwxDsZtUl+zEe2OjVn7
	8h2O97eCU276ueXAPbpXBf5A9p7Rftc14yhfQmVm6+ndgbziIZO9vgbFzAc+vER8V/7ScUdMIoG
	CBm8JYM7hd0cS3XdAqr7RBJg+LBEbXE9bfBMRs4/uhaD9Z3yDbkj4+dGu4podnCAX3DR5XCIQDZ
	KmpciaOjMUhar
X-Google-Smtp-Source: AGHT+IGoAErhktQNv0M6osBWpcUzCcRWIGu/yeCrHetCUgtlm5VJ3mzTZushq/OVDZ+/5QOZAwmocA==
X-Received: by 2002:a5d:6c63:0:b0:385:fdc2:1808 with SMTP id ffacd0b85a97d-38bf57a65b6mr4346248f8f.40.1737140676428;
        Fri, 17 Jan 2025 11:04:36 -0800 (PST)
Received: from ?IPv6:2003:de:3746:4600:ac00:378:25cc:9f2c? (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38bf32222d1sm3227051f8f.38.2025.01.17.11.04.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2025 11:04:35 -0800 (PST)
Message-ID: <2ffbb28882f4399000269e5c3c74639776b033d7.camel@suse.com>
Subject: Re: [PATCH v2 03/14] multipathd: sync maps at end of checkerloop
From: Martin Wilck <martin.wilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, 
	dm-devel@lists.linux.dev
Date: Fri, 17 Jan 2025 20:04:34 +0100
In-Reply-To: <Z2SVH8f7z72SV6n5@redhat.com>
References: <20241211225909.298770-1-mwilck@suse.com>
	 <20241211225909.298770-4-mwilck@suse.com> <Z2SVH8f7z72SV6n5@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Thu, 2024-12-19 at 16:50 -0500, Benjamin Marzinski wrote:
> On Wed, Dec 11, 2024 at 11:58:58PM +0100, Martin Wilck wrote:
> > Rather than calling sync_mpp early in the checkerloop and tracking
> > map synchronization with synced_count, call sync_mpp() in the
> > CHECKER_FINISHED
> > state, if either at least one path of the map has been checked in
> > the current
> > iteration, or the sync tick has expired. This avoids potentially
> > deleting
> > paths from the pathvec through the do_sync_mpp() ->
> > update_multipath_strings()
> > -> sync_paths -> check_removed_paths() call chain while we're
> > iterating over
> > the pathvec. Also, the time gap between obtaining path states and
> > syncing
> > the state with the kernel is smaller this way.
> >=20
>=20
> Sorry for the delayed review. I've been busy lately and there was a
> lot
> to look at with moving the syncs from before we check the paths till
> the
> end. Turns out I'm mostly o.k. with this. Syncing right before we
> checked the paths still left a small window where things could change
> in
> the kernel state, and we wouldn't see them before we checked the
> paths.
> It's just a larger window now.
>=20
> The one place where we won't just pick up the change on the next
> checker
> loop is enable_group(). If the kernel disables a pathgroup,
> multipathd
> would re-enable it if a path in it switched states to PATH_UP. I'm
> not
> totally sure how necessary this is. The kenel has code to re-enable
> the
> pathgroups. But it's been there a while, and perhaps it does avoid an
> issue.
>=20
> The kernel doesn't even necessarily send an event if it disables a
> pathgroup (since the pathgroup isn't actually disabled, it's just
> bypassed, which means all the other pathgroups are checked first).=C2=A0
> So
> there is a real chance that since the last path check, the pgp-
> >status
> could have changed. By not checking before we check the path, we
> could
> not realize that tht pgp is in PGSTATE_DISABLED when a path switches
> states to PATH_UP.=C2=A0 It shouldn't be that hard to check in sync_mpp()
> if
> there are any disabled path_groups the include a path where
> pp->is_checked =3D=3D CHECK_PATH_NEW_UP. So we could move the
> enable_group()
> code to checker_finished() as well and fix this.

Right. I'll add a patch on top of the series. Thanks for spotting this.

Martin

