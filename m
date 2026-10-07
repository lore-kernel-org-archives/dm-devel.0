Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F7A3B637E
	for <dm-devel@lists.linux.dev>; Wed,  7 Oct 2026 19:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791400901; cv=none; b=HX66p1r/BWIfCDkmeqqspP6B8jQ+7fZ1PkFlVDw0zKbD9+k58pde5z8t8thQt4xkWozBkjm4Wgb8IHZnCdnVEQyZdCOol58x7mL9qSOovbjRQFjeSamChRaEOC/hOI4AvvE4FtbACBX90knU8rrxkKIB6ut8U2OJLc6OL+mxWM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791400901; c=relaxed/simple;
	bh=QzjKlXJTIGS/OUqXW8c019kHOynuTm/WnRaGeNAnglc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Xn1jaENS9TkHrNU7HrPWOyCtMn0UkfvSKavInxT0mk+LnRIIQ8JiUsZAC5qPhrPxtvCgzSHcmAl1jLaLQX+kNaaeOljIb29mhbrCU3liY0zXUiMvSGBvhMuv6Fa9cRE21YOPkgjZab4oXaVgtJT/J7oj/MeHB1BG7ZCZKoMvS4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=oA1j57O1; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=oA1j57O1; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="oA1j57O1";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="oA1j57O1"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A6F8421B7A;
	Wed,  7 Oct 2026 19:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791400897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iTaNLngAnQzHAoJh8h8NvIPuVcZ6SSPWzlYOwk7J69Q=;
	b=oA1j57O1TvoaXeLNe1Fuz+YD0okZFzNc+KTXb/EU1v50AxQikUdsK1phgvu053Mu6n402M
	U7GJbzCDZJHRqGfduSUe1BxFcBp5Z+dC81s7JlhI1p33Rf7Eh7lSQ1WujyMQpUvFulDkKN
	kdZaTz8zqBn2Ed7C6Wlrmom5Srw7+Wo=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791400897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iTaNLngAnQzHAoJh8h8NvIPuVcZ6SSPWzlYOwk7J69Q=;
	b=oA1j57O1TvoaXeLNe1Fuz+YD0okZFzNc+KTXb/EU1v50AxQikUdsK1phgvu053Mu6n402M
	U7GJbzCDZJHRqGfduSUe1BxFcBp5Z+dC81s7JlhI1p33Rf7Eh7lSQ1WujyMQpUvFulDkKN
	kdZaTz8zqBn2Ed7C6Wlrmom5Srw7+Wo=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4A8AF13354;
	Wed,  7 Oct 2026 19:21:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OK6NB8GbxmovCQAAD6G6ig
	(envelope-from <mwilck@suse.com>); Wed, 07 Oct 2026 19:21:37 +0000
Message-ID: <136782c48a0b514ad107b3b2aef18d437e2ce9de.camel@suse.com>
Subject: Re: [PATCH v2 2/2] libmultipath: dm_flush_map__: log if the resume
 fails after a failed remove
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Suresh Thelkar
	 <suresh.thelkar@yahoo.com>
Cc: dm-devel@lists.linux.dev
Date: Wed, 07 Oct 2026 21:21:36 +0200
In-Reply-To: <asZ2WTKM-SeIbsE6@redhat.com>
References: <20261005045726.71858-1-suresh.thelkar@yahoo.com>
	 <20261007092236.165908-1-suresh.thelkar@yahoo.com>
	 <20261007092236.165908-3-suresh.thelkar@yahoo.com>
	 <asZ2WTKM-SeIbsE6@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[redhat.com,yahoo.com];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[yahoo.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email]

On Wed, 2026-10-07 at 12:42 -0400, Benjamin Marzinski wrote:
> On Wed, Oct 07, 2026 at 09:22:36AM +0000, Suresh Thelkar wrote:
> > After a failed DM_DEVICE_REMOVE the map was suspended earlier in
> > dm_flush_map__(), and the recovery path issued a single fire-and-
> > forget
> > DM_DEVICE_RESUME whose result was ignored. If that resume ioctl
> > failed,
> > the map could be left suspended with no trace in the logs, which
> > wedges
> > any later task in uninterruptible D state and, because sync() walks
> > every block device, hangs I/O node-wide until reboot.
> >=20
> > Check the DM_DEVICE_RESUME return value and log at condlog(1) when
> > it
> > fails, so a leaked suspend is at least visible in the logs. The map
> > is
> > known to have been suspended at the start of the loop, so the ioctl
> > return value is authoritative.
> >=20
> > Signed-off-by: Suresh Thelkar <suresh.thelkar@yahoo.com>
>=20
> I want to discuss this change from v1 a bit. The issue that the
> second
> resume is solving is the same one that lead us to add a second resume
> to
> dm_addmap_reload(). If the device has an invalid inactive table, and
> you
> do a resume, dm will attempt to swap the table, fail, and leave the
> device suspended with the invalid table removed. Immediately issuing
> a
> second resume will cause dm to actually resume with the old table. If
> we
> don't manage to resume the device, it seems much less likely that
> waiting a second and re-attempting the remove will succeed (I believe
> the most common case is us racing with something that temporarily
> opens
> the device, like udev. It may need the device to be unsuspended to
> do a quick read and close it again).=20
>=20
> Now, I admit that this is WAY more likely to happen when we are
> actually
> reloading the table, since we just added an inactive table, and dm
> might
> not be able to swap it correctly for any number of reasons. To hit
> this
> issue when removing the device there would need to be an inactive
> table
> (which is unlikely) and dm would have to fail when trying to swap
> tables
> (which is also unlikely). Also, we resume the table in other places
> in
> the code, without caring about this corner case. For consistency's
> sake,
> we should probably either always do it, or only do it when we've
> loaded
> a new table.
>=20
> Thoughts? Also, I'm fine with this change going in as-is and dealing
> with the resume question as a separate issue.

Right, thanks for explaining it. I'd forgotten about this failure
scenario. With this in mind, it actually makes sense to retry the
resume. You're right, there should be no inactive table, but retrying
won't hurt. [*]

I'd appreciate a short comment explaining the problem scenario that
the retry attempts to avoid (i.e. a short version of Ben's explanation
here).

Regards
Martin

[*] I wonder what would happen if there was a _valid_ inactive table.
In that case, instead of removing the map, we'd reload it with a
different table, which seems wrong. But again, there should  be none.

--=20
Dr. Martin Wilck <mwilck@suse.com>
SUSE Software Solutions Germany GmbH, Frankenstr. 146, 90461 N=C3=BCrnberg,
Germany
Gesch=C3=A4ftsf=C3=BChrer: Stefan Gaiser, Jochen Jaser, Abhinav Puri (HRB
36809,AG N=C3=BCrnberg)
