Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8349722EE0
	for <dm-devel@lists.linux.dev>; Wed, 17 Jan 2024 18:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705515532; cv=none; b=QLl2Hynxe72AizQeZXpy4wB6RIyKLVOoonTj/mIQa8sPwovPAs+0Uw0aVZ/GsFlPw8c7e/EzkSo5UUjBpeOK5uzFEtLJJ+T72R1btkjIfbIuBbXf7Q8d/AAGNq5Om+Mm0R8jpKnyVlL/8aMNPOpobiEyjiUY1DBC+wCSPNz/nmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705515532; c=relaxed/simple;
	bh=U/HOsuSALESYByEZMxsqkpAadSe0Ph12ksQGc6g63Dw=;
	h=DKIM-Signature:Received:X-MC-Unique:Received:Received:Received:
	 Received:Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type:X-Scanned-By; b=dy2baNkeJkr6M9U7NnVWi2VVgLW+K0YAaT1CAWmruYkMuazkr/l4j2nXoZXfGz4nPGWfOYIIR6oSBvloDha151JLDDOCCmV9l3DZ/J33OPme69SwphzD+cQC7UE5ma67bwLA5rEklkgxS86C221JBhkE6HvtesCAs6goLloe8ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I4YoBYWR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I4YoBYWR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705515529;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Nfo38sqj/Duul0x+61EoOlWpjTj/qTa2XQS7wYE8wfg=;
	b=I4YoBYWRIcVFsTtDebyRSWve6pRbqGTf0P1Io7mhs5jL1Qw39x7XxAbAqbtDtecGUAM0Rg
	YO1V3+2+vJkLJMPTWIqp2rMh29EQaJ/K5cIImLYXk4FOXD6YYeWjGbtg9JM72jH8xkARLO
	9Jg8XcpTjIOQn/74RY7UH0bmfJxrB9I=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-480-JiZ-FnulNk-PA-LnLmzq5A-1; Wed,
 17 Jan 2024 13:18:48 -0500
X-MC-Unique: JiZ-FnulNk-PA-LnLmzq5A-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9F6313830090;
	Wed, 17 Jan 2024 18:18:47 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 926BF492BE6;
	Wed, 17 Jan 2024 18:18:47 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 8A7DF30C039C; Wed, 17 Jan 2024 18:18:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 89C883FB50;
	Wed, 17 Jan 2024 19:18:47 +0100 (CET)
Date: Wed, 17 Jan 2024 19:18:47 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Yu Kuai <yukuai3@huawei.com>, Song Liu <song@kernel.org>, 
    David Jeffery <djeffery@redhat.com>, Li Nan <linan122@huawei.com>
cc: dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, 
    Mike Snitzer <msnitzer@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>, 
    Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 2/7] md: fix a race condition when stopping the sync thread
In-Reply-To: <e5e8afe2-e9a8-49a2-5ab0-958d4065c55e@redhat.com>
Message-ID: <8fb335e-6d2c-dbb5-d7-ded8db5145a@redhat.com>
References: <e5e8afe2-e9a8-49a2-5ab0-958d4065c55e@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

Note that md_wakeup_thread_directly is racy - it will do nothing if the
thread is already running or it may cause spurious wake-up if the thread
is blocked in another subsystem.

In order to eliminate the race condition, we will retry
md_wakeup_thread_directly after 0.1 seconds.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org	# v6.7
Fixes: 130443d60b1b ("md: refactor idle/frozen_sync_thread() to fix deadlock")

---
 drivers/md/md.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/md/md.c
===================================================================
--- linux-2.6.orig/drivers/md/md.c
+++ linux-2.6/drivers/md/md.c
@@ -4889,6 +4889,7 @@ static void stop_sync_thread(struct mdde
 
 	mddev_unlock(mddev);
 
+retry:
 	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 	/*
 	 * Thread might be blocked waiting for metadata update which will now
@@ -4898,9 +4899,11 @@ static void stop_sync_thread(struct mdde
 	if (work_pending(&mddev->sync_work))
 		flush_work(&mddev->sync_work);
 
-	wait_event(resync_wait,
+	if (!wait_event_timeout(resync_wait,
 		   !test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||
-		   (check_seq && sync_seq != atomic_read(&mddev->sync_seq)));
+		   (check_seq && sync_seq != atomic_read(&mddev->sync_seq)),
+		   HZ / 10))
+		goto retry;
 
 	if (locked)
 		mddev_lock_nointr(mddev);

