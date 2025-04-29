Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB12259C9D
	for <dm-devel@lists.linux.dev>; Tue, 29 Apr 2025 20:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745958358; cv=none; b=auirXxgmiGk5J10ECfl8D/9iTI3hdbpgLZDa3a5x4dpdxU5mOgsaoGv41GBeStVVGpqoeJcbtfWIvva7johOuVQ3MIhGBeRlmICGLk8HL/VBwxysKcj+xda4mGLibaNRnhAOZw7MguatzWh1XdYbzn9Ma7DGFtD70lIOLwLuOCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745958358; c=relaxed/simple;
	bh=+LiomySum0m5VNX4HcBpBbLtxrXi0hRB4q/4/wmXpHA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Sfnl1EUiYqDWcAuQxxVQtIW8Yw+acO4gFTVakZ8FGUxqzQAQnP6RgMqGkbjkZlweHm5hgL5r8gS8M1Zl9EZY80NqgljEoeGl9wwtAtPah85H9l/iiSKhMChmoOXQPiCgwSz22y5wzec3Dt//MK1zN9nhB0Gxml7UCQM16hhNBPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=M4yo4tS8; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=hurZ0Oeh; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="M4yo4tS8";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="hurZ0Oeh"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D1AE91F391;
	Tue, 29 Apr 2025 20:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1745958354; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+LiomySum0m5VNX4HcBpBbLtxrXi0hRB4q/4/wmXpHA=;
	b=M4yo4tS82mVAAFoFQNe/cuwR7N2ZPZNwbyH5vXQNUpRjirTwocb1siy/eeGs6GyeZ03k52
	KpKV9A+UFvhIwYqwNqRpEh3zOuwleVK5S9GE/GtTNyDOKMnAcS6ZLdppDT9bsbsGL7VyOP
	A+uUd1wT5byP+x86o9Q1rNYxijB79EY=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=hurZ0Oeh
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1745958353; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+LiomySum0m5VNX4HcBpBbLtxrXi0hRB4q/4/wmXpHA=;
	b=hurZ0Oehb1lT+K7NmqwUlfekt5Ntf2Oi8DB5n+hfWL70nmviVHoIOv178c5RFmtMfj+d65
	peLSyJ/l8ixjKNlc8AJJHieAYJ3EOq1C664EuQlfgqDRV5B/ufWMYbqsj7t4Z+aK5yJCcm
	BbLL3U7Ys5gb6Gwl2T7WE9noTcijCkc=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 99D5813931;
	Tue, 29 Apr 2025 20:25:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0TuHI9E1EWi+WAAAD6G6ig
	(envelope-from <mwilck@suse.com>); Tue, 29 Apr 2025 20:25:53 +0000
Message-ID: <2ae580165d03014e8c378c6cdd86bb76ac721bdf.camel@suse.com>
Subject: Re: [PATCH 2/2] libdmmp/Makefile: Add target
 docs/man/dmmp_strerror.3 to .PHONY list
From: Martin Wilck <mwilck@suse.com>
To: Yoann Congal <yoann.congal@smile.fr>
Cc: Sofiane HAMAM <sofiane.hamam@smile.fr>, dm-devel@lists.linux.dev, 
	bmarzins@redhat.com, =?ISO-8859-1?Q?K=E9l=E9fa_San=E9?=
 <kelefa.sane@smile.fr>
