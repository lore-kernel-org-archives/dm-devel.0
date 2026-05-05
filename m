Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C893048A2B2
	for <dm-devel@lists.linux.dev>; Tue,  5 May 2026 15:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777995851; cv=none; b=Alh7yWF+wBte/haKMGYZA2i7TSl/hqYz83glxwWXa3QfV1Acoq7SZ9YjT93uugJU5BCeE7Ml0FSGziqgiPA1f/vCcUhaHJW2Fib8v+b/J8n04tkF0jxAlp5eCzuUI0A3NcJHeeb3t8KlW16QLqDV41H653Uyx/SDk/bRxgUoMmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777995851; c=relaxed/simple;
	bh=fCd8eyB7f0SM9/sYMJFKP3PCJh1vCaJpCy3c8Gg0hK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lf94J/F4rhLR6qwXnpxtVvRYA0dO9T40dQoVKVyIMzMZweJw2LIzp11M01lhWw2RCJQYbgpdiws2N+YAlGZ6L33m5PflRsCf6q93Mnxu3Vu/I7fJk5tSEygpEEUkrptCrd6bBB+84OFa7a/rldG4uPP3itgM9+XKVU5KemUf59U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LFWCL5ru; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LFWCL5ru"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-488a8ca4aadso57268845e9.3
        for <dm-devel@lists.linux.dev>; Tue, 05 May 2026 08:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777995847; x=1778600647; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eP2CaYIiUzRkNVTCiezwUnhKqoleCnOWr9F8J8vHEFs=;
        b=LFWCL5ruLK9QiQdTkUOIdKGJx1jcptrRPb2ebSoCKvwlKADec0L4RvFJsWM9ATXY0Z
         +83NeZxFcZw3hpRoAU6cRKofHaXeqEfhzMLZtrl/eSTM9DWVD7G9w7p5GzriehKUWVj2
         cF+7TNs2XhwRC3MpYGrTIQMsteWcLLynFV7f6ix7Y2spbax2Lom0Fd2QaqR1qH2rGJal
         PBE8P4EMTtU4uLYqLKmB1f3YtQ9Cw6pQmRs0dT30iJHe8i5b5PlroGx6ezsK1/RMR7Ce
         FThifpg5cwguFP54vgWqQvf5C9j390jVsJC26sxBWZGBqyj+0L0WgZoE2GhKg8lh2MVq
         vsDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777995847; x=1778600647;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eP2CaYIiUzRkNVTCiezwUnhKqoleCnOWr9F8J8vHEFs=;
        b=BKOVvRBzVDZm7FV3gQS/wuLd0ojNTkXvr0v2GUozkBBHWZ3FnP2JsuGPugoCgKWW9Z
         3ItdLZFMh/bMuxXcK5ssgBTjYL1MGuBfgMeayZIUMc/SRFZzkIzBeI5cixWryn4mV+Rw
         oG9U7R/3r1UNDwGURwd1YzATM8WEe8sktzxJJORBJDBygLZSACVC18eOORbfjH80ET/k
         2Cxk5Vt6RRi/l3oAxfiWAEMCzQ2UtPkFnfyYwWGLItfSoOFmuNzv31yJyEqCs0Nrs2QF
         CfE0tZKBGnUDp2mtH+Tt4nzX0YJcMLZSzGLyHMWxExqRcD28Znzy6/yNn0SYFXFvVOkC
         lB8g==
X-Forwarded-Encrypted: i=1; AFNElJ/HIs1od4GPMj6IywL+OEY2oL1/ftklxttRQqUB7Jvt3/5qdiMbvq52qssuLUF9nnshB3zgUerUrw==@lists.linux.dev
X-Gm-Message-State: AOJu0YypYVI/IcPdCCinLwpA3b+dUdiHettXqnj5lmjubqkrkyCGmh9v
	1WMrfxuC9DCL/bQ7Eg+/W+43mxgEXszI6q6pSVMVwF/Zh+N0VLhgFXoEadXY+iJvR5w=
