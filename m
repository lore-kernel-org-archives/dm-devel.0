Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AFA9397E9F
	for <dm-devel@lists.linux.dev>; Mon, 16 Mar 2026 14:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773670034; cv=none; b=ONbH+c4qRLkLcI6Pj4E8x5jGNqw9CtTnsK4+YZQU8ZEu6Cq9cnK41tMdQqdqc6l8K5u9BzcsFoTR9Y3eKa2GrPbE56KtewxozDWe/bHyovWZqv2dOtwxqj3q1lYsnpMEIhTBgc38AlS37XwBSwygX4+H58QGNyJ9CrQxSgwvdFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773670034; c=relaxed/simple;
	bh=YxL6RdPVB3y738Wf5MrxI8dULdsIWDQZ/1ZHMtg8LQw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=eBdDJw19LAJzRjSAM3hozaKoRBFYA1+lPF+FLo9Mkp4geGCKinKq+nhqvmK1WfjNzUvBijS4bpVagBKqGLAuoaTnJZ4DXZPvlhF5P0bxmMj7G4zCujsgZ5mhvUaolDNn4BF3IVKCXCHGgGJXRAzBHvc7hEjUR1kGThc+yS5EzbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=QPNUH5d8; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=QPNUH5d8; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="QPNUH5d8";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="QPNUH5d8"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7384C4D2E8;
	Mon, 16 Mar 2026 14:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1773670031; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YxL6RdPVB3y738Wf5MrxI8dULdsIWDQZ/1ZHMtg8LQw=;
	b=QPNUH5d8Zbfg3VeY1v50WG1YNpSMfZN/0MRalwMf5tDyy022PQv8u03wdQ1It3itti8cRc
	Ng3iFE87DtEXFpz8OWCsRCzHqp5FWok2Z/j+QrqYsgMLYP+AZqTa8jTCvhQncfl5W4JytJ
	auGmUyHbJikwI3lZgF6xLgcfjDDluFc=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1773670031; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YxL6RdPVB3y738Wf5MrxI8dULdsIWDQZ/1ZHMtg8LQw=;
	b=QPNUH5d8Zbfg3VeY1v50WG1YNpSMfZN/0MRalwMf5tDyy022PQv8u03wdQ1It3itti8cRc
	Ng3iFE87DtEXFpz8OWCsRCzHqp5FWok2Z/j+QrqYsgMLYP+AZqTa8jTCvhQncfl5W4JytJ
	auGmUyHbJikwI3lZgF6xLgcfjDDluFc=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 51DBC4273B;
	Mon, 16 Mar 2026 14:07:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5i/gEo8OuGkgBgAAD6G6ig
	(envelope-from <mwilck@suse.com>); Mon, 16 Mar 2026 14:07:11 +0000
Message-ID: <d72b98cf99e1f9af2223cde15c4e586b13747569.camel@suse.com>
Subject: Re: [PATCH 1/2] multipath-tools: add SPDX-License-Identifier tag to
 libmpathutil/util.c
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, DM_DEVEL-ML <dm-devel@lists.linux.dev>
Date: Mon, 16 Mar 2026 15:07:10 +0100
In-Reply-To: <20260313231449.79972-1-xose.vazquez@gmail.com>
References: <20260313231449.79972-1-xose.vazquez@gmail.com>
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
	NEURAL_HAM_SHORT(-0.20)[-0.999];
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
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid,suse.com:email]
X-Spam-Flag: NO

On Sat, 2026-03-14 at 00:14 +0100, Xose Vazquez Perez wrote:
> This file combines "LGPL-2.1-or-later" and "GPLv2 or later" code,
> so the resulting code is GPL-2.0-or-later via the LGPL conversion
> clause.
>=20
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

This would relicense the entire file, except the basename()
implementation, which is already under GPL-2.0-or-later. That is quite
probably not in line with the intention of every copyright holder.

We can move libmp_basename() to a separate file to clarify the license
of this code snippet.

Regards
Martin
