Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C80342C9D
	for <dm-devel@lists.linux.dev>; Tue,  6 Jan 2026 10:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767695483; cv=none; b=TqUQcmwfosiA2+PyffjPMboYufEkqk38m7SmDJwQU4VTODBSKqRxpw1FHdq5FG9GMwN6P8NYhv7UKnlpyjRZ8VNTrnKLgZYmS/SeneVhP+HW+YPLjSL6ckAteErR+TzA4QVeG65kVSWez4B1EEm1KfIJPuC5vDs/Au1qM3lcBWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767695483; c=relaxed/simple;
	bh=KRuJG//E0rvlhOSjXqtG9eDJZS9LylP/h66a/Hf0+uA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kNSWHq+8boZy3lL+a4AhlaSGFFHvVj56oW3HjFiTgLWXAbuvuNtvN8Zip7PfIm0GoHaZP+jR716u/s77HIGqyN5gikE5gXYu9b14FPnatrTTbS0VduG3UOp1exIS5dsOGnyYGrwHXcrdC+buieUS7qfiT6oML3M2jDsRvh5zCQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ZTgET/a/; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ZTgET/a/; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ZTgET/a/";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ZTgET/a/"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5C1F65BCC3;
	Tue,  6 Jan 2026 10:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1767695479; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=olheXERRRA+slhc+DLPgvqrmxffKsTZayuPpkOXmTpM=;
	b=ZTgET/a/8BZc2ZOQaZcya7IDqh0b9No8DZP3Wdk4/X8OTl2qDxVW/KQgAVwEARJWw+92KC
	BKRjY8OUEXvg2VRzAFNBZO6MuKmPqIFo1DSCuQoHwjFSPtB1+ARcYlAOz6swYHKnrZWY4L
	HSm8aWTOMIJatGYLqTO0Ryt9rVsDURA=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1767695479; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=olheXERRRA+slhc+DLPgvqrmxffKsTZayuPpkOXmTpM=;
	b=ZTgET/a/8BZc2ZOQaZcya7IDqh0b9No8DZP3Wdk4/X8OTl2qDxVW/KQgAVwEARJWw+92KC
	BKRjY8OUEXvg2VRzAFNBZO6MuKmPqIFo1DSCuQoHwjFSPtB1+ARcYlAOz6swYHKnrZWY4L
	HSm8aWTOMIJatGYLqTO0Ryt9rVsDURA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 379E03EA63;
	Tue,  6 Jan 2026 10:31:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uKPlC3fkXGkEIQAAD6G6ig
	(envelope-from <mwilck@suse.com>); Tue, 06 Jan 2026 10:31:19 +0000
Message-ID: <0a89de25ab451995aee9af8745627cf14c00cdca.camel@suse.com>
Subject: Re: [PATCH v2 14/26] multipathd: add_map_without_path(): orphan
 paths instead of freeing them
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, 
	dm-devel@lists.linux.dev, Benjamin Marzinski <bmarzins@suse.com>
Date: Tue, 06 Jan 2026 11:31:18 +0100
In-Reply-To: <aVxGoTt8zHbnmGXI@redhat.com>
References: <20251219144108.237928-1-mwilck@suse.com>
	 <20251219144108.237928-15-mwilck@suse.com> <aUYkuzmyuntUhEvk@redhat.com>
	 <f74331bcf74067f85a8836e014d322eccf2995ed.camel@suse.com>
	 <aVxGoTt8zHbnmGXI@redhat.com>
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
X-Spam-Score: -4.26
X-Spam-Level: 
X-Spamd-Result: default: False [-4.26 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.16)[-0.804];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid]

