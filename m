Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD84C182A5B
	for <dm-devel@lists.linux.dev>; Tue,  9 Jul 2024 21:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720561191; cv=none; b=nsRP4fTlSOfGk21r1PtUgGYDTe7iCMgKgMIqppe35WOboC/XOVkedwMDHoQp8+bUdluml3igx2ovSNQWlCUk+C8NzQuynxLeR2kcT/iSLZHWVfdgNB8LmHQYchi74uczVxm8Z9NOvnkk2v2M0saWM1eelPp442pzjDRNghJUiLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720561191; c=relaxed/simple;
	bh=5NuwC02vKg35zEqPIbpUxzIHZqWrqaXVkG+0U7nlYjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KHrcLiyvnY0YnaaC1Uk/x8iVmzu0gq/ZKlt+bwrUWk3LNqxut1Ga8Usgwfcb7Aef27dkYCrMI95ocDha5T/pJrYFpy9woI4bpslAnq/AHrvOS6DJy4+pZtJArYqUmBfFdPEsxTaswa1IgDmDx9DYljxCsZjTppAxU207G7cXr2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SXY8oTpt; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SXY8oTpt"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-58bac81f40bso7513834a12.1
        for <dm-devel@lists.linux.dev>; Tue, 09 Jul 2024 14:39:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720561187; x=1721165987; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zDpgdxQTbPJ5rdGlBdKaz6zmfU8E+UbT1GSD1jQiPeU=;
        b=SXY8oTpteCycII8RsycKPlZ+ACc41crxtDtbatqYTsQyVczBHtZyq/FR2FbXm6+sQb
         H4Tv/NVr77WKECslpnT2y6LYuLtf1c1ahz7rYIMItZeO1GnNRapVqLDFYX+3S06dTGYH
         sgjkhssSlhHaKPJnRZPk145TTrl4knmVcZ6LwgNdUN04UzMv60IKIQTs71eWBWRZHaaz
         bg+25mxQBEfa5S7z0jvATzpGvIdgYjNrfpoFlf+/O983j/FI4OVqPBU4v7QHfPl7/Pii
         9HwHMy/rQjyT4lwi6cYwaV7GslPwEOMNBdkNo3D40VXNrc24PIRe0ApYcZ8HF8dtw60W
         ypwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720561187; x=1721165987;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zDpgdxQTbPJ5rdGlBdKaz6zmfU8E+UbT1GSD1jQiPeU=;
        b=U18exCPtRVAZmnUk/EGlgbdYn/wGvfCMigDVzCeTks2YEY293TLVVaCQJwZppTvduZ
         Oc/+yMDfMfMLHAkPjzSCCfE+mZAsmzHYBiv9tgHY+dt7kyHMI/lG33GFOPVHGyjzLXzq
         IwgIjABfo0gZTE697/PeqzvcY2UA11KDqAd3Uo1IzLtnaxtWfFXRJ8L7SE5yZ2jeQ2tC
         rQnCMAqtVF9PDz3VhuOERrJixbSA0Q3hWCRAxlvcXL2iAelIxZRecaLdpEmYvXl9D9oC
         U4gjXsiaNUXtw7iBrO0101gIPBDmH1bAHQ39x9IOZN3Xzbnv/aJRrnZXXCXGNbrKViv/
         hLow==
X-Gm-Message-State: AOJu0YwPIWDP1G1xzqJHL8F2ASNcWBIUsa/Dva1R2A3c66S+TOjY+2wy
	gwoGXBMphTa6HnWUoktFSgX373PIezxnLe3Af9k6ejhr23MhGT5j7LK0jGWn304a2PtendmjqQg
	N
X-Google-Smtp-Source: AGHT+IEWnEYFyWiAjoCHDwLAryYYgh7bAHGGAjsFuXP8mYZK2EQLeElZXrrVsx11szq0LPf5HelnOw==
X-Received: by 2002:a17:906:2342:b0:a77:e1fb:7dec with SMTP id a640c23a62f3a-a780b6b316dmr212995866b.17.1720561186853;
        Tue, 09 Jul 2024 14:39:46 -0700 (PDT)
