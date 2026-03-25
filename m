Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF821ACED5
	for <dm-devel@lists.linux.dev>; Wed, 25 Mar 2026 19:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774467387; cv=none; b=SPK1RCgv/KUGon1RThoC8j0Vqhea6UWQgQPDwNfhE+lcRubOstWUXpo7B24tBYXixpPpgYHBDFQ6xrwf6JR8xptdBBSvBsNmqGeh2jjMyPMOQUqZqAQP1K6VBrAPNrYgy8jPLtllY0LSQsIYw1XLZ/LWFaY+SK51vC6xkYhIPc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774467387; c=relaxed/simple;
	bh=x2CUGmGSNioWBrm9LJkmnNvPnWXIJomhJ/ncF19Kz14=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Mh5jlSfCb+dIhMf3XyeTn9UkYynDXXa5Hve4nOsbF3gxrxlo0WUmJbCZBNvrsORcT4XVS//59cmRe9LyARgFBmJln72z12l+Vm79po9hKT3BpCH/Go+w86yOXIvMKzODUU5UhnjAb9MzLVmqQ69CPfCB6Xy66MU4lXZad5zb38I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=vao7tL+b; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="vao7tL+b"
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62PHJYrY1320344
	for <dm-devel@lists.linux.dev>; Wed, 25 Mar 2026 12:36:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=IqYQP8kBQ93H6DBnxgEkQXIWtL8jM7015iPHEbrKbJg=; b=vao7tL+bWbbZ
	v3UzrygjQCK6CjuO1mBVrGUg6WgzH/jtA2JmvEQ0wjGbqbFmdKLIo1pqBS4Qhz8i
	/p8EsEJC+fCTKSJJdLbiiCu9cemNNwJIj7wIpIQqWK6Qa0CRAi+/4uzhJJkflT2A
	iddYdG5qj3PL6OTZ8Y2rLrbRex9F6gF4c8w4zxCSFVyHvEz0hSSwI7jdI0xeJpOS
	nWMN3cMM0vQ9yy2a/kXH8c8l7ml4Y89w7/OsllB4vU/XPh+kwLNVCKyTRWxPk9vl
	VdBlm4J80iDWq6OW7rLsvn4Z4bxRskTmRpmcuBgNIogu5iHsLAF5f7dxNQxTzRk0
	2eCnenmmmg==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4d42mbvsg8-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Wed, 25 Mar 2026 12:36:25 -0700 (PDT)
Received: from twshared111727.16.frc2.facebook.com (2620:10d:c0a8:1c::11) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.35; Wed, 25 Mar 2026 19:36:23 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id BBBADD2EC965; Wed, 25 Mar 2026 12:36:08 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <dm-devel@lists.linux.dev>
CC: <mpatocka@redhat.com>, <snitzer@kernel.org>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [PATCH 3/3] dm: provide helper to set stacked limits
Date: Wed, 25 Mar 2026 12:36:08 -0700
Message-ID: <20260325193608.2827042-3-kbusch@meta.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260325193608.2827042-1-kbusch@meta.com>
References: <20260325193608.2827042-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI1MDE0MyBTYWx0ZWRfXworjFrenSn7/
 jK5UPwutZSuYD2MsibOV2cTFklY8nkvHVn3UQJsyNbrY8UEjd9Mut7vc44HXMWktSdlGkORwg7L
 Grh2IlBSn2nFXgTHB4ALveJBCUyrHzQOzQZ6tzjuv3PO3MIRHvt5uaMijREFdcgW81dqvXqDpNb
 fBLg/5prIFSF77mW9jc772nriUTpvKlglOs5hsKDzhlRBei19JdhXxERYC97Ax4eC1DH0htD6FX
 N6q30h436HCl4eVIxNdN44vFD+ko/M3cHjjsjNvnCtvzj+Hey8PYIo3t9L18t0/aBADvvgQDzSM
 zIPnIUR7s8fNuyBSyGNG4MS4YPUMPy4rzsKx5h7y4cdirZkSrnfsYF8E/seQTytWOv64YSDcWRf
 ox71ipzzqI+g8EzEe+kFrLFnr29y8kxuT+G/1x5mlfBCkt5EEHeimbXXqXLSHf72/u44KYL36fC
 NLnIYUk+v77QHdj3Klg==
X-Proofpoint-GUID: 5x2n_nw9HjXcGARpy6QxJEv7Uf0tYuth
X-Proofpoint-ORIG-GUID: 5x2n_nw9HjXcGARpy6QxJEv7Uf0tYuth
X-Authority-Analysis: v=2.4 cv=FNwWBuos c=1 sm=1 tr=0 ts=69c43939 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=crHB47gyY4rKiduisYu9:22 a=VwQbUJbxAAAA:8 a=RWx4YFyQamIsJo1nD9gA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-25_05,2026-03-24_01,2025-10-01_01

