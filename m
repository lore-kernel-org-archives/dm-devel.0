Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795475403;
	b=RjGugeJfwC9KkXxVZzamI29aBcCnfIKhRdjZ7Lau3qKBD+sY5R2Zg22UjvebaGX+t44V
	 BI7oQ0qTPbhEB7DuYgN2AVlow31TIjBpD43zWpcytm59b5i2wmWjOz84WhMkCaw2hrQpQ
	 Y40qyZI9LjnrBr9Sq8iNkhVK5ts6NnoDaRi3lXfmpllaL8dIolS2rmIkDS6YpWh5wFHbg
	 A93yWyquE4G1Z4wNLCe7egFrdL6Op6E6sUdpf1nt3YqKCtUeiLEQ16IjUsV7NxMwOtOMm
	 qjENsc2OhfpE2rOFJsWdWWIxt9kBRyof+ntz5aZbb0cGY2sNJhY8idphhhIZU+Gihsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795475403;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version:
	 X-Spamd-Result:X-Spam-Score:X-Spam-Level:X-Spam-Flag;
	bh=GEUXgfdQo3MMvt8Pk6y+n5CbzxOayfuRqMaE2uROPsc=;
	b=2gQjxaShPcbzVcfsSfz7AalCN18L6mIag9Z7c0CWjuIxz7JQltpT3SJCKOUR1DFsT2ut
	 NJzXYndjbOzvXGtDST8edUWRXOLmNGfLpEdTsjdFrmf8RDqAH7DPRfvJRWf/g0AAoUPzp
	 JCw6Xda/WCxxyj5BfUDKOyqdRMl6+SwhQRUV3J/eqvDCRmZqSbJUQYyi9UHsg6dISPWas
	 hw0v9RZooS0pc7DNIvx7hY76pZrAP5ck3B2tWdkY1gQ7uC6tkqM+b+PPLilV+yAzGyAnV
	 akyHij3PhKpTy9rxPBJ2/IUFYJkxwTEgwXi6rvjFebdkU16ky7mqsOUilGU27FkDvsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=EiaVYKmG;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=SVeoClS0;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D52606A31E
	for <dm-devel@lists.linux.dev>; Mon, 23 Nov 2026 23:10:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 93D52606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=EiaVYKmG;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=SVeoClS0
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7EBE22200E;
	Mon, 23 Nov 2026 23:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795475400; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GEUXgfdQo3MMvt8Pk6y+n5CbzxOayfuRqMaE2uROPsc=;
	b=EiaVYKmGebVDvpgsG+WzIweiUmtYSpB660BPq21jT1hwPk6Jq4eQJ6s9mOGJOM9m2KbGii
	1OAQB0G2wG/tK/wjas8v9xdo7HlXrJSZpPq9W98pePX9G0EOG/YDTNAFenEHPNfE8tV6cF
	2jCZohwFs+fv4GTfxbd10I1Q3Gy5cx4=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795475399; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GEUXgfdQo3MMvt8Pk6y+n5CbzxOayfuRqMaE2uROPsc=;
	b=SVeoClS0VttaF4GvZ8ETtNGVkelkdmevaO9osSOlysZ1JQXIfRFx1ccJa3kb4N6AZFre5m
	zzDBxr5XKbtelWbx3c4wQZJ7OAFLPoW5FlYFEbiRBbKAeQpbHpRkf6EyIzCK+UQoz/bGWm
	D58CLugbOHArGMFETk1BRnZayWedQpM=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3F4F513505;
	Mon, 23 Nov 2026 23:09:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /ey8BcfHBGt/ZAAAD6G6ig
	(envelope-from <mwilck@suse.com>); Mon, 23 Nov 2026 23:09:59 +0000
Message-ID: <a5fd94eaab6ee835b2a387a2ade58aa8fa587782.camel@suse.com>
Subject: Re: [PATCH 00/13] multipath-tools: hwtable updates and minor
 cleanups
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, DM_DEVEL-ML <dm-devel@lists.linux.dev>
Date: Tue, 24 Nov 2026 00:09:58 +0100
In-Reply-To: <20261113125549.504780-1-xose.vazquez@gmail.com>
References: <20261113125549.504780-1-xose.vazquez@gmail.com>
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
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_TO(0.00)[gmail.com];
	TAGGED_RCPT(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_DN_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Score: -11.80
X-Spam-Level: 
X-Spam-Flag: NO

On Fri, 2026-11-13 at 13:55 +0100, Xose Vazquez Perez wrote:
> Xose Vazquez Perez (13):
> =C2=A0 multipath-tools: multipathd.8.in: fix mandoc WARNINGs
> =C2=A0 multipath-tools: hwtable: make no_path_retry independent of
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 DEFAULT_CHECKINT
> =C2=A0 multipath-tools: hwtable: add FUJITSU ETERNUS VX710/VX740
> =C2=A0 multipath-tools: add EMC VNXe info
> =C2=A0 multipath-tools: hwtable: update Intel Multi-Flex comment
> =C2=A0 multipath-tools: hwtable: update Pivot3 maintainer email address
> =C2=A0 multipath-tools: hwtable: update template instructions
> =C2=A0 multipath-tools: hwtable: add EMC/Celerra
> =C2=A0 multipath-tools: hwtable: update IBM arrays entries and comments
> =C2=A0 multipath-tools: hwtable: add Dell PowerFlex NVMe (formerly
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 iScaleIO/VxFlex OS)
> =C2=A0 multipath-tools: hwtable: add Western Digital OpenFlex NVMe
> =C2=A0 multipath-tools: add repology table to README.md
> =C2=A0 multipath-tools: move SPDX-License-Identifier to the top of
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 create-config.mk and rules.mk
>=20
> =C2=A0README.md=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 2 +=
+
> =C2=A0create-config.mk=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 2 +-
> =C2=A0libmultipath/hwtable.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | =
58 ++++++++++++++++++++++++++-------
> --
> =C2=A0multipath/multipath.conf.5.in |=C2=A0 2 +-
> =C2=A0multipathd/multipathd.8.in=C2=A0=C2=A0=C2=A0 |=C2=A0 8 ++---
> =C2=A0rules.mk=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=
=A0 2 +-
> =C2=A06 files changed, 53 insertions(+), 21 deletions(-)
>=20
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

For the series: Reviewed-by: Martin Wilck <mwilck@suse.com>

Thanks!


--=20
Dr. Martin Wilck <mwilck@suse.com>
SUSE Software Solutions Germany GmbH, Frankenstr. 146, 90461 N=C3=BCrnberg,
Germany
Gesch=C3=A4ftsf=C3=BChrer: Stefan Gaiser, Jochen Jaser, Abhinav Puri (HRB
36809,AG N=C3=BCrnberg)
