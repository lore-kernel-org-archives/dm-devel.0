Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB083396F8
	for <dm-devel@lists.linux.dev>; Wed,  7 Jan 2026 20:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767817140; cv=none; b=njdHc5ZMq/Q/+e5Jsb8K2L+dkCIDT3krlbjmr3C/6Tt+6Pp1ZyrB9VcGRDa5r5mjYo9gTC6a2+nvT//ER5yWZYgZ+ITSk3Q5QkxE7WLSCXBmrDdkBzNc7DerVE6SAS4fykJwtuzTSBF2Wy+unCgMGPgPXp9J6mPE1Xe42OmCEik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767817140; c=relaxed/simple;
	bh=/C15T6q/ue2tcZsfL3o/G4tNyJdOAQ8aUM6FnTPDlhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=guAsMBxJ/c8x/5GdPS+FULPM9PRropS6Xfr2zyjuU5YvjnhrUuZTGoP74r2vYq2x2erHMASX2GGYa/ACNJim4GqF5upgW9BE1m7QtzVV3QWXKT7EU1lzgbf2Co/rFETJnLi7pXZUPenxGL9FB9cXrJjEInQsBMrItM06yQUJprM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PFNtspb2; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PFNtspb2"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b83b72508f3so408040566b.2
        for <dm-devel@lists.linux.dev>; Wed, 07 Jan 2026 12:18:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767817135; x=1768421935; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lbAOFB5V0xgraVXg9CweY3OeUQRsfBgf/2Wi3EspVQ8=;
        b=PFNtspb2ygOtDkjbZaLN/QQ4anf0jVgRRjro/yVP8cqd0qONRBAnXViPPgI/b7MlgG
         tzHbkYADEeZp0cDP0fSsN5iyPP9NeEPZpXnE3IycqLTyRQRr1QsN8LCLI9jj49RkcLB4
         Zeac0ThEMA03QWmpSdHXIYdjzKIWOE4H9kz03beo+7d2NIicxvGy10bDCNwbeQvF/6T9
         RQxN6ZlRcgV7vBFbxiaGxRxwZXLKO7arVW4Xa7HTuene0fwTPrfcVQoSXLYicuFDNV0J
         zdhQbCJ14PEk0HOmfHEynJbAQ5O7COlHjyhuPKxTE05IrQ5BQiHPyG0Tm2+zsD/U2H+L
         FlYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767817135; x=1768421935;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lbAOFB5V0xgraVXg9CweY3OeUQRsfBgf/2Wi3EspVQ8=;
        b=VKNUFb99H9rBhVbdoFwvOzfAIae/Oy2CwrSOThLIDs/JdVXhq/TG77A/aHDPMFe0ue
         QjyPfUt4uWq1YyofPWqgbRr5PS+GAfSwk1g7EtrULksghlzhbLUnlIM37yQWp7r/qpwx
         /jp8AisnmZqMd6uluwj7z42xYdFMy9kLFwnYiikS2rkHRvKf2VqeFJerprHkN4bOjnqB
         A201tL7AjR7aiM/nLlFbBsfk6CWgEmm8xOoPMFVtafmsMcG7FmitsjTetiJzg3xQ80VN
         vlVIz0zd0y/dcRr5QPf/2r/mMfumB2sBZquKrFNt/Nyjffhd1T0TWPDTk9/7auQcyi3Q
         8Agw==
X-Gm-Message-State: AOJu0Ywyir+AnInm9fZCTla/T3I9hMPZRjoz0Rar899p1TO6gnVN0T3F
	EiI0hpXGhHyCfhfFVwQxWiA0qZJ3+yU3wK6KoDZ7e5oi+eSgSYy4CMd39xP8BNQDe2I=
X-Gm-Gg: AY/fxX4tXMNue0xc985dvaQd/u04yscw9aof5+OwWKJ7stgISpEYMRdukETAes+HN3D
	IWudEUvToYin+RMpXoHix/c+9190DYoqbHWKKmkn9u5M5/CUkIRkM574EVt6loAeEaTkVorgtv3
	ZCm7jDy2q1yl5lRLHQOK8TJFonc2i+sfCvUc6cymgQS8rk+z4RuZQdFyfNSJ5hS/3llnwpZS3lW
	SOjBICLvA9J4M1xZbj/4hm0uSwzYMx7U5Zm+o88KPjclFANiCzr/xQ8vtlFds1EM40Ztv80sisO
	PL8DfedAUCgSyL3pwEBmXCE3Ki9ZYw2UtTkaCAMlIJ/WT8mDNn6vHNhV1pd/Fzyp5AFozQz36OF
	Oj/xjCcVCQ1caWBn1GNhf3W2mjRzqe8gDpCqX8yEWRtVuEI1K8DGPD7SpG9wWXJ83TSVMA44YfT
	ZHhuNK4/XFdDjMe/6Hnak64vNW5aAt9v4L/lQIWAtonqTLGcwqHImWdbmCBBJzwJDxMc4ZMlwVr
	9yqvyw86JkP
X-Google-Smtp-Source: AGHT+IEQlHl5TB0gLWsdPkwbiQncHKYDc9bwS3n0UjzghrAolDtP9otqZoGlsQw51gUtZu15YHEjQA==
X-Received: by 2002:a17:907:6d01:b0:b84:1fc7:9457 with SMTP id a640c23a62f3a-b844519023cmr344571366b.8.1767817134917;
        Wed, 07 Jan 2026 12:18:54 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b842a2ab77bsm634351866b.25.2026.01.07.12.18.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jan 2026 12:18:54 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: [PATCH v3 14/26] multipath: free paths through pathvec in check_usable_paths()
Date: Wed,  7 Jan 2026 21:18:14 +0100
Message-ID: <20260107201826.323977-15-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260107201826.323977-1-mwilck@suse.com>
References: <20260107201826.323977-1-mwilck@suse.com>
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
 multipath/main.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/multipath/main.c b/multipath/main.c
index e3123e5..2b23564 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -214,12 +214,17 @@ static int check_usable_paths(struct config *conf,
 			      const char *devpath, enum devtypes dev_type)
 {
 	struct udev_device __attribute__((cleanup(cleanup_udev_device))) *ud = NULL;
-	struct multipath __attribute__((cleanup(cleanup_multipath_and_paths))) *mpp = NULL;
 	struct pathgroup *pg;
 	struct path *pp;
 	char __attribute__((cleanup(cleanup_charp))) *params = NULL;
 	char __attribute__((cleanup(cleanup_charp))) *status = NULL;
-	vector __attribute((cleanup(cleanup_vector))) pathvec = NULL;
+	vector __attribute((cleanup(cleanup_pathvec_and_free_paths))) pathvec = NULL;
+	/*
+	 * The sequence of variable definitions matters here, cleanup handlers
+	 * are executed in reverse order of definition, and we access pp->mpp
+	 * in free_multipath().
+	 */
+	struct multipath __attribute__((cleanup(cleanup_multipath))) *mpp = NULL;
 	char uuid[DM_UUID_LEN];
 	dev_t devt;
 	int r = 1, i, j;
-- 
2.52.0

