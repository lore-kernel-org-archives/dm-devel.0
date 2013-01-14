From: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Bcache upstreaming
Date: Mon, 14 Jan 2013 17:53:30 -0500
Message-ID: <20130114225330.GA1365@redhat.com>
References: <20130104235040.GA26407@google.com>
 <CAMM=eLeeh6jb28KXGE9ZBbkMV1ysE-6NH2BjfpTsQcHAawEs+w@mail.gmail.com>
 <20130110175954.GR26407@google.com>
 <20130114223722.GZ26407@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130114223722.GZ26407-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: dm-devel.ids

On Mon, Jan 14 2013 at  5:37pm -0500,
Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:

> On Thu, Jan 10, 2013 at 09:59:54AM -0800, Kent Overstreet wrote:
> > On Wed, Jan 09, 2013 at 10:49:04AM -0500, Mike Snitzer wrote:
> > > Hey Kent,
> > > 
> > > On Fri, Jan 4, 2013 at 6:50 PM, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>wrote:
> > > 
> > > > I've (finally!) got a bcache branch hacked up that ought to be suitable
> > > > to go upstream, possibly in staging initially.
> > > >
> > > > It's currently closer to the dev branch than the stable branch, plus
> > > > some additional minor changes to make it all more self contained. The
> > > > code has seen a decent amount of testing and I think it's in good shape,
> > > > but I'd like it if it could see a bit more testing before I see about
> > > > pushing it upstream.
> > > >
> > > > If anyone wants to try it out, checkout the bcache-for-staging branch.
> > > > It's against Linux 3.7.
> > > 
> > > 
> > > I pulled your 'bcache-for-staging' code into a 'dm-devel-cache-bcache'
> > > branch on my github:
> > > https://github.com/snitm/linux
> > > 
> > > Purpose is to have a single kernel to compare dm-cache and bcache.  My
> > > branch is against 3.8-rc2.  While importing your code I needed the
> > > following change to get bcache to compile:
> > > https://github.com/snitm/linux/commit/400b1257e93975864fd6c4b827537a0234551253
> > > 
> > > It now builds without issue but I haven't tested the resulting bcache to
> > > know if I broke the sysfs interface due to s/cache/bcache/ on some local
> > > variables, I don't think I did but I'll defer to you.  (BTW those crafty
> > > sysfs macros you have were pretty opaque; not really seeing what they buy
> > > in the grand scheme.  And #include "sysfs.c" is different than any code
> > > I've seen in the kernel).
> > 
> > Yeah, it was an ugly hack when I pulled the sysfs code out of super.c so
> > I could avoid adding a bunch of non static symbols. But apparantly the
> > various functions weren't even static in the first place, heh. I'll fix
> > this the right way, thanks.
> 
> Want to try again with the latest bcache-for-upstream branch? I fixed
> all that sysfs stuff, but I wasn't seeing the original build error so
> I'd appreciate if you verify I did in fact fix that issue.

Will do, thanks Kent.
