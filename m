Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5AEE22EE0
	for <dm-devel@lists.linux.dev>; Wed, 17 Jan 2024 18:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705515622; cv=none; b=l7WrmLM7KsbuUMkKN3KtsQFvO1W9C8dAtautUsSnGH5rdADmSxDGe3DX/hk3MwzyaWWrZnQp0HwJElFsnwK5sclKPmo9Tane4OCy2fRAdm4KZfh2iuB3JcPKvNsv1VJkm4HvGcbxWe1odC+pLE5kNU+1458dRBOW38qb6vWqGas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705515622; c=relaxed/simple;
	bh=etaA6fhQ5wBt/qt9TCxoYJgxUmhq3AgF6IM1tgMIjUw=;
	h=DKIM-Signature:Received:X-MC-Unique:Received:Received:Received:
	 Received:Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type:X-Scanned-By; b=EtH3ajJXODze4aA6vNJq4h681ZG5sFFNtjmcnmSm7VeZLJbHd1HH30MGwhXSpTf+4PwaViAFL8/j74q47eMi/8bVRVn1SzTdjOFb9SYIssGHvS7KpOuoEXKEd+G9DDtSChTs6JyAX4iWOY4E16vmTHnl4rj7CRa4hV1U3KvAsyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VK30q1O5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VK30q1O5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705515619;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8ivHleY87+YYgQ50ZwaeuC85r8tVB0aEOPq+W73pVX4=;
	b=VK30q1O5F0oCOFPC8V3v5uHMhyz4rutpB1elIZaLqE6vLuD/f6IKIUhMZt/RbP/GVY7Br8
	DEaYl0s5X85OGQ0tgcMUsw5nPodSKnnqrFefeiTY18ZEh4PZT4Zer7PO1fKej536SkYcTd
	t79UDM3Yabl5AY9ViHcxoaW7To4Zhyg=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-562-9QVdjnIHMv67seNjxi-7sQ-1; Wed,
 17 Jan 2024 13:20:14 -0500
X-MC-Unique: 9QVdjnIHMv67seNjxi-7sQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 99E021C41B21;
	Wed, 17 Jan 2024 18:20:13 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9386DFEEE;
	Wed, 17 Jan 2024 18:20:13 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 8B42E30C039C; Wed, 17 Jan 2024 18:20:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 8A80B3FB50;
	Wed, 17 Jan 2024 19:20:13 +0100 (CET)
Date: Wed, 17 Jan 2024 19:20:13 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Yu Kuai <yukuai3@huawei.com>, Song Liu <song@kernel.org>, 
    David Jeffery <djeffery@redhat.com>, Li Nan <linan122@huawei.com>
cc: dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, 
    Mike Snitzer <msnitzer@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>, 
    Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 4/7] md: call md_reap_sync_thread from __md_stop_writes
In-Reply-To: <e5e8afe2-e9a8-49a2-5ab0-958d4065c55e@redhat.com>
Message-ID: <ceeca667-ecc5-a776-8c89-9bf6facb93c9@redhat.com>
References: <e5e8afe2-e9a8-49a2-5ab0-958d4065c55e@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

The commit f52f5c71f3d4 ("md: fix stopping sync thread") breaks the LVM2
test shell/lvconvert-raid-reshape-linear_to_raid6-single-type.sh

There are many places that test for MD_RECOVERY_RUNNING or
mddev->sync_thread. If we don't reap the thread, they would be confused.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: f52f5c71f3d4 ("md: fix stopping sync thread")
Cc: stable@vger.kernel.org	# v6.7

---
 drivers/md/md.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-2.6/drivers/md/md.c
===================================================================
--- linux-2.6.orig/drivers/md/md.c
+++ linux-2.6/drivers/md/md.c
@@ -6308,6 +6308,12 @@ static void md_clean(struct mddev *mddev
 static void __md_stop_writes(struct mddev *mddev)
 {
 	stop_sync_thread(mddev, true, false);
+
+	if (mddev->sync_thread) {
+		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
+		md_reap_sync_thread(mddev);
+	}
+
 	del_timer_sync(&mddev->safemode_timer);
 
 	if (mddev->pers && mddev->pers->quiesce) {

