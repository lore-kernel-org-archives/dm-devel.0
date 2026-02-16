Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74F882EE607
	for <dm-devel@lists.linux.dev>; Mon, 16 Feb 2026 14:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771252195; cv=none; b=lbMrAnLe7Ukq0TTl1Z9ZordbKcFr3jxm25HgftPWrkBz5I7VvPY533AAPPdx/YSUxt0whn/mSkbL4f2+4gfxv2+si4BOsh2mkveq3H+li4veao4qLijo16JQx6QtKRguwVYZNFYRve6FL8J8Y/MhBQa2IvcrC+PDzlDqutw7ySs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771252195; c=relaxed/simple;
	bh=2L43AkcKAPj5yfrTZMOriDlkGteUcGVDVJX5UWh40Yg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=miVWRGVJv+ZUNmMCdFCqpDFJUtY5VE8gYJ+/mVHL0k3gVTRRLTe+tMBY+Cds7Zk8IzNXGsNRZ1wIoFSp/2rvHvJ7Vw7XEDInePQ6yl7jpTly1bW62OfduSzmv3AYL7TiPiysvb76jMxeNIniwAgKSFenSLVBV2AXMT9xJraM8gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=K9h8t9l2; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=K9h8t9l2; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="K9h8t9l2";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="K9h8t9l2"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A72113E89F;
	Mon, 16 Feb 2026 14:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1771252192; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2L43AkcKAPj5yfrTZMOriDlkGteUcGVDVJX5UWh40Yg=;
	b=K9h8t9l2JoCCdTX2Ce4MBX1YP8ExOslHVdaflyALz5HE6Kmec/AOXx8U+/9sY1RCZNTBEH
	EtuImBiJAkFev5k2Y/8IKcGA8V7CYVVBJBs26IIUL0kHwXObeSATK/guvYMp6ZqCzjzfE9
	Pv2DsE7gIFx8Qnair3tEOgtvhrPRGN0=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1771252192; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2L43AkcKAPj5yfrTZMOriDlkGteUcGVDVJX5UWh40Yg=;
	b=K9h8t9l2JoCCdTX2Ce4MBX1YP8ExOslHVdaflyALz5HE6Kmec/AOXx8U+/9sY1RCZNTBEH
	EtuImBiJAkFev5k2Y/8IKcGA8V7CYVVBJBs26IIUL0kHwXObeSATK/guvYMp6ZqCzjzfE9
	Pv2DsE7gIFx8Qnair3tEOgtvhrPRGN0=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6E2823EA62;
	Mon, 16 Feb 2026 14:29:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ipSbEeApk2n4LAAAD6G6ig
	(envelope-from <mwilck@suse.com>); Mon, 16 Feb 2026 14:29:52 +0000
Message-ID: <9d7f46621b16358471ab29b23da3a060075b8729.camel@suse.com>
Subject: Re: [PATCH] multipath-tools: add missing colon to the multipath
 output
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, DM_DEVEL-ML <dm-devel@lists.linux.dev>
Date: Mon, 16 Feb 2026 15:29:49 +0100
In-Reply-To: <20260216112537.120343-1-xose.vazquez@gmail.com>
References: <20260216112537.120343-1-xose.vazquez@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid,suse.com:email]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

On Mon, 2026-02-16 at 12:25 +0100, Xose Vazquez Perez wrote:
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
> =C2=A0libmultipath/propsel.c | 2 +-
> =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
>=20

Reviewed-by: Martin Wilck <mwilck@suse.com>
