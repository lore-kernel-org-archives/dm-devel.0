Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E196733B6D6
	for <dm-devel@lists.linux.dev>; Mon, 22 Jun 2026 17:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782150191; cv=none; b=ucwHo10RLyhZHqoyHPBNgJ6f9j4ylZJ94nL0IGHfoji1TiNV27jA549LqHgi7f94qEN1qlO9RGX1BPXQx4i5LHLNAJfH/X28cVX43YTdF2vICPnGW5o33NgiOBGZ8rP/SNYLK7WoKIeZop4lBlgdg8ba0nM2WJM0WP7Uhr0B4Fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782150191; c=relaxed/simple;
	bh=ciOnInfIrlVNGj9B+H97jY8XeIm5Xq/k7daeId3+lPc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EbR6RVR5Kfa0uROOxTlneL/TqgU54jEh8rp7LCaoCVdQ8shxBQss9LHyZTItvE7aRPWc2qB/IISEBCAmeopaEwa6yTmkrPnHRjTDEP1vWE0CEH3hOCXmg1GteV7NTBdzTtbkjBk6nGte5i0dpSd7ZUdGZZYbc3rctDrJEBAUDuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=VX82u59s; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="VX82u59s"
Received: from pps.filterd (m0528004.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65MHVU582357964
	for <dm-devel@lists.linux.dev>; Mon, 22 Jun 2026 10:43:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=7eZT0eaIoKAY4JfubM1+S7MnrycBVHNDXCi+iFHr330=; b=VX82u59s18YF
	+0ZDWvFFkC7uZlSfYZFXkEge4CrBSPAk6ch0L6ZM0+rRyugfANZX90MCIJHPZ9dR
	J/VK412Kt+85WO7VM4sx36VtJivYiUewy2/RqyOOASk9gn5jpSLfGXJ/e0W5K55i
	O7uEB5SGSj++LFseumY7C659b//zy1g/tSpj5t9wDqrWyrNkGHxxvovmm15MaOla
	x8D+YupBykHJsHt4Ncghmc4rzGuCuQp6OHkStTVPr63TN6LA21UrnCaUXFh6wo2O
	BMnPcPhX3d2wRV70gfKvFkSGUk4LdD1C6HyujpCPZaxBROMXbQ30iMsT1qULNKja
	Lic1mL/6ug==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4excgdrh08-11
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Mon, 22 Jun 2026 10:43:08 -0700 (PDT)
Received: from twshared16795.04.snb2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.41; Mon, 22 Jun 2026 17:43:02 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 5937223A15DDD; Mon, 22 Jun 2026 10:42:46 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <linux-block@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
CC: <dm-devel@lists.linux.dev>, <hch@lst.de>, <axboe@kernel.dk>,
        <brauner@kernel.org>, <djwong@kernel.org>, <viro@zeniv.linux.org.uk>,
        Keith
 Busch <kbusch@kernel.org>
Subject: [PATCHv2 2/6] block: report the actual status
Date: Mon, 22 Jun 2026 10:42:37 -0700
Message-ID: <20260622174241.2299563-3-kbusch@meta.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260622174241.2299563-1-kbusch@meta.com>
References: <20260622174241.2299563-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIyMDE3MyBTYWx0ZWRfX05HBOjVHNcoM
 dJERggCWJcuJtK2mLKj5I6Xcco3dJvgXdNiSF5mFYL+o2EdwNDyqmwmBX7hNW2mEbQaK5SxWh4y
 cbpTKEg5wL0lSPtaaa102TvlWB0TIZ8=
X-Proofpoint-ORIG-GUID: iNzXF9Ose7tvWoKzgo0dgomLrWG0YN2I
X-Proofpoint-GUID: iNzXF9Ose7tvWoKzgo0dgomLrWG0YN2I
X-Authority-Analysis: v=2.4 cv=GK841ONK c=1 sm=1 tr=0 ts=6a39742d cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=GbPsI2Ihf5RTnMjR_gZv:22 a=VwQbUJbxAAAA:8 a=3Jhqao3C4D3DWECJMaUA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIyMDE3MyBTYWx0ZWRfX7/OXSoPOqNyb
 kyJhIOxocm+a42M708tgK/YZsXC1v02NwPYMD0BjEvqsCgGb8e8G1yiSIxLRWZn2qRRrOXWJvOx
 nyuLNxjS0x+cgvIOU5yWc7mJHZYRgyNosHr6y5b2wcuu8p9W4aJ6MmTgpHKL7St17VVIpgqP8Rx
 4M8+QjiE6atwgMGTt7cGS/1CXEZa0YZd6fYsjE1LxPjwwVvy8NR3hEeZdl7zWytIR18Ra0WcHz0
 zLjOVf+K5MNv711xW/NRK9OGVko92KCs1JDrMFiVba3/7D8F0pqYdn6t+D1l1tLyw31Z63YGw99
 Miw8BRlRdoD5kDqHxnST7YtCmpkEbCd9uP3wEWGrVjw5WVhCpOMMQTkd6U8US8VhUMYgz5mVwAj
 3S3e4PxiFOyrsj7+kXjds48PKyjVnXita9nVwYobqgu08PNh4m4t4uAtzafQuWbcYfXgCIzUlho
 Wzvso4Z4ubyXqYnj9NA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-22_03,2026-06-22_01,2025-10-01_01

From: Keith Busch <kbusch@kernel.org>

Rather than assume EIO, set the actual reported status for user space
informational purposes.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 block/fops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/fops.c b/block/fops.c
index 15783a6180dec..f237d6cab8975 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -218,7 +218,7 @@ static ssize_t __blkdev_direct_IO(struct kiocb *iocb,=
 struct iov_iter *iter,
=20
 		ret =3D blkdev_iov_iter_get_pages(bio, iter, bdev);
 		if (unlikely(ret)) {
-			bio_endio_status(bio, BLK_STS_IOERR);
+			bio_endio_errno(bio, ret);
 			break;
 		}
 		if (iocb->ki_flags & IOCB_NOWAIT) {
--=20
2.52.0

