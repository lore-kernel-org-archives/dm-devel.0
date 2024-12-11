Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC97E1C4A02
	for <dm-devel@lists.linux.dev>; Wed, 11 Dec 2024 20:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733948464; cv=none; b=tum+pAnBJ/clOLq8fOzxLrwP/1x6Df5FMk7jcy8MhWP9fUSIPNeD0C+vPWssHFyL2V8JWQ7hQJejwHTFT/8lw5Br+xwAPWZrQYaE/BWY5nEyZekRho6iENB/2/J+c3M0xIPX1QaJh+JF5jKnAZ4JJ8WRUTztNZNByekn7gNiu0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733948464; c=relaxed/simple;
	bh=EJixyHS7MHj13McybYEP+Ko93nEcVVAyoGUcMiyYFlo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PmYgm6vbYytl+4mc5NAMernoXgNjBvQ8RsjRwfTZoTOESM+TGA+y51MDP4OhwA4/4b+sdD77ZPDvVZTcRW3ZxzxoZ9a7VaNhn4A0NJ975eMn5nKsx0X1mlFVt/NUEfmoWdOEOouQRghJLoE04Q6xCdcW9yegIHmSycErdl0wyHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=m0UslV+d; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=m0UslV+d; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="m0UslV+d";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="m0UslV+d"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2D89521181;
	Wed, 11 Dec 2024 20:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1733948459; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EJixyHS7MHj13McybYEP+Ko93nEcVVAyoGUcMiyYFlo=;
	b=m0UslV+dNE16V0bGjNMVDiTU75ZCbZ+hIniVfNNelVJKh/JC8bdaio3jigHTUSvyTgVl/L
	VgIE8Fx6eN7bjjBKq91zYxG4BXFjPSZPa2S7FjhPBKlbffr/eu4bLdyz+QyY4jzhc3hY5k
	iBH8b2W+aStq/pR4ed7SI8EIHvPmj4M=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1733948459; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EJixyHS7MHj13McybYEP+Ko93nEcVVAyoGUcMiyYFlo=;
	b=m0UslV+dNE16V0bGjNMVDiTU75ZCbZ+hIniVfNNelVJKh/JC8bdaio3jigHTUSvyTgVl/L
	VgIE8Fx6eN7bjjBKq91zYxG4BXFjPSZPa2S7FjhPBKlbffr/eu4bLdyz+QyY4jzhc3hY5k
	iBH8b2W+aStq/pR4ed7SI8EIHvPmj4M=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 07A2813983;
	Wed, 11 Dec 2024 20:20:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IZpJACv0WWdFHAAAD6G6ig
	(envelope-from <mwilck@suse.com>); Wed, 11 Dec 2024 20:20:59 +0000
Message-ID: <30fccbf041abd3af27f0228b51df431a2ca8438a.camel@suse.com>
Subject: Re: [PATCH 03/13] multipathd: allow map removal in do_sync_mpp()
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, 
	dm-devel@lists.linux.dev
Date: Wed, 11 Dec 2024 21:20:58 +0100
In-Reply-To: <Z1nHUk8o3_qqPwED@redhat.com>
References: <20241206233617.382200-1-mwilck@suse.com>
	 <20241206233617.382200-4-mwilck@suse.com> <Z1jPMVejcI61qP9z@redhat.com>
	 <ee6fcbda31fd1f13969653782417fbed748f5bc7.camel@suse.com>
	 <Z1nHUk8o3_qqPwED@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid]
X-Spam-Flag: NO
X-Spam-Level: 

