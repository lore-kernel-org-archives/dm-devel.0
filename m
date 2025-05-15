Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAFBE2980C7
	for <dm-devel@lists.linux.dev>; Thu, 15 May 2025 10:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747305258; cv=none; b=CKhvz4r/bOkzuK2l3C1CDdRfz9lyocV4o18XWO0l/DX8AQCHfAFt3sja28XtkcdBL2vFh/yBLO+Y7JRMd4i0VM5zX+0oE4jUzkVazFmBc4LFNehTrVF3rpuwDwZFaw4H1LkeYQSVwmmvP6Q2x7qj9hAmSxe+CSWjAMb1fuAfduc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747305258; c=relaxed/simple;
	bh=RD4Ye3A/BClSx0ngveQIAD++ZNWmt0zK+L/tPyHgig0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CLPPE52GCt4XWsNrTpTf0+x0SPTMIVJJfEwmQ/Ytq5/gKrtc1bE2Xki+gjrkj84hBb7dihI26dc66VB6YWqvOF90UUldR1mATe0CQMFnS7jo+PGix/QMCnb5UcIhjtanLwQFVJwE06LVQvUlj3sI2vD6BedaeYXh+Ad7AJ0/InI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=VMg7sALZ; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Q+lKCKop; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="VMg7sALZ";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Q+lKCKop"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EF42A1F387;
	Thu, 15 May 2025 10:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1747305255; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RD4Ye3A/BClSx0ngveQIAD++ZNWmt0zK+L/tPyHgig0=;
	b=VMg7sALZY4M5YuD+DEtiMwnIrSlgBpALsLrXF8zBN/S3OQD2ecuVUHN3oNuYc2/RQePEJV
	1suT9qoFms6dh9wyvZP4zzXwvmaSbZmxA0RO+e9rRykyytbuqQuRZndw00kbJlHJJiIik3
	Tdm6VcdxGPRl+3tmMT44pQytfrb1IqE=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=Q+lKCKop
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1747305253; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RD4Ye3A/BClSx0ngveQIAD++ZNWmt0zK+L/tPyHgig0=;
	b=Q+lKCKopHg9CyOifjfSbomKlXOQhSanE3gQS94QeOYKFlfDjN154iA3h0c4n4oQ+QkI3GP
	WvvNoiOVuPpFqX6klVdV5YA+PlLsqmesma2MP/YMuXXdrNJJiqCNC+uxuUrgLNiSws81ED
	luWuf8o8kjLBkEgyqdAOzF/C2w7yO10=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 95519137E8;
	Thu, 15 May 2025 10:34:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TU7+IiXDJWivYwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Thu, 15 May 2025 10:34:13 +0000
Message-ID: <2f0fc8ef7d04c590893bd6d54a6c0c842c4b21d7.camel@suse.com>
Subject: Re: [PATCH 0/2] dm mpath: Interface for explicit probing of active
 paths
From: Martin Wilck <mwilck@suse.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christoph Hellwig	
 <hch@infradead.org>, Kevin Wolf <kwolf@redhat.com>,
 dm-devel@lists.linux.dev,  Hanna Czenczek <hreitz@redhat.com>, Mikulas
 Patocka <mpatocka@redhat.com>, snitzer@kernel.org, "Kernel Mailing List,
 Linux" <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.com>
Date: Thu, 15 May 2025 12:34:13 +0200
In-Reply-To: <CABgObfaEiMN=YANk02EWini+jAXU1MxSvo8_jYWaMiu3ds7hgQ@mail.gmail.com>
References: <20250429165018.112999-1-kwolf@redhat.com>
	 <47dd225b433b0df585a25084a2e793344eeda239.camel@suse.com>
	 <aCIRUwt5BueQmlMZ@redhat.com> <aCLe5UT2kfzI96TQ@infradead.org>
	 <aCMQ5S-gI6vZJxmq@redhat.com> <aCQiz88HksKg791Z@infradead.org>
	 <aCTDiHMuMncwdp_X@redhat.com>
	 <50beb356b4dc000446fd186ab754c87f386eaeae.camel@suse.com>
	 <CABgObfaEiMN=YANk02EWini+jAXU1MxSvo8_jYWaMiu3ds7hgQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: EF42A1F387
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	MID_RHS_MATCH_FROM(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:dkim,suse.com:mid];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Action: no action

