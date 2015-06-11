From: Christoph Hellwig <hch@lst.de>
Subject: Re: block: add a bi_error field to struct bio
Date: Thu, 11 Jun 2015 09:59:15 +0200
Message-ID: <20150611075915.GA2407@lst.de>
References: <1433338959-24808-1-git-send-email-hch@lst.de> <1433338959-24808-2-git-send-email-hch@lst.de> <20150604153106.GA31567@redhat.com> <20150610081138.GA3841@lst.de> <20150610152649.GA31140@redhat.com> <20150611075327.GA2113@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150611075327.GA2113@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-btrfs@vger.kernel.org
List-Id: dm-devel.ids

On Thu, Jun 11, 2015 at 09:53:27AM +0200, Christoph Hellwig wrote:
> On Wed, Jun 10, 2015 at 11:26:49AM -0400, Mike Snitzer wrote:
> > Unfortunately by dropping the original error (e.g. -EREMOTEIO) on the
> > floor (in the 'if (endio) {' branch) you're breaking the REQ_WRITE_SAME
> > check.
> 
> I think this also happens in the old code before my patch, e.g.:

Ok, after and audit of the instance I noticed that returning 0 from
->end_io even if an error is passed is a valid calling convention,
and with that the below analysis is invalid.  I'll take it back and
will do the simplest possible conversion for now and return my
attention to sorting out this mess later.
