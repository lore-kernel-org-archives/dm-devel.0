From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: small dm mpath cleanups
Date: Fri, 28 Apr 2017 16:23:58 -0400
Message-ID: <20170428202358.GA28562@redhat.com>
References: <20170426074039.14602-1-hch@lst.de>
 <1493232084.2632.5.camel@sandisk.com>
 <20170427063318.GA20345@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170427063318.GA20345@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: hch@lst.de
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, axboe@kernel.dk
List-Id: dm-devel.ids

On Thu, Apr 27 2017 at  2:33am -0400,
hch@lst.de <hch@lst.de> wrote:

> On Wed, Apr 26, 2017 at 06:41:27PM +0000, Bart Van Assche wrote:
> > On Wed, 2017-04-26 at 09:40 +0200, Christoph Hellwig wrote:
> > > this series has some prep patches for my work to have proper, type
> > > checked block errors codes.  One fallout of that is that we need to
> > > get rid of how dm overloads a few return values with either internal
> > > positive error codes or negative errno values.  This patches does
> > > that, which happens to clean things up a bit, and also allows us
> > > dm to propagate the actual error code in one case where it currently
> > > is dropped on the floor.
> > 
> > Hello Christoph,
> > 
> > Some patches in this series conflict with patches I would like to end up in
> > the stable kernel series. If I would rebase my patch series on top of your
> > series then that would make it harder to apply my patches on the stable
> > kernel trees. Mike and Christoph, please advise how to proceed.
> 
> Bugfixes always go before cleanups.  I'd be happy to delay and/or rebase
> any of my patches as needed.

I rebased your patchset ontop of Bart's patchset that I've already
staged in linux-dm.git's 'dm-4.12' branch.

When I try to apply this rebased patchset, it turns out 'dm-4.12' is
missing linux-block.git commit 8fc779805 ("dm mpath: don't check for
req->errors").  Because of this your first patch ("dm mpath: merge
do_end_io into multipath_end_io") won't apply due to conflict.

Not sure how we skin this cat.  Unfortunately Jens cannot easily pick
this rebased patchset up because he'll be missing all of Bart's changes
that I've staged in linux-dm.git's 'dm-4.12'.

In hindsight, linux-block.git commit 8fc779805 likely should've been
routed through linux-dm.git.  But not a big deal.

How should we skin this cat of getting your changes into 4.12?  I could
send a 2nd pull request to Linus after both linux-block.git and
linux-dm.git are merged... sound OK?

Until then, and/or for now, I've staged the fully merged result in
linux-next via linux-dm.git's 'for-next', see:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=for-next

Mike
