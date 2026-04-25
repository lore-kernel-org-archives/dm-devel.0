Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D63D135BDB8
	for <dm-devel@lists.linux.dev>; Sat, 25 Apr 2026 17:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777137382; cv=none; b=bYG1ptNPKIna0G81+1RK5Cu0qXmiCj2YIPLhagkMUwUXJbcmsdiWUiC9d9qcqYcHqWSkxo/FGIPs6VqyjE8skxyFUpT+hHtc41cW40HyHExplyqHuTf6mp6/ETNwu59oo3OTSVUckPc8tEOPK3vAm+Kvw1owkSgs+UV5Ii26Ppk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777137382; c=relaxed/simple;
	bh=eZ8QN/DzZ+NCIYr2B9UZifvyMUMAWQw4HXElsw+c/10=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MllFSYy1NY0JCXWLi7NmbKfju57oonZxWp7f8kMFZ6ClbgRE8tqRRtydFCTS7pvd0RPZFJEl6iLmDkwWDgaZvFd3qewgrePJUgR0bkY7YiK7qJ1iFKiBvtz9tpTJWObeYo5dyH8fVQwTZQteBKUCuVq6InSkTdDRO/4gpjU5ERA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=nXZGKjMl; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=nXZGKjMl; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="nXZGKjMl";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="nXZGKjMl"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7AEA85BD01;
	Sat, 25 Apr 2026 17:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777137371; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gJYD6ILnjpsWky86YMj6QLx7uWl5mbfvbyko+VBq87I=;
	b=nXZGKjMlq0nEX9TqAn99fwKL+IVuj7ryRUCHYuoHPdZHUPrqDJOWMrH7oAMimiUjgJ3ei8
	CISc9iv9ULDIn2NLT6R02Mufwu1FynURAf1sbjV2Gk2bcSpvaKyMZedwafnsFtKdGli9xj
	ucg5R/VS6pxt/1B3ltEeC4JL1JYOq0U=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=nXZGKjMl
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777137371; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gJYD6ILnjpsWky86YMj6QLx7uWl5mbfvbyko+VBq87I=;
	b=nXZGKjMlq0nEX9TqAn99fwKL+IVuj7ryRUCHYuoHPdZHUPrqDJOWMrH7oAMimiUjgJ3ei8
	CISc9iv9ULDIn2NLT6R02Mufwu1FynURAf1sbjV2Gk2bcSpvaKyMZedwafnsFtKdGli9xj
	ucg5R/VS6pxt/1B3ltEeC4JL1JYOq0U=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 53C14593A6;
	Sat, 25 Apr 2026 17:16:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WU2UEtv27GlzawAAD6G6ig
	(envelope-from <mwilck@suse.com>); Sat, 25 Apr 2026 17:16:11 +0000
Message-ID: <b2f1700d804f5f254dd614ba09746534ea0d0a22.camel@suse.com>
Subject: Re: [PATCH 1/2] checkers: add alua path checker and async checker
 framework
From: Martin Wilck <mwilck@suse.com>
To: Brian Bunker <brian@purestorage.com>, dm-devel@lists.linux.dev
Cc: bmarzins@redhat.com, Krishna Kant <krishna.kant@purestorage.com>
Date: Sat, 25 Apr 2026 19:16:10 +0200
In-Reply-To: <20260325151940.18928-2-brian@purestorage.com>
References: <20260325151940.18928-1-brian@purestorage.com>
	 <20260325151940.18928-2-brian@purestorage.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.0 
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DWL_DNSWL_BLOCKED(0.00)[suse.com:dkim];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:dkim,suse.com:mid];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Queue-Id: 7AEA85BD01
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 

Hi Brian,

