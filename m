Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CAC43815CE
	for <dm-devel@lists.linux.dev>; Mon, 25 May 2026 12:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779711238; cv=none; b=NXShBe3a4sqArBIMCt7RCUv476f4Qbk04O+ruatALpfxcM1ufN/1jcTpKRgfOBiWlnw8tp5llYrJMsYXPHDxV/jEa7s49g1yk6TPsChzJ0PxRuST3fcofPZHgcrMM+qi3q/VPydQC3ItZij1Mo3ijboqfz6ZqMITrlIeTdDhyI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779711238; c=relaxed/simple;
	bh=/4q5SKHnarsZjvQtvTuR/8//1DZSB0QZDm6o2TCtk5U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BjNd3UxfNO35vdg2jpHAsfBFgwd1YSaPYNE4JDTAvmYSkL/y3oANTJPWJSZ71AuLAdorGqHQINPyIZ2BrMH+6X7ChDCOtkMkFFr7HY9lswMtrAiyXIjVfa9mlsZdhbhgW9Awpdp3ccPkGirHT9H6ZofhSIUksznyfypOXDYWi4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=E8zxzaK7; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=MV9wbSOb; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="E8zxzaK7";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="MV9wbSOb"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64P9Emxn080127
	for <dm-devel@lists.linux.dev>; Mon, 25 May 2026 12:13:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=7ynmZufDjRg
	f1FwaoBl/o9v3N5HQZnGqFH7Md0cfKT8=; b=E8zxzaK7j1Vayl9xFW9Fi4nCNZQ
	UQHFAcGichSfi2kdVVJWfmEXa2LWpicN8Yw5m1V1NUV0acFCwgQ2Zr6ebDnlg92p
	yrz6XNZyIw26rIwOJGGD50edzYvXzsqLALoc9Tc1tCjC0bKuoCZO5qyxibaebcvP
	zDznFQuQQQpXr4SpiKPRVa+O7TAjug4aT0ciqJ7GPWiUVRfWXxZ5e8btyWwovZ+s
	LK6UEPB8vcBOMpwiIzTUjJtChvhwl0jZWYwJaq1TdpASxKPTaq2jVRmqATUg/p53
	ejhgYkAbV8CJ5IQeds+wc8d0kJ09/Fb+8nID2eqmB4YiKKJ9Pxf7phUQXJA==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eckma8jpd-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Mon, 25 May 2026 12:13:56 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-2ef37c3f773so9656743eec.1
        for <dm-devel@lists.linux.dev>; Mon, 25 May 2026 05:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779711236; x=1780316036; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7ynmZufDjRgf1FwaoBl/o9v3N5HQZnGqFH7Md0cfKT8=;
        b=MV9wbSObpZnPxeDInx3XB/YNSotyW2ahk9Lq8oqKJUMPudQfOr3nD+A+Xlr1kFP6RM
         z8AGU8sPIjoWf/9XWE9KSCL+C/tyWUOxU+M0lzQGH8wcidRxDk1W6yThZzk5/VkV4FU6
         QakV/BPlc+UGpicYxqB0LOxPwejZsbQW9qaeeZMdk3qq4Rq3zUWP/yrhBAa6DY1lxR3F
         GIyGcDOIp5H5rT1h+GEHkC6oca/YFcfpPL5ajCnrlkwCZAYhfrhG/XJVY0kiwI3EbKAR
         CzuIYnJYA7JA20aVvpgJKSFk2+V9CXMaUfmij71fkQTKOhbC/xaRPTMoYy2m4Qo0pqi5
         lyXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779711236; x=1780316036;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7ynmZufDjRgf1FwaoBl/o9v3N5HQZnGqFH7Md0cfKT8=;
        b=TwQKRXSwVQLsT9LweCZg/O1UmHsBJXrSZTzuUNeVZjtu18JAf/6gy28djXQZa0BYtb
         6v7FCqCiEHNV/7XQrnsW6FXgcdfJZ1uXscOvImEqev/0Bfbp32TDFi1CoqySUIn6e4a+
         Ix4xivC5ffUkGaNrOMqG/u9WfN4ooJapqTLc9F6VLhGxME2N+CnmDZfqA0KmkeztqGqU
         Nn5ME/Ztpsm5d8ZqQM5MKzwMB7rupbWjpFtb5wZ3PR5UJ7s+koKzhGNb5Gx9Zq+L1NyI
         asN4ThFeI74GkehFuNNFTcq/MZRZbphI67YMJSqgy8ofb5io9Zg7gsvSFIr4+BuFJPJc
         e/hQ==
