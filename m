Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964CC1DC9B4
	for <dm-devel@lists.linux.dev>; Mon,  7 Apr 2025 14:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744036978; cv=none; b=qfn7WhP7nVFHlynvQwT4sz8eM22lIcGCpwSVXZdWn1MSwaTGUI03drqENm8IWUOLWZoawA+/ki8wyGLd4xhEz4qloTaRJQnxuxoJtPLu0pG7AQU9EBgf4qHvZV4sDorGCPFDLLqVH41/uT4IjfET7FNLpJMn8RcmHwF5GjUxgvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744036978; c=relaxed/simple;
	bh=VQvUJPg0CiloOIvjyUm7ciBy/Dkt6WPzuYpa+pu+/P8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HK3o6rEC2XxmxvKxmCMB3jkMPw0ChNuGhinK0RtRrLrzrL3l2tCjFst/d73D1R+m21jnUXPX4DzZ/D0Ee6rZQ8GQa7OznXetNfqN1sQmFcs/NqFfjuor4DtKd+juTNMhmcEL51RN6z2AoeME9j4cTdWvrS8CgyWc5EPcsmYU+Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=r7CN5ZVv; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=r7CN5ZVv; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="r7CN5ZVv";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="r7CN5ZVv"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A49C82116E;
	Mon,  7 Apr 2025 14:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1744036974; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VQvUJPg0CiloOIvjyUm7ciBy/Dkt6WPzuYpa+pu+/P8=;
	b=r7CN5ZVvJSybfsjWd3uPoLJvL6es52CQTROw3zRYAP5F7EkeSIHAt3S8Zn76E0yhUVNbjC
	KKLOSoCH7D1SnmVJYlbpF7BfDKt2cpDaxYDXQtK/Tu+hmm2N5sTO2OvOZFEfFrOthP2vsj
	U8frKlPvRbvbJ890PdB9Ps9Z0ORCUG8=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1744036974; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VQvUJPg0CiloOIvjyUm7ciBy/Dkt6WPzuYpa+pu+/P8=;
	b=r7CN5ZVvJSybfsjWd3uPoLJvL6es52CQTROw3zRYAP5F7EkeSIHAt3S8Zn76E0yhUVNbjC
	KKLOSoCH7D1SnmVJYlbpF7BfDKt2cpDaxYDXQtK/Tu+hmm2N5sTO2OvOZFEfFrOthP2vsj
	U8frKlPvRbvbJ890PdB9Ps9Z0ORCUG8=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6FAFE13691;
	Mon,  7 Apr 2025 14:42:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id O123GW7k82dYLwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Mon, 07 Apr 2025 14:42:54 +0000
Message-ID: <4333916895109b795283620765d57d74c18137ad.camel@suse.com>
Subject: Re: [PATCH 2/2] libdmmp/Makefile: Add target
 docs/man/dmmp_strerror.3 to .PHONY list
From: Martin Wilck <mwilck@suse.com>
To: Yoann Congal <yoann.congal@smile.fr>
Cc: Sofiane HAMAM <sofiane.hamam@smile.fr>, dm-devel@lists.linux.dev, 
	bmarzins@redhat.com, =?ISO-8859-1?Q?K=E9l=E9fa_San=E9?=
 <kelefa.sane@smile.fr>
Date: Mon, 07 Apr 2025 16:42:53 +0200
In-Reply-To: <CAMSfU+5pbVe4JsXDY2xH40CS_K=vqH9iaCEso9tfMh19daNgZA@mail.gmail.com>
References: <20250404122902.2750036-1-sofiane.hamam@smile.fr>
	 <20250404122902.2750036-2-sofiane.hamam@smile.fr>
	 <72355f1d0984647e91f8c50f1c2295071af49e33.camel@suse.com>
	 <b88e8b9c8f4fb17478b2020d9a00dabbe49d1f29.camel@suse.com>
	 <CAMSfU+5pbVe4JsXDY2xH40CS_K=vqH9iaCEso9tfMh19daNgZA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.0 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.993];
	MIME_GOOD(-0.10)[text/plain];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid]
X-Spam-Score: -4.30
X-Spam-Flag: NO

