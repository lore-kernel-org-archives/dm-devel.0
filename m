Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F07462374B
	for <dm-devel@lists.linux.dev>; Wed, 17 Jan 2024 18:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705515482; cv=none; b=PhL5kZZUVGAhJnDT83ncwofSp312LbV1Jwk0xBs71dvtgQGug7U3IsHv4KFadlQMzXWkWlFuLnRVPNXZt/KpdbPCb5vuZJDV7GmhozcWvd3BUZq6df4LHjw3AtSV3JI37vf/WFSE9t/9GWNVsjcI+e6ZTKEO1oIk4isOpapAE1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705515482; c=relaxed/simple;
	bh=odaoLRetP6yq9eTrctHLbHR7C/CXSfIABfBoEMR3r/I=;
	h=DKIM-Signature:Received:X-MC-Unique:Received:Received:Received:
	 Received:Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type:X-Scanned-By; b=qVEHhy3eaYwmEgZAIc9ve1Y9Ohjtaz9c7R+XKsts+rn6Aa+Ll+SGz28YEAFxiPRKCoYhbUoN5Y9ABuAJJsRMkFcQIP1+0YSOPe/eQV+VrBCULUaDMesTS3w6vSJUEjsBvpXrhFLDHF31dGKvFQNY8qcJllT7NqUKbp1NglgyfYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y961S+sL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y961S+sL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705515479;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OQbrENSM13PTlCIUi4M0i7iy9OOjiGDINAdzr/zFb8Q=;
	b=Y961S+sLOFwfqd1ZJzgjOmDcLceT+oCBoh9iBhxB/hznKxahDRR6TOPEFy2ul6lNSijreq
	byEOVMs1BaGHhMtNsMcp/HwxbxHsV+aFefbJqHdaAr47j3DTMa0DZsTdCRSjwTWfJL9tg9
	XE4NaUrxm1zFhaKIXSWGl04t+u4JnRQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-587-gmWMPmWgONCymp9Oh6vp4A-1; Wed, 17 Jan 2024 13:17:58 -0500
X-MC-Unique: gmWMPmWgONCymp9Oh6vp4A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CF37A885626;
	Wed, 17 Jan 2024 18:17:57 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C6E9640C6EB9;
	Wed, 17 Jan 2024 18:17:57 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id BDF2C30C039C; Wed, 17 Jan 2024 18:17:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id BD1973FB50;
	Wed, 17 Jan 2024 19:17:57 +0100 (CET)
Date: Wed, 17 Jan 2024 19:17:57 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Yu Kuai <yukuai3@huawei.com>, Song Liu <song@kernel.org>, 
    David Jeffery <djeffery@redhat.com>, Li Nan <linan122@huawei.com>
cc: dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, 
    Mike Snitzer <msnitzer@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>, 
    Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 1/7] md: Revert fa2bbff7b0b4 ("md: synchronize flush io with
 array reconfiguration")
In-Reply-To: <e5e8afe2-e9a8-49a2-5ab0-958d4065c55e@redhat.com>
Message-ID: <2c29cbd4-736d-2f23-2bc-636881c150d6@redhat.com>
References: <e5e8afe2-e9a8-49a2-5ab0-958d4065c55e@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

The commit fa2bbff7b0b4 breaks the LVM2 test shell/integrity-caching.sh,
so let's revert it.

sysrq: Show Blocked State
task:lvm             state:D stack:0     pid:8275  tgid:8275  ppid:1373   flags:0x00000002
Call Trace:
 <TASK>
 __schedule+0x228/0x570
 ? __percpu_ref_switch_mode+0xb7/0x1b0
 schedule+0x29/0xa0
 mddev_suspend+0xec/0x1a0 [md_mod]
 ? housekeeping_test_cpu+0x30/0x30
 dm_table_postsuspend_targets+0x34/0x50 [dm_mod]
 __dm_destroy+0x1c5/0x1e0 [dm_mod]
 ? table_clear+0xa0/0xa0 [dm_mod]
 dev_remove+0xd4/0x110 [dm_mod]
 ctl_ioctl+0x2e1/0x570 [dm_mod]
 dm_ctl_ioctl+0x5/0x10 [dm_mod]
 __x64_sys_ioctl+0x85/0xa0
 do_syscall_64+0x5d/0x1a0
 entry_SYSCALL_64_after_hwframe+0x46/0x4e

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: fa2bbff7b0b4 ("md: synchronize flush io with array reconfiguration")

---
 drivers/md/md.c |   21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

Index: linux-2.6/drivers/md/md.c
===================================================================
--- linux-2.6.orig/drivers/md/md.c
+++ linux-2.6/drivers/md/md.c
@@ -543,9 +543,6 @@ static void md_end_flush(struct bio *bio
 	rdev_dec_pending(rdev, mddev);
 
 	if (atomic_dec_and_test(&mddev->flush_pending)) {
-		/* The pair is percpu_ref_get() from md_flush_request() */
-		percpu_ref_put(&mddev->active_io);
-
 		/* The pre-request flush has finished */
 		queue_work(md_wq, &mddev->flush_work);
 	}
@@ -565,7 +562,12 @@ static void submit_flushes(struct work_s
 	rdev_for_each_rcu(rdev, mddev)
 		if (rdev->raid_disk >= 0 &&
 		    !test_bit(Faulty, &rdev->flags)) {
+			/* Take two references, one is dropped
+			 * when request finishes, one after
+			 * we reclaim rcu_read_lock
+			 */
 			struct bio *bi;
+			atomic_inc(&rdev->nr_pending);
 
 			atomic_inc(&rdev->nr_pending);
 			rcu_read_unlock();
@@ -577,6 +579,7 @@ static void submit_flushes(struct work_s
 			atomic_inc(&mddev->flush_pending);
 			submit_bio(bi);
 			rcu_read_lock();
+			rdev_dec_pending(rdev, mddev);
 		}
 	rcu_read_unlock();
 	if (atomic_dec_and_test(&mddev->flush_pending))
@@ -629,18 +632,6 @@ bool md_flush_request(struct mddev *mdde
 	/* new request after previous flush is completed */
 	if (ktime_after(req_start, mddev->prev_flush_start)) {
 		WARN_ON(mddev->flush_bio);
-		/*
-		 * Grab a reference to make sure mddev_suspend() will wait for
-		 * this flush to be done.
-		 *
-		 * md_flush_reqeust() is called under md_handle_request() and
-		 * 'active_io' is already grabbed, hence percpu_ref_is_zero()
-		 * won't pass, percpu_ref_tryget_live() can't be used because
-		 * percpu_ref_kill() can be called by mddev_suspend()
-		 * concurrently.
-		 */
-		WARN_ON(percpu_ref_is_zero(&mddev->active_io));
-		percpu_ref_get(&mddev->active_io);
 		mddev->flush_bio = bio;
 		bio = NULL;
 	}

