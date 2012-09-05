From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v7 9/9] block: Avoid deadlocks with bio
 allocation by stacking drivers
Date: Wed, 5 Sep 2012 13:57:59 +1000
Message-ID: <20120905035758.GF13691@dastard>
References: <1346175456-1572-1-git-send-email-koverstreet@google.com>
	<1346175456-1572-10-git-send-email-koverstreet@google.com>
	<Pine.LNX.4.64.1208291210180.774@file.rdu.redhat.com>
	<20120829165006.GB20312@google.com>
	<20120829170711.GC12504@redhat.com>
	<20120829171345.GC20312@google.com>
	<20120830220745.GI27257@redhat.com>
	<20120903004927.GM15292@dastard>
	<20120904135422.GC13768@redhat.com>
	<20120904182633.GB3638@dhcp-172-17-108-109.mtv.corp.google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20120904182633.GB3638@dhcp-172-17-108-109.mtv.corp.google.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Kent Overstreet <koverstreet@google.com>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, bharrosh@panasas.com, Vivek Goyal <vgoyal@redhat.com>
List-Id: dm-devel.ids

On Tue, Sep 04, 2012 at 11:26:33AM -0700, Tejun Heo wrote:
> Hello,
> 
> On Tue, Sep 04, 2012 at 09:54:23AM -0400, Vivek Goyal wrote:
> > > Given that we are working around stack depth issues in the
> > > filesystems already in several places, and now it seems like there's
> > > a reason to work around it in the block layers as well, shouldn't we
> > > simply increase the default stack size rather than introduce
> > > complexity and performance regressions to try and work around not
> > > having enough stack?
> > 
> > Dave,
> > 
> > In this particular instance, we really don't have any bug reports of
> > stack overflowing. Just discussing what will happen if we make 
> > generic_make_request() recursive again.
> 
> I think there was one and that's why we added the bio_list thing.

There was more than one - it was a regular enough to be considered a
feature... :/

> > > I mean, we can deal with it like the ia32 4k stack issue was dealt
> > > with (i.e. ignore those stupid XFS people, that's an XFS bug), or
> > > we can face the reality that storage stacks have become so complex
> > > that 8k is no longer a big enough stack for a modern system....
> > 
> > So first question will be, what's the right stack size? If we make
> > generic_make_request() recursive, then at some storage stack depth we will
> > overflow stack anyway (if we have created too deep a stack). Hence
> > keeping current logic kind of makes sense as in theory we can support
> > arbitrary depth of storage stack.
> 
> But, yeah, this can't be solved by enlarging the stack size.  The
> upper limit is unbound.

Sure, but recursion issue is isolated to the block layer.

If we can still submit IO directly through the block layer without
pushing it off to a work queue, then the overall stack usage problem
still exists. But if the block layer always pushes the IO off into
another workqueue to avoid stack overflows, then the context
switches are going to cause significant performance regressions for
high IOPS workloads.  I don't really like either situation.

So while you are discussing stack issues, think a little about the
bigger picture outside of the immediate issue at hand - a better
solution for everyone might pop up....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
