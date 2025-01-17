Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E7641AA1EE
	for <dm-devel@lists.linux.dev>; Fri, 17 Jan 2025 20:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737145687; cv=none; b=RIU7PufBIp94ztGtKQ8WgEp/m8C2am+M8LkaF9mOZAiNZWiECVr93Zx9GBUK2LjuTI+o4GjHlfSaLogd8VF7/hJJmuHlXff+q90QSXG7uBTSikWLm8nJdfcg6/GHa3/6AWUtzmbzK3Izvf2f/jUAqHCZwB/50Fu+c4dIIYZZn4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737145687; c=relaxed/simple;
	bh=PQq3YN8k98NGU9J71/BJVmtnmIZSPl7ppr8W6Xw84fo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pwIt7zZHzDie8EMcY5SmWFINnbxYHFokYcbP5d3XuMYAq0YxWfZPZ9x7cAOw4AcXw9hxyyBo67jxgX4QlA2AkfO6wIc5tPg+sLHzvICrs2lIHX0jfLngzpYArF74qMHO1x2diNxVQRlwMt6GcTBVe/mOU0oQUGg2M80f+we66GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gapB4EYo; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gapB4EYo"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4362bae4d7dso17507155e9.1
        for <dm-devel@lists.linux.dev>; Fri, 17 Jan 2025 12:28:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1737145684; x=1737750484; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mtZEbBUk8iooZM6o9hfD7+70jt04crglOHdK3Bq9exk=;
        b=gapB4EYo9PH9bwUcQzJtqBN7ctZ4rF92n23mXSwQB1pLXUFaVg1q6bCBQB6p2jgnoa
         PGEs0eJosY1g0kwnUPUAY12sF39TxAWlskg72uN44HQqXjbekoJLqz+8qoBCSTAsxZ94
         lf9Ce4JP++xdAwkJlCTDDgZxrxQARUu+Ny3JcIJkStVrpLvvxzmnvRWmgJXYAiDl75vY
         vpWQ3JzbsHzdhB/n2vktGD6A2RXn4C9ijOIzrwQPphimmtx5O1kFjXx+pUwGdIu7lIQP
         3Qh9f7guIp2ytvAX9uOBMZ8w20x93OjuZtDSz2EmXw7Svf+Nf8bdQGDx7Ra2rGOOTnGk
         htmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737145684; x=1737750484;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mtZEbBUk8iooZM6o9hfD7+70jt04crglOHdK3Bq9exk=;
        b=bMUFNR3rDS8XGn1CbvOnRyXdL7xyhT1h2Mwr0ndj+nvJbzBEQY9p0GXmpocIvVUso/
         SGWxXlr5j+MGQGBgWJhyTY8tNuTYvUHBxRv8iuOG6fb8uGqLww2n0xapzs4D7/GKBx5U
         /1/Vby0NAE8q4XefGkYUPMOml6BG1FmCkXgl8ZHqK5LdzIskInhBO/v90zAuEA06Jckh
         0PsTQ3heOGMKw1RLmUcGCr6NfNfXlWCLzXUhhaYv2TVsxDU/+KQKqgP8VUDxSDE9wwxo
         3UFs2JTKC/QOsKwpB6k8lim11WxEoB3BUYYH0xTnOfJkcA4L0G1txx3rC4+fIH+ZEJfE
         BAKA==
X-Gm-Message-State: AOJu0YxF90qfWlh1VsO0y6nx2F5E50Zstd6wLc8G4YJy6rB428EcEo5k
	eOT5HxwEPriZN9nmt0VXCB4YbaIrHLt7kUri11nsHM8Y7Sb9AG/T5aC3kTGbKC8=
X-Gm-Gg: ASbGnctvDTMqDA8vzixb5n2EzLVu/8Sgr7C2zUdKh/apYnC/+C/QsVX1qGW9QHNl0lb
	upqk3YHb4RWmvrSK5b2rJG/cgLK1TLhdenyQ7oC2COr1fNGssbO9OITEx4JSnZ5nYQ4YNvGiwG2
	/CxPwa9naPpNJg0r7J3mmHU0jK5xAa9oFRySMAizB46KTgqghi3v28Q5syHzRNXnPUliMjiDihy
	gfidX5fdjGh17X/ndbIi0gyfCoF81WVc6wee+Fz2eUEGEeBg5CcnKglDUaKaegfRUzhYOTyuqn5
	KuoRGVx/PPrExuEnDd3Z4g65U/+fJn0qEiIJmK1feVY=
