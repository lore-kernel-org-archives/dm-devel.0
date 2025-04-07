Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6463D226883
	for <dm-devel@lists.linux.dev>; Mon,  7 Apr 2025 08:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744015919; cv=none; b=FtzHpyxosTaSNAZiEqf/du45BDwrFJrGImMY2ebgCKVyhniibPe7Qq1uXWQs3Qk/qhJhI9RkWZPkzGQjLHEnF3VX7K2/QUYVXoIv6ZsNK5L65qRAAlCYKJmGZAjThEukBDgOe0mgvi2joK7XJidpJRln4PeZY1IdpJDjWmvZq7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744015919; c=relaxed/simple;
	bh=41eoQJNixBgb3BhV3DhVb6KLoQjFemI13ytSIWdy1Pc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Yszk0ZPorQBmN2XkJ4DYW8MTYT3OcxJRGv0TvoAxg2DVd/gg4h+PAhadfaN/SKrM2NKUME7KLjeXznk0PNnvAwXsY+7wTkZRR/lPnzgqInz7Vaqgei2YNJcttIY+b5ciCK6WJQ06YrdOqOMeizN39Sz89eSX5MyD/LHINsQj87M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=NUQDImCk; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=NUQDImCk; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="NUQDImCk";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="NUQDImCk"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5218E1F449;
	Mon,  7 Apr 2025 08:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1744015914; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3mqYQsvmBrJytq8wwCbbID7IPtKQTx7kNbppDoL/so4=;
	b=NUQDImCkTDdsOVxlhSElDozNgUd7PmPkjwVr/Qwh4vCKHqYwTx6G3ojoi+YL6WNNa5omdc
	GRxR/uo2R1CvoICSZwqxKcdtFeAppaO22O0nbCmh6GC45dfg9y/xum2wQ5KghVcQTlmrtZ
	BcJwDNSK4jJo23zrEyYP5bBeByO9Wss=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=NUQDImCk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1744015914; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3mqYQsvmBrJytq8wwCbbID7IPtKQTx7kNbppDoL/so4=;
	b=NUQDImCkTDdsOVxlhSElDozNgUd7PmPkjwVr/Qwh4vCKHqYwTx6G3ojoi+YL6WNNa5omdc
	GRxR/uo2R1CvoICSZwqxKcdtFeAppaO22O0nbCmh6GC45dfg9y/xum2wQ5KghVcQTlmrtZ
	BcJwDNSK4jJo23zrEyYP5bBeByO9Wss=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1DCCA13691;
	Mon,  7 Apr 2025 08:51:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XL+1BSqS82e3NQAAD6G6ig
	(envelope-from <mwilck@suse.com>); Mon, 07 Apr 2025 08:51:54 +0000
Message-ID: <cceb5e41c4042e11566ecefb98150d220a5b474b.camel@suse.com>
Subject: Re: [PATCH 1/2] libdmmp/Makefile: Fix KBUILD_BUILD_TIMESTAMP usage
From: Martin Wilck <mwilck@suse.com>
To: Sofiane HAMAM <sofiane.hamam@smile.fr>, dm-devel@lists.linux.dev
Cc: bmarzins@redhat.com, =?ISO-8859-1?Q?K=E9l=E9fa_San=E9?=
	 <kelefa.sane@smile.fr>, Yoann Congal <yoann.congal@smile.fr>
Date: Mon, 07 Apr 2025 10:51:53 +0200
In-Reply-To: <20250404122902.2750036-1-sofiane.hamam@smile.fr>
References: <20250404122902.2750036-1-sofiane.hamam@smile.fr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.0 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Rspamd-Queue-Id: 5218E1F449
X-Spam-Level: 
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.98%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim,suse.com:mid];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.51
X-Spam-Flag: NO

On Fri, 2025-04-04 at 14:29 +0200, Sofiane HAMAM wrote:
> From: K=C3=A9l=C3=A9fa San=C3=A9 <kelefa.sane@smile.fr>
>=20
> Add missing $ (Makefile need to escape '$' as '$$')
>=20
> Signed-off-by: Yoann Congal <yoann.congal@smile.fr>
> Signed-off-by: Sofiane HAMAM <sofiane.hamam@smile.fr>
> Signed-off-by: Kelefa Sane <kelefa.sane@smile.fr>
> ---
> =C2=A0libdmmp/Makefile | 2 +-
> =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/libdmmp/Makefile b/libdmmp/Makefile
> index 172ba045..7e0e2509 100644
> --- a/libdmmp/Makefile
> +++ b/libdmmp/Makefile
> @@ -74,7 +74,7 @@ doc: docs/man/dmmp_strerror.3
> =C2=A0docs/man/dmmp_strerror.3:	$(HEADERS)
> =C2=A0	$(Q)TEMPFILE=3D$(shell mktemp); \
> =C2=A0	cat $^ | perl docs/doc-preclean.pl >$$TEMPFILE; \
> -	[ "$KBUILD_BUILD_TIMESTAMP" ] || \
> +	[ "$$KBUILD_BUILD_TIMESTAMP" ] || \
> =C2=A0	=C2=A0=C2=A0=C2=A0 KBUILD_BUILD_TIMESTAMP=3D`git log -n1 --pretty=
=3D%cd --
> date=3Diso -- $^`; \
> =C2=A0	export KBUILD_BUILD_TIMESTAMP; \
> =C2=A0	LC_ALL=3DC \

Reviewed-by: Martin Wilck <mwilck@suse.com>

