Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 383FF3101A7
	for <dm-devel@lists.linux.dev>; Tue, 16 Jun 2026 17:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631650; cv=none; b=F1MqubXmNbvIWWW2Pb2NBzFkQwn4YELxY+cTGXoQG5EcAq5bhpjhT0as22PxpEIG6ScGM2uP5ujvycPJN105ok45KYIxdda1w9V+0EfbG4/PVSCPSwhZnBdgxYeNFRcCfXrwXeBHh8yef2l/P2+t6MLajYM5CD0oPEJIVB0yhAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631650; c=relaxed/simple;
	bh=LOwnnb7MLnYXNSGIdbnVIddgC3nGF5HioRRME1HgwxQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cgNk1IeNmFZB7usqY5squZCp54rIhbEnn0c4DMhjZ47uF+zPzNqX/icCQPsPA4AXcBEFDgTpC03MWGBwXOiPrKMr2YOVjL6mI0IISMU6BEs8Mm+WmHPkTzF8PPRviF0EX3pq1KVrAZHmOJXqRe4dVCqs9Db/Fq7RAjHhIORXsSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=sCp0a44b; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="sCp0a44b"
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65GHBunD1484351
	for <dm-devel@lists.linux.dev>; Tue, 16 Jun 2026 10:40:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=tFOpxzrc/5nljYW7VdZedMiTY2PkEVFwNiTljv+laB0=; b=sCp0a44bnyK6
	s6oe0Z2MFVxTLOLoOAQNPyudppZodGEpiRajO51E/sSUCOHzbND4xD3A7oL+e0au
	hxe8pjs+h3YGH0wmvauQ6EF4WLiwot2jZSOg3d2o4hDzeSLVVmD7lPgtHwkVF0hi
	DDUBzVskvjuTbO08cvhCjuO59tcfCr4x0zM08km4slpPaBIuuBkR1sM2BmsrzT97
	E2IyL4r+5JRlxhnnzAJfzlOyNzWIDJYGsB1zcg67Nqfpuof+bdMePEV8m34skZxd
	Q4kpznoesEwWKpd7sSjPdRCRLxNkWP34sRwMMen4BEpKFfwt9wI+CfkH6+PTa0hj
	4QMVhR8iMg==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4eu7twsn0a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Tue, 16 Jun 2026 10:40:47 -0700 (PDT)
Received: from twshared8664.02.snb3.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.41; Tue, 16 Jun 2026 17:40:46 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 1ABA22331A654; Tue, 16 Jun 2026 08:40:24 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <dm-devel@lists.linux.dev>
CC: <linux-block@vger.kernel.org>, <mpatocka@redhat.com>, <kbusch@kernel.org>,
        <linux@treblig.org>, <vklimovs@gmail.com>
Subject: [PATCH 2/2] dm-raid1: don't fail the mirror for invalid I/O errors
Date: Tue, 16 Jun 2026 08:40:09 -0700
Message-ID: <20260616154009.2123183-1-kbusch@meta.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260616150554.1686662-1-kbusch@meta.com>
References: <20260616150554.1686662-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: NJbu2AkLlVCAriMxUHBUdaZzQzrRXoVW
X-Proofpoint-GUID: NJbu2AkLlVCAriMxUHBUdaZzQzrRXoVW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE2MDE4MSBTYWx0ZWRfX8sTkmCidjTxA
 R64LWRMUrMBbExZBV4frYDSjH5uB00cHdBRbVaKr2FGdr44o3eRxJeOL9ynPsdDYOJBtr5NYOlc
 pRzmkX9YbSfx8rPQ2glR8j9XhxB6iyfo1PcNWqdPl+2DUFN3JPnymk6lmpvsph98pG9UJ01460Z
 KPQNUr0kss6Wjr9XWayPlNc8RsfO+M/xVv1dAPAaHeVftfFLWRmdcxawt04fmkmT0p+5F1/xMEO
 Sabz98VnLcMc4Qft9Tl0iHYNlVZdeIZS6dQqvSXIKfY2RAY/LZAu/k6WhjIfIJ9k8QGza3qVmR0
 ckcf2af5rPv0qkb+0TbXGqtGaFbfW6U2+0ZuiLS2xxwZBq08I6J85qexdqeHYHJGN+ehMVE3zRe
 pWNnzq5OB0rJtaywkusl3AByME+MHX5xq6h3FcO+KauxABVz6FU9Fm1zOcweAMZzGYH3M0NDxmr
 7AZI28S93irmMfB3A5Q==
X-Authority-Analysis: v=2.4 cv=dYqwG3Xe c=1 sm=1 tr=0 ts=6a318a9f cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=8elwO82fXORLTBIkMd32:22 a=VwQbUJbxAAAA:8 a=3WJfbomfAAAA:8 a=pGLkceISAAAA:8
 a=ECpI9oUnO1FrOKOjoQ8A:9 a=1cNuO-ABBywtgFSQhe9S:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE2MDE4MSBTYWx0ZWRfX0hDVt4IsocPd
 4YVlgaVssiaOdgMx9hyhSt74EEybgwEdLJ2paSn84GVz5ALcozNV9FkVOvhzTNOxstOmYeCXIhc
 lMIdKyUh6CXg7Q7roCfH0xj9pxbdmxU=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-16_05,2026-06-16_01,2025-10-01_01