On Wed, 2024-12-11 at 12:09 -0500, Benjamin Marzinski wrote:
> On Wed, Dec 11, 2024 at 01:06:46PM +0100, Martin Wilck wrote:
> > On Tue, 2024-12-10 at 18:30 -0500, Benjamin Marzinski wrote:
> > > On Sat, Dec 07, 2024 at 12:36:07AM +0100, Martin Wilck wrote:
> > > > We previously didn't allow map removal inside the checker loop.
> > > > But
> > > > with the late updates to the checkerloop code, it should be
> > > > safe to
> > > > orphan
> > > > paths and delete maps even in this situation. We remove such
> > > > maps
> > > > everywhere
> > > > else in the code already, whenever refresh_multipath() or
> > > > setup_multipath()
> > > > is called.
> > >=20
> > > Actually, thinking about this more, what do we get by proactively
> > > deleting the multipath device if something goes wrong in the
> > > checker?
> > > If
> > > we successfully reload a device, but can't sync it with the
> > > kernel,
> > > that's one thing, But that was triggered by a change in the
> > > device,
> > > and
> > > we know that when we reloaded the device, device-mapper was
> > > working.
> > > I'm
> > > leery of possibly deleting the map because of a transient device-
> > > mapper
> > > issue.=C2=A0 I'm not sure if on a check that we do repeatedly, we
> > > should
> > > delete the device on an error.=C2=A0 We haven't in the past, and as
> > > far as
> > > I
> > > know, it doesn't cause problems.=C2=A0=20
> >=20
> > I don't disagree. But the same can be said for basically all call
> > chains where setup_multipath() is called for an existing map. I was
> > just following the pattern that we use e.g. in ev_add_path(), or in
> > update_mpp_prio(). Why would we treat the checker and path addition
> > differently in this respect?
>=20
> I'm confused here.=C2=A0

Well, I was writing confused things. My thinking was going in circles
about the removal of paths and maps, and I didn't properly distinguish
between map reloading and updating the state from the kernel.

Sorry.

> ev_add_path() doesn't remove the device if the reload
> fails. If a reload fails, the table should stay the same. That's why
> I
> said that in other cases where we delete the device, we know that
> when
> we just reloaded the device, device-mapper was working. Looking at
> the
> code, that isn't really true. After failed reloads, we still call
> setup_multipath to update our state, and we will delete the device if
> that fails.


> This is why we call setup_multipath after failed reloads, to make
> sure
> multipathd's view of the multipath device resyncs with the kernel's,
> which hasn't changed from what it was before the reload failed.

Right.

> > In the checker, this can't happen. Obviously, no other process can
> > grab
> > a path device while the device mapper is holding it, so -EBUSY
> > won't
> > occur if we reload an existing map. Even device deletion doesn't
> > cause
> > failure on reload. It is possible to delete a SCSI device while
> > it's
> > mapped, and execute a table reload / suspend / resume cycle on the
> > map
> > while referencing the deleted device. The kernel keeps holding the
> > reference to the deleted device, and will simply mark it as
> > failed.=C2=A0This holds also if the mapped paths are re-grouped or re-
> > ordered in the table. Failure occurs only if we temporarily remove
> > the
> > device from the map and re-add it, because as soon as the device is
> > removed from the map's dm table, its refcount drops to zero, and
> > it's
> > gone for good.
> >=20
> > IOW, reloading a map with a table containing only already-mapped
> > devices will never fail, except in extreme situations like kernel
> > OOM.
>=20
> Maybe I should clarify my position a bit. I am fine with reloading
> the
> device in the checkerloop if something has changed. This obviously
> does run a very small risk of something going wrong and a device
> getting
> removed unnecessarily, but we know that we need to reload the device,
> so
> we should.
>=20
> What I would rather avoid is reloading the device because we failed
> to
> get it's state in do_sync_mpp().

FTR, in my v4 patchset, I won't try to do that any more.

> I'm not actually worried about the kernel so much as libdevmapper. It
> is
> not designed for multi-threaded processes, and that has bitten us in
> the
> past. For intance, it's why we don't delete devices in dmevent_loop()
> on
> libdevmapper errors. dm_get_events() just waits and retries if
> getting
> the device list fails, and for each device, it calls dm_is_mpath and
> will only delete a device on DM_IS_MPATH_NO, which is what I
> suggested
> for the cleanup function.
>=20
> I'm pretty sure we've handled all of the known issues here, with
> fixes
> like:
> 02d4bf07 ("libmultipath: protect racy libdevmapper calls with a
> mutex")
> 34e01d2f ("multipath-tools: don't call dm_lib_release() any more")
>=20
> I'd rather not risk having missed some issue that could cause a
> temporary error in a function that we call every couple of seconds
> (almost always unnecessarily).

Ok, getting it. I thought that an error in DM_TABLE_STATUS must almost
neccessarily mean -ENXIO (from the kernel pov), which would mean that
some external entity removed the device, and that we should act as if
someone had used the "remove map" CLI command. But I didn't think about
libdevmapper.

Martin

