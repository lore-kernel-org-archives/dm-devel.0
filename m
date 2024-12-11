Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 962831F239A
	for <dm-devel@lists.linux.dev>; Wed, 11 Dec 2024 22:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733957986; cv=none; b=eOxWePKnmeQDYF+pzCKh4m0Ywex5VwACRlVY3lObpagvLBSmdbVyEJ8ZE/yYDr3X3IOzkrWeM6hVCYj75T+dlCxaBTNOiEEx9tuYJEhWctdD4zK3lK9qHc+2I+4IavYLB4UjeNEPsg3YRRZ6W8xSiyoowivLNjCda9yE/b5ncL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733957986; c=relaxed/simple;
	bh=2L/8xfKDSEJ++zS63Ca+tPcEufykt3HTgiQLX1DCRjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GhjxGA4W74Qjy7RqH9O8+svR/dbtakzrub/vTAHccXM0mOrsmcAy8WuaD20msJFvMDHv6FdfMLHjl9Gxnphyy5Zi+nYEv6Klqu0mEFo/pvAouzlUEdn6l6mf8l9o2lq8OwUYES0LDoGxoWsERxyryWHQmPfjgqpr4vIuDp/tXSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gDiPtTgs; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gDiPtTgs"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5d0ac27b412so9628129a12.1
        for <dm-devel@lists.linux.dev>; Wed, 11 Dec 2024 14:59:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1733957983; x=1734562783; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vjr7YmZscWelZAChWz44ooWTn/oPYEfuoQ8CPQdWeHU=;
        b=gDiPtTgsxxp/M36SgQPp0GtW3nMDjUuE8V8+gWLIfQDEWXpqUmJ7rRyek0IqcsYMPp
         eI6cA0fmlaE5SJ5yQ76KvqGQMcqlEyfucmElyPe0iandMNigcmGXcC0FH2WDsuciCOtI
         w//mK10oJ79CNWQUpy5oPycUhz9HbCC6eOPm27G98AA9o1TeyKcivALWtggfkJTeFHWm
         tE6KSyg4kfE5cO16s+eQZ0l1Xb78iMNlZSlanxze26HFowOksAbHme9N1sWRcvicZ0SF
         oVTnTiNxTzi+T3sW2cFDhEXo9IEDb6Cy5HNODeV7dqeYHFA/sNZnV8XiKNsncp+Qhi3S
         MMcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733957983; x=1734562783;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vjr7YmZscWelZAChWz44ooWTn/oPYEfuoQ8CPQdWeHU=;
        b=KJBGDd/qUH+IA42CBn+Po5yWPVDeUR/ZdBn+6WbwS28y2ZGxppiuG6y/rNx+FR8O4y
         EafX+0pEbfPjdvsjfKv557DXMjxwbykyo4XC+a+9J0BXipKj2xUaDpI8LIhump4bT0tz
         +JF4MA8wMBfnUmOmoNMoZkGBN/TBt3BBgE2MrqXD5dPgBH9Xxv0+d8ofooj0pQxd25y8
         4svZC+tzryWZ1vhq/UJzeM4XHQ3JWp5Sfzz6sVxankuRyuoiDd9xOjuiFiRjTORSRX3y
         J989M7YnWeM6bBtkmR9A6bJ/tRyGLxqhs1aDk254VLWGIDPtFYXqyZp7ufOXnrEWwc6W
         3IYA==
X-Gm-Message-State: AOJu0YyVSyClIIFrApzNVBYV9O7EG0LYXY8EOZ+BbU5ZA4SoZYijHVjh
	xT2fRTk00RjDdbspzZdqbBnc5MivFHvEmqLOta18I0RRvJrlkiahmcfiqeWE2qk=
X-Gm-Gg: ASbGncsnsQsN/WBA3R4/LAEAeAYSVsApr024SoClvq1OPRE46CdVkZs7Ipt+xutMZBp
	HAlAHOSxq4TpL6U5igtYWv96ZXwgBAIbSPE9jY9N6Ti89WShMxoieZn4HzOmy3E4dJpWL8zQdTj
	6SstUi7e9adO0tNd507rur0NBztb+r+XaWqItQuHdhO341eiwAtgHik9DrCWDlACOidUKIbwrya
	13bBPSN5Iqwuv1f67sZCzbP7kcGm2iByRO4O416y69WylcC03zLozu/I8YJGnjmtGcTOS7YHauu
	4qmECQcDss5zs08ut5z+d/iBbLDpp/dcmbHhtC9w
X-Google-Smtp-Source: AGHT+IHN2uzYSzXWPPGcsbeSYLQfDD4lOnVu5Re6uFftdpTt8MDTyDwAv6o79AbOAOWZwGr0Gr4vag==
X-Received: by 2002:a05:6402:4005:b0:5d0:e410:468b with SMTP id 4fb4d7f45d1cf-5d4330821b3mr4565279a12.2.1733957982688;
        Wed, 11 Dec 2024 14:59:42 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-5d14c7aa842sm9587348a12.83.2024.12.11.14.59.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2024 14:59:42 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 05/14] multipathd: move yielding for waiters to start of checkerloop
Date: Wed, 11 Dec 2024 23:59:00 +0100
Message-ID: <20241211225909.298770-6-mwilck@suse.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241211225909.298770-1-mwilck@suse.com>
References: <20241211225909.298770-1-mwilck@suse.com>
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
index 178618c..be542f6 100644
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
@@ -3045,16 +3055,6 @@ checkerloop (void *ap)
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
2.47.0

