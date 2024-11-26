Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF4B1BE238
	for <dm-devel@lists.linux.dev>; Tue, 26 Nov 2024 11:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732619710; cv=none; b=ALgEH7FT3tofnhs1uGpIOJFwkpvt2l+boNsYvYr2ZSbRoAtyyvRfx85SBL6oA51I4CgT7GOul/YSu2xs6+IYEpa/sKPcGUeD1DjEwnoc30asR8zWwVMgoJd+lEZkcpj8gorm3XRU7XWTd6J2YV3alXR3Fwh/rREbGpCUp6OcC3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732619710; c=relaxed/simple;
	bh=EtrqKF+pIwoU7qMO/6f5ENH4+DNh7LLMmt/XBhOFxtg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Uo4WjIf7aZmf0urRMLBYA2fMG7Q4UVAjvEOU/pQdVqAaOIltZxKMUypnizsf8gPB6K5V5rd9FYRWXT5jrxDJ9ALek269zwf2q2CN1N4bLJK8gr6oYgdgyR6UPxewBvxhkfyOfrulQwxbtFq1jLk1OHWRgEmjMhErBMyA0Au/zu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=f7fDLpzG; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=f7fDLpzG; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="f7fDLpzG";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="f7fDLpzG"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 99F3A2116E;
	Tue, 26 Nov 2024 11:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1732619706; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EtrqKF+pIwoU7qMO/6f5ENH4+DNh7LLMmt/XBhOFxtg=;
	b=f7fDLpzGpXeX4fnNq/kIshJjoaTaIoumBuLXIePZykJLG9HQSurMgkBw3YjSLtcXo1Z1ZN
	KFqI2N2cgQzvZco8vbNH6BOhY7TMo4OAT33I0wXFVQM6nQoophPmib5pIvmnCuwEO4hIHA
	sDOUujQ8gL8UJ1rMcnOF+OyS6ebNF8Y=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=f7fDLpzG
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1732619706; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EtrqKF+pIwoU7qMO/6f5ENH4+DNh7LLMmt/XBhOFxtg=;
	b=f7fDLpzGpXeX4fnNq/kIshJjoaTaIoumBuLXIePZykJLG9HQSurMgkBw3YjSLtcXo1Z1ZN
	KFqI2N2cgQzvZco8vbNH6BOhY7TMo4OAT33I0wXFVQM6nQoophPmib5pIvmnCuwEO4hIHA
	sDOUujQ8gL8UJ1rMcnOF+OyS6ebNF8Y=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 745AD13890;
	Tue, 26 Nov 2024 11:15:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id v8/YGrqtRWcXNgAAD6G6ig
	(envelope-from <mwilck@suse.com>); Tue, 26 Nov 2024 11:15:06 +0000
Message-ID: <6cd4e709400b0169d745a4f9a25159bd47c44904.camel@suse.com>
Subject: Re: [PATCH 2/3] libmultipath: pgcmp(): compare number of paths
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, 
	dm-devel@lists.linux.dev
Date: Tue, 26 Nov 2024 12:15:06 +0100
In-Reply-To: <Z0Tm7AJeGdZs5WIS@redhat.com>
References: <20241125143224.51934-1-mwilck@suse.com>
	 <20241125143224.51934-3-mwilck@suse.com> <Z0Tm7AJeGdZs5WIS@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Rspamd-Queue-Id: 99F3A2116E
X-Spam-Score: -4.51
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:mid,suse.com:dkim];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

On Mon, 2024-11-25 at 16:06 -0500, Benjamin Marzinski wrote:
> On Mon, Nov 25, 2024 at 03:32:23PM +0100, Martin Wilck wrote:
> > pathcmp() makes sure that all paths in pgp have a match in cpgp,
> > but not
> > vice-versa. Check the number of paths, too.
>=20
> This looks fine. But looking at it made we a nervous about cpgp->id.=C2=
=A0
> We
> only calculate that in pgcmp() (and just for mpp, not cmpp) and in
> disassemble_map(). But we clearly can have pathgroup changes after
> that,
> as the last patch has shown. To be safe, we should either skip the
> whole
> pgp->id thing (it's not a huge time savings) or recalculate it for
> all
> of cmpp's path groups before we start the loops in pgcmp().

Agreed. Like before, I am wondering if we should drop pgp->id in 0.11.0
already or postpone.

IMO my patch is a valid fix for a minor issue which needs redesign in a
future release.

Martin

