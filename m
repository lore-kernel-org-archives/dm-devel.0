From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RFC PATCH] blk-mq: fixup RESTART when queue becomes idle
Date: Thu, 18 Jan 2018 17:01:33 -0500
Message-ID: <20180118220132.GA20860@redhat.com>
References: <b2e5b7e6-ce4b-6053-adae-63cc44d773af@wdc.com>
 <20180118170353.GB19734@redhat.com>
 <1516296056.2676.23.camel@wdc.com>
 <20180118183039.GA20121@redhat.com>
 <1516301278.2676.35.camel@wdc.com>
 <deeb2b2e-6d0e-a144-843d-d08626de8aea@kernel.dk>
 <20180118204856.GA31679@redhat.com>
 <1516309128.2676.38.camel@wdc.com>
 <20180118212327.GB31679@redhat.com>
 <1516311554.2676.50.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1516311554.2676.50.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "osandov@fb.com" <osandov@fb.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "ming.lei@redhat.com" <ming.lei@redhat.com>
List-Id: dm-devel.ids

On Thu, Jan 18 2018 at  4:39pm -0500,
Bart Van Assche <Bart.VanAssche@wdc.com> wrote:

> On Thu, 2018-01-18 at 16:23 -0500, Mike Snitzer wrote:
> > On Thu, Jan 18 2018 at  3:58P -0500,
> > Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
> > 
> > > On Thu, 2018-01-18 at 15:48 -0500, Mike Snitzer wrote:
> > > > For Bart's test the underlying scsi-mq driver is what is regularly
> > > > hitting this case in __blk_mq_try_issue_directly():
> > > > 
> > > >         if (blk_mq_hctx_stopped(hctx) || blk_queue_quiesced(q))
> > >
> > > These lockups were all triggered by incorrect handling of
> > > .queue_rq() returning BLK_STS_RESOURCE.
> > 
> > Please be precise, dm_mq_queue_rq()'s return of BLK_STS_RESOURCE?
> > "Incorrect" because it no longer runs blk_mq_delay_run_hw_queue()?
> 
> In what I wrote I was referring to both dm_mq_queue_rq() and scsi_queue_rq().
> With "incorrect" I meant that queue lockups are introduced that make user
> space processes unkillable. That's a severe bug.

And yet Laurence cannot reproduce any such lockups with your test...

Are you absolutely certain this patch doesn't help you?
https://patchwork.kernel.org/patch/10174037/

If it doesn't then that is actually very useful to know.

> > We have time to get this right, please stop hyperventilating about
> > "regressions".
> 
> Sorry Mike but that's something I consider as an unfair comment. If Ming and
> you work on patches together, it's your job to make sure that no regressions
> are introduced. Instead of blaming me because I report these regressions you
> should be grateful that I take the time and effort to report these regressions
> early. And since you are employed by a large organization that sells Linux
> support services, your employer should invest in developing test cases that
> reach a higher coverage of the dm, SCSI and block layer code. I don't think
> that it's normal that my tests discovered several issues that were not
> discovered by Red Hat's internal test suite. That's something Red Hat has to
> address.

You have no self-awareness of just how mypoic you're being about this.

I'm not ignoring or blaming you for your test no longer passing.  Far
from it.  I very much want to fix this.  But I want it fixed in a way
that doesn't paper over the real bug(s) while also introducing blind
queue runs that compromise the blk-mq RESTART code's ability to work as
intended.

I'd have thought you could appreciate this.  We need a root cause on
this, not hand-waving justifications on why problematic delayed queue
runs are correct.

Please just focus on helping Laurence get his very capable testbed to
reproduce this issue.  Once we can reproduce these "unkillable" "stalls"
in-house it'll be _much_ easier to analyze and fix.

Thanks,
Mike
