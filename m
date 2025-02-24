Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B2A1A2397
	for <dm-devel@lists.linux.dev>; Mon, 24 Feb 2025 21:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740433770; cv=none; b=FkYHKMzrlD/Du6V2FCJ1u0Rkk6afz2PJW7F63gBVzaa3tLJXuszIfy7seiEFMJ7KPwYpDTvDcEhmkHoH+05IBjrusr/P5IkuYXq1fZo1JOpfGMcoJPGlOEItdPqNoi6dfL54NWegw4WlU+tQCRanHXGM3snGAc/yu/MnERCneEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740433770; c=relaxed/simple;
	bh=KCGI8Bnai1dk0eVxTgL7CFb9br1XQ3Qkk4898Kq1a6w=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RrRkGrt7uQ8yjx5Fk/0q4MexjLq+0L2MmRGJKkEm5jPP8DmiAkLVxlhZQIoTJWMrpw1GYnn+sAYubzDcfG8pf/4eV8tO4t3qY+ZBe61UutBjHvZ+psZLw/qeBwu/CTbbnYfeKP+aOv75D64hVrKWjkjx8vwaTpvF6KLQd7adAKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=LWD7Ixq4; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=LWD7Ixq4; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="LWD7Ixq4";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="LWD7Ixq4"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 858B32117A;
	Mon, 24 Feb 2025 21:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1740433766; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eOyIi/z+ya+m76/JMC12tQPgO+s6n7qyU7DDlBmO+qw=;
	b=LWD7Ixq46otwN5N6bcZMpKf3HgzjH/eRrdis1xIc1+s7OyoM3mYvDjR1370kQK/Y0HKveC
	OeLP5EFC4FIUaNAsxVf9ghKzoDO+0z0ylrS1q73Srt9QV6RYEwir0qLDYzbzAkxgKr2V1Z
	VO0rXUtxNibD8hTU0QGYULgt7G/ZAAw=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1740433766; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eOyIi/z+ya+m76/JMC12tQPgO+s6n7qyU7DDlBmO+qw=;
	b=LWD7Ixq46otwN5N6bcZMpKf3HgzjH/eRrdis1xIc1+s7OyoM3mYvDjR1370kQK/Y0HKveC
	OeLP5EFC4FIUaNAsxVf9ghKzoDO+0z0ylrS1q73Srt9QV6RYEwir0qLDYzbzAkxgKr2V1Z
	VO0rXUtxNibD8hTU0QGYULgt7G/ZAAw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 52DA913707;
	Mon, 24 Feb 2025 21:49:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3UamEmbpvGdGTwAAD6G6ig
	(envelope-from <mwilck@suse.com>); Mon, 24 Feb 2025 21:49:26 +0000
Message-ID: <bd1ae3c37733c3ad90236faf6ef7dcf0b8bf950b.camel@suse.com>
Subject: Re: [PATCH v4 09/10] libmpathcmd: honor MULTIPATH_SOCKET_NAME
 environment variable
From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>, 
	dm-devel@lists.linux.dev, Alice Frosi <afrosi@redhat.com>, Paolo Bonzini
	 <pbonzini@redhat.com>
Date: Mon, 24 Feb 2025 22:49:25 +0100
In-Reply-To: <Z7yt0vTRWUa1Bj3M@redhat.com>
References: <20250221204108.70631-1-mwilck@suse.com>
	 <20250221204108.70631-3-mwilck@suse.com> <Z7yt0vTRWUa1Bj3M@redhat.com>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email]
X-Spam-Flag: NO
X-Spam-Level: 

On Mon, 2025-02-24 at 12:35 -0500, Benjamin Marzinski wrote:
> On Fri, Feb 21, 2025 at 09:41:08PM +0100, Martin Wilck wrote:
> > In systemd installments, users can already override the socket
> > names
> > that systemd listens on. With this patch, clients using libmpathcmd
> > can be customized to use a non-standard socket by setting an
> > environment
> > variable.
> >=20
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> > =C2=A0libmpathcmd/mpath_cmd.c | 7 +++++--
> > =C2=A01 file changed, 5 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/libmpathcmd/mpath_cmd.c b/libmpathcmd/mpath_cmd.c
> > index 83cb6ad..5a23236 100644
> > --- a/libmpathcmd/mpath_cmd.c
> > +++ b/libmpathcmd/mpath_cmd.c
> > @@ -20,6 +20,7 @@
> > =C2=A0#include <stdlib.h>
> > =C2=A0#include <unistd.h>
> > =C2=A0#include <stdio.h>
> > +#include <stdlib.h>
> > =C2=A0#include <sys/types.h>
> > =C2=A0#include <sys/socket.h>
> > =C2=A0#include <sys/un.h>
> > @@ -104,6 +105,7 @@ int mpath_connect__(int nonblocking)
> > =C2=A0	int flags =3D 0;
> > =C2=A0	const char *const names[2] =3D {PATHNAME_SOCKET,
> > ABSTRACT_SOCKET};
> > =C2=A0	int name_idx =3D 0;
> > +	const char *env_name =3D getenv("MULTIPATH_SOCKET_NAME"),
> > *name;
> > =C2=A0
> > =C2=A0retry:
> > =C2=A0	fd =3D socket(AF_LOCAL, SOCK_STREAM, 0);
> > @@ -116,12 +118,13 @@ retry:
> > =C2=A0			(void)fcntl(fd, F_SETFL,
> > flags|O_NONBLOCK);
> > =C2=A0	}
> > =C2=A0
> > -	len =3D mpath_fill_sockaddr__(&addr, names[name_idx]);
> > +	name =3D env_name ? env_name : names[name_idx];
> > +	len =3D mpath_fill_sockaddr__(&addr, name);
> > =C2=A0	if (connect(fd, (struct sockaddr *)&addr, len) =3D=3D -1) {
> > =C2=A0		int err =3D errno;
> > =C2=A0
> > =C2=A0		close(fd);
> > -		if (++name_idx =3D=3D 1)
>=20
> You lost a "+" from ++name_idx
>=20

Ouch, thanks a bunch for spotting that.

Martin
