From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Patch "dm: ensure bio submission follows a depth-first tree
 walk" has been added to the 4.15-stable tree
Date: Thu, 22 Mar 2018 09:56:22 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1803220951310.23476@file01.intranet.prod.int.rdu2.redhat.com>
References: <152172399419061@kroah.com> <20180322134759.GA27235@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180322134759.GA27235@redhat.com>
Sender: stable-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: gregkh@linuxfoundation.org, neilb@suse.com, alexander.levin@microsoft.com, stable@vger.kernel.org, stable-commits@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

I agree.

The patch "dm: ensure bio submission follows a depth-first tree walk" 
doesn't really fix any bug (and it may introduce new bugs), so it isn't 
applicable to the stable kernel branches.

The kernel 4.15 and below have a "dm_offload" mechanism that avoids the 
possible deadlocks in dm, there is no reason why this should be converted 
to the "depth-first tree walk".

Mikulas


On Thu, 22 Mar 2018, Mike Snitzer wrote:

> On Thu, Mar 22 2018 at  9:06am -0400,
> gregkh@linuxfoundation.org <gregkh@linuxfoundation.org> wrote:
> 
> > 
> > This is a note to let you know that I've just added the patch titled
> > 
> >     dm: ensure bio submission follows a depth-first tree walk
> > 
> > to the 4.15-stable tree which can be found at:
> >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > 
> > The filename of the patch is:
> >      dm-ensure-bio-submission-follows-a-depth-first-tree-walk.patch
> > and it can be found in the queue-4.15 subdirectory.
> > 
> > If you, or anyone else, feels it should not be added to the stable tree,
> > please let <stable@vger.kernel.org> know about it.
> 
> The following applies to 4.14 stable@ too.
> 
> I think it very questionable to pull this into stable trees.  How'd it
> even elevate to be considered for stable@?
> 
> But if you do, you definitely need this additional upstream commit:
> 8dd601fa8317 ("dm: correctly handle chained bios in dec_pending()")
> 
> Even with that I'm not excited about supporting some partial backport of
> these changes because there were a lot more related changes -- only
> taking a subset makes these stable@ kernels unicorns.. I deal with
> enough unicorn vendor kernels (but on my terms, with my control over
> what is "supportable"):
> 
> Anyway, other related commits are:
> 80cd17578310 dm crypt: remove BIOSET_NEED_RESCUER flag
> c110a4b6e603 dm io: remove BIOSET_NEED_RESCUER flag from bios bioset
> f31c21e4365c dm: remove unused 'num_write_bios' target interface
> 318716ddea08 dm: safely allocate multiple bioset bios
> 4a3f54d94d5c dm: remove BIOSET_NEED_RESCUER based dm_offload infrastructure
> 0776aa0e30aa dm: ensure bio-based DM's bioset and io_pool support targets' maximum IOs
> 3d7f45625a84 dm: fix __send_changing_extent_only() to send first bio and chain remainder
> 
> So NAK from me.  If others have a compelling argument I'm open to
> considering.
> 
> Mike
> 
