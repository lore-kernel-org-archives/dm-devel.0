Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849401E5718
	for <dm-devel@lists.linux.dev>; Tue, 13 May 2025 07:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119996; cv=none; b=VS7xmZvc3FfA7H+kb69OHs0D7gVkiC6x5BKTFNYCUJ3YXSf37aZRwYE4NDiVoJs6c/Cbjh92UqdypbrD8LSk39G5iGBw0crr2evR6lU8+45ZNug5iyZE+1XsNw5uPlJBb8E7fyTQ9Y3poXQqFTTRZmi6IIEVidmLKbVpps3PAls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119996; c=relaxed/simple;
	bh=HrY8RXQw+0LoYZLU9N77Uq02JLsXugCfMucRRJyH5LQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QhgoZdbEspw2D1rtFektfe1qU8SSNI5Ma7BzT/jeNPSI5QVxq1xU4cYjl8VpvuzUNwuw/XWSsC6FFlqGhcAb01ab75oIeZmNK4Eih+S2aZ5Iwv7gwCbeEJxb+8kzF0bhvGy5XrELg7O71qdcqhwyY99fJYk7iJM26xkhK7HRLgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=bKSqtD8M; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=bKSqtD8M; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="bKSqtD8M";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="bKSqtD8M"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 91E932119D;
	Tue, 13 May 2025 07:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1747119992; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E4RNMeAGwPkYmbKq0c3z5PMFjKyvJtYRCxiTSBCv/aM=;
	b=bKSqtD8MjCEm030QMcGkVEzSveBlUpyIUZrpXPxgYGa3R1qfDbeLYB8splD9c26SUFr8WI
	4mKM228sn7mbbklJANpSnBchocjH9SIBZUrhpdxUFF76X54AfG9GqNC7Te9hJZ2dWeXLOj
	CNHkWEeg+zUfIhV+U7jQMQuuQbMX3Jo=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=bKSqtD8M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1747119992; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E4RNMeAGwPkYmbKq0c3z5PMFjKyvJtYRCxiTSBCv/aM=;
	b=bKSqtD8MjCEm030QMcGkVEzSveBlUpyIUZrpXPxgYGa3R1qfDbeLYB8splD9c26SUFr8WI
	4mKM228sn7mbbklJANpSnBchocjH9SIBZUrhpdxUFF76X54AfG9GqNC7Te9hJZ2dWeXLOj
	CNHkWEeg+zUfIhV+U7jQMQuuQbMX3Jo=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4BA8B1365D;
	Tue, 13 May 2025 07:06:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zH7jEHjvImhNUwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Tue, 13 May 2025 07:06:32 +0000
Message-ID: <1767e6d3757f824039b4f799157d262a8dd74ced.camel@suse.com>
Subject: Re: [PATCH 0/2] dm mpath: Interface for explicit probing of active
 paths
From: Martin Wilck <mwilck@suse.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Christoph Hellwig
 <hch@infradead.org>
Cc: Kevin Wolf <kwolf@redhat.com>, dm-devel@lists.linux.dev,
 hreitz@redhat.com, 	snitzer@kernel.org, bmarzins@redhat.com,
 linux-kernel@vger.kernel.org
Date: Tue, 13 May 2025 09:06:31 +0200
In-Reply-To: <8e009e40-a1d2-5eea-3930-f81446b16722@redhat.com>
References: <20250429165018.112999-1-kwolf@redhat.com>
		 <47dd225b433b0df585a25084a2e793344eeda239.camel@suse.com>
		 <8e009e40-a1d2-5eea-3930-f81446b16722@redhat.com>
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
X-Rspamd-Queue-Id: 91E932119D
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:mid,suse.com:dkim];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Action: no action

Hello Mikulas,

On Mon, 2025-05-12 at 15:46 +0200, Mikulas Patocka wrote:
> Hi
>=20
>=20
> On Thu, 8 May 2025, Martin Wilck wrote:
>=20
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
>=20
> Normal reads and writes would also hang in an uninterruptible sleep
> if a=20
> path stops responding.

Right. That's why multipathd uses TEST UNIT READY if supported by the
storage, and either aio or separate I/O threads to avoid the main
thread being blocked, and generally goes to great lengths to make sure
that misbehaving storage hardware can cause no freeze.

The way I read Kevin's code, you'd queue up additional IO in the same
context that had submitted the original failing IO. I realize that qemu
uses asynchronous IO, but AFAIK the details depend on the qemu options
for the individual VM, and it isn't clear to me whether or not
DM_MPATH_PROBE_PATHS_CMD can bring the entire VM to halt.

> >  [...]
> >=20
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
>=20
> What exactly do you mean? You say "you could have dm-mpath 'handle'
> IO=20
> errors by failing the active path for "path errors".

What I meant was that dm-mpath could call fail_path() in case of an
error, using a similar mechanism to the block IO code path.

> Christoph doesn't want dm-mpath can't look at the error code - so dm-
> mpath=20
> doesn't know if path error occured or not.=C2=A0

My impression from the previous discussion was that Christoph mainly
objected to SG_IO requests being retried in the kernel [1], not so much
to the inspection of the error code by device mapper.

I may have misunderstood this of course. Adding Christoph into the loop
so that he can clarify what he meant.=20

> qemu could look at the error=20
> code, but qemu doesn't know which path did the SG_IO go through - so
> it=20
> can't instruct qemu to fail that path.
>=20
> One of the possibility that we discussed was to add a path-id to
> SG_IO, so=20
> that dm-mpath would mark which path did the SG_IO go through and qemu
> could instruct dm-mpath to fail that path. But we rejected it as
> being=20
> more complicated than the current approach.

If we discuss extending SG_IO itself, it might be easier to have it
store the blkstatus_t somewhere in the sg_io_hdr. More about that idea
in my reply to Kevin.

Regards,
Martin

[1] https://lore.kernel.org/all/20210701075629.GA25768@lst.de/


> > Contrary to my set, you wouldn't attempt retries in the kernel, but
> > leave this part to qemu instead, like in the current set. That
> > would
> > avoid Christoph's main criticism that "Failing over SG_IO does not
> > make
> > sense" [2].
> >=20
> > Doing the failover in qemu has the general disadvantage that qemu
> > has
> > no notion about the number of available and/or healthy paths; it
> > can
> > thus only guess the reasonable number of retries for any given I/O.
> > But
> > that's unavoidable, given that the idea to do kernel-level failover
> > on
> > SG_IO is rejected.
> >=20
> > Please let me know your thoughts.
> >=20
> > Best Regards
> > Martin
> >=20
> > [1]
> > https://lore.kernel.org/all/20210628151558.2289-1-mwilck@suse.com/
> > [2] https://lore.kernel.org/all/20210701075629.GA25768@lst.de/
>=20
> Mikulas

