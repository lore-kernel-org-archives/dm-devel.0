From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] Implement barrier support for single device DM devices
Date: Mon, 18 Feb 2008 10:31:23 +1100
Message-ID: <20080217233123.GA155407@sgi.com>
References: <20080215120821.GA8267@basil.nowhere.org> <20080215122002.GM29914@agk.fab.redhat.com> <47B58EAA.8040405@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757790AbYBQXcB@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <47B58EAA.8040405@msgid.tls.msk.ru>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Andi Kleen <andi@firstfloor.org>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Fri, Feb 15, 2008 at 04:07:54PM +0300, Michael Tokarev wrote:
> Alasdair G Kergon wrote:
> > On Fri, Feb 15, 2008 at 01:08:21PM +0100, Andi Kleen wrote:
> >> Implement barrier support for single device DM devices
> >  
> > Thanks.  We've got some (more-invasive) dm patches in the works that
> > attempt to use flushing to emulate barriers where we can't just
> > pass them down like that.
> 
> I wonder if it's worth the effort to try to implement this.
> 
> As far as I understand (*), if a filesystem realizes that the
> underlying block device does not support barriers, it will
> switch to using regular flushes instead

No, typically the filesystems won't issue flushes, either.

> - isn't it the same
> thing as you're trying to do on an MD level?
> 
> Note that a filesystem must understand barriers/flushes on
> underlying block device, since many disk drives don't support
> barriers anyway.
> 
> (*) this is, in fact, an interesting question.  I still can't
> find complete information about this.  For example, how safe
> xfs is if barriers are not supported or turned off?  Is it
> "less safe" than with barriers?  Will it use regular cache
> flushes if barriers are not here?

Try reading at the XFS FAQ:

http://oss.sgi.com/projects/xfs/faq/#wcache

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
