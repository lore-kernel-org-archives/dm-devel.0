Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C38C3FE373
	for <dm-devel@lists.linux.dev>; Thu, 30 Apr 2026 09:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777542777; cv=none; b=n4p+9TbIpk21WgoZJReR45UKUPFrEm5dQ+EAi07ReH1wEl9P5nymE7DlJl2priwCrVldstCMiCMDsCDc3Agg+yOPbluSAWruMs3IBW0jskjOxMCvB5ps8adO/j1q1Fzt+gCDt+gfQ8raGr5Ufsyyhrjn6uhJUTA9+KmyaiTxoHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777542777; c=relaxed/simple;
	bh=oKEFlZ7j+cKtRBji8SO0Ip/DJfA6is5IIdXwt6HGb2A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jNQOGIxGxCnhTQwsTVV2iYZjkRpx2v6EwKIn3bIBwV0JWUirq9XyPFhq3y05zOe0mtzWaGAenoGWoCL3o8EnkXT/oAGZvM6XWN+uJ1p1aRGQ/rUIJuBKXYYO242XH1KiNRDYzeFeOmJK6jm1AlXcIYY26B6XWz6IViwJ2VueWaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=eEbBPJFd; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=PDDUjDYi; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="eEbBPJFd";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="PDDUjDYi"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63U8aNTM3732422
	for <dm-devel@lists.linux.dev>; Thu, 30 Apr 2026 09:52:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=lrYikL+96ns
	dg6Sdr1h2bfcZxEJEZfN5XyHVJwCmeaM=; b=eEbBPJFdhlNimEoeJIrVXbHT+Al
	G6aIO1ekVqLK8bATQY4QQJh9Zi20Gjzfzd7UI/MeiirMCdlUzSJDGG4QfvIDp8DP
	5m96YMAn3GluzA7tz0Xc5UkIfF19vsKvVUNs8zMXT23G6uR8h+Y0YWPNkDpOzeBp
	Ieg5OsSHnY3uw9F/DAPMRksGVdsLr9Jjpa3xlsNZhmzVmQ4UPQrE1zJJxkObPmC+
	pGFW2pIaYFE9vfSKtyxVFOU+P4d+Q0pv/p1vwhbTvJrjWcu9y8Qj7qIP+41TyLx2
	+KtWujVXEal1ZNc3KFRR0kqX6ykp5GZTsEvieNWHyvVezSd8d99xKObFwdw==
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4duv3x9x5y-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Thu, 30 Apr 2026 09:52:54 +0000 (GMT)
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-2c0f6593ef5so1070955eec.1
        for <dm-devel@lists.linux.dev>; Thu, 30 Apr 2026 02:52:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1777542773; x=1778147573; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lrYikL+96nsdg6Sdr1h2bfcZxEJEZfN5XyHVJwCmeaM=;
        b=PDDUjDYi3E5Fupdo/KN11L9HCPLhQW6Isuj7Yz+dtFQs02ReQxYgQNqC75oFln2FF6
         gXA1Z7KJO4TnsXD3CqMFhVBVRVpIAvH+LpMboIHOqCCPkwonsn2r/VPTV5xS4hDstB6W
         9qNMr3mrc75yT5WRtgEdIzQgIzfNA5JkI2I3Mx3EHRr/o2xWiiM7U8jcyC68DBGb/eNn
         dqsJZVqDDLUAREkgXU8y+St4wxRQOPKIK//jlD/ORZh+uGY8ohZptusUYSBcGy9XR0Lw
         FTBA8Bf5dPJKZbQsvGQiE5eVrgwg42HfrUwgWbgP/eQYGi/RPFn+Vas3sFuNgk1Lkud3
         41xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777542773; x=1778147573;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lrYikL+96nsdg6Sdr1h2bfcZxEJEZfN5XyHVJwCmeaM=;
        b=UgybwZl4W8mPc0Ed5DnmnDYOmZU1krc0A2fB8onHfv0x45+PHHBndrghlYhX67n0CS
         DQxA3hu8LtBfQx4YY96O2ZG6CL+qdxg8Y9YoNNV3GL+SFgMgp3OFQnDnWo2wFsdXqyUY
         qTM+vVGq3hZlyhvF5XaRD+rsqQ9033GlkwIOR0E0BxapVbgUA4BGtryAdEGAw4DNJf6i
         OQEb4NOPEyBABXRhZSiMJ1bEnPftvN3ZruqW6Fpd+SvX8gvXAxMJtcVJ7LmTwQbLNDN4
         K/aBEIRF1//SLolIFqHJ+Lqer5sCVpOCy49lVGEoImxlxoQoI2rUMAA2jg2Eeg9jHXE4
         gQXA==
