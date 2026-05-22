Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B883AF643
	for <dm-devel@lists.linux.dev>; Fri, 22 May 2026 16:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779468294; cv=none; b=OPa2qgYj98iP0DDzWUnZQdKUfmmX49r6t89f6F7F9sX8zZ3srzx626BV/VgrICvfospAiZRYb5n4sjpI8JB6BOf3DF8Ko196/v6SnHRk24Hh0uLjLpcGe+yGY0mtsVNjUQHPEj719a06Jvh/FVODYU4MYQaQXW6beys5r4JD8u4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779468294; c=relaxed/simple;
	bh=ehRpsGZ43GgymLwm0mBAdCNWD3aLcNZmZBRYfebqKNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iMGPmWsAw7t3Xxbc3oEssUohlMtFUlvhQM7+1365p/wM7IXVlYAo2KWyzcI/iEXQadoApUl2bdPxxOe0E8LoFkJZ8b0NtY/PddJkSmwlUgN2EdxNjfSwE9Axr+fwK8h3QW/10gQy8EbcN47HCsTT9tmsunscncWE8K3fi9nHYec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=V8Pjlanc; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="V8Pjlanc"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-45e8a834cc2so3700541f8f.1
        for <dm-devel@lists.linux.dev>; Fri, 22 May 2026 09:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779468289; x=1780073089; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YGALIbFvlL4M5hXrCj+JWdejRmSOAEb4H+KRXPTBNoA=;
        b=V8PjlancPAYtGWWM+G496CfJMT1XkBgqcIgxOFXj40vPTwm/2cYK+FJe2KHftKWdRm
         AIr86t39O20tCLgZP81qQdIQ83IqmQnuoD6pmfHr6jMzSXnUcLDU5qj0P7G1SUgvqaE2
         WRJYMwb3ovN8Ek7cWp5LgULQACkyuREnK/ZxdGQHs0O+4ohnxI0Vemj8tCxqs6gC72uq
         8QFP7UVEARMpSGdOT249lBpXnhG2ccrlMwJ7DZF0Y3X91of8QQXtyLSSABUSAWPjrFZh
         FModNxu6RNS73RoBMINQIMyi8XOb4+Yt9I7/VUjiF2kkYfXWSUQpAfYL74leGUANtu68
         cKFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779468289; x=1780073089;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YGALIbFvlL4M5hXrCj+JWdejRmSOAEb4H+KRXPTBNoA=;
        b=EBq+n4zbH0Ho0412B9qwCJBMgajmvsjcnksn6s2fbVBFbl24wArFKdzBStWGn1su0T
         jz5+ALUcYih1oqFUuWuxPz70cvzGhyoMDPDerdBIJdUt8dGV/5fYQpyAGF9sM9leRcZ8
         NgVT4gvu0jjfMK5DN2V6R1LtFXEY77Eyzk69FZUPCbZeR7uBUw11FBp3DgnIDMFyuHP4
         JeJXFUMoPabswfWrlt/jExvJivBPJ7wjFpLJpfDymGuGV6VJYjTP+ir9oSLD1FLAR2ha
         wMsKppR4pYfIwsW31QyrP0Q23+kJ3shXs7GC6tE77zDcLDRvQyK3yJHSGIh3XX5JJPgd
         naAg==
X-Forwarded-Encrypted: i=1; AFNElJ/br7B6gnKgC+IibU2jwH6WHrwF+chf/E1+Afm2ry7tvf/DhoiBi0mt+MVw6E5VNm7uNvTqaCYUZg==@lists.linux.dev
X-Gm-Message-State: AOJu0YxHzzsOYMIFbb75rsTxy/mZxz41Cn5XViyQCDJD9OYyptQLmLCE
	C4sSThuiOSnj9dtlzQR498PlBKDbd1hYU4mpXMj9fARIdDxb+gNX1+ckmMfJLNwLrR8=
X-Gm-Gg: Acq92OFaxOjz9BqP3CUuGYvtZOG7lDr8PweSXTxZ6dR11QBQEKu73az1BeIsl9cJEEf
	5WqKEZTV1ln+9QMt+8fjPn5MBoaorsdLSpi8UlFPSHkQUuxSu4iy1UMIG+yJ9yLFRad3BEs7mDZ
	A5K8zH+QUDjzUjF9mgId0xrvr6mk52C2E1C3nyMzE1bHZsxd9fredlaV240adpAKcsZdWahI+Db
	LYS0F+4HThB0ilSlR/YVCtg3sMRh+irmytjGVAfAVR06ZfkNll9GshNk8LY6Iw7idHAcwPoAPSn
	vcYePO29vQ+u9Ko8kDMR0v21V7m13TzAF6IJdMEj4EzEITAtOwtf35mRZZiWI2Lza0cF1qQa1ND
	LYIfTd9wnlZJvmVBcRXp45YjQjMN3N65xU1fqfshv0sadB7Ng9801H6QHmcrZv7sZjxcD/FmYNm
	9tgF7LSD9KMDh4g/uKHvRVjpcmuXO2HL4kpyovxNj/a5LLqxLJ+F7L3AVeE7GpAbTKBfBIVUE03
	4qUdK2We+HiwQ==
