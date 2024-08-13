Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58FD198A05
	for <dm-devel@lists.linux.dev>; Tue, 13 Aug 2024 15:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723561926; cv=none; b=bz8G/kIdkzsKGRZE+EjSB4GEJjgHn0RaV/Pt1wQSLudDW9pPOeBiouGzDC3dViMLMx5uoUFcZlVyTDl1pe6YOyI9pm4h1oaNQ1zTTPh/vJbVj2lvkXJE3bZ27/qTMLFE7pXpDBJOsQClAN1wUCsTPcPud757egaqMmlzlXyJz/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723561926; c=relaxed/simple;
	bh=Dbu2iXjcABhE/op+lkFf9LsA2UV71HJbPKsi0jtgIdE=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RGrISjExQrjFdPwANvUMd8OIPYeo7SzB4PoTyxgwHM/e1ackUKDXoAuWOWA7bNxBsk9qO05LqFGvOFn5JxjcweNMJ2j/WJeR27WOVSTF/OdYIEIKgNra5HXhc2SrfqAWEjwr7jd1D2uGtNAbD+5rv5lBGepu/o47TicA6MTQUvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=luFj54pP; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ng4GSga4; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="luFj54pP";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ng4GSga4"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B34952282F;
	Tue, 13 Aug 2024 15:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1723561923; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Dbu2iXjcABhE/op+lkFf9LsA2UV71HJbPKsi0jtgIdE=;
	b=luFj54pP+AFUWPZe4rHPvYnLfdVp3qLUw1rjxLBV9UpawAdTr8ubC20821/L8FI2YNs62w
	f2isIvd2ptHreXU/AET/PYOu53zHYijBjMk7r/Fbj82ed/a65Gc7bZ/8k+i/Hvg3/S+e5s
	EOi7XIHS5yt5E7CE5SE8IdPB+yPXl2o=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=ng4GSga4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1723561921; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Dbu2iXjcABhE/op+lkFf9LsA2UV71HJbPKsi0jtgIdE=;
	b=ng4GSga4ZK6wN8qE9y+FS+k32UFpJXh/MQAPqg70Sw4G3VNLTox/jCRS2mwA+kspure9f3
	yIPQlydyr2UkcDkqjFLueLuVVt683rllTpW6TuGfD6Wc0CkhWqLpSn0TBCnzkSdbQ1NT9U
	hHAgfc2A85ORxL7aC4IO4WMHeEmNZY8=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8C7E113983;
	Tue, 13 Aug 2024 15:12:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id p2KuIMF3u2aSNwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Tue, 13 Aug 2024 15:12:01 +0000
Message-ID: <eb038365e0ce82eaba0cd5697b74ed2a80a45e4e.camel@suse.com>
Subject: Re: [PATCH] removed duplicate check for subsection devices
From: Martin Wilck <mwilck@suse.com>
To: spybull <spybull@proton.me>, "bmarzins@redhat.com"
 <bmarzins@redhat.com>,  "dm-devel@lists.linux.dev"
 <dm-devel@lists.linux.dev>
Date: Tue, 13 Aug 2024 17:12:01 +0200
In-Reply-To: <TI8T_ijNQUzUt4vhmNUqgakWd1LJaKYxVmnFUF2dQs-DdTfLLEbaETdLQv3RjX8ur6T73gxM_arDIAiqD_bPoT01rfmxJ3d7UmHUj-aYyAs=@proton.me>
References: 
	<TI8T_ijNQUzUt4vhmNUqgakWd1LJaKYxVmnFUF2dQs-DdTfLLEbaETdLQv3RjX8ur6T73gxM_arDIAiqD_bPoT01rfmxJ3d7UmHUj-aYyAs=@proton.me>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Rspamd-Queue-Id: B34952282F
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-6.49 / 50.00];
	BAYES_HAM(-2.98)[99.93%];
	DWL_DNSWL_MED(-2.00)[suse.com:dkim];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:dkim,suse.com:mid,suse.com:email,proton.me:email]
X-Spam-Score: -6.49
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Level: 

On Tue, 2024-08-13 at 11:09 +0000, spybull wrote:
> Hello all
>=20
> From cd1c6223f05cd3f34b66fe6239d60e7bc3a5a428 Mon Sep 17 00:00:00
> 2001
> From: Babich Vladimir <spybull@proton.me>
> Date: Tue, 13 Aug 2024 12:49:05 +0300
> Subject: [PATCH] removed duplicate check for subsection devices
>=20

Hm, your email client swallowed all the "||" operators.
But I saw the correct patch under
https://github.com/opensvc/multipath-tools/pull/93

So,

Reviewed-by: Martin Wilck <mwilck@suse.com>

Thanks!

