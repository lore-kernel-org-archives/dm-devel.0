Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF2A3074B1
	for <dm-devel@lists.linux.dev>; Thu, 25 Jun 2026 06:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782368485; cv=none; b=f2OqKI8ni97P6uSQ96g2OYKqqbQTwIr9fK3GYJtarAvNUEKJN/5pS2kQ1TX4T8ZBEZYOtTYtGzswj5JTMy62mukBMx3KwuBbDsSxFgdpa9ZwFVwMH24+rkhKsJgQr3JT8ypoGg7rNqwFjlaOXtaLv5OgPuSMt2N/RteK7LBpA44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782368485; c=relaxed/simple;
	bh=bL8/YbKKO5Np+ohroE0bx+J5q+sOxNqPhtv58rBJzBs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FeN4sZH+Qls5WyQkt1P+QR/hSQE87Op9D0tc+hAsP6DNT8BEW85lSWwTtmIRgCY2UPrVda8fCMR9lfLeDvv+YQmF0H5KGj/uJ5sBogk8Pkgxe9tZHSzV6/15NK19iYJNQ4IuxtEorovtSnJd3Z/3rzVy8gYz/a+n6HwLcLW6Tj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=njlxOvk6; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=+oqTS3T/; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=MdPeFHw0; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=u3vEFErV; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="njlxOvk6";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="+oqTS3T/";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="MdPeFHw0";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="u3vEFErV"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CA87E7177E;
	Thu, 25 Jun 2026 06:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782368482; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cdZ2+S7fWe0B1dG1muf9vuVLk8A9vqThawVcdjGfxpY=;
	b=njlxOvk6oXG8WupgwmjL7HD/Zu580AUYU54blJKMBZk8pGBKh3wMOPRahaLLTr1mvIU7et
	eld5WcZC1ua3IyyU7kTSSCdEwwr5IQwVkASLEOVZqTJCHhrpLFLjpfvLrqUEeb7c7P3chL
	4LotzwDllRnTYgIlpRgAo4wAVeH/XQc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782368482;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cdZ2+S7fWe0B1dG1muf9vuVLk8A9vqThawVcdjGfxpY=;
	b=+oqTS3T//GPVhZ12keIB/iU7Vt0PzA2UER9RAbLumPfmg4dE7ejVCKp9rSyfACoZwZ1dYe
	H5aXNVLw+wnmwSCA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782368481; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cdZ2+S7fWe0B1dG1muf9vuVLk8A9vqThawVcdjGfxpY=;
	b=MdPeFHw0YTuQkYaqf12eCxAxa47XxhmiV44LnDS5wLKIhoLwkVg14Wj6rHowYoxm3emko9
	koyi1As4Fn7Ih6GyQOOShW4gRRBy0ZjoFF8xs1Zh+9SuWYZB8lTC4xtB/Q/PlO6cOzxI/A
	qfjPDVy/32K3GAG43BfMMNWTvicoW3Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782368481;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cdZ2+S7fWe0B1dG1muf9vuVLk8A9vqThawVcdjGfxpY=;
	b=u3vEFErVBNj2PiCjXGSsYnvLQZHsz2Kzidtg8F53J2aJAlB8kEicfiklJ89MFDaobDlPxV
	wgCT+ao+D+sTE3CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 79CAD779A8;
	Thu, 25 Jun 2026 06:21:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id s/01HOHIPGrbQAAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 25 Jun 2026 06:21:21 +0000
Message-ID: <09a9a71d-9da9-4fcc-ad04-5acc9c053399@suse.de>
Date: Thu, 25 Jun 2026 08:21:21 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/5] block: fix dio leak on metadata mapping error
To: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
Cc: dm-devel@lists.linux.dev, hch@lst.de, axboe@kernel.dk,
 brauner@kernel.org, djwong@kernel.org, viro@zeniv.linux.org.uk,
 Keith Busch <kbusch@kernel.org>
References: <20260624170905.3972095-1-kbusch@meta.com>
 <20260624170905.3972095-3-kbusch@meta.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260624170905.3972095-3-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo,lst.de:email]
X-Spam-Level: 

On 6/24/26 7:09 PM, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> A failed integrity mapping holds a dio reference, so we need to go
> through the full bio ending in case there were previously submitted
> bio's in the sequence.
> 
> Fixes: 2729a60bbfb92 ("block: don't silently ignore metadata for sync read/write")
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>   block/fops.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
