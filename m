Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C945A28E569
	for <dm-devel@lists.linux.dev>; Wed,  7 May 2025 19:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644787; cv=none; b=XKwKS5O/d7JBX56lll1sObtmisR+UCAZd9Hm7wyD66oa/+swZhWNypXi8k8EMVElEhnlmM6lQnKHjzBsxSR6fl57pqbWakNGBY4s2hBvuogqG6zisic5YVSmlfqKES0VIFqPicBp+KWd/eMMOg4H2+CJJA9+8endNsqRESmJrEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644787; c=relaxed/simple;
	bh=s/OOb4J8Ot3/0aWU1evJLXber+ngoXvNsy5EnePZOMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BzdBpPDuw5rYZOxqLSJe57Al6WcqM+v2qFq3kQrOVIZrW+pZbd+s8UjXNxV+mAh4xQibGIf/3ok7jp5wuGEVwMNgSoJjkXTTIpXB91OmvOQu5R7g7ektjcE7T6kiHLJbjKkSmdcPxBHcd5ATpgWr+dwTGNadyS8gUESQWEVcSfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Qu2srvj2; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Qu2srvj2"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-43ce70f9afbso2429095e9.0
        for <dm-devel@lists.linux.dev>; Wed, 07 May 2025 12:06:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1746644784; x=1747249584; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kCnwWzJWRW3DW9JnZAKemdrhz/2+b+jvBNl3O44Vess=;
        b=Qu2srvj2poIzLn5jCl7qeT6k2D2AL8Ag82/+aYvZ64nGVxggaAmK/9t+uAAa88gQpt
         NoL54ww6iX2r2eetFJiqjEEzcqH+J5XiTc58eoLhV8KucNt23iuGHP1Hfz9ihq89Uyo/
         y5BSHztiR93aIFw8ZOqa7hHUsqoImMQmyWb+AmCyxJ+mhUU7zan2GkNYZEy2fr7mOb6M
         B42IMkTTP9IEpE0Fdu/bjiwBUoC9ta+QeR4afCnQE4s7Q32jKlbpi+Wo7lTNk6yQip43
         FTYAACFrFJn7FUn/kVypaXtSus+h556aWevuMvRXFHovyjCUTA7mcEjORYwRgvkuK5XL
         cjBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746644784; x=1747249584;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kCnwWzJWRW3DW9JnZAKemdrhz/2+b+jvBNl3O44Vess=;
        b=EW9lpnUviXZR7W1vjz1HcrNX30vax2YVR2mmBrtUj/iYNcx9C3o0p9iyNSXZi/yNYn
         zugyK/Xz0ZfI0bbj/khFJ1sQGT8KdqLGhtpP94iLpnJ8ZaOdH4aWTHgeBE4MDL1T7W0u
         0Oq5PBnbbp7TQK9Ph/Y8oY86b209j22U5O/dN5rPr1drSr3c9savk43WlhLW1rsc+Zm6
         eRlYzjG11KNt3xbdYfnbc1eS8B2mXsIc0qlfXWw5enj0wWnp12mfKJnZGbXRxUSZ0p8N
         bTZmizydKSTWM0c1oM6r2JFxzzH+lB8FKbXZ4F+qv1MnaUZ6kq99GAUR8pDPJbPebhXb
         heHQ==
X-Forwarded-Encrypted: i=1; AJvYcCXAAllkM5o3mxBsXj5dMi4RmcIEwfLk+u7oK8yRdpoGBRfmLOXvk/UfF2XYyu196okdQ+xawt4tKA==@lists.linux.dev
X-Gm-Message-State: AOJu0YzBOQG8qFQ1zaHS186iS1Z8OziKsBgjydBY2AotBiiTvrnOyGNX
	4l1xi+zO+UfW5zVs8jNxbRXLzc7MkpJo21+Pa6FfVVxjz845Nwvgs3lTHewmQIT07korfl9Zq1R
	g
X-Gm-Gg: ASbGnctGuuj92C74UNTPb4Av9jGarsr/k464CtMGmGtfyxS5rfucLwGd29TYaBmUevf
	90F8XOYhBxYltAtTj1ci5AyoWnZ6U54hqEoJnWxqAeHAycd6xdeJKiekbKKaHB4f8+qXk+6Kg3A
	PONb65WKwMBSt3902q//SVwhrWLuE4wVRjZ5wGxO1+L1A01EmM4xFv7F7rpfuw+NMtDaXgE5HAD
	fiiSGJaB43sU/9hgOr6a0nsccAmUNEA5w0yxlEOn8asnUow7WbO8W70/ICVw7C+1ok9FxMO5UyZ
	u41HTsRl2t83Btj5tPCzC20af7klD3IYGU7FNJZLuXZ4j0DKqysVN9F/Xymcj8BIEU2WNO98MPU
	k8sO1AcbStASSK5yklyGJyK/xHXL4
X-Google-Smtp-Source: AGHT+IHjLuec9DTzVyA7P2evjJt1WIxyJ9n3B4KO5NJEKbFyiwjAMh+2padqWRvtsvqXgJU64pHbGw==
X-Received: by 2002:a05:600c:1e03:b0:441:d438:505c with SMTP id 5b1f17b1804b1-442d034b36emr5381845e9.32.1746644783942;
        Wed, 07 May 2025 12:06:23 -0700 (PDT)
Received: from localhost (p200300de3740fd00677a2a06a3663993.dip0.t-ipconnect.de. [2003:de:3740:fd00:677a:2a06:a366:3993])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3a0b2c4a84csm4792463f8f.42.2025.05.07.12.06.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 May 2025 12:06:23 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	dm-devel@lists.linux.dev
Subject: [PATCH v2 7/8] libmpathutil: remove vector_repack()
Date: Wed,  7 May 2025 21:05:51 +0200
Message-ID: <20250507190552.209637-8-mwilck@suse.com>
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

This function is unused, and its implementation looks odd.
Remove it.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathutil/vector.c | 13 -------------
 libmpathutil/vector.h |  1 -
 2 files changed, 14 deletions(-)

diff --git a/libmpathutil/vector.c b/libmpathutil/vector.c
index f69d644..6ad5dd5 100644
--- a/libmpathutil/vector.c
+++ b/libmpathutil/vector.c
@@ -138,19 +138,6 @@ vector_del_slot(vector v, int slot)
 	}
 }
 
-void
-vector_repack(vector v)
-{
-	int i;
-
-	if (!v || !v->allocated)
-		return;
-
-	for (i = 0; i < VECTOR_SIZE(v); i++)
-		if (i > 0 && v->slot[i] == NULL)
-			vector_del_slot(v, i--);
-}
-
 vector
 vector_reset(vector v)
 {
diff --git a/libmpathutil/vector.h b/libmpathutil/vector.h
index 85127ad..171ab6a 100644
--- a/libmpathutil/vector.h
+++ b/libmpathutil/vector.h
@@ -86,7 +86,6 @@ extern void vector_del_slot(vector v, int slot);
 extern void *vector_insert_slot(vector v, int slot, void *value);
 int find_slot(vector v, const void *addr);
 int vector_find_or_add_slot(vector v, void *value);
-extern void vector_repack(vector v);
 extern void vector_dump(vector v);
 extern void dump_strvec(vector strvec);
 extern int vector_move_up(vector v, int src, int dest);
-- 
2.49.0