X-Forwarded-Encrypted: i=1; AFNElJ9O0iGz8pzoPkU4X/iCtQ4HnCLpeEQAMb8UnQYncWZ+7etaF7FEsmOfTOBeziuT5mtD3zwH4G3Uvw==@lists.linux.dev
X-Gm-Message-State: AOJu0YweBQi1kVmR53zF2kAB1TQJeZUlfvV+DDEkhmusyAJHjkJmfjM3
	WQwWrRohaS6BGsPRLr1TmZbiT84KZEtQcD+mfEJ2nwKRYg9Sp9NjDi/VVoXefIFzXGrt7zIBzmD
	YBEd3+PUkM+hui0wQIJ87p4BUG3rTRhIzR8n3ICa/ahClFiZiUVba8H4UD8hFuw==
X-Gm-Gg: AeBDieurmP24sBO7sBI0+cnEdp82oIY+BBQW0Ghv22kSL+LcfPc/ipT304FmdiQgWSm
	tKvG7r64sYEETKM4iNCDoy9LvNOtj0tT1AUr/4kYng31Nnx7XkxfPr64vmGRWZfS6RIFF1hduWs
	I6tixjhUaCd8qiGyzmx/PSxptmc95mIMIxR3TZBRFBx4OPSeJVivUTzHuVTiWSVwjSfiqQkWhqw
	G+HE+TV3nYQMtogCHBifIQjoslVqp10YF1XWh9GDagn6AQ0QLMvvNsA8k7KdN3oW9Tb3OQ4sPqi
	Q0DKYcXeYWLc4pHwc8BW8VM29rxP1syFYakWrdkgAdCikP5WHIZrPLfsy7K0AAFX3GtcbkmGMsf
	hUKUA2v5n9BvVmMGzPo0c2P7gnlQxiorLj+aeZ0LO22CqQXn+hPfSSebMcVnyR67KHFS6cOS7Co
	7t1CyftSFfZy8Ctno=
X-Received: by 2002:a05:7301:168f:b0:2c1:7793:7bbb with SMTP id 5a478bee46e88-2ed3e67f82dmr848280eec.27.1777542773044;
        Thu, 30 Apr 2026 02:52:53 -0700 (PDT)
X-Received: by 2002:a05:7301:168f:b0:2c1:7793:7bbb with SMTP id 5a478bee46e88-2ed3e67f82dmr848258eec.27.1777542772331;
        Thu, 30 Apr 2026 02:52:52 -0700 (PDT)
