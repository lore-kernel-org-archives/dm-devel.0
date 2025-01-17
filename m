Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBBB61AA1EC
	for <dm-devel@lists.linux.dev>; Fri, 17 Jan 2025 20:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737145690; cv=none; b=sCFbzZ4Xv5pnjKSv60e5S/cUDnO1dGVO2Xf04wz9K3f9ig6URtItzT1cPTRWh8ag+SJ1q/IxWWk5eLmh1evjI4DH0zPdaiFEiv26TQrpuo7gGDwjrdR5sJiIYc4+GGFclGzDkFsnnGYAAkSCFS9AxcAkw9Mzyr34hhYTxNo7KnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737145690; c=relaxed/simple;
	bh=TXvHX6rD9UEu17Nh5kcx6HlH+kWUAnrqiphXjY6ZfO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g24RSLyYAn5QOf9iIdbrP/m2yC4yFBVZo0q/tJyW+EpzTkivi9oDPNrkGYJqjpuK3G7KeGivZD8cqz13YFXBJHYmGxZY6TI8BnFESdOouMnkyJ6wiS9IkY7d3ZaMR/yExu62CNLG12mle+mdv7iSkmDIB0xk3vTghrYirPMXiak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=QwWBRAxE; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="QwWBRAxE"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-43634b570c1so17586425e9.0
        for <dm-devel@lists.linux.dev>; Fri, 17 Jan 2025 12:28:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1737145685; x=1737750485; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3FAQR0CloH+Vym2Qp7L6fu+O3qTMs67J2krPs3YCWAs=;
        b=QwWBRAxEnaIBunSdyobIspWpzgz3Jyy7Xfg3Z9oIveQg37ZsEMYQOahEVJgu2oJWNT
         fM6j62gRyBtZ5Bd9GER5TQYUYnElrBboXh/sxVdO8cAP01Veh9guYeugfk3f23evnbrS
         C2P1qOKtUgYHZ9ZekW8l779+RC+nSdc9QJR//zrpvO/rlFQOwTEug2zJuJO2YlyUnPO0
         usIUOPB8GkFReW4hj11eDb7nVIxD/sC1gLGalNBPhNROjQsT2+zbBk9/Du0iezJa9Hfj
         Rb/YXFfpQVLJFnzVOT3dQuCsAgmIMGWWJmRkGbE5Ucl/yBxBRrR6PoJq9mpwTg9m3V39
         s6Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737145685; x=1737750485;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3FAQR0CloH+Vym2Qp7L6fu+O3qTMs67J2krPs3YCWAs=;
        b=fM+yASzCu2BEEHOZY+gmLJABXb6L4iwnNiV6TojlWS3QgtZjbpSQxHhZ2Dqu430r0H
         W2s/4JuBh+TmAJFaWktABzySiVXNBG8oHlvcd4QOgoKWchZSelT5pYBKY1qgLMSuRIYJ
         KhoxERu2/oPeztt2gd9OLIp04MZqHKVgXehMucgYDtwIzmv0yRE6swtC4dOuI6MVrvUb
         tbj2rtAKoufdUbudxfYOdFSvCEYHzfVk9GmCsblk+8XBmNly63MoyGH0nobm/3AYwmKd
         jR9DMdPjKkAiy2dlBUppw8wkopRTumgkJqWAoZ/CdMQRvBMFSJdXgVgFkHhrZv+4Ayrr
         XIrA==
X-Gm-Message-State: AOJu0YwkbfMN5wCUTdxI2syZfThUS3geM+Q+bfco+dJb7ZyZEbIVw/iA
	2J3BuIrHQcPDWY/RvQEceUqZR1z+ff+Ok0ce+2Rr6vDGD0qf1kiP0XZspJ4gxqM=