On Wed, 2026-03-25 at 08:19 -0700, Brian Bunker wrote:
> Add an 'alua' path checker that uses RTPG to check path state. The
> checker maps ALUA Asymmetric Access States to path states:
> =C2=A0 - AAS_OPTIMIZED, AAS_NON_OPTIMIZED -> PATH_UP
> =C2=A0 - AAS_STANDBY -> PATH_GHOST
> =C2=A0 - AAS_TRANSITIONING -> PATH_PENDING
> =C2=A0 - AAS_UNAVAILABLE, AAS_OFFLINE -> PATH_DOWN
>=20
> As part of this change, the common async threading infrastructure is
> extracted from the TUR checker into a new async_checker base class.
> Both TUR and ALUA checkers now extend this base, eliminating code
> duplication and establishing a pattern for future async checkers.
>=20
> Two fields are added to struct path (alua_state, alua_timestamp) to
> cache ALUA state for use by prioritizers.
>=20
> When detect_checker is enabled, the alua checker is auto-selected for
> devices with TPGS support. Explicitly configured checkers in the
> hardware table take precedence over auto-detection.
>=20
> Signed-off-by: Brian Bunker <brian@purestorage.com>
> Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
> ---
> =C2=A0libmultipath/Makefile=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 2 +-
> =C2=A0libmultipath/async_checker.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 | 249 +++++++++++++++++++++
> =C2=A0libmultipath/async_checker.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 | 123 +++++++++++
> =C2=A0libmultipath/checkers.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 1 +
> =C2=A0libmultipath/checkers.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 1 +
> =C2=A0libmultipath/checkers/Makefile=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 |=C2=A0=C2=A0 3 +-
> =C2=A0libmultipath/checkers/alua.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 | 266 +++++++++++++++++++++++
> =C2=A0libmultipath/checkers/tur.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 | 302 ++++--------------------
> --
> =C2=A0libmultipath/libmultipath.version=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=
=C2=A0 8 +
> =C2=A0libmultipath/prioritizers/alua.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=
=A0 30 ---
> =C2=A0libmultipath/prioritizers/alua.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=
=A0=C2=A0 8 +
> =C2=A0libmultipath/prioritizers/alua_rtpg.c |=C2=A0 62 +++++-
> =C2=A0libmultipath/prioritizers/alua_rtpg.h |=C2=A0=C2=A0 4 +
> =C2=A0libmultipath/propsel.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 16 +-
> =C2=A0libmultipath/structs.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 2 +
> =C2=A0libmultipath/structs.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 3 +
> =C2=A0multipath/multipath.conf.5.in=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0 23 +-
> =C2=A017 files changed, 795 insertions(+), 308 deletions(-)
> =C2=A0create mode 100644 libmultipath/async_checker.c
> =C2=A0create mode 100644 libmultipath/async_checker.h
> =C2=A0create mode 100644 libmultipath/checkers/alua.c
>=20
> [...]

> =C2=A0
> diff --git a/libmultipath/checkers/alua.c
> b/libmultipath/checkers/alua.c
> new file mode 100644
> index 00000000..bff1bed6
> --- /dev/null
> +++ b/libmultipath/checkers/alua.c
> @@ -0,0 +1,266 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * ALUA Path Checker - uses RTPG to check path state
> + *
> + * Based on the TUR checker by Christophe Varoqui.
> + *
> + * Copyright (c) 2026 Brian Bunker <brian@purestorage.com>
> + * Copyright (c) 2026 Krishna Kant <krishna.kant@purestorage.com>
> + */
> +#include <errno.h>
> +#include <pthread.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <sys/sysmacros.h>
> +#include <sys/types.h>
> +#include <unistd.h>
> +#include <urcu/uatomic.h>
> +
> +#include "async_checker.h"
> +#include "checkers.h"
> +#include "debug.h"
> +#include "prio.h"
> +#include "structs.h"
> +#include "time-util.h"
> +#include "../prioritizers/alua.h"
> +#include "../prioritizers/alua_rtpg.h"
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
> +	struct async_checker_context base;	/* Must be first */
> +	/* ALUA-specific cached data for prioritizer */
> +	int aas;=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*=
 Asymmetric Access State */
> +	int tpg;=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*=
 Target Port Group */
