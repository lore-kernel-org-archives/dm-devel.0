From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-writeboost: Progress Report
Date: Mon, 13 Jan 2014 10:14:28 -0500
Message-ID: <20140113151428.GB31538@redhat.com>
References: <52D0F25D.6030904@gmail.com> <20140113100903.GA4984@debian>
	<52D3D21B.8030408@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <52D3D21B.8030408@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Akira Hayakawa <ruby.wktk@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Jan 13 2014 at  6:46am -0500,
Akira Hayakawa <ruby.wktk@gmail.com> wrote:

> Hi, Joe,
> 
> > Do you have any benchmarks yet?  Which situations does it out perform
> > bcache and dm-cache?
> Yes, I do.
> Writeboost outperforms other cache softwares in case of bursty random writes.
> With the fio script below, dm-writeboost recorded a throughput as high as the
> sequential write throughput of the cache device (259MB/266MB. only 3% loss).
> This is because Writeboost makes a log on the RAM and writes it out to the
> cache device in sequential manner. I don't think other cache softwares can achieve
> this high level of throughput.

Meaning you haven't actually tested dm-cache or bcache with the same fio
script?

I'd imagine bcache would do fairly well with 4K IOs.  But not as well as
a log-based approach like you have.  But _knowing_ the difference is
significant is important.

> By the way, Writeboost improves only writes so if you need more improvement on reads
> you can stack dm-cache (write-through) under dm-writeboost. They are orthogonal.
> dm-cache seems to be good for read caching.

OK.  But it is still unclear to me that such stacking can provide
completely complementary caching.  Needing to maintain multiple
codebases for caching is far from ideal too.

> For read caching, I have an another plan to develop separate cache module that, on the other hand,
> purely focuses on improving reads. I have a name "dm-readboost" in my mind.
> Since write cache and read cache require different data structures and controls they should be separated.
> So, if dm-cache can be simpler and optimized by deleting the support for writeback mode I really prefer it.

This idea that a single target cannot provide meaningful caching for
both reads and writes is really unwelcome.  Conceptually stacking is
simple, but in practice the management layers that need to configure
these stacks is fairly cumbersome.  Not only that but piercing through
one "orthogonal" cache layer to get to the other's cached data could be
awkward.  When paired together they may not make efficient use of the
SSD (fast storage) because they _could_ be caching the same data.  Care
needs to be taken to ensure that these stacks are trully complementary.
And seeing as that'd coordination would cross code maintainer
boundaries: I'm skeptical.

> >> 5. Add regression tests under testing/ of my Github tree
> >> --------------------------------------------------------
> >> Joe's test-suite is really well-designed but it has too many things before stand-by.
> > 
> > I'm not sure what you mean here?
> device-mapper-test-suite is a flexible framework but it has too many dependencies outside Ruby.

So that is your reason to not use it?  Pretty sure the deps you don't
care about could be made more fine-grained (so that the test checks for
the specific dep rather than a global check for all deps).
