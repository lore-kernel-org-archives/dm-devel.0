From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Bcache upstreaming
Date: Thu, 31 Jan 2013 14:01:13 -0800
Message-ID: <20130131220113.GI12631@moria.home.lan>
References: <CAMM=eLeeh6jb28KXGE9ZBbkMV1ysE-6NH2BjfpTsQcHAawEs+w@mail.gmail.com>
 <20130110175954.GR26407@google.com>
 <20130114223722.GZ26407@google.com>
 <20130114225330.GA1365@redhat.com>
 <20130117022728.GA16148@redhat.com>
 <20130117114104.GJ10411@moria.home.lan>
 <20130130233643.GD12631@moria.home.lan>
 <20130131001020.GA7541@redhat.com>
 <20130131012627.GF12631@moria.home.lan>
 <20130131012747.GG12631@moria.home.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130131012747.GG12631-jC9Py7bek1znysI04z7BkA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

On Wed, Jan 30, 2013 at 05:27:47PM -0800, Kent Overstreet wrote:
> On Wed, Jan 30, 2013 at 05:26:27PM -0800, Kent Overstreet wrote:
> > On Wed, Jan 30, 2013 at 07:10:21PM -0500, Mike Snitzer wrote:
> > > On Wed, Jan 30 2013 at  6:36pm -0500,
> > > Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > > 
> > > > On Thu, Jan 17, 2013 at 03:41:04AM -0800, Kent Overstreet wrote:
> > > > > On Wed, Jan 16, 2013 at 09:27:28PM -0500, Mike Snitzer wrote:
> > > > > > On Mon, Jan 14 2013 at  5:53pm -0500,
> > > > > > Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > > > > > 
> > > > > > > On Mon, Jan 14 2013 at  5:37pm -0500,
> > > > > > > Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > > > > > > 
> > > > > > > > Want to try again with the latest bcache-for-upstream branch? I fixed
> > > > > > > > all that sysfs stuff, but I wasn't seeing the original build error so
> > > > > > > > I'd appreciate if you verify I did in fact fix that issue.
> > > > > > > 
> > > > > > > Will do, thanks Kent.
> > > > > > 
> > > > > > I hit the crash below if I do this in a script:
> > > > > > 
> > > > > > echo 1 > /sys/block/bcache0/bcache/cache/unregister
> > > > > > echo 1 > /sys/block/bcache0/bcache/stop
> > > > > 
> > > > > Thanks - I reproduced it, trying to figure out the sanest way to fix it.
> > > > > This is not the prettiest area of the code :P
> > > > 
> > > > And, I finally have a fix for it up.
> > > > 
> > > > Fixed a bunch of other bugs today too... notably the bug where it'd
> > > > crash if you enabled discards. Was there anything else you or anyone
> > > > else was hitting?
> > > 
> > > Great, thanks, the other outstanding report was this one:
> > > https://lkml.org/lkml/2013/1/17/554
> > 
> > Yep, that was the discard bug I just fixed.
> 
> Err I misread - nope, I missed that one. Taking a look now.

And, it's fixed.
