Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B123C3C07
	for <dm-devel@lists.linux.dev>; Fri, 10 Apr 2026 13:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775828445; cv=none; b=Rmi0JfNIf7rjdOlZ1ZkOlYHSbzDJax9XxfPxnM+8m0Z0TSUYeC7a4+0QxD2ukc0mcZ/DMWHU70in18GEvSBKKH2kdsidpBtz7f6j94hgwf/RGIskmevqDMgIxX4ng1WJxK5H+x7pZ4E7ZgCbunOpDfQga5HSGUWZnu71gTpSf9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775828445; c=relaxed/simple;
	bh=ZzD48c6YNqTNTxvog2KhjcUYavGruY/dRo31R1J745I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Co2GZ4JWZy2blNjmnHsx05zsDeOqXDoZAzZ0gh84Sqy4zutpu9/Rb0K6rWpx176R8FPwd8xos+bkA2u24XA/ABszjaYvJDlAXCl9ttjJshAfQjedKL3iv5ETLIVPRnnVwAUTOcJJHQRwSPcMgAub6OBRJuiGj+8an4S6D9xP2Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=GISwSpW9; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=UsmAoJsk; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="GISwSpW9";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="UsmAoJsk"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63AAKDTZ2698454
	for <dm-devel@lists.linux.dev>; Fri, 10 Apr 2026 13:40:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=4/G7uDRt/NN
	5uhqO8B7jr/VAfO0+XnKeOAa+4ruW6IA=; b=GISwSpW9PL/WB+EIKDmDd5ONuKn
	Oz2E254irHMF71/LzvvEz3+ZhGBZmNcSUC0ywboTcfQC1yQGkCB0BcZp1M80OlQz
	K+W4ds/tueKzDQbPt4Y5GY7EXFythgbht49+MLaucVo2CuLPVrn5IL0rqV4l3osa
	2G/h1BRtKFuLSx79Ifwr1BaQ/pkuTi8hMVgiY8YwAPnRv+ZWzQ+pRgGt1Kquz4f8
	jKWqZA9n8l+j6ie8egkI6R5fet9eLFmaYs4/fPSwjt/aXl+7yVRfh4KKL8nzd9X5
	Qd2fHES4XslHPKNs/EiYlxMZb4tfRiEDM6VoAdJCI2/zMMHzyZxS9CoWhTw==
