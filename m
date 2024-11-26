Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B056FBF
	for <dm-devel@lists.linux.dev>; Tue, 26 Nov 2024 11:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732619542; cv=none; b=bQ9/R0BELOMq4qBqXBAmI6NpeeLJdL0Y5gXjGRBK6Kd2qd/5C/BBx4getHAbGcQfcHOypTH52/rG8JcjfbtbKk45RNvGAV6Q0Sv2DOJ03kQlNNT7ryDiby21gjkp5WXjASXjSYjDASjieK0nNJAtcPNZtfkM5FrhAOcCaHvNsSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732619542; c=relaxed/simple;
	bh=yIrUzTMmE21IpgCKGI8syymkoMnmt69ylD5pLS0LJWk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MZoBhwzPeK9EVP3DQPkbKFZhRQ3dGLc924Xcswj4ZLjVZtESa5Ai6nJW0rANiRs4QBDQpzeeOt1Qaj65zi8kkDBrCby4a7Zma8OqKU8459Oc4F+78+9GKV/hqDoNMzee30iABNLG8U7X3mTX0hPkhGluan+eHtv0kdAdfgP+5Nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Lkt79Dn2; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Lkt79Dn2; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Lkt79Dn2";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Lkt79Dn2"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 76DCA21158;
	Tue, 26 Nov 2024 11:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1732619537; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yIrUzTMmE21IpgCKGI8syymkoMnmt69ylD5pLS0LJWk=;
	b=Lkt79Dn2sC0z6MR1tEJkwO0eO4BJa4cnmC7SyTt59aTfw62YYxG63F41kDf5X2u6nNZfD9
	aBjObLYBk89flxRAKMxEGa2sD74FkCV756K8nwF+3eD2OBvHtH3aDaCk3Gtr8tpKyd53fy
	xMmGsUOeVmn1SKSAn3qOyem4xaqL8BQ=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=Lkt79Dn2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1732619537; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yIrUzTMmE21IpgCKGI8syymkoMnmt69ylD5pLS0LJWk=;
	b=Lkt79Dn2sC0z6MR1tEJkwO0eO4BJa4cnmC7SyTt59aTfw62YYxG63F41kDf5X2u6nNZfD9
	aBjObLYBk89flxRAKMxEGa2sD74FkCV756K8nwF+3eD2OBvHtH3aDaCk3Gtr8tpKyd53fy
	xMmGsUOeVmn1SKSAn3qOyem4xaqL8BQ=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 50CC613890;
	Tue, 26 Nov 2024 11:12:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3H4hEhGtRWctNQAAD6G6ig
	(envelope-from <mwilck@suse.com>); Tue, 26 Nov 2024 11:12:17 +0000
Message-ID: <98e94d1f52967129b50d25d61f9d400531fff1dd.camel@suse.com>
Subject: Re: [PATCH 1/3] libmultipath: fix handling of pp->pgindex
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, 
	dm-devel@lists.linux.dev
Date: Tue, 26 Nov 2024 12:12:16 +0100
In-Reply-To: <Z0TeksRGcJ9k4cqx@redhat.com>
References: <20241125143224.51934-1-mwilck@suse.com>
	 <20241125143224.51934-2-mwilck@suse.com> <Z0TeksRGcJ9k4cqx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Rspamd-Queue-Id: 76DCA21158
X-Spam-Score: -4.51
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FROM_HAS_DN(0.00)[];
	URIBL_BLOCKED(0.00)[suse.com:mid,suse.com:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:mid,suse.com:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

On Mon, 2024-11-25 at 15:31 -0500, Benjamin Marzinski wrote:
> On Mon, Nov 25, 2024 at 03:32:22PM +0100, Martin Wilck wrote:
> > pp->pgindex is set in disassemble_map() when a map is parsed.
> > There are various possiblities for this index to become invalid.
> > pp->pgindex is only used in enable_group() and
> > followover_should_fallback(),
> > and both callers take no action if it is 0, which is the right
> > thing to do if we don't know the path's pathgroup.
> >=20
> > Make sure pp->pgindex is reset to 0 in various places:
> > - when it's orphaned,
> > - before (re)grouping paths,
> > - when we detect a bad mpp assignment in update_pathvec_from_dm().
> >=20
> > The hunk in group_paths is mostly redundant with the hunk in
> > free_pgvec(), but
> > because we're looping over pg->paths in the former and over pg->pgp
> > in
> > the latter, I think it's better too play safe.
>=20
> I'm not sure this will always fix issue #105. Perhaps I'm overlooking
> the connection in the code and this just needs a more explicit
> explanation to aid clueless reviewers, but here's what I don't get.
>=20
> As far as I can see, the only change here that would effect the
> reported
> issue is the change to update_pathvec_from_dm(). While I totally
> agree
> that if you have a path that appears to be two multipath devices, you
> can't trust pp->pgindex, I believe there's also another problem.
>=20
> Say you have a multipath device with two path groups (pgp1 and pgp2)
> each with one path (pp1 in pgp1 and pp2 in pgp2). In this case,
> pp1->pgindex =3D=3D 1 and pp2->pgindex =3D=3D 2. If update_pathvec_from_d=
m()
> discovers that pp1 is part of another multipath device, and removes
> it,
> that will mean that pgp1 is now empty, so update_pathvec_from_dm()
> will
> also remove that (at the delete_pg label).=C2=A0 But pp2->pgindex will
> still
> be set to 2 even though there's only one path group, so it will now
> point off the end of the pgp list. Right?

Right, thanks for pointing this out. If we delete a pg, we need to
invalidate all pgindex values for all paths in the map. We can't
decrement them, because they must match kernel indices (see below).

> At any rate, updating pgindex seems finicky and perhaps we should
> just
> drop it. It's not that much work to scan the path groups for the path
> in
> enable_group() and since we're already reading through the path
> groups
> in followover_should_failback(), we can just refactor the code a
> little
> bit to avoid needing pgindex at all.

I had similar thoughts, but I was looking for a minimal fix for the
0.11.0 release. Probably dropping pgindex for good is the right thing
to do, but is it 0.11.0 material?

We'd still have the problem that enable_group() et al. need a pgindex
value that matches the kernel configuration. We can only be sure that
this index is correct if disassemble_map() has just set it. Any change
we apply in multipathd's data structures won't match the kernel's view
of the map.

This problem is subtle, AFAICS. It's related to the fact that if
update_pathvec_from_dm() finds any inconsistencies, we *should* reload
the map, possibly multiple times, until these inconsistencies have been
resolved. But we can't do that in all code paths in which this function
is called (or at least, we haven't been able to prove that we can
without risking breakage).

I have vague ideas how this could be solved, but they would require a
major code restructuring.

Regards,
Martin