On Mon, 2026-01-05 at 18:17 -0500, Benjamin Marzinski wrote:
> On Mon, Jan 05, 2026 at 04:15:37PM +0100, Martin Wilck wrote:
> > On Fri, 2025-12-19 at 23:23 -0500, Benjamin Marzinski wrote:
> > > On Fri, Dec 19, 2025 at 03:40:56PM +0100, Martin Wilck wrote:
> > > > If add_map_without_path() fails to set up the multipath data
> > > > structures,
> > > > don't free the paths associated with the map as
> > > > cleanup_multipath_and_paths() would; just orphan the paths.
> > > > update_pathvec_from_dm() will handle the paths and see if they
> > > > need to be removed.
> > > >=20
> > > > Suggested-by: Benjamin Marzinski <bmarzins@suse.com>
> > > > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > > > ---
> > > > =C2=A0multipathd/main.c | 12 +++++++-----
> > > > =C2=A01 file changed, 7 insertions(+), 5 deletions(-)
> > > >=20
> > > > diff --git a/multipathd/main.c b/multipathd/main.c
> > > > index c03546b..7b522e8 100644
> > > > --- a/multipathd/main.c
> > > > +++ b/multipathd/main.c
> > > > @@ -771,8 +771,8 @@ fail:
> > > > =C2=A0
> > > > =C2=A0static int add_map_without_path (struct vectors *vecs, const
> > > > char
> > > > *alias)
> > > > =C2=A0{
> > > > -	struct multipath
> > > > __attribute__((cleanup(cleanup_multipath_and_paths)))
> > > > -		*mpp =3D alloc_multipath();
> > > > +	struct multipath
> > > > __attribute__((cleanup(cleanup_multipath))) *mpp =3D
> > > > +		alloc_multipath();
> > > > =C2=A0	char __attribute__((cleanup(cleanup_charp))) *params =3D
> > > > NULL;
> > > > =C2=A0	char __attribute__((cleanup(cleanup_charp))) *status =3D
> > > > NULL;
> > > > =C2=A0	struct config *conf;
> > > > @@ -802,11 +802,13 @@ static int add_map_without_path (struct
> > > > vectors *vecs, const char *alias)
> > > > =C2=A0	mpp->mpe =3D find_mpe(conf->mptable, mpp->wwid);
> > > > =C2=A0	put_multipath_config(conf);
> > > > =C2=A0
> > > > -	if ((rc =3D update_multipath_table__(mpp, vecs->pathvec,
> > > > 0,
> > > > params, status)) !=3D DMP_OK)
> > > > +	if (update_multipath_table__(mpp, vecs->pathvec, 0,
> > > > params, status) !=3D DMP_OK ||
> > > > +	=C2=A0=C2=A0=C2=A0 !vector_alloc_slot(vecs->mpvec)) {
> > > > +		orphan_paths(vecs->pathvec, mpp, "failed to
> > > > add
> > > > map");
> > > > =C2=A0		return DMP_ERR;
> > >=20
> > > I'm not sure we should just call orphan_paths() after we call
> > > update_multipath_table__(). If we hit a cancellation point in the
> > > middle
> > > of update_multipath_table__(), we want to fully orphan any paths
> > > that
> > > got added to the device before we cancelled.=C2=A0=C2=A0
> >=20
> > Sorry, I don't understand.
> >=20
> > The __attribute__((cleanup())) functions don't protect against
> > thread
> > cancellation. If we want to achieve what you describe, we must add
> > a
> > pthread_cleanup_push()/pop() pair around the
> > update_multipath_table__()
> > call.
>=20
> I'm pretty sure they do run during cancellation after I added
> ca957f2a
> ("multipath-tools: Makefile.inc: compile with -fexceptions").

Right, I forgot about that, sorry. Re-reading the docs, I'd like
to double-check if this is really guaranteed.

I think we should get rid of cancellation for our long-running threads.
Later ;-)

> > But would that buy us anything? update_multipath_table__() only
> > manipulates multipathd's internal data structures, which, if a
> > cancellation happens, will almost immediately all be freed anyway.
> > What
> > harm would be done if these paths weren't orphaned in such a case?
> > Yes,
> > the some paths might now link to a non-existing struct multipath.
> > I'd
> > see your point if we accessed pp->mpp in the path-freeing code
> > path,
> > but we don't do this any more.
>=20
> We check whether pp->mpp is set in lots of places in the code to
> decide
> what to do with the paths. But you are correct that we don't ever
> call
> add_map_without_path() from a thread that can be cancelled and have
> multipathd continue running, and we aren't likely to do so.

Yes, this was my thinking. I didn't write it explicitly. The function
is only called from the uevent_dispatch thread, which is cancelled if
and only if multipathd exits.

However, you are right that this isn't clean. What actually need=C2=A0
here is remove_map(), which does exactly what we want, AFAICS.
But I'll give the struct-multipath-freeing code another review.

Regards
Martin
