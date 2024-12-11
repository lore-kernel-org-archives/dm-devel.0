Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A046D225A2C
	for <dm-devel@lists.linux.dev>; Wed, 11 Dec 2024 12:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733918811; cv=none; b=pMoINPrDpf5ljZ09xZsBIQToVhQJPlO8KlgqSXrwFnQkLnewCj5bDNKW+rRIZm6M/tucUFB6vLxzlKhpzyBZsPFDAMtzC0r49YONwqR/WBQUlMkLhGKa6tWJXbko4R9HRg16GJsoal33HC25nS/bZUPtc8mp26s7NE5qsDFIb7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733918811; c=relaxed/simple;
	bh=ZIxXJYhCpXuyZIRyXsdAlcc73D8caRmNCtH08g5UX4s=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ere6pD/8JPPSwYigmq3jsURgltBH/ISl26uMcpxz+kcCFGwKxyzbowJQqikYSsPTTC1OP8cjJOcCnKrFD5wWMAsyO5/+slVNyIkH4nH028VPkWODmLlnN3bK2l9SIUKSLe33WIKnA0uwHqglt2c3MBjwgGBxUhrQ9iVBbFveifY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=snFrrRjx; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=snFrrRjx; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="snFrrRjx";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="snFrrRjx"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A51491F38C;
	Wed, 11 Dec 2024 12:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1733918807; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZIxXJYhCpXuyZIRyXsdAlcc73D8caRmNCtH08g5UX4s=;
	b=snFrrRjxKezFjGHTZlU9imx0XbZfZAQq8+/V60SyfCu6BUVCWHFrjpTExzG+gIoJvbvY7F
	/+icQUQXOJZLWpU3bUFUAnmr8bmTkHUa9SOhAFoZjwpUTg9Rd47UDhq0PRXr5EQHlJzBFC
	pvcnJHD8/7JQ5iagghkvrQGZm6q73TM=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=snFrrRjx
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1733918807; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZIxXJYhCpXuyZIRyXsdAlcc73D8caRmNCtH08g5UX4s=;
	b=snFrrRjxKezFjGHTZlU9imx0XbZfZAQq8+/V60SyfCu6BUVCWHFrjpTExzG+gIoJvbvY7F
	/+icQUQXOJZLWpU3bUFUAnmr8bmTkHUa9SOhAFoZjwpUTg9Rd47UDhq0PRXr5EQHlJzBFC
	pvcnJHD8/7JQ5iagghkvrQGZm6q73TM=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7EF6113983;
	Wed, 11 Dec 2024 12:06:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 47xvHVeAWWeKfQAAD6G6ig
	(envelope-from <mwilck@suse.com>); Wed, 11 Dec 2024 12:06:47 +0000
Message-ID: <ee6fcbda31fd1f13969653782417fbed748f5bc7.camel@suse.com>
Subject: Re: [PATCH 03/13] multipathd: allow map removal in do_sync_mpp()
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, 
	dm-devel@lists.linux.dev
Date: Wed, 11 Dec 2024 13:06:46 +0100
In-Reply-To: <Z1jPMVejcI61qP9z@redhat.com>
References: <20241206233617.382200-1-mwilck@suse.com>
	 <20241206233617.382200-4-mwilck@suse.com> <Z1jPMVejcI61qP9z@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Rspamd-Queue-Id: A51491F38C
X-Spam-Level: 
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:mid];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.51
X-Spam-Flag: NO

On Tue, 2024-12-10 at 18:30 -0500, Benjamin Marzinski wrote:
> On Sat, Dec 07, 2024 at 12:36:07AM +0100, Martin Wilck wrote:
> > We previously didn't allow map removal inside the checker loop. But
> > with the late updates to the checkerloop code, it should be safe to
> > orphan
> > paths and delete maps even in this situation. We remove such maps
> > everywhere
> > else in the code already, whenever refresh_multipath() or
> > setup_multipath()
> > is called.
>=20
> Actually, thinking about this more, what do we get by proactively
> deleting the multipath device if something goes wrong in the checker?
> If
> we successfully reload a device, but can't sync it with the kernel,
> that's one thing, But that was triggered by a change in the device,
> and
> we know that when we reloaded the device, device-mapper was working.
> I'm
> leery of possibly deleting the map because of a transient device-
> mapper
> issue.=C2=A0 I'm not sure if on a check that we do repeatedly, we should
> delete the device on an error.=C2=A0 We haven't in the past, and as far a=
s
> I
> know, it doesn't cause problems.=C2=A0=20

I don't disagree. But the same can be said for basically all call
chains where setup_multipath() is called for an existing map. I was
just following the pattern that we use e.g. in ev_add_path(), or in
update_mpp_prio(). Why would we treat the checker and path addition
differently in this respect?

If we look at this pragmatically (assuming that multipathd gets the
parameters right), the most probable reason for a map reload failure is
failure to open a path device in bdev_open(), either because the device
doesn't exist, or because it's busy or otherwise unavailable. If this
happens in ev_add_path(), the likely reason is that the path just added
was busy, and the smartest action upon such a failure would probably be
to just undo that addition. We currently don't do that; we remove the
entire map, which is questionable, as you state correctly.

In the checker, this can't happen. Obviously, no other process can grab
a path device while the device mapper is holding it, so -EBUSY won't
occur if we reload an existing map. Even device deletion doesn't cause
failure on reload. It is possible to delete a SCSI device while it's
mapped, and execute a table reload / suspend / resume cycle on the map
while referencing the deleted device. The kernel keeps holding the
reference to the deleted device, and will simply mark it as
failed.=C2=A0This holds also if the mapped paths are re-grouped or re-
ordered in the table. Failure occurs only if we temporarily remove the
device from the map and re-add it, because as soon as the device is
removed from the map's dm table, its refcount drops to zero, and it's
gone for good.

IOW, reloading a map with a table containing only already-mapped
devices will never fail, except in extreme situations like kernel OOM.

Thus, AFAICS, the only relevant scenario where a reloading would fail
is trying to add a path device that was not previously mapped, and
that's either busy (perhaps in another map) or has been deleted, IOW
only when we reload after calling adopt_paths(). This is where we could
improve. If we fail to reload after adopting new paths, we could fall
back to the existing table, and perhaps try to add paths one by one.
Again, this is post-0.11 material.

OTOH, practially impossible is not totally impossible, so we need to be
prepared to map reload failure either way. IMO the best thing we can do
in this case is to keep using the kernel's map, and retry reloading
later.=C2=A0

The only critical situation is WWID change of path devices. We must try
to fix this situation ASAP when we detect it. I'm unsure what the best
action is if a reload fails in that situation, though (other than
failing the path, as we already do).

Martin

