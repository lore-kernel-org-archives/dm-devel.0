Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7CD521B8E7
	for <dm-devel@lists.linux.dev>; Wed,  7 May 2025 07:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746602380; cv=none; b=H/sg0KA7R43aPHalCiOaejQ5IqcpJr/npZDYptAr1wqbEPor0VlCiPCeVgdhDoP/LCxRLnFUbvzFwMdlREm3DiV90yZQR4eviK+vBsvabsFa2ImT6n/upaQmS2ACR+zZmsFm2sZ/CN+rvwJwbX+0fPCfKA8/N8vGmYrmy5CfFj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746602380; c=relaxed/simple;
	bh=aChXSkeeohw6y+Z3NQkeTMxkT5UQh+D8m6qaFnApVp8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Tf3p1gI4ww38+LTCi4X1vqnBS7nZCO6v4g2d+7f34pOTFLs/7gSM7PffybLe5cmDRDN4PV5VJUh8tFPWINiDusuulG3g7R0FhH5gwZ0Dy3on0ntLNE14htkC+NUEYgeAFmRl2mmsc47HRTZJ7RSO290rKJs4CW4f0GX7wuSlOso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Myr28NxS; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Myr28NxS; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Myr28NxS";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Myr28NxS"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8C7FF21188;
	Wed,  7 May 2025 07:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1746602376; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3ILjFl4umxEvlnVKVT6G+PDS8FVGhfkIpgq+j7B+Kt4=;
	b=Myr28NxSW8yIOcPADE34UXj9jbvGK+zUzYux7bcylrF+Uz8xTYUN7cpoCqE32Kgdge4mRR
	Ehj0pzByfQeItA6f+MoPIFVvzbbwNyE6crmvA/P0fJoLXFP54rMU/beiO2aU3Xa1ebYVvu
	vjKmHE9D6O76jPWo02LC1W/JDFYAiHI=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=Myr28NxS
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1746602376; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3ILjFl4umxEvlnVKVT6G+PDS8FVGhfkIpgq+j7B+Kt4=;
	b=Myr28NxSW8yIOcPADE34UXj9jbvGK+zUzYux7bcylrF+Uz8xTYUN7cpoCqE32Kgdge4mRR
	Ehj0pzByfQeItA6f+MoPIFVvzbbwNyE6crmvA/P0fJoLXFP54rMU/beiO2aU3Xa1ebYVvu
	vjKmHE9D6O76jPWo02LC1W/JDFYAiHI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5E18213882;
	Wed,  7 May 2025 07:19:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id lOtuFYgJG2hNUwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Wed, 07 May 2025 07:19:36 +0000
Message-ID: <a078f35f617bf8b6ac0624b723b52933c0a109aa.camel@suse.com>
Subject: Re: [PATCH 4/6] libmpathutil: silence compiler warning in
 vector_del_slot()
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, Xose Vazquez Perez
	 <xose.vazquez@gmail.com>, dm-devel@lists.linux.dev
Date: Wed, 07 May 2025 09:19:35 +0200
In-Reply-To: <aBqGxgGHFuvADCQ4@redhat.com>
References: <20250505163007.59352-1-mwilck@suse.com>
	 <20250505163007.59352-5-mwilck@suse.com> <aBqGxgGHFuvADCQ4@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Rspamd-Queue-Id: 8C7FF21188
X-Spam-Score: -3.01
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	MID_RHS_MATCH_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[opensvc.com,gmail.com,lists.linux.dev];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCPT_COUNT_THREE(0.00)[4];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,fedoraproject.org:url]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

On Tue, 2025-05-06 at 18:01 -0400, Benjamin Marzinski wrote:
> On Mon, May 05, 2025 at 06:29:56PM +0200, Martin Wilck wrote:
> > Try to silence a gcc warning. Also, replace the wrong-looking
> > VECTOR_DEFAULT_SIZE by 1 (after all, we've just deleted a single
> > element).
> >=20
> > Found by Fedora's static analysis [1].
> >=20
> > [1]
> > https://openscanhub.fedoraproject.org/task/51915/log/device-mapper-mult=
ipath-0.11.1-1.fc43/scan-results.html
> >=20
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> > =C2=A0libmpathutil/vector.c | 16 ++++++++--------
> > =C2=A01 file changed, 8 insertions(+), 8 deletions(-)
> >=20
> > diff --git a/libmpathutil/vector.c b/libmpathutil/vector.c
> > index 7f763cb..3386651 100644
> > --- a/libmpathutil/vector.c
> > +++ b/libmpathutil/vector.c
> > @@ -107,28 +107,28 @@ int find_slot(vector v, const void *addr)
> > =C2=A0void
> > =C2=A0vector_del_slot(vector v, int slot)
> > =C2=A0{
> > -	int i;
> > +	int i, allocated;
> > =C2=A0
> > =C2=A0	if (!v || !v->allocated || slot < 0 || slot >=3D
> > VECTOR_SIZE(v))
> > =C2=A0		return;
> > =C2=A0
> > =C2=A0	for (i =3D slot + 1; i < VECTOR_SIZE(v); i++)
> > -		v->slot[i-1] =3D v->slot[i];
> > +		v->slot[i - 1] =3D v->slot[i];
> > =C2=A0
> > -	v->allocated -=3D VECTOR_DEFAULT_SIZE;
> > +	allocated =3D v->allocated - 1;
> > =C2=A0
> > -	if (v->allocated <=3D 0) {
> > +	if (allocated <=3D 0) {
> > =C2=A0		free(v->slot);
> > =C2=A0		v->slot =3D NULL;
> > =C2=A0		v->allocated =3D 0;
> > =C2=A0	} else {
> > =C2=A0		void *new_slot;
> > =C2=A0
> > -		new_slot =3D realloc(v->slot, sizeof (void *) * v-
> > >allocated);
> > -		if (!new_slot)
> > -			v->allocated +=3D VECTOR_DEFAULT_SIZE;
> > -		else
> > +		new_slot =3D realloc(v->slot, sizeof(void *) *
> > allocated);
> > +		if (new_slot) {
> > =C2=A0			v->slot =3D new_slot;
> > +			v->allocated =3D allocated;
> > +		}
>=20
> Actually, now that I think about this a bit more, I don't think that
> this was ever the right thing to do. If the realloc() fails, I see no
> harm in keeping the smaller v->allocated value. Future realloc()s and
> free()s will still work correctly. On the other hand, if we restore
> the
> old, larger v->allocated value (or with your code, never reduce it in
> the first place) there will be a duplicate value on the list, which I
> can definitely see causing problems.

This is a fundamental problem of our vector implementation, IMO. We
don't distinguish between "allocated" and "used", or IOW, we use the
term "allocated" while we mean "used".

My thinking was that "allocated" should track the actual size of the
allocated memory. But you are right, it's better to have the C library
track the allocated size and keep in mind that v->allocated actually
has the semantics of "used".

I'll send a v2 with this change.

Regards
Martin

PS: I've wanted to improve the vector implementation for years.
IMO we should separate "allocated" and "used", and should cease
reallocating the vectors whenever an element is added or removed, which
is horribly inefficient. I'd actually started working on that a while
ago but didn't finish. Anyway, that's future material.

