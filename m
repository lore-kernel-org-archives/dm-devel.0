Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE31C3AC0CA
	for <dm-devel@lists.linux.dev>; Thu, 12 Mar 2026 19:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773343895; cv=none; b=Yt7stnZxp+d2gdftZhoRRX+X9IFfNGRJV8lI/mURNKeC2IcdkROn5kwAx9pfdL8My60b56JrG8lJVePlQCOSasjPPAMPsggOcAPr0kPlIVI5U1y5xlUl1/PVItXwru/1zJT825+onYxQTDhAgVdEJ+HT2o1s/L5Iw75GDk8c5lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773343895; c=relaxed/simple;
	bh=givuKbd0CXQz0dthcv5EunK27bFfg0z0c3zr3yrA8VI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=eHSXXB4YT60I1Q0gxdMOgcFWIuboQQdOriZNIOLorx/fQ/yHG/kBeK7MquwOyBBrgPF9W101bzlb5FFnCusLChRewf2gWNHD6ff0vyqpn5VWvBqMNWV8hrLcqCuz/R/D9gHW72zfXBoRLyBN9X8QwdfvQLetamBWNcXmvbm1lFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=hlRS5cp8; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=IX8dcY+d; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="hlRS5cp8";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="IX8dcY+d"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EC8195BE73;
	Thu, 12 Mar 2026 19:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1773343892; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=givuKbd0CXQz0dthcv5EunK27bFfg0z0c3zr3yrA8VI=;
	b=hlRS5cp84C6e4qbo99KDfFQch+8fYXA5xqCS3msX+ECVhTsQ9gp94hJ4M56HhEXBO1lQGp
	7PRVnOSpKJ4ZAcb7MywtefHqKXUYxkLVmREzBihlrdcFFuE38tWSO+mQG21p8fW5WC2gqr
	++vafYtWQlhm+o1CseJ5u2zXV3TcOUM=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1773343891; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=givuKbd0CXQz0dthcv5EunK27bFfg0z0c3zr3yrA8VI=;
	b=IX8dcY+dHV3Lkii8csaBQfiH316Ty7FYLsLc73/hyb4P8tROXkpKbCHmX2Wc72h0oj6W+R
	9X5iSB6rT60iJeZFVf66/7k4zdBaNUD78jc6j+tR9UTkrHc5YmfC6AVF9aG47xueqIa61a
	AAghtnciOiB+UrGkGPSu8OZVqqCu5Yc=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D0A8F40124;
	Thu, 12 Mar 2026 19:31:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id F7rGMZMUs2keMgAAD6G6ig
	(envelope-from <mwilck@suse.com>); Thu, 12 Mar 2026 19:31:31 +0000
Message-ID: <dc790696d57a889e5a3383abaab491f858561595.camel@suse.com>
Subject: Re: [PATCH 1/1] checkers: add alua path checker
From: Martin Wilck <mwilck@suse.com>
To: Brian Bunker <brian@purestorage.com>
Cc: bmarzins@redhat.com, dm-devel@lists.linux.dev
Date: Thu, 12 Mar 2026 20:31:31 +0100
In-Reply-To: <CAHZQxy+V5YSiHnB5sp8A_jbN_n1OQ633KiDeFa+vXQrNafHzDA@mail.gmail.com>
References: <20260312001642.53321-1-brian@purestorage.com>
	 <20260312001642.53321-2-brian@purestorage.com>
	 <8653507a25c02727037e7e8bad4b2178a9702040.camel@suse.com>
	 <CAHZQxy+V5YSiHnB5sp8A_jbN_n1OQ633KiDeFa+vXQrNafHzDA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid,suse.com:email]
X-Spam-Flag: NO

