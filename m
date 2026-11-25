Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795630605;
	b=3avCAlpqegGJ4/Q/LpCEz70JyJ1NIRjotHxAkL8GDpfgo/x+YKe7H2+dbyciK7h/Qc03
	 8BWpjwEM8QqBjkqciv3KCsNZCbrPpnJmFbR27AifPBAO2K6jSTyHFUt8p255Up6W0uZsM
	 Nkh6OSTAqbz35JrzoVJdcNESkQdSfj1FFT8tLF++Ro7Daz8qeE8ballL7DV4Z4hhQJEaB
	 jsCN6xP/I8lBjg+G++D8LMLACv04GFcmx1WBTi1HVNNf8Ok2HuQ+YIL4iyr3QAIzu5/T9
	 cNnICjXiN7ZjnAMfggGWBHaeyJr+9p5FMTayTyb42N4Ntv80P4fh3eGIEYXewDJpNnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795630605;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=xJl3VeU28yFIf7u8OboR3R/WMzTEeOW8WHDyp56+HdQ=;
	b=s3U3xTGtyPglbXXAzEJ1zYDNggEg+Rh3wfmIifymQzokDDj/7BMLdKLKbT6aW1sb7poG
	 vL7R2LTQl7MQQIEzGMT+nKtWTxMZ9P33awyW3exXnLD83wki/7siuRswsY1+9CUNOoMeu
	 bPhgG627SYcGEstHz/UO2qSPQ6/TZc2rAhqxkj2mqRwI+wZIexQpzSgmG8wbrwiSvLzQS
	 xGxQu9IoSXKzSw7I/t7ux0GR0pbDMtWrFZVOSjwrt1JQeLf1pKudCwcDX7rbBWcmZldLm
	 bClCea+HQCe+pRCfj7cL4dta9EZXMz0DbV53IalLRdtqikxQI6LVmyjOK/CKXMt8xVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=S+wlp2hT;
	arc=none smtp.remote-ip=209.85.210.171
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 575FB606A32C
	for <dm-devel@lists.linux.dev>; Wed, 25 Nov 2026 18:16:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 575FB606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=S+wlp2hT
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-8b68e59ab33so4455785b3a.2
        for <dm-devel@lists.linux.dev>; Wed, 25 Nov 2026 10:16:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795630605; x=1796235405; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xJl3VeU28yFIf7u8OboR3R/WMzTEeOW8WHDyp56+HdQ=;
        b=S+wlp2hTt05s/xYPfgLK3JxBxvrL+ccPVnB994AmpfTPglOG0ihadEnReXj7buH6yY
         dR71CDCbbkGmM8vFTrKhYqtKEAAAO2p1HZx8XMaIjCX26bTqoOfeQ30/sLniz90tL+oU
         goLH/PbDW14ubHjrZ4E3IxecQQ5x1mbqCKggrXGpspjRvyRSv4e9tGZp7FYYuy3XKGJ/
         ZvFnFQ3pzeIW0LTLzaJ2xnLmavMJzHx1mNIMBOd1Wt9F5RnCV3uauCJR6L8PZvAhNRyy
         uM/rGTyGYjp83FgXsUCyy7er2gqWG8+bpUoJIIjPCs9GkWCxDfX6gR6kFTYCoCPOiJav
         pevw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795630605; x=1796235405;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xJl3VeU28yFIf7u8OboR3R/WMzTEeOW8WHDyp56+HdQ=;
        b=0SIsFiOqfPZAr9Hk+3z1JgbLE7lboyyPRse3ZDZWidSoVgxlBgHBIcaMb9O4j65qSs
         thcuR+qK0+RUT9WeXtmPqF/GPxhZHqa5QvSLnf6LuQ7xBisYAEXYfJrRR4HlXchvtVX3
         Smq9wN/n4d9OoRjeZnvqTVJYAW6LOK6DeKK/KoJtn2jbY6eAq5CkwV95b4i/3m6eNwZM
         lSqjV7wTDUxm2LJRMrWuVAS5ZCmYtslqiYde69H3oD3Su+dwlx4+X6yLYm7m/dEO7e4j
         UpFid13I/tnJVwODtWmo2tNAKR3gbfNN9KIhSQXDIvuTz5F11sPPno8xCRh/h1HTFKXD
         /EBQ==
X-Gm-Message-State: APuU4Z/sdweECogUsfwb7DOZl9kRD8txxBHZhRqDExt4jZJN4Kc1eyAS
	6q3/O4ZtEiJ/3N+Xix7bM9ECCPN5lk/FsseMolJ/FL6iwE1SFEmfCm/uRjWxHSAV
