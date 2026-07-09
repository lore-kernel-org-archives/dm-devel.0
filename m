Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896E34314A4
	for <dm-devel@lists.linux.dev>; Thu,  9 Jul 2026 16:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783613740; cv=none; b=hYk4mPur0NJtZ26PC05kvZA+Q2gEbpfHVguN3p0dQ+6hjy4BlmU2M8lVmdGE8iCIrqv/5LW2WnJrtN92AILz7FZXMQrs3s46ks00n7T1z56+kdMmEPWuEa4LWd319QGmi3BzpShX+iNXefzY5K+qlZmWKir1a9sw4Xt/QgEr+rM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783613740; c=relaxed/simple;
	bh=0qJ0JEkJsV8S07hiX9/6NMHT9drX6HzoPBXTn8UFLKE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gbylr8vZJLdjqaaaqx5uZktCCz4O4TilGQOLnjurU2KvXEH+SV+fuKSduJzxl7B4V7ZigxvpL6iDpg/fPLXMxRjY7GOaXRKb3stcj5F4Ax6HCWJY6B2OawWorF2eiR+i6/Bf/iWYQgyrTSdRGqnWtoT/2w1soqsBwOQ2A8JvZRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=qLJirc7u; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="qLJirc7u"
Received: from pps.filterd (m0528008.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 669EV2Og2899437
	for <dm-devel@lists.linux.dev>; Thu, 9 Jul 2026 09:15:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=Wg1p2FlT7nkSU0dCrDKtoObcbCr0u9he73zG4JgzQus=; b=qLJirc7uTb9b
	3bPwmJaLipWPxD8DaLvX5GwXEpEkcAmXhsGMZOBM5/38pYrBvg7MLCTSTxXGqeNB
	S6cE2yv+xyFCM0MfknSeNlQpBKUsMda60vmbV4RNnCZynShW+4ZHK74g/o+VpIiL
	2UWu/Uz9g7gMYV1A/ca7NUCvCKTuq1MfK46aBcCxvQon8R0wgo+09y5MM79lH2s7
	jsIVFmjrWrURaos5CRJWVbZncs1fjctp9hYcb06exNmQbMDvc4SbmxwxGs4jwN2v
	vcSHa7cc9d4s2x7L+KXMZcM77QIAN2ghPXUuHYJ5yWG7hbATHBmK4LGj2TW9vZkj
	TzgWGYo5ng==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4fadfagq5a-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Thu, 09 Jul 2026 09:15:38 -0700 (PDT)
Received: from twshared95846.15.frc2.facebook.com (2620:10d:c085:208::7cb7) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.41; Thu, 9 Jul 2026 16:15:36 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 670D524D56C5A; Thu,  9 Jul 2026 09:15:20 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <dm-devel@lists.linux.dev>, <mpatocka@redhat.com>
CC: <snitzer@kernel.org>, <bmarzins@redhat.com>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [PATCHv5 2/3] dm-crypt: handle memory allocation failures
Date: Thu, 9 Jul 2026 09:15:18 -0700
Message-ID: <20260709161519.1559723-3-kbusch@meta.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260709161519.1559723-1-kbusch@meta.com>
References: <20260709161519.1559723-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: WXELYbkClxAyMQw3oYKUywEF5dfJRl1a
X-Proofpoint-ORIG-GUID: WXELYbkClxAyMQw3oYKUywEF5dfJRl1a
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA5MDE1OCBTYWx0ZWRfXz67q0QX6rErG
 x+Wtv7q2cgMp5hia84OQ1307e124+OvqAJJHTF09RozptllcjNAWNo3dixBxWiIbv96B34TQmsP
 og6c+OhRB2wDz27by2Kjh0l8I8Xjv1/plKDY/o7tOb6pOwHKvUrOUv+Mmk5XK0k601fOMNzzcuU
 4HnDmPLiAK0+ojU+W/QS62zeSEQECeCRxSi0dGaREa8JQRPIPGdbuAOwNEckFE4sQ9HKltBpF3u
 3Br3krOCj+iryUJCbIJR+KsKBHtmXmZTA4aD+zzLIzEQccUevHU+Zq9kHVFexh396cgkcq5rG9h
 8KmXGp+LZ0tXGDsh78mF04FEj2N8sxTxW2Xzdx12ul0pUhYiuRaBLNBSKsdp72mVxqyNcpa/Fhf
 v7+E72Hof5as06pF02r7H8fOChE6+0zOg/s/wviGSmhtV5/kDaqMuHN9lV3M7kXAsG2YdhOP2mA
 bM1o3NC7R582fQNiTeA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA5MDE1OCBTYWx0ZWRfX9HP6jQ+rCUY8
 jHcxHMvYGqj6JW+Yg21t8j08qXJRQcFi1YtJhyQhMXVeqrqhZhOW9FgBsXWIJUZpixaombqyecs
 kE5fZbHOUZUmPESIQ84xigctSY6SM6U=
X-Authority-Analysis: v=2.4 cv=D8l37PRj c=1 sm=1 tr=0 ts=6a4fc92a cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=_1IyUuN4QrATX339ibzo:22 a=VwQbUJbxAAAA:8 a=nfHjPHAFtudC9iwHPRkA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-09_03,2026-07-09_02,2025-10-01_01

From: Keith Busch <kbusch@kernel.org>

There are a few paths that can fail with -ENOMEM, like skcipher_copy_iv,
which had been treated as a generic failure. This is a transient host
resource issue that can be retried later.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 drivers/md/dm-crypt.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 608b617fb817f..fc9c875cccfd2 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1338,6 +1338,8 @@ static int crypt_convert_block_aead(struct crypt_co=
nfig *cc,
 			dm_audit_log_bio(DM_MSG_PREFIX, "integrity-aead",
 					 ctx->bio_in, s, 0);
 		}
+	} else if (unlikely(r =3D=3D -ENOMEM)) {
+		return r;
 	}
