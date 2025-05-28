Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D61721DE8AD
	for <dm-devel@lists.linux.dev>; Wed, 28 May 2025 20:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748465061; cv=none; b=DD8K3DfPy1oMOouchsy3AdauqN1TjV/2WC4aGvLMBg4My0RxxipoF11KRyEp/Gj/9tgzp1+HjjsoTtalvYse2dtd7W7mBvlMIFH8ohrVr7vg/vw070nfWjIHAPkW83TO6ZyyzCmHf1h5g2E4dBY8eySJ1oOEl4q/Ud4i4g5ZlK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748465061; c=relaxed/simple;
	bh=sXXLXOGOqT4dO+1XYmVPqJETrWZAlhCPuflWhIPlJrM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EYorcO7PvTwjjfddvSCAOExY45pJ6tSMh/EjMYJ7b4CuSMMx7QCdNPDLjP3V1ds6EBbN+MlygSzSGIlFiF79TgVSwTRvuMVw3Co9L0HSJfThkJ4t/iUrdnwNO3s6ntujv+nPYiVah8zkgMlFA/dmeovRip2VsN0BNVGpMAyEI/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=BJ33AZLZ; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=H+QMa7la; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="BJ33AZLZ";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="H+QMa7la"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C68411F441;
	Wed, 28 May 2025 20:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1748465058; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sXXLXOGOqT4dO+1XYmVPqJETrWZAlhCPuflWhIPlJrM=;
	b=BJ33AZLZkZtXqwYJ/6pt64wHTIFfWDob+3HWGok3c2fxxzOYB+vuqiHfyJRojS1j3Tfhkn
	wUn5xa/MHkPHvYoXM8tsxPyBkKjIbVPGyHT3VL2jAjr+Kb77IYSkF0xwwT0YGpHs4WLLYO
	GtvNkeJ2BYg/C6AZc9p6J+ZYeLQPAL4=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1748465057; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sXXLXOGOqT4dO+1XYmVPqJETrWZAlhCPuflWhIPlJrM=;
	b=H+QMa7la7DJnkJ6ln7zcBNYSmOzLTts8WTTkAOe5VtiY0t1VY5FWM9KSClHp7fZt7f4DzH
	jj8Z5F0ycft+dUStM7pIDb4W8HYPjH19nPhXW5lk3yQaX3hZ38qHPGXVhoPoM7CjbS5mWj
	MXoSrY6OcFmp11Ob17ZHiO3+X9fViqw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 77A34136E0;
	Wed, 28 May 2025 20:44:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JTVSG6F1N2g6NgAAD6G6ig
	(envelope-from <mwilck@suse.com>); Wed, 28 May 2025 20:44:17 +0000
Message-ID: <914a7e9207c028a74d5c579273b4c71b555619d7.camel@suse.com>
Subject: Re: [PATCH 0/2] dm mpath: Interface for explicit probing of active
 paths
From: Martin Wilck <mwilck@suse.com>
To: Christoph Hellwig <hch@infradead.org>, Benjamin Marzinski
	 <bmarzins@redhat.com>
Cc: Kevin Wolf <kwolf@redhat.com>, dm-devel@lists.linux.dev,
 hreitz@redhat.com, 	mpatocka@redhat.com, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>
Date: Wed, 28 May 2025 22:44:16 +0200
In-Reply-To: <aCrCYbvOJs44Kj5a@infradead.org>
References: <20250429165018.112999-1-kwolf@redhat.com>
	 <47dd225b433b0df585a25084a2e793344eeda239.camel@suse.com>
	 <aCIRUwt5BueQmlMZ@redhat.com>
	 <d51d6f85b5728648fe9c584f9cb3acee12c4873f.camel@suse.com>
	 <cc2ec011cf286cb5d119f2378ecbd7b818e46769.camel@suse.com>
	 <aCW95f8RGpLJZwSA@redhat.com> <aCbUcdew393RZIkV@infradead.org>
	 <aCdifWdCQCR3Nqb0@redhat.com> <aCrCYbvOJs44Kj5a@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	URIBL_BLOCKED(0.00)[suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -4.30

On Sun, 2025-05-18 at 22:32 -0700, Christoph Hellwig wrote:
> On Fri, May 16, 2025 at 12:06:21PM -0400, Benjamin Marzinski wrote:
> > I've run into SCSI arrays that always act like they were called
> > with the
> > ALL_TG_PT flag set (or perhaps they were just configured that way,
> > I
> > never could get a straight answer about that).
>=20
> Hmm, that's pretty strange.
>=20
> > libmpathpersist accepts
> > this flag, and only sends one registration per initiator & target
> > device
> > when it's set, instead of one per initator & target port.
>=20
> With "this flag" you mean ALL_TG_PT?

multipath-tools allows setting the flag "all_tg_pt" in multipath.conf
for certain storage devices or multipath maps. If this flag is set,
mpathpersist will always act as if the --param-alltgpt flag was given.
This means that the REGISTER commands are sent once per initiator port
(SCSI host) only, instead of once per I_T nexus.

By default,=C2=A0the all_tg_pt flag is not set for any device, not even for
EMC VNX, where Ben observed the described behavior. It seems that
devices that behave like this are a rare exception.

> > dm-multipath
> > currently doesn't have the knowledge necessary to figure out which
> > devices it needs to send reservations to, even if the kernel PR API
> > supported this.
> >=20
> > But I supposed it could just send the registration normally down
> > one
> > path and if that works, it could just ignore the existing key when
> > it
> > sends the registration down all the other paths.
>=20
> We could add support for a similar flag to the kernel PR API.=C2=A0 The
> problem is to figure out how to discover support for it.=C2=A0 What does
> the library do for that currently?

dm-multipath has no knowledge about target or initiator ports, and I
fail to see how we could provide this knowledge to it without adding
yet another layering violation. Just sending the command once will not
be sufficient if there are multiple local ports.

Regards
Martin
