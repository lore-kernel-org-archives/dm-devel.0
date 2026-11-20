Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.227.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795193194;
	b=cx+ssHEXdyTZISzj0EgIYFC30sglaZHiMTfxsuVWW+P4zKR41h2x/RDzTDvLYfj9h6rG
	 SEGHqEFlI6vRtk6rQIHuURYaOe1kJdutFW+eyCxpzhxdSu7We1a+oOdrj3epVqzy1oFNb
	 cOC/hRYoAUTGX2ADHPNzbEt/NrQi54wA6cXJPBkiGRTioDSsi4zdr/ISGdJcu32wII3BL
	 YSWjFFvdZdPng8Fm4oWdY1WAVfwWu2Qltj8QyFuBT0GQCpF30U9H6gxWOFvdzwU/5KzN8
	 mEA+01rZKU67tZ2TRxwa9BLn9VOeNcxlBZIJojiMJ6HvF5Zno/Q6r1rwaDcPj1tdQvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795193194;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=cVr6BO8LwnEwZj8CTAB9lfzXGWtsY28dFZWdaaxR7Ww=;
	b=W3hdMhTUOUWn3/x0EYf6c/UssD1GkKYe23DRw219Q/zQ9WdncBV8JLSZT5ieR9/pGeuT
	 tD3IU4tX3KtlDBGUidKUFaXE0zWReBHj1ex4PLSlBFiMNrm5qO9f1PO9vXcReqcDHu62t
	 D5l3hmbi/DeEhnV0ue5NTQJkj3cuv8uakbm79/Q0e/YTUMrWuI6qJTKDc+SpFUXM4ui0f
	 WkHhNZTIE13ymWPZblwRamfsJOz7l1VlWTFtYvJPWQfawQSLBO7S9/k9FZcLCjAF6Idzp
	 GfNYVvr7fVYhlcYgkKK15CV4kuJsW19zVg4senTvN6bXTv5AvUrqsYCyQc+1OatWFzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HEw8suiv;
	arc=none smtp.remote-ip=74.125.227.133
Received: from mail-pj2-f5.google.com (mail-pj2-f5.google.com [74.125.227.133])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B88606A32A
	for <dm-devel@lists.linux.dev>; Fri, 20 Nov 2026 16:46:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 19B88606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HEw8suiv
Received: by mail-pj2-f5.google.com with SMTP id 98e67ed59e1d1-3b41c8d9767so579595a91.1
        for <dm-devel@lists.linux.dev>; Fri, 20 Nov 2026 08:46:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795193193; x=1795797993; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=cVr6BO8LwnEwZj8CTAB9lfzXGWtsY28dFZWdaaxR7Ww=;
        b=HEw8suivdBYJbLlBplmDe8U2STSAW7OoEJ42cWeEA/Sw3bmVOY2ZtI5HxcGZgR4jAP
         1CS1WsGmguIJm09dl8UKG0Rw0JfLC+bWpgQGN1/inF1XxPzHPKX06sJ+CYoPwxhcy9Bi
         0cXZKH8tFvoQ/zdFqHTWHGJCdHa757IWwzod8tOobuf4U66isBIESKn31gHMwh4oQUQt
         ah//UaU9R4JJnoRUkgFSPcHP8V/Ncgsqn/SuSBV7Ax1ncEZLh6vtV/QCJv8NunO92aSu
         qCn2YyEZuzpOMr4E+Dd55S87eShUEJwgs0itoAUt7FusdVLbw8aiIlM636YRUyqklpw3
         KV6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795193193; x=1795797993;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cVr6BO8LwnEwZj8CTAB9lfzXGWtsY28dFZWdaaxR7Ww=;
        b=OmSA144qwUUr1QWXtWxpi2HDYB8utHKipKYUtwm9lhpyw/s94cUiDuixsm5cFP7f/Y
         0aRLcWrtGzr+pYxE0s1K3AEFfima/yLZv0HXw9rz06qxt2qnbCX1WDCFQiwnqE9+NNmW
         Ie9pDVJ9caH3DyTSSPXzzcmh1mcTgUq6tulkGV0T3lzL8w5GJj/jFxL+9XRfyCWjQFvG
         se3paz4qcvZOXyMWQpucupkHI66nbH0qj1Kx1dSscVHSIOlKmwlKtQZmyKT1mBKX6jRp
         6nK34LnjGUewh1wXEuqhiWrh8ikMrin7Ps6ST0mGKhJyqxAaPzF7m5j+z4LlDzypoF5Z
         xV6A==