X-Forwarded-Encrypted: i=1; AFNElJ8+Y4OshBk7b4aBZqb8jcjLF8tJh0kIzkQe5xuAV9uXOwDaEGzRCpxtM8m8oCg9ussLi6hqllPfzA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwPqOVThqBzD4TFvT2GPwJnM/XNBTZrpfx10dUt+RJ1bsh00BJv
	nFma/yREuGNU5c8fCRXn58a+05SZBJPCCA6KcLGo5h5lYMUaLdisz6uqcPSZWUgnhXiM4J3b+3F
	nQy9NUcz2HhD+pkYIz0vgIKvluxXjL8W7g+J3AbFnk4IoBaZy//GxP+NeGWF7DA==
X-Gm-Gg: Acq92OHGsFy3pCsZ+6MQXusMdSetSc0yo25d/1WF80ZxsWV2r7MgXrfbjnhKLL7GskO
	4Y6zjZAQCjPGwZOdOQoomX1g2B2OaHF4ZFsqSa50GyPD5bdV1NfmbSEzB4gvruemEfaFYqs7Ahy
	SEN/FD7f5mDU081VKq7ps0E+Ljpd8/Ng4wHmWZbD+deAxpe8LQWy1X8Y899HT9NZEUSClmdKvjA
	mNrMzMZzIzYIJ1AIQb8dqWQRRdGusqqQqyOc8JjcYmtSVrQSVrcbYSAQZhh0z2i3IV8bOe92E6g
	WMUXVRPY30QUyYtHWn1cwh1F1Oh8v71M7vZ5ksF+qsbm4OErZvDC6qeoUuowKjJWxRZ5KSc2L7c
	iDVLa9sqyc33/vYTLDXPb2apvL6KEHkbLTpXHZOy9HxoetUuNtXIYyeg6QLbQEzhRHEWlPE4OoH
	ee52U3lqPvV8dlrns=
X-Received: by 2002:a05:7300:fb8b:b0:2ea:cd38:f921 with SMTP id 5a478bee46e88-3044912c345mr6233909eec.26.1779711235678;
        Mon, 25 May 2026 05:13:55 -0700 (PDT)
X-Received: by 2002:a05:7300:fb8b:b0:2ea:cd38:f921 with SMTP id 5a478bee46e88-3044912c345mr6233886eec.26.1779711234979;
        Mon, 25 May 2026 05:13:54 -0700 (PDT)
Received: from u20-san1p10573.qualcomm.com (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-304535ae870sm7552264eec.19.2026.05.25.05.13.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2026 05:13:54 -0700 (PDT)
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Eric Biggers <ebiggers@kernel.org>,
        Milan Broz <gmazyland@gmail.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        Benjamin Marzinski <bmarzins@redhat.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/1] dm-inlinecrypt: add support for hardware-wrapped keys
Date: Mon, 25 May 2026 05:13:48 -0700
Message-Id: <20260525121348.1321282-2-linlin.zhang@oss.qualcomm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260525121348.1321282-1-linlin.zhang@oss.qualcomm.com>
References: <20260525121348.1321282-1-linlin.zhang@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=cL3QdFeN c=1 sm=1 tr=0 ts=6a143d04 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22 a=EUspDBNiAAAA:8
 a=3b9_pEqgJirTJOw7QqIA:9 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-ORIG-GUID: vkkTlfM3Cb8oRLnDtr7r0ob5ZVkIEIJ7
