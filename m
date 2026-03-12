Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C83B212D7C
	for <dm-devel@lists.linux.dev>; Thu, 12 Mar 2026 16:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773333171; cv=none; b=D96/wgNpB3St7uoNilBB/SVOVxeYu8vRyB8kiIMhiilLQlI8s5F55TeNOY2+dHdq6p8z4a4g64QKZK2oOoEY0kPpdEr0lQ/cOf7YA5qmR+rRCbiB9nej3hMM5QRhSnR9ojpHQo1S/fjZgU9/QVDfNJd0YsdiFNx0/3166Agxd64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773333171; c=relaxed/simple;
	bh=HW0TkeZvRknBu5/QcKM7Nfjn/rPkDVP3/XGQIaXN6iw=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PTJ15v/RsU2QuQaZ4imj799NHm3+uwkGbyin5QflSw86JCII8nSPhJo5ttXIXcDcUeteyqGXpbRxbhF3M7wJ9gV+1jZQ+CNKKi+iiXEBkwkJtGmysDSOBuH40MB3TUqKp+IrYA3521zfBbftXfypGDdo26vGw3Ag86KQuKJmY2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=b7KedUmG; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=b7KedUmG; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="b7KedUmG";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="b7KedUmG"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 90E5D5C04F;
	Thu, 12 Mar 2026 16:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1773333166; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gNQ0NTdexzTN064QlP3UYlLNRLYojPLT7ANIr94mVLk=;
	b=b7KedUmGLJn5mz63us4/dC/87mBUcNXNvp9OCjJfLrV5+RMLE5dpj5FPEVaNgEIjyXjGAk
	OzBAmjhcl1nTvA0KOUdRL5kERRAF0YUSLEs7AtKOOWANOxgzHomWf/AyGrC7gGJey3vzYL
	Hi1YVZYXlFQtso48ftYc+5umZWg5BFE=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1773333166; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gNQ0NTdexzTN064QlP3UYlLNRLYojPLT7ANIr94mVLk=;
	b=b7KedUmGLJn5mz63us4/dC/87mBUcNXNvp9OCjJfLrV5+RMLE5dpj5FPEVaNgEIjyXjGAk
	OzBAmjhcl1nTvA0KOUdRL5kERRAF0YUSLEs7AtKOOWANOxgzHomWf/AyGrC7gGJey3vzYL
	Hi1YVZYXlFQtso48ftYc+5umZWg5BFE=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 72CF440073;
	Thu, 12 Mar 2026 16:32:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id u8nrGq7qsmlSeAAAD6G6ig
	(envelope-from <mwilck@suse.com>); Thu, 12 Mar 2026 16:32:46 +0000
Message-ID: <8653507a25c02727037e7e8bad4b2178a9702040.camel@suse.com>
Subject: Re: [PATCH 1/1] checkers: add alua path checker
From: Martin Wilck <mwilck@suse.com>
To: Brian Bunker <brian@purestorage.com>, bmarzins@redhat.com, 
	dm-devel@lists.linux.dev
Date: Thu, 12 Mar 2026 17:32:46 +0100
In-Reply-To: <20260312001642.53321-2-brian@purestorage.com>
References: <20260312001642.53321-1-brian@purestorage.com>
	 <20260312001642.53321-2-brian@purestorage.com>
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
	NEURAL_HAM_SHORT(-0.20)[-1.000];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO

Hi Brian,

On Wed, 2026-03-11 at 17:16 -0700, Brian Bunker wrote:
> Add an 'alua' path checker that uses RTPG to check path state, and an
> 'alua_cached' prioritizer that uses the checker's cached ALUA state.
>=20
> The checker maps ALUA Asymmetric Access States to path states:
> =C2=A0 - AAS_OPTIMIZED, AAS_NON_OPTIMIZED -> PATH_UP
> =C2=A0 - AAS_STANDBY -> PATH_GHOST
> =C2=A0 - AAS_TRANSITIONING -> PATH_PENDING
> =C2=A0 - AAS_UNAVAILABLE, AAS_OFFLINE -> PATH_DOWN
>=20
> The alua_cached prioritizer first checks for cached state from the
> alua
> checker, then falls back to sysfs, then to issuing RTPG directly.
> This
> maintains backward compatibility with other checker configurations.
>=20
> When detect_checker is enabled, the alua checker is auto-selected for
> devices with TPGS support. When the alua checker is in use,
> detect_prio
> auto-selects the alua_cached prioritizer.
>=20
> Signed-off-by: Brian Bunker <brian@purestorage.com>

Thanks! Just a few remarks for now.

Martin

