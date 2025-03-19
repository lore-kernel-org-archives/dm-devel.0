Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8140D1F4CBE
	for <dm-devel@lists.linux.dev>; Wed, 19 Mar 2025 10:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742378791; cv=none; b=V+meFCR+DWyLOo4Kd+UajLRnk9rnXTA/tSmNSmU3HxN5ssWkRxw74za0oDjSogSLt8lAoYJ7Ku1mPzZSYMHizNWRBDY/9fR3ljcTCJbNqBnRNIKwNIeQzDopAZxXSv0QUJNUM8b0pa3nKB8wKlTKJW9Psg6r1uX23r6Lto0aiNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742378791; c=relaxed/simple;
	bh=fOE2efMHV41LwYhm/o3qDDa69sjLxjrsymYuCii07yk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VayO8xDBKsHzRoRz3ctsJ70xs9lkNbetg3qgOewasTr2bkUb3clw+1eza06GhYkNV3E9YboDCm4ovmyDDfUX2CgKaq8u/IkeC9n5lTJZf2Xc6sO1yUc4k6nWxQY53MxNgv6B5y+aUPNK/X92q7Zm9br+mu6aKVClCZYAk5yWGbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=KM4IBT/P; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=KM4IBT/P; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="KM4IBT/P";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="KM4IBT/P"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5F5B21F38F;
	Wed, 19 Mar 2025 10:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1742378786; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xv1ePlXTuLazU1ikXfz4TTlr90GzYONrRMeGh4HATMg=;
	b=KM4IBT/PSxyKiXbiR3KndY8fIaF+4YfF6PedvvaJKetvpFegoIQb5DzMiE+A/HgNox7te7
	EPmFRpcfaiBEV4UlYwNkTgtmnCN1KHTfKzkBQUmRkYPHxBgo84tzToDZ4iOnKW+QlkATSw
	mHb3USCvREwg1vEZDXJvekaVuTanDrA=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="KM4IBT/P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1742378786; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xv1ePlXTuLazU1ikXfz4TTlr90GzYONrRMeGh4HATMg=;
	b=KM4IBT/PSxyKiXbiR3KndY8fIaF+4YfF6PedvvaJKetvpFegoIQb5DzMiE+A/HgNox7te7
	EPmFRpcfaiBEV4UlYwNkTgtmnCN1KHTfKzkBQUmRkYPHxBgo84tzToDZ4iOnKW+QlkATSw
	mHb3USCvREwg1vEZDXJvekaVuTanDrA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2F4F613726;
	Wed, 19 Mar 2025 10:06:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pgkQCSKX2me2VwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Wed, 19 Mar 2025 10:06:26 +0000
Message-ID: <0fc9d18df1c4baa1cbea67cbadca73b9142030d9.camel@suse.com>
Subject: Re: [PATCH RFC] multipath-tools: add Generic SCSI in hwtable
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, DM-DEVEL ML <dm-devel@lists.linux.dev>
Date: Wed, 19 Mar 2025 11:06:25 +0100
In-Reply-To: <Z9oCmSP3Zm11T7zr@redhat.com>
References: <20250317173352.14387-1-xose.vazquez@gmail.com>
	 <Z9h_dgeRCakpLak9@redhat.com>
	 <3d9867d00eeb9d9ec65a2f93ea09cd71a960c4bc.camel@suse.com>
	 <Z9oCmSP3Zm11T7zr@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Rspamd-Queue-Id: 5F5B21F38F
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
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	URIBL_BLOCKED(0.00)[suse.com:dkim,suse.com:mid,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,opensvc.com:email,linux.dev:email];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	MID_RHS_MATCH_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,opensvc.com,lists.linux.dev];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	TAGGED_RCPT(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim,suse.com:mid,suse.com:email]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

