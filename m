Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FD2726B946
	for <dm-devel@lists.linux.dev>; Tue, 29 Apr 2025 06:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745908267; cv=none; b=CE1fD1RBDgR8a20Idb0hUuD4MFR9Z4ZI/d/BMmHH0PoxrhHjIlIAoXeaoiiU9RcHuVJxvRnq47STcsiewny2ghR7X8gFPKfqlo61BOQMOEKcPEICMOvihD32Jl318MYZT2IGvZOJLckmYEXNZ+CMS/hdXjPza2xCV1HYbAFGIUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745908267; c=relaxed/simple;
	bh=0itftDmjkpVev479Jw2iDbbKedGJ9vLfK8+FwvVEbzM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UXO/QH6WccBqiF+O8cb+6iGUjkpI03GzuJ7pbLiiMVj1LiD57/0qGDWshmDkN8vw3C4fF5kKGJYNbo30U+sPcOoFyOwiM799wMa5OdrvitD1BD2ynzpP6InkctmOv4K8yHZDKerZCW189SIZLCGtU8NpNZkTDuLzWhTlAnhEW00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=swZftD9R; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=9PO1x5p4; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=w2vUnPr9; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=MH2PCR27; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="swZftD9R";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="9PO1x5p4";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="w2vUnPr9";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="MH2PCR27"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 850B91F8BD;
	Tue, 29 Apr 2025 06:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1745908264; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=grj4tteQ0hZ0UcL5/GdOtdzOdyrG2CBvSCbh6UsGUUo=;
	b=swZftD9RbUpjgwPfCWrDRcID2zDkMb1bEZt6PSmatAhbbKTcLCfgSCJG5XmtcXrCIEGKGl
	QWvHUVoEpd2UhKf77V1720+iwG1jMFLoNIv86mknMo55ifxgnW8hTpSZutfiwZ+8ud1Da+
	bZOEk2fEhe1rADQBXhRBFymWMyMg5bI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1745908264;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=grj4tteQ0hZ0UcL5/GdOtdzOdyrG2CBvSCbh6UsGUUo=;
	b=9PO1x5p4rYBCoXy+aJGmWWMPEPsD9wwCEeLlJajhIbcSX4f9SXwrb5q7WYYTsMEjQyn6dR
	rZDVHMK4RsfugTCQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=w2vUnPr9;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=MH2PCR27
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1745908263; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=grj4tteQ0hZ0UcL5/GdOtdzOdyrG2CBvSCbh6UsGUUo=;
	b=w2vUnPr9MwMWZRX3wLgERXjJ0xdAW3UuP0B+i5JhyT7vjv/kkAAnVBH9RCHfz/I+Dn4jG9
	eO0bjyh4YL7bcaIat9DgRY2MvwZJrjGzw8F9BWluc0F4SYwJpRRkHdFCVFI6aO1q2+DMi9
	RYYfdYC5GEgMd/2ijcOnB0jk4IuDhPc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1745908263;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=grj4tteQ0hZ0UcL5/GdOtdzOdyrG2CBvSCbh6UsGUUo=;
	b=MH2PCR27WKSyQY0izd8CkUw0jMCtxZ+PRCCe5u8GzN+3c6t5ThpBQfO9tRZKATTuuoLm7K
	HwqRxx75xmGT4iBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8DD6B13931;
	Tue, 29 Apr 2025 06:31:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id I5vJICZyEGjJYAAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 29 Apr 2025 06:31:02 +0000
Message-ID: <2f140d8b-6a2a-41af-ba73-0963713f211e@suse.de>
Date: Tue, 29 Apr 2025 08:31:02 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/9] block: cleanup blk_mq_in_flight_rw()
To: Yu Kuai <yukuai1@huaweicloud.com>, hch@infradead.org, axboe@kernel.dk,
 xni@redhat.com, agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
 song@kernel.org, yukuai3@huawei.com, cl@linux.com, nadav.amit@gmail.com,
 ubizjak@gmail.com, akpm@linux-foundation.org
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, yi.zhang@huawei.com,
 yangerkun@huawei.com, johnny.chenyi@huawei.com
References: <20250427082928.131295-1-yukuai1@huaweicloud.com>
 <20250427082928.131295-5-yukuai1@huaweicloud.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250427082928.131295-5-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 850B91F8BD
X-Spam-Score: -3.01
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	FREEMAIL_TO(0.00)[huaweicloud.com,infradead.org,kernel.dk,redhat.com,kernel.org,huawei.com,linux.com,gmail.com,linux-foundation.org];
	MIME_TRACE(0.00)[0:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,suse.de:email,huawei.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

On 4/27/25 10:29, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> Also add comment for part_inflight_show() for the difference between
> bio-based and rq-based device.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>   block/blk-mq.c | 12 ++++++------
>   block/blk-mq.h |  3 +--
>   block/genhd.c  | 43 +++++++++++++++++++++++++------------------
>   3 files changed, 32 insertions(+), 26 deletions(-)
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 301dbd3e1743..0067e8226e05 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -89,7 +89,7 @@ struct mq_inflight {
>   	unsigned int inflight[2];
>   };
>   
> -static bool blk_mq_check_inflight(struct request *rq, void *priv)
> +static bool blk_mq_check_in_driver(struct request *rq, void *priv)

Please don't rename these functions. 'in flight' always means 'in flight
in the driver', so renaming them just introduces churn with no real 
advantage.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
