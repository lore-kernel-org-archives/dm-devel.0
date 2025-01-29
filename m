Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74742C2E0
	for <dm-devel@lists.linux.dev>; Wed, 29 Jan 2025 12:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738155549; cv=none; b=AKmHNwbyjt3/2T7BlFmz0IWHLbtdbpTGcZ6axGd22glhxssbfIm89fCOZyq8tum3kj5lDqe61gL778sxRUzpfJ/A4LkoYrhuBaVEts8HrgBtfCzTwvrIu3SU+7XUXZTnR+Vj6W+Ps3nsj0DVGbq0U31oOWANtXMxoyb8xIf3J9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738155549; c=relaxed/simple;
	bh=mn/Iu4vck2zoNoFdfEsTsKoU50+fcOBn+RnOc9kbLd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=su0Zstq/m+nOq6pArxhKtTuIgW7yxM+iacrjvK98s/rgFB0aEeW8U8nL+MgGpMmHXnk/UJwgKi8wCm9+XMbF+AC1JGB3PiNzFTn1ARuqTkefgyfbSsuDw/sQHzX+wixFnZhIlDvIsUC7iAWOrRXJQPirttskoxv8ZL1PCwXkUls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a4jyPAaY; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a4jyPAaY"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5d96944401dso11302134a12.0
        for <dm-devel@lists.linux.dev>; Wed, 29 Jan 2025 04:59:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738155546; x=1738760346; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G40G1T9SUUvupscQgoMk+NwyLFLkXFcpsWcAlUwTaJI=;
        b=a4jyPAaYMBjxpHXgmUcpBx6fdMpEie05vtw2R2pUhtdSO6lKsdKgBvutSTzd9hy3C1
         8PI+lDkH5UL0bgBV0PQF9GYeUefJXgCimlhhcjMf/U8YxiJIdNjkFweiMKGNAwZVZZLL
         Edy2En+daVry/tmK8Fh2PVGSxI+BUmJGuodeeTbyP/T5pCf2YNKG+lJf9JQFQFHbQfgV
         9N1H6oDNmQe31FetcvRYLm73oz+vcLch4RZ6Zrd5l6FDx1ykOwQM07Sufkq5u4caeZ7n
         MMSo8/Hr9qr08UzVr5oxumYOCu9FdqpfJSxfcCPcgW3kyJmK3hQwBoKdN3WWBxRelu2a
         6RQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738155546; x=1738760346;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G40G1T9SUUvupscQgoMk+NwyLFLkXFcpsWcAlUwTaJI=;
        b=EHbOm3C1baStVg1LgrXXB2r3Q9a2x/vyR1ogMfInUwKC4h0qEFI2vse8N6pKM0dG7J
         mF36+Pp7nZBziNGS2aj2YUx2pOLMMb6xZTBVRSEq6MXJlyu8pStN7zWKPSyLICoeY19k
         O4Wwx8XpqPDH/vFPn+SHPtOGs84mHxIZufzwIo5DlApoWi1bqr+UY8vcaAWJCLfqGZ7v
         r5o+R0Q7TuQlBsILWsBoZQdYGo6IXaPoWXol+RllzvASxLO8zoNXHAwgIHc1NpzeF1Nk
         Yg+e0BzUUP8K5qor5JC1oExsQP/KEfngdkYwTrNEn4uHKTZKs6sTrM15bKrMc4ERogMd
         z55A==
X-Gm-Message-State: AOJu0YxqQf4GmivtGnmR+pssNZDjJWsdhELyw13IwkfHELynqiWP9YMe
	zbI2Q1CniHQjZm3hq2kRR6gb8fDQXa1Vln7vuJX9EEu9fM15hFV1Vn4Rqw==
X-Gm-Gg: ASbGncsY69zEjBWr1WMKJLTzsFiFSUC9Qhfw8z5cZXlG9Rdb8ENnZSiI60gzVqoYfrs
	RaPZKOkUF42+B7qCtyKxuPuMhh/pIgni+Zsv0KKeOcixaBRW5r1JfUeApqnWuXpabip5xTk2tw/
	t47mOHzRdPT4Re1kEeOHhSIVjxGepFiTRm3XSv8xcFXDlXNorL3OSY5+wXL9xuhjt7WBm/+2Muw
	+OqZJYqbkQcWo9mpeV3cRLHA+AKjfj8RoYGr2TZj20LIJhji4TJRa3Hl6s4/+C+4ksjxIwZVpZT
	ETwGohUVs7e/JJ9GbaWeVQ==
X-Google-Smtp-Source: AGHT+IF62U0Vtl/z45QR0pI+nCippifMDlXOvbjODPi2TutH+2nK7nzwydBin9WcrJBv4ZuyFKfRxQ==
X-Received: by 2002:a05:6402:1ec9:b0:5d0:e410:468b with SMTP id 4fb4d7f45d1cf-5dc5efa8adamr2647746a12.2.1738155545680;
        Wed, 29 Jan 2025 04:59:05 -0800 (PST)
Received: from syrah.fi.muni.cz ([2001:718:801:22c:1369:c402:50e6:7236])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5dc186c9115sm8537417a12.54.2025.01.29.04.59.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jan 2025 04:59:05 -0800 (PST)
From: Milan Broz <gmazyland@gmail.com>
To: dm-devel@lists.linux.dev
Cc: Milan Broz <gmazyland@gmail.com>
Subject: [PATCH 3/3] dm-crypt: Document integrity_key_size option.
Date: Wed, 29 Jan 2025 13:58:57 +0100
Message-ID: <20250129125857.252448-3-gmazyland@gmail.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250129125857.252448-1-gmazyland@gmail.com>
References: <20250129125857.252448-1-gmazyland@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch adds documentation for new option introduced in commit
4441686b24a1 ("dm-crypt: Allow to specify the integrity key size as option").

Signed-off-by: Milan Broz <gmazyland@gmail.com>
---
 Documentation/admin-guide/device-mapper/dm-crypt.rst | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/admin-guide/device-mapper/dm-crypt.rst b/Documentation/admin-guide/device-mapper/dm-crypt.rst
index 9f8139ff97d6..4467f6d4b632 100644
--- a/Documentation/admin-guide/device-mapper/dm-crypt.rst
+++ b/Documentation/admin-guide/device-mapper/dm-crypt.rst
@@ -146,6 +146,11 @@ integrity:<bytes>:<type>
     integrity for the encrypted device. The additional space is then
     used for storing authentication tag (and persistent IV if needed).
 
+integrity_key_size:<bytes>
+    Optionally set the integrity key size if it differs from the digest size.
+    It allows the use of wrapped key algorithms where the key size is
+    independent of the cryptographic key size.
+
 sector_size:<bytes>
     Use <bytes> as the encryption unit instead of 512 bytes sectors.
     This option can be in range 512 - 4096 bytes and must be power of two.
-- 
2.47.2

