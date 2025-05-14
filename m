Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3DC118DB37
	for <dm-devel@lists.linux.dev>; Wed, 14 May 2025 17:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747244245; cv=none; b=cHoX8iyDkYsMHoLkb+00FGcPvIwpSbc3pUebRFQ85/sEq5K8YJhM1cxeN1wDMkKNpPGY+DzLzdJqI+IFj5sQ+hpPO/Ib7L1vRYNrw0t7QE/d181kQDq5vlEpdrK7n6ozT/Hz4sL5b2wgifPgSbHekSdAit7VK9WhKohma4u+o+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747244245; c=relaxed/simple;
	bh=JKexnO2Q2BnjLLOK348ei8IMpNVZwDl9P/ySv6Fj1VQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MmELmrHfd2YudRZ89UFr/c8wZBAHCSlSasGjlQGg4Niixj1fR+TM7jF1XFIWIH2tDjqSRqEa96bL+m4Acc8wwDRwQPHBkCTZfTBZtyjtD2kod6a3qa5CAL2KslisgXXUi1Ky12lRDj0KzVW3DqvWi+627YbjXl9ynh7BckzIK6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=MUtYkgFS; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=MUtYkgFS; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="MUtYkgFS";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="MUtYkgFS"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BC53B1F399;
	Wed, 14 May 2025 17:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1747244240; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JKexnO2Q2BnjLLOK348ei8IMpNVZwDl9P/ySv6Fj1VQ=;
	b=MUtYkgFSFubfI/dh4y74gZVNMsj+IryboAYMp56IqA/xCVpXmswAlnTFOmWVtg/dH5rKwf
	WbKYDingBGEUIEa6UAMKnm4T+Dxn5DPl2nZpICQc5pKc0768p4x8YJ66edeV89gePsFnRf
	9mxTmBRlHSZAMPX84ilWElLOGqadi0o=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1747244240; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JKexnO2Q2BnjLLOK348ei8IMpNVZwDl9P/ySv6Fj1VQ=;
	b=MUtYkgFSFubfI/dh4y74gZVNMsj+IryboAYMp56IqA/xCVpXmswAlnTFOmWVtg/dH5rKwf
	WbKYDingBGEUIEa6UAMKnm4T+Dxn5DPl2nZpICQc5pKc0768p4x8YJ66edeV89gePsFnRf
	9mxTmBRlHSZAMPX84ilWElLOGqadi0o=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 63FE413306;
	Wed, 14 May 2025 17:37:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id z0lPFtDUJGgyUAAAD6G6ig
	(envelope-from <mwilck@suse.com>); Wed, 14 May 2025 17:37:20 +0000
Message-ID: <50beb356b4dc000446fd186ab754c87f386eaeae.camel@suse.com>
Subject: Re: [PATCH 0/2] dm mpath: Interface for explicit probing of active
 paths
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christoph Hellwig
	 <hch@infradead.org>
Cc: Kevin Wolf <kwolf@redhat.com>, dm-devel@lists.linux.dev,
 hreitz@redhat.com, 	mpatocka@redhat.com, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, 	pbonzini@redhat.com, Hannes Reinecke
 <hare@suse.com>
Date: Wed, 14 May 2025 19:37:19 +0200
In-Reply-To: <aCTDiHMuMncwdp_X@redhat.com>
References: <20250429165018.112999-1-kwolf@redhat.com>
	 <47dd225b433b0df585a25084a2e793344eeda239.camel@suse.com>
	 <aCIRUwt5BueQmlMZ@redhat.com> <aCLe5UT2kfzI96TQ@infradead.org>
	 <aCMQ5S-gI6vZJxmq@redhat.com> <aCQiz88HksKg791Z@infradead.org>
	 <aCTDiHMuMncwdp_X@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,imap1.dmz-prg2.suse.org:helo]

Hello Ben, hello Christoph,

On Wed, 2025-05-14 at 12:23 -0400, Benjamin Marzinski wrote:
> On Tue, May 13, 2025 at 09:57:51PM -0700, Christoph Hellwig wrote:
> >=20
> > SG_IO is fine and the only way for SCSI passthrough.=C2=A0 But doing
> > SCSI passthrough through md-multipath just doesn't work.=C2=A0 SCSI
> > isn't
> > built for layering, and ALUA and it's vendor-specific variants and
> > alternatives certainly isn't.=C2=A0 If you try that you're playing with
> > fire and is not chance of ever moving properly.
>=20
> Could you be a bit more specific. All multipath is doing here is
> forwarding the ioctls to an underlying scsi device, and passing back
> up
> the result. Admittedly, it doesn't always make sense to pass the
> ioctl
> on from the multipath device to just one scsi device. Persistent
> Reservations are perfect example of this, and that's why QEMU doesn't
> use DMs ioctl passthrough code to handle them.=C2=A0

I'd go one step further. Christoph is right to say that what we're
currently doing in qemu =E2=80=93 passing through every command except the
PRIN/PROUT to a multipath device =E2=80=93 is a dangerous thing to do.

Passthrough from a dm-multipath device to a SCSI device makes sense
only for a small subset of the SCSI command set. Basically just for the
regular IO commands like the various READ and WRITE variants and the
occasional UNMAP. However, in practice these commands account for 99.y%
percent of the actual commands sent to devices. The fact that customers
have been running these setups in large deployments over many years
suggests that, if other commands ever get passed through to member
devices, it has rarely had fatal consequences.

Nobody would seriously consider sending ALUA commands to the multipath
devices. TUR and REQUEST SENSE are other examples for commands that
can't be reasonably passed through to random member devices of a
multipath map. There are certainly many more examples. I guess it would
make sense to review the command set and add some filtering in the qemu
passthrough code.

AFAIK the only commands that we really need to pass through (except the
standard ones) are the reservation commands, which get special handling
by qemu anyway. @Ben, @Kevin, are you aware of anything else?

So: admittedly we're using a framework for passing through any command,
where we actually need to pass through only a tiny subset of commands.
Thinking about it this way, it really doesn't look like the perfect
tool for the job, and we may want to look into a different approach for
the future.

> Also, when you have ALUA
> setups, not all the scsi devices are equal. But multipath isn't
> naievely
> assuming that they are. It's only passing ioctls to the highest
> priority
> activated paths, just like it does for IO, and multipath is in charge
> of
> handling explicit alua devices. This hasn't proved to be problematic
> in
> practice.
>=20
> The reality of the situation is that customers have been using this
> for
> a while, and the only issue that they run into is that multipath
> can't
> tell when a SG_IO has failed due to a retryable error. Currently,
> they're left with waiting for multipathd's preemptive path checking
> to
> fail the path so they can retry down a new one. The purpose of this
> patchset and Martin's previous one is to handle this problem. If
> there
> are unavoidable critical problems that you see with this setup, it
> would
> be really helpful to know what they are.

I'd also be interested in understanding this better. As noted above,
I'm aware that passing through everything is dangerous and wrong in
principle. But in practice, we haven't observed anything serious except
(as Ben already said) the failure to do path failover in the SG_IO code
path, which both this patch set and my set from the past are intended
to fix.

While I am open for looking for better alternatives, I still hope that
we can find an agreement for a short/mid-term solution that would allow
us to serve our customers who currently use SCSI passthrough setups.=20
That would not just benefit us (the enterprise distros), because it
would also help us fund upstream contributions.


Regards
Martin
