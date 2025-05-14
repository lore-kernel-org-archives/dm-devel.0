Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A22F11C860E
	for <dm-devel@lists.linux.dev>; Wed, 14 May 2025 06:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747204776; cv=none; b=V0UW32WMAqpf0451EhrWaMig1T6ZA6Z3ePmmeTv5FV9Kq4TumuhnMv2msILsJoU5ru9wTt6u7CLK1Jqzn5h4OEJiCi2Pg+TemigOlxzio9ij4ijt0zqouT5hG4UDAOUtI9/XHPPuXlMv9NpuReMQ+wSbWMrymt9HBPh+ruEtjYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747204776; c=relaxed/simple;
	bh=t+I9jepCTpJL8tyV3dOboQAZCLRWhrYhIPZr5m8t808=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OvqoJxgdY/z7SNHtp0cXqfsZvDfyJcNPwBb/yHs0+D9Tyscbga3TMLvw1mrsPvSblFS5gekNj6fpch8I4Cj3jie/MSwvjAY5qH9L3EbcPemFaOm+rmPxAyXt5A6Ubc67ome1GJA7eRQRjyMY0DXju31vV2nA9osaAqsrKGxP7kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=1DrrCWys; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=M6KEQfAy; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=1DrrCWys; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=M6KEQfAy; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="1DrrCWys";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="M6KEQfAy";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="1DrrCWys";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="M6KEQfAy"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D0A1D1F793;
	Wed, 14 May 2025 06:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1747204766; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t0kF4dO/+KxJMqI/h3j7CUouKL+W5cmBwxlegzo07i8=;
	b=1DrrCWys1+JN1yBIJncm+kcW7DfWTTRCAEUXbiv1K+lcDKnvdlpGh68U3hVV1LKyClp6aG
	KtCtWmA2/MXFIZMPt8HOJyN/no5HOyiwnkJWyLXjQuMuz1j9HMab+IaHVXe1MtTCKxssdF
	KQpXmgAkHm15HBofyURIvb6UTRG5MEM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1747204766;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t0kF4dO/+KxJMqI/h3j7CUouKL+W5cmBwxlegzo07i8=;
	b=M6KEQfAyo+8S/KYWgukPNV970s1dpMk/NrXWUfBbq+LNepfQ61k2gxRG0rlWOwYM9xG7Kj
	iqHaRAxIOl05rlCQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1747204766; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t0kF4dO/+KxJMqI/h3j7CUouKL+W5cmBwxlegzo07i8=;
	b=1DrrCWys1+JN1yBIJncm+kcW7DfWTTRCAEUXbiv1K+lcDKnvdlpGh68U3hVV1LKyClp6aG
	KtCtWmA2/MXFIZMPt8HOJyN/no5HOyiwnkJWyLXjQuMuz1j9HMab+IaHVXe1MtTCKxssdF
	KQpXmgAkHm15HBofyURIvb6UTRG5MEM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1747204766;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t0kF4dO/+KxJMqI/h3j7CUouKL+W5cmBwxlegzo07i8=;
	b=M6KEQfAyo+8S/KYWgukPNV970s1dpMk/NrXWUfBbq+LNepfQ61k2gxRG0rlWOwYM9xG7Kj
	iqHaRAxIOl05rlCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0C2D1137E8;
	Wed, 14 May 2025 06:39:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IQm8OJ06JGjZcQAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 14 May 2025 06:39:25 +0000
Message-ID: <37bb9993-baaa-4dc8-b5d4-e66201e4a462@suse.de>
Date: Wed, 14 May 2025 08:39:25 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] dm mpath: Interface for explicit probing of active
 paths
To: Benjamin Marzinski <bmarzins@redhat.com>,
 Christoph Hellwig <hch@infradead.org>
Cc: Kevin Wolf <kwolf@redhat.com>, Martin Wilck <mwilck@suse.com>,
 dm-devel@lists.linux.dev, hreitz@redhat.com, mpatocka@redhat.com,
 snitzer@kernel.org, linux-kernel@vger.kernel.org
References: <20250429165018.112999-1-kwolf@redhat.com>
 <47dd225b433b0df585a25084a2e793344eeda239.camel@suse.com>
 <aCIRUwt5BueQmlMZ@redhat.com> <aCLe5UT2kfzI96TQ@infradead.org>
 <0340c51e-6f89-4799-b2f1-19c785a19ff2@suse.de>
 <aCLjPLCztuXhgpnA@infradead.org>
 <d2a7fa68-1890-4367-a2ac-59ec220779bd@suse.de>
 <aCLrbz3bRLwUbA8p@infradead.org> <aCNzf7MJa-hLQpmv@redhat.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <aCNzf7MJa-hLQpmv@redhat.com>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email]
X-Spam-Score: -4.30

On 5/13/25 18:29, Benjamin Marzinski wrote:
> On Mon, May 12, 2025 at 11:49:19PM -0700, Christoph Hellwig wrote:
>> On Tue, May 13, 2025 at 08:32:12AM +0200, Hannes Reinecke wrote:
>>> Reservations and stuff.
>>
>> They should use the kernel persistent reservation API.
> 
> Currently QEMU isn't sending Persistent Reservation requests to
> multipath devices at all. It's sending those directly to the underlying
> scsi devices. The issue here is with all the other SCSI commands that
> users want to send to their SCSI passthrough device that is actually a
> multipath device on top of a number of SCSI paths. They expect to
> get back the actual sense and status information, so QEMU needs to
> send them via SG_IOs.
> 
> Without reading that sense and status information in kernel, the
> multipath target can't know if it needs to fail a path and retry the
> ioctl down a different path. QEMU can read this information, but it
> doesn't know what path the multipath device send the ioctl down. This
> patch just gives users a way to check the paths in the active pathgroup
> (which all should be able to handle IO) and fail those that can't.
> While QEMU is the driver of this, it's completely general functionality.
> 
Ouch.
Different reservations on different paths? Really?
How do you manage to keep the reservations up-to-date?

My recommendation is to use the _same_ reservation on all paths,
precisely to avoid having to re-do reservations on path failure.
And for that scenario the kernel persistent reservation API
would work fine.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
