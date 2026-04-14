Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE68E1C01
	for <dm-devel@lists.linux.dev>; Tue, 14 Apr 2026 19:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776193441; cv=none; b=fwffpis8RdoUoVIipigBp30Yc9xdJ5VjUmQuErq8w20osEVt0RaGC5rBanuZCyiiG7W3kjq/eBYotjqJqqLo7PQbZu5yBWZPhzXlCNCC7xHNFOj/IQe5c1e5Gd870RgelnhNSB6P+ng2vxq98LjPRt80TsBQAmkMxu4uK+Lf0uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776193441; c=relaxed/simple;
	bh=cTXsm8tj4+Aew6KZ7P/9JHRSQEBBa68fwxqOtIF4p6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=jhSH4cytoM+D1qA5e0S3YQLQmuKcIXdc9tiVCmKT+YqaemvAuQBZdJDKM9wcqFUJhlju1lXfBFw9yMdb9CRFO2d1bcFlgkrxLsNl8nRkmkwij9ljzIG8p8AT2QGihcR+IU5USvpV0IRnLyah3GmUNVX9x/khgcQqVH1Dcl6PEKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G8JI8gBq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G8JI8gBq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776193438;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0rmEvvdam10Cf8MxTAK66l5x4XHEJkIkPLQ3pRrmcAw=;
	b=G8JI8gBqRfIQS4oDp0J3Oz8ZM1f4kGTKbX398/WFSSm6bPsP/fZx+hPV76xWTJ+cAVJ98r
	5EKh8wB6d8/rg/XV6HIKCgu1m/+1BsUsAeJHkTnQQbNoF09BocjJW1wAByzx+vPtyFxVgo
	aB/OKhSlcysHgGyedFhsOq0cYHYJtRw=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-288-FaphZKyqM1qFakKujGcX6g-1; Tue,
 14 Apr 2026 15:03:55 -0400
X-MC-Unique: FaphZKyqM1qFakKujGcX6g-1
X-Mimecast-MFC-AGG-ID: FaphZKyqM1qFakKujGcX6g_1776193434
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BBB7A195608F;
	Tue, 14 Apr 2026 19:03:53 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4385C1800451;
	Tue, 14 Apr 2026 19:03:52 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 63EJ3pfS1946415
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 14 Apr 2026 15:03:51 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 63EJ3oId1946414;
	Tue, 14 Apr 2026 15:03:50 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Yang Xiuwei <yangxiuwei@kylinos.cn>
Cc: Yu Kuai <yukuai@alb-78bjiv52429oh8qptp.cn-shenzhen.alb.aliyuncs.com>,
        Li Nan <linan666@huaweicloud.com>, Song Liu <song@kernel.org>,
        linux-raid@vger.kernel.org, dm-devel@lists.linux.dev,
        Xiao Ni <xni@redhat.com>, Nigel Croxon <ncroxon@redhat.com>
Subject: [RFC PATCH] dm-raid: only requeue bios when dm is suspending.
Date: Tue, 14 Apr 2026 15:03:50 -0400
Message-ID: <20260414190350.1946406-1-bmarzins@redhat.com>
In-Reply-To: <ad6FNUtSCS_zTrHW@redhat.com>
References: <ad6FNUtSCS_zTrHW@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: W7vRhKKh_iCyCVQBIsk6fV6WHWXpE-jUyMJ20SB6Fe8_1776193434
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

returning DM_MAPIO_REQUEUE from the target map() function only requeues
the bio during noflush suspends. During regular operations or during
flushing suspends, it fails the bio. Failing the bio during flushing
suspends is the correct behavior here. We cannot handle the bio, and we
cannot suspends while it is outstanding. But during normal operations,
we should not push the bio back to do. Instead, wait for the reshape
to be resumed.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---

Yang Xiuwei, if you are still able to see I/O errors during LVM testing,
does this patch fix them?

 drivers/md/dm-raid.c | 7 +++++++
 drivers/md/md.h      | 1 +
 drivers/md/raid5.c   | 6 ++++--
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 4bacdc499984..cac61d57e7e2 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3831,6 +3831,7 @@ static void raid_presuspend(struct dm_target *ti)
 	 * resume, raid_postsuspend() is too late.
 	 */
 	set_bit(RT_FLAG_RS_FROZEN, &rs->runtime_flags);
+	WRITE_ONCE(mddev->dm_suspending, 1);
 
 	if (!reshape_interrupted(mddev))
 		return;
@@ -3847,6 +3848,9 @@ static void raid_presuspend(struct dm_target *ti)
 static void raid_presuspend_undo(struct dm_target *ti)
 {
 	struct raid_set *rs = ti->private;
+	struct mddev *mddev = &rs->md;
+
+	WRITE_ONCE(mddev->dm_suspending, 0);
 
 	clear_bit(RT_FLAG_RS_FROZEN, &rs->runtime_flags);
 }
@@ -3854,6 +3858,7 @@ static void raid_presuspend_undo(struct dm_target *ti)
 static void raid_postsuspend(struct dm_target *ti)
 {
 	struct raid_set *rs = ti->private;
+	struct mddev *mddev = &rs->md;
 
 	if (!test_and_set_bit(RT_FLAG_RS_SUSPENDED, &rs->runtime_flags)) {
 		/*
@@ -3864,6 +3869,8 @@ static void raid_postsuspend(struct dm_target *ti)
 		mddev_suspend(&rs->md, false);
 		rs->md.ro = MD_RDONLY;
 	}
+	WRITE_ONCE(mddev->dm_suspending, 0);
+
 }
 
 static void attempt_restore_of_faulty_devices(struct raid_set *rs)
diff --git a/drivers/md/md.h b/drivers/md/md.h
index ac84289664cd..e8d7332c5cb9 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -463,6 +463,7 @@ struct mddev {
 	int				delta_disks, new_level, new_layout;
 	int				new_chunk_sectors;
 	int				reshape_backwards;
+	int				dm_suspending;
 
 	struct md_thread __rcu		*thread;	/* management thread */
 	struct md_thread __rcu		*sync_thread;	/* doing resync or reconstruct */
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 8854e024f311..d528263f92a3 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6042,8 +6042,10 @@ static enum stripe_result make_stripe_request(struct mddev *mddev,
 	raid5_release_stripe(sh);
 out:
 	if (ret == STRIPE_SCHEDULE_AND_RETRY && reshape_interrupted(mddev)) {
-		bi->bi_status = BLK_STS_RESOURCE;
-		ret = STRIPE_WAIT_RESHAPE;
+		if (!mddev_is_dm(mddev) || READ_ONCE(mddev->dm_suspending)) {
+			bi->bi_status = BLK_STS_RESOURCE;
+			ret = STRIPE_WAIT_RESHAPE;
+		}
 		pr_err_ratelimited("dm-raid456: io across reshape position while reshape can't make progress");
 	}
 	return ret;
-- 
2.50.1