X-Received: by 2002:a05:6000:290b:b0:43d:7e6f:3816 with SMTP id ffacd0b85a97d-45eb38c359fmr7314300f8f.40.1779468289215;
        Fri, 22 May 2026 09:44:49 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-45eb6c9f58dsm5196118f8f.5.2026.05.22.09.44.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2026 09:44:48 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Brian Bunker <brian@purestorage.com>,
	dm-devel@lists.linux.dev
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 07/19] libmultipath: use shared_ptr for checker classes
Date: Fri, 22 May 2026 18:44:03 +0200
Message-ID: <20260522164415.846589-8-mwilck@suse.com>
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

Utilize the share_ptr code for tracking the refcount of checker classes.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/checkers.c | 58 ++++++++++++++---------------------------
 libmultipath/checkers.h |  2 --
 2 files changed, 19 insertions(+), 41 deletions(-)

diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
index 5655146..a3b9cc8 100644
--- a/libmultipath/checkers.c
+++ b/libmultipath/checkers.c
@@ -39,41 +39,11 @@ const char *checker_state_name(int i)
 	return checker_state_names[i];
 }
 
-static struct checker_class *alloc_checker_class(void)
+static void free_checker_class(void *ptr)
 {
-	struct checker_class *c;
-
-	c = calloc(1, sizeof(struct checker_class));
-	if (c) {
-		INIT_LIST_HEAD(&c->node);
-		uatomic_set(&c->refcount, 1);
-	}
-	return c;
-}
-
-/* Use uatomic_{sub,add}_return() to ensure proper memory barriers */
-static int checker_class_ref(struct checker_class *cls)
-{
-	return uatomic_add_return(&cls->refcount, 1);
-}
-
-static int checker_class_unref(struct checker_class *cls)
-{
-	return uatomic_sub_return(&cls->refcount, 1);
-}
-
-void free_checker_class(struct checker_class *c)
-{
-	int cnt;
-
+	struct checker_class *c = ptr;
 	if (!c)
 		return;
-	cnt = checker_class_unref(c);
-	if (cnt != 0) {
-		condlog(cnt < 0 ? 1 : 4, "%s checker refcount %d",
-			c->name, cnt);
-		return;
-	}
 	condlog(3, "unloading %s checker", c->name);
 	list_del(&c->node);
 	if (c->reset)
@@ -84,7 +54,18 @@ void free_checker_class(struct checker_class *c)
 				c->name, dlerror());
 		}
 	}
-	free(c);
+}
+
+static struct checker_class *alloc_checker_class(void)
+{
+	struct checker_class *c;
+
+	c = alloc_shared_ptr(sizeof(*c), free_checker_class);
+	if (c) {
+		memset(c, 0, sizeof(*c));
+		INIT_LIST_HEAD(&c->node);
+	}
+	return c;
 }
 
 void cleanup_checkers (void)
@@ -92,9 +73,8 @@ void cleanup_checkers (void)
 	struct checker_class *checker_loop;
 	struct checker_class *checker_temp;
 
-	list_for_each_entry_safe(checker_loop, checker_temp, &checkers, node) {
-		free_checker_class(checker_loop);
-	}
+	list_for_each_entry_safe(checker_loop, checker_temp, &checkers, node)
+		put_shared_ptr(checker_loop);
 }
 
 static struct checker_class *checker_class_lookup(const char *name)
@@ -198,7 +178,7 @@ done:
 	list_add(&c->node, &checkers);
 	return c;
 out:
-	free_checker_class(c);
+	put_shared_ptr(c);
 	return NULL;
 }
 
@@ -284,7 +264,7 @@ void checker_put (struct checker * dst)
 	if (src && src->free)
 		src->free(dst);
 	checker_clear(dst);
-	free_checker_class(src);
+	put_shared_ptr(src);
 }
 
 int checker_get_state(struct checker *c)
@@ -393,7 +373,7 @@ void checker_get(struct checker *dst, const char *name)
 	if (!src)
 		return;
 
-	(void)checker_class_ref(dst->cls);
+	get_shared_ptr(dst->cls);
 }
 
 int init_checkers(void)
diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
index e69dfd9..7ff8e01 100644
--- a/libmultipath/checkers.h
+++ b/libmultipath/checkers.h
@@ -135,7 +135,6 @@ struct checker;
 struct checker_class {
 	struct list_head node;
 	void *handle;
-	int refcount;
 	int sync;
 	char name[CHECKER_NAME_LEN];
 	int (*check)(struct checker *);
@@ -200,7 +199,6 @@ void checker_get(struct checker *, const char *);
 int libcheck_check(struct checker *);
 int libcheck_init(struct checker *);
 void libcheck_free(struct checker *);
-void *libcheck_thread(struct checker_context *ctx);
 void libcheck_reset(void);
 int libcheck_mp_init(struct checker *);
 int libcheck_pending(struct checker *c);
-- 
2.54.0