=20
 	if (!r && cc->iv_gen_ops && cc->iv_gen_ops->post)
@@ -1417,6 +1419,9 @@ static int crypt_convert_block_skcipher(struct cryp=
t_config *cc,
 	else
 		r =3D crypto_skcipher_decrypt(req);
=20
+	if (unlikely(r =3D=3D -ENOMEM))
+		return r;
+
 	if (!r && cc->iv_gen_ops && cc->iv_gen_ops->post)
 		cc->iv_gen_ops->post(cc, org_iv, dmreq);
=20
@@ -1593,6 +1598,13 @@ static blk_status_t crypt_convert(struct crypt_con=
fig *cc,
 		case -EBADMSG:
 			atomic_dec(&ctx->cc_pending);
 			return BLK_STS_PROTECTION;
+		/*
+		 * There was a host resource issue.
+		 */
+		case -ENOMEM:
+			atomic_dec(&ctx->cc_pending);
+			complete(&ctx->restart);
+			return BLK_STS_RESOURCE;
 		/*
 		 * There was an error while processing the request.
 		 */
@@ -2072,10 +2084,11 @@ static void kcryptd_crypt_write_convert(struct dm=
_crypt_io *io)
 			  test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags), true);
 	/*
 	 * Crypto API backlogged the request, because its queue was full
-	 * and we're in softirq context, so continue from a workqueue
-	 * (TODO: is it actually possible to be in softirq in the write path?)
+	 * and we're in softirq context, or a host memory allocation
+	 * temporarily failed, so continue from a workqueue (TODO: is it
+	 * actually possible to be in softirq in the write path?)
 	 */
-	if (r =3D=3D BLK_STS_DEV_RESOURCE) {
+	if (r =3D=3D BLK_STS_DEV_RESOURCE || r =3D=3D BLK_STS_RESOURCE) {
 		INIT_WORK(&io->work, kcryptd_crypt_write_continue);
 		queue_work(cc->crypt_queue, &io->work);
 		return;
@@ -2148,9 +2161,10 @@ static void kcryptd_crypt_read_convert(struct dm_c=
rypt_io *io)
 	}
 	/*
 	 * Crypto API backlogged the request, because its queue was full
-	 * and we're in softirq context, so continue from a workqueue
+	 * and we're in softirq context, or a host memory allocation
+	 * temporarily failed, so continue from a workqueue
 	 */
-	if (r =3D=3D BLK_STS_DEV_RESOURCE) {
+	if (r =3D=3D BLK_STS_DEV_RESOURCE || r =3D=3D BLK_STS_RESOURCE) {
 		INIT_WORK(&io->work, kcryptd_crypt_read_continue);
 		queue_work(cc->crypt_queue, &io->work);
 		return;
--=20
2.52.0

