Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF66A2749CA
	for <dm-devel@lists.linux.dev>; Tue, 29 Apr 2025 06:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745908053; cv=none; b=Q92weUJ1/fjK0oj9pJuQd+m+5nbb0wRnuv8q5n1NiinVspZ8GCFMsUTNxRZH/h0WxzBDWlqj8d+BCcE9rgm+gnxsF4jzR609BGXkXoAlnP8owEP9URHJzNGkQkSpZmVvSXIrY/sidDNbPSQj6UwAD3LikHbM6IBzJlAyR9ceGqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745908053; c=relaxed/simple;
	bh=xrsciajtCOMDU/0+6efvQVMaAL+7MADLRTwjTRj09ks=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P9h1ooX8EYoYyiqc3B9tP97FqilWkbM7j3RD6cLeO91iHS0Yhtzsl9fWNxdbcRb/34/Nm9YAnSZstnfi5heYC1yN0CtFVDfkOtZkbpwryYEGuumBwdqVBOzSsyHfIfkeIZaMuqqw7E0l8go5yTMvN9OMMONyUG2hXra6/VDeJZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=AUmGM2iG; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=3eqtIOKc; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=AUmGM2iG; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=3eqtIOKc; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="AUmGM2iG";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="3eqtIOKc";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="AUmGM2iG";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="3eqtIOKc"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 07AAE1FE8B;
	Tue, 29 Apr 2025 06:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1745908050; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3lIoiG/zUZmf47pO1+oR2n+5TkpPk63GEaSXHmTgwjs=;
	b=AUmGM2iGx9XAG941Tcsw0PMu5mCYnd/zrJIKbGYjKe0E3LuplaRy0i2QT2IvDdBOF+ERD2
	xpIOlZOWa6sjo/Fp3WPEdOULKPktlL88hgBwTopI8SgZyRLm+qA6qaWql+A6FJEazhvVJv
	faZUd/lFF2aZyuV11VTEs3/HOdRvUJE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1745908050;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3lIoiG/zUZmf47pO1+oR2n+5TkpPk63GEaSXHmTgwjs=;
	b=3eqtIOKc6l4/3gsdycDOR1zVHT4jte8WTXsNmgHkDQoCK5TD1tPtrD30ng4IKHi2AvKlFs
	eD7FiAs1llRmiRDw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1745908050; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3lIoiG/zUZmf47pO1+oR2n+5TkpPk63GEaSXHmTgwjs=;
	b=AUmGM2iGx9XAG941Tcsw0PMu5mCYnd/zrJIKbGYjKe0E3LuplaRy0i2QT2IvDdBOF+ERD2
	xpIOlZOWa6sjo/Fp3WPEdOULKPktlL88hgBwTopI8SgZyRLm+qA6qaWql+A6FJEazhvVJv
	faZUd/lFF2aZyuV11VTEs3/HOdRvUJE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1745908050;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3lIoiG/zUZmf47pO1+oR2n+5TkpPk63GEaSXHmTgwjs=;
	b=3eqtIOKc6l4/3gsdycDOR1zVHT4jte8WTXsNmgHkDQoCK5TD1tPtrD30ng4IKHi2AvKlFs
	eD7FiAs1llRmiRDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 49DD913931;
	Tue, 29 Apr 2025 06:27:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bMscEFFxEGjMXwAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 29 Apr 2025 06:27:29 +0000
Message-ID: <23ba6efd-de51-408c-bc8d-225bb265d1e2@suse.de>
Date: Tue, 29 Apr 2025 08:27:28 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/9] block: WARN if bdev inflight counter is negative
To: Yu Kuai <yukuai1@huaweicloud.com>, hch@infradead.org, axboe@kernel.dk,
 xni@redhat.com, agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
 song@kernel.org, yukuai3@huawei.com, cl@linux.com, nadav.amit@gmail.com,
 ubizjak@gmail.com, akpm@linux-foundation.org
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, yi.zhang@huawei.com,
 yangerkun@huawei.com, johnny.chenyi@huawei.com
References: <20250427082928.131295-1-yukuai1@huaweicloud.com>
 <20250427082928.131295-4-yukuai1@huaweicloud.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250427082928.131295-4-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_TO(0.00)[huaweicloud.com,infradead.org,kernel.dk,redhat.com,kernel.org,huawei.com,linux.com,gmail.com,linux-foundation.org];
	TAGGED_RCPT(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[20];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[huawei.com:email,suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -2.80
X-Spam-Flag: NO

On 4/27/25 10:29, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> Which means there is a BUG for related bio-based disk driver, or blk-mq
> for rq-based disk, it's better not to hide the BUG.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>   block/genhd.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
Please make 'BUG' lowercase.

Otherwise:

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
