From: "hch@lst.de" <hch@lst.de>
Subject: Re: small dm mpath cleanups
Date: Thu, 27 Apr 2017 08:33:18 +0200
Message-ID: <20170427063318.GA20345@lst.de>
References: <20170426074039.14602-1-hch@lst.de> <1493232084.2632.5.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1493232084.2632.5.camel@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "hch@lst.de" <hch@lst.de>, "snitzer@redhat.com" <snitzer@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: dm-devel.ids

On Wed, Apr 26, 2017 at 06:41:27PM +0000, Bart Van Assche wrote:
> On Wed, 2017-04-26 at 09:40 +0200, Christoph Hellwig wrote:
> > this series has some prep patches for my work to have proper, type
> > checked block errors codes.  One fallout of that is that we need to
> > get rid of how dm overloads a few return values with either internal
> > positive error codes or negative errno values.  This patches does
> > that, which happens to clean things up a bit, and also allows us
> > dm to propagate the actual error code in one case where it currently
> > is dropped on the floor.
> 
> Hello Christoph,
> 
> Some patches in this series conflict with patches I would like to end up in
> the stable kernel series. If I would rebase my patch series on top of your
> series then that would make it harder to apply my patches on the stable
> kernel trees. Mike and Christoph, please advise how to proceed.

Bugfixes always go before cleanups.  I'd be happy to delay and/or rebase
any of my patches as needed.
