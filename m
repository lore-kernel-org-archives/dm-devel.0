Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A1361B4137
	for <dm-devel@lists.linux.dev>; Tue, 21 Jan 2025 11:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737457976; cv=none; b=f7dBX7qp+HmZRTyBGCyXFD31u6umEKIO+G4BJMEP21xzk7PQ4ueLBCdMfGAZAZ0a2cwa6QGMptB1QM/rnD2jJqWTI0v0nzyKUWMS+r/GEL2wue5ET+8EHMjgeD3JqLLkg4mB3dVy/5rbpy7b5R269kjUQthd+ORA0BTKJuo+3sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737457976; c=relaxed/simple;
	bh=TFRo6e4xiGmyQaVfIhTLcXciRcjyFDTGhHnKamTQMhs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=R/dLA3dMckxby6CBtdbl1Vgib3LhnwjFL2p2wVfNLUDzLP7T4RfEJllYhQsWvObnfjMvD5XnzBjcEF2afV+kJfu/YPJZ877aKrWpqK6y6njhwtFSdjxQB9cbWQDLzXSr+F+OxFdk3c8oiYCkbDcAmE0cpx68d80cXGdcaTvsCHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=k1ll4l1M; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=uO6knqpj; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="k1ll4l1M";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="uO6knqpj"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6D099211A4;
	Tue, 21 Jan 2025 11:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1737457972; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5HsJOYAmTqz6GKWl1HggZ6N9HEyn2woyxtdfwxdETnk=;
	b=k1ll4l1Mq1rFtuaMOYM1vP8rgrUgCaLohogCXw6KhigTt3iyfOAiNYa1R2odYJq/FSfqAU
	W/Io27qePuUp1eoU2AlNjirY7VBG+zkFrQ/CGD69TU/6P3P4EDwB6fyP2xNkvxLur5tgT7
	VBCyv1UOOsV+8cG9kS863xbHUcHdgMA=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1737457971; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5HsJOYAmTqz6GKWl1HggZ6N9HEyn2woyxtdfwxdETnk=;
	b=uO6knqpjC4aj3GboDR8v0D2EOFZepKd9TViI3z/xNmWoLVqY+uuiwewVx/U6csmPZmRKJB
	rpgpVpZNRsj/4RNCE4FOim/sU5Ay2KqR2RjIUuyF2NMrsreDcc4Tm/WcG5vNqOKJH4HFBo
	yaFLz1NI+WBShkRcdqonlRebtebDJ+Y=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4601F1387C;
	Tue, 21 Jan 2025 11:12:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YPF/DzOBj2duTAAAD6G6ig
	(envelope-from <mwilck@suse.com>); Tue, 21 Jan 2025 11:12:51 +0000
Message-ID: <bd30c82ae259c15cfcb9b26985c3a6c139986822.camel@suse.com>
Subject: Re: [PATCH v3 15/15] multipathd: enable pathgroups in
 checker_finished()
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, 
	dm-devel@lists.linux.dev
