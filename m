From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Bcache upstreaming
Date: Fri, 1 Feb 2013 08:15:47 -0800
Message-ID: <20130201161547.GY26407@google.com>
References: <20130131230800.GB13540@redhat.com>
 <20130201003311.GJ12631@moria.home.lan>
 <20130201033810.GA14867@redhat.com>
 <20130201103944.GM8837@soda.linbit>
 <20130201141003.GA18095@redhat.com>
 <20130201145504.GS6824@mtj.dyndns.org>
 <20130201152743.GV26407@google.com>
 <20130201153019.GT6824@mtj.dyndns.org>
 <20130201153318.GW26407@google.com>
 <20130201160820.GA31863@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130201160820.GA31863-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Lars Ellenberg <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: dm-devel.ids

On Fri, Feb 01, 2013 at 08:08:20AM -0800, Tejun Heo wrote:
> Hey,
> 
> On Fri, Feb 01, 2013 at 07:33:18AM -0800, Kent Overstreet wrote:
> > Could add a new, fixed version that doesn't do the refcounting, bcache
> > and I imagine md could use that right away (maybe even just split the
> > refcounting out into different functions and have dm call those
> > directly, probably an easy way to refactor it anyways)
> 
> I don't know.  We then would have two interfaces doing about the same
> thing and a flag indicating whether the new or old one was used to
> create the link so that exclusive close can decide to remove it or
> not, which seems a bit complicated. 

Eww, not a flag. I meant a completely separate functions, rip out the
refcounting entirely and have the refcounting-manipulating versions
available as

bd_link_disk_holder_broken()
bd_unlink_disk_holder_broken()

or somesuch.

> Let's see whether Mike can remove
> the weirdness from dm side.

That'd be best, but if it can't happen right away it's just a way to
isolate the weirdness.
