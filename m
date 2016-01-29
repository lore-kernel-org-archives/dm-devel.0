From: Andy Whitcroft <apw@canonical.com>
Subject: Re: reinstate dm target local ioctl support
Date: Fri, 29 Jan 2016 14:35:58 +0000
Message-ID: <20160129143558.GR9864@bark>
References: <1453989019-24300-1-git-send-email-apw@canonical.com>
 <20160129135712.GA7201@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160129135712.GA7201@agk-dp.fab.redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>, mohan_srinivasan@yahoo.com, dm-devel@redhat.com, Neil Brown <neilb@suse.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Tim Gardner <tim.gardner@canonical.com>
List-Id: dm-devel.ids

On Fri, Jan 29, 2016 at 01:57:12PM +0000, Alasdair G Kergon wrote:
> On Thu, Jan 28, 2016 at 01:50:19PM +0000, Andy Whitcroft wrote:
> > However this also removed the possibility of a dm target having target
> > specific ioctls.  Currently this is not used by any in-tree targets but
> > was utilised by the flashcache out-of-tree module.
>  
> What data is being passed in and out?
> 
> The method we support is passing it through DM_TARGET_MSG (as text).
> For examples look at dm-switch.c and dm-stats.c, which handled
> pretty large quantities of data.
> 
> Would that work?

That sounds like it has all the bits one would need indeed.  I will
investigate that.  Thanks for the info.

-apw
