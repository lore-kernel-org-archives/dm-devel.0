Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE7F1FECA9
	for <dm-devel@lists.linux.dev>; Wed, 19 Feb 2025 16:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739983050; cv=none; b=W/5V7UOH9lA+nS3X9sBdSmN2IQZSISNNvIS4925jntM8gWkanuw2hP6i2h2ahiZAfzSMX+Q1HB3M3L04pffHCKPqat8C2SrapuIdv9/T6rsS5mAiO4x5tiR5aUAfgxytNHGKllEpvCWiGs7V8x6qO2nff3+9+DN9lc/YPEVvecg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739983050; c=relaxed/simple;
	bh=tNY6dkh1yEsy6Fl/YmMYelEun06AD50SlJe77dbwVpg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HyNxarUm0+7b3LF6HPrD00fbzEkvhohIONw41aLHT/EwhL5kJOTRduene3x+c8gQSQoXdqNQM1kWoc4SpWwv6zcPxpBTSQVxfgBSdaUL5f0wJcrfX7+YssW645O6GwLlh9iGUgCPiQLm+BpJrx7MbFQhid3Nk8Ho6vYGFDCXQGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=KqLhBp+w; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=/5bP/JhE; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=KqLhBp+w; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=/5bP/JhE; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="KqLhBp+w";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="/5bP/JhE";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="KqLhBp+w";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="/5bP/JhE"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A95F0219CE;
	Wed, 19 Feb 2025 16:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1739983046; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T2jyHn7yTMMH8O/+ItUH0fidGGGeUj4EmKCE7n+50rk=;
	b=KqLhBp+wAkV6VDPh8CkR+tvxiqRgp6NzzeC2n4OYtJFviJ6La1IfO6bm+miHL3F0TVJocO
	MD/8aeQiGG52mGMC+lFr6IwNqzQlh5MtlkxTVW4y/rFblWE9IpSwpWWmT+n0uqKJAyORje
	wstyum5wza7mDuiXuwlCY9h/gphaG3A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1739983046;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T2jyHn7yTMMH8O/+ItUH0fidGGGeUj4EmKCE7n+50rk=;
	b=/5bP/JhEYNLYhw9t9AXp3zq+Rq/t+rr8wwCrM70XZgP/KkZNHPVgzf30hbVGJefNebWZEx
	AL6NFq8g5bl481BQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1739983046; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T2jyHn7yTMMH8O/+ItUH0fidGGGeUj4EmKCE7n+50rk=;
	b=KqLhBp+wAkV6VDPh8CkR+tvxiqRgp6NzzeC2n4OYtJFviJ6La1IfO6bm+miHL3F0TVJocO
	MD/8aeQiGG52mGMC+lFr6IwNqzQlh5MtlkxTVW4y/rFblWE9IpSwpWWmT+n0uqKJAyORje
	wstyum5wza7mDuiXuwlCY9h/gphaG3A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1739983046;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T2jyHn7yTMMH8O/+ItUH0fidGGGeUj4EmKCE7n+50rk=;
	b=/5bP/JhEYNLYhw9t9AXp3zq+Rq/t+rr8wwCrM70XZgP/KkZNHPVgzf30hbVGJefNebWZEx
	AL6NFq8g5bl481BQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 302DF137DB;
	Wed, 19 Feb 2025 16:37:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 21LjCcYItmcLSwAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 19 Feb 2025 16:37:26 +0000
Message-ID: <1858bc0a-465b-4cf3-a95c-dbe05740adff@suse.de>
Date: Wed, 19 Feb 2025 17:37:25 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] block: move the block layer auto-integrity code into
 a new file
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org,
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
 target-devel@vger.kernel.org
References: <20250218182207.3982214-1-hch@lst.de>
 <20250218182207.3982214-3-hch@lst.de>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250218182207.3982214-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email]
X-Spam-Flag: NO
X-Spam-Level: 

On 2/18/25 19:21, Christoph Hellwig wrote:
> The code that automatically creates a integrity payload and generates /
> verifies the checksums for bios that don't have submitter-provided
> integrity payload currently sits right in the middle of the block
> integrity metadata infrastruture.  Split it into a separate file to
> make the different layers clear.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   block/Makefile             |   3 +-
>   block/bio-integrity-auto.c | 162 +++++++++++++++++++++++++++++++++++++
>   block/bio-integrity.c      | 159 ------------------------------------
>   3 files changed, 164 insertions(+), 160 deletions(-)
>   create mode 100644 block/bio-integrity-auto.c
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
