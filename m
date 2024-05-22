Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F40BC156
	for <dm-devel@lists.linux.dev>; Wed, 22 May 2024 06:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716358690; cv=none; b=RDiwTxZvvRsadfJOZKP6ByOF7RNSMf+4ooYHZ38Gyvzzr9TkM+wa9Q24SRr+koNURXoX+Ud/yJibJXG+Y+ZPiLKyISnZZo4Sq+VpDCx35b6YOj+81+trnyyGfpnB1IOcMLYBiC57032X7BcLG0Gl2txPJUxVK0LJXhwohVt0V68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716358690; c=relaxed/simple;
	bh=r0AhBuyrcaOJwXDElJ+aGb1STye2IrpKm3LzKoe3MfI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MVNg+h+/e0hnrpoSrkYsYveqrijO4ojdSZch9fQeFdZIptXl03uCrbQ59MFBLPkG7YWm4MF/ZrXzQIp0NKKUmQuU7jKE2tM+uhTdWyWyokGxO1Q9Gu8SToGSvUSTcIwaKU9pD+x+ILZJ5N6Ty4lv4M+xUiZgLBPEsWODhhX1wnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=NSMDZijr; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=oZjlVXE1; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=NSMDZijr; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=oZjlVXE1; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="NSMDZijr";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="oZjlVXE1";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="NSMDZijr";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="oZjlVXE1"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 930A95C675;
	Wed, 22 May 2024 06:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1716358686; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ef3cHcPZsaKznDM1jP5IwWFdnUEQD0LbM3ITuF7szyc=;
	b=NSMDZijrWYW6lumuR1NyoZDpWOW/ouJevi9m/Lv0vLZX1Noza9cNx+aLB75+5bDoFH/Yko
	bMorrjLlbHdqAYF3COXOpE8inyyawR4fClzSFNQsB99MuY5CxvMa1V8T8Ufk7Q3FUMePfF
	0/JoX5+2wHe8/d2UlpHK+3IgRDOLhNA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1716358686;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ef3cHcPZsaKznDM1jP5IwWFdnUEQD0LbM3ITuF7szyc=;
	b=oZjlVXE1VDqKbxOwfzyHul8diuCX/VSqMJ+wXXa3bT9nfmfeMps63JJe/EzzklY4UIaoes
	x0RU/63OZ4kKQOAA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1716358686; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ef3cHcPZsaKznDM1jP5IwWFdnUEQD0LbM3ITuF7szyc=;
	b=NSMDZijrWYW6lumuR1NyoZDpWOW/ouJevi9m/Lv0vLZX1Noza9cNx+aLB75+5bDoFH/Yko
	bMorrjLlbHdqAYF3COXOpE8inyyawR4fClzSFNQsB99MuY5CxvMa1V8T8Ufk7Q3FUMePfF
	0/JoX5+2wHe8/d2UlpHK+3IgRDOLhNA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1716358686;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ef3cHcPZsaKznDM1jP5IwWFdnUEQD0LbM3ITuF7szyc=;
	b=oZjlVXE1VDqKbxOwfzyHul8diuCX/VSqMJ+wXXa3bT9nfmfeMps63JJe/EzzklY4UIaoes
	x0RU/63OZ4kKQOAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6EF9513A1E;
	Wed, 22 May 2024 06:18:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cz/KFh6OTWZaLAAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 22 May 2024 06:18:06 +0000
Message-ID: <1b4b3f4e-c4fe-4a82-a9fc-593742e0398d@suse.de>
Date: Wed, 22 May 2024 08:18:06 +0200
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
 <5fc134e0-6f9b-4f87-8dea-ba929bf1e91d@suse.de>
 <10a92e14-70f5-e3c8-dd75-532c35d51d13@ewheeler.net>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <10a92e14-70f5-e3c8-dd75-532c35d51d13@ewheeler.net>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,imap1.dmz-prg2.suse.org:helo]

On 5/22/24 01:19, Eric Wheeler wrote:
> On Sun, 19 May 2024, Hannes Reinecke wrote:
>> On 5/18/24 00:04, Eric Wheeler wrote:
>>> On Fri, 17 May 2024, Hannes Reinecke wrote:
>>>
>>>> On 5/17/24 02:18, Eric Wheeler wrote:
>>>>> Hello everyone,
>>>>>
>>>>> Is there any work being done on namespaces for device-mapper targets, or
>>>>> for the block layer in general?
>>>>>
>>>>> For example, namespaces could make `dmsetup table` or `losetup -a` see
>>>>> only devices mapped in that name space. I found this article from to 2013,
>>>>> but it is quite old:
>>>>>    https://lwn.net/Articles/564854/
>>>>>
>>>>> If you know any more recent work on the topic that I would be interested.
>>>>> Thank you for help!
>>>>>
>>>> It is on my to-do list.
>>>> We sure should work on that one.
>>>
>>> How you envision hooking namespaces into the block layer?
>>>
>> Overall idea is to inherit devices from the original namespace.
>> - upon creation the new namespace inherits all devices from the
>>    original ns.
> 
> For namespace initialization, is there way to start with an empty
> namespace (no inherit), and only add devices the namespace that you would
> like to provide to the container? For example, you might want to provide a
> logical volume to the container and then let the container users do with
> they want in terms of creating new devices from that namespace-assigned
> "root level" device.
> 
> Somehow it needs to be safe in terms of the container users changing the
> device mapper table spec of a "root level" device using `dmsetup reload
> --table`.
> 
... except that you can't add anything as you won't have a tty, and 
hence can't start a shell. And you might not be able to call 'malloc', 
as glibc cannot call mmap() on /dev/zero.

And the plan is to be introduce namespaces for block devices, not for 
character devices, so all character devices need to show up in all
namespaces.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

