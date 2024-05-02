Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9BEA1635A2
	for <dm-devel@lists.linux.dev>; Thu,  2 May 2024 19:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714676412; cv=none; b=PBNqa38VZy+PHPSZ0Rhtyron7+89dMgotOdPGqSKGeWFGYpEHJHuTYOITgIMWAXXfTxXzDuIaC0Fol+jExr3zxXpYq/NWJ3cEbF52nYFSkknVxmkaCSQyYAfag0ECbQAPAqUfINfw71gvIMsrviU1l4Dsw5ZXYDAYKvEyu4nzuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714676412; c=relaxed/simple;
	bh=30dtFGm1hkhKZCekFdmTYbeiLAo+Xk2DVXWo5sniE10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mVyeYUzFggakYHq9oIT7hGkjTTxl3bos8qJ78aUg/N3IbTDvnaZ0DPGUHUhy20qKZV0ulJ0ccYQeODrCUKxqw4XT4HwU8ag2TBJDFminlw3dEaE2vxi8N/Gkua8Ec49SUzqHOYTP4Kb33gyD2lTRhVMzlzgGeEZKjCl4LBQGKYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=g8mNHc95; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="g8mNHc95"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a58772187d8so1063429266b.3
        for <dm-devel@lists.linux.dev>; Thu, 02 May 2024 12:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1714676408; x=1715281208; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YcQXJI4rkH47Kd+WCRFf6zni670SxE8JHxCN7gKLILs=;
        b=g8mNHc95MyGstHqFQrhVqtbRfPV1telUo79eacN4nThicvf2hrEnbdjbXlKHW2GgXc
         NXXycxDSE6QBm2/WgEtV5ikY2d2yq9zZaPaVa08lZc5t1Uor3r82wL3XPUQrtkWwsebD
         hqbeKodwVh0yLMvm9gN7FLEw4BVOAoh0HUoYSnVVYXgKFutHNt/4xHbHzSpK7PvnFkQX
         I5r8MCjhoB9EDBYNrm1CkpmGWTnofCZsUw6ipHH3DsfWkAZ1Z8HXVasmz/LWdfAgUyUE
         uLpIg7K+ZpBgQ/wgGUPBbDGD0UO85xidTVZHuBtAFXBF5zK1d8pv4MimHSqLmUEP/UdZ
         zQAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714676408; x=1715281208;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YcQXJI4rkH47Kd+WCRFf6zni670SxE8JHxCN7gKLILs=;
        b=GTHS14x5WcHCnJiPtqisADMUqu07b8TKo0wNqpFYFccc6PNppXyzNJeFoX7FV7H7UU
         A6f5IAw8MyEo6n71YyMjXUu6JJd1pFLloN7FI1QJV1QfJx5zGeeZfgrHExhfw2vvwYDl
         XZ/iIh7Soxok0HvnCP6pq9jCuzhvjDU4yK158CeItgP3REqnOFIrDtDL8XQDzZnX/+6G
         Hb2/9OiqXLVkkPXmAAzMHQi6UN3mEO0GOdi9Y0x0cZ09nsjN2aaH2DRz4lSn1RXRCqXR
         RkFYQzghtJKtr05J1ep3MayKizgvftwr6Q1a5f/xACxF3xFddHrvsxzoo0Rwm8WE5tcB
         GdRA==
X-Gm-Message-State: AOJu0Yw/gsauVA2VivkPuLILm1AgwlbjLPKENNf1vyMLdxfWeA83tqVN
	2lJHyPXmv6Eh+sLeRkOa3J9kgDRPmZzeqJEhWKuRnyPyeLqIMB+zuULCbjaMjSoeNZT7IRWpXBB
	d
X-Google-Smtp-Source: AGHT+IE2O6BBPkaNOc2n/NOvvVR2rM4FDVgXdQ+GsBXrYYgyGH3PcDzsyPqzIAmqWMBH9DD7JiZlow==
X-Received: by 2002:a17:906:3748:b0:a58:d7d8:2f48 with SMTP id e8-20020a170906374800b00a58d7d82f48mr263167ejc.72.1714676408320;
        Thu, 02 May 2024 12:00:08 -0700 (PDT)
Received: from localhost (p200300de373edc00b298a6be282c8242.dip0.t-ipconnect.de. [2003:de:373e:dc00:b298:a6be:282c:8242])
        by smtp.gmail.com with UTF8SMTPSA id hz18-20020a1709072cf200b00a597bd55982sm358944ejc.130.2024.05.02.12.00.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 May 2024 12:00:08 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 3/3] libmultipath: add argument names to some prototypes
Date: Thu,  2 May 2024 20:59:46 +0200
Message-ID: <20240502185946.31192-4-mwilck@suse.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240502185946.31192-1-mwilck@suse.com>
References: <20240502185946.31192-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index a242381..19b79c5 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -42,12 +42,12 @@ int dm_simplecmd_flush (int task, const char *name, uint16_t udev_flags);
 int dm_simplecmd_noflush (int task, const char *name, uint16_t udev_flags);
 int dm_addmap_create (struct multipath *mpp, char *params);
 int dm_addmap_reload (struct multipath *mpp, char *params, int flush);
-int dm_map_present (const char *);
+int dm_map_present (const char *name);
 int dm_map_present_by_uuid(const char *uuid);
-int dm_get_map(const char *, unsigned long long *, char **);
-int dm_get_status(const char *, char **);
-int dm_type(const char *, char *);
-int dm_is_mpath(const char *);
+int dm_get_map(const char *name, unsigned long long *size, char **outparams);
+int dm_get_status(const char *name, char **outstatus);
+int dm_type(const char *name, char *type);
+int dm_is_mpath(const char *name);
 
 enum {
 	DM_FLUSH_OK = 0,
-- 
2.44.0

