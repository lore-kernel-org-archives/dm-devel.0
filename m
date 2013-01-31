From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Bcache upstreaming
Date: Thu, 31 Jan 2013 09:01:03 -0800
Message-ID: <20130131170103.GT26407@google.com>
References: <20130104235040.GA26407@google.com>
 <CAMM=eLeeh6jb28KXGE9ZBbkMV1ysE-6NH2BjfpTsQcHAawEs+w@mail.gmail.com>
 <20130110175954.GR26407@google.com>
 <20130114223722.GZ26407@google.com>
 <20130114225330.GA1365@redhat.com>
 <20130117022728.GA16148@redhat.com>
 <20130117114104.GJ10411@moria.home.lan>
 <20130130233643.GD12631@moria.home.lan>
 <20130131165223.GB11894@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130131165223.GB11894-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

On Thu, Jan 31, 2013 at 11:52:23AM -0500, Mike Snitzer wrote:
> On Wed, Jan 30 2013 at  6:36pm -0500,
> Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> 
> > On Thu, Jan 17, 2013 at 03:41:04AM -0800, Kent Overstreet wrote:
> > > On Wed, Jan 16, 2013 at 09:27:28PM -0500, Mike Snitzer wrote:
> > > > On Mon, Jan 14 2013 at  5:53pm -0500,
> > > > Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > > > 
> > > > > On Mon, Jan 14 2013 at  5:37pm -0500,
> > > > > Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > > > > 
> > > > > > Want to try again with the latest bcache-for-upstream branch? I fixed
> > > > > > all that sysfs stuff, but I wasn't seeing the original build error so
> > > > > > I'd appreciate if you verify I did in fact fix that issue.
> > > > > 
> > > > > Will do, thanks Kent.
> > > > 
> > > > I hit the crash below if I do this in a script:
> > > > 
> > > > echo 1 > /sys/block/bcache0/bcache/cache/unregister
> > > > echo 1 > /sys/block/bcache0/bcache/stop
> > > 
> > > Thanks - I reproduced it, trying to figure out the sanest way to fix it.
> > > This is not the prettiest area of the code :P
> > 
> > And, I finally have a fix for it up.
> > 
> > Fixed a bunch of other bugs today too...
> 
> Hey Kent,
> 
> Which branch did you push your latest fixes to?  I cannot seem to find
> them.

They're in the master bcache branch (also -dev and -testing)
