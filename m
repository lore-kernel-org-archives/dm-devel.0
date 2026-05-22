Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611473B9927
	for <dm-devel@lists.linux.dev>; Fri, 22 May 2026 16:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779468293; cv=none; b=Ij98RU82ltyCoEWbvDYRgnB3X4nhkHSYMdwTWWA15xu25D44OEwl1WT9s7R09ZFgC6uONA8RNeJHq2dlgb4wqYD5ZuCaebRzCTkh0pvjm6CYFeTOH5AX8B1ngJPfqphOmAloYZ6jQfG8w4DXdTIf0Rix1cstvcOyjWbwwEa/0n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779468293; c=relaxed/simple;
	bh=cH23sU+zftvu1jsbJSdGD1TjXDeuj4BhVqOxAb3wcs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XPytFnCEP7C+4r4nk9+SNWZtIYM/qBwjsy/6EDPXGXaqsT734uIO3Bj+05KNVh6MXtcFczG/HUAY+9M9/srtdVQ+HXwFipmy2TzZwkHdcYD/r1JP+CQ4teXAP7CbZajjf1iX+mi/uxhKK2K2JCuNZqQfrBon4B0drO96Q0kIfic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=B0tncBd2; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="B0tncBd2"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4903974854dso18956215e9.3
        for <dm-devel@lists.linux.dev>; Fri, 22 May 2026 09:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779468291; x=1780073091; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3TouJLChTgRmN54e2DEM7izKB9gTvmWH4nMbHnxWSNA=;
        b=B0tncBd2sDsSMRkg2cuv57MyOVX/LP+DqyCdn7+tvPZ+yF0C9kZGcnYZVhECnBaXKo
         F+Bj8PhK/0JqaTFY8Wlbriln+QmyePT8JmHQGIMY+2Pu0sDWZ8mrFxZ4aLQLQfPIPK0v
         UtMtFlatxZ538qo3czY/v4sI1p/XtId0m+r06UiXa2vCZGXzBXrxXk/mhWHTClfvef9S
         pe+sy5LfXdfgJ46I0KiiGIsre/rW/sYBCewahK67FaSbYJrJPLhc5bY3TU+1AJuXRlOP
         0+bSFkHLMUsvpnYo2tiznWs37NxjHv0SgUN0GS+pzAmEm0si98nifp/sIKnI2N629O7E
         NJPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779468291; x=1780073091;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3TouJLChTgRmN54e2DEM7izKB9gTvmWH4nMbHnxWSNA=;
        b=OW3plrkkvQIRalsC3oggGM752CFY/Yrypsq7frt+sK6GtBIxtMiuiGZRZ5B5FXQxHU
         +CjsAN17Wu/DVata1BVdoQWZoJjev3nnx6AzOFEVWt+6kWmul0uV+jbCCddbJdRk/lMn
         iZpI7Yz08/YnD4IAMSAVJSApwduLz1LlelM1FF0wbL/ZuuEKJ6QH7FrAldi3J4zMeZ9U
         Zfd4DEQ7znQ9OFCJpvq9ziVoLlBzag7RpfA7Smwf1wklj5HuyEFIyNnLwk5bp2uP2KkH
         Nj6Nx+6Qd9uBkQHglv52xKchQ3uJ0eZEyd6DO0vzvKdlAn7Kwh6qdwCQIkYdpLvGR7dn
         StQw==
X-Forwarded-Encrypted: i=1; AFNElJ+ZuFhl8lbbXpb15TrCMJ5zVJW2sIp3AmHgYthXeOEI/Q4dPoenJu7YX5BC4yMHgRmQKKMJ2gDaSQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YyNADXr4tOoVg9XJPd66PRjgiYZa4wh1BkLQMLEfrN6x8RJ1YXv
	helYekhIUFLVibWka7PjWSRG1hubVp1zHKKixf6LvkoOT6zQTOYy2ewGw2QyS1xiJq2HcQfr48Y
	7qLmGjLY=
X-Gm-Gg: Acq92OGGYMDN0cp3+EVu9N/+l2aZO8AYKFiE4ncGxNiGe7ICE03IjG8eX+Qjx+vJEub
	KT6GXcD690V542x1Honx8iEKxIWnxaJ3CPbRr2c+m0RZOUrYorjMW0c0KwQoCdzJJwb+mDQzSXp
	9coNxzVTA0Z5qAFHLjlTSQl+a+kyzQZ8CKOyMK3YjRJlnUYG3GnWvGf8wohZdfUvxYen4hgncpA
	p6xbl7X2LPP+nlAXkENhaNUbzL4fVJYcvPTc+m2VZf5QrcNeRmgyGZhePBmWznjxsb1fm1XiDE7
	Mbvj4MBM4Qb8L7S7eUZE/vUQJwbEBvg9WCNBrsaeaew+xWwifEx4SpnBUFnRCIxWYWYJOa8et91
	BGB8QcQrY3p3YghgeamX2coHZCcrFi68wtpVyyYzV38xcy6E8Xebn5nLCTPFYAD+I4dv8zOfejF
	jkFHHtm4S9yaJr5Xb7KLAy1eImKDAMoDe07CkuFptGEYgfNZqpK2iFbccP6CMw4r/kx29d99aWs
	eiqU5u2223unnWosQXIu970
