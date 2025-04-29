Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4922622F3B0
	for <dm-devel@lists.linux.dev>; Tue, 29 Apr 2025 20:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745957171; cv=none; b=B6nbxbJW7NAIuAcqqFHrO2aSanew+pMCpft/DJ1uvl3U3/oY0F8cxkNSdQxSmea0Mu2Zr77eX0D9WCmRuTmP50bzlEopd+w1dHR63ThoGTenqb8qxKtIzskjv3VqE86K1hZ/a+aY46aGtRwXR/5jraBz0kPh+As87O/ypun1JRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745957171; c=relaxed/simple;
	bh=aMe+/8/FfiylRKf6BmOCIEFOY0hOpHIsQfuIskp9uNk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XEX2mreOU4A8Vn6GSNqfakxZwN96U0K+DexmU4If2klh61CPypFyGroyPGYjn2hyISZdvwRQkeXUynyLSZcCgA9gdPYvy5Lz2dXrvbVWzbcJ8Mf1AYvbalMKn7FEnC+HNhMkjilLFUPfU+UfMOs7b+myjcYRG8ti5/JlmCh3viw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=OOF0+lrx; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=OOF0+lrx; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="OOF0+lrx";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="OOF0+lrx"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 27B2821908;
	Tue, 29 Apr 2025 20:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1745957167; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aMe+/8/FfiylRKf6BmOCIEFOY0hOpHIsQfuIskp9uNk=;
	b=OOF0+lrxMPnOFtccwJMUKlRPcuOziClGpMqPwJaSGJ7ldfmlmqCAryTkromdZYbS20ZKC0
	QRxaMLcTi2m9BOKWD+3m1zdOq9yHAqd9jmzSY0NV4TpyLX2rN2R86WaAkwoHy+JgHCNxoy
	J4zFQJTel+sYZPKRsNJyp4fR/++TIDc=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=OOF0+lrx
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1745957167; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aMe+/8/FfiylRKf6BmOCIEFOY0hOpHIsQfuIskp9uNk=;
	b=OOF0+lrxMPnOFtccwJMUKlRPcuOziClGpMqPwJaSGJ7ldfmlmqCAryTkromdZYbS20ZKC0
	QRxaMLcTi2m9BOKWD+3m1zdOq9yHAqd9jmzSY0NV4TpyLX2rN2R86WaAkwoHy+JgHCNxoy
	J4zFQJTel+sYZPKRsNJyp4fR/++TIDc=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E8DBC1340C;
	Tue, 29 Apr 2025 20:06:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id lJkDNy4xEWjYVAAAD6G6ig
	(envelope-from <mwilck@suse.com>); Tue, 29 Apr 2025 20:06:06 +0000
Message-ID: <bee02f6baae30380b8f2c5021dd0dcdebc7d81d8.camel@suse.com>
Subject: Re: [PATCH 2/2] libdmmp/Makefile: Add target
 docs/man/dmmp_strerror.3 to .PHONY list
From: Martin Wilck <mwilck@suse.com>
To: Yoann Congal <yoann.congal@smile.fr>
Cc: Sofiane HAMAM <sofiane.hamam@smile.fr>, dm-devel@lists.linux.dev, 
	bmarzins@redhat.com, =?ISO-8859-1?Q?K=E9l=E9fa_San=E9?=
 <kelefa.sane@smile.fr>
Date: Tue, 29 Apr 2025 22:06:06 +0200
In-Reply-To: <CAMSfU+6ho6uxcNW4zx9Orb8qHAN239NaNt31vB3qE5vKuAVX=A@mail.gmail.com>
References: <20250404122902.2750036-1-sofiane.hamam@smile.fr>
	 <20250404122902.2750036-2-sofiane.hamam@smile.fr>
	 <72355f1d0984647e91f8c50f1c2295071af49e33.camel@suse.com>
	 <b88e8b9c8f4fb17478b2020d9a00dabbe49d1f29.camel@suse.com>
	 <CAMSfU+5pbVe4JsXDY2xH40CS_K=vqH9iaCEso9tfMh19daNgZA@mail.gmail.com>
	 <4333916895109b795283620765d57d74c18137ad.camel@suse.com>
	 <CAMSfU+6ho6uxcNW4zx9Orb8qHAN239NaNt31vB3qE5vKuAVX=A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Rspamd-Queue-Id: 27B2821908
X-Spam-Level: 
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email,suse.com:dkim,suse.com:mid];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.51
X-Spam-Flag: NO

