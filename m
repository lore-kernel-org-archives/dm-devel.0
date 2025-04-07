Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E337E13777E
	for <dm-devel@lists.linux.dev>; Mon,  7 Apr 2025 10:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744021959; cv=none; b=FHj9wKo0fRHxIB8DAMGrlt4enuuv36Qa2wh6SWVlDoYFhRIbYterAvfSl1sGc1TcxjMXbh9uXb4ZIWbUCO7S5DrQxjKbrw0zaGs6QDpmm6HuAT75+yipARyzJj/3N4F58r8GeNJFBMPVsBzeHqCWIENBhHskaJ5dxKAeeuUsH3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744021959; c=relaxed/simple;
	bh=2x9hzD8M06hytZ/PaKgXd2BhG9XxgPlOi/U3PQ7w0ms=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jkKSTRm9WGCUOyhBrsencscjwZMM9tK2XWAj2hudotmv33XwXz/4QdP0LO84RQ0+HA4PzxBC7XaedSGQh/tKfjcHcFTA9MaEyTF5Okrg5sPFmGxX2alwwZsJCYcC8ZICz6gng8IvoxAzo4eUz+zYsgNCbSmW8TVmlT1H5sfzvy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=q91V2KRH; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=q91V2KRH; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="q91V2KRH";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="q91V2KRH"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BEA6C1F388;
	Mon,  7 Apr 2025 10:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1744021954; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nW7l2QDVNkRTCIsnoOQDrwJC8r2SrDprftvjh3O5gGQ=;
	b=q91V2KRHVrs2p8vVNhcyvo0ru/8YDuoAg09rUJAwEakr27ADin/RAmINUW25p9zlKya4pC
	ry78HfHgBdTBbMFH0xQ0KMqGTeDE7UoZznQsUZN7zppldU+dmDOvkHGGBtmBhYjQYX0maG
	hqchZ/S8KeuXx0y4AedEyHRzg68HSuA=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1744021954; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nW7l2QDVNkRTCIsnoOQDrwJC8r2SrDprftvjh3O5gGQ=;
	b=q91V2KRHVrs2p8vVNhcyvo0ru/8YDuoAg09rUJAwEakr27ADin/RAmINUW25p9zlKya4pC
	ry78HfHgBdTBbMFH0xQ0KMqGTeDE7UoZznQsUZN7zppldU+dmDOvkHGGBtmBhYjQYX0maG
	hqchZ/S8KeuXx0y4AedEyHRzg68HSuA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8D0EF13691;
	Mon,  7 Apr 2025 10:32:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 52nuIMKp82ckWQAAD6G6ig
	(envelope-from <mwilck@suse.com>); Mon, 07 Apr 2025 10:32:34 +0000
Message-ID: <b88e8b9c8f4fb17478b2020d9a00dabbe49d1f29.camel@suse.com>
Subject: Re: [PATCH 2/2] libdmmp/Makefile: Add target
 docs/man/dmmp_strerror.3 to .PHONY list
From: Martin Wilck <mwilck@suse.com>
To: Sofiane HAMAM <sofiane.hamam@smile.fr>, dm-devel@lists.linux.dev
Cc: bmarzins@redhat.com, =?ISO-8859-1?Q?K=E9l=E9fa_San=E9?=
	 <kelefa.sane@smile.fr>, Yoann Congal <yoann.congal@smile.fr>
Date: Mon, 07 Apr 2025 12:32:34 +0200
In-Reply-To: <72355f1d0984647e91f8c50f1c2295071af49e33.camel@suse.com>
References: <20250404122902.2750036-1-sofiane.hamam@smile.fr>
		 <20250404122902.2750036-2-sofiane.hamam@smile.fr>
	 <72355f1d0984647e91f8c50f1c2295071af49e33.camel@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.0 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Level: 

On Mon, 2025-04-07 at 10:53 +0200, Martin Wilck wrote:
> On Fri, 2025-04-04 at 14:29 +0200, Sofiane HAMAM wrote:
> > From: K=C3=A9l=C3=A9fa San=C3=A9 <kelefa.sane@smile.fr>
> >=20
> > When checking out the git repos, sometimes, target
> > docs/man/dmmp_strerror.3 is newer that the prerequisite
> > libdmmp/libdmmp.h this leads to a non reproducible behavior:
> > Sometimes, the timestamps are updated in the manpages, sometimes
> > not.
> >=20
> > Signed-off-by: Yoann Congal <yoann.congal@smile.fr>
> > Signed-off-by: Sofiane HAMAM <sofiane.hamam@smile.fr>
> > Signed-off-by: Kelefa Sane <kelefa.sane@smile.fr>
> > ---
> > =C2=A0libdmmp/Makefile | 2 +-
> > =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/libdmmp/Makefile b/libdmmp/Makefile
> > index 7e0e2509..187bcb8c 100644
> > --- a/libdmmp/Makefile
> > +++ b/libdmmp/Makefile
> > @@ -20,7 +20,7 @@ CFLAGS +=3D $(LIB_CFLAGS) -fvisibility=3Dhidden
> > =C2=A0LIBDEPS +=3D $(shell $(PKG_CONFIG) --libs json-c) -L$(mpathcmddir=
) -
> > lmpathcmd -lpthread
> > =C2=A0
> > =C2=A0all: $(LIBS) doc
> > -.PHONY:	doc clean install uninstall check speed_test
> > dep_clean
> > +.PHONY:	doc clean install uninstall check speed_test
> > dep_clean docs/man/dmmp_strerror.3
> > =C2=A0
>=20
> I've seen the issue you refer to, but this is not the right solution.
> It will cause the time stamps of the man pages to be regenerated on
> every build.

After investigating this some more: AFAICS, your patch 1/2 fixes the
erratic behavior in the (normal) case where KBUILD_BUILD_TIMESTAMP is
not set and git is available. Previously, in this case, the kernel-doc
script would have substituted the current date for
KBUILD_BUILD_TIMESTAMP (yielding "April 2025" today). With your fix,
KBUILD_BUILD_TIMESTAMP is correctly set to "August 2024".

We need to create a commit that updates the man page time stamps to
"August 2024". I'll do this.=C2=A0

Once this is done, the build rule does the right thing, AFAICS. While
it will rewrite the man pages if the libdmmp.h timestamp is updated, it
won't apply any real changes (visible in "git diff" or "git status")
unless libdmmp.h has actually changed.

Am I overlooking something?

Martin

