From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH V3 0/5]  dm-rq: improve sequential I/O performance
Date: Fri, 12 Jan 2018 12:40:01 -0500
Message-ID: <20180112174000.GB5134@redhat.com>
References: <20180111060159.12991-1-ming.lei@redhat.com>
 <20180111220742.GA31944@redhat.com>
 <1515710256.2752.72.camel@sandisk.com>
 <20180112014232.GB25090@ming.t460p>
 <20180112015721.GB32298@redhat.com>
 <20180112033308.GC25090@ming.t460p>
 <20180112171840.GA4541@redhat.com>
 <1515778013.2396.3.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1515778013.2396.3.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "ming.lei@redhat.com" <ming.lei@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

On Fri, Jan 12 2018 at 12:26pm -0500,
Bart Van Assche <Bart.VanAssche@wdc.com> wrote:

> On Fri, 2018-01-12 at 12:18 -0500, Mike Snitzer wrote:
> > This is going upstream for 4.16:
> > https://git.kernel.org/pub/scm/linux/kernel/git/snitzer/linux.git/commit/?h=dm-4.16&id=5b18cff4baedde77e0d69bd62a13ae78f9488d89
> 
> That is really gross. I have explained many times in detail on the dm-devel
> list why that blk_mq_delay_run_hw_queue() call is necessary. So I think it is
> wrong if you remove it. Isn't the responsibility of you as the device mapper
> kernel maintainer to avoid regressions instead of introducing regressions?

Please stop, seriously.

You've not explained it many times.  We cannot get a straight answer
from you.  No analysis that establishes that if an underlying dm-mq
multipath path is out of tags (shared or otherwise) that dm-rq core
_must_ run the hw queue after a delay.  

Commit 6077c2d7060 just papers over a real blk-mq problem (that may now
be fixed).  Your assertions that blk-mq would need to otherwise poll
(and waste resources so it can immediately retry) ignores that blk-mq
_should_ make progress as requests complete or if/when a path is
recovered, etc.  So I'm not going to accept your dysfuctional reasoning
on this, sorry.  _THAT_ is my job as a maintainer. 
