Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7D613ADC
	for <dm-devel@lists.linux.dev>; Wed, 29 Nov 2023 18:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JTNjoxS6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701281816;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=A7O+nrxq0xNIq93HqJFUw/NnBwip9ukcfOSmmM9yu6Q=;
	b=JTNjoxS6VPzTAjHoKBQTvk2d1Z0xqeYYBGS5BxVVL892xzc9+mid2Vq/m0H3Zc7n2wAlyg
	uy/2qyIMmVsOb+ybKHXXQpXecgl7DrqygF82twb3BPIaI5BFK3NeOHGBplOHwaETUg645f
	I+vxeduCUFqTSn4StdbAau1uca3lWw8=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-620-Lf3EjYeoP8WKdDFc0qXHjQ-1; Wed,
 29 Nov 2023 13:16:52 -0500
X-MC-Unique: Lf3EjYeoP8WKdDFc0qXHjQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 302F238116E4;
	Wed, 29 Nov 2023 18:16:52 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 27D4F492BFA;
	Wed, 29 Nov 2023 18:16:52 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 0BB4730C1A8C; Wed, 29 Nov 2023 18:16:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 08AD53FB76;
	Wed, 29 Nov 2023 19:16:52 +0100 (CET)
Date: Wed, 29 Nov 2023 19:16:52 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Sasha Levin <sashal@kernel.org>
cc: Christian Loehle <christian.loehle@arm.com>, 
    stable-commits@vger.kernel.org, stable@vger.kernel.org, 
    Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    dm-devel@lists.linux.dev
Subject: Re: Patch "dm delay: for short delays, use kthread instead of timers
 and wq" has been added to the 6.6-stable tree
In-Reply-To: <ZWd3HCVNTkZYREGo@sashalap>
Message-ID: <b8d0fdf7-fca4-4a2d-3dd-94b2c97b7fb4@redhat.com>
References: <20231129025441.892320-1-sashal@kernel.org> <cac7f5be-454c-5ae1-e025-9ad1d84999fc@redhat.com> <bdf739ae-5e45-4192-b682-81f05982c220@arm.com> <30e67bef-4aaf-31d6-483f-2ca6523099c3@redhat.com> <ZWd3HCVNTkZYREGo@sashalap>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10



On Wed, 29 Nov 2023, Sasha Levin wrote:

> On Wed, Nov 29, 2023 at 06:28:16PM +0100, Mikulas Patocka wrote:
> >
> >
> >On Wed, 29 Nov 2023, Christian Loehle wrote:
> >
> >> Hi Mikulas,
> >> Agreed and thanks for fixing.
> >> Has this been selected for stable because of:
> >> 6fc45b6ed921 ("dm-delay: fix a race between delay_presuspend and
> >> delay_bio")
> >> If so, I would volunteer do the backports for that for you at least.
> >
> >I wouldn't backport this patch - it is an enhancement, not a bugfix, so it
> >doesn't qualify for the stable kernel backports.
> 
> Right - this watch was selected as a dependency for 6fc45b6ed921
> ("dm-delay: fix a race between delay_presuspend and delay_bio").
> 
> In general, unless it's impractical, we'd rather take a dependency chain
> rather than deal with a non-trivial backport as those tend to have
> issues longer term.
> 
> -- 
> Thanks,
> Sasha

The patch 70bbeb29fab0 ("dm delay: for short delays, use kthread instead 
of timers and wq") changes behavior of dm-delay from using timers to 
polling, so it may cause problems to people running legacy kernels - the 
polling consumes more CPU time than the timers - so I think it shouldn't 
go to the stable kernels where users expect that there will be no 
functional change.

Here I'm submitting the patch 6fc45b6ed921 backported for 6.6.3.

Mikulas


From: Mikulas Patocka <mpatocka@redhat.com>

dm-delay: fix a race between delay_presuspend and delay_bio

In delay_presuspend, we set the atomic variable may_delay and then stop
the timer and flush pending bios. The intention here is to prevent the
delay target from re-arming the timer again.

However, this test is racy. Suppose that one thread goes to delay_bio,
sees that dc->may_delay is one and proceeds; now, another theread executes
delay_presuspend, it sets, dc->may_delay to zero, deletes the timer and
flushes pending bios. Now, the first thread continues and adds the bio to
delayed->list despite the fact that dc->may_delay is false.

In order to fix this bug, we change may_delay's type from atomic_t to bool
and we read and write it only while holding the delayed_bios_lock mutex.
Note that we don't have to grab the mutex in delay_resume because there
are no bios in flight at this point.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/dm-delay.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

Index: linux-stable/drivers/md/dm-delay.c
===================================================================
--- linux-stable.orig/drivers/md/dm-delay.c	2023-11-29 19:03:03.000000000 +0100
+++ linux-stable/drivers/md/dm-delay.c	2023-11-29 19:03:03.000000000 +0100
@@ -31,7 +31,7 @@ struct delay_c {
 	struct workqueue_struct *kdelayd_wq;
 	struct work_struct flush_expired_bios;
 	struct list_head delayed_bios;
-	atomic_t may_delay;
+	bool may_delay;
 
 	struct delay_class read;
 	struct delay_class write;
@@ -192,7 +192,7 @@ static int delay_ctr(struct dm_target *t
 	INIT_WORK(&dc->flush_expired_bios, flush_expired_bios);
 	INIT_LIST_HEAD(&dc->delayed_bios);
 	mutex_init(&dc->timer_lock);
-	atomic_set(&dc->may_delay, 1);
+	dc->may_delay = true;
 	dc->argc = argc;
 
 	ret = delay_class_ctr(ti, &dc->read, argv);
@@ -247,7 +247,7 @@ static int delay_bio(struct delay_c *dc,
 	struct dm_delay_info *delayed;
 	unsigned long expires = 0;
 
-	if (!c->delay || !atomic_read(&dc->may_delay))
+	if (!c->delay)
 		return DM_MAPIO_REMAPPED;
 
 	delayed = dm_per_bio_data(bio, sizeof(struct dm_delay_info));
@@ -256,6 +256,10 @@ static int delay_bio(struct delay_c *dc,
 	delayed->expires = expires = jiffies + msecs_to_jiffies(c->delay);
 
 	mutex_lock(&delayed_bios_lock);
+	if (unlikely(!dc->may_delay)) {
+		mutex_unlock(&delayed_bios_lock);
+		return DM_MAPIO_REMAPPED;
+	}
 	c->ops++;
 	list_add_tail(&delayed->list, &dc->delayed_bios);
 	mutex_unlock(&delayed_bios_lock);
@@ -269,7 +273,10 @@ static void delay_presuspend(struct dm_t
 {
 	struct delay_c *dc = ti->private;
 
-	atomic_set(&dc->may_delay, 0);
+	mutex_lock(&delayed_bios_lock);
+	dc->may_delay = false;
+	mutex_unlock(&delayed_bios_lock);
+
 	del_timer_sync(&dc->delay_timer);
 	flush_bios(flush_delayed_bios(dc, 1));
 }
@@ -278,7 +285,7 @@ static void delay_resume(struct dm_targe
 {
 	struct delay_c *dc = ti->private;
 
-	atomic_set(&dc->may_delay, 1);
+	dc->may_delay = true;
 }
 
 static int delay_map(struct dm_target *ti, struct bio *bio)

