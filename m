Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9967846BAC
	for <dm-devel@lists.linux.dev>; Wed, 29 Nov 2023 17:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SI9/XMM8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701278904;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gGcBevaxInflxD/2WPmzI4H4+g5bMKyxmKV2qXA/lHk=;
	b=SI9/XMM8L1MtzLMjWzD3xDb9MkujjPj3fS4RC+vbnj+mH77zlQgD0iiQulvv5/6G0p/jQY
	U5qiVyRTD8IilixOL6zMZD+xoZP9aa/D9oON/A1toXWE+ROzs9robj4NjKC0GfxZxvC/Mu
	9JoDS5JdAnQFo7FjkB42zJmX362FqHU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-275-cwMEDQDeNviGrunSlsJRZQ-1; Wed, 29 Nov 2023 12:28:16 -0500
X-MC-Unique: cwMEDQDeNviGrunSlsJRZQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6A7E0811E7D;
	Wed, 29 Nov 2023 17:28:16 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 643F52026D4C;
	Wed, 29 Nov 2023 17:28:16 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 44CCD30C1A8C; Wed, 29 Nov 2023 17:28:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 422D83FB76;
	Wed, 29 Nov 2023 18:28:16 +0100 (CET)
Date: Wed, 29 Nov 2023 18:28:16 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Christian Loehle <christian.loehle@arm.com>
cc: Sasha Levin <sashal@kernel.org>, stable-commits@vger.kernel.org, 
    stable@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, 
    Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev
Subject: Re: Patch "dm delay: for short delays, use kthread instead of timers
 and wq" has been added to the 6.6-stable tree
In-Reply-To: <bdf739ae-5e45-4192-b682-81f05982c220@arm.com>
Message-ID: <30e67bef-4aaf-31d6-483f-2ca6523099c3@redhat.com>
References: <20231129025441.892320-1-sashal@kernel.org> <cac7f5be-454c-5ae1-e025-9ad1d84999fc@redhat.com> <bdf739ae-5e45-4192-b682-81f05982c220@arm.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4



On Wed, 29 Nov 2023, Christian Loehle wrote:

> Hi Mikulas,
> Agreed and thanks for fixing.
> Has this been selected for stable because of:
> 6fc45b6ed921 ("dm-delay: fix a race between delay_presuspend and delay_bio")
> If so, I would volunteer do the backports for that for you at least.

I wouldn't backport this patch - it is an enhancement, not a bugfix, so it 
doesn't qualify for the stable kernel backports.

Mikulas

