From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: dm-mpath: Improve handling of busy paths
Date: Wed, 20 Sep 2017 20:36:09 +0000
Message-ID: <1505939767.2509.23.camel@wdc.com>
References: <20170920181212.5532-1-bart.vanassche@wdc.com>
	<20170920185637.GA30126@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170920185637.GA30126@redhat.com>
Content-Language: en-US
Content-ID: <2A5E7E8EB0C33347AD073E2F5D768334@namprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "snitzer@redhat.com" <snitzer@redhat.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "hch@lst.de" <hch@lst.de>, "hare@suse.com" <hare@suse.com>
List-Id: dm-devel.ids

On Wed, 2017-09-20 at 14:56 -0400, Mike Snitzer wrote:
> On Wed, Sep 20 2017 at  2:12pm -0400,
> Bart Van Assche <bart.vanassche@wdc.com> wrote:
> >  	bdev = pgpath->path.dev->bdev;
> >  	q = bdev_get_queue(bdev);
> > -	clone = blk_get_request(q, rq->cmd_flags | REQ_NOMERGE, GFP_ATOMIC);
> > +	/*
> > +	 * For blk-mq this code is called from inside dm_mq_queue_rq() and
> > +	 * sleeping is allowed due to BLK_MQ_F_BLOCKING.  For the legacy block
> > +	 * layer this code is called from workqueue context. Hence unlocking
> > +	 * and reacquiring the queue lock is not necessary.
> > +	 */
> > +	clone = blk_get_request(q, rq->cmd_flags | REQ_NOMERGE, GFP_NOIO);
> >  	if (IS_ERR(clone)) {
> >  		/* EBUSY, ENODEV or EWOULDBLOCK: requeue */
> >  		bool queue_dying = blk_queue_dying(q);
> 
> It concerns me that we'd basically be allowing one or more really poorly
> behaving underlying path(s) to sabotage the entire dm-multipath device
> by blocking waiting for a request/tag on potentially pathologically
> saturated and/or substandard path(s) (of particular concern when using
> the round-robin path selector).

That's a valid concern, but if different paths are known to have different
latency characteristics, shouldn't users choose another path selector than
round-robin, e.g. the service-time path selector?

Additionally, shouldn't substandard paths be handled at a higher level than
dm-path? My proposal if we really want flaky paths to be avoided automatically
is to modify multipathd such that the path state can have three possible
values instead of two (up/down/flaky instead of up/down) and to let multipathd
recognize flaky paths.

> > @@ -504,6 +510,8 @@ static int multipath_clone_and_map(struct dm_target *ti, struct request *rq,
> >  		if (queue_dying) {
> >  			atomic_inc(&m->pg_init_in_progress);
> >  			activate_or_offline_path(pgpath);
> > +		} else {
> > +			WARN_ON_ONCE(true);
> >  		}
> >  		return DM_MAPIO_DELAY_REQUEUE;
> >  	}
> 
> There is no reason for this WARN_ON_ONCE to be part of this patch.
> Really not seeing the point of it at all though.

OK, I will leave this change out. The only purpose of that WARN_ON_ONCE(true)
statement is to verify that request allocation only fails for dying paths and
not in any other case.

> This type of change needs to be carefully tested.  It is very
> fundamental and takes us further and further away from avoiding
> deadlocks/stalls.
> 
> Have you run this change through your IB SRP test harness?

Yes, this patch survives several srp-test runs. The command I used to test
this patch is as follows:

    srp-test/run_tests -f xfs -e deadline

This means that legacy dm on top of legacy SCSI, dm-mq on top of scsi-mq and
legacy dm on top of scsi-mq have been tested.

> I can run it through the mptest suite but that falls way short of
> real-world destructive multipath testing in the face of heavy IO.

Thanks, performing additional testing with the mptest suite is definitely
welcome.

Bart.
