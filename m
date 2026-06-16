Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99CD03126D9
	for <dm-devel@lists.linux.dev>; Tue, 16 Jun 2026 15:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781622389; cv=none; b=GvcCeVd7aGLTuAM/s4oeQQHAnkAlVlHambxGLAVh8Pwq+SacQbSwDrj7LOFb3upuSBw1d/YFzUCV6GalxAjp/JxSClm8WHa1v80nBlI+Y8YZS9qUHi6w8RRqfZs0/w2w1yi46FCXyTHFwW5zkxHT1HK8o5I1lDX7oMwrTo/nDZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781622389; c=relaxed/simple;
	bh=qjAMRIkrTWtf55YKiy2JWQ6uzQPH54YrvaetC38u/SM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=NsrC8YR6VsM2O7SwGB5hW6FgBC8kb6kYoaMmmOWabTUDpK9qPUWYFSFllt1zWlZyDRFiQujUtRsBQgnKGbTCTxB64yOVmd/NLECUXcybh4zeJvRhywimFB4ERg1NyDJXHUZ1X8/LvHSVFJuxWnetp3KRG+cLueWs5MqBGnzfYCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=b62Otg18; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="b62Otg18"
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65GDq4rU1053076
	for <dm-devel@lists.linux.dev>; Tue, 16 Jun 2026 08:06:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2025-q2; bh=8754YTzdUZCrFCN5Ie
	bHKL3kS7U9JO6bpooJ7zRMorE=; b=b62Otg18YG5TiPx/rMaZBqiabdFXOL/dy6
	mwucwuO7YGhj0NdXHXnOSjVVTrMhTTHQ3z/mSn0IWAT9QvPPehbRFO0TXUjHvHXb
	StPwAvWuuTHbOY98SHEbeswXWAcUQypAuu4umSX1Glf7xid/OeF0MYqfSFOkE1Wy
	w5uM9SGTD8COs09gUsYEXBL82eRH0GjaGWHq9rQJEEd2X3snv0hGv27SUmlFgLXK
	0VpD05bbujGIaqBTGUAemlrPmX+YdiCzH0a6g4FIvmRk8/JRL1X2W/v8j2dcgFoY
	jsBmmniBvfPFP0OrMu0XGPWnU+yIXHiOTHwKpnc3zYiox7pQ0bQg==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4eu78s8pn8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Tue, 16 Jun 2026 08:06:26 -0700 (PDT)
Received: from twshared17215.34.frc3.facebook.com (2620:10d:c0a8:1b::2d) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.41; Tue, 16 Jun 2026 15:06:25 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id B9A8E23312251; Tue, 16 Jun 2026 08:06:11 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <dm-devel@lists.linux.dev>
CC: <linux-block@vger.kernel.org>, <mpatocka@redhat.com>,
        Keith Busch
	<kbusch@kernel.org>,
        "Dr. David Alan Gilbert" <linux@treblig.org>,
        Vjaceslavs
 Klimovs <vklimovs@gmail.com>
Subject: [PATCH 1/2] dm-io: clone the source bio instead of copying its biovec
Date: Tue, 16 Jun 2026 08:05:53 -0700
Message-ID: <20260616150554.1686662-1-kbusch@meta.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: PGGuxOVsMySKPYoDQQuA4y5mKbqX9DGK
X-Proofpoint-ORIG-GUID: PGGuxOVsMySKPYoDQQuA4y5mKbqX9DGK
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE2MDE1NSBTYWx0ZWRfX5aEeMAmERPIA
 IwmP1Fcxy/aZ1avFvn0U5yMt9zHPfrU9xIgWnesIZXJOwnd9u+qDccHa45MFzbnCpi1juyKFgSb
 abmSqbcO1xq1gx2UPkEjZP40nORIjCY=
X-Authority-Analysis: v=2.4 cv=ZN3nX37b c=1 sm=1 tr=0 ts=6a316672 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=tpM8CJlwf7uhpglF1g9U:22 a=VwQbUJbxAAAA:8 a=3WJfbomfAAAA:8 a=pGLkceISAAAA:8
 a=7WxoBgBYM47uA12wEMwA:9 a=1cNuO-ABBywtgFSQhe9S:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE2MDE1NSBTYWx0ZWRfXydGCfKZvlb2S
 WDtrgoAXiHu/azYxz6nrNI5DSmuE2OHt5AF00PFJ5F88Lg9A1cbcT5gAf8N/SDrTms/l5Kwo5u5
 XB+4dgo2q5ZZVHrrRAebN7MLnx0Yp3JP+hjgb5w7tX0B3ONd2DeA7SX7QRav8DvSPUvWa6S/Zie
 A0pfHaUQPa9COBfIBEaEVyDjalkhqqMGHdVqd/VSzRVC9bundFkh+lNCKYq4KnCedeSB16s5Hrm
 C30Pyt9Hjy5lcs9astiW5LilWxc7zv5fqND9857ZdOAlqRr7WoJ2bXxHm2zNEKmZOYJlNI48CNI
 2LnMqJOIdFBiZoOTD8dbZsFw5dD3acmPgvNtqs1SWoRsDBXWuSLS2fz+L4PrzNoqQkfvTQg/mqW
 RFmTcnJklMBH8OemBt8jYPw70VqQW30+ZtZVRDdJdOidbrPPGp9N+2eDEZE+2mi0AQtOBJzralw
 UcF+EOlTer3yyOGg6Fw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-16_04,2026-06-15_04,2025-10-01_01

