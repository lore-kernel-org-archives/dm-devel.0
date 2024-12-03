Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD9041EB9FA
	for <dm-devel@lists.linux.dev>; Tue,  3 Dec 2024 12:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733229633; cv=none; b=JHZ1iHC5iCgnmuckaW5Bh8Gt4WeNEqiPLjHhqN4lGT2YRHD9o9W7wd0xWLuUe6Ko/sCxWwcyYWFtyLStj3S5GAI05RncxhEtApmPmcv6QKLHQAx7YNeev0asTD0ky1vvgx7SdDgIoCVco/kXXxTGhJVDlVV9mEPm7ZPKbLomkSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733229633; c=relaxed/simple;
	bh=CkbFXrsQfJa4NRFLLGKjWwtALALORw+s2atGqyZ8eHs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fw0TM1sXRKdWmEscDPXx5mJF/EY47AhWMafnIboP5ut5p0QhaRSkNZy7sN/GwBQ6dlaXKrNl2KEYA4lqJo5iBFJfcKqGVQk78gzRwx1Ta7Pa05IMS1bKT1bAvsB0sccOAmOHmGImjxOySL1SvvDE4eZ53wSInn9GRQfjmKZyVoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=O6QNBW1y; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=o9U1DJff; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="O6QNBW1y";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="o9U1DJff"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BD3FA1F453;
	Tue,  3 Dec 2024 12:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1733229622; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KQONLInAANtysbvy1DQD4NVc5DK+HUVSH7eMfbaEKEw=;
	b=O6QNBW1ycg82GsBaR7QGniTeILzBOc4GOYPiTYLIAgabuWPVr5BCfrbJ2zMJbmaZX9wUMV
	wuHPld8lDaYQ0Ie/3voLyt6b4Hr3rD+aEupUDr2pcW4/gHu+MqQkeIA+CqhgK4OWrZkDVS
	w/jmzqMwzLvvImCIMj/Gy7Y82GUBAV8=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=o9U1DJff
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1733229621; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KQONLInAANtysbvy1DQD4NVc5DK+HUVSH7eMfbaEKEw=;
	b=o9U1DJffjuFF+fan+Pjo/fOCQkKl7syTWKH04pIG4PvDszxcPhz1Kx4vhvrgj278+vZLWF
	fVj7fyhfRGfcglLCTYHqd+jusA9QRgLHjj+OrKk0sWfvc0VdUARHmobsURIq0MMYNINVHo
	hXYpIpPigppIlzVp31Nq45a/Wl71COk=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 940E7139C2;
	Tue,  3 Dec 2024 12:40:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id U0s+IjX8Tmd+DwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Tue, 03 Dec 2024 12:40:21 +0000
Message-ID: <f163eb852936ae015627034f6b6abbf405d309fb.camel@suse.com>
Subject: Re: [PATCH v2 5/8] libmultipath: re-implement pgcmp without the
 pathgroup id
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, 
	dm-devel@lists.linux.dev
Date: Tue, 03 Dec 2024 13:40:21 +0100
In-Reply-To: <Z05OAl5bhpsruTLh@redhat.com>
References: <20241127230430.139639-1-mwilck@suse.com>
	 <20241127230430.139639-6-mwilck@suse.com> <Z05OAl5bhpsruTLh@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Rspamd-Queue-Id: BD3FA1F453
X-Spam-Level: 
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:mid];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.51
X-Spam-Flag: NO

On Mon, 2024-12-02 at 19:17 -0500, Benjamin Marzinski wrote:
> On Thu, Nov 28, 2024 at 12:04:27AM +0100, Martin Wilck wrote:
> >=20
> > @@ -763,11 +795,7 @@ void select_action (struct multipath *mpp,
> > const struct vector_s *curmp,
> > =C2=A0		select_reload_action(mpp, "minio change");
> > =C2=A0		return;
> > =C2=A0	}
> > -	if (!cmpp->pg || VECTOR_SIZE(cmpp->pg) !=3D VECTOR_SIZE(mpp-
> > >pg)) {
> > -		select_reload_action(mpp, "path group number
> > change");
> > -		return;
> > -	}
> > -	if (pgcmp(mpp, cmpp)) {
> > +	if (!cmpp->pg || pgcmp(mpp, cmpp)) {
>=20
> I know that the code did this before, but is there a reason why we
> always reload if cmpp->pg is NULL? I'm pretty sure it's possible to
> call
> select action when neither mpp nor cmpp have any paths. (cli_reload
> on a
> pathless device should do that). In this case, the topology isn't
> changing, and AFAICS pgcmp() should work with no pathgroups.


It dates back to b0991a8 ("Allow zero paths for multipath map"),
multipath-tools 0.4.9.

I guess back then Hannes either encountered in crash in some situation,
or he was just being cautious.

I can remove this check.

Martin


