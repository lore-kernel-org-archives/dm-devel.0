From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: blkio cgroups controller doesn't work with LVM?
Date: Wed, 2 Mar 2016 11:06:49 -0500
Message-ID: <20160302160649.GB29826@mtj.duckdns.org>
References: <56CDF283.9010802@windriver.com>
 <56CEB1BC.4000005@kyup.com>
 <20160225145314.GA20699@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160225145314.GA20699-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>, Chris Friesen <chris.friesen-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

Hello,

On Thu, Feb 25, 2016 at 09:53:14AM -0500, Mike Snitzer wrote:
> Right, LVM created devices are bio-based DM devices in the kernel.
> bio-based block devices do _not_ have an IO scheduler.  Their underlying
> request-based device does.

dm devices are not the actual resource source, so I don't think it'd
work too well to put io controllers on them (can't really do things
like proportional control without owning the queue).

> I'm not well-versed on the top-level cgroup interface and how it maps to
> associated resources that are established in the kernel.  But it could
> be that the configuration of blkio cgroup against a bio-based LVM device
> needs to be passed through to the underlying request-based device
> (e.g. /dev/sda4 in Chris's case)?
> 
> I'm also wondering whether the latest cgroup work that Tejun has just
> finished (afaik to support buffered IO in the IO controller) will afford
> us a more meaningful reason to work to make cgroups' blkio controller
> actually work with bio-based devices like LVM's DM devices?
> 
> I'm very much open to advice on how to proceed with investigating this
> integration work.  Tejun, Vivek, anyone else: if you have advice on next
> steps for DM on this front _please_ yell, thanks!

I think the only thing necessary is dm transferring bio cgroup tags to
the bio's that it ends up passing down the stack.  Please take a look
at fs/btrfs/extent_io.c::btrfs_bio_clone() for an example.  We
probably should introduce a wrapper for this so that each site doesn't
need to ifdef it.

Thanks.

-- 
tejun