From: Keith Busch <kbusch@kernel.org>

For DM_IO_BIO requests, do_region() built each destination bio by walking
the source bio's biovec and re-adding the pages one at a time, tracking
the remaining transfer in sectors. The vector lengths are byte granular
and need not be sector aligned (e.g. a misaligned O_DIRECT buffer split
across pages), so the sector-based accounting could lose a sub-sector
fragment: to_sector() truncated the remainder and the outer loop spun
forever submitting empty bios, hanging the I/O.

There is no need to rebuild the biovec at all. The destination reads into
(or writes from) exactly the same pages as the source bio, so the bio can
simply clone the source's biovec with bio_alloc_clone() and remap it to
the target device. The clone inherits the source's iterator and alignment=
,
and the block layer splits it to the target's limits on submission, so th=
e
whole region maps to a single cloned bio with no manual page copying or
sector accounting.

This removes the per-page copy path (and its open-coded bvec dpages
helpers) for bio-backed I/O and fixes the hang on misaligned direct I/O t=
o
a dm-mirror device. Page-list, vma and kmem sources keep the existing cop=
y
path.

Fixes: 7eac33186957 ("iomap: simplify direct io validity check")
Fixes: 5ff3f74e145a ("block: simplify direct io validity check")
Reported-by: Dr. David Alan Gilbert <linux@treblig.org>
Reported-by: Vjaceslavs Klimovs <vklimovs@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 drivers/md/dm-io.c | 67 +++++++++++++++++-----------------------------
 1 file changed, 24 insertions(+), 43 deletions(-)

diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index 1db565b376200..28adfeb58f240 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -170,12 +170,11 @@ struct dpages {
 			 struct page **p, unsigned long *len, unsigned int *offset);
 	void (*next_page)(struct dpages *dp);
=20
-	union {
-		unsigned int context_u;
-		struct bvec_iter context_bi;
-	};
+	unsigned int context_u;
 	void *context_ptr;
=20
+	struct bio *orig_bio;
+
 	void *vma_invalidate_address;
 	unsigned long vma_invalidate_size;
 };
@@ -210,44 +209,6 @@ static void list_dp_init(struct dpages *dp, struct p=
age_list *pl, unsigned int o
 	dp->context_ptr =3D pl;
 }
=20
-/*
- * Functions for getting the pages from a bvec.
- */
-static void bio_get_page(struct dpages *dp, struct page **p,
-			 unsigned long *len, unsigned int *offset)
-{
-	struct bio_vec bvec =3D bvec_iter_bvec((struct bio_vec *)dp->context_pt=
r,
-					     dp->context_bi);
-
-	*p =3D bvec.bv_page;
-	*len =3D bvec.bv_len;
-	*offset =3D bvec.bv_offset;
-
-	/* avoid figuring it out again in bio_next_page() */
-	dp->context_bi.bi_sector =3D (sector_t)bvec.bv_len;
-}
-
-static void bio_next_page(struct dpages *dp)
-{
-	unsigned int len =3D (unsigned int)dp->context_bi.bi_sector;
-
-	bvec_iter_advance((struct bio_vec *)dp->context_ptr,
-			  &dp->context_bi, len);
-}
-
-static void bio_dp_init(struct dpages *dp, struct bio *bio)
-{
-	dp->get_page =3D bio_get_page;
-	dp->next_page =3D bio_next_page;
-
-	/*
-	 * We just use bvec iterator to retrieve pages, so it is ok to
-	 * access the bvec table directly here
-	 */
-	dp->context_ptr =3D bio->bi_io_vec;
-	dp->context_bi =3D bio->bi_iter;
-}
-
 /*
  * Functions for getting the pages from a VMA.
  */
@@ -332,6 +293,21 @@ static void do_region(const blk_opf_t opf, unsigned =
int region,
 		return;
 	}
=20
+	if (dp->orig_bio) {
+		bio =3D bio_alloc_clone(where->bdev, dp->orig_bio, GFP_NOIO,
+				      &io->client->bios);
+		bio->bi_iter.bi_sector =3D where->sector;
+		bio->bi_iter.bi_size =3D where->count << SECTOR_SHIFT;
+		bio->bi_opf =3D opf;
+		bio->bi_end_io =3D endio;
+		bio->bi_ioprio =3D ioprio;
+		store_io_and_region_in_bio(bio, io, region);
+
+		atomic_inc(&io->count);
+		submit_bio(bio);
+		return;
+	}
+
 	/*
 	 * where->count may be zero if op holds a flush and we need to
 	 * send a zero-sized flush.
@@ -468,6 +444,7 @@ static int dp_init(struct dm_io_request *io_req, stru=
ct dpages *dp,
=20
 	dp->vma_invalidate_address =3D NULL;
 	dp->vma_invalidate_size =3D 0;
+	dp->orig_bio =3D NULL;
=20
 	switch (io_req->mem.type) {
 	case DM_IO_PAGE_LIST:
@@ -475,7 +452,11 @@ static int dp_init(struct dm_io_request *io_req, str=
uct dpages *dp,
 		break;
=20
 	case DM_IO_BIO:
-		bio_dp_init(dp, io_req->mem.ptr.bio);
+		/*
+		 * The destination bios clone this bio's biovec directly, so
+		 * there are no per-page accessors to set up here.
+		 */
+		dp->orig_bio =3D io_req->mem.ptr.bio;
 		break;
=20
 	case DM_IO_VMA:
--=20
2.52.0

