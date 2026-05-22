Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93117477E42
	for <dm-devel@lists.linux.dev>; Fri, 22 May 2026 16:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779468291; cv=none; b=q7WTWPoE3LFZ0U6CYJ8y3VLmwrscEy3Z/UFlNtvPTzB4eCipmnx1V/LvrVNl0Nh14md+GX3+N0V4YYpsnnAsbas1m7OJv7A2cp1oF+lcLlfyrbSuHyCPiE4aygg6oWljw+RXpNG6XCKCbZHdwVCP9/UMYVfzGaX97iqIrvKCb4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779468291; c=relaxed/simple;
	bh=uoFcHGXG09AF+TnGwFZwUW6Wn70grVvo5AN/hcTDhZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eiv/53mV6PYLXOV0gaJ5P9leM0nw8lDIh1274LhCNiCRc8gmfMOrqxERUa+P1xuKeBG7B04EHS+Z5hONVfI8+0+SkmF3+f/UcKqjrYOcmofxWj1ujU2UAopbsqJ8dIpglcp8D+69ROpEhPhD+pMFWhykvdGYPpYtYA2+iOfax14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=FyjlI/PF; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="FyjlI/PF"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-48d146705b4so80872055e9.3
        for <dm-devel@lists.linux.dev>; Fri, 22 May 2026 09:44:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779468285; x=1780073085; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2w5ZsBtzFpczptMobR5poWRPL40S+ojT87bfOGknq4c=;
        b=FyjlI/PF8evfh1rHATBlWL9ptdY/CvpxS9ielbx1+GndZ1ktge8cO6lPY/C1uNBr2r
         BbL884IWBeBO2E3QsTR1RUMEo48oR2Wc58xYyxoCMQ0lfGd1nX9b2a3oi/WEbpXTLHec
         uUf6bfjerNLPE4TwqTx3nRFxQ9axMh+/0MrG79qZfLC6cLszJuFrKvNKqA2GpKPpBzi/
         em5UMrFDC+ad17BvHq53Jn77Wv4LvRIGsL96shoNk65p6GM2fpa2zkLMJif9RES8dMCz
         Nv4eKXt3BKpMzp5mHU3chdUBCnRUzxehYMJf8MQNX3mBlcmtRY0/mqB/hIWRZJgS681r
         7MlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779468285; x=1780073085;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2w5ZsBtzFpczptMobR5poWRPL40S+ojT87bfOGknq4c=;
        b=juf2Bpmk4wbC+zi50bwbiQtnbeKIpIaLjao2Dv6LMpdS8jdD/vEr3Bl+Bv7cByM12q
         jxDsDSBwxVWQOC3gU/xLtz01HtZFzOkW8fHiq2tYRlAce6cr/nGwihrfuC4gIdFRquoL
         iuyG+CKBy8LThi78ri8gS/CoLoBAjUj3lq2v1RBYDau9Pwi1LdIiyo2Oscij8kgufyD8
         fH02N8nXEBGkTJ2Rw6PoPuN/2tA5541EaBPme3qLkVNfniZPmAYAtKk4MnA/3sct7NSU
         C+KLfFb82PFOuazyynI4/nWO2JTZF11+8E5660X/uOtj2rW5Pz4JxAgLtAuSFW7c1q62
         27Ug==
X-Forwarded-Encrypted: i=1; AFNElJ8mBM/FJi+H43v4kmp0y127r2Qh5yCQFcypVUJtcbx15vDz9jnLJ0j3vti4KcVs3ZHDVZYEbwFLVQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YyP7PjZi+naKaNpO9IVxSaxGpIas1n4Nbcwd3fVmn7poGhTfp9Q
	6v7hjhz8DT1M1sbiorGmx0GnOFDTAp0ZIX+O3OlFkVXWpdCQcUZ/vm53eeXncxfs0ZA=
X-Gm-Gg: Acq92OGTzCbYJ3Hn8ej6xeJgU+abIw83LDnFQyV3RBJInYcjegecRDxOnInYY1SG+rc
	7c5cFyVIUz5B9p/c6xjSM7EJIfHQsSI+DNMUzlrBD4DA9pow74bStC3X7cdYSZ6yszgM44Cq6eQ
	034zNe34swRSqbnzE8nTHE1eE+9v9hhRGQ6Du7+SE/v/toGO+JAtk0rGx7YrCjOJjULPSDjL54H
	6UNat+8dz25SyVG2EOv0cf+wUO7na17MyJiOLihw/YGUFfW/sLBWBmm2nqt+scYDfKLGEgkk6p2
	Z/ndwXWGmAULM68kucuNHlFcQ+Ku3Y3NovvZPYMU2CyG5L7ZJ0XF9xLobVAw5FzAteDH2gGDTH0
	6n5sAtqceRh8cBOJ1ThC9lNWwqWMzWWYcH0FRJ+peCUI87H2L8jzVFKe+GnwI8jq/X63YsPK9O+
	hJ9Sat+0hsBzUJEGPBuUV8qxrKOAoyti3NWicrYa0MzB8QpK2XHs1pFlTYG5TAlamK3wntTQlcI
	Hn1w2di/hJVQA==
