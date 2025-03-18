Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E88920767E
	for <dm-devel@lists.linux.dev>; Tue, 18 Mar 2025 11:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742296116; cv=none; b=heirEOF11hYLcyF/mbL/kTA1agXd3/1n7xBph/RftvOq7esyvp7jItdefgWg+N5Vk3nShe55qHeESz8gHTbQ3enm03vS9DR8b3u65OwH5XqyoUh17n0wMJnyFhBOGuI/SF0phkwEe4m3YH5TlXyRcg2NWkAC1vIy1xriz7jBuEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742296116; c=relaxed/simple;
	bh=EVdWYkfcmkGOqZLLWgbEZXK2tkWnY8lqXQrOIe1RvEE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LRDSlZV4HMUxe4Nndw8ShST/Z+Rl003HkY7KRXIf/ccEBdCJWHRVe9M+jZj9ymAktCwJ+xfY2MLj7lESCXM1jccz4jClRgR5aJnxQqbVLdy943BP8q8ffG4JJFHtBog5JecNvtm5JzsBddJTgOcd6etkxcurdK5GSBgvoIZFSxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=bRjM/T0c; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=bRjM/T0c; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="bRjM/T0c";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="bRjM/T0c"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 259D521AB1;
	Tue, 18 Mar 2025 11:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1742296113; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GodyCswUlNHCiyuFk+rCxOn/x4wZfeZKPKUYFFNo5kc=;
	b=bRjM/T0cSSq1D7n8PiHbhGYl4KBW1RGmQUNCm7XBQrbKKLX/gYp4ciliJ8bq5kbb6R3CiT
	tdN3O7InPZVSUyGXWJUw7Wy8w6uWY8Zu3mCy0Wg0FWOhGo34UimVQDOyUuQ4W3r++dfQHt
	zxYwlcYkaNa+RwdBIBlmrclr9nCFu54=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1742296113; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GodyCswUlNHCiyuFk+rCxOn/x4wZfeZKPKUYFFNo5kc=;
	b=bRjM/T0cSSq1D7n8PiHbhGYl4KBW1RGmQUNCm7XBQrbKKLX/gYp4ciliJ8bq5kbb6R3CiT
	tdN3O7InPZVSUyGXWJUw7Wy8w6uWY8Zu3mCy0Wg0FWOhGo34UimVQDOyUuQ4W3r++dfQHt
	zxYwlcYkaNa+RwdBIBlmrclr9nCFu54=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EDD1D139D2;
	Tue, 18 Mar 2025 11:08:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AOaCODBU2WeRRAAAD6G6ig
	(envelope-from <mwilck@suse.com>); Tue, 18 Mar 2025 11:08:32 +0000
Message-ID: <3d9867d00eeb9d9ec65a2f93ea09cd71a960c4bc.camel@suse.com>
Subject: Re: [PATCH RFC] multipath-tools: add Generic SCSI in hwtable
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Xose Vazquez Perez
	 <xose.vazquez@gmail.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, DM-DEVEL ML
	 <dm-devel@lists.linux.dev>
Date: Tue, 18 Mar 2025 12:08:32 +0100
In-Reply-To: <Z9h_dgeRCakpLak9@redhat.com>
References: <20250317173352.14387-1-xose.vazquez@gmail.com>
	 <Z9h_dgeRCakpLak9@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_TO(0.00)[redhat.com,gmail.com];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_DN_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCPT_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TAGGED_RCPT(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -2.80
X-Spam-Flag: NO

On Mon, 2025-03-17 at 16:00 -0400, Benjamin Marzinski wrote:
> On Mon, Mar 17, 2025 at 06:33:51PM +0100, Xose Vazquez Perez wrote:
> > Cc: Martin Wilck <mwilck@suse.com>
> > Cc: Benjamin Marzinski <bmarzins@redhat.com>
> > Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> > Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
> > Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> > ---
> > =C2=A0libmultipath/hwtable.c | 11 +++++++++++
> > =C2=A01 file changed, 11 insertions(+)
> >=20
> > diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> > index f8cf3fa9..34b1fd2f 100644
> > --- a/libmultipath/hwtable.c
> > +++ b/libmultipath/hwtable.c
> > @@ -79,6 +79,17 @@
> > =C2=A0#endif
> > =C2=A0
>=20
> If we wanted to make these changes, we could just change
> DEFAULT_PGPOLICY, DEFAULT_FAILBACK, and DEFAULT_NO_PATH_RETRY. But I
> still think that for completely unknown devices, we should stick with
> our current defaults. They're safe and I haven't heard any complaints
> about them.

I agree. The point of the hwtable is to change the defaults for
specific devices. Using "vendor =3D .*" and "product =3D ".*" is against
the spirit of the hwtable.=C2=A0

Unless I am mistaken, this  change would override user settings in the
"defaults" section of multipath.conf.=C2=A0This happens a lot already for
those systems that do have a specific hwtable entry, and I am sure that
that comes as a surprise for users (it has confused myself a
significant couple of times). By adding these catch-all entries, we'd
make the "defaults" section ineffective for any setting that's
available in the "devices" section, too.

Thinking about it, that might actually be a good thing, as it would
eliminate the uncertainty whether or not a given "defaults" setting
would take effect for a given storage device.=C2=A0Maybe we should
officially stop supporting settings in "defaults" that can be
overridden by device-spefic settings, just to reduce confusion in this
area, and recommend using a catch-all device setting (in
multipath.conf, not in the built-in hwtable) instead.

Anyway, that would be a possible cause for major breakage, as user
settings in the field would suddenly stop being effective. We can't
possibly just let it slip in with a minor hwtable patch like this.

Regards
Martin

> -Ben
>=20
> > =C2=A0static struct hwentry default_hw[] =3D {
> > +	/*
> > +	 * Generic SCSI devices
> > +	 */
> > +	{
> > +		/* Generic SCSI */
> > +		.vendor=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D ".*",
> > +		.product=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D ".*",
> > +		.pgpolicy=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D GROUP_BY_PRIO,
> > +		.pgfailback=C2=A0=C2=A0=C2=A0 =3D -FAILBACK_IMMEDIATE,
> > +		.no_path_retry =3D 30,
> > +	},
> > =C2=A0	/*
> > =C2=A0	 * Generic NVMe devices
> > =C2=A0	 *
> > --=20
> > 2.48.1
>=20

