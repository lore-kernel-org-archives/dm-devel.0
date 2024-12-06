Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44B3212FBB
	for <dm-devel@lists.linux.dev>; Fri,  6 Dec 2024 23:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528216; cv=none; b=crqtM7mQ1DE60eyst5oStOVe+sP/6+TCdDdjHKodIhuagIHVaKkSMHXuT7Gxk6Zv53yktRkWtPqRjYvJB21+b8cxbI578bRNQj7NmZo5oAsHpCMnwhV6QgR65gPDP6o4Al27SYqck0YMGCsa0dMldSNvXSi/DvpVoaVMe2GodiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528216; c=relaxed/simple;
	bh=VM9RZVmeh0u/cxmPfPWbpX7ErJpy7NWNplo7By4btNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YE03CVD4WzauLSKudfuu/ae5Jp+bft4O7i4c3gHTBO7ge9qrAszZZzt3zLhcKNRCOST3fI6lsFF8uGzib4BnXGzpH62E6jtUpZ7aHdpOkhrBM3SdRizVu76VaRGhxDmL6D+4SGCd13WKFEK4tagaBrfwmPoQWN2SmOytM27upyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bvGtm4ao; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bvGtm4ao"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3862df95f92so826437f8f.2
        for <dm-devel@lists.linux.dev>; Fri, 06 Dec 2024 15:36:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1733528211; x=1734133011; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+OACd7f0gCpXI8Vzu589HrhuxASgEy1RetfktqqkSpA=;
        b=bvGtm4aohcpJwZslBWAoxMRrKpvhhSk6c8YyiMuYnFFScUuAdr6iKC9rhzmw4/mIr3
         uR4IINV4XXgzIYw5pTcv4Z+SdK4lOKzSeYk9A4T0rMfj1/9mxTDQLbPrVLYdK3z9gHJy
         9pJ23HMNbPxflocgrfqTv50nvErwtzqOGE/7E7E3ZS5QNXa8pTPeYHdHARV+XCbbW1vw
         2MbgZkzxhE3xPHF9PznXg9Ufzok8Jm3PHudElDw3O8GzNA+nUgoNBi031u2nliijBwlA
         ++Zgdosyi1dKlg6nLMIk9vxbeGniVvTQQYI7m9B1M0Pw0SoT+t8vK7ZyxogE6hbL0w2a
         NuWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733528211; x=1734133011;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+OACd7f0gCpXI8Vzu589HrhuxASgEy1RetfktqqkSpA=;
        b=TUR5UPgHqFOL5wBM/ZRYdQE4VghfM9tfXyOqG9p2gwV7AJYqqm2waehIc6K57v+qpV
         6ajQ80PlQ5Ghv0xEey5G9hujzKdu1ZcgdDBLybKuGhfBZPqHaAcOEyICNOLmtsfQtG2v
         GdABtFMUrFPOnSVOuY2hVvfBwCh2EDstrglLFbvVXOu+Y+5OEWVEUi6ITtcVST7EhPTj
         2Tf3UsxJ6JuAwLi2OMRMbzqI0juLzEiJ+gInYzTUeF7jgDhnywgFzXKXFvZahEwaKxJj
         ZUp5pCGhapfaX5sKnMnAWIHUmlj138lmG4/9ZGcNIwHYfZGtex8MIMa0j08TODMO0DOD
         vp+g==
X-Gm-Message-State: AOJu0Yw5JL9gbYa19TzVdBKD8Gc5CU2WRX20IUYBML0ZborPcB8RxrGd
	cVIpeLylmD9gC+J8UQlA3uNkbnQV12OeMW7k/a1T4qUrlCMvasaDeS1TkngHdMg=
X-Gm-Gg: ASbGncsZ1NlO0EyE5fGcphBsr6zl7Q2E8jr4iyPs08yYvEsNXGYqRfYTvhFccNJggoi
	SRpbbqpsiybx0elsG3KH06aOuQP6QL8U+vBYuuPfLYc7kMhJkVuDgPrOzZWhLL1wq26xLCKV5ff
	4OdR9Ur78JkCL9liNWVdDOzcoSSUCrmctojrEUW06wmvjSCp/9p2ipIOquDLSaF7X7aihGVWvwg
	9EjXXjiH2Zir5dilf4H9ufPNjhPTWyaZVVPOM5aOqOqX81WcDH3CiESbOyBXDPRiEFFNFop/PKk
	VHfeslZ+fns0havaKSFUzun+/z5G5gNlmQA9
X-Google-Smtp-Source: AGHT+IGosXMY6GqEjLV+ilH9uYopJRfWOCU1igeSwhqUOUGKIJS+gmIHAzSx2x+Z5kviU3ih9xdofQ==
X-Received: by 2002:a05:6000:717:b0:385:f4b0:596 with SMTP id ffacd0b85a97d-3862b3632ecmr3704115f8f.18.1733528210925;
        Fri, 06 Dec 2024 15:36:50 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-aa625e92a58sm304239166b.48.2024.12.06.15.36.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Dec 2024 15:36:50 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 07/13] multipathd: move "tick" calls into checker_finished()
Date: Sat,  7 Dec 2024 00:36:11 +0100
Message-ID: <20241206233617.382200-8-mwilck@suse.com>
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

The various "tick" functions will only be called after CHECKER_FINISHED
is reached. So we might as well move them into the respective code block
into checker_finished(). This way don't have to drop and re-take he lock
when all paths have been checked.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 354fadf..7e844a5 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2990,6 +2990,11 @@ static void checker_finished(struct vectors *vecs)
 			/* multipath device deleted */
 			i--;
 	}
+	deferred_failback_tick(vecs);
+	retry_count_tick(vecs->mpvec);
+	missing_uev_wait_tick(vecs);
+	ghost_delay_tick(vecs);
+	partial_retrigger_tick(vecs->pathvec);
 }
 
 static void *
@@ -3069,16 +3074,6 @@ checkerloop (void *ap)
 			lock_cleanup_pop(vecs->lock);
 		}
 
-		pthread_cleanup_push(cleanup_lock, &vecs->lock);
-		lock(&vecs->lock);
-		pthread_testcancel();
-		deferred_failback_tick(vecs);
-		retry_count_tick(vecs->mpvec);
-		missing_uev_wait_tick(vecs);
-		ghost_delay_tick(vecs);
-		partial_retrigger_tick(vecs->pathvec);
-		lock_cleanup_pop(vecs->lock);
-
 		if (count)
 			count--;
 		else {
-- 
2.47.0

