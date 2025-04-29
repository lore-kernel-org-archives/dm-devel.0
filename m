Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9473B270ED5
	for <dm-devel@lists.linux.dev>; Tue, 29 Apr 2025 06:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745907925; cv=none; b=KIP8UOPAUvGyWXmQLtoL4WkLPKUgULH1xMpRSLpqGYAE3KBubgUtxIYaozflXBz8cctb7bRxVoOfQp/fjeV1UT0o+2j9cZrBWtutrAT2R2GIiW2VCcLh1sGCr+0TULoFY2NTNVodkM5iL+xX0MMYMKmnqYD658COktf2P3aOLmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745907925; c=relaxed/simple;
	bh=778Tsk9V5RLv7u5+J8mGWYXvwJlfwQGKJpCCruIQUNE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ObrBCZGfhB5PqvZT31nDTQStXdwH0+wqahQ7TL6hxNHE45c3crnKHK8BTvZoZfLQVt/jnYnFiC1tBuHDXSfgF23AqTwrBQlUSwGLDhFiPjZRbOzxW4yyUSCCQta0LFpt3DpHh3OluLQG1yrUbqPBI2GTffsqPNleCwrC0CFv50I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=v774V8tB; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=yspDwa/p; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=GIrBtqGC; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=61sHmbae; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="v774V8tB";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="yspDwa/p";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="GIrBtqGC";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="61sHmbae"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9743C1FE70;
	Tue, 29 Apr 2025 06:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1745907921; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6S9stFslWf1BocyHPdJ7xpeGvTQZK2+LLCON0hSowMM=;
	b=v774V8tBsZIa3heGVk7dMz7I2YGN8Q4XYJ2H0hD+yh2Cq8e8Z9kynUoPJBq3X7bx6vjs+X
	8V/n97lgllXwZ4gWqf2lRCGBUyNhdwPv4HPoGzeyDlrQ9ZYIvD4KUIzGUO9CgLVZ9w4niQ
	+gyEq8F1/Ue72ydTTvgyOVO1RHajdFs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1745907921;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6S9stFslWf1BocyHPdJ7xpeGvTQZK2+LLCON0hSowMM=;
	b=yspDwa/phnJy9/hXeqiKf5K0DX2VJ6AE+cWx/PasYEvrPVWASypiGtqUwsXeQoEBJf0PK2
	ER5DiNBXdIW6XpAg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1745907920; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6S9stFslWf1BocyHPdJ7xpeGvTQZK2+LLCON0hSowMM=;
	b=GIrBtqGCIJt5d0JgegSc5q88NNUI/zJwxb40x6wGkaAV+TEhTpT3Y7yg1bqcGfoh9mcJRo
	La1M52RUxo/44edFm73UjY/LNq8HwujLI8vKSsPX2qu4FjXn8Hfz4ma3HVz9Occbz+RhKQ
	57UG2psavtfWR9gbb8DFq8s2V9o5/LQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1745907920;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6S9stFslWf1BocyHPdJ7xpeGvTQZK2+LLCON0hSowMM=;
	b=61sHmbael7fiLlZyEIhtBVRhd3J90RgppOy+KlEaO5WE/xOfuOnM3DD744y26buVoZIG/q
	mj8WS6gL10HSIQDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D57A413931;
	Tue, 29 Apr 2025 06:25:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id O75WMc9wEGg8XwAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 29 Apr 2025 06:25:19 +0000
Message-ID: <bbac5c03-270b-4686-82e2-638aef59323d@suse.de>
Date: Tue, 29 Apr 2025 08:25:19 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/9] blk-mq: remove blk_mq_in_flight()
To: Yu Kuai <yukuai1@huaweicloud.com>, hch@infradead.org, axboe@kernel.dk,
 xni@redhat.com, agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
 song@kernel.org, yukuai3@huawei.com, cl@linux.com, nadav.amit@gmail.com,
 ubizjak@gmail.com, akpm@linux-foundation.org
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, yi.zhang@huawei.com,
 yangerkun@huawei.com, johnny.chenyi@huawei.com
References: <20250427082928.131295-1-yukuai1@huaweicloud.com>
 <20250427082928.131295-2-yukuai1@huaweicloud.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250427082928.131295-2-yukuai1@huaweicloud.com>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,huawei.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -2.80
X-Spam-Flag: NO

On 4/27/25 10:29, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> It's not used and can be removed.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>   block/blk-mq.c | 10 ----------
>   block/blk-mq.h |  2 --
>   2 files changed, 12 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