Received: from mail-dl1-f71.google.com (mail-dl1-f71.google.com [74.125.82.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4degt9ub1d-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Fri, 10 Apr 2026 13:40:41 +0000 (GMT)
Received: by mail-dl1-f71.google.com with SMTP id a92af1059eb24-12bf9974587so1027959c88.0
        for <dm-devel@lists.linux.dev>; Fri, 10 Apr 2026 06:40:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1775828441; x=1776433241; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4/G7uDRt/NN5uhqO8B7jr/VAfO0+XnKeOAa+4ruW6IA=;
        b=UsmAoJskykoUHRQq8trp0KmEOZ+9uY95qmg1TFDfHegeDbalhx9YtupToEs1i4Gnk4
         7Cy9UiSWG8pHtOECuoE4zLUw3OBngApdOlbzvy7+TwoVSt+0YXQtGvmng9XSygF7yLpT
         lfaPymro3att37pG4isOaKkHuOzG5LeBnwXxuP2b/l71UlYuIbNLQ1PAcItZDZ52rRLL
         DRWtTSYmMRm9XVwcu6sTSXG50PCxtBvp8C++yiDkZ+JeySNFP4C8PeWm8HBuv86UtPay
         YZMv/Vm91YZmbEgyqRN1hCkIFqFpGqq9RmeBTaLEsZwsOrrYMLZKI19JYa8oowUyXQ8K
         SHww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775828441; x=1776433241;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4/G7uDRt/NN5uhqO8B7jr/VAfO0+XnKeOAa+4ruW6IA=;
        b=cLhYE80xYq4KT7c20uj5gOiD9HgwaVfzLua72hd/Y9QFvtx+/6S1HSrqww7CEw9u4U
         FMs83+U0w4EHCb79+jVnUw81Umtw4+N9CSY9nyZu0VQXkYok1Jgx+xHZz6CQVCKuPl2k
         ozA6tSAQFK6QBKO2mRD3KG0EfEFDW7LhjbGmzqUAlLZG08JDqlKNSujbptXp6uZ2hJp2
         AC2SIwSXwRn2a89LP6No+UOIx5nevSIVqkBUWlDqeqyGML/nYhI5JOeU0kppp4Gok8JR
         V2GC6xn/Gh49FDpaLayTbunh4O4VYAOfOcK8eaAifJfy3f8VuXsojfzA3DzkzI45jz4/
         q/Qg==
X-Forwarded-Encrypted: i=1; AJvYcCU9YXRbXXMS/QfC2JEkzWlzh0prNz/ORj/x9XBvy3qyoCYuuWwrsLe44y7rQnZZnFtOCTb2RgjIpA==@lists.linux.dev
X-Gm-Message-State: AOJu0YzsbMQOCYFKUjQlsv/QOgA4Zsg0hBvWRtJsID6lSUYTxhjnPBLO
	KiHfeZTLczkFN6C+p2XqAJKzrTfRIfyOtkprmbzJhhNKQ4U1M7Ro1iiW8vUkUtfR8XXkFYwmcmg
	5TDR4HjmOX3FnW528S9HluB64AFeZNIoBHSndrI2Te4hxbsvQI3ooD/qrk7Kwkw==
X-Gm-Gg: AeBDiesIV68dgJfiV6Cyb8cn9bE3aAiUkKmSlpkEUn1rk7OdJH+tF4irblk1BKTR1JW
	LEMD2DI8XB0saugnrHGqrhv8of7HUoI9NX1KyzX0qWuksy2zsjYpXmut6VefSnvfrdmckJarJCb
	rrHi7Lw9UlM4l5+r+0nvHJHZpA40vIIoC5GOTESezQWdXFCnORsOqjDnbAGnqS2Z+sYD3wQnman
	3PupmhsXEEKptDydLGgENX5g5vGBXCbAHEBT7v9rRLp+C+mlH6xeyxr86Rs3RsMRwH7VEDPX/Zk
	gUIOYTmGG/Dcr0ppHsFDYf8nvEarr65sWBSQzFmX0GXv7maC9XngahsJJ43X/9ZUzUVZHK8148V
	S/Az9J6Rk2JaDlfN+Mk4af0+InrBJB+rKLC4rvyjC91B6osPlHRExax+pMRFK6yYGebxVGuIXGL
	RAXWW6
X-Received: by 2002:a05:7022:790:b0:11b:b179:6e17 with SMTP id a92af1059eb24-12c34f07ce4mr1827735c88.34.1775828440731;
        Fri, 10 Apr 2026 06:40:40 -0700 (PDT)
X-Received: by 2002:a05:7022:790:b0:11b:b179:6e17 with SMTP id a92af1059eb24-12c34f07ce4mr1827703c88.34.1775828439906;
        Fri, 10 Apr 2026 06:40:39 -0700 (PDT)
Received: from u20-san1p10573.qualcomm.com (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2d561bde70csm5172631eec.15.2026.04.10.06.40.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 06:40:39 -0700 (PDT)
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
To: linux-block@vger.kernel.org, ebiggers@kernel.org, mpatocka@redhat.com,
        gmazyland@gmail.com
Cc: linux-kernel@vger.kernel.org, adrianvovk@gmail.com,
        dm-devel@lists.linux.dev, quic_mdalam@quicinc.com, israelr@nvidia.com,
        hch@infradead.org, axboe@kernel.dk
Subject: [PATCH v2 3/3] dm: add documentation for dm-inlinecrypt target
Date: Fri, 10 Apr 2026 06:40:31 -0700
Message-Id: <20260410134031.2880675-4-linlin.zhang@oss.qualcomm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260410134031.2880675-1-linlin.zhang@oss.qualcomm.com>
References: <20260410134031.2880675-1-linlin.zhang@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDEwMDEyOCBTYWx0ZWRfXzrzdefDpc5WR
 1qiMTnpYyqA6QDpot8TYjmP+Roj/yImN3+N4Nsbrw8rt1ZhHwkIiWb5UhVT4gMBh7B2DX/JwJzZ
 AOKql3vEQ3qhZdYXwSIrqGzhsY4JXWkaVeZKSCXGAtmtVUOZYOvK2WMzjLbvmsJge/iY/i/TN90
 jbRFUvgcUXFoP9cbhqg+StAefX++UthQseh6+mrThe6myoy67SPgl9kLqn7LjdZ5gUopmpvUivS
 XUmJvDOrz/5z95wXKjIrMiEj725dsOouBLbJptCRxMfxKoUfFGJ6w+sYD+1Uhss5vHJFSNms/2Z
 +emnYXT4YI96xiuAM6Nb5JlHMVKaE8II0BFPUZJ0xoFoisANJFzhjZKDHDkLJTaLgIQQhZLJkSR
 OMgowen3ILg1OCsvgTfOuByKwvKtpntugwaLgUjNI3U08vpgB2kWjDB0VklWnhKkCSPIf6IOaOL
 e7LnJV6DACMJuYLePIw==
X-Proofpoint-ORIG-GUID: vsgwaN5efR-Wccj8VW32g9_iNw5VlA4m
X-Proofpoint-GUID: vsgwaN5efR-Wccj8VW32g9_iNw5VlA4m
X-Authority-Analysis: v=2.4 cv=BJyDalQG c=1 sm=1 tr=0 ts=69d8fdda cx=c_pps
 a=JYo30EpNSr/tUYqK9jHPoA==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22 a=VwQbUJbxAAAA:8
 a=p0WdMEafAAAA:8 a=EUspDBNiAAAA:8 a=r5tAstHzX-DRmjCks68A:9
 a=Fk4IpSoW4aLDllm1B1p-:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-10_04,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 suspectscore=0 malwarescore=0 bulkscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 clxscore=1015 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604100128

This adds the admin-guide documentation for dm-inlinecrypt.

dm-inlinecrypt.rst is the guide to using dm-inlinecrypt.

Signed-off-by: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
---
 .../device-mapper/dm-inlinecrypt.rst          | 122 ++++++++++++++++++
 1 file changed, 122 insertions(+)
 create mode 100644 Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst

diff --git a/Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst b/Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst
new file mode 100644
index 000000000000..c302ba73fc38
--- /dev/null
+++ b/Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst
@@ -0,0 +1,122 @@
+========
+dm-inlinecrypt
+========
+
+Device-Mapper's "inlinecrypt" target provides transparent encryption of block devices
+using the inline encryption hardware.
+
+For a more detailed description of inline encryption, see:
+https://docs.kernel.org/block/inline-encryption.html
+
+Parameters::
+
+	      <cipher> <key> <iv_offset> <device path> \
+	      <offset> [<#opt_params> <opt_params>]
+
+<cipher>
+    Encryption cipher type.
+
+    The cipher specifications format is::
+
+       cipher
+
+    Examples::
+
+       aes-xts-plain64
+
+    The cipher type is correspond one-to-one with encryption modes. For
+    instance, the corresponding crypto mode of aes-xts-plain64 is
+    BLK_ENCRYPTION_MODE_AES_256_XTS.
+
+<key>
+    Key used for encryption. It is encoded either as a hexadecimal number
+    or it can be passed as <key_string> prefixed with single colon
+    character (':') for keys residing in kernel keyring service.
+    You can only use key sizes that are valid for the selected cipher.
+    Note that the size in bytes of a valid key must be in bellow range.
+
+        [BLK_CRYPTO_KEY_TYPE_RAW, BLK_CRYPTO_KEY_TYPE_HW_WRAPPED]
+
+<key_string>
+    The kernel keyring key is identified by string in following format:
+    <key_size>:<key_type>:<key_description>.
+
+<key_size>
+    The encryption key size in bytes. The kernel key payload size must match
+    the value passed in <key_size>.
+
+<key_type>
+    Either 'logon', or 'trusted' kernel key type.
+
+<key_description>
+    The kernel keyring key description inlinecrypt target should look for
+    when loading key of <key_type>.
+
+<iv_offset>
+    The IV offset is a sector count that is added to the sector number
+    before creating the IV.
+
+<device path>
+    This is the device that is going to be used as backend and contains the
+    encrypted data.  You can specify it as a path like /dev/xxx or a device
+    number <major>:<minor>.
+
+<offset>
+    Starting sector within the device where the encrypted data begins.
+
+<#opt_params>
+    Number of optional parameters. If there are no optional parameters,
+    the optional parameters section can be skipped or #opt_params can be zero.
+    Otherwise #opt_params is the number of following arguments.
+
+    Example of optional parameters section:
+        allow_discards sector_size:4096 iv_large_sectors
+
+allow_discards
+    Block discard requests (a.k.a. TRIM) are passed through the inlinecrypt
+    device. The default is to ignore discard requests.
+
+    WARNING: Assess the specific security risks carefully before enabling this
+    option.  For example, allowing discards on encrypted devices may lead to
+    the leak of information about the ciphertext device (filesystem type,
+    used space etc.) if the discarded blocks can be located easily on the
+    device later.
+
+sector_size:<bytes>
+    Use <bytes> as the encryption unit instead of 512 bytes sectors.
+    This option can be in range 512 - 4096 bytes and must be power of two.
+    Virtual device will announce this size as a minimal IO and logical sector.
+
+iv_large_sectors
+   IV generators will use sector number counted in <sector_size> units
+   instead of default 512 bytes sectors.
+
+   For example, if <sector_size> is 4096 bytes, plain64 IV for the second
+   sector will be 8 (without flag) and 1 if iv_large_sectors is present.
+   The <iv_offset> must be multiple of <sector_size> (in 512 bytes units)
+   if this flag is specified.
+
+Example scripts
+===============
+LUKS (Linux Unified Key Setup) is now the preferred way to set up disk
+encryption with dm-inlinecrypt using the 'cryptsetup' utility, see
+https://gitlab.com/cryptsetup/cryptsetup
+
+::
+
+	#!/bin/sh
+	# Create a inlinecrypt device using dmsetup
+	dmsetup create inlinecrypt1 --table "0 `blockdev --getsz $1` inlinecrypt aes-xts-plain64 babebabebabebabebabebabebabebabebabebabebabebabebabebabebabebabe 0 $1 0"
+
+::
+
+	#!/bin/sh
+	# Create a inlinecrypt device using dmsetup when encryption key is stored in keyring service
+	dmsetup create inlinecrypt2 --table "0 `blockdev --getsz $1` inlinecrypt aes-xts-plain64 :64:logon:fde:dminlinecrypt_test_key 0 $1 0"
+
+::
+
+	#!/bin/sh
+	# Create a inlinecrypt device using cryptsetup and LUKS header with default cipher
+	cryptsetup luksFormat $1
+	cryptsetup luksOpen $1 inlinecrypt1
-- 
2.34.1

