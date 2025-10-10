Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A79154654
	for <dm-devel@lists.linux.dev>; Fri, 10 Oct 2025 11:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760095241; cv=none; b=k50XAeVRgb4aY5JzYn2hnByWbrBntw8iOBw4aRSIPKUt6TNzsU6dRCaK7xWt7C+ZGGzUM4N/WuZGcLD/r+qmGMdSWTDoezhLkwwWaYcNoZnxq3jTi+YfC+nBYDKwsV1+HkrNyqIvb6YQqk32sPB1DJD9IpTJI3UVtfIV7SlP0cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760095241; c=relaxed/simple;
	bh=XW6CIUmDS3xM4zA7HAzYZGzFBodrwSWD6yJxIMRjDyM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hJ6TsNEj4NEBgTb470NyGop3nIQBMKv8Cl/rMSPvmUY4Cgg62Knagcn1ltvlYRMWgYF5QUHGKKvyNUmuUGHkLv4GEeVI4mDhdUYPf4q82RBz8413432oR1SIPoWPMJeH0jFPzxatvIxmxUYJw/7whtfrX7k+aMt41bSG7braAo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=qcHuyocK; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=qcHuyocK; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="qcHuyocK";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="qcHuyocK"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 92C601F822;
	Fri, 10 Oct 2025 11:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1760095235; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SMYcuMjzBwYxy+VyH+GBkUW3ngNF49j09A5ou/rCk1Y=;
	b=qcHuyocKFI3ckcfEaXP1gfOmX91UaXM5axrtsxm+SzYJCk31xJVAR/fi+ItxLtkSVOC/jh
	2g6J+IWeuhLX58Wsy7oUHDpc8O7Fw2ZpXHCGDLDUXN2adE2sfmwBC/BlzOlnbj2Sue4ciH
	y3yL8CaOoaQ8RBGfNAHkOGJPwut+p9U=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=qcHuyocK
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1760095235; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SMYcuMjzBwYxy+VyH+GBkUW3ngNF49j09A5ou/rCk1Y=;
	b=qcHuyocKFI3ckcfEaXP1gfOmX91UaXM5axrtsxm+SzYJCk31xJVAR/fi+ItxLtkSVOC/jh
	2g6J+IWeuhLX58Wsy7oUHDpc8O7Fw2ZpXHCGDLDUXN2adE2sfmwBC/BlzOlnbj2Sue4ciH
	y3yL8CaOoaQ8RBGfNAHkOGJPwut+p9U=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 724DA1375D;
	Fri, 10 Oct 2025 11:20:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KozeGgPs6Gj5XwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Fri, 10 Oct 2025 11:20:35 +0000
Message-ID: <cd074f884f847ed291c2e720657668d6a0523f8f.camel@suse.com>
Subject: Re: [PATCH 2/2] multipath-tools: add mandoc check to man pages
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, DM_DEVEL-ML <dm-devel@lists.linux.dev>
Date: Fri, 10 Oct 2025 13:20:35 +0200
In-Reply-To: <20251010092211.57426-2-xose.vazquez@gmail.com>
References: <20251010092211.57426-1-xose.vazquez@gmail.com>
	 <20251010092211.57426-2-xose.vazquez@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 92C601F822
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_DN_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FREEMAIL_TO(0.00)[gmail.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_COUNT_TWO(0.00)[2];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim,suse.com:mid,suse.com:email]
X-Spam-Score: -3.01

On Fri, 2025-10-10 at 11:22 +0200, Xose Vazquez Perez wrote:
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
> =C2=A0kpartx/kpartx.8=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 1 +
> =C2=A0libmpathpersist/mpath_persistent_reserve_in.3=C2=A0 | 1 +
> =C2=A0libmpathpersist/mpath_persistent_reserve_out.3 | 1 +
> =C2=A0mpathpersist/mpathpersist.8.in=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 5 +++--
> =C2=A0multipath/multipath.8.in=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 | 5 +++--
> =C2=A0multipath/multipath.conf.5.in=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 5 +++-=
-
> =C2=A0multipathd/multipathc.8=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 | 1 +
> =C2=A0multipathd/multipathd.8.in=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 | 5 +++--
> =C2=A08 files changed, 16 insertions(+), 8 deletions(-)
>=20
> diff --git a/kpartx/kpartx.8 b/kpartx/kpartx.8
> index ef8051a5..2a55c96b 100644
> --- a/kpartx/kpartx.8
> +++ b/kpartx/kpartx.8
> @@ -2,6 +2,7 @@
> =C2=A0.\" Make sure there are no errors with:
> =C2=A0.\" groff -z -wall -b -e -t kpartx/kpartx.8
> =C2=A0.\" man --warnings -E UTF-8 -l -Tutf8 -Z=C2=A0 kpartx/kpartx.8 >
> /dev/null
> +.\" mandoc -W all -T lint kpartx/kpartx.8

Nack. We don't need this in every man page. Actually, we don't need the
other command lines mentioned in the man pages, either. While looking
at this, I realize that the "groff" command line is wrong. AFAICT it
should be=20

   groff -man -z -wall -b -e -t -Tutf8 $MANPAGE_FILE

But really, it makes no sense to me to have these reminders in every
man page. If we want to keep our man pages in order (which is of course
a worthwhile goal), we should rather write a GitHub workflow to check
them. That would be a helpful contribution.

I would still question whether our man pages need to pass 3 different
commands. AFAICS the "groff" and "man" commands are basically
equivalent anyway, as "man" simply calls "groff" for the parsing and
formatting. Wrt mandoc in general, see my reply to patch 1/2.

Regards,
Martin
