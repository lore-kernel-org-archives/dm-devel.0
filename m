From: Chris Mason <clm@fb.com>
Subject: Re: [RFC][PATCH] dm: add dm-power-fail target
Date: Mon, 24 Nov 2014 15:18:50 -0500
Message-ID: <1416860330.3019.7@mail.thefacebook.com>
References: <1416607231-8588-1-git-send-email-jbacik@fb.com>
	<20141124184534.GA24398@lenny.home.zabbo.net> <54738154.9010203@fb.com>
	<20141124195749.GA27597@lenny.home.zabbo.net> <547391DD.30406@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <547391DD.30406@fb.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Josef Bacik <jbacik@fb.com>
Cc: Zach Brown <zab@redhat.com>, linux-btrfs@vger.kernel.org, david@fromorbit.com, sandeen@redhat.com, dm-devel@redhat.com, hch@infradead.org, linux-fsdevel@vger.kernel.org, tytso@mit.edu
List-Id: dm-devel.ids

On Mon, Nov 24, 2014 at 3:15 PM, Josef Bacik <jbacik@fb.com> wrote:
> On 11/24/2014 02:57 PM, Zach Brown wrote:
> 
> That is way complicated, I was just going to take two devices, one 
> that's a linear mapping and the other that's the log, and then write 
> to the log the sector+data that was written in order that it 
> completes, and then have userspace do the replay.  So basically do 
> the flush tracking like I am, then write out chunks to the log device 
> to keep a semblance of how the flushing would have affected stuff, 
> something like this
> 
> write a, write b, a complete, flush, b complete, flush complete
> 
> would log out
> 
> wrote a, flush, write b, <other writes>, <next flush>
> 
> and then we have a userspace thing that could do something like 
> replay all writes to a flush, do fs consistency and data consistency 
> checks, walk to the next flush, rinse repeat, and that way we could 
> be sure that we always have a consistent fs.  This would make it 
> easier to check complex fs operations (like btrfs's balance) without 
> having to come up with special hacks in those operations to check 
> them.  I like this better because it's less DM code which means less 
> swearing printks, but whichever we think will be the best thing for 
> this sort of testing.  Thanks,

I vote for whatever is the easiest to fit in our little programmer 
brains.  The more complex the tool, the less we'll trust it.

-chris



