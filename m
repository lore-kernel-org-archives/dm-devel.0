Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F8D1F4E59
	for <dm-devel@lists.linux.dev>; Tue, 13 May 2025 08:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747123262; cv=none; b=CQ+n3DoNTp3EUur24J0DPMn0+MsZWcc9sZOY4U0r9Ou20NhymTdlMYnB73n92Zp0yX5meroHbMMbZkVy8Uw4E5iLbONDZnp4v7LzWnyfm3rnyZdfiYtJikZYkWmrZTaZPm2C4PLhkVpTc/bWbPYyW82vuefGmxKatX7e0Mf2BSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747123262; c=relaxed/simple;
	bh=0fNdxGoZRuR+zs6oYrKOzs+v0MZrMWbTmr97qtylY7U=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=azaX8PEZpgSqeNi1VqIkLk2hTdHvhZfP1a6lLgcPS6KqhGL6c58EtGwZYH4QbGardRMHApSswDCo+iJfyT0ENDT8/GL+XZLf3//aW/kt/hNlmrgYGfOIDKa5VdjcPKWo87X6SLel5qhV1IOBJ1xIMM44ouAWWWv0RPIaeS3nD94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=U30L8G9O; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=U30L8G9O; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="U30L8G9O";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="U30L8G9O"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7BE2F2119C;
	Tue, 13 May 2025 08:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1747123258; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0fNdxGoZRuR+zs6oYrKOzs+v0MZrMWbTmr97qtylY7U=;
	b=U30L8G9OrnKmUlDuPv5IkBayCjjUZrie92gjUqJI1M9OO4pxE3k9ojN670t0Gdf+gzOgeu
	UoZhijB3dwRvDdVs4f/+xhCW7NEi+pGo1+t88zfHiN2/bPtYpF8ps5B3FJPRIpdM0Pa4iP
	YcY/KHAyddbpnaEED5sUI1wVPH5OEc4=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=U30L8G9O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1747123258; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0fNdxGoZRuR+zs6oYrKOzs+v0MZrMWbTmr97qtylY7U=;
	b=U30L8G9OrnKmUlDuPv5IkBayCjjUZrie92gjUqJI1M9OO4pxE3k9ojN670t0Gdf+gzOgeu
	UoZhijB3dwRvDdVs4f/+xhCW7NEi+pGo1+t88zfHiN2/bPtYpF8ps5B3FJPRIpdM0Pa4iP
	YcY/KHAyddbpnaEED5sUI1wVPH5OEc4=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 354041365D;
	Tue, 13 May 2025 08:00:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IvlmCzr8ImgTZwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Tue, 13 May 2025 08:00:58 +0000
Message-ID: <d51d6f85b5728648fe9c584f9cb3acee12c4873f.camel@suse.com>
Subject: Re: [PATCH 0/2] dm mpath: Interface for explicit probing of active
 paths
From: Martin Wilck <mwilck@suse.com>
To: Kevin Wolf <kwolf@redhat.com>, Christoph Hellwig <hch@infradead.org>
Cc: dm-devel@lists.linux.dev, hreitz@redhat.com, mpatocka@redhat.com, 
	snitzer@kernel.org, bmarzins@redhat.com, linux-kernel@vger.kernel.org
Date: Tue, 13 May 2025 10:00:57 +0200
In-Reply-To: <aCIRUwt5BueQmlMZ@redhat.com>
References: <20250429165018.112999-1-kwolf@redhat.com>
		 <47dd225b433b0df585a25084a2e793344eeda239.camel@suse.com>
		 <aCIRUwt5BueQmlMZ@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 7BE2F2119C
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim,bootlin.com:url]
X-Spam-Score: -4.51

Hi Kevin,