X-Proofpoint-GUID: vkkTlfM3Cb8oRLnDtr7r0ob5ZVkIEIJ7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI1MDEyNiBTYWx0ZWRfX7eCc+Y3RfK+A
 bsYPj5n43KQeBqt5UL/F3d40S8EgJEi+xNVuhmdIV+0F9tqOr5qWlVAfh7SDVwoBuHfi09vQVDB
 VJbbpAhafvw9jnjXb1Df/WVl6Ior1wJa5j4vommo9+eBJvvM/fbSqDQhQDtCAd5UjEj6Qxbl5ZI
 7Q1Pa122wiMQOpjZTJzpoqeoOgyuHzZnzxVeT0HZD44jdQkA23rfjbodo3vnBWQMp/hXzK2rGZ5
 Z6zhGX0mW6qzonIfl6YBosJ4tqH0cPsljiSoypi7NLPP5P0ZNsVcTMhKxOg9gloY7+jq93D2Fl8
 fUk5krnc5XUX2iz/SibSAwvcRMx5u7V7l3RBJrCXHCxlIhHkOxwqlt6lH8+JQshtTio5MPyeAUj
 SmuGMd5qVUuK+2K3eRciBV5tRKoRtamAdaXY0TbjPekPiEAnOydfIVZ/Rq7hMKIRBDUIR7fo5pP
 xwQt+1gf7rg7HgUxQAw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-25_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 bulkscore=0 priorityscore=1501 phishscore=0 adultscore=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 clxscore=1015 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605250126

Add support for hardware-wrapped encryption keys to the
dm-inlinecrypt target.

Introduce a new optional argument <key_type> to indicate
whether the provided key is a raw key or a hardware-wrapped
key. Based on this flag, the appropriate blk-crypto key type
is selected when initializing the key.

This allows dm-inlinecrypt to work with hardware that requires
keys to be wrapped and managed by the underlying inline
encryption engine.

Update the target argument parsing accordingly and pass the
key type to blk_crypto_init_key(). Documentation is also
updated to reflect the new parameter and usage.

Signed-off-by: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
---
 .../device-mapper/dm-inlinecrypt.rst          | 20 +++---
 drivers/md/dm-inlinecrypt.c                   | 63 ++++++++++++-------
 2 files changed, 54 insertions(+), 29 deletions(-)

diff --git a/Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst b/Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst
index c71e600efb76..8f7961f99a88 100644
--- a/Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst
+++ b/Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst
@@ -39,18 +39,19 @@ Parameters::
 
 <key_string>
     The kernel keyring key is identified by string in following format:
-    <key_size>:<key_type>:<key_description>.
+    <key_size>:<keyring_type>:<key_description>.
 
 <key_size>
     The encryption key size in bytes. The kernel key payload size must match
     the value passed in <key_size>.
 
-<key_type>
-    Either 'logon', or 'trusted' kernel key type.
+<keyring_type>
+    The type of the key inside the kernel keyring. It can be either 'logon',
+    or 'trusted' kernel key type.
 
 <key_description>
     The kernel keyring key description inlinecrypt target should look for
-    when loading key of <key_type>.
+    when loading key of <keyring_type>.
 
 <iv_offset>
     The IV offset is a sector count that is added to the sector number
@@ -70,7 +71,12 @@ Parameters::
     Otherwise #opt_params is the number of following arguments.
 
     Example of optional parameters section:
-        allow_discards sector_size:4096 iv_large_sectors
+        keytype:raw allow_discards sector_size:4096 iv_large_sectors
+
+<key_type>
+    The type of the key as seen by the block layer, either standard or
+    hardware-wrapped. The string is supplied in the table as <keytype:raw>
+    or <keytype:hw-wrapped>.
 
 allow_discards
     Block discard requests (a.k.a. TRIM) are passed through the inlinecrypt
@@ -113,11 +119,11 @@ using dmsetup
 
 	#!/bin/sh
 	# Create a inlinecrypt device using dmsetup
-	dmsetup create inlinecrypt1 --table "0 `blockdev --getsz $1` inlinecrypt aes-xts-plain64 babebabebabebabebabebabebabebabebabebabebabebabebabebabebabebabe 0 $1 0"
+	dmsetup create inlinecrypt1 --table "0 `blockdev --getsz $1` inlinecrypt aes-xts-plain64 babebabebabebabebabebabebabebabebabebabebabebabebabebabebabebabe 0 0 $1 0 1 keytype:raw"
 
 ::
 
 	#!/bin/sh
 	# Create a inlinecrypt device using dmsetup when encryption key is stored in keyring service
