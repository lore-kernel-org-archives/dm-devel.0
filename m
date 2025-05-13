Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6504935976
	for <dm-devel@lists.linux.dev>; Tue, 13 May 2025 06:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747117860; cv=none; b=gyrwy214vMx/BRPdoL8r09uhsS9itHuqpznYqFjran43PfKkvSb/+PVqU3MngOFcbLd4jH10+PQNalnUHd/XB5GPuTnIQj+rCtVGPI4e8PBTmTjO9PMtdEzEuRP28hb/UbZtdL7O1BQ8Ge1NICZ/WkitNO4FsAoxXO6uqDs43t0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747117860; c=relaxed/simple;
	bh=aZBL4GBTXVH/XcCa0nhyLI3hav2EGhWlligqqBckACI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z0kf5M6t9Gc4V1qACFEdK9i2D4t3XXCUDRXBwax7EmwCFD4dIKUKeyXholXSd6EBSYLSktHNiAnGDJw408UlVmP0AryQVfR+OfJNN4XKhkpkHVXI2d00VZoar82z2ZB18ot82JP3v9L19UikyPl/vy3LJ4C4M/DKZCtly0qgAuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=lQQxuheK; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ZC6wYFni; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=lQQxuheK; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ZC6wYFni; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="lQQxuheK";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ZC6wYFni";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="lQQxuheK";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ZC6wYFni"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 78B9D211A2;
	Tue, 13 May 2025 06:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1747117856; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j2cbLjWTSbGNj0XNwnqUpsQPLn+Rd8LAjJ9qDnJPUSs=;
	b=lQQxuheKUsh61PzojAfA/oIL3zgzDtf9NU2OKg1r+UM6VhaRNvSr3FJ6EfGwQFvIWpJ42n
	GWmQOliYUb1t92w42FHjXguq/x0NyOO82Zj/FEAdIldoR+OSxw5yZldLlO3VlaClAC3lOI
	dVfNUD5v/ue+KZqbqBZZo/ZdtTf3ico=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1747117856;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j2cbLjWTSbGNj0XNwnqUpsQPLn+Rd8LAjJ9qDnJPUSs=;
	b=ZC6wYFniyoAzOK84hHfcGLeWQai9U4b5O8PdmByr5eNNuDR2og2II1wmBzBq8MEG0bvDSk
	nv5ZtibE6C3+sFAg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=lQQxuheK;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ZC6wYFni
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1747117856; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j2cbLjWTSbGNj0XNwnqUpsQPLn+Rd8LAjJ9qDnJPUSs=;
	b=lQQxuheKUsh61PzojAfA/oIL3zgzDtf9NU2OKg1r+UM6VhaRNvSr3FJ6EfGwQFvIWpJ42n
	GWmQOliYUb1t92w42FHjXguq/x0NyOO82Zj/FEAdIldoR+OSxw5yZldLlO3VlaClAC3lOI
	dVfNUD5v/ue+KZqbqBZZo/ZdtTf3ico=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1747117856;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j2cbLjWTSbGNj0XNwnqUpsQPLn+Rd8LAjJ9qDnJPUSs=;
	b=ZC6wYFniyoAzOK84hHfcGLeWQai9U4b5O8PdmByr5eNNuDR2og2II1wmBzBq8MEG0bvDSk
	nv5ZtibE6C3+sFAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 12360137E8;
	Tue, 13 May 2025 06:30:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jpDpASDnImgSRwAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 13 May 2025 06:30:56 +0000
Message-ID: <ecff74ca-f3a5-4848-8836-54f1d7810aca@suse.de>
Date: Tue, 13 May 2025 08:30:55 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] dm mpath: Interface for explicit probing of active
 paths
To: Kevin Wolf <kwolf@redhat.com>, Martin Wilck <mwilck@suse.com>
Cc: dm-devel@lists.linux.dev, hreitz@redhat.com, mpatocka@redhat.com,
 snitzer@kernel.org, bmarzins@redhat.com, linux-kernel@vger.kernel.org
References: <20250429165018.112999-1-kwolf@redhat.com>
 <47dd225b433b0df585a25084a2e793344eeda239.camel@suse.com>
 <aCIRUwt5BueQmlMZ@redhat.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <aCIRUwt5BueQmlMZ@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 78B9D211A2
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,suse.de:mid];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action