On Thu, 2025-05-15 at 04:53 +0200, Paolo Bonzini wrote:
> Il mer 14 mag 2025, 13:37 Martin Wilck <mwilck@suse.com> ha scritto:
> >=20
> > I'd go one step further. Christoph is right to say that what we're
> > currently doing in qemu =E2=80=93 passing through every command except =
the
> > PRIN/PROUT to a multipath device =E2=80=93 is a dangerous thing to do.
> >=20
> > Passthrough from a dm-multipath device to a SCSI device makes sense
> > only for a small subset of the SCSI command set. Basically just for
> > the
> > regular IO commands like the various READ and WRITE variants and
> > the
> > occasional UNMAP. The fact that customers
> > have been running these setups in large deployments over many years
> > suggests that, if other commands ever get passed through to member
> > devices, it has rarely had fatal consequences.
> >=20
> > Nobody would seriously consider sending ALUA commands to the
> > multipath
> > devices. TUR and REQUEST SENSE are other examples for commands that
> > can't be reasonably passed through to random member devices of a
> > multipath map.
>=20
> Yes, as usual things are a bit more complicated. First, a handful of
> commands are special (REQUEST SENSE would be for HBAs that don't use
> auto sense, but that is fortunately not something you encounter).
> Second, there's already a filter in the kernel in
> drivers/scsi/scsi_ioctl.c for commands that are allowed without
> CAP_SYS_RAWIO. QEMU is subject to that so the commands you'll see are
> mostly I/O, INQUIRY, TUR, MODE SENSE/SELECT and that's it.

Thanks for mentioning this.

However, I suppose that depends on the permissions with which the qemu
process is started, no? Wouldn't qemu need CAP_SYS_RAWIO for PCI
passthrough as well?=20

I admit that I'm confused by the many indirections in qemu's scsi-block
code flow. AFAICS qemu forwards everything except PRIN/PROUT to the
kernel block device in "scsi-block" mode. Correct me if I'm wrong.

Anwyway, let's not forget that we're talking about the kernel here.
While qemu is the main target application for this feature is created,
any application can use it, and it may or may not run with
CAP_SYS_RAWIO.

> Any command that the kernel doesn't filter would be rejected, or
> handled specially in the case of PR commands (PR commands use a
> separate privileged helper to send them down to the device; the
> helper
> also knows about multipath and uses the userspace libmpathpersist if
> it receives a dm-mpath file descriptor via SCM_RIGHTS).
>=20
> > AFAIK the only commands that we really need to pass through (except
> > the standard ones) are the reservation commands, which get special
> > handling
> > by qemu anyway. @Ben, @Kevin, are you aware of anything else?
>=20
> .Of the ones that aren't simple I/O, mode parameters and TUR are the
> important cases. A TUR failure would be handled by the ioctl that
> Kevin proposed here by forcing a path switch. Mode parameters might
> not be shared(*) and would need to be sent down all the paths in that
> case; that can be fixed in userspace if necessary.

Passing TUR from a multipath device to a random member doesn't make
much sense to me. qemu would need to implement some logic to determine
whether the map has any usable paths.

> > I'd also be interested in understanding this better. As noted
> > above,
> > I'm aware that passing through everything is dangerous and wrong in
> > principle. But in practice, we haven't observed anything serious
> > except
> > (as Ben already said) the failure to do path failover in the SG_IO
> > code
> > path, which both this patch set and my set from the past are
> > intended
> > to fix.
>=20
> Yes, the kernel filter is a PITA in the normal single path case but
> here it helps not doing something overly wrong.

This seems coincidental to me. Filtering by permissions and filtering
for commands that make sense on multipath devices are orthogonal
problems.

Regards,
Martin
