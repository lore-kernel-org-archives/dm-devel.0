Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBBB52BEFF5
	for <dm-devel@lists.linux.dev>; Fri, 13 Mar 2026 11:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773403138; cv=none; b=g5zuwD6Ubyy3rPaeAtujiQYT9/BxVLD4TH9ig4rNf1c5S4F8FHZYe6r0EpexBIAHTkOIkgTZIXu5BQt2FJGTpUNKn9rthn7+QO+W64Pfn1b1PU8JtQRmDS+ItYiHLK4KHJXQ+lsXvubC4YbT+C1sN4yzdDXXj5MHJFhAzrXKhvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773403138; c=relaxed/simple;
	bh=ZPWZl827o/DVE97ZPBElZ49uNliBhB4FtHMSjNi1lnY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=l/VqFe3zoRYMgxFPb3jybYxAUIBuW69IGNIsB27OukcBqbpj+B9NfAz9WdL+eSBm0nHNQinu2Ce0QZ6rhIEgwRozcFzxq7rhTizZUM670B1lS2orifWxwv7+jNasYeVnvVKUstskjjJeZjXAxwbr9PQkm2JSmonHCWjxTYzNUKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=G4/gHmJh; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=G4/gHmJh; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="G4/gHmJh";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="G4/gHmJh"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2FC2D402DB;
	Fri, 13 Mar 2026 11:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1773403135; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4VfbfMjDd2+PPupy9SR6v24EZ/uPylJNzIFVNzwBrSA=;
	b=G4/gHmJh4AXTp4yrSUx8Msz5nCAM8N6M0zAc5Ymz9oP7EwgShb3dkeB18WMsakr3WCDaX2
	whVPS+5chzlpjFf44dpLx9ZuYCpQue/2+hHxb5oBZmFHwa+cq8N+8Huqyawg41ZS5xhDpX
	kZDPUg7J/OLb1kMMNmv6wIs/g90iWas=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1773403135; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4VfbfMjDd2+PPupy9SR6v24EZ/uPylJNzIFVNzwBrSA=;
	b=G4/gHmJh4AXTp4yrSUx8Msz5nCAM8N6M0zAc5Ymz9oP7EwgShb3dkeB18WMsakr3WCDaX2
	whVPS+5chzlpjFf44dpLx9ZuYCpQue/2+hHxb5oBZmFHwa+cq8N+8Huqyawg41ZS5xhDpX
	kZDPUg7J/OLb1kMMNmv6wIs/g90iWas=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0AFA9404F1;
	Fri, 13 Mar 2026 11:58:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EqOeAf/7s2nMJAAAD6G6ig
	(envelope-from <mwilck@suse.com>); Fri, 13 Mar 2026 11:58:55 +0000
Message-ID: <b1a92815f8140702bdb742411ab11b499eb49c59.camel@suse.com>
Subject: Re: [PATCH] multipath-tools: identify the hds.c licence explicitly
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, DM_DEVEL-ML <dm-devel@lists.linux.dev>, 
 Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>
Date: Fri, 13 Mar 2026 12:58:54 +0100
In-Reply-To: <20260313110016.91868-1-xose.vazquez@gmail.com>
References: <20260313110016.91868-1-xose.vazquez@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_TO(0.00)[gmail.com];
	TAGGED_RCPT(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_DN_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO

On Fri, 2026-03-13 at 12:00 +0100, Xose Vazquez Perez wrote:
> ACK from the Copyright holder.
>=20
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> Signed-off-by: Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>
> ---
> =C2=A0libmultipath/prioritizers/hds.c | 4 +---
> =C2=A01 file changed, 1 insertion(+), 3 deletions(-)
>=20
> diff --git a/libmultipath/prioritizers/hds.c
> b/libmultipath/prioritizers/hds.c
> index 212301ea..70eaa8c0 100644
> --- a/libmultipath/prioritizers/hds.c
> +++ b/libmultipath/prioritizers/hds.c
> @@ -1,3 +1,4 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> =C2=A0/*
> =C2=A0 * (C) Copyright HDS GmbH 2006. All Rights Reserved.
> =C2=A0 *
> @@ -60,9 +61,6 @@
> =C2=A0 *=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 not =
work under RHEL4 U3 i386
> =C2=A0 * Changes 2007-06-27:
> =C2=A0 *	- switched from major:minor argument to device node argument
> - *
> - * This file is released under the GPL.
> - *
> =C2=A0 */
> =C2=A0
> =C2=A0#include <stdio.h>

This represents a license change. The common understanding of "GPL
without version", AFAIK, is that the person receiving the code can
choose to use it under any version of the GPL, including GPLv1.

Strictly speeking, by changing the license to GPL v2.0, we're taking
away rights from users.

Hitachi Vantara as the successor of HDS is the main copyright holder
for this file. While others have contributed to the file, the
respective changes are all trivial. So by adding Matthias' S-O-B,
you're adding credibility to this change.=20

Anyway, users are free to use and distribute the code from earlier
versions of multipath-tools under other versions of the GPL.

So:

Reviewed-by: Martin Wilck <mwilck@suse.com>


