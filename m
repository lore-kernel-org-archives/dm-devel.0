Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF3A8529D
	for <dm-devel@lists.linux.dev>; Fri, 24 May 2024 09:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716544581; cv=none; b=h5HBvhP4UOzlO7cimXyl289CkjzfGVkLqFbkAfG2VXUXNhwp/dpsDzFKZrERJqsgPtr9wHoX+TNpS9ZFKeaJA04CfRs/xXSYQwRkXjxPAH/4cd78gPw4IY8obLCIq31o95hgwINajk/8D4QzAp0QG8vtdCwpbxeRYWs1l8LnOug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716544581; c=relaxed/simple;
	bh=Wde1Vcg3DrvjjBLVaaaD4uzfsVHRnnsrBw+Psi67I5o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Eo3cn3Kj1iSF4mnT5PVpMVw2qYX4oQDS2whkJ6tbMyq6jmPmpE7xocbpI2EtopSYI3BmaBe9+hKG9M4HxBnF9okJe+AydXduM2yJOnx4d3LXp4OoFSaTFezzVzBgEDOMd8cQfjsSMpoV+lDVJrhhscMImClv2frhy0aWiy5vb6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=1Rufcvu3; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=iq8opB5g; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=1Rufcvu3; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=iq8opB5g; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="1Rufcvu3";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="iq8opB5g";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="1Rufcvu3";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="iq8opB5g"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DFE6C339F9;
	Fri, 24 May 2024 09:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1716544577; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DZFlcmINg/Isvga3KiQsLCL3UIKEfKhxP7t+c8CzVIE=;
	b=1Rufcvu3pOQcrD2Z454UhqqQPWPuyZ1W0N5oHpyjdtJjRaPTG9d3VM0XXJzQCicgjXHBf6
	mNRKidVWStBzmnJ0oJI6navEKvkZWIeQKuyT+PTnO2OsNip/Wy1Gbi6kAR9nFnNbfGSYUz
	90VvXTAdS8ovWhk3pxXTsID/48Wxuk8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1716544577;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DZFlcmINg/Isvga3KiQsLCL3UIKEfKhxP7t+c8CzVIE=;
	b=iq8opB5gZwV94rIkQ82q2Xwzbi2Fg5KEtU1FBX6CfLqYhvaaaJ3rQE2eYduxVza7yfCLQ2
	+yQmJ+lye4EM5DAw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1716544577; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DZFlcmINg/Isvga3KiQsLCL3UIKEfKhxP7t+c8CzVIE=;
	b=1Rufcvu3pOQcrD2Z454UhqqQPWPuyZ1W0N5oHpyjdtJjRaPTG9d3VM0XXJzQCicgjXHBf6
	mNRKidVWStBzmnJ0oJI6navEKvkZWIeQKuyT+PTnO2OsNip/Wy1Gbi6kAR9nFnNbfGSYUz
	90VvXTAdS8ovWhk3pxXTsID/48Wxuk8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1716544577;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DZFlcmINg/Isvga3KiQsLCL3UIKEfKhxP7t+c8CzVIE=;
	b=iq8opB5gZwV94rIkQ82q2Xwzbi2Fg5KEtU1FBX6CfLqYhvaaaJ3rQE2eYduxVza7yfCLQ2
	+yQmJ+lye4EM5DAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BE9EF13A6B;
	Fri, 24 May 2024 09:56:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SbC0LUFkUGZxTQAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 24 May 2024 09:56:17 +0000
Message-ID: <6658470a-fce2-4570-ab2d-6eb28f2fc421@suse.de>
Date: Fri, 24 May 2024 11:56:17 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] block: blk_set_stacking_limits() doesn't validate
To: Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@kernel.org>,
 linux-block@vger.kernel.org, dm-devel@lists.linux.dev
References: <20240524062119.143788-1-hare@kernel.org>
 <20240524073957.GB16336@lst.de>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240524073957.GB16336@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.28 / 50.00];
	BAYES_HAM(-2.99)[99.96%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -4.28
X-Spam-Flag: NO

On 5/24/24 09:39, Christoph Hellwig wrote:
> On Fri, May 24, 2024 at 08:21:19AM +0200, Hannes Reinecke wrote:
>> blk_validate_zoned_limits() checks whether any of the zoned limits
>> are set for non-zoned limits. As blk_set_stacking_limits() sets
>> max_zone_append_sectors() it'll fail to validate.
> 
> Except that you now broke it for zone devices.  Normally if we are
> not building a stacked zoned device there should at least be one
> underlying device that has a zero max_zone_append_limit, thus lowering
> the stacked device limit to 0.  I guess you have a scenario where that
> is not the case, so please explain it so that we can fix it.
> 
I just found it weird that a simple 'memset' for the initial device 
configuration and then calling blk_set_stacking_limits() will lead to a 
failure in blk_validate_limits() ...

But I'll relent; this had been coming up during large block testing with 
NVMe, but was only tangentially related.
So I'll retract it.

Cheers,

Hannes

