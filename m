From: Joe Thornber <thornber@redhat.com>
Subject: Re: [dm-devel] [PATCH] staging: writeboost: Add dm-writeboost
Date: Wed, 10 Dec 2014 10:00:33 +0000
Message-ID: <20141210100033.GA21108@debian>
References: <5484498E.4000202@gmail.com>
 <20141207200834.GA2322@kroah.com>
 <5484C0E9.3060707@gmail.com>
 <20141209151253.GA17660@debian>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141209151253.GA17660@debian>
Sender: linux-kernel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, gregkh@linuxfoundation.org, snitzer@redhat.com, agk@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Tue, Dec 09, 2014 at 03:12:53PM +0000, Joe Thornber wrote:
> Writeboost is significantly slower than the spindle alone for this
> very simple test.  I do not understand what is causing the issue.

I started doing the code review and now understand what's going on,
sadly.

You are splitting all bios up into 4k blocks to simplify the metadata
layout, and mapping logic.  This murders performance.  File systems
and the block layer try really hard to submit the largest bio possible
for a reason.

A simple dd in large chunks across your cache reveals this:

raw spindle:        8.9s
writeboost type 0:  32.2s
writeboost type 1:  71.1s

dm-cache and dm-thin do also split io into blocks, but much larger,
user configurable blocks.  It's still a performance issue for us,
which is why I'm using range locking to move away from this bio
splitting (eg, recent cache discard patches).

One of the main advantages of a log based metadata layout is you can
cope nicely with arbitrarily sized bios.  Unlike dm-cache for
instance, which has to do a read from the origin if it wants to cache
a write that partially covers a block (or maintain a 'valid' bit for
each sector of every cached block).

The writeboost target as it stands will only benefit v. small, random
io.  It will seriously degrade performance of any other IO profile.
I'm NACKing this for upstream, and will not be spending any more time
on it at this point.

You've put a lot of effort into this so far, so I suggest you redesign
the log metadata, and drop the io splitting; you'll end up with
something far better.

Sorry,

- Joe
