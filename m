From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Bcache upstreaming
Date: Thu, 31 Jan 2013 16:33:11 -0800
Message-ID: <20130201003311.GJ12631@moria.home.lan>
References: <20130130233643.GD12631@moria.home.lan>
 <20130131001020.GA7541@redhat.com>
 <20130131012627.GF12631@moria.home.lan>
 <20130131012747.GG12631@moria.home.lan>
 <20130131014835.GH12631@moria.home.lan>
 <20130131190249.GA12786@redhat.com>
 <CAC7rs0u_aJS5BsJ0E7wH98z2VxXr=SK1z8yL0-m0Pc85ncJNHg@mail.gmail.com>
 <20130131221711.GA13540@redhat.com>
 <CAC7rs0ue6YgqrX9Nc18GdnVtJd558F6W=BZiMXZdRqig3s7sBA@mail.gmail.com>
 <20130131230800.GB13540@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130131230800.GB13540-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

On Thu, Jan 31, 2013 at 06:08:00PM -0500, Mike Snitzer wrote:
> On Thu, Jan 31 2013 at  5:25pm -0500,
> Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 
> > On Thu, Jan 31, 2013 at 2:17 PM, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > > Ah, yeah I had a typo in my script.  When I fixed it I get a BUG (with
> > > your latest bcache code) when I try to mkfs.xfs /dev/bcache0:
> > 
> > Heh, that's the dev branch - you don't want to be running the dev
> > branch, there's a lot of buggy crap in there and it almost definitely
> > corrupts data. Testing branch should be good, though.
> 
> OK, I'll pick up changes from -testing until directed elsewhere.
> 
> BTW, here are couple things I've noticed with bcache:
> 
> - The log messages seem to have an extra newline at the end.

How are you seeing that/which log messages? I hadn't noticed that
myself (do they not get printed somehow?)

> - bcache doesn't appear to be establishing proper holders on the devices
>   it uses for the backing and cache devices.
>   - lsblk doesn't show any associations with bcache devices.

How's that created - what function am I looking for?

>   - the fio utility isn't able to get any stats for the bcache device or
>     the devices bcache uses.

I'd been meaning to fix that, never got around to figuring out how those
stats are generated. Function/file you can point me to?

> - if I 'stop' a bcache device (using sysfs) while it is mounted; once I
>   unmount the filesystem the device that bcache was using as a cache
>   still has an open count of 1 but the bcache device then no longer
>   exists

You mean the backing device isn't open, just the cache device?

That's intended behaviour, backing and cache devices have separate
lifetimes (and you can attach many backing devices to a single cache).

You just have to stop the cache set separately, via
/sys/fs/bcache/<uuid>/stop or /sys/block/<cache device>/bcache/set/stop
