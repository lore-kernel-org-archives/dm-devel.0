From: Joe Thornber <thornber@redhat.com>
Subject: Re: dm-writeboost: Progress Report
Date: Tue, 14 Jan 2014 10:17:14 +0000
Message-ID: <20140114101713.GA6450@debian>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, Jan 13, 2014 at 08:46:35PM +0900, Akira Hayakawa wrote:
> Hi, Joe,
> 
> > Do you have any benchmarks yet?  Which situations does it out perform
> > bcache and dm-cache?
> Yes, I do.
> Writeboost outperforms other cache softwares in case of bursty random writes.
> With the fio script below, dm-writeboost recorded a throughput as high as the
> sequential write throughput of the cache device (259MB/266MB. only 3% loss).

That certainly sounds faster than dm-cache.  However bcache is very
good at this sort of thing.

> To tell the truth, I don't have any more equipments to have benchmark more.

Let's get all your tests into dmtest then.  This will make it much
easier for other people to test who do have the hardware.  Heinz has
got some up to date hardware, so you should talk nicely to him (once
the tests are in dmtest).

> Why I
> need my software in the tree is not only to have the "many eyes" on my code to improve
> the quality but also to have Writeboost participate in public benchmark
> (like this http://www.accelcloud.com/2012/04/18/linux-flashcache-and-bcache-performance-testing/).

In accepting a piece of software into the kernel the community is
promising to maintain it for the forseeable future (even if you lose
interest).  They wont take it unless there's a compelling reason; your
own personal reason of wanting to improve the code quality and see how
it performs, wont do.  Sorry.  It sounds like writeboost is performing
v. well, so let's just finish the benchmarking and make a proper
argument.

> For read caching, I have an another plan to develop separate cache module that, on the other hand,
> purely focuses on improving reads. I have a name "dm-readboost" in my mind.
> Since write cache and read cache require different data structures and controls they should be separated.
> So, if dm-cache can be simpler and optimized by deleting the support for writeback mode I really prefer it.

As you say dm-cache covers this area.

> >> Joe's test-suite is really well-designed but it has too many things before stand-by.
> > 
> > I'm not sure what you mean here?
> device-mapper-test-suite is a flexible framework but it has too many dependencies outside Ruby.

You mean third party tools like 'dt' etc.  How about if I make the
dependency checking 'suite' dependent?  That way your dm-writeboost
suite will not need tools that are used by thinp or dm-cache?

- Joe
