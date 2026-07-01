Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E27D3B52F8
	for <dm-devel@lists.linux.dev>; Wed,  1 Jul 2026 08:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782894071; cv=none; b=HTO9m8Pti4VvBQg3ZsufCxJzL6Hsc4+VGTRUrLdkGqrqzYhM4zxRLlDQ5drT2sEccUpMnz1l7eLWr7VS0+5AagclKjvtNPL0DkTU0Jzu//lEJ+5ASs7UpW2uVS9FdILTxTTJlMb720NaxS7lGACggLPWMcnabj7Vazr5yZbWxIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782894071; c=relaxed/simple;
	bh=6aWBc2ETLyxbPHLI+3ABcRShCBxJaGpkM/unpqd+Kf0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=L7e9c1F+xYDTK+LWKDtX7leqZL7KhQY5cvdnbzuitjx2Fu7ZCUfko0Dhj/mfaT/yELY7v7Qimu0FA3V0EYyxuDnGFdRiglfJtneGKP34aXGL6V6LxtU7DMi791S21jqIUifl7MwrJzSLztd1MV06/TJ56VvFgPPGRRKSfFZXDVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=DH6YZZgB; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="DH6YZZgB"
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6618FfWW3041078;
	Wed, 1 Jul 2026 01:21:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=PPS06212021; bh=AKKu56ZgS
	9ubUrxUx2ApmjVOoTD+umpID06Hs4j9ekk=; b=DH6YZZgBEVimEFKbNAJ79KL8C
	wFbPaaCVEDxiuXd92yq/+BjVeI9+4FKrQSoNglsDozDyXrucqagAnHPo18H6mBhE
	aZ+O9fHy5v8sk5cLNOQPhtPmb9cKL/YqNtt9IZa3hFLz0APKet5MfsL/ae4TMGOk
	A/vaoyW/VmQebfj9KCLj+GRrno+s3yoEbxVtSJopZjZ/9miGV7pZwpBwd6ebB8ow
	Dw6pFhkhjj///vAttoitl4t1L8mINtDUh9t9WrauR2jvDQkO+eA4fK6wmpTjgJh7
	b7WjhM58JaExzVLhYnWgtCNptufhDHXeXXqPg72DdO+pECTT0pUhZR4+Ebgrw==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4f29synat6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Wed, 01 Jul 2026 01:21:05 -0700 (PDT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Wed, 1 Jul 2026 01:21:05 -0700
Received: from pek-lpd-ccm4.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Wed, 1 Jul 2026 01:21:03 -0700
From: Jiangong.Han <jiangong.han@windriver.com>
To: <agk@redhat.com>, <snitzer@kernel.org>, <mpatocka@redhat.com>,
        <bmarzins@redhat.com>
CC: <dm-devel@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
        <jiangong.han@windriver.com>
Subject: [PATCH] dm: Use `clear_and_wake_up_bit()` in device mapper
Date: Wed, 1 Jul 2026 16:21:02 +0800
Message-ID: <20260701082102.3321398-1-jiangong.han@windriver.com>
X-Mailer: git-send-email 2.37.3
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: TrNtiHZoIMiHUOIS7buzscLqEjsrSqaN
X-Authority-Analysis: v=2.4 cv=HsJG3UTS c=1 sm=1 tr=0 ts=6a44cdf1 cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22
 a=HK-ge7EqtdluswH-FwHe:22 a=SiqW3_QkAAAA:8 a=t7CeM3EgAAAA:8
 a=0sXvDpdg966-iehJYB8A:9 a=0-oVHmElw7bdUHZZ8WX8:22 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-ORIG-GUID: TrNtiHZoIMiHUOIS7buzscLqEjsrSqaN
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAxMDA4NSBTYWx0ZWRfX2LxYDCd4aQw3
 hx4QlSyP6N3xcxWLI1AVgJTonjZfgyalqAfJRUBiuHmg47CWEk33D3JsRAHaKbCAOzn7petKDM1
 ni0kbzlPUlZT4LNi2aRMSXOnLka3mroUFHma2FiisC+4qXksDZb7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAxMDA4NSBTYWx0ZWRfXy+zGYTHiHZWz
 Ky3Y3/IbCPB94ZAkFxNI067MJbHlfuIu8AjhASYEvnxJk/CcuonVBzjkkZsRejVFKwXCnFHOHfi
 Xv2mTFENHPlhgBY5BxAR0iQfTUOp8t20fbN6oyY1I3hSiWIZcsGqDxmXJ9IfESmcI+Ad7hvlkBj
 psSDoCGSWfzlMwM+cDJWXQFhHSJrV4to/LevOA+7TIUXZ2Wa2pX2PgXQWWFhoIhFGw7vC1yj8bV
 0RFxQVRK03haZfXnZnAY/oorBwl5XMF+/5REbVXFI7xRF398O8Ti1NaMn3CeYXm49jIOu5DD72M
 CRk0TMnr5CavnANvS6O8d0mk7TCxdA5pjsda48qLB3vZTwBds+6JGyqtRAj4GtjDccehxUbuzzB
 9jH4leKtVvTT/Ss8ImEuHGKDvZizmmuHq0Xtv1tLvHHKJWD+vf1JPLuQWJYfDroJAQZAyWrd5H/
 xANGgzsNjilekEPxwwg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-01_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 clxscore=1011 impostorscore=0 adultscore=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607010085

The helper was introduced in 'commit 8236b0ae31c83 ("bdi: wake up
concurrent wb_shutdown() callers.")' as a generic way of doing the same
sequence of operations:
	clear_bit_unlock();
	smp_mb__after_atomic();
	wake_up_bit();

The helper was first implemented to avoid bugs caused by forgetting to
call `wake_up_bit()` after `clear_bit_unlock()`. Replace the open-coded
sequence with the helper to avoid duplicate code and reduce code paths
to maintain.
Suggested-by: code@agatha.dev
Link: https://kernelnewbies.org/Beginner%20Cleanup%20and%20Refactor%20Tasks%20by%20Agatha%20Isabelle%20Moreira#task_001
Link: https://kernelnewbies.org/Beginner%20Cleanup%20and%20Refactor%20Tasks%20by%20Agatha%20Isabelle%20Moreira#task_002
Signed-off-by: Jiangong.Han <jiangong.han@windriver.com>
---
 drivers/md/dm-snap.c           | 4 +---
 drivers/md/dm-zoned-metadata.c | 8 ++------
 drivers/md/dm-zoned-reclaim.c  | 4 +---
 3 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 1489fda9d24a..c8a9ca1eeae7 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -911,9 +911,7 @@ static int init_hash_tables(struct dm_snapshot *s)
 
 static void merge_shutdown(struct dm_snapshot *s)
 {
-	clear_bit_unlock(RUNNING_MERGE, &s->state_bits);
-	smp_mb__after_atomic();
-	wake_up_bit(&s->state_bits, RUNNING_MERGE);
+	clear_and_wake_up_bit(RUNNING_MERGE, &s->state_bits);
 }
 
 static struct bio *__release_queued_bios_after_merge(struct dm_snapshot *s)
diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index f4f81c79a080..094b63215882 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -519,9 +519,7 @@ static void dmz_mblock_bio_end_io(struct bio *bio)
 	else
 		flag = DMZ_META_READING;
 
-	clear_bit_unlock(flag, &mblk->state);
-	smp_mb__after_atomic();
-	wake_up_bit(&mblk->state, flag);
+	clear_and_wake_up_bit(flag, &mblk->state);
 
 	bio_put(bio);
 }
