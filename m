Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E5E35836B
	for <dm-devel@lists.linux.dev>; Sun, 26 Jul 2026 06:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785048211; cv=none; b=aZFGtadMA+1qv7g8626Etfu90Q/fXpZhAMFOWTF9Prj135IaJyA7W9pKX4399Uk7LTzLuW2m+YkIA+zcjZnRvaSm94FqPOQbIZU8x7CcyJPk0dDH8RBQNJ8r7Ss7XlBFcEjcml2pjzAMVSOkLXeg9O5Pw+0lxjlDYUcCMS3Z9zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785048211; c=relaxed/simple;
	bh=lQ0deDMG2ApjUGYfjrTxheuqqCEzUkKh96mLGK98wEY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jZIPU2K/kL1eBSACE3GS4Cdfl9Xh/woUT84kXYAChS2OWJV1VliCQs32pgYFneGjXf/blAxla6aZHvsAyx1xwzaz8W28+H5IaoVANIf9guzylvp6vT3UNAGWPYjN29hO6OmjLMKVgEaY9T/fdkX4ILZlES84KCT7hFKOdCnZLL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N4zrrtJk; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N4zrrtJk"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-38125cebfdaso2411573a91.1
        for <dm-devel@lists.linux.dev>; Sat, 25 Jul 2026 23:43:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785048210; x=1785653010; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=tsKwdWS067cUnKKxouS4gGBgT4NLjJldK5XvcD/R/Fo=;
        b=N4zrrtJkxmfQah4fItUlhN625G7+IREm5p3v1P5JvtjjgLXmWrPaDTgUy6EBV4AiQG
         oF6wwGGO9D5nz/ZUkBHh0kgXXYrZ9hTtChbd2bbMICKjd0bSecPhh/TjPmzHW8JdJqsP
         jMQPREyDwgdYTUKLs8Pkmvg4Df2arEc2nWDvSxmD7DV2tU/7SRYnkGs4LvDciuWZZhfF
         Q7faK0VVqsQMM7h5/BbWmWE0yS8zWDqfHlmYcPZtO5DgM5GLrEbkbVXpBCiQYs0xWEHU
         qrFaQa7xtI0cYIUan0V5W38blLEDO4nOb3GWLrCq89Hrb1RLWbtvkEFunHIsE9pVKw9Z
         Uo9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785048210; x=1785653010;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tsKwdWS067cUnKKxouS4gGBgT4NLjJldK5XvcD/R/Fo=;
        b=Uu+AO3wEkrOteoMMtoSwvMmH872J+hOWwSQwS6eDsm3ZxwBnEkti3lVy7BPMFz4Eqe
         JhNcrmWTXPrH4/GTfORAxXLY0+rDl3uBtV2mI0Is9djJe4svHsKarFUMKyS2wMBM0GfX
         qEyhxD13BUVUR1fcfKvSHsm1wwDFUGn4TPWuCcOj7JhLJFAZqIr1FDI3w7lPnkyuTlEK
         RQO084y5GdI3M2is4uU51av0Vsfx3zMnoR8mLg8QRvaWoPF56iWh3mlglbXx/eOpDNZ0
         WItsL8HmQtH0NSqyS2BYfmI4vH3r+Qz2SIFe8ZrqCNuXCZtUde9qh7G60tBe3TS0GCrb
         B9QQ==
X-Gm-Message-State: AOJu0YwGt8UfkNAeiXFVDZ4Ws+Ju8XCdpcK0lsXLReluTnbbG3J8tzTV
	zTe0YylGcaygBSPT6VeYwP72q4XTnnSfrA+RipsUzS9EYmfs0tS+QL9C
X-Gm-Gg: AR+sD10k9MYFgmE+w9BrMYcMtV05rAq7ucYWh1fNANUhNUK2rhtTysqawMHHjcO/60j
	lygsIvSttcW5gfbZOZnBox3DRvaeSuB5175SoAUGQvKIWaiaygTUVJ0ILetvu004VOPQGsFwj2X
	A2B/T+Ea6oAl41HYk2rJSGO6yrIJg8misc/d4MABjac/sY5ZySlFXxfCOZuIgwK4MZYlodP0Fmh
	gIOeNcrO6GUZsGbyXyuTW8uytXZSY3+V60FzimFFyudPBBvYCNWm9TGLsGE1+o08VRHZGEG13h8
	OF5lTG4fs4NVhixaSAt0MFUXFwuc1cMVtIOXl/19A4tExVZzOLn9rLqCdlRP0WxzKpJMDEqugFx
	Ou1/TxNkif+kANzjuSEht2dW2ouj0auPIPui7lU+//cRfcuRen3YZvLbA2spKOFxV8p7eGHliKu
	pj3V+gcRNmuTAboIzEZqnRBBcPhqpwTrM=
X-Received: by 2002:a17:90b:3f0c:b0:38d:a8be:a597 with SMTP id 98e67ed59e1d1-38f298b4c1bmr4839444a91.37.1785048209741;
        Sat, 25 Jul 2026 23:43:29 -0700 (PDT)
Received: from acer-nitro-anv15-41.entro.com ([118.34.230.2])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f294e1ab1sm1467217a91.10.2026.07.25.23.43.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jul 2026 23:43:29 -0700 (PDT)
From: "shaikh.kamal" <shaikhkamal2012@gmail.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>
Cc: dm-devel@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] docs: device-mapper: dm-inlinecrypt: fix 'bellow' spelling
Date: Sun, 26 Jul 2026 12:13:09 +0530
Message-ID: <20260726064309.20263-1-shaikhkamal2012@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix spelling error reported by codespell: bellow -> below.
No functional change.

Signed-off-by: shaikh.kamal <shaikhkamal2012@gmail.com>
---
 Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst b/Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst
index 76b3aae21eb4..8258a72f00a8 100644
--- a/Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst
+++ b/Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst
@@ -33,7 +33,7 @@ Parameters::
     or it can be passed as <key_string> prefixed with single colon
     character (':') for keys residing in kernel keyring service.
     You can only use key sizes that are valid for the selected cipher.
-    Note that the size in bytes of a valid key must be in bellow range.
+    Note that the size in bytes of a valid key must be in below range.
 
         [BLK_CRYPTO_KEY_TYPE_RAW, BLK_CRYPTO_KEY_TYPE_HW_WRAPPED]
 
-- 
2.43.0