On Sat, 2025-04-12 at 00:05 +0200, Yoann Congal wrote:
> Le lun. 7 avr. 2025 =C3=A0 16:42, Martin Wilck <mwilck@suse.com> a =C3=A9=
crit :
> >=20
> > On Mon, 2025-04-07 at 12:53 +0200, Yoann Congal wrote:
> > > Hello,
> > >=20
> > > Le lun. 7 avr. 2025 =C3=A0 12:32, Martin Wilck <mwilck@suse.com> a
> > > =C3=A9crit :
> > > >=20
> > > > On Mon, 2025-04-07 at 10:53 +0200, Martin Wilck wrote:
> > > > > On Fri, 2025-04-04 at 14:29 +0200, Sofiane HAMAM wrote:
> > > > > > From: K=C3=A9l=C3=A9fa San=C3=A9 <kelefa.sane@smile.fr>
> > > > > >=20
> > > > > > When checking out the git repos, sometimes, target
> > > > > > docs/man/dmmp_strerror.3 is newer that the prerequisite
> > > > > > libdmmp/libdmmp.h this leads to a non reproducible
> > > > > > behavior:
> > > > > > Sometimes, the timestamps are updated in the manpages,
> > > > > > sometimes
> > > > > > not.
> > > > > >=20
> > > > > > Signed-off-by: Yoann Congal <yoann.congal@smile.fr>
> > > > > > Signed-off-by: Sofiane HAMAM <sofiane.hamam@smile.fr>
> > > > > > Signed-off-by: Kelefa Sane <kelefa.sane@smile.fr>
> > > > > > ---
> > > > > > =C2=A0libdmmp/Makefile | 2 +-
> > > > > > =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
> > > > > >=20
> > > > > > diff --git a/libdmmp/Makefile b/libdmmp/Makefile
> > > > > > index 7e0e2509..187bcb8c 100644
> > > > > > --- a/libdmmp/Makefile
> > > > > > +++ b/libdmmp/Makefile
> > > > > > @@ -20,7 +20,7 @@ CFLAGS +=3D $(LIB_CFLAGS) -
> > > > > > fvisibility=3Dhidden
> > > > > > =C2=A0LIBDEPS +=3D $(shell $(PKG_CONFIG) --libs json-c) -
> > > > > > L$(mpathcmddir) -
> > > > > > lmpathcmd -lpthread
> > > > > >=20
> > > > > > =C2=A0all: $(LIBS) doc
> > > > > > -.PHONY:=C2=A0=C2=A0=C2=A0 doc clean install uninstall check sp=
eed_test
> > > > > > dep_clean
> > > > > > +.PHONY:=C2=A0=C2=A0=C2=A0 doc clean install uninstall check sp=
eed_test
> > > > > > dep_clean docs/man/dmmp_strerror.3
> > > > > >=20
> > > > >=20
> > > > > I've seen the issue you refer to, but this is not the right
> > > > > solution.
> > > > > It will cause the time stamps of the man pages to be
> > > > > regenerated
> > > > > on
> > > > > every build.
> > > >=20
> > > > After investigating this some more: AFAICS, your patch 1/2
> > > > fixes
> > > > the
> > > > erratic behavior in the (normal) case where
> > > > KBUILD_BUILD_TIMESTAMP
> > > > is
> > > > not set and git is available. Previously, in this case, the
> > > > kernel-
> > > > doc
> > > > script would have substituted the current date for
> > > > KBUILD_BUILD_TIMESTAMP (yielding "April 2025" today). With your
> > > > fix,
> > > > KBUILD_BUILD_TIMESTAMP is correctly set to "August 2024".
> > > >=20
> > > > We need to create a commit that updates the man page time
> > > > stamps to
> > > > "August 2024". I'll do this.
> > > >=20
> > > > Once this is done, the build rule does the right thing, AFAICS.
> > > > While
> > > > it will rewrite the man pages if the libdmmp.h timestamp is
> > > > updated, it
> > > > won't apply any real changes (visible in "git diff" or "git
> > > > status")
> > > > unless libdmmp.h has actually changed.
> > > >=20
> > > > Am I overlooking something?
> > >=20
> > > Depending on the order the files are written on disk during the
> > > git
> > > clone/archive extraction (is dmmp_strerror.3 written before or
> > > after
> > > libdmmp.h ?), the build rule will either run or not.
> > > But, as you wrote, with your latest patch, it does not matter at
> > > all
> > > because the rewritten timestamp will be exactly the same.
> > >=20
> > > Apart from this little quirk without any consequence, it looks
> > > good
> > > to me.
> > >=20
> > > The only future problem I can imagine is if libdmmp.h is updated
> > > without updating the timestamps (again).
> > > In this case, we will either get the timestamps from the sources
> > > or
> > > from git.
> >=20
> > That shouldn't happen because as soon as someone changes libdmmp.h
> > and
> > runs "make", the timestamps will be updated. Even if it does, the
> > worst
> > possible outcome is an outdated timestamp in the man pages, which
> > we've
> > seem to have had for several years now.
> > Also, the actual content of libdmmp.h has hardly changed over
> > years.
> >=20
> > If someone can contribute a better fix, we'll apply it happily. But
> > I'd
> > rather not want to have to check in the man pages after every
> > build.
>=20
> Our (Yocto project) situation is quite different: We build from
> scratch every time and the sources are only kept during the
> compilation, erased after.
> So we will use in our integration the 2 patches of this series to
> force a reproducible build of the manpages.
>=20
> Thanks!

Can I take this as an acked-by: from your part?
Or @Ben could you give it a review?

Martin
