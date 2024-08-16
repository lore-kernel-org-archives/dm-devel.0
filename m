Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 670E9817
	for <dm-devel@lists.linux.dev>; Fri, 16 Aug 2024 11:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723807308; cv=none; b=GVbLErdKI3qqGKCogYcA2XpVd3cG+SHpCUYWN+jgicOe3HQkvh5VT6d4u9ORs1FJVrztx4s73hugvCxL5GK+Kvc5MpMkqbiTe+tuozvHj3kvzgpDciQ6EJrKDiyyDrDeiP36D7eAC/FyItySyzpAClc5Cp8ePMuwugOPwZNLHJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723807308; c=relaxed/simple;
	bh=IADffIUOZUeWhBBUJk+WF4tkynjTBtyZT6qoEOHUVGA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=C+0v9ztntfocD7H+pLi0zGC6c0kTN5BTKn/bxh5jV2QXvoEIPtaY2Z3IthSwj+MRWjx3SsNH+SbUB9R1R4y/iffIvQ9Y4Vo0Xdmf999b2ESuV18CGiPyJF8KILcMp2c2k50+buV6eSpiwTYNCNTgjnK4IbNIJHtBcFAf8BvAjLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=UJQy7Tct; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="UJQy7Tct"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47FKI1mc011973;
	Fri, 16 Aug 2024 11:21:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding; s=pp1; bh=WBRevDFy4jnIkA1sUngew6w+DT
	eNFm/70g0d7/fTqtI=; b=UJQy7TctmALy+KHnJPEJxy2pf/DGt514I40v8r6LxQ
	hNZIAfmtWHIID1CU3pKCQPbKz2ixFZS85n35oMT9lEwWFRLOvK/CTk8ZiJzghP5S
	1JBArOShiidefnUfTwi8E1OBLexWRvtfGvCzdiW2D/M79UXQ1F4OzeLcRE+hiCq1
	U0CXAAPgMNo9UTSbZWeX6X1dFWBHsqtF9gs02sNNiGtfyMKuX53qUV6pqeiLeCOE
	jrkywy3X8HjwYo5nzhVzObwBesOUAVK3H5vyFklqSIb3vkEDDGAiZwNjY87WJBri
	Xw7S9AxAyOjfubzQjrEWSryFgTtQ8x3WdmLJSngvOfWg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4111d6g8mn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 16 Aug 2024 11:21:39 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 47GBLc8i001655;
	Fri, 16 Aug 2024 11:21:38 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4111d6g8mj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 16 Aug 2024 11:21:38 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 47GAECgl010102;
	Fri, 16 Aug 2024 11:21:37 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 40xjx13h25-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 16 Aug 2024 11:21:37 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 47GBLXjL35586586
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Aug 2024 11:21:35 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 48D902004B;
	Fri, 16 Aug 2024 11:21:33 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 29B2620043;
	Fri, 16 Aug 2024 11:21:33 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 16 Aug 2024 11:21:33 +0000 (GMT)
From: Ingo Franzki <ifranzki@linux.ibm.com>
To: dm-devel@lists.linux.dev
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
        gmazyland@gmail.com
Subject: [PATCH] dm-crypt: Allow to specify the integrity key size as option
Date: Fri, 16 Aug 2024 13:21:33 +0200
Message-ID: <20240816112133.2100537-1-ifranzki@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6OsaHx3ZJ28UD7EjQZ1PF0YP4r2FlTMb
X-Proofpoint-ORIG-GUID: m7OXmQrzkTMQBjlf5xkLTpBN36xDuErX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-16_03,2024-08-15_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 phishscore=0
 spamscore=0 malwarescore=0 priorityscore=1501 impostorscore=0 adultscore=0
 bulkscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2407110000
 definitions=main-2408160080

For the MAC based integrity operation, the integrity key size (i.e.
key_mac_size) is currently set to the digest size of the used digest.

For wrapped key HMAC algorithms, the key size is independent of the
cryptographic key size. So there is no known size of the mac key in
such cases. The desired key size can optionally be specified as argument
when the dm-crypt device is configured via 'integrity_key_size:%u'.
If no integrity_key_size argument is specified, the mac key size
is still set to the digest size, as before.

Increase version number to 1.28.0 so that support for the new
argument can be detected by user space (i.e. cryptsetup).

Signed-off-by: Ingo Franzki <ifranzki@linux.ibm.com>
---
 Documentation/admin-guide/device-mapper/dm-crypt.rst |  4 ++++
 drivers/md/dm-crypt.c                                | 11 +++++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/device-mapper/dm-crypt.rst b/Documentation/admin-guide/device-mapper/dm-crypt.rst
index e625830d335e..636b47c582f0 100644
--- a/Documentation/admin-guide/device-mapper/dm-crypt.rst
+++ b/Documentation/admin-guide/device-mapper/dm-crypt.rst
@@ -160,6 +160,10 @@ iv_large_sectors
    The <iv_offset> must be multiple of <sector_size> (in 512 bytes units)
    if this flag is specified.
 
+integrity_key_size:<bytes>
+   Use an integrity key of <bytes> size instead of using an integrity key size
+   of the digest size of the used HMAC algorithm.
+
 
 Module parameters::
 max_read_size
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 348b4b26c272..c4c706115870 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2937,7 +2937,8 @@ static int crypt_ctr_auth_cipher(struct crypt_config *cc, char *cipher_api)
 	if (IS_ERR(mac))
 		return PTR_ERR(mac);
 
-	cc->key_mac_size = crypto_ahash_digestsize(mac);
+	if (!cc->key_mac_size)
+		cc->key_mac_size = crypto_ahash_digestsize(mac);
 	crypto_free_ahash(mac);
 
 	cc->authenc_key = kmalloc(crypt_authenckey_size(cc), GFP_KERNEL);
@@ -3219,6 +3220,12 @@ static int crypt_ctr_optional(struct dm_target *ti, unsigned int argc, char **ar
 			cc->cipher_auth = kstrdup(sval, GFP_KERNEL);
 			if (!cc->cipher_auth)
 				return -ENOMEM;
+		} else if (sscanf(opt_string, "integrity_key_size:%u", &val) == 1) {
+			if (val == 0) {
+				ti->error = "Invalid integrity_key_size argument";
+				return -EINVAL;
+			}
+			cc->key_mac_size = val;
 		} else if (sscanf(opt_string, "sector_size:%hu%c", &cc->sector_size, &dummy) == 1) {
 			if (cc->sector_size < (1 << SECTOR_SHIFT) ||
 			    cc->sector_size > 4096 ||
@@ -3758,7 +3765,7 @@ static void crypt_io_hints(struct dm_target *ti, struct queue_limits *limits)
 
 static struct target_type crypt_target = {
 	.name   = "crypt",
-	.version = {1, 27, 0},
+	.version = {1, 28, 0},
 	.module = THIS_MODULE,
 	.ctr    = crypt_ctr,
 	.dtr    = crypt_dtr,
-- 
2.43.0

