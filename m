Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9865630FC06
	for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 21:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766006491; cv=none; b=UvUJJ+QWOkWGtg14lgGG5U6hf6B1gagpR7fvU4ae5LyUAoGNv7ydDqMBWIMAq1M8A14l/wzf5NHSLxhR/Q9G4XQaxuX3Wijnr6sAlEdDpDnx6pn41FgJOKggiHbr4jiVDdM2cnQHYsIaXjTYQMH/FLSMYZti8gL6Bj7jE9eqnZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766006491; c=relaxed/simple;
	bh=ArYCHYcFmIG8pY4CeG8mZ3WEwvWDQq0npPgnlt/Vlr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jQnQbkw6+tI00v8zGbn1QglG0EbSsLnfwYuOD9iMFP8LsyGXb61i2Xd19E8h+mlDAOzvMWf4L/uMdGR5q9SCjEQnaguEJmhSAPULXdhkygXZ2XgTjSo4fhijCOufB7zp8qInqUIDjBUN3wU1ULe/lEyjY6MvExbNF+gKNdrgmlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=f508Gh4V; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="f508Gh4V"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b735e278fa1so1137374666b.0
        for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 13:21:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766006488; x=1766611288; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=66t8FHwNxX6Dxf1gzMEf4/Vj4X2uf3f4HRlSNQsGZWo=;
        b=f508Gh4V/L1dfcDyMySRlyF34JOdSc5CmCfdZBkBpLi+PpstClBxzh1lWoUz4snZ1w
         iqLF6jpQwJquf8stQEcmn4m6EhW6b2zMt6vQAFmkhubktZvn12cZfUttFPpJI+2MUtyR
         RWbL/O0/jXT0UAqMsxshXmiDs9EmJWkmkY3Xw6DQSTjEKcWqFdnejEnX2hzTG9WdHghW
         w+VhfPGEfdj8/ceB2bCI7/hCPX5+Ne1rRJfNqjgyYOtjRAbofaHjG2Zw6cB3/aia3jlO
         Bo73TP9ypcIrOg4WV6pnS+uoovkK0clUbsgAOgbD1OjsoTELzl982UQrtGnsF9e1Y2iW
         Vkhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766006488; x=1766611288;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=66t8FHwNxX6Dxf1gzMEf4/Vj4X2uf3f4HRlSNQsGZWo=;
        b=cfnZQpW2u94Jd83uJ33t9uGMXuAAwfNQwrMOCAX62sfWe/+6aueTbqLHatmk7NYQnA
         GMz4sxnzA/W+H/23MuiecgyylDsiX5YRM0W9En+On1BWkVY7h4EwzaL5Ngh68sV2dMHC
         RJLnkeZiokmpr9E9WOhO19HUTZ5/6Yc+kYkAlLhoQqSw92fXLGuCT1q+1sDWuUU0U7/c
         3gxWsF34P19uNr2piQ37H9yJ3Q2aJ0R7tNXIKvY3h+BnJTrR2DerRypZCOQbNc2uVyRJ
         KExPUk3/g8RreysoFa7OtDLtQlBGgYU2IVL8Q5Rd514J5tfzLW3psJSzhRQBOVn5N7sh
         g5DQ==
X-Gm-Message-State: AOJu0YxxL85OtGWLWux+ZEzIUsFoLtaW1ZlLQmtiMH15CDIOD5nlycuC
	cZnHTyPtHZC6X7+Tv811tlDaPo5k8J+Crn/L2LxOsfDuk2KjguB5UaWP6CX7s8gX8is=
X-Gm-Gg: AY/fxX4/8dDqmgUBs6fVTMYqTSGFYjUQ0LPhNbajTY5MHLw1e+B6E2E8OMRannWXbwY
	X/EyYCilch8fu4Z0EtiLbxMoOPCFN7TtXkl15gQfcoa8pQJXOx2OkNBwxWv0Quq9WaGBwhgL5qP
	uSncjOv/R9+XQdUvAkQfU+pL6lWrWj0Bgzbtn6dU2JYWL3TIVGBKerFvMUem9dg7D4O+wT7ZHpV
	WgRgZ0d8g7IJp/Qq+W5j3Cjn8zIqW5uOYHOZeRiuKjcPrIqJMnU0IGNN76Z39v1ejWLupP+Hnyt
	vunkfyiq5PkphICcyfbMNO5P4/vSXWm+IxT52kXEgCad6ebhKYel13AS5Pgzkc7/xe+9roK/Hql
	YDUqX+a079gnoWRomK7MxDQ0BiOWyquqrN+hjMjQ2cB28hsdSJFFtS3A5RiAuLE4E/6Adj3P/kS
	SckQ9SSR0w5Vs4KJeaIgge5XzZj08cO5183T8YXaj0UL/dPCQ9OzJ/brCRS4M7BqOnSnBhhaMbP
	g==
X-Google-Smtp-Source: AGHT+IGt0QbzwDrStc9/OjnCcE8uuIJoQNAOuWu2oO1p8XwVi2pvw8n0rwzowAplBfo8YNrncUOSkQ==
X-Received: by 2002:a17:906:c115:b0:b77:1166:7d63 with SMTP id a640c23a62f3a-b7d238c34f1mr2083152166b.40.1766006487717;
        Wed, 17 Dec 2025 13:21:27 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-64b585d4a04sm668523a12.10.2025.12.17.13.21.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Dec 2025 13:21:26 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 06/21] libmultipath: don't free paths in orphan_paths()
Date: Wed, 17 Dec 2025 22:20:58 +0100
Message-ID: <20251217212113.234959-7-mwilck@suse.com>
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

remove_map() should just do what the name says, remove the map.
It is unexpected that it also frees the paths of the map, which
can happen if these paths are in INIT_PARTIAL or INIT_REMOVED
state. This is particularly wrong if remove_map is called from a code path
where other data structures are still holding references to the paths in
question, in particular configure() -> coalesce_paths().

Don't free paths in orphan_paths(). A follow-up patch will make sure
that these paths are freed from the checker loop.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/structs.c     |  4 ++++
 libmultipath/structs_vec.c | 15 +++------------
 2 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index e6e673f..7df5562 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -139,6 +139,10 @@ alloc_path (void)
 	return pp;
 }
 
+/*
+ * we don't set pp->initialized here.
+ * check_removed_path() relies on it being preserved.
+ */
 void
 uninitialize_path(struct path *pp)
 {
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 7f5da21..3344005 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -383,18 +383,9 @@ static void orphan_paths(vector pathvec, struct multipath *mpp, const char *reas
 	struct path * pp;
 
 	vector_foreach_slot (pathvec, pp, i) {
-		if (pp->mpp == mpp) {
-			if (pp->initialized == INIT_REMOVED ||
-			    pp->initialized == INIT_PARTIAL) {
-				condlog(3, "%s: freeing path in %s state",
-					pp->dev,
-					pp->initialized == INIT_REMOVED ?
-					"removed" : "partial");
-				vector_del_slot(pathvec, i--);
-				free_path(pp);
-			} else
-				orphan_path(pp, reason);
-		} else if (pp->add_when_online &&
+		if (pp->mpp == mpp)
+			orphan_path(pp, reason);
+		else if (pp->add_when_online &&
 			   strncmp(mpp->wwid, pp->wwid, WWID_SIZE) == 0) {
 			pp->add_when_online = false;
 		}
-- 
2.52.0

