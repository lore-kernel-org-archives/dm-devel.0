Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D241D20DD2
	for <dm-devel@lists.linux.dev>; Thu,  2 May 2024 06:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714630665; cv=none; b=ZfWoLn2vt3NLMw9/4JMIv52bZbnplvHk1f+QDWnc+s2sD23E6V9sHgI4GJl1FN099szvn1KYks6RCeUGIWuA9b7/b1S7zvT2UZCTCC7U9axs4PASyf0CXx+Gvgee1QF8pflXhXMZ2jtOuYvyOvMAXTjRW9nUlR7MItim4ExaC1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714630665; c=relaxed/simple;
	bh=Sl5gUGB5ZzQlUVPKcb23ztOy0M8yoP8sF5qYiLxBwK0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=CnwB+E3tJ4LSI/5vOUCS7ZY+djNf55NfZ3jJVpMMWJ8KJybNT31aKmwZWGVwVFqKdNgZbjNaUAisn4cr8cWQ3L4x78geqDKCbUWc4j5u2SVWecxpXooFrwBZ3xtx0FJMbu7CIbUGoMSWi8j0OMCPxsLWEnnOWWl7Yf1lJ1LTnzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=PIzLf7ds; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=3Dh1xAJ4; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=FqFfmb3L; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=gspXrBhM; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="PIzLf7ds";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="3Dh1xAJ4";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="FqFfmb3L";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="gspXrBhM"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5044F1FBA0;
	Thu,  2 May 2024 06:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1714630662; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qacpEau5b1l43ykPJ/yo27juHJ1ZDFIBuzANBUXAopA=;
	b=PIzLf7ds9xLsH0KWYE0/o8ISOZfOeLsRD1csX0AhEqemCoSnFPPAemqFqOBVqVhLa8+FPU
	mVLk2CVLqyx4iHGx0hearhuPyeWgFncu4LEex2VHL3QkOMutdMlzgE6G6pYch3y/emlfkZ
	Dgb6A93fRK29zI44DEUKnISHCsCIWFQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1714630662;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qacpEau5b1l43ykPJ/yo27juHJ1ZDFIBuzANBUXAopA=;
	b=3Dh1xAJ4VsGXOaf9ZcqkvhlZ3sNrzTbt2oiYlGBkrSf4KPPR8Be9xTcVtVfgeAaQYqHRRI
	QD0c54/oq8htaPCQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FqFfmb3L;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=gspXrBhM
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1714630661; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qacpEau5b1l43ykPJ/yo27juHJ1ZDFIBuzANBUXAopA=;
	b=FqFfmb3LZsQZu2VnMZi1ySKlfBOGWOtoUc5APWaO/1fwSmRznKG49M5URhVhLp2oos57rN
	RWvNGxtRnL4qqtzmEdtTirvvIUzZ5Tumata5OxeBejBeX7vd0IL4li9l4GIH7lS8afX5is
	xaSbw8e3M0raYlYlekfrTXosqt+xBuU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1714630661;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qacpEau5b1l43ykPJ/yo27juHJ1ZDFIBuzANBUXAopA=;
	b=gspXrBhMvPnjrb3V9PL4VDvmVq619vd1Ba7Km+RO0tSwYOX9oV73NF4IJmb0/Uam6ydLcP
	I0Ta/Y5OjJKN93BA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 18D251386E;
	Thu,  2 May 2024 06:17:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tbVnBAUwM2a2OAAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 02 May 2024 06:17:41 +0000
Message-ID: <cff4fe01-76d7-4ca1-8db6-8ec40a4ef116@suse.de>
Date: Thu, 2 May 2024 08:17:39 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 14/14] block: Cleanup blk_revalidate_zone_cb()
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@redhat.com>
References: <20240501110907.96950-1-dlemoal@kernel.org>
 <20240501110907.96950-15-dlemoal@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240501110907.96950-15-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.50 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 5044F1FBA0
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Score: -4.50

On 5/1/24 13:09, Damien Le Moal wrote:
> Define the code for checking conventional and sequential write required
> zones suing the functions blk_revalidate_conv_zone() and

using

> blk_revalidate_seq_zone() respectively. This simplifies the zone type
> switch-case in blk_revalidate_zone_cb().
> 
> No functional changes.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   block/blk-zoned.c | 129 +++++++++++++++++++++++++++-------------------
>   1 file changed, 77 insertions(+), 52 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

