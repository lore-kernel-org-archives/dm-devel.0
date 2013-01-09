From: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Bcache upstreaming
Date: Wed, 9 Jan 2013 11:12:06 -0500
Message-ID: <CAMM=eLdxz17qG8=Px5VoRpv2pGsGhVn3erCQLrcr=Lm-vCOrWw@mail.gmail.com>
References: <20130104235040.GA26407@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130104235040.GA26407-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

(take3 with feeling.. I reverted to the gmail's old compose so all
should be right in my plain-text gmail world... apologies to Kent and
dm-devel for the redundant messages)

Hey Kent,

On Fri, Jan 4, 2013 at 6:50 PM, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> I've (finally!) got a bcache branch hacked up that ought to be suitable
> to go upstream, possibly in staging initially.
>
> It's currently closer to the dev branch than the stable branch, plus
> some additional minor changes to make it all more self contained. The
> code has seen a decent amount of testing and I think it's in good shape,
> but I'd like it if it could see a bit more testing before I see about
> pushing it upstream.
>
> If anyone wants to try it out, checkout the bcache-for-staging branch.
> It's against Linux 3.7.

I pulled your 'bcache-for-staging' code into a 'dm-devel-cache-bcache'
branch on my github:
https://github.com/snitm/linux

Purpose is to have a single kernel to compare dm-cache and bcache.  My
branch is against 3.8-rc2.  While importing your code I needed the
following change to get bcache to compile:
https://github.com/snitm/linux/commit/400b1257e93975864fd6c4b827537a0234551253

It now builds without issue but I haven't tested the resulting bcache
to know if I broke the sysfs interface due to s/cache/bcache/ on some
local variables, I don't think I did but I'll defer to you.  (BTW
those crafty sysfs macros you have were pretty opaque; not really
seeing what they buy in the grand scheme.  And #include "sysfs.c" is
different than any code I've seen in the kernel).
