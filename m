Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 426DC318EF0
	for <dm-devel@lists.linux.dev>; Wed, 27 May 2026 17:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779903017; cv=none; b=qhEd2Az0Qbw2FI2+Rt7AW8MNf8Y3AF2xvytmqLNvO5Gw4LIRc6UxW3yNey+6MK2hEQlwVN/BCnQXLaCd+sUqJ7qntvHKiOUuCUdXgQVX0TFdotQsNgv4vGId1sEWdB7p/0XnQ/T6jPrUFbhGhZY9xXUFrE4QEBEgeRn1fXno/TU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779903017; c=relaxed/simple;
	bh=6PdudYBTpOsANXowEIM5FmRNH8UuLAhPK/VYXDu5y2U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mOia534NDHZLK/MkS5ia6i8URYp8QJETIVd/Rd7RedC6xPil/7MbRi4kh0HSasbuQQuKzhk4GUGOLjCs5JA27kQbGnShk5diuUhQrdSZjoONSebR7Vk3jhPJlOn9//CCAYoddCdWPlUJKM0IO/ZglpELd0A2YqwzbTrhhXl9ZI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7E49D6ACE5;
	Wed, 27 May 2026 17:30:13 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4422E5A938;
	Wed, 27 May 2026 17:30:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yNuPDiUqF2q0HAAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 27 May 2026 17:30:13 +0000
Message-ID: <a4e1860b-f118-4eab-8c43-9c25dd5fbbd4@suse.de>
Date: Wed, 27 May 2026 19:30:12 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/19] libmpathutil: runner: use shared_ptr
To: Martin Wilck <mwilck@suse.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 Brian Bunker <brian@purestorage.com>, dm-devel@lists.linux.dev
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>
References: <20260522164415.846589-1-mwilck@suse.com>
 <20260522164415.846589-10-mwilck@suse.com>
 <5cb00fa3-159b-4463-9599-55c7f8ba702f@suse.de>
 <f4188f6ac60be14ca4ee325f776a89184e7ef01a.camel@suse.com>
 <c03305cd-5408-4b28-bcab-a43a566ce6ef@suse.de>
 <f8ea80b80cb3e26b42e6d4dc1ec3cfedca2eb2fc.camel@suse.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <f8ea80b80cb3e26b42e6d4dc1ec3cfedca2eb2fc.camel@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Queue-Id: 7E49D6ACE5
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Flag: NO
X-Rspamd-Action: no action
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Score: -4.00
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[];
	TAGGED_RCPT(0.00)[]

On 5/27/26 16:11, Martin Wilck wrote:
> On Wed, 2026-05-27 at 15:13 +0200, Hannes Reinecke wrote:
>> On 5/27/26 12:11, Martin Wilck wrote:
>>> On Wed, 2026-05-27 at 11:40 +0200, Hannes Reinecke wrote:
>>>
>>>
>>>> But if the path comes back we need to reinstate the checker,
>>>> which
>>>> not
>>>> only requires additional memory (which might need a recursion
>>>> into
>>>> the
>>>> filesystem to get free pages) but we also might need to read the
>>>> checker
>>>> module from disk (again). So plenty of opportunity to deaslock
>>>> waithing
>>>> for the disk be become readable.
>>>
>>> In checker_get(), we call add_checker_class() if the class is not
>>> yet
>>> loaded, which will take one ref on the class, and then
>>> get_shared_ptr()
>>> for every path (including the one for which add_checker_class() had
>>> been called), which means we have (number of paths + 1) references
>>> on
>>> the class, and will only drop the last ref when multipathd calls
>>> cleanup_checkers() during exit.
>>>
>>> Therefore I don't think it's possible that we unload the shared
>>> library
>>> prematurely, and have to reload it later.
>>>
>> Hmm.
>>
>> Really hmmmmm.
>>
>> If the checkers are loaded during startup, and unloaded on shutdown,
>> there really is no point in refcounting them, is there?
>> Wouldn't global pointers to each check sufficient here, avoiding
>> the need for refcounting altogether?
> 
> Currently checker and prioritizer DSOs aren't loaded during startup.
> They are loaded when the first path that uses the given checker is
> initialized.
> 
> I agree that it would be possible to simplify the code by just loading
> all checkers and prioritizers in advance, in which case we wouldn't
> need refcounting, like you wrote. Actually, we don't need to use shared
> objects in the first place; we could simply include all the checker and
> prioritizer code in libmultipath itself.
> 
> The shared object architecture dates back to multipath-tools 0.4.9
> (2008). We (actually, you ;-) ) added refcounting to fix races in
> 323090f ("Use refcounting for checkers"). So far it hasn't occured to
> me to change this architecture, which has been working well for over a
> decade.
> 
> Anyway, this discussion is orthogonal to my current patch set.
> 
That is true.

So maybe for a later cleanup.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