Date: Tue, 29 Apr 2025 22:25:53 +0200
In-Reply-To: <CAMSfU+5X2XA57xkXuueGOEm+ZB5xyiJXPJjjwQgaNBrjRsKu=w@mail.gmail.com>
References: <20250404122902.2750036-1-sofiane.hamam@smile.fr>
	 <20250404122902.2750036-2-sofiane.hamam@smile.fr>
	 <72355f1d0984647e91f8c50f1c2295071af49e33.camel@suse.com>
	 <b88e8b9c8f4fb17478b2020d9a00dabbe49d1f29.camel@suse.com>
	 <CAMSfU+5pbVe4JsXDY2xH40CS_K=vqH9iaCEso9tfMh19daNgZA@mail.gmail.com>
	 <4333916895109b795283620765d57d74c18137ad.camel@suse.com>
	 <CAMSfU+6ho6uxcNW4zx9Orb8qHAN239NaNt31vB3qE5vKuAVX=A@mail.gmail.com>
	 <bee02f6baae30380b8f2c5021dd0dcdebc7d81d8.camel@suse.com>
	 <CAMSfU+5X2XA57xkXuueGOEm+ZB5xyiJXPJjjwQgaNBrjRsKu=w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Rspamd-Queue-Id: D1AE91F391
X-Spam-Score: -4.51
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:mid,suse.com:email];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

