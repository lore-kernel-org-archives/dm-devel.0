Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6E92FB0B9
	for <dm-devel@lists.linux.dev>; Mon, 24 Nov 2025 23:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764028107; cv=none; b=AJU0GSxoFlmRgrn+chDBnWaPU/ib3bQxYS9n8RsCbbRLupYPnoNQh3wCjhHiba34NQHgbV68Ses4/BUnXt4jYGjdWaIVMSfuAirR7IA6QVmZMliK8bmI1dwWZjQrc5rC/AjQb9TrBmC5YHrNWqgoVypGYkDHOgi667em6oMImzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764028107; c=relaxed/simple;
	bh=ZSqWbY8pVyhLaY6mUuy6f+COqFQf+G+FnHH6zSesNgY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JBIqpTyz1zweSBuIHxwY5VFzRBpbCgfagO2DSXmCS9hojoTduqpCs1KrTnq2QZvz2bA3B3aybT+hvfDurLgma7gUhzcNl3rH/fmrJA2RUZ24ZlyIeWqk7IWlq+WrJfFE0cQg5gOr8u/H8q+5zkAeT/eZix6qSHxdWtUaSE74d14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HW5Hu4Cx; arc=none smtp.client-ip=74.125.82.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HW5Hu4Cx"
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-11b6bc976d6so6067022c88.0
        for <dm-devel@lists.linux.dev>; Mon, 24 Nov 2025 15:48:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764028104; x=1764632904; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9hEyetpjb5QpX08wjji0bcnEJUxus+pp0XTDG4Zkk6c=;
        b=HW5Hu4CxomPFhOryLZTGb/CCrP9+wSMXlyOtiC9P/HJmF/RCxivx2rQ0DQuUpkSU4B
         Uk3ju39QGPl7ProMnUikQ06nq9Sr4hCKkdSBb1hLUvkToqdgoAMeUDYbel+SqMIX+1jS
         mswJ6bpxXJT9wvzFYv0UcfAbQfNyiYuROIpEYVaNoPTBs/e0mE/JWz9Ft1ebJhGBxR5T
         7EZ5o56KuoI9O/cIl2DX8PVLYrX792gcgZ/aqBifDnW9Dg7ik3dgJGsWF5wOGbuG2Jh8
         bL2KP2q26t/rRAdD9DuOib/h6qJJ2mCEAO0DGK8+PqkhsGrKtGe7l+TGvvU8qPcuwVWJ
         tnzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764028104; x=1764632904;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9hEyetpjb5QpX08wjji0bcnEJUxus+pp0XTDG4Zkk6c=;
        b=RZfSghnQ9NAMP1VpEOemWnU4y+sKKlaUT1AB82z3rw0tk4pa5t051KSFlHIdSfsjcf
         oVtMyIHaVSrXTkp/I2AkLj4FV+wiNEjgS2RdTCwS9CFrpgm9vo6DxBCDOH+Q4RBuVhTb
         en5DdrLxuYGN9gddIWB5Xc1Hx0zipTthO2Zh+OGHA/Aqihmph4pgBCNbfrhtbb3Z4AR4
         82NlsgJIjfqIFZmdeAFwraRVHN9BuTkqsQW8HZVlyhOSfJF1+7q00t0Es36TTrwgu0pg
         N1ikWCm6c+WLujdH+eS9pab5GzLYR3u1XnMlj4BSjBuPQSJ4TSGPGGuHcxPZshvWMH6I
         UyZg==
X-Forwarded-Encrypted: i=1; AJvYcCUx/SsOS19BKzjmn7WzHYpJbmU0dRfKSdf2ilF/tWor8F2/JUjJEw8EYggo8HitqjjvGmWK0tcAlQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz9jF4kvFwvxvROfpcytX/xIV7LyOQqJigf5/ENdTNs8/6u6xuv
	DlPttnGKdi+Wq+KjLmoiI+dbrteCumycNyZYi6+eFORHH4SkFdBW18AN
X-Gm-Gg: ASbGncuoKD0+Rcb16PHhwq/ZXVNCr2f38g0jkyXFZbze5z8kcirbUG7VeWRDY08ykY1
	zqij23AVbG6pEYYD5rgU+3CKuMLhj5qEsnjynGzt4VuofkXkXptXysr/adnoZds5TiSpfLx1xRz
	AwwM3LBmhxkB+kdRiD83o+RD3hZqItLDmAQkyp4MMEqkQ/i8XURlJDb5ADA1KLGkKdc9ptIA51X
	mNRPT8XGMYHIWv7LEARHtmiJazAAJ5VnT6XTOeATR/ELuJo0ZZ3esx7oSw8kFlpdiYOrqqRh2GM
	OeR0KH14/TVq7KMw5Lq3UFS8MZprFiJ5Xya+fWbexG4bl5070AasYQSXvx8w4dZq+JVJcg/S4fm
	VtSeT/UKxWazjpOucUDEK5NxTcOVBsR+gGEEvwL3DAfRIcz5vO3cCLM34/l9ugHMUUb5d9UoGtJ
	OT2ucfkfU/2DtbmfrBzGhbalnV4kFKOiwBBURnla8qe9aEN60=
X-Google-Smtp-Source: AGHT+IG0os1yUTB1U8y0wFQR2JhU9wfG8RKwx2eS9+a2sORTH4Ie8rtwmUzrvPIYkCFTBjjRJcm4Ew==
X-Received: by 2002:a05:7022:ec17:b0:11b:9386:a382 with SMTP id a92af1059eb24-11c9cabc4f0mr8878128c88.21.1764028103912;
        Mon, 24 Nov 2025 15:48:23 -0800 (PST)
Received: from localhost (ip70-175-132-216.oc.oc.cox.net. [70.175.132.216])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11c93cd457dsm72215229c88.0.2025.11.24.15.48.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 15:48:23 -0800 (PST)
From: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
To: axboe@kernel.dk,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	song@kernel.org,
	yukuai@fnnas.com,
	hch@lst.de,
	sagi@grimberg.me,
	kch@nvidia.com,
	jaegeuk@kernel.org,
	chao@kernel.org,
	cem@kernel.org
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-xfs@vger.kernel.org,
	bpf@vger.kernel.org,
	Chaitanya Kulkarni <ckulkarnilinux@gmail.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH V3 2/6] md: ignore discard return value
Date: Mon, 24 Nov 2025 15:48:02 -0800
Message-Id: <20251124234806.75216-3-ckulkarnilinux@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20251124234806.75216-1-ckulkarnilinux@gmail.com>
References: <20251124234806.75216-1-ckulkarnilinux@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__blkdev_issue_discard() always returns 0, making all error checking at
call sites dead code.

Simplify md to only check !discard_bio by ignoring the
__blkdev_issue_discard() value.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
---
 drivers/md/md.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 7b5c5967568f..aeb62df39828 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9132,8 +9132,8 @@ void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
 {
 	struct bio *discard_bio = NULL;
 
-	if (__blkdev_issue_discard(rdev->bdev, start, size, GFP_NOIO,
-			&discard_bio) || !discard_bio)
+	__blkdev_issue_discard(rdev->bdev, start, size, GFP_NOIO, &discard_bio);
+	if (!discard_bio)
 		return;
 
 	bio_chain(discard_bio, bio);
-- 
2.40.0

