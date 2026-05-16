Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388CA3DD511
	for <dm-devel@lists.linux.dev>; Sat, 16 May 2026 11:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778932254; cv=none; b=AwYt5bLv5j7tL6ZW82A3mUERef4kSBIsga9oBr33efNHWiMR0CbDQZA+yLl8rJxskyPvnq4IwhsSH344KW3INFII6WTx+zOSOE9ODhrVaODmUb+y4lZk0y+g8yuPlWoxY0vnsUBH74+X1SLuLbMy2L+HfjH7K9HbxShRXNgO/rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778932254; c=relaxed/simple;
	bh=HsvOfF/WcvWpGuFgzOw3j+phD1tzcGCGNbFw2dXUCgg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gjyN2e83c3LhzKl3PGcEvRSI5/nO/q4PTBWqCddkY2ebIefOyi/Fncom2b4NHT9Xiir7OYxZEfFPk8o/Gp4KabvbUtKSSusQvZ98tp8ZRBmwhmx+Ld1Uk8+N7N762MXcPYg5VkJ4ifbNHOBuzKdNDUdRwC2BlkdmLocKWYEWreo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=kK9flCtn; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ZstMAaob; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="kK9flCtn";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ZstMAaob"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64G3leVd3288260
	for <dm-devel@lists.linux.dev>; Sat, 16 May 2026 11:50:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=Sl4Tqs3rL2g
	O+I8+VZQCtEcpE/idf6GLGIeKnd8ZYGk=; b=kK9flCtnJYpfpDXM0oagfIE6QV+
	WfOn/Oz4Oir3q9tSQSMZDk+TwWOl37EgEWyU/Jn4fmORtjf7QXupcwHpKQ7YwOGI
	Aak8WF0T5skxoq6pCWEbfF/hhBKprfCPFAbnYIHCHvcgiR/20KJJmOGZArs3Sh2q
	xFQ3dYV25EJQkJlKGogSTSSv8VVPwDchoRCuQY94j1Gp83nI6DnpUQLirzzQHIgD
	KUQXX/j6xNMUWCaxbFvoqicQSbip6kgEbQS2GRY+Gdlx7IXYSpFxgmwzFuaokHQd
	6OQK4sUGAeCtXbAY7E00St4xU+0EyH6baIsAXRI925istNLPIQrlqP0Gzfw==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e6gyw0ryk-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Sat, 16 May 2026 11:50:52 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-2f3ec2e8d07so2224438eec.1
        for <dm-devel@lists.linux.dev>; Sat, 16 May 2026 04:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1778932251; x=1779537051; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sl4Tqs3rL2gO+I8+VZQCtEcpE/idf6GLGIeKnd8ZYGk=;
        b=ZstMAaobXsPsZlfkP06FT5DFcS89ixsLa1jo7Y2HA9CIArH+bDPV8mSOcPeU2WNJd5
         AvnnpptSQVAiWRmKnf4RDTL1qCIDlr8dPP+RzJDVjtQvHzTvot625gczWWetEjI3q7RE
         KEtBAOufDO6fWMa+wgxC+sH3LdHUjP9fr3oDUvs9BvV+xfbODDj5rHAUh3sqyjJ13jQx
         08YkvEwUhcfBa9NJkSbZYQ18oTa8EjXiGm7KAj3N1zigV3vwwbW3vSg7RgSzAqM7ST97
         v1wzzt1z13ApartiACzCjXS+jVAMH4VFfTkbzfhcL7TGOdAouquAYTOPNKtVYZCM0tYb
         L4gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778932251; x=1779537051;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Sl4Tqs3rL2gO+I8+VZQCtEcpE/idf6GLGIeKnd8ZYGk=;
        b=FOr6+MpP/dSnnPi6/vJP5HKYuGvGUrJak+YMh3IUV4Z0VHtZpRkseH7SJAoSWaXbbb
         /zUX52Fo2uuUQWjZqAMBLDcdhfrucj5Na+xKMR5V0taeBmJ2Do6pwddo5WH3usBHMNMB
         3C9HuUHY1yKkWqhxSjbDv6cpYV4xHrj3FLS38aWqx+isF5ykBD/V321jVikudMPG4pio
         HLFL2EmCwRB9o4LkpUtSVdfv1s4LRM90tBp/eLGqlchZIWZxl5x8Q0CFZuBsvcTySS5t
         BhYDzEsfXt+UtEUeSSwV4Fw9I7d+rPbM/E+2HORhAyDvkEnsv/e8O+RvsAlueT3PBUrN
         kAqg==
