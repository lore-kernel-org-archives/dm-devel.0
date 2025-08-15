Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C56C2C21F6
	for <dm-devel@lists.linux.dev>; Fri, 15 Aug 2025 07:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755244610; cv=none; b=VCnoITKNlj9BcUCKi31di+DzANbFMmnOesg9wtLRgvrAOwheJUD3vEfBLdSVseZC/shrK/9nN7KzSpJbIY04v5C/u+BNbwnG8bNBdlsbQdMmCsvutDcmVBeueVYcmGTk2iGlo8Mml3tMGVHjxlXcCe1/s3gt/Jzr0FPgHYSzO8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755244610; c=relaxed/simple;
	bh=LhTo5cCdwQe8pulukYwJ1m6eHZbBpd52JQDpSBVReeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k6Bl7DK1PDyU/frcCRWGKXLuOPuZzRhLaA36Xlnkz1mmRZPFmxr9GZex342o+6t5vtEb4usBnLiLDDoVZyP/22CopN0WfThCbyZBkkomP9kNGUrNS45XF2fdmutG8NIS+H4bwvZqDXyK3Wigqi3aQAuEqEp+qwf2KRMho5v1LuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U4cCQgBC; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U4cCQgBC"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-76e2e89bebaso1349033b3a.1
        for <dm-devel@lists.linux.dev>; Fri, 15 Aug 2025 00:56:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755244609; x=1755849409; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+F9NmXtez3GpQw5LIS9Oo9You3cZ7+F/dZD1WEotmBQ=;
        b=U4cCQgBCnZ1vUyXQ+ScNiGQy3+XfMaLUhIJo3MXF6FV2AB9/ieVBSqkqlezdTD0JoQ
         aU2tdh7TKo0V/ofnjShmDSOyw2ZdWXNYtWjcGbnNh5hCQf8F3ya6+q15PHddNlbnVxc5
         KifPiSUTRKpSGhe5g9A/UdFT0iHuHqcNojj2tHWNQO66z5pR1kjfxH5tMz9MN2yHHGQ1
         OMtU4l0sSVWBOF2VZvOgV2K/uw/d7f3pl3ZXOQX0a6WX1COVe9tCJAtw5kwTKMSaJRJ+
         /BkbVO5g/BbsibV207BOYCXIoSpWBTfct8bLGvQmyoA5LWufUHC2UJ342TaLLclr4hq0
         Qnkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755244609; x=1755849409;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+F9NmXtez3GpQw5LIS9Oo9You3cZ7+F/dZD1WEotmBQ=;
        b=uLIhtImiAfCaxrt9XrTe2zcjaGrby8EJQsZXfvJYI3F6ulCuD9lp94NI7qEAKM1z8v
         6z1Abt1EL3H2QVEQf7s3jAGDJpP+nyRVVY4RLtpMR2aVaNs++cDPOs8BBlHyAVZP3BLO
         p0ZOh/QR0lOM0wJJo2Cxk0Q4bMOidVSW+nlZ8YWMeaWq+aQIWCevyWFi8luQleGBSy8Q
         prg3o5PjprecfziUjJrw8udxfFoe4GyfnM5nmmlYyaYMjqh1eiSoUoIPuYQdkr56Hj9n
         EXHyvpcdb0CI/uyQTqiHBwOl2/TiRjviCGFB8oI5GHT8qpvHumaiTk4VGFWffSE2RqBC
         nmjQ==
X-Forwarded-Encrypted: i=1; AJvYcCVd+1y9LNpsByZ068Gheb+UZXMMqBLWwVR5gkmLaFdVMGhmM48kkC2X2XYa4YU8QnLNwTt+re/IOg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yxgty5frqH9z4GMzYDrUUGjU93D8McfgAa+UCUASKmi66ofcTSV
	8diw3v0UsXr8yeacm81YoT1tBrbYaC3ANKj24SEEujHDGEb+BFKDjg0w
X-Gm-Gg: ASbGncsyVm4dAP3HWgHtyBg8CRZBc02XHfX+u2VKEJ4hAVyhoLXU2D5fuD8Nb2Rd0qp
	Hsl3zFvFwWOjsBpUbc+8lJVJPwJ0PzX07RIWn3rDszt4yPRi0/r9eZHt1ncRErIKgTKU1pjJRj5
	HUFlmUCcYadeJP2bW9iKbVSay08bfNgvDOefHMqGsaXEuCX2NlbE93kshn3pJSC/6Nr5vWQRu9e
	fN7fOyRygRQv5wuKDzssKXs4jRgKdtcC0i5P0Uf2Jf4YNk4TFM8ANOl8UMbA1+squYeZXwhB1Pw
	r8t2XBuST0rQZ/AXJdCHwwPBc9fv3Vq0sDWhFE9uqBxiCt6wwWdJwD4/+MwMdcAkQ/VO4IkGiHf
	r/coSncUN9OXCu4/Fpck4wg==
