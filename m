Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0549C2D6E75
	for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 08:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766131744; cv=none; b=hkDISSPYMO+27g6pZuqcONao8wa1N+BouofsnXYXs1RhAkBkHJ5wNEUaZ22dKz19GrwzzxlispWwYc0eJjSJX8P2aPF3AGjwYpBJDgud12y9c48iuUDBnhZHC3ACeCPkDlh6+j65zC+9cV3L+8kcdRjQsoBnx8bO2kJywTiSKmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766131744; c=relaxed/simple;
	bh=9olMn9z//NXmo3YeWjRP3mV8DFp3BL8CbdKaKMeh+Mc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jGd31ZHrXjO7kwdGsLvikAo0OLyt7zwkt2FAxzXizTGMFO3OGjXefXO528LsQ8UNK4DIBxvhrd1Q8MS0KNoxYNQv4QmCQk4ZyE6+G8qeXborFP6bYrWk2MvD2xkI0Oye9YpOlxJfFOD7RzNDpGXvIRQBu+zSOB/vFZK7q5RHy0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=jGYtb3Zt; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Q5DZivtY; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="jGYtb3Zt";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Q5DZivtY"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BCCCD5BD14;
	Fri, 19 Dec 2025 08:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1766131738; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sLjRr8U88yDLaS8hOjvhBQkVOU++bUbYEdC+LDYcVBg=;
	b=jGYtb3Zti+Cef9vErcrBN7DHuwS7dGPlgQK3RqtxUQqVi0SfbUYD8P+mkUhwJrg1BLN50j
	MBpzVmD2v0ZrH3YIn+JRDNoyOWMGZS6+T70bpUHiFTwKBGKIK7ueAv7v1BO/WbNVVBMpho
	hUdduLlACt+yjfVbEW48FfMLtEEmoC4=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=Q5DZivtY
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1766131737; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sLjRr8U88yDLaS8hOjvhBQkVOU++bUbYEdC+LDYcVBg=;
	b=Q5DZivtYZC/PlJMN6aPnGST5Em2SRh2vb++UP70L6zgBCnRtsSYDkFloXop2uXpLFodedB
	rll6aA9IvSL3HUVH6oEsUF0BIEkEn2xYNEb6g61uCe1Rok/gD8ZkALL2tpzRcvnjAoWbgo
	ZXTjf15Yy+TJDlgEroyp54ZEkXiBObs=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9DF5C3EA63;
	Fri, 19 Dec 2025 08:08:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6GsVJRkIRWnIcwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Fri, 19 Dec 2025 08:08:57 +0000
Message-ID: <e0238bedbf5d4c54b46e261137ed5127ee234e0d.camel@suse.com>
Subject: Re: [PATCH 17/21] libmpathutil: use union for bitfield
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, 
	dm-devel@lists.linux.dev
Date: Fri, 19 Dec 2025 09:08:57 +0100
In-Reply-To: <aUSZmCKh12TEqq86@redhat.com>
References: <20251217212113.234959-1-mwilck@suse.com>
	 <20251217212113.234959-18-mwilck@suse.com> <aUSZmCKh12TEqq86@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Rspamd-Queue-Id: BCCCD5BD14
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:mid,suse.com:dkim,suse.com:email];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Level: 

On Thu, 2025-12-18 at 19:17 -0500, Benjamin Marzinski wrote:
> On Wed, Dec 17, 2025 at 10:21:09PM +0100, Martin Wilck wrote:
> > The macro BITFIELD used a cast of a pointer to a different
> > anonymous struct
> > to (struct bitfield *). This violates strict aliasing rules,
> > because the
> > two structs aren't compatible types in the sense of the language
> > specification. With -O2, gcc 15.1 generates code that makes th
> > pgcmp()
> > function fail, because the compiler doesn't initialize bf->len aka
> > __storage_for__bf.len to 64.
> >=20
> > The problem will show through error messages like this:
> >=20
> > multipathd[1974208]: is_bit_set_in_bitfield: bitfield overflow: 1
> > >=3D 0
> >=20
> > Fix this by using a union
> >=20
> > Fixes: 9a2f173 ("libmpathutil: change STATIC_BITFIELD to BITFIELD")
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> > =C2=A0libmpathutil/util.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 8=
 ++++----
> > =C2=A0libmpathutil/util.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 41 ++++=
+++++++++++++++++++------------
> > ----
> > =C2=A0libmultipath/configure.c=C2=A0 |=C2=A0 4 ++--
> > =C2=A0libmultipath/pgpolicies.c |=C2=A0 2 +-
> > =C2=A0tests/util.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 10 +++++-----
> > =C2=A05 files changed, 36 insertions(+), 29 deletions(-)
> >=20
> > diff --git a/libmpathutil/util.c b/libmpathutil/util.c
> > index 37412c6..5e45750 100644
> > --- a/libmpathutil/util.c
> > +++ b/libmpathutil/util.c
> > */
> > +#define BITFIELD(name,
> > length)						\
> > +	union bitfield __storage_for__ ## name =3D
> > {			\
> > +		.__bits =3D { 0
> > },					\
> > +		.__len =3D
> > (length),					\
> > =C2=A0	}; \
>=20
> It looks like this only allocates one bitfield_t, regardless of
> length.
> Am I missing something here?

Hm, yes. While this is kind of intentional, the code is confusing. The
whole BITFIELD thing is a mess. Given that it's only used in two lines,
I guess I might as well just remove it.

Martin
