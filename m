Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270F93EDAC9
	for <dm-devel@lists.linux.dev>; Wed, 27 May 2026 10:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779878610; cv=none; b=SeyDVgfmlZ+BzYc3i4cBB3zqrINrUiA31Y96aYS6j2uWvK9VHMpDDDDTb5AAsje6nu2mlU3QIL0JXHF/H47Meu1qRLVETfYi2NwuDk0qfDM+Y8pIMwy+KmOU68MoN+uW1WATkJEcd5HtnVJzCg9kdZU4cNIUD+p5cZtRQztLjvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779878610; c=relaxed/simple;
	bh=CL5xoxAXq6uxYyvUnZyiUruH0Ru3ObPYGSQCqX+BjEs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WbWoeYQsY2EyC6QgARKi+l9MVGKrYHkT9pEvi5UO1LVxbNEWxHe3R0r/o1Z6m82jJAtbTI39CK8hZcanOmmfi8IHZkVbxFtkz7srk7JM+NtFwbY2FemCwYdYIy1C+ExawbhFYtleEgsFqX8h7Y/bdRZdcEUW/DBKlU2vKtjRoC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7ABF56A956;
	Wed, 27 May 2026 10:43:27 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5007B5A7B6;
	Wed, 27 May 2026 10:43:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id v/xqEs/KFmqCewAAD6G6ig
	(envelope-from <mwilck@suse.com>); Wed, 27 May 2026 10:43:27 +0000
Message-ID: <68c656ed5e6db979dd03587e5274f9cd50e29ef9.camel@suse.com>
Subject: Re: [PATCH v2 04/19] libmpathutil: add implementation of generic
 shared pointer
From: Martin Wilck <mwilck@suse.com>
To: Hannes Reinecke <hare@suse.de>, Christophe Varoqui	
 <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>,
  Brian Bunker <brian@purestorage.com>, dm-devel@lists.linux.dev
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>
Date: Wed, 27 May 2026 12:43:26 +0200
In-Reply-To: <b4bfe78c-3a19-4702-a663-2735f86d4a56@suse.de>
References: <20260522164415.846589-1-mwilck@suse.com>
	 <20260522164415.846589-5-mwilck@suse.com>
	 <b4bfe78c-3a19-4702-a663-2735f86d4a56@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.1 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[];
	TAGGED_RCPT(0.00)[]
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Queue-Id: 7ABF56A956
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 
X-Rspamd-Action: no action

Hi Hannes,

On Wed, 2026-05-27 at 11:28 +0200, Hannes Reinecke wrote:
> On 5/22/26 18:44, Martin Wilck wrote:
> > Add a set of simple functions to handle refcounted pointers.
> >=20
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> > =C2=A0 libmpathutil/libmpathutil.version |=C2=A0 7 +++++
> > =C2=A0 libmpathutil/util.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 45
> > ++++++++++++++++++++++++++++---
> > =C2=A0 libmpathutil/util.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 5 ++++
> > =C2=A0 3 files changed, 53 insertions(+), 4 deletions(-)
> >=20
> That really looks like the Hazard pointers from Paul McK and Mathieu=20
> Desnoyers. Maybe have a look and see if you cannot re-use the
> approach here.

Thanks for the hint. Hazard pointers are a far more advanced
complicated concept, focussed on cache efficiency and performance.
That's important for the kernel, but it would be over-engineered for
libmultipath, IMO. We just need to make sure that the pointer is not
freed as long as it's still referenced somewhere.

