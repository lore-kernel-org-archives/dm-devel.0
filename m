Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F8523CE
	for <dm-devel@lists.linux.dev>; Fri, 15 Aug 2025 07:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755244607; cv=none; b=bbrP3nz+A2M7Cmbux9me6JzZfrwUvL1Tt5fBTGPygtkDaoKL6MhOpwkqBPRD41/o2Gt6R1sd+uPbiqRgx/yCcNiLR9sMk4E0oStxDPyOEF0sNrX9K5eJj3c9c4vTczh2HoKDB1h3YWub5xXOadp9kPyu98qnt4gyj5baraf40V0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755244607; c=relaxed/simple;
	bh=9zyrvDyjfVYyWsuS94gwRz8UnTctJ6fTZCf1KTGT0T0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eCw2iuilJufSrcgUGaZONrDlphMW4ouSSYIcvOgEqB8iXn3F5cC8pFXFhabLpbj3XcoePTpgwyT4v7TpNXPMa5LSGCGtkZRTwFOThyxj+dP7BKH6HfG5vlwQDOCCkCi6Y4UYvgBsHFAf1v+aJl3xmG0k43NNKPmrMcSDXPs0Ato=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gjKtM9qU; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gjKtM9qU"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-24458242b33so16791915ad.3
        for <dm-devel@lists.linux.dev>; Fri, 15 Aug 2025 00:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755244605; x=1755849405; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=94HKFscQ+ugjTxu5GnpFNBaeL2IHgfjLAhQn0iZHS7E=;
        b=gjKtM9qUu5dScNL4zP7jQVwAPDGiWOux42ZVdgnI5xdNLrjhUN6M+stzDGQzxYTulf
         ego3xm6UFQNEzW8v0jvjsth0s51VFwwDEAagqI30WmT2xZZ4DHPPPy81Vnc4bxrZ7BZ6
         jkW/AL5DHN5Y3zwg7JWgX8k/XO3qAfdNwkG08KwCrggG02+pNNYOvCinZgMf7+kiF12D
         LGqxNXEKr2kfy4f7Emj+6Fiqnw7IyS8H1zKU9ULnDRC9ZRVcRpqw6CwwWyn/7K2u2sp8
         3x6GDLqsNBpga9PxfPoyWdHD5XR5v420L1eokABeHCvKNyQZ60Uxl2j3tIgvhVUP1yAo
         6/+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755244605; x=1755849405;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=94HKFscQ+ugjTxu5GnpFNBaeL2IHgfjLAhQn0iZHS7E=;
        b=B8oTty46UBnBq7e3VjxigmjAXWgnIblCIXgjRDGRHmcaRhxNWi+n2DVdDju4DijRdf
         ScUkQwYbQTZZTSvz86xMFoqYOsbY7vjGBZz0PwAO+edn9wCueofALBGpJMoPAvLJ16N1
         pRSzJA9PkzjDl22RQNx+LbOFrsacjCOTJSoYceFOTjzwIntCnO9n+Gr37YvT1E03qUyR
         FDhPPOiQY6ozNsPCRJG7nNPuioJkkGF8h/xhXxVecIXnuHujFVdXbTG/G0xWMnwHKj/w
         hXG5WgZttYOPit+DLBqm5VC/txgZ588Ce4gkavGfLX2lflHkkhXGdRBYuUStkCLhBNN3
         ck7g==
X-Forwarded-Encrypted: i=1; AJvYcCUowomua0hp8Xlbi6og+Qlhl3K7iB95ICjzmvQPfiw7E1kkFqGI5Wz3ta0Camo+E4gdmKFzJ2K7MQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yygy2dboVyjV7CbcKLav7lFF3bAnp4C8UKR96MsMT9a7ASAqSo7
	E/E/cO/s9qxk9iAsi7s8fm+UoG6EafikRsmP6Uh/Il81GMwaXUutFCdx
