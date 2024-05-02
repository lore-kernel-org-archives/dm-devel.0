Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77F819BBA
	for <dm-devel@lists.linux.dev>; Thu,  2 May 2024 06:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714630398; cv=none; b=k6ggvnTR10Crfh5QHO4LYk2ceO/kHnYABXF0bFe4mkTtU2yRrvnRAkLQ9utZNDi5eq40PKAsOe27+gULRf8T9YLazc7sfzP/tsqNJRdZ4zCaASrh7CX92wj555+6j1dHGiowGckskSi2KuAvOM0F3jJKnlf1Y2F3EiaaeXf5kVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714630398; c=relaxed/simple;
	bh=paUDE/j3lxS/rOS8PY75c5kvyDoaviwLnIunHiOGwL0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=YlSCqhnhxUAz9UQwgDOKVbaAsvBoBj1EJbeP/EKjtoCXfuU329N8ASN0WpTIvZOzEvTCso3WANe6pVRqLWcugmRfUY5F8CoOQ6OJHCYPtuY5nE/m2zp04YRrbqw92cZvdG7a7DNt7nXk9JrO5xUkgr1rHiJEP0vqZi0H8GgtNlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=E26CM3zA; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=HiCZyVZE; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=E26CM3zA; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=HiCZyVZE; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="E26CM3zA";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="HiCZyVZE";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="E26CM3zA";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="HiCZyVZE"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 155E61FB99;
	Thu,  2 May 2024 06:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1714630395; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oXMuMKR7/M3RbksrOVUnQAxtSvWFp/lW35xHIQcleAI=;
	b=E26CM3zAMqZSlq6q3HvSqm/W7+uRa+6uRqGDa6/FLFAM34n9fAW/WtdnnI/U9P4UFzUdcJ
	uSMzmyepNnWrf7kk4SCX5SbeU5xGMIPdIcTCCNXnh0nTr58PwUJI48TZqohQRjq2EJfA5Q
	nGDIHrJ1DiOp2fuZYBMkZWL+AvP5E2k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1714630395;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oXMuMKR7/M3RbksrOVUnQAxtSvWFp/lW35xHIQcleAI=;
	b=HiCZyVZEbevFncHAvxH8MAEQ36CA3qeuL3mtGp8NY5E56tCT6uNDmhSeqoX6AN64kyPTV5
	i4c0sZ9apFZUmYCg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1714630395; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oXMuMKR7/M3RbksrOVUnQAxtSvWFp/lW35xHIQcleAI=;
	b=E26CM3zAMqZSlq6q3HvSqm/W7+uRa+6uRqGDa6/FLFAM34n9fAW/WtdnnI/U9P4UFzUdcJ
	uSMzmyepNnWrf7kk4SCX5SbeU5xGMIPdIcTCCNXnh0nTr58PwUJI48TZqohQRjq2EJfA5Q
	nGDIHrJ1DiOp2fuZYBMkZWL+AvP5E2k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1714630395;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oXMuMKR7/M3RbksrOVUnQAxtSvWFp/lW35xHIQcleAI=;
	b=HiCZyVZEbevFncHAvxH8MAEQ36CA3qeuL3mtGp8NY5E56tCT6uNDmhSeqoX6AN64kyPTV5
	i4c0sZ9apFZUmYCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9A20A1386E;
	Thu,  2 May 2024 06:13:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ICyBI/ouM2ZMNgAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 02 May 2024 06:13:14 +0000
Message-ID: <88eab17c-de23-4f1c-b9b1-5ebdafe266e7@suse.de>
Date: Thu, 2 May 2024 08:13:13 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 10/14] block: Improve blk_zone_write_plug_bio_merged()
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@redhat.com>
References: <20240501110907.96950-1-dlemoal@kernel.org>
 <20240501110907.96950-11-dlemoal@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240501110907.96950-11-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:email]
X-Spam-Score: -4.29
X-Spam-Flag: NO

On 5/1/24 13:09, Damien Le Moal wrote:
> Improve blk_zone_write_plug_bio_merged() to check that we succefully get
> a reference on the zone write plug of the merged BIO, as expected since
> for a merge we already have at least one request and one BIO referencing
> the zone write plug. Comments in this function are also improved to
> better explain the references to the BIO zone write plug.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>   block/blk-zoned.c | 9 +++++++--
>   1 file changed, 7 insertions(+), 2 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

