From: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Bcache upstreaming
Date: Fri, 1 Feb 2013 15:32:30 -0500
Message-ID: <20130201203229.GA21110@redhat.com>
References: <20130201033810.GA14867@redhat.com>
 <20130201103944.GM8837@soda.linbit>
 <20130201141003.GA18095@redhat.com>
 <20130201145504.GS6824@mtj.dyndns.org>
 <20130201152743.GV26407@google.com>
 <20130201153019.GT6824@mtj.dyndns.org>
 <20130201153318.GW26407@google.com>
 <20130201160820.GA31863@mtj.dyndns.org>
 <20130201161547.GY26407@google.com>
 <20130201161809.GB31863@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130201161809.GB31863-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Lars Ellenberg <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: dm-devel.ids

On Fri, Feb 01 2013 at 11:18am -0500,
Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:

> Hello, Kent.
> 
> On Fri, Feb 01, 2013 at 08:15:47AM -0800, Kent Overstreet wrote:
> > Eww, not a flag. I meant a completely separate functions, rip out the
> > refcounting entirely and have the refcounting-manipulating versions
> > available as
> 
> No, I mean, internally there needs to be a way whether the currently
> existing linkage is from the old or new interface for exclusive close
> to be able to decide whether it can remove it or not.  Anyways, let's
> wait for Mike for now.

The need for the same holder refcount is like I thought: a DM device's
active and inactive tables can open the same block devices.  I looked at
the prospect of pushing the refcount into DM but I don't think it is as
clean as having the bd_holder_disk struct continue to provide the
refcount.  Pushing it into DM would still require an explicit call to
bd_unlink_disk_holder.

The refcount is really pretty benign; so I'm inclined to leave things as
is.