On Mon, 2025-05-12 at 17:18 +0200, Kevin Wolf wrote:
> Am 08.05.2025 um 15:51 hat Martin Wilck geschrieben:
> > Hello Kevin,
> >=20
> > [I'm sorry for the previous email. It seems that I clicked "send"
> > in
> > the wrong window].
> >=20
> > On Tue, 2025-04-29 at 18:50 +0200, Kevin Wolf wrote:
> > > Multipath cannot directly provide failover for ioctls in the
> > > kernel
> > > because it doesn't know what each ioctl means and which result
> > > could
> > > indicate a path error. Userspace generally knows what the ioctl
> > > it
> > > issued means and if it might be a path error, but neither does it
> > > know
> > > which path the ioctl took nor does it necessarily have the
> > > privileges
> > > to
> > > fail a path using the control device.
> >=20
> > Thanks for this effort.
> >=20
> > I have some remarks about your approach. The most important one is
> > that
> > the DM_MPATH_PROBE_PATHS_CMD ioctl appears to be a dangerous
> > command.
> > It sends IO to possibly broken paths and waits for it to complete.
> > In
> > the common error case of a device not responding, this might cause
> > the
> > code to hang for a long time in the kernel ioctl code path, in
> > uninterruptible sleep (note that these probing commands will be
> > queued
> > after other possibly hanging IO). In the past=C2=A0we have put a lot of
> > effort into other code paths in multipath-tools and elsewhere to
> > avoid
> > this kind of hang to the extent possible. It seems to me that your
> > set
> > re-introduces this risk.
>=20
> That's a fair point. I don't expect this code to be fully final,
> another
> thing that isn't really optimal (as mentioned in the comment message)
> is
> that we're not probing paths in parallel, potentially adding up
> timeouts
> from multiple paths.
>=20
> I don't think this is a problem of the interface, though, but we can
> improve the implementation keeping the same interface.

> Maybe I'm missing something, but I think the reason why it has to be
> uninterruptible is just that submit_bio_wait() has the completion on
> the
> stack? So I suppose we could just kmalloc() some state, submit all
> the
> bios, let the completion callback free it, and then we can just stop
> waiting early (i.e. wait_for_completion_interruptible/killable) and
> let
> the requests complete on their own in the background.
>=20
> Would this address your concerns or is there another part to it?

It'd be an improvement. Not sure if it'd solve the problem entirely.

> > Apart from that, minor observations are that in patch 2/2 you don't
> > check whether the map is in queueing state, and I don't quite
> > understand why you only check paths in the map's active path group
> > without attempting a PG failover in the case where all paths in the
> > current PG fail.
>=20
> Ben already fixed up the missing check.

I missed that.

> Not attempting PG failover was also his suggestion, on the basis that
> it
> would be additional work for no real benefit when you can only submit
> requests for the current PG anyway. If userspace retries the SG_IO,
> it
> will already pick a different PG, so having the kernel do the same
> doesn't really improve anything.

Ok. But continuing along this line of reasoning, I'd conclude that it
would be even more useful to fail the path in device-mapper directly
after a failed IO request (given that we find an agreeable way to do
this, see below). Qemu could then retry, depending on the error code.
Paths would be failed one after the other, and eventually a PG failover
would occur.

> > I am wondering whether the DM_MPATH_PROBE_PATHS_CMD ioctl is
> > necessary
> > at all. Rather than triggering explicit path probing, you could
> > have
> > dm-mpath "handle" IO errors by failing the active path for "path
> > errors". That would be similar to my patch set from 2021 [1], but
> > it
> > would avoid the extra IO and thus the additional risk of hanging in
> > the
> > kernel.
> >=20
> > Contrary to my set, you wouldn't attempt retries in the kernel, but
> > leave this part to qemu instead, like in the current set. That
> > would
> > avoid Christoph's main criticism that "Failing over SG_IO does not
> > make
> > sense" [2].
>=20
> Maybe I misunderstood, but my understanding from the feedback you got
> back then was that no SCSI-specific code was wanted in device mapper.
> This is why we kept interpreting the status codes in userspace.

As I wrote in my reply to Mikulas already, my understanding was that
Christoph's main objection was against retrying SG_IO ioctls in the
kernel on different paths, not against inspecting the error code.