X-Gm-Gg: AeBDieuC3jo1hVGK2ElUCehqQtnFQBGI7HU2VT0H/TIIjzb/chxAKzsUEkKDFujP1s7
	rO48C2+JTzQAB3OcZh5+XE+8oqiJSs9pjTw6XjNNRHNsBMpKswtv/I9Skoiq5xN70SlrjZr82qu
	T5G/uOpO/BaErpBX1WMIrgTe0oN+pvoDFs5gcQ1Qe4Jqml7nLyy3A1otsUQiq3rAdVVW3+4BqK7
	DwNPUiF3L+dRcHHsSVUvtGQQ1rlR3rt3t8UtdiVs3fkg5SBCjeJE/zZPs1Vo4gPo8vyf7JpENWz
	ptZgh/HOIxaltMtOCHkcrc2nbRpZV4K57sT65YzCyTsVxdvcL4ERXbENXuAbFbYc+rKkbt2K4+O
	N1szDYs9bOpJzvtpvMyZ3dEJvG3V+OkJaYP9XagSK8Fx3caleQfiSkr3JZYV820bb/NHgBBozDd
	fPtv9cRQD9qBSQApzD27rS2K9NgwNl/TPDFKFQsNpCxlWl7+6JdG1ZkpDMekmKUFI4xBAl6vtr3
	GGoKTgtEHOu4g+IY1uJzK8N
X-Received: by 2002:a05:600c:a30a:b0:488:b187:3c with SMTP id 5b1f17b1804b1-48a9865d905mr179201595e9.14.1777995846965;
        Tue, 05 May 2026 08:44:06 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-48a822c3422sm381553625e9.8.2026.05.05.08.44.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2026 08:44:06 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Brian Bunker <brian@purestorage.com>,
	dm-devel@lists.linux.dev
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 17/18] libmultipath: checkers: rework mpcontext passing
Date: Tue,  5 May 2026 17:43:31 +0200
Message-ID: <20260505154332.448054-18-mwilck@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260505154332.448054-1-mwilck@suse.com>
References: <20260505154332.448054-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The emc_clariion path checker requires an "mpcontext" that is shared
between the checkers for all paths of a given multipath map. This context
is currently represented in struct multipath as a void *, the pointer to
which is passed to the checker. The checker allocates the actual memory in
the libcheck_mp_init() function, and changes the pointer in struct
multipath. This is a dangerous layering violation as the checker operates
on memory it doesn't own, and not type-safe at all.

This patch changes the mpcontext handling as follows: The void * pointer
is replaced by a dedicated union checker_mpcontext. It only contains
a long integer element, which is sufficient to store the information
needed by emc_clariion.

Instead of initializing this value in mp_init, the address of the union is
passed to libcheck_check() and libcheck_pending() if the path that is being
checked has an associated struct multipath. Passing a union pointer
improves compile-time type safety. In order to check whether the value is
initialized, instead of testing for a NULL pointer like before, the code
defines an INVALID_MPCONTEXT value. This value must obviously be chosen
such that it doesn't represent a valid context value, which is the case for
emc_clariion.

For a synchronous checker (like emc_clariion), libcheck_check() is allowed
to write to this memory, because at the time of the call we know that
pp->mpp is valid. The same holds for libcheck_pending().

This change requires checker_check() and checker_get_state() to be passed
a "struct path *" rather than a "struct checker *". The layer separation
happens in these functions now.

The async_checker code also gets an implementation of mpcontext handling,
in preparation of converting emc_clariion to an async checker.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/async_checker.c         | 32 +++++++++++-------
 libmultipath/async_checker.h         |  5 +--
 libmultipath/checkers.c              | 46 +++++++++++---------------
 libmultipath/checkers.h              | 44 ++++++++++++++++---------
 libmultipath/checkers/directio.c     |  6 ++--
 libmultipath/checkers/emc_clariion.c | 49 ++++++++++------------------
 libmultipath/discovery.c             |  8 ++---
 libmultipath/libmultipath.version    |  2 +-
 libmultipath/structs.c               |  3 +-
 libmultipath/structs.h               |  3 +-
 tests/directio.c                     |  2 +-
 11 files changed, 100 insertions(+), 100 deletions(-)

