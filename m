Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5709E208D7
	for <dm-devel@lists.linux.dev>; Thu,  2 May 2024 06:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714629945; cv=none; b=ryES7miBNh4tXBt10IuizwtXvJwEvVoEKorJ3hW6TXe+TSM6l3uyUUJyNy7Uzb3vRCh69be60QvF8a+SpONAKndcr85sFzKJR5mVhqatSTsU7VACbkxQJ/+PBYAX8fhjADH/hDwkYIVmu/h0dhAyuvE9Ecx7jkbDUXM+ms46vWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714629945; c=relaxed/simple;
	bh=RMxyq3pcgaLnaTXu0X9VtGCzw8V2l9Ji9nWk4AeU5JU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ES6OGlzFN4qf1DDoo5NUBTgIk3yUeLuKkkwOpzi6+8yqIcvwRhWtuBdbY8mJ+S7C68+hAmmipT/wbTkxbYVVKQqvH60PsAyU7f7iGZhbQC3y8PzXG3cjGxKctZccfOxrFCucw/3ZH0weo51OKFCG6pKb0tKhRslBi1sOyDvnlMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=zDu6UiaA; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=H6MdSbVe; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=zDu6UiaA; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=H6MdSbVe; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="zDu6UiaA";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="H6MdSbVe";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="zDu6UiaA";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="H6MdSbVe"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 72DCB1FB99;
	Thu,  2 May 2024 06:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1714629940; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bjy9PzjDzsywpsYqHMTzoUUCfvszhGjZi86QsUU5Q90=;
	b=zDu6UiaAVta/SmTt3n4T5sJp8H5qsCRtVFJ2H54l/tmTCpK4EOcN60qxFKDZNWR39EXf+8
	ZHsaxej4TQP9zeNgcKyFHW7FeZLsJwmjEcjuoLqdNaECMycl7Y/yxLU11bvb/ffM/5/XYb
	H8BwQf8iEIN39FscUxT/XV60jLlFQsg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1714629940;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bjy9PzjDzsywpsYqHMTzoUUCfvszhGjZi86QsUU5Q90=;
	b=H6MdSbVe1U0z20pMb2giIKu+9iRtgVd1XNkfN8IoqrUPH3bIpTiWngXyllYPyl62ErhDfE
	6JEnMOSrI6vHfBBw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=zDu6UiaA;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=H6MdSbVe
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1714629940; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bjy9PzjDzsywpsYqHMTzoUUCfvszhGjZi86QsUU5Q90=;
	b=zDu6UiaAVta/SmTt3n4T5sJp8H5qsCRtVFJ2H54l/tmTCpK4EOcN60qxFKDZNWR39EXf+8
	ZHsaxej4TQP9zeNgcKyFHW7FeZLsJwmjEcjuoLqdNaECMycl7Y/yxLU11bvb/ffM/5/XYb
	H8BwQf8iEIN39FscUxT/XV60jLlFQsg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1714629940;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bjy9PzjDzsywpsYqHMTzoUUCfvszhGjZi86QsUU5Q90=;
	b=H6MdSbVe1U0z20pMb2giIKu+9iRtgVd1XNkfN8IoqrUPH3bIpTiWngXyllYPyl62ErhDfE
	6JEnMOSrI6vHfBBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2CB6B13957;
	Thu,  2 May 2024 06:05:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QO/RCDQtM2blNAAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 02 May 2024 06:05:40 +0000
Message-ID: <2069ed0a-790a-4444-9bcb-2a89d3886aaa@suse.de>
Date: Thu, 2 May 2024 08:05:39 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/14] block: Unhash a zone write plug only if needed
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@redhat.com>
References: <20240501110907.96950-1-dlemoal@kernel.org>
 <20240501110907.96950-7-dlemoal@kernel.org>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240501110907.96950-7-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -6.50
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 72DCB1FB99
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-6.50 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	DWL_DNSWL_MED(-2.00)[suse.de:dkim];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]

On 5/1/24 13:08, Damien Le Moal wrote:
> Fix disk_remove_zone_wplug() to ensure that a zone write plug already
> removed from a disk hash table of zone write plugs is not removed
> again. Do this by checking the BLK_ZONE_WPLUG_UNHASHED flag of the plug
> and calling hlist_del_init_rcu() only if the flag is not set.
> 
> Furthermore, since BIO completions can happen at any time, that is,
> decrementing of the zone write plug reference count can happen at any
> time, make sure to use disk_put_zone_wplug() instead of atomic_dec() to
> ensure that the zone write plug is freed when its last reference is
> dropped. In order to do this, disk_remove_zone_wplug() is moved after
> the definition of disk_put_zone_wplug(). disk_should_remove_zone_wplug()
> is moved as well to keep it together with disk_remove_zone_wplug().
> 
> To be consistent with this change, add a check in disk_put_zone_wplug()
> to ensure that a zone write plug being freed was already removed from
> the disk hash table.
> 
> Fixes: dd291d77cc90 ("block: Introduce zone write plugging")
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>   block/blk-zoned.c | 55 +++++++++++++++++++++++++++--------------------
>   1 file changed, 32 insertions(+), 23 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

