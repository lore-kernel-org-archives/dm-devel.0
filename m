Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A13920DD72
	for <dm-devel@lists.linux.dev>; Fri,  9 May 2025 14:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746800376; cv=none; b=u+iJNLHpQVArh/fMqM+hWC1V3CF6jCSczNvN/38KhdMblrpFZJPf3wKVIERwI7qCPwNuCQ1k9OPerNmUAllpDsMwF6pzlfvTlCwyBfBvMp14MLmURrf2TOdv+vslsnXtWgbHjmrDjC3EYijWF/CuVPGVRjAV1beixRtFcRuKmnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746800376; c=relaxed/simple;
	bh=nCjK81dhh6SbIzg1eJE7Ln1OIx0mw2F8M/Bo72xGB9Y=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cRMe0/G8Hk1JR5wM2gFbbDmMRjmDO1DqZmuGC4R3o8fxQsWyWdUh/br9zLMm08R/HPwWiW2+hBO05sjEw6AbjGNvDHKTJlxKuWWTCTnVJ7iBDd0hQ6uwOPhR6FG4F/8ql80NKM4wzqC4X2MIgkH6KfeOaCN7Y4bwkDEs+UyZ+qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=hRM4x6TO; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=hRM4x6TO; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="hRM4x6TO";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="hRM4x6TO"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 192532115E;
	Fri,  9 May 2025 14:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1746800372; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=63PDrJsSlTOrASLg85QCJCBTYaIDJ7NtDSOsY+t76o4=;
	b=hRM4x6TOU1XDlyLrpW1BtLVqsTppWGQSffB+VZexl485bXtyBq5hbVR1xMNQV4dmPM1gay
	QKjuzORuCxVcwGL8GVA+35eiE7UReUVk4ZXZrFQUVuKglDLg+3IsbRhSxMPXMM7Fzn13l7
	/r+XS42EZ1FPa+ZeKh8YaXYJgZC2NFM=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1746800372; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=63PDrJsSlTOrASLg85QCJCBTYaIDJ7NtDSOsY+t76o4=;
	b=hRM4x6TOU1XDlyLrpW1BtLVqsTppWGQSffB+VZexl485bXtyBq5hbVR1xMNQV4dmPM1gay
	QKjuzORuCxVcwGL8GVA+35eiE7UReUVk4ZXZrFQUVuKglDLg+3IsbRhSxMPXMM7Fzn13l7
	/r+XS42EZ1FPa+ZeKh8YaXYJgZC2NFM=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DF7B11399F;
	Fri,  9 May 2025 14:19:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GfT+NPMOHmhrSgAAD6G6ig
	(envelope-from <mwilck@suse.com>); Fri, 09 May 2025 14:19:31 +0000
Message-ID: <83ecaf89daa16c74872b3b6b51a5e7fbf637270c.camel@suse.com>
Subject: Re: [PATCH] multipath-tools: fix misspellings
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, DM-DEVEL ML <dm-devel@lists.linux.dev>
Date: Fri, 09 May 2025 16:19:30 +0200
In-Reply-To: <20250509125444.222611-1-xose.vazquez@gmail.com>
References: <20250509125444.222611-1-xose.vazquez@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	ARC_NA(0.00)[];
	TAGGED_RCPT(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,linux.dev:email,opensvc.com:email,suse.com:email,suse.com:mid]

Hello Xose,

On Fri, 2025-05-09 at 14:54 +0200, Xose Vazquez Perez wrote:
> codespell:
> ./tests/mapinfo.c:964: ouput =3D=3D> output
> ./libmultipath/devmapper.h:118: paramters =3D=3D> parameters
> ./libmpathutil/uxsock.c:69: everone =3D=3D> everyone

As you may know, a spell checker is part of our regular GitHub CI [1].
This checker has found a large amount of spelling errors in our code
base when we first tried it. We therefore decided to restrict it to
user-visible parts of the code, i.e. error messages, man pages, READMEs
etc.

While there's nothing wrong with your patch per se, I am hesitant to
apply it, because if we start fixing spelling errors in comments, we
should be consequent and=C2=A0eliminate all spelling mistakes, which would
cause a large number of code changes that are irrelevant to
functionality. That, in turn, would make it more difficult to assess
future code changes for regressions and bug fixes.

I'd like to continue following a policy of small changes. That means
that we fix things like indentation, formatting, whitespace, and
spelling only in those places of the code which we actually make
changes for.

This is just my personal preference of course. I'm open for discussion.

Regards
Martin

[1] https://github.com/opensvc/multipath-tools/actions/workflows/spelling.y=
ml

>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> SUMMARY:
> everone=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1
> ouput=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1
> paramters=C2=A0=C2=A0=C2=A0=C2=A0 1
>=20
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
> =C2=A0libmpathutil/uxsock.c=C2=A0=C2=A0=C2=A0 | 2 +-
> =C2=A0libmultipath/devmapper.h | 2 +-
> =C2=A0tests/mapinfo.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 | 2 +-
> =C2=A03 files changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/libmpathutil/uxsock.c b/libmpathutil/uxsock.c
> index 59c47170..02b387d0 100644
> --- a/libmpathutil/uxsock.c
> +++ b/libmpathutil/uxsock.c
> @@ -66,7 +66,7 @@ int ux_socket_listen(const char *name)
> =C2=A0	}
> =C2=A0
> =C2=A0	/*
> -	 * Socket needs to have rw permissions for everone.
> +	 * Socket needs to have rw permissions for everyone.
> =C2=A0	 * SO_PEERCRED makes sure that only root can modify things.
> =C2=A0	 */
> =C2=A0	if (name[0] !=3D '@' &&
> diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
> index 4aeefad1..c0f7aa0d 100644
> --- a/libmultipath/devmapper.h
> +++ b/libmultipath/devmapper.h
> @@ -115,7 +115,7 @@ typedef struct libmp_map_info {
> =C2=A0 *
> =C2=A0 * This function obtains the requested information for the device-
> mapper map
> =C2=A0 * identified by the input parameters.
> - * If non-NULL, the name, uuid, and dmi output paramters may be
> filled in for
> + * If non-NULL, the name, uuid, and dmi output parameters may be
> filled in for
> =C2=A0 * any return value besides DMP_NOT_FOUND and will always be filled
> in for
> =C2=A0 * return values other than DMP_NOT_FOUND and DMP_ERR.
> =C2=A0 * The other parameters are only filled in if the return value is
> DMP_OK.
> diff --git a/tests/mapinfo.c b/tests/mapinfo.c
> index 36511607..399e16e7 100644
> --- a/tests/mapinfo.c
> +++ b/tests/mapinfo.c
> @@ -961,7 +961,7 @@ static void test_mapinfo_bad_target_type_03(void
> **state)
> =C2=A0			=C2=A0=C2=A0 (mapid_t) { .str =3D "foo", },
> =C2=A0			=C2=A0=C2=A0 (mapinfo_t) { .dmi =3D &dmi, .name =3D name,
> .uuid =3D uuid });
> =C2=A0	assert_int_equal(rc, DMP_NO_MATCH);
> -	/* make sure that the ouput was filled in */
> +	/* make sure that the output was filled in */
> =C2=A0	assert_memory_equal(&dmi, &MPATH_DMI_01, sizeof(dmi));
> =C2=A0	assert_true(!strcmp(name, MPATH_NAME_01));
> =C2=A0	assert_true(!strcmp(uuid, MPATH_UUID_01));
