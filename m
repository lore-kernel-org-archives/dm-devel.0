Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E609715886C
	for <dm-devel@lists.linux.dev>; Mon, 24 Feb 2025 22:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740434606; cv=none; b=DioQiEPaRUSB2DPCcT2J/ZvidoZlgS7kkIN7y12LmeBQosBw5j7AZZ2X1JUvIlAWGGCCDJV5mhXwEbLF71uXEQfVA6eIsMco4A/0HsJoBzHypaXiGVvu6FZSb5hIetB0Xx5ELgKadsB4YD4x+UASSYG7c0AuKjRofmGOzZ3+jtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740434606; c=relaxed/simple;
	bh=HdphhnkJ/blxxdCLXWXaEk7bi3rwRWbREBvdHwgbn9Q=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=N/rkh0NW6gxIZQz+3c4eWpaE/wWhGqk3WKuEgSN1VbR0od45vGZi8yF0+1bvOCp11dJJ5nlQsKirBMs2PLdaMxa7JeKmcKnlTejZupVkwI/PBK2sasAqF1bCoNpU2VNnc9cG0ZjSffEZ+oDQUwaL1nBUbL+U4lXBalPW995DuUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=LhgLRiwW; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=UCfbczfN; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="LhgLRiwW";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="UCfbczfN"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E4FAD1F44E;
	Mon, 24 Feb 2025 22:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1740434602; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HdphhnkJ/blxxdCLXWXaEk7bi3rwRWbREBvdHwgbn9Q=;
	b=LhgLRiwWvpvtwVUOp9L1h4N7l1RuYxIJdkVFbKAMBsaxqshs666OETwK/cz85uu63FQugX
	ql5Jbu972KD4I91Kq6ovX8OlAVpgZCCbwDaBCZlt8kHNSt3jeD2Xne4Iq+7fLZoj8MYrhb
	2HX1/6/lrv6tpeIhGh6CHPq4GeVygVM=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1740434601; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HdphhnkJ/blxxdCLXWXaEk7bi3rwRWbREBvdHwgbn9Q=;
	b=UCfbczfNK0eEoDlRp+vq6MJA7Zbh7+mC7oqP4gMpcdq8riFBbSxgQHQaq3fD1cSZlMNXj2
	e0y8X1s86kUN55sSMywvK0hGqBi0r5zvEmXJbMKzovHTzeWnWhbHbfkaGOS4qIbAU76223
	wwICBQ9WuZio/YQU4RqEryjK9LDdPog=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BE28313AA4;
	Mon, 24 Feb 2025 22:03:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0sbELKnsvGdHUwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Mon, 24 Feb 2025 22:03:21 +0000
Message-ID: <c021e98981f5dd3e95bbff3ac16f3081536335dc.camel@suse.com>
Subject: Re: [PATCH] libmpathutils/uxsock.c: Include string.h for memcpy
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Khem Raj <raj.khem@gmail.com>
Cc: dm-devel@lists.linux.dev
Date: Mon, 24 Feb 2025 23:03:21 +0100
In-Reply-To: <Z7OkPcrX9dhWUPSn@redhat.com>
References: <20250217200503.4166910-1-raj.khem@gmail.com>
	 <Z7OkPcrX9dhWUPSn@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-0.999];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	FREEMAIL_TO(0.00)[redhat.com,gmail.com];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Level: 

On Mon, 2025-02-17 at 16:03 -0500, Benjamin Marzinski wrote:
> On Mon, Feb 17, 2025 at 12:05:03PM -0800, Khem Raj wrote:
> > Fixes
> > uxsock.c:72:2: error: call to undeclared library function 'memcpy'
> > with type 'void *(void *, const void *, unsigned long)'; ISO C99
> > and later do not support implicit function declarations [-
> > Wimplicit-function-declaration]
>=20
> Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

Thanks, it turns out that we have this include already in the queue
branch, but I applied your patch on stable-0.11.y and stable-0.10.y.

Regards
Martin

> >=20
> > Signed-off-by: Khem Raj <raj.khem@gmail.com>
> > Cc: Benjamin Marzinski <bmarzins@redhat.com>
> > Cc: Martin Wilck <mwilck@suse.com>
> > ---
> > =C2=A0libmpathutil/uxsock.c | 1 +
> > =C2=A01 file changed, 1 insertion(+)
> >=20
> > diff --git a/libmpathutil/uxsock.c b/libmpathutil/uxsock.c
> > index 2135476d..a474874e 100644
> > --- a/libmpathutil/uxsock.c
> > +++ b/libmpathutil/uxsock.c
> > @@ -8,6 +8,7 @@
> > =C2=A0#include <stdlib.h>
> > =C2=A0#include <unistd.h>
> > =C2=A0#include <stdarg.h>
> > +#include <string.h>
> > =C2=A0#include <fcntl.h>
> > =C2=A0#include <sys/ioctl.h>
> > =C2=A0#include <sys/types.h>
>=20

