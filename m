Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6D421C160
	for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 14:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766155298; cv=none; b=sJKRz3EWdvxWKHExMnynKzjKFGQGyBC9NfRb6Yeqtu6ykWmF/GSc/wzO80iUi54GtiH7tV0NOOwvrTgdsfj9ilATuh/8bvR8OvlOeNnVLdy+fxqtb4VMaYiTO1ymvnJ3ftXkS4pnBG3ME+40Xlu098XNfzYL4Z7JkXgATXtlN10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766155298; c=relaxed/simple;
	bh=pagyc188YiZqmvBgsAejWzFWnH/00y2ksA+4OUZ2jzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qfjPuG0pxPy6wnW/UO7wwjR5mWj3kX54PzFxfJkWxS2k/sH+ffi/SSlI7Dq/SnJuL31XPCO9LE2YA56AqJyac8jIAUKXXm1By0OI8kWRR6VSTkKJEnUTBF0Qk3/i1SB76CP70gBmS0N0O7Z1LRCJI3n5pvstF7ykTjKyJu99F7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Kp6UN1EV; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Kp6UN1EV"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b8018eba13cso152464566b.1
        for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 06:41:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766155294; x=1766760094; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t3khDVMKDlrZ1QZPn21K9U5r6cR+HpaL35d4A6PcRAg=;
        b=Kp6UN1EV08TLRvxsvNqh9okbK3o6QndJq2N42GlfISiATLE/27imtXplVSbpLK3UtO
         lwaKhH1VR6Az+3EXp2pe77tlppuhXxRegCZAxJxxG8OsWWgUdrnyscVNjOpJTY39hYqR
         yDCTwYdNBxdG7l23kfgwlNric7IIOksLFJELiNXHV9Ghe6FfYfJjGFfQHNIkysMTHaUQ
         B/c5I2DFDfhJX3AtdNjq+GbnjrJ8JXKyWkClnGhdXBxw4sTEUPugxxnXHJNLr37dhNAk
         cNtpvAdigO/2vKLxo86qC3LCTP48QzHRQEokvy1hJWvg7uWOV8gwkpkTDIhii+1kZ/oA
         cF9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766155294; x=1766760094;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=t3khDVMKDlrZ1QZPn21K9U5r6cR+HpaL35d4A6PcRAg=;
        b=JcsP9jAZgHNgn3ZYEpINpHDYUxM51lDpSUJHsjVsjHIAOkvIrFcwmPmgA0XsMJr95n
         Vq6R0qj3WXvo24PjSz3DEvWCDai1A+uXbXs0g1AeNIAXJmBXx+AWTyuVnCe9pq6ZjHP3
         Su2CTgPOGlJwIea4YXNTuavL3VAEYojnGT1N2FG/rPlfmHxrY10ZduLpBXadkayOZ46a
         gpjRdCfTH7dNk9XbXsB+4mZGpR880w528GeVBfmpmpkZ1gzi0TpdLPDwOM155neUn3IG
         8EnFmduk1nW5p/L2/7nYxLg7aeLwSG5nz9ycU5H+81WeaESqhIq/PbRi8lTMV4QBYtmT
         xdCw==
X-Gm-Message-State: AOJu0Yx/ZEDRqJ7HhoNHSbhm0zqFH+Q+L+eLG3oWDltvyvL0a4ez2h3y
	6l4Vj/j92gcGVIK2oLL5nXh3lXuzRNdJK/6R8/4EAg5MHZ0F9o8IW+9PAvY3CYoUsJI=
X-Gm-Gg: AY/fxX6H87RMtyTqkugNFAQy73OabwLiirUoUgCmB57dWQWMC02FOzW6iKRciJZB1c6
	eqbnKj8nsPuV5G/exrQ/EqEgqPakoBPSPmBqbPU4fUkZENRwABHSARAHpNTpOTy+i7fzl0SY96V
	5F9fmystcu0Bdr2RrHP0SjwsC5lZQbi+dxVWoIrM0XVZPu/RHLAkfsGS5fY85XmDfVejYrSC70E
	eQFQe1yVZaHSqp5T9byTcJggk7JwarskU8VUn7rzRNBIikoU8SXMFFEAw7FDLF1emZSPQYJmHXx
	NkAYPizi/IeaQQIImKrjCDNAXinGuBhw7vx5CuMje4+fURGXBOcJhHhwVJ6uvKf3C1SaoHQ6MbE
	CpE1O0Ytt+27o49v0kJLMFOr8F81W19rrIAIdSZo4bxLBvrpxAb+Sj52yQv1J2t6kZ1pcgdcTn9
	qEi2I0oQraXlrkSwfOsmfwvuDsHtOkyKsc7+iuVKUkv2wTMywEao46Es3B38Awp1ITqNUf8HM/T
	Q==
X-Google-Smtp-Source: AGHT+IESrREc2kHUTWBqa0uSTYHppsCWol8aYBMrKhc8oJX3byRlOXU5R+xKIltiOPsDNsxHgVv5AQ==
X-Received: by 2002:a17:907:8dcd:b0:b80:f2e:6e0 with SMTP id a640c23a62f3a-b80371756b6mr304728166b.35.1766155294466;
        Fri, 19 Dec 2025 06:41:34 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-64b91494ce2sm2366819a12.17.2025.12.19.06.41.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Dec 2025 06:41:33 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 16/26] libmultipath: remove cleanup_multipath_and_paths()
Date: Fri, 19 Dec 2025 15:40:58 +0100
Message-ID: <20251219144108.237928-17-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251219144108.237928-1-mwilck@suse.com>
References: <20251219144108.237928-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This function is not used any more.

Suggested-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/libmultipath.version | 1 -
 libmultipath/structs.c            | 6 ------
 libmultipath/structs.h            | 1 -
 3 files changed, 8 deletions(-)

diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index 366b829..39384d6 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -69,7 +69,6 @@ global:
 	cleanup_bindings;
 	cleanup_lock;
 	cleanup_multipath;
-	cleanup_multipath_and_paths;
 	cleanup_pathvec_and_free_paths;
 	cleanup_udev_device_ptr;
 	cleanup_udev_enumerate_ptr;
diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 9e1734d..868c3d6 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -324,12 +324,6 @@ void cleanup_multipath(struct multipath **pmpp)
 		free_multipath(*pmpp);
 }
 
-void cleanup_multipath_and_paths(struct multipath **pmpp)
-{
-	if (*pmpp)
-		free_multipath(*pmpp);
-}
-
 void free_multipathvec(vector mpvec)
 {
 	int i;
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index a637af7..251e672 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -582,7 +582,6 @@ void free_pathgroup(struct pathgroup *pgp);
 void free_pgvec(vector pgvec);
 void free_multipath(struct multipath *mpp);
 void cleanup_multipath(struct multipath **pmpp);
-void cleanup_multipath_and_paths(struct multipath **pmpp);
 void free_multipath_attributes(struct multipath *);
 void free_multipathvec(vector mpvec);
 
-- 
2.52.0

