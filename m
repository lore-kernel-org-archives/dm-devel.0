Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com [209.85.222.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D409762EC
	for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 20:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706646424; cv=none; b=PqNwdHQhlC+ZaJqeaeh2vA2PzqaC2+jmlEDfBmnkzMUJdmDIyC39xiwuYcRK4G/01Eqxie3xWi+9hXNSONORSy1jjmH1aznxdMhRVulrf1WjkaQhdIvUCroEQBHIDI3xMtD61gLkbbLc1QLV0rWbW4zXDT4fXKHvPMPXJUAI1SM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706646424; c=relaxed/simple;
	bh=HliTvmZ/wQhrAnaFAJtdmxUGXmJWIxV25We+GxozMUs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LqYFdxNtkduCDZ5Uqe56YVnAlfGKuVfNfXQ8JmSBB0YEQGDVCMzA9aVbdFAb/IxsT0j4n1KtnFgitjwGAKiZnkUmPyQyd4Rk+dmUXgy19PaMSQKnLl1PNXp3mp885MqcriLqYeLFjFPqqXTSrwpwoFJGBXbJr45pL7IV7haed4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=redhat.com; arc=none smtp.client-ip=209.85.222.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: by mail-ua1-f48.google.com with SMTP id a1e0cc1a2514c-7d317aafbd1so1787467241.2
        for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 12:27:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706646421; x=1707251221;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bIcIe5FyuKFcH4vURbTWxAwlx05s2kSFzUiSOFxihrc=;
        b=Wxbwnj0yKUbBGneP75cu+Ta3/BZcE1soQjC3Emb4JGLTLbJxDzlKXSHXdP/XDjIBtl
         LQrIG7wvgKYA9edK/rQLvm9vUuQq9Pi6gB4WWqp1QYNyGGVc2Bp089r78MIiaST431N/
         TrzLQeYUMAqvuupK8ZCVp7MbmVsFNddqMPWFMLQGMjwLxE0B0muGjTIdT6BScmb7LQTD
         aSSonLgX7kU6DzcfkmEjfCp0nhabf/r44CYYEitcNGi3JTQddk0KtwMDfDsxfUoPP3eo
         z3BF9AcbWeHF+9EGiXM/inGqZ+qa831K5r6pVLZTo9Hz5s/u/s+AXhz/gNlBq6nWLtLU
         KtqA==
X-Gm-Message-State: AOJu0Yw0FCTB1T/072eHeTnrhLVs3szMTvjujzuG+lvwA4HgevXOyUMP
	zdbtsg3Kj60fqtvS0OjQegsYlD20/JF9PsOE+u5xG1tnacj2Cu+vMaTkLaU7tw==
X-Google-Smtp-Source: AGHT+IExuUp6xS5G0CKVYTFYw3IZx74J0UcNlVX7QPKc3rvl2HNQOGF4h14hFGBJ10trlK8znVVdSw==
X-Received: by 2002:a05:6102:2a78:b0:469:85df:dea4 with SMTP id hp24-20020a0561022a7800b0046985dfdea4mr438363vsb.21.1706646421159;
        Tue, 30 Jan 2024 12:27:01 -0800 (PST)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id dz11-20020ad4588b000000b0068c493426edsm2786041qvb.104.2024.01.30.12.27.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jan 2024 12:27:00 -0800 (PST)
From: Mike Snitzer <snitzer@kernel.org>
To: axboe@kernel.dk,
	hongyu.jin.cn@gmail.com
Cc: ebiggers@kernel.org,
	dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	Hongyu Jin <hongyu.jin@unisoc.com>,
	Eric Biggers <ebiggers@google.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH v9 5/5] dm crypt: Fix IO priority lost when queuing write bios
Date: Tue, 30 Jan 2024 15:26:38 -0500
Message-Id: <20240130202638.62600-6-snitzer@kernel.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20240130202638.62600-1-snitzer@kernel.org>
References: <20240130202638.62600-1-snitzer@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hongyu Jin <hongyu.jin@unisoc.com>

Since dm-crypt queues writes to a different kernel thread (workqueue),
the bios will dispatch from tasks with different io_context->ioprio
settings and blkcg than the submitting task, thus giving incorrect
ioprio to the io scheduler.

Get the original IO priority setting via struct dm_crypt_io::base_bio
and set this priority in the bio for write.

Link: https://lore.kernel.org/dm-devel/alpine.LRH.2.11.1612141049250.13402@mail.ewheeler.net

Signed-off-by: Hongyu Jin <hongyu.jin@unisoc.com>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-crypt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index ab1e30630e64..2b4671d15201 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1683,6 +1683,7 @@ static struct bio *crypt_alloc_buffer(struct dm_crypt_io *io, unsigned int size)
 				 GFP_NOIO, &cc->bs);
 	clone->bi_private = io;
 	clone->bi_end_io = crypt_endio;
+	clone->bi_ioprio = io->base_bio->bi_ioprio;
 
 	remaining_size = size;
 
-- 
2.40.0

