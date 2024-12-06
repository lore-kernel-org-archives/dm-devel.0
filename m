Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0020F212FB2
	for <dm-devel@lists.linux.dev>; Fri,  6 Dec 2024 23:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528212; cv=none; b=QZPKtsmlZPSnePFpKSDxNEpNsB1YOPox7UfUM5UYPC4yyLXqUXL/R/a7ysnoAE67b9De6hHnd+WDxGfChIMuhxjyaxTV52Uhxa7lR+Zfzvyfb1hMJniTslX5xptCYP+jS7x9Ms7PaG5AJHabVo8S6FDHn5FrzIUXh9T8MaUMvEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528212; c=relaxed/simple;
	bh=XF/ICEjUmEe8APKJ/lc3d+Ft3EwAIYcQQmlAFuQUn/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RZCZohUMKAoKi0qE4mTM4WS+qv/lVy2mR71jD6i5nVuNUe9nXYymefhdDBrLehMhCvivTWw+P8h4mhWKcK/Jfn0PoLd6qAmONpJksnyyA3Cje5o+YSVkd/JlsNnyGWg8Y74niIMPVIPPsmfalUFnrmjQkA3AHvBCOO5fQzIEs2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=XY1vFMIt; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="XY1vFMIt"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-aa629402b53so304736966b.3
        for <dm-devel@lists.linux.dev>; Fri, 06 Dec 2024 15:36:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1733528208; x=1734133008; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=veSSevNJn/GBoZMTmrFIII7vi6M7CueSXDqP/PcBPa4=;
        b=XY1vFMItKFf1mY/bzHXcHTTqLjfTp1n4b+uoEGC3pmuUU22FzLrSLYgsoNUjeumV08
         EI6LJTA9t12gTvIxvZF3TqNfjYsmO7c6M//qXCFBlJfEpVmQJqtN7pN7k3ga0jZWIHIY
         jdXX4JFvDWwFg5Xux4rtmP6USmvbwPF247ugtM8C9yy4DBD7qi/Bj/6Hlvk4Z2mBtWRg
         gLtJcjvn2rAwuIN+ILTeuMNiUzp/CPftKSSNxp/7d/f1OBWdlUq52u4KCizA/eicVybk
         62v8rV9Dxa8deQ3w4DTw0vViu7lFM3So1FKiIZ5rdv8wK30YHDrbKNkuSeverXXyRdjK
         u3Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733528208; x=1734133008;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=veSSevNJn/GBoZMTmrFIII7vi6M7CueSXDqP/PcBPa4=;
        b=UADU4Vjeh7j7DU9bBQvSp4Gc9poOP4Vx8oYMvyl88HoiO0slqNG9LoLhr7fzwAaYuY
         QjrwMFIZ3jll352dIU4f0kjkzn6r8Y/NwVj+g12LnNOFH5LD4POmWdIqUC8EZ7jUQrh0
         GnXR+Vns5zt8Ftn8n5UT7vDeektGGi2uCLcnrUbAB/poD/CzELSAIHX45Unqt+1a1rG4
         sOsKHvfVYTEmot/8H5mRwx2PAQJDiWaNGY7Mc8XEeBWXfQYy6xgjRZsJIPDj359niVM/
         cBBDVMP0ZVltajrQH3cERb9FJXXQ2nPa9yKikqn92qLqkA7kifB0wCaeG3uNl26IQr35
         PEfQ==
X-Gm-Message-State: AOJu0YwfIoKm7lDojjaIVnVYU0tGPR/tn+l+py8yK64tBJ/KCApIeEZz
	E24yop+HpzeUaoAbfecKkfuOs8SemR1wowyHuoRAwk4my6jnylMG1iC7v9BNEbw=
X-Gm-Gg: ASbGncvjGcF7AyqVO15pwyg3RGfIM0O579R2fLdb/PsHIKaPf55p07vAos46Ix4y81G
	Sj8KkxvHECirgFXOIIp66tN1iTeAmFB4BW87Hnoj7sGJID3N5DzRiDTbU1iup5JhTowaylqV1Tf
	BU+iKVrGIY+QhgFDlUN6dKEaMtcfLLaxV90w2CL9oSF1RlCgpXLOoxlhOJ1HAgcgE7MgZAfE6kv
	6PT+WpNofAkss4eTdqDqYj8r5ZpWGJxMAoXYGvDbGaQkwMRjbRrEbhAi8rJcETvZrCVWh3dG+pW
	eGVqDlc+s/Wfl5ag5VsHKXlPBf2ZQkPxt5Un
X-Google-Smtp-Source: AGHT+IF4M82Y2Nj34lEBgb9mC/tBZibx3CxQK1/YoQfZuz3Uk7PhLtK5TjW5H49hM3b6WtcRN9z86g==
X-Received: by 2002:a17:906:3291:b0:aa6:25c8:e75a with SMTP id a640c23a62f3a-aa63a088c55mr296571766b.27.1733528208085;
        Fri, 06 Dec 2024 15:36:48 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-aa625e5c660sm304156466b.19.2024.12.06.15.36.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Dec 2024 15:36:47 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 05/13] multipathd: move yielding for waiters to start of checkerloop
Date: Sat,  7 Dec 2024 00:36:09 +0100
Message-ID: <20241206233617.382200-6-mwilck@suse.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241206233617.382200-1-mwilck@suse.com>
References: <20241206233617.382200-1-mwilck@suse.com>
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
---
 multipathd/main.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 18083c7..5f16094 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -3018,6 +3018,16 @@ checkerloop (void *ap)
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
@@ -3050,16 +3060,6 @@ checkerloop (void *ap)
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

