From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Bcache upstreaming
Date: Fri, 1 Feb 2013 07:27:43 -0800
Message-ID: <20130201152743.GV26407@google.com>
References: <20130131190249.GA12786@redhat.com>
 <CAC7rs0u_aJS5BsJ0E7wH98z2VxXr=SK1z8yL0-m0Pc85ncJNHg@mail.gmail.com>
 <20130131221711.GA13540@redhat.com>
 <CAC7rs0ue6YgqrX9Nc18GdnVtJd558F6W=BZiMXZdRqig3s7sBA@mail.gmail.com>
 <20130131230800.GB13540@redhat.com>
 <20130201003311.GJ12631@moria.home.lan>
 <20130201033810.GA14867@redhat.com>
 <20130201103944.GM8837@soda.linbit>
 <20130201141003.GA18095@redhat.com>
 <20130201145504.GS6824@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130201145504.GS6824-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Lars Ellenberg <lars.ellenberg-63ez5xqkn6DQT0dZR+AlfA@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: dm-devel.ids

On Fri, Feb 01, 2013 at 06:55:04AM -0800, Tejun Heo wrote:
> Hey, Mike.
> 
> On Fri, Feb 01, 2013 at 09:10:03AM -0500, Mike Snitzer wrote:
> > Well judging by the header for commit 49731baa41df404c2c3f44555869ab387363af43  
> > ("block: restore multiple bd_link_disk_holder() support") it just looks
> > like Tejun hates the fact that DM and MD are using this interface.  No
> > alternative is provided; so the "DON'T USE THIS UNLESS YOU'RE ALREADY
> > USING IT." rings hollow.
> 
> The original code was gross regarding kobj handling there so I might
> have overreacted.  Ah right, the refcnt doesn't belong there.  The
> caller should already own both the master and slave devices (creator
> of the former, exclusive opener of the latter) and that really should
> be the extent of ownership that block layer tracks.
> bk_[un]link_disk_holder() implements completely isolated refcnting
> because dm somehow calls the function for the same pair multiple
> times.
> 
> ISTR the problem w/ block layer was that because this adds a separate
> layer of refcnting, it can't be tied to the usual rule of block device
> access.  ie. we really shouldn't need bd_unlink_disk_holder() but the
> linkage's lifetime should be bound to the exclusive open of the slave
> device, which can't currently be done.

Ah ok. Yeah, that refcounting is odd.

> IIRC, there was only one case where this happens in dm, would you be
> interested in tracking that down?  I'd be happy to lose the extra
> refcnting code and tie it back to bdev exclusive open.
> 
> > Kent was talking about using MD (and though he isn't opposed to DM he
> > doesn't care to integrate with DM himself).  Either DM or MD would
> > implicitly enable bcache to use this interface.  But in the near-term I
> > cannot see why Kent shouldn't be able to use bd_link_disk_holder too.
> 
> Being part of dm or dm should make this mostly irrelevant, no?

Yeah, but who knows when that'll actually happen and since this is for
userspace I'm just going to call it. The refcounting won't affect me,
and using it in bcache won't affect ripping that out.
