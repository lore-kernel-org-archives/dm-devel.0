From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2] block: flush queued bios when the process blocks
Date: Thu, 15 Oct 2015 04:06:10 -0400
Message-ID: <20151015080610.GA25536@redhat.com>
References: <5384CE82.90601@kernel.dk>
 <alpine.LRH.2.02.1405291944090.22123@file01.intranet.prod.int.rdu2.redhat.com>
 <20151005205943.GB25762@redhat.com>
 <alpine.LRH.2.02.1510061410450.27916@file01.intranet.prod.int.rdu2.redhat.com>
 <20151006185016.GA31955@redhat.com>
 <20151006201637.GA4158@redhat.com>
 <alpine.LRH.2.02.1510081100510.9641@file01.intranet.prod.int.rdu2.redhat.com>
 <20151008150859.GA11770@redhat.com>
 <20151009195203.GA18790@redhat.com>
 <CACVXFVPgvKEJo1dPigk303=GGVc3fJnuEk+QP+VEf=xa_Lz+vA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACVXFVPgvKEJo1dPigk303=GGVc3fJnuEk+QP+VEf=xa_Lz+vA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kent.overstreet@gmail.com>, dm-devel@redhat.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, Oct 14 2015 at 11:27pm -0400,
Ming Lei <tom.leiming@gmail.com> wrote:

> On Sat, Oct 10, 2015 at 3:52 AM, Mike Snitzer <snitzer@redhat.com> wrote:
> >
> > Turns out that this change:
> > http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/commit/?h=wip&id=2639638c77768a86216be456c2764e32a2bcd841
> >
> > needed to be reverted with:
> > http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/commit/?h=wip&id=ad3ccd760da7c05b90775372f9b39dc2964086fe
> >
> > Because nested plugs caused generic_make_request()'s onstack bio_list to
> > go out of scope (blk_finish_plug() wouldn't actually flush the list
> > within generic_make_request because XFS already added an outermost
> > plug).
> 
> Looks you should have defined bio_list in plug as
> 
>                'struct bio_list bio_list'
> 
> instead of one pointer.

I realized that and fixed it (see commit ad3ccd760da7c05b90 referenced
above that does exactly that).  That wasn't the problem.

> >
> > But even after fixing that I then hit issues with these changes now
> > resulting in imperfect 'in_generic_make_request' accounting that happens
> > lazily once the outermost plug completes blk_finish_plug.  manifested as
> > dm-bufio.c:dm_bufio_prefetch's BUG_ON(dm_bufio_in_request()); hitting.
> 
> Looks this problem should be related with above 'bio_list' definition too.

No, as I explained it was due to the nested plug:

> >
> > Basically using the blk-core's onstack plugging isn't workable for
> > fixing this deadlock and we're back to having to seriously consider
> > this (with its additional hook in the scheduler)

To elaborate, for the code in DM (and other subsystems like bcache) that
rely on accurate accounting of whether we're actively _in_
generic_make_request: using plug to store/manage the bio_list isn't
workable because nested plugs change the lifetime of when the bio_list
is processed (as I implemented it -- which was to respect nested plugs).
I could've forced the issue by making the bio_list get processed
regardless of nesting but that would've made the onstack plugging much
more convoluted (duality between nested vs not just for bio_list's
benefit and for what gain?  Simply to avoid an extra conditional
immediately in the scheduler?  That conditional was still added anyway
but just as part of blk_needs_flush_plug so in the end there wasn't any
benefit!).

Hopefully my middle-of-the-night reply is coherent and helped to clarify
my position that (ab)using blk_plug for the bio_list management is
_really_ awkward. ;)

Thanks,
Mike