X-Google-Smtp-Source: AGHT+IG2n5h40h0uXDvhOaYG1ODrl6MH66mS0Kg0YJ2Fc6MbnZC5W+akAaB8uZW/JgLmbU+Z8yK1Xw==
X-Received: by 2002:a05:6a00:993:b0:76b:fd9d:853d with SMTP id d2e1a72fcca58-76e447bf915mr1371167b3a.14.1755244608609;
        Fri, 15 Aug 2025 00:56:48 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76e45292dc1sm587699b3a.50.2025.08.15.00.56.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Aug 2025 00:56:47 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 2B3EB42BF64F; Fri, 15 Aug 2025 14:56:40 +0700 (WIB)
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
Subject: [PATCH 1/3] dm-pcache: Remove unnecessary line breaks
Date: Fri, 15 Aug 2025 14:56:14 +0700
Message-ID: <20250815075622.23953-3-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250815075622.23953-2-bagasdotme@gmail.com>
References: <20250815075622.23953-2-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3370; i=bagasdotme@gmail.com; h=from:subject; bh=LhTo5cCdwQe8pulukYwJ1m6eHZbBpd52JQDpSBVReeY=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDBnznq9XeaPT6ddyxvznDt+WUuX/07Z5cE+YENi4cufF2 jXZquqFHaUsDGJcDLJiiiyTEvmaTu8yErnQvtYRZg4rE8gQBi5OAZjI+lyGf/pbZkxcdY+ff7Xm 0vMFG9oTpi0tzT3Lfl3geHvzYeN9N/gY/nCs/fxc/TBncZFI1oe4ac8iHrQ8vvOE+ev1PHfD+hm Ld7IDAA==
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Sphinx confuses line breaks that are placed right before section
headings with title heading overline. This causes htmldocs build to spit
out markup error:

Documentation/admin-guide/device-mapper/dm-pcache.rst:27: CRITICAL: Title overline & underline mismatch.

-------------------------------------------------------------------------------
Constructor
=========== [docutils]

reStructuredText markup error!

Remove line breaks to keep htmldocs building.

Fixes: 6fb8fbbaf147 ("dm-pcache: add persistent cache target in device-mapper")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lore.kernel.org/linux-next/20250815130543.3112144e@canb.auug.org.au/
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/admin-guide/device-mapper/dm-pcache.rst | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/Documentation/admin-guide/device-mapper/dm-pcache.rst b/Documentation/admin-guide/device-mapper/dm-pcache.rst
index e6433fab7bd64b..ecd015be798243 100644
--- a/Documentation/admin-guide/device-mapper/dm-pcache.rst
+++ b/Documentation/admin-guide/device-mapper/dm-pcache.rst
@@ -24,7 +24,6 @@ Quick feature summary
 * Pure *DAX path* I/O – no extra BIO round-trips
 * *Log-structured write-back* that preserves backend crash-consistency
 
--------------------------------------------------------------------------------
 Constructor
 ===========
 
@@ -57,7 +56,6 @@ Example
 The first time a pmem device is used, dm-pcache formats it automatically
 (super-block, cache_info, etc.).
 
--------------------------------------------------------------------------------
 Status line
 ===========
 
@@ -97,7 +95,6 @@ Field meanings
 ``key_tail``                     First key-set that may be reclaimed by GC.
 ===============================  =============================================
 
--------------------------------------------------------------------------------
 Messages
 ========
 
@@ -107,7 +104,6 @@ Messages
 
    dmsetup message <dev> 0 gc_percent <0-90>
 
--------------------------------------------------------------------------------
 Theory of operation
 ===================
 
@@ -151,7 +147,6 @@ If ``data_crc is enabled`` dm-pcache computes a CRC32 over every cached data
 range when it is inserted and stores it in the on-media key.  Reads
 validate the CRC before copying to the caller.
 
--------------------------------------------------------------------------------
 Failure handling
 ================
 
@@ -163,7 +158,6 @@ Failure handling
   rebuild the in-core trees; every segment’s generation guards against
   use-after-free keys.
 
--------------------------------------------------------------------------------
 Limitations & TODO
 ==================
 
@@ -172,7 +166,6 @@ Limitations & TODO
 * Table reload is not supported currently.
 * Discard planned.
 
--------------------------------------------------------------------------------
 Example workflow
 ================
 
@@ -196,6 +189,5 @@ Example workflow
    umount /mnt
    dmsetup remove pcache_sdb
 
--------------------------------------------------------------------------------
 ``dm-pcache`` is under active development; feedback, bug reports and patches
 are very welcome!
-- 
An old man doll... just what I always wanted! - Clara