> +	time_t timestamp;=C2=A0 /* When this data was collected */
> +	/* Data needed for RTPG in thread - copied before thread
> starts */
> +	unsigned int timeout_ms;
> +};
> +
> +int libcheck_init(struct checker *c)
> +{
> +	int ret =3D async_checker_init(c, sizeof(struct
> alua_checker_context));
> +	if (ret =3D=3D 0) {
> +		struct alua_checker_context *ct =3D c->context;
> +		ct->aas =3D -1;
> +		ct->tpg =3D -1;
> +	}
> +	return ret;
> +}
> +
> +void libcheck_free(struct checker *c)
> +{
> +	async_checker_free(c);
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
> +	/* Discover TPG ID if not already set */
> +	if (pp->tpg_id =3D=3D GROUP_ID_UNDEF) {
> +		int tpg =3D get_target_port_group(pp);
> +		if (tpg < 0) {
> +			*msgid =3D CHECKER_MSGID_DOWN;
> +			return PATH_DOWN;
> +		}
> +		pp->tpg_id =3D tpg;
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
> +#define alua_thread_cleanup_push(ct) \
> +	pthread_cleanup_push(async_checker_cleanup_func, &(ct)-
> >base)
> +#define alua_thread_cleanup_pop(ct) pthread_cleanup_pop(1)
> +
> +/*
> + * Async thread function.
> + * IMPORTANT: Do not access struct path from here - it may be freed.
> + * Use only data copied to context before thread start: fd, tpg,
> timeout_ms.
> + */
> +void *libcheck_thread(struct checker_context *ctx)
> +{
> +	struct alua_checker_context *ct =3D
> +		container_of(ctx, struct alua_checker_context,
> base.ctx);
> +	struct timespec ts;
> +	int state;
> +	short msgid;
> +	int aas;
> +
> +	/* This thread can be canceled, so setup clean up */
> +	alua_thread_cleanup_push(ct);
> +
> +	condlog(4, "%d:%d : alua checker starting up", major(ct-
> >base.devt),
> +		minor(ct->base.devt));
> +
> +	/* Use fd-based check - path pointer is not safe here */
> +	aas =3D get_asymmetric_access_state_fd(ct->base.fd, ct->tpg,
> +					=C2=A0=C2=A0=C2=A0=C2=A0 ct->timeout_ms);
> +	pthread_testcancel();
> +
> +	if (aas < 0) {
> +		if (aas =3D=3D -RTPG_LUN_DISCONNECTED) {
> +			msgid =3D CHECKER_MSGID_DISCONNECTED;
> +			state =3D PATH_DISCONNECTED;
> +		} else {
> +			msgid =3D CHECKER_MSGID_DOWN;
> +			state =3D PATH_DOWN;
> +		}
> +		aas =3D -1;
> +	} else {
> +		state =3D alua_state_to_path_state(aas, &msgid);
> +	}
> +
> +	/* Store results in context - will be copied to path by
> libcheck_check */
> +	get_monotonic_time(&ts);
> +	pthread_mutex_lock(&ct->base.lock);
> +	ct->base.state =3D state;
> +	ct->base.msgid =3D msgid;
> +	ct->aas =3D aas;
> +	ct->timestamp =3D ts.tv_sec;
> +	pthread_cond_signal(&ct->base.active);
> +	pthread_mutex_unlock(&ct->base.lock);
> +
> +	condlog(4, "%d:%d : alua checker finished, state %s",
> major(ct->base.devt),
> +		minor(ct->base.devt), checker_state_name(state));
> +
> +	if (!uatomic_xchg(&ct->base.running, 0))
> +		pause();
> +
> +	alua_thread_cleanup_pop(ct);
> +
> +	return ((void *)0);
> +}
> +
> +bool libcheck_need_wait(struct checker *c)
> +{
> +	return async_checker_need_wait(c);
> +}
> +
> +int libcheck_pending(struct checker *c)
> +{
> +	return async_checker_pending(c, MSG_ALUA_RUNNING);
> +}
> +
> +/*
> + * Sync mode callback for async_checker_check.
> + * Safe to access path here since we're in the main thread.
> + */
> +static int alua_check_callback(struct checker *c,
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct async_checker_context *ba=
se_ct
> +					__attribute__((unused)),
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 short *msgid)
> +{
> +	struct path *pp =3D container_of(c, struct path, checker);
> +	struct timespec ts;
> +	int aas =3D -1;
> +	int state;
> +
> +	state =3D alua_check(pp, &aas, msgid);
> +
> +	/* Cache ALUA state for prioritizer */
> +	get_monotonic_time(&ts);
> +	pp->alua_state =3D aas;
> +	pp->alua_timestamp =3D ts.tv_sec;
> +
> +	return state;
> +}
> +
> +int libcheck_check(struct checker *c)
> +{
> +	struct alua_checker_context *ct =3D c->context;
> +	struct path *pp =3D container_of(c, struct path, checker);

I just had another look at this patch as I'm working on the checkers
myself, and I have to say that this is something you absolutely cannot
do, especially not when the checker thread is supposed to run
asynchronously. There's a reason that we pass "struct checker *" to the
checker threads and not "struct path *", and the code above is a hack
to work around this design decision.

When you write a checker, you need to think carefully what information
you actually need, and copy that from "struct path" to the checker
context. Currently, for all checkers except emc_clariion, nothing is
needed except pp->fd and pp->timeout. I understand that the alua
checker needs more context, but that doesn't mean you can simply pass
the entire data structure to the checker, and I believe that an  ALUA
can be written so that it needs just a few more fields (if any).

For the "caching" functionality for the prioritizer, I understand that
you need to store the alua_state property in "struct path". So far I
haven't figured out how to do this properly. I could imagine something
like a "checker_private" field in "struct path" which could be handled
like this:
   =20
union checker_private {
    long alua_data;
}

struct path {
...
    union checker_private c_private;=C2=A0

    state =3D checker_get_state(c, &pp->c_private)

and checker_get_state() would do something like

int checker_get_state(struct checker *c,=C2=A0
                      union checker_private *private)
{
     ...
     if (c->set_private_data)
          c->set_private_data(private);
}

("private" is perhaps not the best name for this if it's to be shared
with the prioritizer but you get the idea).

Let me know if this would be sufficient for your needs.

Btw, I'm still working on my approach for the async checker mechanism,
which will be quite different from what we had before, and based on my
recent "runner" patch set. I'll try to design it such that porting your
code to that framework will be easy. (That's why I just had another
look at your code).

Regards
Martin