X-Google-Smtp-Source: AGHT+IHH3k9lxl0icOVYqKsSAHoiOLIiBpPPGfsUc7E4PLXz+H5PdrYJPdA2+oOxXT5YxXes4wD+6A==
X-Received: by 2002:a05:600c:1907:b0:434:effb:9f8a with SMTP id 5b1f17b1804b1-438913ef2c5mr45212625e9.15.1737145683678;
        Fri, 17 Jan 2025 12:28:03 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-437c0f03984sm93151665e9.0.2025.01.17.12.28.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2025 12:28:02 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 10/15] multipathd: don't call update_map() from missing_uev_wait_tick()
Date: Fri, 17 Jan 2025 21:27:33 +0100
Message-ID: <20250117202738.126196-11-mwilck@suse.com>
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

Instead, check for missing uevents in the existing mpvec loop.
Note that if the uevent tick expires, we need to call update_map() rather than
reload_and_sync_map(), because the paths have not been added to the multipath
(see wait_for_udev handling ev_add_path()).

The set of actions taken by update_map() is a superset of those in
reload_and_sync_map(), thus we don't need to call the latter if we've already
called the former.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 44 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 753f48c..2989cb1 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2029,29 +2029,19 @@ followover_should_failback(struct multipath *mpp)
 	return 0;
 }
 
-static void
-missing_uev_wait_tick(struct vectors *vecs)
+/* Returns true if update_map() needs to be called */
+static bool
+missing_uev_wait_tick(struct multipath *mpp, bool *timed_out)
 {
-	struct multipath * mpp;
-	int i;
-	int timed_out = 0;
+	if (mpp->wait_for_udev && --mpp->uev_wait_tick <= 0) {
+		int wait = mpp->wait_for_udev;
 
-	vector_foreach_slot (vecs->mpvec, mpp, i) {
-		if (mpp->wait_for_udev && --mpp->uev_wait_tick <= 0) {
-			timed_out = 1;
-			condlog(0, "%s: timeout waiting on creation uevent. enabling reloads", mpp->alias);
-			if (mpp->wait_for_udev > 1 &&
-			    update_map(mpp, vecs, 0)) {
-				/* update_map removed map */
-				i--;
-				continue;
-			}
-			mpp->wait_for_udev = 0;
-		}
+		mpp->wait_for_udev = 0;
+		*timed_out = true;
+		condlog(0, "%s: timeout waiting on creation uevent. enabling reloads", mpp->alias);
+		return wait > 1;
 	}
-
-	if (timed_out && !need_to_delay_reconfig(vecs))
-		unblock_reconfigure();
+	return false;
 }
 
 static void
@@ -2956,16 +2946,25 @@ update_paths(struct vectors *vecs, int *num_paths_p, time_t start_secs)
 static void checker_finished(struct vectors *vecs, unsigned int ticks)
 {
 	struct multipath *mpp;
+	bool uev_timed_out = false;
 	int i;
 
 	vector_foreach_slot(vecs->mpvec, mpp, i) {
 		bool inconsistent, prio_reload, failback_reload;
+		bool uev_wait_reload;
 
 		sync_mpp(vecs, mpp, ticks);
 		inconsistent = mpp->need_reload;
 		prio_reload = update_mpp_prio(mpp);
 		failback_reload = deferred_failback_tick(mpp);
-		if (prio_reload || failback_reload || inconsistent)
+		uev_wait_reload = missing_uev_wait_tick(mpp, &uev_timed_out);
+		if (uev_wait_reload) {
+			if (update_map(mpp, vecs, 0)) {
+				/* multipath device deleted */
+				i--;
+				continue;
+			}
+		} else if (prio_reload || failback_reload || inconsistent)
 			if (reload_and_sync_map(mpp, vecs) == 2) {
 				/* multipath device deleted */
 				i--;
@@ -2977,7 +2976,8 @@ static void checker_finished(struct vectors *vecs, unsigned int ticks)
 				mpp->alias);
 		retry_count_tick(mpp);
 	}
-	missing_uev_wait_tick(vecs);
+	if (uev_timed_out && !need_to_delay_reconfig(vecs))
+		unblock_reconfigure();
 	ghost_delay_tick(vecs);
 	partial_retrigger_tick(vecs->pathvec);
 }
-- 
2.47.1

