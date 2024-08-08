Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E4AC18FC8B
	for <dm-devel@lists.linux.dev>; Thu,  8 Aug 2024 15:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723130804; cv=none; b=BNlarb+/H4UPX9+akBphLoM8hdqqBKo3xGyO0suGf/zei6KDMB43zrb8YgeauFLlacWHmwEyruDVT7vw0QUywPN6Ww22AcZN2Rzk1s47DwFraFQdFTOtUdthy0ZArQWKF11oBsqeZtR1Kz9rC5Lf7iiEi5mYzheTTWBi1fx+EqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723130804; c=relaxed/simple;
	bh=NOFk6e52Uc7MAjLOv9ZjNGotUPymEq6QB+RbEmle4lk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cpj8x7IGwuTUAjvnlPqpbiYMWfmSU6+Af3IZt6fVk4fOzQ3DqJgwAa+tuh17TcALNJXCUkEIgRktjJhsKXN51BKMXNEcS7ITOddbsWPAeJ01TeTF/l6+abX4ge/eyJNHlGLIpCP0UDJsaRfWoAQ0mU++5LXV+SxKsyRmRWvZG80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PBHTAm2I; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PBHTAm2I"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5af326eddb2so3573229a12.1
        for <dm-devel@lists.linux.dev>; Thu, 08 Aug 2024 08:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723130800; x=1723735600; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ahsw4dy4eRtFoE83ZWIz+kosLp6YcHyTpHwz+qnszlo=;
        b=PBHTAm2IvTmP3fXkaAK5d1EOqF0xjjfoG6rEICOG9NmFAJMgq7UtIWZ41dmdPq2qiD
         F89u5Lzcq8JVIubhDzxZHZjugHw4dE8zyNb//G0xJl17I5JAQNRHeWkTsxqtpo6KdefJ
         nsWImhwqjtD4xNJ9noM2u/sbOB9gv6+gzl0O2zylvQkPG9bV871fSY2jpF5RNpUxoOkd
         eqCmJT6FxWyoFiYQH/o8Ue2yDc8SUP8S9qDcOuK498zbePc0BwqlcQQnmDL8oyQC6B5H
         pH4LDkyJSTyXcohGY1OvuraULT1vUkAHJtqDDfZU2YoeF5eb4pYjjDlIMBxbGptx73Lp
         BhvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723130800; x=1723735600;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ahsw4dy4eRtFoE83ZWIz+kosLp6YcHyTpHwz+qnszlo=;
        b=E7ssz7ozjqKen3Qwt7YX2lq7H0yhxGdoRkQNOGXU8FZOvJlJ+R7UZ7px4vqBrZjMoQ
         SjB3tqRt5uUHL5tgSAzzhoffPBSmz00VZv5jA4dpcVGpCdPat3ZARv3bMH0l0ZVs2FVr
         WIY6e1la8NYPuB8glcqoRVsGjE55jFELLSODwzaY7iITVashdJ/0aj6XVYK7L0z86/1d
         1zEkrZ+8LQkE8t5kA5INfOgarr71iQRYkadPEYiJL69BNY93SEBnzIfmTR7BFF6FkUBQ
         FkA7BlrH5nDeoaMNHfBx+/lXVA8sxRxRfFDJAQb/iMV55x5MGpCde9z9jm65JR+KIzOa
         Kf+w==
X-Gm-Message-State: AOJu0YzOhU2by56LhtZ2OFAcOgvFqS66ZsbW7RabVcFzHvwv16GfeJLk
	fu37AaYgpo6ZG0C7h9FHtxoKqSBOhkqYrCIivRrXK0Ry2XEHy2hGrd7r2idZiK9aL7TswMNKBlN
	g0pE=
X-Google-Smtp-Source: AGHT+IH1e6CKHMNZEw2U7e8WS2fKoiRizfAIn4sy94fd6vQ8jHGy3SXVrJMPtqoz/BUDpQnNcgRmAA==
X-Received: by 2002:a17:907:a0c:b0:a72:66d5:892c with SMTP id a640c23a62f3a-a8091f5aba8mr217347166b.18.1723130799586;
        Thu, 08 Aug 2024 08:26:39 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a7dc9bc3c9asm752437066b.37.2024.08.08.08.26.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Aug 2024 08:26:39 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 06/41] libmultipath: devmapper.c: rename __DR_UNUSED__, and fix __attribute typo
Date: Thu,  8 Aug 2024 17:25:45 +0200
Message-ID: <20240808152620.93965-7-mwilck@suse.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240808152620.93965-1-mwilck@suse.com>
References: <20240808152620.93965-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 0347a17..fe604f1 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -45,9 +45,9 @@ static int dm_conf_verbosity;
 
 #ifdef LIBDM_API_DEFERRED
 static int dm_cancel_remove_partmaps(const char * mapname);
-#define __DR_UNUSED__ /* empty */
+#define DR_UNUSED__ /* empty */
 #else
-#define __DR_UNUSED__ __attribute__((unused))
+#define DR_UNUSED__ __attribute__((unused))
 #endif
 
 static int dm_remove_partmaps (const char *mapname, int flags);
@@ -1041,7 +1041,7 @@ int _dm_flush_map (const char *mapname, int flags, int retries)
 }
 
 int
-dm_flush_map_nopaths(const char *mapname, int deferred_remove __DR_UNUSED__)
+dm_flush_map_nopaths(const char *mapname, int deferred_remove DR_UNUSED__)
 {
 	int flags = DMFL_NEED_SYNC;
 
@@ -1196,7 +1196,7 @@ dm_disablegroup(const char * mapname, int index)
 
 static int dm_get_multipath(const char *name, struct multipath **pmpp)
 {
-	struct multipath __attribute((cleanup(cleanup_multipath))) *mpp = NULL;
+	struct multipath __attribute__((cleanup(cleanup_multipath))) *mpp = NULL;
 	char uuid[DM_UUID_LEN];
 	int rc;
 
-- 
2.46.0

