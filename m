Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FE932110
	for <dm-devel@lists.linux.dev>; Fri,  9 May 2025 14:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746800564; cv=none; b=CHxDX3p40XKdjylAVqzLHqXyLvYvg+ClDtWTq7c6lRMHTz4rsN8DeR8RkQSlGhCFxh8w5jA85wvj15RP1QcJmko2/ScMjLEmkCreqXOcZ8IV0ugGFyIQQTQlYV7aTroWiInyPqrjBJa9LBk7A14No+cPrQhLrHNnQnShMFkNYaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746800564; c=relaxed/simple;
	bh=Zs75B+Q+7wKGWIVmlwQ9YygrkkgFkF8iAA8gZTcXCPw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BHM2XUOLpIc+fJhsNsrOiu77wi+XW7b2Hb3XfDDYRrvpS8GVDuFS6OP4N4Kn6QWmnGKfezdPGReTtytiPok0nO6L2Q0SmC8LDV5qdXgm/nxU2WPcB1Z7Ps6gkl4+y4Hropz3/0flThS8CUYxI9djMnd2idYr8pahVDikbXuhVlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=VqfR3183; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=VqfR3183; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="VqfR3183";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="VqfR3183"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1ED991F38E;
	Fri,  9 May 2025 14:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1746800561; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Zs75B+Q+7wKGWIVmlwQ9YygrkkgFkF8iAA8gZTcXCPw=;
	b=VqfR3183zguM+JlgkdWgbYDQU8ex5lnLUcWBOltUADbglYyIlWR1ys84YM9KOfxp9ZPeea
	GoOd/9HzJ5cCeaZ+iDHPYuSpR9KidVXK/Lkk8H6j942kFm2RMNNgLeIqRf67rg10hd2a1V
	0l4EYIqoo0WzwVg4tgmkWldkL1RvrRA=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1746800561; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Zs75B+Q+7wKGWIVmlwQ9YygrkkgFkF8iAA8gZTcXCPw=;
	b=VqfR3183zguM+JlgkdWgbYDQU8ex5lnLUcWBOltUADbglYyIlWR1ys84YM9KOfxp9ZPeea
	GoOd/9HzJ5cCeaZ+iDHPYuSpR9KidVXK/Lkk8H6j942kFm2RMNNgLeIqRf67rg10hd2a1V
	0l4EYIqoo0WzwVg4tgmkWldkL1RvrRA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E616713931;
	Fri,  9 May 2025 14:22:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id z/uUNrAPHmhLSwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Fri, 09 May 2025 14:22:40 +0000
Message-ID: <01c09aff033bdc1ba06c7a3265c1a1a477be1a04.camel@suse.com>
Subject: Re: [PATCH] multipath-tools: replace round-robin path selector with
 the default for NFINIDAT/InfiniBox
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, DM-DEVEL ML <dm-devel@lists.linux.dev>, 
 John Meneghini <jmeneghi@redhat.com>
Date: Fri, 09 May 2025 16:22:40 +0200
In-Reply-To: <085c156c31fcd2fc5da4e889642bd6186c677a7c.camel@suse.com>
References: <20250509134459.226640-1-xose.vazquez@gmail.com>
	 <085c156c31fcd2fc5da4e889642bd6186c677a7c.camel@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Flag: NO
X-Spam-Score: -2.79
X-Spam-Level: 
X-Spamd-Result: default: False [-2.79 / 50.00];
	BAYES_HAM(-2.99)[99.94%];
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
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid,infinidat.com:email]

On Fri, 2025-05-09 at 16:08 +0200, Martin Wilck wrote:
>=20
> This code is from 55da608 ("libmultipath: update INFINIDAT builtin
> config"), signed-off by=C2=A0arnony@infinidat.com. We usually don't chang=
e
> defaults from explicit vendor recommendations without consent from
> the
> vendor. I've added Arnon to cc, maybe he wants to comment on your
> suggestion.

Arnon's email address bounces. Unless we find someone else from
Infinidat to comment, I think we should keep the current default. Users
are free to override the defaults if the aren't happy with the
performance.

Thanks
Martin
