Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A175D763E4
	for <dm-devel@lists.linux.dev>; Mon,  6 May 2024 07:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714980374; cv=none; b=bKKLp36E6vac2Xt7SEOcVpMwqAwhBDRn3kGHCIRe+K7HuZczvo6K2Rz/UKHzLNp+XhTSNVcNs0K7/xdzW2uXSQUQ7A+bXdQSTIhgMpRZ2frWK3RbMKF1BFPAcZeE+k3/wWUpmxFDSpfs1mmSSlXXIlNCJ40bn0ThZ1IlcBAi08k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714980374; c=relaxed/simple;
	bh=AllLnRUfY8oVArg/OQXVQOXZddAbll/rOsq1CE5JEdc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FLaAbUBjmep9vts9puQMOycjE29kdsambUq3hd7UxzQZ3buiR7+bLQ0/b6mOUpvj9ILO4M6B12cSlD+cLAS1piIu20MFavifKSaT7WimQCl48m6gQVPUZzVrwQJX3Gdm3MG4FZcTiS1QGhHX2r35063PMZotPuRtxBATMt3X2mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linbit.com; spf=pass smtp.mailfrom=linbit.com; dkim=pass (2048-bit key) header.d=linbit-com.20230601.gappssmtp.com header.i=@linbit-com.20230601.gappssmtp.com header.b=xIuLsQPm; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linbit-com.20230601.gappssmtp.com header.i=@linbit-com.20230601.gappssmtp.com header.b="xIuLsQPm"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a59a0e4b773so344914266b.2
        for <dm-devel@lists.linux.dev>; Mon, 06 May 2024 00:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linbit-com.20230601.gappssmtp.com; s=20230601; t=1714980369; x=1715585169; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9rIFkbCWlbzUtN5PpRfhtP4G9tKmdZ6WmQepTdXTBAk=;
        b=xIuLsQPmCAKp4nx23KKtrR8lE5/4ib02pJGOgIvXkW8G88W5u0NRAQEJ1tOKW6Uk7l
         6kW055lYZph1l11CX2eicvbLsReQZYTxuPy3mE1f5t5VzdeU1tP0lbJpljdJPG5ZHQ1J
         cU2iMdSfnIxtTv38Ru5iZN6jgm81DtbIrASMSXOirpHoArFt60+WG8uzP+7UCLtOfE/z
         pP1XA8fbaM8EIoYYN0wL3OcSegnOM64gtRqSxKuqIBAIom+K0qREIYp1SUB0Q3/xuNXR
         yP6lMD/ZvTyQuGG2vv80nb4/APi3PUDNYAskpflgP9Kx3iB1O4B3O/N18kJROuoXzzXh
         EeNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714980369; x=1715585169;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9rIFkbCWlbzUtN5PpRfhtP4G9tKmdZ6WmQepTdXTBAk=;
        b=aN+NZeHm4VfdOjLGeQGduzdK6WvVbU9qecVTbEznaj99QOCRgpb85LjDmbogB68ZTa
         P6XmHzbWDXg8e5X/c0VHm8pBj7b8JUsfbZInXO+tm8/kY/2SJmuQK4PfCDNZSXgqGe/2
         9MrDUgLV5PuITjv+F+OGjV+ddQcn49wM6JgOuxYGcxJoyeBXHiLSX/F1+FoK/EkCQ0TR
         MfMYIk3LgxW47acwq8BInLLAy9hZ9Geq+4UGvQYfvNLug+qbPigaC7YtM9xLfTMrnkGB
         ySL+389T8ufIr10UzFGTiVlrZWQisp5/aDLxuHHc8TRM/jS/zpC5+QV8OARxqZCAdswF
         NwJQ==
X-Forwarded-Encrypted: i=1; AJvYcCVorxTUwqhQZ8tDWnSzAqOJKCtGE8ysxN+Iky/0Qi/dnRY9ROXki8UKKu6Qmxegw6Kd2cB/NtWvyAM8Lc5WymO+hqpCudPfjPs=
X-Gm-Message-State: AOJu0YzoLQt8j4BmRPa0IwBx3iuavFsz5rknryvm2RcZE3pVmya3JBPV
	EfghwIaGBXvAW/8W++6b+ZRitawyt0pMziZytai/AJR3DfoGZSaoRfLiWI9dvNbMSwyuID1ergt
	7
X-Google-Smtp-Source: AGHT+IHSvKPsrFKqw6KfE2f2jYNvVCpSGhY+PowBEX5x/SvfY5hyvV+g/7mmozBB6bOQ6w0e/lHa8w==
X-Received: by 2002:a17:907:3f1d:b0:a59:c9ce:3390 with SMTP id hq29-20020a1709073f1d00b00a59c9ce3390mr2161679ejc.30.1714980369175;
        Mon, 06 May 2024 00:26:09 -0700 (PDT)
Received: from jrc-a.. (213-47-229-24.cable.dynamic.surfer.at. [213.47.229.24])
        by smtp.gmail.com with ESMTPSA id oy17-20020a170907105100b00a599a5dec53sm3552611ejb.125.2024.05.06.00.26.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 May 2024 00:26:08 -0700 (PDT)
From: Joel Colledge <joel.colledge@linbit.com>
To: Christian Loehle <christian.loehle@arm.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/1] dm-delay: fix hung task introduced by kthread mode
Date: Mon,  6 May 2024 09:25:23 +0200
Message-Id: <20240506072523.399767-2-joel.colledge@linbit.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240506072523.399767-1-joel.colledge@linbit.com>
References: <20240506072523.399767-1-joel.colledge@linbit.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If the worker thread is not woken due to a bio, then it is not woken at
all. This causes the hung task check to trigger. This occurs, for
instance, when no bios are submitted. Also when a delay of 0 is
configured, delay_bio() returns without waking the worker.

Prevent the hung task check from triggering by creating the thread with
kthread_run() instead of using kthread_create() directly.

Fixes: 70bbeb29fab0 ("dm delay: for short delays, use kthread instead of timers and wq")
Signed-off-by: Joel Colledge <joel.colledge@linbit.com>
---
 drivers/md/dm-delay.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/dm-delay.c b/drivers/md/dm-delay.c
index 5eabdb06c649..eac166405b6b 100644
--- a/drivers/md/dm-delay.c
+++ b/drivers/md/dm-delay.c
@@ -267,8 +267,7 @@ static int delay_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		 * In case of small requested delays, use kthread instead of
 		 * timers and workqueue to achieve better latency.
 		 */
-		dc->worker = kthread_create(&flush_worker_fn, dc,
-					    "dm-delay-flush-worker");
+		dc->worker = kthread_run(&flush_worker_fn, dc, "dm-delay-flush-worker");
 		if (IS_ERR(dc->worker)) {
 			ret = PTR_ERR(dc->worker);
 			dc->worker = NULL;
-- 
2.34.1

