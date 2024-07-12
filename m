Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6032176ABE
	for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 17:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720804574; cv=none; b=FSNimaSZoWDY1ubralcU91lhfm63Oz4tul5hWRZFZHW0vtzi6jOIjziD+5kA4+bCoNbVWoYTD1sYQfDETQln5mlE8ik8Wl7Zc2tQDoMjIVEbUSrkVNyoj5coAGvEr1CEFoW+5W5tlKcyoJJfFph7M3bSi2PiAGqwKFkwYmF55nM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720804574; c=relaxed/simple;
	bh=f6FJwVNd/STw2y9zRsAPqzEXHFiQ9ypYedvhDpRA+JE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c/1COba6zSdIwhoQqWCvLB5lmCRzDdUftchtxhIZlTgfUv6TPDLnxI0YunAGeww/EA937TOp8u6+LG138PmfeOC+GGp4KdamenJXypHAm5KOinPr3th2grYq2ObU+fPc3kJ0likA160Me1B3pRvmT5bG0r8Z64eyX256zQ21eJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Ix3Rijmw; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Ix3Rijmw"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-58b447c5112so3121974a12.3
        for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 10:16:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720804571; x=1721409371; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jgjj4l5iw6Q6BQz/iiJXLjnYQf7taPZxWA6gM/urBSE=;
        b=Ix3RijmwIWD714ikGOS3OsP3NlVR6VDyv3PWfB2ONLyoyBNeu7VDraHAnKqToTe5sY
         Co+8ltNR5z2QaoEM8nVMPfPg5Hno3mnSoXoYPuNG6lmEjBoMtl18y2lbP5wmm0h643M7
         BtZUNBGgcprf1TT1UaVYb/Cq7TCwl/DD98fg1bPSJwdvJChoXgA1AiD1MdU64ivfIjw0
         k7F1HGDoYdLyxN8HOxwXqAhLmZbC2Et7ui0qMDl9AFfafgQmFTtpbogc7mC8FzwwpgyI
         /N7wHI4QAtsHyRubfR2Vx+FWeJSC5AOSgmKdoDP46Fh4xTqBBMQYt6I/DPqyvqF2jTYL
         0O6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720804571; x=1721409371;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jgjj4l5iw6Q6BQz/iiJXLjnYQf7taPZxWA6gM/urBSE=;
        b=m8wti1BH7N7wdYaBcqUoyCIPAjr6ug3nskdVHKzxTzp7MhDS2FzrQeN6HStVTOilRE
         K6QGhXaYzAnHZLgmu9IuWSy35vx6sZQWeDfCbPkwXXSHUseI4oO7PfDcbRvLSrh6inAI
         V9gq1DgVOgrChfy2iU6dktQDnUz4g17KUf9i2UCfUNDae6D/OmLBLkEter2W9Uchl2uD
         Bo2rV/NqkgKB1WTc0OWkLmrxCc06r+k8ZEW5EMUJ4tdnsDI1blYM2EuxJaHojB6VbC8M
         9MNp5meqzd1TOeZoGD9VMMMn5VTMbZpAccfN77+U5R9a/rZuL4S6/ColOUbx5mrpdZMu
         7NhQ==
X-Gm-Message-State: AOJu0YyBu/WKdOcx3mqGd21w0+l7ytYt6cATGtMUlye+YLy6vVBEFUlD
	jk3QAqwg5OFlG9XEO+0CrJ3LPpgv7lRdVehARj3XVaCLZmusC1rWx9wwkCd5uaE=
X-Google-Smtp-Source: AGHT+IFJsaDX8QW2eRRBkkjaHwnilokSjpyAlFr9VO7bAaNSdkOlt0L87PeH9eFfvYwScfPEoNPWxg==
X-Received: by 2002:a05:6402:34c8:b0:595:7c14:18da with SMTP id 4fb4d7f45d1cf-5957c141933mr8730657a12.34.1720804570974;
        Fri, 12 Jul 2024 10:16:10 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-5959bd1d4bdsm4003325a12.88.2024.07.12.10.16.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 10:16:10 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 38/49] libmultipath: update mpp->dmi in update_multipath_table()
Date: Fri, 12 Jul 2024 19:14:46 +0200
Message-ID: <20240712171458.77611-39-mwilck@suse.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240712171458.77611-1-mwilck@suse.com>
References: <20240712171458.77611-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This comes almost for free now.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/structs_vec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index f2cfe31..295dac8 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -497,6 +497,7 @@ update_multipath_table (struct multipath *mpp, vector pathvec, int flags)
 				  .target = &params,
 				  .status = &status,
 				  .size = &mpp->size,
+				  .dmi = &mpp->dmi,
 			  });
 
 	if (r != DMP_OK) {
-- 
2.45.2

