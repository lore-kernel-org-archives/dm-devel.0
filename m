Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B359B28E5E4
	for <dm-devel@lists.linux.dev>; Wed,  7 May 2025 19:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644788; cv=none; b=L2sP+InwFvegGeKW2De/mmsfQiyKbnNRnWr/fgLUROvW95OGUfWkKYzoz2+ltefl3DlVPNxbgdhQMsU0QUJM1pW1WeEZUQsFaLi6R3nxl/sEihHYS9f58eQWsAcZdGkyXxPErHHrlF8KfvcTexwVjeCzxdIgAj1muUjEv4sx8G8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644788; c=relaxed/simple;
	bh=bD+j6w6R3vYXgauuBdZEd7il0MP/jZOjut+5ByGIHko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XUf+t5e/nppK54q7gGK/omnl/LTd+TREwhaw1eEV1QehnTf3pve+rCB8cgo1hOC7heiTZBYIujsaWTIzFXe/+4I1IDPmd+Fua5iyFgrjYvElM4h4fGRo3sNNXmwmMJHelaAR9OoyQ+dWBsamua559QxvQXqtw3IqXr6Umq3NPUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=UBAuli/+; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="UBAuli/+"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-39c266c2dd5so211321f8f.3
        for <dm-devel@lists.linux.dev>; Wed, 07 May 2025 12:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1746644785; x=1747249585; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iU1p6sFcIy4Z7KFWtjJZ0LnZr7IjT3YMG55w7eMnnpc=;
        b=UBAuli/+I2Fl12yEoQvDI4B9i3kf0S8UK1jUMtK3/EFxvadQqDzBWb9cggKv7EkxZh
         ua5onJ2C1re6BBnSqY4jWe+Cxx+n3yICfMw9+Rj0uwR42LsDztijiJwT9PnuTmpptBGG
         gJ0BzBSz79UHm6ms+PIAcld7NIX5t2gBws/AKlL2SD/kmINAZ9FrK+pvBIfms4+HV4Js
         iUwa5M3QlA/mEiJdV+aYO4YcISK59T6bk6H0u3G87tyIsIc45S5sVJnxZ7EJYIxmra35
         EgKaSEF9MnRcLKvMuUyl6ckzXjifydsDH3igsQpNFWR9hUUJw/lS1dfqzmoOEmVFJt11
         aMMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746644785; x=1747249585;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iU1p6sFcIy4Z7KFWtjJZ0LnZr7IjT3YMG55w7eMnnpc=;
        b=C0MdYaPnWIWqQXBvNZGzSnxX6PRxP0JyVDUrgy4ZyRcY4tFV78GcenBBvzsApKFne4
         cJkeguGarM7CEUkVzSqn62eBMM7lUci6sAYc0piEUg0l0/Pn67oNR10zziGHKu+5Wsar
         c2yr7cL1IBuJWNMIwTk9Njycf57jQQBrtb9LJEsbtnWIKfzS2n7GlvfiKFl41AeWHPM1
         OEfS7lbLb001VoOfnredwxmXSYm0rffIa0VZT4uhUhFJT/lI93oEC3NmZi61aiu1552Z
         s0oJTc5s11oA6Nuy6yMvdtBr+zaJF0RRiFk0DsKWzch3uFselJsPlnoceq55DAvxWpQ0
         v1Nw==
X-Forwarded-Encrypted: i=1; AJvYcCVlbyk1220PJFQX0zcVRE9ShkYyhW4okXlG7mhIpgcWkXHE+FY04JVPKvbOlesz9I6jBCO7o0KyAA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwW3hY8rxJmi7j7ZD6mQbjoDUy8nEzIJNP+TJNDj6iZPyujV9ej
	Jh3FVNNAfNo3F9KhH8EEgR9UyWKXODn6JOZu5cgLhFkXgbByTF4vGlhpDyLlveQ=
