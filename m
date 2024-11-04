Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D4A1BD039
	for <dm-devel@lists.linux.dev>; Mon,  4 Nov 2024 17:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730740295; cv=none; b=jvGy7NDQu/seFaZIK5EEXQ2s0um5Xk6a9eQ40Us3Ou1qL5QpKmst5sm3Ys8We5FNrAq+shlpZ1Hfg3Qt0FEs6xxYlHemTgPhevHL0P4o/KDZcba4VK+ay/FIXENbtpDE3+pRD0nW7TK77UydzrfEtC4BIhtM6owk3505V+Q3Fn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730740295; c=relaxed/simple;
	bh=rGHN7I6unPAiu2qHUKZ/yla9xsoHe+v7Q+KNqOXzH+k=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VHbTbnLHe1YYj1MYiVNpu+GJITs5IFz9yO03q3zJ2C5MM7ghR8CzM6PFuTc3HjkjGGaKRlAfwF62xCORDr6GWaiyYV1sK4AffHhcuhW+8u1bi8jhh1Lp/P0yYqIUDa9yZmUTosXc8K/KhuJR07nhfWz3RDoNEV0G+l5cFaSK6es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=m+3gKAYI; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=m+3gKAYI; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="m+3gKAYI";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="m+3gKAYI"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 34F2B21BB6;
	Mon,  4 Nov 2024 17:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1730740290; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rGHN7I6unPAiu2qHUKZ/yla9xsoHe+v7Q+KNqOXzH+k=;
	b=m+3gKAYIZ8ZcV2Uihkhy7NYZxbWEMCxmJr+xZoT9Ka39O7ZSa+OA5Xnnq73Oq4Rsf1zBAQ
	Pq8fd3PsNwr3CR6C/Lj/POvbgQ/nHuJSoHH9GFWLrUjtI8qJ3QkfDTziBCGXXdDZu31IYI
	BPUmMCSr7yO7nEnExSjqhVMCdXMtjUU=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1730740290; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rGHN7I6unPAiu2qHUKZ/yla9xsoHe+v7Q+KNqOXzH+k=;
	b=m+3gKAYIZ8ZcV2Uihkhy7NYZxbWEMCxmJr+xZoT9Ka39O7ZSa+OA5Xnnq73Oq4Rsf1zBAQ
	Pq8fd3PsNwr3CR6C/Lj/POvbgQ/nHuJSoHH9GFWLrUjtI8qJ3QkfDTziBCGXXdDZu31IYI
	BPUmMCSr7yO7nEnExSjqhVMCdXMtjUU=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 02AFF13736;
	Mon,  4 Nov 2024 17:11:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3pWwOkEAKWcCNwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Mon, 04 Nov 2024 17:11:29 +0000
Message-ID: <34c62d0956bffb0237623960849de7d02f7eb465.camel@suse.com>
Subject: Re: [PATCH v2 5/5] 11-dm-mpath.rules.in: set .DM_NOSCAN if
 MPATH_UNCHANGED is set
From: Martin Wilck <mwilck@suse.com>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>, Zdenek Kabelac	
 <zkabelac@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>,
  Benjamin Marzinski	 <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Date: Mon, 04 Nov 2024 18:11:29 +0100
In-Reply-To: <04e0c494-a04d-49e1-861d-77738b799c91@gmail.com>
References: <20241103224349.42582-1-mwilck@suse.com>
	 <20241103224349.42582-6-mwilck@suse.com>
	 <3edf87cf-a698-4415-9fd0-b4f7eb40bd61@redhat.com>
	 <753040e488750a3fcd3b911b741173bace4c0cb3.camel@suse.com>
	 <04e0c494-a04d-49e1-861d-77738b799c91@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Score: -2.80
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_TO(0.00)[gmail.com,redhat.com,opensvc.com];
	TAGGED_RCPT(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid]
X-Spam-Flag: NO
X-Spam-Level: 

On Mon, 2024-11-04 at 17:55 +0100, Zdenek Kabelac wrote:
> Dne 04. 11. 24 v 16:03 Martin Wilck napsal(a):
> > On Mon, 2024-11-04 at 15:00 +0100, Zdenek Kabelac wrote:
> > > Dne 03. 11. 24 v 23:43 Martin Wilck napsal(a):
> > > > When multipath reloads a device or fails or restores a path,
> > > > the
> > > > udev
> > > > rules disable LVM scanning, but since .DM_NOSCAN isn't set,
> > > > blkid
> > > > is
> > > > still run on the device. When multipath devices that are set to
> > > > queue_if_no_path lose all their paths at close to the same
> > > > time,
> > > > udev
> > But note that multipath is overloading the .DM_NOSCAN flag here to
> > tell
> > higher layers that blkid shouldn't be run in the first place if a
> > multipath map is in a certain state (we're reusing this flag, which
> > was
> > originally created for LVM, in a similar but not identical case
> > where
> > we want the blkid call to be skipped).
> >=20
> > Unlike LVM, multipath has no way to set a UUID with special
> > properties,
> > because multipath doesn't own any meta data on disk. In the case of
> > multipath, the .DM_NOSCAN property can, and will, change for a map
> > while its UUID remains constant. That's what this patch is about.
>=20
> Hi
>=20
> It's been more about the idea - that you can try to communicate some
> protocol logic for 'libblkid' in some way - that will automatically
> make sure blkid will not try to open device in these unwanted cases.
>=20
> It could be possibly something like:
>=20
> if DM device is=C2=A0 'mpath' &&=C2=A0 file=C2=A0 /run/mpath/do_not_open_=
MPATH_UUID
> exists
> the this will be makeing libblkid think it's a device it should not
> be opened.
>=20
> Then mpath tool is just manages present of this file - so this way
> you
> do not rely on works of any udev flag.

We'd still need to manipulate these "flag" files through udev rules,
and we'd have to make sure no stale such file remain in place. I don't
see the advantage of this approach yet (for multipath).

We are are already using this sort of "flag file" mechanism to
communicate between udev rules and multipathd, where environment
variables can't be used. Again, in the LVM case, certain devices are
always "private" to LVM and it makes no sense to run blkid on them, not
even manually. But that isn't the case for multipath.

Martin

