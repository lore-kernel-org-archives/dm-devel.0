Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93179292B2E
	for <dm-devel@lists.linux.dev>; Mon,  5 Jan 2026 15:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767626141; cv=none; b=lQoLTXY7FhJfL/tdYtDDDU5+KhVW+dnYnE3ysjnO2u9asJdo/NWILmzCSI/vWmSLb3QbQt9uE1lpvDrVolPTllpx5GR2nxFkQ+UQQsIPsoyFhUScFWtRCejMXaG7VS4aE/J3X7QDG0rAuOxC+bhEdW9AOsBERO4jCLSadRO/U7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767626141; c=relaxed/simple;
	bh=FGknCfNeClZ2AsHV0yKiAvqy8XNsu2X/Ae+O6Jh7ubE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uOq1NyS6+MbILRqnPjfJ3PT+BxoGhu3Oq1EBQKfArshdNTjk+eATQJgidKyN3pJjsiw8DQ19V6fDyho6EgxF5qx0W0XgVQDDt+MPYI0DTXeD2i39M4mF3TijBCIxBChQQ7Ndchqgnm4uf5lb1EuitEUfSTMygRDhPO6UlfKXiZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=JZhBXmXD; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=JZhBXmXD; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="JZhBXmXD";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="JZhBXmXD"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C444C3371A;
	Mon,  5 Jan 2026 15:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1767626137; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DjNNz97w6KIG8kipo4TjOQfI59EoRB12AtCa3hsmsXA=;
	b=JZhBXmXD5fMFxUfiYT8GSNNKDBS3QueR1CGuAI5Uk/5qs2L1brOdjx0+YjL64wnvRTpKKC
	A1C+iUPzfgThFsENq6FXVa+lH4v3GcNpzTEWfY40agjAZfoGOzg9PjNIKihxrtwk3TdznV
	gpzj/M5WUE02TDVo17F+Bp0ttMd292I=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=JZhBXmXD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1767626137; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DjNNz97w6KIG8kipo4TjOQfI59EoRB12AtCa3hsmsXA=;
	b=JZhBXmXD5fMFxUfiYT8GSNNKDBS3QueR1CGuAI5Uk/5qs2L1brOdjx0+YjL64wnvRTpKKC
	A1C+iUPzfgThFsENq6FXVa+lH4v3GcNpzTEWfY40agjAZfoGOzg9PjNIKihxrtwk3TdznV
	gpzj/M5WUE02TDVo17F+Bp0ttMd292I=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A2BBD13964;
	Mon,  5 Jan 2026 15:15:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id orKpJpnVW2kwEQAAD6G6ig
	(envelope-from <mwilck@suse.com>); Mon, 05 Jan 2026 15:15:37 +0000
Message-ID: <f74331bcf74067f85a8836e014d322eccf2995ed.camel@suse.com>
Subject: Re: [PATCH v2 14/26] multipathd: add_map_without_path(): orphan
 paths instead of freeing them
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, 
	dm-devel@lists.linux.dev, Benjamin Marzinski <bmarzins@suse.com>
Date: Mon, 05 Jan 2026 16:15:37 +0100
In-Reply-To: <aUYkuzmyuntUhEvk@redhat.com>
References: <20251219144108.237928-1-mwilck@suse.com>
	 <20251219144108.237928-15-mwilck@suse.com> <aUYkuzmyuntUhEvk@redhat.com>
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
X-Rspamd-Queue-Id: C444C3371A
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Level: 

On Fri, 2025-12-19 at 23:23 -0500, Benjamin Marzinski wrote:
> On Fri, Dec 19, 2025 at 03:40:56PM +0100, Martin Wilck wrote:
> > If add_map_without_path() fails to set up the multipath data
> > structures,
> > don't free the paths associated with the map as
> > cleanup_multipath_and_paths() would; just orphan the paths.
> > update_pathvec_from_dm() will handle the paths and see if they
> > need to be removed.
> >=20
> > Suggested-by: Benjamin Marzinski <bmarzins@suse.com>
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> > =C2=A0multipathd/main.c | 12 +++++++-----
> > =C2=A01 file changed, 7 insertions(+), 5 deletions(-)
> >=20
> > diff --git a/multipathd/main.c b/multipathd/main.c
> > index c03546b..7b522e8 100644
> > --- a/multipathd/main.c
> > +++ b/multipathd/main.c
> > @@ -771,8 +771,8 @@ fail:
> > =C2=A0
> > =C2=A0static int add_map_without_path (struct vectors *vecs, const char
> > *alias)
> > =C2=A0{
> > -	struct multipath
> > __attribute__((cleanup(cleanup_multipath_and_paths)))
> > -		*mpp =3D alloc_multipath();
> > +	struct multipath
> > __attribute__((cleanup(cleanup_multipath))) *mpp =3D
> > +		alloc_multipath();
> > =C2=A0	char __attribute__((cleanup(cleanup_charp))) *params =3D
> > NULL;
> > =C2=A0	char __attribute__((cleanup(cleanup_charp))) *status =3D
> > NULL;
> > =C2=A0	struct config *conf;
> > @@ -802,11 +802,13 @@ static int add_map_without_path (struct
> > vectors *vecs, const char *alias)
> > =C2=A0	mpp->mpe =3D find_mpe(conf->mptable, mpp->wwid);
> > =C2=A0	put_multipath_config(conf);
> > =C2=A0
> > -	if ((rc =3D update_multipath_table__(mpp, vecs->pathvec, 0,
> > params, status)) !=3D DMP_OK)
> > +	if (update_multipath_table__(mpp, vecs->pathvec, 0,
> > params, status) !=3D DMP_OK ||
> > +	=C2=A0=C2=A0=C2=A0 !vector_alloc_slot(vecs->mpvec)) {
> > +		orphan_paths(vecs->pathvec, mpp, "failed to add
> > map");
> > =C2=A0		return DMP_ERR;
>=20
> I'm not sure we should just call orphan_paths() after we call
> update_multipath_table__(). If we hit a cancellation point in the
> middle
> of update_multipath_table__(), we want to fully orphan any paths that
> got added to the device before we cancelled.=C2=A0=C2=A0

Sorry, I don't understand.

The __attribute__((cleanup())) functions don't protect against thread
cancellation. If we want to achieve what you describe, we must add a
pthread_cleanup_push()/pop() pair around the update_multipath_table__()
call.

But would that buy us anything? update_multipath_table__() only
manipulates multipathd's internal data structures, which, if a
cancellation happens, will almost immediately all be freed anyway. What
harm would be done if these paths weren't orphaned in such a case? Yes,
the some paths might now link to a non-existing struct multipath. I'd
see your point if we accessed pp->mpp in the path-freeing code path,
but we don't do this any more.

> Perhaps the easiest way to
> solve this is to make cleanup_multipath_and_paths() loop through all
> the
> path in mpp->pg and orphan them before calling free_multipath().

Like I said above, that would have no effect in the case of
cancellation.

I can add pthread_cleanup_push()/pop() pair if you insist, but so far I
don't see the benefit.

Regards
Martin
