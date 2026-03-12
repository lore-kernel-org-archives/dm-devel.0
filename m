Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5BBF3AC0E2
	for <dm-devel@lists.linux.dev>; Thu, 12 Mar 2026 07:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773299436; cv=none; b=VwuQms812TCoWr0fV27tfPEkIXjTgfHr/SbdTulrdvs7k0Xt3oD3hPqGw0P/eU4hAB3/3XJlGpiLuqZl1NPSGw5Kq7TV/GoJ0NVofU3PueHbfb1IO1p9ojUWkTXYbBed5IKMOFvApiTyJUKY0h0/EAmxrH0P29Byxemh196xP/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773299436; c=relaxed/simple;
	bh=JZRYTXo+JjHZpZlDU6EMIbBSq24RUHmUGrqZsllm2Rg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Zl48F4g5QptpC6Ce0XKvitgbKd4yQtnDsefZZhdQB+naFf/mlwhtPSNk+fQ1v45VXWDkmBNIucYSu6y7/FHPDgam7zr5rwY7SiRFWPBcoGrBMFmtHJJ4VX4JJWGIc9ouO04IVWsejiUXQWPmhOCbJmdrKPnzbCu6jlWW5401qd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Iym63A57; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=P3t1QYH9; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Iym63A57; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=P3t1QYH9; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Iym63A57";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="P3t1QYH9";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Iym63A57";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="P3t1QYH9"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CA39C5BD08;
	Thu, 12 Mar 2026 07:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773299430; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tr9cbP1Svc+kQDHpamxFCkcB3+I0OqVICFe/AAvO56s=;
	b=Iym63A57FAkSLhROOWTQTWB5Qxoye0liG9oRllY+8tfIW5M99vQvWLWmsniGSsL7zi1tcX
	YiY7klMMpj1MklGN04QmzNIX+H095qmQD8uzy07BBoBKO/PM5dS14Ac4/ZMZ7mavRe/VJs
	6iqMKMO8hJ2kJ4+jsJu2Jv4skA5Lze8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773299430;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tr9cbP1Svc+kQDHpamxFCkcB3+I0OqVICFe/AAvO56s=;
	b=P3t1QYH9YA7nVPHXkqMP9G9bSD1+eBON4x9C7ONmQcdrdrT9Qre0+MHf9v8eRwaT98yDnJ
	NRlkMyx9g4joxcCA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Iym63A57;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=P3t1QYH9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773299430; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tr9cbP1Svc+kQDHpamxFCkcB3+I0OqVICFe/AAvO56s=;
	b=Iym63A57FAkSLhROOWTQTWB5Qxoye0liG9oRllY+8tfIW5M99vQvWLWmsniGSsL7zi1tcX
	YiY7klMMpj1MklGN04QmzNIX+H095qmQD8uzy07BBoBKO/PM5dS14Ac4/ZMZ7mavRe/VJs
	6iqMKMO8hJ2kJ4+jsJu2Jv4skA5Lze8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773299430;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tr9cbP1Svc+kQDHpamxFCkcB3+I0OqVICFe/AAvO56s=;
	b=P3t1QYH9YA7nVPHXkqMP9G9bSD1+eBON4x9C7ONmQcdrdrT9Qre0+MHf9v8eRwaT98yDnJ
	NRlkMyx9g4joxcCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9AFFE3FE4A;
	Thu, 12 Mar 2026 07:10:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cuQlJOZmsmk5FgAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 12 Mar 2026 07:10:30 +0000
Message-ID: <91ed7162-719f-4ff2-9951-913fe8096f08@suse.de>
Date: Thu, 12 Mar 2026 08:10:30 +0100
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/1] checkers: add alua path checker
To: Brian Bunker <brian@purestorage.com>, bmarzins@redhat.com,
 mwilck@suse.com, dm-devel@lists.linux.dev