> While discussing the approaches with Mikul=C3=A1=C5=A1 and Ben, one optio=
n that
> was briefly discussed was a pair of ioctls: One that wraps ioctls and
> returns which path the ioctl took, and another one to fail that path
> if
> inspection of the result in userspace comes to the conclusion that
> it's
> a path error. I didn't think this could be implemented without also
> allowing an unprivileged process to DoS the device by just failing
> all
> paths even if they are still good, so we didn't continue there.

This doesn't sound too promising IMO.

If we want to find a solution that's focused on user space, I'd suggest
to use multipathd rather than additional ioctls. After all, all
necessary information is available in multipathd.

Already today, qemu can use the multipath socket to query the current
state of paths in a map. I can imagine a new multipathd CLI command
that would instruct multipathd to check all paths of a given map
immediately (@Ben: set pp->tick to 1 for all paths of the map). This
command could be sent to multipathd in case of a suspected path
failure. This would have similar semantics as the
DM_MPATH_PROBE_PATHS_CMD ioctl, with some advantages, as it would take
the multipath configuration of the specific storage array into account.
It'd also avoid blocking qemu. multipathd would allow this command for
non-root connections, but to avoid DoS, accept it only once every N
seconds.

> Anyway, if it actually were acceptable for the kernel to check SG_IO
> results for path errors and fail the path while still returning the
> result unchanged, then that would work for us for the specific case,
> of
> course. But I don't expect this really addresses Christoph's
> concerns.

For regular block IO, the "path error" logic is in blk_path_error() [1]
and scsi_result_to_blk_status() [2]. blk_path_error() can be called
from dm; the problem in the SG_IO code path is that we don't have a
blk_status_t to examine. Therefore, in my old code, I replicated the
logic of scsi_result_to_blk_status() in the dm layer. It works, but
it's admittedly not the cleanest possible approach. OTOH, SG_IO on dm
devices isn't the cleanest thing to do in general ;-)

> If you think it does, is there another reason why you didn't try this
> before?

It didn't occur to me back then that we could fail paths without
retrying in the kernel.

Perhaps we could have the sg driver pass the blk_status_t (which is
available on the sg level) to device mapper somehow in the sg_io_hdr
structure? That way we could entirely avoid the layering violation
between SCSI and dm. Not sure if that would be acceptible to Christoph,
as blk_status_t is supposed to be exclusive to the kernel. Can we find
a way to make sure it's passed to DM, but not to user space?

Alternatively (if maintainers strictly object the error code inspection
by dm), I wonder whether we could just _always_ fail the current path
in case of errors in the dm-mpath SG_IO code path, without inspecting
the error code. Rationale: a) most potential error conditions are
treated as "path error" in block IO code path, b) qemu can still
inspect the error code and avoid retrying for errors that aren't path
errors, and c) if multipathd is running and the path has been failed
mistakenly, it will reinstate that path after just a few seconds. In
the worst case, an unintentional failover would occur. That isn't as
bad as it used to be, as active-passive configurations with explicit
TPGS are less common then in the past.

> (And it wouldn't be generic, so would we potentially have to repeat
> the
> exercise for other ioctls in the future?)

I don't think so. Do you have anything specific in mind?

> > Doing the failover in qemu has the general disadvantage that qemu
> > has
> > no notion about the number of available and/or healthy paths; it
> > can
> > thus only guess the reasonable number of retries for any given I/O.
> > But
> > that's unavoidable, given that the idea to do kernel-level failover
> > on
> > SG_IO is rejected.
>=20
> Yes, it's a bit unfortunate, but we have to work with what we have.
> QEMU
> doesn't even necessarily know that it's dealing with a multipath
> device,
> so it just has to blindly try the ioctl and see if it works.

See the paragraph about multipathd above.

Regards
Martin

[1] https://elixir.bootlin.com/linux/v6.14.6/source/include/linux/blk_types=
.h#L185
[2] https://elixir.bootlin.com/linux/v6.14.6/source/drivers/scsi/scsi_lib.c=
#L685

PS: Yet another option that Christoph has suggested in the past would
be to move away from qemu's "scsi-block", and use the generic block
reservation mechanism to allow passthrough of reservation commands from
VMs to the host. Nobody seems to have explored this option seriously so
far.
