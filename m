Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2889122EF6
	for <dm-devel@lists.linux.dev>; Wed, 13 Dec 2023 10:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dg75IXOa"
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-7b435966249so297655039f.0
        for <dm-devel@lists.linux.dev>; Wed, 13 Dec 2023 02:42:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702464179; x=1703068979; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fRWJvmM8+hpVsGJoyvu2YuvVcQVJUfQcuTmMveSE8/s=;
        b=dg75IXOaiVwGYhhvdOsHYmS1cZqIE+a4zoR2f4lIgpVVe/E8gxpU/EyFJQGwhLXPJ3
         dGvg2nRfyWzpxX4QSwS5uicDMBv6rAxDlPXCJKLYMK8lue9SlSuozVQCnY7wLyJ81Qma
         iEqXRbluEJo07jz29zoQGQdW3M6Mjk1SSpzifDvpCtUxIhfOPieUXIX1N/wvi6wwxioB
         gTRw3UipyFohX2rcZndSOYomqH0fybhxnJ/7fhrYepJf98+gFSnl0/4kFIVlMUh3aWZa
         t1zANIxxR8v6rym09RkThOIy8wPHouy873xbMsGtXa0GE0RhC7VJdPlL9vn331TJv4Z+
         3XIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702464179; x=1703068979;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fRWJvmM8+hpVsGJoyvu2YuvVcQVJUfQcuTmMveSE8/s=;
        b=kGwyGhZpyEp/oFJUjYMwQMFa7WdZV/ZoCudVNMKOlRgkp2e5O+Ofq+DKttIVkt1iCI
         11A+UZGhLuwm72kJ+VfgPL1C16myILKS6bTIWDE6sRkBJKp6DkFk4Luy305tJzR1BJBm
         Soi/W03176K01hpN+Hl7g7eymGGhYug/aHgkxhqTsCzGiSndKYkBb+EkoJHE87LyTnIg
         ilguot1RPijYs0TE1t0iA7Poj6Uj1TVC1GZ9gsyhcLlR50xhF8Tb/xQnXwIbIBywiEVi
         FxxV5Fjx56qmI8JTN7JkrtQyzN20PULzqkokCaH3SbEagI4v5e0p+ZMXuJf6AH9SFz6M
         Yqyw==
X-Gm-Message-State: AOJu0Yz9ACzojlUN0poWLCCOu+3OsvW9YrdtFTLw2UdevDZnIMyTV+N4
	kHgFmsexOmwbdxQiY17LH/o=
X-Google-Smtp-Source: AGHT+IFqnQH5xHRTW7lkDH3nUXotSoQk9CUeHU1CHahsXGxY0QsPY5pXBPOQ53OTwye2jv3CgtPipw==
X-Received: by 2002:a5e:c742:0:b0:7b7:1717:693f with SMTP id g2-20020a5ec742000000b007b71717693fmr8044235iop.10.1702464179355;
        Wed, 13 Dec 2023 02:42:59 -0800 (PST)
Received: from ubuntu.. ([117.18.48.102])
        by smtp.gmail.com with ESMTPSA id c11-20020a6b4e0b000000b0078647b08ab0sm3058186iob.6.2023.12.13.02.42.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Dec 2023 02:42:59 -0800 (PST)
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
Subject: [PATCH v5 5/5] dm-crypt: Fix lost ioprio when queuing write bios
Date: Wed, 13 Dec 2023 18:42:16 +0800
Message-Id: <20231213104216.27845-6-hongyu.jin.cn@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231213104216.27845-1-hongyu.jin.cn@gmail.com>
References: <CAMQnb4MQUJ0VnA5XO-enrXTJvHbo6FJCVPGszGaq-R34hfbeeg@mail.gmail.com>
 <20231213104216.27845-1-hongyu.jin.cn@gmail.com>
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

