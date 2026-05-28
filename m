Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D14D3502A8
	for <dm-devel@lists.linux.dev>; Thu, 28 May 2026 07:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779954630; cv=none; b=L8r54WwfHGP3TJi5rF6dzWlWnsq0Tjcg2I2SN5Wp4bYtqvXJIyQha1gwfM1uR5+LNfZXFBElvhXKD3gbDqExJv1+I/TPIJskglM7qpwNtsmUXZdD8EGGv/1OGeJXwAUs1LVB08DpsNpaMK+VZ3ODoDmTRRiqrmniGN87cT6laf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779954630; c=relaxed/simple;
	bh=VuzwQ3dBA1gslPmvZ+boBf5lXL/nghx7BCb2pSPKnEo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=S/FEIIWhozEvifahkaW8LFPusE3Ep0KPzm5QmzTHCwIIhHqYeU+9KgQ2l7kU6IhHWgKedahlT5VBSaEx9s8XHtHtY5UB0LwbJ1XHoXGigMXzHznYGJre3H3HR55wBhqg3akV48DxeNTXhI85kDyMX7MzNtMfSKQ881g+QVfx4nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Qh5M9Tzl; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=u7mE35YY; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Qh5M9Tzl";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="u7mE35YY"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8B9D46AEF5;
	Thu, 28 May 2026 07:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779954627; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8d8zsbWMUv9uaZ6qEGlE1/xHqLtKrowr0HGHRukXozg=;
	b=Qh5M9TzlBwLjaPpiD/FKGVOF6RHrg3x31MkTa9NTZ3nn0YZGEzRUNvzgTkja6NZQ+/rzfW
	T5F6A/cTT1gjYoxu+GbFrhWEiK8VF+v2ekivEX9LyXeJfHmd0jhvxjrzRfewC+LEBvNMpQ
	jyyBPdlmobh23dPh2WrCWGk82HMKCs4=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=u7mE35YY
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779954626; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8d8zsbWMUv9uaZ6qEGlE1/xHqLtKrowr0HGHRukXozg=;
	b=u7mE35YYEjp13sePDwAvs4qIOeFs4/oM+99omlQxPOnHZ/sthsYALuW5I1TTx9sMLR2pJR
	meghr0N90rMYUHrrodeZBuMb6xTrj8IrcaLvui49fOQOI/39n7aBI84B/jnMGl35ZNhDSi
	d9VRqn2Q3HPPENjnOEH2qofznlouj1E=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 65C525AC95;
	Thu, 28 May 2026 07:50:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7Ya2F8LzF2oSYwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Thu, 28 May 2026 07:50:26 +0000
Message-ID: <1c061e532328360a407d4649b256f2d3695ef08e.camel@suse.com>
Subject: Re: [PATCH v2 04/19] libmpathutil: add implementation of generic
 shared pointer
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, Brian Bunker
	 <brian@purestorage.com>, dm-devel@lists.linux.dev, Xose Vazquez Perez
	 <xose.vazquez@gmail.com>
Date: Thu, 28 May 2026 09:50:25 +0200
In-Reply-To: <ahd7Xcfe3alqjROA@redhat.com>
References: <20260522164415.846589-1-mwilck@suse.com>
	 <20260522164415.846589-5-mwilck@suse.com> <ahd7Xcfe3alqjROA@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 8B9D46AEF5
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
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[opensvc.com,purestorage.com,lists.linux.dev,gmail.com];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	TAGGED_RCPT(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim,suse.com:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -3.01

On Wed, 2026-05-27 at 19:16 -0400, Benjamin Marzinski wrote:
> On Fri, May 22, 2026 at 06:44:00PM +0200, Martin Wilck wrote:
> > Add a set of simple functions to handle refcounted pointers.
> >=20
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> > =C2=A0libmpathutil/libmpathutil.version |=C2=A0 7 +++++
> > =C2=A0libmpathutil/util.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 45
> > ++++++++++++++++++++++++++++---
> > =C2=A0libmpathutil/util.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 5 ++++
> > =C2=A03 files changed, 53 insertions(+), 4 deletions(-)
> >=20
> > diff --git a/libmpathutil/util.c b/libmpathutil/util.c
> > index 23a9797..3c623ec 100644
> > --- a/libmpathutil/util.c
> > +++ b/libmpathutil/util.c
> > @@ -384,3 +382,42 @@ void cleanup_udev_device(struct udev_device
> > **udd)
> > =C2=A0	if (*udd)
> > =C2=A0		udev_device_unref(*udd);
> > =C2=A0}
> > +
> > +struct shared_ptr {
> > +	long refcnt;
> > +	void (*destructor)(void *);
> > +	char __attribute__((aligned(sizeof(void *)))) ptr[];
> > +};
> > +
> > +void *alloc_shared_ptr(size_t size, void (*destructor)(void *))
> > +{
> > +	struct shared_ptr *sp =3D malloc(sizeof(*sp) + size);
> > +
> > +	if (!sp)
> > +		return NULL;
> > +	uatomic_set(&sp->refcnt, 1);
> > +	sp->destructor =3D destructor;
> > +	return sp->ptr;
> > +}
> > +
> > +void get_shared_ptr(void *ptr)
> > +{
>=20
> We should probably return here if ptr is NULL, like we do in
> put_shared_ptr(). Alternatively, this might be a reasonable place for
> an
> assert(), since nobody should be calling these with NULL pointers.

That makes sense. I'll add an assert(), and change put_shared_ptr()
accordingly.

Martin
