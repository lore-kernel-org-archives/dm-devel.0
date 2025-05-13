Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE521E991A
	for <dm-devel@lists.linux.dev>; Tue, 13 May 2025 06:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747116589; cv=none; b=L1G6qeLK+T3DPtAzogZOlKKEFN2JQyUFlegSpXOGIqfUoUzL8ScCiU7MxZlUFqLKQKAgBoBOIiVxk6Cu6b7jWzVj0yMTkc+1vFCebTufufUEJi9NVBDjeT3Vx5c18kwPrD5ytWpmVMHaQmTXewRPBtHUnadNKWg/+HrjV8maEcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747116589; c=relaxed/simple;
	bh=SiAJOcPhF5ZcvLR80Kj3eWSNASMiANtxhQCs1FVKI/k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EDkRFqVKW22A8sPTLQwD+oShjJSDUPAn5430r0aASbJKd0z7cd1Xf/EUpCr0rqw1yhAQz9q0ZX6mIdNgKew7scJidB7IDL7hdojXIIBoi7eL0cgba4JHKwC9os7+DaILg9gT07X+BgqLVC3VSgtH8RCRMBgtIweGrzdskJCRKDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=MMRN3fHd; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=1qd3F3bG; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=MMRN3fHd; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=1qd3F3bG; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="MMRN3fHd";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="1qd3F3bG";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="MMRN3fHd";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="1qd3F3bG"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6F85E1F387;
	Tue, 13 May 2025 06:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1747116586; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iQl2xd5pYmgmS7e1vmtjBQXxxTTpVuRRCi7wCMozpqY=;
	b=MMRN3fHdGN6GkBgaqdXY5CLZnCLKqj/DKdkxhCdGJ5tqPAOInfkneSyFHA2+GXngIk5S+X
	MaN/VSdUbHrvBXFGB4bfEQ4jyK0aPalIGkQcvKu8GqXrTnRdA8/9cVkRKyVRmLD6gWggKS
	L3KMsMQ2ArA8NScaKMnYP0UslKKDg+M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1747116586;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iQl2xd5pYmgmS7e1vmtjBQXxxTTpVuRRCi7wCMozpqY=;
	b=1qd3F3bGOSSQKJZivplnLnZH2NcorMMH268x/J6hf/6J+PkHzFu5EzUWH0V06kf5sV+tsD
	kgDx5rsb2jE0LnCA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1747116586; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iQl2xd5pYmgmS7e1vmtjBQXxxTTpVuRRCi7wCMozpqY=;
	b=MMRN3fHdGN6GkBgaqdXY5CLZnCLKqj/DKdkxhCdGJ5tqPAOInfkneSyFHA2+GXngIk5S+X
	MaN/VSdUbHrvBXFGB4bfEQ4jyK0aPalIGkQcvKu8GqXrTnRdA8/9cVkRKyVRmLD6gWggKS
	L3KMsMQ2ArA8NScaKMnYP0UslKKDg+M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1747116586;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iQl2xd5pYmgmS7e1vmtjBQXxxTTpVuRRCi7wCMozpqY=;
	b=1qd3F3bGOSSQKJZivplnLnZH2NcorMMH268x/J6hf/6J+PkHzFu5EzUWH0V06kf5sV+tsD
	kgDx5rsb2jE0LnCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 19822137E8;
	Tue, 13 May 2025 06:09:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jYShBCriImiJQAAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 13 May 2025 06:09:46 +0000
Message-ID: <0340c51e-6f89-4799-b2f1-19c785a19ff2@suse.de>
Date: Tue, 13 May 2025 08:09:45 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] dm mpath: Interface for explicit probing of active
 paths
To: Christoph Hellwig <hch@infradead.org>, Kevin Wolf <kwolf@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>, dm-devel@lists.linux.dev,
 hreitz@redhat.com, mpatocka@redhat.com, snitzer@kernel.org,
 bmarzins@redhat.com, linux-kernel@vger.kernel.org
References: <20250429165018.112999-1-kwolf@redhat.com>
 <47dd225b433b0df585a25084a2e793344eeda239.camel@suse.com>
 <aCIRUwt5BueQmlMZ@redhat.com> <aCLe5UT2kfzI96TQ@infradead.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <aCLe5UT2kfzI96TQ@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email]
X-Spam-Score: -4.30

On 5/13/25 07:55, Christoph Hellwig wrote:
> On Mon, May 12, 2025 at 05:18:43PM +0200, Kevin Wolf wrote:
>> Yes, it's a bit unfortunate, but we have to work with what we have. QEMU
>> doesn't even necessarily know that it's dealing with a multipath device,
>> so it just has to blindly try the ioctl and see if it works.
> 
> Why is qemu even using SG_IO to start with?
> 
To be able to forward SCSI commands.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
