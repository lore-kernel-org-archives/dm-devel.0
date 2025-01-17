Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5352F1AA1EC
	for <dm-devel@lists.linux.dev>; Fri, 17 Jan 2025 20:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737145681; cv=none; b=faOBxmoZwfSBGFf8Az6IjU3O7kyuZvWa0Qj5npB63jaCoX4F7sA5YKnOSXoJ0tRJLxg21ooNV2ntQvsYmu0pmDexxDbMZKYSqTitKIxM4AXcnME2XNkXFQP4VEvZ7ovnpI3CT/zI9USq+iBAleop9i9LMc2j0c2xn9H3NTXbK2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737145681; c=relaxed/simple;
	bh=PxNkpUcqDnUp0eMQkZDvPNQTPWo8bXoH73pgz+aMsfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k9GyHVe4uRB3HE6A2d0xapfy0CkIyWjsLOWRFbE/mk7Gcy8j1MN7a9v7XjlWDqLn+7Zx68M/z0lFMh/tdmlWoWNQaeA/Hayrho9PuDpJBBPq2kgRMk4eCQHEzWjBgMCLVwtY84XPfFa0lTIOg55VjGoAyCRGRTh2KJwVu37pa7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=KCn0CLmG; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="KCn0CLmG"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-388cae9eb9fso1397096f8f.3
        for <dm-devel@lists.linux.dev>; Fri, 17 Jan 2025 12:27:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1737145677; x=1737750477; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=19BQLtmNh4CRhfryyvO3w4ODKlMauyNxWNqaWMZphHs=;
        b=KCn0CLmGrFauB6Q/QkNeO+hHHPpCOl+ds0HtApGEASGhdPMvN+7sSv5+pzrynR4vn6
         KCYiDUjV7GsBzkm9RF9sa+cvLFy+Hwg7d+IBVfEYEKW/dpSi92o5CeK19JM+n2aSMmXT
         /gEYPPVlB9ek34FO+pYf2YDv6E/hccFn9yxupLgxCaKgSpHtPgAkDtxrvsV5EG93lN7O
         i6A+3UUwCfjsYKpwgJClLC4B4rqsulvJDa1PCPGt/946Yg/v1Q654KiKukRIFYGrJV0e
         vFjgzvLu1VWl+8CQ1SlV+CFVQ3EkExpviJTssFUFImifirx6nAYJMUbb6pIFKKX0ZLlz
         SrWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737145677; x=1737750477;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=19BQLtmNh4CRhfryyvO3w4ODKlMauyNxWNqaWMZphHs=;
        b=i20vLBnHErQFm6uQ1xdzjRf+M+wLvKjEjauqRlSDMOyTbPrJChXXh/mHe50m67+IQC
         sdc0cDQ8IR9xAnx4HaW/Jg1KoyxcDbjFZMnHCWrJ9ssAt3xIaITuAakju8Bj0kVvD72O
         Wf58C/Cjn0xqHprlCVvgnK6vZ/ywV/7Juw1Zw9n8BAPAY3KaqPKZUfO5m1ZMwIzLGXSf
         B9p30AbgtA/KCQo+JMiXCjD/03VJtcpwa/xUmcRotw8zn1Dpl6SjAZ2Dm0Iovu3tmHji
         gPqNmhA7DMwri+IKXvQHQMPOOqUh1nCBvW5vvK9M30Vtq14iaV2rLBnQIT6AAj/OtsfT
         C53Q==
X-Gm-Message-State: AOJu0YyWVpgVmXad4lK9iLeuzPprRUEy21sZDE3Y0+5YY8SMTUZm5SqJ
	V1BzHJiy9dznxZyGAonNfhupEQ9MbrXfJ7/WQonxdPaUF49XT6acNiPYunSVEZYT4UfYhwHlV7e
	O
