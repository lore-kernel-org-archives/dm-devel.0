Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F1E4315A
	for <dm-devel@lists.linux.dev>; Mon, 22 Sep 2025 18:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758566308; cv=none; b=WU23a8ha2QUTH6/qIzxjFpx+Ja2iB9X3/4W76fTkHxj4ou44eJsXCleIzFD0uJuOJL8BANH+IJLTKujit9baRk2B58zQ/DIetNbqbRFDMIXqvaam6JrLZ/Yic0ntdQUw9YIERbD5WKGEj/ZCGxgEPptr7GUR5X2wehOMYCs37HI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758566308; c=relaxed/simple;
	bh=WRYQ5I5irsGAeW2WbpT+hsJl7WyFRDyDulp9iEadMUc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZLfMpilsWezw1VIdv5OGZ/bU4myfVgpXUp4GrWJV02fjcF3Bur3u7teb6+XxHpAJ7BOh+vhHR5aZUVNakM15IInm9cvcWSambjPB3uPqmqlUjk0O7FH5Cm+PysJyQv7A80AFGuhGqHETAw/kNqqEWsMx5+0Pc4EqrpYS/e286z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=fxXHfPnL; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=PQvhi1Jy; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="fxXHfPnL";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="PQvhi1Jy"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E25B71F828;
	Mon, 22 Sep 2025 18:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1758566304; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/elph46VYiUsqKN06NKKBjFfP9BlyvchDxmF3n8m9G0=;
	b=fxXHfPnLd4ZGR9RAplBjpl2lcDsAiqXS/g9zj5G+b2o5Br7czZpHZ3x5IxZugLzhtVW921
	MQFhYswyC50obVmbhGQV/MOHRckB0qHTFKzIuq1iHkyPbjqDsMM42SnWePfNWQPPZ54Zn9
	1fRDw9jSjb9oWN44V/3lJ5pu5O7XDGs=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1758566303; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/elph46VYiUsqKN06NKKBjFfP9BlyvchDxmF3n8m9G0=;
	b=PQvhi1JyxLrS5MyvD7kbH7sOaGox5qthdyBadqSwu3gVjDyoF5vVhO7/h42lR+UKini7Xy
	GAsSw87nNGXS5EzVc9ct0TR0eLZ2j7hzHs3/m9J/If1g42eWuHGAjS7joUdeVFlq//dGlh
	xTgW3FNXs6vrmSmu/E/2DP89nt+Ec/A=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BE28D1388C;
	Mon, 22 Sep 2025 18:38:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id m4jTLJ+X0WggXQAAD6G6ig
	(envelope-from <mwilck@suse.com>); Mon, 22 Sep 2025 18:38:23 +0000
Message-ID: <c5f6f6b7957683f0d4a73d9162d05ab31b16e080.camel@suse.com>
Subject: Re: [PATCH 1/3] multipath-tools: add Acronis Cyber Infrastructure
 to hwtable
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Xose Vazquez Perez
	 <xose.vazquez@gmail.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, DM_DEVEL-ML
	 <dm-devel@lists.linux.dev>
Date: Mon, 22 Sep 2025 20:38:23 +0200
In-Reply-To: <aMMNV-_0nX0gOdXM@redhat.com>
References: <20250910194205.145919-1-xose.vazquez@gmail.com>
	 <20250910194205.145919-2-xose.vazquez@gmail.com>
	 <aMMNV-_0nX0gOdXM@redhat.com>
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
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_TO(0.00)[redhat.com,gmail.com];
	TAGGED_RCPT(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_DN_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid]
X-Spam-Flag: NO
X-Spam-Score: -2.80

On Thu, 2025-09-11 at 13:56 -0400, Benjamin Marzinski wrote:
> On Wed, Sep 10, 2025 at 09:41:57PM +0200, Xose Vazquez Perez wrote:
> > Source:
> > https://dl.acronis.com/u/software-defined/html/AcronisCyberInfrastructu=
re_3_5_users_guide_en-US/accessing-iscsi/accessing-iscsi-targets-from-linux=
.html
> >=20
> > Cc: Martin Wilck <mwilck@suse.com>
> > Cc: Benjamin Marzinski <bmarzins@redhat.com>
> > Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> > Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
> > Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> > ---
> > =C2=A0libmultipath/hwtable.c | 15 +++++++++++++++
> > =C2=A01 file changed, 15 insertions(+)
> >=20
> > diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> > index 1a78c36d..12e10577 100644
> > --- a/libmultipath/hwtable.c
> > +++ b/libmultipath/hwtable.c
> > @@ -1371,6 +1371,21 @@ static struct hwentry default_hw[] =3D {
> > =C2=A0		.pgpolicy=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D GROUP_BY_SERIAL,
> > =C2=A0		.no_path_retry =3D 30,
> > =C2=A0	},
> > +	/*
> > +	 * Acronis
> > +	 */
> > +	{
> > +		// Cyber Infrastructure
> > +		.vendor=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D "VSTORAGE",
> > +		.product=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D "VSTOR-DISK",
> > +		.prio_name=C2=A0=C2=A0=C2=A0=C2=A0 =3D PRIO_ALUA,
> > +		.pgpolicy=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D GROUP_BY_NODE_NAME,
> > +		.detect_prio=C2=A0=C2=A0 =3D DETECT_PRIO_OFF,
> > +		.features=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D "2 pg_init_retries 50",
> > +		.pgfailback=C2=A0=C2=A0=C2=A0 =3D -FAILBACK_FOLLOWOVER,
>=20
> I'm not sure about the pgfailback setting. the FAILBACK_FOLLOWOVER
> mode
> is not something that is really needed for a specific array type. It
> works like FAILOVER_IMMEDIATE, but it's designed to work so that if
> multiple nodes are using the same multipath device, and one of them
> loses access to the highest priority pathgroup but the others don't,
> multipath won't keep switching pathgroups back and forth. The nodes
> that
> can see the higher priority pathgroup won't automatically switch back
> to
> it, since they weren't the ones that switched away from it. So the
> setting is more for a specific use case, and not a specific array
> type.
>=20
> On the other hand, it is what the vendor tested, and with a single
> machine accessing the multipath device, you usually only switch away
> from the highest priority pathgroup because you lost access to all
> the
> paths in it.

Not necessarily. path_group_prio_update() calculates the average of the
path priorities in the group. With ALUA and groups of 6+ paths, an
optimized group with one healthy path will have a lower prio (8) than a
non-optimized group with all healthy paths (10). In such a case it
could happen that multipathd switches to the non-optimized group and
never switches back.

I would suggest setting FAILBACK_IMMEDIATE instead. It's well
documented that FOLLOWOVER is only for cluster environments.

Regards
Martin

>  So it usually won't get stuck on a lower priority pathgroup
> while a higher priority one is usable, although that could happen.=20




>=20
> Thoughts?
>=20
> -Ben
>=20
> > +		.flush_on_last_del =3D FLUSH_ALWAYS,
> > +		.no_path_retry =3D NO_PATH_RETRY_QUEUE,
> > +	},
> > =C2=A0	/*
> > =C2=A0	 * EOL
> > =C2=A0	 */
> > --=20
> > 2.51.0