On Thu, 2026-03-12 at 11:38 -0700, Brian Bunker wrote:
> On Thu, Mar 12, 2026 at 9:32=E2=80=AFAM Martin Wilck <mwilck@suse.com> wr=
ote:
>=20
> > Hi Brian,
> >=20
> > On Wed, 2026-03-11 at 17:16 -0700, Brian Bunker wrote:
> > > Add an 'alua' path checker that uses RTPG to check path state,
> > > and an
> > > 'alua_cached' prioritizer that uses the checker's cached ALUA
> > > state.
> > >=20
> > > The checker maps ALUA Asymmetric Access States to path states:
> > > =C2=A0 - AAS_OPTIMIZED, AAS_NON_OPTIMIZED -> PATH_UP
> > > =C2=A0 - AAS_STANDBY -> PATH_GHOST
> > > =C2=A0 - AAS_TRANSITIONING -> PATH_PENDING
> > > =C2=A0 - AAS_UNAVAILABLE, AAS_OFFLINE -> PATH_DOWN
> > >=20
> > > The alua_cached prioritizer first checks for cached state from
> > > the
> > > alua
> > > checker, then falls back to sysfs, then to issuing RTPG directly.
> > > This
> > > maintains backward compatibility with other checker
> > > configurations.
> > >=20
> > > When detect_checker is enabled, the alua checker is auto-selected
> > > for
> > > devices with TPGS support. When the alua checker is in use,
> > > detect_prio
> > > auto-selects the alua_cached prioritizer.
> > >=20
> > > Signed-off-by: Brian Bunker <brian@purestorage.com>
> >=20
> > Thanks! Just a few remarks for now.
> >=20
> > Martin
> >=20
> > > ---
> > > =C2=A0libmultipath/Makefile=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=
=C2=A0 5 +
> > > =C2=A0libmultipath/checkers.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 1 +
> > > =C2=A0libmultipath/checkers.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 1 +
> > > =C2=A0libmultipath/checkers/Makefile=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 3 +-
> > > =C2=A0libmultipath/checkers/alua.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 426
> > > ++++++++++++++++++++++++
> > > =C2=A0libmultipath/checkers/alua.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 15 +
> > > =C2=A0libmultipath/prio.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 |=C2=A0=C2=A0 1 +
> > > =C2=A0libmultipath/prio.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 |=C2=A0=C2=A0 1 +
> > > =C2=A0libmultipath/prioritizers/Makefile=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 |=C2=A0=C2=A0 1 +
> > > =C2=A0libmultipath/prioritizers/alua_cached.c | 224 +++++++++++++
> > > =C2=A0libmultipath/prioritizers/alua_rtpg.c=C2=A0=C2=A0 |=C2=A0 12 +-
> > > =C2=A0libmultipath/prioritizers/alua_rtpg.h=C2=A0=C2=A0 |=C2=A0=C2=A0=
 1 +
> > > =C2=A0libmultipath/prioritizers/sysfs.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 |=C2=A0=C2=A0 7 +-
> > > =C2=A0libmultipath/propsel.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 20 =
+-
> > > =C2=A0libmultipath/structs.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=
=A0 2 +
> > > =C2=A0libmultipath/structs.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=
=A0 3 +
> > > =C2=A016 files changed, 716 insertions(+), 7 deletions(-)
> > > =C2=A0create mode 100644 libmultipath/checkers/alua.c
> > > =C2=A0create mode 100644 libmultipath/checkers/alua.h
> > > =C2=A0create mode 100644 libmultipath/prioritizers/alua_cached.c
> >=20

[...]

> > Instead of duplicating the threading implementation of the TUR
> > checker
> > here we should abstract it out and use the common framework by both
> > checkers (and others, too, maybe). This is a thing I've wanted to
> > do
> > for a long time. Maybe it's time to start doing it now.
> >=20
> I considered that sort of re-work, but I was concerned that changes
> adding to the existing checker might muddy the waters. There are
> certainly
> changes where helper functions could be extracted for both checkers
> to leverage them.
>=20

I didn't mean to say that _you_ have to do it. I see it as my job,
actually. The question is whether you are willing to wait until I get
to it...

[...]

