Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 720B128C009
	for <dm-devel@lists.linux.dev>; Wed, 28 Jan 2026 07:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769586681; cv=none; b=rBlpx4YS+vCS0+YcEJilAbqhnhlVQiZZJhtB7b3r5KPPhmOny/9VJBIP6pDeJ16TG2CSy8KD+GPh4Cb+f404DB6JBDsSMni+2CwICSBe4qFT74wUnQsaa3L4gX7p68CoqgGTCoPMBDsYCmAMYR/MFW1Ktz6w43RUQLR3l6FQAek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769586681; c=relaxed/simple;
	bh=thVxlNYLm7rFaCpCd4sKprQ523d/PEqhR/sfnI44Q1Y=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=b46LCa+PFgTZ40AfmWnVWh+1t5JOTakPQiOurd3DPMMc2/n9sMMwc1QKjJSl2wx1xMhX68AKGKTn79HIb8+zyXVPGapKOS4MoxcCSbegasIFMb5gRuHlsp3H9JD3ReLVU0c8CoLJtyc2+utdB+miXxQJ7KSztGOw1btvPZ3J7Wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=SlbuEXfZ; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=SlbuEXfZ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="SlbuEXfZ";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="SlbuEXfZ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B822033A81;
	Wed, 28 Jan 2026 07:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1769586678; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=thVxlNYLm7rFaCpCd4sKprQ523d/PEqhR/sfnI44Q1Y=;
	b=SlbuEXfZpFcLtQITbxxSmqRWCNyBYqNSuMqoqses3FLRPnz3rTtoxpDBhhrLG9/mHxOxTb
	8vWCFdpqdrSTKEbJ8mZHJbvIY5Tp2QOgNaBKRM01sJ4WM8akuOmHirLBXeObjxbFVyKj2F
	pHWYiM/bhJPGQ3iJlOU8UyEFhIeEu6Y=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1769586678; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=thVxlNYLm7rFaCpCd4sKprQ523d/PEqhR/sfnI44Q1Y=;
	b=SlbuEXfZpFcLtQITbxxSmqRWCNyBYqNSuMqoqses3FLRPnz3rTtoxpDBhhrLG9/mHxOxTb
	8vWCFdpqdrSTKEbJ8mZHJbvIY5Tp2QOgNaBKRM01sJ4WM8akuOmHirLBXeObjxbFVyKj2F
	pHWYiM/bhJPGQ3iJlOU8UyEFhIeEu6Y=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8EF133EA61;
	Wed, 28 Jan 2026 07:51:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XeTSIfa/eWmKewAAD6G6ig
	(envelope-from <mwilck@suse.com>); Wed, 28 Jan 2026 07:51:18 +0000
Message-ID: <8574d0a57136ace02638664422b7bef7766fa94c.camel@suse.com>
Subject: Re: [PATCH 0/3] dm mpath: Minor multipath related cleanup
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Mikulas Patocka
	 <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>
Cc: dm-devel@lists.linux.dev
Date: Wed, 28 Jan 2026 08:51:18 +0100
In-Reply-To: <20260128001224.462746-1-bmarzins@redhat.com>
References: <20260128001224.462746-1-bmarzins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid,suse.com:email]
X-Spam-Level: 
X-Spam-Flag: NO

On Tue, 2026-01-27 at 19:12 -0500, Benjamin Marzinski wrote:
> This patchset fixes two minor bugs in creating multipath devices, and
> removes some dm locking that is no longer necessary after a change in
> the
> multipath code.
>=20
> Benjamin Marzinski (3):
> =C2=A0 dm mpath: Add missing dm_put_device when failing to get scsi dh
> name
> =C2=A0 Revert "dm: fix a race condition in retrieve_deps"
> =C2=A0 dm mpath: make pg_init_delay_msecs settable
>=20
> =C2=A0drivers/md/dm-core.h=C2=A0 |=C2=A0 1 -
> =C2=A0drivers/md/dm-ioctl.c |=C2=A0 7 +------
> =C2=A0drivers/md/dm-mpath.c | 22 +++++++++++-----------
> =C2=A0drivers/md/dm-table.c | 32 ++++++++------------------------
> =C2=A04 files changed, 20 insertions(+), 42 deletions(-)

Reviewed-by: Martin Wilck <mwilck@suse.com>
