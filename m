Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A25112BEA1
	for <dm-devel@lists.linux.dev>; Mon, 26 Feb 2024 14:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958663; cv=none; b=OHj8l9sNtKBNs1bycoTLo+9dcc8XBegKsuf1BW627liCXItMnhOQpiAqmZ7AjSdc2ClfPW7ikl1CGNdO98DOuMPGmkjZrt9B5Kkmnfbo73CHboQ/6JTJa2OUU2AkpOTugwy6UJt4dHpoao7rJVz6X7zPwi9Bh0lDv65DxBmREmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958663; c=relaxed/simple;
	bh=WS8wGXmQM2s1gH1iYfEEVs4FsClq44BPDrBK14QrVOA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YslmxFpgMf/FGIzhqUMVCgWuKf38WZB1CdHDJ9lTjcBYcIIbzZnL/+wLM4ElAv07V8Ije7Tak/D6zPoZBecw/Vcgv1Os1NRNBe2Nu9zg7cdkk8LVpdOWWT/0dpmlA8n/sbkSxI3fn4zrRTBlZkFodNdbgG9be/ueT9QG+dpAC/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DCHsz+Gk; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DCHsz+Gk"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41QDLLdF031418;
	Mon, 26 Feb 2024 14:43:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2023-11-20; bh=vEUYPk/vTjUcosp4mayE+HEMCQCXiWr8F/WnC06iTYQ=;
 b=DCHsz+GkTt9rNVCCdVmhEAkA5ZrezQMCfGL0y2w6tT5OrubfWdR3EMvzYZY3RbpxEZnk
 barjTYcrSibPx4+EHS/o4v7vcubTQDkDZ+RxzYFxbu2UuWmpFp7dZPmzteWCRvCrx9CK
 JM9cvc7kJtJlPsKCkCVOxaUZUiphApUhgywD4gP+oyE3KrdxaXAVg8uQOtFrI6V7YCpH
 qXMXCXCqm8Ym2+iNcby3Nxdnwd6mrTdSnqnfT9dGs2iYdyUTw8iNQUvzdk1vmBNBCHWj
 bN1sv7j7+ATNc8+eV9AD6pWoZochj9pYZZ2YdfB8onjtjQ0a+T5Dpv7yIH0LnZfssE+z Qw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wf90v4njc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Feb 2024 14:43:58 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41QESwwd001840;
	Mon, 26 Feb 2024 14:43:56 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wf6w5n9ry-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Feb 2024 14:43:56 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 41QEhuwF030519;
	Mon, 26 Feb 2024 14:43:56 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3wf6w5n9qa-1;
	Mon, 26 Feb 2024 14:43:55 +0000
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
To: Matthew Sakai <msakai@redhat.com>, dm-devel@lists.linux.dev,
        Mike Snitzer <snitzer@kernel.org>, Ken Raeburn <raeburn@redhat.com>,
        Chung Chung <cchung@redhat.com>, Thomas Jaskiewicz <tom@jaskiewicz.us>,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        John Wiele <jwiele@redhat.com>,
        "J. corwin Coburn" <corwin@hurlbutnet.net>,
        linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, dan.carpenter@linaro.org
Subject: [PATCH] dm vdo: Fix a use-after-free in load_index_save()
Date: Mon, 26 Feb 2024 06:41:35 -0800
Message-ID: <20240226144155.2101066-1-harshit.m.mogalapalli@oracle.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-26_10,2024-02-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 adultscore=0
 mlxscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402260111
X-Proofpoint-GUID: 4v26zrTyEdjYF7bZ2CgOZzmIitR6aBNZ
X-Proofpoint-ORIG-GUID: 4v26zrTyEdjYF7bZ2CgOZzmIitR6aBNZ

Smatch warns:
	drivers/md/dm-vdo/indexer/index-layout.c:1570
	load_index_save() warn: 'table' was already freed.

Store the error value in result and then free the table before
returning.

Fixes: b46d79bdb82a ("dm vdo: add deduplication index storage interface")
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
---
This is based on static analysis and only compile tested.
---
 drivers/md/dm-vdo/indexer/index-layout.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-vdo/indexer/index-layout.c b/drivers/md/dm-vdo/indexer/index-layout.c
index 1453fddaa656..18fac999e3e4 100644
--- a/drivers/md/dm-vdo/indexer/index-layout.c
+++ b/drivers/md/dm-vdo/indexer/index-layout.c
@@ -1566,10 +1566,11 @@ static int __must_check load_index_save(struct index_save_layout *isl,
 
 
 	if (table->header.type != RH_TYPE_SAVE) {
+		result = vdo_log_error_strerror(UDS_CORRUPT_DATA,
+						"unexpected index save %u header type %u",
+						instance, table->header.type);
 		vdo_free(table);
-		return vdo_log_error_strerror(UDS_CORRUPT_DATA,
-					      "unexpected index save %u header type %u",
-					      instance, table->header.type);
+		return result;
 	}
 
 	result = read_index_save_data(reader, isl, table->header.payload);
-- 
2.39.3