> > > --- a/libmultipath/prioritizers/Makefile
> > > +++ b/libmultipath/prioritizers/Makefile
> > > @@ -13,6 +13,7 @@ LIBDEPS =3D -lmultipath -lmpathutil -lm -lpthread
> > > -
> > > lrt
> > > =C2=A0# If you add or remove a prioritizer also update
> > > multipath/multipath.conf.5
> > > =C2=A0LIBS =3D \
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 libprioalua.so \
> > > +=C2=A0=C2=A0=C2=A0=C2=A0 libprioalua_cached.so \
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 libprioconst.so \
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 libpriodatacore.so \
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 libprioemc.so \
> >=20
> > I think the below should go into a separate patch.
> >=20
> Can they be separated? The prioritizer's logic relies
> on the checker populating values for its decision.
>=20

First the checker, then the prioritizer?

> >=20
> > > diff --git a/libmultipath/prioritizers/alua_cached.c
> > > b/libmultipath/prioritizers/alua_cached.c
> > > new file mode 100644
> > > index 00000000..2ba5b2e7
> > > --- /dev/null
> > > +++ b/libmultipath/prioritizers/alua_cached.c
> > > @@ -0,0 +1,224 @@
> > > +/*
> > > + * (C) Copyright IBM Corp. 2004, 2005=C2=A0=C2=A0 All Rights Reserve=
d.
> > > + * Modified 2024 to support cached ALUA state from checker
> > > + *
> > > + * ALUA prioritizer that can use cached state from alua checker
> > > + * to avoid duplicate RTPG commands.
> > > + *
> > > + * This file is released under the GPL.
> >=20
> > Please add a proper license header.
> >=20
> > > + */
> > > +#include <stdio.h>
> > > +#include <string.h>
> > > +
> > > +#include <time.h>
> > > +
> > > +#include "debug.h"
> > > +#include "prio.h"
> > > +#include "structs.h"
> > > +#include "checkers.h"
> > > +#include "discovery.h"
> > > +
> > > +#include "alua.h"
> > > +
> > > +#define ALUA_PRIO_NOT_SUPPORTED=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 1
> > > +#define ALUA_PRIO_RTPG_FAILED=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 2
> > > +#define ALUA_PRIO_GETAAS_FAILED=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 3
> > > +#define ALUA_PRIO_TPGS_FAILED=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 4
> > > +#define ALUA_PRIO_NO_INFORMATION=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 5
> > > +#define ALUA_PRIO_CACHED_STALE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 6
> > > +
> > > +/* Maximum age of cached ALUA state in seconds */
> > > +#define ALUA_CACHE_MAX_AGE_SECS=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 5
> > > +
> > > +static const char * aas_string[] =3D {
> > > +=C2=A0=C2=A0=C2=A0=C2=A0 [AAS_OPTIMIZED]=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 =3D "active/optimized",
> > > +=C2=A0=C2=A0=C2=A0=C2=A0 [AAS_NON_OPTIMIZED]=C2=A0=C2=A0=C2=A0=C2=A0=
 =3D "active/non-optimized",
> > > +=C2=A0=C2=A0=C2=A0=C2=A0 [AAS_STANDBY]=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D "standby",
> > > +=C2=A0=C2=A0=C2=A0=C2=A0 [AAS_UNAVAILABLE]=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 =3D "unavailable",
> > > +=C2=A0=C2=A0=C2=A0=C2=A0 [AAS_LBA_DEPENDENT]=C2=A0=C2=A0=C2=A0=C2=A0=
 =3D "logical block dependent",
> > > +=C2=A0=C2=A0=C2=A0=C2=A0 [AAS_RESERVED]=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D "ARRAY BUG: invalid TPGs state!",
> > > +=C2=A0=C2=A0=C2=A0=C2=A0 [AAS_OFFLINE]=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D "offline",
> > > +=C2=A0=C2=A0=C2=A0=C2=A0 [AAS_TRANSITIONING]=C2=A0=C2=A0=C2=A0=C2=A0=
 =3D "transitioning between states",
> > > +};
> >=20
> > We shouldn't duplicate the definition of these constants.
>=20
> This was somewhat intentional though not efficient. I will
> do better with leveraging in the next patch.
>=20
>=20

OK.

Thanks
Martin


