Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969F84AEE0
	for <dm-devel@lists.linux.dev>; Fri, 12 Apr 2024 07:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712906490; cv=none; b=lxh+XuNMG2K74Lu8SU4wCXlEDWbKomK7zchez4SkUWPqfANKxpMey4BsHzg4xHDnTLmMg/jteWIwVmtA97SvjDrx5p2ssJOGdoLAsKVQvNgjrAWu+jfux/qtJX5viD7y+UCfrMNUgDV4omIltm/QJkim3aLdciCBVMbfw7j7yVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712906490; c=relaxed/simple;
	bh=IXMwaKyf2Lq16MMhiN3Mdu467lK1RY9yTo+GETuFYrA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iIUBZqAMvyTRjnzBVBZZG1beTqspFQ4J8JAl0td7H3FvTSalsSOPly7DKxm2a7eh2Cx6tPUxv6v3JbVRjmS8v3nAwVs0MPHgXBTM8qP+MbQ5rmDCoR6eyPXexqrOi+Z5K6FxRUwtEasjWU8nHPHCDg5SVYSk7QvwUaHLCjOzpx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=NpBT/ezv; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=NpBT/ezv; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="NpBT/ezv";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="NpBT/ezv"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7EAB25F97D;
	Fri, 12 Apr 2024 07:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1712906480; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IXMwaKyf2Lq16MMhiN3Mdu467lK1RY9yTo+GETuFYrA=;
	b=NpBT/ezvwbyyP9sau5H4P+AmNi9cWxygbQ9+o7WSOf0e+dEnGXqxspLrocPrQxoqhu1G97
	Zdd5xNFY0lIgI8aE3hRpyNC2dC4tOR51heF2nrovX8/beJ8o3OCLXTxieQZlxgORzVTZF1
	FwCnUQHDsO716RBh3kJVftXB5VHaoqQ=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="NpBT/ezv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1712906480; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IXMwaKyf2Lq16MMhiN3Mdu467lK1RY9yTo+GETuFYrA=;
	b=NpBT/ezvwbyyP9sau5H4P+AmNi9cWxygbQ9+o7WSOf0e+dEnGXqxspLrocPrQxoqhu1G97
	Zdd5xNFY0lIgI8aE3hRpyNC2dC4tOR51heF2nrovX8/beJ8o3OCLXTxieQZlxgORzVTZF1
	FwCnUQHDsO716RBh3kJVftXB5VHaoqQ=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3F4BB13942;
	Fri, 12 Apr 2024 07:21:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id x0y1DfDgGGaNZwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Fri, 12 Apr 2024 07:21:20 +0000
Message-ID: <20c44a0ebb3aef1c6924aa7ab6006785330bb744.camel@suse.com>
Subject: Re: Problem with [PATCH] libmultipath: fix max_sectors_kb on adding
 path
From: Martin Wilck <mwilck@suse.com>
To: Hannes Reinecke <hare@suse.com>, "bmarzins@redhat.com"
 <bmarzins@redhat.com>,  Etienne Aujames <eaujames@ddn.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, 
	nilesh.javali@marvell.com, DM-DEVEL ML <dm-devel@lists.linux.dev>
Date: Fri, 12 Apr 2024 09:21:11 +0200
In-Reply-To: <13eefee4-02ab-4cdf-b317-6a8585b4afdf@suse.com>
References: <ac898b4b79947c22d510bb365e9b507faac1f016.camel@ddn.com>
	 <9bb4ca089c3d2dd5b331df88f3f89953916b0b17.camel@suse.com>
	 <7742003e19b5a49398067dc0c59dfa8ddeffc3d7.camel@suse.com>
	 <13eefee4-02ab-4cdf-b317-6a8585b4afdf@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.0 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 7EAB25F97D
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:dkim];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.com:+]

On Fri, 2024-04-12 at 08:06 +0200, Hannes Reinecke wrote:
> >=20
> We have gone into great pains in the kernel to ensure the queue
> limits
> are sane, and updated correctly. Even for stacking devices.

This is true, but only for the creation of stacked devices (table
activation, as far as device mapper is concerned). Admins are free to
change max_sectors_kb any time; there's no propagation of changed
settings along the device stack, and no sanity checking in the kernel
prevents them from setting values that will cause I/O errors.

> I sinserely doubt we need this patch from multipath anymore.
> Having to adjust max_sectors_kb really should be reserved for
> corner-cases where the user has a dodgy hardware which doesn't
> report correct limits.

Right. We've seen a couple of cases where decreasing max_sectors_kb
from the default value was the only remedy for weird I/O failures. This
happened with remote storage reporting wrong limits, misbehaving
elements in the fabric, and even with virtualized IO stacks.

> But even that should rather be handled by blacklisting.
> Can't we just set max_sectors_kb to readonly in the kernel and
> be done with it?

Personally, I think this goes a bit too far. I believe the kernel
should disallow changing (more specifically, decreasing) the
max_sectors_kb sysfs attribute for block devices that are either in use
(bd_openers > 0) or held by other block devices (bd_holder !=3D NULL).
That would eliminate a large portion of bad cases, AFAICS. Admins could
still increase max_sectors_kb at the top of the device stack, but that
would arguably count as shooting oneself into the foot.

Errors in valid configurations are possible, even without changing
max_sectors_kb in sysfs. Consider a multipath map consisting of devices
with different max_sectors (for example mixed iSCSI/tcp and
iSCSI/bnx2i). If only the paths with large max_sectors are initially
detected, and others are added later, the map's max_sectors will be
decreased while in use, and the change will not be propagated to
stacked block layers above multipath: bummer. The only way to avoid
this in general is implementing limit propagation. I assume that the
implementation of block limit propagation in the kernel would be a
major effort with lots of possible race conditions. It's far easier to
have admins simply impose max_sectors_kb on multipath maps in corner
case scenarios like this.

Regards,
Martin

