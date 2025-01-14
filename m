Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E262080DA
	for <dm-devel@lists.linux.dev>; Tue, 14 Jan 2025 21:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736890654; cv=none; b=K8pLCNbkG2u2OZokMuwVDq8xhjTU1JHsAKHUNgILbzzxjS5vK6n3MwOoq1DVehxC83XdEEB9MITxCsXgxKzvylbDkG4rKVgRzwGQwQYPPBXs1lvVqfYySH6GCzxJTdH4S6LWQhDb8RzfN9+nqwko3mCUmS5Rnb+okp3LAbsvObU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736890654; c=relaxed/simple;
	bh=8KKQ22iWtMAPyUgr15YIpgWbb5ue7LuILcJwvFj+Z+A=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=k1MZNUSFtSU5NBW6i+jXJEXmoRSHnfGCFpojrZPHjaXkNPy15QZQ1hrvNNn51t5KwsPxr+htsJSpIqJ2Izo+jOSsZAPtQCoWTswh2Mfv0XNrWMM22zvP7X1Tm4WvGkCXd0Vh0PkePKbvCRXTK4PDxSHr/uN4jLrvkE3DBo9VDgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=VuOvIPJE; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=VuOvIPJE; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="VuOvIPJE";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="VuOvIPJE"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1DF351F44E;
	Tue, 14 Jan 2025 21:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1736890650; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8KKQ22iWtMAPyUgr15YIpgWbb5ue7LuILcJwvFj+Z+A=;
	b=VuOvIPJEUV2dYfNac/Xf5c0bXEmFvCsLVXfaKitD65Pjh0cNb1F8l1+MjDkbLRVd9OD0+F
	ePMm0EGU5ZJAAdRcBNrgDITyshIrAg1Qxmga7Oku+8s8FuG0zmKOllbseCkGHwfhQ67TJT
	n7CTN05R8dDJfVZja/SpH/cx/l/LNSI=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1736890650; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8KKQ22iWtMAPyUgr15YIpgWbb5ue7LuILcJwvFj+Z+A=;
	b=VuOvIPJEUV2dYfNac/Xf5c0bXEmFvCsLVXfaKitD65Pjh0cNb1F8l1+MjDkbLRVd9OD0+F
	ePMm0EGU5ZJAAdRcBNrgDITyshIrAg1Qxmga7Oku+8s8FuG0zmKOllbseCkGHwfhQ67TJT
	n7CTN05R8dDJfVZja/SpH/cx/l/LNSI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EC5581384C;
	Tue, 14 Jan 2025 21:37:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +WQROBnZhmewWwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Tue, 14 Jan 2025 21:37:29 +0000
Message-ID: <c640c8116e252d18fa89c4dfa6aa8ebb600e3c16.camel@suse.com>
Subject: Re: [PATCH v2 04/14] multipathd: quickly re-sync if a map is
 inconsistent
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, 
	dm-devel@lists.linux.dev
Date: Tue, 14 Jan 2025 22:37:24 +0100
In-Reply-To: <Z2SW3m9qq9ZBTLa7@redhat.com>
References: <20241211225909.298770-1-mwilck@suse.com>
	 <20241211225909.298770-5-mwilck@suse.com> <Z2SW3m9qq9ZBTLa7@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.2 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -4.30
X-Spam-Flag: NO

On Thu, 2024-12-19 at 16:57 -0500, Benjamin Marzinski wrote:
> On Wed, Dec 11, 2024 at 11:58:59PM +0100, Martin Wilck wrote:
> > After reading the kernel device-mapper table,
> > update_pathvec_from_dm()
> > sets the mpp->need_reload flag if an inconsistent state was found
> > (often a
> > path with wrong WWID). We expect reload_and_sync_map() to fix this
> > situation.
> > However, schedule a quick resync in this case, to be double-check
> > that the
> > inconsistency has been fixed.
>=20
> I'm not too sure about this. My biggest worry with handling
> mpp->need_reload in the checkerloop is what happens if for some
> reason
> multipathd and the kernel keep disagreeing on something. You would
> just
> keep reloading the device. That seems unlikely, so I've o.k. with
> handling it here, but if that does happen, this would make it much
> worse.=C2=A0 Instead of reloading every path check, you would reload ever=
y
> loop.
>=20
> If you do detect an inconsistent state, and trigger a reload, and the
> state is still inconsistent after that, I would argue that yet
> another
> reload is more likely to remain inconsistent than it is to fix the
> problem. So I would rather not speed it up.
>=20

Please see my reply to 03/14.

Martin

