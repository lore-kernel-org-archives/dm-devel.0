Received: from mail-43167.protonmail.ch (mail-43167.protonmail.ch [185.70.43.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA975350A17
	for <dm-devel@lists.linux.dev>; Wed,  7 Jan 2026 16:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.167
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767805054; cv=none; b=Xcrmi/z0EtDJvXDMtehYSGZmJHx2W11rtscA+/fIWR6OmWDReCT72FI+RttFbfnvLLu1/vsTh/HO7+aH+vC3eLKSBq2iNhEcfTnXC9VvmYt2oaWYKpgN8W4jMq7IyOzGuqc/pm2ce4SEwLpRYcG9DqxDG5F8eLQiGeHZz3CFjzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767805054; c=relaxed/simple;
	bh=R06/wB74wV7O0wa3PEUJ6x/UEU4HQIPtvQnm85Q3nf0=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QF6erdmNklhlYBJhHEwputrnJhD21kW+PyqnfIPhZV4nd12GTRbBRr1AN4+SG9gsliJP6iwq5ez31qhmGXLeNd0lAwKpbQ6a3Zt/PIqBHD+sjnO7n+iXYX/N+TFtlDfEJ2pPOMthO8Q3YGCxzgDJ6yF9s3hrtJ10p9Ia/hpMv7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=d86Zi/Ro; arc=none smtp.client-ip=185.70.43.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="d86Zi/Ro"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1767805042; x=1768064242;
	bh=R06/wB74wV7O0wa3PEUJ6x/UEU4HQIPtvQnm85Q3nf0=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=d86Zi/Rok6eh0CXEI8d63SNuQYONuXSPx8Ioq8dPLCEu3ftpj1ZRkrXlWKtq0CN8u
	 1LLEHT8tUhGB0LTTFJFqebLkggDRSeGsb97P7eix12Porn6ZH9FmhTXk52QIfveMvY
	 3IWClflAadfX8Wkxiol0rJeOQlbj0awotHeSmhBgDuOHo+fX+Y8QBllSbnB7d/nefQ
	 KXrmYKFXvLaPQXopyl7D4FoXoOOMA3p+0WJovgy5lpfiIuMmm/4NMyQIRV/p4Ah17E
	 Au2t4sKzWXDJnDWYFWDndqqXdeUIhr89CwwPxvjMdRWoFFX3INL3fDPNLv1mhweAvb
	 ROaksWxiFE+VQ==
Date: Wed, 07 Jan 2026 16:57:19 +0000
To: Martin Wilck <mwilck@suse.com>
From: vad.sol@proton.me
Cc: dm-devel@lists.linux.dev, Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH] libmultipath: Remove the undefined symbol from the linker script
Message-ID: <xj5_fRorsKLqis5Q4dj0PzEMvP31tbxEUexvxS2wjUmBXELFSXNHNihZFNR-Y6g0BlViGu7h2VLOqw-Nmz3FR5avpezbxEqiURZuHBXXw4Q=@proton.me>
In-Reply-To: <230b090c5fa6b144f57c4d1bfc8dc5c7282b3e00.camel@suse.com>
References: <20260107120938.28215-2-vad.sol@proton.me> <230b090c5fa6b144f57c4d1bfc8dc5c7282b3e00.camel@suse.com>
Feedback-ID: 154827606:user:proton
X-Pm-Message-ID: e80238e8d77383a9d07d440e271bc646ee3adc0b
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wednesday, January 7th, 2026 at 12:21 PM, Martin Wilck <mwilck@suse.com>=
 wrote:
>
> On Wed, 2026-01-07 at 12:09 +0000, Michal Rostecki wrote:
>=20
> > dm_get_multipath() is a static function, not a symbol that can be
> > exported. Clang is strict about not allowing undefined symbols in
> > linker
> > scripts and therefore its presence prevents clang from building
> > libmultipath.
> >=20
> > Fixes: https://github.com/opensvc/multipath-tools/issues/132
> > Fixes: bf3a4ad ("libmultipath: simplify dm_get_maps()")
> > Signed-off-by: Michal Rostecki vad.sol@proton.me
>=20
>=20
> Thanks!
>=20
> Reviewed-by: Martin Wilck mwilck@suse.com
>=20
>=20
> Yet I'm wondering which compiler version you use, or if you use any
> non-standard compilation options. Our CI compiles multipath-tools with
> MANY different versions of clang, but never encountered this problem.

I'm glad you asked - after reading your email I tried using different
linkers and it looks like it's a linker error and it's thrown only by
lld. lld enabled --no-undefined-version as a default option.[0] Choice
of a compiler (gcc, clang) shouldn't matter.

I'm using clang 21.1.7 on Gentoo on musl-llvm profile, which uses full
LLVM toolchain (clang + compiler-rt + libunwind + lld, also in 21.1.7
version) system-wide, so that's why I've seen the error without
providing any additional flags.

From what I see, no other linker enables that by default and I've been
able to build the current master without errors with bfd and mold:

$ make LDFLAGS=3D"-fuse-ld=3Dbfd"
$ make LDFLAGS=3D"-fuse-ld=3Dmold"

One can reproduce the error on any system by specifying lld explicitly:

$ make LDFLAGS=3D"-fuse-ld=3Dlld"

Or by passing --no-undefined-version (and making the warning fatal),
which throws an error wyth any linker:

$ make LDFLAGS=3D"-fuse-ld=3Dmold -Wl,--no-undefined-version -Wl,--fatal-wa=
rnings".=20

I will send v2 with a more accurate commit message.

[0] https://reviews.llvm.org/D135402

> Martin
>=20
> > ---
> > libmultipath/libmultipath.version | 1 -
> > 1 file changed, 1 deletion(-)
> >=20
> > diff --git a/libmultipath/libmultipath.version
> > b/libmultipath/libmultipath.version
> > index 89ae2a3c..5017a54d 100644
> > --- a/libmultipath/libmultipath.version
> > +++ b/libmultipath/libmultipath.version
> > @@ -85,7 +85,6 @@ global:
> > dm_geteventnr;
> > dm_get_major_minor;
> > dm_get_maps;
> > - dm_get_multipath;
> > dm_is_mpath;
> > dm_mapname;
> > dm_prereq;