> BR,
> Christian
> 
> On 29/11/2023 08:28, Mikulas Patocka wrote:
> > Hi
> > 
> > This patch doesn't fix any bug (and introduces several serious bugs), so 
> > it shouldn't be backported at all.
> > 
> > Mikulas
> > 
> > 
> > On Tue, 28 Nov 2023, Sasha Levin wrote:
> > 
> >> This is a note to let you know that I've just added the patch titled
> >>
> >>     dm delay: for short delays, use kthread instead of timers and wq
> >>
> >> to the 6.6-stable tree which can be found at:
> >>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> >>
> >> The filename of the patch is:
> >>      dm-delay-for-short-delays-use-kthread-instead-of-tim.patch
> >> and it can be found in the queue-6.6 subdirectory.
> >>
> >> If you, or anyone else, feels it should not be added to the stable tree,
> >> please let <stable@vger.kernel.org> know about it.
> >>
> >>
> >>
> >> commit 976fd593415e170a8ed5db68683b280d5876982d
> >> Author: Christian Loehle <christian.loehle@arm.com>
> >> Date:   Fri Oct 20 12:46:05 2023 +0100
> >>
> >>     dm delay: for short delays, use kthread instead of timers and wq
> >>     
> >>     [ Upstream commit 70bbeb29fab09d6ea6cfe64109db60a97d84d739 ]
> >>     
> >>     DM delay's current design of using timers and wq to realize the delays
> >>     is insufficient for delays below ~50ms.
> >>     
> >>     This commit enhances the design to use a kthread to flush the expired
> >>     delays, trading some CPU time (in some cases) for better delay
> >>     accuracy and delays closer to what the user requested for smaller
> >>     delays. The new design is chosen as long as all the delays are below
> >>     50ms.
> >>     
> >>     Since bios can't be completed in interrupt context using a kthread
> >>     is probably the most reasonable way to approach this.
> >>     
> >>     Testing with
> >>     echo "0 2097152 zero" | dmsetup create dm-zeros
> >>     for i in $(seq 0 20);
> >>     do
> >>       echo "0 2097152 delay /dev/mapper/dm-zeros 0 $i" | dmsetup create dm-delay-${i}ms;
> >>     done
> >>     
> >>     Some performance numbers for comparison, on beaglebone black (single
> >>     core) CONFIG_HZ_1000=y:
> >>     
> >>     fio --name=1msread --rw=randread --bs=4k --runtime=60 --time_based \
> >>         --filename=/dev/mapper/dm-delay-1ms
> >>     Theoretical maximum: 1000 IOPS
> >>     Previous: 250 IOPS
> >>     Kthread: 500 IOPS
> >>     
> >>     fio --name=10msread --rw=randread --bs=4k --runtime=60 --time_based \
> >>         --filename=/dev/mapper/dm-delay-10ms
> >>     Theoretical maximum: 100 IOPS
> >>     Previous: 45 IOPS
> >>     Kthread: 50 IOPS
> >>     
> >>     fio --name=1mswrite --rw=randwrite --direct=1 --bs=4k --runtime=60 \
> >>         --time_based --filename=/dev/mapper/dm-delay-1ms
> >>     Theoretical maximum: 1000 IOPS
> >>     Previous: 498 IOPS
> >>     Kthread: 1000 IOPS
> >>     
> >>     fio --name=10mswrite --rw=randwrite --direct=1 --bs=4k --runtime=60 \
> >>         --time_based --filename=/dev/mapper/dm-delay-10ms
> >>     Theoretical maximum: 100 IOPS
> >>     Previous: 90 IOPS
> >>     Kthread: 100 IOPS
> >>     
> >>     (This one is just to prove the new design isn't impacting throughput,
> >>     not really about delays):
> >>     fio --name=10mswriteasync --rw=randwrite --direct=1 --bs=4k \
> >>         --runtime=60 --time_based --filename=/dev/mapper/dm-delay-10ms \
> >>         --numjobs=32 --iodepth=64 --ioengine=libaio --group_reporting
> >>     Previous: 13.3k IOPS
> >>     Kthread: 13.3k IOPS
> >>     
> >>     Signed-off-by: Christian Loehle <christian.loehle@arm.com>
> >>     [Harshit: kthread_create error handling fix in delay_ctr]
> >>     Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
> >>     Signed-off-by: Mike Snitzer <snitzer@kernel.org>
> >>     Stable-dep-of: 6fc45b6ed921 ("dm-delay: fix a race between delay_presuspend and delay_bio")
> >>     Signed-off-by: Sasha Levin <sashal@kernel.org>
> >>
> >> diff --git a/drivers/md/dm-delay.c b/drivers/md/dm-delay.c
> >> index 7433525e59856..efd510984e259 100644
> >> --- a/drivers/md/dm-delay.c
> >> +++ b/drivers/md/dm-delay.c
> >> @@ -13,6 +13,7 @@
> >>  #include <linux/blkdev.h>
> >>  #include <linux/bio.h>
> >>  #include <linux/slab.h>
> >> +#include <linux/kthread.h>
> >>  
> >>  #include <linux/device-mapper.h>
> >>  
> >> @@ -31,6 +32,7 @@ struct delay_c {
> >>  	struct workqueue_struct *kdelayd_wq;
> >>  	struct work_struct flush_expired_bios;
> >>  	struct list_head delayed_bios;
> >> +	struct task_struct *worker;
> >>  	atomic_t may_delay;
> >>  
> >>  	struct delay_class read;
> >> @@ -66,6 +68,44 @@ static void queue_timeout(struct delay_c *dc, unsigned long expires)
> >>  	mutex_unlock(&dc->timer_lock);
> >>  }
> >>  
> >> +static inline bool delay_is_fast(struct delay_c *dc)
> >> +{
> >> +	return !!dc->worker;
> >> +}
> >> +
> >> +static void flush_delayed_bios_fast(struct delay_c *dc, bool flush_all)
> >> +{
> >> +	struct dm_delay_info *delayed, *next;
> >> +
> >> +	mutex_lock(&delayed_bios_lock);
> >> +	list_for_each_entry_safe(delayed, next, &dc->delayed_bios, list) {
> >> +		if (flush_all || time_after_eq(jiffies, delayed->expires)) {
> >> +			struct bio *bio = dm_bio_from_per_bio_data(delayed,
> >> +						sizeof(struct dm_delay_info));
> >> +			list_del(&delayed->list);
> >> +			dm_submit_bio_remap(bio, NULL);
> >> +			delayed->class->ops--;
> >> +		}
> >> +	}
> >> +	mutex_unlock(&delayed_bios_lock);
> >> +}
> >> +
> >> +static int flush_worker_fn(void *data)
> >> +{
> >> +	struct delay_c *dc = data;
> >> +
> >> +	while (1) {
> >> +		flush_delayed_bios_fast(dc, false);
> >> +		if (unlikely(list_empty(&dc->delayed_bios))) {
> >> +			set_current_state(TASK_INTERRUPTIBLE);
> >> +			schedule();
> >> +		} else
> >> +			cond_resched();
> >> +	}
> >> +
> >> +	return 0;
> >> +}
> >> +
> >>  static void flush_bios(struct bio *bio)
> >>  {
> >>  	struct bio *n;
> >> @@ -78,7 +118,7 @@ static void flush_bios(struct bio *bio)
> >>  	}
> >>  }
> >>  
> >> -static struct bio *flush_delayed_bios(struct delay_c *dc, int flush_all)
> >> +static struct bio *flush_delayed_bios(struct delay_c *dc, bool flush_all)
> >>  {
> >>  	struct dm_delay_info *delayed, *next;
> >>  	unsigned long next_expires = 0;
> >> @@ -115,7 +155,10 @@ static void flush_expired_bios(struct work_struct *work)
> >>  	struct delay_c *dc;
> >>  
> >>  	dc = container_of(work, struct delay_c, flush_expired_bios);
> >> -	flush_bios(flush_delayed_bios(dc, 0));
> >> +	if (delay_is_fast(dc))
> >> +		flush_delayed_bios_fast(dc, false);
> >> +	else
> >> +		flush_bios(flush_delayed_bios(dc, false));
> >>  }
> >>  
> >>  static void delay_dtr(struct dm_target *ti)
> >> @@ -131,8 +174,11 @@ static void delay_dtr(struct dm_target *ti)
> >>  		dm_put_device(ti, dc->write.dev);
> >>  	if (dc->flush.dev)
> >>  		dm_put_device(ti, dc->flush.dev);
> >> +	if (dc->worker)
> >> +		kthread_stop(dc->worker);
> >>  
> >> -	mutex_destroy(&dc->timer_lock);
> >> +	if (!delay_is_fast(dc))
> >> +		mutex_destroy(&dc->timer_lock);
> >>  
> >>  	kfree(dc);
> >>  }
> >> @@ -175,6 +221,7 @@ static int delay_ctr(struct dm_target *ti, unsigned int argc, char **argv)
> >>  {
> >>  	struct delay_c *dc;
> >>  	int ret;
> >> +	unsigned int max_delay;
> >>  
> >>  	if (argc != 3 && argc != 6 && argc != 9) {
> >>  		ti->error = "Requires exactly 3, 6 or 9 arguments";
> >> @@ -188,16 +235,14 @@ static int delay_ctr(struct dm_target *ti, unsigned int argc, char **argv)
> >>  	}
> >>  
> >>  	ti->private = dc;
> >> -	timer_setup(&dc->delay_timer, handle_delayed_timer, 0);
> >> -	INIT_WORK(&dc->flush_expired_bios, flush_expired_bios);
> >>  	INIT_LIST_HEAD(&dc->delayed_bios);
> >> -	mutex_init(&dc->timer_lock);
> >>  	atomic_set(&dc->may_delay, 1);
> >>  	dc->argc = argc;
> >>  
> >>  	ret = delay_class_ctr(ti, &dc->read, argv);
> >>  	if (ret)
> >>  		goto bad;
> >> +	max_delay = dc->read.delay;
> >>  
> >>  	if (argc == 3) {
> >>  		ret = delay_class_ctr(ti, &dc->write, argv);
> >> @@ -206,6 +251,8 @@ static int delay_ctr(struct dm_target *ti, unsigned int argc, char **argv)
> >>  		ret = delay_class_ctr(ti, &dc->flush, argv);
> >>  		if (ret)
> >>  			goto bad;
> >> +		max_delay = max(max_delay, dc->write.delay);
> >> +		max_delay = max(max_delay, dc->flush.delay);
> >>  		goto out;
> >>  	}
> >>  
> >> @@ -216,19 +263,37 @@ static int delay_ctr(struct dm_target *ti, unsigned int argc, char **argv)
> >>  		ret = delay_class_ctr(ti, &dc->flush, argv + 3);
> >>  		if (ret)
> >>  			goto bad;
> >> +		max_delay = max(max_delay, dc->flush.delay);
> >>  		goto out;
> >>  	}
> >>  
> >>  	ret = delay_class_ctr(ti, &dc->flush, argv + 6);
> >>  	if (ret)
> >>  		goto bad;
> >> +	max_delay = max(max_delay, dc->flush.delay);
> >>  
> >>  out:
> >> -	dc->kdelayd_wq = alloc_workqueue("kdelayd", WQ_MEM_RECLAIM, 0);
> >> -	if (!dc->kdelayd_wq) {
> >> -		ret = -EINVAL;
> >> -		DMERR("Couldn't start kdelayd");
> >> -		goto bad;
> >> +	if (max_delay < 50) {
> >> +		/*
> >> +		 * In case of small requested delays, use kthread instead of
> >> +		 * timers and workqueue to achieve better latency.
> >> +		 */
> >> +		dc->worker = kthread_create(&flush_worker_fn, dc,
> >> +					    "dm-delay-flush-worker");
> >> +		if (IS_ERR(dc->worker)) {
> >> +			ret = PTR_ERR(dc->worker);
> >> +			goto bad;
> >> +		}
> >> +	} else {
> >> +		timer_setup(&dc->delay_timer, handle_delayed_timer, 0);
> >> +		INIT_WORK(&dc->flush_expired_bios, flush_expired_bios);
> >> +		mutex_init(&dc->timer_lock);
> >> +		dc->kdelayd_wq = alloc_workqueue("kdelayd", WQ_MEM_RECLAIM, 0);
> >> +		if (!dc->kdelayd_wq) {
> >> +			ret = -EINVAL;
> >> +			DMERR("Couldn't start kdelayd");
> >> +			goto bad;
> >> +		}
> >>  	}
> >>  
> >>  	ti->num_flush_bios = 1;
> >> @@ -260,7 +325,10 @@ static int delay_bio(struct delay_c *dc, struct delay_class *c, struct bio *bio)
> >>  	list_add_tail(&delayed->list, &dc->delayed_bios);
> >>  	mutex_unlock(&delayed_bios_lock);
> >>  
> >> -	queue_timeout(dc, expires);
> >> +	if (delay_is_fast(dc))
> >> +		wake_up_process(dc->worker);
> >> +	else
> >> +		queue_timeout(dc, expires);
> >>  
> >>  	return DM_MAPIO_SUBMITTED;
> >>  }
> >> @@ -270,8 +338,13 @@ static void delay_presuspend(struct dm_target *ti)
> >>  	struct delay_c *dc = ti->private;
> >>  
> >>  	atomic_set(&dc->may_delay, 0);
> >> -	del_timer_sync(&dc->delay_timer);
> >> -	flush_bios(flush_delayed_bios(dc, 1));
> >> +
> >> +	if (delay_is_fast(dc))
> >> +		flush_delayed_bios_fast(dc, true);
> >> +	else {
> >> +		del_timer_sync(&dc->delay_timer);
> >> +		flush_bios(flush_delayed_bios(dc, true));
> >> +	}
> >>  }
> >>  
> >>  static void delay_resume(struct dm_target *ti)
> >> @@ -356,7 +429,7 @@ static int delay_iterate_devices(struct dm_target *ti,
> >>  
> >>  static struct target_type delay_target = {
> >>  	.name	     = "delay",
> >> -	.version     = {1, 3, 0},
> >> +	.version     = {1, 4, 0},
> >>  	.features    = DM_TARGET_PASSES_INTEGRITY,
> >>  	.module      = THIS_MODULE,
> >>  	.ctr	     = delay_ctr,
> >>
> > 
> 