@@ -1910,9 +1908,7 @@ void dmz_unlock_zone_reclaim(struct dm_zone *zone)
 	WARN_ON(dmz_is_active(zone));
 	WARN_ON(!dmz_in_reclaim(zone));
 
-	clear_bit_unlock(DMZ_RECLAIM, &zone->flags);
-	smp_mb__after_atomic();
-	wake_up_bit(&zone->flags, DMZ_RECLAIM);
+	clear_and_wake_up_bit(DMZ_RECLAIM, &zone->flags);
 }
 
 /*
diff --git a/drivers/md/dm-zoned-reclaim.c b/drivers/md/dm-zoned-reclaim.c
index ad9c7bc21d54..c041413c729e 100644
--- a/drivers/md/dm-zoned-reclaim.c
+++ b/drivers/md/dm-zoned-reclaim.c
@@ -106,9 +106,7 @@ static void dmz_reclaim_kcopy_end(int read_err, unsigned long write_err,
 	else
 		zrc->kc_err = 0;
 
-	clear_bit_unlock(DMZ_RECLAIM_KCOPY, &zrc->flags);
-	smp_mb__after_atomic();
-	wake_up_bit(&zrc->flags, DMZ_RECLAIM_KCOPY);
+	clear_and_wake_up_bit(DMZ_RECLAIM_KCOPY, &zrc->flags);
 }
 
 /*
-- 
2.37.3

