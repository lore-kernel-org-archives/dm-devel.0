Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 663FA5CD1B
	for <dm-devel@lists.linux.dev>; Tue, 12 Dec 2023 11:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IA7WBEYW"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1d0c94397c0so31319325ad.2
        for <dm-devel@lists.linux.dev>; Tue, 12 Dec 2023 03:12:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702379554; x=1702984354; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fRWJvmM8+hpVsGJoyvu2YuvVcQVJUfQcuTmMveSE8/s=;
        b=IA7WBEYWwgnfPWTL7G3pzd1ONuF4VH9/4mA8oECGDkUbnkpBrUnSPaHf3bOuJiPTem
         AJGCZzanMet2fAE5gnVcwMyx/U3W+71KWKtfhS1hym8l3E2mUb/xmiNIg1N9Sz4Bh79g
         Mkrikn0bMNaGmpeK59b3SAmz+6R7Y1YGmgC0PbDatGb4c2UuXPaT7BNDdfcseMfUN1mT
         YdgkbyVm9boqJqtnzfvmzBfPtFdW3RpsfHvHX7rpW6n/ziQZdgwVPcNCU3DbNc0K3/gz
         GHuXMbpos4FUQe8mLoVTcBzExbzmWuFaz57gRcxWegT6bic/9ZaYu6P8LtvItm/j4DjL
         +Jdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702379554; x=1702984354;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fRWJvmM8+hpVsGJoyvu2YuvVcQVJUfQcuTmMveSE8/s=;
        b=r+40NQ0WaO5/RXjKnO2xaaYlTxW48+T5rJYS5qpNNAhydT1xb/6vWOZrtZkYLsfWqz
         NrewgNkZ2zXkQKFtj993tEjXS571WVRNOdr4KULsyzv9GhSu20bZkfhfWX9lEwvSZ42T
         jr/8Y5n2XaCSN/q0wjMMvBSl8tht8XiVrwS4O7rOCNSUcucjaUY8irpdKbZqO62R2gEy
         /pzzSfdXDOmEzC28EaBx7W6RJlQG+Z/ax4ba+ncX9WFgu9bKoBX1t4Ojrsx0GBBtL6qn
         3GxkxeJaE0Skf20Us1XFyK9HdjGfGqJEe0TMhHxqLGK2T+O+5KAhb5o7EHQVHbZzPrzi
         IzDA==
X-Gm-Message-State: AOJu0YzG7QY65mondJaIxNOmeM5dSI7q6b3qzhtYDvwmkj4ajPLoIwfW
	ajYWuuEAMztDoVEZ+392IaI=
X-Google-Smtp-Source: AGHT+IFlcy+h/DMb4yTLMEPWYaQdXpLguXXRtdGTaHrTLhSYejeIi4auC/X/p0G23rVz46hOssocww==
X-Received: by 2002:a17:902:780a:b0:1d3:3876:bfe with SMTP id p10-20020a170902780a00b001d338760bfemr169241pll.90.1702379553803;
        Tue, 12 Dec 2023 03:12:33 -0800 (PST)
Received: from ubuntu.. ([117.18.48.102])
        by smtp.gmail.com with ESMTPSA id 21-20020a170902ee5500b001d0511c990csm8345453plo.237.2023.12.12.03.12.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Dec 2023 03:12:33 -0800 (PST)
From: Hongyu Jin <hongyu.jin.cn@gmail.com>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	axboe@kernel.dk,
	ebiggers@kernel.org
Cc: zhiguo.niu@unisoc.com,
	ke.wang@unisoc.com,
	yibin.ding@unisoc.com,
	hongyu.jin@unisoc.com,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org
Subject: [PATCH v4 5/5] dm-crypt: Fix lost ioprio when queuing write bios
Date: Tue, 12 Dec 2023 19:11:50 +0800
Message-Id: <20231212111150.18155-6-hongyu.jin.cn@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231212111150.18155-1-hongyu.jin.cn@gmail.com>
References: <ZXeJ9jAKEQ31OXLP@redhat.com>
 <20231212111150.18155-1-hongyu.jin.cn@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hongyu Jin <hongyu.jin@unisoc.com>

The original submitting bio->bi_ioprio setting can be retained by
struct dm_crypt_io::base_bio, we set the original bio's ioprio to
the cloned bio for write.

Link: https://lore.kernel.org/dm-devel/alpine.LRH.2.11.1612141049250.13402@mail.ewheeler.net

Signed-off-by: Hongyu Jin <hongyu.jin@unisoc.com>
---
 drivers/md/dm-crypt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 6de107aff331..7149da6555b8 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1683,6 +1683,7 @@ static struct bio *crypt_alloc_buffer(struct dm_crypt_io *io, unsigned int size)
 				 GFP_NOIO, &cc->bs);
 	clone->bi_private = io;
 	clone->bi_end_io = crypt_endio;
+	clone->bi_ioprio = io->base_bio->bi_ioprio;
 
 	remaining_size = size;
 
-- 
2.34.1

