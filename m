Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72CC918638
	for <dm-devel@lists.linux.dev>; Sun, 19 May 2024 11:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716117267; cv=none; b=BLaTeZ2laB73teiALIpIr91WissxKsZGw4r6fnZ2J/fFnEXcxBsIrPOk/RRJVxqWUjKCBA1VFCT1LX/C9lffzjPweVREyAVMLW+IA5Z+aCpRQ+PcdCHCgJechhLvUDqnAJ8xigKtByV+wB00uycuPFTFY6os04F9xRImGPYKDa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716117267; c=relaxed/simple;
	bh=gWkQQv+PTBdUyXOqpGIopnE494UiTwBS+G6jGgeNoVY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q/wzhylbp11UNIjh1UEYnWPeTMX1hAqYpMQNlUUtJioySwDMcPxVtcbwgUz9UjG08PVkvsPa+gv0S2opXYL8q5L567+BRQH0tl+dBdz/+9TR8/al15bIVMA48tSgG9UnTDyAHaCFmR/PDGqpshxgSC59/PnDBNyYTHkkt/0JYFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=v41wEHJ8; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=KIQMpv0w; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=v41wEHJ8; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=KIQMpv0w; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="v41wEHJ8";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="KIQMpv0w";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="v41wEHJ8";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="KIQMpv0w"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7DF0B22CEE;
	Sun, 19 May 2024 11:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1716117257; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5Gm1u9Koqw89TuDsJwaurwObpqruOPHXXAgXl4nC0l8=;
	b=v41wEHJ8b0nE+Jj/7xLKl2ugLcOLq0aTdOsVfZnQNAeqH1AzHncvJbe8fmXUMDBtv4KoNF
	t9SUg/9PjUo0nNb04ABtHlW4++PlHdHnaTNBEV5PHtVcD6CoR5MimUgWR+lvlgtJu0uijY
	dVuJQNaMSzIVpWvyIeU3nrAFAOQGzA0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1716117257;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5Gm1u9Koqw89TuDsJwaurwObpqruOPHXXAgXl4nC0l8=;
	b=KIQMpv0wZuBIre6t2H15nu/5N4f2csg+JZ74jTN77YaRluVWbDTJYEjYGErB9TkMXZ0UIe
	SOWI1x+q84CxezAg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1716117257; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5Gm1u9Koqw89TuDsJwaurwObpqruOPHXXAgXl4nC0l8=;
	b=v41wEHJ8b0nE+Jj/7xLKl2ugLcOLq0aTdOsVfZnQNAeqH1AzHncvJbe8fmXUMDBtv4KoNF
	t9SUg/9PjUo0nNb04ABtHlW4++PlHdHnaTNBEV5PHtVcD6CoR5MimUgWR+lvlgtJu0uijY
	dVuJQNaMSzIVpWvyIeU3nrAFAOQGzA0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1716117257;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5Gm1u9Koqw89TuDsJwaurwObpqruOPHXXAgXl4nC0l8=;
	b=KIQMpv0wZuBIre6t2H15nu/5N4f2csg+JZ74jTN77YaRluVWbDTJYEjYGErB9TkMXZ0UIe
	SOWI1x+q84CxezAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4E5D6134C3;
	Sun, 19 May 2024 11:14:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 51l0EAnfSWYUBwAAD6G6ig
	(envelope-from <hare@suse.de>); Sun, 19 May 2024 11:14:17 +0000
Message-ID: <5fc134e0-6f9b-4f87-8dea-ba929bf1e91d@suse.de>
Date: Sun, 19 May 2024 13:14:15 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Kernel namespaces for device mapper targets and block devices?
Content-Language: en-US
To: Eric Wheeler <dm-devel@lists.ewheeler.net>
Cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org
References: <61c1fff7-b5ff-dfdd-62c1-506e055ae5e@ewheeler.net>
 <a3d8bab5-9293-4765-b202-d2bbecaa1f63@suse.de>
 <f55c2eb7-eb6d-3f95-b2c8-a28e9447e570@ewheeler.net>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <f55c2eb7-eb6d-3f95-b2c8-a28e9447e570@ewheeler.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -3.29
X-Spam-Level: 
X-Spamd-Result: default: False [-3.29 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	SUBJECT_ENDS_QUESTION(1.00)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email]

On 5/18/24 00:04, Eric Wheeler wrote:
> On Fri, 17 May 2024, Hannes Reinecke wrote:
> 
>> On 5/17/24 02:18, Eric Wheeler wrote:
>>> Hello everyone,
>>>
>>> Is there any work being done on namespaces for device-mapper targets, or
>>> for the block layer in general?
>>>
>>> For example, namespaces could make `dmsetup table` or `losetup -a` see
>>> only devices mapped in that name space. I found this article from to 2013,
>>> but it is quite old:
>>>   https://lwn.net/Articles/564854/
>>>
>>> If you know any more recent work on the topic that I would be interested.
>>> Thank you for help!
>>>
>> It is on my to-do list.
>> We sure should work on that one.
> 
> How you envision hooking namespaces into the block layer?
> 
Overall idea is to inherit devices from the original namespace.
- upon creation the new namespace inherits all devices from the
   original ns.
- new devices show up only in the current namespace and all
   namespaces derived from it.
- Namespace teardown should remove all devices created
   within this namespace.

I did a patchset once, based upon suggestion from Christian Brauner.
Let me dig it up.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

