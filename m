Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 207EA2FBE1D
	for <dm-devel@lists.linux.dev>; Wed,  7 Jan 2026 12:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767788480; cv=none; b=YTBnnt0AQPC48axaB5tsKZKDlE5wx9ibaVk6JrOUf/ZM3eOnXTI1OjR2vtCYSr6XzQazjGRYQ7IZDuZcXGrhXePLdv3cNiqCl63OXQNLt2BY3i/oeyPS38SsvfmOyqtK3O15fmw8X8RZFAgKLB3p3ycYgzIBdRtknXrFyp1P8BE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767788480; c=relaxed/simple;
	bh=XpsWDZMW8V0308z8HS4jCiCHf1xHYjt3Th7lxX8qOOE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HCH0fKB4j3gCmed0ignhKPbgbY39oSV1Qr+iE6LTwmfFpSSNVf44hCmHIWo9tv9ATAaP+nyLsLzpaC5R1Dm4TlAXCRIOPRbL1jPdouAlT1ogrMs34oLxO9eD560wG6OQZq9uRInXvNX6JK8/l6A7+roVL3yiUmgdaS/HWjZV3+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=C989afom; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=C989afom; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="C989afom";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="C989afom"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2D6B45BCCC;
	Wed,  7 Jan 2026 12:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1767788477; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l2xtuQ4R5oLjXdSUTLwc5btjVfDW+Co5zuPFA3BWDvM=;
	b=C989afomZOIFf2NTrehkDGweiJuIOs006n/LBtHHanG2jOqQ4m9L9nygziZZPQqtqMEXpN
	Up8FaQAAYQ7xwCL6DcQj9AJxbCsMwfmbsimSn3Ap1YI4YeRpga4+9LV6v0px9xrdYOOkHX
	qemENquS/n1xxH3DjU620/4fTcvkoJQ=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1767788477; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l2xtuQ4R5oLjXdSUTLwc5btjVfDW+Co5zuPFA3BWDvM=;
	b=C989afomZOIFf2NTrehkDGweiJuIOs006n/LBtHHanG2jOqQ4m9L9nygziZZPQqtqMEXpN
	Up8FaQAAYQ7xwCL6DcQj9AJxbCsMwfmbsimSn3Ap1YI4YeRpga4+9LV6v0px9xrdYOOkHX
	qemENquS/n1xxH3DjU620/4fTcvkoJQ=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1154C3EA63;
	Wed,  7 Jan 2026 12:21:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oHAeA71PXmmORgAAD6G6ig
	(envelope-from <mwilck@suse.com>); Wed, 07 Jan 2026 12:21:17 +0000
Message-ID: <230b090c5fa6b144f57c4d1bfc8dc5c7282b3e00.camel@suse.com>
Subject: Re: [PATCH] libmultipath: Remove the undefined symbol from the
 linker script
From: Martin Wilck <mwilck@suse.com>
To: Michal Rostecki <vad.sol@proton.me>, dm-devel@lists.linux.dev
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed, 07 Jan 2026 13:21:16 +0100
In-Reply-To: <20260107120938.28215-2-vad.sol@proton.me>
References: <20260107120938.28215-2-vad.sol@proton.me>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Flag: NO
X-Spam-Score: -4.29
X-Spam-Level: 
X-Spamd-Result: default: False [-4.29 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.19)[-0.929];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[proton.me:email,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid]

On Wed, 2026-01-07 at 12:09 +0000, Michal Rostecki wrote:
> dm_get_multipath() is a static function, not a symbol that can be
> exported. Clang is strict about not allowing undefined symbols in
> linker
> scripts and therefore its presence prevents clang from building
> libmultipath.
>=20
> Fixes: https://github.com/opensvc/multipath-tools/issues/132
> Fixes: bf3a4ad ("libmultipath: simplify dm_get_maps()")
> Signed-off-by: Michal Rostecki <vad.sol@proton.me>

Thanks!

Reviewed-by: Martin Wilck <mwilck@suse.com>

Yet I'm wondering which compiler version you use, or if you use any
non-standard compilation options. Our CI compiles multipath-tools with
MANY different versions of clang, but never encountered this problem.

Martin

> ---
> =C2=A0libmultipath/libmultipath.version | 1 -
> =C2=A01 file changed, 1 deletion(-)
>=20
> diff --git a/libmultipath/libmultipath.version
> b/libmultipath/libmultipath.version
> index 89ae2a3c..5017a54d 100644
> --- a/libmultipath/libmultipath.version
> +++ b/libmultipath/libmultipath.version
> @@ -85,7 +85,6 @@ global:
> =C2=A0	dm_geteventnr;
> =C2=A0	dm_get_major_minor;
> =C2=A0	dm_get_maps;
> -	dm_get_multipath;
> =C2=A0	dm_is_mpath;
> =C2=A0	dm_mapname;
> =C2=A0	dm_prereq;
