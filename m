Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92CC270ED5
	for <dm-devel@lists.linux.dev>; Tue, 29 Apr 2025 06:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745908328; cv=none; b=Kch2YSAuTM2ggczgQx5yOPyiwoXpLVY9HhXAiuE1KD2vBvdEhX8Qjtl5KGk/5Qq2z5yldmZ14UC9q2K348bWB+wDAFu/x0sarN/0kCP/bMjdQ7qAklbc3O1BADG+IG483RPTlKZGE4ydTcCGtCh4GveLBbIJF6kgkgU+J7firZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745908328; c=relaxed/simple;
	bh=0Ql/rIHLDhsZjUrJ0yvcDPUdLxdsSEIMZKWMY5g6t0E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lbhBZuBzNnQ8+wfT2XIqz9sMupSv0NsRYqhMVzSpTevw3cn+GrZXqhjrEj/QobvYIjv2W695yIUNEX46XVduEfcSOPzlXuecYRrqMUnVU/UYKOxputWljLNHo1wMie+Vz5GuosQjYPWAGAKYsTrzdUwKzxqMcyUBktmVO5c+JmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=SiLHboWZ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=VZ1sPI4w; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ZfKeIexI; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=qy6dfZlh; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="SiLHboWZ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="VZ1sPI4w";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ZfKeIexI";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="qy6dfZlh"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DBD9C21E53;
	Tue, 29 Apr 2025 06:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1745908325; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RTUWv/IVqikGan6M7itnAnbNVw5XF2cNlFeNXMKPDMU=;
	b=SiLHboWZKb1pxwrYjFzbp3D3DcdIOX5iwQ8IqtmLgvyFPEuH7HRPl7PRhDiJmmDv+pPkv0
	ZqSmO1o+EFqjUQl3VAs3NKWtJFV6QYFqAv3byECb+Dr586tXT9tqjAQ4WwWln4r119nu/6
	vBekdjryOuzNhTm/vKR8UcJvMwNuU/s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1745908325;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RTUWv/IVqikGan6M7itnAnbNVw5XF2cNlFeNXMKPDMU=;
	b=VZ1sPI4wi5SD/cOXHnRgmU/D68aCSQ92ywnr10c42SGpAUORl5JSNjlFdOhmV4ABAfNulT
	gIfR/4QywC6CbkCQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZfKeIexI;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qy6dfZlh
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1745908324; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RTUWv/IVqikGan6M7itnAnbNVw5XF2cNlFeNXMKPDMU=;
	b=ZfKeIexIZ2nxVE7BNz6cZGVWttmr9mdzzibPGaurA9dcvcI74aMYSx/2o+9K/1oT+fc7g7
	djnVlC/fpqDydQnepFdvczhrhp6mCyE65xLPk8Lo88dZzngO+Xv1DrfZkx8+Dz/kNYxqkJ
	Jls6biyVAVP+C//vrgAtrgINv1W2WIQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1745908324;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RTUWv/IVqikGan6M7itnAnbNVw5XF2cNlFeNXMKPDMU=;
	b=qy6dfZlhoWcDPo0LUgRUGYTu8oflHarmH8C14paw1qp/H1e8+XyaUx/DAmj5wgobmETswg
	C2EhuyIuFhnBk0Bg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C279E13931;
	Tue, 29 Apr 2025 06:32:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id VgjxLWNyEGgBYQAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 29 Apr 2025 06:32:03 +0000
Message-ID: <9b869482-f8a6-456e-a4c0-0e83020296c5@suse.de>
Date: Tue, 29 Apr 2025 08:32:03 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/9] block: export API to get the number of bdev
 inflight IO
To: Yu Kuai <yukuai1@huaweicloud.com>, hch@infradead.org, axboe@kernel.dk,
 xni@redhat.com, agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
 song@kernel.org, yukuai3@huawei.com, cl@linux.com, nadav.amit@gmail.com,
 ubizjak@gmail.com, akpm@linux-foundation.org
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, yi.zhang@huawei.com,
 yangerkun@huawei.com, johnny.chenyi@huawei.com
References: <20250427082928.131295-1-yukuai1@huaweicloud.com>
 <20250427082928.131295-6-yukuai1@huaweicloud.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250427082928.131295-6-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DBD9C21E53
X-Spam-Score: -3.01
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
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
> - rename part_in_{flight, flight_rw} to bdev_count_{inflight, inflight_rw}
> - export bdev_count_inflight, to fix a problem in mdraid that foreground
>    IO can be starved by background sync IO in later patches
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>   block/blk-core.c          |  2 +-
>   block/blk.h               |  1 -
>   block/genhd.c             | 22 ++++++++++++++++------
>   include/linux/part_stat.h |  2 ++
>   4 files changed, 19 insertions(+), 8 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
