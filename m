Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794516477;
	b=TmH8lWfk2RUF1AJ00gilUCLED0a/2ak8BM8YSLIN4J9eEEo5WMy+8uI68S/7ff/aRQkm
	 tJ9uVRY0IfyXo+jaRbn8IUIYWTYjMlkHQPxRfLgGn7HccH4ofBaiY1UA4Qth4oDqoPvTh
	 AQ4lXWn5blaGZZyflYTPxcNwV0QpXDO57AWFBzptF2X+ImamHH4tZabHJTear/0IBRDXk
	 1c5In81lwSiwJLthAMRsbip5jP9r15F4036E24eQdGsZ7CFzwnkvNpGFWzD1tYESitzzM
	 BxSCOtWt9coV/JNZsarL/Xp9L0mTiQicMN9T09o2FLnfcFbiGIJ+1xlVn7VAJ25FGJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794516477;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version:
	 X-Rspamd-Queue-Id:X-Spam-Level:X-Rspamd-Server:X-Rspamd-Action:
	 X-Spam-Flag:X-Spamd-Result:X-Spam-Score;
	bh=8GAlIvu/7n9x7rn1wWVO1KYEgzha+ou77/lYlNohJbY=;
	b=U4/Y+AbjmYzDEjMcWmDm+4Y/iIySXbqoCuw0nYh90N8k3kIlOgX+VxWfX4PUoe9hKjLu
	 nhBTDM74MlC0Ol7I4iQh1MkCSpDKwq8gF3lSsaGI4P58hMifkRcjR0boz8Wr1keQ3fNzd
	 eVy4fBifuP0nOoCDTTVsHgOhBWVHPBAbeSHeW/QAtmOai1q+SSZbKaP9U8qaRp5WXAVkW
	 wSIkkFTdjO4b2pxh996e4idC4XqfFq7amOnlaXU3ZZ2Bfbazs9dzbviOTuxFu4N37c2Gm
	 7OEVF6JR9xMbhKREWH2qmiPgkxokczd4myLue9eoEqBIJc3OsZybhcxpEjMrSpUIrmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="HFJ/1KLd";
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="HFJ/1KLd";
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11D13606A32A
	for <dm-devel@lists.linux.dev>; Thu, 12 Nov 2026 20:47:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 11D13606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=HFJ/1KLd;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=HFJ/1KLd
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 25C732218F;
	Thu, 12 Nov 2026 20:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794516475; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8GAlIvu/7n9x7rn1wWVO1KYEgzha+ou77/lYlNohJbY=;
	b=HFJ/1KLdg9dxXHOj/quxvRJwPNlQWSV4Y8l5lUPjoSjXvhyTuQdnpDy0IuIhvPVZgH3/4m
	q1sr6J7oHC3/0Jq0OVeb8mdmbwQazxAq/0ExIfRAtnBcoqLiaE3wK8ruGamMmYZCyCMNOQ
	qufIU4w1IRebl7Iymkhv2DAtJwUSmL4=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="HFJ/1KLd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794516475; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8GAlIvu/7n9x7rn1wWVO1KYEgzha+ou77/lYlNohJbY=;
	b=HFJ/1KLdg9dxXHOj/quxvRJwPNlQWSV4Y8l5lUPjoSjXvhyTuQdnpDy0IuIhvPVZgH3/4m
	q1sr6J7oHC3/0Jq0OVeb8mdmbwQazxAq/0ExIfRAtnBcoqLiaE3wK8ruGamMmYZCyCMNOQ
	qufIU4w1IRebl7Iymkhv2DAtJwUSmL4=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B91F313432;
	Thu, 12 Nov 2026 20:47:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BFNZIvol9mobRwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Thu, 12 Nov 2026 20:47:54 +0000
Message-ID: <b087c205fa86ccda6743ebcdafb7e5340234a4af.camel@suse.com>
Subject: Re: udev / multipath-tools: WWID determination with SG_IO vs. sysfs
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Brian Bunker <brian@purestorage.com>, Hannes Reinecke <hare@suse.com>, 
 Christophe Varoqui <christophe.varoqui@opensvc.com>,
 dm-devel@lists.linux.dev
Date: Thu, 12 Nov 2026 21:47:54 +0100
In-Reply-To: <avYaaRagjQOdhnyj@redhat.com>
References: <20261109185556.27139-1-brian@purestorage.com>
	 <214d18ebabeca8318352dfa5456bc5b37cdefdeb.camel@suse.com>
	 <20261111174259.41911-1-brian@purestorage.com>
	 <cad66f75079fe0a89150e304d753527f140c67d9.camel@suse.com>
	 <20261111230535.12947-1-brian@purestorage.com>
	 <83f73b9cb1506eb80220759e3e0aae18648f80c4.camel@suse.com>
	 <avYaaRagjQOdhnyj@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.62.1 
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Rspamd-Queue-Id: 25C732218F
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-13.51 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim,suse.com:email];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Score: -13.51

On Thu, 2026-11-12 at 14:58 -0500, Benjamin Marzinski wrote:
> On Thu, Nov 12, 2026 at 08:00:58PM +0100, Martin Wilck wrote:
>=20
> =C2=A0
> > Brian's patch would add more such ioctls and thus increase the
> > likelihood of observing a stall. To be observed.
> >=20
>=20
> This is true, and unlike the existing recheck_wwids use and the
> prioritizer, it won't be called right after the path checker
> determined
> a path to be up. We do also do SG_IO ioctls in pathinfo when DI_IOCTL
> is
> set (when we're adding a path, reconfiguring multipath, or
> initializing
> a partial path). In that case we do check if the path is up according
> to
> sysfs first, but we don't call the checker.

So, would you prefer making it conditional on something else but
"recheck_wwid"?

Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>
SUSE Software Solutions Germany GmbH, Frankenstr. 146, 90461 N=C3=BCrnberg,
Germany
Gesch=C3=A4ftsf=C3=BChrer: Stefan Gaiser, Jochen Jaser, Abhinav Puri (HRB
36809,AG N=C3=BCrnberg)
