Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35566279358
	for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 14:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766155287; cv=none; b=n7H5OxYir5lgbyANa79MHCOPMfVZPRWk1XmusfoltzMrSRC4UQxASd6L6BovKbYRMU2BUQUTEwoHgQQ0kH6hQ+90ZctqMNpd4oCG+RWmZYxcM/D4BjXMz+ZNrz8Rkqb4ZVJyb8wQKJIqdvM0hYQLl5X1NtGZzq6LR4VWcBO35Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766155287; c=relaxed/simple;
	bh=r21+NTiGMnhOcZx0wxSHG57j0qhXwfrotnI/bfa2IrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XUl7sj4nbxx69l1j0PD5gd/E5+YMwHPAbJO7Cr/equ1L2VRWHi+ZC1MhuUuQGGKCHOOnZb2FBPiFa9zve3a3v3vBheUdGj1saoM/GxoXUon5VsEd3CUI76F2Ovi+EB+mXXQM+csoGZg8MPSxYVxb9CuoaVBDLYfCJOU6FiUGZPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=GWd5qBNj; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="GWd5qBNj"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b7ffa421f1bso515095266b.0
        for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 06:41:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766155283; x=1766760083; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2d9Gq2/9PdUvLGAI3xJ+4CHWJzAMjGhLTYBtx4NhG9I=;
        b=GWd5qBNjR/+2PvHUjV6Ql58p8JNrUz+6jzoA2fGiJ8AZICIShOO/g69xUWStCGoOyL
         tsbVNfmAmEO3GWQE5hXZEezaDt7gka/37BFl4r96uLIRT4NZ3Ri/ILK2FA+a4lZP0c/M
         lVNBO7BsZrj5+sKSbSJNYgmivTDPRSMDu8Qb9oyEP5lRc5/iR3KaGmri/W/DuKqiVF2K
         GaZC4gQvbgiNzOej6KWrpjQAfx97YdujMUBea9mshWQXOX35/ymvYEd7ZEEAA/ShS+Bo
         tQJAf8+mbuIvXcSInBZpQgwXmjYtE0bvlOVpbtaP7z76P+7+6MdkIP6abh3wGeDN4waR
         YFcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766155283; x=1766760083;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2d9Gq2/9PdUvLGAI3xJ+4CHWJzAMjGhLTYBtx4NhG9I=;
        b=BzlAdgcWrBk3tzrCP1CbSrXnCGfpz8p5m2oY3KerNBolHNupc/aMMCAu6E3ZWQKF6V
         83vL+uZ8yOqKoT9AbAcS+ixldBOlBKdSnDLmeuZ5U+wO72ZtdESj/kX/w47sGZtOwJQH
         8pBARAzrIkNxdIL/412mZEQ3J5yzyk1PzcGo+UMIrAc4bPIN6y3Kg9Fo9YojG19ujKE5
         J8HvUlHT0EEleOzh2N9FfMsSF0bTY3D1PDYhKPlDOnhJuN6UnxNfhVcbBb5tpcM4c3yT
         Btu3LopDF4seaN3cFHED5npNPp29sdyOKQvAa6OOTPMpoGdRuadD8LCrt4+uDla+5L6F
         eTYw==
X-Gm-Message-State: AOJu0YwMnaue/QaLfKF6+Sx9A1gbTfWpim6hru/iSb96YCPEkpT8uuL/
	lZCBJSIDs0KSiRPLl6Fv2FlG61SelYmjdZC/DRP86SegkmH41gW5/EFXOd10voiNWLw=
X-Gm-Gg: AY/fxX71ootbO+pWDZNxmt0FvP9rU3dtpOVOVOfycmUVhhS7o5MWB6f3CSXPvDggwqZ
	iZ8shEN4k19YJslngu8ox2frfUkY1zrqQRxxEZfbY8l8W54zw/XuAAQngOVBx4LbAoGy6JmzayV
	yhwhfZziMm0nBWp1njFkfUpYag0gbp4RczFEuysGynzkGoCRH4AurdJzd6B0X9XffLHfEQaqtPG
	gDJLVHa1dkiQp8Q4AoXDLMhxr2ws+b9hA8a5ov0Zum4UWaTwE1olq8lgY6tBedAkxjFrkTyrK5M
	HVWNsXiyztp96mJ9qDrSVgNJgKVQxU4jw2bZrO9Qcgt7fcsPASUgIWfCMfZ1uaE+2p7sPa2R3yn
	Jn+1KOvGqBUpVZguEMh+J1TqTvIeip+iZJNihRJM05A31J2/88mcQUA3sGCX+pmIvT4JPUTONRF
	e+S1zrWrckTZtST94v0/xU6IvqhsgZA+sHNJZw9AOHG1gxhvg1rrPQNYPGT9bNYEKsexyl0i3Ni
	Q==
X-Google-Smtp-Source: AGHT+IGYThcHtLtubt+1/I9fcrUHh9FKVrg9Gi+NwSiiSu4qznKdOgXd7NLOGKnIatiEZnQ9BTYkDg==
X-Received: by 2002:a17:907:8688:b0:b80:456d:bd99 with SMTP id a640c23a62f3a-b80456dc544mr111320066b.19.1766155283313;
        Fri, 19 Dec 2025 06:41:23 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b8037f0b7bcsm252363066b.49.2025.12.19.06.41.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Dec 2025 06:41:22 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 06/26] libmultipath: export cleanup_multipath()
Date: Fri, 19 Dec 2025 15:40:48 +0100
Message-ID: <20251219144108.237928-7-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251219144108.237928-1-mwilck@suse.com>
References: <20251219144108.237928-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/libmultipath.version | 1 +
 1 file changed, 1 insertion(+)

diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index 19e4f39..1b67b16 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -68,6 +68,7 @@ global:
 	check_foreign;
 	cleanup_bindings;
 	cleanup_lock;
+	cleanup_multipath;
 	cleanup_multipath_and_paths;
 	cleanup_udev_device_ptr;
 	cleanup_udev_enumerate_ptr;
-- 
2.52.0

