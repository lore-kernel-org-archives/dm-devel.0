From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [dm-devel] [PATCH v7 9/9] block: Avoid deadlocks with bio
 allocation by stacking drivers
Date: Wed, 29 Aug 2012 09:26:12 -0700
Message-ID: <20120829162612.GA20312@google.com>
References: <1346175456-1572-1-git-send-email-koverstreet@google.com>
 <1346175456-1572-10-git-send-email-koverstreet@google.com>
 <20120828204910.GG24608@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120828222800.GG1048@moria.home.lan>
 <20120828230108.GI1048@moria.home.lan>
 <20120829013150.GA9269@redhat.com>
 <20120829032558.GA22214@moria.home.lan>
 <20120829125759.GB12504@redhat.com>
 <20120829143913.GA5500@agk-dp.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120829143913.GA5500-FDJ95KluN3Z0klwcnFlA1dvLeJWuRmrY@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: dm-devel.ids

On Wed, Aug 29, 2012 at 03:39:14PM +0100, Alasdair G Kergon wrote:
> It's also instructive to remember why the code is the way it is: it used
> to process bios for underlying devices immediately, but this sometimes
> meant too much recursive stack growth.  If a per-device rescuer thread
> is to be made available (as well as the mempool), the option of
> reinstating recursion is there too - only punting to workqueue when the
> stack actually becomes "too big".  (Also bear in mind that some dm
> targets may have dependencies on their own mempools - submission can
> block there too.)  I find it helpful only to consider splitting into two
> pieces - it must always be possible to process the first piece (i.e.
> process it at the next layer down in the stack) and complete it
> independently of what happens to the second piece (which might require
> further splitting and block until the first piece has completed).

I'm sure it could be made to work (and it may well simpler), but it
seems problematic from a performance pov.

With stacked devices you'd then have to switch stacks on _every_ bio.
That could be made fast enough I'm sure, but it wouldn't be free and I
don't know of any existing code in the kernel that implements what we'd
need (though if you know how you'd go about doing that, I'd love to
know! Would be useful for other things).

The real problem is that because we'd need these extra stacks for
handling all bios we couldn't get by with just one per bio_set. We'd
only need one to make forward progress so the rest could be allocated
on demand (i.e. what the workqueue code does) but that sounds like it's
starting to get expensive.
