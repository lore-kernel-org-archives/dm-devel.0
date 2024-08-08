Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C65918FC6F
	for <dm-devel@lists.linux.dev>; Thu,  8 Aug 2024 15:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723130802; cv=none; b=nCCRtEP3LsXO41lhh8tCKMayTGYf/ZmktVIEXZETQbX13NkwPUbJGuNVTFXyes+VtJKPGGfU7DIpzocpNPP1x8vLlTc2nBO8xMfav3E7jNOMdNWeq7DqfYfZC310j+jopqHZQ5qwJ3dvWRNv/TgYOw35/GwSl0OsCcnLp1SZB6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723130802; c=relaxed/simple;
	bh=zxA+WHcAAzzaGsIwTernqIbopft2AIjK6JWUOg/J0F8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IiXKiNgtIXCf4YezkqJXfLIA1njqDi9tC7Jqj4ji4/PHMijqs4yaEiJk2Dx0raVjhG2V78OK8LDBAefS9MoH7JKKjYyKFsUuXF7jK6YXtUzxVuzWwyqhtDy4MVFSlalnKsjgfBL2fYeKhKktEvXXXdeVzOJpIfRyFHMyVXjcs8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Zpel1T0a; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Zpel1T0a"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a7aabb71bb2so121356966b.2
        for <dm-devel@lists.linux.dev>; Thu, 08 Aug 2024 08:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1723130799; x=1723735599; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8ftlhIu1XDGoNXVs49AS9O6VzVuEVWBScs1YE0hhGwQ=;
        b=Zpel1T0aREvVlcBYcE1HARtQo5CPSd04LHC/nEu+V9U+4FJX3PMPOjWtvNuCJ3TO6b
         OG5dbHMuhbplqwlBfSKdIUiF27l60QQQUU32DvT/deCUoZgF3MmFa6J45iDhvvVlrnPj
         Z/keWP9leHBTBSkUk3nGAWyfMZbNi7qXfGMS2iONbbNnib2lGEvTPBPa1x3k6SBvQZ+Q
         tf0nKqtUh+jwnfT4CMx2MCHS7aknGVoS+IV+FKvY4VpScC53CIPQ5g6WFiF3vruMufo9
         XaE8WidNB7VryXZ+JjjAM7d9PQLQEVRf1of13dEa5Ejnt47WTies4F3wNTFKoBgP0a4e
         E7gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723130799; x=1723735599;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8ftlhIu1XDGoNXVs49AS9O6VzVuEVWBScs1YE0hhGwQ=;
        b=m8J+q6wD73RvN9RcSlGpEQiLEuDqC3AIQRIrjKMge9ERSf4OptSNPJ14hHn2WEC9ku
         GI8jiPcj6R6YOi0KH50TFQV2MibfF95QPmau7HBgGxEbJBJbs1CzS7NHbXyeWd9qQG5S
         DCbSa2px30oPuPqI16OGEnY2Tpn1s1w4sRdGQ/vCi8VlLY34ExeKj1qfHgR9RI26js0i
         iIG8L6TQsO7XiJXEDTd4zI/MR5VBvS3j9EIbNK7gpZgLTbSyCs3/I9x6eiq0ow06DlKW
         PEeJRIO4boQnodA09vSl8CUrXl/ATP4qT2q8Xi+88V2ftr2nOtaK4GiN1h0unXLYdu3k
         8yMg==
X-Gm-Message-State: AOJu0YxzRqpmmfaCurxFgHh91cNiEeuLKzL6wCXpZo7vVsq1U25tEefg
	9kkxEyky3Npp4xgvUJ5aUrNYQ68ZdERkJmWYM6shbW2a2a3lv0JIzZ7bUhbttzM=
X-Google-Smtp-Source: AGHT+IHwGzaWi3sT71e50kI7QBFNQ0NOBGt6E0WOvQbq5E5xqH+0abgjWgmZMR9PmJz7WW5tsl6/PA==
X-Received: by 2002:a17:907:f1cc:b0:a7a:c812:36bb with SMTP id a640c23a62f3a-a8090c2303cmr165391066b.8.1723130798560;
        Thu, 08 Aug 2024 08:26:38 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a7dc9e80e5fsm750176466b.161.2024.08.08.08.26.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Aug 2024 08:26:38 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 05/41] libmpathutil: fix __attribute typo in log_pthread.c
Date: Thu,  8 Aug 2024 17:25:44 +0200
Message-ID: <20240808152620.93965-6-mwilck@suse.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240808152620.93965-1-mwilck@suse.com>
References: <20240808152620.93965-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathutil/log_pthread.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmpathutil/log_pthread.c b/libmpathutil/log_pthread.c
index 69b441b..f30eb7e 100644
--- a/libmpathutil/log_pthread.c
+++ b/libmpathutil/log_pthread.c
@@ -60,7 +60,7 @@ static void flush_logqueue (void)
 	} while (empty == 0);
 }
 
-static void cleanup_log_thread(__attribute((unused)) void *arg)
+static void cleanup_log_thread(__attribute__((unused)) void *arg)
 {
 	logdbg(stderr, "log thread exiting");
 	pthread_mutex_lock(&logev_lock);
-- 
2.46.0

