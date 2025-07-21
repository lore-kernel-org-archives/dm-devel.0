Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B246F213E6D
	for <dm-devel@lists.linux.dev>; Mon, 21 Jul 2025 07:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753082440; cv=none; b=HYjZ8E6Mn4X3qLJG7BT3VH8tw5QjD7mkZuNNYYCaTMjxEre5tIkZxouj3V9o7/iuJrZdOEoe31ivG/b42bhrBpe+AmScvJddZ0NykyBlCk0JvMSSuoT1khfZ0ZYpMev2BazQuHP2BAG1HCa++1FxkuE9uEWjkuYib1u6yJZjyOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753082440; c=relaxed/simple;
	bh=vhyVaF+VwSE5Nv0XurRTY1XyiQX0w0q56TQFEO1m5HY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Dmu41y4iGefiA+8ILv5cYB/mQWRbmonuLlt3lRz+9d/diDMN4utnvECmokEs6o88cG24h24/u5OMETLZz8JhZiJ9JaAD0HHDum1WFAh9pDo2QPqbGIhTNutWYxoCvPusVWSymuSkjDNOj/WVOjFHnkt162xPEAO9YPG+31oau9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=jZ3HBTX0; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=d2wkt+pw; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Mu+Urtox; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=buNlm4c1; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="jZ3HBTX0";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="d2wkt+pw";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Mu+Urtox";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="buNlm4c1"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CC2B8219A0;
	Mon, 21 Jul 2025 07:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1753082437; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=atEYXapJNnnWn8WFmFtauKP7GSe+7FXB/M3FFuUsqa4=;
	b=jZ3HBTX0CQ7c/Ptl9GfsB1uL2ExxFxKAzgBtWDbRlE6TbYU82Ro1wt+ycMdCJST3OtHAlU
	VX5RcSfMRwWMTfUlcQjWoujCAER+BQjZxs1lcpvdHXkJs342qJubD0MGIlDUK25t5vFj1L
	m5KeAwuKWmekKeZUt30hZ1cC6auIwyo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1753082437;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=atEYXapJNnnWn8WFmFtauKP7GSe+7FXB/M3FFuUsqa4=;
	b=d2wkt+pwCPZ1vaaQec6JULv21XTfvKFIVhDzgLz4yPwNiGdY3aiv+qFbU4g+SzbjrQcnFK
	2+nm0joAnjh1ZnCw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Mu+Urtox;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=buNlm4c1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1753082436; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=atEYXapJNnnWn8WFmFtauKP7GSe+7FXB/M3FFuUsqa4=;
	b=Mu+UrtoxzK+ewffTpYQLB4IBi3g0ZV7SHg7W0Faio/DK3vr7WfgO7cJ6xs3qOiMcQ9NHP1
	oInBngiTWi+Aq/qXXdb1Rh5Jc/jOg/FXGH3JZ6O0Y6arYZJJqzH/KhAuAInouYrxYOAER2
	65bGKJI05IqQCBRrNfEhGL90YNpcspI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1753082436;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=atEYXapJNnnWn8WFmFtauKP7GSe+7FXB/M3FFuUsqa4=;
	b=buNlm4c1erxrBD/sojvPYEK1IC6uwqKYy4SwP3GHMz9tN1QhhB2iyorSCdFRhrdtRUuwNA
	KJabPUZErTuu6pDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3EA23136A8;
	Mon, 21 Jul 2025 07:20:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +TmsDUTqfWhcXAAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 21 Jul 2025 07:20:36 +0000
Message-ID: <ef2bd059-e32d-41a2-bb33-da0621d7ff02@suse.de>
Date: Mon, 21 Jul 2025 09:20:35 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 11/11] md/md-llbitmap: introduce new lockless bitmap
To: Yu Kuai <yukuai1@huaweicloud.com>, corbet@lwn.net, agk@redhat.com,
 snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, yi.zhang@huawei.com,
 yangerkun@huawei.com, johnny.chenyi@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250718092336.3346644-1-yukuai1@huaweicloud.com>
 <20250718092336.3346644-12-yukuai1@huaweicloud.com>
 <04ba77bb-464d-4b98-91e6-4225204ae679@suse.de>
 <bc215f88-a652-090f-ae99-8aaba6c591c4@huaweicloud.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <bc215f88-a652-090f-ae99-8aaba6c591c4@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: CC2B8219A0
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_TWELVE(0.00)[14];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:mid,suse.de:email];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -4.51

