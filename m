From: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Bcache upstreaming
Date: Fri, 1 Feb 2013 11:12:27 -0500
Message-ID: <20130201161227.GA19245@redhat.com>
References: <20130131012747.GG12631@moria.home.lan>
 <20130131014835.GH12631@moria.home.lan>
 <20130131190249.GA12786@redhat.com>
 <CAC7rs0u_aJS5BsJ0E7wH98z2VxXr=SK1z8yL0-m0Pc85ncJNHg@mail.gmail.com>
 <20130131221711.GA13540@redhat.com>
 <CAC7rs0ue6YgqrX9Nc18GdnVtJd558F6W=BZiMXZdRqig3s7sBA@mail.gmail.com>
 <20130131230800.GB13540@redhat.com>
 <20130201003311.GJ12631@moria.home.lan>
 <20130201033810.GA14867@redhat.com>
 <20130201153936.GX26407@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130201153936.GX26407-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

On Fri, Feb 01 2013 at 10:39am -0500,
Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:

> On Thu, Jan 31, 2013 at 10:38:11PM -0500, Mike Snitzer wrote:
> > I'm just seeing extra newlines (empty lines), e.g.:
> > bcache: run_cache_set() invalidating existing data
> 
> Oh I see it, I screwed that up when I converted a bunch of stuff to
> pr_*() macros and my brain was so used to reading the same stuff I
> didn't notice it. I'll have that fixed in a minute.
> 
> > > > - bcache doesn't appear to be establishing proper holders on the devices
> > > >   it uses for the backing and cache devices.
> > > >   - lsblk doesn't show any associations with bcache devices.
> > > 
> > > How's that created - what function am I looking for?
> > 
> > bd_link_disk_holder and bd_unlink_disk_holder
> 
> Ok, that's done - it's in the testing branch
> 
> > 
> > > >   - the fio utility isn't able to get any stats for the bcache device or
> > > >     the devices bcache uses.
> > > 
> > > I'd been meaning to fix that, never got around to figuring out how those
> > > stats are generated. Function/file you can point me to?
> > 
> > I think you'll get the stats for via genhd (add_disk) -- the stats are
> > the 'disk_stats dkstats' member of the genhd's hd_struct.  But as of
> > now you'll notice that /sys/block/bcacheX/stat only ever contains 0s.
> 
> > 
> > part_stat_inc, part_stat_add are the low-level methods for driving the
> > counters up.  But I'm not sure why bcache isn't getting these stats  --
> > disk stats are something we get for free with DM devices so I haven't
> > really had to dig into these mechanics in detail.
> 
> Ah, I remember coming across that before now. Got that fixed too, it's
> in both the stable and testing branches.
> 
> And dm and md are both calling it from their make_request functions,
> which is why bcache wasn't getting it.

stats and lsblk look good.

> > > > - if I 'stop' a bcache device (using sysfs) while it is mounted; once I
> > > >   unmount the filesystem the device that bcache was using as a cache
> > > >   still has an open count of 1 but the bcache device then no longer
> > > >   exists
> > > 
> > > You mean the backing device isn't open, just the cache device?
> > >
> > > That's intended behaviour, backing and cache devices have separate
> > > lifetimes (and you can attach many backing devices to a single cache).
> > > 
> > > You just have to stop the cache set separately, via
> > > /sys/fs/bcache/<uuid>/stop or /sys/block/<cache device>/bcache/set/stop
> > 
> > The /dev/bcacheX device was mounted.  I issued 1 to
> > /sys/block/#{bcache_name}/bcache/stop before unmounting.  I then
> > unmounted /dev/bcacheX, the remaining bcache device infrastructure was
> > torn down.  But after that the device that was the cache device was
> > still held open -- seems like a reference leaked.
> 
> Was there still a directory in /sys/fs/bcache?

Yes, after unmount the /dev/bcacheX device is deleted but the
associated /sys/fs/bcache/<uuid> still exists.

Echoing 1 to /sys/fs/bcache/<uuid>/stop cleared it up.
