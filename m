From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/1] block: rework flush sequencing for blk-mq
Date: Fri, 14 Mar 2014 09:00:21 -0400
Message-ID: <20140314130021.GA12589@redhat.com>
References: <20140130132620.GA6031@infradead.org>
 <20140130132630.GB6031@infradead.org>
 <x49iorp3fhm.fsf@segfault.boston.devel.redhat.com>
 <20140308155240.GA32297@infradead.org>
 <CAMM=eLewbtK7LiNZCXo=hm-sjVU2+MN+xTFuxb89mDA1iS3r0w@mail.gmail.com>
 <531B74B6.4070004@suse.de>
 <20140312102849.GA26509@infradead.org>
 <20140313161347.GA6598@redhat.com>
 <20140314092519.GA10139@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140314092519.GA10139@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Hannes Reinecke <hare@suse.de>, Jeff Moyer <jmoyer@redhat.com>, Jens Axboe <axboe@kernel.dk>, Shaohua Li <shli@fusionio.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Mar 14 2014 at  5:25am -0400,
Christoph Hellwig <hch@infradead.org> wrote:

> On Thu, Mar 13, 2014 at 12:13:47PM -0400, Mike Snitzer wrote:
> > Pretty ironic that in the same email that you ask someone to "Let's make
> > this a little less personal." you start by asserting upstream
> > dm-multipath sees very little testing -- and use your commit that
> > recently broke dm-multipath as the basis.  Anyway, please exapnd on what
> > you feel is broken with upstream dm-multipath.
> 
> Getting a little upset, eh?  I didn't say it's broken, I said it gets
> very little testing.  The regression from me was found like so many
> before only after it was backported o some enterprise kernel.

Even _really_ basic dm-multipath testing would've uncovered this bug.
 
> I think the problem here is two-fold:
>  a) the hardware you use with dm-multipath isn't widely available.
>  b) it uses a very special code path in the block layer no one else uses
> 
> a) might be fixable by having some RDAC or similar emulation in qemu if
> someone wants to spend the effort.

The regression from the commit in question was easily reproduced/tested
using scsi_debug.  Just start the multipathd service and any scsi_debug
device in the system will get multipath'd.

> b) is a bit harder, but we should think hard about it when rewriting the
> multipath code to support blk-mq.  Talking about which I think trying to
> use dm-multipath on any blk-mq device will go horribly crash and boom at
> the moment.

If/when blk-mq/scsi-mq is used as the primary mechanism for multipathing
it must (initially anyway) but implemented in terms of a dm-multipath
fork (call it "dm-multiqueue"?).  We cannot take 6+ months of breaking
and then fixing dm-multipath.  When dm-multiqueue is more proven we can
look at the best way forward.
