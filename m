From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Bcache upstreaming
Date: Mon, 14 Jan 2013 14:36:04 -0800
Message-ID: <20130114223603.GY26407@google.com>
References: <20130104235040.GA26407@google.com>
 <CAMM=eLdxz17qG8=Px5VoRpv2pGsGhVn3erCQLrcr=Lm-vCOrWw@mail.gmail.com>
 <20130110164704.GA30790@redhat.com>
 <20130110181424.GS26407@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130110181424.GS26407-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

On Thu, Jan 10, 2013 at 10:14:24AM -0800, Kent Overstreet wrote:
> On Thu, Jan 10, 2013 at 11:47:04AM -0500, Mike Snitzer wrote:
> > On Wed, Jan 09 2013 at 11:12am -0500,
> > Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > 
> > > (take3 with feeling.. I reverted to the gmail's old compose so all
> > > should be right in my plain-text gmail world... apologies to Kent and
> > > dm-devel for the redundant messages)
> > > 
> > > Hey Kent,
> > > 
> > > On Fri, Jan 4, 2013 at 6:50 PM, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
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
> > > I pulled your 'bcache-for-staging' code into a 'dm-devel-cache-bcache'
> > > branch on my github:
> > > https://github.com/snitm/linux
> > > 
> > > Purpose is to have a single kernel to compare dm-cache and bcache.  My
> > > branch is against 3.8-rc2.  While importing your code I needed the
> > > following change to get bcache to compile:
> > > https://github.com/snitm/linux/commit/400b1257e93975864fd6c4b827537a0234551253
> > > 
> > > It now builds without issue but I haven't tested the resulting bcache
> > 
> > Just tried to use bcache at it locked up:
> 
> Interesting, this is a new bug...
> 
> The main bcache branch is also on top of 3.7, and it doesn't have this
> new allocation code and should be fine if you want to try that (there
> were also a few bugs I fixed in the master branch without updating the
> staging branch, but this looks like something new).
> 
> Gonna try and reproduce this, after I fix that sysfs code. Hrm.

Fyi, this is fixed (missed it because my test scripts were using cache
replacement policy = random, to better stress other stuff. Doh.)