diff --git a/libmultipath/async_checker.c b/libmultipath/async_checker.c
index 52e24f2..63704aa 100644
--- a/libmultipath/async_checker.c
+++ b/libmultipath/async_checker.c
@@ -7,8 +7,8 @@
 #include <stdlib.h>
 #include <stdbool.h>
 #include <dlfcn.h>
-#include "async_checker.h"
 #include "checkers.h"
+#include "async_checker.h"
 #include "debug.h"
 #include "runner.h"
 
@@ -61,6 +61,7 @@ int async_check_init(struct checker *c)
 	if (fstat(c->fd, &sb) == 0)
 		acc->rdata.devt = sb.st_rdev;
 	acc->chkr.cls = c->cls;
+	SET_INVALID_MPCONTEXT(acc->rdata.mpc);
 	c->context = acc;
 	if (acc->async_init)
 		return acc->async_init(&acc->rdata);
@@ -149,35 +150,42 @@ bool async_check_need_wait(struct checker *c)
 	return acc && acc->rtx;
 }
 
-int async_check_pending(struct checker *c)
+int async_check_pending(struct checker *c, union checker_mpcontext *mpc)
 {
 	struct async_checker_context *acc = c->context;
+	int rc;
 	/* The if path checker isn't running, just return the exiting value. */
 	if (!acc || !acc->rtx)
 		return c->path_state;
 
-	/* This may nullify ct->rtx */
-	check_runner_state(acc);
+	/* This may nullify acc->rtx */
+	rc = check_runner_state(acc);
 	c->msgid = acc->rdata.msgid;
+	if (rc == RUNNER_DONE && mpc && !IS_INVALID_MPCONTEXT(acc->rdata.mpc))
+		*mpc = acc->rdata.mpc;
 	return acc->rdata.state;
 }
 
