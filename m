From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Bcache upstreaming
Date: Fri, 1 Feb 2013 12:43:39 -0800
Message-ID: <20130201204339.GF31863@mtj.dyndns.org>
References: <20130201103944.GM8837@soda.linbit>
 <20130201141003.GA18095@redhat.com>
 <20130201145504.GS6824@mtj.dyndns.org>
 <20130201152743.GV26407@google.com>
 <20130201153019.GT6824@mtj.dyndns.org>
 <20130201153318.GW26407@google.com>
 <20130201160820.GA31863@mtj.dyndns.org>
 <20130201161547.GY26407@google.com>
 <20130201161809.GB31863@mtj.dyndns.org>
 <20130201203229.GA21110@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130201203229.GA21110-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Lars Ellenberg <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: dm-devel.ids

Hello,

On Fri, Feb 01, 2013 at 03:32:30PM -0500, Mike Snitzer wrote:
> The need for the same holder refcount is like I thought: a DM device's
> active and inactive tables can open the same block devices.  I looked at
> the prospect of pushing the refcount into DM but I don't think it is as
> clean as having the bd_holder_disk struct continue to provide the

It's a layering thing.  It's dm which is sharing exclusive open.  It
should be dm's responsibility to keep track of who's using what.

> refcount.  Pushing it into DM would still require an explicit call to
> bd_unlink_disk_holder.

While I don't know the code, I can't see why it has to be that way.
If a dm device is holding a device, it'll maintain the link between
old and new tables.  If it's being transferred to another device or
whatnot, it really should release the exclusive open and then
reacquire for the new use.

> The refcount is really pretty benign; so I'm inclined to leave things as
> is.

Yeah, the code isn't horribly complex but it's conceptually pretty
ugly.  If dm can back out of it, it would be awesome.  If that's not
something readily obtainable, ah well, another cruft we have to keep
around, I guess.

Thanks.

-- 
tejun
