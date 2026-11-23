Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795454343;
	b=s+gSKCnLb8OuaQLaC3+QN7ECpbAELmk7mFL7eFKEOdWnrSS76ySl7jVUs3j5dWQ29Sc2
	 2NFJadyeXxgqBZiHuqLSjn5qGe0qS6kpFe6F3jgUgHV2HJb5fRuhVf3mTdm7tasF8oQr9
	 SeNVNxJe3JfEonQVdrArkF1QFYCIINeUWQFO4e2d4b/BaWESbDufUGFR4ukjmKXuaKM0g
	 RwpZZvxARqaHD3DMD+7WKn00khdHzDDaO9pLR0SeCUdjZ+bvk0Cm3n75Zr3ny8XZ06+F3
	 B5YZRrdEv8ys4B2znciQYXhR7MERyFpzqoh9gpWzRVKcJXkja5tazO0rw1C7GICb77w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795454343;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version:
	 X-Spam-Flag:X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=6VNkOSZ1sF7g+/ankhw3n2EHH4CNoQbXcUnUKHPey/s=;
	b=oDXtt0eW+3Foenje1ynoczpqeVPQhVCTa5pmsKvmgrB7uJBJeDFfP2KW0n1+hOwRzPBv
	 308yCgXSGh6vOX6dc+KIFNI56lHlAwDIfhc8hADuUpvyZ+6agGDiQdttoUnvtoxC/XyIN
	 MmTJJS27p9wOKTX6CZpf6ojNydQaLGTrSsUqTvlQAXUkrchY59QMewzbOCfwZ3ueFFtA8
	 E5aKm36M9Ib4ZXE0bPODSW/xxBDvMdjhm4hUl+8W1UT6BZ0S4gIN9bICWRIhuqSUY+JYu
	 xeT7rTmsP11UXW3XUZcXASvmqQ4nES26EwLsyanydtQ7JV8Yjn1J9gLQzDixYuyXZ8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=YiyjM0iu;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=YiyjM0iu;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A143D606A31A
	for <dm-devel@lists.linux.dev>; Mon, 23 Nov 2026 17:19:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A143D606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=YiyjM0iu;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=YiyjM0iu
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A8FF422119;
	Mon, 23 Nov 2026 17:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795454340; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6VNkOSZ1sF7g+/ankhw3n2EHH4CNoQbXcUnUKHPey/s=;
	b=YiyjM0iuZEBVzbh45YsnNxGM/bsiYyHQyfYZGPcrqYJodaUEqW/VFRrcz0k2I8z+pOL22H
	0KFBlq/L8FarYXWNwJJ+RT9ivUCbknwFe34qsPxa2Z1OlRD/navjcGkg4KXEPjsPf0aNoW
	cdL0l5uF1m35ZS0G/wWJcKqrsvqwDqo=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795454340; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6VNkOSZ1sF7g+/ankhw3n2EHH4CNoQbXcUnUKHPey/s=;
	b=YiyjM0iuZEBVzbh45YsnNxGM/bsiYyHQyfYZGPcrqYJodaUEqW/VFRrcz0k2I8z+pOL22H
	0KFBlq/L8FarYXWNwJJ+RT9ivUCbknwFe34qsPxa2Z1OlRD/navjcGkg4KXEPjsPf0aNoW
	cdL0l5uF1m35ZS0G/wWJcKqrsvqwDqo=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6683E13510;
	Mon, 23 Nov 2026 17:19:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id emwhEIR1BGtIDAAAD6G6ig
	(envelope-from <mwilck@suse.com>); Mon, 23 Nov 2026 17:19:00 +0000
Message-ID: <accb92fd1fb9bf941c28ad8bc4427807740558f7.camel@suse.com>
Subject: Re: [PATCH RESEND 03/13] multipath-tools: hwtable: add FUJITSU
 ETERNUS VX710/VX740
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, DM_DEVEL-ML <dm-devel@lists.linux.dev>
Date: Mon, 23 Nov 2026 18:18:59 +0100
In-Reply-To: <64b6d939-f527-417c-b5f8-c804e02846fe@gmail.com>
References: <20261113125549.504780-1-xose.vazquez@gmail.com>
	 <20261113125549.504780-4-xose.vazquez@gmail.com>
	 <16d621bce8b1e5f027f07a8b235be0d1f6f05796.camel@suse.com>
	 <64b6d939-f527-417c-b5f8-c804e02846fe@gmail.com>
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
X-Spam-Flag: NO
X-Spam-Level: 
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

On Mon, 2026-11-23 at 18:09 +0100, Xose Vazquez Perez wrote:
> On 11/23/26 4:00 PM, Martin Wilck wrote:
>=20
> > On Fri, 2026-11-13 at 13:55 +0100, Xose Vazquez Perez wrote:
>=20
> > > +=09{
> > > +=09=09// ETERNUS VX700 series
> > > +=09=09.vendor=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D "FUJITSU=
",
> > > +=09=09.product=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D "ETERNUS_VX70=
0",
> > > +=09=09.pgpolicy=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D MULTIBUS,
> > > +=09=09.no_path_retry =3D 120,
> > > +=09},
> >=20
> > I see this in the manual (my Japanese being a bit rusty), but are
> > you
> > certain that the VX700 has no ALUA support? If it does, it's at
> > least
> > misleading to set pgpolicy to MULTIBUS here, as this will be
> > overridden
> > by ALUA auto-detection.
> The Fujitsu manuals specify an active-active setup with
> "path_grouping_policy multibus", and the "multipath -ll"
> example shows all paths active in a single group:
>=20
> page=C2=A0 8:
> https://www.fsastech.com/ja-jp/products/storage/assets-a/manual/afa-disk/=
p3am-3912.pdf
> page 35:
> https://www.fsastech.com/ja-jp/products/storage/assets-a/manual/afa-disk/=
p3am-6362.pdf
>=20
> I did not see ALUA support mentioned in the docs.

Gemini told me that the VX 700 uses DataCore SANsymphony-V as its
storage virtualization engine, which does support ALUA. No clue,
perhaps Gemini is wrong.

It doesn't hurt much, anyway. If the system does support ALUA,
multipath will use it.

So, ok.

Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>
SUSE Software Solutions Germany GmbH, Frankenstr. 146, 90461 N=C3=BCrnberg,
Germany
Gesch=C3=A4ftsf=C3=BChrer: Stefan Gaiser, Jochen Jaser, Abhinav Puri (HRB
36809,AG N=C3=BCrnberg)
