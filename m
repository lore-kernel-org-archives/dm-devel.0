Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73DD93D566F
	for <dm-devel@lists.linux.dev>; Mon, 15 Jun 2026 09:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781514679; cv=none; b=UfCzgvhtB94X8x7IOJPPeIF4uU52TjBgldteVzPdDquWuFooRgdrp2dEw9XQZfuXaK7xIdXadwhcxlmGWuVaglZkDY0Q7d7XeAYCCGJwwnaRidAggwoJHpAE1qwxVhqqvr5fmn6HXL6KedSzu8xw/2Udv9OucLUrC49L0KdZskw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781514679; c=relaxed/simple;
	bh=XqgT+hS2ZDHUHicjeCpo7BbJJoNe9MCxprQYpfgJEcQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=eYc795gBDJA2GzmrQmejeisMol5NPRpAdG7dNImFLEPbO/b2kPcXjDQJG2SZv2Sy0CLkbDaMArWE4ivRJ7H9+UE5lNaANqXAm/TEPQRJGxFjN5YquQj9gsL0SLAkyinKPPKB2Dp/ng4qh/59y9Xz3xv02QNMBQzFjGFaP818Jqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=gvmKLGSH; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=gvmKLGSH; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="gvmKLGSH";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="gvmKLGSH"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6672875939;
	Mon, 15 Jun 2026 09:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781514668; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XqgT+hS2ZDHUHicjeCpo7BbJJoNe9MCxprQYpfgJEcQ=;
	b=gvmKLGSHSXg+O76RLp3gQCAZieoiHJIGFy6LKMt8DHrwsIi5+EOpI2S6Xu+ZFDoeNn9OK2
	j8ZXeas1t1BAsBMmM0JbyM5quC9XurFgpntobN1CQ1lnwHOzG8kAjQCkUh2VYBCjXgyBgH
	s4bZ4yAUUvzuifGTamxZmV/zA3xydeo=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=gvmKLGSH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781514668; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XqgT+hS2ZDHUHicjeCpo7BbJJoNe9MCxprQYpfgJEcQ=;
	b=gvmKLGSHSXg+O76RLp3gQCAZieoiHJIGFy6LKMt8DHrwsIi5+EOpI2S6Xu+ZFDoeNn9OK2
	j8ZXeas1t1BAsBMmM0JbyM5quC9XurFgpntobN1CQ1lnwHOzG8kAjQCkUh2VYBCjXgyBgH
	s4bZ4yAUUvzuifGTamxZmV/zA3xydeo=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 45110779A9;
	Mon, 15 Jun 2026 09:11:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MXrGD6zBL2qrLAAAD6G6ig
	(envelope-from <mwilck@suse.com>); Mon, 15 Jun 2026 09:11:08 +0000
Message-ID: <562d0c52ef13cfc1f8dec3c59b05b56304ce2c02.camel@suse.com>
Subject: Re: [PATCH 1/3] multipath-tools: delete obsolete information from
 multipath.conf.5
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, DM_DEVEL-ML <dm-devel@lists.linux.dev>
Date: Mon, 15 Jun 2026 11:11:07 +0200
In-Reply-To: <20260607103831.336833-2-xose.vazquez@gmail.com>
References: <20260607103831.336833-1-xose.vazquez@gmail.com>
	 <20260607103831.336833-2-xose.vazquez@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 6672875939
X-Spam-Flag: NO
X-Spam-Score: -4.01
X-Spam-Level: 
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	DWL_DNSWL_LOW(-1.00)[suse.com:dkim];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	TO_DN_ALL(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_TRACE(0.00)[suse.com:+];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On Sun, 2026-06-07 at 12:38 +0200, Xose Vazquez Perez wrote:
> repeat_count (rr_min_io, rr_min_io_rq, rr_weight) has been
> unsupported
> since kernel 4.6 ( commits 90a4323ccfea and=C2=A0 21136f89d76d ).
>=20

I can't make up my mind on this patch. It is true that most path
selectors in the kernel have ignored the repeat_count argument
for a long time (historical_service_time still seems to honour it).

But this is multipath-tools. _We_ still have quite a bit of code for
handling the minio and weight settings. We should add a hint the the
man page that these settings are ignored by modern kernels, but it
would be simply wrong to say that _our_ code ignores them while it
doesn't.=20

We can decide to remove this functionality from multipath-tools, which
would obviously mean removing it from the man page as well. But if we
do, we should apply further cleanups. I suppose that providing the
"weightedpath" prioritizer makes no sense if we have no path selector
algorithm that takes such weights into account, for example.

I should also note that there have been discussions with some partners
about re-introducing parameterized path selectors. This was a topic in=20
the context of Fibre Channel FPIN notifications: FPINs can be used by
FC fabric to notify hosts about overloaded paths. With a parameterized
path selector, the load on such paths could be decreased by multipathd.
temporarily until the situation is normal again. While there has been
little progress in this area, I don't consider it cast in stone that
the kernel will keep ignoring path selector parameters forever, or IOW,
that there won't be new path selectors in the future that do accept
path parameters again.

No doubt that the way these parameters are interpreted in different
ways ("minio" vs. "weight" vs "repeat_count") and the way this is
exposed to end users in the configuration file and in the man page is
broken and confusing. But fixing that would be a larger effort.

Regards
Martin
