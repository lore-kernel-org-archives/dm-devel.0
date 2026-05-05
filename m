Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB353313550
	for <dm-devel@lists.linux.dev>; Tue,  5 May 2026 15:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777995832; cv=none; b=XR1BNvwHqSySNaR5xtR7NYVGfpht7FTrkfza+WBi4qDmvRhbRzGUilxAHGBedEC+gYJzb4GgGGUDs7Jf9CYqX/vMSMRgz46QJ/b9V2qojbavIhrRl5MBc5KxJbO22rCnkfJm32yhFxSeF2acH95uLnAhggeMihG9qwe/JTDXbQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777995832; c=relaxed/simple;
	bh=+SV1aCKHCEh9yLLdZMcjVw/dn6z9S++Hfly2E/FEefY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hiiWPvzzcxG9c8qsYG1cFBs9XI41nnlkk3vfGwEJFlbxD2A+c3MZA2xak3eXJwqZZrvH0EYKFSOkkpguupbLYm1qwE3VyL4YoyCcX9ThrnNZrb728EbFMRyDvQ54kU+NWSHdwyQvz9v74a7TdK/PbziARiecyQlIY/l9Bf2m5Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=J+EpCJ+u; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="J+EpCJ+u"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4852b81c73aso41793395e9.3
        for <dm-devel@lists.linux.dev>; Tue, 05 May 2026 08:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777995829; x=1778600629; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V8s8VBAs2l69nhhSL5YVwwv2mdkZA9gOsHYKi1K03Y0=;
        b=J+EpCJ+uSA0ZOQXApC9j4TyI+jVjZHIH+E7sKZYG9MjmQojEK98EVNXdfV/mgsoOvN
         zTDol/7s4G19FEW0aO6fkQaCirf2S8g5CvexvyfiXtJpUrMa6C/RKhqPpZC6Tc/19WLF
         tC0fxuS9fXWz5JWu5J81x6y+ovezYIPZ7HHAYdhTEyJsLwdRUhhQlmnWdW0vfXlPt5Gw
         6JrBdPtWQTBrdNXwWny6yDadBq0PnPAIqtb6LJHQssUfs5vsvGU4tlOvvlaloo2oysPQ
         pZ7Z3sNJen694FbofybS6OoVUKXajOtYVwtvf2/SU0wZ1gnr6B8x/l4NrqVszYH1FGLq
         GwMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777995829; x=1778600629;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=V8s8VBAs2l69nhhSL5YVwwv2mdkZA9gOsHYKi1K03Y0=;
        b=FEw02LEEbtlkfqeBnpQNsgx40BYg1Ea8Td/AYuprRPaaYWQ2aA0aBV9I0IRsE+7fhh
         ZSj0yf2v3zwrlzEiYG3dtuHLAZVWMjTSXoUwf0MUA4hj6t3ItOLuEC2CKIVrt0DV8hrj
         l3Bs6Q/mCGzCDByCFMryP4BTnieIotSA/2kPue2yo8MoMmCBu3d8V5JNa92lPKhI5I73
         rqnI5Ek4j6dYRhq01Pcbdqe9rwmZtQeN5RGutmH++LZ041OHCe0yfQSKTB4aaeL91Pe9
         5iQLkBKCmHPCbV+6QNGJ7/z/al4oD6101CzRvV8PXucI6w1uTh9YEthpUk4RwHN6PCWB
         LcjQ==
X-Forwarded-Encrypted: i=1; AFNElJ/IGKBYvgRtuGrpgnsUDduOWHeTfe+halewjfLWSXnnvrywdfcwk9jXu3zMtQRcIwLGWRYL1kiksQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YwsR4dKv2/K/3PBUjCO0kkYr83MEZUtyjIiMrGh5PfnqmfJbG7+
	7LzoeqTtCvFNtEJSi4IXEDVTc71jkZuZhckcm/+4/A+8QkUOw9UbRjePpxajYQ56TDQ=
X-Gm-Gg: AeBDievd+80ND2oxC4bg7iDEKGoaYk3oRk8M2NP2huvpvHHTgZL7+WMAcymkeo9UimG
	Vm3CeNPb1Q058aXR/eRZ6ySEpySpIX6nwoITXT6eI5EWeelXmW4/LJuhCIxuVW7tzrhxMSGdGKK
	+sgCvuDlfoJgs9Chk/toHTAc7dg1+/qzJiwg0EIQW1/x9XoBDvlYXxyEnsRMzInf6dy/SPPlgXI
	be03dYYjM3gwi8IdCKADFmn1gJs/If2a9WiWVAxQ8pL8hVxI75oFOD+ATpk2YojR7LFWGj1mowa
	4T0WfOxNvhvnC7+6wAShQ0ojgCS9+ETmGqljDxyxjsDJrpaXi1oCWBzgS5jy7ziB2QPaTADAMhA
	B57dg4nAgFzKqAGDBNFa+OmGC7dlBJ8opca2GKWhyS2slv41iqChvVrtIzXHSuqNW/3/7WJwfRk
	whSnARiAe0tVKUBmDiQdW1x4L5FCaz0EvvHZvMzuhomB6EwVgX2Xv15fiDYqO7R50BKJJRmeO6g
	KHG2sJ0HheE5f9dlzVPuTe2
X-Received: by 2002:a05:600c:a46:b0:485:3ff1:d5ed with SMTP id 5b1f17b1804b1-48d186dc7c6mr58749355e9.1.1777995829027;
        Tue, 05 May 2026 08:43:49 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-45055960811sm5613918f8f.27.2026.05.05.08.43.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2026 08:43:48 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Brian Bunker <brian@purestorage.com>,
	dm-devel@lists.linux.dev
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 04/18] libmpathutil: add implementation of generic shared pointer
Date: Tue,  5 May 2026 17:43:18 +0200
Message-ID: <20260505154332.448054-5-mwilck@suse.com>
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

Add a set of simple functions to handle refcounted pointers.

Signed-off-by: Martin Wilck <mwilck@suse.com>
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

