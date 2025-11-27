Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771CE29993F
	for <dm-devel@lists.linux.dev>; Thu, 27 Nov 2025 15:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764256604; cv=none; b=CwhT12yenUvd20YUi7Qid2/nIMDnAdQIsRtoI6/ZHM9AlTuHKrWGTy/2/Ho6WYWIcbiqoeeNe6ZgY8/qxAdnSG9u0f9XUNgiHS2P44spQ+DEf7U9Bfjdr1kq/LZ91rz2rA8lUN5ctkm8ZpVe+YEP3sxwHBmincJD3Wg7bUj9DMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764256604; c=relaxed/simple;
	bh=ArXhYeDjp5v2/aFURW67IaunCobWIXdRa/zg23hVVkQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=el8rAojLk86E2t6VfNTLF0eYJeI8ofyagZwLE8gFNK9x9RN71vOOPsBMgzxjJ4ZmmsuupzSILCGV8Dkx4jjM2XOjBbxA9anJ7JTiGLMWdakS0oGW8phMsuhQPhZcIu5QMoNb1oUFU8K4gnvHKUeopD/NCTO9MZLVqtoVG1A0oVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=jzQR8KeM; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=jzQR8KeM; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="jzQR8KeM";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="jzQR8KeM"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 75DCC5BDD6;
	Thu, 27 Nov 2025 15:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1764256600; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ArXhYeDjp5v2/aFURW67IaunCobWIXdRa/zg23hVVkQ=;
	b=jzQR8KeMtPKo/tHAm329G1VMtJsGXHBfmd+6/Yn/tq3TEMFRAvG66ktErUZ3PV5XBI1zVZ
	EKvE5qManmYEStInArxVy4qX5eSpubhZiBfTRrwK1YwGASj6AvcM8sDJsOBWIMpqX8WaVv
	PHiWyoKGppP3tIhgElNMJxHRWG3t7dA=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1764256600; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ArXhYeDjp5v2/aFURW67IaunCobWIXdRa/zg23hVVkQ=;
	b=jzQR8KeMtPKo/tHAm329G1VMtJsGXHBfmd+6/Yn/tq3TEMFRAvG66ktErUZ3PV5XBI1zVZ
	EKvE5qManmYEStInArxVy4qX5eSpubhZiBfTRrwK1YwGASj6AvcM8sDJsOBWIMpqX8WaVv
	PHiWyoKGppP3tIhgElNMJxHRWG3t7dA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 521583EA63;
	Thu, 27 Nov 2025 15:16:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YLreElhrKGm+OwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Thu, 27 Nov 2025 15:16:40 +0000
Message-ID: <cbfe1553807abd9df686adefbbc4ee973d466522.camel@suse.com>
Subject: Re: [PATCH] multipath-tools: add Seagate Exos and Nytro series to
 hwtable
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, DM_DEVEL-ML <dm-devel@lists.linux.dev>
Date: Thu, 27 Nov 2025 16:16:39 +0100
In-Reply-To: <20251115145010.470404-1-xose.vazquez@gmail.com>
References: <20251115145010.470404-1-xose.vazquez@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_TO(0.00)[gmail.com];
	TAGGED_RCPT(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_DN_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[opensvc.com:email,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid,seagate.com:url,linux.dev:email]

On Sat, 2025-11-15 at 15:50 +0100, Xose Vazquez Perez wrote:
> Config from, #102:
> https://www.seagate.com/content/dam/seagate/migrated-assets/www-content/s=
upport-content/raid-storage-systems/corvault/_shared/files/205042000-01-B_C=
ORVAULT_SMG.pdf
>=20
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
> =C2=A0libmultipath/hwtable.c | 9 +++++++++
> =C2=A01 file changed, 9 insertions(+)
>=20

Reviewed-by: Martin Wilck <mwilck@suse.com>
