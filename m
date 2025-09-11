Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 412B5178372
	for <dm-devel@lists.linux.dev>; Thu, 11 Sep 2025 06:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757570467; cv=none; b=cZvIP9W5thz91+6ebjsI8AYqtxkGjntiZMqBsL+fsLNujTe8gG48db8UVQ45CGrmsNGI/uQOvNu1PzK9nQkfZmQIfnFm2kwwk8hIWoSHhkdlAT27yamQfy3p+AhKtJqdoLmRl4GXIqCIi3IOWZkLgJ90G3FCzSV5l3qgdstZ4yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757570467; c=relaxed/simple;
	bh=PSMXmytG9kDLN2g6rJ8G5P1XD44cmYyfx1vDuSCaU3c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AgnFvOjQXGyKW+Q7oSz+2nJdLJxMlFQuIhpumUXUskiwk5mgawUYW5ohIwlUtoz30j0TYbHIMYe/7ff2TTt/LKE51kGyHkTh6ICoL9u94E7tOC/xnVNdkL7YygLeK5jXNF9uZUGw7gNLksit7x9r5sAgLjSDHaK5053cQRTWuRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=GeeR2irY; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=vv0EaV0E; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=GeeR2irY; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=vv0EaV0E; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="GeeR2irY";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="vv0EaV0E";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="GeeR2irY";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="vv0EaV0E"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CB42D372C5;
	Thu, 11 Sep 2025 06:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757570462; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U5+ZIA/2TrJD876qLUDhS8rerYGRbbiyLk/wmVD5X1Y=;
	b=GeeR2irY1FG/gibTeZtyFYAMUUSKlGAUfnFo/Et80/ldfjD68d0jInM9dGl9D0Hzd6/rZF
	MaprpfO2pDgIaiwaVKFTaiDvjMPGxgq2e+GtvPm5lvvFMVfbHd/pvPbAb9r/GFCuojbsX8
	eOIWu1HkjwVW5KOVaSpi++RRBziFnuc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757570462;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U5+ZIA/2TrJD876qLUDhS8rerYGRbbiyLk/wmVD5X1Y=;
	b=vv0EaV0EF2iCSU8PHY6F0afcoxPi3zYs5AbEQg1rtq/lza8V862BvxNdTuyLZwxeftE1Lo
	3A61ibQLq5MkOKCw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757570462; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U5+ZIA/2TrJD876qLUDhS8rerYGRbbiyLk/wmVD5X1Y=;
	b=GeeR2irY1FG/gibTeZtyFYAMUUSKlGAUfnFo/Et80/ldfjD68d0jInM9dGl9D0Hzd6/rZF
	MaprpfO2pDgIaiwaVKFTaiDvjMPGxgq2e+GtvPm5lvvFMVfbHd/pvPbAb9r/GFCuojbsX8
	eOIWu1HkjwVW5KOVaSpi++RRBziFnuc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757570462;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U5+ZIA/2TrJD876qLUDhS8rerYGRbbiyLk/wmVD5X1Y=;
	b=vv0EaV0EF2iCSU8PHY6F0afcoxPi3zYs5AbEQg1rtq/lza8V862BvxNdTuyLZwxeftE1Lo
	3A61ibQLq5MkOKCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8BE701372E;
	Thu, 11 Sep 2025 06:01:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4asaIJ5lwmhdQwAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 11 Sep 2025 06:01:02 +0000
Message-ID: <e1e3a403-87e8-4e06-b68f-b8c8814a3160@suse.de>
Date: Thu, 11 Sep 2025 08:01:02 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] dm: Preserve the order of REQ_PREFLUSH writes
To: Bart Van Assche <bvanassche@acm.org>,
 Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
 Damien Le Moal <dlemoal@kernel.org>, Alasdair Kergon <agk@redhat.com>
References: <20250910172742.187645-1-bvanassche@acm.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250910172742.187645-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_TWO(0.00)[2];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid]
X-Spam-Flag: NO
X-Spam-Score: -4.30

On 9/10/25 19:27, Bart Van Assche wrote:
> The dm core splits REQ_PREFLUSH bios that have data into two bios.
> First, a REQ_PREFLUSH bio with no data is submitted to all underlying
> dm devices. Next, the REQ_PREFLUSH flag is cleared and the same bio is
> resubmitted. This approach is essential if there are multiple underlying
> devices to provide correct REQ_PREFLUSH semantics.
> 
> Splitting a bio into an empty flush bio and a non-flush data bio is
> not necessary if there is only a single underlying device. Hence this
> patch that does not split REQ_PREFLUSH bios if there is only one
> underlying device.
> 
> This patch preserves the order of REQ_PREFLUSH writes if there is only
> one underlying device and if one or more write bios have been queued
> past the REQ_PREFLUSH bio before the REQ_PREFLUSH bio is processed.
> 
> Cc: Mike Snitzer <snitzer@kernel.org>
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> 
> Changes compared to v1:
>   - Made the patch description more detailed.
>   - Removed the reference to write pipelining from the patch description.
> 
>   drivers/md/dm.c | 16 ++++++++++------
>   1 file changed, 10 insertions(+), 6 deletions(-)
> 
Hmm. But if additional writes can sneak in between sending the empty
flush and the original write bio, why does that happen only for targets
with one device?
IOW: Doesn't this reordering also happen for targets with several
devices?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
