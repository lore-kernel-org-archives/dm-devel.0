Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B52395ACC
	for <dm-devel@lists.linux.dev>; Mon, 20 Jul 2026 20:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784578270; cv=none; b=Yhj7FmUmtiXH29bOFvJrmTsi3VYU5v7koM/DvA2yb15qo72MCIU4AEcdgUCI+gfxeFM4RYdEtwPvPHNS7oNw/39dD7F59GnhOWYoeJeo9icx/HPw7lTDS0WzBpX2uj0zhRM+7LuviOQcjACRpPSZhwX4qnsmx7nfxKQt+P36S6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784578270; c=relaxed/simple;
	bh=OUuOHmPuAVyZLe5WHXkb7v0Ym0I+unXVLFV/t/XYvXo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=MyGE62abs3UXvGirIC+fiGiSYfPT8G1gLa+86WvRoXCaIc0azpHgMd97pxcdLiVNitKAJLCibR9YfQUPca5C6+CTqHASql4dpBdhPEn55zjHGcNiLyGWI1B9in7Q53tlJ6Nei02Ap4SeMCG0CYJ3MwX/IIO5tKYtBAtSZekWg/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=EEjuFbNK; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="EEjuFbNK"
Received: from pps.filterd (m0528004.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66KJQDfB2796050
	for <dm-devel@lists.linux.dev>; Mon, 20 Jul 2026 13:11:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2025-q2; bh=dA9VgY7XPpIvG6wKms
	Q9cynp3tOwpPa627n1rXVynfo=; b=EEjuFbNKz5JEQJxT/k6+kAi44fF0m3esd+
	ZoTE2OvJk43E3se6O9zO7dSIn9Wwkl4yzNdhRYlyXXvKcL2PJyAcSCaPHv+83qTK
	ZfMG7zDEQwCuX6oa+iPlDslagGTFV/cSDWMsVjUwz+tgtOCYHGYlY9BO7osM96p/
	IPfIdiAodCUoFyqTH/uV8ZG7mH5AefTZTFzyKQx3BrzAdcMRzWA4xRir1kECb33e
	6+XgzJtiqpHHSv7sKay5I8Ojw+w3DuyKHp8l87N2LZSAU/O8TOp+JRzGuooL37Fe
	8XgI7p6BLYvYjpg6BK9gS4fzUf9D4kNkc0ZMM1qDMVScIqpmDsTg==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4fgu4dfyy3-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <dm-devel@lists.linux.dev>; Mon, 20 Jul 2026 13:11:07 -0700 (PDT)
Received: from twshared40132.32.frc3.facebook.com (2620:10d:c0a8:1c::11) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.41; Mon, 20 Jul 2026 20:11:06 +0000
Received: by devbig197.nha3.facebook.com (Postfix, from userid 544533)
	id 890F525A00281; Mon, 20 Jul 2026 13:11:03 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <linux-block@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
CC: <dm-devel@lists.linux.dev>, <hch@lst.de>, <axboe@kernel.dk>,
        <brauner@kernel.org>, <djwong@kernel.org>, <viro@zeniv.linux.org.uk>,
        Keith
 Busch <kbusch@kernel.org>
Subject: [PATCH RESEND 0/5] block: validate direct I/O memory alignment
Date: Mon, 20 Jul 2026 13:10:52 -0700
Message-ID: <20260720201057.1862857-1-kbusch@meta.com>
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
X-Proofpoint-GUID: hRAszXuxGiQKgpkRwa6YQhqjUdx280kK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIwMDIyMCBTYWx0ZWRfX/3eRzBD1L8ak
 2aLLsPIpb+WxDTYr3xcRu7mUv1QIQlC5RkQJ76TruOPKuru3MYa/vR6kfyPFi07eo5Tps0EsW7/
 GKiWUlzdiGyr/yBlRh5cy9MBFlYktktYoBHVOM1zOhEmcscswXvpGvF0JQ60OxEKWibztjo2iLW
 hA4QfEP/2bS7fdzNgHAgnjzcKTlus0fr4px+okMmEH/80rIkapDtZV5EKfUT/TD3pF8n4UPJJWl
 jZL8PaBoJSYJNBoY+lJ7PRFxbO+0anA2zv1ECsP5+uvNPkv/iwlNKEBvMFCCbnLUMVVny8tPkPV
 g5qX6JLrqMg+iI8kfCIEXrhKWXpMr3peefv87x3GnqqdsRrT5qAYasS2kBVeHjVuQPacLP+cZ99
 iv/ISHShPi2fJ8rTx2Fdsn+IxZ3UXEyLvsIx/2gTu0P6qgdGmrE9wwLnzZfFCWApfFqKE3dwua3
 ptANRg0ZWCx5Ws/FY8Q==
X-Proofpoint-ORIG-GUID: hRAszXuxGiQKgpkRwa6YQhqjUdx280kK
X-Authority-Analysis: v=2.4 cv=NOrlPU6g c=1 sm=1 tr=0 ts=6a5e80db cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=GbPsI2Ihf5RTnMjR_gZv:22 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=VabnemYjAAAA:8
 a=rFgjrMAfHNG0gpnDTA8A:9 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIwMDIyMCBTYWx0ZWRfX2b6zk+uk8ZoY
 vcx/TpWAHH2mLm2zlESTNHOaUttbcCfRgzlBbD9x/HyQysMntrsK+db+w0NTuWkv00UfZ3AsIgG
 2EqXQg7SygoMhM6RGImr3E4X6wRSThI=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-20_05,2026-07-20_03,2025-10-01_01

From: Keith Busch <kbusch@kernel.org>

Resending in case this got lost.

This addresses the misaligned direct-io problem behind various threads:

 https://lore.kernel.org/linux-xfs/20260610145218.141369-1-cem@kernel.org=
/
 https://lore.kernel.org/all/CAC_j7i1R7oy+nRhxEjCTba=3DDUgn02w9X+p94DCu0a=
Hv5+5tKnQ@mail.gmail.com/
 https://lore.kernel.org/linux-block/ai7rnH20IYeSmY8s@gallifrey/
 https://lore.kernel.org/linux-block/20260616154009.2123183-1-kbusch@meta=
.com/

The previously tested fixes are correct as far as they go, but they
treat the symptom: they only matter because an invalid bio reaches those
drivers in the first place.

The reason it reaches them is an assumption I made when I removed
direct-io alignment checks in 5ff3f74e145a ("block: simplify direct io
validity check") and 7eac331869575 ("iomap: simplify direct io validity
check"): every bio is eventually split to the device limits, and the
upper layers cope with resulting errors once the bio has formed. Both
were optimistic assumptions. Drivers with their own ->submit_bio may
never pass through blk_mq_submit_bio()'s split, so the check never runs
for them, and as numerous threads showed, the consumers don't uniformly
handle this condition.

This series stops the invalid bio at the source instead. It validates
the buffer's alignment against the alignment limits when the bio is
built from the iov_iter. The check is folded into the bvec extraction
that already walks the vectors, so it adds only a comparison on a path
that is pinning direct-io pages anyway. Misalignment is now uniformly
rejected with EINVAL before submission for every direct-io path.

Only changes in this version are just adding the reviewers from the
previous:

https://lore.kernel.org/linux-block/20260624170905.3972095-1-kbusch@meta.=
com/

Keith Busch (5):
  block: use blkdev_iov_iter_get_pages status for errors
  block: fix dio leak on metadata mapping error
  loop: set dma_alignment from the backing file for direct I/O
  zloop: set dma_alignment from the backing files for direct I/O
  block: validate user space vectors during extraction

 block/bio.c           | 56 ++++++++++++++++++++++++++++++++++++++++---
 block/blk-map.c       |  2 +-
 block/fops.c          | 10 ++++----
 drivers/block/loop.c  | 46 ++++++++++++++++++++++++++++-------
 drivers/block/zloop.c | 35 +++++++++++++++++++--------
 fs/iomap/direct-io.c  |  1 +
 include/linux/bio.h   |  2 +-
 include/linux/uio.h   | 10 +++++++-
 lib/iov_iter.c        |  9 ++++++-
 9 files changed, 142 insertions(+), 29 deletions(-)

--=20
2.52.0

