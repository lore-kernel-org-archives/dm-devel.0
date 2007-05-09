From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6.22 PATCH 23/26] dm delay:
Date: Tue, 8 May 2007 17:54:10 -0700
Message-ID: <20070508175410.d5b7e91f.akpm@linux-foundation.org>
References: <20070508194859.GD24114@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070508194859.GD24114@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com, Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org, Heinz Mauelshagen <mauelshagen@redhat.com>
List-Id: dm-devel.ids

On Tue, 8 May 2007 20:48:59 +0100
Alasdair G Kergon <agk@redhat.com> wrote:

> From: Heinz Mauelshagen <mauelshagen@redhat.com>
> 
> New device-mapper target that can delay I/O (for testing).
> Reads can be separated from writes, redirected to different underlying
> devices and delayed by differing amounts of time.
> 
> ..
>
> +/*
> + * Copyright (C) 2005-2007 Red Hat GmbH
> + *
> + * A target that delays reads and/or writes and can send
> + * them to different devices.
> + *
> + * This file is released under the GPL.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/blkdev.h>
> +#include <linux/bio.h>
> +#include <linux/slab.h>
> +
> +#include "dm.h"
> +#include "dm-bio-list.h"
> +
> +#define DM_MSG_PREFIX "delay"
> +
> +struct delay_c {
> +	struct timer_list delay_timer;
> +	struct semaphore timer_lock;

Can we get this converted to a mutex asap, please?

It's only used in a single place and perhaps we don't need this lock at
all?

> +	struct work_struct flush_expired_bios;
> +	struct list_head delayed_bios;
> +	atomic_t may_delay;
> +	mempool_t *delayed_pool;
> +
> +	struct dm_dev *dev_read;
> +	sector_t start_read;
> +	unsigned read_delay;
> +	unsigned reads;
> +
> +	struct dm_dev *dev_write;
> +	sector_t start_write;
> +	unsigned write_delay;
> +	unsigned writes;
> +};
> +
> +struct delay_info {
> +	struct delay_c *context;
> +	struct list_head list;
> +	struct bio *bio;
> +	unsigned long expires;
> +};
> +
> +static DEFINE_MUTEX(delayed_bios_lock);
> +
> +static struct workqueue_struct *kdelayd_wq;
> +static struct kmem_cache *delayed_cache;
> +
> +static void handle_delayed_timer(unsigned long data)
> +{
> +	struct delay_c *dc = (struct delay_c *)data;
> +
> +	queue_work(kdelayd_wq, &dc->flush_expired_bios);
> +}
> +
> +static void queue_timeout(struct delay_c *dc, unsigned long expires)
> +{
> +	down(&dc->timer_lock);
> +
> +	if (!timer_pending(&dc->delay_timer) || expires < dc->delay_timer.expires)
> +		mod_timer(&dc->delay_timer, expires);
> +
> +	up(&dc->timer_lock);
> +}
>
> ...
>
> +
> +	init_timer(&dc->delay_timer);
> +	dc->delay_timer.function = handle_delayed_timer;
> +	dc->delay_timer.data = (unsigned long)dc;

setup_timer() could be used here.

> +	INIT_WORK(&dc->flush_expired_bios, flush_expired_bios);
> +	INIT_LIST_HEAD(&dc->delayed_bios);
> +	init_MUTEX(&dc->timer_lock);
> +	atomic_set(&dc->may_delay, 1);
> +
> +	ti->private = dc;
> +	return 0;
> +
> +bad:
> +	kfree(dc);
> +	return -EINVAL;
> +}
> +
>
> ...
>
> +
> +static int __init dm_delay_init(void)
> +{
> +	int r = -ENOMEM;
> +
> +	kdelayd_wq = create_workqueue("kdelayd");
> +	if (!kdelayd_wq) {
> +		DMERR("Couldn't start kdelayd");
> +		goto bad_queue;
> +	}

Do we really really need one instance of kdelayd on each CPU?

I suspect a single-threaded workqueue would suffice here.  We have a big
global lock in this driver anyway....

Probably create_workqueue() should have defaulted to single-threaded on day
one.  Oh well.


> +	delayed_cache = kmem_cache_create("dm-delay",
> +					  sizeof(struct delay_info),
> +					  __alignof__(struct delay_info),
> +					  0, NULL, NULL);

We have an ugly^Wnice new KMEM_CACHE macro for this now.

What's that __alignof__ doing in there?

> +	if (!delayed_cache) {
> +		DMERR("Couldn't create delayed bio cache.");
> +		goto bad_memcache;
> +	}
> +
> +	r = dm_register_target(&delay_target);
> +	if (r < 0) {
> +		DMERR("register failed %d", r);
> +		goto bad_register;
> +	}
> +
> +	return 0;
> +
> +bad_register:
> +	kmem_cache_destroy(delayed_cache);
> +bad_memcache:
> +	destroy_workqueue(kdelayd_wq);
> +bad_queue:
> +	return r;
> +}
> +
