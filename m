Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB305DF29
	for <dm-devel@lists.linux.dev>; Wed, 29 Nov 2023 20:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NlVGcsWd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1302C433C8;
	Wed, 29 Nov 2023 20:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701288015;
	bh=y6DTR0XzN3LA+VxGaGWdYbXTfnwImTnM9jriaGLyul0=;
	h=From:To:Cc:Subject:Date:From;
	b=NlVGcsWd05s7vykZjfzbwLX2FY/dUBsMpXIbX5pnC6fUlwR33GCnuXb7df6hmJdcM
	 GnelRQqsyc6bhhrjr6K+SWk3GN8DAezX+pmVdRqmeS4QZlqQlRJ+7UIttEpc3WNks3
	 bovjGuqiv24xSRJBqCl6gZXVNt2VVn63bR06fUvEw4zQJIvTa1ZwtmhDnHg5QO4cX1
	 BqiYxwn5uAdgf4Fo/PrZIeWnucAKFX4geRRKWMNx/Bw/XjqNYr8lTZwNDJh9vBRPca
	 BLD6K6OYdBq9tKrQ4aXrqJLFsce3bxp4GEywbPOto9sJi5qrMf+4vnNPT1lTrUhwAo
	 zivTjSK8lbhIg==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	mpatocka@redhat.com
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	dm-devel@lists.linux.dev
Subject: Patch "dm-delay: fix a race between delay_presuspend and delay_bio" has been added to the 6.6-stable tree
Date: Wed, 29 Nov 2023 15:00:07 -0500
Message-ID: <20231129200011.1245858-1-sashal@kernel.org>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

This is a note to let you know that I've just added the patch titled

    dm-delay: fix a race between delay_presuspend and delay_bio

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-delay-fix-a-race-between-delay_presuspend-and-del.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit e8071595ba85eccf5091cef594e6eab669a486f2
Author: Mikulas Patocka <mpatocka@redhat.com>
Date:   Wed Nov 29 13:38:43 2023 -0500

    dm-delay: fix a race between delay_presuspend and delay_bio
    
    [ Upstream commit 6fc45b6ed921dc00dfb264dc08c7d67ee63d2656 ]
    
    In delay_presuspend, we set the atomic variable may_delay and then stop
    the timer and flush pending bios. The intention here is to prevent the
    delay target from re-arming the timer again.
    
    However, this test is racy. Suppose that one thread goes to delay_bio,
    sees that dc->may_delay is one and proceeds; now, another thread executes
    delay_presuspend, it sets dc->may_delay to zero, deletes the timer and
    flushes pending bios. Then, the first thread continues and adds the bio to
    delayed->list despite the fact that dc->may_delay is false.
    
    Fix this bug by changing may_delay's type from atomic_t to bool and
    only access it while holding the delayed_bios_lock mutex. Note that we
    don't have to grab the mutex in delay_resume because there are no bios
    in flight at this point.
    
    Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
    Cc: stable@vger.kernel.org
    Signed-off-by: Mike Snitzer <snitzer@kernel.org>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/drivers/md/dm-delay.c b/drivers/md/dm-delay.c
index 7433525e59856..3726fae3006e3 100644
--- a/drivers/md/dm-delay.c
+++ b/drivers/md/dm-delay.c
@@ -31,7 +31,7 @@ struct delay_c {
 	struct workqueue_struct *kdelayd_wq;
 	struct work_struct flush_expired_bios;
 	struct list_head delayed_bios;
-	atomic_t may_delay;
+	bool may_delay;
 
 	struct delay_class read;
 	struct delay_class write;
@@ -192,7 +192,7 @@ static int delay_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	INIT_WORK(&dc->flush_expired_bios, flush_expired_bios);
 	INIT_LIST_HEAD(&dc->delayed_bios);
 	mutex_init(&dc->timer_lock);
-	atomic_set(&dc->may_delay, 1);
+	dc->may_delay = true;
 	dc->argc = argc;
 
 	ret = delay_class_ctr(ti, &dc->read, argv);
@@ -247,7 +247,7 @@ static int delay_bio(struct delay_c *dc, struct delay_class *c, struct bio *bio)
 	struct dm_delay_info *delayed;
 	unsigned long expires = 0;
 
-	if (!c->delay || !atomic_read(&dc->may_delay))
+	if (!c->delay)
 		return DM_MAPIO_REMAPPED;
 
 	delayed = dm_per_bio_data(bio, sizeof(struct dm_delay_info));
@@ -256,6 +256,10 @@ static int delay_bio(struct delay_c *dc, struct delay_class *c, struct bio *bio)
 	delayed->expires = expires = jiffies + msecs_to_jiffies(c->delay);
 
 	mutex_lock(&delayed_bios_lock);
+	if (unlikely(!dc->may_delay)) {
+		mutex_unlock(&delayed_bios_lock);
+		return DM_MAPIO_REMAPPED;
+	}
 	c->ops++;
 	list_add_tail(&delayed->list, &dc->delayed_bios);
 	mutex_unlock(&delayed_bios_lock);
@@ -269,7 +273,10 @@ static void delay_presuspend(struct dm_target *ti)
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
@@ -278,7 +285,7 @@ static void delay_resume(struct dm_target *ti)
 {
 	struct delay_c *dc = ti->private;
 
-	atomic_set(&dc->may_delay, 1);
+	dc->may_delay = true;
 }
 
 static int delay_map(struct dm_target *ti, struct bio *bio)
