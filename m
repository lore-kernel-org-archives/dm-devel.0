Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8F6324B33
	for <dm-devel@lists.linux.dev>; Thu, 12 Mar 2026 19:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773344027; cv=pass; b=UpxOZygy3yPZALDz7YvE2FBvjASpo1UzuAiwuNs9CAh0mvO4itE42xdp+bwAevhp4kDatsuMcDg+87hFwmDZ9CuRTRMhevjoQzipgEp6hQvm6Ev1t2jxH9a+OJYSv7bV91jvevbiROmPljD6ATxDTDyN5GTncV8It+JnmF49Swo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773344027; c=relaxed/simple;
	bh=QKQETjE7Rz1xCLlb0XAgTrjHmsQopymEw0yd2kjXO8I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=YfiBPinlKfxMwHQhEox+CnmEC5B0QdKW0Hy42zcEDvwmEixVHzSCOIw0idsN4caMxUUzM2dv3g2TomTC/SExZmVRX2RmKWlLwy+htTOqwifOWP2lzrdZsgYIsnZbkk3OeN0/E6IeGIl4QoIRAdGBAyh4sCfANliAjDcEiFYqZt8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=DTV3v7wu; arc=pass smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="DTV3v7wu"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-38a2f196cbaso12518331fa.1
        for <dm-devel@lists.linux.dev>; Thu, 12 Mar 2026 12:33:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773344022; cv=none;
        d=google.com; s=arc-20240605;
        b=h+aaSHOlyJ1QUubbeHE9oI3MApjlVJlbntUN/GKCLUv8HWx6CGsHSiHG08sPa+r37V
         PeWbObC/tcmt5ErxCIeQUJfnGosuKIlnropllaPMC/C2AHIzYMj18kh/C75JXZmfKcX4
         2p91K5asPmfP9E6YlqV7n5H0g/xyq7N9lpQjvs1mcqJvnYd0D6wtfs2Gazuy+zZ0d15v
         KMvPsDyBoeKHhxZU4vosnr5Ho37kIp2vTw4RMXZloVYzLqDrdk6+7VPvzYrMLiS1pgtw
         BjlblzQvR7Tu0kx6oWX5slYGlCenBzrWNQlk7r8TxzZJ5wHcbEK/JX4eRgB7BRCbMMJA
         RIzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pXplQwKMSeR1DFGOxSp1YeM5eTNTUdKO66vNajK3jWI=;
        fh=l3CRNgvI34UZ3wS7PlCwranVVWi6QT1yE5+JJM716rk=;
        b=Y4lc+Gr8I5rWLdRYCm1Qg+xSgpNehfcYS06z1jIWZUm5DiP59dZfVUxWWLAhSuyz1M
         FIPqvoseS55CKH99dzsXpE/3PDCpvppqMsqGvNvzGTcw6UHBaR5Q3VyaLq9TU6BxAXQY
         5TP5bCy+nF7vrSRkliHQqAQtYBlIiDEiYa7VskVx/wan2fgKrEMDh36J9LtR2P8xQ+S5
         WovSYNkjSQQviEm2imhVK3iFNid4VSnqTYfxzldH/WLW5Svh/LAdCcNAtqwLLU8vAb0I
         1wxUNA+m8o+Sghw41P+ft7GS7kxuuwvNjP4CyQsWYt49PoEY6q+JTsdPbawvpXeLdgKO
         zwhA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1773344022; x=1773948822; darn=lists.linux.dev;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pXplQwKMSeR1DFGOxSp1YeM5eTNTUdKO66vNajK3jWI=;
        b=DTV3v7wu7u8hZ67unTuOy8ItgcW/PxM+Hvi/cYmBJJD7RPmC+owrHpXdLwN7OZmNAj
         GGPtbWmE3m989pz45qShnT4KY0RthDPhN0ZrWeqFvMRtKCkQa/Y2IDL32+pR/J13vSWT
         AH6Zk3ant/jnmy9Zt3WhuYKc7W3qnvcZDodYKt5UT3pND56jhasz4B6sl5eW2G1LeinO
         gDaKhInLsklMNHTLYzskavvvy0nozRwj8q0RGGLO2f87iXl8xeRH0kuEHYIOq68cqm6M
         6S+ftOQph170WzqZF8nCWnVJABcyVYSWXG9jV/+MDgZHvLqlbnffvytsWCYRTTKE+1qk
         CvYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773344022; x=1773948822;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pXplQwKMSeR1DFGOxSp1YeM5eTNTUdKO66vNajK3jWI=;
        b=VA0HnrgfXUjV/BI9O0IYPOIvgXLPj3b011LMtO9BDJPaZ5yNXPM/Zr6e13Q4UdRAgE
         Sfu6kdVhEEy/cMyi49WmltYBXjDwvYV8IQtmQbfi37TLZAk+vYh+A/GmMxvgK0Q2/yvC
         ZbXW3U+HiZLoiMIw5Ad+mhn5HwupWXu5LFqZhs/Ln5xDzg9xCuhYh4ziZEnQ3UPsqdgK
         t1BdbkpgC7ykXGKdSAba5rviki1rqJcMWCyDDh2DDMwTnd68YtZPmXaufXBJPMarblHz
         OL+Qex66OS32G9f0qucvyVnwHoykb+yiS5CLxhNHHR6KpJ4o9scVEyNzfwod9zZWx3L9
         vTpQ==
X-Gm-Message-State: AOJu0YwrVUOKqae9p5q4HKn9Two3dSAnIOJX+y+1SxveNPjRuBlHE7RN
	QV2AxZi/Hyq/nFQ7kflxmFA2kDswpCh0ekg1wy08xnPIrykiX/NeU0YSs9h/+Z68Kj4JPbgQe2B
	vIbk2Nvhhb445vdOCrYFWaqHHGy+IcuYSoObtHMKltGMWz86E1UbA
X-Gm-Gg: ATEYQzynC5lzXuwFggry7+Ds+gTteLtx5JaPM9OLM6kQIdOhse/OzDYD8Bl0BreDAY8
	BIlH7R3WdcLX76Gn3bSfpRNxiK93GUEORPOr14VYpu3ski1nU7zsBQvAfc4ZNmYjmC48voxjMJ3
	J3GBFaZPwq8jpjrLBNU84FNJzRa9eBfU+dJpdUnQfr+eefGVCkQqssIYdy6tnemSKM3EFTQHnOt
	KCAJEGrVMFg/GlHJpIRFa7gWridx0yWFZdJSQZAcT8FTpUGeSwS/4ncEvr6TCoA41maxUPvMi1w
	1Oi9oP/1yKRpWSYtft4ZE8zCy6JWtup69fK6jixPxwQFqcLw0TNNo6nK6Lryo5w=