> ---
> =C2=A0libmultipath/Makefile=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=
=A0 5 +
> =C2=A0libmultipath/checkers.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 1 +
> =C2=A0libmultipath/checkers.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 1 +
> =C2=A0libmultipath/checkers/Makefile=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 3 +-
> =C2=A0libmultipath/checkers/alua.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 426
> ++++++++++++++++++++++++
> =C2=A0libmultipath/checkers/alua.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 15 +
> =C2=A0libmultipath/prio.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=
=C2=A0=C2=A0 1 +
> =C2=A0libmultipath/prio.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=
=C2=A0=C2=A0 1 +
> =C2=A0libmultipath/prioritizers/Makefile=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=
=C2=A0=C2=A0 1 +
> =C2=A0libmultipath/prioritizers/alua_cached.c | 224 +++++++++++++
> =C2=A0libmultipath/prioritizers/alua_rtpg.c=C2=A0=C2=A0 |=C2=A0 12 +-
> =C2=A0libmultipath/prioritizers/alua_rtpg.h=C2=A0=C2=A0 |=C2=A0=C2=A0 1 +
> =C2=A0libmultipath/prioritizers/sysfs.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 |=C2=A0=C2=A0 7 +-
> =C2=A0libmultipath/propsel.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 20 +-
> =C2=A0libmultipath/structs.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 2 +
> =C2=A0libmultipath/structs.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 3 +
> =C2=A016 files changed, 716 insertions(+), 7 deletions(-)
> =C2=A0create mode 100644 libmultipath/checkers/alua.c
> =C2=A0create mode 100644 libmultipath/checkers/alua.h
> =C2=A0create mode 100644 libmultipath/prioritizers/alua_cached.c
>=20
> diff --git a/libmultipath/Makefile b/libmultipath/Makefile
> index 85767ab4..379f4d02 100644
> --- a/libmultipath/Makefile
> +++ b/libmultipath/Makefile
> @@ -38,6 +38,11 @@ nvme-lib.o: nvme-lib.c nvme-ioctl.c nvme-ioctl.h
> =C2=A0dict.o:	dict.c
> =C2=A0	$(Q)$(CC) $(CPPFLAGS) $(CFLAGS) -Wno-unused-parameter -c -o
> $@ $<
> =C2=A0
> +# checkers/alua.o needs to find headers in parent directory
> +checkers/alua.o: checkers/alua.c
> +	@echo building $@ because of $?
> +	$(Q)$(CC) $(CPPFLAGS) $(CFLAGS) -I. -c -o $@ $<
> +
> =C2=A0make_static =3D $(shell sed '/^static/!s/^\([a-z]\{1,\} \)/static \=
1/'
> <$1 >$2)
> =C2=A0
> =C2=A0nvme-ioctl.c: nvme/nvme-ioctl.c
> diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
> index bb6ad1ee..21aa52d4 100644
> --- a/libmultipath/checkers.c
> +++ b/libmultipath/checkers.c
> @@ -461,6 +461,7 @@ int init_checkers(void)
> =C2=A0		EMC_CLARIION,
> =C2=A0		READSECTOR0,
> =C2=A0		CCISS_TUR,
> +		ALUA_RTPG,
> =C2=A0	};
> =C2=A0	unsigned int i;
> =C2=A0
> diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
> index a969e7d1..2905f3fc 100644
> --- a/libmultipath/checkers.h
> +++ b/libmultipath/checkers.h
> @@ -98,6 +98,7 @@ enum path_check_state {
> =C2=A0#define EMC_CLARIION "emc_clariion"
> =C2=A0#define READSECTOR0=C2=A0 "readsector0"
> =C2=A0#define CCISS_TUR=C2=A0=C2=A0=C2=A0 "cciss_tur"
> +#define ALUA=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "alua"
> =C2=A0#define NONE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "none"
> =C2=A0#define INVALID=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "invalid"
> =C2=A0
> diff --git a/libmultipath/checkers/Makefile
> b/libmultipath/checkers/Makefile
> index 6f7cfb95..dfdd13a1 100644
> --- a/libmultipath/checkers/Makefile
> +++ b/libmultipath/checkers/Makefile
> @@ -17,7 +17,8 @@ LIBS=3D \
> =C2=A0	libcheckdirectio.so \
> =C2=A0	libcheckemc_clariion.so \
> =C2=A0	libcheckhp_sw.so \
> -	libcheckrdac.so
> +	libcheckrdac.so \
> +	libcheckalua.so
> =C2=A0
> =C2=A0all: $(LIBS)
> =C2=A0
> diff --git a/libmultipath/checkers/alua.c
> b/libmultipath/checkers/alua.c
> new file mode 100644
> index 00000000..cb3d7000
> --- /dev/null
> +++ b/libmultipath/checkers/alua.c
> @@ -0,0 +1,426 @@
> +/*
> + * ALUA Path Checker
> + *
> + * Copyright (c) 2024
> + * This file is released under the GPL.

Please add a proper license header.

> + */
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <sys/types.h>
> +#include <sys/stat.h>
> +#include <sys/sysmacros.h>
> +#include <unistd.h>
> +#include <fcntl.h>
> +#include <errno.h>
> +#include <pthread.h>
> +#include <urcu.h>
> +#include <urcu/uatomic.h>
> +
> +#include "checkers.h"
> +#include "debug.h"
> +#include "structs.h"
> +#include "prio.h"
> +#include "util.h"
> +#include "time-util.h"
> +#include "../prioritizers/alua.h"
> +#include "../prioritizers/alua_rtpg.h"
> +#include "alua.h"
> +
> +#define MAX_NR_TIMEOUTS 1
> +
> +enum {
> +	MSG_ALUA_RTPG_NOT_SUPPORTED =3D CHECKER_FIRST_MSGID,
> +	MSG_ALUA_RTPG_TRANSITIONING,
> +	MSG_ALUA_RUNNING,
> +	MSG_ALUA_TIMEOUT,
> +};
> +
> +#define IDX_(x) (MSG_ ## x - CHECKER_FIRST_MSGID)
> +const char *libcheck_msgtable[] =3D {
> +	[IDX_(ALUA_RTPG_NOT_SUPPORTED)] =3D " ALUA not supported",
> +	[IDX_(ALUA_RTPG_TRANSITIONING)] =3D " path is transitioning",
> +	[IDX_(ALUA_RUNNING)] =3D " still running",
> +	[IDX_(ALUA_TIMEOUT)] =3D " timed out",
> +	NULL,
> +};
> +
> +struct alua_checker_context {
> +	dev_t devt;
> +	int state;
> +	int running; /* uatomic access only */
> +	int fd;
> +	unsigned int timeout;
> +	time_t time;
> +	pthread_t thread;
> +	pthread_mutex_t lock;
> +	pthread_cond_t active;
> +	int holders; /* uatomic access only */
> +	int msgid;
> +	struct checker_context ctx;
> +	unsigned int nr_timeouts;
> +	bool checked_state;
> +	/* ALUA-specific cached data for prioritizer */
> +	int aas;=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*=
 Asymmetric Access State */
> +	int tpg;=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*=
 Target Port Group */
> +	time_t timestamp;=C2=A0 /* When this data was collected */
> +	/* Data needed for RTPG in thread */
> +	struct path *pp;=C2=A0=C2=A0 /* Path pointer - only valid during check
> */
> +};

Instead of duplicating the threading implementation of the TUR checker
here we should abstract it out and use the common framework by both
checkers (and others, too, maybe). This is a thing I've wanted to do
for a long time. Maybe it's time to start doing it now.




> +
> +int libcheck_init(struct checker *c)
> +{
> +	struct alua_checker_context *ct;
> +	struct stat sb;
> +
> +	ct =3D malloc(sizeof(struct alua_checker_context));
> +	if (!ct)
> +		return 1;
> +	memset(ct, 0, sizeof(struct alua_checker_context));
> +
> +	ct->state =3D PATH_UNCHECKED;
> +	ct->fd =3D -1;
> +	ct->aas =3D -1;
> +	ct->tpg =3D -1;
> +	uatomic_set(&ct->holders, 1);
> +	pthread_cond_init_mono(&ct->active);
> +	pthread_mutex_init(&ct->lock, NULL);
> +	if (fstat(c->fd, &sb) =3D=3D 0)
> +		ct->devt =3D sb.st_rdev;
> +	ct->ctx.cls =3D c->cls;
> +	c->context =3D ct;
> +
> +	return 0;
> +}
> +
> +static void cleanup_context(struct alua_checker_context *ct)
> +{
> +	pthread_mutex_destroy(&ct->lock);
> +	pthread_cond_destroy(&ct->active);
> +	free(ct);
> +}
> +
> +void libcheck_free(struct checker *c)
> +{
> +	if (c->context) {
> +		struct alua_checker_context *ct =3D c->context;
> +		int holders;
> +		int running;
> +
> +		running =3D uatomic_xchg(&ct->running, 0);
> +		if (running)
> +			pthread_cancel(ct->thread);
> +		ct->thread =3D 0;
> +		holders =3D uatomic_sub_return(&ct->holders, 1);
> +		if (!holders)
> +			cleanup_context(ct);
> +		c->context =3D NULL;
> +	}
> +	return;
> +}
> +
> +/*
> + * Map ALUA Asymmetric Access State to path state
> + */
> +static int alua_state_to_path_state(int aas, short *msgid)
> +{
> +	switch (aas & 0x0f) {
> +	case AAS_OPTIMIZED:
> +	case AAS_NON_OPTIMIZED:
> +		*msgid =3D CHECKER_MSGID_UP;
> +		return PATH_UP;
> +	case AAS_STANDBY:
> +		*msgid =3D CHECKER_MSGID_GHOST;
> +		return PATH_GHOST;
> +	case AAS_TRANSITIONING:
> +		*msgid =3D MSG_ALUA_RTPG_TRANSITIONING;
> +		return PATH_PENDING;
> +	case AAS_UNAVAILABLE:
> +	case AAS_OFFLINE:
> +	default:
> +		*msgid =3D CHECKER_MSGID_DOWN;
> +		return PATH_DOWN;
> +	}
> +}
> +
> +/*
> + * Main ALUA check function - uses alua_rtpg.c library.
> + * This is called either in sync mode or from the async thread.
> + */
> +static int
> +alua_check(struct path *pp, int *aas_out, short *msgid)
> +{
> +	int aas;
> +
> +	if (pp->tpg_id =3D=3D GROUP_ID_UNDEF) {
> +		*msgid =3D CHECKER_MSGID_DOWN;
> +		return PATH_DOWN;
> +	}
> +
> +	aas =3D get_asymmetric_access_state(pp, pp->tpg_id);
> +	if (aas < 0) {
> +		if (aas =3D=3D -RTPG_LUN_DISCONNECTED) {
> +			*msgid =3D CHECKER_MSGID_DISCONNECTED;
> +			return PATH_DISCONNECTED;
> +		}
> +		*msgid =3D CHECKER_MSGID_DOWN;
> +		return PATH_DOWN;
> +	}
> +
> +	*aas_out =3D aas;
> +	return alua_state_to_path_state(aas, msgid);
> +}
> +
> +#define alua_thread_cleanup_push(ct)
> pthread_cleanup_push(cleanup_func, ct)
> +#define alua_thread_cleanup_pop(ct) pthread_cleanup_pop(1)
> +
> +static void cleanup_func(void *data)
> +{
> +	int holders;
> +	struct alua_checker_context *ct =3D data;
> +
> +	holders =3D uatomic_sub_return(&ct->holders, 1);
> +	if (!holders)
> +		cleanup_context(ct);
> +}
> +
> +void *libcheck_thread(struct checker_context *ctx)
> +{
> +	struct alua_checker_context *ct =3D
> +		container_of(ctx, struct alua_checker_context, ctx);
> +	int state, running;
> +	short msgid;
> +	int aas;
> +
> +	/* This thread can be canceled, so setup clean up */
> +	alua_thread_cleanup_push(ct);
> +
> +	condlog(4, "%d:%d : alua checker starting up", major(ct-
> >devt),
> +		minor(ct->devt));
> +
> +	state =3D alua_check(ct->pp, &aas, &msgid);
> +	pthread_testcancel();
> +
> +	/* ALUA checker done */
> +	pthread_mutex_lock(&ct->lock);
> +	ct->state =3D state;
> +	ct->msgid =3D msgid;
> +	ct->aas =3D aas;
> +	ct->tpg =3D ct->pp->tpg_id;
> +	ct->timestamp =3D time(NULL);
> +	/* Update path-level cache for prioritizer use */
> +	ct->pp->alua_state =3D aas;
> +	ct->pp->alua_timestamp =3D ct->timestamp;
> +	pthread_cond_signal(&ct->active);
> +	pthread_mutex_unlock(&ct->lock);
> +
> +	condlog(4, "%d:%d : alua checker finished, state %s",
> major(ct->devt),
> +		minor(ct->devt), checker_state_name(state));
> +
> +	running =3D uatomic_xchg(&ct->running, 0);
> +	if (!running)
> +		pause();
> +
> +	alua_thread_cleanup_pop(ct);
> +
> +	return ((void *)0);
> +}
> +
> +static void alua_set_async_timeout(struct checker *c)
> +{
> +	struct alua_checker_context *ct =3D c->context;
> +	struct timespec now;
> +
> +	get_monotonic_time(&now);
> +	ct->time =3D now.tv_sec + c->timeout;
> +}
> +
> +static int alua_check_async_timeout(struct checker *c)
> +{
> +	struct alua_checker_context *ct =3D c->context;
> +	struct timespec now;
> +
> +	get_monotonic_time(&now);
> +	return (now.tv_sec > ct->time);
> +}
> +
> +static int check_pending(struct checker *c)
> +{
> +	struct alua_checker_context *ct =3D c->context;
> +	int alua_status =3D PATH_PENDING;
> +
> +	pthread_mutex_lock(&ct->lock);
> +	if (ct->state !=3D PATH_PENDING || ct->msgid !=3D
> MSG_ALUA_RUNNING) {
> +		alua_status =3D ct->state;
> +		c->msgid =3D ct->msgid;
> +	}
> +	pthread_mutex_unlock(&ct->lock);
> +	if (alua_status =3D=3D PATH_PENDING && c->msgid =3D=3D
> MSG_ALUA_RUNNING) {
> +		condlog(4, "%d:%d : alua checker still running",
> +			major(ct->devt), minor(ct->devt));
> +	} else {
> +		int running =3D uatomic_xchg(&ct->running, 0);
> +		if (running)
> +			pthread_cancel(ct->thread);
> +		ct->thread =3D 0;
> +	}
> +
> +	ct->checked_state =3D true;
> +	return alua_status;
> +}
> +
> +bool libcheck_need_wait(struct checker *c)
> +{
> +	struct alua_checker_context *ct =3D c->context;
> +	return (ct && ct->thread && uatomic_read(&ct->running) !=3D 0
> &&
> +		!ct->checked_state);
> +}
> +
> +int libcheck_pending(struct checker *c)
> +{
> +	struct alua_checker_context *ct =3D c->context;
> +
> +	/* The if path checker isn't running, just return the
> exiting value. */
> +	if (!ct || !ct->thread)
> +		return c->path_state;
> +
> +	return check_pending(c);
> +}
> +
> +int libcheck_check(struct checker *c)
> +{
> +	struct alua_checker_context *ct =3D c->context;
> +	struct path *pp =3D container_of(c, struct path, checker);
> +	pthread_attr_t attr;
> +	int alua_status =3D PATH_PENDING, r;
> +	int aas;
> +
> +	if (!ct)
> +		return PATH_UNCHECKED;
> +
> +	if (checker_is_sync(c)) {
> +		alua_status =3D alua_check(pp, &aas, &c->msgid);
> +		ct->tpg =3D pp->tpg_id;
> +		ct->aas =3D aas;
> +		ct->timestamp =3D time(NULL);
> +		/* Update path-level cache for prioritizer use */
> +		pp->alua_state =3D aas;
> +		pp->alua_timestamp =3D ct->timestamp;
> +		return alua_status;
> +	}
> +
> +	/* Async mode */
> +	if (ct->thread) {
> +		ct->checked_state =3D true;
> +		if (alua_check_async_timeout(c)) {
> +			int running =3D uatomic_xchg(&ct->running, 0);
> +			if (running) {
> +				pthread_cancel(ct->thread);
> +				condlog(3, "%d:%d : alua checker
> timeout",
> +					major(ct->devt), minor(ct-
> >devt));
> +				c->msgid =3D MSG_ALUA_TIMEOUT;
> +				alua_status =3D PATH_TIMEOUT;
> +			} else {
> +				pthread_mutex_lock(&ct->lock);
> +				alua_status =3D ct->state;
> +				c->msgid =3D ct->msgid;
> +				pthread_mutex_unlock(&ct->lock);
> +			}
> +			ct->thread =3D 0;
> +		} else if (uatomic_read(&ct->running) !=3D 0) {
> +			/*
> +			 * ct->running may be stale - the thread
> sets
> +			 * msgid/state under lock, then clears
> running
> +			 * after releasing it. Check msgid under
> lock
> +			 * to get the truth. Only MSG_ALUA_RUNNING
> means
> +			 * no result yet.
> +			 */
> +			pthread_mutex_lock(&ct->lock);
> +			if (ct->msgid !=3D MSG_ALUA_RUNNING) {
> +				alua_status =3D ct->state;
> +				c->msgid =3D ct->msgid;
> +				ct->thread =3D 0;
> +			}
> +			pthread_mutex_unlock(&ct->lock);
> +		} else {
> +			/* ALUA checker done */
> +			ct->thread =3D 0;
> +			pthread_mutex_lock(&ct->lock);
> +			alua_status =3D ct->state;
> +			c->msgid =3D ct->msgid;
> +			pthread_mutex_unlock(&ct->lock);
> +		}
> +	} else {
> +		if (uatomic_read(&ct->holders) > 1) {
> +			/* The thread has been cancelled but hasn't
> quit. */
> +			if (ct->nr_timeouts <=3D MAX_NR_TIMEOUTS) {
> +				if (ct->nr_timeouts =3D=3D
> MAX_NR_TIMEOUTS) {
> +					condlog(2, "%d:%d : waiting
> for stalled alua thread to finish",
> +						major(ct->devt),
> minor(ct->devt));
> +				}
> +				ct->nr_timeouts++;
> +				c->msgid =3D MSG_ALUA_TIMEOUT;
> +				return PATH_TIMEOUT;
> +			}
> +			ct->nr_timeouts++;
> +			/*
> +			 * Start a new thread while the old one is
> stalled.
> +			 * We have to prevent it from interfering
> with the new
> +			 * thread. We create a new context and leave
> the old
> +			 * one with the stale thread, hoping it will
> clean up
> +			 * eventually.
> +			 */
> +			condlog(3, "%d:%d : alua thread not
> responding",
> +				major(ct->devt), minor(ct->devt));
> +
> +			if (libcheck_init(c) !=3D 0) {
> +				c->msgid =3D CHECKER_MSGID_DOWN;
> +				return PATH_UNCHECKED;
> +			}
> +			((struct alua_checker_context *)c->context)-
> >nr_timeouts =3D ct->nr_timeouts;
> +
> +			if (!uatomic_sub_return(&ct->holders, 1)) {
> +				/* It did terminate, eventually */
> +				cleanup_context(ct);
> +				((struct alua_checker_context *)c-
> >context)->nr_timeouts =3D 0;
> +			}
> +
> +			ct =3D c->context;
> +		} else
> +			ct->nr_timeouts =3D 0;
> +
> +		/* Start new ALUA checker */
> +		pthread_mutex_lock(&ct->lock);
> +		alua_status =3D ct->state =3D PATH_PENDING;
> +		c->msgid =3D ct->msgid =3D MSG_ALUA_RUNNING;
> +		pthread_mutex_unlock(&ct->lock);
> +		ct->fd =3D c->fd;
> +		ct->timeout =3D c->timeout;
> +		ct->pp =3D pp;
> +		ct->checked_state =3D false;
> +		uatomic_add(&ct->holders, 1);
> +		uatomic_set(&ct->running, 1);
> +		alua_set_async_timeout(c);
> +		setup_thread_attr(&attr, 32 * 1024, 1);
> +		r =3D start_checker_thread(&ct->thread, &attr, &ct-
> >ctx);
> +		pthread_attr_destroy(&attr);
> +		if (r) {
> +			uatomic_sub(&ct->holders, 1);
> +			uatomic_set(&ct->running, 0);
> +			ct->thread =3D 0;
> +			condlog(3, "%d:%d : failed to start alua
> thread, using"
> +				" sync mode", major(ct->devt),
> minor(ct->devt));
> +			alua_status =3D alua_check(pp, &aas, &c-
> >msgid);
> +			ct->tpg =3D pp->tpg_id;
> +			ct->aas =3D aas;
> +			ct->timestamp =3D time(NULL);
> +			/* Update path-level cache for prioritizer
> use */
> +			pp->alua_state =3D aas;
> +			pp->alua_timestamp =3D ct->timestamp;
> +			return alua_status;
> +		}
> +	}
> +
> +	return alua_status;
> +}
> +
> diff --git a/libmultipath/checkers/alua.h
> b/libmultipath/checkers/alua.h
> new file mode 100644
> index 00000000..b53cef66
> --- /dev/null
> +++ b/libmultipath/checkers/alua.h
> @@ -0,0 +1,15 @@
> +/*
> + * ALUA Path Checker Header
> + *
> + * This file is released under the GPL.

Please add a proper license header.

> + */
> +#ifndef _ALUA_CHECKER_H
> +#define _ALUA_CHECKER_H
> +
> +/* ALUA checker caches state in struct path for prioritizer use:
> + *=C2=A0=C2=A0 pp->alua_state=C2=A0=C2=A0=C2=A0=C2=A0 - cached AAS value=
 (-1 if not cached)
> + *=C2=A0=C2=A0 pp->alua_timestamp - when the state was last updated
> + */
> +
> +#endif /* _ALUA_CHECKER_H */
> +

Only comments in this file?


> diff --git a/libmultipath/prio.c b/libmultipath/prio.c
> index 24f825bd..2d59d04e 100644
> --- a/libmultipath/prio.c
> +++ b/libmultipath/prio.c
> @@ -29,6 +29,7 @@ int init_prio(void)
> =C2=A0#ifdef LOAD_ALL_SHARED_LIBS
> =C2=A0	static const char *const all_prios[] =3D {
> =C2=A0		PRIO_ALUA,
> +		PRIO_ALUA_CACHED,
> =C2=A0		PRIO_CONST,
> =C2=A0		PRIO_DATACORE,
> =C2=A0		PRIO_EMC,
> diff --git a/libmultipath/prio.h b/libmultipath/prio.h
> index 119b75f2..b54ece0d 100644
> --- a/libmultipath/prio.h
> +++ b/libmultipath/prio.h
> @@ -17,6 +17,7 @@ struct path;
> =C2=A0 * Known prioritizers for use in hwtable.c
> =C2=A0 */
> =C2=A0#define PRIO_ALUA		"alua"
> +#define PRIO_ALUA_CACHED	"alua_cached"
> =C2=A0#define PRIO_CONST		"const"
> =C2=A0#define PRIO_DATACORE		"datacore"
> =C2=A0#define PRIO_EMC		"emc"
> diff --git a/libmultipath/prioritizers/Makefile
> b/libmultipath/prioritizers/Makefile
> index ff2524c2..201c52c0 100644
> --- a/libmultipath/prioritizers/Makefile
> +++ b/libmultipath/prioritizers/Makefile
> @@ -13,6 +13,7 @@ LIBDEPS =3D -lmultipath -lmpathutil -lm -lpthread -
> lrt
> =C2=A0# If you add or remove a prioritizer also update
> multipath/multipath.conf.5
> =C2=A0LIBS =3D \
> =C2=A0	libprioalua.so \
> +	libprioalua_cached.so \
> =C2=A0	libprioconst.so \
> =C2=A0	libpriodatacore.so \
> =C2=A0	libprioemc.so \

I think the below should go into a separate patch.

> diff --git a/libmultipath/prioritizers/alua_cached.c
> b/libmultipath/prioritizers/alua_cached.c
> new file mode 100644
> index 00000000..2ba5b2e7
> --- /dev/null
> +++ b/libmultipath/prioritizers/alua_cached.c
> @@ -0,0 +1,224 @@
> +/*
> + * (C) Copyright IBM Corp. 2004, 2005=C2=A0=C2=A0 All Rights Reserved.
> + * Modified 2024 to support cached ALUA state from checker
> + *
> + * ALUA prioritizer that can use cached state from alua checker
> + * to avoid duplicate RTPG commands.
> + *
> + * This file is released under the GPL.

Please add a proper license header.

> + */
> +#include <stdio.h>
> +#include <string.h>
> +
> +#include <time.h>
> +
> +#include "debug.h"
> +#include "prio.h"
> +#include "structs.h"
> +#include "checkers.h"
> +#include "discovery.h"
> +
> +#include "alua.h"
> +
> +#define ALUA_PRIO_NOT_SUPPORTED			1
> +#define ALUA_PRIO_RTPG_FAILED			2
> +#define ALUA_PRIO_GETAAS_FAILED			3
> +#define ALUA_PRIO_TPGS_FAILED			4
> +#define ALUA_PRIO_NO_INFORMATION		5
> +#define ALUA_PRIO_CACHED_STALE			6
> +
> +/* Maximum age of cached ALUA state in seconds */
> +#define ALUA_CACHE_MAX_AGE_SECS			5
> +
> +static const char * aas_string[] =3D {
> +	[AAS_OPTIMIZED]		=3D "active/optimized",
> +	[AAS_NON_OPTIMIZED]	=3D "active/non-optimized",
> +	[AAS_STANDBY]		=3D "standby",
> +	[AAS_UNAVAILABLE]	=3D "unavailable",
> +	[AAS_LBA_DEPENDENT]	=3D "logical block dependent",
> +	[AAS_RESERVED]		=3D "ARRAY BUG: invalid TPGs state!",
> +	[AAS_OFFLINE]		=3D "offline",
> +	[AAS_TRANSITIONING]	=3D "transitioning between states",
> +};

We shouldn't duplicate the definition of these constants.

> +
> +static const char *aas_print_string(int rc)
> +{
> +	rc &=3D 0x7f;
> +
> +	if (rc & 0x70)
> +		return aas_string[AAS_RESERVED];
> +	rc &=3D 0x0f;
> +	if (rc > AAS_RESERVED && rc < AAS_OFFLINE)
> +		return aas_string[AAS_RESERVED];
> +	else
> +		return aas_string[rc];
> +}
> +
> +/*
> + * Try to get ALUA info with optimization:
> + * 1. If using alua checker: use its cached state (it just polled!)
> + * 2. Try sysfs (kernel maintains this, no I/O needed)
> + * 3. Fall back to issuing RTPG directly
> + *
> + * Rationale: The checker is our active poller. If we're using alua
> + * and its cache is fresh, we trust that data first. If the cache
> misses
> + * (stale or empty), we try sysfs before issuing RTPG. This provides
> a
> + * three-tier optimization: checker cache =E2=86=92 sysfs =E2=86=92 RTPG=
.
> + */
> +/* Maximum length of sysfs access_state string */
> +#define ALUA_ACCESS_STATE_SIZE 32
> +
> +int
> +get_alua_info_cached(struct path * pp, bool *used_cache)
> +{
> +	int	rc;
> +	int	tpg;
> +	bool	diff_tpg;
> +	char	buff[ALUA_ACCESS_STATE_SIZE];
> +
> +	*used_cache =3D false;
> +
> +	/* First: if using alua checker, use its fresh data from
> path structure */
> +	if (checker_selected(&pp->checker)) {
> +		const char *chk_name =3D checker_name(&pp->checker);
> +
> +		if (chk_name && strcmp(chk_name, "alua") =3D=3D 0 &&
> +		=C2=A0=C2=A0=C2=A0 pp->alua_state >=3D 0) {
> +			time_t now =3D time(NULL);
> +			time_t age =3D now - pp->alua_timestamp;
> +
> +			if (pp->alua_timestamp > 0 && age <=3D
> ALUA_CACHE_MAX_AGE_SECS) {
> +				condlog(4, "%s: using cached ALUA
> state from checker (fresh poll)", pp->dev);
> +				*used_cache =3D true;
> +				return pp->alua_state;
> +			}
> +			condlog(4, "%s: cached ALUA state not
> available or stale, trying sysfs",
> +				pp->dev);
> +			/* Cache miss - try sysfs before issuing
> RTPG */
> +		}
> +	}
> +
> +	/* Second: try sysfs (if cache missed or not using alua
> checker) */
> +	rc =3D sysfs_get_asymmetric_access_state(pp, buff,
> sizeof(buff));
> +	if (rc >=3D 0) {
> +		/* Parse sysfs state string to ALUA state value */
> +		int aas =3D -1;
> +		int priopath =3D rc; /* rc contains preferred bit */
> +
> +		if (!strncmp(buff, "active/optimized", 16))
> +			aas =3D AAS_OPTIMIZED;
> +		else if (!strncmp(buff, "active/non-optimized", 20))
> +			aas =3D AAS_NON_OPTIMIZED;
> +		else if (!strncmp(buff, "lba-dependent", 13))
> +			aas =3D AAS_LBA_DEPENDENT;
> +		else if (!strncmp(buff, "standby", 7))
> +			aas =3D AAS_STANDBY;
> +
> +		if (aas >=3D 0) {
> +			condlog(4, "%s: using sysfs ALUA state (no
> I/O)", pp->dev);
> +			*used_cache =3D true;
> +			return (priopath ? 0x80 : 0) | aas;
> +		}
> +	}
> +
> +	/* Last resort: issue RTPG directly */
> +	tpg =3D get_target_port_group(pp);
> +	if (tpg < 0) {
> +		rc =3D get_target_port_group_support(pp);
> +		if (rc < 0)
> +			return -ALUA_PRIO_TPGS_FAILED;
> +		if (rc =3D=3D TPGS_NONE)
> +			return -ALUA_PRIO_NOT_SUPPORTED;
> +		return -ALUA_PRIO_RTPG_FAILED;
> +	}
> +	diff_tpg =3D (pp->tpg_id !=3D GROUP_ID_UNDEF && pp->tpg_id !=3D
> tpg);
> +	pp->tpg_id =3D tpg;
> +	condlog((diff_tpg) ? 2 : 4, "%s: reported target port group
> is %i",
> +		pp->dev, tpg);
> +	rc =3D get_asymmetric_access_state(pp, tpg);
> +	if (rc < 0) {
> +		condlog(2, "%s: get_asymmetric_access_state returned
> %d",
> +			__func__, rc);
> +		return -ALUA_PRIO_GETAAS_FAILED;
> +	}
> +
> +	condlog(3, "%s: aas =3D %02x [%s]%s", pp->dev, rc,
> aas_print_string(rc),
> +		(rc & 0x80) ? " [preferred]" : "");
> +	return rc;
> +}
> +
> +int get_exclusive_pref_arg(char *args)
> +{
> +	char *ptr;
> +
> +	if (args =3D=3D NULL)
> +		return 0;
> +	ptr =3D strstr(args, "exclusive_pref_bit");
> +	if (!ptr)
> +		return 0;
> +	if (ptr[18] !=3D '\0' && ptr[18] !=3D ' ' && ptr[18] !=3D '\t')
> +		return 0;
> +	if (ptr !=3D args && ptr[-1] !=3D ' ' && ptr[-1] !=3D '\t')
> +		return 0;
> +	return 1;
> +}
> +
> +int getprio (struct path * pp, char * args)
> +{
> +	int rc;
> +	int aas;
> +	int priopath;
> +	int exclusive_pref;
> +	bool used_cache =3D false;
> +
> +	if (pp->fd < 0)
> +		return -ALUA_PRIO_NO_INFORMATION;
> +
> +	exclusive_pref =3D get_exclusive_pref_arg(args);
> +	rc =3D get_alua_info_cached(pp, &used_cache);
> +
> +	if (used_cache) {
> +		condlog(4, "%s: priority calculated from cached ALUA
> state (no RTPG issued)",
> +			pp->dev);
> +	}
> +
> +	if (rc >=3D 0) {
> +		aas =3D (rc & 0x0f);
> +		priopath =3D (rc & 0x80);
> +		switch(aas) {
> +		case AAS_OPTIMIZED:
> +			rc =3D 50;
> +			break;
> +		case AAS_NON_OPTIMIZED:
> +			rc =3D 10;
> +			break;
> +		case AAS_LBA_DEPENDENT:
> +			rc =3D 5;
> +			break;
> +		case AAS_STANDBY:
> +			rc =3D 1;
> +			break;
> +		default:
> +			rc =3D 0;
> +		}
> +		if (priopath && (aas !=3D AAS_OPTIMIZED ||
> exclusive_pref))
> +			rc +=3D 80;
> +	} else {
> +		switch(-rc) {
> +		case ALUA_PRIO_NOT_SUPPORTED:
> +			condlog(0, "%s: alua not supported", pp-
> >dev);
> +			break;
> +		case ALUA_PRIO_RTPG_FAILED:
> +			condlog(0, "%s: couldn't get target port
> group", pp->dev);
> +			break;
> +		case ALUA_PRIO_GETAAS_FAILED:
> +			condlog(0, "%s: couldn't get asymmetric
> access state", pp->dev);
> +			break;
> +		case ALUA_PRIO_TPGS_FAILED:
> +			condlog(3, "%s: couldn't get supported alua
> states", pp->dev);
> +			break;
> +		}
> +	}
> +	return rc;
> +}
> +
> diff --git a/libmultipath/prioritizers/alua_rtpg.c
> b/libmultipath/prioritizers/alua_rtpg.c
> index 053cccb7..5da06b50 100644
> --- a/libmultipath/prioritizers/alua_rtpg.c
> +++ b/libmultipath/prioritizers/alua_rtpg.c
> @@ -75,6 +75,7 @@ enum scsi_disposition {
> =C2=A0	SCSI_GOOD =3D 0,
> =C2=A0	SCSI_ERROR,
> =C2=A0	SCSI_RETRY,
> +	SCSI_DISCONNECTED,
> =C2=A0};
> =C2=A0
> =C2=A0static int
> @@ -124,6 +125,12 @@ scsi_error(struct sg_io_hdr *hdr, int opcode)
> =C2=A0	PRINT_DEBUG("alua: SCSI error for command %02x: status %02x,
> sense %02x/%02x/%02x",
> =C2=A0		=C2=A0=C2=A0=C2=A0 opcode, hdr->status, sense_key, asc, ascq);
> =C2=A0
> +	/* Check for disconnected LUN (unmapped at target) */
> +	if (sense_key =3D=3D 0x5 && asc =3D=3D 0x25 && ascq =3D=3D 0x00) {
> +		/* ILLEGAL REQUEST / LOGICAL UNIT NOT SUPPORTED */
> +		return SCSI_DISCONNECTED;
> +	}
> +
> =C2=A0	if (sense_key =3D=3D UNIT_ATTENTION || sense_key =3D=3D NOT_READY)
> =C2=A0		return SCSI_RETRY;
> =C2=A0	else
> @@ -325,7 +332,10 @@ retry:
> =C2=A0	}
> =C2=A0
> =C2=A0	rc =3D scsi_error(&hdr, OPERATION_CODE_RTPG);
> -	if (rc =3D=3D SCSI_ERROR) {
> +	if (rc =3D=3D SCSI_DISCONNECTED) {
> +		PRINT_DEBUG("do_rtpg: LUN disconnected (unmapped at
> target)!");
> +		return -RTPG_LUN_DISCONNECTED;
> +	} else if (rc =3D=3D SCSI_ERROR) {
> =C2=A0		PRINT_DEBUG("do_rtpg: SCSI error!");
> =C2=A0		return -RTPG_RTPG_FAILED;
> =C2=A0	} else if (rc =3D=3D SCSI_RETRY) {
> diff --git a/libmultipath/prioritizers/alua_rtpg.h
> b/libmultipath/prioritizers/alua_rtpg.h
> index ff6ec0ef..030ca58d 100644
> --- a/libmultipath/prioritizers/alua_rtpg.h
> +++ b/libmultipath/prioritizers/alua_rtpg.h
> @@ -21,6 +21,7 @@
> =C2=A0#define RTPG_NO_TPG_IDENTIFIER			2
> =C2=A0#define RTPG_RTPG_FAILED			3
> =C2=A0#define RTPG_TPG_NOT_FOUND			4
> +#define RTPG_LUN_DISCONNECTED			5
> =C2=A0
> =C2=A0int get_target_port_group_support(const struct path *pp);
> =C2=A0int get_target_port_group(const struct path *pp);
> diff --git a/libmultipath/prioritizers/sysfs.c
> b/libmultipath/prioritizers/sysfs.c
> index 5e8adc05..ab058ea9 100644
> --- a/libmultipath/prioritizers/sysfs.c
> +++ b/libmultipath/prioritizers/sysfs.c
> @@ -10,6 +10,9 @@
> =C2=A0#include "discovery.h"
> =C2=A0#include "prio.h"
> =C2=A0
> +/* Maximum length of sysfs access_state string */
> +#define ALUA_ACCESS_STATE_SIZE 32
> +
> =C2=A0static const struct {
> =C2=A0	unsigned char value;
> =C2=A0	char *name;
> @@ -39,11 +42,11 @@ int get_exclusive_pref_arg(char *args)
> =C2=A0int getprio (struct path * pp, char *args)
> =C2=A0{
> =C2=A0	int prio =3D 0, rc, i;
> -	char buff[512];
> +	char buff[ALUA_ACCESS_STATE_SIZE];
> =C2=A0	int exclusive_pref;
> =C2=A0
> =C2=A0	exclusive_pref =3D get_exclusive_pref_arg(args);
> -	rc =3D sysfs_get_asymmetric_access_state(pp, buff, 512);
> +	rc =3D sysfs_get_asymmetric_access_state(pp, buff,
> sizeof(buff));
> =C2=A0	if (rc < 0)
> =C2=A0		return PRIO_UNDEF;
> =C2=A0	prio =3D 0;
> diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> index 56895c4b..e421abba 100644
> --- a/libmultipath/propsel.c
> +++ b/libmultipath/propsel.c
> @@ -262,6 +262,7 @@ verify_alua_prio(struct multipath *mp)
> =C2=A0		if (!prio_selected(&pp->prio))
> =C2=A0			continue;
> =C2=A0		if (strncmp(name, PRIO_ALUA, PRIO_NAME_LEN) &&
> +		=C2=A0=C2=A0=C2=A0 strncmp(name, PRIO_ALUA_CACHED, PRIO_NAME_LEN)
> &&
> =C2=A0		=C2=A0=C2=A0=C2=A0 strncmp(name, PRIO_SYSFS, PRIO_NAME_LEN))
> =C2=A0			 return false;
> =C2=A0		assume_alua =3D true;
> @@ -690,7 +691,12 @@ int select_checker(struct config *conf, struct
> path *pp)
> =C2=A0		}
> =C2=A0		(void)path_get_tpgs(pp);
> =C2=A0		if (pp->tpgs !=3D TPGS_NONE && pp->tpgs !=3D TPGS_UNDEF)
> {
> -			ckr_name =3D TUR;
> +			/*
> +			 * For ALUA devices (any TPGS support), use
> alua
> +			 * checker which combines path checking with
> ALUA state
> +			 * caching for optimal performance.
> +			 */
> +			ckr_name =3D ALUA;
> =C2=A0			goto out;
> =C2=A0		}
> =C2=A0	}
> @@ -767,8 +773,15 @@ void detect_prio(struct path *pp)
> =C2=A0		if ((tpgs =3D=3D TPGS_EXPLICIT || !check_rdac(pp)) &&
> =C2=A0		=C2=A0=C2=A0=C2=A0 sysfs_get_asymmetric_access_state(pp, buff, 51=
2)
> >=3D 0)
> =C2=A0			default_prio =3D PRIO_SYSFS;
> -		else
> +		else {
> =C2=A0			default_prio =3D PRIO_ALUA;
> +			/* If using alua checker, use cached
> prioritizer */
> +			if (checker_selected(&pp->checker)) {
> +				const char *chk_name =3D
> checker_name(&pp->checker);
> +				if (chk_name && strcmp(chk_name,
> ALUA) =3D=3D 0)
> +					default_prio =3D
> PRIO_ALUA_CACHED;
> +			}
> +		}
> =C2=A0		break;
> =C2=A0	default:
> =C2=A0		return;
> @@ -831,7 +844,8 @@ out:
> =C2=A0	/*
> =C2=A0	 * fetch tpgs mode for alua, if its not already obtained
> =C2=A0	 */
> -	if (!strncmp(prio_name(p), PRIO_ALUA, PRIO_NAME_LEN)) {
> +	if (!strncmp(prio_name(p), PRIO_ALUA, PRIO_NAME_LEN) ||
> +	=C2=A0=C2=A0=C2=A0 !strncmp(prio_name(p), PRIO_ALUA_CACHED, PRIO_NAME_L=
EN))
> {
> =C2=A0		int tpgs =3D path_get_tpgs(pp);
> =C2=A0
> =C2=A0		if (tpgs =3D=3D TPGS_NONE) {
> diff --git a/libmultipath/structs.c b/libmultipath/structs.c
> index f4413127..6483a568 100644
> --- a/libmultipath/structs.c
> +++ b/libmultipath/structs.c
> @@ -126,6 +126,8 @@ alloc_path (void)
> =C2=A0		pp->fd =3D -1;
> =C2=A0		pp->tpgs =3D TPGS_UNDEF;
> =C2=A0		pp->tpg_id =3D GROUP_ID_UNDEF;
> +		pp->alua_state =3D -1;
> +		pp->alua_timestamp =3D 0;
> =C2=A0		pp->priority =3D PRIO_UNDEF;
> =C2=A0		pp->checkint =3D CHECKINT_UNDEF;
> =C2=A0		checker_clear(&pp->checker);
> diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> index 9adedde2..c4bddee9 100644
> --- a/libmultipath/structs.h
> +++ b/libmultipath/structs.h
> @@ -444,6 +444,9 @@ struct path {
> =C2=A0	vector hwe;
> =C2=A0	struct gen_path generic_path;
> =C2=A0	int tpg_id;
> +	/* Cached ALUA state from checker for prioritizer use */
> +	int alua_state;		/* AAS value, -1 if not
> cached */
> +	time_t alua_timestamp;	/* When alua_state was last updated
> */
> =C2=A0	enum ioctl_info_states ioctl_info;
> =C2=A0};
> =C2=A0
