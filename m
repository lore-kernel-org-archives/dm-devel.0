Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807EB20DC3
	for <dm-devel@lists.linux.dev>; Thu,  2 May 2024 05:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714629217; cv=none; b=Jxzowa8mDzkUxfmy1eIWI8pEqAfI/8JPyeTE4fJW5FdCMvgdqqAaituqlcPyO8OX6iS/tsDTr1QUvtOmAvsAOfgFI2xDyfPwCaZd33DqUTlMtnkvKbJ0ppI+ImxpLQ4gkHHsbR+tiKoLCvx6+5/2/LgFNEexp9caHZNsYlaQPZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714629217; c=relaxed/simple;
	bh=OVp5PIBaGWITFmPhq5tvBajBugH1TopbMVbjp314sp8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=lE/JB4GSTz1GH7QY4Ujts3npFpkaibcpp9N/rChZyIxG9lgTG4OnHx5bfPSjGuRcYEATfneFnB/DxKPF4bvmnbdsjK7FfACNBbW6AtI/MF2rtHW3B0zuofIRbgrrQAWOabvAI8r+CnIQKLxcKnPy4vOQmQc2Y/15gEIXjRpz830=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=tRuH3UQ+; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Vu6nrCRu; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=tRuH3UQ+; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Vu6nrCRu; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="tRuH3UQ+";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Vu6nrCRu";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="tRuH3UQ+";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Vu6nrCRu"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B49AE1FB9B;
	Thu,  2 May 2024 05:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1714629214; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EA4jIojeVUp482zW5vj6NmFzrEze4JJHyNUOE53kEBA=;
	b=tRuH3UQ+iUdfIBGmQiKNNJBWpqdHEX1e8YcysLIzdpRlgqKpZjmp76msg5+kb6M9dqwbcs
	2H+l04ZObthCEq4i8PtezAohegwaJvfdoEdmYeU/NgluMEsz7wMDFWpkj/CV6dQwn3GkhG
	itdaEXrku9m415dSxLDO+MEJ1HseirU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1714629214;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EA4jIojeVUp482zW5vj6NmFzrEze4JJHyNUOE53kEBA=;
	b=Vu6nrCRuz0ZLGmxXcfb5IHZv9gdG8Eejk5DeniLzBeKRvGektceuGo96TxpAiIwmMjkT2b
	cXlWBDSi2FonAIDQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1714629214; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EA4jIojeVUp482zW5vj6NmFzrEze4JJHyNUOE53kEBA=;
	b=tRuH3UQ+iUdfIBGmQiKNNJBWpqdHEX1e8YcysLIzdpRlgqKpZjmp76msg5+kb6M9dqwbcs
	2H+l04ZObthCEq4i8PtezAohegwaJvfdoEdmYeU/NgluMEsz7wMDFWpkj/CV6dQwn3GkhG
	itdaEXrku9m415dSxLDO+MEJ1HseirU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1714629214;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EA4jIojeVUp482zW5vj6NmFzrEze4JJHyNUOE53kEBA=;
	b=Vu6nrCRuz0ZLGmxXcfb5IHZv9gdG8Eejk5DeniLzBeKRvGektceuGo96TxpAiIwmMjkT2b
	cXlWBDSi2FonAIDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 66ED113326;
	Thu,  2 May 2024 05:53:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kEYNF14qM2YXMQAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 02 May 2024 05:53:34 +0000
Message-ID: <a4a24ec1-9f22-4c36-96f1-4b5206ab0fbc@suse.de>
Date: Thu, 2 May 2024 07:53:33 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/14] block: Fix zone write plug initialization from
 blk_revalidate_zone_cb()
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@redhat.com>
References: <20240501110907.96950-1-dlemoal@kernel.org>
 <20240501110907.96950-4-dlemoal@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240501110907.96950-4-dlemoal@kernel.org>
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
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email]

On 5/1/24 13:08, Damien Le Moal wrote:
> When revalidating the zones of a zoned block device,
> blk_revalidate_zone_cb() must allocate a zone write plug for any
> sequential write required zone that is not empty nor full. However, the
> current code tests the latter case by comparing the zone write pointer
> offset to the zone size instead of the zone capacity. Furthermore,
> disk_get_and_lock_zone_wplug() is called with a sector argument equal to
> the zone start instead of the current zone write pointer position.
> This commit fixes both issues by calling disk_get_and_lock_zone_wplug()
> for a zone that is not empty and with a write pointer offset lower than
> the zone capacity and use the zone capacity sector as the sector
> argument for disk_get_and_lock_zone_wplug().
> 
> Fixes: dd291d77cc90 ("block: Introduce zone write plugging")
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>   block/blk-zoned.c | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