From: Keith Busch <kbusch@kernel.org>

BLK_STS_INVAL indicates the I/O request itself was invalid (for example a
misaligned direct I/O), not that the device has failed. dm-raid1 treated
any read or write completion error as a device failure: it failed the
mirror leg, retried on the alternatives - which fail identically - and
eventually returned EIO while spuriously degrading the array.

Since commit 5ff3f74e145a ("block: simplify direct io validity check") th=
e
direct I/O path no longer rejects misaligned buffers up front, so an
invalid bio now reaches the lower block layers, which fail it with
BLK_STS_INVAL. dm-io collapses the block status into a per-region error
bit before invoking the completion callback, so record BLK_STS_INVAL on
the originating bio and have the dm-raid1 read, write and end_io paths
propagate it instead of failing the device.

This mirrors the raid1/raid10 fix in commit f7b24c7b41f23
("md/raid1,raid10: don't fail devices for invalid IO errors") for the
device-mapper mirror target.

Fixes: 7eac33186957 ("iomap: simplify direct io validity check")
Fixes: 5ff3f74e145a ("block: simplify direct io validity check")
Reported-by: Dr. David Alan Gilbert <linux@treblig.org>
Reported-by: Vjaceslavs Klimovs <vklimovs@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 drivers/md/dm-io.c    | 14 +++++++++++++-
 drivers/md/dm-raid1.c | 28 +++++++++++++++++++++++++++-
 2 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index 28adfeb58f240..f382e9f9be059 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -37,6 +37,7 @@ struct io {
 	struct dm_io_client *client;
 	io_notify_fn callback;
 	void *context;
+	struct bio *orig_bio;
 	void *vma_invalidate_address;
 	unsigned long vma_invalidate_size;
 } __aligned(DM_IO_MAX_REGIONS);
@@ -132,8 +133,18 @@ static void complete_io(struct io *io)
=20
 static void dec_count(struct io *io, unsigned int region, blk_status_t e=
rror)
 {
-	if (error)
+	if (error) {
 		set_bit(region, &io->error_bits);
+		/*
+		 * BLK_STS_INVAL means the bio was not valid for the underlying
+		 * device (e.g. a misaligned direct I/O), which is a caller error
+		 * rather than a device failure. Record it on the original bio so
+		 * bio-based targets can propagate it instead of treating it as a
+		 * media error and failing the device.
+		 */
+		if (error =3D=3D BLK_STS_INVAL && io->orig_bio)
+			io->orig_bio->bi_status =3D error;
+	}
=20
 	if (atomic_dec_and_test(&io->count))
 		complete_io(io);
@@ -398,6 +409,7 @@ static void async_io(struct dm_io_client *client, uns=
igned int num_regions,
 	io->client =3D client;
 	io->callback =3D fn;
 	io->context =3D context;
+	io->orig_bio =3D dp->orig_bio;
=20
 	io->vma_invalidate_address =3D dp->vma_invalidate_address;
 	io->vma_invalidate_size =3D dp->vma_invalidate_size;
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index de5c00704e69c..022ad791c2957 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -524,6 +524,17 @@ static void read_callback(unsigned long error, void =
*context)
 		return;
 	}
=20
+	/*
+	 * BLK_STS_INVAL means the bio was not valid for the underlying device,
+	 * e.g. a misaligned direct I/O. That is a caller error, not a device
+	 * failure, so propagate it rather than failing the mirror and retrying
+	 * on the other legs, which would fail the same way.
+	 */
+	if (bio->bi_status =3D=3D BLK_STS_INVAL) {
+		bio_endio(bio);
+		return;
+	}
+
 	fail_mirror(m, DM_RAID1_READ_ERROR);
=20
 	if (likely(default_ok(m)) || mirror_available(m->ms, bio)) {
@@ -622,6 +633,16 @@ static void write_callback(unsigned long error, void=
 *context)
 		return;
 	}
=20
+	/*
+	 * BLK_STS_INVAL means the bio was not valid for the underlying device,
+	 * e.g. a misaligned direct I/O. Propagate the error without degrading
+	 * the array.
+	 */
+	if (bio->bi_status =3D=3D BLK_STS_INVAL) {
+		bio_endio(bio);
+		return;
+	}
+
 	/*
 	 * If the bio is discard, return an error, but do not
 	 * degrade the array.
@@ -1262,7 +1283,12 @@ static int mirror_end_io(struct dm_target *ti, str=
uct bio *bio,
 		return DM_ENDIO_DONE;
 	}
=20
-	if (*error =3D=3D BLK_STS_NOTSUPP)
+	/*
+	 * BLK_STS_INVAL means the bio was not valid for the underlying device,
+	 * e.g. a misaligned direct I/O. Propagate it rather than failing the
+	 * mirror and retrying, which would fail the same way on every leg.
+	 */
+	if (*error =3D=3D BLK_STS_NOTSUPP || *error =3D=3D BLK_STS_INVAL)
 		goto out;
=20
 	if (bio->bi_opf & REQ_RAHEAD)
--=20
2.52.0

