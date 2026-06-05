Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C6FE40E8F2
	for <dm-devel@lists.linux.dev>; Fri,  5 Jun 2026 14:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780669054; cv=none; b=FbR7duZksAHMCTtmOolK/iYtDmSaWD2Ayc1lxIc4Yk9UNXmsASfP94UFUbs17dLRK+K3S+tFMnDwTboSHAfEL7ek9deNqmuAxy5CCZwG+k7IxTBwq6gl0zFPkyHsOx53W2ihVroqJFNysG1AXd+sK9kNUDyVUzytpcQy2buUxF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780669054; c=relaxed/simple;
	bh=33UJXWLSn/ZDnSFaW40FP9NsuIqBWxPX6VKsmEP1oLE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Cwwn4ORy0irtmIgA8ro57ShYg7n6443k0gIFEIIuzOTfNZ4dGvmALZ/sBTjTDv0o/LkHIpPbhYcYxYU5uFrLtVe67h2V4LunaT4/Y96ly6y2CUFoz0uL5E0GWM5IweigicYOyT7XPK//ZV4HXCkB3bIJIn2gsX8vZIsyj7tqBWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=UCxixQ7m; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=AqXo0SrP; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="UCxixQ7m";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="AqXo0SrP"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 08E4675B89;
	Fri,  5 Jun 2026 14:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780669051; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=33UJXWLSn/ZDnSFaW40FP9NsuIqBWxPX6VKsmEP1oLE=;
	b=UCxixQ7mT2HGjpAvOe+qD/Yf37lMufuc0alIqih5AwRShL3zHr4I4NoKnPZipQXzju6pG6
	1MNF9Zb9MiqHuEOCVY8J54Ze6pNAgi/oN8j95pf0sQ4aXvB+7vZFyDl92niB3W3O80XnuM
	wzZaOquhK1Cf1FQrqcMoMyAZ9ejhLiQ=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780669050; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=33UJXWLSn/ZDnSFaW40FP9NsuIqBWxPX6VKsmEP1oLE=;
	b=AqXo0SrPd/Jo67o3+d5OY7EOEub2P+/CW1H0XhfXHppqWGKupZMmhwvTE8vHnZPJj+Jf6i
	ggx4s9SegbaYB60hwlDVghgK5+T6Bu5G8wPsY6CboIG7xdrnb9xN8OmoDnriEkYrQLWprG
	dLjbQie+YEnx1u+YzIVJ4OXeFvwL62g=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DC724779A8;
	Fri,  5 Jun 2026 14:17:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id I4i6NHnaImqyQgAAD6G6ig
	(envelope-from <mwilck@suse.com>); Fri, 05 Jun 2026 14:17:29 +0000
Message-ID: <a4648b1b4c04cea0f81696d06b523447aa047624.camel@suse.com>
Subject: Re: [BUG] multipath-tools: 0 cyl reported on large disks due to
 overflow
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Xose Vazquez Perez
	 <xose.vazquez@gmail.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, DM_DEVEL-ML
	 <dm-devel@lists.linux.dev>
Date: Fri, 05 Jun 2026 16:17:29 +0200
In-Reply-To: <ahX0RqXAVsKWUIGN@redhat.com>
References: <02a2bb69-c13d-43bb-bbed-2a1bd3007ba4@gmail.com>
	 <ahX0RqXAVsKWUIGN@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 
X-Spam-Score: -2.80

On Tue, 2026-05-26 at 15:28 -0400, Benjamin Marzinski wrote:
> On Fri, May 22, 2026 at 11:10:36PM +0200, Xose Vazquez Perez wrote:
> > Hi,
> >=20
> > An integer overflow occurs in
> > libmultipath/discovery.c:get_geometry() when
> > querying geometry on large disks resulting in "0 cyl" being
> > reported:
> >=20
> > # multipath -ll -d -v3
> > ... | sdgm: 0 cyl, 64 heads, 32 sectors/track, start at 0
> >=20
> > # fdisk -l /dev/sdgm
> > Disk /dev/sdgm: 12 TiB, 13194139533312 bytes, 25769803776 sectors
> > Units: sectors of 1 * 512 =3D 512 bytes
> >=20
> > # dmesg | grep sdgm
> > sd 5:0:3:100: [sdgm] 25769803776 512-byte logical blocks: (13.2
> > TB/12.0TiB)
> >=20
> >=20
> > The root cause is that struct hd_geometry, from
> > libmultipath/structs.h,
> > defines cylinders as an unsigned short.
> >=20
> > Since it is a legacy interface, it should either sanitize the log
> > output
> > or avoid relying on CHS geometry for large devices.
>=20
> I'm totally fine with never reporting the geometry info or moving it
> to
> log level 4 (since there can be value to even pointless debugging
> messages. They can show you where you made it to if you happned to
> hang
> in a function)
>=20
> But I don't personally have a problem with multipath simply passing
> along the geometry data it gets from the disk. Sure, it may be
> garbage,
> but then DM's garbage matches the disk's garbage. I highly doubt that
> anything actually cares what geometry a DM device reports. But I
> don't
> see any benefit to changing what it currently does.
>=20
> Thoughts?

I agree. And as -v3 is already a moderate debugging level for us, I
don't see the log message as problematic, either.

Martin