On Tue, 2025-04-29 at 22:19 +0200, Yoann Congal wrote:
> Le mar. 29 avr. 2025 =C3=A0 22:06, Martin Wilck <mwilck@suse.com> a =C3=
=A9crit
> :
> >=20
> > On Sat, 2025-04-12 at 00:05 +0200, Yoann Congal wrote:
> > > Le lun. 7 avr. 2025 =C3=A0 16:42, Martin Wilck <mwilck@suse.com> a
> > > =C3=A9crit :
> > > >=20
> > > > On Mon, 2025-04-07 at 12:53 +0200, Yoann Congal wrote:
> > > > > Hello,
> > > > >=20
> > > > > Le lun. 7 avr. 2025 =C3=A0 12:32, Martin Wilck <mwilck@suse.com> =
a
> > > > > =C3=A9crit :
> > > > > >=20
> > > > > > On Mon, 2025-04-07 at 10:53 +0200, Martin Wilck wrote:
> > > > > > > On Fri, 2025-04-04 at 14:29 +0200, Sofiane HAMAM wrote:
> > > > > > > > From: K=C3=A9l=C3=A9fa San=C3=A9 <kelefa.sane@smile.fr>
> > > > > > > >=20
> > > > > > > > When checking out the git repos, sometimes, target
> > > > > > > > docs/man/dmmp_strerror.3 is newer that the prerequisite
> > > > > > > > libdmmp/libdmmp.h this leads to a non reproducible
> > > > > > > > behavior:
> > > > > > > > Sometimes, the timestamps are updated in the manpages,
> > > > > > > > sometimes
> > > > > > > > not.
> > > > > > > >=20
> > > > > > > > Signed-off-by: Yoann Congal <yoann.congal@smile.fr>
> > > > > > > > Signed-off-by: Sofiane HAMAM <sofiane.hamam@smile.fr>
> > > > > > > > Signed-off-by: Kelefa Sane <kelefa.sane@smile.fr>
> > > > > > > > ---
> > > > > > > > =C2=A0libdmmp/Makefile | 2 +-
> > > > > > > > =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
> > > > > > > >=20
> > > > > > > > diff --git a/libdmmp/Makefile b/libdmmp/Makefile
> > > > > > > > index 7e0e2509..187bcb8c 100644
> > > > > > > > --- a/libdmmp/Makefile
> > > > > > > > +++ b/libdmmp/Makefile
> > > > > > > > @@ -20,7 +20,7 @@ CFLAGS +=3D $(LIB_CFLAGS) -
> > > > > > > > fvisibility=3Dhidden
> > > > > > > > =C2=A0LIBDEPS +=3D $(shell $(PKG_CONFIG) --libs json-c) -
> > > > > > > > L$(mpathcmddir) -
> > > > > > > > lmpathcmd -lpthread
> > > > > > > >=20
> > > > > > > > =C2=A0all: $(LIBS) doc
> > > > > > > > -.PHONY:=C2=A0=C2=A0=C2=A0 doc clean install uninstall chec=
k
> > > > > > > > speed_test
> > > > > > > > dep_clean
> > > > > > > > +.PHONY:=C2=A0=C2=A0=C2=A0 doc clean install uninstall chec=
k
> > > > > > > > speed_test
> > > > > > > > dep_clean docs/man/dmmp_strerror.3
> > > > > > > >=20
> > > > > > >=20
> > > > > > > I've seen the issue you refer to, but this is not the
> > > > > > > right
> > > > > > > solution.
> > > > > > > It will cause the time stamps of the man pages to be
> > > > > > > regenerated
> > > > > > > on
> > > > > > > every build.
> > > > > >=20
> > > > > > After investigating this some more: AFAICS, your patch 1/2
> > > > > > fixes
> > > > > > the
> > > > > > erratic behavior in the (normal) case where
> > > > > > KBUILD_BUILD_TIMESTAMP
> > > > > > is
> > > > > > not set and git is available. Previously, in this case, the
> > > > > > kernel-
> > > > > > doc
> > > > > > script would have substituted the current date for
> > > > > > KBUILD_BUILD_TIMESTAMP (yielding "April 2025" today). With
> > > > > > your
> > > > > > fix,
> > > > > > KBUILD_BUILD_TIMESTAMP is correctly set to "August 2024".
> > > > > >=20
> > > > > > We need to create a commit that updates the man page time
> > > > > > stamps to
> > > > > > "August 2024". I'll do this.
> > > > > >=20
> > > > > > Once this is done, the build rule does the right thing,
> > > > > > AFAICS.
> > > > > > While
> > > > > > it will rewrite the man pages if the libdmmp.h timestamp is
> > > > > > updated, it
> > > > > > won't apply any real changes (visible in "git diff" or "git
> > > > > > status")
> > > > > > unless libdmmp.h has actually changed.
> > > > > >=20
> > > > > > Am I overlooking something?
> > > > >=20
> > > > > Depending on the order the files are written on disk during
> > > > > the
> > > > > git
> > > > > clone/archive extraction (is dmmp_strerror.3 written before
> > > > > or
> > > > > after
> > > > > libdmmp.h ?), the build rule will either run or not.
> > > > > But, as you wrote, with your latest patch, it does not matter
> > > > > at
> > > > > all
> > > > > because the rewritten timestamp will be exactly the same.
> > > > >=20
> > > > > Apart from this little quirk without any consequence, it
> > > > > looks
> > > > > good
> > > > > to me.
> > > > >=20
> > > > > The only future problem I can imagine is if libdmmp.h is
> > > > > updated
> > > > > without updating the timestamps (again).
> > > > > In this case, we will either get the timestamps from the
> > > > > sources
> > > > > or
> > > > > from git.
> > > >=20
> > > > That shouldn't happen because as soon as someone changes
> > > > libdmmp.h
> > > > and
> > > > runs "make", the timestamps will be updated. Even if it does,
> > > > the
> > > > worst
> > > > possible outcome is an outdated timestamp in the man pages,
> > > > which
> > > > we've
> > > > seem to have had for several years now.
> > > > Also, the actual content of libdmmp.h has hardly changed over
> > > > years.
> > > >=20
> > > > If someone can contribute a better fix, we'll apply it happily.
> > > > But
> > > > I'd
> > > > rather not want to have to check in the man pages after every
> > > > build.
> > >=20
> > > Our (Yocto project) situation is quite different: We build from
> > > scratch every time and the sources are only kept during the
> > > compilation, erased after.
> > > So we will use in our integration the 2 patches of this series to
> > > force a reproducible build of the manpages.
> > >=20
> > > Thanks!
> >=20
> > Can I take this as an acked-by: from your part?
>=20
> You can!
>=20
> Acked-by: Yoann Congal <yoann.congal@smile.fr>
>=20
> FYI, I participated in the patch development and am already in the
> Signed-off-by list if you did not notice.

On the first one, but not on the second, which simply updated the time
stamps.

Well I guess that one is so obvious that no specific review is
necessary. I'll add your acked-by nonetheless, thanks!


Regards
Martin
