Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22B03BE147
	for <dm-devel@lists.linux.dev>; Thu, 25 Jun 2026 06:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782368800; cv=none; b=K5Y9qFhprCbjeR02H/JXPQHGDKtSte/JI/J1paqQEr2s/BrBlYH8YU5eBTFzSAeF9spJIRrHWLmoX1gQV82V3SrhVLOodzZ5OpcKiXe4zkhtUj2dAPAB1XYzZLAK/VEXkIJTRpgjUlcWQ5TyP9wbPt5v4aOBjolUAoyT8xvgJk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782368800; c=relaxed/simple;
	bh=HcW+L5T+Qky+xo3J+n1Fku+nL2Nswn2OzModHv/j2uw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gshGa9+x1Nz08zvnBSlUjZcdXdu3+Xglcm/xXaaidR3cRFvLuptmeMRzDSzuqXgUcjCmxwT/c+o1gSzp72jpaaa7r6AmJfbg9LyYNZf9K0jFJp0SjH1vTRlAVW4T5qw2tBB5EHCypmiGMva5YOfW3qi3MDualt7Ah8P/+61myh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=lGyiGJFx; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=kEceCIIJ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=lGyiGJFx; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=kEceCIIJ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="lGyiGJFx";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kEceCIIJ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="lGyiGJFx";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kEceCIIJ"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5DEF7717DB;
	Thu, 25 Jun 2026 06:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782368797; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bm8B3uQ8SOI6t/viUBWEauLyKC5BACJBZxQz/3RtpPg=;
	b=lGyiGJFxwU9/t0TJ9m3PfSbJ7jRP8CkFht7JwJsfLGkoQP45tRYqfODJBl/LJ9gQbXQj2F
	DOPVt+pP5snmC4AZ8EnzOOkgBIp4DesrNbpPeopzAbD3LfRBebYB5YhZVC351NXkYi3NLM
	8nhVIHspPo+DMlntx1eWL++tPXbwuow=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782368797;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bm8B3uQ8SOI6t/viUBWEauLyKC5BACJBZxQz/3RtpPg=;
	b=kEceCIIJwFCFH4GnSO19RBk4naGALrmhvRckEDA5xoVyrv68nasgM2T9BKtOTUDeVBU7Hc
	ZUrM3z7W+98FD9DQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=lGyiGJFx;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=kEceCIIJ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782368797; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bm8B3uQ8SOI6t/viUBWEauLyKC5BACJBZxQz/3RtpPg=;
	b=lGyiGJFxwU9/t0TJ9m3PfSbJ7jRP8CkFht7JwJsfLGkoQP45tRYqfODJBl/LJ9gQbXQj2F
	DOPVt+pP5snmC4AZ8EnzOOkgBIp4DesrNbpPeopzAbD3LfRBebYB5YhZVC351NXkYi3NLM
	8nhVIHspPo+DMlntx1eWL++tPXbwuow=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782368797;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bm8B3uQ8SOI6t/viUBWEauLyKC5BACJBZxQz/3RtpPg=;
	b=kEceCIIJwFCFH4GnSO19RBk4naGALrmhvRckEDA5xoVyrv68nasgM2T9BKtOTUDeVBU7Hc
	ZUrM3z7W+98FD9DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F3763779A8;
	Thu, 25 Jun 2026 06:26:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bxbNORzKPGqbRQAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 25 Jun 2026 06:26:36 +0000
Message-ID: <14b10820-8af3-47ca-a471-41d6e90afb6b@suse.de>
Date: Thu, 25 Jun 2026 08:26:36 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/5] zloop: set dma_alignment from the backing files
 for direct I/O
To: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
Cc: dm-devel@lists.linux.dev, hch@lst.de, axboe@kernel.dk,
 brauner@kernel.org, djwong@kernel.org, viro@zeniv.linux.org.uk,
 Keith Busch <kbusch@kernel.org>
References: <20260624170905.3972095-1-kbusch@meta.com>
 <20260624170905.3972095-5-kbusch@meta.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260624170905.3972095-5-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 5DEF7717DB
X-Spam-Flag: NO
X-Spam-Score: -5.51
X-Spam-Level: 
X-Spamd-Result: default: False [-5.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	DWL_DNSWL_LOW(-1.00)[suse.de:dkim];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	URIBL_BLOCKED(0.00)[suse.de:dkim,suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On 6/24/26 7:09 PM, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Direct I/O user pages are forwarded to the backing files unchanged, so
> the backing's DMA alignment requirement applies to them. Track the
> backing file's dio_mem_align and advertise it as the zloop device's
> dma_alignment if it is larger than the default so we advertise proper
> limits and misaligned I/O is rejected early instead of being dispatched
> to the backend.
> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>   drivers/block/zloop.c | 35 +++++++++++++++++++++++++----------
>   1 file changed, 25 insertions(+), 10 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
