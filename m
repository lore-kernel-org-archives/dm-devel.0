Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03F65187332
	for <dm-devel@lists.linux.dev>; Fri, 17 Jan 2025 17:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737133485; cv=none; b=Kjb9oT1sM1FEsGiJTA8mIjy6di7ZNouWTLCKKyqF3P2Cca2gfSYJJHNmMefgepidxdcg+TO6fVYPTmLfDoZ86KOB9h92xupzCsgupjFpa7BazwLjJ55F7NFDB+jAQonT6KRvCMnuPTQ5AFQ2ajVuh9RG1PmMyXEl84UR+L/bpAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737133485; c=relaxed/simple;
	bh=bz8yV9oRG9itXTmA50G4SbP7D6wgiQuNdmz8HXRtY+M=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WyBtLEDtwzIRJJwLmkzmgQe02EIX4jxkds+aJ7lAdBqHw+lMXcKqchltYydLnv6Ooqx6BugOHhblS5SJDsyFDkBIZwKs1bz76xqQi7xa5EXukhF7I95z36GZP/S1llYD+ZAB0T1EkeHcJg+yHv+imJQ31EWTtQdHEt4daWcGZxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=OQIubZNd; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=OQIubZNd; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="OQIubZNd";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="OQIubZNd"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 049841F37C;
	Fri, 17 Jan 2025 17:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1737133481; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bz8yV9oRG9itXTmA50G4SbP7D6wgiQuNdmz8HXRtY+M=;
	b=OQIubZNdl46F6vK1k8+OPzWXT/De2nq8RjLLme9VgHyHkQa7w///yFdO2jhyyf4Xkfu52W
	zAmreJTg8IzWTaTy9blGEqVUWRrkBwqobBigqSZpwqIBsG4QIf2LcSClNU7JODMgJhxR+4
	QG9TW1xKDpSEBUYTS/feZDtFJjmkZyU=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=OQIubZNd
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1737133481; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bz8yV9oRG9itXTmA50G4SbP7D6wgiQuNdmz8HXRtY+M=;
	b=OQIubZNdl46F6vK1k8+OPzWXT/De2nq8RjLLme9VgHyHkQa7w///yFdO2jhyyf4Xkfu52W
	zAmreJTg8IzWTaTy9blGEqVUWRrkBwqobBigqSZpwqIBsG4QIf2LcSClNU7JODMgJhxR+4
	QG9TW1xKDpSEBUYTS/feZDtFJjmkZyU=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CE0ED13332;
	Fri, 17 Jan 2025 17:04:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0ynKMKiNimcEXQAAD6G6ig
	(envelope-from <mwilck@suse.com>); Fri, 17 Jan 2025 17:04:40 +0000
Message-ID: <aaa36920d015a2c10532d658348b0ba323a4dbc6.camel@suse.com>
Subject: Re: [PATCH] multipath-tools: Merge Infinidat with Lenovo in hwtable
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, DM-DEVEL ML <dm-devel@lists.linux.dev>
Date: Fri, 17 Jan 2025 18:04:40 +0100
In-Reply-To: <618c7b05-da75-449f-beae-ec8f0c3d5172@gmail.com>
References: <20250116230427.17740-1-xose.vazquez@gmail.com>
	 <5a2e75c50ce9d9e639f60377481adf6bf116460f.camel@suse.com>
	 <618c7b05-da75-449f-beae-ec8f0c3d5172@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Rspamd-Queue-Id: 049841F37C
X-Spam-Score: -3.01
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FREEMAIL_TO(0.00)[gmail.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

Hello Xose,

On Fri, 2025-01-17 at 15:16 +0100, Xose Vazquez Perez wrote:
> On 1/17/25 2:54 PM, Martin Wilck wrote:
>=20
> > On Fri, 2025-01-17 at 00:04 +0100, Xose Vazquez Perez wrote:
> > > Lenovo to acquire Infinidat:
> > > https://www.infinidat.com/en/news/press-releases/lenovo-acquire-infin=
idat-further-expanding-enterprise-storage-portfolio
> > >=20
> >=20
> > Does our hwtable have to reflect company acquisitions?
>=20
> Not directly, but it's order by vendors. So..

If device names change, any time. But just because vendor A has bought
vendor B, I don't think a code change is warranted. This kind of change
makes `git blame` more cumbersome to use, with almost no benefit.=C2=A0
The sort order in hwtable.c is not guaranteed in any way. Users who are
interested in the defaults for a given device will search for the
vendor and/or device name anyway.

Regards
Martin

