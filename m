From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v7 9/9] block: Avoid deadlocks with bio allocation by
 stacking drivers
Date: Wed, 29 Aug 2012 10:13:45 -0700
Message-ID: <20120829171345.GC20312@google.com>
References: <1346175456-1572-1-git-send-email-koverstreet@google.com>
 <1346175456-1572-10-git-send-email-koverstreet@google.com>
 <Pine.LNX.4.64.1208291210180.774@file.rdu.redhat.com>
 <20120829165006.GB20312@google.com>
 <20120829170711.GC12504@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120829170711.GC12504-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-Id: dm-devel.ids

On Wed, Aug 29, 2012 at 01:07:11PM -0400, Vivek Goyal wrote:
> On Wed, Aug 29, 2012 at 09:50:06AM -0700, Kent Overstreet wrote:
> 
> [..]
> > > The problem is that majority of device mapper code assumes that if we 
> > > submit a bio, that bio will be finished in a finite time. The commit 
> > > d89d87965dcbe6fe4f96a2a7e8421b3a75f634d1 in 2.6.22 broke this assumption.
> > > 
> > > I suggest - instead of writing workarounds for this current->bio_list 
> > > misbehavior, why not remove current->bio_list at all? We could revert 
> > > d89d87965dcbe6fe4f96a2a7e8421b3a75f634d1, allocate a per-device workqueue, 
> > > test stack usage in generic_make_request, and if it is too high (more than 
> > > half of the stack used, or so), put the bio to the target device's 
> > > blockqueue.
> > > 
> > > That could be simpler than allocating per-bioset workqueue and it also 
> > > solves more problems (possible deadlocks in dm).
> > 
> > It certainly would be simpler, but honestly the potential for
> > performance regressions scares me (and bcache at least is used on fast
> > enough devices where it's going to matter). Also it's not so much the
> > performance overhead - we can just measure that - it's that if we're
> > just using the workqueue code the scheduler's getting involved and we
> > can't just measure what the effects of that are going to be in
> > production.
> 
> Are workqueues not getting involved already in your solution of punting
> to rescuer thread.

Only on allocation failure.

> In the proposal above also, workers get involved
> only if stack depth is too deep. So for normal stack usage performance
> should not be impacted.
> 
> Performance aside, punting submission to per device worker in case of deep
> stack usage sounds cleaner solution to me.

Agreed, but performance tends to matter in the real world. And either
way the tricky bits are going to be confined to a few functions, so I
don't think it matters that much.

If someone wants to code up the workqueue version and test it, they're
more than welcome...
