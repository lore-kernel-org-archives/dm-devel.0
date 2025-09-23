Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 890AB24BCF5
	for <dm-devel@lists.linux.dev>; Tue, 23 Sep 2025 06:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758608581; cv=none; b=k0eIGM74OMsQ1EOq0GEa2HQkgEG9nudul0x4EJVODKuNWwS4js3eXMnBeMlf3A3lWil2FvEMXofXaHr+YjXo5fipPsZHQRnNKqriPJY24KI44L1dRftj+B3m1lePYXbhJx+rBwIw+1OEk5HC09Eh0zS8+RVrxmPhrsq5uk3QsjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758608581; c=relaxed/simple;
	bh=fMi7hsngE2kZ+uO4L0o1knf8YHMpnNssl1ykXAbkz54=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ur3OE7tCF19gb8384IK2hYd8URjBIBUizpb4Z87Q4QoY3C5Rhi9r/p/h8+ZtySu5ViAnM5PFUutApXEhiFg0JByU2F9DN2OGb47wSNPKhzSnBnB/2xaLgaY8Jj1aQTyfaNQj+1jgoAf6DoAUIw5QYwl19XDsx8UrR8EbrLObDUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=FvfZUN0V; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=FvfZUN0V; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="FvfZUN0V";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="FvfZUN0V"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 953E422212;
	Tue, 23 Sep 2025 06:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1758608577; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dACowttJeszSH/vXCOoxVBSqR40G7prCx2P9TkQNmdA=;
	b=FvfZUN0VciVJcF5FPNKxf3WDYj3zLWmNuGrb92eDXlQXy2urHDfLQbvbV4V+GEX9aKk7P5
	u/POU4mAVL46s0VlVAyJCE/fWBYn2qTlBafrQdS7gjd62voyfyTwyqjnkUGgVJkZgNWmpr
	hC3EnUbtjIKT9mNgkplkReR8SRVd2G4=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=FvfZUN0V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1758608577; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dACowttJeszSH/vXCOoxVBSqR40G7prCx2P9TkQNmdA=;
	b=FvfZUN0VciVJcF5FPNKxf3WDYj3zLWmNuGrb92eDXlQXy2urHDfLQbvbV4V+GEX9aKk7P5
	u/POU4mAVL46s0VlVAyJCE/fWBYn2qTlBafrQdS7gjd62voyfyTwyqjnkUGgVJkZgNWmpr
	hC3EnUbtjIKT9mNgkplkReR8SRVd2G4=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 76E14132C9;
	Tue, 23 Sep 2025 06:22:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id I3rzG8E80mjqGAAAD6G6ig
	(envelope-from <mwilck@suse.com>); Tue, 23 Sep 2025 06:22:57 +0000
Message-ID: <35c05d07d399fd56f1baa4c30c7a3447fef2d9fd.camel@suse.com>
Subject: Re: [PATCH 1/3] multipath-tools: add Acronis Cyber Infrastructure
 to hwtable
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Xose Vazquez Perez
	 <xose.vazquez@gmail.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, DM_DEVEL-ML
	 <dm-devel@lists.linux.dev>
Date: Tue, 23 Sep 2025 08:22:56 +0200
In-Reply-To: <c5f6f6b7957683f0d4a73d9162d05ab31b16e080.camel@suse.com>
References: <20250910194205.145919-1-xose.vazquez@gmail.com>
		 <20250910194205.145919-2-xose.vazquez@gmail.com>
		 <aMMNV-_0nX0gOdXM@redhat.com>
	 <c5f6f6b7957683f0d4a73d9162d05ab31b16e080.camel@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 953E422212
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_DN_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FREEMAIL_TO(0.00)[redhat.com,gmail.com];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_COUNT_TWO(0.00)[2];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim,suse.com:mid,suse.com:email]
X-Spam-Score: -3.01