X-Gm-Gg: ASbGncvlI29Uwks9W8fPYnrEy+eAM5E1IEAbvcyAn0T0oljTKjOOYWmlvynl1+qDuz7
	wZP1RvclUCge5tJuRaow6Gk2U5imqwDS0V7BnlR7kvyO13t/MEV9ioPL4+/0uuim0r0pvY4zSIh
	//htz7hAgfaoqajRtCp/a/3olBcI/+FoTjKsChv/t6qKggspca9FhimlcAkuVDK55PfyYhkS43I
	7cssQzoMNLC74HgJi01EB1XgJU7yiTX2AGkbm2YSNpGSu8+p7xXpH6pbFBmtwZoUrLMpP7i8pYU
	ibzuUBqugGAyAQrlEIC7NAWeJd6R8kj+0biHUlw1XS4=
X-Google-Smtp-Source: AGHT+IHuNw6XiUsTHlC1hTK9hwzxbKYJtEpbmxvLPtaFjyq0REZGqBhMVfFt5nhifJRLO4H7ml0hYw==
X-Received: by 2002:a05:6000:1565:b0:386:41bd:53a3 with SMTP id ffacd0b85a97d-38bf57c0716mr4016424f8f.50.1737145677507;
        Fri, 17 Jan 2025 12:27:57 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-438904131f5sm43270665e9.11.2025.01.17.12.27.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2025 12:27:56 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 06/15] multipathd: add checker_finished()
Date: Fri, 17 Jan 2025 21:27:29 +0100
Message-ID: <20250117202738.126196-7-mwilck@suse.com>
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

Move the code that handles the checker_state == CHECKER_FINISHED state
into a separate function for better readability. Subsequent patches will
add code to this function.

Replace the "&& reload_and_sync_map()" conditional by a subordinate if
statement, as this expresses the logic of the code better.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 43 +++++++++++++++++++++++++------------------
 1 file changed, 25 insertions(+), 18 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 25aab09..988c82c 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2967,6 +2967,29 @@ update_paths(struct vectors *vecs, int *num_paths_p, time_t start_secs)
 	return CHECKER_FINISHED;
 }
 
+static void checker_finished(struct vectors *vecs, unsigned int ticks)
+{
+	struct multipath *mpp;
+	int i;
+
+	vector_foreach_slot(vecs->mpvec, mpp, i) {
+		bool inconsistent;
+
+		sync_mpp(vecs, mpp, ticks);
+		inconsistent = mpp->need_reload;
+		if (update_mpp_prio(mpp) || inconsistent)
+			if (reload_and_sync_map(mpp, vecs) == 2) {
+				/* multipath device deleted */
+				i--;
+				continue;
+			}
+		/* need_reload was cleared in dm_addmap and then set again */
+		if (inconsistent && mpp->need_reload)
+			condlog(1, "BUG: %s; map remained in inconsistent state after reload",
+				mpp->alias);
+	}
+}
+
 static void *
 checkerloop (void *ap)
 {
@@ -3034,24 +3057,8 @@ checkerloop (void *ap)
 			if (checker_state == CHECKER_UPDATING_PATHS)
 				checker_state = update_paths(vecs, &num_paths,
 							     start_time.tv_sec);
-			if (checker_state == CHECKER_FINISHED) {
-				vector_foreach_slot(vecs->mpvec, mpp, i) {
-					bool inconsistent;
-
-					sync_mpp(vecs, mpp, ticks);
-					inconsistent = mpp->need_reload;
-					if ((update_mpp_prio(mpp) || inconsistent) &&
-					    reload_and_sync_map(mpp, vecs) == 2) {
-						/* multipath device deleted */
-						i--;
-						continue;
-					}
-					/* need_reload was cleared in dm_addmap and then set again */
-					if (inconsistent && mpp->need_reload)
-						condlog(1, "BUG: %s; map remained in inconsistent state after reload",
-							mpp->alias);
-				}
-			}
+			if (checker_state == CHECKER_FINISHED)
+				checker_finished(vecs, ticks);
 			lock_cleanup_pop(vecs->lock);
 		}
 
-- 
2.47.1

