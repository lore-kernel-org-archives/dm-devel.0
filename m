Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B223178372
	for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 17:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720804583; cv=none; b=Q7YzuDVn9IoB0DyXy9bmSxxo2wR8a5PDkIhH5Ieeamrq16CuTNPimK1kvPcp5mfgZ5vwt7l+MwpRqz0zoexuezZMjqtsjg75jgOHB+pTSLCJkgFIxAfEvByr4jqN5TPteMWRh7IrFBq7Yh5ZgmoN0+cTikBhZGUGV5xOntIpmDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720804583; c=relaxed/simple;
	bh=7/eSxiYmc8IKQw9+EcIkfI1nv5QJYW8HSIpkAyO9tKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Di9vuS+TCWZ+d0GherH3eRlH71C2lxyQ0yWspi+iVYDz7t1NAQq5PqWY0xOcyX/lj8p0Gvu3qoZSiikM0ne0/CQVkKf3HW5ViguJOg/29LXun0zhjE5o4CJYARDr7He51bV5we2p1s+4qOXEd1YsgK1qI82CB8vcUZHhFdNYlMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=GShI8sl3; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="GShI8sl3"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a77e392f59fso300576566b.1
        for <dm-devel@lists.linux.dev>; Fri, 12 Jul 2024 10:16:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720804580; x=1721409380; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tnWScXCo1vFyuMNGR4o4Ab/JA4Iy5gM7X7XpNNA5SNM=;
        b=GShI8sl3mDi7xuv3UA0u52GWwS4wQvWuEyBC5Ya+IVEjwg5lEjzkC232QFLhoYKYMM
         CJ41mcYlxSdlqFCOVw3tjwtBpEVRkdv8qAjRSu2OJ6cN0LJ+Omtp9Pcw3P4l+B9FvfDL
         0rV3xmnyMqRurVKwrPK5EvsnzRgW1JvJgKZRwDELw4XhvhhESBTSEvaw7vz+irTMk4pc
         zzuNn5VCOq6LY6RZ/DTq4PIhJyB5MlVqkGTlsOI2L1SwE7maV0JnqOrZ5HeGdRQanAPq
         5NEEm/vXRUdQm2VXTJMS4ghjsCkLSabAbg31MKdh0CbioxIrVgad5Z3bt+VcePo6B8V8
         k89g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720804580; x=1721409380;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tnWScXCo1vFyuMNGR4o4Ab/JA4Iy5gM7X7XpNNA5SNM=;
        b=bxZA6jUV8UwCpgdDpATsDSpEaIe+33xRkvRXvhcft/2Te9rKIw40G5FfZL7QbjDTDr
         i4Er2WlgDMdlqWF7gSXcNzaovcNBX89xwVjNetPhkFosu3pVOQrdX4Cdkxjf66tQpJ0j
         21aqg/wa5C9zpWwFO6S12hWKc7mNP8l/GYwRBvc9Z/d5u73m9im3duiHoFqML0djkuvu
         LButX2kyBM5YLzD13LtQvWYDnUGWmJ9SFhBf8yf/7/HRFEH6u//5wplk8HSaFkUjzQQd
         3vRWQ1HESzzqssG4cFnUv9rTFti5j6VOSlduIw5K81I5k31cwgzuzwIc+6XqWCPswQGq
         lWRw==
X-Gm-Message-State: AOJu0Ywn7PO3nGR3CTkc2nFmjPeYHahtOXFmRCSiK8o2g5fRS9Xcy6r2
	RdEDCy0odqbiR85h3btBCe2wvy6AC98NihNxB34DbS3l+HHBYrfB6kmK8EVDeeE=
X-Google-Smtp-Source: AGHT+IEdUjS8TDir1U3WOEUfjqekcI++ep9nes/NzcR7rmMMwBbCenl6oVm94WUp1LtYBfFdXPjhYA==
X-Received: by 2002:a17:907:3f19:b0:a77:c548:6456 with SMTP id a640c23a62f3a-a780b88608amr986224166b.59.1720804579887;
        Fri, 12 Jul 2024 10:16:19 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-a780a6e05cdsm360111866b.74.2024.07.12.10.16.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 10:16:19 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 46/49] libmultipath: fix deferred_remove logic in remove_partmap()
Date: Fri, 12 Jul 2024 19:14:54 +0200
Message-ID: <20240712171458.77611-47-mwilck@suse.com>
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

The logic for returning DM_FLUSH_BUSY in remove_partmap() got
accidentally reverted in commit 20aeeb6. Fix it.

Fixes: 20aeeb6 ("libmultipath: fix deferred_remove function arguments")

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index b52b10e..5749d63 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -1383,7 +1383,7 @@ remove_partmap(const char *name, void *data)
 
 	if (dm_get_opencount(name)) {
 		dm_remove_partmaps(name, rd->flags);
-		if ((rd->flags & DMFL_DEFERRED) && dm_get_opencount(name)) {
+		if (!(rd->flags & DMFL_DEFERRED) && dm_get_opencount(name)) {
 			condlog(2, "%s: map in use", name);
 			return DM_FLUSH_BUSY;
 		}
-- 
2.45.2

