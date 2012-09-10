From: Kent Overstreet <koverstreet@google.com>
Subject: Re: [dm-devel] [PATCH 2/2] block: Avoid deadlocks with bio
 allocation by stacking drivers
Date: Mon, 10 Sep 2012 16:06:43 -0700
Message-ID: <20120910230643.GC19739@google.com>
References: <20120910002810.GA23241@moria.home.lan>
 <20120910172210.GC14103@google.com>
 <20120910202435.GG16360@google.com>
 <20120910204010.GA32310@google.com>
 <20120910213349.GH16360@google.com>
 <20120910213710.GA7677@google.com>
 <20120910215633.GA19739@google.com>
 <20120910220910.GB7677@google.com>
 <20120910225057.GA10477@agk-dp.fab.redhat.com>
 <CAOS58YO5puV2iPhwe0vbyEydPnR=eWPStNRm=xEpMeo-TMHCaw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOS58YO5puV2iPhwe0vbyEydPnR=eWPStNRm=xEpMeo-TMHCaw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, device-mapper development <dm-devel@redhat.com>, david@fromorbit.com, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>, bharrosh@panasas.com, Vivek Goyal <vgoyal@redhat.com>
List-Id: dm-devel.ids

On Mon, Sep 10, 2012 at 04:01:01PM -0700, Tejun Heo wrote:
> Hello,
> 
> On Mon, Sep 10, 2012 at 3:50 PM, Alasdair G Kergon <agk@redhat.com> wrote:
> >> >     Note that this doesn't do anything for allocation from other mempools.
> >
> > Note that dm has several cases of this, so this patch should not be used with
> > dm yet.  Mikulas is studying those cases to see whether anything like this
> > might be feasible/sensible or not.
> 
> IIUC, Kent posted a patch which converts all of them to use front-pad
> (there's no reason not to, really). This better come after that but
> it's not like this is gonna break something which isn't broken now.

Not all, I only did the easy one - you know how dm has all those crazy
abstraction layers? They've got multiple per bio allocations because of
that; the core dm code does one, and then some other code takes that
struct dm_io* and allocates its own state pointing to that (which then
points to the original bio...)

So front_pad should still work, but you need to have say dm_crypt pass
the amount of front pad it needs to the core dm code when it creates the
bio_set, and then dm crypt can use container_of(struct dm_io) and embed
like everything does that use the bio_set front pad.

*I'm probably misremembering all the names.