On Mon, 2025-04-07 at 12:53 +0200, Yoann Congal wrote:
> Hello,
>=20
> Le lun. 7 avr. 2025 =C3=A0 12:32, Martin Wilck <mwilck@suse.com> a =C3=A9=
crit :
> >=20
> > On Mon, 2025-04-07 at 10:53 +0200, Martin Wilck wrote:
> > > On Fri, 2025-04-04 at 14:29 +0200, Sofiane HAMAM wrote:
> > > > From: K=C3=A9l=C3=A9fa San=C3=A9 <kelefa.sane@smile.fr>
> > > >=20
> > > > When checking out the git repos, sometimes, target
> > > > docs/man/dmmp_strerror.3 is newer that the prerequisite
> > > > libdmmp/libdmmp.h this leads to a non reproducible behavior:
> > > > Sometimes, the timestamps are updated in the manpages,
> > > > sometimes
> > > > not.
> > > >=20
> > > > Signed-off-by: Yoann Congal <yoann.congal@smile.fr>
> > > > Signed-off-by: Sofiane HAMAM <sofiane.hamam@smile.fr>
> > > > Signed-off-by: Kelefa Sane <kelefa.sane@smile.fr>
> > > > ---
> > > > =C2=A0libdmmp/Makefile | 2 +-
> > > > =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
> > > >=20
> > > > diff --git a/libdmmp/Makefile b/libdmmp/Makefile
> > > > index 7e0e2509..187bcb8c 100644
> > > > --- a/libdmmp/Makefile
> > > > +++ b/libdmmp/Makefile
> > > > @@ -20,7 +20,7 @@ CFLAGS +=3D $(LIB_CFLAGS) -fvisibility=3Dhidden
> > > > =C2=A0LIBDEPS +=3D $(shell $(PKG_CONFIG) --libs json-c) -
> > > > L$(mpathcmddir) -
> > > > lmpathcmd -lpthread
> > > >=20
> > > > =C2=A0all: $(LIBS) doc
> > > > -.PHONY:=C2=A0=C2=A0=C2=A0 doc clean install uninstall check speed_=
test
> > > > dep_clean
> > > > +.PHONY:=C2=A0=C2=A0=C2=A0 doc clean install uninstall check speed_=
test
> > > > dep_clean docs/man/dmmp_strerror.3
> > > >=20
> > >=20
> > > I've seen the issue you refer to, but this is not the right
> > > solution.
> > > It will cause the time stamps of the man pages to be regenerated
> > > on
> > > every build.
> >=20
> > After investigating this some more: AFAICS, your patch 1/2 fixes
> > the
> > erratic behavior in the (normal) case where KBUILD_BUILD_TIMESTAMP
> > is
> > not set and git is available. Previously, in this case, the kernel-
> > doc
> > script would have substituted the current date for
> > KBUILD_BUILD_TIMESTAMP (yielding "April 2025" today). With your
> > fix,
> > KBUILD_BUILD_TIMESTAMP is correctly set to "August 2024".
> >=20
> > We need to create a commit that updates the man page time stamps to
> > "August 2024". I'll do this.
> >=20
> > Once this is done, the build rule does the right thing, AFAICS.
> > While
> > it will rewrite the man pages if the libdmmp.h timestamp is
> > updated, it
> > won't apply any real changes (visible in "git diff" or "git
> > status")
> > unless libdmmp.h has actually changed.
> >=20
> > Am I overlooking something?
>=20
> Depending on the order the files are written on disk during the git
> clone/archive extraction (is dmmp_strerror.3 written before or after
> libdmmp.h ?), the build rule will either run or not.
> But, as you wrote, with your latest patch, it does not matter at all
> because the rewritten timestamp will be exactly the same.
>=20
> Apart from this little quirk without any consequence, it looks good
> to me.
>=20
> The only future problem I can imagine is if libdmmp.h is updated
> without updating the timestamps (again).
> In this case, we will either get the timestamps from the sources or
> from git.

That shouldn't happen because as soon as someone changes libdmmp.h and
runs "make", the timestamps will be updated. Even if it does, the worst
possible outcome is an outdated timestamp in the man pages, which we've
seem to have had for several years now.
Also, the actual content of libdmmp.h has hardly changed over years.

If someone can contribute a better fix, we'll apply it happily. But I'd
rather not want to have to check in the man pages after every build.

Regards
Martin