Received: from localhost (p200300de37360a00d7e56139e90929dd.dip0.t-ipconnect.de. [2003:de:3736:a00:d7e5:6139:e909:29dd])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-594bc4e80c6sm1500983a12.46.2024.07.09.14.39.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 14:39:46 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 01/44] multipath-tools CI: more fixes for arm/v7
Date: Tue,  9 Jul 2024 23:38:52 +0200
Message-ID: <20240709213935.177028-2-mwilck@suse.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709213935.177028-1-mwilck@suse.com>
References: <20240709213935.177028-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The previous fix for the CI under arm/v7 was incomplete, and actually broke
the tests under openSUSE Tumbleweed. Closer examination showed that the issues
were caused by Debian's move to 64bit time_t on some 32 bit architectures [1][2].
This effort causes _TIME_BITS=64 to be set by gcc internally, and introduces
symbol redirections for libaio [3], on Debian with gcc 13 and newer only.

Fix the conditions for symbol remappings in wrap64.h.

[1] https://wiki.debian.org/ReleaseGoals/64bit-time
[2] https://salsa.debian.org/toolchain-team/gcc/-/commit/d82fb8a8ab7b84f61fb8290a2c3aa2e3f54e7b8a
[3] https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1062218

Fixes: 6a7524a ("multipath-tools tests: fix CI failures on arm/v7 with glibc 2.37")
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 tests/wrap64.h | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/tests/wrap64.h b/tests/wrap64.h
index 7e43420..890fae8 100644
--- a/tests/wrap64.h
+++ b/tests/wrap64.h
@@ -47,7 +47,8 @@
  * fcntl() needs special treatment; fcntl64() has been introduced in 2.28.
  * https://savannah.gnu.org/forum/forum.php?forum_id=9205
  */
-#if defined(__GLIBC__) && __GLIBC_PREREQ(2, 37) && defined(__arm__) && __ARM_ARCH == 7
+#if defined(__GLIBC__) && __GLIBC_PREREQ(2, 34) && __BITS_PER_LONG == 32 \
+	 && defined(_TIME_BITS) && _TIME_BITS == 64
 #define WRAP_FCNTL_NAME __fcntl_time64
 #elif defined(__GLIBC__) && __GLIBC_PREREQ(2, 28)
 #define WRAP_FCNTL_NAME WRAP_NAME(fcntl)
@@ -60,7 +61,8 @@
 /*
  * glibc 2.37 uses __ioctl_time64 for ioctl
  */
-#if defined(__GLIBC__) && __GLIBC_PREREQ(2, 37) && defined(__arm__) && __ARM_ARCH == 7
+#if defined(__GLIBC__) && __GLIBC_PREREQ(2, 34) && __BITS_PER_LONG == 32 \
+	 && defined(_TIME_BITS) && _TIME_BITS == 64
 #define WRAP_IOCTL_NAME __ioctl_time64
 #else
 #define WRAP_IOCTL_NAME ioctl
@@ -68,7 +70,8 @@
 #define WRAP_IOCTL CONCAT2(__wrap_, WRAP_IOCTL_NAME)
 #define REAL_IOCTL CONCAT2(__real_, WRAP_IOCTL_NAME)
 
-#if defined(__NR_io_pgetevents) && __BITS_PER_LONG == 32 && defined(_TIME_BITS) && _TIME_BITS == 64
+#if defined(__GLIBC__) && defined(LIBAIO_REDIRECT) && __BITS_PER_LONG == 32 \
+	&& defined(_TIME_BITS) && _TIME_BITS == 64
 #define WRAP_IO_GETEVENTS_NAME io_getevents_time64
 #else
 #define WRAP_IO_GETEVENTS_NAME io_getevents
-- 
2.45.2

