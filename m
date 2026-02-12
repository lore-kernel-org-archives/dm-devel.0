Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB6F200C2
	for <dm-devel@lists.linux.dev>; Thu, 12 Feb 2026 18:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770919547; cv=none; b=oDc11MQZjLi4ocrPjg8mKjmQv7uEJZ+xE3HaVGxvZRDTmRqaKFo17zSOUfiDeguD66I3nXJcELeV2JrQHyehikKyfW6q0QhrkxAFtx3g/MWHmm/J0lHupDNuFky/X7jJBmUEeuYrMVRSpHZnZ4j3vEn4ZPUyVtgCU0poXUAzzLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770919547; c=relaxed/simple;
	bh=YKjWTk6wKM5JJ6LgYDdkxSVUz8K8iLx1pREUcjQdavk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=b2fgfQl4sPnwMT03y9uoQE8sDLDNN21PADLBhEc/RbPC63SDz9SmlVSL982Zhy5axUKGzkAo2nWbhkCd5x4yVFONZ6aGqNjEKM85m7c3tvnnRRzlbYSm3LVocPxVhbPYrpydtFeDTlc8etBN8QZyjPoIRGvGmEeO5yMbY09fLaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ILX7PHEn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ILX7PHEn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770919545;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=cyzWq1J4t8CqXOOi7BR/1JMfHIixthKhaYPekWHzqL4=;
	b=ILX7PHEn7FcOSVS9K6CcxY8hYPMXZXbV20MoZOAueOChfufHN9Rd95y6U9Mfi7bgQcI4At
	bS8NXw9M13vPoDfHC0mmtNZenJJ64b/NyxBrWYHG4+gY2uMiMYtZPikyWerXcqsX/UVHb4
	KLRCaruXedjCBI5WRi39WFV8bZWovRg=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-499-4loMLB6nMRWdNOm2ZKqjJA-1; Thu,
 12 Feb 2026 13:05:43 -0500
X-MC-Unique: 4loMLB6nMRWdNOm2ZKqjJA-1
X-Mimecast-MFC-AGG-ID: 4loMLB6nMRWdNOm2ZKqjJA_1770919543
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 08C011955BF9;
	Thu, 12 Feb 2026 18:05:43 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 67E151800669;
	Thu, 12 Feb 2026 18:05:42 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 61CI5f6X1154484
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 12 Feb 2026 13:05:41 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 61CI5fAg1154483;
	Thu, 12 Feb 2026 13:05:41 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@lists.linux.dev, Kevin Wolf <kwolf@redhat.com>,
        Hanna Czenczek <hreitz@redhat.com>,
        Martin Wilck <martin.wilck@suse.com>
Subject: [PATCH] dm-mpath: don't stop probing paths at presuspend
Date: Thu, 12 Feb 2026 13:05:41 -0500
Message-ID: <20260212180541.1154475-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: whOOXBc48s-zxfwMhaaVGQzDsyXQo6bXcMGcywR0lAw_1770919543
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Commit 5c977f102315 ("dm-mpath: Don't grab work_mutex while probing
paths"), added code to make multipath quit probing paths early, if it
was trying to suspend. This isn't necessary. It was just an optimization
to try to keep path probing from delaying a suspend. However it causes
problems with the intended user of this code, qemu. The path probing
code was added because failed ioctls to multipath devices don't cause
paths to fail in cases where a regular IO failure would.

If an ioctl to a path failed because the path was down, and the
multipath device had passed presuspend, the M_MPATH_PROBE_PATHS ioctl
would exit early, without probing the path. The caller would then retry
the original ioctl, hoping to use a different path. But if there was
only one path in the pathgroup, it would pick the same non-working path
again, even if there were working paths in other pathgroups.

ioctls to a suspended dm device will return -EAGAIN, notifying the
caller that the device is suspended, but ioctls to a device that is just
preparing to suspend won't (and in general, shouldn't). This means that
the caller (qemu in this case) would get into a tight loop where it
would issue an ioctl that failed, skip probing the paths because the
device had already passed presuspend, and start over issuing the ioctl
again. This would continue until the multipath device finally fully
suspended, or the caller gave up and failed the ioctl.

multipath's path probing code could return -EAGAIN in this case, and the
caller could delay a bit before retrying, but the whole purpose of
skipping the probe after presuspend was to speed things up, and that
would just slow them down. Instead, remove the is_suspending flag, and
check dm_suspended() instead to decide whether to exit the probing code
early. This means that when the probing code exits early, future ioctls
will also be delayed, because the device is fully suspended.

Fixes: 5c977f102315 ("dm-mpath: Don't grab work_mutex while probing paths")
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/dm-mpath.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index de03f9b06584..09a5544bc8b1 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -102,7 +102,6 @@ struct multipath {
 	struct bio_list queued_bios;
 
 	struct timer_list nopath_timer;	/* Timeout for queue_if_no_path */
-	bool is_suspending;
 };
 
 /*
@@ -1749,9 +1748,6 @@ static void multipath_presuspend(struct dm_target *ti)
 {
 	struct multipath *m = ti->private;
 
-	spin_lock_irq(&m->lock);
-	m->is_suspending = true;
-	spin_unlock_irq(&m->lock);
 	/* FIXME: bio-based shouldn't need to always disable queue_if_no_path */
 	if (m->queue_mode == DM_TYPE_BIO_BASED || !dm_noflush_suspending(m->ti))
 		queue_if_no_path(m, false, true, __func__);
@@ -1774,7 +1770,6 @@ static void multipath_resume(struct dm_target *ti)
 	struct multipath *m = ti->private;
 
 	spin_lock_irq(&m->lock);
-	m->is_suspending = false;
 	if (test_bit(MPATHF_SAVED_QUEUE_IF_NO_PATH, &m->flags)) {
 		set_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags);
 		clear_bit(MPATHF_SAVED_QUEUE_IF_NO_PATH, &m->flags);
@@ -2098,7 +2093,7 @@ static int probe_active_paths(struct multipath *m)
 		if (m->current_pg == m->last_probed_pg)
 			goto skip_probe;
 	}
-	if (!m->current_pg || m->is_suspending ||
+	if (!m->current_pg || dm_suspended(m->ti) ||
 	    test_bit(MPATHF_QUEUE_IO, &m->flags))
 		goto skip_probe;
 	set_bit(MPATHF_DELAY_PG_SWITCH, &m->flags);
@@ -2107,7 +2102,7 @@ static int probe_active_paths(struct multipath *m)
 
 	list_for_each_entry(pgpath, &pg->pgpaths, list) {
 		if (pg != READ_ONCE(m->current_pg) ||
-		    READ_ONCE(m->is_suspending))
+		    dm_suspended(m->ti))
 			goto out;
 		if (!pgpath->is_active)
 			continue;
-- 
2.50.1