AFAICS, Mathieu's code is targeted at the kernel. We could consider
using some generic user-space hazard pointer implementation for
libmultipath if there is something we could take off the shelf (like,
as a part of liburcu, which we're using anyway). But I don't see a
strong need for it. There's no doubt that libmultipath is inefficient
in many ways, but it isn't CPU-intensive, and thus correctness and
simplicity matter more than efficiency.

>=20
> > diff --git a/libmpathutil/libmpathutil.version
> > b/libmpathutil/libmpathutil.version
> > index c69120d..51594ad 100644
> > --- a/libmpathutil/libmpathutil.version
> > +++ b/libmpathutil/libmpathutil.version
> > @@ -194,3 +194,10 @@ global:
> > =C2=A0 local:
> > =C2=A0=C2=A0	*;
> > =C2=A0 };
> > +
> > +LIBMPATHUTIL_6.1 {
> > +global:
> > +	alloc_shared_ptr;
> > +	get_shared_ptr;
> > +	put_shared_ptr;
> > +} LIBMPATHUTIL_6.0;
> > diff --git a/libmpathutil/util.c b/libmpathutil/util.c
> > index 23a9797..3c623ec 100644
> > --- a/libmpathutil/util.c
> > +++ b/libmpathutil/util.c
> > @@ -12,15 +12,13 @@
> > =C2=A0 #include <dirent.h>
> > =C2=A0 #include <unistd.h>
> > =C2=A0 #include <errno.h>
> > +#include <urcu/uatomic.h>
> > =C2=A0 #include "mt-udev-wrap.h"
> > =C2=A0=20
> > =C2=A0 #include "util.h"
> > =C2=A0 #include "debug.h"
> > -#include "checkers.h"
> > =C2=A0 #include "vector.h"
> > -#include "structs.h"
> > -#include "config.h"
> > -#include "log.h"
> > +#include "list.h"
> > =C2=A0=20
> > =C2=A0 size_t
> > =C2=A0 strchop(char *str)
> > @@ -384,3 +382,42 @@ void cleanup_udev_device(struct udev_device
> > **udd)
> > =C2=A0=C2=A0	if (*udd)
> > =C2=A0=C2=A0		udev_device_unref(*udd);
> > =C2=A0 }
> > +
> > +struct shared_ptr {
> > +	long refcnt;
> > +	void (*destructor)(void *);
> > +	char __attribute__((aligned(sizeof(void *)))) ptr[];
> > +};
> > +
> > +void *alloc_shared_ptr(size_t size, void (*destructor)(void *))
> > +{
> > +	struct shared_ptr *sp =3D malloc(sizeof(*sp) + size);
> > +
> > +	if (!sp)
> > +		return NULL;
> > +	uatomic_set(&sp->refcnt, 1);
> > +	sp->destructor =3D destructor;
> > +	return sp->ptr;
> > +}
> > +
> > +void get_shared_ptr(void *ptr)
> > +{
> > +	struct shared_ptr *sp =3D container_of(ptr, struct
> > shared_ptr, ptr);
> > +
> > +	if (uatomic_add_return(&sp->refcnt, 1) < 0)
> > +		condlog(0, "%s: refcount overflow", __func__);
> > +}
> > +
> > +void put_shared_ptr(void *ptr)
> > +{
> > +	struct shared_ptr *sp;
> > +
> > +	if (!ptr)
> > +		return;
> > +	sp =3D container_of(ptr, struct shared_ptr, ptr);
> > +	if (uatomic_sub_return(&sp->refcnt, 1) =3D=3D 0) {
> > +		if (sp->destructor)
> > +			sp->destructor(ptr);
> > +		free(sp);
> > +	}
> > +}
>=20
> I _think_ the could be implemented better using RCU primitives;
> in the end, what you really care about is whether the pointer is
> valid (9which is what RCU provides).

What we want to achieve is just that (the destructor is called and) the
memory is freed when the last reference is dropped, but no sooner. It's
the same concept that the kernel uses for refcounted objects all over
the place.

> Or indeed use the hazard pointer approach, and count the number
> of RCU references to that object ...

Like I said, I'd like to keep it simple. The basic refcounting
that this patch implements does the job for libmultipath.=C2=A0

I just created this admittedly simple abstraction because the multipath
code was using reference counters in multiple places, and I wanted to
consolidate the code and add a unit test for it. It's not the purpose
of this patch set to optimize for performance. If we want to optimize
it, the API is simple enough that we can substitute the implementation
easily with something more efficient in the future.
>=20

> > diff --git a/libmpathutil/util.h b/libmpathutil/util.h
> > index aed1bc1..ffbb182 100644
> > --- a/libmpathutil/util.h
> > +++ b/libmpathutil/util.h
> > @@ -160,4 +160,9 @@ void cleanup_charp(char **p);
> > =C2=A0 void cleanup_ucharp(unsigned char **p);
> > =C2=A0 void cleanup_udev_device(struct udev_device **udd);
> > =C2=A0 void cleanup_bitfield(union bitfield **p);
> > +
> > +void *alloc_shared_ptr(size_t size, void (*destructor)(void *));
> > +void get_shared_ptr(void *ptr);
> > +void put_shared_ptr(void *ptr);
> > +
> > =C2=A0 #endif /* UTIL_H_INCLUDED */
>=20
> ... or just leave it as it is if the approach is to complex.
> I doubt it's time-critical.
>=20

Exactly. I'd like to see what Ben and others think.

Regards,
Martin




> Cheers,
>=20
> Hannes