On 7/21/25 09:12, Yu Kuai wrote:
> Hi,
> 
> 在 2025/07/21 14:20, Hannes Reinecke 写道:
>> On 7/18/25 11:23, Yu Kuai wrote:
>>> From: Yu Kuai <yukuai3@huawei.com>
>>>
> 
>>> +
>>> +#define BITMAP_DATA_OFFSET 1024
>>> +
>>> +/* 64k is the max IO size of sync IO for raid1/raid10 */
>>> +#define MIN_CHUNK_SIZE (64 * 2)
>>> +
>>
>> Hmm? Which one is it?
>> Comment says 'max IO size', but it's called 'MIN_CHUNK_SIZE'...
> 
> max IO size here means the internal recovery IO size for raid1/10,
> and we're handling at most one llbimtap bit(chunksie) at a time, so
> chunksize should be at least 64k, otherwise recovery IO size will be
> less.
> 
Okay.

>>> +/*
>>> + * Dirtied bits that have not been accessed for more than 5s will be 
>>> cleared
>>> + * by daemon.
>>> + */
>>> +#define BARRIER_IDLE 5
>>> +
>>
>> Should this be changeable, too?
> 
> Yes, idealy this should. Perhaps a new sysfs api?
> 
Yes, similarly to the daemon_delay one.

>>
> 
>>> +    if (!test_bit(LLPageDirty, &pctl->flags))
>>> +        set_bit(LLPageDirty, &pctl->flags);
>>> +
>>> +    /*
>>> +     * The subpage usually contains a total of 512 bits. If any 
>>> single bit
>>> +     * within the subpage is marked as dirty, the entire sector will be
>>> +     * written. To avoid impacting write performance, when multiple 
>>> bits
>>> +     * within the same sector are modified within a short time 
>>> frame, all
>>> +     * bits in the sector will be collectively marked as dirty at once.
>>> +     */
>>
>> How short is the 'short timeframe'?
>> Is this the BARRIER_IDLE setting?
>> Please clarify.
> 
> Yes, if the page is not accessed for BARRIER_IDLE seconds.
> 
Please update the comment to refer to that.

>>> +static struct page *llbitmap_read_page(struct llbitmap *llbitmap, 
>>> int idx)
>>> +{
>>> +    struct mddev *mddev = llbitmap->mddev;
>>> +    struct page *page = NULL;
>>> +    struct md_rdev *rdev;
>>> +
>>> +    if (llbitmap->pctl && llbitmap->pctl[idx])
>>> +        page = llbitmap->pctl[idx]->page;
>>> +    if (page)
>>> +        return page;
>>> +
>>> +    page = alloc_page(GFP_KERNEL | __GFP_ZERO);
>>> +    if (!page)
>>> +        return ERR_PTR(-ENOMEM);
>>> +
>>> +    rdev_for_each(rdev, mddev) {
>>> +        sector_t sector;
>>> +
>>> +        if (rdev->raid_disk < 0 || test_bit(Faulty, &rdev->flags))
>>> +            continue;
>>> +
>>> +        sector = mddev->bitmap_info.offset +
>>> +             (idx << PAGE_SECTORS_SHIFT);
>>> +
>>> +        if (sync_page_io(rdev, sector, PAGE_SIZE, page, REQ_OP_READ,
>>> +                 true))
>>> +            return page;
>>> +
>>> +        md_error(mddev, rdev);
>>> +    }
>>> +
>>> +    __free_page(page);
>>> +    return ERR_PTR(-EIO);
>>> +}
>>> +
>>
>> Have you considered moving to folios here?
>>
> 
> Of course, however, because the md high level helpers is still using
> page, I'm thinking about using page for now, which is simpler, and
> moving to folios for all md code later.
> 
> 
Fair enough.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