Received: from u20-san1p10573.qualcomm.com (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ed1c0d218dsm5885804eec.27.2026.04.30.02.52.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2026 02:52:52 -0700 (PDT)
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
To: linux-block@vger.kernel.org, ebiggers@kernel.org, mpatocka@redhat.com,
        gmazyland@gmail.com, bmarzins@redhat.com
Cc: linux-kernel@vger.kernel.org, adrianvovk@gmail.com,
        dm-devel@lists.linux.dev, quic_mdalam@quicinc.com, israelr@nvidia.com,
        hch@infradead.org, axboe@kernel.dk
Subject: [PATCH v3 3/3] dm: add documentation for dm-inlinecrypt target
Date: Thu, 30 Apr 2026 02:52:44 -0700
Message-Id: <20260430095244.3352446-4-linlin.zhang@oss.qualcomm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260430095244.3352446-1-linlin.zhang@oss.qualcomm.com>
References: <20260430095244.3352446-1-linlin.zhang@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDMwMDA5OSBTYWx0ZWRfXzva5iehpDr9m
 xRc9SvM6UrVeGKPyGpFWuhsyD0pPX0KDVAtqtCa3hmGlcEVW0NFxuZpDdTcC3nk62hmKwFDHyfm
 RPth3rVtJcO5bGeCHAf9hOMlFgcEuZjIarjhXPm9iUmwmTfvo5Y3kqj9/HIrgKP3VdBPiMTZCce
 ANWaS4C12ywEIDvfIFCvmZjFo9tXFRveNzNWUaL1ZgAtVt4KwVkqm7x42ajmfWB7A8FSj10gAH+
 HKDk1mZAxWZCyu7O1cxuqoS4X8CJMuAgPAxzm1xeziCAEyFzjEnFOytGXgyd+bLctglUJNhlrCp
 mt2e4WYIL6hHEaA3MggW2+Hv4xNZ6EolmHYTB9l+Q3EKTUvhetkzgCKTCWGRnN4ib3mY+YdI6eV
 /pCht1iIpqAlbBfoEambv3fIkO9fO6v9eGl9lQmjsH7PQk1wPtPJHGtoW9BmNIVyUVpj+p281e7
 huxL09do+lHcDquhtWw==
X-Authority-Analysis: v=2.4 cv=Oc2oyBTY c=1 sm=1 tr=0 ts=69f32676 cx=c_pps
 a=wEP8DlPgTf/vqF+yE6f9lg==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=r5tAstHzX-DRmjCks68A:9 a=bBxd6f-gb0O0v-kibOvt:22
X-Proofpoint-GUID: nUin-v-J_N4rLFOg2OJJwgny7qNIDTeb
X-Proofpoint-ORIG-GUID: nUin-v-J_N4rLFOg2OJJwgny7qNIDTeb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-30_03,2026-04-28_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 lowpriorityscore=0 phishscore=0 suspectscore=0
 impostorscore=0 bulkscore=0 malwarescore=0 priorityscore=1501 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2604300099

This adds the admin-guide documentation for dm-inlinecrypt.

dm-inlinecrypt.rst is the guide to using dm-inlinecrypt.

Signed-off-by: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
---
 .../device-mapper/dm-inlinecrypt.rst          | 123 ++++++++++++++++++
 1 file changed, 123 insertions(+)
 create mode 100644 Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst

diff --git a/Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst b/Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst
new file mode 100644
index 000000000000..c71e600efb76
--- /dev/null
+++ b/Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst
@@ -0,0 +1,123 @@
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
+    The cipher type corresponds to the encryption modes supported by
+    inline crypto in the block layer. Currently, only
+    BLK_ENCRYPTION_MODE_AES_256_XTS (i.e. aes-xts-plain64) is supported.
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
+    Use <sector_size>-based sector numbers for IV generation instead of
+    512-byte sectors.
+
+    For dm-inlinecrypt, this flag must be specified when <sector_size>
+    is larger than 512 bytes. The legacy 512-byte-based IV behavior is
+    not supported.
+
+    When specified, if <sector_size> is 4096 bytes, plain64 IV for the
+    second sector will be 1, and <iv_offset> must be a multiple of
+    <sector_size> (in 512-byte units).
+
+Example scripts
+===============
+Currently, dm-inlinecrypt devices must be set up directly using dmsetup.
+There is no userspace support yet to integrate dm-inlinecrypt with LUKS
+or cryptsetup. In particular, cryptsetup currently only supports
+dm-crypt, and cannot be used to create dm-inlinecrypt mappings.
+
+The following examples demonstrate how to create dm-inlinecrypt devices
+using dmsetup
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
-- 
2.34.1