On 5/12/25 17:18, Kevin Wolf wrote:
> Am 08.05.2025 um 15:51 hat Martin Wilck geschrieben:
>> Hello Kevin,
>>
>> [I'm sorry for the previous email. It seems that I clicked "send" in
>> the wrong window].
>>
>> On Tue, 2025-04-29 at 18:50 +0200, Kevin Wolf wrote:
>>> Multipath cannot directly provide failover for ioctls in the kernel
>>> because it doesn't know what each ioctl means and which result could
>>> indicate a path error. Userspace generally knows what the ioctl it
>>> issued means and if it might be a path error, but neither does it
>>> know
>>> which path the ioctl took nor does it necessarily have the privileges
>>> to
>>> fail a path using the control device.
>>
>> Thanks for this effort.
>>
>> I have some remarks about your approach. The most important one is that
>> the DM_MPATH_PROBE_PATHS_CMD ioctl appears to be a dangerous command.
>> It sends IO to possibly broken paths and waits for it to complete. In
>> the common error case of a device not responding, this might cause the
>> code to hang for a long time in the kernel ioctl code path, in
>> uninterruptible sleep (note that these probing commands will be queued
>> after other possibly hanging IO). In the past we have put a lot of
>> effort into other code paths in multipath-tools and elsewhere to avoid
>> this kind of hang to the extent possible. It seems to me that your set
>> re-introduces this risk.
> 
> That's a fair point. I don't expect this code to be fully final, another
> thing that isn't really optimal (as mentioned in the comment message) is
> that we're not probing paths in parallel, potentially adding up timeouts
> from multiple paths.
> 
> I don't think this is a problem of the interface, though, but we can
> improve the implementation keeping the same interface.
> 
> Maybe I'm missing something, but I think the reason why it has to be
> uninterruptible is just that submit_bio_wait() has the completion on the
> stack? So I suppose we could just kmalloc() some state, submit all the
> bios, let the completion callback free it, and then we can just stop
> waiting early (i.e. wait_for_completion_interruptible/killable) and let
> the requests complete on their own in the background.
> 
> Would this address your concerns or is there another part to it?
> 
Not really. There are two issues which ultimately made us move away
from read I/O as path checkers:

- Spurious timeouts due to blocked or congested submission
- Error handling delays and stalls

When using normal read/write functions for path checking you are
subjected to normal I/O processing rules, ie I/O is inserted
at the end of the submission queue. If the system is busy the
path checker will time out prematurely without ever having reached
the target. One could avoid that by extending the timeout, but that
would make the path checker unreliable.

But the real issue is error handling. Path checker are precisely there
to check if the path is healthy, and as such _will_ be subjected
to error handling (or might even trigger error handling itself).
The thing about error handling is that you can only return affected
commands once error handling is complete, as only then you can be
sure that no DMA is pending on the buffers and one can free/re-use
the associated pages.
On SCSI error handling can be an _extremely_ lengthy affair
(we had reports for over one hour), and the last thing you want is
to delay your path checker for that time.

(And besides, I didn't even mention the third problem with I/O-based
path checkers, namely that the check entirely the wrong thing; we
are not interested whether we can do I/O, we are interested in whether
we can send commands. In the light of eg ALUA these are two very
different things.)

>> Apart from that, minor observations are that in patch 2/2 you don't
>> check whether the map is in queueing state, and I don't quite
>> understand why you only check paths in the map's active path group
>> without attempting a PG failover in the case where all paths in the
>> current PG fail.
> 
> Ben already fixed up the missing check.
> 
> Not attempting PG failover was also his suggestion, on the basis that it
> would be additional work for no real benefit when you can only submit
> requests for the current PG anyway. If userspace retries the SG_IO, it
> will already pick a different PG, so having the kernel do the same
> doesn't really improve anything.
> 
Precisely.

I think the best way forward here is to have a 'post_ioctl' handler
(much like we have a pre_ioctl handler nowadays).
This would check the return code from the ioctl, and invalidate the
current path if there was an I/O error.
That way the user can resubmit the ioctl, until all paths are exhausted.
For that to work we need to agree on two error codes, one for
'path failed, retry' and one for 'path failed, no retry possible'.
Resetting path status will be delegated to multipathd, but then that's
its main task anyway.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
