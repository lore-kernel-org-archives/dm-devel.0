Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795606966;
	b=EAUJ4fua1nNQsT/CBtjXXhT4sXFpBuoZzql97WD0uSCBT2KsAR2RsWbN2yXE0+LmMIvc
	 bjQPJMp/fXXSHJNGIcL9YvbYsmphBjhJWSQf16EX86kIzhEcQCg6MJqiHcO3s4BYsuJFa
	 dMqG8k4oUQzt0AxBK027eKm8uU8ZVL2u+rKHkSK3Hy+3Ip+LZE11yEUXNhUqgMl4b+oxw
	 E7sgkU10ntgHZoOmhQ/478v3ooMXkz/aL6wtQJ2H8RtoXMbifxpDS7fdcnJNWCsCEhyiR
	 qrvpIiN7GoD4l5OyPqapa9+VnR4ve4gUy63WNSTatXZhdVZfWeoMyk6nwoUcZl4T3eQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795606966;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version:
	 X-Rspamd-Queue-Id:X-Spam-Level:X-Rspamd-Server:X-Rspamd-Action:
	 X-Spam-Flag:X-Spamd-Result:X-Spam-Score;
	bh=VlXi/S86x8dgQRU79aRyYODqM4HwYWUGda3dNwxCuA4=;
	b=Pbel0E6v8z0JUdTF52ux1cFG59eK/gHhJcbMbRDvtQIJfqP+UwpgXkd9HWW+CPlZGjCn
	 k1JXugE47tGlmHD4NHPsLojrhvL/hTOdmJCtu6mHyka3uxPOC9Jcxt52FjvO3rfF7nSw9
	 TlpKbfCwKI/dDwesqvg1JTW7Buub+hV5OyHK8+12KRT0OPal2WM8v91VVKrnh6sGck7j9
	 /vaKVDd0PB3KVqi9OHgB6NnLdL0s8cbiyaacuBKjE28LlfN9BFtiAQ7iA3VZl9neDeHpZ
	 OzwIEnt6vPTunS3nbumrPCmFtLPkJRpNeEHF02esa40RTXF2mQxCCnBlZkhp5H4Nrwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=ViawF8aM;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=ViawF8aM;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531BE606A31E
	for <dm-devel@lists.linux.dev>; Wed, 25 Nov 2026 11:42:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 531BE606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=ViawF8aM;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=ViawF8aM
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7D7A31F7A2;
	Wed, 25 Nov 2026 11:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795606964; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VlXi/S86x8dgQRU79aRyYODqM4HwYWUGda3dNwxCuA4=;
	b=ViawF8aM5ookihdm0EwG/WUxRt8+uoBq4VZoB+VdM7omXNHgn8njbpkxd5v6Cq2SjRoljV
	mRq+1PVUIxM9R7aMwTTAFaEBXp8htsqUmhNYzaEff7EX/WpR7oZHPZbXCDukuyk50cYs5n
	JEeiWi71t6R0KKGOl6F0jLlfv44lUtg=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=ViawF8aM
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795606964; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VlXi/S86x8dgQRU79aRyYODqM4HwYWUGda3dNwxCuA4=;
	b=ViawF8aM5ookihdm0EwG/WUxRt8+uoBq4VZoB+VdM7omXNHgn8njbpkxd5v6Cq2SjRoljV
	mRq+1PVUIxM9R7aMwTTAFaEBXp8htsqUmhNYzaEff7EX/WpR7oZHPZbXCDukuyk50cYs5n
	JEeiWi71t6R0KKGOl6F0jLlfv44lUtg=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3D8C01339F;
	Wed, 25 Nov 2026 11:42:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uulgBLTJBmsrNgAAD6G6ig
	(envelope-from <mwilck@suse.com>); Wed, 25 Nov 2026 11:42:44 +0000
Message-ID: <e187be141dc1e65cb643fc5ba77c4a1cff536f99.camel@suse.com>
Subject: Re: [PATCH 5/7] multipath-tools: multipathc: print version string
 on startup
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, DM_DEVEL-ML <dm-devel@lists.linux.dev>
Date: Wed, 25 Nov 2026 12:42:43 +0100
In-Reply-To: <20261125102605.82009-6-xose.vazquez@gmail.com>
References: <20261125102605.82009-1-xose.vazquez@gmail.com>
	 <20261125102605.82009-6-xose.vazquez@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.62.1 
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Rspamd-Queue-Id: 7D7A31F7A2
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-12.01 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
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
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim,suse.com:email,linux.dev:email,opensvc.com:email];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_TRACE(0.00)[suse.com:+];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,linux.dev:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -12.01

On Wed, 2026-11-25 at 11:26 +0100, Xose Vazquez Perez wrote:
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
> =C2=A0multipathd/multipathc.c | 3 +++
> =C2=A01 file changed, 3 insertions(+)
>=20

What for? I'd prefer multipathd not to be chatty, and I fail to see the
benefit of this unsolicited output.

It would be nice to have a "show version" command that would print not
only the multipath-tools version but also the versions of relevant
other componenents (libdm, kernel dm, kernel mpath). But that's a
different thing.

Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>
SUSE Software Solutions Germany GmbH, Frankenstr. 146, 90461 N=C3=BCrnberg,
Germany
Gesch=C3=A4ftsf=C3=BChrer: Stefan Gaiser, Jochen Jaser, Abhinav Puri (HRB
36809,AG N=C3=BCrnberg)
