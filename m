Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9E0B320E
	for <dm-devel@lists.linux.dev>; Thu,  2 May 2024 06:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714630325; cv=none; b=CJHnTtY+hl1JCNdy1alZq0H2k7GQJ/Kkl+1zOYzgQiho6s2CY6O8kmnZGjdRB32137VMkorVQlfR9WO2ojSl9Mfe2XMDFF03MYu1C8/qbXBbjLNpc+OFs4iIDxd3AcV3SeqjB9A/As1LTObtgYgXC2KKHY3lPGwDLoMpt+597Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714630325; c=relaxed/simple;
	bh=MCxMeek1JhQY1UqefDFPTPZrl7KO6eqwEONHezVc2qs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=T1WG3wBC3gnO/VVDKZ/OfwjkZfXRJ1jbcj3ZEV9tslN7odd74okALzLuyFW+54BpKOs48qrwk81uaY1QKtkdcWCPsUvpGYpafWJIsON5rvAuH77JiulH1r4tjpo5JPqgQHfJP8HOPkMKn+7TUxcwCbCmJwuVbtxz7+NMOQnVc/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=nsQLu8AK; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=InVtJ8rA; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=nsQLu8AK; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=InVtJ8rA; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="nsQLu8AK";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="InVtJ8rA";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="nsQLu8AK";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="InVtJ8rA"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0B49835008;
	Thu,  2 May 2024 06:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1714630321; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6MBmIOGke7oMjlMsdaUYRtfYRQRl9qZvuUD/BAmuiiw=;
	b=nsQLu8AK4OGnQrpgLErerMw+5u1IB23mA/YfK7xJPk2QidYFzs+Hpg5xXbiZT2ASTQU8rI
	36Wvqto4RD/iXm0a/pq5OpnndkvUEy21nyMemKCY+5tUutU/hKF2Y1zSgkgS//+nrlv+ZI
	uyu29Pgo2ztCqs4oVMZWaAmkQZ4javY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1714630321;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6MBmIOGke7oMjlMsdaUYRtfYRQRl9qZvuUD/BAmuiiw=;
	b=InVtJ8rAWt2UTPu/ow52erpGm8TlxiRFOoIY2QxDfTgZW+FoStH+SdlH542pC/4r5tj73z
	U+zpJKDZ2WW+85Cg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1714630321; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6MBmIOGke7oMjlMsdaUYRtfYRQRl9qZvuUD/BAmuiiw=;
	b=nsQLu8AK4OGnQrpgLErerMw+5u1IB23mA/YfK7xJPk2QidYFzs+Hpg5xXbiZT2ASTQU8rI
	36Wvqto4RD/iXm0a/pq5OpnndkvUEy21nyMemKCY+5tUutU/hKF2Y1zSgkgS//+nrlv+ZI
	uyu29Pgo2ztCqs4oVMZWaAmkQZ4javY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1714630321;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6MBmIOGke7oMjlMsdaUYRtfYRQRl9qZvuUD/BAmuiiw=;
	b=InVtJ8rAWt2UTPu/ow52erpGm8TlxiRFOoIY2QxDfTgZW+FoStH+SdlH542pC/4r5tj73z
	U+zpJKDZ2WW+85Cg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B99D31386E;
	Thu,  2 May 2024 06:12:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2BGBK7AuM2ZMNgAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 02 May 2024 06:12:00 +0000
Message-ID: <83b23ef3-e46e-493b-a6ab-9496517822b9@suse.de>
Date: Thu, 2 May 2024 08:11:59 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/14] block: Fix handling of non-empty flush write
 requests to zones
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@redhat.com>
References: <20240501110907.96950-1-dlemoal@kernel.org>
 <20240501110907.96950-10-dlemoal@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240501110907.96950-10-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -4.29
X-Spam-Level: 
X-Spamd-Result: default: False [-4.29 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]

On 5/1/24 13:09, Damien Le Moal wrote:
> Zone write plugging ignores empty (no data) flush operations but handles
> flush BIOs that have data to ensure that the flush machinery generated
> write is processed in order. However, the call to
> blk_zone_write_plug_attempt_merge() which sets a request
> RQF_ZONE_WRITE_PLUGGING flag is called after blk_insert_flush(), thus
> missing indicating that a non empty flush request completion needs
> handling by zone write plugging.
> 
> Fix this by moving the call to blk_zone_write_plug_attempt_merge()
> before blk_insert_flush(). And while at it, rename that function as
> blk_zone_write_plug_init_request() to be clear that it is not just about
> merging plugged BIOs in the request. While at it, also add a WARN_ONCE()
> check that the zone write plug for the request is not NULL.
> 
> Fixes: dd291d77cc90 ("block: Introduce zone write plugging")
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>   block/blk-mq.c    |  6 +++---
>   block/blk-zoned.c | 12 ++++++++----
>   block/blk.h       |  4 ++--
>   3 files changed, 13 insertions(+), 9 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

