Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D64701AAE13
	for <dm-devel@lists.linux.dev>; Fri, 17 Jan 2025 20:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737145679; cv=none; b=TlV9EXL0PSzofLvFvYKeZAmAPhrik6zVxPfzRhf5GJZsJBuPtuWK9VcB+atYyHMpS+vzOtZ0NtReiFyC8k20EBIZ2QXyXXuRt3fALkmHU1Ip3j7EKv/QOqmq/CkStGNzQrl/RIZACvOAtkeljwhwSlKICcNwGW60y4b8OkBDvvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737145679; c=relaxed/simple;
	bh=myGFqqHcQLi1SYKR3C+dvtXbPkaXowosnZeITNlEB5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KaYr0sdtdBOw2rKsDi7az1etVh8JrLhyS0QJzQ0v8kfv2tseJDU+9yWrMFbccYL/Ul4Q6N4fg2mxsZg87xQa5rA5j+T4+nDKGpSJmV3RraQryqxfBvZW7/Y5MOOzmdkc4m8RyeQRIOD+Twh0e4ui847zzui9qvP4Hz65SxCtsts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=M0+g66Ix; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="M0+g66Ix"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4361815b96cso17215315e9.1
        for <dm-devel@lists.linux.dev>; Fri, 17 Jan 2025 12:27:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1737145676; x=1737750476; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fitHqImlk5TTJDF74Epkv/FvsB4bp2n7kksfYCUEsMY=;
        b=M0+g66Ixqk6N0fPeom3p5JA2AiNFhhqvEFEdonZ7DyyNKqRS/xk1YyeYHRaanFXsaH
         5Z5Qc295CRJWu7ltzcDOwlb8Str+vJJinAE4sI1L+gfQ9Jr8MYEISGNn9+g9yRO2gcdy
         Ul8DpGQh/OgO2zqovXiy8ydzJdGAYYl4HPuY6i59r43HFl8vjEdE/ztXWvUZxxkVlUpf
         Cc7+oxt2dOrTHkZ5thLglHTuXBTYb+UAY9j8TRXe/NmdLv+6r6eLsM1UhHgkL3kQE1UO
         m50C8Mhxd5zq5L2LmnTF6qpXjZVXZ9uttBVhNM/V02eLdoMkTD0XIAD0qL6XjnAYxb9d
         x3+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737145676; x=1737750476;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fitHqImlk5TTJDF74Epkv/FvsB4bp2n7kksfYCUEsMY=;
        b=TYX7GagUbDUfxJ2GNIJWmVK+5yqVhnJNGfHW/qt+NFt+vybY7XWzXJfjXBRswxI4Lt
         UQK0QQJJ5sZ+LxYIxTIJ/+rOcawiQq/fXXxazJ84uqVnRZiM55hJ8cw1dRzKErp8s4RM
         KtR7NrwP6/ZAVsd7GOFjCSxx7uj2RdN717F29uW5tMi9NSz2vhPP2lArupS3BhnfSpuz
         Mbnt/sC/V4VoNrwGarHsNCm5jMicOpj1hU4I5HXEYVM04fsC5v3KPJrew+PlKzhMtWgi
         aqDLMhB2baNxhMeHLh42sRrAgKIx/JT4b63MaRMKxHx1sDkWYeRuBRYoAGy65zAQEltY
         4klw==
X-Gm-Message-State: AOJu0YwZZafvsT2c+5aUl2IC4y121CqPCPmej1NMVZjk7d+/0RK559tT
	8gBoNN+Q8OeEDyby1UC/wjn8Z+5DQG9kKKHJ6MXYNMxOEudE1JxPakO/GbHP0Us=
X-Gm-Gg: ASbGnctBiQsqP72ua6fWNGoufV/NpCqexyL8rzR3sD5+oJGhgGTLt/sJDjZ2XccIosL
	yJ+CiSBfrbI/2VQ+q55dvKZ1NRkAXCcojQwDKshNk8jPT2MDS3OUfgiJFqokT35vOurXpTXpSjb
	smwhQ9a4O/mCnDp2CtheNjcDbhLOzrRMB3/ztLCyQN/JU8GNje8O9TtFJDJYbfYpwMEc+pWAKfd
	rYXbSkusQxH4sgZdaa7TvAhm/HsFdGnxRxmlOYNyifWU8gqm9kyHnHRXZGfm9iGhxb8D3HK5NMo
	IBgVJwUcX8UxNf2IKXsvH58E9eLtCxwUqSKr3/AwJnw=
X-Google-Smtp-Source: AGHT+IEo8D6vQqhSxLEUWxVEW/J/Nc7DGJ2ysFZPzso+QRmG7SwfLkb+Gb+XY7iccHsHXENq5+EgfQ==
X-Received: by 2002:a05:600c:1386:b0:434:f2f4:4c07 with SMTP id 5b1f17b1804b1-438913de07cmr43028395e9.15.1737145675882;
        Fri, 17 Jan 2025 12:27:55 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-437c753ca42sm102105685e9.35.2025.01.17.12.27.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2025 12:27:55 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 05/15] multipathd: move yielding for waiters to start of checkerloop
Date: Fri, 17 Jan 2025 21:27:28 +0100
Message-ID: <20250117202738.126196-6-mwilck@suse.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250117202738.126196-1-mwilck@suse.com>
References: <20250117202738.126196-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This simplifies the lock-taking logic and prepares the following
patch.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index ff3031e..25aab09 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -3007,6 +3007,16 @@ checkerloop (void *ap)
 			struct multipath *mpp;
 			int i;
 
+			if (checker_state != CHECKER_STARTING) {
+				struct timespec wait = { .tv_nsec = 10000, };
+				if (checker_state == CHECKER_WAITING_FOR_PATHS) {
+					/* wait 5ms */
+					wait.tv_nsec = 5 * 1000 * 1000;
+					checker_state = CHECKER_UPDATING_PATHS;
+				}
+				nanosleep(&wait, NULL);
+			}
+
 			pthread_cleanup_push(cleanup_lock, &vecs->lock);
 			lock(&vecs->lock);
 			pthread_testcancel();
@@ -3043,16 +3053,6 @@ checkerloop (void *ap)
 				}
 			}
 			lock_cleanup_pop(vecs->lock);
-			if (checker_state != CHECKER_FINISHED) {
-				/* Yield to waiters */
-				struct timespec wait = { .tv_nsec = 10000, };
-				if (checker_state == CHECKER_WAITING_FOR_PATHS) {
-					/* wait 5ms */
-					wait.tv_nsec = 5 * 1000 * 1000;
-					checker_state = CHECKER_UPDATING_PATHS;
-				}
-				nanosleep(&wait, NULL);
-			}
 		}
 
 		pthread_cleanup_push(cleanup_lock, &vecs->lock);
-- 
2.47.1