X-Gm-Gg: ASbGncsgvGwDqIMm+mMYc43KYZH22PIPd1kBzzxjxKUUeymGm0/CBewy0uzdHCBvbM6
	cTN4AmBoOBb3jEYiBpqnPjwTtiSBMBW/5VsvjJ9cHlqc/SmKa0kRKGL7kno197pnOJya/ORmA5O
	DBGMzeRS1mCYSgA95s7y9QoRCVgSK2fwn3V2mgdtHhD4Wx6KdWAHtsQ4W5khGYeVMrdi8is9I3K
	/TOUZan8P3hQuy/a1ZSVCyCL2xP5O3cp6RxDGaWllWI++bnPOnpa8U2El1f4gn4uAbuwKqwnD0Q
	OXe+OnCPuPsPWfIigE9NsGef81nxlXUzl7FeoGo92mIk8ijQvn4nKBQkGCN0gT7dddCGlyZFK4P
	LyeKu0ZZS5UmWSmOztskHag==
X-Google-Smtp-Source: AGHT+IENpZ3DUGjafhYrp0JjY0F8GbPlJ45vECelGvT3ZIvS7UFcIYwlqSHw/Sa5we/uG9E5ip1mjw==
X-Received: by 2002:a17:903:2f92:b0:242:9bc6:6bc2 with SMTP id d9443c01a7336-2446d9fcb10mr15906305ad.57.1755244604805;
        Fri, 15 Aug 2025 00:56:44 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2446d53eec7sm8353225ad.118.2025.08.15.00.56.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Aug 2025 00:56:43 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 5148B40AB483; Fri, 15 Aug 2025 14:56:41 +0700 (WIB)
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Documentation <linux-doc@vger.kernel.org>,
	Linux Device Mapper <dm-devel@lists.linux.dev>
Cc: Dongsheng Yang <dongsheng.yang@linux.dev>,
	Zheng Gu <cengku@gmail.com>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH 3/3] Documentation: device-mapper: Add dm-pcache docs to toctree index
Date: Fri, 15 Aug 2025 14:56:16 +0700
Message-ID: <20250815075622.23953-5-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250815075622.23953-2-bagasdotme@gmail.com>
References: <20250815075622.23953-2-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1099; i=bagasdotme@gmail.com; h=from:subject; bh=9zyrvDyjfVYyWsuS94gwRz8UnTctJ6fTZCf1KTGT0T0=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDBnznq9PdTXSW1PU3DZ9WmNR9v79zHlvucNvJl1J0Ev8k vj7fqRHRykLgxgXg6yYIsukRL6m07uMRC60r3WEmcPKBDKEgYtTACayPozhn1XN6+cHdUquipzf lOt1bXaY8bzPC4Pj4zUcfzlntmu1mTIybEjYN2GSWISwyx25T40z7jVrmrslvPL47Hdi81/eteZ vWQA=
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit

Sphinx reports missing toctree entry warning:

Documentation/admin-guide/device-mapper/dm-pcache.rst: WARNING: document isn't included in any toctree [toc.not_included]

Add dm-pcache docs to device-mapper toctree to fix the warning.

Fixes: 6fb8fbbaf147 ("dm-pcache: add persistent cache target in device-mapper")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lore.kernel.org/linux-next/20250815131115.45518c74@canb.auug.org.au/
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/admin-guide/device-mapper/index.rst | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/admin-guide/device-mapper/index.rst b/Documentation/admin-guide/device-mapper/index.rst
index cc5aec8615765e..f1c1f4b824bafe 100644
--- a/Documentation/admin-guide/device-mapper/index.rst
+++ b/Documentation/admin-guide/device-mapper/index.rst
@@ -18,6 +18,7 @@ Device Mapper
     dm-integrity
     dm-io
     dm-log
+    dm-pcache
     dm-queue-length
     dm-raid
     dm-service-time
-- 
An old man doll... just what I always wanted! - Clara

