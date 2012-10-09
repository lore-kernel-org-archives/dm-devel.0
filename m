From: Zach Brown <zab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 5/5] aio: Refactor aio_read_evt, use cmxchg(), fix bug
Date: Tue, 9 Oct 2012 16:10:59 -0700
Message-ID: <20121009231059.GV26187@lenny.home.zabbo.net>
References: <1349764760-21093-1-git-send-email-koverstreet@google.com>
 <1349764760-21093-5-git-send-email-koverstreet@google.com>
 <20121009183753.GP26187@lenny.home.zabbo.net>
 <20121009212724.GD29494@google.com>
 <20121009224703.GT26187@lenny.home.zabbo.net>
 <20121009225509.GA26835@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121009225509.GA26835-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org
List-Id: dm-devel.ids

> Well, the ringbuffer does have those compat flags and incompat flags.
> Which libaio conveniently doesn't check, but for what it does it
> shouldn't really matter I guess.

Well, the presumed point of the incompat flags would be to tell an app
that it isn't going to get what it expects!  Ideally it'd abort, not
blindly charge on ahead.

> I figure if anyone else is using the ringbuffer directly and not
> checking the flag fields... well, they deserve to have their stuff
> broken :P

Nope!  I subscribe to the unpopular notion that you don't change
interfaces just because you can.

> Anyways, if we can't change the ringbuffer at all we could always create
> a new version of the io_setup() syscall that gives you a new ringbuffer
> format.

That might be the easiest way to tweak the existing aio interface, yeah.
Jens wants to do that in his patches as well.  He used the hack of
setting nr_events to INT_MAX to indicate not using the ring, but adding
a flags parameter to a new syscall seems a lot less funky.

> I'm wondering what interest there is in creating a new aio interface to
> solve these and other issues.
> 
> I kind of feel like as long as we've got a list of complaints, we should
> prototype something in one place that fixes all our complaints... think
> of it as documenting all the known issues, if nothing else.

I'd help out with that, yes.

On my list of complaints would be how heavy the existing aio
setup/submission/completion/teardown interface is.   A better interface
should make it trivial to just bang out a call and synchronously wait
for it.  Get that right and you don't have to mess around with aio and
sync variants.

One of the harder things to get right would be specifying the DIF/DIX
checksums per sector.  But I think we should.  Poor Martin has hung out
to dry for too long.

And perhaps obviously, I'd start with the acall stuff :).  It was a lot
lighter.  We could talk about how to make it extensible without going
all the way to the generic packed variable size duplicating or not and
returning or not or.. attributes :).

- z
