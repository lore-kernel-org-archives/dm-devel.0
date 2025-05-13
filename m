Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6561EA7DF
	for <dm-devel@lists.linux.dev>; Tue, 13 May 2025 06:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747117936; cv=none; b=mgl58V+4vmqmyKZfARe2COwqvnttWpqY/9pz0PJJps2yet3fWvbtJRFnUY0JeXYJrbhFNlvq42SLTlljUEFfZyjJ2K+qHqx5vSOhnheLc5+OtwRAj3WQWNlS9YfnrMj+9IBorxYhXGJjVm6hj1fyWmI+XIzZ5lGPmzhpfxkBsgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747117936; c=relaxed/simple;
	bh=IZl1YQRTJNwVCr/kLAahPYK27pMJDP5N3BnT/1OGfmA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j4uGcM4qr0xHoQKU5L4j46KFwHSVXNrk+/vJSUvljpzF6mJR82tKIJIZVs0ZYya4a9oOCze8+0oWawVzipni2sEGfxMaEC7OWTGzjvEott3n0I/hc31DFGCokMKLgQ2w2npBbSoM5epPTsWNr7quq2L5rs5QRX9ydTwgFCHKOUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=yPv77/uJ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=vQyvztrZ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=yPv77/uJ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=vQyvztrZ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="yPv77/uJ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="vQyvztrZ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="yPv77/uJ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="vQyvztrZ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0BF602119D;
	Tue, 13 May 2025 06:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1747117933; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g6JbC6wkC/8KlkNKMqPXFLnKJmHN0ICj7kZnD9u1AoA=;
	b=yPv77/uJtYvhJ/jzS/MgPS4rSu9UtvAivTuMD44D7zxPGsp8UeOp9X57dkXDJLyTTuGG/5
	O+7RLOyaogApCs2v1ALHjLwZOg1c2d50uYztLEl0Tfhpe+ilZ/WMf0pH1LXOrQtaBvmCL0
	13w4ux7XJhLcqyYx627jzXYCqUy6rsU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1747117933;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g6JbC6wkC/8KlkNKMqPXFLnKJmHN0ICj7kZnD9u1AoA=;
	b=vQyvztrZbOvBEpC7YZM2oYGm7Ue8QdYVKsgdKpr6MUG66dU7ZqJdMzcqR1IloKfvLJHJne
	D4OuSfd51TXuiQCw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1747117933; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g6JbC6wkC/8KlkNKMqPXFLnKJmHN0ICj7kZnD9u1AoA=;
	b=yPv77/uJtYvhJ/jzS/MgPS4rSu9UtvAivTuMD44D7zxPGsp8UeOp9X57dkXDJLyTTuGG/5
	O+7RLOyaogApCs2v1ALHjLwZOg1c2d50uYztLEl0Tfhpe+ilZ/WMf0pH1LXOrQtaBvmCL0
	13w4ux7XJhLcqyYx627jzXYCqUy6rsU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1747117933;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g6JbC6wkC/8KlkNKMqPXFLnKJmHN0ICj7kZnD9u1AoA=;
	b=vQyvztrZbOvBEpC7YZM2oYGm7Ue8QdYVKsgdKpr6MUG66dU7ZqJdMzcqR1IloKfvLJHJne
	D4OuSfd51TXuiQCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B5626137E8;
	Tue, 13 May 2025 06:32:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iz6xKmznImh2RwAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 13 May 2025 06:32:12 +0000
Message-ID: <d2a7fa68-1890-4367-a2ac-59ec220779bd@suse.de>
Date: Tue, 13 May 2025 08:32:12 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] dm mpath: Interface for explicit probing of active
 paths
To: Christoph Hellwig <hch@infradead.org>
Cc: Kevin Wolf <kwolf@redhat.com>, Martin Wilck <mwilck@suse.com>,
 dm-devel@lists.linux.dev, hreitz@redhat.com, mpatocka@redhat.com,
 snitzer@kernel.org, bmarzins@redhat.com, linux-kernel@vger.kernel.org
References: <20250429165018.112999-1-kwolf@redhat.com>
 <47dd225b433b0df585a25084a2e793344eeda239.camel@suse.com>
 <aCIRUwt5BueQmlMZ@redhat.com> <aCLe5UT2kfzI96TQ@infradead.org>
 <0340c51e-6f89-4799-b2f1-19c785a19ff2@suse.de>
 <aCLjPLCztuXhgpnA@infradead.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <aCLjPLCztuXhgpnA@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email]
X-Spam-Score: -4.30

On 5/13/25 08:14, Christoph Hellwig wrote:
> On Tue, May 13, 2025 at 08:09:45AM +0200, Hannes Reinecke wrote:
>> On 5/13/25 07:55, Christoph Hellwig wrote:
>>> On Mon, May 12, 2025 at 05:18:43PM +0200, Kevin Wolf wrote:
>>>> Yes, it's a bit unfortunate, but we have to work with what we have. QEMU
>>>> doesn't even necessarily know that it's dealing with a multipath device,
>>>> so it just has to blindly try the ioctl and see if it works.
>>>
>>> Why is qemu even using SG_IO to start with?
>>>
>> To be able to forward SCSI commands.
> 
> Why?
> 
Reservations and stuff.
There are customer who use GPFS ...

But yes, I know. We are working on it; it should be possible to hook in
the generic block reservation code here.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
