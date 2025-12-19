Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B97A21C160
	for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 14:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766155283; cv=none; b=DElcpd6P92SQZg7H7TGRfuz+98Ci2aBahJ8/lQXQxotegmiJw6ZstyE380FkpYAu/+lt6BBcLnpECUuX5NNXkN+oelZDydeFf6Sf/luAvNuJRvm0/PNXy1cxriAohGldrp0FbDIDMxwS94xHRglkpBaD0XAA8IMQ+2CVduGdwdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766155283; c=relaxed/simple;
	bh=eo3u7f5Qa99k1dhUAeEXGPDOKDwn1WZU3TAaj0JV5so=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m48FkHqd3qCEDUrG8NEajaFuz80FNUQZb3Pw8FbuE/grGZyfuTzriMtI6xbYrG6XFCPqakbGYNupjtPW7urpWVXP8Uj+IVLDWVx8/zjIOKj6iqjaPUIG7yUqDbaMS8TdvkpDYdZVBB1cz7PyLOof8aRjbkP3BxGBCUUgyQUAQao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=KK3Vvr3X; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="KK3Vvr3X"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-64b9b0b4d5dso1260900a12.1
        for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 06:41:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766155278; x=1766760078; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wO6+sKjgYCE+0Jb39O7QEN+DAwhOPH/9wWP9XP540Lg=;
        b=KK3Vvr3XuxHrH2PW37ZihlX/3ojd4nqcFaLrgUC1S2jG3iMXKF1ByKlofsBkfUbEOv
         ZiFUL8hKwpq7kxncLgqugGF9kkRVhywOuqjXXkZr3vzJo5H4C4FjXzojDt2oB53hLvf2
         0ACh5Sl3KOVdAJBrKgPrxUu5zNERAsvPCTvpjzv0aK0dAPbHLzECKt8lRvmKJhAJLX9p
         7lfXFr96HTQ7/MF2hqWGj32XyKjL0dJbb4jsPKSiDX5yFrGMxettE4Jwohfo0zIyHT5G
         dQFfBP1iNWoI9LeHFBHUJzzOcgUWd9v11201ibJvtn+QX2DCe9FjIynkxwftZAa1G7Ko
         dqbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766155278; x=1766760078;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wO6+sKjgYCE+0Jb39O7QEN+DAwhOPH/9wWP9XP540Lg=;
        b=TKYMr2xY0cO1UaLgZfGkL4JFVTl8RR7bHycT5kEWBM2rwZhsTYCtXsSfdWkwv6MX10
         6pCDDBMCQ/Wtr8n9S/JFDuF8V7qnztJmNuesssrUpOVK6+nKwYwbQQdn0wtyQU70/aDy
         ptiSi2jgj6IKgx8EpbLa1zFuGkRHjlgMhaaQ1WZ4M5Tg/X8yVcBb4/Qgx+G01P//T/gf
         FfV7PXfV7Wu0xo8A/AyFxVlF8GX/lMAVNmTnWXhMCDlvyV27R/9vH1VJLhcbwELqaknk
         cSx7ZXAPd/Xoy9IB/T++z5afxJB6qZ2lxMk0XG85PviaL+5bORmNznOUGfEh20Oi8wU6
         zNdQ==
X-Gm-Message-State: AOJu0YyhZMEQ5J4QGPNRNClNCIaAh9kvfZllxC0kpAW+LIU5HivY0yuc
	ks4HS3cI2G51yPccFN0ImcE5XPWqH6fTVQ52IgIxgVfGHsNlOVZstCK//MN5/qdpnU8=
X-Gm-Gg: AY/fxX48tUbzflJHBCpjLS8cv/HvdsPHKqdq0lQW/NGnLvSL/6MlAxsGx2jEkGHdL+A
	VJ13KiCGYLZj9wVmUugTxv82gYpOxef1MeslTSGKwiOexBGeTVdvSWYfMqtvuk1M8ZaAsdz0ID5
	lCcI7pWBDmsQlpuoWFuypRHX8g5GuGXSrsRR1iyWzjKU8xZY41x0rTXCQyDUz/l4hPqavxs4QWO
	efTEt6w1HLaNQ43BnAeH+n45ep4asR9kPKmXJGC/HtrS0F1LOI5ULXq0SqdWtVuM438A95R67Qq
	euIHJHeyqjlo/8dq6uB+tTS1e/+ZwXlHwCPk6yPKIs3DpWTiFgYyfT7QuyVsdQQ3H6C7ayVHgU3
	HDKpylOps3fC11vdg3uESRDDSgNCxIXNvJR3le5B4+pcCvfTBjmQVaDKZKtE0+MHeCpXrjITgN2
	RS2qsbBH+Y1jGl8U3CM1mOcGWzMoQNgPP83j6rvZ/+1Ml4P4VgQuaVh46RGKfAivFyWYruxFiaa
	A9R4HqpLHsA
X-Google-Smtp-Source: AGHT+IES4m+aEhJmEJOOB7YnuJ5rkDqEnmjSoaLJ+4XGhem/I5LGZvcmP+YzsaxYYiV4XxhQhowjGg==
X-Received: by 2002:a05:6402:510a:b0:64b:946a:4a3a with SMTP id 4fb4d7f45d1cf-64b946a5166mr2070552a12.31.1766155277990;
        Fri, 19 Dec 2025 06:41:17 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-64b9105655asm2412783a12.9.2025.12.19.06.41.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Dec 2025 06:41:17 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 01/26] libmultipath: drop drop_multipath
Date: Fri, 19 Dec 2025 15:40:43 +0100
Message-ID: <20251219144108.237928-2-mwilck@suse.com>
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

This function is unused.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/structs.c | 18 ------------------
 libmultipath/structs.h |  3 +--
 2 files changed, 1 insertion(+), 20 deletions(-)

diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index dfa547b..1cbbea8 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -353,24 +353,6 @@ void cleanup_multipath_and_paths(struct multipath **pmpp)
 		free_multipath(*pmpp, FREE_PATHS);
 }
 
-void
-drop_multipath (vector mpvec, char * wwid, enum free_path_mode free_paths)
-{
-	int i;
-	struct multipath * mpp;
-
-	if (!mpvec)
-		return;
-
-	vector_foreach_slot (mpvec, mpp, i) {
-		if (!strncmp(mpp->wwid, wwid, WWID_SIZE)) {
-			free_multipath(mpp, free_paths);
-			vector_del_slot(mpvec, i);
-			return;
-		}
-	}
-}
-
 void
 free_multipathvec (vector mpvec, enum free_path_mode free_paths)
 {
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 9247e74..e7a0585 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -582,8 +582,7 @@ void free_pgvec (vector pgvec, enum free_path_mode free_paths);
 void free_multipath (struct multipath *, enum free_path_mode free_paths);
 void cleanup_multipath(struct multipath **pmpp);
 void cleanup_multipath_and_paths(struct multipath **pmpp);
-void free_multipath_attributes (struct multipath *);
-void drop_multipath (vector mpvec, char * wwid, enum free_path_mode free_paths);
+void free_multipath_attributes(struct multipath *);
 void free_multipathvec (vector mpvec, enum free_path_mode free_paths);
 
 struct adapter_group * alloc_adaptergroup(void);
-- 
2.52.0

