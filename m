Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF69210E4
	for <dm-devel@lists.linux.dev>; Thu,  2 May 2024 05:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714629130; cv=none; b=W48/E6Wo3lxa7jfoQ60HDD55kjX7czPqzHKGAltPtHTCFWYj6P8QGlIdSwu8gNASPBsMmLkutzE25nzHPXTA6cN0ZnqLL9PsO2xi27GY8CZcKEsVFcaxvfGPj7DTG8SiHAzHmvd6mlKPWgFKOSk/qI4esTJHSAyP1aso3TaMWH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714629130; c=relaxed/simple;
	bh=Is/7uLglwJtxzSQe0FyMkav8TQQ9e6aE2IeF4vh0NDY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=KzsjzWjfiU/wSNdxjp4bAgQ3FiZTK3+fhDlYdi63DXMvn588gv2dK/DSys2wqUex8Y4X9b/HFd4XnwCsf56APD9ytFCXIG0tHVQaoSyxD+vgKWz40cmza5dPGlJyqOzVOSXfDjc6RDe3wK0dZfFBOwesUQcz7I/kRwGmHfqg8tQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=IhUWhyc4; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ep7O70d4; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=IhUWhyc4; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ep7O70d4; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="IhUWhyc4";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ep7O70d4";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="IhUWhyc4";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ep7O70d4"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6CFE234FE1;
	Thu,  2 May 2024 05:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1714629126; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Th7OKRKrC2Tb8u9LD1r2qnxLpLZvYTaVRgO7T9cFwt0=;
	b=IhUWhyc4vZ6Dze6lC7GLxy9SPum0yqCcBXXgo3ClxEKtpMYxLDPBKRIqiTLm2iJwVMQXUL
	qMgmhMrxXu7i1JuC0o58qwNZvgJ+COaL3JFCw+cKsFlgzhpXP78lJLa0mB2DYDM28/o++N
	O928/8fvGn4ZVe3l3SP79ZECgP050rg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1714629126;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Th7OKRKrC2Tb8u9LD1r2qnxLpLZvYTaVRgO7T9cFwt0=;
	b=ep7O70d4+PCSZezfmaLFWf7jTpdPZ97RXME2rfGAdp9mJGsH5CFcZRHCMEMaskOlngAkc4
	cMLG1WWhxUKUzlBA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=IhUWhyc4;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ep7O70d4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1714629126; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Th7OKRKrC2Tb8u9LD1r2qnxLpLZvYTaVRgO7T9cFwt0=;
	b=IhUWhyc4vZ6Dze6lC7GLxy9SPum0yqCcBXXgo3ClxEKtpMYxLDPBKRIqiTLm2iJwVMQXUL
	qMgmhMrxXu7i1JuC0o58qwNZvgJ+COaL3JFCw+cKsFlgzhpXP78lJLa0mB2DYDM28/o++N
	O928/8fvGn4ZVe3l3SP79ZECgP050rg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1714629126;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Th7OKRKrC2Tb8u9LD1r2qnxLpLZvYTaVRgO7T9cFwt0=;
	b=ep7O70d4+PCSZezfmaLFWf7jTpdPZ97RXME2rfGAdp9mJGsH5CFcZRHCMEMaskOlngAkc4
	cMLG1WWhxUKUzlBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 32ED713326;
	Thu,  2 May 2024 05:52:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HPERCgYqM2YXMQAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 02 May 2024 05:52:06 +0000
Message-ID: <124aa437-e09e-4d2d-9bf5-59045e6bbd54@suse.de>
Date: Thu, 2 May 2024 07:52:04 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/14] block: Exclude conventional zones when faking
 max open limit
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@redhat.com>
References: <20240501110907.96950-1-dlemoal@kernel.org>
 <20240501110907.96950-3-dlemoal@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240501110907.96950-3-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.50 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 6CFE234FE1
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Score: -4.50

On 5/1/24 13:08, Damien Le Moal wrote:
> For a device that has no limits for the maximum number of open and
> active zones, we default to using the number of zones, limited to
> BLK_ZONE_WPLUG_DEFAULT_POOL_SIZE (128), for the maximum number of open
> zones indicated to the user. However, for a device that has conventional
> zones and less zones than BLK_ZONE_WPLUG_DEFAULT_POOL_SIZE, we should
> not account conventional zones and set the limit to the number of
> sequential write required zones. Furthermore, for cases where the limit
> is equal to the number of sequential write required zones, we can
> advertize a limit of 0 to indicate "no limits".
> 
> Fix this by moving the zone write plug mempool resizing from
> disk_revalidate_zone_resources() to disk_update_zone_resources() where
> we can safely compute the number of conventional zones and update the
> limits.
> 
> Fixes: 843283e96e5a ("block: Fake max open zones limit when there is no limit")
> Reported-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>   block/blk-zoned.c | 38 ++++++++++++++++++++++++++++----------
>   1 file changed, 28 insertions(+), 10 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

