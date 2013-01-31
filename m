From: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Bcache upstreaming
Date: Thu, 31 Jan 2013 18:08:00 -0500
Message-ID: <20130131230800.GB13540@redhat.com>
References: <20130117114104.GJ10411@moria.home.lan>
 <20130130233643.GD12631@moria.home.lan>
 <20130131001020.GA7541@redhat.com>
 <20130131012627.GF12631@moria.home.lan>
 <20130131012747.GG12631@moria.home.lan>
 <20130131014835.GH12631@moria.home.lan>
 <20130131190249.GA12786@redhat.com>
 <CAC7rs0u_aJS5BsJ0E7wH98z2VxXr=SK1z8yL0-m0Pc85ncJNHg@mail.gmail.com>
 <20130131221711.GA13540@redhat.com>
 <CAC7rs0ue6YgqrX9Nc18GdnVtJd558F6W=BZiMXZdRqig3s7sBA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAC7rs0ue6YgqrX9Nc18GdnVtJd558F6W=BZiMXZdRqig3s7sBA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

On Thu, Jan 31 2013 at  5:25pm -0500,
Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Thu, Jan 31, 2013 at 2:17 PM, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > Ah, yeah I had a typo in my script.  When I fixed it I get a BUG (with
> > your latest bcache code) when I try to mkfs.xfs /dev/bcache0:
> 
> Heh, that's the dev branch - you don't want to be running the dev
> branch, there's a lot of buggy crap in there and it almost definitely
> corrupts data. Testing branch should be good, though.

OK, I'll pick up changes from -testing until directed elsewhere.

BTW, here are couple things I've noticed with bcache:

- The log messages seem to have an extra newline at the end.

- bcache doesn't appear to be establishing proper holders on the devices
  it uses for the backing and cache devices.
  - lsblk doesn't show any associations with bcache devices.
  - the fio utility isn't able to get any stats for the bcache device or
    the devices bcache uses.

- if I 'stop' a bcache device (using sysfs) while it is mounted; once I
  unmount the filesystem the device that bcache was using as a cache
  still has an open count of 1 but the bcache device then no longer
  exists