X-Gm-Gg: ASbGncv3MEfgv5N+zBUSxow/FstbCf434xiBeCBLMamn7hw1G+RpqagzcL2sEFEVaDb
	9FBUy1Ja/ds7J6wP+/C94fBzErqt5AnuXhok9nP6P2cufyeHZ0pEzzpJDyVEhMAzx4E5UxdyZE5
	rtQkHoL8wzbjKpYwDLiMRCwshdbqMilt8TN6yOilyKhe2vxZf84pSjqiht1dzXjNiucSegLC7lq
	TsR4M0QjksBw+EWKRgwbv1M8WEJJnzeD7tTaab+lqBpjcVM2I0veRDaRmCipu+bKGKvcnvEILZk
	MujX8bObc+dKmS7LOUNxpDnH+TWbUAhSt5PwGV+uc98=
X-Google-Smtp-Source: AGHT+IHfvaYwFEnMZCD6Ui/qQgMnztKuN0IcItYNPkJrlZRMyXNrZRiAyf0DZHfzQ/lZfmy0nBTrZQ==
X-Received: by 2002:a05:600c:3d06:b0:42f:7e87:3438 with SMTP id 5b1f17b1804b1-438912d91admr48038195e9.0.1737145684943;
        Fri, 17 Jan 2025 12:28:04 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-437c752910esm106960055e9.28.2025.01.17.12.28.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2025 12:28:04 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 11/15] multipathd: don't call udpate_map() from ghost_delay_tick()
Date: Fri, 17 Jan 2025 21:27:34 +0100
Message-ID: <20250117202738.126196-12-mwilck@suse.com>
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

Instead, move the call into the existing mpvec loop and call update_map()
from checker_finished().

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 33 ++++++++++++---------------------
 1 file changed, 12 insertions(+), 21 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 2989cb1..176d9bf 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2044,26 +2044,17 @@ missing_uev_wait_tick(struct multipath *mpp, bool *timed_out)
 	return false;
 }
 
-static void
-ghost_delay_tick(struct vectors *vecs)
+static bool
+ghost_delay_tick(struct  multipath * mpp)
 {
-	struct multipath * mpp;
-	int i;
-
-	vector_foreach_slot (vecs->mpvec, mpp, i) {
-		if (mpp->ghost_delay_tick <= 0)
-			continue;
-		if (--mpp->ghost_delay_tick <= 0) {
-			condlog(0, "%s: timed out waiting for active path",
-				mpp->alias);
-			mpp->force_udev_reload = 1;
-			if (update_map(mpp, vecs, 0) != 0) {
-				/* update_map removed map */
-				i--;
-				continue;
-			}
-		}
+	if (mpp->ghost_delay_tick <= 0)
+		return false;
+	if (--mpp->ghost_delay_tick <= 0) {
+		condlog(0, "%s: timed out waiting for active path", mpp->alias);
+		mpp->force_udev_reload = 1;
+		return true;
 	}
+	return false;
 }
 
 static bool deferred_failback_tick(struct multipath *mpp)
@@ -2951,14 +2942,15 @@ static void checker_finished(struct vectors *vecs, unsigned int ticks)
 
 	vector_foreach_slot(vecs->mpvec, mpp, i) {
 		bool inconsistent, prio_reload, failback_reload;
-		bool uev_wait_reload;
+		bool uev_wait_reload, ghost_reload;
 
 		sync_mpp(vecs, mpp, ticks);
 		inconsistent = mpp->need_reload;
 		prio_reload = update_mpp_prio(mpp);
 		failback_reload = deferred_failback_tick(mpp);
 		uev_wait_reload = missing_uev_wait_tick(mpp, &uev_timed_out);
-		if (uev_wait_reload) {
+		ghost_reload = ghost_delay_tick(mpp);
+		if (uev_wait_reload || ghost_reload) {
 			if (update_map(mpp, vecs, 0)) {
 				/* multipath device deleted */
 				i--;
@@ -2978,7 +2970,6 @@ static void checker_finished(struct vectors *vecs, unsigned int ticks)
 	}
 	if (uev_timed_out && !need_to_delay_reconfig(vecs))
 		unblock_reconfigure();
-	ghost_delay_tick(vecs);
 	partial_retrigger_tick(vecs->pathvec);
 }
 
-- 
2.47.1

