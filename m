Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1BB330F7F9
	for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 21:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766006486; cv=none; b=RKFHR4dSyc+jMu5zPwqfeQKBWxxBA8Xt+wfmKOYhGWMi+YfChuRTUL1/ZoiFqX0EqhAkVk4GOPND616ohMgYPC/MGUflKvdicK81oTOip46Z1vmMdfCpZ5vATRSpwvgTI3qdSiXBftVSigDWB7IeQynwISXW83VNN3cwsf8mJjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766006486; c=relaxed/simple;
	bh=BL/zRnRwUF5g/5G47sBr3JovPQ8I38cphh67wQ6o1q0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AZN/2PhqHiW/BTYQI7RV05xW7vwSyWA7OpFYAt2F5SROoqOTcR2iae2sqC6pAVEw6jWMAY+Mq8uCE/gurleptDp/Qz+xl4LtvjG+zqfyjD4fbuZv1pSPQU1cJ27o6wNH6i/ohBIPJeaRigVN3yrlozRT00xCuOkZFeB6SOhiyvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BSuy2juK; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BSuy2juK"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-63c489f1e6cso2281667a12.1
        for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 13:21:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766006482; x=1766611282; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5Bs4ErL/wH8f/hrnKUGog4nEX5ZBJs2TqAf0LEunNIo=;
        b=BSuy2juKGHnhmL9BNwvsh2zuk7MlRAHEyoaJP8NOCpKI/1FVlxB31+4TCpdtTG9Q8B
         dzKNpOIisEoQ3vgjVq3oQKMLWshVLIewNGpdzBeTdnb3+n4TzBufNLhSrM9ejobfH218
         Tb2XkCZDKePaC5aHcUzwxnS3Os/SDqQWTgOJa4l9vcoOqH20NmHKUS1tOCExqlL8DChk
         3RBuSTpG+Lmo3CMYL/yWSVO8QILJh3+HG99ILKFy+E4dwzn5lDln0EQ3BHs2kzUc49wj
         pSXrgVyzT4Yo0tnBYaeBQi0Nfl1zSy09x7djs/gV1yzgaYKImKXdznacyP89bouaFTfU
         D1wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766006482; x=1766611282;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5Bs4ErL/wH8f/hrnKUGog4nEX5ZBJs2TqAf0LEunNIo=;
        b=o2BQObCIUegtXKNSj7P+UW5XFwE0AJfpriF5JjnAc3t7fk3JoPXjVLHVHZqX/t5LwA
         sVi9pQcOnKyQY8abSWPZCmsSm6ct3tfwhMhhX+cgz83REKIz5U/ymrMs8ACfUsD2juz5
         Dgqu9sqNWvzu79EHrCAzYQz8n4sVXFAYYgDuEo9/8o23sJc4gCX+NH/ZSiQY/wEy8LHo
         0db7nC+ZWIg0ZBY6f/yRrMs+q+hJU+uJm8i5IVStpnDaP4bqhKmHZSaZ4JyOjiCkbAzs
         xfynAjMTzypffkbmOvzDeD8d6CO3nhxs0pOIF3YqnXy2kI1RTumPFG2y8xNkW6PEx1Jx
         PhQQ==
X-Gm-Message-State: AOJu0YwOne4xwlkfLblqoTTYDL9HdQEEqLo66Fk8OWy5FNrCcAbZtxDu
	h/HnR5h7R9DZtT3xP6GfRU2LADQBV53DR5FTfA9uKLfJBd0gcs9fGvtnXiw0thct3I4=
X-Gm-Gg: AY/fxX54NTuKmDAfStagwiVAcYoGs9c5Z4pv0NeP+/R8zL1B/ONCpvmplS/rtu/PmFF
	fl8SQxZqqOz/KOpbDH3/rmNB/76ueOk4E9XnB1Hp42y+pcCr/NA4A0dKfr+806dU5rYTUjtUH+p
	GTUiThKse6/Rr9N67NUIwhWekZQEp8PxR9V0wf53Is0L5mLKZ52JrzWjwhAkGEj0a2EkXFLwvCj
	CUN0cLJmnXufhpznSMglvI8fZePnXs2ypL2oRJWhce7SKYipXP49Gas/z77R24O/nBMbmFnL87a
	WK0locy6IzDFgx2AUTeEHaqoUvZIfZVGfdq6LdIpylhf8NDIlB9M14diAQgeZd70zIPeIlC3nZx
	HnhuSC0O5UQEB8em3UdXqkXGc9hstAQjUXfLgvwa7qYAR/5Ok5D9ZG7V7BKxwpytsV/6zcmI8zu
	E+00vTXlh82OLXBYmsXCFyH1nD/vePN9jDGcSxIzIU5OsYQ344T4he07zUl7Bbtc5WrLEb1MvQ6
	A==
X-Google-Smtp-Source: AGHT+IFRkDnPE5lKkgL0cysENHyQzhqrPaEeidM/vwtk/znBJg/JLwYl5VuJ2HpPpix4cKjvE0hMGw==
X-Received: by 2002:a05:6402:348c:b0:649:c6fb:1f5c with SMTP id 4fb4d7f45d1cf-64b584b1391mr699858a12.5.1766006482062;
        Wed, 17 Dec 2025 13:21:22 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-64b585d4a04sm668367a12.10.2025.12.17.13.21.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Dec 2025 13:21:21 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 01/21] libmultipath: drop drop_multipath
Date: Wed, 17 Dec 2025 22:20:53 +0100
Message-ID: <20251217212113.234959-2-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251217212113.234959-1-mwilck@suse.com>
References: <20251217212113.234959-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This function is unused.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/structs.c | 18 ------------------
 libmultipath/structs.h |  1 -
 2 files changed, 19 deletions(-)

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
index 9247e74..81c69b4 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -583,7 +583,6 @@ void free_multipath (struct multipath *, enum free_path_mode free_paths);
 void cleanup_multipath(struct multipath **pmpp);
 void cleanup_multipath_and_paths(struct multipath **pmpp);
 void free_multipath_attributes (struct multipath *);
-void drop_multipath (vector mpvec, char * wwid, enum free_path_mode free_paths);
 void free_multipathvec (vector mpvec, enum free_path_mode free_paths);
 
 struct adapter_group * alloc_adaptergroup(void);
-- 
2.52.0