X-Forwarded-Encrypted: i=1; AL+hErGQByN402CNY1hBC0zBh6h5QFL/F5TBCL3OA1HWYTYnF24sB7Ol4n6Ca1NGKCG1e2TTyfapsok4Og==@lists.linux.dev
X-Gm-Message-State: APuU4Z8gVibFMn/NQLlq/Y0YOtPK3zOkbCcX+m8FOeS8O2L/T20I2LAN
	+lCm6SChCm2xOWPje2AncztC26R3I8+E5msRx+zybI1AQfjPZfQRFqv4viypcds=
X-Gm-Gg: AZFdTZd1SSfW+PQjzrZTZyzCNuwiqhIqT/45GFTFrc5szk1PVT6vteAM+D0cWgHrP6d
	Hf/cm8lqI8lku+OeLNQzCuZJmEpnFYwY8eNxQ8AyJ2oi0oFCu9PAHT8KlnJg+BeToshgZMv1ebE
	0cevgiZem/vI3+b2Vslx7VTVdDs/HBj/Pvov9Jt+U0sv32sP3EoKRTNvru0eDesCg64iuXK/bY3
	1Iy1t4wYtfQFUqYoziVQ71BxPdeuCQNSqXPau9MWCgquut9xn4k5wsngZqC0Gpt7wCQixSQOj2e
	BeZldXzoHdsn5JdIkvqLrW04cdWRZ63mCoGZZP9vXGbF0BVV+60+3wS7N7vvGTZlpPo0pq6X/sT
	PDcjDCEFDFCTlfvhHhHe7ugZxEE2Rvn2l4Awit0vwgLnVod/3Bcw3uW7/qPdXRfYMGYcumBJDlr
	8qXThEngmb0Ul66mXj1E1QWbm+25lzqyZPM0nw/aWDvP0SJPm7olZ2Y9X+KJ28CAw3ImgBUhybN
	gHS9ngwg3PFJwCh9y5WCF2mFVDMEcnfUI1kCiskgdM49Lr9lZpkwIXEHzdFD/G+N7XGwXmmjrum
	8LUjopmLT/BiI8JFCm/Trgg2KV6H+vpx8PO+ctA=
X-Received: by 2002:a17:90a:ec86:b0:3b4:889:883a with SMTP id 98e67ed59e1d1-3b41c9bacbbmr3540757a91.66.1795193193511;
        Fri, 20 Nov 2026 08:46:33 -0800 (PST)
Received: from archlinux ([2405:201:ac01:5300:17d2:d5ee:24bc:b49c])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b405d97356sm7903186a91.13.2026.11.20.08.46.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 08:46:33 -0800 (PST)
From: Anvik Loitongbam <permissiontogallop@gmail.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev
Cc: Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] dm-inlinecrypt: emit key type as an optional table argument
Date: Fri, 20 Nov 2026 22:06:01 +0530
Message-ID: <20261120163601.114199-1-permissiontogallop@gmail.com>
X-Mailer: git-send-email 2.56.1
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

inlinecrypt_status() emits ctx->key_type as a positional argument between
the key and iv_offset:

  <cipher> <key> <key_type> <iv_offset> <dev_path> <start>

but inlinecrypt_ctr() parses the base table as:

  <cipher> <key> <iv_offset> <dev_path> <start>