References: <20260312001642.53321-1-brian@purestorage.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260312001642.53321-1-brian@purestorage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim,suse.de:mid,suse.de:email];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Queue-Id: CA39C5BD08
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 

On 3/12/26 01:16, Brian Bunker wrote:
> For ALUA-capable storage arrays, multipath-tools currently uses TUR
> (Test Unit Ready) as the default path checker while a separate
> prioritizer determines ALUA state. When sysfs provides ALUA state
> (the common case), no RTPG command is needed for priority. However,
> if sysfs is unavailable or detect_prio is off, the prioritizer issues
> RTPG, resulting in two SCSI commands per path check cycle: TUR + RTPG.
> 
> This patch introduces an 'alua' path checker that uses RTPG as the path
> check command, providing two benefits:
> 
> 1. For configurations where RTPG is needed for priority, this eliminates
>     duplicate I/O by combining path checking and ALUA state retrieval
>     into a single RTPG command.
> 
> 2. RTPG provides richer path state information than TUR:
>     * TRANSITIONING state detected and mapped to PATH_PENDING,
>       preventing false all paths down during controller failover
>     * STANDBY state detected and mapped to PATH_GHOST
>     * UNAVAILABLE/OFFLINE states properly distinguished
> 
> The richer state information is valuable even when sysfs is available,
> as TUR cannot distinguish between these ALUA-specific conditions.
> 
> This design intentionally couples the checker and prioritizer: the
> alua_cached prioritizer consumes state cached by the alua checker.
> While this blurs the traditional separation between these components,
> for ALUA the path state and priority fundamentally derive from the
> same underlying data, making the coupling a natural fit.
> 
> This patch sets the alua checker as the auto-detected default for ALUA
> devices to demonstrate its benefits. We recognize that adopting a new
> default checker requires careful consideration; the auto-detection can
> be adjusted or removed based on review feedback.
> 
> Brian Bunker (1):
>    checkers: add alua path checker
> 
>   libmultipath/Makefile                   |   5 +
>   libmultipath/checkers.c                 |   1 +
>   libmultipath/checkers.h                 |   1 +
>   libmultipath/checkers/Makefile          |   3 +-
>   libmultipath/checkers/alua.c            | 426 ++++++++++++++++++++++++
>   libmultipath/checkers/alua.h            |  15 +
>   libmultipath/prio.c                     |   1 +
>   libmultipath/prio.h                     |   1 +
>   libmultipath/prioritizers/Makefile      |   1 +
>   libmultipath/prioritizers/alua_cached.c | 225 +++++++++++++
>   libmultipath/prioritizers/alua_rtpg.c   |  12 +-
>   libmultipath/prioritizers/alua_rtpg.h   |   1 +
>   libmultipath/prioritizers/sysfs.c       |   7 +-
>   libmultipath/propsel.c                  |  25 +-
>   libmultipath/structs.c                  |   2 +
>   libmultipath/structs.h                  |   3 +
>   16 files changed, 721 insertions(+), 8 deletions(-)
>   create mode 100644 libmultipath/checkers/alua.c
>   create mode 100644 libmultipath/checkers/alua.h
>   create mode 100644 libmultipath/prioritizers/alua_cached.c
> 

Hmm. Some array vendor have been less than happy when I
tried a similar thing during development of the ALUA
device handler.
Problem is that RTPG requires a cluster callout on the
array side, as it needs to contain information about
the _entire_ target system. Which, for distributed systems,
is a costly operation. So using this as a path
checker is not making certain array vendors happy.

However: as you might have followed the discussion
about scsi multipathing, maybe we can turn this around
to profit both sides:
Can't we move ALUA state handling into the generic
code, leaving the device handler only to deal with
explicit ALUA?
That way we can intercept sense codes and send RTPG
only when required, such that the ALUA state of
the scsi device is correct.
And the the ALUA path checker just has to evaluate
the information in sysfs.
_And_ scsi multipathing can use that information, too.

Hmm?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
