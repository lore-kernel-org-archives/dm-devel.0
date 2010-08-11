From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: [PATCH] dm-throttle: new device mapper target to
 throttle reads and writes
Date: Wed, 11 Aug 2010 17:45:13 +0200
Message-ID: <1281541513.4964.332.camel@o>
Reply-To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

From heinzm@redhat.com Wed Aug 11 17:19:52 2010
Subject: Re: [dm-devel] [PATCH} dm-throttle: new device mapper target to
 throttle reads and writes
From: Heinz Mauelshagen <heinzm@redhat.com>
Reply-To: heinzm@redhat.com
To: Vivek Goyal <vgoyal@redhat.comm>
Cc: dm-devel@redhat.comm
In-Reply-To: <20100810184138.GC9028@redhat.com>
References: <1281447742.4964.46.camel@o>
<20100810184138.GC9028@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat Inc.
Message-ID: <1281539990.4964.328.camel@o>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Date: Wed, 11 Aug 2010 17:19:52 +0200
X-Evolution-Format: text/plain
X-Evolution-Account: 1270744278.6871.1@o
X-Evolution-Transport:
 smtp://heinzm;auth=PLAIN@smtp.corp.redhat.com/;use_ssl=never
X-Evolution-Fcc: mbox:/home/mauelsha/.evolution/mail/local#Sent
Content-Transfer-Encoding: 8bit

On Tue, 2010-08-10 at 14:41 -0400, Vivek Goyal wrote:
> On Tue, Aug 10, 2010 at 03:42:22PM +0200, Heinz Mauelshagen wrote:
> 
> [..]
> > +/* Decide about throttling (ie. deferring bios). */
> > +static int throttle(struct throttle_c *tc, struct bio *bio)
> > +{
> > +	int rw = (bio_data_dir(bio) == WRITE);
> > +	unsigned bps; /* Bytes per second. */
> > +
> > +	smp_rmb();
> > +	bps = tc->params.bs[rw];
> > +	if (bps) {
> > +		unsigned size;
> > +		struct account *ac = &tc->account;
> > +		struct ac_rw *ac_rw = ac->rw + rw;
> > +
> > +		if (time_after(jiffies, ac_rw->end_jiffies))
> > +			/* Measure time exceeded. */
> > +			account_reset(rw, tc);
> > +		else if (test_bit(rw, &ac->flags))
> > +			/* In case we're throttled already. */
> > +			return 1;
> > +
> > +		/* Account I/O size. */
> > +		size = ac_rw->size + bio->bi_size;
> > +		if (size > bps) {
> > +			/* Hit kilobytes per second threshold. */
> > +			set_bit(rw, &ac->flags);
> > +			return 1;
> 
> If bio->bi_size is greate than bps, will I always keep on throttling
> and hang?

bps needs to be set larger than the bio maximum size expected with the
current implementatio, right. The algorithm needs changing to cope with
bi_size larger than bps (see below).

> 
> [..]
> > +/* Map a throttle io. */
> > +static int throttle_map(struct dm_target *ti, struct bio *bio,
> > +			union map_info *map_context)
> > +{
> > +	int r, rw = (bio_data_dir(bio) == WRITE);
> > +	struct throttle_c *tc = ti->private;
> > +	struct ac_rw *ac_rw = tc->account.rw + rw;
> > +
> > +	mutex_lock(&ac_rw->mutex);
> > +	do {
> > +		r = throttle(tc, bio);
> > +		if (r) {
> > +			long end = ac_rw->end_jiffies, j = jiffies;
> > +
> > +			/* Wait till next second when KB/s reached. */
> > +			if (j < end)
> > +				schedule_timeout_uninterruptible(end - j);
> > +		}
> 
> So a thread is blocked if it crossed the IO rate. There is no such
mechanism
> to take the bio, statsh away somewhere and dispatch it to disk later.
The
> way request queue descriptors work.

Right, the aim for this testing target was to keep it as simple as
possible to solve the purpose of simulating low bandwidth transports or
varying device throughput properties.

Cheap approaches to tackle this issue include to set ti->split_io based
on bps < BIO_MAX_SIZE (units ignored) in the ctr/message interface,
to prohibit bps smaller than BIO_MAX_SIZE altogether or to change the
throttle() algorithm to allow for > 1s measurement periods based on
bi_size maximum vs. bps ratios.

The 1st one obviously causing more bio splits, the 2nd one prohibiting
small bandwidth simulation and the last one causing io peeks, which is
actually not what I wanted.


> Processes are blocked only if queue
> is congested otherwise one allows processes to submit requests and go
> back and do other work.
> 
> I am assuming that this will be bad for AIO.

Yes, bio stashing/dispatching mandatory to make AIO work

Regards,
Heinz

> 
> Thanks
> Vivek
