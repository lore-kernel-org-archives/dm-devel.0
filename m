Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDFB8653
	for <dm-devel@lists.linux.dev>; Tue, 18 Feb 2025 00:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739837118; cv=none; b=JqSU+ETE2D5Qlog/0mnUKfB+fCjWOSvJq5Kmx3rVUihNMfFHUn22TpffsHYHcuOkMRMzWyhbExrALPDFHx8iizE52YH+QxcFsHNGG3B0kA8oKLMsHixJIdkOQ7cTQ4dehnI5+2uzqX01FgvC0lClZ3uWoNIOGQHL6IZFeWYL0nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739837118; c=relaxed/simple;
	bh=fKMNDtPgBWzewNP09wt6qdo5POjU4+tmK81tOVQYEtk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tAFnQQWTgoLfALSloCd8ccFF0PmRfN62VcCjEStTiJuLCTcDMRH0KgyER4dfdjiXGJoytJ6vaW8xcoe17JnGyuRBdS0WFAUNsoJ9m79F6ns8POX1EHfYOMDZ0hyd7cH2uNXWKnaLJJoeUBgfOlsKsZlEsMYHJUpnM/ObloaoezA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=FDq3qyY8; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=FDq3qyY8; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="FDq3qyY8";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="FDq3qyY8"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B709A2116B;
	Tue, 18 Feb 2025 00:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1739837113; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2WCri/s0M23ZNlWeq5gSIF/n/r8w36fuAV/XIN/F4M8=;
	b=FDq3qyY8traJqj+dTT+eI7AiLnChTkfCzTcKxA7cE6ID2WxDCgef9OoeHfuRtcpeJj46xg
	LVw0r9CxnNM1LDYwG/2k30pHfMdwGAcz0jhW6CZj3guD6S6801KsfhGMMW76O3DOgi45DS
	Ay8Bp+3+4ZupTV8t2kxPbJ2sNe3JaVM=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1739837113; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2WCri/s0M23ZNlWeq5gSIF/n/r8w36fuAV/XIN/F4M8=;
	b=FDq3qyY8traJqj+dTT+eI7AiLnChTkfCzTcKxA7cE6ID2WxDCgef9OoeHfuRtcpeJj46xg
	LVw0r9CxnNM1LDYwG/2k30pHfMdwGAcz0jhW6CZj3guD6S6801KsfhGMMW76O3DOgi45DS
	Ay8Bp+3+4ZupTV8t2kxPbJ2sNe3JaVM=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 815F2136CF;
	Tue, 18 Feb 2025 00:05:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dDzuHbnOs2dkTAAAD6G6ig
	(envelope-from <mwilck@suse.com>); Tue, 18 Feb 2025 00:05:13 +0000
Message-ID: <1679e707f126d96229353865e1185f85b638ebaf.camel@suse.com>
Subject: Re: [PATCH v3 08/10] libmpathcmd: try both abstract and pathname
 sockets
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, Alice Frosi
	 <afrosi@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	dm-devel@lists.linux.dev
Date: Tue, 18 Feb 2025 01:05:12 +0100
In-Reply-To: <Z7O-zzUk0tP1Tv-N@redhat.com>
References: <20250214221011.136762-1-mwilck@suse.com>
	 <20250214221011.136762-9-mwilck@suse.com> <Z7O-zzUk0tP1Tv-N@redhat.com>
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
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
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
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid,suse.com:email]
X-Spam-Flag: NO
X-Spam-Level: 

On Mon, 2025-02-17 at 17:57 -0500, Benjamin Marzinski wrote:
> On Fri, Feb 14, 2025 at 11:10:09PM +0100, Martin Wilck wrote:
> > When connecting to the multipathd socket, try the pathname socket
> > first, then the abstract socket. Fail only if both connection
> > attempts
> > fail.
> >=20
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> > =C2=A0libmpathcmd/mpath_cmd.c | 13 ++++++++++---
> > =C2=A01 file changed, 10 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/libmpathcmd/mpath_cmd.c b/libmpathcmd/mpath_cmd.c
> > index c7cf954..ba5bb31 100644
> > --- a/libmpathcmd/mpath_cmd.c
> > +++ b/libmpathcmd/mpath_cmd.c
> > @@ -102,7 +102,10 @@ int mpath_connect__(int nonblocking)
> > =C2=A0	size_t len;
> > =C2=A0	struct sockaddr_un addr;
> > =C2=A0	int flags =3D 0;
> > +	const char *names[2] =3D {PATHNAME_SOCKET, ABSTRACT_SOCKET};
> > +	int name_idx =3D 0;
> > =C2=A0
> > +retry:
> > =C2=A0	fd =3D socket(AF_LOCAL, SOCK_STREAM, 0);
> > =C2=A0	if (fd =3D=3D -1)
> > =C2=A0		return -1;
> > @@ -113,13 +116,17 @@ int mpath_connect__(int nonblocking)
> > =C2=A0			(void)fcntl(fd, F_SETFL,
> > flags|O_NONBLOCK);
> > =C2=A0	}
> > =C2=A0
> > -	len =3D mpath_fill_sockaddr__(&addr, ABSTRACT_SOCKET);
> > +	len =3D mpath_fill_sockaddr__(&addr, names[name_idx]);
> > =C2=A0	if (connect(fd, (struct sockaddr *)&addr, len) =3D=3D -1) {
> > =C2=A0		int err =3D errno;
> > =C2=A0
> > =C2=A0		close(fd);
> > -		errno =3D err;
> > -		return -1;
> > +		if (err =3D=3D ECONNREFUSED && ++name_idx =3D=3D 1)
>=20
> Most of the connect() return codes are things that could presumably
> be
> fixed by trying a different address (not the errors related to a
> problem
> with sockfd, but we just created the socket, so those seem pretty
> impossible). Is there a reason why we don't just retry on any error?

I've done some testing and when I was using a wrong address name, I=20
always got ECONNREFUSED. So I thought it might be cleaner to not
blindly assume retrying might help for other error codes. But I can see
your point, it's just a single retry and can't really hurt to just try
the other socket name.

I'll remove that condition.

Regards
Martin


