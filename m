From: Joe Thornber <thornber@redhat.com>
Subject: Re: Allow read IO during share block breaking in dm-thin
Date: Fri, 23 Aug 2013 10:59:29 +0100
Message-ID: <20130823095929.GA24230@debian>
References: <CAKTMprMVgxTDjs+4JEJLgb+1BpLCnY_mXHzvROqKCEiGe5Ekpw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAKTMprMVgxTDjs+4JEJLgb+1BpLCnY_mXHzvROqKCEiGe5Ekpw@mail.gmail.com>
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

Hi Dennis,

On Fri, Aug 23, 2013 at 10:35:30AM +0800, Teng-Feng Yang wrote:
> So here is my question, do we really need to quiesce all share read
> IOs before adding a new data mapping, or the share read IO's deferred
> set is meant to deal with some other problems?

This is a good question.

As you say we could let the read ios continue to run to the old block.
For large block sizes this could reduce latency of those reads.

I have a suspicion that I originally wrote things this way so we never
complete a read bio with older data after earlier completing a write
bio.  But if the bios were submitted concurrently there's no need to
observe this restriction.

There is one thing you need to consider if you're going to make this
change.  The old block may well have it's reference count reduced to
zero as a result of inserting the new mapping.  This in itself is
fine; we're careful to never free and realloc a block within the same
transaction.  But it does mean you'd need to start quiescing as part
of the commit operation.  I worry that introducing quiescing at the
commit level would impact the latency of ios to all blocks, rather
than just the one that's having it's sharing broken.

You could restructure the REQ_FUA/REQ_FLUSH code (which triggers the
commits), such that only they get stalled waiting for the quiesce,
but that's a chunk more work.

Do some benchmarking, quantify the problem.  Then we can make a call
on whether the development effort is worth it.

- Joe
