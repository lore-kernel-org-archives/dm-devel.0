Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35AD32B9BD
	for <dm-devel@lists.linux.dev>; Thu, 15 Jan 2026 21:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768513926; cv=none; b=HNTjjOEK3P2qDhwhlbS7W5Q4qz26jWWUiAI9Or59ASXfdrtkhmwPStnf/u9/t6GTrg+rwvGhAFfUMUag157HA3ub5l0Po84oAuKis5pZPTntqngcw1LUNJUWGCUCcVWKruOAu/PAWIaCpiJ/kCRIsHQYm3ueZ/JrmWhkQH+YW3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768513926; c=relaxed/simple;
	bh=zWYsgi7X8olDWOiqd0n2ARsVZVSoeAf0u1dBnQ2jc7I=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qncukY8iQ0LR3YBr9LD7oABJrZIAzMbZYsUPuM1PTRK0F2Gm5RgOE/suN7HRgzWQIOiRj38rOG53bqzld4UjbQJem+3KRF9ZQKaP7BV1c6GtH52EdQYLmQl+UuEOVWgMeY5qx0e2U8fYIlvGI2yH1pouKriJbX/hmHX70052TLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=oOlaRcLt; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=oOlaRcLt; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="oOlaRcLt";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="oOlaRcLt"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E73A55BCCE;
	Thu, 15 Jan 2026 21:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1768513922; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zWYsgi7X8olDWOiqd0n2ARsVZVSoeAf0u1dBnQ2jc7I=;
	b=oOlaRcLtPwOk1n2k0uuulD+e/Lt2kBXtA313lejjF2lOA1vqpoF6UdZ9My3UZR0FIpJQhH
	G3Gm03Go3szYfk5gVO0KVqrbw9O+X6D45lz2z8AfeL5OHdnwYcOZQoVoQSWwbhm6uU2QPb
	XS+r9GxwyPaVZFEcZrEgyNjYqqafT2Y=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1768513922; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zWYsgi7X8olDWOiqd0n2ARsVZVSoeAf0u1dBnQ2jc7I=;
	b=oOlaRcLtPwOk1n2k0uuulD+e/Lt2kBXtA313lejjF2lOA1vqpoF6UdZ9My3UZR0FIpJQhH
	G3Gm03Go3szYfk5gVO0KVqrbw9O+X6D45lz2z8AfeL5OHdnwYcOZQoVoQSWwbhm6uU2QPb
	XS+r9GxwyPaVZFEcZrEgyNjYqqafT2Y=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C65723EA63;
	Thu, 15 Jan 2026 21:52:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0mq1LoJhaWlZAgAAD6G6ig
	(envelope-from <mwilck@suse.com>); Thu, 15 Jan 2026 21:52:02 +0000
Message-ID: <8a8b3322a7d10f754337b26760c208d165e0189c.camel@suse.com>
Subject: Re: [PATCH v3 21/26] kpartx: fix some memory leaks
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>
Date: Thu, 15 Jan 2026 22:52:02 +0100
In-Reply-To: <20260107201826.323977-22-mwilck@suse.com>
References: <20260107201826.323977-1-mwilck@suse.com>
	 <20260107201826.323977-22-mwilck@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Score: -4.29
X-Spamd-Result: default: False [-4.29 / 50.00];
	BAYES_HAM(-2.99)[99.96%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid]
X-Spam-Level: 
X-Spam-Flag: NO

On Wed, 2026-01-07 at 21:18 +0100, Martin Wilck wrote:
> These leaks were reported by LeakSanitizer.

Coverity showed that this patch was wrong. I'll resend.

Martin