X-Forwarded-Encrypted: i=1; AFNElJ8lrP4eYu3fWbGfIWbAkNnDdjj4m1z+QdmeEzqhWDZH9g2bjzLTbS55hP+M8z7DdcGZ2qf2Jcp5mA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yzbqu9LjEL0fRFQl8Yh6K7hYRJsippCkUHK/qqUTd/AdKnmcUQh
	P8nQ54N/wPZbCsDI5woon96hQpITmPF52RHG2qcBhvChu9GFk4a1Jfi9RggfqxjPYJ4C4+IRl61
	PNRAm1hXdOswBaFfaKhFn8R2ryKqiQaXkXczBEQ0p01g0h531gi2EYvqZSU6jdA==
X-Gm-Gg: Acq92OEllXJButoXf3NJ25gQI7fQYntBfNj/FnYwfnqFEprSL5PTVMDn7/QIv9jBKBI
	bH4bpphZh3IpheSSfTr3F3TtmvKWooicHkqRAMxOEReA2V/yhAxG3f357NaBFCYIJ5M3w9BqaDO
	0z7dEdYg1NXEZJTRbsY78WhEzos5wTDtPvz9Wgm2IA+bRD08166IxhsWbLVCZXr33Y5iJHf/8ji
	/WNilgH78pJxBKq8yyZ8JQI/VvNAzPfc8uSvQ2TVTxBi0sRkKRGVIEhra1fSRb6piGT0m6IVsKh
	6bmfkZdmlwqyAjcYiGY82Im1thQfmA/BYDilXgNvVIjMEcLQU5e7doMQwrflwOx4y+f5C+1xGfK
	68ljMuEd2bkqTM2FC/if6uuJRb37L53QtwfmsKmfJfjmsqUnQN7RUl/+a+UCQ708vWcrE6MLDuM
	d7HZ6mhTI1pJhVoW8=
X-Received: by 2002:a05:7300:ec17:b0:2e7:c701:aa85 with SMTP id 5a478bee46e88-30398626570mr4111486eec.17.1778932251033;
        Sat, 16 May 2026 04:50:51 -0700 (PDT)
X-Received: by 2002:a05:7300:ec17:b0:2e7:c701:aa85 with SMTP id 5a478bee46e88-30398626570mr4111468eec.17.1778932250456;
        Sat, 16 May 2026 04:50:50 -0700 (PDT)
Received: from u20-san1p10573.qualcomm.com (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30293e2e69esm11782612eec.1.2026.05.16.04.50.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 May 2026 04:50:50 -0700 (PDT)
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Eric Biggers <ebiggers@kernel.org>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        Benjamin Marzinski <bmarzins@redhat.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/1] dm-inlinecrypt: add support for hardware-wrapped keys
Date: Sat, 16 May 2026 04:50:45 -0700
Message-Id: <20260516115045.3958326-2-linlin.zhang@oss.qualcomm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260516115045.3958326-1-linlin.zhang@oss.qualcomm.com>
References: <20260516115045.3958326-1-linlin.zhang@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE2MDExNiBTYWx0ZWRfX6NnVBEqnszfh
 FoeI02+FqL93eumLjra0Nul2Heg1i9fqlshX0x07ABOHUrYgzKG+VXK1raWB6G2B2BS3rZ/VtHc
 yM6Undmy8qvff+bHEoU8gWrJEXfjDIDDvcca16MmM+PL5c0fAfFlXI9l/xHz/vVTpbzjjCgPA4Y
 Vc586lowLDSf2JDMWfoK/c1e6KGeN9MU7C6lYzy1HM26gxUIZu20/L6OYyCsdrRCuYX4BZZ54dw
 iWWHpy2y48VTDlRz9+Pf8+Jaf16Y0dinsmBQeYXD4TFvQ+QG4lRZFBFD1QUUQ0cR8u1Ji3zmhLw
 K8zb0xPQDm20O9g+qY8ytvZyoQkg+gqbPElrBC9agoO4/6p1uxeXKVQ10vxt9y/gkBaNr/53AzD
 Qm4fw2lFnwxJBWpNJqNv3d2aL2x8y6fKW6VbKK5zuo7pmugJEttwrjyKrkSHyA7xhE+FeV3JvL6
 PU7LNhztSPliayqi2kA==
X-Proofpoint-GUID: JWagqmIRkttdXZJ3PauXatM99wAU9nGs
X-Proofpoint-ORIG-GUID: JWagqmIRkttdXZJ3PauXatM99wAU9nGs
X-Authority-Analysis: v=2.4 cv=E5v9Y6dl c=1 sm=1 tr=0 ts=6a085a1c cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=KrrCeawaZyiTPODpdG8A:9 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-16_01,2026-05-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 bulkscore=0 adultscore=0 spamscore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 phishscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605160116

Add support for hardware-wrapped encryption keys to the
dm-inlinecrypt target.

