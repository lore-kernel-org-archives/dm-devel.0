Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D53042741AB
	for <dm-devel@lists.linux.dev>; Thu,  4 Dec 2025 21:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764883917; cv=none; b=O5xseIYs7DAwxErYuUaN4T9ofS/Q47PQZGqALiG66XbMoKFHwImmd7UwB8CtulGYQNnnFJ1fNw6Oerueqwd6A26T1Bu0q2zc+lnI2tKc7scclVOxtNUyUXx9c7MRiihLtER3Jj6E8Bxs7wJfa3/8eHf/XS5JIvI5n5rFkdLhuyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764883917; c=relaxed/simple;
	bh=NssZwv4PUEmyXVu3o9WkZp7kXvdy8PkTUWOhUS1cEBg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=BI02E1X/gZyQJT+8wkk9rR1gz6/XBeOqGRbCcpIcNcPe+GU2P7pKb9aUK3YZjw0Y32WAazhKNc5UzBukGcddufwpp1xJZ+2f8NLvEy4yiIDXcG3hr3eHgNRC1Hnu2JiCKwxm7P4SP4okvzwwjZopMzDSXJVOD5iLB+dorarwlTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gxeTOmLb; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gxeTOmLb"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-47789cd2083so9273655e9.2
        for <dm-devel@lists.linux.dev>; Thu, 04 Dec 2025 13:31:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764883910; x=1765488710; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=e/iWqx9ViANsCsdYJUk5CadAuT1dZRwweaObbeAfeqA=;
        b=gxeTOmLbS0LWfJtuZgzFyNaS2VnnnjDC5oMrQ/RryQe7tmGqbaHDTlnqSoX2zgV57g
         rvVMuqn9e+OFJ2dkFPixxJPP+CWbGAzuKtJEy6LJ7Hk8IwLZ07Bb5oWHj1xife/GnM05
         J9dpNB5Ob6kDU/IL26ormpEVw/ONLyLrUWd7sKvhdFeqg90LKW5GssuWAdePLYFxCn92
         5Ap39lb6OfQQL4ZwENM22EaTilpWWt+dp/BoSEfMRDGxHoDcgatPB/vt1M5kBd+qOabV
         Qn1dZI14PLtPGcfkEJLKhM4+Q7XtvEorwlgRRUcQMVAft9cGLKhf//EBe0WD6WNX4cQO
         b+Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764883910; x=1765488710;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e/iWqx9ViANsCsdYJUk5CadAuT1dZRwweaObbeAfeqA=;
        b=aOOxMyocPX5A+6fJYmi1QDl9sqpPsn4X8CZU/kEXXUnHR6FlQsot7dUV0QYTzJm5lH
         553IJUjr2OIkQ5LLjbyPXoqj+xxV98ZrIHiOBOToNNGlQvqR/ZdUn/Sy8Yxl08Ujla+U
         MnEmzhhjB7YSBWP2RfYl/mu5ZJp09PiLlqKLScVilz3DabvlofmHiCATewWXrgdFUkE7
         o/12Ngn6wqJY4QYtE4KzUN07jb2EsXPTD5vy25Kaa1ez1NuiI2TDFxaGqFTCGEOAjHMB
         alFkRMwqspxoOTqYciE9xZAAzDxvfKp8K9bruhkWpXWN4LWPr/soj76+F7krj7bAas4B
         uLNg==
X-Gm-Message-State: AOJu0YwwarsCWZN/26Bq04Q+g1yg47koWVrhlCPEQxRjm6mgxHVcRSTs
	4Ypx66LUHrTXwz23b0hJ+GhEdUQ3bBvV0HoIY3Yp0YcqaoLeRHX/DQwhEJk6Zsky
X-Gm-Gg: ASbGnctpM7nOYFjaEFKZ4D13JlhcpXxr8a/b8tquGl3Ac+YbQfOldY8r2kyznFrmqMu
	ZKRjaRBWucpNxJ3WzA+jeRMCRI0PNElEgykcBBPnlEskpreHfTAKEEy5JPNs2uyi3wYTsvrVYI8
	O0U5Ttd+CJzggM2EpZ5mdJr7nFknGvskvvJvjg81R827qI7+3EFATgJTrfX5a2BdG4b0pbQRDlH
	QAOwcecO7WJmXUsDiyzrPQSWVfIKOZ8NucMADf8CgY/K/5iTpKG6zE0HzZnB3Dq9HlXTTVdOkkJ
	ndWO8ivzKDQ4YRgRweadFleuaTxF8iz92BCY+ylJ9oOZd4mwZFwLDTzomDBiz2OpHmUD7fUoncX
	vIqAMC4f7jUZSF71QcteKb01E0W6yIZ9eBNsMoVrxtbhGXWCpEJRUE/sRC12R8tm5ufSdglKx8H
	SH+g==
X-Google-Smtp-Source: AGHT+IFH4BsC345ceUuX75LdeYFYMh2ozWn8+y1QltIkK58EIk+KBOTffWv70Z5yGWccFAmqxXHSjA==
X-Received: by 2002:a05:600c:1c2a:b0:477:8985:4039 with SMTP id 5b1f17b1804b1-4792af1b697mr94233875e9.17.1764883909407;
        Thu, 04 Dec 2025 13:31:49 -0800 (PST)
Received: from zeus.lan ([79.112.74.166])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7cbfee71sm4956708f8f.15.2025.12.04.13.31.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 13:31:48 -0800 (PST)
From: Itxaka <itxakaserrano@gmail.com>
X-Google-Original-From: Itxaka <itxaka@kairos.io>
To: dm-devel@lists.linux.dev
Cc: bmarzins@redhat.com,
	mwilck@suse.com,
	Itxaka <itxaka@kairos.io>
Subject: [PATCH multipathd] Dont pthread_join twice
Date: Thu,  4 Dec 2025 22:31:47 +0100
Message-ID: <20251204213147.3625104-1-itxaka@kairos.io>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Currently it seems that urcu would already call pthread_join when
calling call_rcu_data_free since a couple of years ago (since version
v0.14.0)[0] so calling pthread_join on the just released one is
problematic under musl systems. It seems like under glibc this has
several checks in place before trying to dereference the thread but
under musl it has nothing in place to validate so this causes a coredump
on program shutdown.

This is currently present in all version when compiled under musl,
running multipathd -d and sending a SIGTERM to it, you can see the
coredump happening at this point in the code.

The patch just removes this uneeded extra call

[0] https://github.com/urcu/userspace-rcu/commit/1cf55ba47342156cdf25335264b9774a16e0bb2d

Signed-off-by: Itxaka <itxaka@kairos.io>
---
 multipathd/main.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index d11a8576..0573d8f2 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -3739,18 +3739,14 @@ static struct call_rcu_data *mp_rcu_data;
 
 static void cleanup_rcu(void)
 {
-	pthread_t rcu_thread;
-
 	/* Wait for any pending RCU calls */
 	rcu_barrier();
 	if (mp_rcu_data != NULL) {
-		rcu_thread = get_call_rcu_thread(mp_rcu_data);
 		/* detach this thread from the RCU thread */
 		set_thread_call_rcu_data(NULL);
 		synchronize_rcu();
 		/* tell RCU thread to exit */
 		call_rcu_data_free(mp_rcu_data);
-		pthread_join(rcu_thread, NULL);
 	}
 	rcu_unregister_thread();
 }
-- 
2.52.0