-int async_check_check(struct checker *c)
+int async_check_check(struct checker *c, union checker_mpcontext *mpc)
 {
 	struct async_checker_context *acc = c->context;
 
 	if (!acc)
 		return PATH_UNCHECKED;
 
-	if (checker_is_sync(c))
-		return acc->rdata.afunc(&acc->rdata);
+	if (mpc && !IS_INVALID_MPCONTEXT(*mpc))
+		acc->rdata.mpc = *mpc;
 
-	/* Handle the case that the checker just completed */
-	if (acc->rtx) {
-		check_runner_state(acc);
-		c->msgid = acc->rdata.msgid;
-		return acc->rdata.state;
+	if (checker_is_sync(c)) {
+		int rc = acc->rdata.afunc(&acc->rdata);
+
+		if (mpc && !IS_INVALID_MPCONTEXT(acc->rdata.mpc))
+			*mpc = acc->rdata.mpc;
+		return rc;
 	}
+	/* Handle the case that the checker just completed */
+	if (acc->rtx)
+		return async_check_pending(c, mpc);
 
 	/* create new checker thread */
 	acc->rdata.fd = c->fd;
diff --git a/libmultipath/async_checker.h b/libmultipath/async_checker.h
index 835de2a..10948d1 100644
--- a/libmultipath/async_checker.h
+++ b/libmultipath/async_checker.h
@@ -14,14 +14,15 @@ struct runner_data {
 	unsigned int timeout;
 	int state;
 	short msgid;
+	union checker_mpcontext mpc;
 	char checker_ctx[];
 };
 
 int async_check_init(struct checker *c);
 void async_check_free(struct checker *c);
 bool async_check_need_wait(struct checker *c);
-int async_check_pending(struct checker *c);
-int async_check_check(struct checker *c);
+int async_check_pending(struct checker *c, union checker_mpcontext *mpctx);
+int async_check_check(struct checker *c, union checker_mpcontext *mpctx);
 
 #define CHECKER_MAX_CONTEXT_SIZE 1024
 
diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
index 2f20b25..12d928a 100644
--- a/libmultipath/checkers.c
+++ b/libmultipath/checkers.c
@@ -12,6 +12,7 @@
 #include "async_checker.h"
 #include "vector.h"
 #include "util.h"
+#include "structs.h"
 
 static const char * const checker_dir = MULTIPATH_DIR;
 
@@ -164,7 +165,8 @@ static struct checker_class *add_checker_class(const char *name)
 	if (c->async_func)
 		return add_async_checker_class(c);
 
-	c->check = (int (*)(struct checker *)) dlsym(c->handle, "libcheck_check");
+	c->check = (int (*)(struct checker *, union checker_mpcontext *))
+		dlsym(c->handle, "libcheck_check");
 	errstr = dlerror();
 	if (errstr != NULL)
 		condlog(0, "A dynamic linking error occurred: (%s)", errstr);
@@ -178,9 +180,9 @@ static struct checker_class *add_checker_class(const char *name)
 	if (!c->init)
 		goto out;
 
-	c->mp_init = (int (*)(struct checker *)) dlsym(c->handle, "libcheck_mp_init");
 	c->reset = (void (*)(void))dlsym(c->handle, "libcheck_reset");
-	c->pending = (int (*)(struct checker *)) dlsym(c->handle, "libcheck_pending");
+	c->pending = (int (*)(struct checker *, union checker_mpcontext *))
+		dlsym(c->handle, "libcheck_pending");
 	c->need_wait = (bool (*)(struct checker *)) dlsym(c->handle, "libcheck_need_wait");
 	/* These 5 functions can be NULL. call dlerror() to clear out any
 	 * error string */
@@ -239,31 +241,12 @@ void checker_disable (struct checker * c)
 	c->path_state = PATH_UNCHECKED;
 }
 
-int checker_init (struct checker * c, void ** mpctxt_addr)
+int checker_init(struct checker *c)
 {
 	if (!c || !c->cls)
 		return 1;
-	c->mpcontext = mpctxt_addr;
 	if (c->cls->init && c->cls->init(c) != 0)
 		return 1;
-	if (mpctxt_addr && *mpctxt_addr == NULL && c->cls->mp_init &&
-	    c->cls->mp_init(c) != 0) /* continue even if mp_init fails */
-		c->mpcontext = NULL;
-	return 0;
-}
-
-int checker_mp_init(struct checker * c, void ** mpctxt_addr)
-{
-	if (!c || !c->cls)
-		return 1;
-	if (c->mpcontext || !mpctxt_addr)
-		return 0;
-	c->mpcontext = mpctxt_addr;
-	if (*mpctxt_addr == NULL && c->cls->mp_init &&
-	    c->cls->mp_init(c) != 0) {
-		c->mpcontext = NULL;
-		return 1;
-	}
 	return 0;
 }
 
@@ -287,13 +270,17 @@ void checker_put (struct checker * dst)
 	put_shared_ptr(src);
 }
 
-int checker_get_state(struct checker *c)
+int checker_get_state(struct path *pp)
 {
+	struct checker *c = &pp->checker;
+	union checker_mpcontext *mpc;
+
 	if (!c || !c->cls)
 		return PATH_UNCHECKED;
 	if (c->path_state != PATH_PENDING || !c->cls->pending)
 		return c->path_state;
-	c->path_state = c->cls->pending(c);
+	mpc = pp->mpp ? &pp->mpp->mpcontext : NULL;
+	c->path_state = c->cls->pending(c, mpc);
 	return c->path_state;
 }
 
@@ -305,8 +292,10 @@ bool checker_need_wait(struct checker *c)
 	return c->cls->need_wait(c);
 }
 
-void checker_check (struct checker * c, int path_state)
+void checker_check(struct path *pp, int path_state)
 {
+	struct checker *c = &pp->checker;
+
 	if (!c)
 		return;
 
@@ -320,7 +309,10 @@ void checker_check (struct checker * c, int path_state)
 		c->msgid = CHECKER_MSGID_NO_FD;
 		c->path_state = PATH_WILD;
 	} else {
-		c->path_state = c->cls->check(c);
+		union checker_mpcontext *mpc;
+
+		mpc = pp->mpp ? &pp->mpp->mpcontext : NULL;
+		c->path_state = c->cls->check(c, mpc);
 	}
 }
 
diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
index 744be54..eb3455f 100644
--- a/libmultipath/checkers.h
+++ b/libmultipath/checkers.h
@@ -131,6 +131,23 @@ enum {
 	CHECKER_MSGTABLE_SIZE = 100, /* max msg table size for checkers */
 };
 
+/*
+ * Data shared between checkers for a struct multipath.
+ * Should be large enough to hold the data for all checker types.
+ * Currently only used by emc_clariion.
+ */
+union checker_mpcontext {
+	long long_val;
+};
+
+#define INVALID_MPCONTEXT__ -1L
+#define IS_INVALID_MPCONTEXT(mpc) ((mpc).long_val == INVALID_MPCONTEXT__)
+#define SET_INVALID_MPCONTEXT(mpc)			\
+	do {						\
+		(mpc).long_val = INVALID_MPCONTEXT__;	\
+	} while (0)
+
+struct path;
 struct checker;
 struct runner_data;
 struct checker_class {
@@ -138,12 +155,12 @@ struct checker_class {
 	void *handle;
 	int sync;
 	char name[CHECKER_NAME_LEN];
-	int (*check)(struct checker *);
-	int (*init)(struct checker *);	  /* to allocate the context */
-	int (*mp_init)(struct checker *); /* to allocate the mpcontext */
-	void (*free)(struct checker *);	  /* to free the context */
-	void (*reset)(void);		  /* to reset the global variables */
-	int (*pending)(struct checker *); /* to recheck pending paths */
+	int (*check)(struct checker *, union checker_mpcontext *);
+	int (*init)(struct checker *);	/* to allocate the context */
+	void (*free)(struct checker *); /* to free the context */
+	void (*reset)(void);		/* to reset the global variables */
+	int (*pending)(struct checker *,
+		       union checker_mpcontext *); /* to recheck pending paths */
 	bool (*need_wait)(struct checker *); /* checker needs waiting for */
 	int (*async_func)(struct runner_data *); /* callback for async_checker */
 	const char **msgtable;
@@ -157,9 +174,7 @@ struct checker {
 	int disable;
 	int path_state;
 	short msgid;		             /* checker-internal extra status */
-	void * context;                      /* store for persistent data */
-	void ** mpcontext;                   /* store for persistent data shared
-						multipath-wide. */
+	void *context;			     /* store for persistent data */
 };
 
 static inline int checker_selected(const struct checker *c)
@@ -170,8 +185,7 @@ static inline int checker_selected(const struct checker *c)
 const char *checker_state_name(int);
 int init_checkers(void);
 void cleanup_checkers (void);
-int checker_init (struct checker *, void **);
-int checker_mp_init(struct checker *, void **);
+int checker_init(struct checker *);
 void checker_clear (struct checker *);
 void checker_put (struct checker *);
 void checker_reset (struct checker *);
@@ -202,9 +216,9 @@ struct checker_context {
 };
 int start_checker_thread (pthread_t *thread, const pthread_attr_t *attr,
 			  struct checker_context *ctx);
-int checker_get_state(struct checker *c);
+int checker_get_state(struct path *pp);
 bool checker_need_wait(struct checker *c);
-void checker_check (struct checker *, int);
+void checker_check(struct path *, int);
 int checker_is_sync(const struct checker *);
 const char *checker_name (const struct checker *);
 void reset_checker_classes(void);
@@ -217,13 +231,13 @@ void checker_clear_message (struct checker *c);
 void checker_get(struct checker *, const char *);
 
 /* Prototypes for symbols exported by path checker dynamic libraries (.so) */
-int libcheck_check(struct checker *);
+int libcheck_check(struct checker *, union checker_mpcontext *);
 int libcheck_init(struct checker *);
 void libcheck_free(struct checker *);
 void *libcheck_thread(struct checker_context *ctx);
 void libcheck_reset(void);
 int libcheck_mp_init(struct checker *);
-int libcheck_pending(struct checker *c);
+int libcheck_pending(struct checker *c, union checker_mpcontext *);
 bool libcheck_need_wait(struct checker *c);
 
 /*
diff --git a/libmultipath/checkers/directio.c b/libmultipath/checkers/directio.c
index a7422a8..82b2041 100644
--- a/libmultipath/checkers/directio.c
+++ b/libmultipath/checkers/directio.c
@@ -405,7 +405,8 @@ bool libcheck_need_wait(struct checker *c)
 		!ct->checked_state);
 }
 
-int libcheck_pending(struct checker *c)
+int libcheck_pending(struct checker *c,
+		     union checker_mpcontext *mpc __attribute__((unused)))
 {
 	int rc;
 	struct io_event event;
@@ -441,7 +442,8 @@ out:
 	return rc;
 }
 
-int libcheck_check (struct checker * c)
+int libcheck_check(struct checker *c,
+		   union checker_mpcontext *mpctx __attribute__((unused)))
 {
 	int ret;
 	struct directio_context * ct = (struct directio_context *)c->context;
diff --git a/libmultipath/checkers/emc_clariion.c b/libmultipath/checkers/emc_clariion.c
index bf0baab..24a386c 100644
--- a/libmultipath/checkers/emc_clariion.c
+++ b/libmultipath/checkers/emc_clariion.c
@@ -15,6 +15,7 @@
 #include "libsg.h"
 #include "checkers.h"
 #include "debug.h"
+#include "util.h"
 
 #define INQUIRY_CMD     0x12
 #define INQUIRY_CMDLEN  6
@@ -32,18 +33,20 @@
  * simple read test would return 02/04/03 instead
  * of 05/25/01 sensekey/ASC/ASCQ data.
  */
-#define	IS_INACTIVE_SNAP(c)   (c->mpcontext ?				   \
-			       ((struct emc_clariion_checker_LU_context *) \
-					(*c->mpcontext))->inactive_snap	   \
-					    : 0)
+#define IS_INACTIVE_SNAP(mpctx)				\
+	(!mpctx || IS_INVALID_MPCONTEXT(*mpctx) ? 0 : mpctx->long_val)
 
-#define	SET_INACTIVE_SNAP(c)  if (c->mpcontext)				   \
-				((struct emc_clariion_checker_LU_context *)\
-					(*c->mpcontext))->inactive_snap = 1
+#define SET_INACTIVE_SNAP(mpctx)		\
+	do {					\
+		if (mpctx)			\
+			mpctx->long_val = 1;	\
+	} while (0);
 
-#define	CLR_INACTIVE_SNAP(c)  if (c->mpcontext)				   \
-				((struct emc_clariion_checker_LU_context *)\
-					(*c->mpcontext))->inactive_snap = 0
+#define CLR_INACTIVE_SNAP(mpctx)		\
+	do {					\
+		if (mpctx)			\
+			mpctx->long_val = 0;	\
+	} while (0);
 
 enum {
 	MSG_CLARIION_QUERY_FAILED = CHECKER_FIRST_MSGID,
@@ -109,28 +112,12 @@ int libcheck_init (struct checker * c)
 	return 0;
 }
 
-int libcheck_mp_init (struct checker * c)
-{
-	/*
-	 * Allocate and initialize the multi-path global context.
-	 */
-	if (c->mpcontext && *c->mpcontext == NULL) {
-		void * mpctxt = malloc(sizeof(int));
-		if (!mpctxt)
-			return 1;
-		*c->mpcontext = mpctxt;
-		CLR_INACTIVE_SNAP(c);
-	}
-
-	return 0;
-}
-
-void libcheck_free (struct checker * c)
+void libcheck_free(struct checker *c)
 {
 	free(c->context);
 }
 
-int libcheck_check (struct checker * c)
+int libcheck_check(struct checker *c, union checker_mpcontext *mpctx)
 {
 	unsigned char sense_buffer[128] = { 0, };
 	unsigned char sb[SENSE_BUFF_LEN] = { 0, }, *sbb;
@@ -282,7 +269,7 @@ retry:
 				 * passive paths which will return
 				 * 02/04/03 not 05/25/01 on read.
 				 */
-				SET_INACTIVE_SNAP(c);
+				SET_INACTIVE_SNAP(mpctx);
 				condlog(3, "emc_clariion_checker: Active "
 					"path to inactive snapshot WWN %s.",
 					wwnstr);
@@ -300,10 +287,10 @@ retry:
 			 * snapshot LUs if it was in this list since the
 			 * snapshot is no longer inactive.
 			 */
-			CLR_INACTIVE_SNAP(c);
+			CLR_INACTIVE_SNAP(mpctx);
 		}
 	} else {
-		if (IS_INACTIVE_SNAP(c)) {
+		if (IS_INACTIVE_SNAP(mpctx)) {
 			hexadecimal_to_ascii(ct->wwn, wwnstr);
 			condlog(3, "emc_clariion_checker: Passive "
 				"path to inactive snapshot WWN %s.",
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index f59fa6d..ceca9fd 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1998,20 +1998,18 @@ start_checker (struct path * pp, struct config *conf, int daemon, int oldstate)
 			return -1;
 		}
 		checker_set_fd(c, pp->fd);
-		if (checker_init(c, pp->mpp?&pp->mpp->mpcontext:NULL)) {
+		if (checker_init(c)) {
 			checker_clear(c);
 			condlog(3, "%s: checker init failed", pp->dev);
 			return -1;
 		}
 	}
-	if (pp->mpp && !c->mpcontext)
-		checker_mp_init(c, &pp->mpp->mpcontext);
 	checker_clear_message(c);
 	if (conf->force_sync == 0)
 		checker_set_async(c);
 	else
 		checker_set_sync(c);
-	checker_check(c, oldstate);
+	checker_check(pp, oldstate);
 	return 0;
 }
 
@@ -2021,7 +2019,7 @@ get_state (struct path * pp)
 	struct checker * c = &pp->checker;
 	int state, lvl;
 
-	state = checker_get_state(c);
+	state = checker_get_state(pp);
 
 	lvl = state == pp->oldstate || state == PATH_PENDING ? 4 : 3;
 	condlog(lvl, "%s: %s state = %s", pp->dev,
diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index 5e8dbda..d2876c7 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -43,7 +43,7 @@ LIBMPATHCOMMON_1.0.0 {
 	put_multipath_config;
 };
 
-LIBMULTIPATH_33.0.0 {
+LIBMULTIPATH_34.0.0 {
 global:
 	/* symbols referenced by multipath and multipathd */
 	add_foreign;
diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index f441312..c627b2c 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -261,7 +261,7 @@ alloc_multipath (void)
 
 	if (mpp) {
 		mpp->bestpg = 1;
-		mpp->mpcontext = NULL;
+		SET_INVALID_MPCONTEXT(mpp->mpcontext);
 		mpp->no_path_retry = NO_PATH_RETRY_UNDEF;
 		dm_multipath_to_gen(mpp)->ops = &dm_gen_multipath_ops;
 	}
@@ -330,7 +330,6 @@ void free_multipath(struct multipath *mpp)
 		vector_free(mpp->hwe);
 		mpp->hwe = NULL;
 	}
-	free(mpp->mpcontext);
 	free(mpp);
 }
 
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 9adedde..8b71aa2 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -540,8 +540,7 @@ struct multipath {
 	unsigned int stat_queueing_timeouts;
 	unsigned int stat_map_failures;
 
-	/* checkers shared data */
-	void * mpcontext;
+	union checker_mpcontext mpcontext;
 
 	/* persistent management data*/
 	int prkey_source;
diff --git a/tests/directio.c b/tests/directio.c
index fa1e553..addb7cf 100644
--- a/tests/directio.c
+++ b/tests/directio.c
@@ -227,7 +227,7 @@ void do_check_state(struct checker *c, int sync, int chk_state)
 
 void do_libcheck_pending(struct checker *c, int chk_state)
 {
-	assert_int_equal(libcheck_pending(c), chk_state);
+	assert_int_equal(libcheck_pending(c, NULL), chk_state);
 	assert_int_equal(ev_off, 0);
 	memset(mock_events, 0, sizeof(mock_events));
 }
-- 
2.54.0