Introduce a new parameter <is_wrappedkey> to indicate whether
the provided key is a raw key or a hardware-wrapped key. Based
on this flag, the appropriate blk-crypto key type is selected
when initializing the key.

This allows dm-inlinecrypt to work with hardware that requires
keys to be wrapped and managed by the underlying inline
encryption engine.

Update the target argument parsing accordingly and pass the
key type to blk_crypto_init_key(). Documentation is also
updated to reflect the new parameter and usage.

Signed-off-by: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
---
 .../device-mapper/dm-inlinecrypt.rst          | 10 ++-
 drivers/md/dm-inlinecrypt.c                   | 71 +++++++++++--------
 2 files changed, 50 insertions(+), 31 deletions(-)

diff --git a/Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst b/Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst
index c71e600efb76..3a4ce2c5f228 100644
--- a/Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst
+++ b/Documentation/admin-guide/device-mapper/dm-inlinecrypt.rst
@@ -10,7 +10,7 @@ https://docs.kernel.org/block/inline-encryption.html
 
 Parameters::
 
-	      <cipher> <key> <iv_offset> <device path> \
+	      <cipher> <key> <is_wrappedkey> <iv_offset> <device path> \
 	      <offset> [<#opt_params> <opt_params>]
 
 <cipher>
@@ -52,6 +52,10 @@ Parameters::
     The kernel keyring key description inlinecrypt target should look for
     when loading key of <key_type>.
 
+<is_wrappedkey>
+    The flag used to imply if the key is hardware-wrapped or not.
+    '0' means a raw key and '1' means a wrapped key.
+
 <iv_offset>
     The IV offset is a sector count that is added to the sector number
     before creating the IV.
@@ -113,11 +117,11 @@ using dmsetup
 
 	#!/bin/sh
 	# Create a inlinecrypt device using dmsetup
-	dmsetup create inlinecrypt1 --table "0 `blockdev --getsz $1` inlinecrypt aes-xts-plain64 babebabebabebabebabebabebabebabebabebabebabebabebabebabebabebabe 0 $1 0"
+	dmsetup create inlinecrypt1 --table "0 `blockdev --getsz $1` inlinecrypt aes-xts-plain64 babebabebabebabebabebabebabebabebabebabebabebabebabebabebabebabe 0 0 $1 0"
 
 ::
 
 	#!/bin/sh
 	# Create a inlinecrypt device using dmsetup when encryption key is stored in keyring service
-	dmsetup create inlinecrypt2 --table "0 `blockdev --getsz $1` inlinecrypt aes-xts-plain64 :64:logon:fde:dminlinecrypt_test_key 0 $1 0"
+	dmsetup create inlinecrypt2 --table "0 `blockdev --getsz $1` inlinecrypt aes-xts-plain64 :64:logon:fde:dminlinecrypt_test_key 0 0 $1 0"
 
diff --git a/drivers/md/dm-inlinecrypt.c b/drivers/md/dm-inlinecrypt.c
index bd8e58a028c5..4e49edea59cf 100644
--- a/drivers/md/dm-inlinecrypt.c
+++ b/drivers/md/dm-inlinecrypt.c
@@ -29,6 +29,7 @@ static const struct dm_inlinecrypt_cipher {
  *	   For this purpose a "sector" is 512 bytes.
  * @cipher_string: the name of the encryption algorithm being used
  * @key_size: size of the encryption key in bytes
+ * @is_hw_wrapped: true if the key is a hardware-wrapped key, false for a raw key.
  * @iv_offset: starting offset for IVs.  IVs are generated as if the target were
  *	       preceded by @iv_offset 512-byte sectors.
  * @sector_size: crypto sector size in bytes (usually 4096)
@@ -41,6 +42,7 @@ struct inlinecrypt_ctx {
 	sector_t start;
 	const char *cipher_string;
 	unsigned int key_size;
+	bool is_hw_wrapped;
 	u64 iv_offset;
 	unsigned int sector_size;
 	unsigned int sector_bits;
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
@@ -284,7 +286,7 @@ static int inlinecrypt_ctr_optional(struct dm_target *ti,
 
 /*
  * Construct an inlinecrypt mapping:
- * <cipher> [<key>|:<key_size>:<logon>:<key_description>] <iv_offset> <dev_path> <start>
+ * <cipher> [<key>|:<key_size>:<logon>:<key_description>] <is_wrappedkey> <iv_offset> <dev_path> <start>
  *
  * This syntax matches dm-crypt's, but the set of supported functionality has
  * been stripped down.
@@ -293,13 +295,14 @@ static int inlinecrypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
 	struct inlinecrypt_ctx *ctx;
 	const struct dm_inlinecrypt_cipher *cipher;
-	u8 raw_key[BLK_CRYPTO_MAX_ANY_KEY_SIZE];
+	u8 key_bytes[BLK_CRYPTO_MAX_ANY_KEY_SIZE];
+	enum blk_crypto_key_type key_type;
 	unsigned int dun_bytes;
 	unsigned long long tmpll;
 	char dummy;
 	int err;
 
-	if (argc < 5) {
+	if (argc < 6) {
 		ti->error = "Not enough arguments";
 		return -EINVAL;
 	}
@@ -333,21 +336,33 @@ static int inlinecrypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	}
 	ctx->key_size = err;
 
-	err = inlinecrypt_get_key(argv[1], raw_key, ctx->key_size);
+	err = inlinecrypt_get_key(argv[1], key_bytes, ctx->key_size);
 	if (err) {
 		ti->error = "Malformed key string";
 		goto bad;
 	}
 
+	/* <is_wrappedkey> */
+	if (sscanf(argv[2], "%d%c", &err, &dummy) != 1 ||
+			(err != 0 && err != 1)) {
+		ti->error = "Invalid is_wrappedkey flag";
+		err = -EINVAL;
+		goto bad;
+	}
+	ctx->is_hw_wrapped = err;
+	key_type = ctx->is_hw_wrapped ?
+			   BLK_CRYPTO_KEY_TYPE_HW_WRAPPED :
+			   BLK_CRYPTO_KEY_TYPE_RAW;
+
 	/* <iv_offset> */
-	if (sscanf(argv[2], "%llu%c", &ctx->iv_offset, &dummy) != 1) {
+	if (sscanf(argv[3], "%llu%c", &ctx->iv_offset, &dummy) != 1) {
 		ti->error = "Invalid iv_offset sector";
 		err = -EINVAL;
 		goto bad;
 	}
 
 	/* <dev_path> */
-	err = dm_get_device(ti, argv[3], dm_table_get_mode(ti->table),
+	err = dm_get_device(ti, argv[4], dm_table_get_mode(ti->table),
 			    &ctx->dev);
 	if (err) {
 		ti->error = "Device lookup failed";
@@ -355,7 +370,7 @@ static int inlinecrypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	}
 
 	/* <start> */
-	if (sscanf(argv[4], "%llu%c", &tmpll, &dummy) != 1 ||
+	if (sscanf(argv[5], "%llu%c", &tmpll, &dummy) != 1 ||
 	    tmpll != (sector_t)tmpll) {
 		ti->error = "Invalid start sector";
 		err = -EINVAL;
@@ -365,8 +380,8 @@ static int inlinecrypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	/* optional arguments */
 	ctx->sector_size = SECTOR_SIZE;
-	if (argc > 5) {
-		err = inlinecrypt_ctr_optional(ti, argc - 5, &argv[5]);
+	if (argc > 6) {
+		err = inlinecrypt_ctr_optional(ti, argc - 6, &argv[6]);
 		if (err)
 			goto bad;
 	}
@@ -385,10 +400,9 @@ static int inlinecrypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		       (ctx->sector_bits - SECTOR_SHIFT);
 	dun_bytes = DIV_ROUND_UP(fls64(ctx->max_dun), 8);
 
-	err = blk_crypto_init_key(&ctx->key, raw_key, ctx->key_size,
-				  BLK_CRYPTO_KEY_TYPE_RAW,
-				  cipher->mode_num, dun_bytes,
-				  ctx->sector_size);
+	err = blk_crypto_init_key(&ctx->key, key_bytes, ctx->key_size,
+				  key_type, cipher->mode_num,
+				  dun_bytes, ctx->sector_size);
 	if (err) {
 		ti->error = "Error initializing blk-crypto key";
 		goto bad;
@@ -408,7 +422,7 @@ static int inlinecrypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 bad:
 	inlinecrypt_dtr(ti);
 out:
-	memzero_explicit(raw_key, sizeof(raw_key));
+	memzero_explicit(key_bytes, sizeof(key_bytes));
 	return err;
 }
 
@@ -502,9 +516,10 @@ static void inlinecrypt_status(struct dm_target *ti, status_type_t type,
 		 * the returned table.  Userspace is responsible for redacting
 		 * the key when needed.
 		 */
-		DMEMIT("%s %*phN %llu %s %llu", ctx->cipher_string,
-		       ctx->key.size, ctx->key.bytes, ctx->iv_offset,
-		       ctx->dev->name, ctx->start);
+		DMEMIT("%s %*phN %u %llu %s %llu", ctx->cipher_string,
+		       ctx->key.size, ctx->key.bytes,
+		       ctx->is_hw_wrapped ? 1 : 0,
+		       ctx->iv_offset, ctx->dev->name, ctx->start);
 		num_feature_args += !!ti->num_discard_bios;
 		if (ctx->sector_size != SECTOR_SIZE)
 			num_feature_args += 2;
-- 
2.34.1

