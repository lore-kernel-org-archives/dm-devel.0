Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2143803FD
	for <dm-devel@lists.linux.dev>; Mon,  1 Jun 2026 06:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780297127; cv=none; b=XQhbg9JGBZIZ0Sx+6MSRa0W+gXqUpWl0y7Tw5/higH7Sqg/2CjWQAYXngVE4aJEqtlk9uuItGH9MudjEkIu1VwNCLvQjtVVn1QKnog9a8zh6aZRdpq+uVxaiWkPtHEnbjR0uHXzprD7Jy2D3RWz7nlSwgFfjbC5ZK/N/48EKZuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780297127; c=relaxed/simple;
	bh=MfLO14pT/R2LYR4K9rtIqKa9FLhhHOL6H9qEn06qdJI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DTIVC3HTNC3LuyOCl3fGCB0fjjQGiwlQlZAQYagJ0U9qZx/Z+QT4jd0ZoQ5y9VM2lA+QvJh7wiaIqrj+nmMZsjc663KTWMYFiwTwb19WNB5to3hTN2VbcpHrPqNhLUdaty8q8Qfwr0RhREjcYAoa9EaCGVVKFKbrWpT0rWQYD94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=XPBySl14; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=hJncENM4; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=XPBySl14; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=hJncENM4; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="XPBySl14";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="hJncENM4";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="XPBySl14";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="hJncENM4"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7CD926A9F1;
	Mon,  1 Jun 2026 06:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780297124; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lWhZD/1JEdMNcYdh18yF6rHIF+RkikiBViCDfc4s0z4=;
	b=XPBySl143kgF4c9H4RyHJjRTWSv3gMXCNqWIjyc40Vuvp++4YGItMXU4e2m7ZXLFku80x9
	yKp3Fz7qgPD3ndzYPBYvgvGekv6QbtJcD7fBdbYu2KTQbJ/o43mysMDAYJ6BKUA3lzs9Zk
	F3be+9p3rn4IfiLiAyUDoH5sFoCOWqs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780297124;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lWhZD/1JEdMNcYdh18yF6rHIF+RkikiBViCDfc4s0z4=;
	b=hJncENM4jJKWGj3P183VCGXeKULh3JHBZqwz/sq/jRVJLayLdY1M7d5Ory6ZeDrxHsUnij
	lTUydlkdgrGMKTDQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780297124; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lWhZD/1JEdMNcYdh18yF6rHIF+RkikiBViCDfc4s0z4=;
	b=XPBySl143kgF4c9H4RyHJjRTWSv3gMXCNqWIjyc40Vuvp++4YGItMXU4e2m7ZXLFku80x9
	yKp3Fz7qgPD3ndzYPBYvgvGekv6QbtJcD7fBdbYu2KTQbJ/o43mysMDAYJ6BKUA3lzs9Zk
	F3be+9p3rn4IfiLiAyUDoH5sFoCOWqs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780297124;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lWhZD/1JEdMNcYdh18yF6rHIF+RkikiBViCDfc4s0z4=;
	b=hJncENM4jJKWGj3P183VCGXeKULh3JHBZqwz/sq/jRVJLayLdY1M7d5Ory6ZeDrxHsUnij
	lTUydlkdgrGMKTDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 61D7E779A7;
	Mon,  1 Jun 2026 06:58:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /vpIFqQtHWpbNwAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 01 Jun 2026 06:58:44 +0000
Message-ID: <7e2150f2-caf9-47a5-aee9-e7f4bd7f70df@suse.de>
Date: Mon, 1 Jun 2026 08:58:43 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] dm zoned: allocate temporary superblock for tertiary
 devices
To: Dan Carpenter <error27@gmail.com>
Cc: dm-devel@lists.linux.dev
References: <ahrruAVoUpDmh6Cf@stanley.mountain>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <ahrruAVoUpDmh6Cf@stanley.mountain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.994];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWO(0.00)[2];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid]

On 5/30/26 15:52, Dan Carpenter wrote:
> Hello Hannes Reinecke,
> 
> Commit 5d2c74f3ddc0 ("dm zoned: allocate temporary superblock for
> tertiary devices") from Jun 2, 2020 (linux-next), leads to the
> following Smatch static checker warning:
> 
> 	drivers/md/dm-zoned-metadata.c:1332 dmz_load_sb()
> 	error: double free of 'sb->mblk' (line 1336)
> 
> drivers/md/dm-zoned-metadata.c
>      1310         if (zmd->sb_version > 1) {
>      1311                 int i;
>      1312                 struct dmz_sb *sb;
>      1313
>      1314                 sb = kzalloc_obj(struct dmz_sb);
>      1315                 if (!sb)
>      1316                         return -ENOMEM;
>      1317                 for (i = 1; i < zmd->nr_devs; i++) {
>      1318                         sb->block = 0;
>      1319                         sb->zone = dmz_get(zmd, zmd->dev[i].zone_offset);
>      1320                         sb->dev = &zmd->dev[i];
>      1321                         if (!dmz_is_meta(sb->zone)) {
>      1322                                 dmz_dev_err(sb->dev,
>      1323                                             "Tertiary super block zone %u not marked as metadata zone",
>      1324                                             sb->zone->id);
>      1325                                 ret = -EINVAL;
>      1326                                 goto out_kfree;
>      1327                         }
>      1328                         ret = dmz_get_sb(zmd, sb, i + 1);
> 
> This sets sb->mblk on the success path, but if the
> dmz_get_sb() allocation fails then sb->mblk is left as-is.
> 
>      1329                         if (ret) {
>      1330                                 dmz_dev_err(sb->dev,
>      1331                                             "Read tertiary super block failed");
> --> 1332                                 dmz_free_mblock(zmd, sb->mblk);
>                                                                ^^^^^^^^
> On the second iteration throug the loop then this is a double free.
> I think this dmz_free_mblock() should just be deleted.  If
> dmz_get_sb() fails then there shouldn't be anything to free
> here.
> 
Correct. Thanks for pointing this out.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
