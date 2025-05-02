Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E522D14B965
	for <dm-devel@lists.linux.dev>; Fri,  2 May 2025 10:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746180798; cv=none; b=ZcuzwudMrsyRV2wUOfcsvcMDplb27qg1C4Z9WnNYnLZ6DfPP2jO1QHHNC4AP7vKqHEltdYK0SJt259rzOfxHm7XQwoCn2xR/DYISn28uV28BXLI2zjYWerPkt7mdDKHhwTiubUMnCnKWLIdkocFrAIWPVDbIH0KElvWB9ZSKTwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746180798; c=relaxed/simple;
	bh=+WqgyI6vnuSlG5f2e9QfRE3ylPcnIhMeHn5G/pNGDLA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FfHLOiESMBp725NDh7YU0MPIHscShxcLnzuedYnWwnu9+qv63Wv7OzyIasdGcxzGjXnWtNwRRrgh9ZNsHBa89R7fhLXKWT/sfXcfk4KLOOYHBJVmSUBztH8077ijPuGSe3mO1on+aCehK3S6CQqO2JfGBHiUg8+COnsiD5+RWOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=WToHwOrH; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Sjgxu7C9; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="WToHwOrH";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Sjgxu7C9"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DF81C21228;
	Fri,  2 May 2025 10:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1746180795; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+WqgyI6vnuSlG5f2e9QfRE3ylPcnIhMeHn5G/pNGDLA=;
	b=WToHwOrHu3Omq8+WuKtJbUL40xfVKpDA96JqMo75BonE4rQix++/o5g6VabW3TkqKB2V3V
	ntBuFK8WPozRNarkfi2gCWQfnoozPV3JZcQzycyzxNoKiJ+dw8KGjLKOfqyd+JPS+C68Cp
	K7m6bvEkFsHNhLNLp4SbVpOyR/ONi+U=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1746180794; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+WqgyI6vnuSlG5f2e9QfRE3ylPcnIhMeHn5G/pNGDLA=;
	b=Sjgxu7C9Ka4WUDXMUMbngUM+dYD5MH00p4wT/Wusr557RwU0eolhXueDgN0Jj1f4/Uf8lL
	2ZL2OnMohMiqCYo0WVzhp5vBj7MTMsL+qO1V5DRkppuLMIMEOzgaWC41fFBoX3T5BLU/ql
	8xIDnJz8XJcKp2DxWwg7Jo6gJ7PQ6lI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B38E61372E;
	Fri,  2 May 2025 10:13:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mMxPKrqaFGhQZQAAD6G6ig
	(envelope-from <mwilck@suse.com>); Fri, 02 May 2025 10:13:14 +0000
Message-ID: <b0961d94d47d9d4cb61abd6ff03e05af0134222b.camel@suse.com>
Subject: Re: [PATCH 1/2] multipath-tools: hwtable: remove .pgfailback from
 QUANTUM/F1
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, DM-DEVEL ML <dm-devel@lists.linux.dev>
Date: Fri, 02 May 2025 12:13:14 +0200
In-Reply-To: <20250430134528.82361-1-xose.vazquez@gmail.com>
References: <20250430134528.82361-1-xose.vazquez@gmail.com>
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
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	ARC_NA(0.00)[];
	TAGGED_RCPT(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid]
X-Spam-Score: -2.80
X-Spam-Flag: NO

On Wed, 2025-04-30 at 15:45 +0200, Xose Vazquez Perez wrote:
> Useless without a prio
>=20
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>
