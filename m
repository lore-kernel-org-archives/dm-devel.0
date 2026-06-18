Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D82DD34888F
	for <dm-devel@lists.linux.dev>; Thu, 18 Jun 2026 19:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781811647; cv=none; b=lh6J8JumBUUNg0IRyFjfXMUS2n+Q61ksjpg/7yW+MVo0NSpkLtjonQxmgplUvknBe9z8Ar+zjZ2xx2TqQoeTleYlBD//vzIONPqG2vQc6iZwas3sKuTPSskw6pQR1qCd8dCaF/BTmHoBk1kQCQW32YLv0Jgj0JQdpQPP8NV/o9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781811647; c=relaxed/simple;
	bh=5zTZ+HNPGMfVQwRmpRYBJxQJKFhq5UfN8dn7BciDoEc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sgOZEysmcPrHcLxAXncR7RlKsJTTxz9RL2KrnFkNK+pfX8aw7Od8O2GPMTCeYUib8706BixlrT/nji2NqKTiP6ryz0gvJGQsrVOelITSXA6RE/1LvfYp14l5S1sXxhwvQ67WIftRZcnInCA9QS5wPwnfUJhCRiQJTISdogknlZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=HVs8C4hu; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=HVs8C4hu; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="HVs8C4hu";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="HVs8C4hu"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0D1C476183;
	Thu, 18 Jun 2026 19:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781811644; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5zTZ+HNPGMfVQwRmpRYBJxQJKFhq5UfN8dn7BciDoEc=;
	b=HVs8C4huzqbGYOZ3TADg2U7R63CwBgYUUC5fwTZ+p4aVbpKboHO2rVvP0TMBiJZUp+uHEA
	X0HOpit7KkLTiwTpy0Gr4VGUIUTnFUXsENnOZq/dFM+ftvQH97hxJ+1JKTAhbnbCc6pLJ3
	0QxT6l843YkFDPrHZR5Ozv1mZ0hH37Q=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=HVs8C4hu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781811644; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5zTZ+HNPGMfVQwRmpRYBJxQJKFhq5UfN8dn7BciDoEc=;
	b=HVs8C4huzqbGYOZ3TADg2U7R63CwBgYUUC5fwTZ+p4aVbpKboHO2rVvP0TMBiJZUp+uHEA
	X0HOpit7KkLTiwTpy0Gr4VGUIUTnFUXsENnOZq/dFM+ftvQH97hxJ+1JKTAhbnbCc6pLJ3
	0QxT6l843YkFDPrHZR5Ozv1mZ0hH37Q=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E1964779A8;
	Thu, 18 Jun 2026 19:40:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7SL8NbtJNGpcSgAAD6G6ig
	(envelope-from <mwilck@suse.com>); Thu, 18 Jun 2026 19:40:43 +0000
Message-ID: <f89b9b8786568c48d50cd168db49ea10fd92115d.camel@suse.com>
Subject: Re: [PATCH v2 5/8] multipath-tools: clarify path selector
 descriptions in multipath.conf.5
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>, Benjamin Marzinski
	 <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, DM_DEVEL-ML
	 <dm-devel@lists.linux.dev>
Date: Thu, 18 Jun 2026 21:40:43 +0200
In-Reply-To: <32468762-a81d-4a8f-bbab-0874bb696681@gmail.com>
References: <20260616122909.244619-1-xose.vazquez@gmail.com>
	 <20260616122909.244619-6-xose.vazquez@gmail.com>
	 <ajHKli7e2XP82alM@redhat.com>
	 <32468762-a81d-4a8f-bbab-0874bb696681@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 0D1C476183
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,redhat.com];
	TO_DN_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_TRACE(0.00)[suse.com:+];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:mid,suse.com:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On Thu, 2026-06-18 at 15:47 +0200, Xose Vazquez Perez wrote:
> On 6/17/26 12:13 AM, Benjamin Marzinski wrote:
>=20
> > On Tue, Jun 16, 2026 at 02:29:01PM +0200, Xose Vazquez Perez wrote:
>=20
> > > +Choose the path for the next I/O request by \fBcycling through
> > > the path groups\fR.
> >=20
> > This isn't a strong objections, but personally, I'm not sure
> > "groups"
> > makes this better. It kind of sounds like paths are picked from
> > multiple
> > path groups. Perhaps:
> > "cycling through the paths"
> > or
> > "cycling through the paths in the path group"
> >=20
> > I'm also o.k. with leaving it as you have it.
> You are absolutely right. Using the plural "groups" breaks the
> coherence
> of the sentence because I/O is cycled within the active path group,
> not between different groups.
>=20
> I'll restore the singular form in v3. Thanks

Right, my bad, sorry.