-	dmsetup create inlinecrypt2 --table "0 `blockdev --getsz $1` inlinecrypt aes-xts-plain64 :64:logon:fde:dminlinecrypt_test_key 0 $1 0"
+	dmsetup create inlinecrypt2 --table "0 `blockdev --getsz $1` inlinecrypt aes-xts-plain64 :64:logon:fde:dminlinecrypt_test_key 0 0 $1 0 1 keytype:raw"
 
diff --git a/drivers/md/dm-inlinecrypt.c b/drivers/md/dm-inlinecrypt.c
index bd8e58a028c5..be1b4aa8f28b 100644
--- a/drivers/md/dm-inlinecrypt.c
+++ b/drivers/md/dm-inlinecrypt.c
@@ -33,6 +33,7 @@ static const struct dm_inlinecrypt_cipher {
  *	       preceded by @iv_offset 512-byte sectors.
  * @sector_size: crypto sector size in bytes (usually 4096)
  * @sector_bits: log2(sector_size)
+ * @key_type: type of the key -- either raw or hardware-wrapped
  * @key: the encryption key to use
  * @max_dun: the maximum DUN that may be used (computed from other params)
  */
@@ -44,6 +45,7 @@ struct inlinecrypt_ctx {
 	u64 iv_offset;
 	unsigned int sector_size;
 	unsigned int sector_bits;
+	enum blk_crypto_key_type key_type;
 	struct blk_crypto_key key;
 	u64 max_dun;
 };
@@ -83,8 +85,8 @@ static bool contains_whitespace(const char *str)
 	return false;
 }
 
