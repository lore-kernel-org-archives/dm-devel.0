Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D112C1170B
	for <dm-devel@lists.linux.dev>; Mon, 18 Dec 2023 01:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NvoGaRon"
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-6da5250357fso1979091a34.2
        for <dm-devel@lists.linux.dev>; Sun, 17 Dec 2023 17:29:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702862949; x=1703467749; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fRWJvmM8+hpVsGJoyvu2YuvVcQVJUfQcuTmMveSE8/s=;
        b=NvoGaRonPCH3mElB0woLcMq/FfaEXTgYV0CkXS7HbV8xq6zxNdIvSsUCM92AGz2kSi
         c0A8Lr+ayPzkhawB+uuNJqfV1i13M10lZSnLGzVRGxEgeYL8tpitnj7ZwRT4b4NbNRIi
         uOAaUTju9JoHgxfK17M31YZO2SyctX5NOgc34b0bRJnVQBc0qm//NWkyJjpCdHU317Fh
         A2icqifG8mmDkIUTUZgYa7bPN42H+0YWU/giEfWVAm61hRXQxREjt+kT/3IlD7iDvpb5
         o+UirntFQFWh4RQ1CYfCZDHjTn8GQwoWg3TrezvRUcNRCUvO10UDqpwS/u6w4djNIxTl
         Jiag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702862949; x=1703467749;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fRWJvmM8+hpVsGJoyvu2YuvVcQVJUfQcuTmMveSE8/s=;
        b=PfEXPy9EL0onzMhQ/j456QykCQIoArz1ot/rxS9fM1M4FX+P8AHcsoD3DgSGaFvJ6w
         1XtuajCv5+F56mExdpQGphuR5SMglQ3LKpBF/w2cAowo++6rQtAJvwJPRs6rywrMLgIZ
         75/JyYX0iTWMCglQVEXtniT7/BnslXSSQMlZn9SeftPUWXK03E+YLBJ5CHldBxe0zpcb
         2H7AVKBByXZqRUwSPabW5or+lSNuYUXzy8mO+qou7FvXJPWMb1GZNk+jHgxr6D+P0HS4
         6dqbcnMBP/UGS/Z8LmXF1O79vvjPDfzI6xdKmPP+IfKEDo0lfjnpeHsDoQ3RpIBYG5VB
         MSuw==
X-Gm-Message-State: AOJu0YwqRY7sNJLny2H93Kl/PEzZ6EMox7loveUMMwGMYHaN77snuZ6Z
	jkU5nOBLUQ48jwVt19Ushfo=
X-Google-Smtp-Source: AGHT+IEtpmNJei4+QhmEPNWe2n/m3Ke0gpe8rMs2fyyBrNBnELNFolv2m2e5X0IjBTmhtfUH48Z6EQ==
X-Received: by 2002:a9d:638a:0:b0:6d9:d44d:cf1e with SMTP id w10-20020a9d638a000000b006d9d44dcf1emr17069720otk.13.1702862948962;
        Sun, 17 Dec 2023 17:29:08 -0800 (PST)
Received: from ubuntu.. ([117.18.48.102])
        by smtp.gmail.com with ESMTPSA id s6-20020a625e06000000b006d64c4cb661sm1414014pfb.200.2023.12.17.17.29.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Dec 2023 17:29:08 -0800 (PST)
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
Subject: [PATCH v5 RESEND 5/5] dm-crypt: Fix lost ioprio when queuing write bios
Date: Mon, 18 Dec 2023 09:27:46 +0800
Message-Id: <20231218012746.24442-6-hongyu.jin.cn@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231218012746.24442-1-hongyu.jin.cn@gmail.com>
References: <CAMQnb4O15c=JC-zkCJD0U9GWwWko+Hez1iU7+cc3vhNSG86p9w@mail.gmail.com>
 <20231218012746.24442-1-hongyu.jin.cn@gmail.com>
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

