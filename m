Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08DFA2309BE
	for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 14:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766155294; cv=none; b=aS1Vpz7Ai7YDXN9Ow7hyEtPvLN2+raQDk94MqKPZnG6PpDnr3WLtOxH1JLtNSapNqLqaUxdQ1s9LuiUft9VklKv/JrZHgKKMs8ebn9UeS6FyZ+iyHWuuU/1G88bGfflsLCCaF6Xzk5pMReDBcGDnbZYGZVRkBC8wC1DowLoaPxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766155294; c=relaxed/simple;
	bh=PpTk0iflelULXPxgwCjH2GXiDCF2w7PS+L9CVL3uf4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CN4vQAR0iaPd7/wxa/1t/c4utoFv36+zULLAlTLuB0iY3MEN+8VPSg51YjFtFhWe6AOh0PRgTxsdI6oAQjgPfLvU61ovJBOeM86tHQPBLhmCoqzuBoeP5aS+7ElYJfljNdR/f7rIvWzwkisOWx5NjXg1JUcfA0lqExZ2yhgaldg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Kmhw2/Rp; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Kmhw2/Rp"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-640ca678745so3125358a12.2
        for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 06:41:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766155291; x=1766760091; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xc1kdb5mxblUyjrlEcOt9gflOzUZYr7H6u09tQXwUzE=;
        b=Kmhw2/Rpds4AaR8Ikn+YRx3gsCoe27BeRsUG3wNoqFIwGN1WoF48wui1r6Wl3lyEd8
         nkUXutY5CO4o/UFaAngIstRyEHBifM1SZA+8B7GIOH8Z2yWmSVutZhAf2qlXq1jbNGw8
         ldI055oan0iOzo4QpQLYUDPFwQ4uMohu80xOfO6dY0yuAZOfxWTjHCXrYIf9OikKhwI0
         eoL1eQUaY432GiBmWrUsHdm6PFEFTUsMR3D55xQGTLMT+0WbSoFg7gC9SMolZK5QtBSP
         d1Nl0iLSnM+Vi7h9z/qDrCzPUJBxsz1TB300wYbSA0CJMNqDw2JEPJupOJxJemuGCCpF
         ngAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766155291; x=1766760091;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xc1kdb5mxblUyjrlEcOt9gflOzUZYr7H6u09tQXwUzE=;
        b=PjtNCBsnnv+ZfkvIJ1tMzosXjbLzyQkVm6MGu8VBRVDH4bg7N9yLQm4WMh+GCleKGX
         9V8jiPniwMbH6b827tu0gGaD5m/qZPB0WXMZY/fPoR0UhfxqZ9oPa64RGlV/po/aR/bu
         NwyLkKXi9pgAwH77HV4BzqRoDcGKIFEgTFRIWWTQ00qh/k0RLS9sm9lY5T0Asr4TF1I4
         mkJqbRvzNY5cdl27F7OQOPgRsyuaAPh+TCEiifNpJKkMtrzUvSTiqpuXITq0VCilz8fx
         aF4Yk+LkoCHYpKAE9gsymLGVO0+tAsCEXwhFdI58U6YgseUP7PZjA9cthviIsIic9SBM
         kgGQ==
X-Gm-Message-State: AOJu0YxLJo0YzHXHxz5kPY/A9s4sFyCPHgptdyLIBCB7524K31OgJ3ji
	BLBlREtkSa5NcNReGcFrFnRS0x5sMr6tStw6miOc9FzISV9Y1322BTsZJlm9pCGozio=
X-Gm-Gg: AY/fxX5QXswdHC8AlRmLDF/QfRUi+C+Plm8WRAP144sk/GDm8Ch6GU7m/4rmbyxH/Eh
	A/KKu6MBl4tGmX+w01ryrBxT6375X9FSAokgjf4UxdShpPIP33PIeN/sbQ6mmdgAiVC5RPyDPyL
	DaexMGaDWDGqvXS4cnHvA9DWCIepFcX1UeL8w5YiuYGn3AkXcRfcjqTwQzVIbljK/jFngAlyPq+
	Nr3qjcL3kPMsQ+rBMdRR/XWdklZTe2VsqTe66uicHnFKJnlv5Pu+3mLunt8j5W4aVBMKd2DhJ2H
	MDTYkeYh2SfP2q97FVxXTlEnufUIFI//uYuADLfxYc3JF9i+Y4Ez+dMb3o99NMFppfrJfcvTMxW
	PPHrOupAN+0yTahwGbLPKznmpT+FKFnKRBKShrytOqMOxHP0iLhLtETNyGmXW9WQDLn2iOvUXfT
	JMUzhreFAJRrSj3NYSTzDKC/F6qnfqkTyWb4Xh1IUolUvoVietWnl1EhFfquS35UiumoTAR3Pnb
	NEu3GFjlah+
X-Google-Smtp-Source: AGHT+IFiIOc4fbQ8CBUjsFhfTqks7frr2XaWrKcRqq88hD67Nk6LRJy6aCG0iTIZR1L/UkLyd9YNYg==
X-Received: by 2002:a17:907:7e97:b0:b7c:fe7c:e37f with SMTP id a640c23a62f3a-b8036f0f1b5mr314579766b.18.1766155291270;
        Fri, 19 Dec 2025 06:41:31 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b8037ad8577sm247950266b.24.2025.12.19.06.41.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Dec 2025 06:41:30 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 13/26] multipath: free paths through pathvec in check_usable_paths()
Date: Fri, 19 Dec 2025 15:40:55 +0100
Message-ID: <20251219144108.237928-14-mwilck@suse.com>
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

Paths belong to the pathvec and should be freed from it.
Use cleanup_multipath() instead of cleanup_multipath_and_paths(),
and free the paths via the pathvec instead.

Suggested-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/multipath/main.c b/multipath/main.c
index 4b8d7dd..d28628b 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -214,12 +214,12 @@ static int check_usable_paths(struct config *conf,
 			      const char *devpath, enum devtypes dev_type)
 {
 	struct udev_device __attribute__((cleanup(cleanup_udev_device))) *ud = NULL;
-	struct multipath __attribute__((cleanup(cleanup_multipath_and_paths))) *mpp = NULL;
+	struct multipath __attribute__((cleanup(cleanup_multipath))) *mpp = NULL;
 	struct pathgroup *pg;
 	struct path *pp;
 	char __attribute__((cleanup(cleanup_charp))) *params = NULL;
 	char __attribute__((cleanup(cleanup_charp))) *status = NULL;
-	vector __attribute((cleanup(cleanup_vector))) pathvec = NULL;
+	vector __attribute((cleanup(cleanup_pathvec_and_free_paths))) pathvec = NULL;
 	char uuid[DM_UUID_LEN];
 	dev_t devt;
 	int r = 1, i, j;
-- 
2.52.0

