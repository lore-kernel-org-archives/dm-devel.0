Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CFCE54F86
	for <dm-devel@lists.linux.dev>; Tue,  7 May 2024 21:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715116590; cv=none; b=B4k0Vahp52x9e431BzXntQrE7g8Y9yiZeWvZWmOTOywkiny2+iy12cqmUCh89zVaLUjcrBZqqw17japTgBYkAxK5BeKNcsT9Rdlh7CodOzt1oDnNJ/mER45aQsdSVNJ1918hgp/Zd5bRcU7X36Mjr0VgsEMzKIsyMMxJKNZTh+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715116590; c=relaxed/simple;
	bh=jA1zuVBcrIVJyQt5e7kfLmnsN9tEC23/Y5rnfpZvEPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AJuamQpzG43p+XDxzEmbx+6gemSbGTnlhFnXsaoXhPRg6vj4pEnwOoU3tPMfZdgE76WAOwUM6mimHX6DBjTx6i2ldxSPs/IkJua09qWR+UQYyW4nGarjs9kjLHirkw1iQs1SLkJcpVvoMJRBbYPtDaukXj4u3Yr7jJVGEt/cuWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ThTPe1cj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ThTPe1cj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715116588;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NjU7csK28hUUJih5B6w9Kkpvu1Q3aM6hgo99cFPPrVY=;
	b=ThTPe1cj6JxmWVzxKRkgwrVVv+L2LQ2G78WolMElVsAO2CWv8DveEGJIvkGea7LQV+d6GG
	jS5eMIK1PdyDSIrxZrgglHnVYXmMpr9cEwVyuKhok1hmNj/UgfprONNvI0r/JJGZWJuRON
	9/OY85+5mZaYUjmB4iVkxoZhnGFBtaA=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-590-gk0k27RrNKKe8FlAwASiiw-1; Tue,
 07 May 2024 17:16:27 -0400
X-MC-Unique: gk0k27RrNKKe8FlAwASiiw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A69151C00049;
	Tue,  7 May 2024 21:16:26 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 68B21C159AE;
	Tue,  7 May 2024 21:16:26 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 447LGQaY026722
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 7 May 2024 17:16:26 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 447LGQFr026721;
	Tue, 7 May 2024 17:16:26 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        Heinz Mauelshagen <mauelshagen@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 1/3] dm-delay: fix workqueue delay_timer race
Date: Tue,  7 May 2024 17:16:23 -0400
Message-ID: <20240507211626.26706-2-bmarzins@redhat.com>
In-Reply-To: <20240507211626.26706-1-bmarzins@redhat.com>
References: <20240507211626.26706-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

delay_timer could be pending when delay_dtr() is called. It needs to be
shut down before kdelayd_wq is destroyed, so it won't try queueing more
work to kdelayd_wq while that's getting destroyed.

Also the del_timer_sync() call in delay_presuspend() doesn't protect
against the timer getting immediately rearmed by the queued call to
flush_delayed_bios(), but there's no real harm if that does happen.
timer_delete() is less work, and is basically just as likely to stop a
pointless call to flush_delayed_bios().

Fixes: 26b9f228703f ("dm: delay target")
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/dm-delay.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-delay.c b/drivers/md/dm-delay.c
index 1c424983c042..584e3b10802d 100644
--- a/drivers/md/dm-delay.c
+++ b/drivers/md/dm-delay.c
@@ -154,8 +154,10 @@ static void delay_dtr(struct dm_target *ti)
 {
 	struct delay_c *dc = ti->private;
 
-	if (dc->kdelayd_wq)
+	if (dc->kdelayd_wq) {
+		timer_shutdown_sync(&dc->delay_timer);
 		destroy_workqueue(dc->kdelayd_wq);
+	}
 
 	if (dc->read.dev)
 		dm_put_device(ti, dc->read.dev);
@@ -334,7 +336,7 @@ static void delay_presuspend(struct dm_target *ti)
 	mutex_unlock(&delayed_bios_lock);
 
 	if (!delay_is_fast(dc))
-		del_timer_sync(&dc->delay_timer);
+		timer_delete(&dc->delay_timer);
 	flush_delayed_bios(dc, true);
 }
 
-- 
2.45.0

