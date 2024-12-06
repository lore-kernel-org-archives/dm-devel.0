Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC92D213E7D
	for <dm-devel@lists.linux.dev>; Fri,  6 Dec 2024 23:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528219; cv=none; b=gs7QJLBBCaCyIkI09e83ZlGIFklY78Ea0XwmEe7kNZbXvf0Ex3sYIvKMtJUkZ5ae6hrFbu+p/1MzmJ8c6AUqQRbr+7yQ5ZWMjxWEO9ANbHBaP5C5oG+m6YN5VoV4hL/MunIaSi/Qt+cWkbHLJlEI6jKBpzqsivWQPACFwE6VSf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528219; c=relaxed/simple;
	bh=GfC1nm9+X/faPxfcqZ/PB/BecgIqy52UXFPltpeQmBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Igusd4ggEh6QCGXoTrnNz8cE356xkzeKhkcvoyWDNmM9nbaPG543jWUTO2zSrZgu4GARX1uGZwKwrqyKq7S9s9JZqQ5FPTaosTfa85P/oFRGau0co5UGU/Tgxug9be/A/xNeI9v31RWBGSM7lvRbuN3dcKK9PpryGOn5hgCD8ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=cACdxTFf; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="cACdxTFf"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5cf6f804233so3108715a12.2
        for <dm-devel@lists.linux.dev>; Fri, 06 Dec 2024 15:36:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1733528216; x=1734133016; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QJnxfetFbqLwprc1wQl+h8lTOcL+KxH/Cdw1Ln3cl9M=;
        b=cACdxTFfEIpO1HyxjH6uObTZJCPclD0meIa7ITq+SgDkuLTEo8vM2tKnABuwZzqj99
         JteoqISrRkjY3U3nJrx5oettUq96cfkBpCm8vi+A6W8sh70NnOVNwNO7XBSo9jm/6aSy
         QETAr5dYV8lOjrpWQvanNjGcT/AzGDHL7zItRb+1cS6DwljL2FyGTFVNsKjiEIAwH/BO
         Z3dCeLEjYx5ZBVFRTjnd23rxU0nTov3buoUilftmYFs9TEPhorib3OBCtB7sQYKn+RfJ
         Yt3SmT+q/WUdMAKRfpzuO1vuYNsnDeUAGwN8yj/duAqPNpyR9fENeEzAA1IPhbqQiAYD
         vCLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733528216; x=1734133016;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QJnxfetFbqLwprc1wQl+h8lTOcL+KxH/Cdw1Ln3cl9M=;
        b=FqF2zjZHdlFyNH/NlYxGF6vYoVvb/RN/qenOjj8cVnzLNJfCEfzA3H46MO3TcXt7wZ
         9mypJk2AKviDe8fLjdD0wuIEwqBeFmhaxzacGGpjqX8MmkW7z2JaRdgkjEC/Ut8SZpZ/
         MfD80Ye5IW8mHlgLjnP0fYtN/3oCk6oTmtGJygRtNzCj2UIAz3IbV7PhNhaNli7pGs3U
         qYpJChWS8OMDwOJbTnnK3uhcY/GTrZ/2y9ZfRuYUaLhwrjCy+kWIMf68L7Tuq9015N6M
         6m3P+wrOku3bJ34iLpl0iHyoD36jtNcnOunA953WmBZPYL5p5nVZTS3YHLkUZn/f0ekN
         Hmag==
X-Gm-Message-State: AOJu0Yz6+3o7m4Ej0DzuhksBNSk6PqstQmXSnT2x4kyDc58Spt11M5L7
	1XB6A8K7Lej9v2qsMtrSl4eYKTc0ygCzw2wCi22dSfhb/YfIocRfEkKTjQ+gxII=
X-Gm-Gg: ASbGncuqOLb1raKy8tpDnULsC+UlJcCStvQU6ELZAhCWA5heO0dx+HV67LTFo98ziZd
	F+4zZmGWqob1J4lHRNEJf2TW/3uSfP/5CHvWRRMR+NhK+472f2KTaFiC1Y9w5symNgpVJHXTdqF
	lJC36HRc3fzZYJBJNQx6dTTiqUmEGRgYv3MNl72qAb+yTh8GVgCoOWOBcO0kqssCcpt5wYqfnpO
	98iSEhfBh7h/4eYCF9hADSBOGmV3zVO2J9XGu8i4RKgpnkj7JnBvujWvJgz+KCH9LMqcUK20BbB
	4fw90WLCUExU6hyoqzvndyHsyzaDwQSzyjc9
X-Google-Smtp-Source: AGHT+IE3q4iPeOxtWqzRHx9ZF8jWFgMPR7ZFBK0DDS0xLNWwEcJdAKTFUkKNcq86oFShA4b60No35A==
X-Received: by 2002:a05:6402:2749:b0:5d2:7270:6135 with SMTP id 4fb4d7f45d1cf-5d3be75625emr5076828a12.33.1733528216065;
        Fri, 06 Dec 2024 15:36:56 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-5d3da2c242esm314268a12.33.2024.12.06.15.36.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Dec 2024 15:36:55 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 11/13] multipathd: don't call update_map() from missing_uev_wait_tick()
Date: Sat,  7 Dec 2024 00:36:15 +0100
Message-ID: <20241206233617.382200-12-mwilck@suse.com>
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

Instead, check for missing uevents in the existing mpvec loop.
Note that if the uevent tick expires, we need to call update_map() rather than
reload_and_sync_map(), because the paths have not been added to the multipath
(see wait_for_udev handling ev_add_path()).

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 40 +++++++++++++++++++---------------------
 1 file changed, 19 insertions(+), 21 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 4cf5493..4478cc9 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2011,29 +2011,19 @@ followover_should_failback(struct multipath *mpp)
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
@@ -2947,9 +2937,16 @@ update_paths(struct vectors *vecs, int *num_paths_p, time_t start_secs)
 static void checker_finished(struct vectors *vecs)
 {
 	struct multipath *mpp;
+	bool uev_timed_out = false;
 	int i;
 
 	vector_foreach_slot(vecs->mpvec, mpp, i) {
+		if (missing_uev_wait_tick(mpp, &uev_timed_out) &&
+		    update_map(mpp, vecs, 0)) {
+			/* multipath device deleted */
+			i--;
+			continue;
+		}
 		if ((update_mpp_prio(mpp) ||
 		     (mpp->need_reload && mpp->synced_count > 0) ||
 		     deferred_failback_tick(mpp)) &&
@@ -2959,7 +2956,8 @@ static void checker_finished(struct vectors *vecs)
 		else
 			retry_count_tick(mpp);
 	}
-	missing_uev_wait_tick(vecs);
+	if (uev_timed_out && !need_to_delay_reconfig(vecs))
+		unblock_reconfigure();
 	ghost_delay_tick(vecs);
 	partial_retrigger_tick(vecs->pathvec);
 }
-- 
2.47.0

