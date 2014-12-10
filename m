From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: Re: [dm-devel] [PATCH] staging: writeboost: Add dm-writeboost
Date: Wed, 10 Dec 2014 20:00:13 +0900
Message-ID: <548827BD.3050803@gmail.com>
References: <5484498E.4000202@gmail.com> <20141207200834.GA2322@kroah.com>	<5484C0E9.3060707@gmail.com> <20141209151253.GA17660@debian> <20141210100033.GA21108@debian>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141210100033.GA21108@debian>
Sender: linux-kernel-owner@vger.kernel.org
To: ejt@redhat.com
Cc: dm-devel@redhat.com, gregkh@linuxfoundation.org, snitzer@redhat.com, agk@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Hi, Joe

Thanks for continuous evaluation.

I think it's to soon to conclude splitting is the case.
In general, the time order of memory operations and disk operations is much different.
So, it's not likely that bio splitting, memory operation, is the case. Again, in general.
But yes, I will add seq write/read performance tests to dmts to see what's really going on.

By the way, what environment are you using for those tests?

My past result of git-extract differ from yours. I think this is strange.
(http://www.redhat.com/archives/dm-devel/2014-May/msg00052.html)

WriteboostTestsBackingDevice
  Elapsed 52.494120792: git_prepare
  Elapsed 276.545543981: extract all versions
  Finished in 331.363683334 seconds

WriteboostTestsType0
  Elapsed 46.966797484: git_prepare
  Elapsed 215.305219932: extract all versions
  Finished in 270.176494226 seconds.

WriteboostTestsType1
  Elapsed 83.344358679: git_prepare
  Elapsed 236.562481129: extract all versions
  Finished in 329.684926274 seconds.

I conducted those experiments on physical machine with a HDD and a SSD.
I will re-evaluate those tests with the current kernel on my machine and
compare with this result.

- Akira

On 12/10/14 7:00 PM, Joe Thornber wrote:
> On Tue, Dec 09, 2014 at 03:12:53PM +0000, Joe Thornber wrote:
>> Writeboost is significantly slower than the spindle alone for this
>> very simple test.  I do not understand what is causing the issue.
> 
> I started doing the code review and now understand what's going on,
> sadly.
> 
> You are splitting all bios up into 4k blocks to simplify the metadata
> layout, and mapping logic.  This murders performance.  File systems
> and the block layer try really hard to submit the largest bio possible
> for a reason.
> 
> A simple dd in large chunks across your cache reveals this:
> 
> raw spindle:        8.9s
> writeboost type 0:  32.2s
> writeboost type 1:  71.1s
> 
> dm-cache and dm-thin do also split io into blocks, but much larger,
> user configurable blocks.  It's still a performance issue for us,
> which is why I'm using range locking to move away from this bio
> splitting (eg, recent cache discard patches).
> 
> One of the main advantages of a log based metadata layout is you can
> cope nicely with arbitrarily sized bios.  Unlike dm-cache for
> instance, which has to do a read from the origin if it wants to cache
> a write that partially covers a block (or maintain a 'valid' bit for
> each sector of every cached block).
> 
> The writeboost target as it stands will only benefit v. small, random
> io.  It will seriously degrade performance of any other IO profile.
> I'm NACKing this for upstream, and will not be spending any more time
> on it at this point.
> 
> You've put a lot of effort into this so far, so I suggest you redesign
> the log metadata, and drop the io splitting; you'll end up with
> something far better.
> 
> Sorry,
> 
> - Joe
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 
