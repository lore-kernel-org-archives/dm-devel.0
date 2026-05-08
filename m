Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8D0221DB3
	for <dm-devel@lists.linux.dev>; Fri,  8 May 2026 23:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778281872; cv=none; b=sV8+oBm7h0xMC88C5jMyRYbRekizDUvOz7HXZ3IiHCzi7ybbd7T/aAIX7To9hh6LxREGAHCKAPvFAtco5vo5uBqSGVO3ngsalSmtPomyu/a2raODIA1AFcQP/GpJxzAp6POspIng4XxKHtjBLxXjgTo7Be43zrYfMG0YTBfu7X4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778281872; c=relaxed/simple;
	bh=U/IRvpdIVQ5wmQvj+XkLIl8dyqoL0vuM3E+OEl3XUYY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uimpeTWSDlkzNZrmvujygZF9BbNiRqKWGINRvbALQnKGfOPzdtClEf4//NmfnUjTbCmbbRDTLreqF5Kl2PDUns3s+mgpoIgJouf+i0D775nCSiKfMn0+GR7G+R7VgFXqiQpL3fj6SqN0iWAXVVgp4CxGtrVJJa3g0hjH2L7Z56I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=NSDQiWII; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=NSDQiWII; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="NSDQiWII";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="NSDQiWII"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 432986AF19;
	Fri,  8 May 2026 23:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778281869; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U/IRvpdIVQ5wmQvj+XkLIl8dyqoL0vuM3E+OEl3XUYY=;
	b=NSDQiWIIdGAxdn4oAvkMbgdlhNdzCfan7G1lahZMdHiKXC5XQ1yLDMo1lGT7RDkQMC6uke
	in1du1Tz5VcXYLc/UsLPm4v/0Di4IsTLEM4xbW07nrYEsI9bUSTp7UzAnFhPSnsMZBND0h
	syDw6sG6GQsyON0x8D9eZDdy82WFI08=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=NSDQiWII
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778281869; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U/IRvpdIVQ5wmQvj+XkLIl8dyqoL0vuM3E+OEl3XUYY=;
	b=NSDQiWIIdGAxdn4oAvkMbgdlhNdzCfan7G1lahZMdHiKXC5XQ1yLDMo1lGT7RDkQMC6uke
	in1du1Tz5VcXYLc/UsLPm4v/0Di4IsTLEM4xbW07nrYEsI9bUSTp7UzAnFhPSnsMZBND0h
	syDw6sG6GQsyON0x8D9eZDdy82WFI08=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1D46B593A7;
	Fri,  8 May 2026 23:11:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id FjMBBo1t/mn5RQAAD6G6ig
	(envelope-from <mwilck@suse.com>); Fri, 08 May 2026 23:11:09 +0000
Message-ID: <c0567063115fb987e700601ac17821feda87b086.camel@suse.com>
Subject: Re: [PATCH 05/18] multipath-tools tests: add tests for shared
 pointer code
From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski
	 <bmarzins@redhat.com>, Brian Bunker <brian@purestorage.com>, 
	dm-devel@lists.linux.dev
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>
Date: Sat, 09 May 2026 01:11:08 +0200
In-Reply-To: <20260505154332.448054-6-mwilck@suse.com>
References: <20260505154332.448054-1-mwilck@suse.com>
	 <20260505154332.448054-6-mwilck@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:dkim,suse.com:mid]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 432986AF19
X-Spam-Level: 

On Tue, 2026-05-05 at 17:43 +0200, Martin Wilck wrote:
> Add a few tests (mostly meaningful with valgrind or ASAN) to test the
> shared pointer code.
>=20
> Signed-off-by: Martin Wilck <mwilck@suse.com>

This test code needs rework. Don't review it yet.

