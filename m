From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2] block: flush queued bios when the process blocks
Date: Fri, 9 Oct 2015 15:59:07 -0400
Message-ID: <20151009195907.GB18790@redhat.com>
References: <alpine.LRH.2.02.1405271222150.8745@file01.intranet.prod.int.rdu2.redhat.com>
 <5384CE82.90601@kernel.dk>
 <alpine.LRH.2.02.1405291944090.22123@file01.intranet.prod.int.rdu2.redhat.com>
 <20151005205943.GB25762@redhat.com>
 <alpine.LRH.2.02.1510061410450.27916@file01.intranet.prod.int.rdu2.redhat.com>
 <20151006185016.GA31955@redhat.com>
 <20151006201637.GA4158@redhat.com>
 <alpine.LRH.2.02.1510081100510.9641@file01.intranet.prod.int.rdu2.redhat.com>
 <20151008150859.GA11770@redhat.com>
 <20151009195203.GA18790@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151009195203.GA18790@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, kent.overstreet@gmail.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, Oct 09 2015 at  3:52pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:
 
> Turns out that this change:
> http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/commit/?h=wip&id=2639638c77768a86216be456c2764e32a2bcd841
> 
> needed to be reverted with:
> http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/commit/?h=wip&id=ad3ccd760da7c05b90775372f9b39dc2964086fe
> 
> Because nested plugs caused generic_make_request()'s onstack bio_list to
> go out of scope (blk_finish_plug() wouldn't actually flush the list
> within generic_make_request because XFS already added an outermost
> plug).
> 
> But even after fixing that I then hit issues with these changes now
> resulting in imperfect 'in_generic_make_request' accounting that happens
> lazily once the outermost plug completes blk_finish_plug.  manifested as
> dm-bufio.c:dm_bufio_prefetch's BUG_ON(dm_bufio_in_request()); hitting.
> 
> Basically using the blk-core's onstack plugging isn't workable for
> fixing this deadlock and we're back to having to seriously consider
> this (with its additional hook in the scheduler): 

http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/commit/?h=wip&id=a91709cd32b5ca7ca047b68c9299e747f2ae6ca2
