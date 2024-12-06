Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7093F212F88
	for <dm-devel@lists.linux.dev>; Fri,  6 Dec 2024 23:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528213; cv=none; b=Kiz0EL8dKIKu/Wx2TbhjLWJRWs1rkEzyPznkwFaG37wR1ZS77nnls0MkZwSDabSwGM1FZuQZzAp9CuinffYsT8gc0TKfMS5R/2mGhoCk5XvsJfvSINE/CfeRh+ju/k6F9dMzAANUBC9PwacKaK0S3xzpRki4WVo1m+UeHIh4Tww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528213; c=relaxed/simple;
	bh=VIfG8jmuXuviZSVXGB//CY62k39Elp1RheGthqyOM9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M0y4MNRZXuf2dqjLL8AlbfAYzoAxuU1Em0tn6Nk76MZriT0bloHBXdFbTGJjGVmX/VxT3WHe2KMPbhj2Kuv44zMX2hfWTrP/pYEp/M7U/X+wdP7x1yrZp2KzR8ctYXhJvn4avNloXSrz+IGqM+bBoJJ+UtR8orljlV9pEKRDdSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=GxXNNw7J; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="GxXNNw7J"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-aa628d7046eso376356566b.3
        for <dm-devel@lists.linux.dev>; Fri, 06 Dec 2024 15:36:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1733528210; x=1734133010; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oUlNbMqwz+xDVwPO4V5lwInDa87ZyAkls4oZqTyVXlM=;
        b=GxXNNw7JRRQGnQRQyw3V6m2wEAgrNQnZtF49KCTgVYuOJc2TgR58zGaeOBkF97XXJ4
         Ip3HPjp3a4G1HvWuQ035bosgeJagMUFBugkreZYdHnbdUiD8+ZUWcLz24Ka0MWTMHg8G
         DzcOAFVjLj2ywUN9yUHOvGCcufMNv706We5SoCiaC4yZnO2f37QoGstKF77sGitPbHSD
         xVSwiNvMh/bVoxyBLqhN6khHZX5xa7ZLgslCuPMjLN8N7vcGikapS6T9Kg999wtFIaPZ
         S8keRMBNaF5wx4kpfzTB2dJPcsqQNnSNXLNgQ+Oja2CewHTE8t65liTqKW24ZWtwxd5Z
         m+QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733528210; x=1734133010;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oUlNbMqwz+xDVwPO4V5lwInDa87ZyAkls4oZqTyVXlM=;
        b=TQLipvHwHBV1+5BQ3DlyaEVErZ1eCArU7rCgC9MpHQXkjHEBE90yU1jLJ8rWNhOKvC
         Nam/bY69VWbjCWjUPglqD/LAJSAWjGeeOSn1sZkjwU20MSpdNZ+bC8Bo+DjqFVo8Dml+
         XAkrkOXC3nKCDcnUuIkpAf0A3mcd0QdL35Xf0nckcWNIvYTguv9LI6AUTPeKT4FB42In
         UiFCfCytkGUx420P2U4Wcfw0TJg1jvPHcSA7hTUXAdheaSoNWlI3AJ9kObXg6/W6oCjh
         OpC2Ti5wAQIn1/4xBzMLN6I/rrq5joJUpLf7eGHKv9cPWk0dl+dkAc1dMp/f87yMUJZN
         qg4g==
X-Gm-Message-State: AOJu0YxpDg1CnX0G5IiouHWx96qyDqUHVwysFGq0hNrf0SkqBaKCP6UH
	d9gBu/ltmVPrYfDIkJoHSBSQt7juaQhrozc9bghVqi72pHgZ139O3Z92qjd6gYc=
X-Gm-Gg: ASbGnct8B5C+sivmrsPI7SpZP3am1NPMKT2NcWMzNFRL2JRurASXzLkK8hL9hFp6hBh
	Pg+QLFIHx/AE2vOv9jt67Kc3dQ1aMt6FuhBwzSUnTum8+YXvanUtYs2bN4iPfCmOpz9rLfcKruU
	DadxzOSv93sVYuJ+rLf9Y3Gc+zzDM84Bvj3cw5RPN8ikc0UV98IcWLlfl+DjndZS4Ul4MJ4tU5h
	XcNDSJszKt8TCM2FAb5nAEbo2Zw+//Webd47aFXhrZBEuEGRSnBm8Q3QR11bVn77dK32wJ+zDHi
	JbFM26QsT0I3T7ipSqfsFU94pSA6n1jR+EbFikig
X-Google-Smtp-Source: AGHT+IHvwaNATeeTM5HRzvoOdkVTS40mzQ254fehiEvCOn4TqMoWSJ7iTe9ZbwepErSHpBFgEkFd2w==
X-Received: by 2002:a17:907:3455:b0:aa6:3b8e:e079 with SMTP id a640c23a62f3a-aa63b8fbf44mr348375266b.37.1733528209532;
        Fri, 06 Dec 2024 15:36:49 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-aa62608d2f0sm302651966b.145.2024.12.06.15.36.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Dec 2024 15:36:49 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 06/13] multipathd: add checker_finished()
Date: Sat,  7 Dec 2024 00:36:10 +0100
Message-ID: <20241206233617.382200-7-mwilck@suse.com>
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

Move the code that handles the checker_state == CHECKER_FINISHED state
into a separate function for better readability. Subsequent patches will
add code to this function.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 5f16094..354fadf 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2978,6 +2978,20 @@ update_paths(struct vectors *vecs, int *num_paths_p, time_t start_secs)
 	return CHECKER_FINISHED;
 }
 
+static void checker_finished(struct vectors *vecs)
+{
+	struct multipath *mpp;
+	int i;
+
+	vector_foreach_slot(vecs->mpvec, mpp, i) {
+		if ((update_mpp_prio(mpp) ||
+		     (mpp->need_reload && mpp->synced_count > 0)) &&
+		    reload_and_sync_map(mpp, vecs) == 2)
+			/* multipath device deleted */
+			i--;
+	}
+}
+
 static void *
 checkerloop (void *ap)
 {
@@ -3050,15 +3064,8 @@ checkerloop (void *ap)
 			if (checker_state == CHECKER_UPDATING_PATHS)
 				checker_state = update_paths(vecs, &num_paths,
 							     start_time.tv_sec);
-			if (checker_state == CHECKER_FINISHED) {
-				vector_foreach_slot(vecs->mpvec, mpp, i) {
-					if ((update_mpp_prio(mpp) ||
-					     (mpp->need_reload && mpp->synced_count > 0)) &&
-					    reload_and_sync_map(mpp, vecs) == 2)
-						/* multipath device deleted */
-						i--;
-				}
-			}
+			if (checker_state == CHECKER_FINISHED)
+				checker_finished(vecs);
 			lock_cleanup_pop(vecs->lock);
 		}
 
-- 
2.47.0

