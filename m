Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4C54A08
	for <dm-devel@lists.linux.dev>; Mon,  4 Nov 2024 15:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730732591; cv=none; b=a2hoOeVqi0euxuQKVmzqjDMz5TZ3IzZogeFBe8ijFBHJhFIht5eHybERIPT+dejnRX5HngOrDn58gnNhh900LIgBZDMvk7B5xa70zQHNAn82qSc0gnHhrf1USSbQ7xt1uBbsGMXzDinGbfzsFwMnnWjTQ3dphVFkSsYd3TVUyGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730732591; c=relaxed/simple;
	bh=V+lF8hEfOnh+xqgXLvkEycIbxeM7a++ROjIl9ca/iWA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tGeW3ERqfe3wwMhVlNuEJsW38g6p4H8P/qu3jljRolmk/MY5qJKlzdGpVkBju1cuuhgrYZd+ZR/CDjd+LIPEQptFrFYbhD66a5ENwpmHY3e899YvddC6LUZDIQl5Yjq71AjPRfMICTU10PWC7otcfhh3nvxlJB6mZSe/20uhgV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=JqbRIR/9; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=JqbRIR/9; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="JqbRIR/9";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="JqbRIR/9"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2031D21D70;
	Mon,  4 Nov 2024 15:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1730732587; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V+lF8hEfOnh+xqgXLvkEycIbxeM7a++ROjIl9ca/iWA=;
	b=JqbRIR/9PsqakCClRl3PIxN+RWlbIZ6GTqnDcRLS5voaO6MhbLWZGVFIPoAlVqo0jjqq99
	g8FOHiGGv8CJZhGvItFURCdlKstwdjvkT6kpvSM3m5Ik9LU5w1PrJOuiA2qwbNFaZlgqAa
	H+r62lCMNwmNl5Fqm2k4Skbsx9LmAA8=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="JqbRIR/9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1730732587; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V+lF8hEfOnh+xqgXLvkEycIbxeM7a++ROjIl9ca/iWA=;
	b=JqbRIR/9PsqakCClRl3PIxN+RWlbIZ6GTqnDcRLS5voaO6MhbLWZGVFIPoAlVqo0jjqq99
	g8FOHiGGv8CJZhGvItFURCdlKstwdjvkT6kpvSM3m5Ik9LU5w1PrJOuiA2qwbNFaZlgqAa
	H+r62lCMNwmNl5Fqm2k4Skbsx9LmAA8=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E707F13736;
	Mon,  4 Nov 2024 15:03:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SkfDNiriKGfkDAAAD6G6ig
	(envelope-from <mwilck@suse.com>); Mon, 04 Nov 2024 15:03:06 +0000
Message-ID: <753040e488750a3fcd3b911b741173bace4c0cb3.camel@suse.com>
Subject: Re: [PATCH v2 5/5] 11-dm-mpath.rules.in: set .DM_NOSCAN if
 MPATH_UNCHANGED is set
From: Martin Wilck <mwilck@suse.com>
To: Zdenek Kabelac <zkabelac@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Date: Mon, 04 Nov 2024 16:03:06 +0100
In-Reply-To: <3edf87cf-a698-4415-9fd0-b4f7eb40bd61@redhat.com>
References: <20241103224349.42582-1-mwilck@suse.com>
	 <20241103224349.42582-6-mwilck@suse.com>
	 <3edf87cf-a698-4415-9fd0-b4f7eb40bd61@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Rspamd-Queue-Id: 2031D21D70
X-Spam-Level: 
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:dkim,suse.com:mid];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.51
X-Spam-Flag: NO

On Mon, 2024-11-04 at 15:00 +0100, Zdenek Kabelac wrote:
> Dne 03. 11. 24 v 23:43 Martin Wilck napsal(a):
> > When multipath reloads a device or fails or restores a path, the
> > udev
> > rules disable LVM scanning, but since .DM_NOSCAN isn't set, blkid
> > is
> > still run on the device. When multipath devices that are set to
> > queue_if_no_path lose all their paths at close to the same time,
> > udev
>=20
>=20
> Hi
>=20
>=20
> There is worth to be mentioned -=C2=A0=C2=A0 blkid has for a long time
> 'special' rule=20
> -built-in=C2=A0=C2=A0 for LVM (and some other devices i.e. crypt...)
>=20
> So whenever lvm2=C2=A0 uses =C2=A0 LVM-uuid-suffix=C2=A0=C2=A0=C2=A0=C2=
=A0 with the '-suffix' in
> it's UUID -=20
> it's a private DM device which is never even opened by blkid. We
> would like to=20
> convert all remaining LV activations to use this logic for every
> 'private'=20
> device - since this logic is 'persistent' and survive even complete=C2=A0
> removal=20
> od udevdb. However it takes some time and also the backward
> compatibility is=20
> complicating things a lot.
>=20
> But all I say is - the relaing on any logic of=C2=A0 the udev flags is
> always kind=20
> of=C2=A0 problematic - and lvm2 does not depend on this fragile flagging
> too much.

Thanks for the hint. I think you're referring to libblkid's commit
20e1c3d ("libblkid: ignore private LVM devices"), which makes blkid
ignore devices with LVM UUIDs matching "LVM-.*-.*". I actually hadn't
been aware of this.

But note that multipath is overloading the .DM_NOSCAN flag here to tell
higher layers that blkid shouldn't be run in the first place if a
multipath map is in a certain state (we're reusing this flag, which was
originally created for LVM, in a similar but not identical case where
we want the blkid call to be skipped).

Unlike LVM, multipath has no way to set a UUID with special properties,
because multipath doesn't own any meta data on disk. In the case of
multipath, the .DM_NOSCAN property can, and will, change for a map
while its UUID remains constant. That's what this patch is about.

Thanks
Martin

