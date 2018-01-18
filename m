From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [RFC PATCH] blk-mq: fixup RESTART when queue becomes idle
Date: Thu, 18 Jan 2018 16:37:45 -0500
Message-ID: <1516311465.24506.2.camel@redhat.com>
References: <20180118024124.8079-1-ming.lei@redhat.com>
         <b2e5b7e6-ce4b-6053-adae-63cc44d773af@wdc.com>
         <20180118170353.GB19734@redhat.com> <1516296056.2676.23.camel@wdc.com>
         <20180118183039.GA20121@redhat.com> <1516301278.2676.35.camel@wdc.com>
         <deeb2b2e-6d0e-a144-843d-d08626de8aea@kernel.dk>
         <20180118204856.GA31679@redhat.com> <1516309128.2676.38.camel@wdc.com>
         <20180118212327.GB31679@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180118212327.GB31679@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@infradead.org" <hch@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "osandov@fb.com" <osandov@fb.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>
List-Id: dm-devel.ids

On Thu, 2018-01-18 at 16:23 -0500, Mike Snitzer wrote:
> On Thu, Jan 18 2018 at  3:58P -0500,
> Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
> 
> > On Thu, 2018-01-18 at 15:48 -0500, Mike Snitzer wrote:
> > > For Bart's test the underlying scsi-mq driver is what is
> > > regularly
> > > hitting this case in __blk_mq_try_issue_directly():
> > > 
> > >         if (blk_mq_hctx_stopped(hctx) || blk_queue_quiesced(q))
> > 
> > Hello Mike,
> > 
> > That code path is not the code path that triggered the lockups that
> > I reported
> > during the past days.
> 
> If you're hitting blk_mq_sched_insert_request() then you most
> certainly
> are hitting that code path.
> 
> If you aren't then what was your earlier email going on about?
> https://www.redhat.com/archives/dm-devel/2018-January/msg00372.html
> 
> If you were just focusing on that as one possible reason, that isn't
> very helpful.  By this point you really should _know_ what is
> triggering
> the stall based on the code paths taken.  Please use ftrace's
> function_graph tracer if need be.
> 
> > These lockups were all triggered by incorrect handling of
> > .queue_rq() returning BLK_STS_RESOURCE.
> 
> Please be precise, dm_mq_queue_rq()'s return of BLK_STS_RESOURCE?
> "Incorrect" because it no longer runs blk_mq_delay_run_hw_queue()?
> 
> Please try to do more work analyzing the test case that only you can
> easily run (due to srp_test being a PITA).  And less time lobbying
> for
> a change that you don't understand to _really_ be correct.
> 
> We have time to get this right, please stop hyperventilating about
> "regressions".
> 
> Thanks,
> Mike

Hello Bart
I have run a good few loops of 02-mq and its stable for me on your
tree.
I am not running the entire disconnect re-connect loops and un-mounts
etc. for good reason.
I have 35 LUNS so its very impact-full to lose them and have them come
back all the time.

Anyway
I am very happy to try reproduce this in-house so Mike and Ming can
focus on it but I need to know if all I need to do is loop over 02-mq
over and over.

Also please let me know whats debugfs and sysfs to capture and I am
happy to try help move this along.

Regards
Laurence
