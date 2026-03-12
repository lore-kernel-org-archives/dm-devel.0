Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D4F8276058
	for <dm-devel@lists.linux.dev>; Thu, 12 Mar 2026 00:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773274613; cv=none; b=aPg+8BkOkFGlqOATy0Zc1upf4WD3lzg9IFYfLoHM9s2uXt2MwOv43PI/XBVww+5scrskujTiNS0A2Z54vVsxV4YsdNq7COIwuagd7qV9GMr0aPrfhh3MaGWdWjwOoK9qANXdv34kTwvyLqE0xjVGOrRd1m0ZYVwg6i6kFhXON/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773274613; c=relaxed/simple;
	bh=uW8p/qWjBpBF29/2zbFFgOiuqtWvChD/ppMvsJP/HYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HQFrrm4Rn4FNomDpn7KTiSgqnDf5UooKjQfGxJRMv3SQZmdhwKYgpe9jYNWvh+R0AAk2yBsIPUPF/oDjF5hJDex9cyn2aejjLQ0tj5GnwXRgTZbrU5N4YvezMOM9z3crX63DHoF9VcsfFG+4lEO971neQrthw1xm6lvVvpklN1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=cV8GoMaG; arc=none smtp.client-ip=74.125.82.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="cV8GoMaG"
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-2be26d11b95so843628eec.0
        for <dm-devel@lists.linux.dev>; Wed, 11 Mar 2026 17:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1773274610; x=1773879410; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4pLZV2TBA0xVAbmq0dgrffx9N8SVT+pxIUR2MwpIlaU=;
        b=cV8GoMaGBOllzudkf4bwfZwdLlqYxUgBLJoxMSD0LnwGbmpQkKg44u5x/gKzmpHaIX
         gNPX7xLf9ENHqo9o2pDCLB5bYJWQyLWwpLW3GdF/2Lk7/o8PyuCljfjsgHmF798Tq5fV
         ZK/wlLrtc/BNrpHeHYDB8QTDH+2BbQKCNUjcwapnGaga+rS3FkpZmVcVUouJGw0k/Sya
         +y7QydpO3McdOaHW/fnww4t8Q+L5F5nWvhmHsIKeQFi/UzASIbOAxwzy3OXnpO8PujgC
         7oaRa/oCi29LX4ufDOP2NySHFSHBFLCRWkjrW5yFLL2KJzIRcfR+EziWd2ueWFxqEiq9
         KMCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773274610; x=1773879410;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4pLZV2TBA0xVAbmq0dgrffx9N8SVT+pxIUR2MwpIlaU=;
        b=wSAbEmOHw+7zar+9bcVU0ZF9H+khAM5+6JUUKdVbXBqnELWBme44gsLIvTbnKC7j1S
         WLikRWrysz9cKYLA2mg42GLirDqjh8lwD1gGeYdGtT0Fwu/wGbe+LWplNjtaukfpg6Y0
         lclbZkHk6sPj/hbGXFHEbFkPAyvCa/vnAeLGasxHYwIwcno89naaHqekBcGMvXzButee
         0X0iJSkCjISp4oyonTYds+uyE7QrY/tnK/ZKg0kfDwnRR9UrP5sO+jQFrZoUHJKueYNG
         j/NJDvHl2cF3b1Ou/coRi6VSq9q1uCeVxqcwXy2YDpCagH4fR/I28e1g8XbuEx/llCQ0
         Xmxg==
X-Forwarded-Encrypted: i=1; AJvYcCVGD1lKSrOAKw0/t3tSn7BQjDv2rPhgKcoCaa04kTv4kDLLCl7kuRo2t8f3K8a2/Zy6pzK9zXW3aQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YyPERz8Zhb3D+Ka1uTayxTS7rdWVrPMLstxMnPverZgG6C1io7H
	FLfCBrhym1YEiOGya1aZP1aBpnUwuzQ34MjKawbMjAJmB62/qAP6gwpmutTngQZT2j3EPVRAeb5
	HN6o5
X-Gm-Gg: ATEYQzz90xAgYa6bCa319WHKYaLbx05+YBquWBGt1Q3HmmCFNABg+wgPBJKQ4ht7NwZ
	6FW25lO0R0Y7Y/OJj3nucJ++4xiEg3DlhFgF7Dt4JN7C/oD6EvQH26xxtKtDtP2trLA6r52LiRy
	h9j0cLaJ4qgDcxgXgzeM1ueOch45Ub0IsNjtYO/2NERRBYQfn9y+KJN1Tds6PDGxrv7PIv5VNJm
	/1t8v1DISDFf2MV+GUrjNZZtU4Gud63P1ztmi9no+FJeVNleOShycG93iIzIdcfS+qXkVOFOTfV
	WxJeYvTohEDYokA/fV0Zn0pHKtP530Vh+KGR+t4SPovU274wntrQ1AOvawMPVMhenRbfKy1ndAP
	VI291m1AOC90sv0K2JiUL0fre/C+FrOczBrZ2p2JlyEB7kPpBgz2azYJFj4S1Vq7/5dANUnG2Yp
	57VokamY1fEHmlkIBARB93xpvshZX3txqLdfOYR7t+8Szr3wpNdv4xtNim1+oWAXeXPaswlv4mY
	mlSKKp9UaTY3XDHsa/EZoDPNoAHDE9O3B60eQNwb1SQPW1vcbv8iho=
