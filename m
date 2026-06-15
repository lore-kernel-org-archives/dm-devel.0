Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8593F8256
	for <dm-devel@lists.linux.dev>; Mon, 15 Jun 2026 15:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781537598; cv=none; b=Q56xHm5gu/WAnjWZKutp6StvzgwvD4pOEk9/u32v8JtHqqm5saeMFSiAXSXsdR4rB89wYM+SWyghsN4XwMlZDl+zFmK0+pDpN8esV13eN8pY+YZ9zsKexmGCBWydEQPt8kR5juYtzLWeFYpildh68vdjLRlv1RRYrX1sXuuLoOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781537598; c=relaxed/simple;
	bh=Q+TLT/HNVldFhWbaCLb/OJSjEvXAnDpkER+pSogagj0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GruB2qqZRJDAsWakE3f/48lWDkBI1MMtIPTQiVgJAXedqTrReRcanSIY4CdaLDZDEBKra9xn1KEmqaTfey0UEvYXp2r0WuQ7ARpVN1zgn9UgYPwnixaJmfAh4TSd1iU0DNh6Qkpq702eB5HQIRAG3wy+nUk/N/u8QOUGyoT55bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=pb56YmME; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=PEVryuMO; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="pb56YmME";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="PEVryuMO"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D9AE175A46;
	Mon, 15 Jun 2026 15:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781537595; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q+TLT/HNVldFhWbaCLb/OJSjEvXAnDpkER+pSogagj0=;
	b=pb56YmMEY8kDmzr9IYy4oGgo/GVgM+2MZGs3+peyQWDX4gulq/aiwzgOA5klQmY0J9zvV1
	si6o9mo1fdc5iVjIN1K0H5zowSWEeun2GszLc/I2zafnfPxhuxpto/S7JT1UFoioEKAosU
	ODR8u9dKIXlo1GYpMnTWl6ijv+ojWwk=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=PEVryuMO
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781537594; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q+TLT/HNVldFhWbaCLb/OJSjEvXAnDpkER+pSogagj0=;
	b=PEVryuMOKRPDQYCeadeDMNdvr8nMa6qNrKiR5zWwyIeU+yh+rcR0keqJDEYaR8C62SIInO
	1Jyl4d3CyYR5D0vGXg9anEbUL/nAZZ1adfyZKzrQAWqYh+lX9j3vZ8DQ8Jtq1OUfgRLXPf
	rvQAQqaL5ZEIHMADkpL+p8ZeeWkSOR8=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B8667779A7;
	Mon, 15 Jun 2026 15:33:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1nXkKzobMGqQLgAAD6G6ig
	(envelope-from <mwilck@suse.com>); Mon, 15 Jun 2026 15:33:14 +0000
Message-ID: <0bcbaafbdf29d49d92418b6fb5d5b6aaeaed28dc.camel@suse.com>
Subject: Re: [PATCH 1/3] multipath-tools: delete obsolete information from
 multipath.conf.5
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, DM_DEVEL-ML <dm-devel@lists.linux.dev>
Date: Mon, 15 Jun 2026 17:33:14 +0200
In-Reply-To: <ajASrXKCvccL7g65@redhat.com>
References: <20260607103831.336833-1-xose.vazquez@gmail.com>
	 <20260607103831.336833-2-xose.vazquez@gmail.com>
	 <562d0c52ef13cfc1f8dec3c59b05b56304ce2c02.camel@suse.com>
	 <ajASrXKCvccL7g65@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: D9AE175A46
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,opensvc.com,lists.linux.dev];
	DKIM_TRACE(0.00)[suse.com:+];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On Mon, 2026-06-15 at 10:56 -0400, Benjamin Marzinski wrote:
> On Mon, Jun 15, 2026 at 11:11:07AM +0200, Martin Wilck wrote:
> > On Sun, 2026-06-07 at 12:38 +0200, Xose Vazquez Perez wrote:
> > > repeat_count (rr_min_io, rr_min_io_rq, rr_weight) has been
> > > unsupported
> > > since kernel 4.6 ( commits 90a4323ccfea and=C2=A0 21136f89d76d ).
> > >=20
> >=20
> > I can't make up my mind on this patch. It is true that most path
> > selectors in the kernel have ignored the repeat_count argument
> > for a long time (historical_service_time still seems to honour it).
> >=20
> > But this is multipath-tools. _We_ still have quite a bit of code
> > for
> > handling the minio and weight settings. We should add a hint the
> > the
> > man page that these settings are ignored by modern kernels, but it
> > would be simply wrong to say that _our_ code ignores them while it
> > doesn't.=20
> >=20
> > We can decide to remove this functionality from multipath-tools,
> > which
> > would obviously mean removing it from the man page as well. But if
> > we
> > do, we should apply further cleanups. I suppose that providing the
> > "weightedpath" prioritizer makes no sense if we have no path
> > selector
> > algorithm that takes such weights into account, for example.
> >=20
> > I should also note that there have been discussions with some
> > partners
> > about re-introducing parameterized path selectors. This was a topic
> > in=20
> > the context of Fibre Channel FPIN notifications: FPINs can be used
> > by
> > FC fabric to notify hosts about overloaded paths. With a
> > parameterized
> > path selector, the load on such paths could be decreased by
> > multipathd.
> > temporarily until the situation is normal again. While there has
> > been
> > little progress in this area, I don't consider it cast in stone
> > that
> > the kernel will keep ignoring path selector parameters forever, or
> > IOW,
> > that there won't be new path selectors in the future that do accept
> > path parameters again.
> >=20
> > No doubt that the way these parameters are interpreted in different
> > ways ("minio" vs. "weight" vs "repeat_count") and the way this is
> > exposed to end users in the configuration file and in the man page
> > is
> > broken and confusing. But fixing that would be a larger effort.
>=20
> I actually do have a patch set I'm testing that rips out the
> rr_weight
> and rr_min_io_rq code completely. It leaves the rr_min_io
> functionality
> (on the grounds that we many have a use for it later), but it now
> defaults to 1 and is deprecated, so it can't be changed. I assume
> that
> even if this code gets reused in the future, rr_min_io will remain a
> bad name for the option.

That would be a welcome addition to Xose's set, then.

> I feel like the weightedpath priortizer shouldn't be effected by
> this.
> It is still useful to manually assign paths to path_groups when
> combined
> with group_by_prio.

I see that it's possible. Assigning weights only as sort of a sort key
for path grouping appears somewhat non-obvious and over-complicated to
me. But fair enough, some people may use it this way indeed.

Martin