X-Received: by 2002:a05:600d:8494:20b0:48f:d1b8:9aaa with SMTP id 5b1f17b1804b1-490424a1628mr49077755e9.6.1779468290713;
        Fri, 22 May 2026 09:44:50 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4904561f682sm54604125e9.13.2026.05.22.09.44.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2026 09:44:50 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Brian Bunker <brian@purestorage.com>,
	dm-devel@lists.linux.dev
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 08/19] libmultipath: use shared_ptr for prioritizers
Date: Fri, 22 May 2026 18:44:04 +0200
Message-ID: <20260522164415.846589-9-mwilck@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260522164415.846589-1-mwilck@suse.com>
References: <20260522164415.846589-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace the hardcoded refcount handling in prio.c with shared_ptr.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/prio.c | 47 +++++++++++++++++++--------------------------
 libmultipath/prio.h |  1 -
 2 files changed, 20 insertions(+), 28 deletions(-)

diff --git a/libmultipath/prio.c b/libmultipath/prio.c
index 24f825b..bf388e9 100644
--- a/libmultipath/prio.c
+++ b/libmultipath/prio.c
@@ -53,28 +53,11 @@ int init_prio(void)
 	return 0;
 }
 
-static struct prio * alloc_prio (void)
-{
-	struct prio *p;
-
-	p = calloc(1, sizeof(struct prio));
-	if (p) {
-		INIT_LIST_HEAD(&p->node);
-		p->refcount = 1;
-	}
-	return p;
-}
-
-void free_prio (struct prio * p)
+void free_prio(void *ptr)
 {
+	struct prio *p = ptr;
 	if (!p)
 		return;
-	p->refcount--;
-	if (p->refcount) {
-		condlog(4, "%s prioritizer refcount %d",
-			p->name, p->refcount);
-		return;
-	}
 	condlog(3, "unloading %s prioritizer", p->name);
 	list_del(&p->node);
 	if (p->handle) {
@@ -83,7 +66,18 @@ void free_prio (struct prio * p)
 				p->name, dlerror());
 		}
 	}
-	free(p);
+}
+
+static struct prio *alloc_prio(void)
+{
+	struct prio *p;
+
+	p = alloc_shared_ptr(sizeof(*p), free_prio);
+	if (p) {
+		memset(p, 0, sizeof(*p));
+		INIT_LIST_HEAD(&p->node);
+	}
+	return p;
 }
 
 void cleanup_prio(void)
@@ -91,9 +85,8 @@ void cleanup_prio(void)
 	struct prio * prio_loop;
 	struct prio * prio_temp;
 
-	list_for_each_entry_safe(prio_loop, prio_temp, &prioritizers, node) {
-		free_prio(prio_loop);
-	}
+	list_for_each_entry_safe(prio_loop, prio_temp, &prioritizers, node)
+		put_shared_ptr(prio_loop);
 }
 
 static struct prio *prio_lookup(const char *name)
@@ -150,7 +143,7 @@ struct prio *add_prio (const char *name)
 	list_add(&p->node, &prioritizers);
 	return p;
 out:
-	free_prio(p);
+	put_shared_ptr(p);
 	return NULL;
 }
 
@@ -199,17 +192,17 @@ void prio_get(struct prio *dst, const char *name, const char *args)
 	dst->getprio = src->getprio;
 	dst->handle = NULL;
 
-	src->refcount++;
+	get_shared_ptr(src);
 }
 
 void prio_put (struct prio * dst)
 {
-	struct prio * src;
+	struct prio *src;
 
 	if (!dst || !dst->getprio)
 		return;
 
 	src = prio_lookup(dst->name);
 	memset(dst, 0x0, sizeof(struct prio));
-	free_prio(src);
+	put_shared_ptr(src);
 }
diff --git a/libmultipath/prio.h b/libmultipath/prio.h
index 119b75f..7ff1a24 100644
--- a/libmultipath/prio.h
+++ b/libmultipath/prio.h
@@ -45,7 +45,6 @@ struct path;
 
 struct prio {
 	void *handle;
-	int refcount;
 	struct list_head node;
 	char name[PRIO_NAME_LEN];
 	char args[PRIO_ARGS_LEN];
-- 
2.54.0