X-Received: by 2002:a05:7301:678e:b0:2be:287e:e7f with SMTP id 5a478bee46e88-2be8a272ffdmr2098347eec.11.1773274610163;
        Wed, 11 Mar 2026 17:16:50 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([136.226.65.98])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2be8aa73ba6sm4375169eec.25.2026.03.11.17.16.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 11 Mar 2026 17:16:48 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: bmarzins@redhat.com,
	mwilck@suse.com,
	dm-devel@lists.linux.dev
Cc: Brian Bunker <brian@purestorage.com>
Subject: [PATCH 1/1] checkers: add alua path checker
Date: Wed, 11 Mar 2026 17:16:37 -0700
Message-ID: <20260312001642.53321-2-brian@purestorage.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260312001642.53321-1-brian@purestorage.com>
References: <20260312001642.53321-1-brian@purestorage.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit

Add an 'alua' path checker that uses RTPG to check path state, and an
'alua_cached' prioritizer that uses the checker's cached ALUA state.

The checker maps ALUA Asymmetric Access States to path states:
  - AAS_OPTIMIZED, AAS_NON_OPTIMIZED -> PATH_UP
  - AAS_STANDBY -> PATH_GHOST
  - AAS_TRANSITIONING -> PATH_PENDING
  - AAS_UNAVAILABLE, AAS_OFFLINE -> PATH_DOWN

The alua_cached prioritizer first checks for cached state from the alua
checker, then falls back to sysfs, then to issuing RTPG directly. This
maintains backward compatibility with other checker configurations.

When detect_checker is enabled, the alua checker is auto-selected for
devices with TPGS support. When the alua checker is in use, detect_prio
auto-selects the alua_cached prioritizer.

Signed-off-by: Brian Bunker <brian@purestorage.com>
---
 libmultipath/Makefile                   |   5 +
 libmultipath/checkers.c                 |   1 +
 libmultipath/checkers.h                 |   1 +
 libmultipath/checkers/Makefile          |   3 +-
 libmultipath/checkers/alua.c            | 426 ++++++++++++++++++++++++
 libmultipath/checkers/alua.h            |  15 +
 libmultipath/prio.c                     |   1 +
 libmultipath/prio.h                     |   1 +
 libmultipath/prioritizers/Makefile      |   1 +
 libmultipath/prioritizers/alua_cached.c | 224 +++++++++++++
 libmultipath/prioritizers/alua_rtpg.c   |  12 +-
 libmultipath/prioritizers/alua_rtpg.h   |   1 +
 libmultipath/prioritizers/sysfs.c       |   7 +-
 libmultipath/propsel.c                  |  20 +-
 libmultipath/structs.c                  |   2 +
 libmultipath/structs.h                  |   3 +
 16 files changed, 716 insertions(+), 7 deletions(-)
 create mode 100644 libmultipath/checkers/alua.c
 create mode 100644 libmultipath/checkers/alua.h
 create mode 100644 libmultipath/prioritizers/alua_cached.c

diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index 85767ab4..379f4d02 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -38,6 +38,11 @@ nvme-lib.o: nvme-lib.c nvme-ioctl.c nvme-ioctl.h
 dict.o:	dict.c
 	$(Q)$(CC) $(CPPFLAGS) $(CFLAGS) -Wno-unused-parameter -c -o $@ $<
 
+# checkers/alua.o needs to find headers in parent directory
+checkers/alua.o: checkers/alua.c
+	@echo building $@ because of $?
+	$(Q)$(CC) $(CPPFLAGS) $(CFLAGS) -I. -c -o $@ $<
+
 make_static = $(shell sed '/^static/!s/^\([a-z]\{1,\} \)/static \1/' <$1 >$2)
 
 nvme-ioctl.c: nvme/nvme-ioctl.c
diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
index bb6ad1ee..21aa52d4 100644
--- a/libmultipath/checkers.c
+++ b/libmultipath/checkers.c
@@ -461,6 +461,7 @@ int init_checkers(void)
 		EMC_CLARIION,
 		READSECTOR0,
 		CCISS_TUR,
+		ALUA_RTPG,
 	};
 	unsigned int i;
 
diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
index a969e7d1..2905f3fc 100644
--- a/libmultipath/checkers.h
+++ b/libmultipath/checkers.h
@@ -98,6 +98,7 @@ enum path_check_state {
 #define EMC_CLARIION "emc_clariion"
 #define READSECTOR0  "readsector0"
 #define CCISS_TUR    "cciss_tur"
+#define ALUA         "alua"
 #define NONE         "none"
 #define INVALID      "invalid"
 
diff --git a/libmultipath/checkers/Makefile b/libmultipath/checkers/Makefile
index 6f7cfb95..dfdd13a1 100644
--- a/libmultipath/checkers/Makefile
+++ b/libmultipath/checkers/Makefile
@@ -17,7 +17,8 @@ LIBS= \
 	libcheckdirectio.so \
 	libcheckemc_clariion.so \
 	libcheckhp_sw.so \
-	libcheckrdac.so
+	libcheckrdac.so \
+	libcheckalua.so
 
 all: $(LIBS)
 
diff --git a/libmultipath/checkers/alua.c b/libmultipath/checkers/alua.c
new file mode 100644
index 00000000..cb3d7000
--- /dev/null
+++ b/libmultipath/checkers/alua.c
@@ -0,0 +1,426 @@
+/*
+ * ALUA Path Checker
+ *
+ * Copyright (c) 2024
+ * This file is released under the GPL.
+ */
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/sysmacros.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <pthread.h>
+#include <urcu.h>
+#include <urcu/uatomic.h>
+
+#include "checkers.h"
+#include "debug.h"
+#include "structs.h"
+#include "prio.h"
+#include "util.h"
+#include "time-util.h"
+#include "../prioritizers/alua.h"
+#include "../prioritizers/alua_rtpg.h"
+#include "alua.h"
+
+#define MAX_NR_TIMEOUTS 1
+
+enum {
+	MSG_ALUA_RTPG_NOT_SUPPORTED = CHECKER_FIRST_MSGID,
+	MSG_ALUA_RTPG_TRANSITIONING,
+	MSG_ALUA_RUNNING,
+	MSG_ALUA_TIMEOUT,
+};
+
+#define IDX_(x) (MSG_ ## x - CHECKER_FIRST_MSGID)
+const char *libcheck_msgtable[] = {
+	[IDX_(ALUA_RTPG_NOT_SUPPORTED)] = " ALUA not supported",
+	[IDX_(ALUA_RTPG_TRANSITIONING)] = " path is transitioning",
+	[IDX_(ALUA_RUNNING)] = " still running",
+	[IDX_(ALUA_TIMEOUT)] = " timed out",
+	NULL,
+};
+
+struct alua_checker_context {
+	dev_t devt;
+	int state;
+	int running; /* uatomic access only */
+	int fd;
+	unsigned int timeout;
+	time_t time;
+	pthread_t thread;
+	pthread_mutex_t lock;
+	pthread_cond_t active;
+	int holders; /* uatomic access only */
+	int msgid;
+	struct checker_context ctx;
+	unsigned int nr_timeouts;
+	bool checked_state;
+	/* ALUA-specific cached data for prioritizer */
+	int aas;           /* Asymmetric Access State */
+	int tpg;           /* Target Port Group */
+	time_t timestamp;  /* When this data was collected */
+	/* Data needed for RTPG in thread */
+	struct path *pp;   /* Path pointer - only valid during check */
+};
+
+int libcheck_init(struct checker *c)
+{
+	struct alua_checker_context *ct;
+	struct stat sb;
+
+	ct = malloc(sizeof(struct alua_checker_context));
+	if (!ct)
+		return 1;
+	memset(ct, 0, sizeof(struct alua_checker_context));
+
+	ct->state = PATH_UNCHECKED;
+	ct->fd = -1;
+	ct->aas = -1;
+	ct->tpg = -1;
+	uatomic_set(&ct->holders, 1);
+	pthread_cond_init_mono(&ct->active);
+	pthread_mutex_init(&ct->lock, NULL);
+	if (fstat(c->fd, &sb) == 0)
+		ct->devt = sb.st_rdev;
+	ct->ctx.cls = c->cls;
+	c->context = ct;
+
+	return 0;
+}
+
+static void cleanup_context(struct alua_checker_context *ct)
+{
+	pthread_mutex_destroy(&ct->lock);
+	pthread_cond_destroy(&ct->active);
+	free(ct);
+}
+
+void libcheck_free(struct checker *c)
+{
+	if (c->context) {
+		struct alua_checker_context *ct = c->context;
+		int holders;
+		int running;
+
+		running = uatomic_xchg(&ct->running, 0);
+		if (running)
+			pthread_cancel(ct->thread);
+		ct->thread = 0;
+		holders = uatomic_sub_return(&ct->holders, 1);
+		if (!holders)
+			cleanup_context(ct);
+		c->context = NULL;
+	}
+	return;
+}
+
+/*
+ * Map ALUA Asymmetric Access State to path state
+ */
+static int alua_state_to_path_state(int aas, short *msgid)
+{
+	switch (aas & 0x0f) {
+	case AAS_OPTIMIZED:
+	case AAS_NON_OPTIMIZED:
+		*msgid = CHECKER_MSGID_UP;
+		return PATH_UP;
+	case AAS_STANDBY:
+		*msgid = CHECKER_MSGID_GHOST;
+		return PATH_GHOST;
+	case AAS_TRANSITIONING:
+		*msgid = MSG_ALUA_RTPG_TRANSITIONING;
+		return PATH_PENDING;
+	case AAS_UNAVAILABLE:
+	case AAS_OFFLINE:
+	default:
+		*msgid = CHECKER_MSGID_DOWN;
+		return PATH_DOWN;
+	}
+}
+
+/*
+ * Main ALUA check function - uses alua_rtpg.c library.
+ * This is called either in sync mode or from the async thread.
+ */
+static int
+alua_check(struct path *pp, int *aas_out, short *msgid)
+{
+	int aas;
+
+	if (pp->tpg_id == GROUP_ID_UNDEF) {
+		*msgid = CHECKER_MSGID_DOWN;
+		return PATH_DOWN;
+	}
+
+	aas = get_asymmetric_access_state(pp, pp->tpg_id);
+	if (aas < 0) {
+		if (aas == -RTPG_LUN_DISCONNECTED) {
+			*msgid = CHECKER_MSGID_DISCONNECTED;
+			return PATH_DISCONNECTED;
+		}
+		*msgid = CHECKER_MSGID_DOWN;
+		return PATH_DOWN;
+	}
+
+	*aas_out = aas;
+	return alua_state_to_path_state(aas, msgid);
+}
+
+#define alua_thread_cleanup_push(ct) pthread_cleanup_push(cleanup_func, ct)
+#define alua_thread_cleanup_pop(ct) pthread_cleanup_pop(1)
+
+static void cleanup_func(void *data)
+{
+	int holders;
+	struct alua_checker_context *ct = data;
+
+	holders = uatomic_sub_return(&ct->holders, 1);
+	if (!holders)
+		cleanup_context(ct);
+}
+
+void *libcheck_thread(struct checker_context *ctx)
+{
+	struct alua_checker_context *ct =
+		container_of(ctx, struct alua_checker_context, ctx);
+	int state, running;
+	short msgid;
+	int aas;
+
+	/* This thread can be canceled, so setup clean up */
+	alua_thread_cleanup_push(ct);
+
+	condlog(4, "%d:%d : alua checker starting up", major(ct->devt),
+		minor(ct->devt));
+
+	state = alua_check(ct->pp, &aas, &msgid);
+	pthread_testcancel();
+
+	/* ALUA checker done */
+	pthread_mutex_lock(&ct->lock);
+	ct->state = state;
+	ct->msgid = msgid;
+	ct->aas = aas;
+	ct->tpg = ct->pp->tpg_id;
+	ct->timestamp = time(NULL);
+	/* Update path-level cache for prioritizer use */
+	ct->pp->alua_state = aas;
+	ct->pp->alua_timestamp = ct->timestamp;
+	pthread_cond_signal(&ct->active);
+	pthread_mutex_unlock(&ct->lock);
+
+	condlog(4, "%d:%d : alua checker finished, state %s", major(ct->devt),
+		minor(ct->devt), checker_state_name(state));
+
+	running = uatomic_xchg(&ct->running, 0);
+	if (!running)
+		pause();
+
+	alua_thread_cleanup_pop(ct);
+
+	return ((void *)0);
+}
+
+static void alua_set_async_timeout(struct checker *c)
+{
+	struct alua_checker_context *ct = c->context;
+	struct timespec now;
+
+	get_monotonic_time(&now);
+	ct->time = now.tv_sec + c->timeout;
+}
+
+static int alua_check_async_timeout(struct checker *c)
+{
+	struct alua_checker_context *ct = c->context;
+	struct timespec now;
+
+	get_monotonic_time(&now);
+	return (now.tv_sec > ct->time);
+}
+
+static int check_pending(struct checker *c)
+{
+	struct alua_checker_context *ct = c->context;
+	int alua_status = PATH_PENDING;
+
+	pthread_mutex_lock(&ct->lock);
+	if (ct->state != PATH_PENDING || ct->msgid != MSG_ALUA_RUNNING) {
+		alua_status = ct->state;
+		c->msgid = ct->msgid;
+	}
+	pthread_mutex_unlock(&ct->lock);
+	if (alua_status == PATH_PENDING && c->msgid == MSG_ALUA_RUNNING) {
+		condlog(4, "%d:%d : alua checker still running",
+			major(ct->devt), minor(ct->devt));
+	} else {
+		int running = uatomic_xchg(&ct->running, 0);
+		if (running)
+			pthread_cancel(ct->thread);
+		ct->thread = 0;
+	}
+
+	ct->checked_state = true;
+	return alua_status;
+}
+
+bool libcheck_need_wait(struct checker *c)
+{
+	struct alua_checker_context *ct = c->context;
+	return (ct && ct->thread && uatomic_read(&ct->running) != 0 &&
+		!ct->checked_state);
+}
+
+int libcheck_pending(struct checker *c)
+{
+	struct alua_checker_context *ct = c->context;
+
+	/* The if path checker isn't running, just return the exiting value. */
+	if (!ct || !ct->thread)
+		return c->path_state;
+
+	return check_pending(c);
+}
+
+int libcheck_check(struct checker *c)
+{
+	struct alua_checker_context *ct = c->context;
+	struct path *pp = container_of(c, struct path, checker);
+	pthread_attr_t attr;
+	int alua_status = PATH_PENDING, r;
+	int aas;
+
+	if (!ct)
+		return PATH_UNCHECKED;
+
+	if (checker_is_sync(c)) {
+		alua_status = alua_check(pp, &aas, &c->msgid);
+		ct->tpg = pp->tpg_id;
+		ct->aas = aas;
+		ct->timestamp = time(NULL);
+		/* Update path-level cache for prioritizer use */
+		pp->alua_state = aas;
+		pp->alua_timestamp = ct->timestamp;
+		return alua_status;
+	}
+
+	/* Async mode */
+	if (ct->thread) {
+		ct->checked_state = true;
+		if (alua_check_async_timeout(c)) {
+			int running = uatomic_xchg(&ct->running, 0);
+			if (running) {
+				pthread_cancel(ct->thread);
+				condlog(3, "%d:%d : alua checker timeout",
+					major(ct->devt), minor(ct->devt));
+				c->msgid = MSG_ALUA_TIMEOUT;
+				alua_status = PATH_TIMEOUT;
+			} else {
+				pthread_mutex_lock(&ct->lock);
+				alua_status = ct->state;
+				c->msgid = ct->msgid;
+				pthread_mutex_unlock(&ct->lock);
+			}
+			ct->thread = 0;
+		} else if (uatomic_read(&ct->running) != 0) {
+			/*
+			 * ct->running may be stale - the thread sets
+			 * msgid/state under lock, then clears running
+			 * after releasing it. Check msgid under lock
+			 * to get the truth. Only MSG_ALUA_RUNNING means
+			 * no result yet.
+			 */
+			pthread_mutex_lock(&ct->lock);
+			if (ct->msgid != MSG_ALUA_RUNNING) {
+				alua_status = ct->state;
+				c->msgid = ct->msgid;
+				ct->thread = 0;
+			}
+			pthread_mutex_unlock(&ct->lock);
+		} else {
+			/* ALUA checker done */
+			ct->thread = 0;
+			pthread_mutex_lock(&ct->lock);
+			alua_status = ct->state;
+			c->msgid = ct->msgid;
+			pthread_mutex_unlock(&ct->lock);
+		}
+	} else {
+		if (uatomic_read(&ct->holders) > 1) {
+			/* The thread has been cancelled but hasn't quit. */
+			if (ct->nr_timeouts <= MAX_NR_TIMEOUTS) {
+				if (ct->nr_timeouts == MAX_NR_TIMEOUTS) {
+					condlog(2, "%d:%d : waiting for stalled alua thread to finish",
+						major(ct->devt), minor(ct->devt));
+				}
+				ct->nr_timeouts++;
+				c->msgid = MSG_ALUA_TIMEOUT;
+				return PATH_TIMEOUT;
+			}
+			ct->nr_timeouts++;
+			/*
+			 * Start a new thread while the old one is stalled.
+			 * We have to prevent it from interfering with the new
+			 * thread. We create a new context and leave the old
+			 * one with the stale thread, hoping it will clean up
+			 * eventually.
+			 */
+			condlog(3, "%d:%d : alua thread not responding",
+				major(ct->devt), minor(ct->devt));
+
+			if (libcheck_init(c) != 0) {
+				c->msgid = CHECKER_MSGID_DOWN;
+				return PATH_UNCHECKED;
+			}
+			((struct alua_checker_context *)c->context)->nr_timeouts = ct->nr_timeouts;
+
+			if (!uatomic_sub_return(&ct->holders, 1)) {
+				/* It did terminate, eventually */
+				cleanup_context(ct);
+				((struct alua_checker_context *)c->context)->nr_timeouts = 0;
+			}
+
+			ct = c->context;
+		} else
+			ct->nr_timeouts = 0;
+
+		/* Start new ALUA checker */
+		pthread_mutex_lock(&ct->lock);
+		alua_status = ct->state = PATH_PENDING;
+		c->msgid = ct->msgid = MSG_ALUA_RUNNING;
+		pthread_mutex_unlock(&ct->lock);
+		ct->fd = c->fd;
+		ct->timeout = c->timeout;
+		ct->pp = pp;
+		ct->checked_state = false;
+		uatomic_add(&ct->holders, 1);
+		uatomic_set(&ct->running, 1);
+		alua_set_async_timeout(c);
+		setup_thread_attr(&attr, 32 * 1024, 1);
+		r = start_checker_thread(&ct->thread, &attr, &ct->ctx);
+		pthread_attr_destroy(&attr);
+		if (r) {
+			uatomic_sub(&ct->holders, 1);
+			uatomic_set(&ct->running, 0);
+			ct->thread = 0;
+			condlog(3, "%d:%d : failed to start alua thread, using"
+				" sync mode", major(ct->devt), minor(ct->devt));
+			alua_status = alua_check(pp, &aas, &c->msgid);
+			ct->tpg = pp->tpg_id;
+			ct->aas = aas;
+			ct->timestamp = time(NULL);
+			/* Update path-level cache for prioritizer use */
+			pp->alua_state = aas;
+			pp->alua_timestamp = ct->timestamp;
+			return alua_status;
+		}
+	}
+
+	return alua_status;
+}
+
diff --git a/libmultipath/checkers/alua.h b/libmultipath/checkers/alua.h
new file mode 100644
index 00000000..b53cef66
--- /dev/null
+++ b/libmultipath/checkers/alua.h
@@ -0,0 +1,15 @@
+/*
+ * ALUA Path Checker Header
+ *
+ * This file is released under the GPL.
+ */
+#ifndef _ALUA_CHECKER_H
+#define _ALUA_CHECKER_H
+
+/* ALUA checker caches state in struct path for prioritizer use:
+ *   pp->alua_state     - cached AAS value (-1 if not cached)
+ *   pp->alua_timestamp - when the state was last updated
+ */
+
+#endif /* _ALUA_CHECKER_H */
+
diff --git a/libmultipath/prio.c b/libmultipath/prio.c
index 24f825bd..2d59d04e 100644
--- a/libmultipath/prio.c
+++ b/libmultipath/prio.c
@@ -29,6 +29,7 @@ int init_prio(void)
 #ifdef LOAD_ALL_SHARED_LIBS
 	static const char *const all_prios[] = {
 		PRIO_ALUA,
+		PRIO_ALUA_CACHED,
 		PRIO_CONST,
 		PRIO_DATACORE,
 		PRIO_EMC,
diff --git a/libmultipath/prio.h b/libmultipath/prio.h
index 119b75f2..b54ece0d 100644
--- a/libmultipath/prio.h
+++ b/libmultipath/prio.h
@@ -17,6 +17,7 @@ struct path;
  * Known prioritizers for use in hwtable.c
  */
 #define PRIO_ALUA		"alua"
+#define PRIO_ALUA_CACHED	"alua_cached"
 #define PRIO_CONST		"const"
 #define PRIO_DATACORE		"datacore"
 #define PRIO_EMC		"emc"
diff --git a/libmultipath/prioritizers/Makefile b/libmultipath/prioritizers/Makefile
index ff2524c2..201c52c0 100644
--- a/libmultipath/prioritizers/Makefile
+++ b/libmultipath/prioritizers/Makefile
@@ -13,6 +13,7 @@ LIBDEPS = -lmultipath -lmpathutil -lm -lpthread -lrt
 # If you add or remove a prioritizer also update multipath/multipath.conf.5
 LIBS = \
 	libprioalua.so \
+	libprioalua_cached.so \
 	libprioconst.so \
 	libpriodatacore.so \
 	libprioemc.so \
diff --git a/libmultipath/prioritizers/alua_cached.c b/libmultipath/prioritizers/alua_cached.c
new file mode 100644
index 00000000..2ba5b2e7
--- /dev/null
+++ b/libmultipath/prioritizers/alua_cached.c
@@ -0,0 +1,224 @@
+/*
+ * (C) Copyright IBM Corp. 2004, 2005   All Rights Reserved.
+ * Modified 2024 to support cached ALUA state from checker
+ *
+ * ALUA prioritizer that can use cached state from alua checker
+ * to avoid duplicate RTPG commands.
+ *
+ * This file is released under the GPL.
+ */
+#include <stdio.h>
+#include <string.h>
+
+#include <time.h>
+
+#include "debug.h"
+#include "prio.h"
+#include "structs.h"
+#include "checkers.h"
+#include "discovery.h"
+
+#include "alua.h"
+
+#define ALUA_PRIO_NOT_SUPPORTED			1
+#define ALUA_PRIO_RTPG_FAILED			2
+#define ALUA_PRIO_GETAAS_FAILED			3
+#define ALUA_PRIO_TPGS_FAILED			4
+#define ALUA_PRIO_NO_INFORMATION		5
+#define ALUA_PRIO_CACHED_STALE			6
+
+/* Maximum age of cached ALUA state in seconds */
+#define ALUA_CACHE_MAX_AGE_SECS			5
+
+static const char * aas_string[] = {
+	[AAS_OPTIMIZED]		= "active/optimized",
+	[AAS_NON_OPTIMIZED]	= "active/non-optimized",
+	[AAS_STANDBY]		= "standby",
+	[AAS_UNAVAILABLE]	= "unavailable",
+	[AAS_LBA_DEPENDENT]	= "logical block dependent",
+	[AAS_RESERVED]		= "ARRAY BUG: invalid TPGs state!",
+	[AAS_OFFLINE]		= "offline",
+	[AAS_TRANSITIONING]	= "transitioning between states",
+};
+
+static const char *aas_print_string(int rc)
+{
+	rc &= 0x7f;
+
+	if (rc & 0x70)
+		return aas_string[AAS_RESERVED];
+	rc &= 0x0f;
+	if (rc > AAS_RESERVED && rc < AAS_OFFLINE)
+		return aas_string[AAS_RESERVED];
+	else
+		return aas_string[rc];
+}
+
+/*
+ * Try to get ALUA info with optimization:
+ * 1. If using alua checker: use its cached state (it just polled!)
+ * 2. Try sysfs (kernel maintains this, no I/O needed)
+ * 3. Fall back to issuing RTPG directly
+ *
+ * Rationale: The checker is our active poller. If we're using alua
+ * and its cache is fresh, we trust that data first. If the cache misses
+ * (stale or empty), we try sysfs before issuing RTPG. This provides a
+ * three-tier optimization: checker cache → sysfs → RTPG.
+ */
+/* Maximum length of sysfs access_state string */
+#define ALUA_ACCESS_STATE_SIZE 32
+
+int
+get_alua_info_cached(struct path * pp, bool *used_cache)
+{
+	int	rc;
+	int	tpg;
+	bool	diff_tpg;
+	char	buff[ALUA_ACCESS_STATE_SIZE];
+
+	*used_cache = false;
+
+	/* First: if using alua checker, use its fresh data from path structure */
+	if (checker_selected(&pp->checker)) {
+		const char *chk_name = checker_name(&pp->checker);
+
+		if (chk_name && strcmp(chk_name, "alua") == 0 &&
+		    pp->alua_state >= 0) {
+			time_t now = time(NULL);
+			time_t age = now - pp->alua_timestamp;
+
+			if (pp->alua_timestamp > 0 && age <= ALUA_CACHE_MAX_AGE_SECS) {
+				condlog(4, "%s: using cached ALUA state from checker (fresh poll)", pp->dev);
+				*used_cache = true;
+				return pp->alua_state;
+			}
+			condlog(4, "%s: cached ALUA state not available or stale, trying sysfs",
+				pp->dev);
+			/* Cache miss - try sysfs before issuing RTPG */
+		}
+	}
+
+	/* Second: try sysfs (if cache missed or not using alua checker) */
+	rc = sysfs_get_asymmetric_access_state(pp, buff, sizeof(buff));
+	if (rc >= 0) {
+		/* Parse sysfs state string to ALUA state value */
+		int aas = -1;
+		int priopath = rc; /* rc contains preferred bit */
+
+		if (!strncmp(buff, "active/optimized", 16))
+			aas = AAS_OPTIMIZED;
+		else if (!strncmp(buff, "active/non-optimized", 20))
+			aas = AAS_NON_OPTIMIZED;
+		else if (!strncmp(buff, "lba-dependent", 13))
+			aas = AAS_LBA_DEPENDENT;
+		else if (!strncmp(buff, "standby", 7))
+			aas = AAS_STANDBY;
+
+		if (aas >= 0) {
+			condlog(4, "%s: using sysfs ALUA state (no I/O)", pp->dev);
+			*used_cache = true;
+			return (priopath ? 0x80 : 0) | aas;
+		}
+	}
+
+	/* Last resort: issue RTPG directly */
+	tpg = get_target_port_group(pp);
+	if (tpg < 0) {
+		rc = get_target_port_group_support(pp);
+		if (rc < 0)
+			return -ALUA_PRIO_TPGS_FAILED;
+		if (rc == TPGS_NONE)
+			return -ALUA_PRIO_NOT_SUPPORTED;
+		return -ALUA_PRIO_RTPG_FAILED;
+	}
+	diff_tpg = (pp->tpg_id != GROUP_ID_UNDEF && pp->tpg_id != tpg);
+	pp->tpg_id = tpg;
+	condlog((diff_tpg) ? 2 : 4, "%s: reported target port group is %i",
+		pp->dev, tpg);
+	rc = get_asymmetric_access_state(pp, tpg);
+	if (rc < 0) {
+		condlog(2, "%s: get_asymmetric_access_state returned %d",
+			__func__, rc);
+		return -ALUA_PRIO_GETAAS_FAILED;
+	}
+
+	condlog(3, "%s: aas = %02x [%s]%s", pp->dev, rc, aas_print_string(rc),
+		(rc & 0x80) ? " [preferred]" : "");
+	return rc;
+}
+
+int get_exclusive_pref_arg(char *args)
+{
+	char *ptr;
+
+	if (args == NULL)
+		return 0;
+	ptr = strstr(args, "exclusive_pref_bit");
+	if (!ptr)
+		return 0;
+	if (ptr[18] != '\0' && ptr[18] != ' ' && ptr[18] != '\t')
+		return 0;
+	if (ptr != args && ptr[-1] != ' ' && ptr[-1] != '\t')
+		return 0;
+	return 1;
+}
+
+int getprio (struct path * pp, char * args)
+{
+	int rc;
+	int aas;
+	int priopath;
+	int exclusive_pref;
+	bool used_cache = false;
+
+	if (pp->fd < 0)
+		return -ALUA_PRIO_NO_INFORMATION;
+
+	exclusive_pref = get_exclusive_pref_arg(args);
+	rc = get_alua_info_cached(pp, &used_cache);
+
+	if (used_cache) {
+		condlog(4, "%s: priority calculated from cached ALUA state (no RTPG issued)",
+			pp->dev);
+	}
+
+	if (rc >= 0) {
+		aas = (rc & 0x0f);
+		priopath = (rc & 0x80);
+		switch(aas) {
+		case AAS_OPTIMIZED:
+			rc = 50;
+			break;
+		case AAS_NON_OPTIMIZED:
+			rc = 10;
+			break;
+		case AAS_LBA_DEPENDENT:
+			rc = 5;
+			break;
+		case AAS_STANDBY:
+			rc = 1;
+			break;
+		default:
+			rc = 0;
+		}
+		if (priopath && (aas != AAS_OPTIMIZED || exclusive_pref))
+			rc += 80;
+	} else {
+		switch(-rc) {
+		case ALUA_PRIO_NOT_SUPPORTED:
+			condlog(0, "%s: alua not supported", pp->dev);
+			break;
+		case ALUA_PRIO_RTPG_FAILED:
+			condlog(0, "%s: couldn't get target port group", pp->dev);
+			break;
+		case ALUA_PRIO_GETAAS_FAILED:
+			condlog(0, "%s: couldn't get asymmetric access state", pp->dev);
+			break;
+		case ALUA_PRIO_TPGS_FAILED:
+			condlog(3, "%s: couldn't get supported alua states", pp->dev);
+			break;
+		}
+	}
+	return rc;
+}
+
diff --git a/libmultipath/prioritizers/alua_rtpg.c b/libmultipath/prioritizers/alua_rtpg.c
index 053cccb7..5da06b50 100644
--- a/libmultipath/prioritizers/alua_rtpg.c
+++ b/libmultipath/prioritizers/alua_rtpg.c
@@ -75,6 +75,7 @@ enum scsi_disposition {
 	SCSI_GOOD = 0,
 	SCSI_ERROR,
 	SCSI_RETRY,
+	SCSI_DISCONNECTED,
 };
 
 static int
@@ -124,6 +125,12 @@ scsi_error(struct sg_io_hdr *hdr, int opcode)
 	PRINT_DEBUG("alua: SCSI error for command %02x: status %02x, sense %02x/%02x/%02x",
 		    opcode, hdr->status, sense_key, asc, ascq);
 
+	/* Check for disconnected LUN (unmapped at target) */
+	if (sense_key == 0x5 && asc == 0x25 && ascq == 0x00) {
+		/* ILLEGAL REQUEST / LOGICAL UNIT NOT SUPPORTED */
+		return SCSI_DISCONNECTED;
+	}
+
 	if (sense_key == UNIT_ATTENTION || sense_key == NOT_READY)
 		return SCSI_RETRY;
 	else
@@ -325,7 +332,10 @@ retry:
 	}
 
 	rc = scsi_error(&hdr, OPERATION_CODE_RTPG);
-	if (rc == SCSI_ERROR) {
+	if (rc == SCSI_DISCONNECTED) {
+		PRINT_DEBUG("do_rtpg: LUN disconnected (unmapped at target)!");
+		return -RTPG_LUN_DISCONNECTED;
+	} else if (rc == SCSI_ERROR) {
 		PRINT_DEBUG("do_rtpg: SCSI error!");
 		return -RTPG_RTPG_FAILED;
 	} else if (rc == SCSI_RETRY) {
diff --git a/libmultipath/prioritizers/alua_rtpg.h b/libmultipath/prioritizers/alua_rtpg.h
index ff6ec0ef..030ca58d 100644
--- a/libmultipath/prioritizers/alua_rtpg.h
+++ b/libmultipath/prioritizers/alua_rtpg.h
@@ -21,6 +21,7 @@
 #define RTPG_NO_TPG_IDENTIFIER			2
 #define RTPG_RTPG_FAILED			3
 #define RTPG_TPG_NOT_FOUND			4
+#define RTPG_LUN_DISCONNECTED			5
 
 int get_target_port_group_support(const struct path *pp);
 int get_target_port_group(const struct path *pp);
diff --git a/libmultipath/prioritizers/sysfs.c b/libmultipath/prioritizers/sysfs.c
index 5e8adc05..ab058ea9 100644
--- a/libmultipath/prioritizers/sysfs.c
+++ b/libmultipath/prioritizers/sysfs.c
@@ -10,6 +10,9 @@
 #include "discovery.h"
 #include "prio.h"
 
+/* Maximum length of sysfs access_state string */
+#define ALUA_ACCESS_STATE_SIZE 32
+
 static const struct {
 	unsigned char value;
 	char *name;
@@ -39,11 +42,11 @@ int get_exclusive_pref_arg(char *args)
 int getprio (struct path * pp, char *args)
 {
 	int prio = 0, rc, i;
-	char buff[512];
+	char buff[ALUA_ACCESS_STATE_SIZE];
 	int exclusive_pref;
 
 	exclusive_pref = get_exclusive_pref_arg(args);
-	rc = sysfs_get_asymmetric_access_state(pp, buff, 512);
+	rc = sysfs_get_asymmetric_access_state(pp, buff, sizeof(buff));
 	if (rc < 0)
 		return PRIO_UNDEF;
 	prio = 0;
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 56895c4b..e421abba 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -262,6 +262,7 @@ verify_alua_prio(struct multipath *mp)
 		if (!prio_selected(&pp->prio))
 			continue;
 		if (strncmp(name, PRIO_ALUA, PRIO_NAME_LEN) &&
+		    strncmp(name, PRIO_ALUA_CACHED, PRIO_NAME_LEN) &&
 		    strncmp(name, PRIO_SYSFS, PRIO_NAME_LEN))
 			 return false;
 		assume_alua = true;
@@ -690,7 +691,12 @@ int select_checker(struct config *conf, struct path *pp)
 		}
 		(void)path_get_tpgs(pp);
 		if (pp->tpgs != TPGS_NONE && pp->tpgs != TPGS_UNDEF) {
-			ckr_name = TUR;
+			/*
+			 * For ALUA devices (any TPGS support), use alua
+			 * checker which combines path checking with ALUA state
+			 * caching for optimal performance.
+			 */
+			ckr_name = ALUA;
 			goto out;
 		}
 	}
@@ -767,8 +773,15 @@ void detect_prio(struct path *pp)
 		if ((tpgs == TPGS_EXPLICIT || !check_rdac(pp)) &&
 		    sysfs_get_asymmetric_access_state(pp, buff, 512) >= 0)
 			default_prio = PRIO_SYSFS;
-		else
+		else {
 			default_prio = PRIO_ALUA;
+			/* If using alua checker, use cached prioritizer */
+			if (checker_selected(&pp->checker)) {
+				const char *chk_name = checker_name(&pp->checker);
+				if (chk_name && strcmp(chk_name, ALUA) == 0)
+					default_prio = PRIO_ALUA_CACHED;
+			}
+		}
 		break;
 	default:
 		return;
@@ -831,7 +844,8 @@ out:
 	/*
 	 * fetch tpgs mode for alua, if its not already obtained
 	 */
-	if (!strncmp(prio_name(p), PRIO_ALUA, PRIO_NAME_LEN)) {
+	if (!strncmp(prio_name(p), PRIO_ALUA, PRIO_NAME_LEN) ||
+	    !strncmp(prio_name(p), PRIO_ALUA_CACHED, PRIO_NAME_LEN)) {
 		int tpgs = path_get_tpgs(pp);
 
 		if (tpgs == TPGS_NONE) {
diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index f4413127..6483a568 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -126,6 +126,8 @@ alloc_path (void)
 		pp->fd = -1;
 		pp->tpgs = TPGS_UNDEF;
 		pp->tpg_id = GROUP_ID_UNDEF;
+		pp->alua_state = -1;
+		pp->alua_timestamp = 0;
 		pp->priority = PRIO_UNDEF;
 		pp->checkint = CHECKINT_UNDEF;
 		checker_clear(&pp->checker);
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 9adedde2..c4bddee9 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -444,6 +444,9 @@ struct path {
 	vector hwe;
 	struct gen_path generic_path;
 	int tpg_id;
+	/* Cached ALUA state from checker for prioritizer use */
+	int alua_state;		/* AAS value, -1 if not cached */
+	time_t alua_timestamp;	/* When alua_state was last updated */
 	enum ioctl_info_states ioctl_info;
 };
 
-- 
2.50.1 (Apple Git-155)