-static int set_key_user(struct key *key, char *bin_key,
-			const unsigned int bin_key_size)
+static int set_key_user(struct key *key, char *key_bytes,
+			const unsigned int key_bytes_size)
 {
 	const struct user_key_payload *ukp;
 
@@ -92,23 +94,23 @@ static int set_key_user(struct key *key, char *bin_key,
 	if (!ukp)
 		return -EKEYREVOKED;
 
-	if (bin_key_size != ukp->datalen)
+	if (key_bytes_size != ukp->datalen)
 		return -EINVAL;
 
-	memcpy(bin_key, ukp->data, bin_key_size);
+	memcpy(key_bytes, ukp->data, key_bytes_size);
 
 	return 0;
 }
 
-static int inlinecrypt_get_keyring_key(const char *key_string, u8 *bin_key,
-					const unsigned int bin_key_size)
+static int inlinecrypt_get_keyring_key(const char *key_string, u8 *key_bytes,
+					const unsigned int key_bytes_size)
 {
 	char *key_desc;
 	int ret;
 	struct key_type *type;
 	struct key *key;
-	int (*set_key)(struct key *key, char *bin_key,
-				   const unsigned int bin_key_size);
+	int (*set_key)(struct key *key, char *key_bytes,
+				   const unsigned int key_bytes_size);
 
 	/*
 	 * Reject key_string with whitespace. dm core currently lacks code for
@@ -137,7 +139,7 @@ static int inlinecrypt_get_keyring_key(const char *key_string, u8 *bin_key,
 
 	down_read(&key->sem);
 
-	ret = set_key(key, (char *)bin_key, bin_key_size);
+	ret = set_key(key, (char *)key_bytes, key_bytes_size);
 
 	up_read(&key->sem);
 	key_put(key);
@@ -178,8 +180,8 @@ static int get_key_size(char **key_string)
 
 #else
 
-static int inlinecrypt_get_keyring_key(const char *key_string, u8 *bin_key,
-					const unsigned int bin_key_size)
+static int inlinecrypt_get_keyring_key(const char *key_string, u8 *key_bytes,
+					const unsigned int key_bytes_size)
 {
 	return -EINVAL;
 }
@@ -234,7 +236,7 @@ static int inlinecrypt_ctr_optional(struct dm_target *ti,
 	struct inlinecrypt_ctx *ctx = ti->private;
 	struct dm_arg_set as;
 	static const struct dm_arg _args[] = {
-		{0, 3, "Invalid number of feature args"},
+		{0, 4, "Invalid number of feature args"},
 	};
 	unsigned int opt_params;
 	const char *opt_string;
@@ -255,7 +257,23 @@ static int inlinecrypt_ctr_optional(struct dm_target *ti,
 			ti->error = "Not enough feature arguments";
 			return -EINVAL;
 		}
-		if (!strcmp(opt_string, "allow_discards")) {
+		if (str_has_prefix(opt_string, "keytype:")) {
+			const char *val = opt_string + strlen("keytype:");
+
+			if (!*val) {
+				ti->error = "Invalid block key type";
+				return -EINVAL;
+			}
+
+			if (!strcmp(val, "raw")) {
+				ctx->key_type = BLK_CRYPTO_KEY_TYPE_RAW;
+			} else if (!strcmp(val, "hw-wrapped")) {
+				ctx->key_type = BLK_CRYPTO_KEY_TYPE_HW_WRAPPED;
+			} else {
+				ti->error = "Invalid block key type";
+				return -EINVAL;
+			}
+		} else if (!strcmp(opt_string, "allow_discards")) {
 			ti->num_discard_bios = 1;
 		} else if (sscanf(opt_string, "sector_size:%u%c",
 				  &ctx->sector_size, &dummy) == 1) {
@@ -293,7 +311,7 @@ static int inlinecrypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
 	struct inlinecrypt_ctx *ctx;
 	const struct dm_inlinecrypt_cipher *cipher;
-	u8 raw_key[BLK_CRYPTO_MAX_ANY_KEY_SIZE];
+	u8 key_bytes[BLK_CRYPTO_MAX_ANY_KEY_SIZE];
 	unsigned int dun_bytes;
 	unsigned long long tmpll;
 	char dummy;
@@ -333,7 +351,7 @@ static int inlinecrypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	}
 	ctx->key_size = err;
 
-	err = inlinecrypt_get_key(argv[1], raw_key, ctx->key_size);
+	err = inlinecrypt_get_key(argv[1], key_bytes, ctx->key_size);
 	if (err) {
 		ti->error = "Malformed key string";
 		goto bad;
@@ -365,6 +383,7 @@ static int inlinecrypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	/* optional arguments */
 	ctx->sector_size = SECTOR_SIZE;
+	ctx->key_type = BLK_CRYPTO_KEY_TYPE_RAW;
 	if (argc > 5) {
 		err = inlinecrypt_ctr_optional(ti, argc - 5, &argv[5]);
 		if (err)
@@ -385,10 +404,9 @@ static int inlinecrypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		       (ctx->sector_bits - SECTOR_SHIFT);
 	dun_bytes = DIV_ROUND_UP(fls64(ctx->max_dun), 8);
 
-	err = blk_crypto_init_key(&ctx->key, raw_key, ctx->key_size,
-				  BLK_CRYPTO_KEY_TYPE_RAW,
-				  cipher->mode_num, dun_bytes,
-				  ctx->sector_size);
+	err = blk_crypto_init_key(&ctx->key, key_bytes, ctx->key_size,
+				  ctx->key_type, cipher->mode_num,
+				  dun_bytes, ctx->sector_size);
 	if (err) {
 		ti->error = "Error initializing blk-crypto key";
 		goto bad;
@@ -408,7 +426,7 @@ static int inlinecrypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 bad:
 	inlinecrypt_dtr(ti);
 out:
-	memzero_explicit(raw_key, sizeof(raw_key));
+	memzero_explicit(key_bytes, sizeof(key_bytes));
 	return err;
 }
 
@@ -502,8 +520,9 @@ static void inlinecrypt_status(struct dm_target *ti, status_type_t type,
 		 * the returned table.  Userspace is responsible for redacting
 		 * the key when needed.
 		 */
-		DMEMIT("%s %*phN %llu %s %llu", ctx->cipher_string,
-		       ctx->key.size, ctx->key.bytes, ctx->iv_offset,
+		DMEMIT("%s %*phN %u %llu %s %llu", ctx->cipher_string,
+		       ctx->key.size, ctx->key.bytes,
+		       ctx->key_type, ctx->iv_offset,
 		       ctx->dev->name, ctx->start);
 		num_feature_args += !!ti->num_discard_bios;
 		if (ctx->sector_size != SECTOR_SIZE)
-- 
2.34.1

