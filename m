Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 064E32746B
	for <dm-devel@lists.linux.dev>; Tue,  7 May 2024 21:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715116591; cv=none; b=BljDc0X602G1Meo8qlChJmu0sA1jZxlUh+5i2SGuNrVg7+RLVtY1JQc6RU3rK0HUeY8sJCGjLdfZL+D5cZS9Nvh9qfs5Uso74if9dpUQkKY+0n6cBsXnn0sJiuRqH+ZmyUBkxwqHlfOCPbWz3luRMf8vdkfk6gjMIjDrPdNYcYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715116591; c=relaxed/simple;
	bh=bvIH0v5+wqJXhC/6ys+EGY1JbQPMNn4ap4lT2QTdq9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YkTobAg/Zeawq6EihOeUvw2kFqEaP6vR5bgD+W+/MbQUw2YxyqP2DYaqGfPuIhaWtq79enuXuOMoJPLFPqxXUoVnEw7LkDh0AO8LgXfznYEclYrB6W/VYNLSblgZOLJ7ucCqZY9GxuTTv3lBx0S5ZBIkvtmfA5vFZRxUjW/0BaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TdOAHy8x; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TdOAHy8x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715116589;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QPdmbPPVthcGjAAUWNNYKKK2TjQvJiJeFsJmIbH8ck4=;
	b=TdOAHy8xzTMOPQqeZCmuc1FXCw0UGzrfTCIqL1COOn1CqxkGKQ93mM2OMb6UAVgXpWifh5
	MRzLEjFHEbIoda/l0ymwxN4zzfsIUOm+zGvzq3tW4qq4wopv2wgw9vvfoc8Sgu3YClYKxe
	Hnxe24KgP33tGNmlCucamW5KIvCS5+Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-596-O6uOZrlxOxGRguIxlvFS_Q-1; Tue, 07 May 2024 17:16:27 -0400
X-MC-Unique: O6uOZrlxOxGRguIxlvFS_Q-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 23860801211;
	Tue,  7 May 2024 21:16:27 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B2D924750A1;
	Tue,  7 May 2024 21:16:26 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 447LGQXk026730
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 7 May 2024 17:16:26 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 447LGQmQ026729;
	Tue, 7 May 2024 17:16:26 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
        Heinz Mauelshagen <mauelshagen@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 3/3] dm-delay: remove timer_lock
Date: Tue,  7 May 2024 17:16:25 -0400
Message-ID: <20240507211626.26706-4-bmarzins@redhat.com>
In-Reply-To: <20240507211626.26706-1-bmarzins@redhat.com>
References: <20240507211626.26706-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Instead of manually checking the timer details in queue_timeout(), call
timer_reduce() to start the timer or reduce the expiration time. This
avoids needing a lock.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/dm-delay.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/md/dm-delay.c b/drivers/md/dm-delay.c
index b1829c106a37..297ae7ffcd0b 100644
--- a/drivers/md/dm-delay.c
+++ b/drivers/md/dm-delay.c
@@ -28,7 +28,6 @@ struct delay_class {
 
 struct delay_c {
 	struct timer_list delay_timer;
-	struct mutex timer_lock;
 	struct mutex process_bios_lock; /* hold while removing bios to be processed from list */
 	spinlock_t delayed_bios_lock; /* hold on all accesses to delayed_bios list */
 	struct workqueue_struct *kdelayd_wq;
@@ -60,12 +59,7 @@ static void handle_delayed_timer(struct timer_list *t)
 
 static void queue_timeout(struct delay_c *dc, unsigned long expires)
 {
-	mutex_lock(&dc->timer_lock);
-
-	if (!timer_pending(&dc->delay_timer) || expires < dc->delay_timer.expires)
-		mod_timer(&dc->delay_timer, expires);
-
-	mutex_unlock(&dc->timer_lock);
+	timer_reduce(&dc->delay_timer, expires);
 }
 
 static inline bool delay_is_fast(struct delay_c *dc)
@@ -176,7 +170,6 @@ static void delay_dtr(struct dm_target *ti)
 		kthread_stop(dc->worker);
 
 	mutex_destroy(&dc->process_bios_lock);
-	mutex_destroy(&dc->timer_lock);
 
 	kfree(dc);
 }
@@ -234,7 +227,6 @@ static int delay_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	ti->private = dc;
 	INIT_LIST_HEAD(&dc->delayed_bios);
-	mutex_init(&dc->timer_lock);
 	mutex_init(&dc->process_bios_lock);
 	spin_lock_init(&dc->delayed_bios_lock);
 	dc->may_delay = true;
-- 
2.45.0

