From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: block: add a bi_error field to struct bio
Date: Wed, 10 Jun 2015 12:01:12 -0400
Message-ID: <20150610160112.GB31140@redhat.com>
References: <1433338959-24808-1-git-send-email-hch@lst.de>
 <1433338959-24808-2-git-send-email-hch@lst.de>
 <20150604153106.GA31567@redhat.com>
 <20150610081138.GA3841@lst.de>
 <20150610152649.GA31140@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150610152649.GA31140@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-btrfs@vger.kernel.org
List-Id: dm-devel.ids

On Wed, Jun 10 2015 at 11:26am -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Wed, Jun 10 2015 at  4:11am -0400,
> Christoph Hellwig <hch@lst.de> wrote:
> 
> > On Thu, Jun 04, 2015 at 11:31:07AM -0400, Mike Snitzer wrote:
> > > This patch _really_ concerns me because just in DM alone I found you
> > > took liberties that you shouldn't have and created a regression.  First
> > > issue is a real bug (your proposed dm-io.c:dmio_complete change missed
> > > that dm-io uses error_bits and not traditional error code like expected)
> > 
> > Point taken.  I already wanted to complain about the mess due to the bio
> > error abuse with it's own values in DM in the first posting, guess I
> > need to add that to the second one.  I don't think overloading common
> > interfaces with your private error codes is a good idea, but let's
> > leave that for a separate discussion.
> 
> I'll queue a patch to rename 'error' to 'error_bits' where appropriate.

See: https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=f368f463e4cef696ad6b102dbaf5c10dfca7cc63