X-Gm-Gg: AZFdTZdLAr2wB00qAbSwZTlhN9Yz692xMGFAVSFsCiz+VWxobF1a2eDBwkWr8I1Lf5C
	Z7QM1V5uewG4fIY9halvcJXvVTZaxnTNvxIUeip+/i5zND3iTWzSAFmKolrh1rQHdFPWf3jjBUl
	9BQ+nUq7hqwn7vAXvR7UeG8IrsPfCQ/n0Ln1fWTkCsDBLoZ1McLnyPTNelk96HBFfx31A8QDlug
	ocCm+uFcNSlPHfRd7ZjuylpLJCJTBoyCjivGZzVK/I9ho/VF3XNk8UC3Ek5AImRBqH5bRoJ0vdU
	reK80HMa/XPvyGyqw78X8w7iocU5HrVTHXUtapDfYLFoXFy+7kwVd4DbDtnKw0aNZxFN6E4K7r2
	xGEciK689U1pOdUYoc09pMTsN961Vdi56QUzw1E9Xxkae735hwm0u7ge/Rtn/ymxyU2n4LdZ+PT
	EauSjIa4pQpJh4/ZhTq6yWz0UcoPajW+AIND3TDgSnb4u0nXbbrJJQ8eMtbYdRHwia1xHPJVAD6
	egAjD6+Y4PSngsuTmVkp5WBWlwi/U9rZVrcimhPjD5ZtYgOmZ4BLn7ZdyXQLoVucXFP6OXo5lkU
	UTLhRYUw1kUJvLxCloNg9TvaKCGwN1HRnpP4u15jtf/ycscxtCSkMSQuereTGUDuxsRfRVLnGL+
	et+pFB4vtyrqWCt99fLTejsCeAvqAk/sq4mYRTghicFmhsnseBw5PM9osld7P3UoGrXtQq96PpH
	Y=
X-Received: by 2002:a05:6a21:3b8d:b0:3f7:7e3c:af64 with SMTP id adf61e73a8af0-4014c350872mr21282532637.43.1795630604435;
        Wed, 25 Nov 2026 10:16:44 -0800 (PST)
Received: from fedora (n49-177-87-40.rdl1.qld.optusnet.com.au. [49.177.87.40])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8cbe173453dsm6163395b3a.25.2026.11.25.10.16.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 10:16:43 -0800 (PST)
From: Ronnie Sahlberg <ronniesahlberg@gmail.com>
To: dm-devel@lists.linux.dev
Cc: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	bmarzins@redhat.com,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] dm era: stop the worker before closing the metadata
Date: Thu, 26 Nov 2026 04:16:27 +1000
Message-ID: <20261125181627.625466-1-ronniesahlberg@gmail.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

era_destroy() closes the metadata and then destroys the workqueue.
destroy_workqueue() drains the queue first, so a worker that is still
queued or running at that point uses the metadata after it was freed.

The worker is only stopped by postsuspend, and there are two ways to
get to era_destroy() with it still started:

 - It is started by preresume before the era rollover, and stays
   started if the rollover fails.  The device is then still suspended,
   so postsuspend is not called again before the table is destroyed.

 - It is started from the constructor on, since era->suspended is
   initially zero.  A status request for an inactive table runs it, and
   an inactive table is destroyed without ever being suspended:

     dmsetup load era --table "..."
     dmsetup status --inactive era
     dmsetup clear era

In both cases the worker can be busy digesting archived writesets,
requeueing itself after every step, when the table is destroyed.

Stop the worker, which also stops it from requeueing itself, and destroy
the workqueue before closing the metadata.

Fixes: eec40579d848 ("dm: add era target")
Cc: stable@vger.kernel.org
Signed-off-by: Ronnie Sahlberg <ronniesahlberg@gmail.com>
---
An AI coding assistant (Claude) was used to review this patch and to
help write the commit message.

 drivers/md/dm-era-target.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
index ea499adca4ce..8b8b8b3dfa19 100644
--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -1438,12 +1438,15 @@ static void stop_worker(struct era *era)
  */
 static void era_destroy(struct era *era)
 {
+	/* The worker uses the metadata, and may still be digesting. */
+	if (era->wq) {
+		stop_worker(era);
+		destroy_workqueue(era->wq);
+	}
+
 	if (era->md)
 		metadata_close(era->md);
 
-	if (era->wq)
-		destroy_workqueue(era->wq);
-
 	if (era->origin_dev)
 		dm_put_device(era->ti, era->origin_dev);
 

base-commit: 8d7fe9885c62fc9a95bf55d9db244d9672a8aadc
-- 
2.56.0

