Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BAD33BFAF7
	for <dm-devel@lists.linux.dev>; Mon, 15 Jun 2026 08:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781512682; cv=none; b=H1ocCU5eubcIibeQbIkMa5em0ni3wgLrtNZY+jV3GWlScXxOt0no6qbNAEUgm/HjfR+NM8lNZsScM35EXt0WpOdAdH2efq39NFypenpCsc3y0eFPeL2gzGyb93VoStFfu0y+++thqUKrWtYrE3bwh8l7Fs/nBLnQQtTjiBfiroM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781512682; c=relaxed/simple;
	bh=PPD/eRFG+nzKPvKWp8I1HyjWGQoHfoLhfXNI9B+rT0I=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=i2iBT3YZA72DMWYfg0z5uJZpcLK5NK1WsSNTBYoxwuKfeaNgf9BT4Wz+rL+j5JI9xRtoQ9Cyyb96P1yPI8rkeJmTojoLUk+Dpn1xT8inCFmGEiOVoCemHkhcvkI7GOz0WfI1qo4kHNdCvoddZvt2WVUQE0+wq9MV2KkjSiDuyCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=txgACCpo; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=txgACCpo; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="txgACCpo";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="txgACCpo"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 76418759AD;
	Mon, 15 Jun 2026 08:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781512679; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PPD/eRFG+nzKPvKWp8I1HyjWGQoHfoLhfXNI9B+rT0I=;
	b=txgACCpodMHWM+vZFBeBssV2zMAmVeE+X6DzC7SVPZkc6ixW0fTM0s6CT/6JdrWG/TmjpF
	vq+pHlaKxOpKIoureJSDyXwb6mxrzR3BuB+ldiHIQMdm1jnHhi6CMMrpgqJq7wjpA0w5/p
	8lijZdPz89/V1uVHNtAcZbMqQiDbD3A=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781512679; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PPD/eRFG+nzKPvKWp8I1HyjWGQoHfoLhfXNI9B+rT0I=;
	b=txgACCpodMHWM+vZFBeBssV2zMAmVeE+X6DzC7SVPZkc6ixW0fTM0s6CT/6JdrWG/TmjpF
	vq+pHlaKxOpKIoureJSDyXwb6mxrzR3BuB+ldiHIQMdm1jnHhi6CMMrpgqJq7wjpA0w5/p
	8lijZdPz89/V1uVHNtAcZbMqQiDbD3A=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 57067779A7;
	Mon, 15 Jun 2026 08:37:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id po0pFOe5L2oMCwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Mon, 15 Jun 2026 08:37:59 +0000
Message-ID: <35ab9802b0e8a55ade753048cb70ffcafe1069a4.camel@suse.com>
Subject: Re: [PATCH 2/5] multipath-tools: clarify path selector descriptions
 in multipath.conf.5
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	 <christophe.varoqui@opensvc.com>, DM_DEVEL-ML <dm-devel@lists.linux.dev>
Date: Mon, 15 Jun 2026 10:37:58 +0200
In-Reply-To: <994b66b1-68fb-4dd6-90e4-8fcd6f894f62@gmail.com>
References: <20260613131002.144263-1-xose.vazquez@gmail.com>
	 <20260613131002.144263-3-xose.vazquez@gmail.com>
	 <7c28dd835abebb6f9e4ff69159e417cac323409f.camel@suse.com>
	 <994b66b1-68fb-4dd6-90e4-8fcd6f894f62@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Flag: NO
X-Spam-Score: -2.80
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
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid]
X-Spam-Level: 

On Mon, 2026-06-15 at 10:26 +0200, Xose Vazquez Perez wrote:
> On 6/15/26 10:16 AM, Martin Wilck wrote:
>=20
> > On Sat, 2026-06-13 at 15:09 +0200, Xose Vazquez Perez wrote:
> > > Selectors operate on the next individual I/O request rather
> > > than a "bunch" of I/O.
> >=20
> > This patch doesn't apply cleanly to any of my branches (master,
> > queue,
> > tip).
> That quote is from the patch series I sent earlier. You might have
> missed it:

No, but Ben had remarks on it, and I expected you to submit a v2.
So I am gathering that you want me to apply that series, and Ben's
points are addressed by the 2nd series on top. That wasn's obvious to
me, sorry.

Martin


>=20
> Xose Vazquez Perez (3):
> =C2=A0=C2=A0 multipath-tools: delete obsolete information from multipath.=
conf.5
> =C2=A0=C2=A0 multipath-tools: remove explicit width from .TP macros in
> multipath.conf.5
> =C2=A0=C2=A0 multipath-tools: remove explicit widths from macros in the
> remaining man pages
>=20
> =C2=A0 libmpathpersist/mpath_persistent_reserve_in.3 |=C2=A0=C2=A0 4 +-
> =C2=A0 .../mpath_persistent_reserve_out.3=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 4 +-
> =C2=A0 mpathpersist/mpathpersist.8.in=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 2 +-
> =C2=A0 multipath/multipath.8.in=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 |=C2=A0=C2=A0 6 +-
> =C2=A0 multipath/multipath.conf.5.in=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 135 +++++---=
-------
> ---
> =C2=A0 multipathd/multipathd.8.in=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 |=C2=A0=C2=A0 9 +-
> =C2=A0 6 files changed, 51 insertions(+), 109 deletions(-)
