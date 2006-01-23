From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 2/9] device-mapper log bitset: fix endian
Date: Mon, 23 Jan 2006 21:09:01 +0000
Message-ID: <20060123210901.GL4280@agk.surrey.redhat.com>
References: <20060120211300.GC4724@agk.surrey.redhat.com>
	<20060122213741.7d2ed8ef.akpm@osdl.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20060122213741.7d2ed8ef.akpm@osdl.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andrew Morton <akpm@osdl.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Sun, Jan 22, 2006 at 09:37:41PM -0800, Andrew Morton wrote:
> Alasdair G Kergon <agk@redhat.com> wrote:
> >
> >  -	set_bit(bit, (unsigned long *) bs);
> >  +	ext2_set_bit(bit, (unsigned long *) bs);
 
> ext2_set_bit() is non-atomic, so the above code must provide its own
> locking against other CPUs (and threads, if preempt) performing
> modification of this memory.
> 
> Is such locking present?  If not, we should use ext2_set_bit_atomic(). 
> (And if so, the old code could have used __set_bit)

As far as I can tell, all the sets and clears happen from the same 
single-threaded workqueue, but one mirror_map() could run alongside:

        r = ms->rh.log->type->in_sync(ms->rh.log,
                                      bio_to_region(&ms->rh, bio), 0);

which uses:
        ext2_test_bit(bit, (unsigned long *) bs) ? 1 : 0;

So far I haven't found any races here that would cause problems.
(And if there are any, they're probably wider than just making
those operations atomic.)

And it also looks like this code doesn't handle barriers correctly...

Alasdair
-- 
agk@redhat.com
