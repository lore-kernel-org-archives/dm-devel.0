From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH V3 0/5]  dm-rq: improve sequential I/O performance
Date: Thu, 11 Jan 2018 20:43:37 -0500
Message-ID: <20180112014336.GA32298@redhat.com>
References: <20180111060159.12991-1-ming.lei@redhat.com>
 <20180111220742.GA31944@redhat.com>
 <1515710256.2752.72.camel@sandisk.com>
 <20180111225830.GE31944@redhat.com>
 <1515713233.2752.76.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1515713233.2752.76.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@fb.com" <axboe@fb.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "ming.lei@redhat.com" <ming.lei@redhat.com>
List-Id: dm-devel.ids

On Thu, Jan 11 2018 at  6:27pm -0500,
Bart Van Assche <Bart.VanAssche@wdc.com> wrote:

> On Thu, 2018-01-11 at 17:58 -0500, Mike Snitzer wrote:
> > The changes are pretty easy to review.  This notion that these changes
> > are problematic rings very hollow given your lack of actual numbers (or
> > some other concerning observation rooted in testing fact) to back up
> > your position.
> 
> It's not my job to run the multi-LUN test. That's the job of the people who
> want these patches upstream. Since I asked for these test results for the first
> time several months ago I'm surprised that nobody has run these tests yet.

I've reasoned through a few different ways to respond to this.  Fact is
you're not giving me much to work with.  AFAIK you _are_ charted with
supporting the types of storage configs that you've requested
performance results from.

Your dm-rq.c commit 6077c2d706097c0 ("dm rq: Avoid that request
processing stalls sporadically") silently went in through Jens:
https://www.redhat.com/archives/dm-devel/2017-April/msg00157.html
Not sure why that happened to begin with honestly.

But at the end of that post I meant to say:
"If this dm-mq specific commit is justified the case certainly is
_not_ spelled out in the commit header."

Anyway, I've split this contentious removal of dm_mq_queue_rq's
blk_mq_delay_run_hw_queue(hctx, 100/*ms*/) into a separate patch; but
at this point I'm still inclined to accept it for 4.16.

I'll hopefully look closer at understanding the need for commit
6077c2d706097c0 tomorrow.

In the meantime, I'd _really_ appreciate it if you'd give the rest of
the changes Ming has proposed in this patchset a much more open mind!

Thanks,
Mike
