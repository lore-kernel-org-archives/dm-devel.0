Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D0E21D590
	for <dm-devel@lists.linux.dev>; Wed, 27 May 2026 14:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779891109; cv=none; b=oYBZlc1flJ4V0m9NJ+L/B3ZzIzf2XaE2p49Y4wP6leSjpyCQfkmLaEBaOgRWukRkKfhi4yKGzASTvIE7nv9mwFGo7tD2Z0x4t97YCzH/g90LW2EHn1W1XhmsfigT/iZ34SNHRvTwRf4DE82Fcte8rf0C/B3nMyTWqIu6feAfpsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779891109; c=relaxed/simple;
	bh=9sEg7dq2wZAMPTSVNCQPDZQotGeTr+GV0KQ505qKc/4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fplm8sjcSOvctl1n+uq9HP+NfaXwineDC0tMwX6bILlbAj1ryf+1WNUjoqE+aOrMXxAjNlx/FjMH3i2WZ6w+X5Dmn6Yl1JH5BSTFaOqyJhjwIJUMoNSvHNe/oGkRH0J6+cTS/WFIyWfvDWo1uA2GnDn6KcOGSyjHfRz1TiBHeqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=s7fst1S6; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=s7fst1S6; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="s7fst1S6";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="s7fst1S6"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3A146678D8;
	Wed, 27 May 2026 14:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779891106; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9sEg7dq2wZAMPTSVNCQPDZQotGeTr+GV0KQ505qKc/4=;
	b=s7fst1S6SMXyhI1NKoVrsDH3arDgKBnETJmnFpFW8w1mBa7bLey/LLzJr7PYW7KOceNlOd
	ZI6hlIidPbxBmKUbiiv92GFzuO7KymbZBpfjsjQ4wMJGNuKYvjUib8ZuxDdV+piAtmLXMo
	H0BaYsoGfaObqXhUhX9k0WqAVMkWmt8=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779891106; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9sEg7dq2wZAMPTSVNCQPDZQotGeTr+GV0KQ505qKc/4=;
	b=s7fst1S6SMXyhI1NKoVrsDH3arDgKBnETJmnFpFW8w1mBa7bLey/LLzJr7PYW7KOceNlOd
	ZI6hlIidPbxBmKUbiiv92GFzuO7KymbZBpfjsjQ4wMJGNuKYvjUib8ZuxDdV+piAtmLXMo
	H0BaYsoGfaObqXhUhX9k0WqAVMkWmt8=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0F92D5A880;
	Wed, 27 May 2026 14:11:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hQx5AqL7FmoGUwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Wed, 27 May 2026 14:11:46 +0000
Message-ID: <f8ea80b80cb3e26b42e6d4dc1ec3cfedca2eb2fc.camel@suse.com>
Subject: Re: [PATCH v2 09/19] libmpathutil: runner: use shared_ptr
From: Martin Wilck <mwilck@suse.com>
To: Hannes Reinecke <hare@suse.de>, Christophe Varoqui	
 <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>,
  Brian Bunker <brian@purestorage.com>, dm-devel@lists.linux.dev
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>
Date: Wed, 27 May 2026 16:11:45 +0200
In-Reply-To: <c03305cd-5408-4b28-bcab-a43a566ce6ef@suse.de>
References: <20260522164415.846589-1-mwilck@suse.com>
	 <20260522164415.846589-10-mwilck@suse.com>
	 <5cb00fa3-159b-4463-9599-55c7f8ba702f@suse.de>
	 <f4188f6ac60be14ca4ee325f776a89184e7ef01a.camel@suse.com>
	 <c03305cd-5408-4b28-bcab-a43a566ce6ef@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Flag: NO
X-Spam-Score: -6.80
X-Spam-Level: 
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TAGGED_RCPT(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,imap1.dmz-prg2.suse.org:helo]

On Wed, 2026-05-27 at 15:13 +0200, Hannes Reinecke wrote:
> On 5/27/26 12:11, Martin Wilck wrote:
> > On Wed, 2026-05-27 at 11:40 +0200, Hannes Reinecke wrote:
> >=20
> >=20
> > > But if the path comes back we need to reinstate the checker,
> > > which
> > > not
> > > only requires additional memory (which might need a recursion
> > > into
> > > the
> > > filesystem to get free pages) but we also might need to read the
> > > checker
> > > module from disk (again). So plenty of opportunity to deaslock
> > > waithing
> > > for the disk be become readable.
> >=20
> > In checker_get(), we call add_checker_class() if the class is not
> > yet
> > loaded, which will take one ref on the class, and then
> > get_shared_ptr()
> > for every path (including the one for which add_checker_class() had
> > been called), which means we have (number of paths + 1) references
> > on
> > the class, and will only drop the last ref when multipathd calls
> > cleanup_checkers() during exit.
> >=20
> > Therefore I don't think it's possible that we unload the shared
> > library
> > prematurely, and have to reload it later.
> >=20
> Hmm.
>=20
> Really hmmmmm.
>=20
> If the checkers are loaded during startup, and unloaded on shutdown,
> there really is no point in refcounting them, is there?
> Wouldn't global pointers to each check sufficient here, avoiding
> the need for refcounting altogether?

Currently checker and prioritizer DSOs aren't loaded during startup.
They are loaded when the first path that uses the given checker is
initialized.

I agree that it would be possible to simplify the code by just loading
all checkers and prioritizers in advance, in which case we wouldn't
need refcounting, like you wrote. Actually, we don't need to use shared
objects in the first place; we could simply include all the checker and
prioritizer code in libmultipath itself.

The shared object architecture dates back to multipath-tools 0.4.9
(2008). We (actually, you ;-) ) added refcounting to fix races in=20
323090f ("Use refcounting for checkers"). So far it hasn't occured to
me to change this architecture, which has been working well for over a
decade.

Anyway, this discussion is orthogonal to my current patch set.

Regards
Martin