On Mon, 2025-09-22 at 20:38 +0200, Martin Wilck wrote:
> On Thu, 2025-09-11 at 13:56 -0400, Benjamin Marzinski wrote:
> > On Wed, Sep 10, 2025 at 09:41:57PM +0200, Xose Vazquez Perez wrote:
> > > Source:
> > > https://dl.acronis.com/u/software-defined/html/AcronisCyberInfrastruc=
ture_3_5_users_guide_en-US/accessing-iscsi/accessing-iscsi-targets-from-lin=
ux.html
> > >=20
> > > Cc: Martin Wilck <mwilck@suse.com>
> > > Cc: Benjamin Marzinski <bmarzins@redhat.com>
> > > Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> > > Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
> > > Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> > > ---
> > > =C2=A0libmultipath/hwtable.c | 15 +++++++++++++++
> > > =C2=A01 file changed, 15 insertions(+)
> > >=20
> > > diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> > > index 1a78c36d..12e10577 100644
> > > --- a/libmultipath/hwtable.c
> > > +++ b/libmultipath/hwtable.c
> > > @@ -1371,6 +1371,21 @@ static struct hwentry default_hw[] =3D {
> > > =C2=A0		.pgpolicy=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D GROUP_BY_SERIAL,
> > > =C2=A0		.no_path_retry =3D 30,
> > > =C2=A0	},
> > > +	/*
> > > +	 * Acronis
> > > +	 */
> > > +	{
> > > +		// Cyber Infrastructure
> > > +		.vendor=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D "VSTORAGE",
> > > +		.product=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D "VSTOR-DISK",
> > > +		.prio_name=C2=A0=C2=A0=C2=A0=C2=A0 =3D PRIO_ALUA,
> > > +		.pgpolicy=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D GROUP_BY_NODE_NAME,
> > > +		.detect_prio=C2=A0=C2=A0 =3D DETECT_PRIO_OFF,
> > > +		.features=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D "2 pg_init_retries 50"=
,
> > > +		.pgfailback=C2=A0=C2=A0=C2=A0 =3D -FAILBACK_FOLLOWOVER,
> >=20
> > I'm not sure about the pgfailback setting. the FAILBACK_FOLLOWOVER
> > mode
> > is not something that is really needed for a specific array type.
> > It
> > works like FAILOVER_IMMEDIATE, but it's designed to work so that if
> > multiple nodes are using the same multipath device, and one of them
> > loses access to the highest priority pathgroup but the others
> > don't,
> > multipath won't keep switching pathgroups back and forth. The nodes
> > that
> > can see the higher priority pathgroup won't automatically switch
> > back
> > to
> > it, since they weren't the ones that switched away from it. So the
> > setting is more for a specific use case, and not a specific array
> > type.
> >=20
> > On the other hand, it is what the vendor tested, and with a single
> > machine accessing the multipath device, you usually only switch
> > away
> > from the highest priority pathgroup because you lost access to all
> > the
> > paths in it.
>=20
> Not necessarily. path_group_prio_update() calculates the average of
> the
> path priorities in the group. With ALUA and groups of 6+ paths, an
> optimized group with one healthy path will have a lower prio (8) than
> a
> non-optimized group with all healthy paths (10). In such a case it
> could happen that multipathd switches to the non-optimized group and
> never switches back.

Sorry, this example was incorrect. Only paths in UP or GHOST states are
counted in for the PG prio.=C2=A0In this example the optimized group would
still have p =3D 50, and what I described would not occur.

The example would be correct if the 5 non-"healthy" paths in the first
PG were in standby aka GHOST state (resulting in p =3D 55 / 6 =3D 9). But
that's a very different scenario, and highly theoretical.

> I would suggest setting FAILBACK_IMMEDIATE instead. It's well
> documented that FOLLOWOVER is only for cluster environments.

Despite the wrong example, I still think FAILBACK_IMMEDIATE makes
more sense as a general default. We can add a comment about the vendor
recommendations.

Martin