X-Gm-Gg: ASbGncthDJrjWOOZhU7ruyHENnKKiNRtjeXwGGsJ4TbLt84xS7V0iF2i2ClakvfE2Ee
	DquAanusxIkSKq4zHeNXBTqp5AQwPKCTOeXxXXXnU4Dl4FkNObHUCc3/sVJaDafY/UuWyIvPXDg
	7nLPxLMgsrJBK7MmY4IEBwtAHSE3YQkqC+Az4cRV6Fmaest2pkVdcuVTPV0cMLrpREwrgXZA0DL
	AkyQ2lGYbKXLLW7WpPaPQ5NF2NnuRM1hmvDkksgbXReJOh44xhPiRCCMsM9ehz0GnB/0uQb/M+w
	MvzrbHOdIEOcGnurmA3LNSVlyYJgqJe8TfyzvUvcRmY3Nad/v+nQN5Kw4+1+YvwZXhxvUt9gNGh
	4y4XlsttO3Lx3WRmGZ/FMPJByfAnJ
X-Google-Smtp-Source: AGHT+IGnrO6axW02JM+JF7x+VIjw5tHDmT1k2I/dmYHjGGPNCECVxidcUZwq+gxsz+nZHNFoh9EgWw==
X-Received: by 2002:a05:6000:2ab:b0:3a0:83b1:b3c1 with SMTP id ffacd0b85a97d-3a0ba0aa126mr263400f8f.15.1746644785150;
        Wed, 07 May 2025 12:06:25 -0700 (PDT)
Received: from localhost (p200300de3740fd00677a2a06a3663993.dip0.t-ipconnect.de. [2003:de:3740:fd00:677a:2a06:a366:3993])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3a0b8bb1f37sm829028f8f.84.2025.05.07.12.06.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 May 2025 12:06:24 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	dm-devel@lists.linux.dev
Subject: [PATCH v2 8/8] libmpathutil: remove VECTOR_DEFAULT_SIZE macro
Date: Wed,  7 May 2025 21:05:52 +0200
Message-ID: <20250507190552.209637-9-mwilck@suse.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507190552.209637-1-mwilck@suse.com>
References: <20250507190552.209637-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We always add or remove a single element in vector_add_slot() and
vector_remove_slot(). Use of the VECTOR_DEFAULT_SIZE macro suggests that
its value can be changed, but this is not the case.

Remove the macro.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathutil/vector.c | 4 ++--
 libmpathutil/vector.h | 3 +--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/libmpathutil/vector.c b/libmpathutil/vector.c
index 6ad5dd5..34a8512 100644
--- a/libmpathutil/vector.c
+++ b/libmpathutil/vector.c
@@ -45,7 +45,7 @@ vector_alloc_slot(vector v)
 	if (!v)
 		return false;
 
-	new_allocated = v->allocated + VECTOR_DEFAULT_SIZE;
+	new_allocated = v->allocated + 1;
 	new_slot = realloc(v->slot, sizeof (void *) * new_allocated);
 	if (!new_slot)
 		return false;
@@ -115,7 +115,7 @@ vector_del_slot(vector v, int slot)
 	for (i = slot + 1; i < VECTOR_SIZE(v); i++)
 		v->slot[i - 1] = v->slot[i];
 
-	v->allocated -= VECTOR_DEFAULT_SIZE;
+	v->allocated--;
 
 	if (v->allocated <= 0) {
 		free(v->slot);
diff --git a/libmpathutil/vector.h b/libmpathutil/vector.h
index 171ab6a..0a5b32e 100644
--- a/libmpathutil/vector.h
+++ b/libmpathutil/vector.h
@@ -32,8 +32,7 @@ struct vector_s {
 };
 typedef struct vector_s *vector;
 
-#define VECTOR_DEFAULT_SIZE 1
-#define VECTOR_SIZE(V)   ((V) ? ((V)->allocated) / VECTOR_DEFAULT_SIZE : 0)
+#define VECTOR_SIZE(V)   ((V) ? (V)->allocated : 0)
 #define VECTOR_SLOT(V,E) (((V) && (E) < VECTOR_SIZE(V) && (E) >= 0) ? (V)->slot[(E)] : NULL)
 #define VECTOR_LAST_SLOT(V)   (((V) && VECTOR_SIZE(V) > 0) ? (V)->slot[(VECTOR_SIZE(V) - 1)] : NULL)
 
-- 
2.49.0

