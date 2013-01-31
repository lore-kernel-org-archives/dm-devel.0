From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Bcache upstreaming
Date: Wed, 30 Jan 2013 17:25:26 -0800
Message-ID: <20130131012526.GE12631@moria.home.lan>
References: <20130104235040.GA26407@google.com>
 <CAMM=eLeeh6jb28KXGE9ZBbkMV1ysE-6NH2BjfpTsQcHAawEs+w@mail.gmail.com>
 <20130110175954.GR26407@google.com>
 <20130114223722.GZ26407@google.com>
 <20130114225330.GA1365@redhat.com>
 <20130117022728.GA16148@redhat.com>
 <20130117114104.GJ10411@moria.home.lan>
 <20130130233643.GD12631@moria.home.lan>
 <CAOzFzEho6Jn8nd+vSZXEQR5_oxPEZRej=6mivJDz0MsAj5VAZg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAOzFzEho6Jn8nd+vSZXEQR5_oxPEZRej=6mivJDz0MsAj5VAZg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Cc: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

On Thu, Jan 31, 2013 at 10:48:59AM +1100, Joseph Glanville wrote:
> On 31 January 2013 10:36, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > On Thu, Jan 17, 2013 at 03:41:04AM -0800, Kent Overstreet wrote:
> >> On Wed, Jan 16, 2013 at 09:27:28PM -0500, Mike Snitzer wrote:
> >> > On Mon, Jan 14 2013 at  5:53pm -0500,
> >> > Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> >> >
> >> > > On Mon, Jan 14 2013 at  5:37pm -0500,
> >> > > Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> >> > >
> >> > > > Want to try again with the latest bcache-for-upstream branch? I fixed
> >> > > > all that sysfs stuff, but I wasn't seeing the original build error so
> >> > > > I'd appreciate if you verify I did in fact fix that issue.
> >> > >
> >> > > Will do, thanks Kent.
> >> >
> >> > I hit the crash below if I do this in a script:
> >> >
> >> > echo 1 > /sys/block/bcache0/bcache/cache/unregister
> >> > echo 1 > /sys/block/bcache0/bcache/stop
> >>
> >> Thanks - I reproduced it, trying to figure out the sanest way to fix it.
> >> This is not the prettiest area of the code :P
> >
> > And, I finally have a fix for it up.
> >
> > Fixed a bunch of other bugs today too... notably the bug where it'd
> > crash if you enabled discards. Was there anything else you or anyone
> > else was hitting?
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-bcache" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> Last time I checked, dirty data could still appear as a negative
> number, did you get around to fixing that one?

I did!
