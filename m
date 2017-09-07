From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: BFQ + dm-mpath
Date: Thu, 7 Sep 2017 11:52:55 -0400
Message-ID: <20170907155255.GA22848@redhat.com>
References: <1503611578.2899.69.camel@wdc.com>
 <AE77899A-0365-4C7C-91E4-5ACCC396B26B@linaro.org>
 <ED23C7AC-F202-40E3-8421-E714BF446399@linaro.org>
 <1504620914.4135.11.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1504620914.4135.11.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "paolo.valente@linaro.org" <paolo.valente@linaro.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, dm-devel@redhat.com, axboe@kernel.dk
List-Id: dm-devel.ids

On Tue, Sep 05 2017 at 10:15am -0400,
Bart Van Assche <Bart.VanAssche@wdc.com> wrote:

> On Tue, 2017-09-05 at 09:56 +0200, Paolo Valente wrote:
> > Ok, my suspects seem confirmed: the path dm_mq_queue_rq -> map_request
> > -> setup_clone -> blk_rq_prep_clone creates a cloned request without
> > invoking e->type->ops.mq.prepare_request for the target elevator e.
> > The cloned request is therefore not initialized for the scheduler, but
> > it is however inserted into the scheduler by
> > blk_mq_sched_insert_request.  This seems an error for any scheduler
> > that needs to initialize fields in the incoming request, or in general
> > to take some preliminary action.
> > 
> > Am I missing something here?
> 
> (+Mike Snitzer)
> 
> Mike, do you perhaps have the time to look into this memory leak?

It isn't a memory leak, it is missing initialization in the case of
cloned requests (if I'm understanding Paolo correctly).

But cloned requests shouldn't be going through the scheduler.  Only the
original requests should.

Commit bd166ef18 ("blk-mq-sched: add framework for MQ capable IO
schedulers") switched from blk_mq_insert_request() to
blk_mq_sched_insert_request() and in doing so it opened dm-mpath up to
this bug.

Could be we need to take steps to ensure the block layer still
supports bypassing the elevator by using direct insertion?

Or blk_mq_sched_insert_request() needs updating to check if
e->type->ops.mq.prepare_request were actually performed and to fallback
to the !elevator case if not..

Not sure on the fix, but I can look closer if others (like Jens or
Paolo) don't have quicker suggestions.

Mike