From: Keith Busch <kbusch@kernel.org>

There are multiple device mappers that set up their stacking limits
exactly the same for the logical, physical and minimum IO queue limits.
Provide a helper for it.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 drivers/md/dm-crypt.c         |  6 +-----
 drivers/md/dm-integrity.c     |  7 +------
 drivers/md/dm-verity-target.c |  8 +-------
 drivers/md/dm-writecache.c    | 10 +---------
 include/linux/device-mapper.h |  7 +++++++
 5 files changed, 11 insertions(+), 27 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 885208a82c55f..60642cee8609d 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -3684,11 +3684,7 @@ static void crypt_io_hints(struct dm_target *ti, s=
truct queue_limits *limits)
 {
 	struct crypt_config *cc =3D ti->private;
=20
-	limits->logical_block_size =3D
-		max_t(unsigned int, limits->logical_block_size, cc->sector_size);
-	limits->physical_block_size =3D
-		max_t(unsigned int, limits->physical_block_size, cc->sector_size);
-	limits->io_min =3D max_t(unsigned int, limits->io_min, cc->sector_size)=
;
+	dm_stack_bs_limits(limits, cc->sector_size);
 	limits->dma_alignment =3D limits->logical_block_size - 1;
=20
 	/*
diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index d64c15c761d0a..65c30dec82220 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -4046,12 +4046,7 @@ static void dm_integrity_io_hints(struct dm_target=
 *ti, struct queue_limits *lim
 {
 	struct dm_integrity_c *ic =3D ti->private;
=20
-	limits->logical_block_size =3D max(limits->logical_block_size,
-			    ic->sectors_per_block << SECTOR_SHIFT);
-	limits->physical_block_size =3D max(limits->physical_block_size,
-			    ic->sectors_per_block << SECTOR_SHIFT);
-	limits->io_min =3D max(limits->io_min,
-			    ic->sectors_per_block << SECTOR_SHIFT);
+	dm_stack_bs_limits(limits, ic->sectors_per_block << SECTOR_SHIFT);
 	limits->dma_alignment =3D limits->logical_block_size - 1;
 	limits->discard_granularity =3D ic->sectors_per_block << SECTOR_SHIFT;
=20
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.=
c
index e1d435c79e96c..9a9847f94c460 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -1011,13 +1011,7 @@ static void verity_io_hints(struct dm_target *ti, =
struct queue_limits *limits)
 {
 	struct dm_verity *v =3D ti->private;
=20
-	if (limits->logical_block_size < 1 << v->data_dev_block_bits)
-		limits->logical_block_size =3D 1 << v->data_dev_block_bits;
-
-	if (limits->physical_block_size < 1 << v->data_dev_block_bits)
-		limits->physical_block_size =3D 1 << v->data_dev_block_bits;
-
-	limits->io_min =3D limits->logical_block_size;
+	dm_stack_bs_limits(limits, 1 << v->data_dev_block_bits);
=20
 	/*
 	 * Similar to what dm-crypt does, opt dm-verity out of support for
diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 98bd945f6da7b..493f5202ad042 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -1640,17 +1640,9 @@ static void writecache_io_hints(struct dm_target *=
ti, struct queue_limits *limit
 {
 	struct dm_writecache *wc =3D ti->private;
=20
-	if (limits->logical_block_size < wc->block_size)
-		limits->logical_block_size =3D wc->block_size;
-
-	if (limits->physical_block_size < wc->block_size)
-		limits->physical_block_size =3D wc->block_size;
-
-	if (limits->io_min < wc->block_size)
-		limits->io_min =3D wc->block_size;
+	dm_stack_bs_limits(limits, wc->block_size);
 }
=20
-
 static void writecache_writeback_endio(struct bio *bio)
 {
 	struct writeback_struct *wb =3D container_of(bio, struct writeback_stru=
ct, bio);
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.=
h
index 38f625af6ab47..cd4faaf5d4275 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -755,4 +755,11 @@ static inline unsigned long to_bytes(sector_t n)
 	return (n << SECTOR_SHIFT);
 }
=20
+static inline void dm_stack_bs_limits(struct queue_limits *limits, unsig=
ned int bs)
+{
+	limits->logical_block_size =3D max(limits->logical_block_size, bs);
+	limits->physical_block_size =3D max(limits->physical_block_size, bs);
+	limits->io_min =3D max(limits->io_min, bs);
+}
+
 #endif	/* _LINUX_DEVICE_MAPPER_H */
--=20
2.52.0