Date: Tue, 21 Jan 2025 12:12:50 +0100
In-Reply-To: <Z47hizoQciL5Yp-E@redhat.com>
References: <20250117202738.126196-1-mwilck@suse.com>
	 <20250117202738.126196-16-mwilck@suse.com> <Z47hizoQciL5Yp-E@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[bootlin.com:url,suse.com:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Level: 

On Mon, 2025-01-20 at 18:51 -0500, Benjamin Marzinski wrote:
> On Fri, Jan 17, 2025 at 09:27:38PM +0100, Martin Wilck wrote:
> > multipathd calls enable_group() from update_path_state() if a path
> > in a
> > previously disabled pathgroup is reinstated. This call may be
> > mistakenly
> > skipped if the path group status wasn't up-to-date while
> > update_path_state()
> > was executed. This can happen after applying the previous patch
> > "multipathd:
> > sync maps at end of checkerloop", if the kernel has disabled the
> > group during
> > the last checker interval.
> >=20
> > Therefore add another check in checker_finished() after calling
> > sync_mpp(),
> > and enable groups if necessary. This step can be skipped if the map
> > was
> > reloaded, because after a reload, all pathgroups are enabled by
> > default.
>=20
> The logic running in checker_finished() isn't the same as the logic
> running in update_path_state(). It update_path_state(), we only
> enable a
> pathgroup when a path switches to PATH_UP. In checker_finished(), we
> enable it whenever a path is in PATH_UP. I worry that this might not
> always be correct. Perhaps instead of just checking if the path is in
> PATH_UP, we should also make sure that pp->is_checked isn't in
> CHECK_PATH_SKIPPED, which would mean that the checker is pending or
> messed up, and the path is using its old state. This still assumes
> that
> the path switched to some other state before the pathgroup got
> delayed
> in re-initializing again, but that seems pretty safe. I just don't
> want
> to go re-enabling pathgroups where the controller is actually busy,
> since I'm pretty sure that the kernel usually does the right thing
> without multipathd's help.

OK. I'll see if I can add a test for the checker state.

> Alternatively, we could make the check_finished() logic match the
> update_path_state() logic exactly by just setting a flag in the
> path's
> pathgroup during enable_group() (and possibly not call
> dm_enablegroup()
> at all,=C2=A0

That was my first thought, but it doesn't work, because we call =20
free_pgvec(mpp->pg, KEEP_PATHS) update_multipath_strings(), and
reallocate the vector in disassemble_map. I guess we could change that,
but it would be another intrusive patch set. Currently we just can't
store any persistent properties in struct pathgroup.

> but I suppose that there could be a benefit to re-enabling the
> group as soon as possible. I'm still kinda fuzzy on whether the
> kernel's
> own pathgroup re-enabling code makes all this redundant).

The kernel will even try "bypassed" PGs if it finds no other. But that
means that e.g. the marginal pathgroup would be tried before disabled
PGs [1]. In general, I don't think we can rely on the kernel in this
respect.

>  Then, in
> enable_pathrgoups(), instead of checking each path, we just need to
> check if pgp->need_reenable is set for the pathgroup().

As I said, as long as we discard the PGs, I guess we'll have to test
the path flags. It's difficult to come up with a decent test case for
this, in particular if checking for PATH_UP is not enough...


> [...]
>=20
> But perhaps the best answer is to just to say that this is a corner
> case
> where we skip a multipathd action that might be totally unnecessary.
> And
> even if it is a problem, it will be fixed if multipathd ever decides
> that the kernel is using the wrong pathgroup and should switch, or
> whenever the table gets reloaded. Maybe the whole patch is
> unnecessary.

I'm going to submit a v4 that adds a test for the checker flags.

Btw, I could only find one place in the kernel code where the kernel
actively sets the "bypassed" flag, when the SCSI device handler returns
SCSL_DH_DEV_TEMP_BUSY [2]. This seems rather questionable to me. First
of all, this seems to assume that PGs are mapped to "controllers", i.e.
something like "group_by_tpg", which isn't necessarily the case.
Second, while the EMC device handler uses this error code in this way,
in the ALUA handler it rather means a memory allocation failure, and
the other device handlers don't support it at all.

I think we can conclude that the kernel setting "bypassed" on a path
group by itself is indeed a corner case, except for EMC Clariion, which
is quite dated by now.

> Thoughts? I'm clearly thinking too much.
>=20

No, you are not. I strongly appreciate these comments.

Regards,
Martin

[1] Unrelated wild thought: in view of the logic the kernel applies for
"bypassed" PGs, it might actually make sense to use this flag for=20
marginal pathgroups. They would be tried if all else fails, which is
more or less the behavior we want for them. What do you think?

[2] https://elixir.bootlin.com/linux/v6.12.6/source/drivers/md/dm-mpath.c#L=
1564

