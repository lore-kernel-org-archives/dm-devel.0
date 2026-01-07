Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E7B3A1A34
	for <dm-devel@lists.linux.dev>; Wed,  7 Jan 2026 17:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767807286; cv=none; b=ecQJuA5BZ8jhhYkB/nFkaCntmZizKY1f1YE5VwjQfw6yiFOtpZSECXYjWc2WnOwJTUnDvZdAqGUuRYIyN4PvivG4JO9jffxQmKvmrzIn1XphXgnqpX5TX609NDd9e9w21jGNetiEZbYrAw61bdmoM6StigjxkDgxl/A93LIdNMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767807286; c=relaxed/simple;
	bh=RRX1vIKF/NyMmvKt0EnHuzGw+wxxx4V90PqJSdwB2wA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OJcRovBnYZD3KGUVWvVRy1WIINBiZP6/EbT2W8YbfoFOukOzj0V5YNHcxAESfAWef+LmI/um8vaaATMoN6D3TeCdku24pHNa5pXbkzk/7iOFXdbBULHYOMUoeIR13A4urlbMn32PZxIo7Q0zNoAQ39jSl+pXGZUSVwpxCIgmec4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=g+HKeNg1; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=g+HKeNg1; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="g+HKeNg1";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="g+HKeNg1"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9C09F5BCD3;
	Wed,  7 Jan 2026 17:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1767807282; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RRX1vIKF/NyMmvKt0EnHuzGw+wxxx4V90PqJSdwB2wA=;
	b=g+HKeNg1oaO197wUv8z0DVrW29iYfnwepSYCRH5QFbFmb3FBeQKzkZ6QrbDxxUk9aGfPKb
	rDNzJmOrjKck6Y19ycvb6ZhxaTD1458CwUJBh3eV/mYHOooqtlA4Iz/fkaVkTq/qILOZs4
	nDavVPeVfcunYwt2wD/186KpaTuJ8Mc=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1767807282; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RRX1vIKF/NyMmvKt0EnHuzGw+wxxx4V90PqJSdwB2wA=;
	b=g+HKeNg1oaO197wUv8z0DVrW29iYfnwepSYCRH5QFbFmb3FBeQKzkZ6QrbDxxUk9aGfPKb
	rDNzJmOrjKck6Y19ycvb6ZhxaTD1458CwUJBh3eV/mYHOooqtlA4Iz/fkaVkTq/qILOZs4
	nDavVPeVfcunYwt2wD/186KpaTuJ8Mc=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 814CD3EA63;
	Wed,  7 Jan 2026 17:34:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jI1/HjKZXmmCfAAAD6G6ig
	(envelope-from <mwilck@suse.com>); Wed, 07 Jan 2026 17:34:42 +0000
Message-ID: <207e1101fea1de97cbba48e6effd916116c86478.camel@suse.com>
Subject: Re: [PATCH] libmultipath: Remove the undefined symbol from the
 linker script
From: Martin Wilck <mwilck@suse.com>
To: vad.sol@proton.me
Cc: dm-devel@lists.linux.dev, Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed, 07 Jan 2026 18:34:42 +0100
In-Reply-To: <xj5_fRorsKLqis5Q4dj0PzEMvP31tbxEUexvxS2wjUmBXELFSXNHNihZFNR-Y6g0BlViGu7h2VLOqw-Nmz3FR5avpezbxEqiURZuHBXXw4Q=@proton.me>
References: <20260107120938.28215-2-vad.sol@proton.me>
	 <230b090c5fa6b144f57c4d1bfc8dc5c7282b3e00.camel@suse.com>
	 <xj5_fRorsKLqis5Q4dj0PzEMvP31tbxEUexvxS2wjUmBXELFSXNHNihZFNR-Y6g0BlViGu7h2VLOqw-Nmz3FR5avpezbxEqiURZuHBXXw4Q=@proton.me>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spamd-Result: default: False [-4.29 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.19)[-0.947];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -4.29

On Wed, 2026-01-07 at 16:57 +0000, vad.sol@proton.me wrote:
> On Wednesday, January 7th, 2026 at 12:21 PM, Martin Wilck
> <mwilck@suse.com> wrote:
> >=20
> > On Wed, 2026-01-07 at 12:09 +0000, Michal Rostecki wrote:
> >=20
> > > dm_get_multipath() is a static function, not a symbol that can be
> > > exported. Clang is strict about not allowing undefined symbols in
> > > linker
> > > scripts and therefore its presence prevents clang from building
> > > libmultipath.
> > >=20
> > > Fixes: https://github.com/opensvc/multipath-tools/issues/132
> > > Fixes: bf3a4ad ("libmultipath: simplify dm_get_maps()")
> > > Signed-off-by: Michal Rostecki vad.sol@proton.me
> >=20
> >=20
> > Thanks!
> >=20
> > Reviewed-by: Martin Wilck mwilck@suse.com
> >=20
> >=20
> > Yet I'm wondering which compiler version you use, or if you use any
> > non-standard compilation options. Our CI compiles multipath-tools
> > with
> > MANY different versions of clang, but never encountered this
> > problem.
>=20
> I'm glad you asked - after reading your email I tried using different
> linkers and it looks like it's a linker error and it's thrown only by
> lld. lld enabled --no-undefined-version as a default option.[0]
> Choice
> of a compiler (gcc, clang) shouldn't matter.
>=20
> I'm using clang 21.1.7 on Gentoo on musl-llvm profile, which uses
> full
> LLVM toolchain (clang + compiler-rt + libunwind + lld, also in 21.1.7
> version) system-wide, so that's why I've seen the error without
> providing any additional flags.
>=20
> From what I see, no other linker enables that by default and I've
> been
> able to build the current master without errors with bfd and mold:
>=20
> $ make LDFLAGS=3D"-fuse-ld=3Dbfd"
> $ make LDFLAGS=3D"-fuse-ld=3Dmold"
>=20
> One can reproduce the error on any system by specifying lld
> explicitly:
>=20
> $ make LDFLAGS=3D"-fuse-ld=3Dlld"
>=20
> Or by passing --no-undefined-version (and making the warning fatal),
> which throws an error wyth any linker:
>=20
> $ make LDFLAGS=3D"-fuse-ld=3Dmold -Wl,--no-undefined-version -Wl,--fatal-
> warnings".=20
>=20
> I will send v2 with a more accurate commit message.

Not necessary. I've already applied your patch to my "queue" branch.
I can add this additional information to the existing commit.

This makes we wonder whether we could/should use lld in some of our CI
runs (probably those where we use clang as compiler?). Currently the
containers we use for the CI don't contain lld.

Martin