and keytype, is an optional feature argument parsed by
inlinecrypt_ctr_optional(). Resulting in STATUSTYPE_TABLE output for every
dm-inlinecrypt device to be not reloadable, the constructor reads key_type as
iv_offset and shifts the remaining fields.

Keep the base table in constructor order and emit a non-default key type
as keytype:hw-wrapped in the optional feature list. Raw keys remain the
default and are not emitted, preserving the existing table text for
raw-key devices.

The two dmsetup examples in the documentation acquired
the same extra positional key-type field, so removed it there as well.

Fixes: f9f57971da38 ("dm-inlinecrypt: add support for hardware-wrapped keys")
Cc: stable@vger.kernel.org
Signed-off-by: Anvik Loitongbam <permissiontogallop@gmail.com>
---

diff --git a/Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst b/Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst
index 8258a72f00a8..84dd2e6a1b26 100644
--- a/Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst
+++ b/Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst
@@ -119,11 +119,11 @@ using dmsetup
 
 	#!/bin/sh
 	# Create a inlinecrypt device using dmsetup
-	dmsetup create inlinecrypt1 --table "0 `blockdev --getsz $1` inlinecrypt aes-xts-plain64 babebabebabebabebabebabebabebabebabebabebabebabebabebabebabebabe 0 0 $1 0 1 keytype:raw"
+	dmsetup create inlinecrypt1 --table "0 `blockdev --getsz $1` inlinecrypt aes-xts-plain64 babebabebabebabebabebabebabebabebabebabebabebabebabebabebabebabe 0 $1 0 1 keytype:raw"
 
 ::
 
 	#!/bin/sh
 	# Create a inlinecrypt device using dmsetup when encryption key is stored in keyring service
-	dmsetup create inlinecrypt2 --table "0 `blockdev --getsz $1` inlinecrypt aes-xts-plain64 :64:logon:fde:dminlinecrypt_test_key 0 0 $1 0 1 keytype:raw"
+	dmsetup create inlinecrypt2 --table "0 `blockdev --getsz $1` inlinecrypt aes-xts-plain64 :64:logon:fde:dminlinecrypt_test_key 0 $1 0 1 keytype:raw"
 
diff --git a/drivers/md/dm-inlinecrypt.c b/drivers/md/dm-inlinecrypt.c
index 3479dfe5f708..c4a0501e7b9a 100644
--- a/drivers/md/dm-inlinecrypt.c
+++ b/drivers/md/dm-inlinecrypt.c
@@ -522,15 +522,20 @@ static void inlinecrypt_status(struct dm_target *ti, status_type_t type,
 		 * the returned table.  Userspace is responsible for redacting
 		 * the key when needed.
 		 */
-		DMEMIT("%s %*phN %u %llu %s %llu", ctx->cipher_string,
-		       ctx->key.size, ctx->key.bytes,
-		       ctx->key_type, ctx->iv_offset,
+		DMEMIT("%s %*phN %llu %s %llu", ctx->cipher_string,
+		       ctx->key.size, ctx->key.bytes, ctx->iv_offset,
 		       ctx->dev->name, ctx->start);
 		num_feature_args += !!ti->num_discard_bios;
+		if (ctx->key_type != BLK_CRYPTO_KEY_TYPE_RAW)
+			num_feature_args++;
 		if (ctx->sector_size != SECTOR_SIZE)
 			num_feature_args += 2;
 		if (num_feature_args != 0) {
 			DMEMIT(" %d", num_feature_args);
+			if (ctx->key_type != BLK_CRYPTO_KEY_TYPE_RAW)
+				DMEMIT(" keytype:%s",
+				       ctx->key_type == BLK_CRYPTO_KEY_TYPE_HW_WRAPPED ?
+				       "hw-wrapped" : "raw");
 			if (ti->num_discard_bios)
 				DMEMIT(" allow_discards");
 			if (ctx->sector_size != SECTOR_SIZE) {
