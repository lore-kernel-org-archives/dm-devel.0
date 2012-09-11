From: Kent Overstreet <koverstreet@google.com>
Subject: Re: [PATCH 2/2] block: Avoid deadlocks with bio allocation by
 stacking drivers
Date: Tue, 11 Sep 2012 12:31:24 -0700
Message-ID: <20120911193124.GI19739@google.com>
References: <20120910002810.GA23241@moria.home.lan>
 <20120910172210.GC14103@google.com>
 <20120910202435.GG16360@google.com>
 <20120910204010.GA32310@google.com>
 <20120910213349.GH16360@google.com>
 <20120910213710.GA7677@google.com>
 <20120910215633.GA19739@google.com>
 <CAFR8ued=Le4B4i_Rf4eECXsVgKvce9J7bO9sDSS91PFzBZ6j5w@mail.gmail.com>
 <20120911184553.GT7677@google.com>
 <CAFR8uefj7kxNUHLeppsH8THPzM7XCzT3tOxtuZ0qr4XUe7Bbmw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAFR8uefj7kxNUHLeppsH8THPzM7XCzT3tOxtuZ0qr4XUe7Bbmw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Muthu Kumar <muthu.lkml@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, axboe@kernel.dk, Vivek Goyal <vgoyal@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, bharrosh@panasas.com, david@fromorbit.com
List-Id: dm-devel.ids

On Tue, Sep 11, 2012 at 11:58:05AM -0700, Muthu Kumar wrote:
> On Tue, Sep 11, 2012 at 11:45 AM, Tejun Heo <tj@kernel.org> wrote:
> > Hello,
> >
> > On Tue, Sep 11, 2012 at 11:36:28AM -0700, Muthu Kumar wrote:
> >> Does this preserve the CPU from which the bio was submitted
> >> originally. Not familiar with cmwq, may be Tejun can clarify.
> >>
> >> Tejun - the question is, do we honor the rq_affinity with the above
> >> rescue worker implementation?
> >
> > The work item would run from the same CPU but there isn't any
> > mechanism to keep track of the issuing CPU if there are multiple bios
> > to be rescued.  Isn't rq_affinity an optimization hint?  If so, I
> > don't think it matters here.
> >
> 
> Thanks... Just worried about performance impact.
> 
> Kent - Anything to validate that the performance is not impacted would
> be really good. Otherwise, the patch looks great.

Well - there'll only be any performance impact at all when we're memory
constrained enough that GFP_NOWAIT allocations fail, which for these
size allocations definitely isn't normal.

I did test it with forcing everything to use the rescuer, and I also
benchmarked Vivek's version - in any sane configuration, the impact of
punting everything to workqueue is not very noticable (the AHCI
interrupt handler uses more cpu).

> 
> Feel free to add:
> 
> Reviewed-by: Muthukumar Ratty <muthur@gmail.com>

Thanks!