X-Received: by 2002:a2e:9a0e:0:b0:38a:6acb:e5f5 with SMTP id
 38308e7fff4ca-38a897d3822mr1358511fa.29.1773344021838; Thu, 12 Mar 2026
 12:33:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260312001642.53321-1-brian@purestorage.com> <20260312001642.53321-2-brian@purestorage.com>
 <8653507a25c02727037e7e8bad4b2178a9702040.camel@suse.com>
In-Reply-To: <8653507a25c02727037e7e8bad4b2178a9702040.camel@suse.com>
From: Brian Bunker <brian@purestorage.com>
Date: Thu, 12 Mar 2026 12:33:27 -0700
X-Gm-Features: AaiRm51bTKY4rzxz8AGQ7VtIlrx8qAOHnrIQr00z0hU_0GJAJBxFYBpT6lounCE
Message-ID: <CAHZQxy+uoOFU2pneAmsmOFFUCsz=3eNPQQa95zGYEOnoFYyrMQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] checkers: add alua path checker
To: dm-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 12, 2026 at 9:32=E2=80=AFAM Martin Wilck <mwilck@suse.com> wrot=
e:
>
> Hi Brian,
>
> On Wed, 2026-03-11 at 17:16 -0700, Brian Bunker wrote:
> > Add an 'alua' path checker that uses RTPG to check path state, and an
> > 'alua_cached' prioritizer that uses the checker's cached ALUA state.
> >
> > The checker maps ALUA Asymmetric Access States to path states:
> >   - AAS_OPTIMIZED, AAS_NON_OPTIMIZED -> PATH_UP
> >   - AAS_STANDBY -> PATH_GHOST
> >   - AAS_TRANSITIONING -> PATH_PENDING
> >   - AAS_UNAVAILABLE, AAS_OFFLINE -> PATH_DOWN
> >
> > The alua_cached prioritizer first checks for cached state from the
> > alua
> > checker, then falls back to sysfs, then to issuing RTPG directly.
> > This
> > maintains backward compatibility with other checker configurations.
> >
> > When detect_checker is enabled, the alua checker is auto-selected for
> > devices with TPGS support. When the alua checker is in use,
> > detect_prio
> > auto-selects the alua_cached prioritizer.
> >
> > Signed-off-by: Brian Bunker <brian@purestorage.com>
>
> Thanks! Just a few remarks for now.
>
> Martin
>
> > ---
> >  libmultipath/Makefile                   |   5 +
> >  libmultipath/checkers.c                 |   1 +
> >  libmultipath/checkers.h                 |   1 +
> >  libmultipath/checkers/Makefile          |   3 +-
> >  libmultipath/checkers/alua.c            | 426
> > ++++++++++++++++++++++++
> >  libmultipath/checkers/alua.h            |  15 +
> >  libmultipath/prio.c                     |   1 +
> >  libmultipath/prio.h                     |   1 +
> >  libmultipath/prioritizers/Makefile      |   1 +
> >  libmultipath/prioritizers/alua_cached.c | 224 +++++++++++++
> >  libmultipath/prioritizers/alua_rtpg.c   |  12 +-
> >  libmultipath/prioritizers/alua_rtpg.h   |   1 +
> >  libmultipath/prioritizers/sysfs.c       |   7 +-
> >  libmultipath/propsel.c                  |  20 +-
> >  libmultipath/structs.c                  |   2 +
> >  libmultipath/structs.h                  |   3 +
> >  16 files changed, 716 insertions(+), 7 deletions(-)
> >  create mode 100644 libmultipath/checkers/alua.c
> >  create mode 100644 libmultipath/checkers/alua.h
> >  create mode 100644 libmultipath/prioritizers/alua_cached.c
> >
> > diff --git a/libmultipath/Makefile b/libmultipath/Makefile
> > index 85767ab4..379f4d02 100644
> > --- a/libmultipath/Makefile
> > +++ b/libmultipath/Makefile
> > @@ -38,6 +38,11 @@ nvme-lib.o: nvme-lib.c nvme-ioctl.c nvme-ioctl.h
> >  dict.o:      dict.c
> >       $(Q)$(CC) $(CPPFLAGS) $(CFLAGS) -Wno-unused-parameter -c -o
> > $@ $<
> >
> > +# checkers/alua.o needs to find headers in parent directory
> > +checkers/alua.o: checkers/alua.c
> > +     @echo building $@ because of $?
> > +     $(Q)$(CC) $(CPPFLAGS) $(CFLAGS) -I. -c -o $@ $<
> > +
> >  make_static =3D $(shell sed '/^static/!s/^\([a-z]\{1,\} \)/static \1/'
> > <$1 >$2)
> >
> >  nvme-ioctl.c: nvme/nvme-ioctl.c
> > diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
> > index bb6ad1ee..21aa52d4 100644
> > --- a/libmultipath/checkers.c
> > +++ b/libmultipath/checkers.c
> > @@ -461,6 +461,7 @@ int init_checkers(void)
> >               EMC_CLARIION,
> >               READSECTOR0,
> >               CCISS_TUR,
> > +             ALUA_RTPG,
> >       };
> >       unsigned int i;
> >
> > diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
> > index a969e7d1..2905f3fc 100644
> > --- a/libmultipath/checkers.h
> > +++ b/libmultipath/checkers.h
> > @@ -98,6 +98,7 @@ enum path_check_state {
> >  #define EMC_CLARIION "emc_clariion"
> >  #define READSECTOR0  "readsector0"
> >  #define CCISS_TUR    "cciss_tur"
> > +#define ALUA         "alua"
> >  #define NONE         "none"
> >  #define INVALID      "invalid"
> >
> > diff --git a/libmultipath/checkers/Makefile
> > b/libmultipath/checkers/Makefile
> > index 6f7cfb95..dfdd13a1 100644
> > --- a/libmultipath/checkers/Makefile
> > +++ b/libmultipath/checkers/Makefile
> > @@ -17,7 +17,8 @@ LIBS=3D \
> >       libcheckdirectio.so \
> >       libcheckemc_clariion.so \
> >       libcheckhp_sw.so \
> > -     libcheckrdac.so
> > +     libcheckrdac.so \
> > +     libcheckalua.so
> >
> >  all: $(LIBS)
> >
> > diff --git a/libmultipath/checkers/alua.c
> > b/libmultipath/checkers/alua.c
> > new file mode 100644
> > index 00000000..cb3d7000
> > --- /dev/null
> > +++ b/libmultipath/checkers/alua.c
> > @@ -0,0 +1,426 @@
> > +/*
> > + * ALUA Path Checker
> > + *
> > + * Copyright (c) 2024
> > + * This file is released under the GPL.
>
> Please add a proper license header.
I will do that.
>
> > + */
> > +#include <stdio.h>
> > +#include <stdlib.h>
> > +#include <string.h>
> > +#include <sys/types.h>
> > +#include <sys/stat.h>
> > +#include <sys/sysmacros.h>
> > +#include <unistd.h>
> > +#include <fcntl.h>
> > +#include <errno.h>
> > +#include <pthread.h>
> > +#include <urcu.h>
> > +#include <urcu/uatomic.h>
> > +
> > +#include "checkers.h"
> > +#include "debug.h"
> > +#include "structs.h"
> > +#include "prio.h"
> > +#include "util.h"
> > +#include "time-util.h"
> > +#include "../prioritizers/alua.h"
> > +#include "../prioritizers/alua_rtpg.h"
> > +#include "alua.h"
> > +
> > +#define MAX_NR_TIMEOUTS 1
> > +
> > +enum {
> > +     MSG_ALUA_RTPG_NOT_SUPPORTED =3D CHECKER_FIRST_MSGID,
> > +     MSG_ALUA_RTPG_TRANSITIONING,
> > +     MSG_ALUA_RUNNING,
> > +     MSG_ALUA_TIMEOUT,
> > +};
> > +
> > +#define IDX_(x) (MSG_ ## x - CHECKER_FIRST_MSGID)
> > +const char *libcheck_msgtable[] =3D {
> > +     [IDX_(ALUA_RTPG_NOT_SUPPORTED)] =3D " ALUA not supported",
> > +     [IDX_(ALUA_RTPG_TRANSITIONING)] =3D " path is transitioning",
> > +     [IDX_(ALUA_RUNNING)] =3D " still running",
> > +     [IDX_(ALUA_TIMEOUT)] =3D " timed out",
> > +     NULL,
> > +};
> > +
> > +struct alua_checker_context {
> > +     dev_t devt;
> > +     int state;
> > +     int running; /* uatomic access only */
> > +     int fd;
> > +     unsigned int timeout;
> > +     time_t time;
> > +     pthread_t thread;
> > +     pthread_mutex_t lock;
> > +     pthread_cond_t active;
> > +     int holders; /* uatomic access only */
> > +     int msgid;
> > +     struct checker_context ctx;
> > +     unsigned int nr_timeouts;
> > +     bool checked_state;
> > +     /* ALUA-specific cached data for prioritizer */
> > +     int aas;           /* Asymmetric Access State */
> > +     int tpg;           /* Target Port Group */
> > +     time_t timestamp;  /* When this data was collected */
> > +     /* Data needed for RTPG in thread */
> > +     struct path *pp;   /* Path pointer - only valid during check
> > */
> > +};
>
> Instead of duplicating the threading implementation of the TUR checker
> here we should abstract it out and use the common framework by both
> checkers (and others, too, maybe). This is a thing I've wanted to do
> for a long time. Maybe it's time to start doing it now.
I considered that sort of re-work, but I was concerned that changes
adding to the existing checker might muddy the waters. There are certainly
changes where helper functions could be extracted for both checkers
to leverage them.
>
>
>
>
> > +
> > +int libcheck_init(struct checker *c)
> > +{
> > +     struct alua_checker_context *ct;
> > +     struct stat sb;
> > +
> > +     ct =3D malloc(sizeof(struct alua_checker_context));
> > +     if (!ct)
> > +             return 1;
> > +     memset(ct, 0, sizeof(struct alua_checker_context));
> > +
> > +     ct->state =3D PATH_UNCHECKED;
> > +     ct->fd =3D -1;
> > +     ct->aas =3D -1;
> > +     ct->tpg =3D -1;
> > +     uatomic_set(&ct->holders, 1);
> > +     pthread_cond_init_mono(&ct->active);
> > +     pthread_mutex_init(&ct->lock, NULL);
> > +     if (fstat(c->fd, &sb) =3D=3D 0)
> > +             ct->devt =3D sb.st_rdev;
> > +     ct->ctx.cls =3D c->cls;
> > +     c->context =3D ct;
> > +
> > +     return 0;
> > +}
> > +
> > +static void cleanup_context(struct alua_checker_context *ct)
> > +{
> > +     pthread_mutex_destroy(&ct->lock);
> > +     pthread_cond_destroy(&ct->active);
> > +     free(ct);
> > +}
> > +
> > +void libcheck_free(struct checker *c)
> > +{
> > +     if (c->context) {
> > +             struct alua_checker_context *ct =3D c->context;
> > +             int holders;
> > +             int running;
> > +
> > +             running =3D uatomic_xchg(&ct->running, 0);
> > +             if (running)
> > +                     pthread_cancel(ct->thread);
> > +             ct->thread =3D 0;
> > +             holders =3D uatomic_sub_return(&ct->holders, 1);
> > +             if (!holders)
> > +                     cleanup_context(ct);
> > +             c->context =3D NULL;
> > +     }
> > +     return;
> > +}
> > +
> > +/*
> > + * Map ALUA Asymmetric Access State to path state
> > + */
> > +static int alua_state_to_path_state(int aas, short *msgid)
> > +{
> > +     switch (aas & 0x0f) {
> > +     case AAS_OPTIMIZED:
> > +     case AAS_NON_OPTIMIZED:
> > +             *msgid =3D CHECKER_MSGID_UP;
> > +             return PATH_UP;
> > +     case AAS_STANDBY:
> > +             *msgid =3D CHECKER_MSGID_GHOST;
> > +             return PATH_GHOST;
> > +     case AAS_TRANSITIONING:
> > +             *msgid =3D MSG_ALUA_RTPG_TRANSITIONING;
> > +             return PATH_PENDING;
> > +     case AAS_UNAVAILABLE:
> > +     case AAS_OFFLINE:
> > +     default:
> > +             *msgid =3D CHECKER_MSGID_DOWN;
> > +             return PATH_DOWN;
> > +     }
> > +}
> > +
> > +/*
> > + * Main ALUA check function - uses alua_rtpg.c library.
> > + * This is called either in sync mode or from the async thread.
> > + */
> > +static int
> > +alua_check(struct path *pp, int *aas_out, short *msgid)
> > +{
> > +     int aas;
> > +
> > +     if (pp->tpg_id =3D=3D GROUP_ID_UNDEF) {
> > +             *msgid =3D CHECKER_MSGID_DOWN;
> > +             return PATH_DOWN;
> > +     }
> > +
> > +     aas =3D get_asymmetric_access_state(pp, pp->tpg_id);
> > +     if (aas < 0) {
> > +             if (aas =3D=3D -RTPG_LUN_DISCONNECTED) {
> > +                     *msgid =3D CHECKER_MSGID_DISCONNECTED;
> > +                     return PATH_DISCONNECTED;
> > +             }
> > +             *msgid =3D CHECKER_MSGID_DOWN;
> > +             return PATH_DOWN;
> > +     }
> > +
> > +     *aas_out =3D aas;
> > +     return alua_state_to_path_state(aas, msgid);
> > +}
> > +
> > +#define alua_thread_cleanup_push(ct)
> > pthread_cleanup_push(cleanup_func, ct)
> > +#define alua_thread_cleanup_pop(ct) pthread_cleanup_pop(1)
> > +
> > +static void cleanup_func(void *data)
> > +{
> > +     int holders;
> > +     struct alua_checker_context *ct =3D data;
> > +
> > +     holders =3D uatomic_sub_return(&ct->holders, 1);
> > +     if (!holders)
> > +             cleanup_context(ct);
> > +}
> > +
> > +void *libcheck_thread(struct checker_context *ctx)
> > +{
> > +     struct alua_checker_context *ct =3D
> > +             container_of(ctx, struct alua_checker_context, ctx);
> > +     int state, running;
> > +     short msgid;
> > +     int aas;
> > +
> > +     /* This thread can be canceled, so setup clean up */
> > +     alua_thread_cleanup_push(ct);
> > +
> > +     condlog(4, "%d:%d : alua checker starting up", major(ct-
> > >devt),
> > +             minor(ct->devt));
> > +
> > +     state =3D alua_check(ct->pp, &aas, &msgid);
> > +     pthread_testcancel();
> > +
> > +     /* ALUA checker done */
> > +     pthread_mutex_lock(&ct->lock);
> > +     ct->state =3D state;
> > +     ct->msgid =3D msgid;
> > +     ct->aas =3D aas;
> > +     ct->tpg =3D ct->pp->tpg_id;
> > +     ct->timestamp =3D time(NULL);
> > +     /* Update path-level cache for prioritizer use */
> > +     ct->pp->alua_state =3D aas;
> > +     ct->pp->alua_timestamp =3D ct->timestamp;
> > +     pthread_cond_signal(&ct->active);
> > +     pthread_mutex_unlock(&ct->lock);
> > +
> > +     condlog(4, "%d:%d : alua checker finished, state %s",
> > major(ct->devt),
> > +             minor(ct->devt), checker_state_name(state));
> > +
> > +     running =3D uatomic_xchg(&ct->running, 0);
> > +     if (!running)
> > +             pause();
> > +
> > +     alua_thread_cleanup_pop(ct);
> > +
> > +     return ((void *)0);
> > +}
> > +
> > +static void alua_set_async_timeout(struct checker *c)
> > +{
> > +     struct alua_checker_context *ct =3D c->context;
> > +     struct timespec now;
> > +
> > +     get_monotonic_time(&now);
> > +     ct->time =3D now.tv_sec + c->timeout;
> > +}
> > +
> > +static int alua_check_async_timeout(struct checker *c)
> > +{
> > +     struct alua_checker_context *ct =3D c->context;
> > +     struct timespec now;
> > +
> > +     get_monotonic_time(&now);
> > +     return (now.tv_sec > ct->time);
> > +}
> > +
> > +static int check_pending(struct checker *c)
> > +{
> > +     struct alua_checker_context *ct =3D c->context;
> > +     int alua_status =3D PATH_PENDING;
> > +
> > +     pthread_mutex_lock(&ct->lock);
> > +     if (ct->state !=3D PATH_PENDING || ct->msgid !=3D
> > MSG_ALUA_RUNNING) {
> > +             alua_status =3D ct->state;
> > +             c->msgid =3D ct->msgid;
> > +     }
> > +     pthread_mutex_unlock(&ct->lock);
> > +     if (alua_status =3D=3D PATH_PENDING && c->msgid =3D=3D
> > MSG_ALUA_RUNNING) {
> > +             condlog(4, "%d:%d : alua checker still running",
> > +                     major(ct->devt), minor(ct->devt));
> > +     } else {
> > +             int running =3D uatomic_xchg(&ct->running, 0);
> > +             if (running)
> > +                     pthread_cancel(ct->thread);
> > +             ct->thread =3D 0;
> > +     }
> > +
> > +     ct->checked_state =3D true;
> > +     return alua_status;
> > +}
> > +
> > +bool libcheck_need_wait(struct checker *c)
> > +{
> > +     struct alua_checker_context *ct =3D c->context;
> > +     return (ct && ct->thread && uatomic_read(&ct->running) !=3D 0
> > &&
> > +             !ct->checked_state);
> > +}
> > +
> > +int libcheck_pending(struct checker *c)
> > +{
> > +     struct alua_checker_context *ct =3D c->context;
> > +
> > +     /* The if path checker isn't running, just return the
> > exiting value. */
> > +     if (!ct || !ct->thread)
> > +             return c->path_state;
> > +
> > +     return check_pending(c);
> > +}
> > +
> > +int libcheck_check(struct checker *c)
> > +{
> > +     struct alua_checker_context *ct =3D c->context;
> > +     struct path *pp =3D container_of(c, struct path, checker);
> > +     pthread_attr_t attr;
> > +     int alua_status =3D PATH_PENDING, r;
> > +     int aas;
> > +
> > +     if (!ct)
> > +             return PATH_UNCHECKED;
> > +
> > +     if (checker_is_sync(c)) {
> > +             alua_status =3D alua_check(pp, &aas, &c->msgid);
> > +             ct->tpg =3D pp->tpg_id;
> > +             ct->aas =3D aas;
> > +             ct->timestamp =3D time(NULL);
> > +             /* Update path-level cache for prioritizer use */
> > +             pp->alua_state =3D aas;
> > +             pp->alua_timestamp =3D ct->timestamp;
> > +             return alua_status;
> > +     }
> > +
> > +     /* Async mode */
> > +     if (ct->thread) {
> > +             ct->checked_state =3D true;
> > +             if (alua_check_async_timeout(c)) {
> > +                     int running =3D uatomic_xchg(&ct->running, 0);
> > +                     if (running) {
> > +                             pthread_cancel(ct->thread);
> > +                             condlog(3, "%d:%d : alua checker
> > timeout",
> > +                                     major(ct->devt), minor(ct-
> > >devt));
> > +                             c->msgid =3D MSG_ALUA_TIMEOUT;
> > +                             alua_status =3D PATH_TIMEOUT;
> > +                     } else {
> > +                             pthread_mutex_lock(&ct->lock);
> > +                             alua_status =3D ct->state;
> > +                             c->msgid =3D ct->msgid;
> > +                             pthread_mutex_unlock(&ct->lock);
> > +                     }
> > +                     ct->thread =3D 0;
> > +             } else if (uatomic_read(&ct->running) !=3D 0) {
> > +                     /*
> > +                      * ct->running may be stale - the thread
> > sets
> > +                      * msgid/state under lock, then clears
> > running
> > +                      * after releasing it. Check msgid under
> > lock
> > +                      * to get the truth. Only MSG_ALUA_RUNNING
> > means
> > +                      * no result yet.
> > +                      */
> > +                     pthread_mutex_lock(&ct->lock);
> > +                     if (ct->msgid !=3D MSG_ALUA_RUNNING) {
> > +                             alua_status =3D ct->state;
> > +                             c->msgid =3D ct->msgid;
> > +                             ct->thread =3D 0;
> > +                     }
> > +                     pthread_mutex_unlock(&ct->lock);
> > +             } else {
> > +                     /* ALUA checker done */
> > +                     ct->thread =3D 0;
> > +                     pthread_mutex_lock(&ct->lock);
> > +                     alua_status =3D ct->state;
> > +                     c->msgid =3D ct->msgid;
> > +                     pthread_mutex_unlock(&ct->lock);
> > +             }
> > +     } else {
> > +             if (uatomic_read(&ct->holders) > 1) {
> > +                     /* The thread has been cancelled but hasn't
> > quit. */
> > +                     if (ct->nr_timeouts <=3D MAX_NR_TIMEOUTS) {
> > +                             if (ct->nr_timeouts =3D=3D
> > MAX_NR_TIMEOUTS) {
> > +                                     condlog(2, "%d:%d : waiting
> > for stalled alua thread to finish",
> > +                                             major(ct->devt),
> > minor(ct->devt));
> > +                             }
> > +                             ct->nr_timeouts++;
> > +                             c->msgid =3D MSG_ALUA_TIMEOUT;
> > +                             return PATH_TIMEOUT;
> > +                     }
> > +                     ct->nr_timeouts++;
> > +                     /*
> > +                      * Start a new thread while the old one is
> > stalled.
> > +                      * We have to prevent it from interfering
> > with the new
> > +                      * thread. We create a new context and leave
> > the old
> > +                      * one with the stale thread, hoping it will
> > clean up
> > +                      * eventually.
> > +                      */
> > +                     condlog(3, "%d:%d : alua thread not
> > responding",
> > +                             major(ct->devt), minor(ct->devt));
> > +
> > +                     if (libcheck_init(c) !=3D 0) {
> > +                             c->msgid =3D CHECKER_MSGID_DOWN;
> > +                             return PATH_UNCHECKED;
> > +                     }
> > +                     ((struct alua_checker_context *)c->context)-
> > >nr_timeouts =3D ct->nr_timeouts;
> > +
> > +                     if (!uatomic_sub_return(&ct->holders, 1)) {
> > +                             /* It did terminate, eventually */
> > +                             cleanup_context(ct);
> > +                             ((struct alua_checker_context *)c-
> > >context)->nr_timeouts =3D 0;
> > +                     }
> > +
> > +                     ct =3D c->context;
> > +             } else
> > +                     ct->nr_timeouts =3D 0;
> > +
> > +             /* Start new ALUA checker */
> > +             pthread_mutex_lock(&ct->lock);
> > +             alua_status =3D ct->state =3D PATH_PENDING;
> > +             c->msgid =3D ct->msgid =3D MSG_ALUA_RUNNING;
> > +             pthread_mutex_unlock(&ct->lock);
> > +             ct->fd =3D c->fd;
> > +             ct->timeout =3D c->timeout;
> > +             ct->pp =3D pp;
> > +             ct->checked_state =3D false;
> > +             uatomic_add(&ct->holders, 1);
> > +             uatomic_set(&ct->running, 1);
> > +             alua_set_async_timeout(c);
> > +             setup_thread_attr(&attr, 32 * 1024, 1);
> > +             r =3D start_checker_thread(&ct->thread, &attr, &ct-
> > >ctx);
> > +             pthread_attr_destroy(&attr);
> > +             if (r) {
> > +                     uatomic_sub(&ct->holders, 1);
> > +                     uatomic_set(&ct->running, 0);
> > +                     ct->thread =3D 0;
> > +                     condlog(3, "%d:%d : failed to start alua
> > thread, using"
> > +                             " sync mode", major(ct->devt),
> > minor(ct->devt));
> > +                     alua_status =3D alua_check(pp, &aas, &c-
> > >msgid);
> > +                     ct->tpg =3D pp->tpg_id;
> > +                     ct->aas =3D aas;
> > +                     ct->timestamp =3D time(NULL);
> > +                     /* Update path-level cache for prioritizer
> > use */
> > +                     pp->alua_state =3D aas;
> > +                     pp->alua_timestamp =3D ct->timestamp;
> > +                     return alua_status;
> > +             }
> > +     }
> > +
> > +     return alua_status;
> > +}
> > +
> > diff --git a/libmultipath/checkers/alua.h
> > b/libmultipath/checkers/alua.h
> > new file mode 100644
> > index 00000000..b53cef66
> > --- /dev/null
> > +++ b/libmultipath/checkers/alua.h
> > @@ -0,0 +1,15 @@
> > +/*
> > + * ALUA Path Checker Header
> > + *
> > + * This file is released under the GPL.
>
> Please add a proper license header.
>
> > + */
> > +#ifndef _ALUA_CHECKER_H
> > +#define _ALUA_CHECKER_H
> > +
> > +/* ALUA checker caches state in struct path for prioritizer use:
> > + *   pp->alua_state     - cached AAS value (-1 if not cached)
> > + *   pp->alua_timestamp - when the state was last updated
> > + */
> > +
> > +#endif /* _ALUA_CHECKER_H */
> > +
>
> Only comments in this file?
I will look at this. It was likely leftover.
>
>
> > diff --git a/libmultipath/prio.c b/libmultipath/prio.c
> > index 24f825bd..2d59d04e 100644
> > --- a/libmultipath/prio.c
> > +++ b/libmultipath/prio.c
> > @@ -29,6 +29,7 @@ int init_prio(void)
> >  #ifdef LOAD_ALL_SHARED_LIBS
> >       static const char *const all_prios[] =3D {
> >               PRIO_ALUA,
> > +             PRIO_ALUA_CACHED,
> >               PRIO_CONST,
> >               PRIO_DATACORE,
> >               PRIO_EMC,
> > diff --git a/libmultipath/prio.h b/libmultipath/prio.h
> > index 119b75f2..b54ece0d 100644
> > --- a/libmultipath/prio.h
> > +++ b/libmultipath/prio.h
> > @@ -17,6 +17,7 @@ struct path;
> >   * Known prioritizers for use in hwtable.c
> >   */
> >  #define PRIO_ALUA            "alua"
> > +#define PRIO_ALUA_CACHED     "alua_cached"
> >  #define PRIO_CONST           "const"
> >  #define PRIO_DATACORE                "datacore"
> >  #define PRIO_EMC             "emc"
> > diff --git a/libmultipath/prioritizers/Makefile
> > b/libmultipath/prioritizers/Makefile
> > index ff2524c2..201c52c0 100644
> > --- a/libmultipath/prioritizers/Makefile
> > +++ b/libmultipath/prioritizers/Makefile
> > @@ -13,6 +13,7 @@ LIBDEPS =3D -lmultipath -lmpathutil -lm -lpthread -
> > lrt
> >  # If you add or remove a prioritizer also update
> > multipath/multipath.conf.5
> >  LIBS =3D \
> >       libprioalua.so \
> > +     libprioalua_cached.so \
> >       libprioconst.so \
> >       libpriodatacore.so \
> >       libprioemc.so \
>
> I think the below should go into a separate patch.
Can they be separated? The prioritizer's logic relies
on the checker populating values for its decision.
>
> > diff --git a/libmultipath/prioritizers/alua_cached.c
> > b/libmultipath/prioritizers/alua_cached.c
> > new file mode 100644
> > index 00000000..2ba5b2e7
> > --- /dev/null
> > +++ b/libmultipath/prioritizers/alua_cached.c
> > @@ -0,0 +1,224 @@
> > +/*
> > + * (C) Copyright IBM Corp. 2004, 2005   All Rights Reserved.
> > + * Modified 2024 to support cached ALUA state from checker
> > + *
> > + * ALUA prioritizer that can use cached state from alua checker
> > + * to avoid duplicate RTPG commands.
> > + *
> > + * This file is released under the GPL.
>
> Please add a proper license header.
>
> > + */
> > +#include <stdio.h>
> > +#include <string.h>
> > +
> > +#include <time.h>
> > +
> > +#include "debug.h"
> > +#include "prio.h"
> > +#include "structs.h"
> > +#include "checkers.h"
> > +#include "discovery.h"
> > +
> > +#include "alua.h"
> > +
> > +#define ALUA_PRIO_NOT_SUPPORTED                      1
> > +#define ALUA_PRIO_RTPG_FAILED                        2
> > +#define ALUA_PRIO_GETAAS_FAILED                      3
> > +#define ALUA_PRIO_TPGS_FAILED                        4
> > +#define ALUA_PRIO_NO_INFORMATION             5
> > +#define ALUA_PRIO_CACHED_STALE                       6
> > +
> > +/* Maximum age of cached ALUA state in seconds */
> > +#define ALUA_CACHE_MAX_AGE_SECS                      5
> > +
> > +static const char * aas_string[] =3D {
> > +     [AAS_OPTIMIZED]         =3D "active/optimized",
> > +     [AAS_NON_OPTIMIZED]     =3D "active/non-optimized",
> > +     [AAS_STANDBY]           =3D "standby",
> > +     [AAS_UNAVAILABLE]       =3D "unavailable",
> > +     [AAS_LBA_DEPENDENT]     =3D "logical block dependent",
> > +     [AAS_RESERVED]          =3D "ARRAY BUG: invalid TPGs state!",
> > +     [AAS_OFFLINE]           =3D "offline",
> > +     [AAS_TRANSITIONING]     =3D "transitioning between states",
> > +};
>
> We shouldn't duplicate the definition of these constants.
This was somewhat intentional though not efficient. I will
do better with leveraging in the next patch.
>
> > +
> > +static const char *aas_print_string(int rc)
> > +{
> > +     rc &=3D 0x7f;
> > +
> > +     if (rc & 0x70)
> > +             return aas_string[AAS_RESERVED];
> > +     rc &=3D 0x0f;
> > +     if (rc > AAS_RESERVED && rc < AAS_OFFLINE)
> > +             return aas_string[AAS_RESERVED];
> > +     else
> > +             return aas_string[rc];
> > +}
> > +
> > +/*
> > + * Try to get ALUA info with optimization:
> > + * 1. If using alua checker: use its cached state (it just polled!)
> > + * 2. Try sysfs (kernel maintains this, no I/O needed)
> > + * 3. Fall back to issuing RTPG directly
> > + *
> > + * Rationale: The checker is our active poller. If we're using alua
> > + * and its cache is fresh, we trust that data first. If the cache
> > misses
> > + * (stale or empty), we try sysfs before issuing RTPG. This provides
> > a
> > + * three-tier optimization: checker cache =E2=86=92 sysfs =E2=86=92 RT=
PG.
> > + */
> > +/* Maximum length of sysfs access_state string */
> > +#define ALUA_ACCESS_STATE_SIZE 32
> > +
> > +int
> > +get_alua_info_cached(struct path * pp, bool *used_cache)
> > +{
> > +     int     rc;
> > +     int     tpg;
> > +     bool    diff_tpg;
> > +     char    buff[ALUA_ACCESS_STATE_SIZE];
> > +
> > +     *used_cache =3D false;
> > +
> > +     /* First: if using alua checker, use its fresh data from
> > path structure */
> > +     if (checker_selected(&pp->checker)) {
> > +             const char *chk_name =3D checker_name(&pp->checker);
> > +
> > +             if (chk_name && strcmp(chk_name, "alua") =3D=3D 0 &&
> > +                 pp->alua_state >=3D 0) {
> > +                     time_t now =3D time(NULL);
> > +                     time_t age =3D now - pp->alua_timestamp;
> > +
> > +                     if (pp->alua_timestamp > 0 && age <=3D
> > ALUA_CACHE_MAX_AGE_SECS) {
> > +                             condlog(4, "%s: using cached ALUA
> > state from checker (fresh poll)", pp->dev);
> > +                             *used_cache =3D true;
> > +                             return pp->alua_state;
> > +                     }
> > +                     condlog(4, "%s: cached ALUA state not
> > available or stale, trying sysfs",
> > +                             pp->dev);
> > +                     /* Cache miss - try sysfs before issuing
> > RTPG */
> > +             }
> > +     }
> > +
> > +     /* Second: try sysfs (if cache missed or not using alua
> > checker) */
> > +     rc =3D sysfs_get_asymmetric_access_state(pp, buff,
> > sizeof(buff));
> > +     if (rc >=3D 0) {
> > +             /* Parse sysfs state string to ALUA state value */
> > +             int aas =3D -1;
> > +             int priopath =3D rc; /* rc contains preferred bit */
> > +
> > +             if (!strncmp(buff, "active/optimized", 16))
> > +                     aas =3D AAS_OPTIMIZED;
> > +             else if (!strncmp(buff, "active/non-optimized", 20))
> > +                     aas =3D AAS_NON_OPTIMIZED;
> > +             else if (!strncmp(buff, "lba-dependent", 13))
> > +                     aas =3D AAS_LBA_DEPENDENT;
> > +             else if (!strncmp(buff, "standby", 7))
> > +                     aas =3D AAS_STANDBY;
> > +
> > +             if (aas >=3D 0) {
> > +                     condlog(4, "%s: using sysfs ALUA state (no
> > I/O)", pp->dev);
> > +                     *used_cache =3D true;
> > +                     return (priopath ? 0x80 : 0) | aas;
> > +             }
> > +     }
> > +
> > +     /* Last resort: issue RTPG directly */
> > +     tpg =3D get_target_port_group(pp);
> > +     if (tpg < 0) {
> > +             rc =3D get_target_port_group_support(pp);
> > +             if (rc < 0)
> > +                     return -ALUA_PRIO_TPGS_FAILED;
> > +             if (rc =3D=3D TPGS_NONE)
> > +                     return -ALUA_PRIO_NOT_SUPPORTED;
> > +             return -ALUA_PRIO_RTPG_FAILED;
> > +     }
> > +     diff_tpg =3D (pp->tpg_id !=3D GROUP_ID_UNDEF && pp->tpg_id !=3D
> > tpg);
> > +     pp->tpg_id =3D tpg;
> > +     condlog((diff_tpg) ? 2 : 4, "%s: reported target port group
> > is %i",
> > +             pp->dev, tpg);
> > +     rc =3D get_asymmetric_access_state(pp, tpg);
> > +     if (rc < 0) {
> > +             condlog(2, "%s: get_asymmetric_access_state returned
> > %d",
> > +                     __func__, rc);
> > +             return -ALUA_PRIO_GETAAS_FAILED;
> > +     }
> > +
> > +     condlog(3, "%s: aas =3D %02x [%s]%s", pp->dev, rc,
> > aas_print_string(rc),
> > +             (rc & 0x80) ? " [preferred]" : "");
> > +     return rc;
> > +}
> > +
> > +int get_exclusive_pref_arg(char *args)
> > +{
> > +     char *ptr;
> > +
> > +     if (args =3D=3D NULL)
> > +             return 0;
> > +     ptr =3D strstr(args, "exclusive_pref_bit");
> > +     if (!ptr)
> > +             return 0;
> > +     if (ptr[18] !=3D '\0' && ptr[18] !=3D ' ' && ptr[18] !=3D '\t')
> > +             return 0;
> > +     if (ptr !=3D args && ptr[-1] !=3D ' ' && ptr[-1] !=3D '\t')
> > +             return 0;
> > +     return 1;
> > +}
> > +
> > +int getprio (struct path * pp, char * args)
> > +{
> > +     int rc;
> > +     int aas;
> > +     int priopath;
> > +     int exclusive_pref;
> > +     bool used_cache =3D false;
> > +
> > +     if (pp->fd < 0)
> > +             return -ALUA_PRIO_NO_INFORMATION;
> > +
> > +     exclusive_pref =3D get_exclusive_pref_arg(args);
> > +     rc =3D get_alua_info_cached(pp, &used_cache);
> > +
> > +     if (used_cache) {
> > +             condlog(4, "%s: priority calculated from cached ALUA
> > state (no RTPG issued)",
> > +                     pp->dev);
> > +     }
> > +
> > +     if (rc >=3D 0) {
> > +             aas =3D (rc & 0x0f);
> > +             priopath =3D (rc & 0x80);
> > +             switch(aas) {
> > +             case AAS_OPTIMIZED:
> > +                     rc =3D 50;
> > +                     break;
> > +             case AAS_NON_OPTIMIZED:
> > +                     rc =3D 10;
> > +                     break;
> > +             case AAS_LBA_DEPENDENT:
> > +                     rc =3D 5;
> > +                     break;
> > +             case AAS_STANDBY:
> > +                     rc =3D 1;
> > +                     break;
> > +             default:
> > +                     rc =3D 0;
> > +             }
> > +             if (priopath && (aas !=3D AAS_OPTIMIZED ||
> > exclusive_pref))
> > +                     rc +=3D 80;
> > +     } else {
> > +             switch(-rc) {
> > +             case ALUA_PRIO_NOT_SUPPORTED:
> > +                     condlog(0, "%s: alua not supported", pp-
> > >dev);
> > +                     break;
> > +             case ALUA_PRIO_RTPG_FAILED:
> > +                     condlog(0, "%s: couldn't get target port
> > group", pp->dev);
> > +                     break;
> > +             case ALUA_PRIO_GETAAS_FAILED:
> > +                     condlog(0, "%s: couldn't get asymmetric
> > access state", pp->dev);
> > +                     break;
> > +             case ALUA_PRIO_TPGS_FAILED:
> > +                     condlog(3, "%s: couldn't get supported alua
> > states", pp->dev);
> > +                     break;
> > +             }
> > +     }
> > +     return rc;
> > +}
> > +
> > diff --git a/libmultipath/prioritizers/alua_rtpg.c
> > b/libmultipath/prioritizers/alua_rtpg.c
> > index 053cccb7..5da06b50 100644
> > --- a/libmultipath/prioritizers/alua_rtpg.c
> > +++ b/libmultipath/prioritizers/alua_rtpg.c
> > @@ -75,6 +75,7 @@ enum scsi_disposition {
> >       SCSI_GOOD =3D 0,
> >       SCSI_ERROR,
> >       SCSI_RETRY,
> > +     SCSI_DISCONNECTED,
> >  };
> >
> >  static int
> > @@ -124,6 +125,12 @@ scsi_error(struct sg_io_hdr *hdr, int opcode)
> >       PRINT_DEBUG("alua: SCSI error for command %02x: status %02x,
> > sense %02x/%02x/%02x",
> >                   opcode, hdr->status, sense_key, asc, ascq);
> >
> > +     /* Check for disconnected LUN (unmapped at target) */
> > +     if (sense_key =3D=3D 0x5 && asc =3D=3D 0x25 && ascq =3D=3D 0x00) =
{
> > +             /* ILLEGAL REQUEST / LOGICAL UNIT NOT SUPPORTED */
> > +             return SCSI_DISCONNECTED;
> > +     }
> > +
> >       if (sense_key =3D=3D UNIT_ATTENTION || sense_key =3D=3D NOT_READY=
)
> >               return SCSI_RETRY;
> >       else
> > @@ -325,7 +332,10 @@ retry:
> >       }
> >
> >       rc =3D scsi_error(&hdr, OPERATION_CODE_RTPG);
> > -     if (rc =3D=3D SCSI_ERROR) {
> > +     if (rc =3D=3D SCSI_DISCONNECTED) {
> > +             PRINT_DEBUG("do_rtpg: LUN disconnected (unmapped at
> > target)!");
> > +             return -RTPG_LUN_DISCONNECTED;
> > +     } else if (rc =3D=3D SCSI_ERROR) {
> >               PRINT_DEBUG("do_rtpg: SCSI error!");
> >               return -RTPG_RTPG_FAILED;
> >       } else if (rc =3D=3D SCSI_RETRY) {
> > diff --git a/libmultipath/prioritizers/alua_rtpg.h
> > b/libmultipath/prioritizers/alua_rtpg.h
> > index ff6ec0ef..030ca58d 100644
> > --- a/libmultipath/prioritizers/alua_rtpg.h
> > +++ b/libmultipath/prioritizers/alua_rtpg.h
> > @@ -21,6 +21,7 @@
> >  #define RTPG_NO_TPG_IDENTIFIER                       2
> >  #define RTPG_RTPG_FAILED                     3
> >  #define RTPG_TPG_NOT_FOUND                   4
> > +#define RTPG_LUN_DISCONNECTED                        5
> >
> >  int get_target_port_group_support(const struct path *pp);
> >  int get_target_port_group(const struct path *pp);
> > diff --git a/libmultipath/prioritizers/sysfs.c
> > b/libmultipath/prioritizers/sysfs.c
> > index 5e8adc05..ab058ea9 100644
> > --- a/libmultipath/prioritizers/sysfs.c
> > +++ b/libmultipath/prioritizers/sysfs.c
> > @@ -10,6 +10,9 @@
> >  #include "discovery.h"
> >  #include "prio.h"
> >
> > +/* Maximum length of sysfs access_state string */
> > +#define ALUA_ACCESS_STATE_SIZE 32
> > +
> >  static const struct {
> >       unsigned char value;
> >       char *name;
> > @@ -39,11 +42,11 @@ int get_exclusive_pref_arg(char *args)
> >  int getprio (struct path * pp, char *args)
> >  {
> >       int prio =3D 0, rc, i;
> > -     char buff[512];
> > +     char buff[ALUA_ACCESS_STATE_SIZE];
> >       int exclusive_pref;
> >
> >       exclusive_pref =3D get_exclusive_pref_arg(args);
> > -     rc =3D sysfs_get_asymmetric_access_state(pp, buff, 512);
> > +     rc =3D sysfs_get_asymmetric_access_state(pp, buff,
> > sizeof(buff));
> >       if (rc < 0)
> >               return PRIO_UNDEF;
> >       prio =3D 0;
> > diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> > index 56895c4b..e421abba 100644
> > --- a/libmultipath/propsel.c
> > +++ b/libmultipath/propsel.c
> > @@ -262,6 +262,7 @@ verify_alua_prio(struct multipath *mp)
> >               if (!prio_selected(&pp->prio))
> >                       continue;
> >               if (strncmp(name, PRIO_ALUA, PRIO_NAME_LEN) &&
> > +                 strncmp(name, PRIO_ALUA_CACHED, PRIO_NAME_LEN)
> > &&
> >                   strncmp(name, PRIO_SYSFS, PRIO_NAME_LEN))
> >                        return false;
> >               assume_alua =3D true;
> > @@ -690,7 +691,12 @@ int select_checker(struct config *conf, struct
> > path *pp)
> >               }
> >               (void)path_get_tpgs(pp);
> >               if (pp->tpgs !=3D TPGS_NONE && pp->tpgs !=3D TPGS_UNDEF)
> > {
> > -                     ckr_name =3D TUR;
> > +                     /*
> > +                      * For ALUA devices (any TPGS support), use
> > alua
> > +                      * checker which combines path checking with
> > ALUA state
> > +                      * caching for optimal performance.
> > +                      */
> > +                     ckr_name =3D ALUA;
> >                       goto out;
> >               }
> >       }
> > @@ -767,8 +773,15 @@ void detect_prio(struct path *pp)
> >               if ((tpgs =3D=3D TPGS_EXPLICIT || !check_rdac(pp)) &&
> >                   sysfs_get_asymmetric_access_state(pp, buff, 512)
> > >=3D 0)
> >                       default_prio =3D PRIO_SYSFS;
> > -             else
> > +             else {
> >                       default_prio =3D PRIO_ALUA;
> > +                     /* If using alua checker, use cached
> > prioritizer */
> > +                     if (checker_selected(&pp->checker)) {
> > +                             const char *chk_name =3D
> > checker_name(&pp->checker);
> > +                             if (chk_name && strcmp(chk_name,
> > ALUA) =3D=3D 0)
> > +                                     default_prio =3D
> > PRIO_ALUA_CACHED;
> > +                     }
> > +             }
> >               break;
> >       default:
> >               return;
> > @@ -831,7 +844,8 @@ out:
> >       /*
> >        * fetch tpgs mode for alua, if its not already obtained
> >        */
> > -     if (!strncmp(prio_name(p), PRIO_ALUA, PRIO_NAME_LEN)) {
> > +     if (!strncmp(prio_name(p), PRIO_ALUA, PRIO_NAME_LEN) ||
> > +         !strncmp(prio_name(p), PRIO_ALUA_CACHED, PRIO_NAME_LEN))
> > {
> >               int tpgs =3D path_get_tpgs(pp);
> >
> >               if (tpgs =3D=3D TPGS_NONE) {
> > diff --git a/libmultipath/structs.c b/libmultipath/structs.c
> > index f4413127..6483a568 100644
> > --- a/libmultipath/structs.c
> > +++ b/libmultipath/structs.c
> > @@ -126,6 +126,8 @@ alloc_path (void)
> >               pp->fd =3D -1;
> >               pp->tpgs =3D TPGS_UNDEF;
> >               pp->tpg_id =3D GROUP_ID_UNDEF;
> > +             pp->alua_state =3D -1;
> > +             pp->alua_timestamp =3D 0;
> >               pp->priority =3D PRIO_UNDEF;
> >               pp->checkint =3D CHECKINT_UNDEF;
> >               checker_clear(&pp->checker);
> > diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> > index 9adedde2..c4bddee9 100644
> > --- a/libmultipath/structs.h
> > +++ b/libmultipath/structs.h
> > @@ -444,6 +444,9 @@ struct path {
> >       vector hwe;
> >       struct gen_path generic_path;
> >       int tpg_id;
> > +     /* Cached ALUA state from checker for prioritizer use */
> > +     int alua_state;         /* AAS value, -1 if not
> > cached */
> > +     time_t alua_timestamp;  /* When alua_state was last updated
> > */
> >       enum ioctl_info_states ioctl_info;
> >  };
> >
I will put together a 2nd version which addresses these comments.
Thanks,
Brian
--=20
Brian Bunker
PURE Storage, Inc.
brian@purestorage.com
