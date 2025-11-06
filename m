Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B747C2FBDF4
	for <dm-devel@lists.linux.dev>; Thu,  6 Nov 2025 20:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762460884; cv=none; b=soMAuHh8aM4EMa/oVVgJsdsm+UtKGDd9QcFEySb50osxOjq/XyTixMG1XUAW8n+yNPo+Hnvs0m8/iAF4wCgt1ie8rK4xK2/v0rA1jxTL+74ctpgIm3p46UniFqDl8kFa4D332StysDmgKoSFf6IhJ9lv7GQoFkGarf2MNq3M4Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762460884; c=relaxed/simple;
	bh=kycg/pWKUS27eFjqqcMju0PLD086bCo3HMSKT14qRGQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lSYuU/dPLl0P9Irc6pbeThDh86ZcYXUJf9lkOGIrPnojk+vZWn+wqgM8WfaRLTgRyEB6hJQ1kvHUFi2H3IEfPttsegBBGm2lIX3cJfZRsYnXC+cMQ0tG9V4ktJVqWqlvFls2NcS+p1dPquvUK8xKl7usDiTdaTQMhvsGW4JiZzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ZZiOxp+U; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ZZiOxp+U; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ZZiOxp+U";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ZZiOxp+U"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B45EE211F9;
	Thu,  6 Nov 2025 20:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1762460879; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kycg/pWKUS27eFjqqcMju0PLD086bCo3HMSKT14qRGQ=;
	b=ZZiOxp+UaNirXcTbWsYzKGzZyOXTo492dAS8Pkl9OXGgwyK8uShSRNsvGMzLMCusDiDBi1
	rgFfCST8o38oFLbTZ5Gu5gc7jW+WeHiWgS7eRDqS0o2WXJwGXlNaPhAjWd3w94wz5LH9KA
	7mcj2MsPSWxYZh04Up6rb5n0D4FRX5c=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1762460879; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kycg/pWKUS27eFjqqcMju0PLD086bCo3HMSKT14qRGQ=;
	b=ZZiOxp+UaNirXcTbWsYzKGzZyOXTo492dAS8Pkl9OXGgwyK8uShSRNsvGMzLMCusDiDBi1
	rgFfCST8o38oFLbTZ5Gu5gc7jW+WeHiWgS7eRDqS0o2WXJwGXlNaPhAjWd3w94wz5LH9KA
	7mcj2MsPSWxYZh04Up6rb5n0D4FRX5c=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9481913A31;
	Thu,  6 Nov 2025 20:27:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id l/slI88EDWn9IgAAD6G6ig
	(envelope-from <mwilck@suse.com>); Thu, 06 Nov 2025 20:27:59 +0000
Message-ID: <bec693b88c1fa4fc90543be949713c7e659c53ab.camel@suse.com>
Subject: Re: [PATCH] multipath-tools: add repology table to README.md
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, DM_DEVEL-ML <dm-devel@lists.linux.dev>
Date: Thu, 06 Nov 2025 21:27:58 +0100
In-Reply-To: <20251101153353.289617-1-xose.vazquez@gmail.com>
References: <20251101153353.289617-1-xose.vazquez@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_DN_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCPT_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TAGGED_RCPT(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid,suse.com:email]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

On Sat, 2025-11-01 at 16:33 +0100, Xose Vazquez Perez wrote:
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
> =C2=A0README.md | 4 ++++
> =C2=A01 file changed, 4 insertions(+)
>=20
> diff --git a/README.md b/README.md
> index 530caed7..e272f899 100644
> --- a/README.md
> +++ b/README.md
> @@ -5,6 +5,10 @@ multipath-tools for Linux
> =C2=A0
> =C2=A0https://github.com/opensvc/multipath-tools
> =C2=A0
> +<a href=3D"https://repology.org/project/multipath-tools">
> + <img
> src=3D"https://repology.org/badge/vertical-allrepos/multipath-tools.svg
> " align=3D"right">
> +</a>
> +
> =C2=A0This package provides the following binaries to drive the Device
> Mapper multipathing driver:
> =C2=A0

Unless you have a really wide screen for your browser, this makes our
README look strange.=C2=A0

See https://github.com/openSUSE/multipath-tools/tree/tip

IMO it takes too much space, and with its bright colors distracts the
reader from the content of the README.=C2=A0Also, what exactly is the
benefit of having this so prominently in our README? It serves more as
a distro contest than anything else (it reminds me that I need to
update multipath-tools in openSUSE :-).

Is there perhaps a smaller version of this list, or should we just
insert a textual link? Or perhaps a more compact (non-vertical) table
that we could include at the bottom of the README?

Regards
Martin