On Tue, 2025-03-18 at 19:32 -0400, Benjamin Marzinski wrote:
> On Tue, Mar 18, 2025 at 12:08:32PM +0100, Martin Wilck wrote:
> > On Mon, 2025-03-17 at 16:00 -0400, Benjamin Marzinski wrote:
> > > On Mon, Mar 17, 2025 at 06:33:51PM +0100, Xose Vazquez Perez
> > > wrote:
> > > > Cc: Martin Wilck <mwilck@suse.com>
> > > > Cc: Benjamin Marzinski <bmarzins@redhat.com>
> > > > Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> > > > Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
> > > > Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> > > > ---
> > > > =C2=A0libmultipath/hwtable.c | 11 +++++++++++
> > > > =C2=A01 file changed, 11 insertions(+)
> > > >=20
> > > > diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> > > > index f8cf3fa9..34b1fd2f 100644
> > > > --- a/libmultipath/hwtable.c
> > > > +++ b/libmultipath/hwtable.c
> > > > @@ -79,6 +79,17 @@
> > > > =C2=A0#endif
> > > > =C2=A0
> > >=20
> > > If we wanted to make these changes, we could just change
> > > DEFAULT_PGPOLICY, DEFAULT_FAILBACK, and DEFAULT_NO_PATH_RETRY.
> > > But I
> > > still think that for completely unknown devices, we should stick
> > > with
> > > our current defaults. They're safe and I haven't heard any
> > > complaints
> > > about them.
> >=20
> > I agree. The point of the hwtable is to change the defaults for
> > specific devices. Using "vendor =3D .*" and "product =3D ".*" is
> > against
> > the spirit of the hwtable.=C2=A0
> >=20
> > Unless I am mistaken, this=C2=A0 change would override user settings in
> > the
> > "defaults" section of multipath.conf.=C2=A0This happens a lot already
> > for
> > those systems that do have a specific hwtable entry, and I am sure
> > that
> > that comes as a surprise for users (it has confused myself a
> > significant couple of times). By adding these catch-all entries,
> > we'd
> > make the "defaults" section ineffective for any setting that's
> > available in the "devices" section, too.
> >=20
> > Thinking about it, that might actually be a good thing, as it would
> > eliminate the uncertainty whether or not a given "defaults" setting
> > would take effect for a given storage device.=C2=A0Maybe we should
> > officially stop supporting settings in "defaults" that can be
> > overridden by device-spefic settings, just to reduce confusion in
> > this
> > area, and recommend using a catch-all device setting (in
> > multipath.conf, not in the built-in hwtable) instead.
>=20
> The device configs from /etc/multipath.conf will override values in
> the
> built-in hwtable. So a catch-all device config in /etc/multipath.conf
> is
> the same as putting options in the overrides section, not the
> defaults
> section.

Yes. I'd realized that meanwhile, too. Thanks for clarifying it, and
sorry for the confusion.

The "proble"m that I see with our configuration logic is that some
settings simply don't take effect.

- hwtable settings take precedence over defaults
- detect_prio etc. take precedence over explicit settings

While this logic does make general sense, I am sure that many users
have pulled their hair about it, even though it's documented.
But this is how it has been for a decade. User have got used to it. I
don't think it makes sense to put lots of energy into changing it.

> Now that we changed how hwentry configs work, we could probably
> deprecate the overrides section, but I don't think we can replace the
> defaults section.

No, we can't. And we should keep overrides, too. I find it quite
convenient. Unlike the other sections, you can be certain that what you
set there will take effect :-) Also, we need it for the protocol
subsection.

Martin



>=20
> right?
>=20
> -Ben
> =C2=A0
> > Anyway, that would be a possible cause for major breakage, as user
> > settings in the field would suddenly stop being effective. We can't
> > possibly just let it slip in with a minor hwtable patch like this.
> >=20
> > Regards
> > Martin
> >=20
> > > -Ben
> > >=20
> > > > =C2=A0static struct hwentry default_hw[] =3D {
> > > > +	/*
> > > > +	 * Generic SCSI devices
> > > > +	 */
> > > > +	{
> > > > +		/* Generic SCSI */
> > > > +		.vendor=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D ".*",
> > > > +		.product=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D ".*",
> > > > +		.pgpolicy=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D GROUP_BY_PRIO,
> > > > +		.pgfailback=C2=A0=C2=A0=C2=A0 =3D -FAILBACK_IMMEDIATE,
> > > > +		.no_path_retry =3D 30,
> > > > +	},
> > > > =C2=A0	/*
> > > > =C2=A0	 * Generic NVMe devices
> > > > =C2=A0	 *
> > > > --=20
> > > > 2.48.1
> > >=20
>=20