X-Received: by 2002:a05:600d:6450:10b0:48a:7a10:4f17 with SMTP id 5b1f17b1804b1-4904249d125mr48635575e9.6.1779468284561;
        Fri, 22 May 2026 09:44:44 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4904561f682sm54599295e9.13.2026.05.22.09.44.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2026 09:44:44 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Brian Bunker <brian@purestorage.com>,
	dm-devel@lists.linux.dev
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 04/19] libmpathutil: add implementation of generic shared pointer
Date: Fri, 22 May 2026 18:44:00 +0200
Message-ID: <20260522164415.846589-5-mwilck@suse.com>
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

Add a set of simple functions to handle refcounted pointers.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathutil/libmpathutil.version |  7 +++++
 libmpathutil/util.c               | 45 ++++++++++++++++++++++++++++---
 libmpathutil/util.h               |  5 ++++
 3 files changed, 53 insertions(+), 4 deletions(-)

diff --git a/libmpathutil/libmpathutil.version b/libmpathutil/libmpathutil.version
index c69120d..51594ad 100644
--- a/libmpathutil/libmpathutil.version
+++ b/libmpathutil/libmpathutil.version
@@ -194,3 +194,10 @@ global:
 local:
 	*;
 };
+
+LIBMPATHUTIL_6.1 {
+global:
+	alloc_shared_ptr;
+	get_shared_ptr;
+	put_shared_ptr;
+} LIBMPATHUTIL_6.0;
diff --git a/libmpathutil/util.c b/libmpathutil/util.c
index 23a9797..3c623ec 100644
--- a/libmpathutil/util.c
+++ b/libmpathutil/util.c
@@ -12,15 +12,13 @@
 #include <dirent.h>
 #include <unistd.h>
 #include <errno.h>
+#include <urcu/uatomic.h>
 #include "mt-udev-wrap.h"
 
 #include "util.h"
 #include "debug.h"
-#include "checkers.h"
 #include "vector.h"
-#include "structs.h"
-#include "config.h"
-#include "log.h"
+#include "list.h"
 
 size_t
 strchop(char *str)
@@ -384,3 +382,42 @@ void cleanup_udev_device(struct udev_device **udd)
 	if (*udd)
 		udev_device_unref(*udd);
 }
+
+struct shared_ptr {
+	long refcnt;
+	void (*destructor)(void *);
+	char __attribute__((aligned(sizeof(void *)))) ptr[];
+};
+
+void *alloc_shared_ptr(size_t size, void (*destructor)(void *))
+{
+	struct shared_ptr *sp = malloc(sizeof(*sp) + size);
+
+	if (!sp)
+		return NULL;
+	uatomic_set(&sp->refcnt, 1);
+	sp->destructor = destructor;
+	return sp->ptr;
+}
+
+void get_shared_ptr(void *ptr)
+{
+	struct shared_ptr *sp = container_of(ptr, struct shared_ptr, ptr);
+
+	if (uatomic_add_return(&sp->refcnt, 1) < 0)
+		condlog(0, "%s: refcount overflow", __func__);
+}
+
+void put_shared_ptr(void *ptr)
+{
+	struct shared_ptr *sp;
+
+	if (!ptr)
+		return;
+	sp = container_of(ptr, struct shared_ptr, ptr);
+	if (uatomic_sub_return(&sp->refcnt, 1) == 0) {
+		if (sp->destructor)
+			sp->destructor(ptr);
+		free(sp);
+	}
+}
diff --git a/libmpathutil/util.h b/libmpathutil/util.h
index aed1bc1..ffbb182 100644
--- a/libmpathutil/util.h
+++ b/libmpathutil/util.h
@@ -160,4 +160,9 @@ void cleanup_charp(char **p);
 void cleanup_ucharp(unsigned char **p);
 void cleanup_udev_device(struct udev_device **udd);
 void cleanup_bitfield(union bitfield **p);
+
+void *alloc_shared_ptr(size_t size, void (*destructor)(void *));
+void get_shared_ptr(void *ptr);
+void put_shared_ptr(void *ptr);
+
 #endif /* UTIL_H_INCLUDED */
-- 
2.54.0

